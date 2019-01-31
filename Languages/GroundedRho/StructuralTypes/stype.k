// Structural type system for RHO-CALCULUS

require "domains.k"
require "substitution.k"
//require "rho.k"

module STYPE-SYNTAX
import DOMAINS
import SUBSTITUTION
import KAST
//import RHO-SYNTAX

syntax              Var ::= Id                               // General Variables

//-------------
//--- NAMES ---
//-------------

// Channels
syntax             Chan ::= "@" Proc               [strict]  // Chan: Proc --> Name

// Name Variables
syntax          NameVar ::= #LowerId              [namevar]

// Names
syntax             Name ::= Chan
                          | "{" Name "}"          [bracket]

// Name Patterns
syntax          NamePat ::= NameVar
                          | "@" ProcPat

syntax        NameOrPat ::= Name | NamePat

//-----------------
//--- PROCESSES ---
//-----------------

// Process Variables
syntax          ProcVar ::= Var                   [procvar]

// Processes
syntax             Proc ::= "{" Proc "}"          [bracket]
                          | "Nil"                            // Stop: -> Proc
                          | Ground                           // Bool, Int, String
                          | Receive                          // Receive
                          | Send                             // Send
                          | Reify                            // Reify/evaluate
                          > Par                              // Par

syntax              Par ::= Proc "|" Proc                              [left,par]  // Par: Proc*Proc --------> Proc

syntax          Receive ::= "for" "(" Receipt ")" "{" Proc "}"   [binder,receive]  // Receive: Receipt*Proc -> Proc

syntax          Receipt ::= NamePat "<-" NameOrPat                      [receipt]  // Receipt: Name*Name ----> Receipt

syntax             Send ::= Name "!" "(" Proc ")"                [strict(2),send]  // Send: Name*Proc -------> Proc

syntax            Reify ::= "*" Name                                      [reify]  // Reify: Name -----------> Proc

//------------------------
//--- Process Patterns ---
//------------------------

// Par
syntax           ParPat ::= Proc    "|" ProcPat                            [left]  // ParPat: ProcPat*ProcPat --------> ProcPat
                          | ProcPat "|" Proc                               [left]
                          | ProcPat "|" ProcPat                            [left]

syntax         ParOrPat ::= Par | ParPat

// Receive
syntax       ReceivePat ::= "for" "(" Receipt ")" "{" ProcPat "}"        [binder]  // ReceivePat: ReceiptPat*ProcPat -> ProcPat

syntax     ReceiveOrPat ::= Receive | ReceivePat

// Send
syntax          SendPat ::= Name    "!" "(" ProcPat ")"                            // SendPat: Name*ProcPat ----------> ProcPat
                          | NamePat "!" "(" ProcPat ")"                            // SendPat:NamePat*ProcPat --------> ProcPat
                          | NamePat "!" "(" Proc    ")"                            // SendPat: NamePat*Proc ----------> Proc

syntax        SendOrPat ::= Send | SendPat

// Reify
syntax         ReifyPat ::= "*" NamePat                                            // ReifyPat: NamePat --------------> ProcPat

syntax       ReifyOrPat ::= Reify | ReifyPat

syntax          ProcPat ::= SimpleType
                          | ProcVar
                          | ReceivePat
                          | SendPat
                          | ReifyPat
                          > ParPat

syntax        ProcOrPat ::= Proc | ProcPat

// Gound Terms
syntax           Ground ::= Int | Bool | String                                    //Int, Bool, and String ground terms

//----------------
//--- PATTERNS ---
//----------------
syntax            OrPat ::= NameOrPat
                          | ProcOrPat

//------------------------
//--- STRUCTURAL TYPES ---
//------------------------

syntax             Type ::= "#type(" Type ")"                          [function]  // #type( t:Type ) => t
                          | InitialType                                            // Initializing type
                          | IntermediateType                                       // Intermediate type
                          | TerminalType                                           // Terminal type
                          | String                                                 // for toString


// Simple Types - types of ground terms
syntax       SimpleType ::= "Bool"
                          | "Int"
                          | "String"

// Recursive syntax for the type rewrites
//  Initial type
syntax      InitialType ::= "type[" OrPat    "]"
                          | "type[" Leaf     "]"
                          | "type[" Receipt  "]"

//  Intermediate type
syntax IntermediateType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                          | TerminalType
                          | InitialType

//  Terminal type
syntax     TerminalType ::= "type[" String ";;" Leaf             ";;" Leaf             "]"
                          | "type[" String ";;" TerminalType     ";;" TerminalType     "]"


//  Leaf
syntax             Leaf ::= Ground
                          | NameOrPat
                          | ProcOrPat
                          | "#truncate"

//-- toString --
syntax           String ::= "toString(" OrPat ")"

endmodule


module STYPE
import STYPE-SYNTAX

  configuration
    <T>
      <k> $PGM:Type </k>
    </T>

syntax KResult ::= TerminalType

// Normalizer: Order processes by <=Int and String2Int( toString( Proc ) )

//---------------------
//--- Type function ---
//---------------------
rule #type( T:Type ) => T         [strict]

//-----------------------------
//--- Process Type Rewrites ---
//-----------------------------
rule type[ B:Bool                       ] => type[ "leaf"       ;; "bool"    ;; B               ]  // Bool
rule type[ I:Int                        ] => type[ "leaf"       ;; "int"     ;; I               ]  // Int
rule type[ S:String                     ] => type[ "leaf"       ;; "string"  ;; S               ]  // String

rule type[ PV:ProcVar                   ] => type[ "leaf"       ;; "procvar" ;; PV              ]  // Process variable

rule type[ Nil                          ] => type[ "leaf"       ;; "nil"     ;; "Nil"           ]  // Nil

rule type[ * N:Name                     ] => type[ "reify"      ;; type[N]   ;; type[#truncate] ]  // Reify
rule type[ * P:NamePat                  ] => type[ "reifypat"   ;; type[P]   ;; type[#truncate] ]  // Reify pattern

rule type[ N:Name    ! (P:Proc   )      ] => type[ "send"       ;; type[N]   ;; type[P]         ]  // Send
rule type[ N:Name    ! (P:ProcPat)      ] => type[ "sendpat"    ;; type[N]   ;; type[P]         ]  // Send pattern
rule type[ N:NamePat ! (P:ProcPat)      ] => type[ "sendpat"    ;; type[N]   ;; type[P]         ]  // Send pattern
rule type[ N:NamePat ! (P:Proc   )      ] => type[ "sendpat"    ;; type[N]   ;; type[P]         ]  // Send pattern

rule type[ for(R:Receipt) { P:Proc    } ] => type[ "receive"    ;; type[R]   ;; type[P]         ]  // Receive
rule type[ for(R:Receipt) { P:ProcPat } ] => type[ "receivepat" ;; type[R]   ;; type[P]         ]  // Receive pattern

rule type[ P:NamePat <- N:NameOrPat     ] => type[ "bind"       ;; type[N]   ;; type[P]         ]  // Receipt

rule type[ P:Proc     | Q:Proc          ] => type[ "par"        ;; type[P]   ;; type[Q]         ]  // Par
rule type[ P:Proc     | Q:ProcPat       ] => type[ "parpat"     ;; type[P]   ;; type[Q]         ]  // Par pattern
rule type[ P:ProcPat  | Q:Proc          ] => type[ "parpat"     ;; type[P]   ;; type[Q]         ]  // Par pattern
rule type[ P:ProcPat  | Q:ProcPat       ] => type[ "parpat"     ;; type[P]   ;; type[Q]         ]  // Par pattern

//--------------------------
//--- Name Type Rewrites ---
//--------------------------

// Channels
rule type[ @ P:Proc      ] => type[ "quote" ;; type[P]      ;; type[#truncate] ]

// Name patterns
rule type[ @ P:ProcPat   ] => type[ "quote" ;; type[P]      ;; type[#truncate] ]
rule type[ NV:NameVar    ] => type[ "leaf"  ;; "namevar"    ;; NV              ]

//-----------------------------
//--- Pattern Type Rewrites ---
//-----------------------------

// SimpleType
rule type[ ST:SimpleType ] => type[ "simpletype" ;; type[toString(ST)] ;; type[#truncate] ]

// #truncate
rule type[ #truncate     ] => type[ "leaf"       ;; "truncate"         ;; #truncate       ]

endmodule
