

open Tds
open Type
open Exceptions
open Ast
open AstPlacement


type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme


(* analyse_placement_instruction : AstType.instruction -> string -> int -> (AstPlacement.instruction, int)
   Analyse le placement des instructions.

   @param i : Instruction à analyser.
   @param reg : Registre utilisé pour le placement.
   @param depl : Position de départ par rapport au registre.
*)

let rec analyse_placement_instruction i reg depl =
  match i with
  | AstType.Declaration (info_ast, exp) ->
    modifier_adresse_variable depl reg info_ast;
    (AstPlacement.Declaration (info_ast, exp), getTailleTds info_ast)

  | AstType.Affectation (aff, exp) ->
    (AstPlacement.Affectation (aff, exp), 0)

  | AstType.Conditionnelle (exp, bloc1, bloc2) ->
    let nbloc1 = analyse_placement_bloc bloc1 reg depl in
    let nbloc2 = analyse_placement_bloc bloc2 reg depl in
    (AstPlacement.Conditionnelle (exp, nbloc1, nbloc2), 0)

  | AstType.TantQue (exp, bloc) ->
    let nbloc = analyse_placement_bloc bloc reg depl in
    (AstPlacement.TantQue (exp,nbloc), 0)

  |AstType.Retour(e, iast) ->
    begin
    match(info_ast_to_info iast) with
    | InfoFun (_,t_retour, t_params) ->
      let taille_retour = getTaille t_retour in
      let taille_params = List.fold_left (fun acc t -> acc + getTaille t) 0 t_params in
            (AstPlacement.Retour(e, taille_retour, taille_params),0)
    | _ -> raise (ProblemeAst "Erreur analyse_placement_instruction : Retour")
    end

  |AstType.AffichageInt(e) -> (AstPlacement.AffichageInt(e),0)
  
  |AstType.AffichageBool (e) -> (AstPlacement.AffichageBool(e),0)

  |AstType.AffichageRat (e) -> (AstPlacement.AffichageRat(e),0)

  |AstType.Empty -> (AstPlacement.Empty,0)


  |AstType.BoucleFor (ia,e1,e2,e3,bloc) ->
  
      let (_, taille) = analyse_placement_instruction (AstType.Declaration(ia,e1)) reg depl in
      let (nbloc, tailleBloc) = analyse_placement_bloc bloc reg (depl+taille) in
      (AstPlacement.BoucleFor (ia,e1,e2,e3,(nbloc, tailleBloc)), 0)

    
  | AstType.Goto (s) -> (AstPlacement.Goto (s), 0)


  | AstType.Label (s) -> 
    match info_ast_to_info s with
    | InfoGoto(_, t, _, _)  ->
      modifier_adresse_variable depl reg s;
      (AstPlacement.Label (s), getTaille t)
    | _ -> raise (ProblemeAst "Erreur analyse_placement_instruction : Label")
  


(* analyse_placement_bloc : list instructions -> int -> int -> (AstPlacement.bloc, int)
   Analyse le placement des blocs d'instructions.
param bloc : Liste d'instructions à analyser.
param reg : registre pour le placement
param base : position par rapport au registre
return : Un tuple contenant le bloc d'instructions après analyse et la taille totale occupée.
*)
and analyse_placement_bloc bloc reg base =
  match bloc with
  | [] -> ([], 0)  (* Cas de base : liste vide, retourne un bloc vide avec une taille de 0 *)
  | instr_head::instr_tail ->  (* Décompose la liste en tête et queue *)
      (* Analyse la première instruction *)
      let (new_instr_head, size_instr_head) = analyse_placement_instruction instr_head reg base  in
      (* Récursivement, analyse le reste des instructions *)
      let (new_instr_tail, size_instr_tail) = analyse_placement_bloc instr_tail  reg (size_instr_head + base) in
      (* Construit le nouveau bloc et calcule la taille totale *)
      (new_instr_head::new_instr_tail, size_instr_head + size_instr_tail)
  
  


(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction *)
let analyse_placement_fonction(AstType.Fonction(i,l,bloc)) = 
let rec analyse_placement_param li depl =
  match li with
  | [] -> ()
  | h::t -> 
    let info = info_ast_to_info h in
    match info  with
    | InfoVar(_,typ,_,_) -> 
      let taille = getTaille typ in
      modifier_adresse_variable (depl-(taille)) "LB" h;
      (analyse_placement_param t (depl-(taille)))
    | _ -> raise (ProblemeAst "placement fonction")
    in
      analyse_placement_param (List.rev l) 0 ;
      let nb = (analyse_placement_bloc bloc "LB" 3) in Fonction(i,l,nb)

(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie ld placement du programme et tranforme le programme
en un programme de type AstTds.programme *)

let analyser (AstType.Programme (lfonction,bloc)) =
  Programme (List.map (analyse_placement_fonction) lfonction , analyse_placement_bloc bloc "SB" 0)