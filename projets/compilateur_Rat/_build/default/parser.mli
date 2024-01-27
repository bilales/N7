
(* The type of tokens. *)

type token = 
  | WHILE
  | VIRG
  | TRUE
  | SLASH
  | RETURN
  | RAT
  | PV
  | PRINT
  | PO
  | PLUS
  | PF
  | NUM
  | NULL
  | NEW
  | MULT
  | INT
  | INF
  | IF
  | ID of (string)
  | GOTO
  | FOR
  | FALSE
  | EQUAL
  | EOF
  | ENTIER of (int)
  | ELSE
  | DP
  | DENOM
  | CONST
  | CO
  | CF
  | BOOL
  | AO
  | AF
  | ADR

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.AstSyntax.programme)
