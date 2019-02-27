// Reductions of Processes and Process Patterns

require "../grho.k"

module REDUCE-SYNTAX
  import GRHO-SYNTAX

  syntax        Bool ::= Proc    "->" Proc
                       | Proc    "->" ProcPat
                       | ProcPat "->" Proc
                       | ProcPat "->" ProcPat
                       | Proc    "equiv" Proc
                       | ProcPat "equiv" Proc
                       | Proc    "equiv" ProcPat
                       | ProcPat "equiv" ProcPat

  syntax         Set ::= "Red(" ProcOrPat ")"

endmodule

module REDUCE
  import REDUCE-SYNTAX

  configuration
    <T color="purple">                                               //
      <threads color="red">                                          //**activity threads**
        <thread multiplicity="*">                                    // collection of threads (concurrent activity)
          <k> $PGM:Proc </k>                                         // programs and computations are process-based
        </thread>                                                    //
      </threads>                                                     //**tuplespace**
      <tuplespace color="blue">                                      // stores sends and receives
        <sends color="teal">                                         //**sends**
          <send color="cyan" multiplicity="*">                       //
            <schan> .K </schan>                                      // sending channel (many messages on same channel)
            <msg>   .K   </msg>                                      // sent message
            <tuple> .K </tuple>                                      // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
            <sper>  .K  </sper>                                      // 0 for single send (consumed), 1 for persistent send (not consumed)
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      //
            <rchan> .K </rchan>                                      // receiving channel (many messages on same channel)
            <bvars> .K </bvars>                                      // binding varible(s) in continuation
            <bnum>  .K  </bnum>                                      // number of bindings
            <rper>  .K  </rper>                                      // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
            <cont>  .K  </cont>                                      // continuation
          </rec>                                                     //
        </receives>                                                  //
      </tuplespace>                                                  //
      <reaction>                                                     //**where the magic happens**
        <who>   .K   </who>                                          // continuation process
        <what>  .K  </what>                                          // msg process(es)
        <where> .K </where>                                          // binding variable(s)
        <num>    0   </num>                                          // how many comms
      </reaction>                                                    // all comms are processed here
    </T>                                                             //

  syntax KResult ::= Ground | Eval                                   // final output of strict operations

  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>           //
       (.Bag => <thread> <k> P </k> </thread>)                       //
       (.Bag => <thread> <k> Q </k> </thread>)                       //

endmodule