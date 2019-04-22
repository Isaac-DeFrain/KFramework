// RHO CALCULUS with Bool, Int, String ground terms and tuple messages in a monadic style
// No patterns, only name variables

require "domains.k"
require "substitution.k"
require "AltAuxFun/auxfun.k"

// SYNTAX MODULE
module ALTGRHO-SYNTAX
  import DOMAINS
  import SUBSTITUTION

//-----------------
//--- Variables ---
//-----------------
  syntax       Var ::= Id
  syntax       Ids ::= List{Id,","}
  syntax      Vars ::= List{Var,","}
                     | Ids
//  syntax  ProcOrNameVar ::= ProcVar | NameVar
//  syntax ProcOrNameVars ::= ProcVars | NameVars

//-------------
//--- NAMES ---
//-------------
  syntax        Name ::= Chan
                       | NameVar
                       | Unforgeable
  syntax     NameVar ::= Var
                       | QuoteVar
  syntax        Chan ::= "@" Proc              [klabel(chan)]
  syntax    QuoteVar ::= "@" ProcVar           [klabel(quotevar)]
  syntax Unforgeable ::= "unforgeable(" Int ")"
  syntax       Names ::= List{Name,","}
                       | NameVars
  syntax    NameVars ::= List{NameVar,","} | Vars

//-----------------
//--- PROCESSES ---
//-----------------
// TODO: precedences
  syntax      Proc ::= "{" Proc "}"  [bracket]
	 > New
	 > ProcVar
                     > "Nil"
                     | Collection
                     | Ground
                     > AExp
                     > BExp
                     | Eval
                     | Receive
                     | Send
                     | Bundle
                     > Par

// Process Variables
  syntax   ProcVar ::= Var
                     | EvalVar
  syntax   EvalVar ::= "*" NameVar  [klabel(evalvar)]

// Several Processes
  syntax     Procs ::= List{Proc,","}
                     | ProcVars
  syntax  ProcVars ::= List{ProcVar,","} | Vars

// Parallel Composition
// TODO: make a multiset of processes
  syntax       Par ::= Proc "|" Proc     [left]

// Receives
  syntax   Receive ::= SingleRec | MultiRec

  syntax SingleRec ::= "for" "(" Bind  ")" "{" Proc "}"
  syntax  MultiRec ::= "for" "(" Binds ")" "{" Proc "}"

  syntax     Lbind ::= Names "<-" Name
                     | Names "<-" Var
  syntax    Lbinds ::= List{Lbind,";"}

  syntax     Pbind ::= Names "<!" Name
                     | Names "<!" Var
  syntax    Pbinds ::= List{Pbind,";"}

  syntax     Rbind ::= Names "<=" Name
                     | Names "<=" Var
  syntax    Rbinds ::= List{Rbind,";"}

  syntax      Bind ::= Lbind | Pbind | Rbind
  syntax     Binds ::= Lbinds | Pbinds | Rbinds

// Sends
  syntax      Send ::= CSend | USend

  syntax     CSend ::= Name "!"  "(" Procs ")"
  syntax     USend ::= Name "!!" "(" Procs ")"

// Eval
  syntax      Eval ::= "*" Name  [klabel(eval)]

// New
  syntax       New ::= "new" NameVars "in" "{" Proc "}"  [binder]

// Collections
  syntax Collection ::= RhoList | RhoMap | RhoSet | RhoTuple

  syntax    RhoList ::= "[" Procs "]"      [strict]

  syntax     RhoMap ::= "{" RhoKVPairs "}"
  syntax  RhoKVPair ::= Proc ":" Proc      [strict]
  syntax RhoKVPairs ::= List{RhoKVPair,","}

  syntax    RhoSet ::= "Set" "(" Procs ")" [strict]

  syntax  RhoTuple ::= "(" Procs ")"       [strict, klabel(tuple)]

// Ground terms
  syntax    Ground ::= Bool | Int | String | Uri

  syntax       Uri ::= "uri(" String ")"

// AExp & BExp resolve to ground terms
// Arithmetic expressions
  syntax      AExp ::= "{" AExp "}"
                     > Int
                     | Eval     // for interesting message passing, e.g. for( y <- x ){ *y + 5 }
                     | String   // for concatenation & interpolation
                     > AExp "*" AExp  [strict]
	 | AExp "/" AExp  [strict]
                     > AExp "+" AExp  [strict]
                     | AExp "-" AExp  [strict]
	 > AExp "%" AExp  [strict]

// Boolean
  syntax      BExp ::= "{" BExp "}"
                     > Bool
                     | Eval
                     | AExp  "<=" AExp  [strict]
                     | "not" BExp       [strict]
                     > BExp "and" BExp  [strict(1)]
                     > BExp  "or" BExp  [strict(1)]

// Bundles
  syntax    Bundle ::= "bundle+" "{" Proc "}"  // write-only
                     | "bundle-" "{" Proc "}"  // read-only
                     | "bundle0" "{" Proc "}"  // neither read/write
                     | "bundle"  "{" Proc "}"  // both read/write

  syntax KVariable ::= Proc | Procs | Var | Vars

  syntax     KItem ::= Name | Names | Proc | Procs | Set

endmodule

// SEMANTICS MODULE
module ALTGRHO
  import ALTGRHO-SYNTAX
  import AUXFUN
  import SUBSTITUTION

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                               //
      <threads color="red">                                          //**activity threads**
        <thread multiplicity="*">                                    // collection of threads (concurrent activity)
          <k> $PGM:Par </k>                                          // programs and computations are process-based
        </thread>                                                    //
      </threads>                                                     //**tuplespace**
      <tuplespace color="blue">                                      // stores sends and receives
        <sends>                                                      //**sends**
          <send color="cyan" multiplicity="*">                       //
            <schan> .K </schan>                                      // sending channel (many messages on same channel)
            <msg>   .K   </msg>                                      // sent message
            <tuple> .K </tuple>                                      // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
            <stype> .K </stype>                                      // 0 for single send (consumed), 1 for persistent send (not consumed)
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      //
            <rchan> .K </rchan>                                      // receiving channel (many messages on same channel)
            <bvars> .K </bvars>                                      // binding varible(s) in continuation
            <bnum>  .K  </bnum>                                      // number of bindings
            <rtype> .K </rtype>                                      // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
            <cont>  .K  </cont>                                      // continuation
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction>                                                     //**where the magic happens**
        <who>   .K   </who>                                          // continuation process
        <what>  .K  </what>                                          // msg process(es)
        <where> .K </where>                                          // binding variable(s)
      </reaction>                                                    // all comms are processed here
    </T>                                                             //

  syntax KResult ::= Ground | Eval | Proc | Procs | Name | Names

// Arithmetic
  rule I1:Int + I2:Int => I1 +Int I2 [anywhere]
  rule I1:Int - I2:Int => I1 -Int I2 [anywhere]
  rule I1:Int * I2:Int => I1 *Int I2 [anywhere]
  rule I1:Int / I2:Int => I1 /Int I2 requires I2 =/=Int 0 [anywhere]

// Boolean
  rule I1:Int <= I2:Int => I1 <=Int I2 [anywhere]
  rule not B:Bool => notBool B         [anywhere]
  rule true and B:Bool => B            [anywhere]
  rule false and _ => false            [anywhere]

// String
  rule S1:String + S2:String => S1 +String S2 [anywhere]

// New Operator Semantics
  rule new M:NameVar,N:NameVars in { P:Proc } => new N in { P[unforgeable(!I:Int) / M] }
  rule new .NameVars in { P:Proc } => P

// Par Operator Semantics - spawn new thread for each process in par
  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P </k> </thread>)
       (.Bag => <thread> <k> Q </k> </thread>)

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule <k> S:Send => . ...</k>                 // dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                         //
                  <schan> #chan(S)  </schan>   // sending channel
                  <msg>   #msg(S)    </msg>    // sending message(s)
                  <tuple> #length(S) </tuple>  // number of messages
                  <stype> #stype(S)  </stype>  // send type
                </send>)                       //


//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
  rule <k> R:SingleRec => . ...</k>                                  // dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <rchan>  #chan(R) </rchan>                         // receiving channel
                  <bvars>  #bvar(R) </bvars>                         // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>                         // 
                  <rtype> #rtype(R) </rtype>                         // receive type
                  <cont>   #cont(R)  </cont>                         // continuation
                </rec>)                                              //

// Joins
  rule <k> R:MultiRec => . ...</k>                                   //
       (.Bag => <rec>                                                // 
                  <rchan>  #chan(R) </rchan>                         // receiving channel
                  <bvars>  #bvar(R) </bvars>                         // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>                         // 
                  <rtype> #rtype(R) </rtype>                         // receive type
                  <cont>   #cont(R)  </cont>                         // continuation
                </rec>)                                              //

//-------------------
//--- COMM EVENTS ---
//-------------------
// x!(Q) | y(z){P} and x equivN y => P[@Q / y]

// Reaction Cell Semantics - quarantined reaction cell for processing comm events
  rule 
    <reaction>
      <who>   P:Proc => P[@ Q / Y]    </who>
      <what>  Q:Proc , R:Procs => R  </what>
      <where> Y:Name , Z:Names => Z </where>
    </reaction>

  rule
    <reaction>
      <who>   P:Proc => P[@ Q / Y]   </who>
      <what>  Q:Proc , R:Proc => R  </what>
      <where> Y:Name , Z:Name => Z </where>
    </reaction>

  rule
    <reaction>
      <who>   P:Proc => .K   </who>
      <what>  Q:Proc => .K  </what>
      <where> Y:Name => .K </where>
    </reaction>
   (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)

// Comm semantics
// Linear listen, linear send
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of names to bind
     <rtype> 0       </rtype>                                          // linear listen
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X     </schan>                                            // channel X
     <msg>   Q:Procs </msg>                                            // message(s) Q
     <tuple> N     </tuple>                                            // number of messages matches number of names to bind
     <stype> 0     </stype>                                            // linear send
   </send> => .Bag)                                                    //
   <reaction>                                                          // 
     <who>   .K => P   </who>                                          // 
     <what>  .K => Q  </what>                                          // 
     <where> .K => Y </where>                                          // 
   </reaction>                [comm]

// Persistent listen, linear send
  rule                                                                 //consume single send, keep persistent receive
   <rec>                                                               //DON'T consume persistent receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 1       </rtype>                                          // repeated listen
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X     </schan>                                            // channel X
     <msg>   Q:Procs </msg>                                            // message(s) Q
     <tuple> N     </tuple>                                            // number of messages matches number of names to bind
     <stype> 0     </stype>                                            // linear send
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                [comm]

// Linear listen, persistent send
  rule                                                                 //consume single receive and keep single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 0       </rtype>                                          // linear listen
     <cont>  P:Proc   </cont>                                          // continuation
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X     </schan>                                            // channel X
     <msg>   Q:Procs </msg>                                            // message(s) Q
     <tuple> N     </tuple>                                            // number of messages matches number of names to bind
     <stype> 1     </stype>                                            // persistent send
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                [comm]

// Peek semantics
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 2       </rtype>                                          // peek
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X     </schan>                                            // channel X
     <msg>   Q:Procs </msg>                                            // message(s) Q
     <tuple> N     </tuple>                                            // number of messages matches number of names to bind
     <stype> _     </stype>                                            // any kind of send
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                [comm]

// Join
// moved progress to join.k

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P [anywhere, structural]
  rule P:Proc | Nil    => P [anywhere, structural]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag [structural]
  rule <thread> <k> Nil </k> </thread> => .Bag [structural]

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N [anywhere, structural]

// INVERSES
  rule   * @ P:Proc => P [anywhere, structural]

endmodule