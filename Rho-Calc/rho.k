// RHO CALCULUS

require "substitution.k"

module RHO-SYNTAX
  import ID
  import DOMAINS
  import SUBSTITUTION


// NAMES
  syntax Name ::= "@" Proc                         [klabel(Quote)]          // Quote: Proc -> Name
                | Id                                                        // Id: -> Name (not needed)

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

// PRECEDENCE
//  syntax priority Send Rec > Par

  syntax KVariable ::= Name

endmodule

module RHO
  import RHO-SYNTAX
  import SUBSTITUTION

  configuration
    <T>
      <activity>
        <thread color="red" multiplicity="*">    //process pool
          <k> $PGM:Proc </k>
        </thread>
      </activity>
      <space color="cyan">                       //tuplespace
        <recs color="green">                     //receives
          <rec color="yellow" multiplicity="*">
            <rchan> .K </rchan>                  //receiving channel
            <bind> .K </bind>                    //varible binding in continuation
            <cont> .K </cont>                    //continuation
          </rec>
        </recs>
        <sends color="blue">                     //sends
          <send color="teal" multiplicity="*">
            <schan> .K </schan>                  //sending channel
            <msg> .K </msg>                      //message sent
          </send>
        </sends>
      </space>
    </T>

// PAR OPERATOR
  rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P1 </k> </thread>)
       (.Bag => <thread> <k> P2 </k> </thread>)

// SEND SEMANTICS
  rule <k> X:Name ! ( P:Proc ) =>  . ...</k>           //dissolve send in <activity/> and spawn <send/>
       (.Bag => <send>
                  <schan> X </schan>                   //sending channel X
                  <msg>  @P </msg>                     //message sent @P
                </send>)  [structural]

// RECEIVE SEMANTICS
  rule <k>  X:Name ( Y:Name ) { P:Proc } => . ...</k>  //dissolve receive in <activity/> and spawn <rec/>
       (.Bag => <rec>
                  <rchan> X </rchan>                   //receiving channel X
                  <bind>  Y </bind>                    //variable Y binding in continuation P
                  <cont>  P </cont>                    //continuation P
                </rec>) [structural]

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

  rule P:Proc | Nil => P  [structural]

  rule <cont> P:Proc | Nil => P </cont>  [structural]

  rule <thread> <k> . </k> </thread> => .Bag  [structural]

  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q

// REIFY OPERATOR
  rule <msg> @ * X:Name => X </msg>  [structural]

  rule * @ P:Proc => P  [structural]

  rule <cont> * @ P:Proc => P </cont>  [structural]

// REDUCTION RULES

// COMM
// Comm: x!(Q) | x(y){P} => P[@Q / y]
  rule                                            //dissolve send and receive on the same channel
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)  //spawn a new <thread/> holding P[Z / Y]
  (<rec>                                          //dissolve receive with:
     <rchan> X:Name </rchan>                      //receiving channel X
     <bind> Y:Name </bind>                        //binding variable Y
     <cont> P:Proc </cont>                        //continuation P
   </rec> => .Bag)
  (<send>                                         //dissolve send with:
     <schan> X </schan>                           //sending channel X = rceiving channel
     <msg> Z:Name </msg>                          //message sent Z to continuation
   </send> => .Bag)

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION

// SEMANTIC SUBSTITUTION

// rule * @ P:Proc => P  [structural]

endmodule
