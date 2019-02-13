// The #isIn predicate - checks for type inclusion

require "stype.k"

module IS-IN-SYNTAX
  import STYPE

// The function #isIn is the inclusion predicate
  syntax    Bool ::= Type "#isIn"      Type  [function, strict]

// Auxiliaries
  syntax    Bool ::= Type "#isIn-leaf" Type  [function, strict]
  syntax    Bool ::= Type "#isIn-pat"  Type  [function, strict]

  syntax KResult ::= Bool

endmodule

module IS-IN
  import IS-IN-SYNTAX

// Leaves
// bool #isIn bool, int #isIn int, string #isIn string, Nil #isIn Nil, #truncate #isIn #truncate
  rule type[ "leaf" ;; A:String ;; L1:Leaf ] #isIn type[ "leaf" ;; B:String ;; L2:Leaf ] => A ==String B andBool L1 ==K L2

// SimpleTypes - bool #isIn Bool, int #isIn Int, string #isIn String
  rule type[ "leaf" ;; "bool"   ;; _:Bool  ] #isIn type[ "simpletype" ;; type[toString(Bool)  ] ;; type[#truncate] ] => true
  rule type[ "leaf" ;; "int"    ;; _:Bool  ] #isIn type[ "simpletype" ;; type[toString(Int)   ] ;; type[#truncate] ] => true
  rule type[ "leaf" ;; "string" ;; _:Bool  ] #isIn type[ "simpletype" ;; type[toString(String)] ;; type[#truncate] ] => true

// Variables
  rule type[ "quote" ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "namevar" ;; _:NameVar ] => true
  rule type[ _:Name ] #isIn type[ "leaf" ;; "namevar" ;; _:NameVar ] => true

// Semantics for the #isIn predicate
  rule type[ S1:String ;; A1:IntermediateType ;; A2:IntermediateType ]                            // Proc
       #isIn
       type[ S2:String ;; B1:IntermediateType ;; B2:IntermediateType ]                            // ProcOrPat
       =>
         #if toString([ S1 ;; A1 ;; A2 ]) ==String toString([ S2 ;; B1 ;; B2 ])                   // ProcOrPat == Proc
         #then true
         #else
         #fi

endmodule
