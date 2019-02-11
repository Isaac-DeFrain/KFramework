// Polyadic Rho-Calculus

require "domains.k"
require "kast.k"
require "substitution.k"

module POLYRHO-SYNTAX
  import DOMAINS
  import KAST
  import KSEQ-SYMBOLIC
  import SUBSTITUTION

//-----------------
//--- PROCESSES ---
//-----------------

//--- Processes ---
syntax          Proc ::= "{" Proc "}"                              [bracket]
                       | "Nil"
                       | RhoTuple
                       > Eval
                       > Send
                       | Rec
                       > Par

//--- Par ---
syntax           Par ::= List{Proc, "|"}

//--- Receive ---
syntax           Rec ::= "for" "(" Receipt ")" "{" Proc "}"         [binder]

syntax       Receipt ::= Lbind
                       | Lbinds
                       | Rbind
                       | Rbinds

syntax         Lbind ::= NamePat "<-" Name

syntax        Lbinds ::= List{Lbind, ";"}

syntax         Rbind ::= NamePat "<=" Name

syntax        Rbinds ::= List{Rbind, ";"}

//--- Send ---
syntax          Send ::= Name "!" "(" Content ")"

syntax       Content ::= Proc
                       | RhoTuple

//--- Evaluate ---
syntax          Eval ::= "*" Name

//--- Tuple ---
syntax      RhoTuple ::= List{Proc, ","}

//-------------
//--- NAMES ---
//-------------
syntax          Name ::= "{" Name "}"                              [bracket]
                       | "@" Proc

syntax         Names ::= List{Name, ","}

//----------------
//--- PATTERNS ---
//----------------

//--- Process Patterns ---
syntax       ProcVar ::= Id

syntax      ProcVars ::= List{ProcVar, ","}

syntax       ProcPat ::= "{" ProcPat "}"
                       | Proc
                       | PatTuple
                       | ProcVar
                       > EvalPat
                       > SendPat
                       | RecPat
                       > ParPat

//--- ParPat ---
syntax        ParPat ::= List{ProcPat, "|"}

//--- RecPat ---
syntax        RecPat ::= "for" "(" Receipt    ")" "{" ProcPat "}"      [binder]
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

//--- Name Patterns ---
syntax       NameVar ::= #LowerId

syntax      NameVars ::= List{NameVar, ","}

syntax       NamePat ::= NameVar
                       | "@" ProcPat

syntax      NamePats ::= List{NamePat, ","}

endmodule

module POLYRHO
  import POLYRHO-SYNTAX

  configuration
  <T color="purple">
    <k color="teal"> $PGM:ProcPat </k>
  </T>

endmodule
