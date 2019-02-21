// The isIn predicate - checks for type inclusion

require "domains.k"
require "../StructuralTypes/stype.k"

module IS-IN-SYNTAX
  import DOMAINS
  import STYPE-SYNTAX

// The function isIn is the inclusion predicate
  syntax    Bool ::= Type "#isIn" Type          [function]

  syntax    Type ::= "Process"
                   | "Pattern"
                   | "Name"

endmodule

module IS-IN
  import IS-IN-SYNTAX

  syntax KResult ::= Bool

// #isIn Predicate Semantics

// Reflexivity
  rule T:Type #isIn T => true

// Transitivity
//rule #if A:Type #isIn B:Type andBool B #isIn C:Type #then (A #isIn C => true) #else (A #isIn C => false) #fi

// Matching top-level constructors -> subtype inclusion
  rule type[S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[S ;; C:TerminalType ;; D:TerminalType ] => A #isIn C andBool B #isIn D  [strict]

// Leaves
// SimpleTypes
  rule type[ "leaf" ;; "bool"   ;; B:Bool   ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Bool )   ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] => true
  rule type[ "leaf" ;; "int"    ;; I:Int    ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Int )    ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] => true
  rule type[ "leaf" ;; "string" ;; S:String ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( String ) ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] => true

// #truncate
  rule type[#truncate] #isIn type[ "eval"       ;; A:TerminalType ;; B:TerminalType ] => true
  rule type[#truncate] #isIn type[ "quote"      ;; A:TerminalType ;; B:TerminalType ] => true
  rule type[#truncate] #isIn type[ "simpletype" ;; A:TerminalType ;; B:TerminalType ] => true

// Quoted processes match NameVar
  rule type[ "quote" ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[ "leaf" ;; "namevar" ;; N:NameVar] => true

  rule type[ "leaf" ;; "namevar" ;; M:NameVar ] #isIn type[ "leaf" ;; "namevar" ;; N:NameVar ] => true


//-------------------------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------
//--- Name, Process, Pattern ---
//------------------------------
// Leaves are Process except #truncate & namevar
  rule type[ "leaf" ;; A:String   ;; L:Leaf    ] #isIn Process => true requires A =/=String "truncate" andBool A =/=String "namevar"
  rule type[ "leaf" ;; "truncate" ;; #truncate ] #isIn Process => false
  rule type[ "leaf" ;; "namevar"  ;; L:NameVar ] #isIn Process => false

// Variables are Pattern
  rule type[ "leaf" ;; "namevar"  ;; N:NameVar ] #isIn Pattern => true
  rule type[ "leaf" ;; "namevar"  ;; N:NameVar ] #isIn Process => false

// SimpleTypes are patterns
  rule type[ "simpletype" ;; type[toString(Bool)  ] ;; type[ #truncate ] ] #isIn Pattern => true
  rule type[ "simpletype" ;; type[toString(Bool)  ] ;; type[ #truncate ] ] #isIn Process => false

  rule Process #isIn type[ "eval" ;; "namevar" ;; N:NameVar] => true

endmodule
