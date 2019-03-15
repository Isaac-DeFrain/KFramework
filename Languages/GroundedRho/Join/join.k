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
            <id>     .K     </id>                                    // join id - makes it so only listens from the same receive are packaged together and reaction info only comes from one receive at a time
            <length> .K </length>                                    // number of listens in receive
            <cont>   .K   </cont>                                    // continuation
            <comm>   .K   </comm>                                    // "load" if initializing, "" if initialized but not matched, "matched" if all listens have been matched and we're ready to move everything to <reaction/>
            <match>  .K  </match>                                    // number of matches made
            <nono>   .Set </nono>                                    // list of send ids not to match with (because they are consumable and have already been matched)
            <listens>                                                // 
              <listen multiplicity="*">                              // initially poulated and moved to <bindstore/> upon matching with a <send/>
                <chan> .K </chan>                                    // receiving channel (many messages on same channel)
                <vars> .K </vars>                                    // binding varible(s) in continuation
                <num>  .K  </num>                                    // number of bindings
                <type> .K </type>                                    // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
                <msid> .K </msid>                                    // id of a matched send
              </listen>                                              // 
            </listens>                                               // 
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction>                                                     //**where the magic happens**
        <who>   .K   </who>                                          // continuation
        <what>  .K  </what>                                          // msg process(es)
        <where> .K </where>                                          // binding variable(s)
        <rid>   .K   </rid>                                          // receive id; which receive is info being collected from
        <rnum>  .K  </rnum>                                          // reaction count
        <react> .K </react>                                          // "collect" = collect relevant info from send(s) and receive, "react" = substitute (allows multiple sends to be collected for joins)
      </reaction>                                                    // once a comm is identified, all components are move here and all relevant cells are dissolved
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
  rule <k> S:Send => . ...</k>                                       // dissolve Send and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>        #chan(S)  </schan>                  // sending channel X
                  <msg>           #msg(S)    </msg>                  // message(s) P
                  <tuple> #length(#msg(S)) </tuple>                  // length of tuple - how many messages
                  <stype>       #stype(S)  </stype>                  // send type
                  <sid>         !I:Int       </sid>                  // id
                </send>)                                             //

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------

// Single Receive
  rule <k> R:SingleRec => . ...</k>                                  // dissolve Rec and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>      !I:Int    </id>                          // 
				          <length>   1    </length>                          // 
                  <cont>  #cont(R)  </cont>                          // continuation
                  <comm>     ""     </comm>                          // matching is initiated
                  <match>    0     </match>                          // initialized with 0 matches
                  <nono>    .Set    </nono>                          // initialized with empty nono set
                  <listens>                                          // 
                    <listen>                                         // add <listen/> to <listens/>
                      <chan>  #chan(R) </chan>                       // receiving channel
                      <vars>  #bvar(R) </vars>                       // variable Y binding in continuation
                      <num>   #bnum(R)  </num>                       // number of variables to bind
                      <type> #rtype(R) </type>                       // receive type
                      <msid>     ""    </msid>                       // matched send id
                    </listen>                                        // 
                  </listens>                                         // 
                </rec>)                                              // 

// Joins
// Receives with several listens are immediately id wrapped
// We generate a fresh id in a <rec/> for each join and initialize this <rec/> with this id, number of listens, and continuation
  rule <k> R:MultiRec => {[ R ; !I:Int ]} ...</k>                    // generate id & wrap join
       (.Bag => <rec>                                                // 
                  <id>        !I        </id>                        // 
                  <length> #bnum(R) </length>                        // number of listens in receive
                  <cont>   #cont(R)   </cont>                        // continuation
                  <comm>    "load"    </comm>                        // loading is initialized
                  <match>      0     </match>                        // 
                  <nono>      .Set    </nono>                        // 
                  <listens>                                          //    
                    <listen>                                         // 
                      <chan> "" </chan>                              // 
                      <vars> "" </vars>                              // 
                      <num>  ""  </num>                              // 
                      <type> "" </type>                              // 
                      <msid> "" </msid>                              // 
                    </listen>                                        // 
                  </listens>                                         // 
                </rec>)                                              // generate <rec/> with id !I, #bnum(R) listens, and continuation #cont(R)

// Next, each listen is processed within the id wrapped join into the <listen/> in the <rec/> with appropriate id
// Terminating cases
  rule <k> {[ R:SingleRec ; I:Int ]} => . ...</k>                    // 
       <rec>                                                         // 
         <id>     I            </id>                                 // 
				 <length> _:Int    </length>                                 // 
         <cont>   _:Proc     </cont>                                 // 
				 <comm> "load" => "" </comm>                                 // matching is initialized
				 <match>  0         </match>                                 // 0 matches
				 <nono>  .Set        </nono>                                 // empty nono set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>  #chan(R) </chan>                       // receiving channel
                      <vars>  #bvar(R) </vars>                       // variable(s) binding in continuation
                      <num>   #bnum(R)  </num>                       // number of variables to bind
                      <type> #rtype(R) </type>                       // listen type
                      <msid>     ""    </msid>                       // not matched yet
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        // 

// Recursive steps
// Linear
// 2 single listen joins
  rule <k> {[ for( A:Lbind ; B:Lbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
				 <comm>   "load"  </comm>                                    // loading
				 <match>  0      </match>                                    // 0 matches
				 <nono>  .Set     </nono>                                    // empty nono set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <type>     0    </type>                        // linear
                      <msid>    ""    </msid>                        // not matched yet
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        //

// N linear listen joins, N > 2
  rule <k> {[ for( A:Lbind ; B:Lbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
				 <comm>   "load"  </comm>                                    // loading
				 <match>  0      </match>                                    // 0 matches
				 <nono>  .Set     </nono>                                    // empty nono set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <type>     0    </type>                        // linear
                      <msid>    ""    </msid>                        // not matched yet
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        //

// Repeated
// 2 repeated listen joins
  rule <k> {[ for( A:Rbind ; B:Rbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
				 <comm>   "load"  </comm>                                    // loading
				 <match>  0      </match>                                    // 0 matches
				 <nono>  .Set     </nono>                                    // empty nono set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <type>     1    </type>                        // repeated
                      <msid>    ""    </msid>                        // not matched yet
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        //

// N repeated listen joins, N > 2
  rule <k> {[ for( A:Rbind ; B:Rbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
				 <comm>   "load"  </comm>                                    // loading
				 <match>  0      </match>                                    // 0 matches
				 <nono>  .Set     </nono>                                    // empty nono set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <type>     1    </type>                        // repeated
                      <msid>    ""    </msid>                        // not matched yet
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        //

// Peek
// 2 peek joins
  rule <k> {[ for( A:Pbind ; B:Pbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
				 <comm>   "load"  </comm>                                    // loading
				 <match>  0      </match>                                    // 0 matches
				 <nono>  .Set     </nono>                                    // empty nono set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <type>     2    </type>                        // peek
                      <msid>    ""    </msid>                        // not matched yet
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        //

// N peek joins, N > 2
  rule <k> {[ for( A:Pbind ; B:Pbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
				 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
				 <comm>   "load"  </comm>                                    // loading
				 <match>  0      </match>                                    // 0 matches
				 <nono>  .Set     </nono>                                    // empty nono set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <type>     2    </type>                        // peek
                      <msid>    ""    </msid>                        // not matched yet
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        //

//----------------
//--- Matching ---
//----------------
// When a listen matches a send, four things happen simultaneously:
// 1. The match count is increased.
// 2. If the send is consumable, the send id is added to nono set. Otherwise, nothing.
// 3. The listen is moved to the bindstore (so it doesn't match another send).
// 4. The send is moved to the sendstore (it will be consumed from the tuplspace when a comm occurs).

// Consumable sends (add id to nono set)
// 1-tuple
  rule
    <rec>...                                                         // 
      <length> L:Int              </length>                          // L listen receive
      <cont>   _:Proc               </cont>                          // 
      <comm>   ""                   </comm>                          // matching
			<match> M:Int => M +Int 1    </match>                          // increase match count
      <nono>  S:Set => S SetItem(I) </nono>                          // add send id to nono set so it is not matched again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Name  </vars>                                     // variable Y binding in continuation
          <num>  1        </num>                                     // 1 variable to bind
          <type> R:Int   </type>                                     // any receive type
          <msid> "" => I </msid>                                     // id of send mactching the listen
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   Q:Proc  </msg>                                         // message Q
      <tuple> 1     </tuple>                                         // 1-tuple
      <stype> 0     </stype>                                         // consumable send
      <sid>   I:Int   </sid>                                         // 
    </send>                                                          // 
    requires (notBool I in S) andBool (L >Int M)             [match] // 

// N-tuple, N > 1
  rule
    <rec>...                                                         // 
      <length> L:Int              </length>                          // L listen receive
      <cont>   _:Proc               </cont>                          // 
      <comm>   ""                   </comm>                          // matching
			<match> M:Int => M +Int 1    </match>                          // increase match count
      <nono>  S:Set => S SetItem(I) </nono>                          // add send id to nono set so it is not matched again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Names </vars>                                     // variables Y binding in continuation
          <num>  N:Int    </num>                                     // N variables to bind
          <type> R:Int   </type>                                     // any receive type
          <msid> "" => I </msid>                                     // id of send mactching the listen
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   Q:Procs </msg>                                         // messages Q
      <tuple> N     </tuple>                                         // 1-tuple
      <stype> 0     </stype>                                         // consumable send
      <sid>   I:Int   </sid>                                         // 
    </send>                                                          // 
    requires (notBool I in S) andBool (L >Int M)             [match] // 

// Unconsumable sends
// 1-tuple
  rule
    <rec>...                                                         // 
      <length> L:Int           </length>                             // L listen receive
      <cont>   _:Proc            </cont>                             // 
      <comm>   ""                </comm>                             // matching
			<match> M:Int => M +Int 1 </match>                             // increase match count
      <nono>  _:Set              </nono>                             // do NOT add send id to nono set so it can be matched again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Name  </vars>                                     // variable Y binding in continuation
          <num>  1        </num>                                     // 1 variable to bind
          <type> R:Int   </type>                                     // any receive type
          <msid> "" => I </msid>                                     // id of send mactching the listen
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   Q:Proc  </msg>                                         // message Q
      <tuple> 1     </tuple>                                         // 1-tuple
      <stype> 1     </stype>                                         // unconsumable send
      <sid>   I:Int   </sid>                                         // 
    </send>                                                          // 
    requires L >Int M                                        [match] // 

// N-tuple, N > 1
  rule
    <rec>...                                                         // 
      <length> L:Int           </length>                             // L listen receive
      <cont>   _:Proc            </cont>                             // 
      <comm>   ""                </comm>                             // matching
			<match> M:Int => M +Int 1 </match>                             // increase match count
      <nono>  _:Set              </nono>                             // do NOT add send id to nono set so it can be matched again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Name  </vars>                                     // variables Y binding in continuation
          <num>  N:Int    </num>                                     // N variables to bind
          <type> R:Int   </type>                                     // any receive type
          <msid> "" => I </msid>                                     // id of send mactching the listen
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   Q:Proc  </msg>                                         // message Q
      <tuple> N     </tuple>                                         // N-tuple
      <stype> 1     </stype>                                         // unconsumable send
      <sid>   I:Int   </sid>                                         // 
    </send>                                                          // 
    requires L >Int M                                        [match] // 

//-------------------
//--- COMM EVENTS ---
//-------------------
// Reaction Cell Semantics - quarantine for processing substitutions resulting from a comm event
  rule 
    <reaction>                                                       // 
      <who>   P:Proc => P[@ Q / Y]    </who>                         // 
      <what>  Q:Proc , R:Procs => R  </what>                         // 
      <where> Y:Name , Z:Names => Z </where>                         // 
      <rid>          _:Int            </rid>                         // 
      <rnum>         _:Int           </rnum>                         // 
      <react>       "react"         </react>                         // 
    </reaction>                                                      // 

  rule
    <reaction>                                                       // 
      <who>   P:Proc => P[@ Q / Y]    </who>                         // 
      <what>  Q:Proc , R:Proc => R   </what>                         // 
      <where> Y:Name , Z:Name => Z  </where>                         // 
      <rid>          _:Int            </rid>                         // 
      <rnum>         _:Int           </rnum>                         // 
      <react>       "react"         </react>                         // 
    </reaction>                                                      // 

  rule
    <reaction>                                                       // 
      <who>   P:Proc  => .K   </who>                                 // 
      <what>  Q:Proc  => .K  </what>                                 // 
      <where> Y:Name  => .K </where>                                 // 
      <rid>   _:Int   => .K   </rid>                                 // 
      <rnum>  _:Int   => .K  </rnum>                                 //
      <react> "react" => .K </react>                                 // 
    </reaction>                                                      // 
   (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)                  // 
/*
//--- Comm Semantics ---
// Comm occurs when # of sends matched = # of listens in join (i.e. match = length)

// Single listen, single send
// Send info dissolved from all <sendstore/>s and corresponding <bind/>s in <bindstore/> are restored as <listen/>s to <listens/>
// 1-tuple
  rule                                                               // to be consumed linear sends and receive
    <rec>                                                            // number of listens in receive
      <id>      J:Int     </id>                                      //  
      <length>  L:Int </length>                                      // 
      <cont>    P:Proc  </cont>                                      // 
      <listens> _    </listens>                                      // 
      <match>   L      </match>                                      // once match count is equal to listen length: initialize comm
      <nono>    _       </nono>                                      // 
      <bindstore>...                                                 // 
       (<pair>                                                       // 
          <bind> Y:Name <- X:Name </bind>                            // 
          <bid>  I       </bid>                                      // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   // 
      <sendstore>...                                                 // 
       (<vsend>                                                      // 
          <vchan>  X      </vchan>                                   // 
          <vmsg>   Q:Proc  </vmsg>                                   // 
          <vlen>   1       </vlen>                                   // 
          <vtype>  0      </vtype>                                   // 
          <vid>    I:Int    </vid>                                   // 
        </vsend> => .Bag)                                            // 
      </sendstore>                                                   // 
    </rec>                                                           // 
    <reaction>                                                       // begin populating <reaction/>
      <who>   .K => P           </who>                               // relocate continuation & substitution info to <reaction/>
      <what>  .K => Q          </what>                               // 
      <where> .K => Y         </where>                               // 
      <rid>   .K => J           </rid>                               // 
      <rnum>  .K => 1          </rnum>                               //
      <react> .K => "collect" </react>                               // collect all info before reaction begins
    </reaction>                                                      // 
    <rec>                                                            // virtual send management
      <id> H:Int </id>                                               // 
      <length> _:Int </length>                                       // 
      <cont>   _:Proc  </cont>                                       // 
      <listens>...                                                   // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>  #bvar(C) </vars>                          // 
                   <num>      1      </num>                          // 
                   <type> #rtype(C) </type>                          // 
                 </listen>)                                          // 
      </listens>                                                     // 
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins (send was already consumed)
      <nono>  S:Set => S -Set SetItem(I) </nono>                     // delete send id from the nono set in all joins
      <bindstore>...                                                 // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> C:Bind </bind>                                      // 
          <bid>  I       </bid>                                      // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   //  
      <sendstore>...                                                 // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  1  </vlen>                                        // 
           <vtype> 0 </vtype>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
      </sendstore>                                                   // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X </schan>                                           // 
        <msg>   Q   </msg>                                           // 
        <tuple> 1 </tuple>                                           // 
        <stype> 0 </stype>                                           // 
        <sid>   I   </sid>                                           // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    requires (H =/=Int J) andBool (I in S)                    [comm] // 

  rule                                                               // to be consumed linear sends and receive
    <rec>                                                            // number of listens in receive
      <id>      J:Int     </id>                                      //  
      <length>  L:Int </length>                                      // 
      <cont>    P:Proc  </cont>                                      // 
      <listens> _    </listens>                                      // 
      <match>   L      </match>                                      // once match count is equal to listen length: initialize comm
      <nono>    _       </nono>                                      // 
      <bindstore>...                                                 // 
       (<pair>                                                       // 
          <bind> Y:Name <- X:Name </bind>                            // 
          <bid>  I                 </bid>                            // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   // 
      <sendstore>...                                                 // 
       (<vsend>                                                      // 
          <vchan>  X:Name </vchan>                                   // 
          <vmsg>   Q:Proc  </vmsg>                                   // 
          <vlen>   1       </vlen>                                   // 
          <vtype>  0      </vtype>                                   // 
          <vid>    I:Int    </vid>                                   // 
        </vsend> => .Bag)                                            // 
      </sendstore>                                                   // 
    </rec>                                                           // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc => #append(Q;R)   </what>                       // 
      <where> Z:Name => #append(Y;Z)  </where>                       // 
      <rid>   J                         </rid>                       // 
      <rnum>  U:Int => U +Int 1        </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // collecting info before reaction begins
    </reaction>                                                      // 
    <rec>                                                            // virtual send management
      <id> H:Int </id>                                               // 
      <length> _:Int </length>                                       // 
      <cont>   _:Proc  </cont>                                       // 
      <listens>...                                                   // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>  #bvar(C) </vars>                          // 
                   <num>      1      </num>                          // 
                   <type> #rtype(C) </type>                          // 
                 </listen>)                                          // 
      </listens>                                                     // 
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins (send was already consumed)
      <nono>  S:Set => S -Set SetItem(I) </nono>                     // delete send id from the nono set in all joins
      <bindstore>...                                                 // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> C:Bind </bind>                                      // 
          <bid>  I       </bid>                                      // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   //  
      <sendstore>...                                                 // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  1  </vlen>                                        // 
           <vtype> 0 </vtype>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
      </sendstore>                                                   // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X </schan>                                           // 
        <msg>   Q   </msg>                                           // 
        <tuple> 1 </tuple>                                           // 
        <stype> 0 </stype>                                           // 
        <sid>   I   </sid>                                           // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    requires (H =/=Int J) andBool (I in S) andBool (L >Int U) [comm] // 

  rule                                                               // to be consumed linear sends and receive
    <rec>                                                            // number of listens in receive
      <id>      J:Int     </id>                                      //  
      <length>  L:Int </length>                                      // 
      <cont>    P:Proc  </cont>                                      // 
      <listens> _    </listens>                                      // 
      <match>   L      </match>                                      // once match count is equal to listen length: initialize comm
      <nono>    _       </nono>                                      // 
      <bindstore>...                                                 // 
       (<pair>                                                       // 
          <bind> Y:Name <- X:Name </bind>                            // 
          <bid>  I                 </bid>                            // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   // 
      <sendstore>...                                                 // 
       (<vsend>                                                      // 
          <vchan>  X:Name </vchan>                                   // 
          <vmsg>   Q:Proc  </vmsg>                                   // 
          <vlen>   1       </vlen>                                   // 
          <vtype>  0      </vtype>                                   // 
          <vid>    I:Int    </vid>                                   // 
        </vsend> => .Bag)                                            // 
      </sendstore>                                                   // 
    </rec>                                                           // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => #append(Q;R)  </what>                       // 
      <where> Z:Names => #append(Y;Z) </where>                       // 
      <rid>   J                         </rid>                       // 
      <rnum>  U:Int => U +Int 1        </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // collecting info before reaction begins
    </reaction>                                                      // 
    <rec>                                                            // virtual send management
      <id> H:Int </id>                                               // 
      <length> _:Int </length>                                       // 
      <cont>   _:Proc  </cont>                                       // 
      <listens>...                                                   // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>  #bvar(C) </vars>                          // 
                   <num>      1      </num>                          // 
                   <type> #rtype(C) </type>                          // 
                 </listen>)                                          // 
      </listens>                                                     // 
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins (send was already consumed)
      <nono>  S:Set => S -Set SetItem(I) </nono>                     // delete send id from the nono set in all joins
      <bindstore>...                                                 // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> C:Bind </bind>                                      // 
          <bid>  I       </bid>                                      // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   //  
      <sendstore>...                                                 // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  1  </vlen>                                        // 
           <vtype> 0 </vtype>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
      </sendstore>                                                   // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X </schan>                                           // 
        <msg>   Q   </msg>                                           // 
        <tuple> 1 </tuple>                                           // 
        <stype> 0 </stype>                                           // 
        <sid>   I   </sid>                                           // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    requires (H =/=Int J) andBool (I in S) andBool (L >Int U) [comm] // 

// N-tuple, N > 1
  rule                                                               // to be consumed linear sends and receive
    <rec>                                                            // number of listens in receive
      <id>      J:Int     </id>                                      //  
      <length>  L:Int </length>                                      // 
      <cont>    P:Proc  </cont>                                      // 
      <listens> _    </listens>                                      // 
      <match>   L      </match>                                      // once match count is equal to listen length: initialize comm
      <nono>    _       </nono>                                      // 
      <bindstore>...                                                 // 
       (<pair>                                                       // 
          <bind> Y:Names <- X:Name </bind>                           // 
          <bid>  I                  </bid>                           // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   // 
      <sendstore>...                                                 // 
       (<vsend>                                                      // 
          <vchan>  X:Name </vchan>                                   // 
          <vmsg>   Q:Procs </vmsg>                                   // 
          <vlen>   N:Int   </vlen>                                   // 
          <vtype>  0      </vtype>                                   // 
          <vid>    I:Int    </vid>                                   // 
        </vsend> => .Bag)                                            // 
      </sendstore>                                                   // 
    </rec>                                                           // 
    <reaction>                                                       // relocate continuation & substitution info to <reaction/>
      <who>   .K => P           </who>                               // 
      <what>  .K => Q          </what>                               // 
      <where> .K => Y         </where>                               // 
      <rid>   .K => J           </rid>                               // 
      <rnum>  .K => 1          </rnum>                               // 
      <react> .K => "collect" </react>                               // collect all info before reaction begins
    </reaction>                                                      // 
    <rec>                                                            // virtual send management
      <id> H:Int </id>                                               // 
      <length> _:Int </length>                                       // 
      <cont>   _:Proc  </cont>                                       // 
      <listens>...                                                   // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>  #bvar(C) </vars>                          // 
                   <num>      N      </num>                          // 
                   <type> #rtype(C) </type>                          // 
                 </listen>)                                          // 
      </listens>                                                     // 
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins (send was already consumed)
      <nono>  S:Set => S -Set SetItem(I) </nono>                     // delete send id from the nono set in all joins
      <bindstore>...                                                 // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> C:Bind </bind>                                      // 
          <bid>  I       </bid>                                      // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   //  
      <sendstore>...                                                 // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  N  </vlen>                                        // 
           <vtype> 0 </vtype>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
      </sendstore>                                                   // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X </schan>                                           // 
        <msg>   Q   </msg>                                           // 
        <tuple> N </tuple>                                           // 
        <stype> 0 </stype>                                           // 
        <sid>   I   </sid>                                           // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    requires (H =/=Int J) andBool (I in S)                    [comm] //  

  rule                                                               // to be consumed linear sends and receive
    <rec>                                                            // number of listens in receive
      <id>      J:Int     </id>                                      //  
      <length>  L:Int </length>                                      // 
      <cont>    P:Proc  </cont>                                      // 
      <listens> _    </listens>                                      // 
      <match>   L      </match>                                      // once match count is equal to listen length: initialize comm
      <nono>    _       </nono>                                      // 
      <bindstore>...                                                 // 
       (<pair>                                                       // 
          <bind> Y:Names <- X:Name </bind>                           // 
          <bid>  I                  </bid>                           // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   // 
      <sendstore>...                                                 // 
       (<vsend>                                                      // 
          <vchan>  X:Name </vchan>                                   // 
          <vmsg>   Q:Procs </vmsg>                                   // 
          <vlen>   N:Int   </vlen>                                   // 
          <vtype>  0      </vtype>                                   // 
          <vid>    I:Int    </vid>                                   // 
        </vsend> => .Bag)                                            // 
      </sendstore>                                                   // 
    </rec>                                                           // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc => #append(Q;R)   </what>                       // 
      <where> Z:Name => #append(Y;Z)  </where>                       // 
      <rid>   J                         </rid>                       // 
      <rnum>  U:Int => U +Int 1        </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // waiting for all info to be collected before reaction occurs
    </reaction>                                                      // 
    <rec>                                                            // virtual send management
      <id> H:Int </id>                                               // 
      <length> _:Int </length>                                       // 
      <cont>   _:Proc  </cont>                                       // 
      <listens>...                                                   // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>  #bvar(C) </vars>                          // 
                   <num>      N      </num>                          // 
                   <type> #rtype(C) </type>                          // 
                 </listen>)                                          // 
      </listens>                                                     // 
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins (send was already consumed)
      <nono>  S:Set => S -Set SetItem(I) </nono>                     // delete send id from the nono set in all joins
      <bindstore>...                                                 // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> C:Bind </bind>                                      // 
          <bid>  I       </bid>                                      // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   //  
      <sendstore>...                                                 // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  N  </vlen>                                        // 
           <vtype> 0 </vtype>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
      </sendstore>                                                   // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X </schan>                                           // 
        <msg>   Q   </msg>                                           // 
        <tuple> N </tuple>                                           // 
        <stype> 0 </stype>                                           // 
        <sid>   I   </sid>                                           // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    requires (H =/=Int J) andBool (I in S) andBool (L >Int U) [comm] //  

  rule                                                               // to be consumed linear sends and receive
    <rec>                                                            // number of listens in receive
      <id>      J:Int     </id>                                      //  
      <length>  L:Int </length>                                      // 
      <cont>    P:Proc  </cont>                                      // 
      <listens> _    </listens>                                      // 
      <match>   L      </match>                                      // once match count is equal to listen length: initialize comm
      <nono>    _       </nono>                                      // 
      <bindstore>...                                                 // 
       (<pair>                                                       // 
          <bind> Y:Names <- X:Name </bind>                           // 
          <bid>  I                  </bid>                           // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   // 
      <sendstore>...                                                 // 
       (<vsend>                                                      // 
          <vchan>  X:Name </vchan>                                   // 
          <vmsg>   Q:Procs </vmsg>                                   // 
          <vlen>   N:Int   </vlen>                                   // 
          <vtype>  0      </vtype>                                   // 
          <vid>    I:Int    </vid>                                   // 
        </vsend> => .Bag)                                            // 
      </sendstore>                                                   // 
    </rec>                                                           // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => #append(Q;R)  </what>                       // 
      <where> Z:Names => #append(Y;Z) </where>                       // 
      <rid>   J                         </rid>                       // 
      <rnum>  U:Int => U +Int 1        </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // waiting for all info to be collected before reaction occurs
    </reaction>                                                      // 
    <rec>                                                            // virtual send management
      <id> H:Int </id>                                               // 
      <length> _:Int </length>                                       // 
      <cont>   _:Proc  </cont>                                       // 
      <listens>...                                                   // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>  #bvar(C) </vars>                          // 
                   <num>      N      </num>                          // 
                   <type> #rtype(C) </type>                          // 
                 </listen>)                                          // 
      </listens>                                                     // 
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins (send was already consumed)
      <nono>  S:Set => S -Set SetItem(I) </nono>                     // delete send id from the nono set in all joins
      <bindstore>...                                                 // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> C:Bind </bind>                                      // 
          <bid>  I       </bid>                                      // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   //  
      <sendstore>...                                                 // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  N  </vlen>                                        // 
           <vtype> 0 </vtype>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
      </sendstore>                                                   // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X </schan>                                           // 
        <msg>   Q   </msg>                                           // 
        <tuple> N </tuple>                                           // 
        <stype> 0 </stype>                                           // 
        <sid>   I   </sid>                                           // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    requires (H =/=Int J) andBool (I in S) andBool (L >Int U) [comm] // 

  rule
    <reaction>                                                       // continue populating <reaction/>
      <who>   P:Proc                 </who>                          // relocate continuation & substitution info to <reaction/>
      <what>  _                     </what>                          // 
      <where> _                    </where>                          // 
      <rid>   J:Int                  </rid>                          // 
      <rnum>  L:Int                 </rnum>                          // once reaction number = number of listens in receive with id J
      <react> "collect" => "react" </react>                          // once all info is collected, reaction begins
    </reaction>                                                      // 
   (<rec>                                                            // number of listens in receive
      <id>      J      </id>                                         //  
      <length>  L  </length>                                         // 
      <cont>    P    </cont>                                         // 
      <listens> _ </listens>                                         // 
      <match>   L   </match>                                         // once match count is equal to listen length: initialize comm
      <nono>    _    </nono>                                         // 
      <bindstore> _ </bindstore>                                     // 
      <sendstore> _ </sendstore>                                     // 
    </rec> => .Bag)                                                  // 

// Single listen, repeated send
// <rec/> immediately consumed
// Send info NOT dissolved from <sendstore/>s and corresponding <bind/>s in <bindstore/> are restored as <listen/>s to <listens/>
// 1-tuple
  rule                                                               // to be consumed linear sends and receive
    <rec>                                                            // number of listens in receive
      <id>      J:Int     </id>                                      //  
      <length>  L:Int </length>                                      // 
      <cont>    P:Proc  </cont>                                      // 
      <listens> _    </listens>                                      // 
      <match>   L      </match>                                      // once match count is equal to listen length: initialize comm
      <nono>    _       </nono>                                      // 
      <bindstore>...                                                 // 
       (<pair>                                                       // 
          <bind> Y:Name <- X:Name </bind>                            // 
          <bid>  I:Int             </bid>                            // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   // 
      <sendstore>...                                                 // 
       (<vsend>                                                      // 
          <vchan>  X:Name </vchan>                                   // 
          <vmsg>   Q:Proc  </vmsg>                                   // 
          <vlen>   1       </vlen>                                   // 
          <vtype>  1      </vtype>                                   // repeated send
          <vid>    I        </vid>                                   // 
        </vsend> => .Bag)                                            // 
      </sendstore>                                                   // 
    </rec>                                                           // 
    <reaction>                                                       // relocate continuation & substitution info to <reaction/>
      <who>   .K => P       </who>                                   // 
      <what>  .K => Q      </what>                                   // 
      <where> .K => Y     </where>                                   // 
      <rid>   .K => J       </rid>                                   // 
      <rnum>  .K => 1      </rnum>                                   // 
      <react> .K => false </react>                                   // wait for all info to be collected before reaction occurs
    </reaction>                                                      // 
    <rec>                                                            // virtual send management
      <id> H:Int </id>                                               // 
      <length> _:Int </length>                                       // 
      <cont>   _:Proc  </cont>                                       // 
      <listens>...                                                   // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>  #bvar(B) </vars>                          // 
                   <num>      1      </num>                          // 
                   <type> #rtype(B) </type>                          // 
                 </listen>)                                          // 
      </listens>                                                     // 
      <match> M:Int => M -Int 1 </match>                             // decrease match count in all joins (send was already consumed)
      <nono>  _                  </nono>                             // delete send id from the nono set in all joins
      <bindstore>...                                                 // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> B:Bind </bind>                                      // 
          <bid>  I       </bid>                                      // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   //  
      <sendstore>...                                                 // delete corresponding virtual send from <sendstore/> in all joins
         <vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  1  </vlen>                                        // 
           <vtype> 1 </vtype>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend>                                                    //
      </sendstore>                                                   // 
    </rec>                                                           // 
    requires H =/=Int J                                       [comm] // 
/*
// N-tuple, N > 2
  rule                                                               // consume single receive
   (<rec>                                                            // 
      <id>     0        </id>                                        // 
      <length> 1    </length>                                        // 
      <cont>   P:Proc </cont>                                        // continuation P
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Names </vars>                                     // variables Y binding in continuation P
          <num>  N:Int    </num>                                     // N variables
          <type> 0       </type>                                     // consumable
        </listen>                                                    // 
      </listens>                                                     // 
 ...</rec> => .Bag)                                                  //
    <send>                                                           // consume single send
      <schan> X       </schan>                                       // channel X
      <msg>   Q:Procs   </msg>                                       // message Q
      <tuple> N       </tuple>                                       // N-tuple
      <stype> 1       </stype>                                       // repeated send
      <sid>   I:Int     </sid>                                       // 
    </send>                                                          //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
    <rec>                                                            // virtual send management
      <id>      _:Int     </id>                                      // 
      <length>  _:Int </length>                                      // 
      <cont>    _:Proc  </cont>                                      // 
      <listens>                                                      // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>     Z     </vars>                          // 
                   <num>  #length(Z) </num>                          // 
                   <type>     0     </type>                          // 
                 </listen>)                                          // 
   ...</listens>                                                     // 
      <match> _:Int </match>                                         // 
      <nono>  _:Set  </nono>                                         // 
      <bindstore>                                                    // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> Z:Names <- X </bind>                                // 
          <bid>  I             </bid>                                // 
        </pair> => .Bag)                                             // 
   ...</bindstore>                                                   // 
 ...</rec>                                                           // repeated send => do not delete corresponding <vsend/> from <sendstore/>
                                                              [comm] // tagged "comm" for tracking nondeterminism

// Repeated listen, single send
// <send/> immediately consumed
// Send info dissolved from all <sendstore/>s and corresponding <bind/>s in <bindstore/> are restored as <listen/>s to <listens/>
// 1-tuple
  rule                                                               // consume single send
    <rec>...                                                         // 
      <cont> P:Proc </cont>                                          // continuation P
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Name  </vars>                                     // variable Y binding in continuation P
          <num>  1        </num>                                     //
          <type> 1       </type>                                     // unconsumable
        </listen>                                                    // 
      </listens>                                                     // 
 ...</rec>                                                           //
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
    <rec>                                                            // virtual send management
      <id>      _:Int     </id>                                      // 
      <length>  _:Int </length>                                      // 
      <cont>    _:Proc  </cont>                                      // 
      <listens>                                                      // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>     Z     </vars>                          // 
                   <num>  #length(Y) </num>                          // 
                   <type>     0     </type>                          // 
                 </listen>)                                          // 
   ...</listens>                                                     // 
      <match> M:Int => M -Int 1        </match>                      // decrease match count in all joins (send was consumed)
      <nono> S:Set => S -Set SetItem(I) </nono>                      // delete send id from the nono set in all joins
      <bindstore>                                                    // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> Z:Name <= X </bind>                                 // 
          <bid>  I            </bid>                                 // 
        </pair> => .Bag)                                             // 
   ...</bindstore>                                                   //  
      <sendstore>                                                    // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  1  </vlen>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
   ...</sendstore>                                                   // 
    </rec>                                                           //
                                                              [comm] // tagged "comm" for tracking nondeterminism
// N-tuple, N > 2
  rule                                                               // consume single send, single receive
   (<rec>...                                                         // 
      <cont> P:Proc </cont>                                          // continuation P
      <listens>                                                      // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> Y:Names </vars>                                     // variables Y binding in continuation P
          <num>  N:Int    </num>                                     //
          <type> 0       </type>                                     // consumable
        </listen>                                                    // 
      </listens>                                                     // 
 ...</rec> => .Bag)                                                  //
   (<send>                                                           // consume single send
      <schan> X       </schan>                                       // channel X
      <msg>   Q:Procs   </msg>                                       // message Q
      <tuple> N       </tuple>                                       // 1-tuple
      <stype> 0       </stype>                                       // single send
      <sid>   I:Int     </sid>                                       // 
    </send> => .Bag)                                                 //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
      <rid>   .K => 0   </rid>                                       // 
      <react> .K => 1 </react>                                       // 
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
    <rec>                                                            // virtual send management
      <id>      _:Int     </id>                                      // 
      <length>  _:Int </length>                                      // 
      <cont>    _:Proc  </cont>                                      // 
      <listens>                                                      // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>     Z     </vars>                          // 
                   <num>  #length(Z) </num>                          // 
                   <type>     0     </type>                          // 
                 </listen>)                                          // 
   ...</listens>                                                     // 
      <match> M:Int => M -Int 1        </match>                      // decrease match count in all joins
      <nono> S:Set => S -Set SetItem(I) </nono>                      // delete send id from the nono set in all joins
      <bindstore>                                                    // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> Z:Names <- X </bind>                                // 
          <bid>  I             </bid>                                // 
        </pair> => .Bag)                                             // 
   ...</bindstore>                                                   //  
      <sendstore>                                                    // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  1  </vlen>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
   ...</sendstore>                                                   // 
    </rec>                                                           //
                                                              [comm] // tagged "comm" for tracking nondeterminism

// Join comms
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
      <stype> T:Int   </stype>                                       // consumable send
      <sid>   I:Int     </sid>                                       // 
    </send> => .Bag)                                                 //
    <reaction>                                                       //
	    <who>   .K => P   </who>                                       //
	    <what>  .K => Q  </what>                                       //
	    <where> .K => Y </where>                                       //
	  </reaction>                                                      // ultimately spawns a single <thread/> holding P[@Q / Y]
    <rec>                                                            // virtual send management
      <id>      _:Int     </id>                                      // 
      <length>  _:Int </length>                                      // 
      <cont>    _:Proc  </cont>                                      // 
      <listens>...                                                   // 
        (.Bag => <listen>                                            // restore listen to <listens/> in all joins
                   <chan>     X     </chan>                          // 
                   <vars>     Z     </vars>                          // 
                   <num>  #length(Z) </num>                          // 
                   <type>     0     </type>                          // 
                 </listen>)                                          // 
      </listens>                                                     //
      <nono> S:Set => S -Set SetItem(I) </nono>                      // delete send id from the nono set in all joins
      <bindstore>...                                                 // delete corresponding bind/id <pair/> and restore corresponding <listen/> to <listens/> in all joins
       (<pair>                                                       // 
          <bind> Z:Name <- X </bind>                                 // 
          <bid>  I            </bid>                                 // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   //  
      <sendstore>...                                                 // delete corresponding virtual send from <sendstore/> in all joins
        (<vsend>                                                     // 
			     <vchan> X </vchan>                                        // 
			     <vmsg>  Q  </vmsg>                                        // 
			     <vlen>  1  </vlen>                                        // 
					 <vtype> T </vtype>                                        // 
			     <vid>   I   </vid>                                        // 
			   </vsend> => .Bag)                                           //
      </sendstore>                                                   // 
    </rec>                                                           //
                                                              [comm] // tagged "comm" for tracking nondeterminism

// Eliminate no longer useful Nothing cells
  rule
    <rec>...
      <nono> S:Set </nono>                                           // 
      <bindstore>...                                                 // 
       (<pair>                                                       // 
          <bind> Nothing </bind>                                     // 
          <bid>  Nothing  </bid>                                     // 
        </pair> => .Bag)                                             // 
      </bindstore>                                                   // 
      <sendstore>...                                                 // 
       (<vsend>                                                      // 
          <vchan> Nothing </vchan>                                   // 
          <vmsg>  Nothing  </vmsg>                                   // 
          <vlen>  Nothing  </vlen>                                   // 
          <vtype> Nothing </vtype>                                   // 
          <vid>   Nothing   </vid>                                   // 
        </vsend> => .Bag)                                            // 
      </sendstore>                                                   // 
    </rec>                                                           //
    when size(S) >=Int 0                                             // 

  rule
    <rec>...
      <listens>...                                                   // 
       (<listen>                                                     //
          <chan> Nothing </chan>                                     //
          <vars> Nothing </vars>                                     // 
          <num>  Nothing  </num>                                     // 
          <type> Nothing </type>                                     // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
      <nono> S:Set </nono>                                           // 
 ...</rec>                                                           //
    when size(S) >=Int 0                                             // 
*/
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