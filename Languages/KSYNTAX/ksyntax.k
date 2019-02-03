/*
K ::= K "#as" K                              [klabel(#KAs), symbol, poly(0, 1, 2)]

  // functions that preserve sorts and can therefore have inner rewrites
K ::= "#fun" "(" K ")" "(" K ")"             [klabel(#fun2), symbol, poly(0, 1, 2), prefer]

  // functions that do not preserve sort and therefore cannot have inner rewrites
K ::= "#fun" "(" K "=>" K ")" "(" K ")"      [klabel(#fun3), symbol, poly(0, 2; 1, 3)]

Bool ::= left:  K  "==K" K                   [function, functional, smtlib(=), hook(KEQUAL.eq), klabel(_==K_), symbol, latex({#1}\mathrel{=_K}{#2}), equalEqualK]
       |        K "=/=K" K                   [function, functional, smtlib(distinct), hook(KEQUAL.ne), klabel(_=/=K_), symbol, latex({#1}\mathrel{\neq_K}{#2}), notEqualEqualK]

  rule K1:K =/=K K2:K => notBool (K1 ==K K2)
  rule K1:Bool ==Bool K2:Bool =>  K1 ==K K2

K ::= "#if" Bool "#then" K "#else" K "#fi"   [function, functional, smtlib(ite), hook(KEQUAL.ite), poly(0, 2, 3)]

  rule #if C:Bool #then B1 #else _ #fi => B1 requires C
  rule #if C:Bool #then _ #else B2 #fi => B2 requires notBool C

KItem ::= #fresh(String)                         [function, hook(KREFLECTION.fresh), impure]

String ::= #sort(K)                              [function, hook(KREFLECTION.sort)]
         | #getenv(String)
*/

require "domains.k"
require "kast.k"

module KSYNTAX-SYNTAX
import DOMAINS
import KAST

syntax   Exp ::= AExp
               | BExp
               | OExp
               | "(" Exp ")"                             [bracket]
               | "if" BExp "then" Exp "else" Exp "fi"  [strict(1)]

syntax Other ::= List{Id,","}
               | "(" Other ")"

syntax  BExp ::= Bool                               //   Bool < BExp
               | "(" BExp ")"            [bracket]  //     (_): BExp ----------> BExp
               |          "not" BExp      [strict]  //     not: BExp ----------> BExp
               | AExp     "leq" AExp   [seqstrict]  //     leq: AExp x AExp ---> AExp
               | Exp   "equals" Exp       [strict]  //  equals: Exp  x Exp ----> BExp
               | BExp     "and" BExp   [strict(1)]  //     and: BExp x BExp ---> BExp
               > BExp      "or" BExp   [strict(1)]  //      or: BExp x BExp ---> BExp
               > BExp "implies" BExp   [strict(1)]  // implies: BExp x BExp ---> BExp

syntax  AExp ::= Int                                 //   Int < AExp
               | "(" AExp ")"            [bracket]   //    (_): AExp ----------> AExp
               > AExp  "*" AExp        [seqstrict]   //    _*_: AExp x AExp ---> AExp
               > AExp  "+" AExp        [seqstrict]   //    _+_: AExp x AExp ---> AExp
               | AExp  "-" AExp        [seqstrict]   //    _-_: AExp x AExp ---> AExp

syntax  OExp ::= Other                               // Other < OExp
               | "(" OExp ")"            [bracket]   //    (_): OExp ----------> OExp
               > OExp "+" OExp         [seqstrict]   //    _+_: OExp x OExp ---> OExp
//             | OExp "-" OExp         [seqstrict]   //    _-_: OExp x OExp ---> OExp


/* This syntax does not work!!! Use builtin List{Id} instead.
syntax Other ::= ".Empty"
               | "(" Other ")"           [bracket]
               | Id
               | Id "," Other
*/

endmodule

module KSYNTAX
import KSYNTAX-SYNTAX

syntax KResult ::= Bool | Int | Other

// Arithmetic Expressions
rule I1:Int  * I2:Int  => I1 *Int I2
rule I1:Int  + I2:Int  => I1 +Int I2
rule I1:Int  - I2:Int  => I1 -Int I2

// Boolean Expressions
rule not true  => false
rule not false => true

rule I1:Int    leq I2:Int => I1 <=Int I2

rule B1:Bool          equals B2:Bool          => B1 ==Bool B2
rule I1:Int           equals I2:Int           => I1 ==Int I2
rule .Other           equals .Other           => true
rule A1:Id            equals A2:Id            => A1 ==K A2
rule A1:Id , A2:Other equals B1:Id , B2:Other => A1 ==K B1 and A2 ==K B2

rule false     and _:Bool => false
rule true      and B:Bool => B

rule true       or _:Bool => true
rule false      or B:Bool => B

rule false implies _:Bool => true
rule true  implies B:Bool => B

// Other Expressions
rule   .Other         + X:Other => X
rule  X:Other         +  .Other => X
rule  X:Id            + Y:Other => X , Y        [strict]
rule X1:Id , X2:Other + Y:Other => X1 , X2 + Y  [strict]

/*
rule   .Other         -  _:Other         => .Other
rule  X:Other         -   .Other         => X
rule  X:Id , .Other   -  Y:Id            => if (X  ==K Y ) then .Other else X  , .Other     fi  [strict]
rule X1:Id , X2:Other -  Y:Id            => if (X1 ==K Y ) then  X2    else X1 , ( X2 - Y ) fi  [strict]
rule  X:Other         - Y1:Id , Y2:Other => ( X - Y1 ) - Y2                                     [strict]
rule ( X1:Other - Y:Id ) , X2:Other      =>
*/

rule  X:Id , .Other =>  X

// Conditional
rule if true  then X:Exp else _:Exp fi => X
rule if false then _:Exp else Y:Exp fi => Y

rule ( ( E:Exp ) ) => ( E )


endmodule
