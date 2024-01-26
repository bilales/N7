#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "readcmd.h"


typedef enum {
    ACTIF,
    SUSPENDU
} Status;


// Structure représentant un processus
struct list_process {
    int id;                 // ID du processus
    pid_t pid;              // PID du processus
    Status status;          // Statut du processus (Actif/Suspendu)
    char* cmd;              // Ligne de commande qui a lancé le processus
    int foreground;
    struct list_process* next;   // Pointeur vers le processus suivant dans la liste
};

typedef struct list_process list_process;

// Fonction pour créer un nouveau processus
list_process* create_process(int id, pid_t pid, Status status, char* cmd, int etat) {
    list_process* p = malloc(sizeof(list_process));
    p->id = id;
    p->pid = pid;
    p->status = status;
    p->cmd = strdup(cmd);   // strdup() alloue de la mémoire pour la chaîne de caractères et la copie dans la nouvelle zone de mémoire
    p->next = NULL;
    p->foreground = etat;
    return p;
}


// Fonction pour ajouter un processus à la fin de la liste
void add_process(list_process** head, list_process* new_process) {
    if (*head == NULL) {
        *head = new_process;
    } else {
        list_process* current = *head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_process;
    }
}

// Fonction pour supprimer un processus de la liste
void delete_process(list_process** head, pid_t pid) {
    list_process* current = *head;
    list_process* previous = NULL;

    // Trouver le processus avec le PID correspondant
    while (current != NULL && current->pid != pid) {
        previous = current;
        current = current->next;
    }

    // Si on a trouvé le processus à supprimer
    if (current != NULL) {
        // Si le processus à supprimer est le premier de la liste
        if (previous == NULL) {
            *head = current->next;
        } else {
            previous->next = current->next;
        }
        // Libérer la mémoire allouée pour la chaîne de caractères et le processus
        free(current->cmd);
        free(current);
    }
}

// Fonction pour mettre à jour le statut d'un processus dans la liste
void update_process_status(list_process** head, pid_t pid, Status status) {
    list_process* current = *head;
    while (current != NULL && current->pid != pid) {
        current = current->next;
    }
    if (current != NULL) {
        current->status = status;
    }
}

// Fonction pour afficher la liste des processus
void process_Display(list_process* head) {
    printf("ID\t\tPID\t\tETAT\t\tCOMMANDE\n");
    list_process* current = head;
    while (current != NULL) {
        printf("%d\t\t%d\t\t%s\t\t%s\n", current->id, current->pid, current->status == ACTIF ? "ACTIF" : "SUSPENDU", current->cmd);
        current = current->next;
    }
}

list_process* parcours_list_fg(list_process* head) {
    list_process* current = head->next;
    while (current != NULL) {
        if (current->foreground) {
            return current;
        }
        current = current->next; // Déplacer le pointeur vers le prochain élément de la liste
    }
    return NULL; // Retourner NULL si aucun élément avec foreground vrai n'est trouvé
}

pid_t find_pid(int id, list_process* head){
    pid_t pid = 0;
    list_process* current = head->next;
    while(current != NULL){
        if(current->id == id){
            pid = current->pid;
       }
      current = current->next;
  }
  return pid;
  }
