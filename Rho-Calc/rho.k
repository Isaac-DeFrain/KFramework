// RHO CALCULUS

require "substitution.k"

module RHO-SYNTAX
  import ID
  import DOMAINS
  import SUBSTITUTION


// NAMES
  syntax Name ::= "@" Proc                         [klabel(Quote)]     // Quote: Proc -> Name
                | Id                                                   // Id: -> Name (not needed)

// PROCESSES
  syntax Proc ::= "Nil"                            [klabel(Stop)]      // Stop: -> Proc
                | Name "(" Name ")"  "{" Proc "}"  [klabel(Rec)]       // Rec: Name*Name*Proc -> Proc
                | Proc "|" Proc                    [klabel(Par),left]  // Par: Proc*Proc -> Proc
                | Name "!" "(" Proc ")"            [klabel(Send)]      // Send: Name*Proc -> Proc
                | "*" Name                         [klabel(Reify)]     // Reify: Name -> Proc
                
// BRACKETS
  syntax Name ::= "{" Name "}"                     [bracket]
                | "(" Name ")"                     [bracket]

  syntax Proc ::= "{" Proc "}"                     [bracket]
                | "(" Proc ")"                     [bracket]

// PRECEDENCE
//  syntax priority Send Rec > Par

  syntax KVariable ::= Name

  syntax Val ::= Name                    //is this what I want?

endmodule

module RHO
  import RHO-SYNTAX
  import SUBSTITUTION

  configuration
    <T>
      <activity>
        <thread multiplicity="*">
          <k> $PGM:Proc </k>
          <procs>                        //input-guarded process pool
            <proc multiplicity="*">
              <cont> .K </cont>          //continuation to be further processed
              <bind> .Map </bind>        //Var |-> Loc, varible bindings in continuation
              <procid> 0 </procid>       //process identifier for bindings
            </proc>
          </procs>
        </thread>
      </activity>
      <incoming>
        <rec multiplicity="*">
          <inchan>                       
            .Map                         //map inChan |-> Loc, Loc connected to continuation from receive
          </inchan>
          <inchanid> .Map </inchanid>    //map inChan |-> procId
        </rec>
      </incoming>
      <outgoing>                         //sends
        <send multiplicity="*">          //many sends to the same channel
          <outchan> .Map </outchan>      //map outChan |-> Loc, 
          <outmsg> .Map </outmsg>        //map Msg |-> Loc, sent message waiting for matching inChan to comm
//          <outchanid> .Map </outchanid>  
        </send>
      </outgoing>
    </T>

  syntax KResult ::= Val                 //is this what I want?

// SEND SEMANTICS
//  rule <k> X:Name ! ( P:Proc ) =>  . ...</k>          //dissolve send and populate cells
//       (.Bag => <send>                                //create new send cell containing:
//                  <outchan> X |-> !L:Int </outchan>   //map outChan |-> Loc
//                  <msg> @P |-> !L </msg>              //map msg |-> Loc, message sent on Chan at Loc
//                </send>)  [structural]

// RECEIVE SEMANTICS
//  rule <k>  X:Name ( Y:Name ) { P:Proc } => . ...</k>  //dissolve receive and populate cells
//       (.Bag => <guard>
//                  <proc> P </proc>                     //P is a continuation
//                  <bind> Y |-> !L:Int </bind>          //location of variable which binds in P
//                </guard>)
//       (.Bag => <inchan> X |-> !L </inchan>)  [structural]

// PAR OPERATOR
//  rule <thread> <k> P | Q => . ...</k>

// SEND OPERATOR
// record outChan, outMsg

// REC OPERATOR
// record binding variable,

// REIFY OPERATOR
// move to process pool?

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

//  rule P:Proc | Nil => P  [structural]

//  rule (<guard> <proc> Nil </proc> <bind> _:Name |-> L:Int </bind> </guard> => .Bag)
//       (<inchan> _:Name |-> L </inchan> => .Bag)  [structural]

//  rule <k> Nil </k> => .  [structural]

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q

// REDUCTION RULES
// COMM EVENT
// inChan "matches" outChan
// COMM: `x(z){P} | y!(Q)` => P[@Q / z] when x \equiv_N y (denoted `x(z){P} | y!(Q)` -> P[@Q / Y])

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION
// [Y / X]: Name -> Name ...

// SEMANTIC SUBSTITUTION

// *(@P) \equiv P (instead of syntactic and semantic substitution? this is how it is in Rholang)
// rule * ( @ P:Proc ) => P  [structural]

endmodule
