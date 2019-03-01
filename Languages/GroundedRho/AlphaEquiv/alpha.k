// Alpha Equivalence for Grounded Rho Calculus

require "../StructuralTypes/stype.k"

module ALPHA-SYNTAX
  import STYPE

  syntax    Bool ::= Type "#alpha" Type  [function,strict]

endmodule

module ALPHA
  import ALPHA-SYNTAX

  configuration
  <k> $PGM:Bool </k>

// Reflexitivity
  rule T:Type #alpha T => true

// Top-level constructor not equal => not alpha equivalent
  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #alpha type[ T:String ;; C:IntermediateType ;; D:IntermediateType ]
       => false requires S =/=String T

// Recursive step
  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #alpha type[ S ;; C:IntermediateType ;; D:IntermediateType ]
       => A #alpha C andBool B #alpha D requires S =/=String "leaf" andBool S =/=String "par"

  rule type[ "par" ;; A:IntermediateType ;; B:IntermediateType ] #alpha type[ "par" ;; C:IntermediateType ;; D:IntermediateType ]
       => (A #alpha C andBool B #alpha D) orBool (A #alpha D andBool B #alpha C)

  rule type[ "leaf" ;; "procvar" ;; _:ProcVar ] #alpha type[ "leaf" ;; "procvar" ;; _:ProcVar ] => true

endmodule