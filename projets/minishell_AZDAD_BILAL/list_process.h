#ifndef List_PROCESS_H
#define List_PROCESS_H

#include <stdlib.h>
#include <sys/types.h>

typedef enum {
    ACTIF,
    SUSPENDU
} Status;

typedef struct list_process {
    int id;                 // ID du processus
    pid_t pid;              // PID du processus
    Status status;          // Statut du processus (Actif/Suspendu)
    char* cmd;              // Ligne de commande qui a lancé le processus
    int foreground;
    struct list_process* next;   // Pointeur vers le processus suivant dans la liste
}list_process;

// Fonction pour créer un nouveau processus
list_process* create_process(int id, pid_t pid, Status status, char* cmd, int etat);

// Fonction pour ajouter un processus à la fin de la liste
void add_process(list_process** head, list_process* new_process);

// Fonction pour supprimer un processus de la liste
void delete_process(list_process** head, pid_t pid);

// Fonction pour mettre à jour le statut d'un processus dans la liste
void update_process_status(list_process** head, pid_t pid, Status status);

// Fonction pour afficher la liste des processus
void process_Display(list_process* head);

//  Retourne le process qui est en avant plan s'il existe
list_process* parcours_list_fg(list_process* head);

// retourne le pid en fonction de l'id
pid_t find_pid(int id, list_process* head);

#endif

