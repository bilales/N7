#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include "readcmd.h"
#include "list_process.h"
#include <signal.h>
#include <fcntl.h>

extern list_process* process_list;
// variable globale utilse pour la commande fg
extern int fg_;



void debug_error(const char* commande) {
    debug_error(commande);
    
}


// Suspendre un process avec son identifiant
void sj(int id) {
    int pid = find_pid(id, process_list);
    if (kill(pid, SIGSTOP) == -1){
        debug_error("sj");
    }
    printf("\n le processus %d est suspendu \n", id);
    update_process_status(&process_list, pid, SUSPENDU);
}

//Suspendre le minishell
void susp(){
    // seul le minishell a pour id 1
    int pid = find_pid(1, process_list);
    if (kill(pid, SIGSTOP)==-1){
        debug_error("susp");
    }
}

//mettre en avant plan un process avec son id
void fg(int id) {
    fg_ =1;
    int status;
    int pid = find_pid(id, process_list);
    if (kill(pid, SIGCONT)==-1){
        debug_error("fg");
        
    }
    printf("\n le processus %d est mis en avant plan \n \n", id);
    if (waitpid(pid, &status, WUNTRACED) == -1) {
        debug_error("waitpid fg");
        
    }
    delete_process(&process_list, pid);
}

//
void bg(int id) {
    int pid = find_pid(id, process_list);
    if (kill(pid, SIGCONT)==-1){
        debug_error("bg");
        
    }
    update_process_status(&process_list, pid, ACTIF);
    printf("\n le processus %d est mis en arrière plan \n", id);
}

void end(){
    printf(" à bientot ! ");
    exit(0);
}

//commande pour changer de répertoire
void change_directory(char *dest){
   if (dest == NULL) {
	    chdir(getenv("HOME"));
    }
    else {
        if (chdir(dest) == -1) {;
            printf("cd: %s : Il n'existe pas de tel fichier ou dossier\n", dest);
        }
    }
}


// test si c'est une commande interne, si oui succes est mis à 1
void cmd_simple(list_process* head, struct cmdline *cmd, int* success) {
    *success = 1;

    // ne nécessite pas de 2 argument
    if (strcmp(cmd->seq[0][0], "exit") == 0) {
        end();
    }

    else if (strcmp(cmd->seq[0][0], "susp") == 0) {
        susp();
    } 
    else if (strcmp(cmd->seq[0][0], "lj") == 0) {
        process_Display(head);


    // nécessite un 2ème argument
    } else if (strcmp(cmd->seq[0][0], "sj") == 0) {
        if (cmd->seq[0][1] != NULL) {
            int id = atoi(cmd->seq[0][1]);
            sj(id);
        } 
    } else if (strcmp(cmd->seq[0][0], "bg") == 0) {
        if (cmd->seq[0][1] != NULL) {
            int id = atoi(cmd->seq[0][1]);
            bg(id);
        } 

    } else if (strcmp(cmd->seq[0][0], "fg") == 0) {
        if (cmd->seq[0][1] != NULL) {
            int id = atoi(cmd->seq[0][1]);
            fg(id);
        }
    }
    else if (strcmp(cmd->seq[0][0], "cd") == 0) {
        if (cmd->seq[0][1] != NULL) {
            change_directory(cmd->seq[0][1]);
        } 
    } 
    else {
        *success = 0;
    }
}


void execute_redirections(char* nom_fichier, int std) {
    // descripteur du fichier en entrée
    int fd;
    switch (std){
        case 1:
            //stdout
            fd = open (nom_fichier, O_WRONLY | O_CREAT | O_TRUNC, 0640);
            break;
        case 0:
            //stdin
            fd =open (nom_fichier, O_RDONLY| O_CREAT);
        default:
            break;
        }
        //Erreur ?
        if (fd < 0) {
            debug_error ("fd redirection");
            exit (1);
        }
        //redirection à l'aide de fd
        if (dup2 (fd, std) == -1) {
            debug_error ("dup2 redirection");
            exit (1);
        }
        //Fermeture
        if (close(fd) < 0) {
            debug_error("close redirection");
            
        }
}

//On regarde s'il y a une redirection dans la commande
void redirection_verif(struct cmdline* commande){
    //test redirection sortie standard
    if (commande->out != NULL) {
        execute_redirections(commande->out, 1);
    }

    //test redirection entrée standard
    if (commande->in != NULL) {
        execute_redirections(commande->in, 0);
    }
}


//Exécute une ligne de commande contenant des pipelines
void execute_pipelines(char ***cmd, int i, int old_fd) {
    // Exécuter la dernière commande, après le dernier pipeline, fin de la recursivité.
    if (cmd[i + 1] == NULL) {
        // Rediriger old_fd vers stdin.
        if (dup2(old_fd, 0) == -1) {
            debug_error("dup2 pipelines");
            
        }
        // Fermer old_fd + erreur
        if (close(old_fd) < 0) {
            debug_error("close pipelines");
            
        }
        // Exécuter la dernière commande.
        if (execvp(cmd[i][0], cmd[i]) < 0) {
            debug_error("execvp pipelines");
            
        }
        //fin de la recursivité
        exit(0);
    }

    // S'il reste des pipelines
    else {
        // Le processus fils.
        pid_t child;
        // Le pipe pour communiquer entre le fils et le père
        int pipe_f2p[2];

        // Créer le pipe et gérer les erreurs systématiquement.
        if (pipe(pipe_f2p) == -1) {
            debug_error("pipe pipelines");
            
        }
        // Créer le processus fils.
        child = fork();
        // Si le fork a échoué.
        if (child < 0) {
            debug_error("fork");
            
        }
        // Si le fils est créé avec succès.
        else if (child == 0) {
            // Fermer pipe_f2p[0] et + erreur
            if (close(pipe_f2p[0]) < 0) {
                debug_error("close pipelines");
                
            }
            // Rediriger old_fd vers stdin.
            if (dup2(old_fd, 0) == -1) {
                debug_error("dup2 pipelines");
                
            }
            // Fermer old_fd + erreur
            if (close(old_fd) < 0) {
                debug_error("close pipelines");
                
            }
            // Rediriger pipe_f2p[1] vers stdout.
            if (dup2(pipe_f2p[1], 1) == -1) {
                debug_error("dup2 pipelines");
                
            }
            // Exécuter la commande courante.
            if (execvp(cmd[i][0], cmd[i]) < 0) {
                debug_error("execvp pipelines pipelines");
                
            }
            exit(0);
        }

        // Processus parent.
        else {
            // Fermer pipe_f2p[1] + erreur
            if (close(pipe_f2p[1]) < 0) {
                debug_error("close pipelines");
                
            }
            // Exécuter le reste de la ligne de commande (récursivité).
            execute_pipelines(cmd, i + 1, pipe_f2p[0]);
        }
    }
}
