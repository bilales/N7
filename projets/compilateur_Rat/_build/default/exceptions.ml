open Type
open Ast.AstSyntax

(* Exceptions pour la gestion des identificateurs *)
exception DoubleDeclaration of string 
exception IdentifiantNonDeclare of string 
exception MauvaiseUtilisationIdentifiant of string 
exception IterateurForNonDeclare of string


(* Exceptions pour le typage *)
(* Le premier type est le type réel, le second est le type attendu *)
exception TypeInattendu of typ * typ
exception TypesParametresInattendus of typ list * typ list
exception TypeBinaireInattendu of binaire * typ * typ (* les types sont les types réels non compatible avec les signatures connues de l'opérateur *)
exception MauvaiseUtilisationAffichage of string
exception TableauVide of string


(* Exceptions pour la génération de code *)
exception MauvaisType of typ
exception ProblemeAst of string

(* Utilisation illégale de return dans le programme principal *)
exception RetourDansMain
