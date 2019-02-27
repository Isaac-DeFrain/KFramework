// Reductions of Processes and Process Patterns

require "../grho.k"

module REDUCE-SYNTAX
  import GRHO-SYNTAX
  import KAST

  syntax        Bool ::= Proc "->"    Proc
                       | Proc "equiv" Proc

  syntax         Set ::= "Red(" Proc ")"

  syntax         Bag ::= Cell

  syntax        Proc ::= "#repar(" Bag ")"

  syntax        Proc ::= Set

endmodule

module REDUCE
  import REDUCE-SYNTAX

  configuration
    <T color="purple">                                               //
      <Threads color="red">                                          //**activity threads**
        <Thread multiplicity="*">                                    // collection of threads (concurrent activity)
          <k> $PGM:Proc </k>                                         // programs and computations are process-based
        </Thread>                                                    //
      </Threads>                                                     //**tuplespace**
      <Tuplespace color="blue">                                      // stores sends and receives
        <Sends color="teal">                                         //**sends**
          <Send color="cyan" multiplicity="*">                       //
            <schan> .K </schan>                                      // sending channel (many messages on same channel)
            <msg>   .K   </msg>                                      // sent message
            <tuple> .K </tuple>                                      // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
            <sper>  .K  </sper>                                      // 0 for single send (consumed), 1 for persistent send (not consumed)
          </Send>                                                    //
        </Sends>                                                     //
        <Receives>                                                   //
          <Rec color="yellow" multiplicity="*">                      //
            <rchan> .K </rchan>                                      // receiving channel (many messages on same channel)
            <bvars> .K </bvars>                                      // binding varible(s) in continuation
            <bnum>  .K  </bnum>                                      // number of bindings
            <rper>  .K  </rper>                                      // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
            <cont>  .K  </cont>                                      // continuation
          </Rec>                                                     //
        </Receives>                                                  //
      </Tuplespace>                                                  //
      <Reaction>                                                     //**where the magic happens**
        <who>   .K   </who>                                          // continuation process
        <what>  .K  </what>                                          // msg process(es)
        <where> .K </where>                                          // binding variable(s)
        <how>    0   </how>                                          // how many comms
      </Reaction>                                                    //
      <Repar>   .K   </Repar>                                        // build reduced process by parring everything in <Receives/>, <Sends/>, & <Threads/>
    </T>                                                             //

  syntax KResult ::= Ground | Eval | Set

// Par
  rule <Thread> <k> P:Proc | Q:Proc => . ...</k> </Thread>           // Par rewritten as ThreadCellBag
       (.Bag => <Thread> <k> P </k> </Thread>)                       //
       (.Bag => <Thread> <k> Q </k> </Thread>)                       //

// Send
  rule <k> X:Name ! ( P:Proc ) => . ...</k>                          // Send rewritten as <Send/>
       (.Bag => <Send>                                               //
                  <schan> X </schan>                                 //sending channel X
                  <msg>   P   </msg>                                 //sending messages P, two or more
                  <tuple> 1 </tuple>                                 //length of tuple - how many messages
                  <sper>  0  </sper>                                 //single send => consumed in comm
                </Send>)                                             //

// Receive
  rule <k> for ( Y:Name <- X:Name ) { P:Proc } => . ...</k>          // Receive rewritten as <Rec/>
       (.Bag => <Rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variable Y binding in continuation P
                  <bnum>      1      </bnum>                         //
                  <rper>      0      </rper>                         //single listen => consumed in comm
                  <cont>      P      </cont>                         //continuation P
                </Rec>)                                              //

// Comm semantics
  rule                                                                 //consume single send, single receive
  (<Rec>                                                               //consume single receive
     <rchan> X:Name </rchan>                                           // channel X
     <bvars> Y:Name </bvars>                                           // binding variable Y
     <bnum>  1       </bnum>                                           // one name to bind
     <rper>  0       </rper>                                           // single listen
     <cont>  P:Proc  </cont>                                           // continuation P
   </Rec> => .Bag)                                                     //
  (<Send>                                                              //consume single send
     <schan> X      </schan>                                           // channel X
     <msg>   Q:Proc   </msg>                                           // message Q
     <tuple> 1      </tuple>                                           // 1-tuple
     <sper>  0       </sper>                                           // single send
   </Send> => .Bag)                                                    //
   <Reaction>                                                          //
     <who>    .K => P        </who>                                    // 
     <what>   .K => Q       </what>                                    // 
     <where>  .K => Y      </where>                                    // 
     <how>     0 => 1        </how>                                    // count or stop at 1?
   </Reaction>                                                  [comm] //

// Reaction Cell Semantics
  rule
    <Reaction>
      <who>   P:Proc => .K   </who>
      <what>  Q:Proc => .K  </what>
      <where> Y:Name => .K </where>
      <how>   _:Int          </how>
    </Reaction>
   (.Bag => <Thread> <k> P[@ Q / Y] </k> </Thread>)

//
  rule 
    <Reaction>
      <who>   .   </who>
      <what>  .  </what>
      <where> . </where>
      <how>   1   </how>
    </Reaction>
   (<Thread> <k> A:Proc </k> </Thread> => .Bag)
   (<Repar> .K => A </Repar>)

  rule 
    <Reaction>
      <who>   .   </who>
      <what>  .  </what>
      <where> . </where>
      <how>   1   </how>
    </Reaction>
   (<Thread> <k> A:Proc </k> </Thread> => .Bag)
   (<Repar> P:Proc => P | A </Repar>)

  rule
    <Reaction>
      <who>   .   </who>
      <what>  .  </what>
      <where> . </where>
      <how>   1   </how>
    </Reaction>
   (<Rec>
      <rchan> X:Name </rchan>
      <bvars> Y:Name </bvars>
      <bnum>  1       </bnum>
      <rper>  0       </rper>
      <cont>  Q:Proc  </cont>
    </Rec> => .Bag)
   (<Repar> P:Proc => P | for( Y <- X ){ Q } </Repar>)

  rule
    <Reaction>
      <who>   .   </who>
      <what>  .  </what>
      <where> . </where>
      <how>   1   </how>
    </Reaction>
   (<Send>
      <schan> X:Name </schan>
      <msg>   Q:Proc   </msg>
      <tuple> 1      </tuple>
      <sper>  0       </sper>
    </Send> => .Bag)
   (<Repar> P:Proc => P | X!(Q) </Repar>)

// Inverses
  rule   @ * N:Name => N                                    [anywhere] 
  rule   * @ P:Proc => P                                    [anywhere] 

// Eliminate Nils
  rule    Nil | P:Proc => P                               [structural] 
  rule P:Proc | Nil    => P                               [structural] 

// Dissolve computationally meaningless threads
  rule <Thread> <k> .K  </k> </Thread> => .Bag            [structural]
  rule <Thread> <k> Nil </k> </Thread> => .Bag            [structural]

endmodule