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
            <sid>   .K   </sid>                                      // send id
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      // each receive is a bag of listens and a continuation
            <id>     .K     </id>                                    // join id - makes it so only listens from the same receive are packaged together
            <length> .K </length>                                    // 
            <cont>   .K   </cont>                                    // continuation
            <listens>                                                // 
              <listen multiplicity="*">                              // initially poulated and moved to <bindstore/> upon matching with a <send/>
                <rchan> .K </rchan>                                  // receiving channel (many messages on same channel)
                <bvars> .K </bvars>                                  // binding varible(s) in continuation
                <bnum>  .K  </bnum>                                  // number of bindings
                <rtype> .K </rtype>                                  // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
              </listen>                                              // 
            </listens>                                               // 
            <nono>     .List    </nono>                              // list of send ids not to move to <sendstore/> because they are consumable
            <bindstore>                                              // storage for listens matching a Send; for restoring the listen to <listen/> if Send is ultimately consumed elsewhere
              <pair multiplicity="*">                                // pairs of binds with their matching send id
                <bind>  .K  </bind>                                  // binds in join which have matched with a send
                <bid>   .K   </bid>                                  // send id - needed to restore bind to <listens/> if this specific send is consumed
              </pair>                                                // 
            </bindstore>                                             // 
            <sendstore>                                              // where sends go after matching with a listen
              <vsend multiplicity="*">                               // virtual copy of <send/>
                <vchan> .K </vchan>                                  // to be dissolved if
                <vmsg>  .K  </vmsg>                                  // this Send is consumed
                <vlen>  .K  </vlen>                                  // from <tuplespace/>
                <vid>   .K   </vid>                                  // 
              </vsend>                                               // 
            </sendstore>                                             // 
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction>                                                     //**where the magic happens**
        <who>   .K   </who>                                          // continuation process
        <what>  .K  </what>                                          // msg process(es)
        <where> .K </where>                                          // binding variable(s)
      </reaction>                                                    // once a comm is identified, all components move here and all relevant cells are dissolved
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

// Par Operator Semantics: par => bag of concurrently executing processes
  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>           //
       (.Bag => <thread> <k> P </k> </thread>)                       //
       (.Bag => <thread> <k> Q </k> </thread>)                       //

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------

//--- Single Sends ---
// Process message <=> 1-tuple
  rule X:Name ! ( P:Proc ) => .                                      // dissolve Send and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        // sending channel X
                  <msg>        P       </msg>                        // sending message P
                  <tuple>      1     </tuple>                        // 1-tuple
                  <stype>      0     </stype>                        // single send (consumed in comm)
                  <sid>     !I:Int     </sid>                        // send id
                </send>)                                             //

// N-tuple messages, N > 1
  rule X:Name ! ( P:Procs ) => .                                     // dissolve Send and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        // sending channel X
                  <msg>        P       </msg>                        // sending messages P, two or more
                  <tuple> #length(P) </tuple>                        // length of tuple - how many messages
                  <stype>      0     </stype>                        // single send (consumed in comm)
                  <sid>     !I:Int     </sid>                        //
                </send>)                                             //

//--- Persistent Sends ---
// Process message <=> 1-tuple
  rule X:Name !! ( P:Proc ) => .                                     // dissolve Send and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        // sending channel X
                  <msg>        P       </msg>                        // sending message P
                  <tuple>      1     </tuple>                        // 1-tuple
                  <stype>      1     </stype>                        // repeated send (NOT consumed in comm)
                  <sid>     !I:Int     </sid>                        //
                </send>)                                             //

// N-tuple messages, N > 1
  rule X:Name !! ( P:Procs ) => .                                    // dissolve Send and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        // sending channel X
                  <msg>        P       </msg>                        // sending messages P, two or more
                  <tuple> #length(P) </tuple>                        // length of tuple - how many messages
                  <stype>      1     </stype>                        // repeated send (NOT consumed in comm)
                  <sid>     !I:Int     </sid>                        //
                </send>)                                             //

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------

//--- Single Receives ---
// Listen for 1-tuple
  rule for ( Y:Name <- X:Name ) { P:Proc } => .                      // dissolve Rec and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>     0     </id>                               // 
                  <length> 1 </length>                               // 
                  <cont>   P   </cont>                               // continuation P
                  <listens>                                          // 
                    <listen>                                         // 
                      <chan> X </chan>                               // receiving channel X
                      <vars> Y </vars>                               // variable Y binding in continuation P
                      <num>  1  </num>                               // 
                      <type> 0 </type>                               // consumable
                    </listen>                                        // 
                  </listens>                                         // 
                    ...                                              // 
                </rec>)                                              // 

// Listen for N-tuple, N > 1
  rule for ( Y:Names <- X:Name ) { P:Proc } => .                     // dissolve Rec and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>     0     </id>                               // 
                  <length> 1 </length>                               // 
                  <cont>   P   </cont>                               // continuation P
                  <listens>                                          // 
                    <listen>                                         // 
                      <chan>    X     </chan>                        // receiving channel X
                      <vars>    Y     </vars>                        // variable Y binding in continuation P
                      <num> #length(Y) </num>                        // 
                      <type>    0     </type>                        // consumable
                    </listen>                                        // 
                  </listens>                                         // 
                    ...                                              // 
                </rec>)                                              // 

//--- Persistent Receives ---
// Listen for 1-tuple
  rule for ( Y:Name <= X:Name ) { P:Proc } => .                      //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>     0     </id>                               // 
                  <length> 1 </length>                               // 
                  <cont>   P   </cont>                               // continuation P
                  <listens>                                          // 
                    <listen>                                         // 
                      <chan> X </chan>                               // receiving channel X
                      <vars> Y </vars>                               // variable Y binding in continuation P
                      <num>  1  </num>                               //
                      <type> 1 </type>                               // unconsumable
                    </listen>                                        // 
                  </listens>                                         // 
                    ...                                              // 
                </rec>)                                              // 

// Listen for N-tuple, N > 1
  rule for ( Y:Names <= X:Name ) { P:Proc } => .                     // dissolve Rec and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>     0     </id>                               // 
                  <length> 1 </length>                               // 
                  <cont>   P   </cont>                               // continuation P
                  <listens>                                          // 
                    <listen>                                         // 
                      <chan>    X     </chan>                        // receiving channel X
                      <vars>    Y     </vars>                        // variable Y binding in continuation P
                      <num> #length(Y) </num>                        // 
                      <type>    1     </type>                        // unconsumable
                    </listen>                                        // 
                  </listens>                                         // 
                    ...                                              // 
                </rec>)                                              // 

//--- Peek ---
// Peek for 1-tuple
  rule for ( Y:Name <! X:Name ) { P:Proc } => .                      //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>     0     </id>                               // 
                  <length> 1 </length>                               // 
                  <cont>   P   </cont>                               // continuation P
                  <listens>                                          // 
                    <listen>                                         // 
                      <chan> X </chan>                               // receiving channel X
                      <vars> Y </vars>                               // variable Y binding in continuation P
                      <num>  1  </num>                               //
                      <type> 2 </type>                               // peek
                    </listen>                                        // 
                  </listens>                                         // 
                    ...                                              // 
                </rec>)                                              // 

// Listen for N-tuple, N > 1
  rule for ( Y:Names <! X:Name ) { P:Proc } => .                     // dissolve Rec and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>     0     </id>                               // 
                  <length> 1 </length>                               // 
                  <cont>   P   </cont>                               // continuation P
                  <listens>                                          // 
                    <listen>                                         // 
                      <chan>    X     </chan>                        // receiving channel X
                      <vars>    Y     </vars>                        // variable Y binding in continuation P
                      <num> #length(Y) </num>                        // 
                      <type>    2     </type>                        // peek
                    </listen>                                        // 
                  </listens>                                         // 
                    ...                                              // 
                </rec>)                                              // 

//-------------
//--- Joins ---
//-------------
// Receives with several listens are immediately id wrapped
// We generate a fresh id in <rec/> for each join and initialize a <rec/> with this id
  rule for( B:Binds ){ P:Proc } => {[ for(B){P} ; !I:Int ]}          // id wrap join
       (.Bag => <rec>                                                // 
                  <id>        !I           </id>                     // 
                  <length> #length (B) </length>                     // 
                  <cont>       P         </cont>                     // continuation P
                  ...                                                // 
                </rec>)                                              // generate <rec/> with id !I, bind length #length(B), and continuation P

// Next, we process each listen in the id wrapped join into the <listen/> in the <rec/> with appropriate id
// Linear
// Terminating cases
  rule ( {[ for( Y:Name <- X:Name ){ P:Proc } ; I:Int ]} => . )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     0     </type>                       // linear listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>                                                        //

  rule ( {[ for( Y:Names <- X:Name ){ P:Proc } ; I:Int ]} => . )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>  #length(Y) </num>                       // 
                      <type>     0     </type>                       // linear listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>                                                        //

// 2 single listen joins
  rule ( {[ for( Y:Name <- X:Name ; B:Lbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     0     </type>                       // linear listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>                                                        //

  rule ( {[ for( Y:Names <- X:Name ; B:Lbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>    X     </chan>                        // receiving channel X
                      <vars>    Y     </vars>                        // variables Y binding in continuation P
                      <num> #length(Y) </num>                        // 
                      <type>    0     </type>                        // linear listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

// N linear listen joins, N > 2
  rule ( {[ for( Y:Name <- X:Name ; B:Lbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     0     </type>                       // linear listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>                                                        //

  rule ( {[ for( Y:Names <- X:Name ; B:Lbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>    X     </chan>                        // receiving channel X
                      <vars>    Y     </vars>                        // variables Y binding in continuation P
                      <num> #length(Y) </num>                        // 
                      <type>    0     </type>                        // linear listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

// Repeated
// Terminating cases
  rule ( {[ for( Y:Name <= X:Name ){ P:Proc } ; I:Int ]} => . )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     1     </type>                       // repeated listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>                                                        //

  rule ( {[ for( Y:Names <= X:Name ){ P:Proc } ; I:Int ]} => . )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variables Y binding in continuation P
                      <num>  #length(Y) </num>                       // 
                      <type>     1     </type>                       // repeated listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>                                                        //

// 2 repeated listen joins
  rule ( {[ for( Y:Name <= X:Name ; B:Rbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     1     </type>                       // repeated listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

  rule ( {[ for( Y:Names <= X:Name ; B:Rbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variables Y binding in continuation P
                      <num>  #length(Y) </num>                       // 
                      <type>     1     </type>                       // repeated listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

// N repeated listen joins, N > 2
  rule ( {[ for( Y:Name <= X:Name ; B:Rbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     1     </type>                       // repeated listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

  rule ( {[ for( Y:Names <= X:Name ; B:Rbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variables Y binding in continuation P
                      <num>  #length(Y) </num>                       // 
                      <type>     1     </type>                       // repeated listen
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

// Peek
// Terminating cases
  rule ( {[ for( Y:Name <! X:Name ){ P:Proc } ; I:Int ]} => . )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     2     </type>                       // peek
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

  rule ( {[ for( Y:Names <! X:Name ){ P:Proc } ; I:Int ]} => . )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>  #length(Y) </num>                       // 
                      <type>     2     </type>                       // peek
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>                                                        //

// 2 peek joins
  rule ( {[ for( Y:Name <! X:Name ; B:Rbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     2     </type>                       // peek
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

  rule ( {[ for( Y:Names <! X:Name ; B:Rbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variables Y binding in continuation P
                      <num>  #length(Y) </num>                       // 
                      <type>     2     </type>                       // peek
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

// N peek joins, N > 2
  rule ( {[ for( Y:Name <! X:Name ; B:Rbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variable Y binding in continuation P
                      <num>      1      </num>                       // 
                      <type>     2     </type>                       // peek
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

  rule ( {[ for( Y:Names <! X:Name ; B:Rbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} )
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <listens>                                                   // 
           (.Bag => <listen>                                         // 
                      <chan>     X     </chan>                       // receiving channel X
                      <vars>     Y     </vars>                       // variables Y binding in continuation P
                      <num>  #length(Y) </num>                       // 
                      <type>     2     </type>                       // peek
                    </listen>)                                       // 
      ...</listens>                                                  // 
    ...</rec>)                                                       //

//-------------------
//--- COMM EVENTS ---
//-------------------
// Reaction Cell Semantics - quarantine for processing substitutions resulting from a comm event
  rule 
    <reaction>                                                       // 
      <who>   P:Proc => P[@ Q / Y]    </who>                         // 
      <what>  Q:Proc , R:Procs => R  </what>                         // 
      <where> Y:Name , Z:Names => Z </where>                         // 
    </reaction>                                                      // 

  rule
    <reaction>                                                       // 
      <who>   P:Proc => P[@ Q / Y]    </who>                         //
      <what>  Q:Proc , R:Proc => R   </what>                         //
      <where> Y:Name , Z:Name => Z  </where>                         //
    </reaction>                                                      // 

  rule
    <reaction>                                                       // 
      <who>   P:Proc => .K   </who>                                  //
      <what>  Q:Proc => .K  </what>                                  //
      <where> Y:Name => .K </where>                                  //
    </reaction>                                                      // 
   (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)                  // 

//--- Comm Semantics ---
// Single listen, single send
// Both immediately consumed
// Send info dissolved from all <sendstore/>s and corresponding <bind/>s in <bindstore/> are restored as <listen/>s to <listens/>
// 1-tuple
  rule                                                               // consume single send, single receive
   (<rec>...                                                         // 
      <cont> P:Proc </cont>                                          // continuation P
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Name  </vars>                                     // variable Y binding in continuation P
          <num>  1        </num>                                     //
          <type> 0       </type>                                     // consumable
        </listen>                                                    // 
      </listens>                                                     // 
 ...</rec> => .Bag)                                                  //
   (<send>                                                           // consume single send
      <schan> X       </schan>                                       // channel X
      <msg>   Q:Proc    </msg>                                       // message Q
      <tuple> 1       </tuple>                                       // 1-tuple
      <stype> 0       </stype>                                       // single send
      <sid>   I:Int     </sid>                                       // 
    </send> => .Bag)                                                 //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
    <rec>                                                            // 
      <id>      _:Int     </id>                                      // 
      <length>  _:Int </length>                                      // 
      <cont> _:Proc  </cont>                                         // 
      <listens>                                                      // 
        (.Bag => <listen>                                            // 
                   <chan>     X     </chan>                          // receiving channel X
                   <vars>     Y     </vars>                          // variables Y binding in continuation P
                   <num>  #length(Y) </num>                          // 
                   <type>     0     </type>                          // 
                 </listen>)                                          // 
   ...</listens>                                                     //
      <nono>      // delete send id from the nono list
      <bindstore> // retrieve <bind/>/<id/> pair and restore corresponding <listen/> to <listens/>
      <sendstore> // delete corresponding virtual send
 ...</rec>)                                                          //
                                                              [comm] // tagged "comm" for tracking nondeterminism

// N-tuple, N > 1
  rule                                                               // consume single send, single receive
   (<rec>...                                                         // consumed single receive
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Names </vars>                                     // variables Y binding in continuation P
          <num>  N:Int    </num>                                     // N variables
          <type> 0       </type>                                     // consumable
        </listen>                                                    // 
      </listens>                                                     // 
      <cont> P </cont>                                               // continuation P
 ...</rec> => .Bag)                                                  //
   (<send>                                                           // consumed single send
      <schan> X       </schan>                                       // channel X
      <msg>   Q:Procs   </msg>                                       // message Q
      <tuple> N       </tuple>                                       // N-tuple
      <stype> 0       </stype>                                       // single send
 ...</send> => .Bag)                                                 //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
                                                              [comm] // tagged "comm" for tracking nondeterminism

// Persistent listen, single send
// 1-tuple
  rule                                                               // consume single send, keep persistent receive
    <rec>...                                                         // 
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Name  </vars>                                     // variable Y binding in continuation P
          <num>  1        </num>                                     //
          <type> 1       </type>                                     // unconsumable
        </listen>                                                    // 
      </listens>                                                     // 
      <cont> P </cont>                                               // continuation P
 ...</rec> => .Bag)                                                  //
   (<send>                                                           // consume single send
      <schan> X       </schan>                                       // channel X
      <msg>   Q:Proc    </msg>                                       // message Q
      <tuple> 1       </tuple>                                       // 1-tuple
      <stype> 0       </stype>                                       // single send
 ...</send> => .Bag)                                                 //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
                                                              [comm] // tagged "comm" for tracking nondeterminism

// N-tuple, N > 2
  rule                                                               // consume single send, keep persistent receive
    <rec>...                                                         // consumed single receive
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Names </vars>                                     // variables Y binding in continuation P
          <num>  N:Int    </num>                                     // N variables
          <type> 1       </type>                                     // unconsumable
        </listen>                                                    // 
      </listens>                                                     // 
      <cont> P </cont>                                               // continuation P
 ...</rec>                                                           //
   (<send>                                                           // consumed single send
      <schan> X       </schan>                                       // channel X
      <msg>   Q:Procs   </msg>                                       // message Q
      <tuple> N       </tuple>                                       // N-tuple
      <stype> 0       </stype>                                       // single send
 ...</send> => .Bag)                                                 //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
                                                              [comm] // tagged "comm" for tracking nondeterminism

// Single listen, persistent send
// 1-tuple
  rule                                                               // consume single receive, keep persistent send
   (<rec>...                                                         // 
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Name  </vars>                                     // variable Y binding in continuation P
          <num>  1        </num>                                     //
          <type> 0       </type>                                     // consumable
        </listen>                                                    // 
      </listens>                                                     // 
      <cont> P </cont>                                               // continuation P
 ...</rec> => .Bag)                                                  //
    <send>                                                           // consume single send
      <schan> X       </schan>                                       // channel X
      <msg>   Q:Proc    </msg>                                       // message Q
      <tuple> 1       </tuple>                                       // 1-tuple
      <stype> 1       </stype>                                       // repeated send
 ...</send>                                                          //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
                                                              [comm] // tagged "comm" for tracking nondeterminism

// N-tuple, N > 1
  rule                                                               // consume single receive and keep single receive
   (<rec>...                                                         // 
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Names </vars>                                     // variables Y binding in continuation P
          <num>  N:Int    </num>                                     // N variables
          <type> 0       </type>                                     // consumable
        </listen>                                                    // 
      </listens>                                                     // 
      <cont> P </cont>                                               // continuation P
 ...</rec> => .Bag)                                                  //
    <send>                                                           // consume single send
      <schan> X       </schan>                                       // channel X
      <msg>   Q:Procs   </msg>                                       // message Q
      <tuple> N       </tuple>                                       // N-tuple
      <stype> 1       </stype>                                       // repeated send
 ...</send>                                                          //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
                                                              [comm] // tagged "comm" for tracking nondeterminism

// Peek semantics
// 1-tuple
  rule                                                               // consume single send, single receive
   (<rec>...                                                         // 
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Name  </vars>                                     // variable Y binding in continuation P
          <num>  1        </num>                                     //
          <type> 2       </type>                                     // peek
        </listen>                                                    // 
      </listens>                                                     // 
      <cont> P </cont>                                               // continuation P
 ...</rec> => .Bag)                                                  //
    <send>                                                           //consume single send
      <schan> X      </schan>                                        // channel X
      <msg>   Q:Proc   </msg>                                        // message Q
      <tuple> 1      </tuple>                                        // 1-tuple
 ...</send>                                                          //
   <reaction>                                                        //
     <who>   .K => P   </who>                                        //
     <what>  .K => Q  </what>                                        //
     <where> .K => Y </where>                                        //
   </reaction>                                                [comm] //

// N-tuple, N > 1
  rule                                                               // consume single send, single receive
   (<rec>...                                                         // 
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Names </vars>                                     // variables Y binding in continuation P
          <num>  N:Int    </num>                                     // N variables
          <type> 2       </type>                                     // peek
        </listen>                                                    // 
      </listens>                                                     // 
      <cont> P </cont>                                               // continuation P
 ...</rec> => .Bag)                                                  //
    <send>                                                           //consume single send
      <schan> X      </schan>                                        // channel X
      <msg>   Q:Procs  </msg>                                        // message Q
      <tuple> N      </tuple>                                        // N-tuple
 ...</send>                                                          //
   <reaction>                                                        //
     <who>   .K => P   </who>                                        //
     <what>  .K => Q  </what>                                        //
     <where> .K => Y </where>                                        //
   </reaction>                                                [comm] //

// Join
// Linear

    <send>                       //
      <schan> .K </schan>                                      // sending channel (many messages on same channel)
      <msg>   .K   </msg>                                      // sent message
      <tuple> .K </tuple>                                      // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
      <stype> .K </stype>                                      // 0 for single send (consumed), 1 for persistent send (not consumed)
      <sid>   .K   </sid>                                      // send id
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      // each receive is a bag of listens and a continuation
            <id> .K </id>                                            // join id - makes it so only listens from the same receive are packaged together
            <listens>                                                // 
              <listen multiplicity="*">                              // initially poulated and moved to <bindstore/> upon matching with a <send/>
                <rchan> .K </rchan>                                  // receiving channel (many messages on same channel)
                <bvars> .K </bvars>                                  // binding varible(s) in continuation
                <bnum>  .K  </bnum>                                  // number of bindings
                <rtype> .K </rtype>                                  // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
              </listen>                                              // 
            </listens>                                               // 
            <cont>      .K      </cont>                              // continuation
            <nono>     .List    </nono>                              // list of send ids not to move to <sendstore/> because they are consumable
            <bindstore>                                              // 
              <bind multiplicity="*">                                // storage for binds in the listens which match a send, for restoring <listen/> if send is consumed
                <join>  .K  </join>                                  // binds in join which have matched with a send
                <bid>   .K   </bid>                                  // send id - needed to restore bind to <listens/> if this specific send is consumed
              </bind>                                                // 
            </bindstore>                                             // 
            <sendstore>                                              // where sends go after matching with a listen
              <jsend multiplicity="*">                               // copy of <send/> to be discarded once this send is consumed from <tuplespace/>
                <jchan> .K </jchan>                                  // 
                <jmsg>  .K  </jmsg>                                  // 
                <jlen>  .K  </jlen>                                  // 
                <jid>   .K   </jid>                                  // 
              </jsend>                                               // 
            </sendstore>                                             // 
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction>                                                     //**where the magic happens**
        <who>   .K   </who>                                          // continuation process
        <what>  .K  </what>                                          // msg process(es)
        <where> .K </where>                                          // binding variable(s)
      </reaction>                                                    //
  
// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P                             [structural] //
  rule P:Proc | Nil    => P                             [structural] //

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag          [structural] //empty threads
  rule <thread> <k> Nil </k> </thread> => .Bag          [structural] //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N                                  [anywhere] //

// INVERSES
  rule   * @ P:Proc => P                                  [anywhere] //

endmodule