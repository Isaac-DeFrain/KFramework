// Structural type system for Grounded RHO-CALCULUS
// Type is a structural binary tree

require "domains.k"

module PSTYPE-SYNTAX
  import DOMAINS

//***************************************************
//*** Grounded Rho-Calculus with Process Patterns ***
//***************************************************

//-------------
//--- NAMES ---
//-------------

// Names
  syntax             Name ::= "{" Name "}"                                [bracket]  // {_}: Name ---> Name
                            > Chan                                                   //         Chan < Name
                            | "WildName"                                             //     WildName < Name
// Channels
  syntax             Chan ::= Quote                                                  //        Quote < Chan
	                          | Unforgeable                                            //  Unforgeable < Chan
                            | Quote "(" Uri ")"                                      // _(_): Quote x Uri ---> Name                            

  syntax            Quote ::= "@" Proc                                               //  @_: Proc ---> Quote

// Unforgeable name
  syntax      Unforgeable ::= "unforgeable(" Int ")"                                 // unforgeable(_): Int ---> Unforgeable

// Several Names
  syntax            Names ::= Name "," Name                         [klabel(names)]  // _,_: Name  x Name ---> Names
                            | Name "," Names                        [klabel(names)]  // _,_: Names x Name ---> Names

//-----------------
//--- PROCESSES ---
//-----------------

// Process Variable
  syntax          ProcVar ::= Id                                                     // Id < ProcVar

// Processes
  syntax             Proc ::= "{" Proc "}"                                [bracket]  // {_}: Proc ----> Proc
                            > New                                                    //           New < Proc
                            > "Nil"                                                  //           Nil < Proc
                            | "WildProc"                                             //      WildProc < Proc
                            | Ground                                                 //        Ground < Proc
                            | SimpleType                                             //     SimplType < Proc
                            | Collection                                             //    Collection < Proc
                            | CollectionPat                                          // CollectionPat < Proc
                            | ProcVar                                                //       ProcVar < Proc
                            > VarRef                                                 //        VarRef < Proc
                            > Eval                                                   //          Eval < Proc
                            > MethodProc                                             //    MethodProc < Proc
                            > AExp                                                   //          AExp < Proc
                            > BExp                                                   //          BExp < Proc
                            > Send                                                   //          Send < Proc
                            > Match                                                  //         Match < Proc
                            | Contract                                               //      Contract < Proc
                            | Receive                                                //       Receive < Proc
                            | Bundle                                                 //        Bundle < Proc
                            > Conditional                                            //   Conditional < Proc
                            > Par                                                    //           Par < Proc
                            > Connectives                                            //   Connectives < Proc

// Logical Connectives
  syntax      Connectives ::= "~" Proc                                               //   ~_: Proc ----------> Connectives
	                          > Proc "/\\" Proc                                        // _/\_: Proc x Proc ---> Connectives
	                          > Proc "\\/" Proc                                        // _\/_: Proc x Proc ---> Connectives

// Par
  syntax              Par ::= Proc "|" Proc                                  [left]  // _|_: Proc x Proc ----------> Par

// Receive
  syntax          Receive ::= "for" "(" Bind  ")" "{" Proc "}"                       // for(_){_}: Bind  x Proc ---> Receive
                            | "for" "(" Binds ")" "{" Proc "}"                       // for(_){_}: Binds x Proc ---> Receive

  syntax             Bind ::= Lbind                                                  // Lbind < Bind, linear
                            | Pbind                                                  // Pbind < Bind, peek
                            | Rbind                                                  // Rbind < Bind, repeated

  syntax            Binds ::= Lbinds                                                 // Lbinds < Binds
                            | Pbinds                                                 // Pbinds < Binds
                            | Rbinds                                                 // Rbinds < Binds

  syntax            Lbind ::= Name  "<-" Chan                                        // _<-_: BindNamePat  x Name ---> Lbind 
                            | Names "<-" Chan                                        // _<-_: BindNamePats x Name ---> Lbind

  syntax           Lbinds ::= Lbind ";" Lbind                                        // 2 linear binds
                            | Lbind ";" Lbinds                                       // N linear binds, N > 2


  syntax            Pbind ::= Name  "<!" Chan                                        // _<!_: BindNamePat  x Name ---> Pbind 
                            | Names "<!" Chan                                        // _<!_: BindNamePats x Name ---> Pbind

  syntax           Pbinds ::= Pbind ";" Pbind                                        // 2 peek binds
                            | Pbind ";" Pbinds                                       // N peek binds, N > 2


  syntax            Rbind ::= Name  "<=" Chan                                        // _<=_: BindNamePat  x Name ---> Rbind 
                            | Names "<=" Chan                                        // _<=_: BindNamePats x Name ---> Rbind

  syntax           Rbinds ::= Rbind ";" Rbind                                        // 2 repeated binds
                            | Rbind ";" Rbinds                                       // N repeated binds, N > 2

// Send
  syntax             Send ::= Name "!"  RhoTuple                                     //  _!(_): Name x RhoTuple ------> Send
                            | Name "!!" RhoTuple                                     // _!!(_): Name x RhoTuple ------> Send

// Eval
  syntax             Eval ::= "*" Name                                               // *: Name ----------------------> Eval

// Ground terms
  syntax           Ground ::= Bool                                                   //   Bool < Ground
                            | Int                                                    //    Int < Ground
                            | String                                                 // String < Ground
                            | Uri                                                    //    Uri < Ground

  syntax              Uri ::= "uri(" String      ")"                                 // uri(_): String ---> Uri

// Collections
  syntax       Collection ::= RhoList                                                // process list
                            | RhoMap                                                 // process map
                            | RhoSet                                                 // process set
                            | RhoTuple                                               // process tuple

// Process lists
  syntax          RhoList ::= "[" Proc  "]"                                          // single process list
                            | "[" Procs "]"                                          // N process list, N > 1

// Process maps
  syntax           RhoMap ::= "{" RhoKVPairs "}"                                     // process map

  syntax       RhoKVPairs ::= Proc ":" Proc                                          // single key-value pair
                            | Proc ":" Proc "," RhoKVPairs                           // N key-value pairs, N > 1

// Process sets
  syntax           RhoSet ::= "Set" "(" Proc  ")"                                    // single process set
                            | "Set" "(" Procs ")"                                    // N process set, N > 1

// Process tuples
  syntax         RhoTuple ::= "(" Proc           ")"               [klabel(tuple1)]  // 1-tuple
                            | "(" Proc "," Proc  ")"               [klabel(tuple2)]  // N-tuple, N > 1
                            | "(" Proc "," Procs ")"               [klabel(tuplen)]  // N-tuple, N > 1

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}"                                 // write-only bundle
                            | "bundle-" "{" Proc "}"                                 // read-only bundle
                            | "bundle0" "{" Proc "}"                                 // no bundle
                            | "bundle"  "{" Proc "}"                                 // read/write bundle

// New
  syntax              New ::= "new" Name  "in" "{" Proc "}"                [binder]  // 1 name declaration
                            | "new" Names "in" "{" Proc "}"                [binder]  // N > 1 name declarations

// Match
  syntax            Match ::= "match" Proc "{" MatchCase  "}"                        // 
                            | "match" Proc "{" MatchCases "}"                        // 

  syntax        MatchCase ::= Proc "=>" Proc                        [klabel(match)]  // _=>_: Proc x Proc -------------> MatchCase

  syntax       MatchCases ::= MatchCase MatchCase                                    // _ _: MatchCase x MatchCase ----> MatchCase
                            | MatchCase MatchCases                                   // _ _: MatchCase x MatchCases ---> MatchCases

// Methods
  syntax       MethodProc ::= Proc "." Method "(" MethodArgs ")"                     // _._(_): Proc x Method x MethodArgs ---> Proc

  syntax           Method ::= "nth"                                                  // nth element in list, tuple?, set
	                          | "toByteArray"                                          // input? -> bytearray
	                          | "hexToBytes"                                           // hex -> bytes
	                          | "union"                                                // list?, map, set union
	                          | "diff"                                                 // map, set difference?
	                          | "add"                                                  // concat list?
	                          | "delete"                                               // delete element from 
	                          | "contains"                                             // contains predicate -> applied to what?
	                          | "get"                                                  // get?
	                          | "getOrElse"                                            // getOrElse?
	                          | "set"                                                  // set?
	                          | "keys"                                                 // return set of keys of a map
	                          | "size"                                                 // number of elements in list, map, set, tuple
	                          | "length"                                               // length of list, tuple - different from size?
	                          | "slice"                                                // slice of list, map, or set
	                          | "confine"                                              // still not in interpreter? semantics?

  syntax       MethodArgs ::= ""
                            | Proc
                            | Procs

// Expressions
  syntax             AExp ::= "(" AExp ")"                                [bracket]  //     (_): AExp ------> AExp
                            > Int                                                    //    Int < AExp
                            | Eval                                                   //   Eval < AExp , for interesting message passing, e.g. for( y <- x ){ *y + 5 }
                            | String                                                 // String < AExp (S1 + S2 => S1 +String S2)
                            > AExp "*" AExp                                [strict]  // _*_: AExp x AExp ---> AExp
                            > AExp "+" AExp                                [strict]  // _+_: AExp x AExp ---> AExp
                            | AExp "-" AExp                                [strict]  // _-_: AExp x AExp ---> AExp

  syntax             BExp ::= "(" BExp ")"                                [bracket]  //  (_): BExp ----------> BExp
                            > Bool                                                   //   Bool < BExp
                            | Eval                                                   //   Eval < BExp
                            | String                                                 // String < BExp
                            | AExp  ">=" AExp                              [strict]  // _>=_: AExp x AExp ---> BExp
                            > "not" BExp                                   [strict]  // not_: BExp ----------> BExp
                            > BExp "and" BExp                              [strict]  //  and: BExp ----------> BExp
                            > BExp  "or" BExp                              [strict]  //   or: BExp ----------> BExp

// Conditional
  syntax      Conditional ::= "if" "(" BExp ")" "then" Proc             [strict(1)]  // if ... then ...
                            | "if" "(" BExp ")" "then" Proc "else" Proc [strict(1)]  // if ... then ... else ...

// Contract
  syntax         Contract ::= "contract" Chan "(" Name  ")" "=" "{" Proc "}"         // syntactic sugar => for( Name  <= Chan ){ Proc }
                            | "contract" Chan "(" Names ")" "=" "{" Proc "}"         // syntactic sugar => for( Names <= Chan ){ Proc }

// Variable Refernces - Makes it so we _don't_ shadow the variable referenced
  syntax           VarRef ::= "=" ProcVar                                            //   =_: ProcVar -------> VarRef

// Several Processes
  syntax            Procs ::= Proc "," Proc                                          // _,_: Proc x Proc  ---> Procs
                            | Proc "," Procs                                         // _,_: Proc x Procs ---> Procs

// Collection Pattern
  syntax    CollectionPat ::= RhoListPat                                             // RhoListPat < CollectionPat
                            | RhoSetPat                                              //  RhoSetPat < CollectionPat

// List Pattern
  syntax       RhoListPat ::= "[" Proc "," "..." ProcVar "]"                      //    [_,..._]: Proc x ProcVar ---> RhoListPat

// Set Pattern
  syntax        RhoSetPat ::= "Set" "(" Proc "," "..." ProcVar ")"                // Set(_,..._): Proc x ProcVar ---> RhoSetPat


//******************************
//*** STRUCTURAL TYPE SYNTAX ***
//******************************
  syntax             Type ::= "#type(" Proc ")"                          [function]  // #type(_): Proc ------> Type
                            | "#type(" Name ")"                          [function]  // #type(_): Name ------> Type
                            | InitialType                                            //          InitialType < Type
                            | IntermediateType                                       //     IntermediateType < Type
                            | TerminalType                                           //         TerminalType < Type
                            | String                                                 //               String < Type


// Simple Types - types of ground terms
  syntax       SimpleType ::= "Bool"                                                 //        "Bool" < SimpleType
	                          | "ByteArray"                                            //   "ByteArray" < SimpleType
                            | "Int"                                                  //         "Int" < SimpleType
                            | "List"                                                 //        "List" < SimpleType
                            | "Map"                                                  //         "Map" < SimpleType
                            | "Set"                                                  //         "Set" < SimpleType
                            | "String"                                               //      "String" < SimpleType
                            | "Tuple"                                                //       "Tuple" < SimpleType
                            | "Unforgeable"                                          // "Unforgeable" < SimpleType
                            | "Uri"                                                  //         "Uri" < SimpleType

// Typical input for type rewrites
  syntax OrProcOrLeafType ::= "type[" Proc         "]"                               // type[_]: Proc ----------> OrProcOrLeafType
                            | "type[" Procs        "]"                               // type[_]: Procs ---------> OrProcOrLeafType
                            | "type[" Name         "]"                               // type[_]: Name ----------> OrProcOrLeafType
                            | "type[" Names        "]"                               // type[_]: Names ---------> OrProcOrLeafType
                            | "type[" Leaf         "]"                               // type[_]: Leaf ----------> OrProcOrLeafType
                            | "type[" RhoKVPairs   "]"                               // type[_]: RhoKVPairs ----> OrProcOrLeafType

//  Initial type
  syntax      InitialType ::= OrProcOrLeafType                                       //             OrProcOrLeafType < InitialType
                            | "type[" Bind             "]"                           // type[_]: Bind ---------------> InitialType
                            | "type[" Binds            "]"                           // type[_]: Binds --------------> InitialType

//  Intermediate type - type[_;;_;;_]: String x IntermediateType x IntermediateType ---> IntermediateType
  syntax IntermediateType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                            | TerminalType                                           // TerminalType < IntermediateType
                            | InitialType                                            //  InitialType < IntermediateType

//  Terminal type - type[_;;_;;_]: String x TerminalType x TerminalType ---> TerminalType
  syntax     TerminalType ::= "type[" String ";;" TerminalType     ";;" TerminalType     "]"
                            | LeafType                                               // LeafType < TerminalType

// corresponds to the leaves in the structural binary tree - type[_;;_;;_]: String x Leaf x Leaf ---> LeafType
  syntax         LeafType ::= "type[" String ";;" Leaf             ";;" Leaf             "]"
	                          | "type[" Truncate  "]"                                  // #truncate - tree unit

//--- toString function ---
  syntax           String ::= "toString(" Proc ")"                                   // toString(_): Proc ---> String
                            | "toString(" Name ")"                                   // toString(_): Name ---> String
                            | "toString(" Type ")"                                   // toString(_): Type ---> String

// Leaves
  syntax             Leaf ::= Ground                                                 //    Ground < Leaf
                            | ProcVar                                                //   ProcVar < Leaf

  syntax         Truncate ::= "#truncate"

endmodule


module PSTYPE
  import PSTYPE-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

  syntax KResult ::= TerminalType

// Arithmetic
  rule A:Int + B:Int => A +Int B  [anywhere]
  rule A:Int * B:Int => A *Int B  [anywhere]
  rule A:Int - B:Int => A -Int B  [anywhere]

// Boolean
  rule A:Int >=   B:Int  => A >=Int   B  [anywhere]
  rule A:Bool and B:Bool => A andBool B  [anywhere]
  rule A:Bool or  B:Bool => A orBool  B  [anywhere]
  rule not B:Bool        => notBool   B  [anywhere]

//---------------------
//--- Type function ---
//---------------------
  rule #type( P:Proc    ) => type[P]
  rule #type( N:Name    ) => type[N]

//*** Leaves ***
// Ground
  rule type[ B:Bool               ] => type[ "leaf"  ;; "bool"        ;; B       ]  // Bool =================> Leaf
  rule type[ I:Int                ] => type[ "leaf"  ;; "int"         ;; I       ]  // Int ==================> Leaf
  rule type[ S:String             ] => type[ "leaf"  ;; "string"      ;; S       ]  // String ===============> Leaf

// Process Variable
  rule type[ X:ProcVar            ] => type[ "leaf"  ;; "procvar"     ;; X       ]  // ProcVar ==============> Leaf

// Nil
  rule type[ Nil                  ] => type[ "leaf"  ;; "nil"         ;; "Nil"   ]  // Nil ==================> Leaf

// Wildcards
  rule type[ WildProc             ] => type[ "leaf"  ;; "wildcard"    ;; "proc"  ]  // WildProc =============> Leaf
  rule type[ WildName             ] => type[ "leaf"  ;; "wildcard"    ;; "name"  ]  // WildName =============> Leaf

// Unforgeable Integers
  rule type[ unforgeable( I:Int ) ] => type[ "leaf"  ;; "unforgeable" ;; I       ]  // Unforgeable ==========> Leaf

// Uri
  rule type[ uri( S:String )      ] => type[ "leaf"  ;; "uri"         ;; S       ]  // Uri ==================> Leaf

//*** Nodes ***
// EvalOrPat
  rule type[ * N:Name             ] => type[ "eval"     ;; type[N]    ;; type[#truncate] ]  // Eval

// SendOrPat
  rule type[ N:Name !  R:RhoTuple ] => type[ "send"     ;; type[N]    ;; type[R] ]  // Send
  rule type[ N:Name !! R:RhoTuple ] => type[ "psend"    ;; type[N]    ;; type[R] ]  // Send

// Receive/Bind(s)
  rule type[ B:Name  <- N:Chan    ] => type[ "lbind"    ;; type[B]    ;; type[N] ]  // Linear bind
  rule type[ B:Names <- N:Chan    ] => type[ "lbind"    ;; type[B]    ;; type[N] ]  // Linear bind
  rule type[ A:Lbind ; B:Lbind    ] => type[ "lbinds"   ;; type[A]    ;; type[B] ]  // 2 linear binds
  rule type[ A:Lbind ; B:Lbinds   ] => type[ "lbinds"   ;; type[A]    ;; type[B] ]  // N linear binds, N > 2

  rule type[ B:Name  <! N:Chan    ] => type[ "peek"     ;; type[B]    ;; type[N] ]  // Peek bind
  rule type[ B:Names <! N:Chan    ] => type[ "peek"     ;; type[B]    ;; type[N] ]  // Peek bind
  rule type[ A:Pbind ; B:Pbind    ] => type[ "peeks"    ;; type[A]    ;; type[B] ]  // 2 peek binds
  rule type[ A:Pbind ; B:Pbinds   ] => type[ "peeks"    ;; type[A]    ;; type[B] ]  // N peek binds, N > 2

  rule type[ B:Name  <= N:Chan    ] => type[ "pbind"    ;; type[B]    ;; type[N] ]  // Persistent bind
  rule type[ B:Names <= N:Chan    ] => type[ "pbind"    ;; type[B]    ;; type[N] ]  // Persistent bind
  rule type[ A:Rbind ; B:Rbind    ] => type[ "pbinds"   ;; type[A]    ;; type[B] ]  // 2 persistent binds
  rule type[ A:Rbind ; B:Rbinds   ] => type[ "pbinds"   ;; type[A]    ;; type[B] ]  // N persistent binds, N > 2

  rule type[ for( R:Bind  ){ P:Proc } ] => type[ "receive"  ;; type[R]    ;; type[P] ]  // Receive
  rule type[ for( R:Binds ){ P:Proc } ] => type[ "receives" ;; type[R]    ;; type[P] ]  // Receives

  rule type[ contract X:Chan ( Y:Name  ) = { P:Proc } ] => type[ "contract" ;; type[ Y <= X ] ;; type[P] ]
  rule type[ contract X:Chan ( Y:Names ) = { P:Proc } ] => type[ "contract" ;; type[ Y <= X ] ;; type[P] ]

// Par
  rule type[ P:Proc | Q:Proc                    ] => type[ "par"    ;; type[P] ;; type[Q]          ]  // Par

// Variable Reference
  rule type[ = P:ProcVar                        ] => type[ "varref" ;; type[P] ;; type[#truncate]  ]  // Variable reference

// New
  rule type[ new N:Name  in { P:Proc }          ] => type[ "new"    ;; type[N] ;; type[P]          ]  // new
  rule type[ new N:Names in { P:Proc }          ] => type[ "new"    ;; type[N] ;; type[P]          ]  // new

// Logical Connectives
  rule type[ P:Proc /\ Q:Proc                   ] => type[ "and"    ;; type[P] ;; type[Q]          ]  // logical and
  rule type[ P:Proc \/ Q:Proc                   ] => type[ "or"     ;; type[P] ;; type[Q]          ]  // logical or
  rule type[ ~ P:Proc                           ] => type[ "not"    ;; type[P] ;; type[#truncate]  ]  // logical negation

// Conditionals
  rule type[ if (true)  then P:Proc             ] => type[ "true"   ;; type[P] ;; type[#truncate]  ]  // if true  then P
  rule type[ if (false) then P:Proc             ] => type[ "false"  ;; type[P] ;; type[#truncate]  ]  // if false then P

  rule type[ if (true)  then P:Proc else Q:Proc ] => type[ "true"   ;; type[P] ;; type[Q]          ]  // if true  then P else Q
  rule type[ if (false) then P:Proc else Q:Proc ] => type[ "false"  ;; type[P] ;; type[Q]          ]  // if false then P else Q

// SimpleType
  rule type[ ST:SimpleType        ] => type[ "simpletype" ;; type[toString(ST)] ;; type[#truncate] ]  // Bool, Int, String types

// Bundles
  rule type[ bundle+{ P:Proc }    ] => type[ "bundle+"    ;; type[P] ;; type[#truncate] ]  // bundle+
  rule type[ bundle-{ P:Proc }    ] => type[ "bundle-"    ;; type[P] ;; type[#truncate] ]  // bundle-
  rule type[ bundle0{ P:Proc }    ] => type[ "bundle0"    ;; type[P] ;; type[#truncate] ]  // bundle0
  rule type[ bundle { P:Proc }    ] => type[ "bundle"     ;; type[P] ;; type[#truncate] ]  // bundle

// Quote
  rule type[ @ P:Proc             ] => type[ "quote"      ;; type[P] ;; type[#truncate] ]  // quoted process pattern
  rule type[ Q:Quote ( U:Uri )    ] => type[ "namedec"    ;; type[Q] ;; type[U]         ]  // 

// Collections
// RhoList
  rule type[ [ P:Proc           ] ] => type[ "list" ;; type[P] ;; type[#truncate] ]           // singleton list
  rule type[ [ P:Proc , Q:Proc  ] ] => type[ "list" ;; type[P] ;; type[Q]         ]           // 2 process list
  rule type[ [ P:Proc , Q:Procs ] ] => type[ "list" ;; type[P] ;; type[Q]         ]           // N process list, N > 2

// RhoMap
  rule type[ P:Proc : Q:Proc                    ] => type[ "kvpair"  ;; type[P]   ;; type[Q]         ]  // single key-value pair
  rule type[ P:Proc : Q:Proc , R:RhoKVPairs     ] => type[ "kvpairs" ;; type[P:Q] ;; type[R]         ]  // N key-value pairs, N > 2

  rule type[ { P:Proc : Q:Proc                } ] => type[ "map"     ;; type[P:Q] ;; type[#truncate] ]  // 2 key-value pairs map
  rule type[ { P:Proc : Q:Proc , S:RhoKVPairs } ] => type[ "map"     ;; type[P:Q] ;; type[S]         ]  // 2 key-value pairs map

// RhoSet
  rule type[ Set( P:Proc           )    ] => type[ "set"     ;; type[P] ;; type[#truncate] ]  // singleton set
  rule type[ Set( P:Proc , Q:Proc  )    ] => type[ "set"     ;; type[P] ;; type[Q]         ]  // 2 element set
  rule type[ Set( P:Proc , Q:Procs )    ] => type[ "set"     ;; type[P] ;; type[Q]         ]  // N element set, N > 2

// RhoTuple
  rule type[ tuple1( P:Proc           ) ] => type[ "tuple"   ;; type[P] ;; type[#truncate] ]  // single process set
  rule type[ tuple2( P:Proc , Q:Proc  ) ] => type[ "tuple"   ;; type[P] ;; type[Q]         ]  // 2 process set
  rule type[ tuplen( P:Proc , Q:Procs ) ] => type[ "tuple"   ;; type[P] ;; type[Q]         ]  // N process set, N > 2

// Several Names
  rule type[ M:Name , N:Name  ] => type[ "names" ;; type[M] ;; type[N]  ]  // 2 names
  rule type[ M:Name , N:Names ] => type[ "names" ;; type[M] ;; type[N]  ]  // N names, N > 2

// Several Procs
  rule type[ P:Proc , Q:Proc  ] => type[ "procs" ;; type[P] ;; type[Q]  ]  // 2 processes
  rule type[ P:Proc , Q:Procs ] => type[ "procs" ;; type[P] ;; type[Q]  ]  // N processes, N > 2

// Collection Patterns
// RhoListPat
  rule type[ [ P:Proc , ... X:ProcVar ]    ] => type[ "listpat" ;; type[P] ;; type[X] ]  //

// RhoSetPat
  rule type[ Set( P:Proc , ... X:ProcVar ) ] => type[ "setpat"  ;; type[P] ;; type[X] ]  // 

// Resolving brackets
  rule type[ { N:Name } ] => type[N]  // bracketed Name type resolution
  rule type[ { P:Proc } ] => type[P]  // bracketed Proc type resolution

endmodule