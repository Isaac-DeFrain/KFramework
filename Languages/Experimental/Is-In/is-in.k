// The #isIn predicate - checks for type inclusion
// Normalizer needed for par structural inclusion

require "domains.k"
require "../StructuralTypes/stype.k"

module IS-IN-SYNTAX
  import STYPE-SYNTAX

endmodule

module IS-IN
  import IS-IN-SYNTAX

  syntax KResult ::= Bool

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Bool </k>
    </T>

//--------------------------------
//--- Type Inclusion Semantics ---
//--------------------------------

// Reflexivity of type inclusion
  rule T:Type #isIn T => true

// Transitivity
// This line kompiles, but I'm not sure how to use it...
//  rule A:Type #isIn C:Type => true when A #isIn ?B:Type andBool ?B #isIn C

// Matching top-level constructors -> subtype inclusion (excluding Par & Leaf)
  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[ S ;; C:IntermediateType ;; D:IntermediateType ] 
       => A #isIn C andBool B #isIn D requires S =/=String "par" andBool S =/=String "leaf"

// Par is unordered
// Par matches with another Par
// Only one par
  rule type[ "par" ;; type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] ;; type[ T:String ;; C:IntermediateType ;; D:IntermediateType ] ]
       #isIn
       type[ "par" ;; E:IntermediateType ;; F:IntermediateType ]
       => (type[ S ;; A ;; B ] #isIn E  andBool  type[ T ;; C ;; D ]   #isIn F) orBool
          (type[ S ;; A ;; B ] #isIn F  andBool  type[ T ;; C ;; D ]   #isIn E) orBool
          (type[ "par" ;; type[ S ;; A ;; B ] ;; type[ T ;; C ;; D ] ] #isIn E  andBool F ==K type[ "leaf" ;; "nil" ;; "Nil"]) orBool
          (type[ "par" ;; type[ S ;; A ;; B ] ;; type[ T ;; C ;; D ] ] #isIn F  andBool E ==K type[ "leaf" ;; "nil" ;; "Nil"])
           requires S =/=String "par" andBool T =/=String "par"

  rule type[ "par" ;; type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] ;; type[ T:String ;; C:Leaf ;; D:Leaf ] ]
       #isIn
       type[ "par" ;; E:IntermediateType ;; F:IntermediateType ]
       => (type[ S ;; A ;; B ] #isIn E  andBool  type[ T ;; C ;; D ]   #isIn F) orBool
          (type[ S ;; A ;; B ] #isIn F  andBool  type[ T ;; C ;; D ]   #isIn E) orBool
          (type[ "par" ;; type[ S ;; A ;; B ] ;; type[ T ;; C ;; D ] ] #isIn E  andBool F ==K type[ "leaf" ;; "nil" ;; "Nil"]) orBool
          (type[ "par" ;; type[ S ;; A ;; B ] ;; type[ T ;; C ;; D ] ] #isIn F  andBool E ==K type[ "leaf" ;; "nil" ;; "Nil"]) 
           requires S =/=String "par"

  rule type[ "par" ;; type[ S:String ;; A:Leaf ;; B:Leaf ] ;; type[ T:String ;; C:IntermediateType ;; D:IntermediateType ] ]
       #isIn
       type[ "par" ;; E:IntermediateType ;; F:IntermediateType ]
       => (type[ S ;; A ;; B ] #isIn E  andBool  type[ T ;; C ;; D ]   #isIn F) orBool
          (type[ S ;; A ;; B ] #isIn F  andBool  type[ T ;; C ;; D ]   #isIn E) orBool
          (type[ "par" ;; type[ S ;; A ;; B ] ;; type[ T ;; C ;; D ] ] #isIn E  andBool F ==K type[ "leaf" ;; "nil" ;; "Nil"]) orBool
          (type[ "par" ;; type[ S ;; A ;; B ] ;; type[ T ;; C ;; D ] ] #isIn F  andBool E ==K type[ "leaf" ;; "nil" ;; "Nil"])
           requires T =/=String "par"

  rule type[ "par" ;; type[ S:String ;; A:Leaf ;; B:Leaf ] ;; type[ T:String ;; C:Leaf ;; D:Leaf ] ]
       #isIn
       type[ "par" ;; E:IntermediateType ;; F:IntermediateType ]
       => (type[ S ;; A ;; B ] #isIn E  andBool  type[ T ;; C ;; D ]   #isIn F) orBool
          (type[ S ;; A ;; B ] #isIn F  andBool  type[ T ;; C ;; D ]   #isIn E) orBool
          (type[ "par" ;; type[ S ;; A ;; B ] ;; type[ T ;; C ;; D ] ] #isIn E  andBool F ==K type[ "leaf" ;; "nil" ;; "Nil"]) orBool
          (type[ "par" ;; type[ S ;; A ;; B ] ;; type[ T ;; C ;; D ] ] #isIn F  andBool E ==K type[ "leaf" ;; "nil" ;; "Nil"])

// Par Recursion - several pars
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
  rule type[ "par" ;; A:IntermediateType ;; type[ "leaf" ;; "nil" ;; "Nil" ] ] #isIn B:Type => A #isIn B
  rule type[ "par" ;; type[ "leaf" ;; "nil" ;; "Nil" ] ;; A:IntermediateType ] #isIn B:Type => A #isIn B
  rule A #isIn type[ "par" ;; B:IntermediateType ;; type[ "leaf" ;; "nil" ;; "Nil" ] ] => A #isIn B
  rule A #isIn type[ "par" ;; type[ "leaf" ;; "nil" ;; "Nil" ] ;; B:IntermediateType ] => A #isIn B

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
  rule type[ S:String ;; _:IntermediateType ;; _:IntermediateType ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Map )         ] ;; type[ #truncate ] ]
       => S ==String "map"

// Each set is in Set
  rule type[ S:String ;; _:IntermediateType ;; _:IntermediateType ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( Set )         ] ;; type[ #truncate ] ]
       => S ==String "set"

// Each string is in String
  rule type[ "leaf" ;; S:String ;; _:Leaf ]
       #isIn
       type[ "simpletype" ;; type[ "leaf" ;; "string" ;; toString( String )      ] ;; type[ #truncate ] ]
       => S ==String "string"

// Each tuple is in Tuple
  rule type[ S:String ;; _:IntermediateType ;; _:IntermediateType ]
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

// Only LeafType in SimpleType
  rule type[ "par"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "quote"   ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "send"    ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "receive" ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "eval"    ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "notpat"  ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "andpat"  ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "orpat"   ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false
  rule type[ "new"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] => false

// WildCards
// WildProc matches every ProcOrPat
  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ]
       => S =/=String "quote" requires S =/=String "leaf"

// WildProc matches all leaves except #truncate and WildName
  rule type[ "leaf" ;; S:String   ;; L:Leaf ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ]
       => S =/=String "unforgeable" requires S =/=String "wildcard"

  rule type[ "leaf" ;; "wildcard" ;; "name" ] #isIn type[ "leaf" ;; "wildcard" ;; "proc" ] => false
  rule type[ "leaf" ;; "wildcard" ;; "proc" ] #isIn type[ "leaf" ;; "wildcard" ;; "name" ] => false

// WildName matches any quoted NameOrPat
  rule type[ "quote"  ;; _:IntermediateType ;; _:IntermediateType ] #isIn type[ "leaf" ;; "wildcard" ;; "name" ] => true
  rule type[ "leaf"   ;; "unforgeable"      ;; _:Leaf             ] #isIn type[ "leaf" ;; "wildcard" ;; "name" ] => true
  rule type[ "newuri" ;; _:String           ;; _:Leaf             ] #isIn type[ "leaf" ;; "wildcard" ;; "name" ] => true

//--- Logical Connectives ---
  rule T:Type #isIn type[ "andpat" ;; A:IntermediateType ;; B:IntermediateType ] => T #isIn A andBool T #isIn B
  rule T:Type #isIn type[ "orpat"  ;; A:IntermediateType ;; B:IntermediateType ] => T #isIn A orBool  T #isIn B
  rule T:Type #isIn type[ "notpat" ;; A:IntermediateType ;; _:IntermediateType ] => notBool T #isIn A

// #truncate
// Only #truncate is in #truncate
  rule T:Type #isIn type[ #truncate ] => T ==K type[#truncate]

//------------------------------------
//--- Name, Process, Pattern Types ---
//------------------------------------
//--- Process Type ---
  rule type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] #isIn Process
       => (S ==String "list"                                                     ) orBool  // list is in Process
          (S ==String "map"                                                      ) orBool  // map is in Process
          (S ==String "set"                                                      ) orBool  // set is in Process
          (S ==String "tuple"                                                    ) orBool  // tuple is in Process
          (S ==String "bundle"                                                   ) orBool  // bundle is in Process
          (S ==String "bundle0"                                                  ) orBool  // bundle is in Process
          (S ==String "bundle+"                                                  ) orBool  // bundle is in Process
          (S ==String "bundle-"                                                  ) orBool  // bundle is in Process
          (S ==String "mult"                                                     ) orBool  // AExp * AExp is in Process
          (S ==String "plus"                                                     ) orBool  // AExp + AExp is in Process
          (S ==String "minus"                                                    ) orBool  // AExp - AExp is in Process
          (S ==String "leq"                                                      ) orBool  // AExp <= AExp is in Process
          (S ==String "and"                                                      ) orBool  // BExp and BExp is in Process
          (S ==String "or"                                                       ) orBool  // BExp or  BExp is in Process
          (S ==String "not"                                                      ) orBool  // not BExp is in Process
          (S ==String "varref"                                                   ) orBool  // VarRef is in Process
          (S ==String "eval"     andBool A #isIn Name                            ) orBool  // Eval is in Process
          (S ==String "match"    andBool A #isIn Process                         ) orBool  // Match is in Process
          (S ==String "method"   andBool A #isIn Process                         ) orBool  // MethodProc is in Process
          (S ==String "par"      andBool A #isIn Process andBool B #isIn Process ) orBool  // Par is in Process
          (S ==String "send"     andBool A #isIn Name    andBool B #isIn Process ) orBool  // Send is in Process
          (S ==String "else"     andBool A #isIn Process andBool B #isIn Process ) orBool  // if...then Proc else Proc is in Process
          (S ==String "receive"  andBool                         B #isIn Process ) orBool  // Receive is in Process
          (S ==String "contract" andBool                         B #isIn Process ) orBool  // Contract is in Process
          (S ==String "new"      andBool                         B #isIn Process ) orBool  // New is in Process
          (S ==String "ifthen"   andBool                         B #isIn Process )         // if...then Proc is in Process

// Leaves are in Process except wildcards & unforgeable
  rule type[ "leaf" ;; S:String ;; _:Leaf ] #isIn Process => S =/=String "unforgeable" andBool S =/=String "wildcard"

//--- Name Type ---
  rule type[ "quote" ;; A:IntermediateType ;; _:IntermediateType ] #isIn Name => A #isIn Process

  rule type[ "leaf"  ;; S:String ;; _:Leaf ] #isIn Name => S ==String "unforgeable"

//--- Pattern Type ---
// Only wildcard leaves are in Pattern
  rule type[ "leaf" ;; S:String ;; _:Leaf ] #isIn Pattern => S ==String "wildcard"

  rule type[ "mappat"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // map pattern is in Pattern
  rule type[ "listpat"    ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // list pattern is in Pattern
  rule type[ "andpat"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // logical and is in Pattern
  rule type[ "orpat"      ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // logical or is in Pattern
  rule type[ "notpat"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // logical not is in Pattern
  rule type[ "mappat"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // map pattern is in Pattern
  rule type[ "setpat"     ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // set pattern is in Pattern
  rule type[ "tuplepat"   ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // tuple pattern is in Pattern
  rule type[ "simpletype" ;; _:IntermediateType ;; _:IntermediateType ] #isIn Pattern => true  // simpltypes are in Pattern
  rule type[ "tuple"      ;; A:IntermediateType ;; _:IntermediateType ] #isIn Pattern => A #isIn Pattern  // pattern tuple is in Pattern
  rule type[ "eval"       ;; A:IntermediateType ;; _:IntermediateType ] #isIn Pattern => A #isIn Pattern  // EvalPat is in Pattern
  rule type[ "else"       ;; A:IntermediateType ;; B:IntermediateType ] #isIn Pattern => A #isIn Pattern orBool B #isIn Pattern  // if...then Pattern else Pattern is in Pattern
  rule type[ "par"        ;; A:IntermediateType ;; B:IntermediateType ] #isIn Pattern => A #isIn Pattern orBool B #isIn Pattern  // ParPat is in Pattern
  rule type[ "send"       ;; A:IntermediateType ;; B:IntermediateType ] #isIn Pattern => A #isIn Pattern orBool B #isIn Pattern  // SendPat is in Pattern
  rule type[ "receive"    ;; _:IntermediateType ;; B:IntermediateType ] #isIn Pattern => B #isIn Pattern  // ReceivePat is in Pattern
  rule type[ "ifthen"     ;; _:IntermediateType ;; B:IntermediateType ] #isIn Pattern => B #isIn Pattern  // if...then Pattern is in Pattern

// #isName, #isProc, #isPat syntactic sugar
  rule #isName T:Type => T #isIn Name
  rule #isProc T:Type => T #isIn Process
  rule #isPat  T:Type => T #isIn Pattern

// Exclusivity of Name, Process, & Pattern
//rule T:Type #isIn Pattern => notBool (T #isIn Process orBool T #isIn Name)

endmodule