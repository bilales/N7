open Type

(* Interface des arbres abstraits *)
module type Ast =
sig
   type affectable
   type expression
   type instruction
   type fonction
   type programme
end


(* *************************************** *)
(* AST après la phase d'analyse syntaxique *)
(* *************************************** *)
module AstSyntax =
struct



(* Opérateurs unaires de Rat *)
type unaire = Numerateur | Denominateur

(* Opérateurs binaires de Rat *)
type binaire = Fraction | Plus | Mult | Equ | Inf 

type affectable =
  | Ident of string
  | Deref of affectable
  | AccesTableau of affectable * expression

(* Expressions de Rat *)
and expression =
  (* un affectable *)
  | Affectable of affectable
  (* Null pour l'affectable *)
  |Null
  (*  *)
  |New of typ
  (* Adresse *)
  |Adresse of string
  (* Appel de fonction représenté par le nom de la fonction et la liste des paramètres réels *)
  | AppelFonction of string * expression list
  (* Booléen *)
  | Boolean of bool
  (* Entier *)
  | Entier of int
  (* Opération unaire représentée par l'opérateur et l'opérande *)
  | Unaire of unaire * expression
  (* Opération binaire représentée par l'opérateur, l'opérande gauche et l'opérande droite *)
  | Binaire of binaire * expression * expression
  (* Création d'un tableau *)
  | CreationTableau of typ * expression
  (* Initialisation d'un tableau avec un ensemble d'expression *)
  | InitialisationTableau of expression list

(* Instructions de Rat *)
type bloc = instruction list
and instruction =
  (* Déclaration de variable représentée par son type, son nom et l'expression d'initialisation *)
  | Declaration of typ * string * expression
  (* Affectation d'une variable représentée par son nom et la nouvelle valeur affectée *)
  | Affectation of affectable * expression
  (* Déclaration d'une constante représentée par son nom et sa valeur (entier) *)
  | Constante of string * int
  (* Affichage d'une expression *)
  | Affichage of expression
  (* Conditionnelle représentée par la condition, le bloc then et le bloc else *)
  | Conditionnelle of expression * bloc * bloc
  (*Boucle TantQue représentée par la conditin d'arrêt de la boucle et le bloc d'instructions *)
  | TantQue of expression * bloc
  (* return d'une fonction *)
  | Retour of expression
  (* Boucle For représentée par l'initialisation, la condition, la mise à jour et le bloc d'instructions *)
  | BoucleFor of typ * string * expression * expression * string * expression * bloc
  | Goto of string
  | Label of string

(* Structure des fonctions de Rat *)
(* type de retour - nom - liste des paramètres (association type et nom) - corps de la fonction *)
type fonction = Fonction of typ * string * (typ * string) list * bloc

(* Structure d'un programme Rat *)
(* liste de fonction - programme principal *)
type programme = Programme of fonction list * bloc

end


(* ******************************************** *)
(* AST après la phase d'analyse des expressions *)
(* ******************************************** *)


(* ********************************************* *)
(* AST après la phase d'analyse des identifiants *)
(* ********************************************* *)
module AstTds =
struct

    (* Affectable *)
    type affectable = 
    | Ident of Tds.info_ast
    | Deref of affectable
    | AccesTableau of affectable * expression

  (* Expressions existantes dans notre langage *)
  (* ~ expression de l'AST syntaxique où les noms des identifiants ont été
  remplacés par les informations associées aux identificateurs *)
  and expression =
    | Affectable of affectable
    | Null
    | New of typ
    | Adresse of Tds.info_ast
    | AppelFonction of Tds.info_ast * expression list
    | Boolean of bool
    | Entier of int
    | Unaire of AstSyntax.unaire * expression
    | Binaire of AstSyntax.binaire * expression * expression
    | CreationTableau of typ * expression
    | InitialisationTableau of expression list

  (* instructions existantes dans notre langage *)
  (* ~ instruction de l'AST syntaxique où les noms des identifiants ont été
  remplacés par les informations associées aux identificateurs
  + suppression de nœuds (const) *)
  type bloc = instruction list
  and instruction =
    | Declaration of typ * Tds.info_ast * expression (* le nom de l'identifiant est remplacé par ses informations *)
    | Affectation of  affectable * expression (* le nom de l'identifiant est remplacé par ses informations *)
    | Affichage of expression
    | Conditionnelle of expression * bloc * bloc
    | TantQue of expression * bloc
    | Retour of expression * Tds.info_ast  (* les informations sur la fonction à laquelle est associé le retour *)
    | Empty (* les nœuds ayant disparus: Const *)
    | BoucleFor of typ * Tds.info_ast * expression * expression *expression * bloc
    | Goto of Tds.info_ast
    | Label of Tds.info_ast


  (* Structure des fonctions dans notre langage *)
  (* type de retour - informations associées à l'identificateur (dont son nom) - liste des paramètres (association type et information sur les paramètres) - corps de la fonction *)
  type fonction = Fonction of typ * Tds.info_ast * (typ * Tds.info_ast ) list * bloc

  (* Structure d'un programme dans notre langage *)
  type programme = Programme of fonction list * bloc

end


(* ******************************* *)
(* AST après la phase de typage *)
(* ******************************* *)
module AstType =
struct

(* Opérateurs unaires de Rat - résolution de la surcharge *)
type unaire = Numerateur | Denominateur

(* Opérateurs binaires existants dans Rat - résolution de la surcharge *)
type binaire = Fraction | PlusInt | PlusRat | MultInt | MultRat | EquInt | EquBool | Inf
  
  (* Affectable *)
type affectable =
  | Ident of Tds.info_ast
  | Deref of affectable
  | AccesTableau of affectable * expression

(* Expressions existantes dans Rat *)
(* = expression de AstTds *)
and expression =
  | Affectable of affectable
  | Null
  | New of typ
  | Adresse of Tds.info_ast
  | AppelFonction of Tds.info_ast * expression list
  | Boolean of bool
  | Entier of int
  | Unaire of unaire * expression
  | Binaire of binaire * expression * expression
  | CreationTableau of typ * expression
  | InitialisationTableau of typ * expression list


(* instructions existantes Rat *)
(* = instruction de AstTds + informations associées aux identificateurs, mises à jour *)
(* + résolution de la surcharge de l'affichage *)
type bloc = instruction list
 and instruction =
  | Declaration of Tds.info_ast * expression
  | Affectation of affectable * expression
  | AffichageInt of expression
  | AffichageRat of expression
  | AffichageBool of expression
  | Conditionnelle of expression * bloc * bloc
  | TantQue of expression * bloc
  | Retour of expression * Tds.info_ast
  | Empty (* les nœuds ayant disparus: Const *)
  | BoucleFor of Tds.info_ast * expression * expression *expression * bloc
  | Goto of Tds.info_ast
  | Label of Tds.info_ast

(* informations associées à l'identificateur (dont son nom), liste des paramètres, corps *)
type fonction = Fonction of Tds.info_ast * Tds.info_ast list * bloc

(* Structure d'un programme dans notre langage *)
type programme = Programme of fonction list * bloc

end

(* ******************************* *)
(* AST après la phase de placement *)
(* ******************************* *)
module AstPlacement =
struct

(* Expressions existantes dans notre langage *)
(* = expression de AstType  *)
type expression = AstType.expression

(* instructions existantes dans notre langage *)
type bloc = instruction list * int (* taille du bloc *)
 and instruction =
 | Declaration of Tds.info_ast * expression
 | Affectation of AstType.affectable * expression
 | AffichageInt of expression
 | AffichageRat of expression
 | AffichageBool of expression
 | Conditionnelle of expression * bloc * bloc
 | TantQue of expression * bloc
 | Retour of expression * int * int 
 | Empty (* les nœuds ayant disparus: Const *)
 | BoucleFor of Tds.info_ast * expression * expression *expression * bloc
  | Goto of Tds.info_ast
  |Label of Tds.info_ast

(* informations associées à l'identificateur (dont son nom), liste de paramètres, corps, expression de retour *)
(* Plus besoin de la liste des paramètres mais on la garde pour les tests du placements mémoire *)
type fonction = Fonction of Tds.info_ast * Tds.info_ast list * bloc

(* Structure d'un programme dans notre langage *)
type programme = Programme of fonction list * bloc

end
