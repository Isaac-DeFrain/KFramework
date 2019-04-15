// RHO CALCULUS with Bool, Int, String ground terms and tuple messages in a monadic style
// No patterns, only name variables

//-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-//
//                                                                                                     //
//    More expressibility with List{Name,","} and List{Proc,","} instead of NameList and ProcList?     //
//                                                                                                     //
//-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-?-//

require "domains.k"
require "substitution.k"
require "AltAuxFun/auxfun.k"

// SYNTAX MODULE
module ALTGRHO-SYNTAX
  import DOMAINS
  import SET
  import SUBSTITUTION

//-------------
//--- NAMES ---
//-------------
  syntax   NameVar ::= Id                                            //  Id < NameVar

  syntax      Name ::= "@" Proc                                      //   @: Proc -------------> Name
                     | NameVar                                       //                NameVar < Name
                     | "unforgeable(" Int ")"                        // unforgeable(_): Int ---> Name

  syntax     Names ::= NeList{Name,","}           [klabel(nameList)] // nonempty comma-separated name list

//-----------------
//--- PROCESSES ---
//-----------------
  syntax      Proc ::= "{" Proc "}"                        [bracket] // {_}: Proc --------> Proc
	 > New                                           //        New < Proc
                     > "Nil"                           [klabel(Nil)] // Nil: -------------> Proc
                     | Collection                                    // Collection < Proc
                     | Ground                                        //     Ground < Proc
                     > AExp                                          //       AExp < Proc
                     > BExp                                          //       BExp < Proc
                     | Eval                                          //       Eval < Proc
                     | Receive                                       //    Receive < Proc
                     | Send                                          //       Send < Proc
                     | Bundle                                        //     Bundle < Proc
                    // > Par                                           //        Par < Proc

// Parallel
  syntax       Par ::= List{Proc, "|"}                               // _|_: Proc x Proc ---> Par

// Receives - no mixed linear/peek/repeated
  syntax   Receive ::= SingleRec                                     // SingleRec < Receive, single listen receive
                     | MultiRec                                      //  MultiRec < Receive, multi-listen receive = join

  syntax SingleRec ::= "for" "(" Bind  ")" "{" Proc "}"              // for(_){_}: Bind x Proc ----> SingleRec

  syntax  MultiRec ::= "for" "(" Binds ")" "{" Proc "}"              // for(_){_}: Binds x Proc ---> MultiRec

  syntax     Lbind ::= Names "<-" Name                               // for( y1,...,yN <- x ){ P }, explicit

  syntax    Lbinds ::= NeList{Lbind,";"}            [klabel(lbinds)] // linear bind list

  syntax     Pbind ::= Names "<!" Name                               // for( y1,...,yN <! x ){ P }, explicit

  syntax    Pbinds ::= NeList{Pbind,";"}            [klabel(pbinds)] // peek bind list

  syntax     Rbind ::= Names "<=" Name                               // for( y1,...,yN <= x ){ P }, explicit

  syntax    Rbinds ::= NeList{Rbind,";"}            [klabel(rbinds)] // repeated bind list

  syntax      Bind ::= Lbind                                         // single linear listen, implicit
                     | Pbind                                         // single peek, implicit
                     | Rbind                                         // single repated listen, implicit

  syntax     Binds ::= Lbinds                                        // linear binds --- for( y1 <- x1 ; ... ; yN <- xN ){ P }, implicit
                     | Pbinds                                        // peek binds ----- for( y1 <! x1 ; ... ; yN <! xN ){ P }, implicit
                     | Rbinds                                        // repeated binds - for( y1 <= x1 ; ... ; yN <= xN ){ P }, implicit

// Send
  syntax      Send ::= ConsumableSend                                //   ConsumableSend < Send
                     | UnconsumableSend                              // UnConsumableSend < Send

  syntax 
    ConsumableSend ::= Name "!"  RhoTuple                            //  _!_: Name x RhoTuple ---> ConsumableSend

  syntax
  UnconsumableSend ::= Name "!!" RhoTuple                            // _!!_: Name x RhoTuple ---> UnconsumableSend

// Eval
  syntax      Eval ::= "*" Name                                      // *_: Name ---> Eval 

// Several Processes
  syntax     Procs ::= NeList{Proc,","}           [klabel(proclist)] // nonempty process list

// New
  syntax       New ::= "new" Names  "in" "{" Proc "}"       [binder] // create unforgeable name

// Collections
  syntax
        Collection ::= RhoList                                       //  RhoList < Collection
                     | RhoMap                                        //   RhoMap < Collection
                     | RhoSet                                        //   RhoMap < Collection
                     | RhoTuple                                      // RhoTuple < Collection

// Process lists
  syntax   RhoList ::= "[" Procs      "]"                            // [_]: Procs --------> RhoList

// Process maps
  syntax    RhoMap ::= "{" RhoKVPairs "}"                            // {_}: RhoKVPairs ---> RhoMap

  syntax RhoKVPair ::= Proc ":" Proc                                 // _:_: Proc x Proc ----------------> RhoKVPair
  
  syntax
        RhoKVPairs ::= NeList{RhoKVPair,","}                         // nonempty key-value pair list

// Process sets
  syntax    RhoSet ::= "Set" "(" Procs ")"                           // Set(_): Procs ----> RhoSet

// Process tuples
  syntax  RhoTuple ::= "(" Procs ")"                 [klabel(tuple)] // (_): Procs ----------> RhoTuple

// Ground terms
  syntax    Ground ::= Bool                                          //   Bool < Ground
                     | Int                                           //    Int < Ground
                     | String                                        // String < Ground
                     | Uri                                           //    Uri < Ground

  syntax       Uri ::= "uri(" String ")"                             // uri(_): String -----> Uri

// AExp & BExp resolve to ground terms
// Arithmetic
  syntax      AExp ::= "{" AExp "}"                                  //     (_): AExp ------> AExp
                     > Int                                           //    Int < AExp
                     | Eval                                          //   Eval < AExp , for interesting message passing, e.g. for( y <- x ){ *y + 5 }
                     | String                                        // String < AExp (S1 + S2 => S1 +String S2)
                     > AExp "*" AExp                        [strict] // _*_: AExp x AExp ---> AExp
                     > AExp "+" AExp                        [strict] // _+_: AExp x AExp ---> AExp
                     | AExp "-" AExp                        [strict] // _-_: AExp x AExp ---> AExp

// Boolean
  syntax      BExp ::= "{" BExp "}"                                  //  (_): BExp ----------> BExp
                     > Bool                                          //   Bool < BExp
                     | Eval                                          //   Eval < BExp
                     | String                                        // String < BExp
                     | AExp  "<=" AExp                   [seqstrict] // _<=_: AExp x AExp ---> BExp
                     | "not" BExp                           [strict] // not_: BExp ----------> BExp
                     > BExp "and" BExp                   [strict(1)] //  and: BExp ----------> BExp
                     > BExp  "or" BExp                      [strict] //   or: BExp ----------> BExp

// Bundles
  syntax    Bundle ::= "bundle+" "{" Proc "}"                        // write-only
                     | "bundle-" "{" Proc "}"                        // read-only
                     | "bundle0" "{" Proc "}"                        // neither read/write
                     | "bundle"  "{" Proc "}"                        // both read/write

// For handling joins in configuration
  syntax  JoinList ::= "{[" Proc ";" Int  "]}"                       // for uniform join id

  syntax   ChanLen ::= "("  Name ";" Int   ")"                       // (listening channel ; number of variables to bind)

  syntax  ChanList ::= "("  Name ";" Names ")"                       // (listening channel ; variable(s) to bind)

  syntax   BindOcc ::= Name ";" Int    ";;" Int                      // listening channel; number of variables to bind; number of occurences
                     | Name ";" Names  ";;" Int                      // listening channel; variable(s) to bind; number of occurences

  syntax      Proc ::= ChanLen                                       // for
                     | BindOcc                                       // auxfun
                     | JoinList                                      // definitions

  syntax KVariable ::= Names | Name

  syntax     KItem ::= Name | Names | Proc | Procs | Set

endmodule

// SEMANTICS MODULE
module ALTGRHO
  import ALTGRHO-SYNTAX
  import SUBSTITUTION
//  import AUXFUN

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

  syntax KResult ::= Ground | Eval                                   // final output of strict operations

// Arithmetic
  rule I1:Int + I2:Int => I1 +Int I2                      [anywhere] //
  rule I1:Int - I2:Int => I1 -Int I2                      [anywhere] //
  rule I1:Int * I2:Int => I1 *Int I2                      [anywhere] //

// Boolean
  rule I1:Int <= I2:Int => I1 <=Int I2                    [anywhere] //
  rule not B:Bool => notBool B                            [anywhere] //
  rule true and B:Bool => B                               [anywhere] //
  rule false and _ => false                               [anywhere] //

// String
  rule S1:String + S2:String => S1 +String S2             [anywhere] //

// New Operator Semantics
  rule new N:Name in { P:Proc } => P[unforgeable(!I:Int) / N]        //
  rule new M:Name , N:Name  in { P:Proc } => new N in { P[unforgeable(!I:Int) / M] }  // 
  rule new M:Name , N:Names in { P:Proc } => new N in { P[unforgeable(!I:Int) / M] }  // 

// Par Operator Semantics
  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>           //
       (.Bag => <thread> <k> P </k> </thread>)                       //
       (.Bag => <thread> <k> Q </k> </thread>)                       //
/*
//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule <k> S:Send => . ...</k>                                       // dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>        #chan(S)  </schan>                  // sending channel
                  <msg>           #msg(S)    </msg>                  // sending message(s)
                  <tuple> #length(#msg(S)) </tuple>                  // number of messages
                  <stype>       #stype(S)  </stype>                  // send type
                </send>)                                             //

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
*/
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
     <bvars> Y:Name  </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of names to bind
     <rtype> 0       </rtype>                                          // linear listen
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X     </schan>                                            // channel X
     <msg>   Q:Proc  </msg>                                            // message(s) Q
     <tuple> N     </tuple>                                            // number of messages matches number of names to bind
     <stype> 0     </stype>                                            // linear send
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          // 
     <what>  .K => Q  </what>                                          // 
     <where> .K => Y </where>                                          // 
   </reaction>                                                         //spawn single <thread/> holding fully substituted continuation
                                                                [comm] //tagged "comm" for tracking nondeterminism

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
   </reaction>                                                         //spawn single <thread/> holding fully substituted continuation
                                                                [comm] //tagged "comm" for tracking nondeterminism

// Persistent listen, linear send
  rule                                                                 //consume single send, keep persistent receive
   <rec>                                                               //DON'T consume persistent receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 1       </rtype>                                          // repeated listen
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X     </schan>                                            // channel X
     <msg>   Q:Proc  </msg>                                            // message(s) Q
     <tuple> N     </tuple>                                            // number of messages matches number of names to bind
     <stype> 0     </stype>                                            // linear send
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] // 

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
   </reaction>                                                  [comm] //

// Linear listen, persistent send
  rule                                                                 //consume single receive and keep single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 0       </rtype>                                          // linear listen
     <cont>  P:Proc   </cont>                                          // continuation
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X     </schan>                                            // channel X
     <msg>   Q:Proc  </msg>                                            // message(s) Q
     <tuple> N     </tuple>                                            // number of messages matches number of names to bind
     <stype> 1     </stype>                                            // persistent send
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] // 

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
   </reaction>                                                  [comm] // 

// Peek semantics
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 2       </rtype>                                          // peek
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X     </schan>                                            // channel X
     <msg>   Q:Proc  </msg>                                            // message(s) Q
     <tuple> N     </tuple>                                            // number of messages matches number of names to bind
     <stype> _     </stype>                                            // any kind of send
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] // 

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
   </reaction>                                                  [comm] // 

// Join
// moved progress to join.k

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P                               [structural]
  rule P:Proc | Nil    => P                               [structural]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag            [structural] //empty threads
  rule <thread> <k> Nil </k> </thread> => .Bag            [structural] //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N                                   [anywhere]

// INVERSES
  rule   * @ P:Proc => P                                   [anywhere]

endmodule