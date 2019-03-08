// RHO CALCULUS with Bool, Int, String ground terms and tuple messages in a monadic style
// No patterns, only name variables

require "domains.k"
require "substitution.k"
require "../AuxFun/auxfun.k"
require "../grho.k"

module JOIN-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX
  import SUBSTITUTION

endmodule

// SEMANTICS MODULE
module JOIN
  import JOIN-SYNTAX
  import AUXFUN

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                               //
      <threads color="red">                                          //**activity threads**
        <thread multiplicity="*">                                    // collection of threads (concurrent activity)
          <k> $PGM:Proc </k>                                         // programs and computations are process-based
        </thread>                                                    //
      </threads>                                                     //**tuplespace**
      <tuplespace color="blue">                                      // stores sends and receives
        <sends>                                                      //**sends**
          <send color="cyan" multiplicity="*">                       //
            <schan> .K </schan>                                      // sending channel (many messages on same channel)
            <msg>   .K   </msg>                                      // sent message
            <tuple> .K </tuple>                                      // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
            <stype> .K </stype>                                      // 0 for single send (consumed), 1 for persistent send (not consumed)
            <spot> .Set </spot>                                      // potential join ids to comm with
            <id>    .K    </id>                                      // send id
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      //
            <rchan> .K </rchan>                                      // receiving channel (many messages on same channel)
            <bvars> .K </bvars>                                      // binding varible(s) in continuation
            <bnum>  .K  </bnum>                                      // number of bindings
            <rtype> .K </rtype>                                      // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
            <join>  .K  </join>                                      // fresh int for each join
            <jlen>  .K  </jlen>                                      // length of join
            <rpot> .Set </rpot>                                      // potential send ids to comm with
            <bind> .Set </bind>                                      // binding occurrences
            <blen> .Set </blen>                                      // channel lengths
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
/*
  Add quarantine cell containing mainreact cell and reaction* cells for testing joins in comms
  SendCellBag <=> send "environment"
*/

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

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------

//--- Single Sends ---
// Process message <=> 1-tuple
  rule <k> X:Name ! ( P:Proc ) => . ...</k>                          //dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        //sending channel X
                  <msg>        P       </msg>                        //sending message P
                  <tuple>      1     </tuple>                        //1-tuple = ( Proc )
                  <stype>      0     </stype>                        //single send => consumed in comm
                  <spot>     .Set     </spot>                        // initial potential join comm id list is empty
                  <id>      !I:Int      </id>                        // send id
                </send>)                                             //

// N-tuple messages, N > 1
  rule <k> X:Name ! ( P:Procs ) => . ...</k>                         //dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        //sending channel X
                  <msg>        P       </msg>                        //sending messages P, two or more
                  <tuple> #length(P) </tuple>                        //length of tuple - how many messages
                  <stype>      0     </stype>                        //single send => consumed in comm
                  <spot>     .Set     </spot>                        // 
                  <id>      !I:Int      </id>                        //
                </send>)                                             //

//--- Persistent Sends ---
// Process message <=> 1-tuple
  rule <k> X:Name !! ( P:Proc ) => . ...</k>                         //dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        //sending channel X
                  <msg>        P       </msg>                        //sending message P
                  <tuple>      1     </tuple>                        //1-tuple
                  <stype>      1     </stype>                        //repeated send => NOT consumed in comm
                  <spot>     .Set     </spot>                        // 
                  <id>      !I:Int      </id>                        //
                </send>)                                             //

// N-tuple messages, N > 1
  rule <k> X:Name !! ( P:Procs ) => . ...</k>                        //dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        //sending channel X
                  <msg>        P       </msg>                        //sending messages P, two or more
                  <tuple> #length(P) </tuple>                        //length of tuple
                  <stype>      1     </stype>                        //repeated send
                  <spot>     .Set     </spot>                        // 
                  <id>      !I:Int      </id>                        //
                </send>)                                             //

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------

//--- Single Receives ---
// Listen for 1-tuple
  rule <k> for ( Y:Name <- X:Name ) { P:Proc } => . ...</k>          //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variable Y binding in continuation P
                  <bnum>      1      </bnum>                         //
                  <rtype>     0     </rtype>                         //consumable
                  <join>      0      </join>                         // 
                  <jlen>      1      </jlen>                         // 
                  <rpot>    .Set     </rpot>                         // 
                  <bind>    .Set     </bind>                         // binding occurrences
			            <blen>    .Set     </blen>                         // channel lengths
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

// Listen for N-tuple, N > 1
  rule <k> for ( Y:Names <- X:Name ) { P:Proc } => . ...</k>         //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //comma-separated list of patterns Y binding in continuation P
                  <bnum>  #length(Y) </bnum>                         //
                  <rtype>     0     </rtype>                         //consumable
                  <join>      0      </join>                         // 
                  <jlen>      1      </jlen>                         // 
                  <rpot>    .Set     </rpot>                         // 
                  <bind>    .Set     </bind>                         //
			            <blen>    .Set     </blen>                         //
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

//--- Persistent Receives ---
// Listen for 1-tuple
  rule <k> for ( Y:Name <= X:Name ) { P:Proc } => . ...</k>          //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variable Y binding in continuation P
                  <bnum>      1      </bnum>                         //
                  <rtype>     1     </rtype>                         //unconsumable
                  <join>      0      </join>                         // 
                  <jlen>      1      </jlen>                         // 
                  <rpot>    .Set     </rpot>                         // 
                  <bind>    .Set     </bind>                         //
			            <blen>    .Set     </blen>                         //
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

// Listen for N-tuple, N > 1
  rule <k> for ( Y:Names <= X:Name ) { P:Proc } => . ...</k>         //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variables Y binding in continuation P
                  <bnum>  #length(Y) </bnum>                         //
                  <rtype>     1     </rtype>                         //unconsumable
                  <join>      0      </join>                         // 
                  <jlen>      1      </jlen>                         // 
                  <rpot>    .Set     </rpot>                         // 
                  <bind>    .Set     </bind>                         //
			            <blen>    .Set     </blen>                         //
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

//--- Peek ---
// Peek for 1-tuple
  rule <k> for ( Y:Name <! X:Name ) { P:Proc } => . ...</k>          //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variable Y binding in continuation P
                  <bnum>      1      </bnum>                         //
                  <rtype>     2     </rtype>                         //peek
                  <join>      0      </join>                         // 
                  <jlen>      1      </jlen>                         // 
                  <rpot>    .Set     </rpot>                         // 
                  <bind>    .Set     </bind>                         // 
			            <blen>    .Set     </blen>                         // 
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

// Listen for N-tuple, N > 1
  rule <k> for ( Y:Names <! X:Name ) { P:Proc } => . ...</k>         //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variables Y binding in continuation P
                  <bnum>  #length(Y) </bnum>                         //
                  <rtype>     2     </rtype>                         //peek
                  <join>      0      </join>                         // 
                  <jlen>      1      </jlen>                         // 
                  <rpot>    .Set     </rpot>                         // 
                  <bind>    .Set     </bind>                         //
			            <blen>    .Set     </blen>                         //
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

//-------------
//--- Joins ---
//-------------
  rule <thread> <k> for ( B:Lbinds ){ P:Proc } => . ...</k> </thread>
       (.Bag => <rec>                                                //
                  <rchan>   #chan (B) </rchan>                       //
                  <bvars>   #bvar (B) </bvars>                       //
                  <bnum> #lengths (B)  </bnum>                       //
                  <rtype>      0      </rtype>                       //
                  <join>    !I:Int     </join>                       // 
                  <jlen>  #length (B)  </jlen>                       // 
                  <rpot>     .Set      </rpot>                       // 
                  <bind> #bindocc (B)  </bind>                       // binding occurrences
			            <blen> #chanlen (B)  </blen>                       // channel lengths 
                  <cont>       P       </cont>                       //
                </rec>)                                              //

// Repeated
  rule <thread> <k> for ( B:Rbinds ){ P:Proc } => . ...</k> </thread>
       (.Bag => <rec>                                                //
                  <rchan>   #chan (B) </rchan>                       //
                  <bvars>   #bvar (B) </bvars>                       //
                  <bnum> #lengths (B)  </bnum>                       //
                  <rtype>      1      </rtype>                       //
                  <join>    !I:Int     </join>                       // 
                  <jlen>  #length (B)  </jlen>                       // 
                  <rpot>     .Set      </rpot>                       // 
                  <bind> #bindocc (B)  </bind>                       // binding occurrences
			            <blen> #chanlen (B)  </blen>                       // channel lengths 
                  <cont>       P       </cont>                       //
                </rec>)                                              //

// Peek
  rule <thread> <k> for ( B:Pbinds ){ P:Proc } => . ...</k> </thread>
       (.Bag => <rec>                                                //
                  <rchan>   #chan (B) </rchan>                       //
                  <bvars>   #bvar (B) </bvars>                       //
                  <bnum> #lengths (B)  </bnum>                       //
                  <rtype>      2      </rtype>                       //
                  <join>    !I:Int     </join>                       // 
                  <jlen>  #length (B)  </jlen>                       // 
                  <rpot>     .Set      </rpot>                       // 
                  <bind> #bindocc (B)  </bind>                       // binding occurrences
			            <blen> #chanlen (B)  </blen>                       // channel lengths 
                  <cont>       P       </cont>                       //
                </rec>)                                              //

//-------------------
//--- COMM EVENTS ---
//-------------------
// x!(Q) | y(z){P} and x equivN y => P[@Q / y]

// Reaction Cell Semantics - quarantine for cells during comm event
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
// Single listen, single send
// 1-tuple
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable Y
     <bnum>  1        </bnum>                                          // one name to bind
     <rtype> 0       </rtype>                                          // single listen
     <join>  0        </join>                                          // 
     <jlen>  1        </jlen>                                          // 
		 <rpot>  _:Set    </rpot>                                          // 
		 <bind>  _:Set    </bind>                                          // binding occurrences
		 <blen>  _:Set    </blen>                                          // channel lengths 
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Proc    </msg>                                          // message Q
     <tuple> 1       </tuple>                                          // 1-tuple
     <stype> 0       </stype>                                          // single send
		 <spot>  _:Set    </spot>                                          // 
     <id>    _         </id>                                           //
   </send> => .Bag)                                                    //
   <reaction>                                                          //
	   <who>   .K => P   </who>                                          //
	   <what>  .K => Q  </what>                                          //
	   <where> .K => Y </where>                                          //
	 </reaction>                                                         //spawn single <thread/> holding sub P[@Q / Y]
                                                                [comm] //tagged "comm" for tracking nondeterminism

// N-tuple, N > 1
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable Y
     <bnum>  N:Int    </bnum>                                          // N names to bind
     <rtype> 0       </rtype>                                          // single listen
     <join>  0        </join>                                          // 
     <jlen>  1        </jlen>                                          // 
		 <rpot>  _:Set    </rpot>                                          // 
		 <bind>  _:Set    </bind>                                          // binding occurrences
		 <blen>  _:Set    </blen>                                          // channel lengths 
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X       </schan>                                          // channel
     <msg>   Q:Procs   </msg>                                          // message
     <tuple> N       </tuple>                                          // N-tuple, N > 1
     <stype> 0       </stype>                                          // single send
		 <spot>  _:Set    </spot>                                          // 
     <id>    _         </id>                                           //
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] //

// Persistent listen, single send
// 1-tuple
  rule                                                                 //consume single send, keep persistent receive
   <rec>                                                               //DON'T consume persistent receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable Y
     <bnum>  1        </bnum>                                          // one name to bind
     <rtype> 1       </rtype>                                          // single listen
     <join>  0        </join>                                          // 
     <jlen>  1        </jlen>                                          // 
		 <rpot>  _:Set    </rpot>                                          // 
		 <bind>  _:Set    </bind>                                          // binding occurrences
		 <blen>  _:Set    </blen>                                          // channel lengths 
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Proc    </msg>                                          // message
     <tuple> 1       </tuple>                                          // 1-tuple
     <stype> 0       </stype>                                          // single send
		 <spot>  _:Set    </spot>                                          // 
     <id>    _         </id>                                           //
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] //

// N-tuple, N > 2
  rule                                                                 //consume single send, keep persistent receive
   <rec>                                                               //DON'T consume persistent receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variables Y, Z
     <bnum>  N:Int    </bnum>                                          // N names to bind
     <rtype> 1       </rtype>                                          // single listen
     <join>  0        </join>                                          // 
     <jlen>  1        </jlen>                                          // 
		 <rpot>  _:Set    </rpot>                                          // 
		 <bind>  _:Set    </bind>                                          // binding occurrences
		 <blen>  _:Set    </blen>                                          // channel lengths 
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Procs   </msg>                                          // message(s)
     <tuple> N       </tuple>                                          // N-tuple
     <stype> 0       </stype>                                          // single send
		 <spot>  _:Set    </spot>                                          // 
     <id>    _         </id>                                           //
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] //

// Single listen, persistent send
// 1-tuple
  rule                                                                 //consume single receive, keep persistent send
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable(s)
     <bnum>  1        </bnum>                                          // one name to bind
     <rtype> 0       </rtype>                                          // single listen
     <join>  0        </join>                                          // 
     <jlen>  1        </jlen>                                          // 
		 <rpot>  _:Set    </rpot>                                          // 
		 <bind>  _:Set    </bind>                                          // binding occurrences
		 <blen>  _:Set    </blen>                                          // channel lengths 
     <cont>  P:Proc   </cont>                                          // continuation
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Proc    </msg>                                          // message Q
     <tuple> 1       </tuple>                                          // 1-tuple
     <stype> 1       </stype>                                          // single send
		 <spot>  _:Set    </spot>                                          // 
     <id>    _         </id>                                           //
   </send>                                                             //
   <reaction>
     <who>   .K => P   </who>
     <what>  .K => Q  </what>
     <where> .K => Y </where>
   </reaction>                                                  [comm]

// N-tuple, N > 1
  rule                                                                 //consume single receive and keep single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s)
     <bnum>  N:Int    </bnum>                                          // N names to bind
     <rtype> 0       </rtype>                                          // single listen
     <join>  0        </join>                                          // 
     <jlen>  1        </jlen>                                          // 
		 <rpot>  _:Set    </rpot>                                          // 
		 <bind>  _:Set    </bind>                                          // binding occurrences
		 <blen>  _:Set    </blen>                                          // channel lengths 
     <cont>  P:Proc   </cont>                                          // continuation
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Procs   </msg>                                          // messages
     <tuple> N       </tuple>                                          // N-tuple
     <stype> 1       </stype>                                          // persistent send
		 <spot>  _:Set    </spot>                                          // 
     <id>    _         </id>                                           //
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] //

// Peek semantics
// 1-tuple
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name </rchan>                                           // channel X
     <bvars> Y:Name </bvars>                                           // binding variable Y
     <bnum>  1       </bnum>                                           // one name to bind
     <rtype> 2      </rtype>                                           // peek
     <join>  0        </join>                                          // 
     <jlen>  1        </jlen>                                          // 
		 <rpot>  _:Set    </rpot>                                          // 
		 <bind>  _:Set    </bind>                                          // binding occurrences
		 <blen>  _:Set    </blen>                                          // channel lengths 
     <cont>  P:Proc  </cont>                                           // continuation P
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X      </schan>                                           // channel X
     <msg>   Q:Proc   </msg>                                           // message Q
     <tuple> 1      </tuple>                                           // 1-tuple
     <stype> _      </stype>                                           // single or repeated send
		 <spot>  _:Set   </spot>                                           // 
     <id>    _         </id>                                           //
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] //

// N-tuple, N > 1
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable Y
     <bnum>  N:Int    </bnum>                                          // N names to bind
     <rtype> 2       </rtype>                                          // peek
     <join>  0        </join>                                          // 
     <jlen>  1        </jlen>                                          // 
		 <rpot>  _:Set    </rpot>                                          // 
		 <bind>  _:Set    </bind>                                          // binding occurrences
		 <blen>  _:Set    </blen>                                          // channel lengths 
     <cont>  P:Proc   </cont>                                          // continuation P
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X       </schan>                                          // channel
     <msg>   Q:Procs   </msg>                                          // message
     <tuple> N       </tuple>                                          // N-tuple
     <stype> _       </stype>                                          // single or repeated send
		 <spot>  _:Set    </spot>                                          // 
     <id>    _          </id>                                          //
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
   </reaction>                                                  [comm] //

// Join
// Linear
  rule
    <rec>                                                              //
      <rchan> N:Names </rchan>                                         //
      <bvars> Y:Names </bvars>                                         //
      <bnum>  H:Procs  </bnum>                                         //
      <rtype> 0       </rtype>                                         //
      <join>  I:Int    </join>                                         // 
      <jlen>  _:Int    </jlen>                                         // 
 		  <rpot>  S1:Set => S1 SetItem((X;T)) </rpot>                      // 
 		  <bind>   _:Set   </bind>                                         // binding occurrences
 		  <blen>  S3:Set   </blen>                                         // channel lengths 
      <cont>  P:Proc   </cont>                                         //
    </rec>                                                             //
    <send>                                                             //
      <schan> X:Name  </schan>                                         //
      <msg>   Q:Proc    </msg>                                         //
      <tuple> 1       </tuple>                                         //
      <stype> _       </stype>                                         //
 		  <spot>  S2:Set => S2 SetItem(I) </spot>                          // 
      <id>    T:Int      </id>                                         //
    </send>                                                            // 
      when ((X;1) in S3) andBool notBool (T in S1)

  rule
    <rec>                                                              //
      <rchan> N:Names </rchan>                                         //
      <bvars> Y:Names </bvars>                                         //
      <bnum>  H:Procs  </bnum>                                         //
      <rtype> 0       </rtype>                                         //
      <join>  I:Int    </join>                                         // 
      <jlen>  J:Int    </jlen>                                         // 
 		  <rpot>  S1:Set => S1 SetItem((X;T)) </rpot>                      // 
 		  <bind>   _:Set   </bind>                                         // binding occurrences
 		  <blen>  S3:Set   </blen>                                         // channel lengths 
      <cont>  P:Proc   </cont>                                         //
    </rec>                                                             //
    <send>                                                             //
      <schan> X:Name  </schan>                                         //
      <msg>   Q:Procs   </msg>                                         //
      <tuple> L:Int   </tuple>                                         //
      <stype> _       </stype>                                         //
 		  <spot>  S2:Set => S2 SetItem(I) </spot>                          // 
      <id>    T:Int      </id>                                         //
    </send>                                                            // 
      when ((X;L) in S3) andBool notBool (T in S1)
/*
// Repeated
  rule <k> {[ for ( B:Rbinds ){ P:Proc } , I:Int ]} => {[ I ;  ]} </k>
       (.Bag => <rec>                                                //
                  <rchan>  #chans (B) </rchan>                       //
                  <bvars>  #bvars (B) </bvars>                       //
                  <bnum> #lengths (B)  </bnum>                       //
                  <rtype>      1      </rtype>                       //
                  <join>       I       </join>                       // 
                  <jlen>  #length (B)  </jlen>                       // 
                  <cont>       P       </cont>                       //
                </rec>)                                              //

// Peek
  rule <k> {[ for ( B:Pbinds ){ P:Proc } , I:Int ]} => {[ I ;  ]} </k>
       (.Bag => <rec>                                                //
                  <rchan>  #chans (B) </rchan>                       //
                  <bvars>  #bvars (B) </bvars>                       //
                  <bnum> #lengths (B)  </bnum>                       //
                  <rtype>      2      </rtype>                       //
                  <join>       I       </join>                       // 
                  <jlen>  #length (B)  </jlen>                       // 
                  <cont>       P       </cont>                       //
                </rec>)                                              //    
*/
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