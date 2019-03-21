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
    <T color="purple">                                               // obligatory top cell
      <threads color="red">                                          //**process threads** (concurrent activity)
        <thread multiplicity="*">                                    // 
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
            <mlid> .Set </mlid>                                      // set of matching listen ids; for consumable sends, these listens will need to forget the send id when it is consumed
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      // each receive is a bag of listens and a continuation
            <id>     .K     </id>                                    // receive id - ensures that only listens from the same receive are packaged together and reaction info only comes from one receive at a time
            <length> .K </length>                                    // number of listens in receive
            <cont>   .K   </cont>                                    // continuation
            <state>  .K  </state>                                    // "load" if initializing, "" if matching, "matched" if all listens have been matched and we're ready to move everything to <reaction/>, "collection" if currently moving info to <reaction/>
            <match>  .K  </match>                                    // number of matches made
            <type>   .K   </type>                                    // 0 = linear (consumable), 1 = persistent (consumable), 2 = peek (consumable)
            <nomo>  .Set  </nomo>                                    // set of send ids not to match further with (because they are consumable and have already been matched by a listen in the receive)
            <listens>                                                // 
              <listen color="green" multiplicity="*">                // bag of listens
                <chan>  .K  </chan>                                  // receiving channel (many messages on same channel)
                <vars>  .K  </vars>                                  // binding varible(s) in continuation
                <num>   .K   </num>                                  // number of bindings
                <lid>   .K   </lid>                                  // listen id
                <msid>  .K  </msid>                                  // id of matched send
              </listen>                                              // 
            </listens>                                               // 
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction>                                                     //**where the magic happens**
        <who>   .K      </who>                                       // continuation
        <what>  .K     </what>                                       // msg process(es)
        <where> .K    </where>                                       // binding variable(s)
        <rid>   .K      </rid>                                       // receive id; which receive is info being collected from
        <rnum>  .K     </rnum>                                       // reaction count
        <react> .K    </react>                                       // "collect" = collect relevant info from send(s) and receive, "forget" = forget send ids, "react" = substitute (allows multiple sends to be collected for joins)
        <forg>  .K     </forg>                                       // set of listen ids which need to forget the consumed send id
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
  rule true  and B:Bool => B                              [anywhere] //
  rule false and _:Bool => false                          [anywhere] //

// String
  rule S1:String + S2:String => S1 +String S2             [anywhere] //

// New Operator Semantics
  rule new N:Name in { P:Proc } => P[unforgeable(!I:Int) / N]        //
  rule new M:Name , N:Name  in { P:Proc } => new N in { P[unforgeable(!I:Int) / M] }  // 
  rule new M:Name , N:Names in { P:Proc } => new N in { P[unforgeable(!I:Int) / M] }  //

// Par Operator Semantics: par => bag of concurrently executing processes
  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>           // puts each parallel process
       (.Bag => <thread> <k> P </k> </thread>)                       // in into its own k cell
       (.Bag => <thread> <k> Q </k> </thread>)                [load] // 

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule <k> S:Send => . ...</k>                                       // dissolve Send and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>        #chan(S)  </schan>                  // sending channel X
                  <msg>           #msg(S)    </msg>                  // message(s) P
                  <tuple> #length(#msg(S)) </tuple>                  // length of tuple - how many messages
                  <stype>       #stype(S)  </stype>                  // send type
                  <sid>         !I:Int       </sid>                  // send id
                  <mlid>         .Set       </mlid>                  // initially no matching listens
                </send>)                                      [load] // 

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------

// Single Listen Receive
  rule <k> R:SingleRec => . ...</k>                                  // dissolve Rec and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>       !I:Int    </id>                         // 
                  <length>    1    </length>                         // 
                  <cont>   #cont(R)  </cont>                         // continuation
                  <state>     ""    </state>                         // matching is initiated immediately for single listen receives
                  <match>     0     </match>                         // initialized with 0 matches
                  <type>  #rtype(R)  </type>                         // receive type
                  <nomo>     .Set    </nomo>                         // initialized with empty nomo set
                  <listens>                                          // 
                    <listen>                                         // add <listen/> to <listens/>
                      <chan>  #chan(R) </chan>                       // receiving channel
                      <vars>  #bvar(R) </vars>                       // variable Y binding in continuation
                      <num>   #bnum(R)  </num>                       // number of variables to bind
	  <lid>    !J:Int   </lid>                       // listen id
                      <msid>     ""    </msid>                       // matched send id
                    </listen>                                        // 
                  </listens>                                         // 
                </rec>)                                       [load] // 

/* 
   --- Joins (Multiple Listen Receives) are immediately id wrapped ---
   For joins, we initialize a rec cell containing a fresh rec id, number of listens, continuation, loading comm status, match count of 0, 
   type of listens, an empty nomo (matching consumable send id) set, and an empty listen (needed to concretize <rec/>)
*/
  rule <k> R:MultiRec => {[ R ; !I:Int ]} ...</k>                    // generate id & wrap join
       (.Bag => <rec>                                                // 
                  <id>        !I        </id>                        // 
                  <length> #bnum(R) </length>                        // number of listens in receive
                  <cont>   #cont(R)   </cont>                        // continuation
                  <state>   "load"   </state>                        // loading is initialized
                  <match>      0     </match>                        // initialized with 0 matches
                  <type>  #rtype(R)   </type>                        // receive type
                  <nomo>     .Set     </nomo>                        // 
                  <listens>                                          //    
                    <listen>                                         // something needs to go here to concretize the configuration
                      <chan>  ""  </chan>                            // these empty strings are immediately deleted once loading is complete
                      <vars>  ""  </vars>                            // 
                      <num>   ""   </num>                            // 
	  <lid>   ""   </lid>                            // 
                      <msid>  ""  </msid>                            // 
                    </listen>                                        // 
                  </listens>                                         // 
                </rec>)                                       [load] // generate <rec/> with id !I, #bnum(R) listens, and continuation #cont(R)

// Next, each listen is processed within the id wrapped join into the <listen/> in the <rec/> with appropriate id
// Terminating case
  rule <k> {[ R:SingleRec ; I:Int ]} => . ...</k>                    // intitialize matching once loading is complete
       <rec>                                                         // 
         <id>       I            </id>                               // 
         <length>   _:Int    </length>                               // 
         <cont>     _:Proc     </cont>                               // 
         <state> "load" => "" </state>                               // matching initialized, loading disengaged
         <match>    0         </match>                               // start with 0 matches
         <type>     _          </type>                               // receive type
         <nomo>    .Set        </nomo>                               // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(R) </chan>                        // receiving channel
                      <vars> #bvar(R) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(R)  </num>                        // number of variables to bind
	  <lid>  !J:Int    </lid>                        // listen id
                      <msid>    ""    </msid>                        // initially not matched
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                 [load] // 

// Recursive steps (there are several rules to handle all of the cases here because Binds ::= Lbinds | Pbinds | Rbinds and the Xbinds are 2 or more)
// Linear
// 2 single listen joins
  rule <k> {[ for( A:Lbind ; B:Lbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
         <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <state>  "load" </state>                                    // loading
         <match>  0      </match>                                    // 0 matches
         <type>   0       </type>                                    // linear
         <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
	  <lid>   !J:Int   </lid>                        // listen id
                      <msid>    ""    </msid>                        // initially not matched
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                 [load] // 

// N linear listen joins, N > 2
  rule <k> {[ for( A:Lbind ; B:Lbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
         <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <state>  "load" </state>                                    // loading
         <match>  0      </match>                                    // 0 matches
         <type>   0       </type>                                    // linear
         <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
	  <lid>   !J:Int   </lid>                        // listen id
                      <msid>    ""    </msid>                        // initially not matched
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                [load]  // 

// Repeated
// 2 repeated listen joins
  rule <k> {[ for( A:Rbind ; B:Rbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
         <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <state>  "load" </state>                                    // loading
         <match>  0      </match>                                    // 0 matches
         <type>   1       </type>                                    // repeated
         <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
	  <lid>   !J:Int   </lid>                        // listen id
                      <msid>    ""    </msid>                        // initially not matched
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                 [load] // 

// N repeated listen joins, N > 2
  rule <k> {[ for( A:Rbind ; B:Rbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
         <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <state> "load"  </state>                                    // loading
         <match>  0      </match>                                    // 0 matches
         <type>   1       </type>                                    // repeated
         <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
	  <lid>   !J:Int   </lid>                        // listen id
                      <msid>    ""    </msid>                        // initially not matched
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                 [load] // 

// Peek
// 2 peek joins
  rule <k> {[ for( A:Pbind ; B:Pbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
         <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <state> "load"  </state>                                    // loading
         <match>  0      </match>                                    // 0 matches
         <type>   2       </type>                                    // peek
         <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
	  <lid>   !J:Int   </lid>                        // listen id
                      <msid>    ""    </msid>                        // initially not matched
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                 [load] // 

// N peek joins, N > 2
  rule <k> {[ for( A:Pbind ; B:Pbinds ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
         <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
         <state> "load"  </state>                                    // loading
         <match>  0      </match>                                    // 0 matches
         <type>   2       </type>                                    // peek
         <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <lid>   !J:Int   </lid>                        // listen id
                      <msid>    ""    </msid>                        // initially not matched
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                 [load] // 

//----------------------------------
//--- Send/Listen Matching Rules ---
//----------------------------------
/* When a listen matches a send, three things happen simultaneously:
   1. The match count is increased.
   2. If the send is consumable, the send id is added to nomo set (so it cannot also be matched by another listen in this join). 
      If the send is unconsumable, the id is NOT added to the nomo set (so it can be matched again by another listen in this join).
   3. The matched listen has the matching send id written in its <msid/> (so it doesn't match another send).
*/
// Consumable sends (add id to nomo set)
// 1-tuple
  rule
    <rec>...                                                         // 
      <length>      L:Int         </length>                          // L listen receive
      <cont>        _:Proc          </cont>                          // 
      <state>       ""             </state>                          // matching
      <match> M:Int => M +Int 1    </match>                          // increase match count
      <type>        _               </type>                          // any receive type
      <nomo>  S:Set => S SetItem(I) </nomo>                          // add send id to nomo set so it is not matched again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> _:Name  </vars>                                     // variable binding in continuation
          <num>  1        </num>                                     // 1 variable to bind
          <lid>  J:Int    </lid>                                     // 
          <msid> "" => I </msid>                                     // id of send mactching the listen
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   _:Proc  </msg>                                         // message
      <tuple> 1     </tuple>                                         // 1-tuple
      <stype> _     </stype>                                         // consumable send
      <sid>   I:Int   </sid>                                         // 
      <mlid>... .Set => SetItem(J) </mlid>                           // 
    </send>                                                          // 
    <reaction>                                                       // reaction cell must be empty
      <who>   .K   </who>                                            // 
      <what>  .K  </what>                                            // 
      <where> .K </where>                                            // 
      <rid>   .K   </rid>                                            // 
      <rnum>  .K  </rnum>                                            // 
      <react> .K </react>                                            // 
      <forg>  .K  </forg>                                            // 
    </reaction>                                                      // 
    requires notBool (I in S) andBool (L >Int M)             [match] // 

// N-tuple, N > 1
  rule
    <rec>...                                                         // 
      <length>      L:Int         </length>                          // L listen receive
      <cont>        _:Proc          </cont>                          // 
      <state>       ""             </state>                          // matching
      <match> M:Int => M +Int 1    </match>                          // increase match count
      <type>        _               </type>                          // any receive type
      <nomo>  S:Set => S SetItem(I) </nomo>                          // add send id to nomo set so it is not matched again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> _:Names </vars>                                     // variables binding in continuation
          <num>  N:Int    </num>                                     // N variables to bind
          <lid>  J:Int    </lid>                                     // listen id
          <msid> "" => I </msid>                                     // id of send mactching the listen
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   _:Procs </msg>                                         // messages
      <tuple> N     </tuple>                                         // 1-tuple
      <stype> _     </stype>                                         // consumable send
      <sid>   I:Int   </sid>                                         // 
      <mlid>... .Set => SetItem(J) </mlid>                           // 
    </send>                                                          // 
    <reaction>                                                       // reaction cell must be empty
      <who>   .K   </who>                                            // 
      <what>  .K  </what>                                            // 
      <where> .K </where>                                            // 
      <rid>   .K   </rid>                                            // 
      <rnum>  .K  </rnum>                                            // 
      <react> .K </react>                                            // 
      <forg>  .K  </forg>                                            // 
    </reaction>                                                      // 
    requires notBool (I in S) andBool (L >Int M)             [match] // 

//-------------------
//--- COMM EVENTS ---
//-------------------
// Reaction Cell Semantics - quarantine for collection substitutions resulting from a comm event
// ensures consumable sends (listens) are only consumed once by one process and consumable listens are only consumed
  rule 
    <reaction>                                                       // 
      <who>   P:Proc => P[@ Q / Y]    </who>                         // 
      <what>  Q:Proc , R:Procs => R  </what>                         // 
      <where> Y:Name , Z:Names => Z </where>                         // 
      <rid>          _                </rid>                         // 
      <rnum>         _               </rnum>                         // 
      <react>     "react"           </react>                         // substitution only happens in react mode
      <forg>       .Set              </forg>                         // 
    </reaction>                                               [comm] // 

  rule
    <reaction>                                                       // 
      <who>   P:Proc => P[@ Q / Y]    </who>                         // 
      <what>  Q:Proc , R:Proc => R   </what>                         // 
      <where> Y:Name , Z:Name => Z  </where>                         // 
      <rid>          _                </rid>                         // 
      <rnum>         _               </rnum>                         // 
      <react>     "react"           </react>                         // substitution only happens in react mode
      <forg>       .Set              </forg>                         // 
    </reaction>                                               [comm] // 

  rule
    <reaction>                                                       // 
      <who>    P:Proc => .K   </who>                                 // 
      <what>   Q:Proc => .K  </what>                                 // 
      <where>  Y:Name => .K </where>                                 // 
      <rid>    I:Int  => .K   </rid>                                 // 
      <rnum>        _ => .K  </rnum>                                 // 
      <react> "react" => .K </react>                                 // when reaction is complete, we move to the collection phase 
      <forg>    .Set  => .K  </forg>                                 // 
    </reaction>                                                      // 
    <threads>...                                                     // 
    (.Bag => <thread> <k> P[@Q / Y] </k> </thread>)                  // spawn a thread containing the fully substituted continuation
    </threads>                                                [comm] // 

// Consuming sends and forgetting send id in matching listens
// No other matching listens
  rule
    <rec>                                                            // receive that is populating reaction cell
      <id>          J         </id>                                  // to go back to collect, L must be > R (when L = R, we go to react phase)
      <length>    L:Int   </length>                                  // 
      <cont>        _       </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>       _      </match>                                  // 
      <type>        _       </type>                                  // 
      <nomo>        _       </nomo>                                  // 
      <listens>     _    </listens>                                  // 
    </rec>                                                           // 
    <reaction>                                                       // 
      <who>            _              </who>                         // 
      <what>           _             </what>                         // 
      <where>          _            </where>                         // 
      <rid>          J:Int            </rid>                         // 
      <rnum>         R:Int           </rnum>                         // 
      <react> "forget" => "collect" </react>                         // no listens need to forget the send id -> resume collection
      <forg>          .Set           </forg>                         // done forgetting
    </reaction>                                                      // 
    requires L >Int R                                                // 

// Other matching listens forget consumed send id recursively during forget phase
  rule
    <reaction>                                                       // 
      <who>               _              </who>                      // 
      <what>              _             </what>                      // 
      <where>             _            </where>                      // 
      <rid>               _              </rid>                      // 
      <rnum>              _             </rnum>                      // 
      <react>          "forget"        </react>                      // in forget phase, each matching listen forgets the consumed send id
      <forg> S:Set => S -Set SetItem(J) </forg>                      // for each element in <forg/>, the matching listen is located within a receive, the send id is forgotten and match count adjusted
    </reaction>                                                      // 
    <receives>...                                                    // 
      <rec>                                                          // 
        <id>          _              </id>                           // 
        <length>      _          </length>                           // 
        <cont>        _            </cont>                           // 
        <state>       _           </state>                           // 
        <match> M:Int => M -Int 1 </match>                           // decrease match count
        <type>        _            </type>                           // 
        <nomo>        _            </nomo>                           // 
        <listens>...                                                 // 
          <listen>                                                   // 
            <chan>   _         </chan>                               // 
            <vars>   _         </vars>                               // 
            <num>    _          </num>                               // 
            <lid>  J:Int        </lid>                               // listen id which needs to forget
            <msid> I:Int => "" </msid>                               // forget consumed send id
          </listen>                                                  // 
        </listens>                                                   // 
      </rec>                                                         // 
    </receives>                                                      // 
    requires J in S                                         [forget] // 

// Matched states
// Comm initializes when # of sends matched = # of listens in receive (i.e. match = length)
// enter matched state
  rule
    <rec>                                                            // 
      <id>        J:Int          </id>                               // 
      <length>    L:Int      </length>                               // 
      <cont>      P:Proc       </cont>                               // 
      <state> "" => "matched" </state>                               // once match count is equal to listen length: matched
      <match>     L           </match>                               // 
      <type>      _            </type>                               // 
      <nomo>      _            </nomo>                               // 
      <listens>   _         </listens>                               // 
    </rec>                                                 [matched] // 

// exit matched state during another receives reaction phase (in case multiple match states occur simultaneously)
  rule
    <rec>                                                            // 
      <id>        J:Int          </id>                               // 
      <length>    L:Int      </length>                               // 
      <cont>      P:Proc       </cont>                               // 
      <state> "matched" => "" </state>                               // if matched state is entered but there is another receive reacting
      <match>     M:Int       </match>                               // 
      <type>      _            </type>                               // 
      <nomo>      _            </nomo>                               // 
      <listens>   _         </listens>                               // 
    </rec>                                                           // 
    <reaction>                                                       // 
      <who>    _    </who>                                           // 
      <what>   _   </what>                                           // 
      <where>  _  </where>                                           // 
      <rid>  R:Int  </rid>                                           // 
      <rnum>   _   </rnum>                                           // 
      <react>  _  </react>                                           // 
      <forg>   _   </forg>                                           // 
    </reaction>                                                      // 
    requires J =/=Int R                                     [demote] // 


// after matched, move to collection phase
  rule
    <rec>                                                            // 
      <id>              J:Int              </id>                     // 
      <length>          L:Int          </length>                     // 
      <cont>            P:Proc           </cont>                     // 
      <state> "matched" => "collection" </state>                     // match count is equal to listen length in matched state
      <match>           L               </match>                     // 
      <type>            _                </type>                     // 
      <nomo>            _                </nomo>                     // 
      <listens>         _             </listens>                     // 
    </rec>                                                           //
    <reaction>                                                       // reaction cell must be empty for promotion to occur
      <who>   .K => P           </who>                               // 
      <what>  .K => ""         </what>                               // 
      <where> .K => ""        </where>                               // 
      <rid>   .K => J           </rid>                               // 
      <rnum>  .K => 0          </rnum>                               // 
      <react> .K => "collect" </react>                               // collect of substitutions is initiated
      <forg>  .K => .Set       </forg>                               // 
    </reaction>                                            [promote] // 

// after L collection/forget phases (after all listens have been processed), consume the receive (if consumable)
  rule
   (<rec>                                                            // consumable receives are consumed once collection/forgetting completes
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>       _        </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>      _       </match>                                  // 
      <type>     T:Int      </type>                                  // 
      <nomo>       _        </nomo>                                  // 
      <listens>    _     </listens>                                  // 
    </rec> => .Bag)                                                  // 
    <reaction>                                                       // 
      <who>            _            </who>                           // 
      <what>           _           </what>                           // 
      <where>          _          </where>                           // 
      <rid>            J            </rid>                           // 
      <rnum>           L           </rnum>                           // collection/forget phase completes when the reaction number matches the listen length
      <react> "forget" => "react" </react>                           // when collection is complete, react mode engages
      <forg>          .Set         </forg>                           // 
    </reaction>                                                      // 
    requires T =/=Int 1                                       [comm] // 

  rule
    <rec>                                                            // unconsumable receives persist and values are restored to initial
      <id>         J:Int            </id>                            // 
      <length>     L:Int        </length>                            // 
      <cont>         _            </cont>                            // 
      <state> "collection" => "" </state>                            // goes back to matching state
      <match>      L => 0        </match>                            // match count reset to 0
      <type>         1            </type>                            // unconsumable receive
      <nomo>   _:Set => .Set      </nomo>                            // nomo set is reset to empty
      <listens>      _         </listens>                            // 
    </rec>                                                           // 
    <reaction>                                                       // 
      <who>            _            </who>                           // 
      <what>           _           </what>                           // 
      <where>          _          </where>                           // 
      <rid>            J            </rid>                           // 
      <rnum>           L           </rnum>                           // collection/forget phase completes when the reaction number matches the listen length
      <react> "forget" => "react" </react>                           // when collection is complete, react mode engages
      <forg>          .Set         </forg>                           // 
    </reaction>                                               [comm] // 

//----------------------
//--- Comm Semantics ---
//----------------------
// Initialize reaction cell

// First...
// Consumable sends (send id forgotten by all other matching listens)
// Linear listens
// 1-tuple message
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // dissolve consumable listen
           <chan> X:Name </chan>                                     // 
           <vars> Y:Name </vars>                                     // 
           <num>  1       </num>                                     // 
           <lid>  V:Int   </lid>                                     // 
           <msid> I:Int  </msid>                                     // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>         "" => Q                 </what>                 // 
      <where>        "" => Y                </where>                 // 
      <rid>             J                     </rid>                 // 
      <rnum>          0 => 1                 </rnum>                 // start reaction count
      <react> "collect" => "forget"         </react>                 // once ids to forget are collected, forget them
      <forg>       .Set => S -Set SetItem(V) </forg>                 // 
    </reaction>                                         [initialize] // 

// N-tuple message
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // dissolve consumable listen
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // 
           <num>  N:Int    </num>                                    // 
           <lid>  V:Int   </lid>                                     // 
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>         "" => Q                 </what>                 // 
      <where>        "" => Y                </where>                 // 
      <rid>             J                     </rid>                 // 
      <rnum>          0 => 1                 </rnum>                 // start reaction count
      <react> "collect" => "forget"         </react>                 // forget ids
      <forg>       .Set => S -Set SetItem(V) </forg>                 // 
    </reaction>                                         [initialize] // 

// Reapeted listen
// 1-tuple message
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>    L         </match>                                  // 
      <type>     1          </type>                                  // 
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
         <listen>                                                    // repeated listen is not dissolved
           <chan> X:Name      </chan>                                // 
           <vars> Y:Name      </vars>                                // 
           <num>  1            </num>                                // 
           <lid>  V:Int        </lid>                                // 
           <msid> I:Int => "" </msid>                                // the consumed send id is forgotten
         </listen>                                                   // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>         "" => Q                 </what>                 // 
      <where>        "" => Y                </where>                 // 
      <rid>             J                     </rid>                 // 
      <rnum>          0 => 1                 </rnum>                 // start reaction count
      <react> "collect" => "forget"         </react>                 // forget ids
      <forg>       .Set => S -Set SetItem(V) </forg>                 // 
    </reaction>                                         [initialize] // 

// N-tuple message
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>    L         </match>                                  // 
      <type>     1          </type>                                  // repeated
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        <listen>                                                     // dissolve consumable listen
          <chan> X:Name      </chan>                                 // 
          <vars> Y:Names     </vars>                                 // 
          <num>  N:Int        </num>                                 // 
          <lid>  V:Int        </lid>                                 // 
          <msid> I:Int => "" </msid>                                 // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>         "" => Q                 </what>                 // 
      <where>        "" => Y                </where>                 // 
      <rid>             J                     </rid>                 // 
      <rnum>          0 => 1                 </rnum>                 // start reaction count
      <react> "collect" => "forget"         </react>                 // forget ids
      <forg>       .Set => S -Set SetItem(V) </forg>                 // 
    </reaction>                                         [initialize] // 

// Peek
// The send is not consumed so its id is not forgotten by other matching listens, the send forgets the listen id
// 1-tuple message
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>    L         </match>                                  // 
      <type>     2          </type>                                  // peek
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
       (<listen>                                                     // dissolve consumable listen
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Name  </vars>                                     // 
          <num>  1        </num>                                     // 
          <lid>  V:Int    </lid>                                     // 
          <msid> I:Int   </msid>                                     // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // 
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set => S -Set SetItem(V) </mlid>                   // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>             P             </who>                         // relocate continuation & substitution info to <reaction/>
      <what>         "" => Q         </what>                         // 
      <where>        "" => Y        </where>                         // 
      <rid>             J             </rid>                         // 
      <rnum>          0 => 1         </rnum>                         // start reaction count
      <react> "collect" => "forget" </react>                         // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set          </forg>                         // send will not be consumed
    </reaction>                                         [initialize] // 

// N-tuple message
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>    L         </match>                                  // 
      <type>     2          </type>                                  // peek
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
       (<listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Names </vars>                                     // 
          <num>  N:Int    </num>                                     // 
          <lid>  V:Int    </lid>                                     // 
          <msid> I:Int   </msid>                                     // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     <send>                                                          // will not be consumed from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>             P             </who>                         // relocate continuation & substitution info to <reaction/>
      <what>         "" => Q         </what>                         // 
      <where>        "" => Y        </where>                         // 
      <rid>             J             </rid>                         // 
      <rnum>          0 => 1         </rnum>                         // start reaction count
      <react> "collect" => "forget" </react>                         // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set          </forg>                         // send will not be consumed
    </reaction>                                         [initialize] // 
    
// Unconsumable Sends & Linear Receives
// 1-tuple message
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
       (<listen>                                                     // dissolve consumable listen
          <chan> X:Name </chan>                                      // 
          <vars> Y:Name </vars>                                      // 
          <num>  1       </num>                                      // 
          <lid>  V:Int   </lid>                                      // 
          <msid> I:Int  </msid>                                      // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // 
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 1     </stype>                                       // unconsumable
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>             P             </who>                         // relocate continuation & substitution info to <reaction/>
      <what>         "" => Q         </what>                         // 
      <where>        "" => Y        </where>                         // 
      <rid>             J             </rid>                         // 
      <rnum>          0 => 1         </rnum>                         // start reaction count
      <react> "collect" => "forget" </react>                         // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set          </forg>                         // send will not be consumed
    </reaction>                                         [initialize] // 

// N-tuple message
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // 
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
       (<listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Names </vars>                                     // 
          <num>  N:Int    </num>                                     // 
          <lid>  V:Int   </lid>                                      // 
          <msid> I:Int   </msid>                                     // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     <send>                                                          // will not be consumed from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 1     </stype>                                       // unconsumable
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>             P             </who>                         // relocate continuation & substitution info to <reaction/>
      <what>         "" => Q         </what>                         // 
      <where>        "" => Y        </where>                         // 
      <rid>             J             </rid>                         // 
      <rnum>          0 => 1         </rnum>                         // start reaction count
      <react> "collect" => "forget" </react>                         // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set          </forg>                         // send will not be consumed
    </reaction>                                         [initialize] // 

//////////////////////////////////////////////////////
///  COLLECTION - after reaction is initialized   ///
//////////////////////////////////////////////////////
// Linear Receives & Consumable Sends
// single name and proc currently in <reaction/>
// adding single name and proc (consumable listen)
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
       (<listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Name  </vars>                                     // 1-tuple
          <num>  1        </num>                                     // 
          <lid>  V:Int    </lid>                                     // 
          <msid> I:Int   </msid>                                     // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // to be consumed from tuplespace, added to <forg/>
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>    R:Proc  => Q , R             </what>                 // single proc initially in <reaction/>
      <where>   Z:Name  => Y , Z            </where>                 // single name initially in <reaction/>
      <rid>             J                     </rid>                 // 
      <rnum>          1 => 2                 </rnum>                 // increase reaction number
      <react> "collect" => "forget"         </react>                 // go to forget phase
      <forg>       .Set => S -Set SetItem(V) </forg>                 // these listen ids will forget I
    </reaction>                                            [collect] // 

// adding multiple names and procs to <reaction/>
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // number of listens in receive
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N variables to bind
           <num>  N:Int    </num>                                    // 
           <lid>  V:Int    </lid>                                    // 
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // to be consumed send in tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       //
        <mlid>  S:Set  </mlid>                                       // set of matching listen ids 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>    R:Proc  => #append(Q;R)      </what>                 // single proc initially in <reaction/>
      <where>   Z:Name  => #append(Y;Z)     </where>                 // single name initially in <reaction/>
      <rid>             J                     </rid>                 // 
      <rnum>          1 => 2                 </rnum>                 // increase reaction number
      <react> "collect" => "forget"         </react>                 // go to forget phase
      <forg>       .Set => S -Set SetItem(V) </forg>                 // these listen ids will forget I
    </reaction>                                            [collect] // 

// multiple names and procs currently in <reaction/> => adding sinlge name and proc
  rule
    <rec>                                                            // number of listens in receive
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "matched" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <lid>  V:Int    </lid>                                    // 
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>    R:Procs => Q , R             </what>                 // multiple procs currently in <reaction/>
      <where>   Z:Names => Y , Z            </where>                 // multiple names currently in <reaction/>
      <rid>             J                     </rid>                 // 
      <rnum>      U:Int => U +Int 1          </rnum>                 // increase reaction number
      <react> "collect" => "forget"         </react>                 // go to forget phase
      <forg>       .Set => S -Set SetItem(V) </forg>                 // these listen ids will forget I
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 

// multiple names and procs currently in <reaction/> => adding sinlge name and proc
  rule
    <rec>                                                            // number of listens in receive
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "matched" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N-tuple
           <num>  N:Int    </num>                                    // 
           <lid>  V:Int    </lid>                                    // 
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>    R:Procs => #append(Q;R)      </what>                 // multiple procs currently in <reaction/>
      <where>   Z:Names => #append(Y;Z)     </where>                 // multiple names currently in <reaction/>
      <rid>             J                     </rid>                 // 
      <rnum>      U:Int => U +Int 1          </rnum>                 // increase reaction number
      <react> "collect" => "forget"         </react>                 // go to forget phase
      <forg>       .Set => S -Set SetItem(V) </forg>                 // these listen ids will forget I
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 

// Persistent Receives & Consumable Sends
// single name and proc currently in <reaction/>
// adding single name and proc (consumable listen)
  rule
    <rec>                                                            // number of listens in receive
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collection" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     1          </type>                                  // repeated
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name      </chan>                                 // 
          <vars> Y:Name      </vars>                                 // 1-tuple
          <num>  1            </num>                                 // 
          <lid>  V:Int        </lid>                                 // 
          <msid> I:Int => "" </msid>                                 // forget send id
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>    R:Proc  => Q , R             </what>                 // single proc initially in <reaction/>
      <where>   Z:Name  => Y , Z            </where>                 // single name initially in <reaction/>
      <rid>             J                     </rid>                 // 
      <rnum>          1 => 2                 </rnum>                 // increase reaction number
      <react> "collect" => "forget"         </react>                 // go to forget phase
      <forg>       .Set => S -Set SetItem(V) </forg>                 // these listen ids will forget I
    </reaction>                                            [collect] // 

// adding multiple names and procs to <reaction/>
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collection" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     1          </type>                                  // repeated
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name      </chan>                                 // 
          <vars> Y:Names     </vars>                                 // N-tuple
          <num>  N:Int        </num>                                 // 
          <lid>  V:Int        </lid>                                 // 
          <msid> I:Int => "" </msid>                                 // forget send id
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>    R:Proc  => #append(Q;R)      </what>                 // single proc initially in <reaction/>
      <where>   Z:Name  => #append(Y;Z)     </where>                 // single name initially in <reaction/>
      <rid>             J                     </rid>                 // 
      <rnum>          1 => 2                 </rnum>                 // increase reaction number
      <react> "collect" => "forget"         </react>                 // go to forget phase
      <forg>       .Set => S -Set SetItem(V) </forg>                 // these listen ids will forget I
    </reaction>                                            [collect] // 

// multiple names and procs currently in <reaction/> => adding sinlge name and proc
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collection" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     1          </type>                                  // repeated
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name      </chan>                                 // 
          <vars> Y:Name      </vars>                                 // 1-tuple
          <num>  1            </num>                                 // 
          <lid>  V:Int        </lid>                                 // 
          <msid> I:Int => "" </msid>                                 // forget send id
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>    R:Procs => Q , R             </what>                 // multiple procs currently in <reaction/>
      <where>   Z:Names => Y , Z            </where>                 // multiple names currently in <reaction/>
      <rid>             J                     </rid>                 // 
      <rnum>      U:Int => U +Int 1          </rnum>                 // increase reaction number
      <react> "collect" => "forget"         </react>                 // go to forget phase
      <forg>       .Set => S -Set SetItem(V) </forg>                 // these listen ids will forget I
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 

// multiple names and procs currently in <reaction/> => adding sinlge name and proc
  rule
    <rec>                                                            // 
      <id>        J:Int       </id>                                  // 
      <length>    L:Int   </length>                                  // 
      <cont>      P:Proc    </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>     L        </match>                                  // 
      <type>      1         </type>                                  // repeated
      <nomo>      _         </nomo>                                  // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name      </chan>                                 // 
          <vars> Y:Names     </vars>                                 // N-tuple
          <num>  N:Int        </num>                                 // 
          <lid>  V:Int        </lid>                                 // 
          <msid> I:Int => "" </msid>                                 // forget send id
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid>  S:Set  </mlid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                     </who>                 // relocate continuation & substitution info to <reaction/>
      <what>    R:Procs => #append(Q;R)      </what>                 // multiple procs currently in <reaction/>
      <where>   Z:Names => #append(Y;Z)     </where>                 // multiple names currently in <reaction/>
      <rid>             J                     </rid>                 // 
      <rnum>      U:Int => U +Int 1          </rnum>                 // increase reaction number
      <react> "collect" => "forget"         </react>                 // go to forget phase
      <forg>       .Set => S -Set SetItem(V) </forg>                 // these listen ids will forget I
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 
    
// Peeking Receives & any Sends
// single name and proc currently in <reaction/>
// adding single name and proc (consumable listen)
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     2          </type>                                  // peek
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <lid>  V:Int    </lid>                                    // listen id
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // NOT consumed from tuplespace
        <schan> X  </schan>                                          // 
        <msg> Q:Proc </msg>                                          // 
        <tuple> 1  </tuple>                                          // 
        <stype> _  </stype>                                          // 
        <sid>   I    </sid>                                          // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // forget listen id
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P             </who>                         // relocate continuation & substitution info to <reaction/>
      <what>    R:Proc  => Q , R     </what>                         // single proc initially in <reaction/>
      <where>   Z:Name  => Y , Z    </where>                         // single name initially in <reaction/>
      <rid>             J             </rid>                         // 
      <rnum>          1 => 2         </rnum>                         // increase reaction number
      <react> "collect" => "forget" </react>                         // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set          </forg>                         // send is not consumed so no listens need to forget
    </reaction>                                            [collect] // 

// adding multiple names and procs to <reaction/>
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     2          </type>                                  // peek
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N variables to bind
           <num>  N:Int    </num>                                    // 
           <lid>  V:Int    </lid>                                    // listen id to forget
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // to be consumed send in tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> _     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // forget listen id
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                 </who>                     // relocate continuation & substitution info to <reaction/>
      <what>    R:Proc  => #append(Q;R)  </what>                     // single proc initially in <reaction/>
      <where>   Z:Name  => #append(Y;Z) </where>                     // single name initially in <reaction/>
      <rid>             J                 </rid>                     // 
      <rnum>          1 => 2             </rnum>                     // increase reaction number
      <react> "collect" => "forget"     </react>                     // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set              </forg>                     // send is not consumed so no listens need to forget
    </reaction>                                            [collect] // 

// multiple names and procs currently in <reaction/> => adding sinlge name and proc
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     2          </type>                                  // peek
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <lid>  V:Int    </lid>                                    // listen id to forget
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> _     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // forget listen id
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P             </who>                         // relocate continuation & substitution info to <reaction/>
      <what>    R:Procs => Q , R     </what>                         // multiple procs currently in <reaction/>
      <where>   Z:Names => Y , Z    </where>                         // multiple names currently in <reaction/>
      <rid>             J             </rid>                         // 
      <rnum>      U:Int => U +Int 1  </rnum>                         // increase reaction number
      <react> "collect" => "forget" </react>                         // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set          </forg>                         // send is not consumed so no listens need to forget
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 

// multiple names and procs currently in <reaction/> => adding sinlge name and proc
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     2          </type>                                  // peek
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N-tuple
           <num>  N:Int    </num>                                    // 
           <lid>  V:Int    </lid>                                    // listen id to forget
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> _     </stype>                                       // 
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // forget listen id
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P                 </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => #append(Q;R)  </what>                       // multiple procs currently in <reaction/>
      <where> Z:Names => #append(Y;Z) </where>                       // multiple names currently in <reaction/>
      <rid>           J                 </rid>                       // 
      <rnum>    U:Int => U +Int 1      </rnum>                       // increase reaction number
      <react> "collect" => "forget"   </react>                       // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>         .Set              </forg>                       // send is not consumed so no listens need to forget
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 
    
// Unconsumable Sends & Receives with Linear Listens
// single name and proc currently in <reaction/>
// adding single name and proc (consumable listen)
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <lid>  V:Int    </lid>                                    // listen id to forget
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // 
        <schan> X  </schan>                                          // 
        <msg> Q:Proc </msg>                                          // 
        <tuple> 1  </tuple>                                          // 
        <stype> 1  </stype>                                          // unconsumable
        <sid>   I    </sid>                                          // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // forget listen id
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P               </who>                         // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => Q , R       </what>                         // single proc initially in <reaction/>
      <where> Z:Name  => Y , Z      </where>                         // single name initially in <reaction/>
      <rid>           J               </rid>                         // 
      <rnum>        1 => 2           </rnum>                         // increase reaction number
      <react> "collect" => "forget" </react>                         // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>         .Set            </forg>                         // send is not consumed so no listens need to forget
    </reaction>                                            [collect] // 

// adding multiple names and procs to <reaction/>
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N variables to bind
           <num>  N:Int    </num>                                    // 
           <lid>  V:Int    </lid>                                    // listen id to forget
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // 
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 1     </stype>                                       // unconsumable
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // forget listen id
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                 </who>                     // relocate continuation & substitution info to <reaction/>
      <what>    R:Proc  => #append(Q;R)  </what>                     // single proc initially in <reaction/>
      <where>   Z:Name  => #append(Y;Z) </where>                     // single name initially in <reaction/>
      <rid>             J                 </rid>                     // 
      <rnum>          1 => 2             </rnum>                     // increase reaction number
      <react> "collect" => "forget"     </react>                     // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set              </forg>                     // send is not consumed so no listens need to forget
    </reaction>                                            [collect] // 

// multiple names and procs currently in <reaction/> => adding sinlge name and proc
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <lid>  V:Int    </lid>                                    // listen id to forget
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // 
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 1     </stype>                                       // unconsumable
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // forget listen id
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P               </who>                         // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => Q , R       </what>                         // multiple procs currently in <reaction/>
      <where> Z:Names => Y , Z      </where>                         // multiple names currently in <reaction/>
      <rid>           J               </rid>                         // 
      <rnum>    U:Int => U +Int 1    </rnum>                         // increase reaction number
      <react> "collect" => "forget" </react>                         // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>         .Set            </forg>                         // send is not consumed so no listens need to forget
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 

// multiple names and procs currently in <reaction/> => adding sinlge name and proc
  rule
    <rec>                                                            // 
      <id>       J:Int        </id>                                  // 
      <length>   L:Int    </length>                                  // 
      <cont>     P:Proc     </cont>                                  // 
      <state> "collection" </state>                                  // "collecting" receives populate <reaction/>
      <match>    L         </match>                                  // 
      <type>     0          </type>                                  // linear
      <nomo>     _          </nomo>                                  // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N-tuple
           <num>  N:Int    </num>                                    // 
           <lid>  V:Int    </lid>                                    // listen id to forget
           <msid> I:Int   </msid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // 
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 1     </stype>                                       // unconsumable
        <sid>   I       </sid>                                       // 
        <mlid> S:Set => S -Set SetItem(V) </mlid>                    // forget listen id
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>             P                 </who>                     // relocate continuation & substitution info to <reaction/>
      <what>    R:Procs => #append(Q;R)  </what>                     // multiple procs currently in <reaction/>
      <where>   Z:Names => #append(Y;Z) </where>                     // multiple names currently in <reaction/>
      <rid>             J                 </rid>                     // 
      <rnum>      U:Int => U +Int 1      </rnum>                     // increase reaction number
      <react> "collect" => "forget"     </react>                     // no ids to forget, but still need to go to forget phase so we can complete reaction
      <forg>           .Set              </forg>                     // send is not consumed so no listens need to forget
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 

// Eliminate empty initializing listen cells
  rule
    <listens>...                                                     // 
      (<listen>                                                      // 
         <chan> "" </chan>                                           // 
         <vars> "" </vars>                                           // 
         <num>  ""  </num>                                           // 
         <lid>  ""  </lid>                                           // 
         <msid> "" </msid>                                           // 
      </listen> => .Bag)                                             // 
    </listens>                                          [structural] // 

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P                             [structural] // 
  rule P:Proc | Nil    => P                             [structural] // 

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag          [structural] // empty threads
  rule <thread> <k> Nil </k> </thread> => .Bag          [structural] // Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N                       [anywhere,structural] // 

// INVERSES
  rule   * @ P:Proc => P                       [anywhere,structural] // 

endmodule