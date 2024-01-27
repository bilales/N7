(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast

type t1 = Ast.AstSyntax.programme
type t2 = Ast.AstTds.programme

(* analyse_tds_affectable: tds -> AstSyntax.affectable -> AstTds.affectable *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre a :  l'affectable à analyser *)
(* Paramètre tds_Label : table de symboles des labels*)
(* Paramètre is_modifiable : boolean indique si l'affectable est modifiable *)
(* Vérifie la bonne utilisation des affectables et tranforme l'affectable
en une affectable de type AstTds.affectable  *)
(* Erreur si  mauvaise utilisation des identifiants *)
(* Erreur si l'identifiant n'est pas déclaré *)

let rec analyse_tds_affectable tds tds_Label is_modifiable a  =
  match a with
  | AstSyntax.Ident id ->
      begin
        match chercherGlobalement tds id with
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds globale. *)
          raise (IdentifiantNonDeclare id)
        | Some info ->
          (* L'identifiant est trouvé dans la tds globale,
          il a donc déjà été déclaré. L'information associée est récupérée. *)
          begin
            match info_ast_to_info info with
            | InfoVar _ ->
              (* Renvoie de l'identifiant *)
              AstTds.Ident info
            | InfoConst _ ->
              (* Modification d'une constante *)
              if is_modifiable then raise (MauvaiseUtilisationIdentifiant id)
              else AstTds.Ident info
            |  _ ->
              (* Modification d'une constante ou d'une fonction *)
              raise (MauvaiseUtilisationIdentifiant id)
          end
      end
  | AstSyntax.Deref a -> 
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      (* Renvoie de la nouvelle Deref où l'expression remplacée par l'expression issue de l'analyse *)
      let aff = analyse_tds_affectable tds tds_Label  is_modifiable a in
      AstTds.Deref (aff)

  | AstSyntax.AccesTableau (affect, expr) ->
        (* Analyse de l'affectable représentant le tableau *)
        let affect_analyse = analyse_tds_affectable tds tds_Label is_modifiable affect in
        (* Analyse de l'expression représentant l'indice *)
        let expr_analyse = analyse_tds_expression tds tds_Label expr in
        (* Construction du nouvel AccesTableau avec les composants analysés *)
        AstTds.AccesTableau (affect_analyse, expr_analyse)

      


(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
and  analyse_tds_expression tds tds_Label e = 
  match e with
  | AstSyntax.AppelFonction (n, le) ->
      begin
        match chercherGlobalement tds n with
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds globale. *)
          raise (IdentifiantNonDeclare n)
        | Some info ->
          (* L'identifiant est trouvé dans la tds globale,
          il a donc déjà été déclaré. L'information associée est récupérée. *)
          begin
            match info_ast_to_info info with
            | InfoFun _ ->
              (* Vérification de la bonne utilisation des identifiants dans les expressions *)
              (* et obtention des expressions transformées *)
              let nle = List.map (analyse_tds_expression tds tds_Label) le in
              (* Renvoie de l'appel de fonction où le nom a été remplacé par l'information
                 et les expressions remplacées par les expressions issues de l'analyse *)
              AstTds.AppelFonction (info, nle)
            |  _ ->
              (* Appel d'une variable ou d'une constante *)
              raise (MauvaiseUtilisationIdentifiant n)
          end
      end
  | AstSyntax.Boolean bool -> AstTds.Boolean bool
  | AstSyntax.Entier i ->
      (* Renvoie du nouvel entier *)
      AstTds.Entier i
  | AstSyntax.Binaire (op, e1, e2) ->
      (* Vérification de la bonne utilisation des identifiants dans les expressions *)
      (* et obtention des expressions transformées *)
      let ne1 = analyse_tds_expression tds tds_Label e1 in
      let ne2 = analyse_tds_expression tds tds_Label e2 in
      (* Renvoie du nouveau binaire où les expressions remplacées par les expressions issues de l'analyse *)
      AstTds.Binaire (op, ne1, ne2)
  | AstSyntax.Affectable a ->
      (* Vérification de la bonne utilisation des identifiants dans l'affectable *)
      (* et obtention de l'affectable transformé *)
      let na = analyse_tds_affectable tds tds_Label false a in
      (* Renvoie de la nouvelle affectable où l'affectable remplacé par l'affectable issue de l'analyse *)
      AstTds.Affectable na
  | AstSyntax.Adresse a -> 
      begin
        match chercherGlobalement tds a with
        | Some info ->
          (* L'identifiant est trouvé dans la tds globale,
          il a donc déjà été déclaré. L'information associée est récupérée. *)
          begin
            match info_ast_to_info info with
            | InfoVar _ ->
              (* Renvoie de l'identifiant *)
              AstTds.Adresse info
            |  _ ->
              (* Modification d'une constante ou d'une fonction *)
              raise (MauvaiseUtilisationIdentifiant a)
          end
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds globale. *)
          raise (IdentifiantNonDeclare a)
      end
  | AstSyntax.New t -> AstTds.New t
  | AstSyntax.Null -> AstTds.Null
  | AstSyntax.CreationTableau (t,e) ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds tds_Label e in
      (* Renvoie de la nouvelle création de tableau où l'expression remplacée par l'expression issue de l'analyse *)
      AstTds.CreationTableau (t, ne)
  | AstSyntax.InitialisationTableau el ->
      (* Vérification de la bonne utilisation des identifiants dans les expressions *)
      (* et obtention des expressions transformées *)
      let nel = List.map (analyse_tds_expression tds tds_Label) el in
      (* Renvoie de l'initialisation de tableau où les expressions remplacées par les expressions issues de l'analyse *)
      AstTds.InitialisationTableau nel
  
  |AstSyntax.Unaire (op, e) ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds tds_Label e in
      (* Renvoie du nouveau unaire où l'expression remplacée par l'expression issue de l'analyse *)
      AstTds.Unaire (op, ne)


(* analyse_tds_instruction : tds -> info_ast option -> AstSyntax.instruction -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si l'instruction i est dans le bloc principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est l'instruction i sinon *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds tds_Label oia i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
      begin
        match chercherLocalement tds n with
        | None ->
            (* L'identifiant n'est pas trouvé dans la tds locale,
            il n'a donc pas été déclaré dans le bloc courant *)
            (* Vérification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformée *)
            let ne = analyse_tds_expression tds tds_Label e in
            (* Création de l'information associée à l'identfiant *)
            let info = InfoVar (n,Undefined, 0, "") in
            (* Création du pointeur sur l'information *)
            let ia = info_to_info_ast info in
            (* Ajout de l'information (pointeur) dans la tds *)
            ajouter tds n ia;
            (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information
            et l'expression remplacée par l'expression issue de l'analyse *)
            AstTds.Declaration (t, ia, ne)
        | Some _ ->
            (* L'identifiant est trouvé dans la tds locale,
            il a donc déjà été déclaré dans le bloc courant *)
            raise (DoubleDeclaration n)
      end
  | AstSyntax.Affectation (aff,exp) -> 
    let new_aff = analyse_tds_affectable tds tds_Label true aff in
    let new_exp = analyse_tds_expression tds tds_Label exp in
    AstTds.Affectation (new_aff, new_exp)

  | AstSyntax.Constante (n,v) ->
      begin
        match chercherLocalement tds n with
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds locale,
             il n'a donc pas été déclaré dans le bloc courant *)
          (* Ajout dans la tds de la constante *)
          ajouter tds n (info_to_info_ast (InfoConst (n,v)));
          (* Suppression du noeud de déclaration des constantes devenu inutile *)
          AstTds.Empty
        | Some _ ->
          (* L'identifiant est trouvé dans la tds locale,
          il a donc déjà été déclaré dans le bloc courant *)
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds tds_Label e in
      (* Renvoie du nouvel affichage où l'expression remplacée par l'expression issue de l'analyse *)
      AstTds.Affichage (ne)

  | AstSyntax.Conditionnelle (c,t,e) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds tds_Label c in
      (* Analyse du bloc then *)
      let bloc_then = analyse_tds_bloc tds tds_Label oia t in
      (* Analyse du bloc else *)
      let bloc_else = analyse_tds_bloc tds tds_Label oia e in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      AstTds.Conditionnelle (nc, bloc_then, bloc_else)
  | AstSyntax.TantQue (cond,b) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds tds_Label cond in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds tds_Label oia b in
      (* Renvoie la nouvelle structure de la boucle *)
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
      begin
      (* On récupère l'information associée à la fonction à laquelle le return est associée *)
      match oia with
        (* Il n'y a pas d'information -> l'instruction est dans le bloc principal : erreur *)
      | None -> raise RetourDansMain
        (* Il y a une information -> l'instruction est dans une fonction *)
      | Some ia ->
        (* Analyse de l'expression *)
        let ne = analyse_tds_expression tds tds_Label e in
        AstTds.Retour (ne,ia)
      end
  | AstSyntax.BoucleFor (t, id1, expr1, expr2, id2, expr3, b) ->

      if id1 <> id2 then
        raise (IterateurForNonDeclare "identifiants différents dans la boucle for") 
      else
        (* Création d'une nouvelle TDS fille pour la boucle *)
        let tds_boucle = creerTDSFille tds in
  
        (* Ajout de l'identifiant de la boucle à la TDS fille *)
        let info = InfoVar(id1, Undefined, 0, "") in
        let ia = info_to_info_ast info in
        ajouter tds_boucle id1 ia;
  
        (* Analyse des expressions de la boucle avec la nouvelle TDS fille *)
        let ne1 = analyse_tds_expression tds_boucle tds_Label expr1 in
        let ne2 = analyse_tds_expression tds_boucle tds_Label expr2 in
        let ne3 = analyse_tds_expression tds_boucle tds_Label expr3 in
  
        (* Analyse du bloc de la boucle avec la nouvelle TDS fille *)
        let nb = analyse_tds_bloc tds_boucle tds_Label (Some ia) b in
  
        (* Construction de la nouvelle instruction BoucleFor avec les éléments analysés *)
        AstTds.BoucleFor (t, ia , ne1, ne2, ne3, nb)
    
    |AstSyntax.Goto (s) ->
      let info = InfoGoto(s, Undefined, 0, "") in
      let ia = info_to_info_ast info in
      AstTds.Goto (ia)

    |AstSyntax.Label (s) -> 
      match chercherLocalement tds_Label s with
      | None -> 
        let info = InfoGoto(s, Undefined, 0, "")  in
        let ia = info_to_info_ast info in
        ajouter tds_Label s ia;
      AstTds.Label (ia)
      | Some _ -> raise (DoubleDeclaration s)
  


(* analyse_tds_bloc : tds -> info_ast option -> AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre tds_Label : la table des symboles des labels courante *)
(* Paramètre oia : None si le bloc li est dans le programme principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est le bloc li sinon *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds tds_Label oia li =
  (* Entrée dans un nouveau bloc, donc création d'une nouvelle tds locale
  pointant sur la table du bloc parent *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc.
     Cette tds est modifiée par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc tds_Label oia) li in
   (* afficher_locale tdsbloc ; *) (* décommenter pour afficher la table locale *)
   nli


(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre tds_Label : la table des symboles des labels courante *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds tds_Label (AstSyntax.Fonction(t,n,lp,li))  =
  match chercherLocalement maintds n with
  | Some _ -> raise (DoubleDeclaration n)
  | None -> 
    let info_fonction = info_to_info_ast (InfoFun(n,Undefined,[])) in
    ajouter maintds n info_fonction;
    let tdsfille = creerTDSFille maintds in
    let m = List.map (fun (a,b) -> 
      match chercherLocalement tdsfille b with
      | Some _ -> raise (DoubleDeclaration b)
      | None -> 
        let i = info_to_info_ast (InfoVar(b, Undefined, 0, "")) in
        ajouter tdsfille b i;
        (a ,i)
    ) lp in
    Ast.AstTds.Fonction (t, info_fonction, m, analyse_tds_bloc tdsfille tds_Label (Some info_fonction) li)

(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (fonctions,prog)) =
  let tds = creerTDSMere () in
  let tds_Label = creerTDSMere () in
  let nf = List.map (analyse_tds_fonction tds tds_Label) fonctions in
  let nb = analyse_tds_bloc tds  tds_Label None prog in
  AstTds.Programme (nf,nb)
