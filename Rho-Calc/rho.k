// RHO CALCULUS

require "substitution.k"

module RHO-SYNTAX
  import ID
  import DOMAINS
  import SUBSTITUTION


// NAMES
  syntax Name ::= "@" Proc                         [klabel(Quote)]          // Quote: Proc -> Name
                | Id                                                        // Id: -> Name (only for convenience)

// PROCESSES
  syntax Proc ::= "Nil"                            [klabel(Stop)]           // Stop: -> Proc
                | Name "(" Name ")"  "{" Proc "}"  [klabel(Rec),binder(2)]  // Rec: Name*Name*Proc -> Proc
                | Proc "|" Proc                    [klabel(Par),left]       // Par: Proc*Proc -> Proc
                | Name "!" "(" Proc ")"            [klabel(Send)]           // Send: Name*Proc -> Proc
                | "*" Name                         [klabel(Reify)]          // Reify: Name -> Proc
                
// BRACKETS
  syntax Name ::= "{" Name "}"                     [bracket]
                | "(" Name ")"                     [bracket]

  syntax Proc ::= "{" Proc "}"                     [bracket]
                | "(" Proc ")"                     [bracket]

  syntax KVariable ::= Name

endmodule

module RHO
  import RHO-SYNTAX
  import SUBSTITUTION

  configuration
    <T>
      <processpool color="red">
        <thread multiplicity="*">                             //collection of threads
          <k> $PGM:Proc </k>                                  //programs and computations are process-based
        </thread>
      </processpool>                                          //tuplespace stores sends and receives
      <tuplespace color="blue">
        <outgoing color="teal">                               //**sends**
          <send color="cyan" multiplicity="*">                //there may be several, even on the same channel
            <schan> .K </schan>                               //sending channel
              <msg> .K </msg>                                 //message
          </send>
        </outgoing>                                           //**************
        <incoming color="green">                              //***receives***
          <rec color="yellow" multiplicity="*">               //
            <rchan> .K </rchan>                               //receiving channel (may be several on same channel)
             <bvar> .K </bvar>                                //binding varible in continuation
             <cont> .K </cont>                                //continuation
          </rec>
        </incoming>
      </tuplespace>
    </T>

// PAR OPERATOR SEMANTICS
  rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P1 </k> </thread>)
       (.Bag => <thread> <k> P2 </k> </thread>)               //[structural]

// SEND OPERATOR SEMANTICS
  rule <k> X:Name ! ( P:Proc ) =>  . ...</k>                  //dissolve send in <activity/> and spawn <send/>
       (.Bag => <send>
                  <schan> X </schan>                          //sending channel X
                  <msg>  @P </msg>                            //message sent @P
                </send>)                                      //[structural]

// RECEIVE OPERATOR SEMANTICS
  rule <k>  X:Name ( Y:Name ) { P:Proc } => . ...</k>         //dissolve Rec in <activity/> and spawn <rec/>
       (.Bag => <rec>
                  <rchan> X </rchan>                          //receiving channel X
                  <bvar>  Y </bvar>                           //variable Y binding in continuation P
                  <cont>  P </cont>                           //continuation P
                </rec>)                                       //[structural]

// REDUCTION RULES

// COMM EVENT
// Comm: x!(Q) | x(y){P} => P[@Q / y]
  rule                                                        //dissolve send and receive on "same" channel
  (<rec>                                                      //dissolve receive:
     <rchan> X:Name </rchan>                                  // channel X
      <bvar> Y:Name </bvar>                                   // binding variable Y
      <cont> P:Proc </cont>                                   // continuation P
   </rec> => .Bag)
  (<send>                                                     //dissolve send:
     <schan> X </schan>                                       // channel X
       <msg> Z:Name </msg>                                    // message Z
   </send> => .Bag)
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn single <thread/> holding sub P[Z / Y]
  [comm]                                                      //tagged "comm" for tracking nondeterminism

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

// Clean up parred expressions
  rule        P:Proc | Nil => P                 [structural]  //Nils in <k/>

  rule <cont> P:Proc | Nil => P </cont>         [structural]  //Nils in <cont/>

// Dissolve computationally meaningless threads
  rule  <thread> <k> .K </k> </thread> => .Bag  [structural]  //empty threads

  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)

// NAME REDUCTIONS
//context       @ * HOLE   => HOLE                            //write as single context reduction?

  rule    <msg> @ * X:Name => X </msg>          [structural]  //name equivalence in <msg/>

  rule  <rchan> @ * X:Name => X </rchan>        [structural]  //name equivalence in <rchan/>

  rule  <schan> @ * X:Name => X </schan>        [structural]  //name equivalence class rep in <schan/>

// *@ operator is idempotent [experimental]
//  context   * @ * @ HOLE   => * @ HOLE                      //write as single context reduction?
                                                              //split between contexts:
  rule        * @ * @ P:Proc => * @ P           [structural]  // in <k/>

  rule <cont> * @ * @ P:Proc => * @ P </cont>   [structural]  // in <cont/>

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION

// SEMANTIC SUBSTITUTION

endmodule
