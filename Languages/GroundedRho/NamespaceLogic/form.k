// Namespace Logic

require "../grho.k"

module FORM-SYNTAX
  import GRHO

  syntax  PForm ::= Bool
                  | "{" PForm "}"                     [bracket]
                  | "Nil"
                  | "not" PForm                        [strict]
                  | PForm "&" PForm                 [seqstrict]
                  | PForm "|" PForm                      [left]
                  | "*" NForm                          [strict]
                  | QForm "!" "(" PForm ")"
                  | "(" QForm "?" NForm ")" PForm
                  | "rec" Name "." PForm
                  | "All" Name ":" PForm "." PForm

  syntax  QForm ::= "@" PForm
                  | NForm

  syntax  NForm ::= "@" Proc
                  | Name

endmodule

module FORM
  import FORM-SYNTAX

endmodule