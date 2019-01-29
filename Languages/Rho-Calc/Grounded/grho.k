// RHO CALCULUS with additional Ground terms

require "domains.k"
require "substitution.k"

module GRHO-SYNTAX
import DOMAINS
import SET
import SUBSTITUTION


//-------------
//--- NAMES ---
//-------------
syntax       Var ::= Id

syntax      Name ::= Var                                           // Var: Id     -> Name (Name variable)
                   | "@" Proc                            [strict]  // Quote: Proc -> Name
                   | "{" Name "}"                       [bracket]

//-----------------
//--- PROCESSES ---
//-----------------
syntax      Proc ::= "{" Proc "}"                       [bracket]
                   | "Nil"                                         // Stop: -> Proc
                   | Ground                                        // Bool, Int, String
                   | Exp                                           // Bool, Int, String expressions
                   | Receive                                       // Receive
                   | Send                                          // Send
                   | Reify                                         // Reify/evaluate
                   > Par                                           // Par

syntax       Par ::= Proc "|" Proc                         [left]  // Par: Proc*Proc -> Proc

syntax   Receive ::= Name "(" Name ")"  "{" Proc "}"  [binder(2)]  // Rec: Name*Name*Proc -> Proc

syntax      Send ::= Name "!" "(" Proc ")"            [strict(2)]  // Send: Name*Proc -> Proc

syntax     Reify ::= "*" Name

syntax       Set ::= "FN(" Proc ")"

// Sets
syntax      Proc ::= Set
                   | "(" Set ")"                        [bracket]
                   | Set "+" Set                         [strict]
                   | Set "-" Set                         [strict]

// GROUND TERMS
syntax    Ground ::= Int | Bool | String                           //Int, Bool, and String ground terms

// Expressions - resolve to ground term
syntax       Exp ::= AExp | BExp

// Arithmetic
syntax      AExp ::= Int
                   | "(" AExp ")"
                   | Reify                    //for interesting message passing: x(y){ *y + 5 }
                   | String                   // S1 + S2 => S1 +String S2
                   | AExp "+" AExp  [strict]
                   | AExp "*" AExp  [strict]

// Boolean
syntax      BExp ::= Bool
                   | "(" BExp ")"
                   | Reify
                   | String
                   | AExp "<=" AExp  [seqstrict]
                   | "not" BExp         [strict]
                   | BExp "&&" BExp  [strict(1)]

// Alpha Equivalence
syntax      Bool ::= Set "==" Set

// Structural Equivalence
syntax      Bool ::= Proc "equiv" Proc   [left]

//syntax KVariable ::= Name

syntax     KItem ::= Name

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

syntax KResult ::= Ground | Reify | Set

// Arithmetic
rule I1:Int + I2:Int => I1 +Int I2
rule I1:Int * I2:Int => I1 *Int I2

// Boolean
rule I1:Int <= I2:Int => I1 <=Int I2
rule not B:Bool => notBool B
rule true && B:Bool => B
rule false && _ => false

// Set
rule S1:Set + S2:Set => S1 S2
rule S1:Set - S2:Set => S1 -Set S2

// String
rule S1:String + S2:String => S1 +String S2

// Free & Bound Names
rule FN( Nil )      => .Set
rule FN( _:Bool   ) => .Set
rule FN( _:Int    ) => .Set
rule FN( _:String ) => .Set

rule FN( X:Name ( Y:Name )  { P:Proc } ) => SetItem(X) + (FN(P) -Set SetItem(Y))

rule FN( X:Name ! ( P:Proc ) )  => SetItem(X) + FN(P)

rule FN( P:Proc | Q:Proc )      => FN(P) + FN(Q)

rule FN( * X:Name )             => SetItem(X)

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
rule    Nil | P:Proc => P                       [anywhere]
rule P:Proc | Nil    => P                       [anywhere]

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

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION

// SEMANTIC SUBSTITUTION

rule P1:Proc equiv P2:Proc => P1 ==K P2

endmodule
