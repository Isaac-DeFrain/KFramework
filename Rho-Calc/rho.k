// RHO CALCULUS

require "substitution.k"

module RHO-SYNTAX
  import ID
  import DOMAINS
//  import SUBSTITUTION


// NAMES
  syntax Name ::= "@" Proc                         [klabel(Quote)]     // Quote: Proc -> Name
                | Id                                                   // Id: -> Name (not needed)

// PROCESSES
//receive is singled out so we can assign KResult ::= Nam Rec
  syntax Rec  ::= Name "(" Name ")"  "{" Proc "}"  [klabel(Rec)]       // Rec: Name*Name*Proc -> Proc

  syntax Proc ::= "Nil"                            [klabel(Stop)]      // Stop: -> Proc
                | Proc "|" Proc                    [klabel(Par),left]  // Par: Proc*Proc -> Proc
                | Name "!" "(" Proc ")"            [klabel(Send)]      // Send: Name*Proc -> Proc
                | "*" Name                         [klabel(Reify)]     // Reify: Name -> Proc
                | Rec
                
// BRACKETS
  syntax Name ::= "{" Name "}"                     [bracket]
                | "(" Name ")"                     [bracket]

  syntax Proc ::= "{" Proc "}"                     [bracket]
                | "(" Proc ")"                     [bracket]

// PRECEDENCE needs to be fixed
  syntax priority Send Rec > Par

  syntax KVariable ::= Name

  syntax Val ::= Name             //is this what I want?

endmodule

module RHO
  import RHO-SYNTAX
  import SUBSTITUTION

  configuration
    <T>
      <threads>
        <thread multiplicity="*">     //kepping track of pars/concurrency (process pool)
          <k> $PGM:Proc </k>
          <procs>                     //input-guarded processes i.e. continuations
            <proc multiplicity="*">
              <pool> .Map </pool>     //continuation
              <pchan> .Map </pchan>   //map inChan |-> Loc tagging continuation
              <bind> .Map </bind>     //Var |-> Loc, varible bindings in continuation
              <depth> 0 </depth>      //how many levels down?
            </proc>
          </procs>
        </thread>          
      </threads>
      <recs>                          //receives/incoming
        <inmail multiplicity="*">     //receives on some channel
          <inchan> .Map </inchan>     //map inChan |-> Loc, 
          <inmsg> .Map </inmsg>       //map Msg |-> Loc, message waiting for inChan
        </inmail>
      </recs>
      <sends>                         //sends/outgoing
        <outmail multiplicity="*">    //many sends to the same channel
          <outchan> .Map </outchan>   //map outChan |-> Loc, 
          <outmsg> .Map </outmsg>     //map Msg |-> Loc, sent message waiting for outChan
        </outmail>
      </sends>
    </T>

  syntax KResult ::= Val | Rec  //is this what I want?

// SEND SEMANTICS
  rule <k> X:Name ! ( P:Proc ) =>  . ...</k>           //dissolve send and populate cells
       <pool>... . => X!(P) |-> !L:Int </pool>
       <outchan>... . =>  X |-> !L </outchan>
       <outmsg>...  . => @P |-> !L </outmsg>  [structural]

// RECEIVE SEMANTICS
  rule <k>  X:Name ( Y:Name ) { P:Proc } => . ...</k>  //dissolve receive and poulated cells
       <pool>...  . => P |-> !L:Int </pool>            //P is a continuation
       <pchan>... . => X |-> !L </pchan>               //location of channel
       <bind>...  . => Y |-> !L </bind>                //location of variable which binds in P
       <depth>    I => I +Int 1 </depth>               //depth(P) = depth(X(Y){P}) + 1
       <inchan>...  . => X |-> !L </inchan>   [structural]

// PAR OPERATOR
// create new thread?

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

//  rule <thread> <k> Nil </k> ...</thread> => .Bag  [structural]

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

// *(@P) \equiv P (instead of syntactic and semantic substitution?)
// rule * ( @ P:Proc ) => P  [structural]

endmodule
