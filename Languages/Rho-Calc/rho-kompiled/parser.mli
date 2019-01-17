type token =
  | STRING of (string)
  | KLABEL of (string)
  | KSEQ
  | DOTK
  | LPAREN
  | RPAREN
  | COMMA
  | DOTKLIST
  | TOKENLABEL
  | KLABELLABEL
  | EOF

val top :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Constants.k
