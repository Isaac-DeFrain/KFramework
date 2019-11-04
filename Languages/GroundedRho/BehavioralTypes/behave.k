// Behavioral Types

require "../grho.k"
require "../Match/match.k"
// other requirements

module BEHAVE-SYNTAX
  import GRHO-SYNTAX

// TODO: add other constructs
  // Nullity
  syntax          Nullity ::= "Null"

  // Greatest fixed point operator
  syntax          Recurse ::= "rec" PatVar "." ProcPat

  // Quantification
  syntax         Quantify ::= NQuantify | PQuantify

    // Name variable quantification
  syntax        NQuantify ::= "\\forall" Var ":" NamePat "." ProcPat
                            | "\\forall" Var "."  ProcPat

    // Proc variable quantification
  syntax        PQuantify ::= "\\forall" ProcVar ":" ProcPat "." ProcPat
                            | "\\forall" ProcVar "."  ProcPat

endmodule

module BEHAVE
  import BEHAVE-SYNTAX

// configuration???

endmodule
