#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include "readcmd.h"
#include "list_process.h"
#include "gestion_cmd.h"
#include <fcntl.h>

pid_t child;
list_process* process_list;   // The list containing the whole process.
int id;              // The id of the process.
int child_status;
list_process* foreground = NULL;
int ctrlZ; // permet de gerer la table des processus
int fg_ = 0; // permet de savoir si un processus a été mis en avant plan




void handler_SIGCHLD() {
    if (!fg_){
	int fils_pid, wstatus ;
        while ((fils_pid = (int) waitpid(-1, &wstatus, WNOHANG | WUNTRACED | WCONTINUED)) > 0) {
            // supprimer
           if WIFEXITED(wstatus) {
            // Si c'est le signal SIGTSTP qui provoque l'exit du fils alors on ne supprime m
            //pas le process
                delete_process(&process_list, fils_pid);
           }
           // changment d'etat
           else if (WIFCONTINUED(wstatus)) {
			   update_process_status(&process_list, fils_pid, ACTIF);
           }
           // changment d'etat
           else if (WIFSTOPPED(wstatus)) {
                if(!ctrlZ){
			   update_process_status(&process_list, fils_pid, SUSPENDU);
               }
           }
        
        }
    }
}

// Le handler associé aux signaux SIGTSTP pour les process dans le foreground pour les suspendre
void handler_SIGTSTP() {
    ctrlZ =1;
    //on selectionne seulement le processus en avant plan grace à la structure de process_list
    foreground = parcours_list_fg(process_list);
    if (foreground != NULL) {
        //une fois le process interrompu il n'est plus dans le foreground
        foreground->foreground=0;
        kill(foreground->pid, SIGSTOP);
        printf("\n le processus %d est suspendu \n \n", foreground->id);
        update_process_status(&process_list, foreground->pid, SUSPENDU);
    }
}



//Ctrl C
void handler_SIGINT () {
    //on selectionne seulement le processus en avant plan grace à la structure de process_list
    foreground = parcours_list_fg(process_list);
    if (foreground != NULL){
        //une fois le process interrompu il n'est plus dans le foreground
        foreground->foreground=0;
        kill(child, SIGINT);
        printf("\n le processus %d a été terminé \n", foreground->id);
}
}

//Fonction pour formater le code, redirections ou pipelines
void redirection_ou_pipeline(struct cmdline* commande){
	    //REDIRECTIONS
        //en effet pour les redirections -> qu'une seule commandes
        if(commande->seq[1] == NULL){
            redirection_verif(commande);
        }
	    //PIPELINES 
	    else {
		    execute_pipelines(commande->seq, 0, 0);
        }
    }

void execute_foreground(pid_t pid, struct cmdline* commande, int i, list_process* new_process) {
    if (pid == -1) {
        perror("fork foreground");
        exit(1);
    } else if (pid == 0) {
        redirection_ou_pipeline(commande);
        execvp(commande->seq[i][0], commande->seq[i]);
        perror("execvp foreground");
        exit(1);
    } else {

        // c'est ici qu'est géré le traitement du
        signal(SIGCHLD, SIG_DFL);

        new_process = create_process(id, child, ACTIF, commande->seq[i][0], 1);
        add_process(&process_list, new_process);
        int status;
        if (waitpid(pid, &status, WUNTRACED) == -1) {
            debug_error("waitpid foreground");
        }

        //si ctrlZ est activité en réalité c'est si le signal SIGTSTP est lancé, alors la gestion
        // de la table est faite ailleurs
        if(!ctrlZ){
        delete_process(&process_list, pid);
        }
    }
}


//fonction qui execute les instructions en background, le père n'attend pas le fils géré par le traitant SIGCHLD
void execute_background (pid_t pid, struct cmdline *commande, int i, list_process* new_process){
    if (pid == -1) {
        perror("fork background");
        exit (1);
    } else if (pid == 0) {
        //Pour les proccess en background, on ne veut pas les suspendre donc on ignorera les SIGTSTP et SIGINT
        sigset_t signaux;
        sigemptyset(&signaux);
        sigaddset(&signaux,SIGINT);
        sigaddset(&signaux,SIGTSTP);
        sigprocmask(SIG_BLOCK,&signaux,NULL);
        redirection_verif(commande);
        execvp(commande->seq[i][0], commande->seq[i]);
        perror("execvp background");
        exit(1);
    } else {
        new_process = create_process(id, child, ACTIF, commande->seq[i][0], 0);
        add_process(&process_list, new_process);
    }
}



int main() {
    list_process* new_process=NULL;     // Le nouveau process
    id = 1;                             // Premier id
    int success = 0;                    // Permet d'exécuter les commandes internes
    int i = 0;
    char cwd[1024];                     // chemin


    signal(SIGCHLD, handler_SIGCHLD);
    //Par défaut on associe SIGTSTP au handler_SIGCHLD, c'est un choix
    signal(SIGTSTP, handler_SIGTSTP);
    signal(SIGINT, handler_SIGINT);
 

    list_process* process_minishell = create_process(id, getpid(), ACTIF, "minsihell", 1);
    add_process(&process_list, process_minishell);
    id ++;

    while (1) {


        //on affiche le chemins
        printf("bilal %s $ ", getcwd(cwd, sizeof(cwd)));
        fflush(stdout);
        struct cmdline* commande = readcmd();
        i = 0;
        fg_ = 0;
 
        while (commande->seq[i] != NULL) {

            
        //On va essayer d'executer les commandes que l'on a défini si échec alors succes vaut 1
        cmd_simple(process_list, commande, &success);

        ctrlZ=0;

        signal(SIGCHLD, handler_SIGCHLD);
        signal(SIGTSTP, handler_SIGTSTP);
        signal(SIGINT, handler_SIGINT);
            
            if (!success) {
                if (!commande->backgrounded) {
                    child = fork();
                    if (child== -1){
                        debug_error("child foreground");
                    }
                    execute_foreground(child, commande, i, new_process);
                } else {
                    child = fork();
                    if (child==-1){
                        debug_error("child background");
                    }
                    execute_background(child, commande, i, new_process);
                }
            } else {
                NULL;
            }
            i++;
        }
        id++;
    }
    return EXIT_SUCCESS;
}
