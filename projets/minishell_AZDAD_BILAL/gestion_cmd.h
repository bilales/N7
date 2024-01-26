//
//  gestion_cmd.h
//  
//
//  Created by Bilal Azdad on 21/04/2023.
//

#ifndef GESTION_CMD_H
#define GESTION_CMD_H

#include "list_process.h"
#include "readcmd.h"

void debug_error(const char* commande);
void sj(pid_t pid);
void fg(pid_t pid);
void bg(pid_t pid);
void end();
void change_directory(char *dest);
void cmd_simple(list_process* head, struct cmdline *cmd, int* success);
void execute_redirections(char* nom_fichier, int std);
void redirection_verif(struct cmdline* commande);
void execute_pipelines(char ***cmd, int i, int old_fd);


#endif
