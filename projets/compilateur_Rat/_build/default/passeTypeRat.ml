(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme

(* analyse_type_affectable : AstTds.affectable -> AstType.affectable *)
(* Paramètre a  : l'affectable à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'affectable
en un affectable de type AstType.affectable  *)
(* Erreur si  mauvaise utilisation des identifiants *)

let rec analyse_type_affectable a = 
  match a with
  | AstTds.Ident iast -> 
  begin
    let info = info_ast_to_info iast in
    match info with
    | InfoConst _ -> (AstType.Ident iast, Int)
    | InfoVar(_,t,_,_) -> 
      modifier_type_variable t iast; 
    (AstType.Ident iast , t)
    | _ -> raise (ProblemeAst "Ident")
  end
  |AstTds.Deref aff -> 
    let (naff, t) = analyse_type_affectable aff in
    begin
        match t with
          |Pointeur nt ->  
              (AstType.Deref(naff),nt)
          | _ -> 
              raise (TypeInattendu (t,Pointeur Undefined))
    end
  | AstTds.AccesTableau (affect, expr) ->
    let (naff,taff) = analyse_type_affectable affect in
    let (nexp,texp) = analyse_type_expression expr in
    begin
      match taff with
      | Tableau t when texp = Int -> (AstType.AccesTableau(naff, nexp), t)
      | Tableau _ -> raise (TypeInattendu (texp, Int))
      | _ -> raise (TypeInattendu (taff, Undefined))
    end


(* analyse_type_expression : AstTds.expression -> AstType.expression *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)

and analyse_type_expression e =
  match e with
  | AstTds.Boolean b -> (AstType.Boolean b, Bool)
  | AstTds.Entier i -> (AstType.Entier i, Int)
  | AstTds.Binaire (op,e1,e2) ->
      let (nexp1,t1) =  analyse_type_expression e1 in
      let (nexp2,t2) =  analyse_type_expression e2 in
        if est_compatible t1 t2 then
          begin
            match op with
            |Mult -> (match (t1, t2) with
                      |(Int,Int) ->(AstType.Binaire(MultInt, nexp1 , nexp2),Int)
                      |(Rat,Rat) ->(AstType.Binaire(MultRat, nexp1 ,nexp2), Rat)
                      |_ -> raise( TypeBinaireInattendu(Mult ,t1,t2)))
            |Plus -> (match (t1, t2) with
                      |(Rat,Rat) ->(AstType.Binaire(PlusRat, nexp1 ,nexp2), Rat)
                      |(Int,Int) ->(AstType.Binaire(PlusInt, nexp1 , nexp2),Int)
                      |_, _-> raise (TypeBinaireInattendu(Plus, t1,t2)))
            |Fraction -> (match (t1,t2) with
                      |(Int,Int) -> (AstType.Binaire(Fraction,nexp1, nexp2), Rat)
                      |_, _ -> raise  (TypeBinaireInattendu(Fraction, t1,t2)))
            |Equ -> (match (t1, t2) with
                      |(Int,Int) ->(AstType.Binaire( EquInt,nexp1 , nexp2), Bool)
                      |(Bool,Bool) ->(AstType.Binaire(EquBool,nexp1 , nexp2),Bool)
                      |_, _ -> raise (TypeBinaireInattendu(Equ, t1,t2)))
            |Inf -> (if est_compatible_list [ t1;t2] [Int;Int]
                      then (Binaire(Inf ,nexp1 ,nexp2),Bool)  
                      else raise (TypeBinaireInattendu(Inf,t1,t2)))
              
            end    
          else raise (TypeBinaireInattendu(op,t1,t2))

  | AstTds.AppelFonction (info, l) ->
    begin
      let l1 = List.map analyse_type_expression l in
        let (le, lt) = List.split l1 in
        begin
          match info_ast_to_info info with
          | InfoFun (_, tr, ltp) ->
            begin
              if (est_compatible_list lt ltp) then (AstType.AppelFonction (info,le), tr)
              else raise (TypesParametresInattendus (lt, ltp))
            end
          |  _ -> raise (ProblemeAst "AppelFonction")
        end
    end
  
  | AstTds.Adresse iast ->
    begin
      let info = info_ast_to_info iast in
      match info with
      | InfoVar(_,t,_,_) -> (AstType.Adresse iast, Pointeur t)
      | _ -> raise (ProblemeAst "Adresse")
    end
  
  | AstTds.Null -> (AstType.Null, Pointeur Undefined)

  | AstTds.New t -> (AstType.New t, Pointeur t)

  | AstTds.Affectable a ->
    let na,ta = analyse_type_affectable a in
    (AstType.Affectable na, ta)
  | AstTds.Unaire (u,e) -> 
    let (ne,t) = analyse_type_expression e in
      begin
        match (u, t) with
        | (Denominateur, Rat) -> (AstType.Unaire(Denominateur, ne), Int)
        | (Numerateur, Rat) -> (AstType.Unaire(Numerateur, ne), Int)
        | _ -> raise (TypeInattendu (t, Rat))
      end

| AstTds.CreationTableau (t, expr) ->
  let (nexpr, texpr) = analyse_type_expression expr in
  begin
    match texpr with
    | Int -> (AstType.CreationTableau(t, nexpr), Tableau t)
    | _ -> raise (TypeInattendu (texpr, Int))
  end

  | AstTds.InitialisationTableau (lexpr) ->
  (*on va appliquer l'analyse sur chaque expression de lexpr qui va renvoyer une paire
  (nexpr,texpr) avec l'expression analysée et son type, on va créer ensuite
  2 listes avec List.split, nlexpr qui contient les expressions et tlexpr
  qui contient les types associés *)
    let nlexpr, tlexpr = List.split (List.map analyse_type_expression lexpr) in
    begin
    match tlexpr with
    | [] -> raise (TableauVide "InitialisationTableau")
    | premier_type_element :: _ ->
      (*Choix arbitraire du type du premier élément*)
        if List.for_all ((=) premier_type_element) tlexpr then
          (AstType.InitialisationTableau(premier_type_element, nlexpr), Tableau premier_type_element)
        else
          raise (TypeInattendu (List.hd tlexpr, premier_type_element))
    end
  



(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstType.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_type_instruction i =
  match i with
  | AstTds.Conditionnelle (e, b1, b2) ->
      begin
        let (ne,t)= analyse_type_expression e in
        if t = Bool then AstType.Conditionnelle (ne, analyse_type_bloc b1, analyse_type_bloc b2)
        else raise (TypeInattendu (t, Bool))
      end
  | AstTds.Declaration (t, info, e) ->
      begin
        let (r_expr, t_expr) = analyse_type_expression e in 
          if est_compatible t t_expr then
            (modifier_type_variable t_expr info;
            AstType.Declaration(info, r_expr))
          else raise (TypeInattendu (t_expr, t))
        end
  | AstTds.Affichage e ->
      begin
        match analyse_type_expression e with
        | (exp,Int) -> AstType.AffichageInt exp
        | (exp,Rat) -> AstType.AffichageRat exp
        | (exp,Bool) -> AstType.AffichageBool exp
        | _ -> raise (MauvaiseUtilisationAffichage "Affichage")
      end
  | AstTds.Affectation (affectable, e) ->

    let (naffectable, taffectable) = analyse_type_affectable affectable in
    let (ne, texpr) = analyse_type_expression e in
    if taffectable = texpr then
      AstType.Affectation(naffectable, ne)
    else
      raise (TypeInattendu (texpr, taffectable))
  | AstTds.TantQue (cond,b) ->

    begin
      let (r_expr, t_expr) = analyse_type_expression cond in
      let bast = analyse_type_bloc b in
      match t_expr with
      | Bool -> AstType.TantQue (r_expr, bast)
      | _ -> raise (TypeInattendu (t_expr, Bool))
    end
  | AstTds.Retour (e,info) ->
      begin
        let (r_expr, t_expr) = analyse_type_expression e in
        match info_ast_to_info info with
        | InfoFun (_, t, _) -> if (est_compatible t t_expr) then AstType.Retour (r_expr,info)
        else raise (TypeInattendu (t_expr, t))
        | _ -> raise (ProblemeAst "Retour")
      end
  | AstTds.Empty -> AstType.Empty
  | AstTds.BoucleFor (t, ia, e1, e2, e3, b) ->
    begin
      modifier_type_variable Int ia;
      let (r_expr1, t_expr1) = analyse_type_expression e1 in
      let (r_expr2, t_expr2) = analyse_type_expression e2 in
      let (r_expr3, t_expr3) = analyse_type_expression e3 in

      if est_compatible_list [t; t_expr1; t_expr2; t_expr3] [Int; Int; Bool; Int] then
        begin
          AstType.BoucleFor (ia, r_expr1, r_expr2, r_expr3, analyse_type_bloc b)
        end
      else 
        if t_expr1 <> Int then 
          raise (TypeInattendu (t_expr1, Int))
        else if t_expr2 <> Bool then
          raise (TypeInattendu (t_expr2, Bool))
        else if t_expr3 <> Int then
          raise (TypeInattendu (t_expr3, Int))
        else
          raise (TypeInattendu (t, Int))
    end
  | AstTds.Goto id ->
    begin
      let info = info_ast_to_info id in
      match info with 
      |InfoGoto(_, t, _, _)  -> 
        begin
        match t with 
          |Undefined -> AstType.Goto id
          |_ -> raise (TypeInattendu (t, Undefined))
        end
      | _ -> raise (ProblemeAst "Goto")
    end
  
  | AstTds.Label id -> AstType.Label id
  

(* analyse_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_type_bloc li =(List.map analyse_type_instruction li)
    
(* analyse_type_fonction : AstTds.fonction -> AstType.fonction *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstType.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_type_fonction (AstTds.Fonction (r, ia, lp, b)) =
  List.iter (fun (a,b) -> modifier_type_variable a b) lp;
  let (lt,lia) = (List.split lp) in
      modifier_type_fonction r lt ia;
      AstType.Fonction(ia, lia, analyse_type_bloc b)

(* analyse_type_programme : AstTds.programme -> AstType.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstType.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstTds.Programme (fonctions, prog)) =
  let n_func = List.map analyse_type_fonction fonctions in
  let n_block = analyse_type_bloc prog in
  AstType.Programme (n_func, n_block)

