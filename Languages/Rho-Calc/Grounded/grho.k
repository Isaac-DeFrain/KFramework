// RHO CALCULUS with additional Ground terms

require "substitution.k"

module GRHO-SYNTAX
  import ID
  import DOMAINS
  import SUBSTITUTION


// NAMES
syntax      Name ::= "@" Proc                                        [strict]  // Quote: Proc -> Name
                   | Id                                                        // Id: -> Name (only for convenience)

// PROCESSES
syntax      Proc ::= "Nil"                                                     // Stop: -> Proc
                   | Ground
                   | Exp
                   | Name "(" Name ")"  "{" Proc "}"              [binder(2)]  // Rec: Name*Name*Proc -> Proc
                   | Name "!" "(" Proc ")"                        [strict(2)]  // Send: Name*Proc -> Proc
                   > Proc "|" Proc                                     [left]  // Par: Proc*Proc -> Proc

syntax Reify ::= "*" Name

// GROUND TERMS
syntax    Ground ::= Int | Bool | String                                       //Int, Bool, and String ground terms
                
// BRACKETS
syntax      Name ::= "{" Name "}"                     [bracket]
                   | "(" Name ")"                     [bracket]

syntax      Proc ::= "{" Proc "}"                     [bracket]
                   | "(" Proc ")"                     [bracket]

// Expressions - resolve to ground term
syntax Exp ::= AExp | BExp

// Arithmetic
syntax AExp ::= Int
              | "(" AExp ")"
              | Reify
              | String
              | AExp "+" AExp  [strict]
              | AExp "*" AExp  [strict]

// Boolean
syntax BExp ::= Bool
              | "(" BExp ")"
              | Reify
              | String
              | AExp "<=" AExp  [seqstrict]
              | "not" BExp         [strict]
              | BExp "&&" BExp  [strict(1)]

syntax KVariable ::= Name

endmodule


module GRHO
  import GRHO-SYNTAX
  import SUBSTITUTION

  configuration
    <T>
      <threadpool color="red">
        <thread multiplicity="*">                             //collection of threads
          <k> $PGM:Proc </k>                                  //programs and computations are process-based
        </thread>                                             //
      </threadpool>                                           //tuplespace stores sends and receives
      <tuplespace color="blue">                               //
        <sends color="teal">                                  //**sends**
          <send color="cyan" multiplicity="*">                //
            <schan> .K </schan>                               //sending channel (many messages on same channel)
            <msg>   .K   </msg>                               //message
          </send>                                             //
        </sends>                                              //
        <receives color="green">                              //**receives**
          <rec color="yellow" multiplicity="*">               //
            <rchan> .K </rchan>                               //receiving channel (many messages on same channel)
            <bvar>  .K  </bvar>                               //binding varible in continuation
            <cont>  .K  </cont>                               //continuation
          </rec>
        </receives>
      </tuplespace>
    </T>

syntax KResult ::= Ground

// Arithmetic
rule I1:Int + I2:Int => I1 +Int I2
rule I1:Int * I2:Int => I1 *Int I2

// String
rule S1:String + S2:String => S1 +String S2

// Boolean
rule I1:Int <= I2:Int => I1 <=Int I2
rule not B:Bool => notBool B
rule true && B:Bool => B
rule false && _ => false

// PAR OPERATOR SEMANTICS
rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>
     (.Bag => <thread> <k> P1 </k> </thread>)
     (.Bag => <thread> <k> P2 </k> </thread>)                 //[structural]

// SEND OPERATOR SEMANTICS
rule <k> X:Name ! ( P:Ground ) =>  . ...</k>                  //dissolve send in <threadpool/> and spawn <send/>
     (.Bag => <send>
                <schan> X </schan>                            //sending channel X
                <msg>  @P   </msg>                            //message sent @P
              </send>)                                        //[structural]

// RECEIVE OPERATOR SEMANTICS
rule <k>  X:Name ( Y:Name ) { P:Proc } => . ...</k>           //dissolve Rec in <threadpool/> and spawn <rec/>
     (.Bag => <rec>
                <rchan> X </rchan>                            //receiving channel X
                <bvar>  Y  </bvar>                            //variable Y binding in continuation P
                <cont>  P  </cont>                            //continuation P
              </rec>)                                         //[structural]

// REDUCTION RULES

// COMM EVENT
// Comm: x!(Q) | x(y){P} => P[@Q / y]
rule                                                          //dissolve send and receive on "same" channel
(<rec>                                                        //dissolve receive:
   <rchan> X:Name </rchan>                                    // channel X
   <bvar>  Y:Name  </bvar>                                    // binding variable Y
   <cont>  P:Proc  </cont>                                    // continuation P
 </rec> => .Bag)
(<send>                                                       //dissolve send:
   <schan> X    </schan>                                      // channel X
   <msg>   Z:Name </msg>                                      // message Z
 </send> => .Bag)
(.Bag => <thread> <k> P[Z / Y] </k> </thread>)                //spawn single <thread/> holding sub P[Z / Y]
[comm]                                                        //tagged "comm" for tracking nondeterminism

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

// Clean up parred expressions
//context HOLE | Nil
//context Nil | HOLE
rule        P:Proc | Nil => P                 [structural]  //Nils in <k/>

rule <cont> P:Proc | Nil => P </cont>         [structural]  //Nils in <cont/>

// Dissolve computationally meaningless threads
rule  <thread> <k> .K </k> </thread> => .Bag  [structural]  //empty threads

rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)

// NAME REDUCTIONS
rule   @ * N:Name => N                          [anywhere]

// INVERSES
rule   * @ P:Proc => P                          [anywhere]
//  rule        * @ * @ P:Proc => * @ P           [structural]  // in <k/>

//  rule <cont> * @ * @ P:Proc => * @ P </cont>   [structural]  // in <cont/>

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION

// SEMANTIC SUBSTITUTION

endmodule
