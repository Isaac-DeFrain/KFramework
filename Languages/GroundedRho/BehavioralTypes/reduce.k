// Reductions of Processes and Process Patterns

require "../grho.k"
require "../AuxFun/auxfun.k"

module REDUCE-SYNTAX
  import GRHO-SYNTAX

  syntax        Bool ::= Proc "->"    Proc
                       | Proc "equiv" Proc

endmodule

module REDUCE
  import REDUCE-SYNTAX
  import AUXFUN

  configuration
    <T color="purple">                                                 //
      <Threads color="red">                                            //**threads of activity**
        <Thread multiplicity="*">                                      // collection of threads (concurrent activity)
          <k> $PGM:Proc </k>                                           // programs and computations are process-based
        </Thread>                                                      //
      </Threads>                                                       //**tuplespace**
      <Tuplespace color="blue">                                        // stores sends and receives
        <Sends color="teal">                                           //**sends**
          <Send color="cyan" multiplicity="*">                         //
            <schan> .K </schan>                                        // sending channel (many messages on same channel)
            <msg>   .K   </msg>                                        // sent message
            <tuple> .K </tuple>                                        // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
            <sper>  .K  </sper>                                        // 0 for single send (consumed), 1 for persistent send (not consumed)
          </Send>                                                      //
        </Sends>                                                       //
        <Receives>                                                     //
          <Rec color="yellow" multiplicity="*">                        //
            <rchan> .K </rchan>                                        // receiving channel (many messages on same channel)
            <bvars> .K </bvars>                                        // binding varible(s) in continuation
            <bnum>  .K  </bnum>                                        // number of bindings
            <rper>  .K  </rper>                                        // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
            <cont>  .K  </cont>                                        // continuation
          </Rec>                                                       //
        </Receives>                                                    //
      </Tuplespace>                                                    //
      <Reaction>                                                       //**where the magic happens**
        <who>   .K   </who>                                            // continuation process
        <what>  .K  </what>                                            // msg process(es)
        <where> .K </where>                                            // binding variable(s)
        <how>    0   </how>                                            // counting comms
      </Reaction>                                                      //
      <Repar>   .K   </Repar>                                          // build reduced process by parring everything in <Receives/>, <Sends/>, & <Threads/>
      <Store>   .K   </Store>                                          // storage for reaction contents during join reaction
    </T>                                                               //

  syntax KResult ::= Ground | Eval | Set                               // Resolving expressions

// Par
  rule <Thread> <k> P:Proc | Q:Proc => . ...</k> </Thread>             // Par rewritten as ThreadCellBag
       (.Bag => <Thread> <k> P </k> </Thread>)                         //
       (.Bag => <Thread> <k> Q </k> </Thread>)                         //

// Send
  rule <k> X:Name ! ( P:Proc ) => . ...</k>                            // Send rewritten as <Send/>
       (.Bag => <Send>                                                 //
                  <schan> X </schan>                                   //sending channel X
                  <msg>   P   </msg>                                   //sending messages P, two or more
                  <tuple> 1 </tuple>                                   //length of tuple - how many messages
                  <sper>  0  </sper>                                   //single send => consumed in comm
                </Send>)                                               //

// N-tuple messages, N > 1
  rule <k> X:Name ! ( P:Procs ) => . ...</k>                           //dissolve send in <threads/> and spawn <send/>
       (.Bag => <Send>                                                 //
                  <schan>      X     </schan>                          //sending channel X
                  <msg>        P       </msg>                          //sending messages P, two or more
                  <tuple> #length (P)  </tuple>                          //length of tuple - how many messages
                  <sper>       0      </sper>                          //single send => consumed in comm
                </Send>)                                               //

// Receive
  rule <k> for ( Y:Name <- X:Name ) { P:Proc } => . ...</k>            // Receive rewritten as <Rec/>
       (.Bag => <Rec>                                                  //
                  <rchan>     X     </rchan>                           //receiving channel X
                  <bvars>     Y     </bvars>                           //variable Y binding in continuation P
                  <bnum>      1      </bnum>                           //
                  <rper>      0      </rper>                           //single listen => consumed in comm
                  <cont>      P      </cont>                           //continuation P
                </Rec>)                                                //

// Listen for N-tuple, N > 1
  rule <k> for ( Y:Names <- X:Name ) { P:Proc } => . ...</k>           //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <Rec>                                                  //
                  <rchan>     X     </rchan>                           //receiving channel X
                  <bvars>     Y     </bvars>                           //comma-separated list of patterns Y binding in continuation P
                  <bnum>  #length(Y) </bnum>                           //
                  <rper>      0      </rper>                           //single listen => consumed in comm
                  <cont>      P      </cont>                           //continuation P
                </Rec>)                                                //

// Reaction Cell Semantics
  rule                                                                 // 
    <Reaction>                                                         // 
      <who>   P:Proc => .K   </who>                                    // 
      <what>  Q:Proc => .K  </what>                                    // 
      <where> Y:Name => .K </where>                                    // 
      <how>       _:Int      </how>                                    // 
    </Reaction>                                                        // 
   (.Bag => <Thread> <k> P[@Q / Y] </k> </Thread>)                     //
  //<Repar> . => P[@ Q / Y] </Repar>                                   // 

  rule                                                                 // 
    <Reaction>                                                         // 
      <who>   P:Proc => P[@ Q / Y]   </who>                            // 
      <what>  Q:Proc , R:Proc => R  </what>                            // 
      <where> Y:Name , Z:Name => Z </where>                            // 
      <how>          _:Int           </how>                            // 
    </Reaction>                                                        // 

  rule                                                                 // 
    <Reaction>                                                         // 
      <who>   P:Proc => P[@ Q / Y]    </who>                           // 
      <what>  Q:Proc , R:Procs => R  </what>                           // 
      <where> Y:Name , Z:Names => Z </where>                           // 
      <how>          _:Int            </how>                           // 
    </Reaction>                                                        //

// Comm semantics
// 1-tuple
  rule                                                                 //consume single receive, single send
  (<Rec>                                                               //single receive:
     <rchan> X:Name </rchan>                                           // channel X
     <bvars> Y:Name </bvars>                                           // binding variable Y
     <bnum>  1       </bnum>                                           // one name to bind
     <rper>  0       </rper>                                           // single listen
     <cont>  P:Proc  </cont>                                           // continuation P
   </Rec> => .Bag)                                                     //
  (<Send>                                                              //single send:
     <schan> X      </schan>                                           // channel X
     <msg>   Q:Proc   </msg>                                           // message Q
     <tuple> 1      </tuple>                                           // 1-tuple
     <sper>  0       </sper>                                           // single send
   </Send> => .Bag)                                                    //
   <Reaction>                                                          //spawn continuation, message, & binding variable in <Reaction/>
     <who>    .K => P        </who>                                    // continuation P
     <what>   .K => Q       </what>                                    // message Q
     <where>  .K => Y      </where>                                    // binding variable Y
     <how> I:Int => I +Int 1 </how>                                    // increase comm count
   </Reaction>                                                  [comm] //

// N-tuple, N > 1
  rule                                                                 //consume single send, single receive
  (<Rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variables Y, Z
     <bnum>  N:Int    </bnum>                                          // N names to bind
     <rper>  0        </rper>                                          // single listen
     <cont>  P:Proc   </cont>                                          // continuation P
   </Rec> => .Bag)                                                     //
  (<Send>                                                              //consume single send
     <schan> X      </schan>                                           // channel X
     <msg>   Q:Procs  </msg>                                           // message(s) Q, R
     <tuple> N      </tuple>                                           // 2-tuple
     <sper>  0       </sper>                                           // single send
   </Send> => .Bag)                                                    //
   <Reaction>                                                          //spawn continuation, message, & binding variable in <Reaction/>
     <who>    .K => P        </who>                                    // continuation P
     <what>   .K => Q       </what>                                    // message Q
     <where>  .K => Y      </where>                                    // binding variable Y
     <how> I:Int => I +Int 1 </how>                                    // increase comm count
   </Reaction>                                                  [comm] //

// After 1 comm event occurs, stop and collect the continuation and everything leftover in <Threads/>, <Sends/>, & <Receives/> into <Repar/>
// Reparring continuation
  rule
    <Reaction>                                                         // The reaction needs a Proc catalyst to start.
      <who>   .   </who>                                               // The continuation from the comm event will
      <what>  .  </what>                                               // always be present in a Thread cell so we
      <where> . </where>                                               // use that as the reaction catalyst.
      <how> N:Int </how>                                               // The fact that this is N means N comm events occured!
    </Reaction>                                                        //
   (<Thread> <k> A:Proc </k> </Thread> => .Bag)                        //
   (<Repar> .K => A </Repar>)                                          // Now there is a Proc in the Repar cell
    requires N =/=Int 0

// Reparring reamains Threads
  rule 
    <Reaction>                                                         // Once reaction has catalyzed, we need to par everything from the
      <who>   .   </who>                                               // Threads, Receives, & Sends cells in the Repar cell.
      <what>  .  </what>                                               //
      <where> . </where>                                               //
      <how> N:Int </how>                                               //
    </Reaction>                                                        //
   (<Thread> <k> A:Proc </k> </Thread> => .Bag)                        // Threads being reparred
   (<Repar> P:Proc => P | A </Repar>)                                  // Par contents of Repar cell with the contents of all the Thread cells
    requires N =/=Int 0

// Reparring remaining Receives
// Listen on 1 name
  rule
    <Reaction>                                                         //
      <who>   .   </who>                                               //
      <what>  .  </what>                                               //
      <where> . </where>                                               //
      <how> N:Int </how>                                               //
    </Reaction>                                                        //
   (<Rec>                                                              // Receives being reparred
      <rchan> X:Name </rchan>                                          //
      <bvars> Y:Name </bvars>                                          //
      <bnum>  1       </bnum>                                          //
      <rper>  0       </rper>                                          //
      <cont>  Q:Proc  </cont>                                          //
    </Rec> => .Bag)                                                    //
   (<Repar> P:Proc => P | for( Y <- X ){ Q } </Repar>)                 // Par contents of Repar cell with the contents of all the Receive cells                                              // 
    requires N =/=Int 0

// Listen on N names, N > 1
  rule
    <Reaction>                                                         //
      <who>   .   </who>                                               //
      <what>  .  </what>                                               //
      <where> . </where>                                               //
      <how> N:Int </how>                                               //
    </Reaction>                                                        //
   (<Rec>                                                              // Receives being reparred
      <rchan> X:Name  </rchan>                                         //
      <bvars> Y:Names </bvars>                                         //
      <bnum>  _:Int    </bnum>                                         //
      <rper>  0        </rper>                                         //
      <cont>  Q:Proc   </cont>                                         //
    </Rec> => .Bag)                                                    //
   (<Repar> P:Proc => P | for( Y <- X ){ Q } </Repar>)                 // Par contents of Repar cell with the contents of all the Receive cells                                              // 
    requires N =/=Int 0

// Reparring remaining Sends
// 1-tuple
  rule
    <Reaction>                                                         //
      <who>   .   </who>                                               //
      <what>  .  </what>                                               //
      <where> . </where>                                               //
      <how> N:Int </how>                                               //
    </Reaction>                                                        //
   (<Send>                                                             // Sends being reparred
      <schan> X:Name </schan>                                          //
      <msg>   Q:Proc   </msg>                                          //
      <tuple> 1      </tuple>                                          //
      <sper>  0       </sper>                                          //
    </Send> => .Bag)                                                   //
   (<Repar> P:Proc => P | X!(Q) </Repar>)                              // Par contents of Repar cell with the contents of all the Send cells
    requires N =/=Int 0

// N-tuple, N > 1
  rule
    <Reaction>                                                         //
      <who>   .   </who>                                               //
      <what>  .  </what>                                               //
      <where> . </where>                                               //
      <how> N:Int </how>                                               //
    </Reaction>                                                        //
   (<Send>                                                             // Sends being reparred
      <schan> X:Name </schan>                                          //
      <msg>   Q:Procs  </msg>                                          //
      <tuple> _:Int  </tuple>                                          //
      <sper>  0       </sper>                                          //
    </Send> => .Bag)                                                   //
   (<Repar> P:Proc => P | X!(Q) </Repar>)                              // Par contents of Repar cell with the contents of all the Send cells                                                // 
    requires N =/=Int 0

// Inverses
  rule   @ * N:Name => N                                    [anywhere] 
  rule   * @ P:Proc => P                                    [anywhere] 

// Eliminate Nils in Par
  rule    Nil | P:Proc => P                               [structural] 
  rule P:Proc | Nil    => P                               [structural] 

// Dissolve computationally meaningless threads
  rule <Thread> <k> .K  </k> </Thread> => .Bag            [structural]

endmodule