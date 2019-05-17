// Structural type system for Grounded RHO-CALCULUS
// A structural type is a structural binary tree

require "domains.k"
require "../grho.k"
// require "../Is-In/is-in.k"

module STYPE-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

//******************************
//*** STRUCTURAL TYPE SYNTAX ***
//******************************
  syntax             Type ::= "#type(" Proc ")" [function]
                            | "#type(" Name ")" [function]
                            | InitialType
                            | IntermediateType
                            | TerminalType
                            | Bool   // for type inclusion
/*
// Simple Types - types of ground terms & collections
  syntax       SimpleType ::= "Bool"
                            | "ByteArray"
                            | "Int"
                            | "List"
                            | "Map"
                            | "Set"
                            | "String"
                            | "Tuple"
                            | "Unforgeable"
                            | "Uri"
*/
// Typical input for type rewrites
  syntax       OrLeafType ::= "type[" Proc  "]"
                            | "type[" Procs "]"
                            | "type[" Name  "]"
                            | "type[" Names "]"
                            | "type[" Leaf  "]"

//  Initial type
  syntax      InitialType ::= OrLeafType
                            | "type[" Bind          "]"
                            | "type[" Binds         "]"
                            | "type[" IfThen        "]"
                            | "type[" Else          "]"
                            | "type[" MatchCase     "]"
                            | "type[" MatchCases    "]"
                            | "type[" MethodAndArgs "]"
                            | "type[" RhoKVPair     "]"
                            | "type[" RhoKVPairs    "]"
                            | "type[" Tag           "]"

//  Intermediate type
  syntax IntermediateType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                            | TerminalType
                            | InitialType

//  Terminal type
  syntax     TerminalType ::= "type[" String ";;" TerminalType ";;" TerminalType "]"
                            | LeafType

// corresponds to the leaves in the structural binary tree
  syntax         LeafType ::= "type[" String ";;" Leaf ";;" Leaf "]"
                            | Unit

//--- toString function ---
  syntax           String ::= "toString(" Proc ")"
                            | "toString(" Name ")"
                            | "toString(" Type ")"

// Leaves
  syntax             Leaf ::= Ground
                            | NameVar
                            | ProcVar
                            | Method
                            | EmptyName
                            | EmptyProc

  syntax         Unit ::= "unit"

  syntax          Tag ::= String "&" Name
                        | String "&" Names
                        | String "&" Proc
                        | String "&" Procs

//----------------------
//--- Type Inclusion ---
//----------------------
// The type inclusion predicate
/*  syntax    Bool ::= Type "#isIn"   Type  [function]
                   | Type "#isin"   Type  [strict(1,2)]
                   |      "#isName" Type  [function]
                   |      "#isProc" Type  [function]
                   |      "#isPat"  Type  [function]

  syntax    Bool ::= Proc "#isIn" Proc
                   | Name "#isIn" Name
                   | Type "#isIn" Proc
                   | Type "#isIn" Name

// Name, Process, Pattern types for #isName, #isProc, #isPat predicates
  syntax    Type ::= "Name"
                   | "Process"
                   | "Pattern"
*/
endmodule


module STYPE
  import STYPE-SYNTAX
//  import IS-IN

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

  syntax KResult ::= TerminalType

//---------------------
//--- Type function ---
//---------------------
  rule #type( P:Proc ) => type[P]
  rule #type( N:Name ) => type[N]

// Tags
  rule type[ S:String & N:Name  ] => type[ S ;; type[N] ;; unit ]
  rule type[ S:String & N:Names ] => type[ S ;; type[N] ;; unit ]
  rule type[ S:String & P:Proc  ] => type[ S ;; type[P] ;; unit ]
  rule type[ S:String & P:Procs ] => type[ S ;; type[P] ;; unit ]

//*** Leaves ***
// Ground
  rule type[ B:Bool   ] => type[ "leaf" ;; "bool"   ;; B     ]
  rule type[ I:Int    ] => type[ "leaf" ;; "int"    ;; I     ]
  rule type[ S:String ] => type[ "leaf" ;; "string" ;; S     ]
  rule type[ Nil      ] => type[ "leaf" ;; "nil"    ;; "Nil" ]

// Method
  rule type[ M:Method ] => type[ "leaf" ;; "method" ;; M ]

// Process Variable
  rule type[ V:NameVar ] => type[ "leaf" ;; "namevar" ;; V ]
  rule type[ V:ProcVar ] => type[ "leaf" ;; "procvar" ;; V ]

// Unforgeable Integers
  rule type[ unforgeable( I:Int ) ] => type[ "leaf" ;; "unforgeable" ;; I ]

// Uri
  rule type[ uri( S:String ) ] => type[ "leaf" ;; "uri" ;; S ]

// EmptyName
  rule type[ EmptyN ] => type[ "leaf" ;; "name" ;; "empty" ]

// EmptyProc
  rule type[ EmptyP ] => type[ "leaf" ;; "proc" ;; "empty" ]

// Wildcards
//  rule type[ #P ] => type[ "leaf" ;; "wildcard" ;; "proc" ]
//  rule type[ #N ] => type[ "leaf" ;; "wildcard" ;; "name" ]

//*** Nodes ***
// SimpleType
//  rule type[ ST:SimpleType ] => type[ "simpletype" ;; type[toString(ST)] ;; unit ]

// Quote
  rule type[ @ P:Proc ] => type[ "quote" ;; type[P] ;; unit ]
//  rule type[ @ P:ProcPat ] => type[ "quote" ;; type[P] ;; unit ]

// Eval
  rule type[ * N:Name ] => type[ "eval" ;; type[N] ;; unit ]
//  rule type[ * N:NamePat ] => type[ "eval" ;; type[N] ;; unit ]

// Sends
  rule type[ N:Name !  (  ) ] => type[ "send" ;; type["chan" & N] ;; type["msg" & EmptyP] ]
  rule type[ N:Name !  ( M:Proc  ) ] => type[ "send" ;; type["chan" & N] ;; type["msg" & M] ]
  rule type[ N:Name !  ( M:Procs ) ] => type[ "send" ;; type["chan" & N] ;; type["msg" & M] ]

  rule type[ N:Name !! (  ) ] => type[ "psend" ;; type["chan" & N] ;; type["msg" & EmptyP] ]
  rule type[ N:Name !! ( M:Proc  ) ] => type[ "psend" ;; type["chan" & N] ;; type["msg" & M] ]
  rule type[ N:Name !! ( M:Procs ) ] => type[ "psend" ;; type["chan" & N] ;; type["msg" & M] ]

//  rule type[ N:Name    !  R:PatTuple ] => type[ "send"  ;; type[N] ;; type[R] ]
//  rule type[ N:NamePat !  R:RhoTuple ] => type[ "send"  ;; type[N] ;; type[R] ]
//  rule type[ N:NamePat !  R:PatTuple ] => type[ "send"  ;; type[N] ;; type[R] ]
//  rule type[ N:Name    !! R:PatTuple ] => type[ "psend" ;; type[N] ;; type[R] ]
//  rule type[ N:NamePat !! R:RhoTuple ] => type[ "psend" ;; type[N] ;; type[R] ]
//  rule type[ N:NamePat !! R:PatTuple ] => type[ "psend" ;; type[N] ;; type[R] ]

// Receives/Binds -- TODO: add guarded binds
  rule type[         <- N:Name  ] => type[ "lbind"  ;; type["bvar" & EmptyN] ;; type["chan" & N] ]
  rule type[ B:Name  <- N:Name  ] => type[ "lbind"  ;; type["bvar" & B] ;; type["chan" & N] ]
  rule type[ B:Names <- N:Name  ] => type[ "lbind"  ;; type["bvar" & B] ;; type["chan" & N] ]
  rule type[ A:Lbind ; B:Lbind  ] => type[ "lbinds" ;; type[A] ;; type[B] ]
  rule type[ A:Lbind ; B:Lbinds ] => type[ "lbinds" ;; type[A] ;; type[B] ]

  rule type[         <! N:Name  ] => type[ "peek"  ;; type["bvar" & EmptyN] ;; type["chan" & N] ]
  rule type[ B:Name  <! N:Name  ] => type[ "peek"  ;; type["bvar" & B] ;; type["chan" & N] ]
  rule type[ B:Names <! N:Name  ] => type[ "peek"  ;; type["bvar" & B] ;; type["chan" & N] ]
  rule type[ A:Pbind ; B:Pbind  ] => type[ "peeks" ;; type[A] ;; type[B] ]
  rule type[ A:Pbind ; B:Pbinds ] => type[ "peeks" ;; type[A] ;; type[B] ]

  rule type[         <= N:Name  ] => type[ "pbind"  ;; type["bvar" & EmptyN] ;; type["chan" & N] ]
  rule type[ B:Name  <= N:Name  ] => type[ "pbind"  ;; type["bvar" & B] ;; type["chan" & N] ]
  rule type[ B:Names <= N:Name  ] => type[ "pbind"  ;; type["bvar" & B] ;; type["chan" & N] ]
  rule type[ A:Rbind ; B:Rbind  ] => type[ "pbinds" ;; type[A] ;; type[B] ]
  rule type[ A:Rbind ; B:Rbinds ] => type[ "pbinds" ;; type[A] ;; type[B] ]

  rule type[ for( B:Bind  ){ P:Proc } ] => type[ "singleRec" ;; type[B] ;; type["cont" & P] ]
  rule type[ for( B:Binds ){ P:Proc } ] => type[ "multiRec"  ;; type[B] ;; type["cont" & P] ]

//  rule type[ for( B:Bind  ){ P:ProcPat } ] => type[ "receive"  ;; type[B] ;; type[P] ]
//  rule type[ for( B:Binds ){ P:ProcPat } ] => type[ "receives" ;; type[B] ;; type[P] ]

// Contracts
  rule type[ contract X:Name (         ) = { P:Proc } ] => type[ "contract" ;; type[   <= X ] ;; type["body" & P] ]
  rule type[ contract X:Name ( Y:Name  ) = { P:Proc } ] => type[ "contract" ;; type[ Y <= X ] ;; type["body" & P] ]
  rule type[ contract X:Name ( Y:Names ) = { P:Proc } ] => type[ "contract" ;; type[ Y <= X ] ;; type["body" & P] ]

//  rule type[ contract X:Name (         ) = { P:ProcPat } ] => type[ "contract" ;; type[   <= X ] ;; type[P] ]
//  rule type[ contract X:Name ( Y:Name  ) = { P:ProcPat } ] => type[ "contract" ;; type[ Y <= X ] ;; type[P] ]
//  rule type[ contract X:Name ( Y:Names ) = { P:ProcPat } ] => type[ "contract" ;; type[ Y <= X ] ;; type[P] ]

// Invocation
  rule type[ invoke N:Name (  ) ] => type[ "invocation" ;; type["name" & N] ;; type[EmptyP] ]
  rule type[ invoke N:Name ( P:Proc  ) ] => type[ "invocation" ;; type["name" & N] ;; type["param" & P] ]
  rule type[ invoke N:Name ( P:Procs ) ] => type[ "invocation" ;; type["name" & N] ;; type["params" & P] ]

// New
  rule type[ new N:Name  in { P:Proc } ] => type[ "new" ;; type["namedec" & N] ;; type[P] ]
  rule type[ new N:Names in { P:Proc } ] => type[ "new" ;; type["namedec" & N] ;; type[P] ]

  rule type[ N:NameVar ( U:Uri ) ] => type[ "newuri" ;; type["name" & N] ;; type[U] ]

//  rule type[ new N:Name  in { P:ProcPat } ] => type[ "new" ;; type[N] ;; type[P] ]
//  rule type[ new N:Names in { P:ProcPat } ] => type[ "new" ;; type[N] ;; type[P] ]

// Par
  rule type[ P:Proc | Q:Proc ] => type[ "par" ;; type[P] ;; type[Q] ]

//  rule type[ P:Proc    | Q:ProcPat ] => type[ "par" ;; type[P] ;; type[Q] ]
//  rule type[ P:ProcPat | Q:Proc    ] => type[ "par" ;; type[P] ;; type[Q] ]
//  rule type[ P:ProcPat | Q:ProcPat ] => type[ "par" ;; type[P] ;; type[Q] ]

// Match
  rule type[ match P:Proc { M:MatchCase  } ] => type[ "match" ;; type[P] ;; type[M] ]
  rule type[ match P:Proc { M:MatchCases } ] => type[ "match" ;; type[P] ;; type[M] ]

  rule type[ P:Proc :=> Q:Proc        ] => type[ "case"  ;; type[P] ;; type[Q] ]
  rule type[ M:MatchCase N:MatchCase  ] => type[ "cases" ;; type[M] ;; type[N] ]
  rule type[ M:MatchCase N:MatchCases ] => type[ "cases" ;; type[M] ;; type[N] ]

// VarRef
  rule type[ =  V:ProcVar ] => type[ "varref" ;; type[V] ;; unit ]
  rule type[ =* V:NameVar ] => type[ "varref" ;; type[V] ;; unit ]

/*
// Logical Patterns
  rule type[ P:Proc    /\ Q:Proc    ] => type[ "andpat" ;; type[P] ;; type[Q] ]
  rule type[ P:Proc    /\ Q:ProcPat ] => type[ "andpat" ;; type[P] ;; type[Q] ]
  rule type[ P:ProcPat /\ Q:Proc    ] => type[ "andpat" ;; type[P] ;; type[Q] ]
  rule type[ P:ProcPat /\ Q:ProcPat ] => type[ "andpat" ;; type[P] ;; type[Q] ]

  rule type[ P:Proc    \/ Q:Proc    ] => type[ "orpat"  ;; type[P] ;; type[Q] ]
  rule type[ P:Proc    \/ Q:ProcPat ] => type[ "orpat"  ;; type[P] ;; type[Q] ]
  rule type[ P:ProcPat \/ Q:Proc    ] => type[ "orpat"  ;; type[P] ;; type[Q] ]
  rule type[ P:ProcPat \/ Q:ProcPat ] => type[ "orpat"  ;; type[P] ;; type[Q] ]

  rule type[ ~ P:Proc    ] => type[ "notpat" ;; type[P] ;; unit ]
  rule type[ ~ P:ProcPat ] => type[ "notpat" ;; type[P] ;; unit ]
*/
// Conditionals
  rule type[ if (B:BExp) P:Proc ] => type[ "ifthen" ;; type[B] ;; type[P] ]
  rule type[ P:IfThen else Q:Proc ] => type[ "else" ;; type[P] ;; type[Q] ]

//  rule type[ if (B:BExp) P:ProcPat  ] => type[ "ifthen" ;; type[B] ;; type[P] ]
//  rule type[ P:IfThenPat else Q:ProcPat  ] => type[ "else"   ;; type[P] ;; type[Q] ]

// Bundles
  rule type[ bundle+{ P:Proc } ] => type[ "bundle+" ;; type[P] ;; unit ]
  rule type[ bundle-{ P:Proc } ] => type[ "bundle-" ;; type[P] ;; unit ]
  rule type[ bundle0{ P:Proc } ] => type[ "bundle0" ;; type[P] ;; unit ]
  rule type[ bundle { P:Proc } ] => type[ "bundle"  ;; type[P] ;; unit ]

// Collections
// RhoList
  rule type[ [ ] ] => type[ "list" ;; type[EmptyP] ;; unit ]
  rule type[ [ P:Proc           ] ] => type[ "list" ;; type[P] ;; unit ]
  rule type[ [ P:Proc , Q:Proc  ] ] => type[ "list" ;; type[P] ;; type[Q] ]
  rule type[ [ P:Proc , Q:Procs ] ] => type[ "list" ;; type[P] ;; type[Q] ]

// RhoListPat
//  rule type[ [ P:ProcPat , ... V:ProcVar ] ] => type[ "listpat" ;; type[P] ;; type[V] ]

// RhoMap
  rule type[ P:Proc : Q:Proc            ] => type[ "kvpair"  ;; type[P] ;; type[Q] ]
  rule type[ R:RhoKVPair , S:RhoKVPair  ] => type[ "kvpairs" ;; type[R] ;; type[S] ]
  rule type[ R:RhoKVPair , S:RhoKVPairs ] => type[ "kvpairs" ;; type[R] ;; type[S] ]

  rule type[ { } ] => type[ "map" ;; type[EmptyP] ;; unit ]
  rule type[ { R:RhoKVPair                } ] => type[ "map" ;; type[R] ;; unit ]
  rule type[ { R:RhoKVPair , S:RhoKVPair  } ] => type[ "map" ;; type[R] ;; type[S] ]
  rule type[ { R:RhoKVPair , S:RhoKVPairs } ] => type[ "map" ;; type[R] ;; type[S] ]

// RhoMapPat
//  rule type[ P:ProcPat : Q:ProcPat                  ] => type[ "kvpat"      ;; type[P]   ;; type[Q] ]
//  rule type[ P:ProcPat : Q:ProcPat , R:RhoKVPat     ] => type[ "kvpats"     ;; type[P:Q] ;; type[R] ]

//  rule type[ { R:RhoKVPat , ... U:ProcVar : V:ProcVar } ] => type[ "mappat" ;; type[R]   ;; type[U:V] ]

// RhoSet
  rule type[ Set( ) ] => type[ "set" ;; type[EmptyP] ;; unit ]
  rule type[ Set( P:Proc  ) ] => type[ "set" ;; type[P] ;; unit ]
  rule type[ Set( P:Procs ) ] => type[ "set" ;; type[P] ;; unit ]

// RhoSetPat
//  rule type[ Set( P:ProcPat , ... V:ProcVar )   ] => type[ "setpat"   ;; type[P]   ;; type[V] ]

// RhoTuple
  rule type[ tuple(( )) ] => type[ "tuple" ;; type[EmptyP] ;; unit ]
  rule type[ tuple( P:Proc  ) ] => type[ "tuple" ;; type[P] ;; unit ]
  rule type[ tuple( P:Procs ) ] => type[ "tuple" ;; type[P] ;; unit ]

// RhoTuplePat
//  rule type[ ( P:ProcPat , ... V:ProcVar  ) ] => type[ "tuplepat" ;; type[P] ;; type[V] ]

// PatTuple
//  rule type[ pat1( P:ProcPat              ) ] => type[ "tuple" ;; type[P] ;; unit ]
//  rule type[ pat2( P:ProcPat , Q:ProcPat  ) ] => type[ "tuple" ;; type[P] ;; type[Q] ]
//  rule type[ patn( P:ProcPat , Q:ProcPats ) ] => type[ "tuple" ;; type[P] ;; type[Q] ]

// Method -- check syntax
  rule type[ P:Proc MA:MethodAndArgs ] => type[ "method" ;; type[P] ;; type[MA] ]
  rule type[ . M:Method ( A:Procs )  ] => type[ "method&args" ;; type[M] ;; type["args" & A] ]
  rule type[ . M:Method ( A:Proc  )  ] => type[ "method&args" ;; type[M] ;; type["args" & A] ]
  rule type[ . M:Method (         )  ] => type[ "method&args" ;; type[M] ;; type["args" & EmptyP] ]

//  rule type[ P:ProcPat . M:MethodAndArgs ] => type[ "method"        ;; type[P] ;; type[M] ]
//  rule type[ M:Method (  A:MethodArgs )  ] => type[ "methodandargs" ;; type[M] ;; type[A] ]

// Several Names
  rule type[ M:Name , N:Name  ] => type[ "names" ;; type[M] ;; type[N] ]
  rule type[ M:Name , N:Names ] => type[ "names" ;; type[M] ;; type[N] ]

//  rule type[ M:NamePat , N:NamePat  ] => type[ "namepats"  ;; type[M] ;; type[N] ]
//  rule type[ M:NamePat , N:NamePats ] => type[ "namepats"  ;; type[M] ;; type[N] ]

// Several Procs
  rule type[ P:Proc , Q:Proc  ] => type[ "procs" ;; type[P] ;; type[Q] ]
  rule type[ P:Proc , Q:Procs ] => type[ "procs" ;; type[P] ;; type[Q] ]

//  rule type[ P:ProcPat , Q:ProcPat  ] => type[ "procpats"  ;; type[P] ;; type[Q] ]
//  rule type[ P:ProcPat , Q:ProcPats ] => type[ "procpats"  ;; type[P] ;; type[Q] ]

// Arithmetic
  rule type[ A:AExp * B:AExp ] => type[ "mult"  ;; type[A] ;; type[B] ]
  rule type[ A:AExp + B:AExp ] => type[ "plus"  ;; type[A] ;; type[B] ]
  rule type[ A:AExp - B:AExp ] => type[ "minus" ;; type[A] ;; type[B] ]

// Boolean
  rule type[ A:AExp <=  B:AExp ] => type[ "leq" ;; type[A] ;; type[B] ]
  rule type[ A:BExp and B:BExp ] => type[ "and" ;; type[A] ;; type[B] ]
  rule type[ A:BExp or  B:BExp ] => type[ "or"  ;; type[A] ;; type[B] ]
  rule type[   not A:BExp      ] => type[ "not" ;; type[A] ;; unit ]

/*
//----------------------
//--- Type Inclusion ---
//----------------------
// Relation to #isIn predicate
  rule A:Type #isin B:Type => A #isIn B

  rule P:Proc #isIn Q:Proc    => #type(P) #isin #type(Q)
//  rule P:Proc #isIn Q:ProcPat => #type(P) #isin #type(Q)
//  rule P:ProcPat #isIn Q:ProcPat => #type(P) #isin #type(Q)
//  rule _:ProcPat #isIn _:Proc    => false

  rule M:Name #isIn N:Name    => #type(M) #isin #type(N)
//  rule M:Name #isIn N:NamePat => #type(M) #isin #type(N)
//  rule M:NamePat #isIn N:NamePat => #type(M) #isin #type(N)
//  rule _:NamePat #isIn _:Name    => false
*/
endmodule