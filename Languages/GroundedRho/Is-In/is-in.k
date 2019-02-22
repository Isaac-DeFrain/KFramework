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

  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "pattern" ] => true requires S =/=String "leaf" andBool A =/=K "namevar" andBool B =/=K #truncate

// Transitivity
//rule #if A:Type #isIn B:Type andBool B #isIn C:Type #then (A #isIn C => true) #else (A #isIn C => false) #fi

// Matching top-level constructors -> subtype inclusion
  rule type[S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[S ;; C:TerminalType ;; D:TerminalType ] => A #isIn C andBool B #isIn D  [strict]

// Leaves
// SimpleTypes
  rule type[ "leaf" ;; "bool"   ;; _:Bool   ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Bool )   ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] => true
  rule type[ "leaf" ;; "int"    ;; _:Int    ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Int )    ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] => true
  rule type[ "leaf" ;; "string" ;; _:String ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( String ) ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] => true

// #truncate
  rule type[#truncate] #isIn type[ "eval"       ;; _:TerminalType ;; _:TerminalType ] => true
  rule type[#truncate] #isIn type[ "quote"      ;; _:TerminalType ;; _:TerminalType ] => true
  rule type[#truncate] #isIn type[ "simpletype" ;; _:TerminalType ;; _:TerminalType ] => true

// NameVar matches any quoted ProcOrPat
  rule type[ "quote" ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "namevar" ;; _:NameVar] => true

// NameVar matches any NameVar
  rule type[ "leaf" ;; "namevar"        ;; _:NameVar ] #isIn type[ "leaf" ;; "namevar"  ;; _:NameVar ] => true

// Wildcard
/*rule type[ "leaf" ;; S:String         ;; _:Leaf    ] #isIn type[ "leaf" ;; "wildcard" ;; "pattern" ] => true requires S =/=String "namevar" andBool S =/=String "truncate"

  rule type[ "unforgeable" ;; _:String  ;; _:Leaf    ] #isIn type[ "leaf" ;; "wildcard" ;; "pattern" ] => true

  rule type[ "simpletype"  ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "pattern" ] => true

  rule type[ "send"    ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "pattern" ] => true
  rule type[ "receive" ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "pattern" ] => true
  rule type[ "eval"    ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "pattern" ] => true
  rule type[ "par"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "pattern" ] => true
*/
//-------------------------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------
//--- Name, Process, Pattern ---
//------------------------------
// Leaves are Process except #truncate & namevar
  rule type[ "leaf" ;; A:String   ;; _:Leaf    ] #isIn Process => true requires A =/=String "truncate" andBool A =/=String "namevar"
  rule type[ "leaf" ;; "truncate" ;; #truncate ] #isIn Process => false
  rule type[ "leaf" ;; "namevar"  ;; _:NameVar ] #isIn Process => false

// Variables are Pattern
  rule type[ "leaf" ;; "namevar"  ;; _:NameVar ] #isIn Pattern => true
  rule type[ "leaf" ;; "namevar"  ;; _:NameVar ] #isIn Process => false

// SimpleTypes are patterns
  rule type[ "simpletype" ;; type[toString(Bool)  ] ;; type[ #truncate ] ] #isIn Pattern => true
  rule type[ "simpletype" ;; type[toString(Bool)  ] ;; type[ #truncate ] ] #isIn Process => false

  rule Process #isIn type[ "eval" ;; "namevar" ;; _:NameVar] => true

endmodule
