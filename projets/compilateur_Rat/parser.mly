/* Imports. */

%{

open Type
open Ast.AstSyntax
%}


%token <int> ENTIER
%token <string> ID
%token RETURN
%token VIRG
%token PV
%token AO
%token AF
%token PF
%token PO
%token EQUAL
%token CONST
%token PRINT
%token IF
%token ELSE
%token WHILE
%token BOOL
%token INT
%token RAT
%token CO
%token CF
%token SLASH
%token NUM
%token DENOM
%token TRUE
%token FALSE
%token PLUS
%token MULT
%token INF
%token EOF
(*ajout*)
%token ADR
%token NEW
%token NULL
%token FOR
%token GOTO
%token DP


(* Type de l'attribut synthétisé des non-terminaux *)
%type <programme> prog
%type <instruction list> bloc
%type <fonction> fonc
%type <instruction> i
%type <typ> typ
%type <typ*string> param
%type <expression> e 
(*ajout *)
%type <affectable> a

(* Type et définition de l'axiome *)
%start <Ast.AstSyntax.programme> main

%%

main : lfi=prog EOF     {lfi}

prog : lf=fonc* ID li=bloc  {Programme (lf,li)}

fonc : t=typ n=ID PO lp=separated_list(VIRG,param) PF li=bloc {Fonction(t,n,lp,li)}

param : t=typ n=ID  {(t,n)}

bloc : AO li=i* AF      {li}

i :
| t=typ n=ID EQUAL e1=e PV          {Declaration (t,n,e1)}
| n=a EQUAL e1=e PV                {Affectation (n,e1)}
| CONST n=ID EQUAL e=ENTIER PV      {Constante (n,e)}
| PRINT e1=e PV                     {Affichage (e1)}
| IF exp=e li1=bloc ELSE li2=bloc   {Conditionnelle (exp,li1,li2)}
| WHILE exp=e li=bloc               {TantQue (exp,li)}
| RETURN exp=e PV                   {Retour (exp)}
(*ajout instruction*)
|FOR PO t=typ n1=ID EQUAL e1=e PV exp=e PV n2=ID EQUAL e2=e PF li=bloc {BoucleFor (t,n1,e1,exp,n2,e2,li)}
| n = ID DP {Label(n)} 
| GOTO n = ID PV {Goto (n)}                





typ :
| BOOL    {Bool}
| INT     {Int}
| RAT     {Rat}
(*ajout type*)
|t = typ MULT {Pointeur t}
|t = typ CO CF {Tableau t}

(*ajout affectable*)

a : 
| n = ID                    {Ident n}
| PO MULT aff = a PF       {Deref (aff)}
| PO aff=a CO e1 = e CF PF           {AccesTableau (aff, e1)}


e : 
| n=ID PO lp=separated_list(VIRG,e) PF   {AppelFonction (n,lp)}
| CO e1=e SLASH e2=e CF   {Binaire(Fraction,e1,e2)}
| TRUE                    {Boolean true}
| FALSE                   {Boolean false}
| e=ENTIER                {Entier e}
| NUM e1=e                {Unaire(Numerateur,e1)}
| DENOM e1=e              {Unaire(Denominateur,e1)}
| PO e1=e PLUS e2=e PF    {Binaire (Plus,e1,e2)}
| PO e1=e MULT e2=e PF    {Binaire (Mult,e1,e2)}
| PO e1=e EQUAL e2=e PF   {Binaire (Equ,e1,e2)}
| PO e1=e INF e2=e PF     {Binaire (Inf,e1,e2)}
| PO exp=e PF             {exp}
(*ajout expression*)
| aff = a                        {Affectable(aff)}
| NULL                              {Null}
| PO NEW p = typ PF                 {New (p)}
| ADR n = ID                        {Adresse(n)}
| PO NEW t=typ CO e1=e CF PF             {CreationTableau (t, e1)}
| AO lp=separated_list(VIRG, e) AF {InitialisationTableau (lp)}



