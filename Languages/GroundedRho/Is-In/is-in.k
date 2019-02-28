// The isIn predicate - checks for type inclusion

require "domains.k"
require "../StructuralTypes/stype.k"

module IS-IN-SYNTAX
  import DOMAINS
  import STYPE-SYNTAX

// The type inclusion predicate
  syntax    Bool ::= Type "#isIn" Type          [function]

// Process, Pattern, Name types
  syntax    Type ::= "Process"
                   | "Pattern"
                   | "Name"

endmodule

module IS-IN
  import IS-IN-SYNTAX

  syntax KResult ::= Bool

//---------------------------------
//--- #isIn Predicate Semantics ---
//---------------------------------

// Reflexivity
  rule T:Type #isIn T => true

  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "procpat" ] => true 
       requires S =/=String "leaf" andBool S =/=String "quote" andBool B =/=K #truncate

// Matching top-level constructors -> subtype inclusion
  rule type[S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[S ;; C:IntermediateType ;; D:IntermediateType ] 
       => A #isIn C andBool B #isIn D requires S =/=String "par" [strict]

// Par is unordered - TODO
  rule type[ "par" ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[ S:String ;; C:IntermediateType ;; D:IntermediateType ]
       => type[ S ;; C ;; D ] ==K type[ "leaf" ;; "wildcard" ;; "procpat" ] orBool
         (S ==String "par" andBool (((A #isIn C andBool B #isIn D) orBool (A #isIn D andBool B #isIn C)) orBool 
          type[ "par" ;; A ;; B ] #isIn C orBool type[ "par" ;; A ;; B ] #isIn D))

// Nil in par is structurally vacuous: P | Nil <=> Nil | P <=> P
  rule type[ "par" ;; A:IntermediateType ;; type[ "leaf" ;; "nil" ;; "Nil" ] ] #isIn A => true
  rule type[ "par" ;; type[ "leaf" ;; "nil" ;; "Nil" ] ;; A:IntermediateType ] #isIn A => true

//--- Leaves ---
// SimpleTypes
  rule type[ "leaf" ;; S:String ;; _:Leaf ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Bool )   ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ]
       => S ==String "bool"
  rule type[ "leaf" ;; S:String ;; _:Leaf ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Int )    ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ]
       => S ==String "int"
  rule type[ "leaf" ;; S:String ;; _:Leaf ] #isIn type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( String ) ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ]
       => S ==String "string"

// #truncate
  rule T:Type #isIn type[ "leaf" ;; "truncate" ;; #truncate ] => T ==K type[#truncate] orBool T ==K type[ "leaf" ;; "truncate" ;; #truncate ]
  rule T:Type #isIn type[ #truncate ] => T ==K type[#truncate] orBool T ==K type[ "leaf" ;; "truncate" ;; #truncate ]
  rule type[#truncate] #isIn type[ "eval"       ;; _:TerminalType ;; _:TerminalType ] => true
  rule type[#truncate] #isIn type[ "quote"      ;; _:TerminalType ;; _:TerminalType ] => true
  rule type[#truncate] #isIn type[ "simpletype" ;; _:TerminalType ;; _:TerminalType ] => true

  rule T:Type #isIn type[ "leaf" ;; "bool"   ;; C:Bool   ] => T ==K type[ "leaf" ;; "bool"   ;; C ]
  rule T:Type #isIn type[ "leaf" ;; "int"    ;; C:Int    ] => T ==K type[ "leaf" ;; "int"    ;; C ]
  rule T:Type #isIn type[ "leaf" ;; "string" ;; C:String ] => T ==K type[ "leaf" ;; "string" ;; C ]

// WildCards
// WildName matches any quoted ProcOrPat
  rule type[ "quote" ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "name"] => true

// WildName matches any unforgeable name
  rule type[ "unforgeable" ;; _:String  ;; _:Leaf    ] #isIn type[ "leaf" ;; "wildcard" ;; "name" ] => true

// WildProc matches leaves except #truncate
  rule type[ "leaf" ;; S:String         ;; L:Leaf    ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ] => S =/=String "truncate" andBool L =/=K "name"

// WildProc matches any Send, Receive, Eval, Par, SimpleType
  rule type[ "send"       ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ] => true
  rule type[ "receive"    ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ] => true
  rule type[ "eval"       ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ] => true
//  rule type[ "par"        ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ] => true
  rule type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ] => true

// Variables
  rule T:Type #isIn type[ "leaf" ;; "procvar" ;; C:ProcVar ] => T ==K type[ "leaf" ;; "procvar" ;; C ]

// Nil only includes Nil
  rule T:Type #isIn type[ "leaf" ;; "nil" ;; "Nil" ] => T ==K type[ "leaf" ;; "nil" ;; "Nil" ]

//--- Connectives ---
  rule T:Type #isIn type[ "and" ;; A:IntermediateType ;; B:IntermediateType ] => T #isIn A andBool T #isIn B
  rule T:Type #isIn type[ "or"  ;; A:IntermediateType ;; B:IntermediateType ] => T #isIn A orBool  T #isIn B
  rule T:Type #isIn type[ "not" ;; A:IntermediateType ;; _:IntermediateType ] => notBool T #isIn A

// Transitivity
//rule #if A:Type #isIn B:Type andBool B #isIn C:Type #then (A #isIn C => true) #else (A #isIn C => false) #fi 

//--------------------------------------------------------------------------------------------------------------------------------------------

//------------------------------------
//--- Name, Process, Pattern Types ---
//------------------------------------
// Leaves are Process except #truncate
  rule type[ "leaf" ;; A:String   ;; _:Leaf    ] #isIn Process => A =/=String "truncate"

// Variables are Process
  rule type[ "leaf" ;; "procvar"  ;; _:ProcVar ] #isIn Process => true
  rule type[ "leaf" ;; "procvar"  ;; _:ProcVar ] #isIn Pattern => false

  rule type[ "quote" ;; A:IntermediateType ;; B:IntermediateType ] #isIn Name 
       => A #isIn Process andBool B #isIn type[ "leaf" ;; "truncate" ;; #truncate ]

  rule type[ "quote" ;; A:IntermediateType ;; B:IntermediateType ] #isIn Pattern
       => A #isIn Pattern andBool B #isIn type[ "leaf" ;; "truncate" ;; #truncate ] 

// SimpleTypes are Pattern
//  rule type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString(Bool)  ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] #isIn T:Type
//       => T ==K Pattern orBool T ==K type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString(Bool)  ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ]

  rule type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString(Int)   ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] #isIn Pattern => true
  rule type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString(Int)   ] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] #isIn Process => false

  rule type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString(String)] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] #isIn Pattern => true
  rule type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString(String)] ;; type[ "leaf" ;; "truncate" ;; #truncate ] ] #isIn Process => false

endmodule