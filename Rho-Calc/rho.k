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
//  syntax priority Send Rec > Par  //needed?

  syntax KVariable ::= Name

  syntax Val ::= Name  //needed?

endmodule

module RHO
  import RHO-SYNTAX
  import SUBSTITUTION

  configuration
    <T>
      <activity color="yellow">
        <thread multiplicity="*">
          <k> $PGM:Proc </k>
          <processes color="red">        //input-guarded processes
            <process multiplicity="*">
              <cont> .K </cont>          //continuation to be further processed
              <bind> .Map </bind>        //Var |-> Loc, varible bindings in continuation
              <procid> 0 </procid>       //process identifier for bindings
            </process>
          </processes>
        </thread>
      </activity>
      <tuplespace color="cyan">          //tuplespace for sends and receives
        <receives color="green">         //receives
          <receive multiplicity="*">
            <recchan>                       
              .Map                       //map inChan |-> Loc, Loc connected to continuation from receive
            </recchan>
            <recid> .Map </recid>        //map inChan |-> procId
          </receive>
        </receives>
        <sends color="blue">             //sends
          <send multiplicity="*">
            <sendchan> .Map </sendchan>  //map sendChan |-> Loc, 
            <msg> .Map </msg>            //map Msg |-> Loc, sent message waiting for matching recChan
//            <outchanid> .Map </outchanid>  
          </send>
        </sends>
      </tuplespace>
    </T>

  syntax KResult ::= Val

// SEND SEMANTICS
  rule <k> X:Name ! ( P:Proc ) =>  . ...</k>           //dissolve send and populate cells
       (.Bag => <send>                                 //create new send cell containing:
                  <sendchan> X |-> !L:Int </sendchan>  //map outChan |-> Loc
                  <msg> @P |-> !L </msg>               //map msg |-> Loc, message sent on Chan at Loc
                </send>)  [structural]

// RECEIVE SEMANTICS
  rule <k>  X:Name ( Y:Name ) { P:Proc } => . ...</k>  //dissolve receive and populate cells
       (.Bag => <process>
                  <cont> P </cont>                     //continuation P
                  <bind> Y |-> !L:Int </bind>          //location of variable which binds in P
                  <procid> !I:Int </procid>
                </process>)
       (.Bag => <receive> <recchan> X |-> !L </recchan> <recid> X |-> !I </recid> </receive>)  [structural]

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
