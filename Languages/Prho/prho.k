// PROCESS-ONLY RHO CALCULUS

require "substitution.k"

module PRHO-SYNTAX
  import ID
  import DOMAINS
  import SUBSTITUTION

// Variables
  syntax       Var ::= Id

// PROCESSES
  syntax      Proc ::= "Nil"                                                    // Nil: ----------------> Proc
                     | Var                                                      // Var: Id -------------> Proc
                     | Receive
                     | Send
                     > Par

  syntax       Par ::= Proc  "|" Proc                                   [left]  // Par: Proc*Proc ------> Proc

  syntax   Receive ::= "for" "(" Proc "<-" Proc ")"  "{" Proc "}"  [binder(2)]  // Receive: Proc*Proc*Proc -> Proc

  syntax      Send ::= "(" Proc ")" "!" "(" Proc ")"                            // Send: Proc*Proc ---------> Proc

  syntax KVariable ::= Proc

endmodule

module PRHO
import PRHO-SYNTAX
import SUBSTITUTION

  configuration
  <T>
    <threadpool color="red">
      <thread multiplicity="*">                               //computation threads
        <k> $PGM:Proc </k>                                    //programs and computations are process-based
      </thread>                                               //
    </threadpool>                                             //tuplespace stores sends and receives
    <tuplespace color="blue">                                 //
      <sends color="teal">                                    //**sends**
        <send color="cyan" multiplicity="*">                  //
          <schan> .K </schan>                                 //sending channel (many messages on same channel)
          <msg>   .K   </msg>                                 //message
        </send>                                               //
      </sends>                                                //
      <receives color="green">                                //**receives**
        <rec color="yellow" multiplicity="*">                 //
          <rchan> .K </rchan>                                 //receiving channel (many messages on same channel)
          <bvar>  .K  </bvar>                                 //binding varible in continuation
          <cont>  .K  </cont>                                 //continuation
        </rec>
      </receives>
    </tuplespace>
  </T>

// PAR OPERATOR SEMANTICS
  rule <thread> <k> P | Q => . ...</k> </thread>
       (.Bag => <thread> <k> P </k> </thread>)
       (.Bag => <thread> <k> Q </k> </thread>)  [structural]

// SEND OPERATOR SEMANTICS
  rule <k> ( X:Proc ) ! ( P:Proc ) =>  . ...</k>              //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>
                  <schan> X </schan>                          //sending channel X
                  <msg>   P   </msg>                          //message sent P
                </send>)                        [structural]

// RECEIVE OPERATOR SEMANTICS
  rule <k>  for ( Y:Proc <- X:Proc ) { P:Proc } => . ...</k>  //dissolve Rec in <threadpool/> and spawn <rec/>
       (.Bag => <rec>
                  <rchan> X </rchan>                          //receiving channel X
                  <bvar>  Y  </bvar>                          //variable Y binding in continuation P
                  <cont>  P  </cont>                          //continuation P
                </rec>)                         [structural]

// REDUCTION RULES

// COMM EVENT
// Comm: x!(Q) | x(y){P} => P[@Q / y]
  rule                                                        //dissolve send and receive on "same" channel
  (<rec>                                                      //dissolve receive:
     <rchan> X:Proc </rchan>                                  // channel X
     <bvar>  Y:Proc  </bvar>                                  // binding variable Y
     <cont>  P:Proc  </cont>                                  // continuation P
   </rec> => .Bag)
  (<send>                                                     //dissolve send:
     <schan> X    </schan>                                    // channel X
     <msg>   Z:Proc </msg>                                    // message Z
   </send> => .Bag)
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn single <thread/> holding sub P[Z / Y]
  [comm]                                                      //tagged "comm" for tracking nondeterminism

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

// Clean up parred expressions
  rule P:Proc | Nil => P                          [anywhere]

// Dissolve computationally meaningless threads
  rule  <thread> <k> .K </k> </thread> => .Bag  [structural]  //empty threads

  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //Nil threads

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION

// SEMANTIC SUBSTITUTION

endmodule
