// Red-Black Polyadic Rho Calculus

requires "domains.k"

module RBRHO-SYNTAX
  import DOMAINS

// Variables
  syntax     Var ::= Id
  syntax    Vars ::= Var
                   | Var "," Vars [right]

// Red Calculus
  syntax   ProcR ::= RedNil | RecR | SendR | EvalR > ParR

  syntax  RedNil ::= "NilR"
  syntax   SendR ::= NameR "!" "(" ProcRs ")"
  syntax    RecR ::= "for" "(" NameRs "<-" NameR ")" "{" ProcR "}"
  syntax   EvalR ::= "*" NameR
  syntax    ParR ::= ProcR "|" ProcR [right]

  // Red Procs
  syntax  ProcRs ::= ProcR
                   | ProcR "," ProcRs [right]

  // Red Names
  syntax   NameR ::= "@" ProcR | Var
  syntax  NameRs ::= NameR | Vars
                   | NameR "," NameRs [right]

// Black Calculus
  syntax   ProcB ::= BlkNil | RecB | SendB | EvalB > ParB

  syntax  BlkNil ::= "NilB"
  syntax   SendB ::= NameB "!" "(" ProcBs ")"
  syntax    RecB ::= "for" "(" NameBs "<-" NameB ")" "{" ProcB "}"
  syntax   EvalB ::= "*" NameB
  syntax    ParB ::= ProcB "|" ProcB [right]

  // Black Procs
  syntax  ProcBs ::= ProcB
                   | ProcB "," ProcBs [right]

  // Black Names
  syntax   NameB ::= "@" ProcB | Var
  syntax  NameBs ::= NameB | Vars
                   | NameB "," NameBs [right]

//--------------------------
//--- Red-Black Calculus ---
//--------------------------
  syntax  ProcRB ::= ProcB | ProcR
                   | RecRB | SendRB
                   > ParRB

  syntax  SendRB ::= SendB | SendR
                   | NameRB "!" "(" ProcRBs ")"
  syntax   RecRB ::= RecB | RecR
                   | "for" "(" NameRBs "<-" NameRB ")" "{" ProcRB "}"
  syntax  EvalRB ::= EvalB | EvalR
                   | "*" NameRB
  syntax   ParRB ::= ParB | ParR
                   | ProcRB "|" ProcRB [right]

  // Red-Black Procs
  syntax ProcRBs ::= ProcRB | ProcBs | ProcRs
                   | ProcB "," ProcRBs [right]
                   | ProcR "," ProcRBs [right]

  // Red-Black Procs
  syntax  NameRB ::= NameB  | NameR  | Var
  syntax NameRBs ::= NameRB | NameBs | NameRs | Vars
                   | NameB "," NameRBs [right]
                   | NameR "," NameRBs [right]

endmodule

module RBRHO
  import RBRHO-SYNTAX

endmodule
