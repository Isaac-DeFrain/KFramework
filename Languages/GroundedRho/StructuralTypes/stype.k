// Structural type system for Grounded RHO-CALCULUS
// Type = Structural binary tree

require "domains.k"
require "kast.k"
require "substitution.k"

module STYPE-SYNTAX
  import DOMAINS
  import SUBSTITUTION

//************************************
//*** Grounded Rho-Calculus Syntax ***
//************************************

//-------------
//--- NAMES ---
//-------------

// Channels
  syntax             Name ::= "{" Name "}"                                [bracket]  // {_}: Name ---> Name
                            | "@" Proc                                     [strict]  // @: Proc -----> Name

// Name Variables
  syntax          NameVar ::= Id                                          [namevar]  // only lowerCamelCase NameVar (solves type parsing ambiguity with ProcVar)
                                                                                     // #LowerId < NameVar
// Name Patterns
  syntax          NamePat ::= "{" NamePat "}"                             [bracket]  //   {_}: NamePat ---> NamePat
                            | NameVar                                                //           NameVar < NamePat
                            | "@" ProcPat                                            //   @: ProcPat -----> NamePat

  syntax        NameOrPat ::= "{" NameOrPat "}"                                      // {_}: NameOrPat ---> NameOrPat
                            | Name                                                   //              Name < NameOrPat
                            | NamePat                                                //           NamePat < NameOrPat

//-----------------
//--- PROCESSES ---
//-----------------

// Process Variables
//syntax          ProcVar ::= Id                                          [procvar]  // Var < ProcVar

// Processes
  syntax             Proc ::= "{" Proc "}"                                [bracket]  // {_}: Proc -> Proc
                            | "Nil"                                                  //        Nil < Proc
                            | Ground                                                 //     Ground < Proc
                            | Receive                                                //    Receive < Proc
                            | Send                                                   //       Send < Proc
                            | Eval                                                   //       Eval < Proc
                            | Bundle                                                 //     Bundle < Proc
                            > Par                                                    //        Par < Proc

// Par
  syntax              Par ::= Proc "|" Proc                              [left,par]  // _|_: Proc x Proc ----------------> Par

// Receive
  syntax          Receive ::= "for" "(" Bind ")" "{" Proc "}"      [binder,receive]  // for(_){_}: Bind x Proc ----------> Receive
                                                                                                                                 // requires ProcPat[N / BindNamePat] to be concrete when N:Name
  syntax             Bind ::= BindNamePat "<-" Name                          [bind]  // _<-_: NamePat x Name ------------> Bind  // e.g. for( y <- @Nil ){ y!("hi") } is a Proc because
                                                                                                                                 // BindNamePat = y and ProcPat = y!("hi") thus
  syntax      BindNamePat ::= NamePat                                                // NamePat < BindNamePat                    // {y!("hi")}[N / y] = N!("hi") is a concrete process

// Send
  syntax             Send ::= Name "!" "(" Proc ")"                [strict(2),send]  // _!(_): Name x Proc --------------> Send

// Eval
  syntax             Eval ::= "*" Name                                      [reify]  // *: Name -------------------------> Eval

// Ground terms
  syntax           Ground ::= Bool                                                   //   Bool < Ground
                            | Int                                                    //    Int < Ground
                            | String                                                 // String < Ground
                            | Uri                                                    //    Uri < Ground
                            | "unforgeable(" Int ")"                                 // unforgeable(_): Int -------------> Ground

  syntax              Uri ::= "uri(" String      ")"                                 // 

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}"                                 // write bundle
                            | "bundle-" "{" Proc "}"                                 // read-only bundle
                            | "bundle0" "{" Proc "}"                                 // 
                            | "bundle"  "{" Proc "}"                                 // 

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
  syntax       ReceivePat ::= "for" "(" Bind    ")" "{" ProcPat "}"        [binder]  // for(_){_}: Bind x ProcPat -----> ProcPat  // requires ProcPat[Name / BindNamePat] to be a process pattern?
                            | "for" "(" BindPat ")" "{" ProcPat "}"        [binder]  // for(_){_}: Bind x ProcPat -----> ProcPat
                            | "for" "(" BindPat ")" "{" Proc    "}"        [binder]

  syntax     ReceiveOrPat ::= Receive                                                //    Receive < ReciveOrPat
                            | ReceivePat                                             // ReceivePat < ReciveOrPat

  syntax          BindPat ::= BindNamePat "<-" NamePat                               // _<-_: BindNamePat x NamePat ---> BindPat

  syntax        BindOrPat ::= Bind                                                   //    Bind < BindOrPat
                            | BindPat                                                // BindPat < BindOrPat

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
                            | "_"
                            | SimpleType                                             //  SimplType < ProcPat
                            | ReceivePat                                             // ReceivePat < ProcPat
                            | SendPat                                                //    SendPat < ProcPat
                            | EvalPat                                                //    EvalPat < ProcPat
                            > ParPat                                                 //     ParPat < ProcPat

// Logical connectives
  syntax          ProcPat ::= "~" ProcPat                                            //   ~_: ProcPat -----------------> ProcPat
                            > Proc    "\\/" ProcPat                                  // _\/_: Proc x ProcPat ----------> ProcPat
                            | ProcPat "\\/" Proc                                     // _\/_: ProcPat x Proc ----------> ProcPat
                            | ProcPat "\\/" ProcPat                                  // _\/_: ProcPat x ProcPat -------> ProcPat
                            > Proc    "/\\" ProcPat                                  // _/\_: Proc x ProcPat ----------> ProcPat
                            | ProcPat "/\\" Proc                                     // _/\_: ProcPat x Proc ----------> ProcPat
                            | ProcPat "/\\" ProcPat                                  // _/\_: ProcPat x ProcPat -------> ProcPat

// Proc or ProcPat
  syntax        ProcOrPat ::= "{" ProcOrPat "}"                                      //      {_}: ProcOrPat -----------> ProcOrPat
                            | Proc                                                   //    Proc < ProcOrPat
                            | ProcPat                                                // ProcPat < ProcOrPat

// Name, NamePat, Proc, or ProcPat
  syntax            OrPat ::= NameOrPat
                            | ProcOrPat
                            | "{" OrPat "}"

//******************************
//*** STRUCTURAL TYPE SYNTAX ***
//******************************
  syntax             Type ::= InitialType                                            //      InitialType < Type
                            | IntermediateType                                       // IntermediateType < Type
                            | TerminalType                                           //     TerminalType < Type
                            | String                                                 //           String < Type (for String input/output)


// Simple Types - types of ground terms
  syntax       SimpleType ::= "Bool"                                                 //   Bool < SimpleType
                            | "Int"                                                  //    Int < SimpleType
                            | "String"                                               // String < SimpleType

// Typical input for type rewrites
  syntax  OrPatOrLeafType ::= "type[" OrPat       "]"                                // type[OrPat] < OrPatOrLeafType
                            | "type[" Leaf        "]"                                //  type[Leaf] < OrPatOrLeafType

//  Initial type
  syntax      InitialType ::= OrPatOrLeafType                                        //   OrPatOrLeafType < InitialType
                            | "type[" BindOrPat   "]"                                //   type[BindOrPat] < InitialType
                            | "type[" BindNamePat "]"                                // type[BindNamePat] < InitialType

//  Intermediate type
  syntax IntermediateType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                            | TerminalType
                            | InitialType

//  Terminal type
  syntax     TerminalType ::= "type[" String ";;" TerminalType     ";;" TerminalType     "]"
                            | LeafType

  syntax         LeafType ::= "type[" String ";;" Leaf             ";;" Leaf             "]"  // corresponds to the leaves in the structural binary tree

//-- toString --
  syntax           String ::= "toString(" OrPat ")"                                  // toString(_): OrPat ---> String
                            | "toString(" Type ")"

  syntax             Leaf ::= Ground
                            | NameVar
                            | "#truncate"

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
//rule #type( T:Type ) => T    [strict]

//*** Leaves ***
// Wildcard
  rule type[ _ ] => type[ "leaf" ;; "wildcard" ;; "_" ]

// Ground
  rule type[ B:Bool                      ] => type[ "leaf"    ;; "bool"     ;; B     ]  // Bool ======> Leaf
  rule type[ I:Int                       ] => type[ "leaf"    ;; "int"      ;; I     ]  // Int =======> Leaf
  rule type[ S:String                    ] => type[ "leaf"    ;; "string"   ;; S     ]  // String ====> Leaf

// NameVar
  rule type[ N:NameVar                   ] => type[ "leaf"    ;; "namevar"  ;; N     ] // NameVar ===> Leaf

// Nil
  rule type[ Nil                         ] => type[ "leaf"    ;; "nil"      ;; "Nil" ] // Nil =======> Leaf

// #truncate
  rule type[ #truncate                   ] => type[ "leaf"    ;; "truncate" ;;      #truncate  ]  // 

//*** Nodes ***
// EvalOrPat
  rule type[ * N:Name                    ] => type[ "eval"    ;; type[N]    ;; type[#truncate] ]  // Eval
  rule type[ * N:NamePat                 ] => type[ "eval"    ;; type[N]    ;; type[#truncate] ]  // Eval pattern

// SendOrPat
  rule type[ N:Name    ! (P:Proc   )     ] => type[ "send"    ;; type[N]    ;; type[P] ]  // Send
  rule type[ N:Name    ! (P:ProcPat)     ] => type[ "send"    ;; type[N]    ;; type[P] ]  // Send pattern
  rule type[ N:NamePat ! (P:Proc   )     ] => type[ "send"    ;; type[N]    ;; type[P] ]  // Send pattern
  rule type[ N:NamePat ! (P:ProcPat)     ] => type[ "send"    ;; type[N]    ;; type[P] ]  // Send pattern

// ReceiveOrPat
  rule type[ for(R:Bind   ){ P:Proc    } ] => type[ "receive" ;; type[R]    ;; type[P] ]  // Receive
  rule type[ for(R:Bind   ){ P:ProcPat } ] => type[ "receive" ;; type[R]    ;; type[P] ]  // Receive pattern
  rule type[ for(R:BindPat){ P:Proc    } ] => type[ "receive" ;; type[R]    ;; type[P] ]  // Receive pattern
  rule type[ for(R:BindPat){ P:ProcPat } ] => type[ "receive" ;; type[R]    ;; type[P] ]  // Receive pattern

// BindOrPat
  rule type[ B:BindNamePat <- N:Name     ] => type[ "bind"    ;; type[B]    ;; type[N] ]  // Bind
  rule type[ B:BindNamePat <- N:NamePat  ] => type[ "bind"    ;; type[B]    ;; type[N] ]  // Bind

// ParOrPat
  rule type[ P:Proc     | Q:Proc         ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par
  rule type[ P:Proc     | Q:ProcPat      ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern
  rule type[ P:ProcPat  | Q:Proc         ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern
  rule type[ P:ProcPat  | Q:ProcPat      ] => type[ "par"     ;; type[P]    ;; type[Q] ]  // Par pattern

//Patterns
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

// Channel
  rule type[ @ P:Proc         ] => type[ "quote"      ;; type[P]            ;; type[#truncate] ]  // quoted process

// Name Pattern
  rule type[ @ P:ProcPat      ] => type[ "quote"      ;; type[P]            ;; type[#truncate] ]  // quoted process pattern

// Resolving brackets
  rule type[ { P:ProcOrPat }  ] => type[P]  // bracketed ProcOrPat type resolution
  rule type[ { N:NameOrPat }  ] => type[N]  // bracketed NameOrPat type resolution

// Unforgeable Integers
  rule type[ unforgeable( I:Int ) ] => type[ "unforgeable" ;; type[I]       ;; type[#truncate] ]  // unforgeable integer

endmodule
