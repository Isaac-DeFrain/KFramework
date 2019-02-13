// The isIn predicate - checks for type inclusion

require "domains.k"
require "../StructuralTypes/stype.k"

module IS-IN-SYNTAX
  import DOMAINS
  import STYPE-SYNTAX

// The function isIn is the inclusion predicate
  syntax    Bool ::= Type "isIn" Type          [function]

// Auxiliaries
/*
  syntax    Bool ::= Type "isIn-leaf" Type  [function, strict]
  syntax    Bool ::= Type "isIn-pat"  Type  [function, strict]
*/
  syntax KResult ::= Bool

endmodule

module IS-IN
  import IS-IN-SYNTAX

// Semantics for the isIn predicate

// Leaves
// "bool isIn bool", "int isIn int", "string isIn string", "Nil isIn Nil", "#truncate isIn #truncate"

//  rule type[ "leaf" ;; "nil" ;; "Nil" ] isIn type[ "leaf" ;; "procvar" ;; _ ] => true

// SimpleTypes - "bool isIn Bool", "int isIn Int", "string isIn String"
  rule type[ "leaf" ;; "bool"   ;; _:Bool  ] isIn type[ "simpletype" ;; type[toString(Bool)  ] ;; type[ #truncate ] ] => true
  rule type[ "leaf" ;; "int"    ;; _:Bool  ] isIn type[ "simpletype" ;; type[toString(Int)   ] ;; type[ #truncate ] ] => true
  rule type[ "leaf" ;; "string" ;; _:Bool  ] isIn type[ "simpletype" ;; type[toString(String)] ;; type[ #truncate ] ] => true

// Variables
// name variables match any quoted process
//  rule type[ "quote" ;; _:IntermediateType ;; type[ #truncate ] ] isIn type[ "leaf" ;; "namevar" ;; _ ] => true
// S1 ==String "quote" andBool S2 ==String "leaf" andBool

// name variables match any name
//rule type[ _:Name                                             ] isIn type[ "leaf" ;; "namevar" ;; _ ] => true

// process variables match any evaluated name
//  rule type[ "reify" ;; _:IntermediateType ;; type[ #truncate ] ] isIn type[ "leaf" ;; "procvar" ;; _ ] => true

// process variables match any process
//rule type[ _:Proc                                             ] isIn type[ "leaf" ;; "procvar" ;; _ ] => true

  rule T:Type isIn T => true

// conditional over sort of A1, A2, B1, B2
  rule type[ S1:String ;; A1:IntermediateType ;; A2:IntermediateType ]                                       // Proc or Name
       isIn
       type[ S2:String ;; B1:TerminalType     ;; B2:TerminalType     ]                                       // ProcOrPat
       =>
       #if   S2 ==String "leaf"                                                                              // type[ProcOrPat] is a LeafType
       #then                                                                                                 //
            #if   S1 =/=String "quote" andBool B1 ==String "procvar"                                         // ProcVar matches any Proc
            #then A1 =/=String "truncate"                                                                    // not Proc if type[ ... ;; "truncate" ;; ... ]
            #else
                 #if   S1 ==String "quote" andBool B1 ==String "namevar"                                     // NameVar matches any Name
                 #then true
                 #else false // B1 =/= "prcovar", now what?
                 #fi
            #fi
       #else                                                                                                // type[ProcOrPat] is NOT a LeafType
            #if   S2 ==String "simpletype"
            #then toString(B1) ==String toString(Bool)   andBool A1 ==String "bool"
                  orBool
                  toString(B1) ==String toString(Int)    andBool A1 ==String "int"
                  orBool
                  toString(B1) ==String toString(String) andBool A1 ==String "string"
            #else false // ProcOrPat is Not  SimpleType and type[...] is NOT a LeafType
            #fi
       #fi

endmodule
