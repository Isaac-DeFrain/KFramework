// The #isIn predicate - checks for type inclusion
// Normalizer needed for par structural inclusion?

require "domains.k"
require "../StructuralTypes/stype.k"

module IS-IN-SYNTAX
  import DOMAINS
  import STYPE-SYNTAX

// The type inclusion predicate
  syntax    Bool ::= Type "#isIn"   Type     [function]
                   |      "#isName" Type     [function]
                   |      "#isProc" Type     [function]
								   |      "#isPat"  Type     [function]

// Name, Process, Pattern types for #isName, #isProc, #isPat predicates
  syntax    Type ::= "Name"
                   | "Process"
                   | "Pattern"

endmodule

module IS-IN
  import IS-IN-SYNTAX

  syntax KResult ::= Bool

//--------------------------------
//--- Type Inclusion Semantics ---
//--------------------------------

// Reflexivity of type inclusion
  rule T:Type #isIn T => true

// Transitivity
//  rule A:Type #isIn B:Type xorBool B #isIn C:Type => notBool A #isIn C 

// Matching top-level constructors -> subtype inclusion (excluding Par & Leaf)
  rule type[S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[S ;; C:IntermediateType ;; D:IntermediateType ] 
       => A #isIn C andBool B #isIn D requires S =/=String "par" andBool S =/=String "leaf"

// Par is unordered - TODO
// Par matches with another Par
  rule type[ "par" ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[ "par" ;; C:IntermediateType ;; D:IntermediateType ]
       => (A #isIn C andBool B #isIn D) orBool
          (A #isIn D andBool B #isIn C) orBool
          (type[ "par" ;; A ;; B ] #isIn C andBool D ==K type[ "leaf" ;; "nil" ;; "Nil" ]) orBool
          (type[ "par" ;; A ;; B ] #isIn D andBool C ==K type[ "leaf" ;; "nil" ;; "Nil" ])

// Par Recursion - TODO
  rule type[ "par" ;; type[ "par" ;; A:IntermediateType ;; B:IntermediateType ] ;; C:IntermediateType ]
       #isIn
       type[ "par" ;; D:IntermediateType ;; E:IntermediateType ]
       => (A #isIn D andBool type[ "par" ;; B ;; C ] #isIn E) orBool
          (A #isIn E andBool type[ "par" ;; B ;; C ] #isIn D) orBool
          (B #isIn D andBool type[ "par" ;; A ;; C ] #isIn E) orBool
          (B #isIn E andBool type[ "par" ;; A ;; C ] #isIn D) orBool
          (C #isIn D andBool type[ "par" ;; A ;; B ] #isIn E) orBool
          (C #isIn E andBool type[ "par" ;; A ;; B ] #isIn D)

// Nil in par is structurally vacuous: P | Nil <=> Nil | P <=> P
  rule type[ "par" ;; A:IntermediateType ;; type[ "leaf" ;; "nil" ;; "Nil" ] ] #isIn A => true
  rule type[ "par" ;; type[ "leaf" ;; "nil" ;; "Nil" ] ;; A:IntermediateType ] #isIn A => true

//--- Leaves ---
// SimpleTypes
// Each bool, integer, string has only one inhabitant <=> concrete processes
  rule T:Type #isIn type[ "leaf"  ;; "bool"        ;; B:Bool    ] => T ==K type[ "leaf"  ;; "bool"        ;;  B     ]
  rule T:Type #isIn type[ "leaf"  ;; "int"         ;; I:Int     ] => T ==K type[ "leaf"  ;; "int"         ;;  I     ]
  rule T:Type #isIn type[ "leaf"  ;; "procvar"     ;; X:ProcVar ] => T ==K type[ "leaf"  ;; "procvar"     ;;  X     ]
  rule T:Type #isIn type[ "leaf"  ;; "nil"         ;; "Nil"     ] => T ==K type[ "leaf"  ;; "nil"         ;; "Nil"  ]
  rule T:Type #isIn type[ "leaf"  ;; "string"      ;; S:String  ] => T ==K type[ "leaf"  ;; "string"      ;;  S     ]
  rule T:Type #isIn type[ "leaf"  ;; "unforgeable" ;; I:Int     ] => T ==K type[ "leaf"  ;; "unforgeable" ;;  I     ]
  rule T:Type #isIn type[ "leaf"  ;; "uri"         ;; S:String  ] => T ==K type[ "leaf"  ;; "uri"         ;;  S     ]
  rule T:Type #isIn type[ "empty" ;; "method"      ;; "args"    ] => T ==K type[ "empty" ;; "method"      ;; "args" ]

// Each bool is in Bool
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Bool )        ] ;; type[ #truncate ] ]
       => S ==String "bool"

// Each bytearray is in ByteArray
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( ByteArray )   ] ;; type[ #truncate ] ]
       => S ==String "bytearray"

// Each integer is in Int
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Int )         ] ;; type[ #truncate ] ]
       => S ==String "int"

// Each list is in List
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( List )        ] ;; type[ #truncate ] ]
       => S ==String "list"

// Each map is in Map
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Map )         ] ;; type[ #truncate ] ]
       => S ==String "map"

// Each set is in Set
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Set )         ] ;; type[ #truncate ] ]
       => S ==String "set"

// Each string is in String
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( String )      ] ;; type[ #truncate ] ]
       => S ==String "string"

// Each tuple is in Tuple
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Tuple )       ] ;; type[ #truncate ] ]
       => S ==String "tuple"

// Each unforgeable is in Unforgeable
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Unforgeable ) ] ;; type[ #truncate ] ]
       => S ==String "unforgeable"

// Each uri is in Uri
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Uri )         ] ;; type[ #truncate ] ]
       => S ==String "uri"

// No constructed OrPats in SimpleType
  rule type[ "par"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "quote"   ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "send"    ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "receive" ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "eval"    ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "patnot"  ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "patand"  ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "pator"   ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false

// #truncate
// Only #truncate is in #truncate
  rule T:Type #isIn type[ #truncate ] => T ==K type[#truncate]

// #truncate is in Eval, Quote, SimpleType
  rule type[ #truncate ] #isIn type[ "eval"       ;; _:IntermediateType ;; _:IntermediateType ] => true
  rule type[ #truncate ] #isIn type[ "quote"      ;; _:IntermediateType ;; _:IntermediateType ] => true
  rule type[ #truncate ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => true
  rule type[ #truncate ] #isIn type[ "not"        ;; _:IntermediateType ;; _:IntermediateType ] => true

// WildCards
// WildProc matches every ProcOrPat
  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ]
       => S =/=String "quote" requires S =/=String "leaf"

// WildProc matches all leaves except #truncate and WildName
  rule type[ "leaf" ;; S:String ;; L:Leaf ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ] => S =/=String "truncate" andBool L =/=K "name"

// WildName matches any quoted NameOrPat
  rule type[ "quote" ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "name"] => true
  rule type[ "unforgeable" ;; _:String ;; _:Leaf ] #isIn type[ "leaf" ;; "wildcard" ;; "name" ] => true
  rule type[ "newuri"      ;; _:String ;; _:Leaf ] #isIn type[ "leaf" ;; "wildcard" ;; "name" ] => true

//--- Connectives ---
  rule T:Type #isIn type[ "patand" ;; A:IntermediateType ;; B:IntermediateType ] => T #isIn A andBool T #isIn B
  rule T:Type #isIn type[ "pator"  ;; A:IntermediateType ;; B:IntermediateType ] => T #isIn A orBool  T #isIn B
  rule T:Type #isIn type[ "patnot" ;; A:IntermediateType ;; _:IntermediateType ] => notBool T #isIn A

//------------------------------------
//--- Name, Process, Pattern Types ---
//------------------------------------

// Exclusivity of Name, Process, & Pattern


//--- Process Type ---
  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn Process
       => (S ==String "list"                                                    ) orBool  // list is in Process
          (S ==String "map"                                                     ) orBool  // map is in Process
          (S ==String "set"                                                     ) orBool  // set is in Process
          (S ==String "tuple"                                                   ) orBool  // tuple is in Process
          (S ==String "bundle"                                                  ) orBool  // bundle is in Process
          (S ==String "mult"                                                    ) orBool  // AExp is in Process
          (S ==String "plus"                                                    ) orBool  // AExp is in Process
          (S ==String "minus"                                                   ) orBool  // AExp is in Process
          (S ==String "leq"                                                     ) orBool  // BExp is in Process
          (S ==String "and"                                                     ) orBool  // BExp is in Process
          (S ==String "or"                                                      ) orBool  // BExp is in Process
          (S ==String "not"                                                     ) orBool  // BExp is in Process
          (S ==String "varref"                                                  ) orBool  // VarRef is in Process
          (S ==String "eval"     andBool A #isIn Name                           ) orBool  // Eval is in Process
          (S ==String "match"    andBool A #isIn Process                        ) orBool  // Match is in Process
          (S ==String "method"   andBool A #isIn Process                        ) orBool  // MethodProc is in Process
          (S ==String "par"      andBool A #isIn Process andBool B #isIn Process) orBool  // Par is in Process
	        (S ==String "send"     andBool A #isIn Name    andBool B #isIn Process) orBool  // Send is in Process
          (S ==String "else"     andBool A #isIn Process andBool B #isIn Process) orBool  // if...then Proc else Proc is in Process
          (S ==String "receive"  andBool                         B #isIn Process) orBool  // Receive is in Process
          (S ==String "contract" andBool                         B #isIn Process) orBool  // Contract is in Process
          (S ==String "new"      andBool                         B #isIn Process) orBool  // New is in Process
          (S ==String "ifthen"   andBool                         B #isIn Process)         // if...then Proc is in Process

// Leaves are Process except #truncate, wildcard, unforgeable
  rule type[ "leaf" ;; S:String ;; _:Leaf ] #isIn Process => S =/=String "unforgeable" andBool S =/=String "wildcard"

//--- Name Type ---
  rule type[ "quote" ;; A:IntermediateType ;; _:IntermediateType ] #isIn Name => A #isIn Process

  rule type[ "leaf"  ;; S:String ;; _:Leaf ] #isIn Name => S ==String "unforgeable"

//--- Pattern Type ---
  rule T:Type #isIn Pattern => notBool (T #isIn Process orBool T #isIn Name)

// SimpleTypes are Pattern
  rule type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true

// #isName, #isProc, #isPat
  rule #isName T:Type => T #isIn Name
  rule #isProc T:Type => T #isIn Process
  rule #isPat  T:Type => T #isIn Pattern

endmodule