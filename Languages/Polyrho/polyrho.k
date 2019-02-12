// Polyadic Rho-Calculus

require "domains.k"
require "kast.k"
require "substitution.k"

module POLYRHO-SYNTAX
  import DOMAINS
  import ID
  import LIST
  import MAP
  import SET
  import KAST
  import KSEQ-SYMBOLIC
  import SUBSTITUTION

//-----------------
//--- PROCESSES ---
//-----------------

//--- Processes ---
syntax          Proc ::= "{" Proc "}"                              [bracket]
                       | "Nil"
                       | Collection
                       > Eval
                       > Send
                       | Rec
                       > Par

//--- Parallel ---
syntax           Par ::= Proc "|" Proc

//--- Receive/Input ---
syntax           Rec ::= "for" "(" Receipt ")" "{" Proc "}"         [binder]

syntax       Receipt ::= Lbind
                       | Lbinds
                       | Rbind
                       | Rbinds

syntax         Lbind ::= NamePat "<-" Name

syntax        Lbinds ::= Lbind
                       | Lbind ";" Lbinds

syntax         Rbind ::= NamePat "<=" Name

syntax        Rbinds ::= Rbind
                       | Rbind ";" Rbinds

//--- Send/Output ---
syntax          Send ::= Name "!" Content

syntax       Content ::= "(" Proc ")"
                       | RhoTuple

//--- Evaluation ---
syntax          Eval ::= "*" Name

//--- Collections ---
syntax         KItem ::= Proc

syntax    Collection ::= RhoList
                       | RhoMap
                       | RhoSet
                       | RhoTuple

syntax         Procs ::= Proc
                       | Proc  "," Procs
                       | Procs "," Proc
                       | Procs "," Procs

syntax       RhoList ::= ".RhoList"
                       | "[" Procs "]"
                       | RhoList RhoList                              [left]

syntax        RhoMap ::= ".RhoMap"
                       | "{" RhoKVPairs "}"
                       | RhoMap RhoMap                                [left]

syntax    RhoKVPairs ::= Proc ":" Proc
                       | Proc ":" Proc "," RhoKVPairs
                       | RhoKVPairs    "," Proc ":" Proc
                       | RhoKVPairs    "," RhoKVPairs

syntax        RhoSet ::= ".RhoSet"                                            // multiset
                       | "Set" "(" Procs ")"
                       | RhoSet RhoSet                                [left]

syntax      RhoTuple ::= "(" Proc ",)"
                       | "(" Proc "," Procs ")"

//-------------
//--- NAMES ---
//-------------
syntax          Name ::= "{" Name "}"                              [bracket]
                       | "@" Proc
                       | NameVar

syntax         Names ::= Name
                       | Name  "," Names
                       | Names "," Name
                       | Names "," Names

//----------------
//--- PATTERNS ---
//----------------

//--- Process Patterns ---
syntax       ProcVar ::= Id

syntax      ProcVars ::= ProcVar
                       | ProcVar  "," ProcVars
                       | ProcVars "," ProcVar
                       | ProcVars "," ProcVars

syntax       ProcPat ::= "{" ProcPat "}"
                       | CollectionPat
                       | ProcVar
                       > EvalPat
                       > SendPat
                       | RecPat
                       > ParPat

//--- ParPat ---
syntax        ParPat ::= Proc    "|" ProcPat
                       | ProcPat "|" Proc
                       | ProcPat "|" ProcPat

//--- RecPat ---
syntax        RecPat ::= "for" "(" Receipt    ")" "{" ProcPat "}"      [binder]
                       | "for" "(" ReceiptPat ")" "{" Proc    "}"      [binder]
                       | "for" "(" ReceiptPat ")" "{" ProcPat "}"      [binder]

syntax    ReceiptPat ::= LbindPat
                       | LbindPats
                       | RbindPat
                       | RbindPats

syntax      LbindPat ::= NamePat "<-" NamePat

syntax     LbindPats ::= List{Lbind, ";"}

syntax      RbindPat ::= NamePat "<=" NamePat

syntax     RbindPats ::= List{Rbind, ";"}

//--- SendPat ---
syntax       SendPat ::= NamePat "!" "(" Content    ")"
                       | Name    "!" "(" ContentPat ")"
                       | NamePat "!" "(" ContentPat ")"

syntax    ContentPat ::= ProcPat
                       | PatTuple

//--- EvalPat ---
syntax       EvalPat ::= "*" NamePat

//--- PatTuple ---
syntax      PatTuple ::= List{ProcPat, ","}
*/
//--- Name Patterns ---
syntax       NameVar ::= #LowerId

syntax      NameVars ::= NameVar
                       | NameVar  "," NameVars
                       | NameVars "," NameVar
                       | NameVars "," NameVars

syntax       NamePat ::= NameVar
//                       | "@" ProcPat

syntax      NamePats ::= NamePat
                       | NamePat  "," NamePats
                       | NamePats "," NamePat
                       | NamePats "," NamePats

endmodule

module POLYRHO
  import POLYRHO-SYNTAX

  configuration
  <T color="purple">
    <k color="teal"> $PGM:Proc </k>
  </T>

//--- Collections ---

// RhoList
  rule L:RhoList .RhoList => L
  rule .RhoList L:RhoList => L
  rule [ P:Procs ] [ Q:Procs ] => [ P , Q ]

// RhoMap
  rule M:RhoMap .RhoMap => M
  rule .RhoMap M:RhoMap => M
  rule { K:RhoKVPairs } { L:RhoKVPairs } => { K , L }

// RhoSet
  rule S:RhoSet .RhoSet => S
  rule .RhoSet S:RhoSet => S
  rule Set( P:Procs ) Set( Q:Procs ) => Set( P , Q )

// RhoTuple


endmodule
