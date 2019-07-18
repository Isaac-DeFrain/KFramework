// IMP: Simple Imperative Language

require "domains.k"

// SYNTAX MODULE
module IMP-SYNTAX
  import DOMAINS-SYNTAX

  syntax   Exp ::= Id
                 | Int
                 | Exp "*" Exp               [left, strict]
                 | Exp "/" Exp               [left, strict]
                 > Exp "+" Exp               [left, strict]
                 | Exp "-" Exp               [left, strict]
                 | "(" Exp ")"                    [bracket]

  syntax  Stmt ::= Id "=" Exp ";"               [strict(2)]
                 | "if" "(" Exp ")" Stmt Stmt   [strict(1)]
                 | "while" "(" Exp ")" Stmt
                 | "{" Stmt "}"                   [bracket]
                 | "{" "}"
                 > Stmt Stmt                         [left]

  syntax  Pgm ::= "int" Ids ";" Stmt

  syntax  Ids ::= List{Id, ","}

endmodule

// SEMANTICS MODULE
module IMP
  import IMP-SYNTAX
  import DOMAINS

  syntax KResult ::= Int

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">
      <k> $PGM:Pgm </k>
      <state> .Map </state>
    </T>

  rule <k> X:Id => I ...</k>
       <state>...  X |-> I ...</state>

  rule A:Int * B:Int => A *Int B
  rule A:Int / B:Int => A /Int B requires B =/=Int 0
  rule A:Int + B:Int => A +Int B
  rule A:Int - B:Int => A -Int B

  rule <k> X:Id = I:Int ;  => . ...</k>
       <state>... X |-> (_ => I) </state>

  rule S:Stmt T:Stmt => S ~> T                    [structural]

  rule if (I) S _ => S  requires I =/=Int 0
  rule if (0) _ S => S

  rule while (B) S => if (B) {S while(B) S} { }   [structural]

  rule { } => .

// initialize unassigned variables with value 0
  rule <k> int (X , Xs => Xs) ; S    </k>
       <state>... (  . => X |-> 0) </state>       [structural]

  rule int .Ids ; S => S                          [structural]

endmodule
