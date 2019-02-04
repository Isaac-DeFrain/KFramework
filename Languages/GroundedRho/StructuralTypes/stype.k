// Structural type system for RHO-CALCULUS
// Type = Structural binary tree

require "domains.k"
require "kast.k"
require "substitution.k"

module STYPE-SYNTAX
import DOMAINS
import KAST
import KSEQ-SYMBOLIC
import SUBSTITUTION

//************************************
//*** Grounded Rho-Calculus Syntax ***
//************************************

syntax              Var ::= Id                                                     // Id < Var, General Variables

//-------------
//--- NAMES ---
//-------------

// Channels
syntax             Name ::= "{" Name "}"                                [bracket]  // {_}: Name ---> Name
                          | "@" Proc                                     [strict]  // @: Proc -----> Name

// Name Variables
syntax          NameVar ::= #LowerId                                    [namevar]  // only lowerCamelCase NameVar (solves type parsing ambiguity with ProcVar)
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
syntax          ProcVar ::= Var                                         [procvar]  // Var < ProcVar

// Processes
syntax             Proc ::= "{" Proc "}"                                [bracket]  // {_}: Proc -> Proc
                          | "Nil"                                                  //        Nil < Proc
                          | Ground                                                 //     Ground < Proc
                          | Receive                                                //    Receive < Proc
                          | Send                                                   //       Send < Proc
                          | Reify                                                  //      Reify < Proc
                          > Par                                                    //        Par < Proc

// Par
syntax              Par ::= Proc "|" Proc                              [left,par]  // _|_: Proc x Proc ----------------> Par

// Receive
syntax          Receive ::= "for" "(" Bind ")" "{" Proc    "}"   [binder,receive]  // for(_){_}: Bind x Proc ------> Receive
                          | "for" "(" Bind ")" "{" ProcPat "}"   [binder,receive]  // for(_){_}: Bind x ProcPat ---> Receive  // countAllOccurrences( BindNamePat , ProcPat ) > 0 ???
                                                                                                                              // requires ProcPat[N / BindNamePat] to be concrete when N:Name
syntax             Bind ::= BindNamePat "<-" Name                          [bind]  // _<-_: NamePat x Name -----------> Bind  // e.g. for( y <- @Nil ){ y!("hi") } is a Proc because
                                                                                                                              // BindNamePat = y and ProcPat = y!("hi") thus
syntax      BindNamePat ::= NamePat                                                // NamePat < BindNamePat                   // {y!("hi")}[N / y] = N!("hi") is a concrete process

// Send
syntax             Send ::= Name "!" "(" Proc ")"                [strict(2),send]  // _!(_): Name x Proc -------------> Send

// Reify
syntax            Reify ::= "*" Name                                      [reify]  // *: Name -----------------------> Reify

// Ground terms
syntax           Ground ::= Bool                                                   //   Bool < Ground
                          | Int                                                    //    Int < Ground
                          | String                                                 // String < Ground

//syntax      KVariable ::= Proc | ProcPat

//syntax        Pattern ::= ProcPat

//------------------------
//--- Process Patterns ---
//------------------------

// Par Pattern
syntax           ParPat ::= Proc    "|" ProcPat                            [left]  //    _|_: Proc x ProcPat ---------> ParPat
                          | ProcPat "|" Proc                               [left]  // _|_: ProcPat x Proc ------------> ParPat
                          | ProcPat "|" ProcPat                            [left]  // _|_: ProcPat x ProcPat ---------> ParPat

syntax         ParOrPat ::= Par                                                    //     Par < ParOrPat
                          | ParPat                                                 //  ParPat < ParOrPat

// Receive Pattern
syntax       ReceivePat ::= "for" "(" Bind    ")" "{" ProcPat "}"        [binder]  // for(_){_}: Bind x ProcPat -----> ProcPat  // requires ProcPat[Name / BindNamePat] to be a process pattern?
                          | "for" "(" BindPat ")" "{" ProcPat "}"        [binder]  // for(_){_}: Bind x ProcPat -----> ProcPat

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

// Reify Pattern
syntax         ReifyPat ::= "*" NamePat                                            // *: NamePat -------------------> ReifyPat

syntax       ReifyOrPat ::= Reify                                                  //    Reify < ReifyOrPat
                          | ReifyPat                                               // ReifyPat < ReifyOrPat

// Process Pattern
syntax          ProcPat ::= "{" ProcPat "}"                                        // {_}: ProcPat ------------------> ProcPat
                          | SimpleType                                             //  SimplType < ProcPat
                          | ProcVar                                                //    ProcVar < ProcPat
                          | ReceivePat                                             // ReceivePat < ProcPat
                          | SendPat                                                //    SendPat < ProcPat
                          | ReifyPat                                               //   ReifyPat < ProcPat
                          > ParPat                                                 //     ParPat < ProcPat

syntax        ProcOrPat ::= "{" ProcOrPat "}"                                      //       {_}: ProcOrPat --------> ProcOrPat
                          | Proc                                                   //     Proc < ProcOrPat
                          | ProcPat                                                //  ProcPat < ProcOrPat

syntax            OrPat ::= NameOrPat
                          | ProcOrPat

//******************************
//*** STRUCTURAL TYPE SYNTAX ***
//******************************

syntax             Type ::= "#type(" Type ")"                          [function]  // #type( t:Type ) => t
                          | InitialType                                            //      InitialType < Type
                          | IntermediateType                                       // IntermediateType < Type
                          | TerminalType                                           //     TerminalType < Type
                          | String                                                 //           String < Type (for String input/output)


// Simple Types - types of ground terms
syntax       SimpleType ::= "Bool"                                                 //   Bool < SimpleType
                          | "Int"                                                  //    Int < SimpleType
                          | "String"                                               // String < SimpleType

// Recursive syntax for the type rewrites
//  Initial type
syntax      InitialType ::= "type[" OrPat       "]"
                          | "type[" Leaf        "]"
                          | "type[" BindOrPat   "]"
                          | "type[" BindNamePat "]"

//  Intermediate type
syntax IntermediateType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                          | TerminalType
                          | InitialType

//  Terminal type
syntax     TerminalType ::= "type[" String ";;" TerminalType     ";;" TerminalType     "]"
                          | "type[" String ";;" Leaf             ";;" Leaf             "]"

//-- toString --
syntax           String ::= "toString(" OrPat ")"                                  // toString(_): OrPat ---> String

syntax             Leaf ::= Ground
                          | NameVar
                          | ProcVar
                          | "#truncate"

endmodule


module STYPE
import STYPE-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

syntax KResult ::= TerminalType

// Normalizer: Order processes by <=String( toString( Proc ) )

//---------------------
//--- Type function ---
//---------------------
rule #type( T:Type ) => T    [strict]

//*** Leaves ***

// Ground
rule type[ B:Bool                      ] => type[ "leaf"    ;; "bool"     ;; B     ] [anywhere]  // Bool ======> Leaf
rule type[ I:Int                       ] => type[ "leaf"    ;; "int"      ;; I     ] [anywhere]  // Int =======> Leaf
rule type[ S:String                    ] => type[ "leaf"    ;; "string"   ;; S     ] [anywhere]  // String ====> Leaf

// ProcVar
rule type[ PV:ProcVar                  ] => type[ "leaf"    ;; "procvar"  ;; PV    ] [anywhere]  // ProcVar ===> Leaf

// NameVar
rule type[ NV:NameVar                  ] => type[ "leaf"    ;; "namevar"  ;; NV    ] [anywhere]  // NameVar ===> Leaf

// Nil
rule type[ Nil                         ] => type[ "leaf"    ;; "nil"      ;; "Nil" ] [anywhere]  // Nil =======> Leaf

//*** Nodes ***
// ReifyOrPat
rule type[ * N:Name                    ] => type[ "reify"   ;; type[N]    ;; type[#truncate] ] [anywhere]  // Reify
rule type[ * P:NamePat                 ] => type[ "reify"   ;; type[P]    ;; type[#truncate] ] [anywhere]  // Reify pattern

// SendOrPat
rule type[ N:Name    ! (P:Proc   )     ] => type[ "send"    ;; type[N]    ;; type[P] ] [anywhere]  // Send
rule type[ N:Name    ! (P:ProcPat)     ] => type[ "send"    ;; type[N]    ;; type[P] ] [anywhere]  // Send pattern
rule type[ N:NamePat ! (P:Proc   )     ] => type[ "send"    ;; type[N]    ;; type[P] ] [anywhere]  // Send pattern
rule type[ N:NamePat ! (P:ProcPat)     ] => type[ "send"    ;; type[N]    ;; type[P] ] [anywhere]  // Send pattern

// ReceiveOrPat
rule type[ for(R:Bind   ){ P:Proc    } ] => type[ "receive" ;; type[R]    ;; type[P] ] [anywhere]  // Receive
rule type[ for(R:Bind   ){ P:ProcPat } ] => type[ "receive" ;; type[R]    ;; type[P] ] [anywhere]  // Receive pattern
rule type[ for(R:BindPat){ P:ProcPat } ] => type[ "receive" ;; type[R]    ;; type[P] ] [anywhere]  // Receive pattern

// BindOrPat
rule type[ B:BindNamePat <- N:Name     ] => type[ "bind"    ;; type[B]    ;; type[N] ] [anywhere]  // Bind
rule type[ B:BindNamePat <- N:NamePat  ] => type[ "bind"    ;; type[B]    ;; type[N] ] [anywhere]  // Bind

// ParOrPat
rule type[ P:Proc     | Q:ProcPat      ] => type[ "par"     ;; type[P]    ;; type[Q] ] [anywhere] // Par pattern
rule type[ P:Proc     | Q:Proc         ] => type[ "par"     ;; type[P]    ;; type[Q] ] [anywhere]  // Par
rule type[ P:ProcPat  | Q:Proc         ] => type[ "par"     ;; type[P]    ;; type[Q] ] [anywhere]  // Par pattern
rule type[ P:ProcPat  | Q:ProcPat      ] => type[ "par"     ;; type[P]    ;; type[Q] ] [anywhere]  // Par pattern

// SimpleType
rule type[ ST:SimpleType    ] => type[ "simpletype" ;; type[toString(ST)] ;; type[#truncate] ] [anywhere]

// Channels
rule type[ @ P:Proc         ] => type[ "quote"      ;; type[P]            ;; type[#truncate] ] [anywhere]
rule type[ @ P:ProcPat      ] => type[ "quote"      ;; type[P]            ;; type[#truncate] ] [anywhere]

// #truncate
rule type[ #truncate         ] => type[ "leaf"       ;; "truncate"         ;;     #truncate  ] [anywhere]

// Resolving brackets
rule type[ { P:ProcOrPat }  ] => type[P] [anywhere]  // bracketed ProcOrPat type resolution
rule type[ { N:NameOrPat }  ] => type[N] [anywhere]  // bracketed NameOrPat type resolution

endmodule
