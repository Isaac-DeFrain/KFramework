// Structural type system for Grounded RHO-CALCULUS
// Type is a structural binary tree

require "domains.k"

module STYPE-SYNTAX
  import DOMAINS

//**********************************************************
//*** Grounded Rho-Calculus Syntax with Process Patterns ***
//**********************************************************

//-------------
//--- NAMES ---
//-------------

// Names
  syntax             Name ::= "{" Name "}"                                [bracket]  // {_}: Name ---> Name
                            > Chan                                                   //         Chan < Name
                            | NameVar                                                //      NameVar < Name
                            | "unforgeable(" Int ")"                                 // unforgeable(_): Int ---> Name

// Channel
  syntax             Chan ::= "@" Proc                                     [strict]  // @: Proc -----> Name

// Name Variables
  syntax          NameVar ::= Id                                                     // Id < NameVar

// Name Patterns
  syntax          NamePat ::= "{" NamePat "}"                             [bracket]  // {_}: NamePat ---> NamePat
                            > "@" ProcPat                                            //   @: ProcPat ---> NamePat
                            | "WildN"                                                //           WildN < NamePat

// Name or Name Pattern
  syntax        NameOrPat ::= "{" NameOrPat "}"                                      // {_}: NameOrPat ---> NameOrPat
                            > Name                                                   //              Name < NameOrPat
                            | NamePat                                                //           NamePat < NameOrPat

// Several Names
  syntax            Names ::= "{" Names "}"                               [bracket]  // {_}: Names ----------> Names
                            > Name "," Name                                          // _,_: Name  x Name ---> Names
                            | Name "," Names                                         // _,_: Names x Name ---> Names

// Several Name Patterns
  syntax         NamePats ::= "{" NamePats "}"                            [bracket]  // {_}: NamePats -------------> NamePats
                            > NamePat "," NamePat                                    // _,_: NamePat  x NamePat ---> NamePats
                            | NamePat "," NamePats                                   // _,_: NamePats x NamePat ---> NamePats

// Name or Name Pattern
  syntax       NameOrPats ::= "{" NameOrPats "}"                                     // {_}: NameOrPats ---> NameOrPats
                            > Names                                                  //              Names < NameOrPats
                            | NamePats                                               //           NamePats < NameOrPats

//-----------------
//--- PROCESSES ---
//-----------------

// Processes
  syntax             Proc ::= "{" Proc "}"                                [bracket]  // {_}: Proc -> Proc
                            > New                                                    //        New < Proc
                            > "Nil"                                                  //        Nil < Proc
                            | Ground                                                 //     Ground < Proc
                            | Collection                                             // Collection < Proc
                            | Receive                                                //    Receive < Proc
                            | Send                                                   //       Send < Proc
                            | Eval                                                   //       Eval < Proc
                            | Bundle                                                 //     Bundle < Proc
                            > Par                                                    //        Par < Proc

// Par
  syntax              Par ::= Proc "|" Proc                                  [left]  // _|_: Proc x Proc ----------------> Par

// Receive
  syntax          Receive ::= "for" "(" Bind  ")" "{" Proc "}"                       // for(_){_}: Bind x Proc ----------> Receive
                            | "for" "(" Binds ")" "{" Proc "}"                       // for(_){_}: Bind x Proc ----------> Receive
                                                                                                                                 // requires ProcPat[N / BindNamePat] to be concrete when N:Name
  syntax             Bind ::= Lbind                                                  // Lbind < Bind, linear                     // e.g. for( y <- @Nil ){ y!("hi") } is a Proc because
                            | Pbind                                                  // Pbind < Bind, peek                       // BindNamePat = y and ProcPat = y!("hi") thus
                            | Rbind                                                  // Rbind < Bind, repeated                   // {y!("hi")}[N / y] = N!("hi") is a concrete process

  syntax            Binds ::= Lbinds                                                 // Lbinds < Binds
                            | Pbinds                                                 // Pbinds < Binds
                            | Rbinds                                                 // Rbinds < Binds

  syntax      BindNamePat ::= Name                                                   //    Name < BindNamePat
                            | NamePat                                                // NamePat < BindNamePat

  syntax     BindNamePats ::= Names
                            | NamePats

  syntax            Lbind ::= BindNamePat  "<-" Name                                 // _<-_: BindNamePat  x Name -----------> Lbind 
                            | BindNamePats "<-" Name                                 // _<-_: BindNamePats x Name -----------> Lbind

  syntax           Lbinds ::= Lbind ";" Lbind                                        // 2 linear binds
                            | Lbind ";" Lbinds                                       // N linear binds, N > 2


  syntax            Pbind ::= BindNamePat  "<!" Name                                 // _<!_: BindNamePat  x Name -----------> Pbind 
                            | BindNamePats "<!" Name                                 // _<!_: BindNamePats x Name -----------> Pbind

  syntax           Pbinds ::= Pbind ";" Pbind                                        // 2 peek binds
                            | Pbind ";" Pbinds                                       // N peek binds, N > 2


  syntax            Rbind ::= BindNamePat  "<=" Name                                 // _<=_: BindNamePat  x Name -----------> Rbind 
                            | BindNamePats "<=" Name                                 // _<=_: BindNamePats x Name -----------> Rbind

  syntax           Rbinds ::= Rbind ";" Rbind                                        // 2 repeated binds
                            | Rbind ";" Rbinds                                       // N repeated binds, N > 2

// Send
  syntax             Send ::= Name "!" "(" Proc ")"                                  // _!(_): Name x Proc --------------> Send

// Eval
  syntax             Eval ::= "*" Name                                               // *: Name -------------------------> Eval

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
  syntax         RhoTuple ::= "(" Proc  ")"                        [klabel(tuple1)]  // 1-tuple
                            | "(" Procs ")"                        [klabel(tuplen)]  // N-tuple, N > 1

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}"                                 // write bundle
                            | "bundle-" "{" Proc "}"                                 // read-only bundle
                            | "bundle0" "{" Proc "}"                                 // read/write bundle
                            | "bundle"  "{" Proc "}"                                 // no bundle

// New
  syntax              New ::= "new" Name  "in" "{" Proc "}"                [binder]  // 1 name declaration
                            | "new" Names "in" "{" Proc "}"                [binder]  // N > 1 name declarations

// Several Processes
  syntax            Procs ::= "{" Procs "}"                               [bracket]  // {_}: Procs ----------> Procs
                            > Proc "," Proc                                          // _,_: Proc x Proc  ---> Procs
                            | Proc "," Procs                                         // _,_: Proc x Procs ---> Procs

//------------------------
//--- Process Patterns ---
//------------------------

// Par Pattern
  syntax           ParPat ::= Proc    "|" ProcPat                            [left]  // _|_: Proc x ProcPat ---------> ParPat
                            | ProcPat "|" Proc                               [left]  // _|_: ProcPat x Proc ---------> ParPat
                            | ProcPat "|" ProcPat                            [left]  // _|_: ProcPat x ProcPat ------> ParPat

  syntax         ParOrPat ::= Par                                                    //     Par < ParOrPat
                            | ParPat                                                 //  ParPat < ParOrPat

// Receive Pattern
  syntax       ReceivePat ::= "for" "(" Bind  ")" "{" ProcPat "}"                    // for(_){_}: Bind  x ProcPat -----> ProcPat  // requires ProcPat[Name / BindNamePat] to be a process pattern?
                            | "for" "(" Binds ")" "{" ProcPat "}"                    // for(_){_}: Binds x ProcPat -----> ProcPat 

  syntax     ReceiveOrPat ::= Receive                                                //    Receive < ReciveOrPat
                            | ReceivePat                                             // ReceivePat < ReciveOrPat

// Send Pattern
  syntax          SendPat ::= Name    "!" "(" ProcPat ")"                            //    _!(_): Name x ProcPat ------> SendPat
                            | NamePat "!" "(" ProcPat ")"                            // _!(_): NamePat x ProcPat ------> SendPat
                            | NamePat "!" "(" Proc    ")"                            // _!(_): NamePat x Proc ---------> SendPat

  syntax        SendOrPat ::= Send                                                   //    Send < SendOrPat
                            | SendPat                                                // SendPat < SendOrPat

// Eval Pattern
  syntax          EvalPat ::= "*" NamePat                                            // *: NamePat --------------------> EvalPat

  syntax        EvalOrPat ::= Eval                                                   //    Eval < EvalOrPat
                            | EvalPat                                                // EvalPat < EvalOrPat

// Process Pattern
  syntax          ProcPat ::= "{" ProcPat "}"                                        // {_}: ProcPat ------------------> ProcPat
                            > "WildP"                                                //      WildP < ProcPat
                            | SimpleType                                             //  SimplType < ProcPat
                            | ReceivePat                                             // ReceivePat < ProcPat
                            | SendPat                                                //    SendPat < ProcPat
                            | EvalPat                                                //    EvalPat < ProcPat
                            > ParPat                                                 //     ParPat < ProcPat

// Logical connectives
  syntax          ProcPat ::= "~" ProcPat                                            //   ~_: ProcPat -----------------> ProcPat
                            > Proc    "/\\" ProcPat                                  // _/\_: Proc x ProcPat ----------> ProcPat
                            | ProcPat "/\\" Proc                                     // _/\_: ProcPat x Proc ----------> ProcPat
                            | ProcPat "/\\" ProcPat                                  // _/\_: ProcPat x ProcPat -------> ProcPat
                            > Proc    "\\/" ProcPat                                  // _\/_: Proc x ProcPat ----------> ProcPat
                            | ProcPat "\\/" Proc                                     // _\/_: ProcPat x Proc ----------> ProcPat
                            | ProcPat "\\/" ProcPat                                  // _\/_: ProcPat x ProcPat -------> ProcPat

// Several Process Patterns
  syntax         ProcPats ::= "{" ProcPats "}"                            [bracket]  // {_}: ProcPats -------------> ProcPats
                            > ProcPat "," ProcPat                                    // _,_: ProcPat  x ProcPat ---> ProcPats
                            | ProcPat "," ProcPats                                   // _,_: ProcPats x ProcPat ---> ProcPats

// Proc or ProcPat
  syntax        ProcOrPat ::= "{" ProcOrPat "}"                                      //      {_}: ProcOrPat -----------> ProcOrPat
                            > Proc                                                   //    Proc < ProcOrPat
                            | ProcPat                                                // ProcPat < ProcOrPat

  syntax       ProcOrPats ::= "{" ProcOrPats "}"                                     // {_}: ProcOrPats ---> ProcOrPats
                            > Procs                                                  //              Procs < ProcOrPats
                            | ProcPats                                               //           ProcPats < ProcOrPats

// Name, NamePat, Proc, or ProcPat
  syntax            OrPat ::= "{" OrPat "}"                                          // {_}: OrPat ---> OrPat
                            > ProcOrPat                                              //     ProcOrPat < OrPat
                            | NameOrPat                                              //     NameOrPat < OrPat

// Names, NamePats, Procs, or ProcPats
  syntax           OrPats ::= "{" OrPats "}"                                         // {_}: OrPats ---> OrPats
                            > ProcOrPats                                             //     ProcOrPats < OrPat
                            | NameOrPats                                             //     NameOrPats < OrPat

//******************************
//*** STRUCTURAL TYPE SYNTAX ***
//******************************
  syntax             Type ::= "#type(" Proc    ")"                                   // #type(_): Proc ------> Type
                            | "#type(" ProcPat ")"                                   // #type(_): ProcPat ---> Type
                            | "#type(" Name    ")"                                   // #type(_): Name ------> Type
                            | "#type(" NamePat ")"                                   // #type(_): NamePat ---> Type
                            | InitialType                                            //          InitialType < Type
                            | IntermediateType                                       //     IntermediateType < Type
                            | TerminalType                                           //         TerminalType < Type
                            | String                                                 //               String < Type (for String input/output)


// Simple Types - types of ground terms
  syntax       SimpleType ::= "Bool"                                                 //   Bool < SimpleType
                            | "Int"                                                  //    Int < SimpleType
                            | "String"                                               // String < SimpleType

// Typical input for type rewrites
  syntax  OrPatOrLeafType ::= "type[" OrPat       "]"                                // type[_]: OrPat --------> OrPatOrLeafType
                            | "type[" OrPats      "]"                                // type[_]: OrPats -------> OrPatOrLeafType
                            | "type[" Leaf        "]"                                // type[_]: Leaf ---------> OrPatOrLeafType
                            | "type[" RhoKVPairs  "]"                                // type[_]: RhoKVPairs ---> OrPatOrLeafType

//  Initial type
  syntax      InitialType ::= OrPatOrLeafType                                        //         OrPatOrLeafType < InitialType
                            | "type[" Bind        "]"                                // type[_]: Bind ----------> InitialType
                            | "type[" Binds       "]"                                // type[_]: Binds ---------> InitialType
                            | "type[" BindNamePat "]"                                // type[_]: BindNamePat ---> InitialType

//  Intermediate type - type[_;;_;;_]: String x IntermediateType x IntermediateType ---> IntermediateType
  syntax IntermediateType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                            | TerminalType                                           // TerminalType < IntermediateType
                            | InitialType                                            //  InitialType < IntermediateType

//  Terminal type - type[_;;_;;_]: String x TerminalType x TerminalType ---> TerminalType
  syntax     TerminalType ::= "type[" String ";;" TerminalType     ";;" TerminalType     "]"
                            | LeafType                                               // LeafType < TerminalType

// corresponds to the leaves in the structural binary tree - type[_;;_;;_]: String x Leaf x Leaf ---> LeafType
  syntax         LeafType ::= "type[" String ";;" Leaf             ";;" Leaf             "]"

//-- toString --
  syntax           String ::= "toString(" OrPat ")"                                  // toString(_): OrPat ---> String
                            | "toString(" Type  ")"                                  // toString(_): Type ----> String

  syntax             Leaf ::= Ground                                                 //    Ground < Leaf
                            | NameVar                                                //   NameVar < Leaf
                            | "#truncate"                                            // #truncate < Leaf

endmodule


module STYPE
  import STYPE-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

  syntax KResult ::= TerminalType

//---------------------
//--- Type function ---
//---------------------
  rule #type( P:Proc    ) => type[P]
  rule #type( P:ProcPat ) => type[P]
  rule #type( N:Name    ) => type[N]
  rule #type( N:NamePat ) => type[N]

//*** Leaves ***
// Ground
  rule type[ B:Bool                      ] => type[ "leaf"    ;; "bool"     ;; B     ]  // Bool ==================> Leaf
  rule type[ I:Int                       ] => type[ "leaf"    ;; "int"      ;; I     ]  // Int ===================> Leaf
  rule type[ S:String                    ] => type[ "leaf"    ;; "string"   ;; S     ]  // String ================> Leaf

// NameVar
  rule type[ N:NameVar                   ] => type[ "leaf"    ;; "namevar"  ;; N     ] // NameVar ================> Leaf

// Nil
  rule type[ Nil                         ] => type[ "leaf"    ;; "nil"      ;; "Nil" ] // Nil ====================> Leaf

// Wildcards
  rule type[ WildP                       ] => type[ "leaf"    ;; "wildcard" ;; "procpat" ]  // WildP =============> Leaf
  rule type[ WildN                       ] => type[ "leaf"    ;; "wildcard" ;; "namepat" ]  // WildN =============> Leaf

// #truncate
  rule type[ #truncate                   ] => type[ "leaf"    ;; "truncate" ;;      #truncate  ]  // #truncate ===> Leaf

//*** Nodes ***
// EvalOrPat
  rule type[ * N:Name                    ] => type[ "eval"    ;; type[N]    ;; type[#truncate] ]  // Eval
  rule type[ * N:NamePat                 ] => type[ "eval"    ;; type[N]    ;; type[#truncate] ]  // Eval pattern

// SendOrPat
  rule type[ N:Name    ! (P:Proc    )    ] => type[ "send"    ;; type[N]    ;; type[P] ]  // Send
  rule type[ N:Name    ! (P:ProcPat )    ] => type[ "send"    ;; type[N]    ;; type[P] ]  // Send pattern
  rule type[ N:NamePat ! (P:Proc    )    ] => type[ "send"    ;; type[N]    ;; type[P] ]  // Send pattern
  rule type[ N:NamePat ! (P:ProcPat )    ] => type[ "send"    ;; type[N]    ;; type[P] ]  // Send pattern

// ReceiveOrPat/Bind(s)
  rule type[ B:BindNamePat <- N:Name     ] => type[ "lbind"   ;; type[B]    ;; type[N] ]  // Linear bind
  rule type[ A:Lbind ; B:Lbind           ] => type[ "lbinds"  ;; type[A]    ;; type[B] ]  // 2 linear binds
  rule type[ A:Lbind ; B:Lbinds          ] => type[ "lbinds"  ;; type[A]    ;; type[B] ]  // N linear binds, N > 2

  rule type[ B:BindNamePat <! N:Name     ] => type[ "pbind"   ;; type[B]    ;; type[N] ]  // Peek bind
  rule type[ A:Pbind ; B:Pbind           ] => type[ "pbinds"  ;; type[A]    ;; type[B] ]  // 2 peek binds
  rule type[ A:Pbind ; B:Pbinds          ] => type[ "pbinds"  ;; type[A]    ;; type[B] ]  // N peek binds, N > 2

  rule type[ B:BindNamePat <= N:Name     ] => type[ "rbind"   ;; type[B]    ;; type[N] ]  // Repeated bind
  rule type[ A:Rbind ; B:Rbind           ] => type[ "rbinds"  ;; type[A]    ;; type[B] ]  // 2 repeated binds
  rule type[ A:Rbind ; B:Rbinds          ] => type[ "rbinds"  ;; type[A]    ;; type[B] ]  // N repeated binds, N > 2

  rule type[ for( R:Bind  ){ P:Proc    } ] => type[ "receive" ;; type[R]    ;; type[P] ]  // Receive
  rule type[ for( R:Bind  ){ P:ProcPat } ] => type[ "receive" ;; type[R]    ;; type[P] ]  // Receive pattern
  rule type[ for( R:Binds ){ P:Proc    } ] => type[ "receive" ;; type[R]    ;; type[P] ]  // Receive
  rule type[ for( R:Binds ){ P:ProcPat } ] => type[ "receive" ;; type[R]    ;; type[P] ]  // Receive pattern

// ParOrPat
  rule type[ P:Proc     | Q:Proc         ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par
  rule type[ P:Proc     | Q:ProcPat      ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern
  rule type[ P:ProcPat  | Q:Proc         ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern
  rule type[ P:ProcPat  | Q:ProcPat      ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern

// Logical Patterns
  rule type[ P:Proc    /\ Q:ProcPat      ] => type[ "and"     ;; type[P]    ;; type[Q] ]  // logical and
  rule type[ P:ProcPat /\ Q:Proc         ] => type[ "and"     ;; type[P]    ;; type[Q] ]  // logical and
  rule type[ P:ProcPat /\ Q:ProcPat      ] => type[ "and"     ;; type[P]    ;; type[Q] ]  // logical and

  rule type[ P:Proc    \/ Q:ProcPat      ] => type[ "or"      ;; type[P]    ;; type[Q] ]  // logical or
  rule type[ P:ProcPat \/ Q:Proc         ] => type[ "or"      ;; type[P]    ;; type[Q] ]  // logical or
  rule type[ P:ProcPat \/ Q:ProcPat      ] => type[ "or"      ;; type[P]    ;; type[Q] ]  // logical or

  rule type[ ~ P:ProcPat                 ] => type[ "not"     ;; type[P]    ;; type[#truncate] ]  // logical negation

// Bundles
  rule
      type[ bundle+{ P:Proc } ] => type[ "bundle+"    ;; type[P]            ;; type[#truncate] ]  // bundle+
  rule
      type[ bundle-{ P:Proc } ] => type[ "bundle-"    ;; type[P]            ;; type[#truncate] ]  // bundle-
  rule
      type[ bundle0{ P:Proc } ] => type[ "bundle0"    ;; type[P]            ;; type[#truncate] ]  // bundle0
  rule
      type[ bundle { P:Proc } ] => type[ "bundle"     ;; type[P]            ;; type[#truncate] ]  // bundle

// Uri
  rule type[ uri( S:String )  ] => type[ "uri"        ;; type[S]            ;; type[#truncate] ]  // uri

// SimpleType
  rule type[ ST:SimpleType    ] => type[ "simpletype" ;; type[toString(ST)] ;; type[#truncate] ]  // Bool, Int, String types

// Channel(s)
  rule type[ @ P:Proc         ] => type[ "quote"      ;; type[P]            ;; type[#truncate] ]  // quoted process

// Name Pattern(s)
  rule type[ @ P:ProcPat      ] => type[ "quote"      ;; type[P]            ;; type[#truncate] ]  // quoted process pattern

// Collections
// RhoList
  rule type[ [ P:Proc           ] ] => type[ "list"   ;; type[P]            ;; type[#truncate] ]  // singleton list
  rule type[ [ P:Proc , Q:Proc  ] ] => type[ "list"   ;; type[P]            ;; type[Q]         ]  // 2 process list
  rule type[ [ P:Proc , Q:Procs ] ] => type[ "list"   ;; type[P]            ;; type[Q]         ]  // N process list, N > 2

// RhoMap
  rule type[ P:Proc : Q:Proc                ] => type[ "kvpair"  ;; type[P]   ;; type[Q]         ]  // single key-value pair
  rule type[ P:Proc : Q:Proc , R:RhoKVPairs ] => type[ "kvpairs" ;; type[P:Q] ;; type[R]         ]  // N key-value pairs, N > 2

  rule type[ { P:Proc : Q:Proc                } ] => type[ "map" ;; type[P:Q] ;; type[#truncate] ]  // 2 key-value pairs map
  rule type[ { P:Proc : Q:Proc , S:RhoKVPairs } ] => type[ "map" ;; type[P:Q] ;; type[S]         ]  // 2 key-value pairs map

// RhoSet
  rule type[ Set( P:Proc           ) ] => type[ "set"        ;; type[P]     ;; type[#truncate] ]  // singleton set
  rule type[ Set( P:Proc , Q:Proc  ) ] => type[ "set"        ;; type[P]     ;; type[Q]         ]  // 2 element set
  rule type[ Set( P:Proc , Q:Procs ) ] => type[ "set"        ;; type[P]     ;; type[Q]         ]  // N element set, N > 2

// RhoTuple - parsing error
  rule type[ tuple1( P:Proc           ) ] => type[ "tuple"    ;; type[P]    ;; type[#truncate] ]  // single process set
  rule type[ tuplen( P:Proc , Q:Proc  ) ] => type[ "tuple"    ;; type[P]    ;; type[Q]         ]  // 2 process set
  rule type[ tuplen( P:Proc , Q:Procs ) ] => type[ "tuple"    ;; type[P]    ;; type[Q]         ]  // N process set, N > 2

// Resolving brackets
  rule type[ { P:ProcOrPat } ] => type[P]  // bracketed ProcOrPat type resolution
  rule type[ { N:NameOrPat } ] => type[N]  // bracketed NameOrPat type resolution

// Unforgeable Integers
  rule type[ unforgeable( I:Int ) ] => type[ "unforgeable" ;; type[I]       ;; type[#truncate] ]  // unforgeable integer

// Several Names/Pats
  rule type[ M:Name , N:Name        ] => type[ "names"     ;; type[M]       ;; type[N]         ]  // 2 names

  rule type[ M:Name , N:Names       ] => type[ "names"     ;; type[M]       ;; type[N]         ]  // N names, N > 2

  rule type[ M:NamePat , N:NamePat  ] => type[ "namepats"  ;; type[M]       ;; type[N]         ]  // 2 name patterns

  rule type[ M:NamePat , N:NamePats ] => type[ "namepats"  ;; type[M]       ;; type[N]         ]  // N name patterns, N > 2

// Several Procs/Pats
  rule type[ P:Proc , Q:Proc        ] => type[ "procs"     ;; type[P]       ;; type[Q]         ]  // 2 processes

  rule type[ P:Proc , Q:Procs       ] => type[ "procs"     ;; type[P]       ;; type[Q]         ]  // N processes, N > 2

  rule type[ P:ProcPat , Q:ProcPat  ] => type[ "procpats"  ;; type[P]       ;; type[Q]         ]  // 2 process patterns

  rule type[ P:ProcPat , Q:ProcPats ] => type[ "procpats"  ;; type[P]       ;; type[Q]         ]  // N process patterns, N > 2

endmodule
