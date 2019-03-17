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
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      // each receive is a bag of listens and a continuation
            <id>     .K     </id>                                    // join id - makes it so only listens from the same receive are packaged together and reaction info only comes from one receive at a time
            <length> .K </length>                                    // number of listens in receive
            <cont>   .K   </cont>                                    // continuation
            <comm>   .K   </comm>                                    // "load" if initializing, "" if initialized but not matched, "matched" if all listens have been matched and we're ready to move everything to <reaction/>, "processing" if currently moving info to <reaction/>
            <match>  .K  </match>                                    // number of matches made
            <type>   .K   </type>                                    // 0 = linear (consumed), 1 = persistent (not consumed), 2 = peek (consumed)
            <nomo>  .Set  </nomo>                                    // list of send ids not to match with (because they are consumable and have already been matched)
            <listens>                                                // 
              <listen multiplicity="*">                              // initially poulated and moved to <bindstore/> upon matching with a <send/>
                <chan> .K </chan>                                    // receiving channel (many messages on same channel)
                <vars> .K </vars>                                    // binding varible(s) in continuation
                <num>  .K  </num>                                    // number of bindings
                <msid> .K </msid>                                    // id of matched send
                <lid>  .K  </lid>                                    // listen id
              </listen>                                              // 
            </listens>                                               // 
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction>                                                     //**where the magic happens**
        <who>       .K      </who>                                   // continuation
        <what>      .K     </what>                                   // msg process(es)
        <where>     .K    </where>                                   // binding variable(s)
        <rid>       .K      </rid>                                   // receive id; which receive is info being collected from
        <rnum>      .K     </rnum>                                   // reaction count
        <react>     .K    </react>                                   // "collect" = collect relevant info from send(s) and receive, "react" = substitute (allows multiple sends to be collected for joins)
        <rset>     .Set    </rset>                                   // set of processed listen ids
        <reat>     .Set    </reat>                                   // set of send ids to consume from the tuplespace upon completion of a reaction
      </reaction>                                                    // once a comm is identified, all components are move here and all relevant cells are dissolved
      <consumable> .Set </consumable>                                // global set of consumable send ids 
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
  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>           // puts each process in parallel
       (.Bag => <thread> <k> P </k> </thread>)                       // into its own k cell
       (.Bag => <thread> <k> Q </k> </thread>)                       // 

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule <k> S:ConsumableSend => . ...</k>                             // dissolve Send and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>        #chan(S)  </schan>                  // sending channel X
                  <msg>           #msg(S)    </msg>                  // message(s) P
                  <tuple> #length(#msg(S)) </tuple>                  // length of tuple - how many messages
                  <stype>       #stype(S)  </stype>                  // send type
                  <sid>         !I:Int       </sid>                  // send id
                </send>)                                             //
        <consumable> C:Set => C SetItem(!I) </consumable>            // add send id to global consumable set

  rule <k> S:UnconsumableSend => . ...</k>                           // dissolve Send and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>        #chan(S)  </schan>                  // sending channel X
                  <msg>           #msg(S)    </msg>                  // message(s) P
                  <tuple> #length(#msg(S)) </tuple>                  // length of tuple - how many messages
                  <stype>       #stype(S)  </stype>                  // send type
                  <sid>         !I:Int       </sid>                  // send id
                </send>)                                             //

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------

// Single Listen Receive
  rule <k> R:SingleRec => . ...</k>                                  // dissolve Rec and spawn <rec/>
       (.Bag => <rec>                                                // 
                  <id>       !I:Int    </id>                         // 
		  <length>    1    </length>                         // 
                  <cont>   #cont(R)  </cont>                         // continuation
                  <comm>      ""     </comm>                         // matching is initiated immediately for single listen receives
                  <match>     0     </match>                         // initialized with 0 matches
		  <type>  #rtype(R)  </type>                         // receive type
                  <nomo>     .Set    </nomo>                         // initialized with empty nomo set
                  <listens>                                          // 
                    <listen>                                         // add <listen/> to <listens/>
                      <chan>  #chan(R) </chan>                       // receiving channel
                      <vars>  #bvar(R) </vars>                       // variable Y binding in continuation
                      <num>   #bnum(R)  </num>                       // number of variables to bind
                      <msid>     ""    </msid>                       // matched send id
		      <lid>    !L:Int   </lid>                       // 
                    </listen>                                        // 
                  </listens>                                         // 
                </rec>)                                              // 

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
                  <comm>    "load"    </comm>                        // loading is initialized
                  <match>      0     </match>                        // initialized with 0 matches
		  <type>  #rtype(R)   </type>                        // receive type
                  <nomo>     .Set     </nomo>                        // 
                  <listens>                                          //    
                    <listen>                                         // something needs to go here to concretize the configuration
                      <chan> "" </chan>                              // these empty strings are immediately deleted once loading is complete
                      <vars> "" </vars>                              // 
                      <num>  ""  </num>                              // 
                      <msid> "" </msid>                              // 
                      <lid>  ""  </lid>                              // 
                    </listen>                                        // 
                  </listens>                                         // 
                </rec>)                                              // generate <rec/> with id !I, #bnum(R) listens, and continuation #cont(R)

// Next, each listen is processed within the id wrapped join into the <listen/> in the <rec/> with appropriate id
// Terminating case
  rule <k> {[ R:SingleRec ; I:Int ]} => . ...</k>                    // 
       <rec>                                                         // 
         <id>     I            </id>                                 // 
	 <length> _:Int    </length>                                 // 
         <cont>   _:Proc     </cont>                                 // 
	 <comm> "load" => "" </comm>                                 // matching initialized, loading disengaged
	 <match>  0         </match>                                 // 0 matches
	 <type>   _          </type>                                 // receive type
	 <nomo>  .Set        </nomo>                                 // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan>  #chan(R) </chan>                       // receiving channel
                      <vars>  #bvar(R) </vars>                       // variable(s) binding in continuation
                      <num>   #bnum(R)  </num>                       // number of variables to bind
                      <msid>     ""    </msid>                       // not matched yet
                      <lid>    !L:Int   </lid>                       // generate listen id
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        // 

// Recursive steps (there are several rules to handle all of the cases here because Binds ::= Lbinds | Pbinds | Rbinds and the Xbinds are 2 or more)
// Linear
// 2 single listen joins
  rule <k> {[ for( A:Lbind ; B:Lbind ){ P:Proc } ; I:Int ]} => {[ for(B){P} ; I ]} ...</k> 
       <rec>                                                         // 
         <id>     I         </id>                                    // 
	 <length> _:Int </length>                                    // 
         <cont>   _:Proc  </cont>                                    // 
	 <comm>   "load"  </comm>                                    // loading
	 <match>  0      </match>                                    // 0 matches
	 <type>   0       </type>                                    // linear
	 <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <msid>    ""    </msid>                        // not matched yet
                      <lid>    !L:Int   </lid>                       // generate listen id
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
	 <type>   0       </type>                                    // linear
	 <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <msid>    ""    </msid>                        // not matched yet
                      <lid>    !L:Int   </lid>                       // generate listen id
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
	 <type>   1       </type>                                    // repeated
	 <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <msid>    ""    </msid>                        // not matched yet
                      <lid>    !L:Int   </lid>                       // generate listen id
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
	 <type>   1       </type>                                    // repeated
	 <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <msid>    ""    </msid>                        // not matched yet
                      <lid>    !L:Int   </lid>                       // generate listen id
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
	 <type>   2       </type>                                    // peek
	 <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <msid>    ""    </msid>                        // not matched yet
                      <lid>    !L:Int   </lid>                       // generate listen id
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
	 <type>   2       </type>                                    // peek
	 <nomo>  .Set     </nomo>                                    // empty nomo set
         <listens>...                                                // 
           (.Bag => <listen>                                         // add <listen/> to <listens/>
                      <chan> #chan(A) </chan>                        // receiving channel
                      <vars> #bvar(A) </vars>                        // variable(s) binding in continuation
                      <num>  #bnum(A)  </num>                        // 
                      <msid>    ""    </msid>                        // not matched yet
                      <lid>    !L:Int   </lid>                       // generate listen id
                    </listen>)                                       // 
         </listens>                                                  // 
    ...</rec>                                                        //

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
      <length>     L:Int          </length>                          // L listen receive
      <cont>       _:Proc           </cont>                          // 
      <comm>       ""               </comm>                          // matching
      <match> M:Int => M +Int 1    </match>                          // increase match count
      <type>       _                </type>                          // any receive type
      <nomo>  S:Set => S SetItem(I) </nomo>                          // add send id to nomo set so it is not matched again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> _:Name  </vars>                                     // variable binding in continuation
          <num>  1        </num>                                     // 1 variable to bind
          <msid> "" => I </msid>                                     // id of send mactching the listen
          <lid>  _        </lid>                                     // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   _:Proc  </msg>                                         // message
      <tuple> 1     </tuple>                                         // 1-tuple
      <stype> 0     </stype>                                         // consumable send
      <sid>   I:Int   </sid>                                         // 
    </send>                                                          // 
    requires notBool (I in S) andBool (L >Int M)             [match] // 

// N-tuple, N > 1
  rule
    <rec>...                                                         // 
      <length>     L:Int          </length>                          // L listen receive
      <cont>       _:Proc           </cont>                          // 
      <comm>       ""               </comm>                          // matching
      <match> M:Int => M +Int 1    </match>                          // increase match count
      <type>       _                </type>                          // any receive type
      <nomo>  S:Set => S SetItem(I) </nomo>                          // add send id to nomo set so it is not matched again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> _:Names </vars>                                     // variables binding in continuation
          <num>  N:Int    </num>                                     // N variables to bind
          <msid> "" => I </msid>                                     // id of send mactching the listen
          <lid>  _        </lid>                                     // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   _:Procs </msg>                                         // messages
      <tuple> N     </tuple>                                         // 1-tuple
      <stype> 0     </stype>                                         // consumable send
      <sid>   I:Int   </sid>                                         // 
    </send>                                                          // 
    requires notBool (I in S) andBool (L >Int M)             [match] // 

// Unconsumable sends (send id is NOT added to nomo set)
// 1-tuple
  rule
    <rec>...                                                         // 
      <length>     L:Int       </length>                             // L listen receive
      <cont>       _:Proc        </cont>                             // 
      <comm>       ""            </comm>                             // matching
      <match> M:Int => M +Int 1 </match>                             // increase match count
      <type>       _             </type>                             // any receive type
      <nomo>       _             </nomo>                             // send id is NOT added to nomo set so it can match again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> _:Name  </vars>                                     // variable binding in continuation
          <num>  1        </num>                                     // 1 variable to bind
          <msid> "" => I </msid>                                     // id of send mactching the listen
          <lid>  _        </lid>                                     // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   _:Proc  </msg>                                         // message
      <tuple> 1     </tuple>                                         // 1-tuple
      <stype> 1     </stype>                                         // unconsumable send
      <sid>   I:Int   </sid>                                         // 
    </send>                                                          // 
    requires L >Int M                                        [match] // 

// N-tuple, N > 1
  rule
    <rec>...                                                         // 
      <length>     L:Int       </length>                             // L listen receive
      <cont>       _:Proc        </cont>                             // 
      <comm>       ""            </comm>                             // matching
      <match> M:Int => M +Int 1 </match>                             // increase match count
      <type>       _             </type>                             // any receive type
      <nomo>       _             </nomo>                             // send id is NOT added to nomo set so it can match again
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // receiving channel X
          <vars> _:Names </vars>                                     // variables binding in continuation
          <num>  N:Int    </num>                                     // N variables to bind
          <msid> "" => I </msid>                                     // id of send mactching the listen
          <lid>  _        </lid>                                     // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           //
    <send>                                                           // matching send
      <schan> X     </schan>                                         // channel X
      <msg>   _:Procs </msg>                                         // messages
      <tuple> N     </tuple>                                         // N-tuple
      <stype> 1     </stype>                                         // unconsumable send
      <sid>   I:Int   </sid>                                         // 
    </send>                                                          // 
    requires L >Int M                                        [match] // 

//-------------------
//--- COMM EVENTS ---
//-------------------
// Reaction Cell Semantics - quarantine for processing substitutions resulting from a comm event
// ensures consumable sends (listens) are only consumed once by one process and consumable listens are only consumed
  rule 
    <reaction>                                                       // 
      <who>   P:Proc => P[@ Q / Y]    </who>                         // 
      <what>  Q:Proc , R:Procs => R  </what>                         // 
      <where> Y:Name , Z:Names => Z </where>                         // 
      <rid>          _                </rid>                         // 
      <rnum>         _               </rnum>                         // 
      <react>     "react"           </react>                         // substitution only happens in react mode
      <rset>         _               </rset>                         // 
      <reat>         _               </reat>                         // 
    </reaction>                                                      // 

  rule
    <reaction>                                                       // 
      <who>   P:Proc => P[@ Q / Y]    </who>                         // 
      <what>  Q:Proc , R:Proc => R   </what>                         // 
      <where> Y:Name , Z:Name => Z  </where>                         // 
      <rid>          _                </rid>                         // 
      <rnum>         _               </rnum>                         // 
      <react>     "react"           </react>                         // substitution only happens in react mode
      <rset>         _               </rset>                         // 
      <reat>         _               </reat>                         // 
    </reaction>                                                      // 

  rule
    <reaction>                                                       // 
      <who>   P:Proc  => P[@ Q / Y] </who>                           // 
      <what>  Q:Proc  => .K        </what>                           // 
      <where> Y:Name  => .K       </where>                           // 
      <rid>   I:Int   =>  I         </rid>                           // 
      <rnum>       _  => .K        </rnum>                           // 
      <react> "react" => "comm"   </react>                           // when reaction is complete and all consumable sends have been consumed, prosume mode disengaged
      <rset>       _  => .Set      </rset>                           // 
      <reat>       _               </reat>                           // eat set is left untouched
    </reaction>                                                      // 

// Consuming after a complete reaction
// consume receive once reaction completes
  rule
    <reaction>                                                       // 
      <who>    P:Proc => .K   </who>                                 // 
      <what>  .              </what>                                 // 
      <where> .             </where>                                 // 
      <rid>    R:Int  => .K   </rid>                                 // 
      <rnum>  .              </rnum>                                 // 
      <react> "comm"  => .K </react>                                 // when reaction is complete and all consumable sends have been consumed, prosume mode disengaged
      <rset>   .Set          </rset>                                 // 
      <reat>   .Set          </reat>                                 // eat set is finished off
    </reaction>                                                      // 
    <receives>...
     (<rec>
        <id>        R         </id>
        <length>    _     </length>
        <cont>      _       </cont>
        <comm> "processing" </comm>
        <match>     _      </match>
        <type>    T:Int      </type>
        <nomo>      _       </nomo>
        <listens>   _    </listens>
      </rec> => .Bag)
    </receives>
    <threads>...
    (.Bag => <thread> <k> P </k> </thread>)                          // spawn a thread containing the fully substituted continuation
    </threads>
    requires T =/=Int 1                                       [comm] // 

  rule
    <reaction>                                                       // 
      <who>        _:Proc          </who>                            // 
      <what>  .                   </what>                            // 
      <where> .                  </where>                            // 
      <rid>        _:Int           </rid>                            // 
      <rnum>  .                   </rnum>                            // 
      <react>      "comm"        </react>                            // when reaction is complete and all consumable sends have been consumed, prosume mode disengaged
      <rset>        .Set          </rset>                            // 
      <reat> E:Set => E -Set SetItem(I) </reat>                      // 
    </reaction>                                                      // 
    <sends>...
     (<send>
        <schan> _ </schan>
        <msg>   _   </msg>
        <tuple> _ </tuple>
        <stype> 0 </stype>
        <sid> I:Int </sid>
      </send> => .Bag)
    </sends>
/*    <receives>...
      <rec>
        <id>     _         </id>
        <length> L:Int </length>
        <cont>   _       </cont>
        <comm>   _       </comm>
        <match>  L      </match>
        <type>   _       </type>
        <nomo>   _       </nomo>
        <listens>...
          <listen>
            <chan> _       </chan>
            <vars> _       </vars>
            <num>  _        </num>
            <msid> I => "" </msid>
            <lid>  _        </lid>
          </listen>
        </listens>
      </rec>
    </receives>  */
    <consumable> C:Set => C -Set SetItem(I) </consumable>
    requires I in E           [comm]

// Match states
// Comm initializes when # of sends matched = # of listens in receive (i.e. match = length)
  rule
    <rec>                                                            // 
      <id>      _              </id>                                 // 
      <length>  L:Int      </length>                                 // 
      <cont>    _            </cont>                                 // 
      <comm> "" => "matched" </comm>                                 // once match count is equal to listen length: initialize comm
      <match>   L           </match>                                 // 
      <type>    _            </type>                                 // 
      <nomo>    _            </nomo>                                 // 
      <listens> _         </listens>                                 // 
    </rec>                                                 [promote] // 

// when a matched send is consumed from a "matched" receive, the receive is demoted back to matching
  rule
    <rec>                                                            // TODO: not 100% sure this is what I want here...
      <id>      _              </id>                                 // I want to make it so that "matched" receives
      <length>  L:Int      </length>                                 // are demoted to "" if a consumable send they
      <cont>    _            </cont>                                 // matched is consumed by another receive.
      <comm> "matched" => "" </comm>                                 // 
      <match>   J:Int       </match>                                 // 
      <type>    _            </type>                                 // 
      <nomo>    _            </nomo>                                 // 
      <listens> _         </listens>                                 // 
    </rec>                                                           // 
    when J <Int L                                           [demote] // 

// once collection finishes, consume receive (if consumable)
  rule
   (<rec>                                                            // consumable receives are consumed once collection completes
      <id>     J:Int        </id>                                    // 
      <length> L:Int    </length>                                    // 
      <cont>     _        </cont>                                    // 
      <comm> "processing" </comm>                                    // 
      <match>    _       </match>                                    // 
      <type>   T:Int      </type>                                    // 
      <nomo>     _        </nomo>                                    // 
      <listens>  _     </listens>                                    // 
    </rec> => .Bag)                                                  // 
    <reaction>                                                       // 
      <who>      _                   </who>                          // 
      <what>     _                  </what>                          // 
      <where>    _                 </where>                          // 
      <rid>      J                   </rid>                          // 
      <rnum>     L                  </rnum>                          // collection completes when the reaction number matches the listen length
      <react> "collect" => "react" </react>                          // when collection is complete, react mode engages
      <rset>     _                  </rset>                          // 
      <reat>     _                  </reat>                          // 
    </reaction>                                                      // 
    requires T =/=Int 1                                      [react] //
/*
  rule
    <rec>                                                            // unconsumable receives persist and values are restored to initial
      <id>       J:Int            </id>                              // 
      <length>   L:Int        </length>                              // 
      <cont>     _              </cont>                              // 
      <comm> "processing" => "" </comm>                              // 
      <match>    L => 0        </match>                              // 
      <type>     1              </type>                              // 
      <nomo>     _ => .Set      </nomo>                              // 
      <listens>  _           </listens>                              // 
    </rec>                                                           // 
    <reaction>                                                       // 
      <who>      _                   </who>                          // 
      <what>     _                  </what>                          // 
      <where>    _                 </where>                          // 
      <rid>      J                   </rid>                          // 
      <rnum>     L                  </rnum>                          // collection completes when the reaction number matches the listen length
      <react> "collect" => "react" </react>                          // when collection is complete, react mode engages
      <rset>     _                  </rset>                          // 
      <reat>     _                  </reat>                          // 
    </reaction>                                              [react] // 
*/
//----------------------
//--- Comm Semantics ---
//----------------------
// Initialize reaction cell

// First...
// Consumable sends (send id forgotten by all other listens, if there are any)
// Linear listens
// 1-tuple message, no other matching listens
  rule
    <rec>                                                            // 
      <id>     J:Int                     </id>                       // 
      <length> L:Int                 </length>                       // number of listens in receive
      <cont>   P:Proc                  </cont>                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L                      </match>                       // 
      <type>   0                       </type>                       // linear
      <nomo>   _                       </nomo>                       // 
      <listens>...                                                   // 
        (<listen>                                                    // dissolve consumable listen
           <chan> X:Name </chan>                                     // 
           <vars> Y:Name </vars>                                     // 
           <num>  1       </num>                                     // 
           <msid> I:Int  </msid>                                     // 
           <lid>  _       </lid>                                     // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>   .K => P           </who>                               // relocate continuation & substitution info to <reaction/>
      <what>  .K => Q          </what>                               // 
      <where> .K => Y         </where>                               // 
      <rid>   .K => J           </rid>                               // 
      <rnum>  .K => 1          </rnum>                               // start reaction count
      <react> .K => "collect" </react>                               // collect all info before reaction begins
      <rset>     _             </rset>                               // 
      <reat> C:Set => C SetItem(I) </reat>                           // 
    </reaction>                                            [initial] // 
/*
// 1-tuple message, more than one receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int                     </id>                       // 
      <length> L:Int                 </length>                       // number of listens in receive
      <cont>   P:Proc                  </cont>                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L                      </match>                       // 
      <type>   0                       </type>                       // linear
      <nomo>   _                       </nomo>                       // 
      <listens>...                                                   // 
        (<listen>                                                    // consume linear listen
           <chan> X:Name  </chan>                                    // listen channel
           <vars> Y:Name  </vars>                                    // variable binding in continuation
           <num>  1        </num>                                    // 1-tuple message
           <msid> I:Int   </msid>                                    // matching send id
           <lid>  _        </lid>                                    // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>   .K => P           </who>                               // relocate continuation & substitution info to <reaction/>
      <what>  .K => Q          </what>                               // 
      <where> .K => Y         </where>                               // 
      <rid>   .K => J           </rid>                               // 
      <rnum>  .K => 1          </rnum>                               // start reaction count
      <react> .K => "collect" </react>                               // collect all info before reaction begins
      <rset>     _             </rset>                               // 
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   1        </num>                                    // 
          <msid>  I => "" </msid>                                    // forget send id
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires H =/=Int J                                    [initial] // 
*/
// N-tuple message, only this receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int                     </id>                       // 
      <length> L:Int                 </length>                       // number of listens in receive
      <cont>   P:Proc                  </cont>                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L                      </match>                       // 
      <type>   0                       </type>                       // linear
      <nomo>   _                       </nomo>                       // 
      <listens>...                                                   // 
        (<listen>                                                    // only dissolve consumable listens, T =/= 1
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // 
           <num>  N:Int    </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>   .K => P           </who>                               // relocate continuation & substitution info to <reaction/>
      <what>  .K => Q          </what>                               // 
      <where> .K => Y         </where>                               // 
      <rid>   .K => J           </rid>                               // 
      <rnum>  .K => 1          </rnum>                               // start reaction count
      <react> .K => "collect" </react>                               // collect all info before reaction begins
      <rset>     _             </rset>                               // 
      <reat> C:Set => C SetItem(I) </reat>                           // 
    </reaction>                                            [initial] // 
/*
// N-tuple message, more than one receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int                     </id>                       // 
      <length> L:Int                 </length>                       // number of listens in receive
      <cont>   P:Proc                  </cont>                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L                      </match>                       // 
      <type>   0                       </type>                       // linear
      <nomo>   _                       </nomo>                       // 
      <listens>...                                                   // 
       (<listen>                                                     // only dissolve consumable listens, T =/= 1
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Names </vars>                                     // 
          <num>  N:Int    </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  _        </lid>                                     // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // N-tuple message
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>   .K => P           </who>                               // relocate continuation & substitution info to <reaction/>
      <what>  .K => Q          </what>                               // 
      <where> .K => Y         </where>                               // 
      <rid>   .K => J           </rid>                               // 
      <rnum>  .K => 1          </rnum>                               // start reaction count
      <react> .K => "collect" </react>                               // collect all info before reaction begins
      <rset>     _             </rset>                               // 
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   N        </num>                                    // 
          <msid>  I => "" </msid>                                    // forget send id
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires H =/=Int J                                    [initial] // 
*/
// Reapeted listen
// Send id dissolved from all <msid/>s in other receives, if they exist

// 1-tuple message, only this receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // number of listens in receive
      <cont>   P:Proc  </cont>                                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // 
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
         <listen>                                                    // repeated
           <chan> X:Name      </chan>                                // 
           <vars> Y:Name      </vars>                                // 
           <num>  1            </num>                                // 
           <msid> I:Int => "" </msid>                                // forget send id
           <lid>  V:Int        </lid>                                // 
         </listen>                                                   // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>        .K => P                </who>                     // relocate continuation & substitution info to <reaction/>
      <what>       .K => Q               </what>                     // 
      <where>      .K => Y              </where>                     // 
      <rid>        .K => J                </rid>                     // 
      <rnum>       .K => 1               </rnum>                     // start reaction count
      <react>      .K => "collect"      </react>                     // collect all info before reaction begins
      <rset>    S:Set => S SetItem(V)    </rset>                     // add listen id to rset
      <reat>    C:Set => C SetItem(I)    </reat>                     // add send id to eat set
    </reaction>                                                      // 
    requires notBool (V in S)                              [initial] // 
/*
// 1-tuple message, more than one receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // number of listens in receive
      <cont>   P:Proc  </cont>                                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // 
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
         <listen>                                                    // repeated
           <chan> X:Name      </chan>                                // 
           <vars> Y:Name      </vars>                                // 
           <num>  1            </num>                                // 
           <msid> I:Int => "" </msid>                                // forget send id
           <lid>  V:Int        </lid>                                // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>        .K => P                </who>                     // relocate continuation & substitution info to <reaction/>
      <what>       .K => Q               </what>                     // 
      <where>      .K => Y              </where>                     // 
      <rid>        .K => J                </rid>                     // 
      <rnum>       .K => 1               </rnum>                     // start reaction count
      <react>      .K => "collect"      </react>                     // collect all info before reaction begins
      <rset>    S:Set => S SetItem(V)    </rset>                     // add listen id to rset
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   1        </num>                                    // 
          <type>  _       </type>                                    // any listen type
          <msid>  I => "" </msid>                                    // forget send id
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires (H =/=Int J) andBool notBool (V in S)         [initial] // 
*/
// N-tuple message, only this receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // number of listens in receive
      <cont>   P:Proc  </cont>                                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // repeated
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        <listen>                                                     // only dissolve consumable listens, T =/= 1
          <chan> X:Name      </chan>                                 // 
          <vars> Y:Names     </vars>                                 // 
          <num>  N:Int        </num>                                 // 
          <msid> I:Int => "" </msid>                                 // 
          <lid>  V:Int        </lid>                                 // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>        .K => P                </who>                     // relocate continuation & substitution info to <reaction/>
      <what>       .K => Q               </what>                     // 
      <where>      .K => Y              </where>                     // 
      <rid>        .K => J                </rid>                     // 
      <rnum>       .K => 1               </rnum>                     // start reaction count
      <react>      .K => "collect"      </react>                     // collect all info before reaction begins
      <rset>    S:Set => S SetItem(V)    </rset>                     // add listen id to rset
      <reat>    C:Set => C SetItem(I)    </reat>                     // 
    </reaction>                                                      // 
    requires notBool (V in S)                              [initial] // 
/*
// N-tuple message, more than one receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // number of listens in receive
      <cont>   P:Proc  </cont>                                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // repeated
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name      </chan>                                 // 
          <vars> Y:Names     </vars>                                 // 
          <num>  N:Int        </num>                                 // 
          <msid> I:Int => "" </msid>                                 // forget send id
          <lid>  V:Int        </lid>                                 // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // N-tuple message
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>        .K => P                </who>                     // relocate continuation & substitution info to <reaction/>
      <what>       .K => Q               </what>                     // 
      <where>      .K => Y              </where>                     // 
      <rid>        .K => J                </rid>                     // 
      <rnum>       .K => 1               </rnum>                     // start reaction count
      <react>      .K => "collect"      </react>                     // collect all info before reaction begins
      <rset>    S:Set => S SetItem(V)    </rset>                     // add listen id to rset
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   N        </num>                                    // 
          <msid>  I => "" </msid>                                    // listens in other receives also forget send id
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires (H =/=Int J) andBool notBool (V in S)         [initial] // 
*/
// Peek
// The send is not consumed so its id is not forgotten by other matching listens

// 1-tuple message, only this receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // number of listens in receive
      <cont>   P:Proc  </cont>                                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L      </match>                                       // 
      <type>   2       </type>                                       // peek
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
       (<listen>                                                     // dissolve consumable listen
          <chan> X:Name </chan>                                      // 
          <vars> Y:Name </vars>                                      // 
          <num>  1       </num>                                      // 
          <msid> I:Int  </msid>                                      // 
          <lid>  _       </lid>                                      // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // 
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> _     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>    .K => P           </who>                              // relocate continuation & substitution info to <reaction/>
      <what>   .K => Q          </what>                              // 
      <where>  .K => Y         </where>                              // 
      <rid>    .K => J           </rid>                              // 
      <rnum>   .K => 1          </rnum>                              // start reaction count
      <react>  .K => "collect" </react>                              // collect all info before reaction begins
      <rset>    _               </rset>                              // 
      <reat>    _               </reat>                              // 
    </reaction>                                           [initiala] // 

// N-tuple message, only this receive has a matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // number of listens in receive
      <cont>   P:Proc  </cont>                                       // 
      <comm> "matched" => "processing" </comm>                       // once collection begins: initialize processing
      <match>  L      </match>                                       // 
      <type>   2       </type>                                       // peek
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
       (<listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Names </vars>                                     // 
          <num>  N:Int    </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  _        </lid>                                     // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     <send>                                                          // will not be consumed from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> _     </stype>                                       // either send type
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // begin populating <reaction/>
      <who>   .K => P           </who>                               // relocate continuation & substitution info to <reaction/>
      <what>  .K => Q          </what>                               // 
      <where> .K => Y         </where>                               // 
      <rid>   .K => J           </rid>                               // 
      <rnum>  .K => 1          </rnum>                               // 
      <react> .K => "collect" </react>                               // collect all info before reaction begins
      <rset>   _               </rset>                               // 
      <reat>   _               </reat>                               // send will not be consumed
    </reaction>                                            [initial] // 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// COLLECTION - after reaction is initialized
// 
// Receives with linear listens
// single name and proc currently in <reaction/>
// adding single name and proc (consumable listen)
// only one receive with matching listen
  rule
    <rec>                                                            // 
      <id>     J:Int        </id>                                    // 
      <length> L:Int    </length>                                    // number of listens in receive
      <cont>   P:Proc     </cont>                                    // 
      <comm> "processing" </comm>                                    // "matched" receives populate <reaction/>
      <match>  L         </match>                                    // 
      <type>   0          </type>                                    // linear
      <nomo>   _          </nomo>                                    // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // to be consumed send in tuplespace
        <schan> X  </schan>                                          // 
        <msg> Q:Proc </msg>                                          // 
        <tuple> 1  </tuple>                                          // 
        <stype> 0  </stype>                                          // 
        <sid>   I    </sid>                                          // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P                </who>                        // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => Q , R        </what>                        // single proc initially in <reaction/>
      <where> Z:Name  => Y , Z       </where>                        // single name initially in <reaction/>
      <rid>           J                </rid>                        // 
      <rnum>        1 => 2            </rnum>                        // increase reaction number
      <react>     "collect"          </react>                        // collecting info before reaction begins
      <rset>          _               </rset>                        // 
      <reat>    C:Set => C SetItem(I) </reat>                        // 
    </reaction>                                            [collect] // 
/*
// other receives with matching listens
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "matched" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   0       </type>                                       // linear
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X  </schan>                                          // 
        <msg> Q:Proc </msg>                                          // 
        <tuple> 1  </tuple>                                          // 
        <stype> 0  </stype>                                          // 
        <sid>   I    </sid>                                          // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                  </who>                              // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => Q , R  </what>                              // single proc initially in <reaction/>
      <where> Z:Name  => Y , Z </where>                              // single name initially in <reaction/>
      <rid>   J                  </rid>                              // 
      <rnum>  1 => 2            </rnum>                              // increase reaction number
      <react> "collect"        </react>                              // collecting info before reaction begins
      <rset>  _                 </rset>                              // 
      <reat>    C:Set => C SetItem(I)    </reat>                     // 
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   1        </num>                                    // 
          <msid>  I => "" </msid>                                    // disconnect other listens from send
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires H =/=Int J                                    [collect] // 
*/
// adding multiple names and procs to <reaction/>
// only one receive with matching listen
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "matched" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   0       </type>                                       // linear
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N variables to bind
           <num>  N:Int    </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // to be consumed send in tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P                 </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => #append(Q;R)  </what>                       // single proc initially in <reaction/>
      <where> Z:Name  => #append(Y;Z) </where>                       // single name initially in <reaction/>
      <rid>           J                 </rid>                       // 
      <rnum>        1 => 2             </rnum>                       // increase reaction number
      <react>      "collect"          </react>                       // collecting info before reaction begins
      <rset>          _                </rset>                       // 
      <reat>    C:Set => C SetItem(I)  </reat>                       // 
    </reaction>                                            [collect] // 
/*
// other receives with matching listens
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "matched" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   0       </type>                                       // linear
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N-tuple
           <num>  N:Int    </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => #append(Q;R)  </what>                       // single proc initially in <reaction/>
      <where> Z:Name  => #append(Y;Z) </where>                       // single name initially in <reaction/>
      <rid>   J                         </rid>                       // 
      <rnum>  1 => 2                   </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // collecting info before reaction begins
      <rset>  _                        </rset>                       // 
      <reat>    C:Set => C SetItem(I)    </reat>                     // 
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   1        </num>                                    // 
          <msid>  I => "" </msid>                                    // disconnect other listens from send
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires H =/=Int J                                    [collect] // 
*/
// multiple names and procs currently in <reaction/> => adding sinlge name and proc
// only one receive with matching listen
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "matched" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   0       </type>                                       // linear
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Proc  </msg>                                       // 
        <tuple> 1     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                  </who>                              // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => Q , R  </what>                              // multiple procs currently in <reaction/>
      <where> Z:Names => Y , Z </where>                              // multiple names currently in <reaction/>
      <rid>   J                  </rid>                              // 
      <rnum>  U:Int => U +Int 1 </rnum>                              // increase reaction number
      <react> "collect"        </react>                              // collecting info before reaction begins
      <rset>  _                 </rset>                              // 
      <reat>  C:Set => C SetItem(I)    </reat>                       // 
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 
/*
// other receives with matching listens
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "matched" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   0       </type>                                       // linear
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Name  </vars>                                    // 1-tuple
           <num>  1        </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                  </who>                              // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => Q , R  </what>                              // multiple procs currently in <reaction/>
      <where> Z:Names => Y , Z </where>                              // multiple names currently in <reaction/>
      <rid>   J                  </rid>                              // 
      <rnum>  U:Int => U +Int 1 </rnum>                              // increase reaction number
      <react> "collect"        </react>                              // collecting info before reaction begins
      <rset>  _                 </rset>                              // 
      <reat>    C:Set => C SetItem(I)    </reat>                     // 
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   1        </num>                                    // 
          <msid>  I => "" </msid>                                    // disconnect other listens from send
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires (H =/=Int J) andBool (L >Int U)               [collect] // 
*/
// multiple names and procs currently in <reaction/> => adding sinlge name and proc
// only one receive with matching listen
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "matched" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   0       </type>                                       // linear
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N-tuple
           <num>  N:Int    </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
         </listen> => .Bag)                                          // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X     </schan>                                       // 
        <msg>   Q:Procs </msg>                                       // 
        <tuple> N     </tuple>                                       // 
        <stype> 0     </stype>                                       // 
        <sid>   I       </sid>                                       // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => #append(Q;R)  </what>                       // multiple procs currently in <reaction/>
      <where> Z:Names => #append(Y;Z) </where>                       // multiple names currently in <reaction/>
      <rid>   J                         </rid>                       // 
      <rnum>  U:Int => U +Int 1        </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // collecting info before reaction begins
      <rset>  _                        </rset>                       // 
      <reat>  C:Set => C SetItem(I)    </reat>                       // 
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 
/*
// other receives with matching listens
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "matched" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   0       </type>                                       // linear
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        (<listen>                                                    // all listens will
           <chan> X:Name  </chan>                                    // 
           <vars> Y:Names </vars>                                    // N-tuple
           <num>  N:Int    </num>                                    // 
           <msid> I:Int   </msid>                                    // 
           <lid>  _        </lid>                                    // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => #append(Q;R)  </what>                       // multiple procs currently in <reaction/>
      <where> Z:Names => #append(Y;Z) </where>                       // multiple names currently in <reaction/>
      <rid>   J                         </rid>                       // 
      <rnum>  U:Int => U +Int 1        </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // collecting info before reaction begins
      <rset>  _                        </rset>                       // 
      <reat>    C:Set => C SetItem(I)    </reat>                     // 
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   N        </num>                                    // 
          <msid>  I => "" </msid>                                    // disconnect other listens from send
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires (H =/=Int J) andBool (L >Int U)               [collect] // 
*/
// Persistent receives
// single name and proc currently in <reaction/>
// adding single name and proc (consumable listen)
// only one receive with matching listen
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "processing" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // repeated
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Name  </vars>                                     // 1-tuple
          <num>  1        </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  V:Int    </lid>                                     // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
      <send>                                                         // consume send from tuplespace
        <schan> X  </schan>                                          // 
        <msg> Q:Proc </msg>                                          // 
        <tuple> 1  </tuple>                                          // 
        <stype> 0  </stype>                                          // 
        <sid>   I    </sid>                                          // 
      </send>                                                        // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P                 </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => Q , R         </what>                       // single proc initially in <reaction/>
      <where> Z:Name  => Y , Z        </where>                       // single name initially in <reaction/>
      <rid>           J                 </rid>                       // 
      <rnum>        1 => 2             </rnum>                       // increase reaction number
      <react>      "collect"          </react>                       // collecting info before reaction begins
      <rset>    T:Set => T SetItem(V)  </rset>                       // add listen id to rset
      <reat>    C:Set => C SetItem(I)  </reat>                       // 
    </reaction>                                            [collect] // 
/*
// other receives with matching listens
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "processing" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   0       </type>                                       // linear
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Name  </vars>                                     // 1-tuple
          <num>  1        </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  V:Int    </lid>                                     // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    <sends>...                                                       // 
     (<send>                                                         // consume send from tuplespace
        <schan> X  </schan>                                          // 
        <msg> Q:Proc </msg>                                          // 
        <tuple> 1  </tuple>                                          // 
        <stype> 0  </stype>                                          // 
        <sid>   I    </sid>                                          // 
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P                 </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => Q , R         </what>                       // single proc initially in <reaction/>
      <where> Z:Name  => Y , Z        </where>                       // single name initially in <reaction/>
      <rid>           J                 </rid>                       // 
      <rnum>        1 => 2             </rnum>                       // increase reaction number
      <react>      "collect"          </react>                       // collecting info before reaction begins
      <rset>    T:Set => T SetItem(V)  </rset>                       // add listen id to rset
      <reat>    C:Set => C SetItem(I)  </reat>                       // 
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
           <chan>  X       </chan>                                   // 
           <vars>  _       </vars>                                   // 
           <num>   1        </num>                                   // 
           <msid>  I => "" </msid>                                   // disconnect other listens from send
           <lid>   _        </lid>                                   // 
         </listen>                                                   // 
       </listens>                                                    // 
     </rec>                                                          // 
     requires H =/=Int J                                   [collect] // 
*/
// adding multiple names and procs to <reaction/>
// only one receive with matching listen
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "processing" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // repeated
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Names </vars>                                     // N-tuple
          <num>  N:Int    </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  V:Int    </lid>                                     // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P                 </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => #append(Q;R)  </what>                       // single proc initially in <reaction/>
      <where> Z:Name  => #append(Y;Z) </where>                       // single name initially in <reaction/>
      <rid>           J                 </rid>                       // 
      <rnum>        1 => 2             </rnum>                       // increase reaction number
      <react>      "collect"          </react>                       // collecting info before reaction begins
      <rset>    T:Set => T SetItem(V)  </rset>                       // add listen id to rset
      <reat>    C:Set => C SetItem(I)  </reat>                       // 
    </reaction>                                            [collect] // 
/*
// other receives with matching listens
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "processing" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // repeated
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Names </vars>                                     // N-tuple
          <num>  N:Int    </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  V:Int    </lid>                                     // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>           P                 </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Proc  => #append(Q;R)  </what>                       // single proc initially in <reaction/>
      <where> Z:Name  => #append(Y;Z) </where>                       // single name initially in <reaction/>
      <rid>           J                 </rid>                       // 
      <rnum>        1 => 2             </rnum>                       // increase reaction number
      <react>      "collect"          </react>                       // collecting info before reaction begins
      <rset>    T:Set => T SetItem(V)  </rset>                       // add listen id to rset
      <reat>    C:Set => C SetItem(I)  </reat>                       // 
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   1        </num>                                    // 
          <msid>  I => "" </msid>                                    // disconnect other listens from send
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires H =/=Int J                                    [collect] // 
*/
// multiple names and procs currently in <reaction/> => adding sinlge name and proc
// only one receive with matching listen
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "processing" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // repeated
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Name  </vars>                                     // 1-tuple
          <num>  1        </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  V:Int    </lid>                                     // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>         P                  </who>                        // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => Q , R        </what>                        // multiple procs currently in <reaction/>
      <where> Z:Names => Y , Z       </where>                        // multiple names currently in <reaction/>
      <rid>         J                  </rid>                        // 
      <rnum>    U:Int => U +Int 1     </rnum>                        // increase reaction number
      <react>      "collect"         </react>                        // collecting info before reaction begins
      <rset>    T:Set => T SetItem(V) </rset>                        // add listen id to rset
      <reat>    C:Set => C SetItem(I) </reat>                        // 
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 
/*
// other receives with matching listens
  rule
    <rec>                                                            // number of listens in receive
      <id>     J:Int     </id>                                       // 
      <length> L:Int </length>                                       // 
      <cont>   P:Proc  </cont>                                       // 
      <comm> "processing" </comm>                                    // "processing" receives populate <reaction/>
      <match>  L      </match>                                       // 
      <type>   1       </type>                                       // repeated
      <nomo>   _       </nomo>                                       // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Name  </vars>                                     // 1-tuple
          <num>  1        </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  V:Int    </lid>                                     // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>         P                  </who>                        // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => Q , R        </what>                        // multiple procs currently in <reaction/>
      <where> Z:Names => Y , Z       </where>                        // multiple names currently in <reaction/>
      <rid>         J                  </rid>                        // 
      <rnum>    U:Int => U +Int 1     </rnum>                        // increase reaction number
      <react>      "collect"         </react>                        // collecting info before reaction begins
      <rset>    T:Set => T SetItem(V) </rset>                        // add listen id to rset
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   1        </num>                                    // 
          <msid>  I => "" </msid>                                    // disconnect other listens from send
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires (H =/=Int J) andBool (L >Int U)               [collect] // 
*/
// multiple names and procs currently in <reaction/> => adding sinlge name and proc
// only one receive with matching listen
  rule
    <rec>                                                            // number of listens in receive
      <id>        J:Int     </id>                                    // 
      <length>    L:Int </length>                                    // 
      <cont>      P:Proc  </cont>                                    // 
      <comm> "processing" </comm>                                    // "processing" receives populate <reaction/>
      <match>     L      </match>                                    // 
      <type>      1       </type>                                    // repeated
      <nomo>      _       </nomo>                                    // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Names </vars>                                     // N-tuple
          <num>  N:Int    </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  V:Int    </lid>                                     // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => #append(Q;R)  </what>                       // multiple procs currently in <reaction/>
      <where> Z:Names => #append(Y;Z) </where>                       // multiple names currently in <reaction/>
      <rid>   J                         </rid>                       // 
      <rnum>  U:Int => U +Int 1        </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // collecting info before reaction begins
      <rset>  T:Set => T SetItem(V)    </rset>                       // add listen id to rset
      <reat>  C:Set => C SetItem(I)    </reat>                       // 
    </reaction>                                                      // 
    requires L >Int U                                      [collect] // 
/*
// other receives with matching listens
  rule
    <rec>                                                            // number of listens in receive
      <id>        J:Int     </id>                                    // 
      <length>    L:Int </length>                                    // 
      <cont>      P:Proc  </cont>                                    // 
      <comm> "processing" </comm>                                    // "processing" receives populate <reaction/>
      <match>     L      </match>                                    // 
      <type>      1       </type>                                    // repeated
      <nomo>      _       </nomo>                                    // 
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan> X:Name  </chan>                                     // 
          <vars> Y:Names </vars>                                     // N-tuple
          <num>  N:Int    </num>                                     // 
          <msid> I:Int   </msid>                                     // 
          <lid>  V:Int    </lid>                                     // 
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
      </send> => .Bag)                                               // 
    </sends>                                                         // 
    <reaction>                                                       // continue populating <reaction/>
      <who>   P                         </who>                       // relocate continuation & substitution info to <reaction/>
      <what>  R:Procs => #append(Q;R)  </what>                       // multiple procs currently in <reaction/>
      <where> Z:Names => #append(Y;Z) </where>                       // multiple names currently in <reaction/>
      <rid>   J                         </rid>                       // 
      <rnum>  U:Int => U +Int 1        </rnum>                       // increase reaction number
      <react> "collect"               </react>                       // collecting info before reaction begins
      <rset>  T:Set => T SetItem(V)    </rset>                       // add listen id to rset
    </reaction>                                                      // 
    <rec>                                                            // 
      <id>          H:Int                  </id>                     // 
      <length>      _:Int              </length>                     // 
      <cont>        _:Proc               </cont>                     // 
      <comm>        _                    </comm>                     // either state is valid
      <match> M:Int => M -Int 1         </match>                     // decrease match count in all joins with a latching listen (send was already consumed)
      <type>        _                    </type>                     // any receive type
      <nomo>  S:Set => S -Set SetItem(I) </nomo>                     // delete send id from the nomo set in all joins with a matching listen
      <listens>...                                                   // 
        <listen>                                                     // 
          <chan>  X       </chan>                                    // 
          <vars>  _       </vars>                                    // 
          <num>   N        </num>                                    // 
          <msid>  I => "" </msid>                                    // disconnect other listens from send
          <lid>   _        </lid>                                    // 
        </listen>                                                    // 
      </listens>                                                     // 
    </rec>                                                           // 
    requires (H =/=Int J) andBool (L >Int U)               [collect] // 
*/
// Eliminate empty initializing listen cells
  rule
    <rec>...
      <listens>...                                                   // 
        (<listen>                                                    // 
           <chan> "" </chan>                                         // 
           <vars> "" </vars>                                         // 
           <num>  ""  </num>                                         // 
           <msid> "" </msid>                                         // 
           <lid>  ""  </lid>                                         // 
        </listen> => .Bag)                                           // 
      </listens>                                                     // 
    </rec>                                                           //

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