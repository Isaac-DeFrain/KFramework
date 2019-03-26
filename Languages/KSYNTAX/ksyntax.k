// K Syntax testing

require "domains.k"
require "kast.k"

module KSYNTAX-SYNTAX
  import DOMAINS
  import KAST
  import KSEQ-SYMBOLIC

  syntax   Exp ::= Cell
                 | AExp
                 | BExp
                 | OExp
                 | "(" Exp ")"                             [bracket]
                 | "if" BExp "then" Exp "else" Exp "fi"  [strict(1)]

  syntax Other ::= List{Int,","}                      // no unit modularity...
                 | "(" Other ")"           [bracket]

  syntax  BExp ::= Bool                               //   Bool < BExp
                 | "(" BExp ")"            [bracket]  //     (_): BExp ----------> BExp
                 |          "not" BExp      [strict]  //     not: BExp ----------> BExp
                 | AExp     "leq" AExp   [seqstrict]  //     leq: AExp x AExp ---> AExp
                 | Exp   "equals" Exp       [strict]  //  equals: Exp  x Exp ----> BExp
                 | BExp     "and" BExp   [strict(1)]  //     and: BExp x BExp ---> BExp
                 | BExp      "or" BExp   [strict(1)]  //      or: BExp x BExp ---> BExp
                 | BExp "implies" BExp   [strict(1)]  // implies: BExp x BExp ---> BExp

  syntax  AExp ::= Int                                //    Int < AExp
                 | "(" AExp ")"            [bracket]  //     (_): AExp ----------> AExp
                 | AExp "*" AExp         [seqstrict]  //     _*_: AExp x AExp ---> AExp
                 | AExp "+" AExp         [seqstrict]  //     _+_: AExp x AExp ---> AExp
                 | AExp "-" AExp         [seqstrict]  //     _-_: AExp x AExp ---> AExp

  syntax  OExp ::= Other                              //  Other < OExp
                 | "(" OExp ")"            [bracket]  //     (_): OExp ----------> OExp
                 > OExp "+" OExp                      //     _+_: OExp x OExp ---> OExp

  syntax  Cell ::= "function1(" Int ")"   [function]  // 

  syntax   Set ::= "Meta" "(" Exp ")"     [function]  // metavariables

endmodule

module KSYNTAX
  import KSYNTAX-SYNTAX

  syntax KResult ::= Bool | Int | Other
  
  configuration
  <T>
    <a> .K </a>
    <b>
      <k multiplicity="*"> $PGM:K </k>
    </b>
  </T>

// Arithmetic Expressions
  rule I1:Int * I2:Int  => I1 *Int I2
  rule I1:Int + I2:Int  => I1 +Int I2
  rule I1:Int - I2:Int  => I1 -Int I2

// Boolean Expressions
  rule not true  => false
  rule not false => true

  rule I1:Int leq I2:Int => I1 <=Int I2

  rule B1:Bool  equals B2:Bool  => B1 ==Bool B2
  rule I1:Int   equals I2:Int   => I1 ==Int I2
  rule .Other   equals .Other   => true
  rule A1:Other equals A2:Other => A1 ==K A2

  rule false and _:Bool => false
  rule true  and B:Bool => B

  rule true   or _:Bool => true
  rule false  or B:Bool => B

  rule false implies _:Bool => true
  rule true  implies B:Bool => B

// Conditional
  rule if true  then X:Exp else _:Exp fi => X
  rule if false then _:Exp else Y:Exp fi => Y
  
// Cell Functions
  rule function1(I:Int) => <a> I </a>
  
  rule <k> <a> A:Int => . ...</a> </k>
       (.Bag => <k> A </k>)

endmodule

/*
Notes:
The following syntax does not work:

  syntax Other ::= ".Empty"
                 | Id
                 | Id "," Other

Use builtin List{Id} (or List{Id,","}) instead.

--------------------------------------------------------------
Also,
  syntax #KVariable ::= Exp

Output:
[Error] Internal: Uncaught exception thrown of type CircularityException.
Please rerun your program with the --debug flag to generate a stack trace, and
file a bug report at https://github.com/kframework/k/issues (Exp < #KVariable < KBott < Exp)

*/