open Tds
open Exceptions
open Ast
open Type
open Code
open Tam

type t1 = Ast.AstPlacement.programme
type t2 = string

  (*Analyse de l'affectable 
     isWritable : boolean = false si c'est pas une expression isWritableiable||  true si une expression ne l'est pas
     a :  type affectable*)
let rec analyse_code_affectable isWritable a =
match a with 
| AstType.Ident id -> 
    begin
      match info_ast_to_info id with 
      | InfoVar(_, t, dep, reg) -> 
          let taille = getTaille t in
          if isWritable then 
            (store taille dep reg, t)
          else
            (load taille dep reg, t)
      | InfoConst(_, v) -> 
          (loadl_int v, Int)
      | _ -> 
          raise (ProblemeAst "Ident")
    end
| AstType.Deref(v) ->
    let (n, t) = analyse_code_affectable false v in 
    begin
      match t with
      | Pointeur ta -> 
          let taille = getTaille ta in
          if isWritable then 
            (n ^ storei taille, ta)
          else
            (n ^ loadi taille, ta)
      | _ -> 
          raise (MauvaisType t)
    end
    | AstType.AccesTableau (id, e) ->
      let (n, t) = analyse_code_affectable false id in 
      let code_expr = analyse_code_expression e in 
      begin
        match t with
        | Tableau t_elem -> 
            let taille = getTaille t_elem in
            (* Multipliez l'indice par la taille de l'élément et accédez à l'élément *)
            if isWritable then 
              ((n ^(loadl_int taille) ^ code_expr ^ subr "IMul" ^ subr"IAdd" ^ storei taille),t_elem)
            else
              (n ^ (loadl_int taille) ^code_expr ^subr "IMul" ^ subr "IAdd" ^loadi taille, t_elem)
        | _ -> 
            raise (MauvaisType t)
      end
        

  
(* analyse_code_expression : expression -> string
   Génère le code Tam pour une expression donnée en utilisant des motifs et des types spécifiques.

   @param e : Expression à analyser.
   @return : Chaîne de caractères représentant le code machine généré.
*)

and analyse_code_expression e =
  match e with
  (* Appel de fonction *)
  | AstType.AppelFonction (id, l) ->
      begin
        match info_ast_to_info id with
        | InfoFun(id, _, _) -> 
          let code = String.concat "" (List.map analyse_code_expression l) in
            code ^ call "SB" id
        | _ -> raise (ProblemeAst "AppelFonction")
      end

  (* Booléen *)
  | AstType.Boolean bool -> 
      if (bool=true) then loadl_int 1 else loadl_int 0

  (* Entier *)
  | AstType.Entier n -> 
      loadl_int n

  (* Opération unaire : Numerateur ou Denominateur *)
  | AstType.Unaire (u, e) ->
    let ne =
      analyse_code_expression e in
      begin
        match u with
        | AstType.Numerateur -> ne ^pop 0 1
        | AstType.Denominateur -> ne ^pop 1 1
      end
  
  (* Opération binaire : PlusInt, MultInt, etc. *)
  | AstType.Binaire (op, exp1, exp2) ->
    let ne1 = analyse_code_expression exp1 in
    let ne2 = analyse_code_expression exp2 in
      begin
        match op with
        | AstType.MultInt -> ne1 ^ ne2 ^ subr "IMul"
        | AstType.MultRat -> ne1 ^ne2 ^ call "SB" "RMul"
        | AstType.PlusInt -> ne1 ^ ne2^ subr "IAdd"
        | AstType.PlusRat -> ne1^ ne2 ^ call "SB" "RAdd"
        | AstType.EquBool -> ne1^ ne2 ^ subr "IEq"
        | AstType.Inf -> ne1 ^ne2 ^subr "ILss"
        | AstType.EquInt -> ne1 ^ ne2 ^ subr "IEq"
        | AstType.Fraction -> ne1 ^ne2 ^call "SB" "norm"
      end
  
  (* Affectable *)
  | AstType.Affectable aff -> 
      let (n, _) = analyse_code_affectable false aff in 
      n

  (* Pointeur null *)
  | AstType.Null -> 
      loadl_int (-1)

  | AstType.New t ->
      let taille = getTaille t in 
      loadi taille ^ subr "Malloc"

  | AstType.Adresse a ->
      begin 
        match info_ast_to_info a with 
        | InfoVar(_, _, dep, reg) -> loada dep reg
        | _ -> raise (ProblemeAst "Adresse")
      end
    
(* Création d'un tableau *)
| AstType.CreationTableau (t, e) ->
  let code_expr = analyse_code_expression e in 
  let taille = getTaille t in 
  code_expr 
  ^ loadl_int taille 
  ^ subr "IMul" 
  ^ subr "Malloc"

(* Initialisation d'un tableau *)
| AstType.InitialisationTableau (t, le) ->
  let taille_element = getTaille t in
  let code = List.map analyse_code_expression le in
  let taille_tableau = List.length code * taille_element in
  let code_expr = String.concat "" code in
  loadl_int taille_tableau
  ^ subr "Malloc"
  ^code_expr 
  ^ loada (-taille_tableau - 1) "ST"
  ^loadi 1 
  ^ storei taille_tableau
  
  

(* analyse_code_instruction : instruction -> string
   Génère le code machine pour une instruction donnée en utilisant des motifs et des types spécifiques.

   @param i : Instruction à analyser.
   @return : Chaîne de caractères représentant le code machine généré.
*)

and analyse_code_instruction i =
  match i with


  | AstPlacement.Declaration(info, e) -> 
      begin
        match info_ast_to_info info with
        | InfoVar(_, t, dep, reg) -> 
            let code_expr = analyse_code_expression e in
            let taille = getTaille t in 
            push taille ^ code_expr ^ store taille dep reg
        | _ -> raise (ProblemeAst "Declaration")
      end


  | AstPlacement.Affectation(a, e) -> 
      let code_expr = analyse_code_expression e in 
      let (code_affectable, _) = analyse_code_affectable true a in 
      code_expr ^ code_affectable


  | AstPlacement.Conditionnelle(c, btrue, bfalse) ->
      let code_cond = analyse_code_expression c in
      let code_true = analyse_code_bloc btrue in
      begin
        match bfalse with
        (* si bfalse vide *)
        | [], 0 -> 
            let end_label = getEtiquette() in   
            code_cond ^ jumpif 0 end_label ^ code_true ^ label end_label
        | _, _ ->
            let code_false = analyse_code_bloc bfalse in 
            let else_label = getEtiquette() in 
            let end_label = getEtiquette() in   
            code_cond ^ jumpif 0 else_label ^ code_true 
            ^ jump end_label ^ label else_label ^ code_false 
            ^ label end_label
      end


  | AstPlacement.AffichageBool exp -> 
    let code_expr = analyse_code_expression exp in
    code_expr ^ subr "BOut"

  | AstPlacement.AffichageInt exp -> 
    let code_expr = analyse_code_expression exp in
    code_expr ^ subr "IOut"

  | AstPlacement.AffichageRat exp -> 
    let code_expr = analyse_code_expression exp in
    code_expr ^ call "SB" "ROut"

  | AstPlacement.TantQue(c, b) -> 
      let code_cond = analyse_code_expression c in 
      let code_bloc = analyse_code_bloc b in 
      let debut_label = getEtiquette() in 
      let fin_label = getEtiquette() in 
      label debut_label 
      ^ code_cond 
      ^ jumpif 0 fin_label 
      ^ code_bloc 
      ^ jump debut_label 
      ^ label fin_label

  | AstPlacement.Retour(e, taille_ret, tparam) ->
    begin
      match taille_ret with
      | 0 -> raise (ProblemeAst "Retour")
      | _ -> analyse_code_expression e ^ return taille_ret tparam
    end


  | AstPlacement.Empty -> ""

  | AstPlacement.BoucleFor(ia, e1, e2, e3, bloc) ->
    begin
    let debut_label = getEtiquette() in
    let fin_label = getEtiquette() in

    match (info_ast_to_info ia) with
    | InfoVar(_, t, dep, reg) ->
      let taille = getTaille t in
      let code_init = analyse_code_expression e1 in
      let code_condition = analyse_code_expression e2 in
      let code_increment = analyse_code_expression e3 in
      let code_bloc = analyse_code_bloc bloc in
    
      (* Génération du code pour la boucle for *)
      push taille
      ^ code_init
      ^store taille dep reg
      ^ label debut_label
      ^load taille dep reg
      ^ code_condition
      ^ jumpif 0 fin_label
      ^code_bloc
      ^ code_increment
      ^ store taille dep reg
      ^ jump debut_label
      ^label fin_label
      ^ pop 0 taille
      | _ -> raise (ProblemeAst "Boucle for")
    end

    |AstPlacement.Goto n -> 
      begin
      let info = info_ast_to_info n in
      match info with
      | InfoGoto(lab, _, _, _) -> jump (lab^"zambio")
      | _ -> raise (ProblemeAst "GOTO tam")
      end
    | AstPlacement.Label n -> 
      (match info_ast_to_info n with
      | InfoGoto(lab, _, _, _)  -> label (lab^"zambio")
      | _ -> raise (ProblemeAst "Label tam"))


  
  (* analyse_code_bloc : (instruction list * int) -> string
  Génère le code machine pour un bloc d'instructions.
  Applique analyse_code_instruction sur chaque instruction du bloc.
  
  @param li : Liste d'instructions du bloc.
  @param taille : Taille allouée pour le bloc.

  *)
  and analyse_code_bloc (li, taille) =
  push taille ^ String.concat "" (List.map analyse_code_instruction li) ^ pop 0 taille


  (* analyse_code_fonction :  AstPlacement.fonction -> string*)

let analyse_code_fonction (AstPlacement.Fonction(info, _, (li,taille))) = 
  match info_ast_to_info info with 
  |InfoFun(n, _, _ ) -> ( 
    let n_bloc = analyse_code_bloc (li,taille) in
    n^"\n"^n_bloc  ^ halt)          
  | _ -> raise (ProblemeAst "Fonction")
  
let analyser (AstPlacement.Programme(fonctions, programme)) =
  let l_code = (List.map analyse_code_fonction fonctions) in
  let fonc =  String.concat "" l_code in
  let code_prog = analyse_code_bloc programme in 
  let main = label "main" ^ code_prog ^halt in
    getEntete() ^ fonc ^ main
  