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
      <activity color="red">
        <thread multiplicity="*">                             //process pool
          <k> $PGM:Proc </k>                                  //computations are process-based
        </thread>
      </activity>                                             //tuplespace a.k.a. where the magic happens
      <tuplespace color="blue">
        <sends color="teal">                                  //sends
          <send color="cyan" multiplicity="*">                //there may be several, on the same channel even
            <schan> .K </schan>                               //sending channel
            <msg>   .K </msg>                                 //message sent
          </send>
        </sends>
        <recs color="green">                                  //receives
          <rec color="yellow" multiplicity="*">               //there may be several, on the same channel even
            <rchan> .K </rchan>                               //receiving channel
            <bind>  .K </bind>                                //varible binding in continuation
            <cont>  .K </cont>                                //continuation of the receive
          </rec>
        </recs>
      </tuplespace>
    </T>

// PAR OPERATOR
  rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P1 </k> </thread>)
       (.Bag => <thread> <k> P2 </k> </thread>)               //[structural]

// SEND SEMANTICS
  rule <k> X:Name ! ( P:Proc ) =>  . ...</k>                  //dissolve send in <activity/> and spawn <send/>
       (.Bag => <send>
                  <schan> X </schan>                          //sending channel X
                  <msg>  @P </msg>                            //message sent @P
                </send>)                                      //[structural]

// RECEIVE SEMANTICS
  rule <k>  X:Name ( Y:Name ) { P:Proc } => . ...</k>         //dissolve Rec in <activity/> and spawn <rec/>
       (.Bag => <rec>
                  <rchan> X </rchan>                          //receiving channel X
                  <bind>  Y </bind>                           //variable Y binding in continuation P
                  <cont>  P </cont>                           //continuation P
                </rec>)                                       //[structural]

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

  rule P:Proc | Nil => P                        [structural]  //dissolve parred Nils in <k/>

  rule <cont> P:Proc | Nil => P </cont>         [structural]  //dissolve parred Nils in continuations

  rule <thread> <k> . </k> </thread> => .Bag    [structural]  //dissolve empty threads

  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //dissolve Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)

// REIFY OPERATOR (can contexts be used here? * @ []:Proc and @ * []:Name)
  rule <msg> @ * X:Name => X </msg>             [structural]  //name equivalence in <msg/>

  rule <rchan> @ * X:Name => X </rchan>         [structural]  //name equivalence in <rchan/>

  rule <schan> @ * X:Name => X </schan>         [structural]  //name equivalence in <schan/>

  rule * @ P:Proc => P                          [structural]  //inverse operator in <k/>

  rule <cont> * @ P:Proc => P </cont>           [structural]  //inverse operator in <cont/>

// REDUCTION RULES

// COMM EVENT (comm tag to track nondeterminism?)
// Comm: x!(Q) | x(y){P} => P[@Q / y]
  rule                                                        //dissolve send and receive on "same" channel
  (<rec>                                                      //dissolve receive with:
     <rchan> X:Name </rchan>                                  //receiving channel X
     <bind>  Y:Name </bind>                                   //binding variable Y
     <cont>  P:Proc </cont>                                   //continuation P
   </rec> => .Bag)
  (<send>                                                     //dissolve send with:
     <schan> X </schan>                                       //send on channel X
     <msg>   Z:Name </msg>                                    //Z is message sent to continuation
   </send> => .Bag)
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawns a new <thread/> holding P[Z / Y]
  [comm]

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION?

// SEMANTIC SUBSTITUTION?

endmodule
