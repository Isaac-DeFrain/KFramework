// RHO CALCULUS with Bool, Int, String ground terms and tuple messages in a monadic style
// No patterns, only name variables

require "domains.k"
require "substitution.k"
require "AuxFun/auxfun.k"

// SYNTAX MODULE
module GRHO-SYNTAX
  import DOMAINS
  import SET
  import SUBSTITUTION

//-------------
//--- NAMES ---
//-------------
  syntax       Var ::= Id                                            //  Id < Var

  syntax   NameVar ::= Var                                           // Var < NameVar

  syntax      Name ::= "@" Proc                                      //   @: Proc -------------> Name
                     | NameVar                                       //                NameVar < Name
                     | "unforgeable(" Int ")"                        // unforgeable(_): Int ---> Name

  syntax     Names ::= "{" Names "}"
                     > Name  "," Name                                // _,_: Name x Name ------> Names
                     | Name  "," Names                               // _,_: Name x Names -----> Names
                     | "@" Procs                                     //

//-----------------
//--- PROCESSES ---
//-----------------
  syntax      Proc ::= "{" Proc "}"                        [bracket] // {_}: Proc --------> Proc
	                   > New                                           // 
                     > "Nil"                                         // Nil: -------------> Proc
                     | Collection                                    // Collection of processes
                     | Ground                                        // Bool, Int, String < Proc
                     | AExp                                          // Arithmetic expressions: AExp < Proc
                     | BExp                                          //    Boolean expressions: BExp < Proc
                     | Eval                                          //    Eval < Proc
                     | Receive                                       // Receive < Proc
                     | Send                                          //    Send < Proc
                     | Bundle                                        //  Bundle < Proc
                     > Par                                           //     Par < Proc

// Parallel
  syntax       Par ::= Proc "|" Proc                          [left] // _|_: Proc x Proc ---> Par

// Receives - no mixed linear/peek/repeated
  syntax   Receive ::= "for" "(" Bind  ")" "{" Proc "}"              // _(_){_}: Bind  x Proc ---> Receive, single pattern
                     | "for" "(" Binds ")" "{" Proc "}"              // _(_){_}: Binds x Proc ---> Receive, several patterns

  syntax      Bind ::= Lbind                                         // single linear bind --- for( y <- x ){ P }
                     | Pbind                                         // single peek bind ----- for( y <! x ){ P }
                     | Rbind                                         // single repeated bind - for( y <= x ){ P }

  syntax     Binds ::= Lbinds                                        // several linear binds --- for( y1 <- x1 ; ... ; yN <- xN ){ P }
                     | Pbinds                                        // several peek binds ----- for( y1 <! x1 ; ... ; yN <! xN ){ P }
                     | Rbinds                                        // several repeated binds - for( y1 <= x1 ; ... ; yN <= xN ){ P }

  syntax     Lbind ::= Name  "<-" Name                               // linear listen for 1-tuple
                     | Names "<-" Name                               // linear listen for N-tuple, N > 1

  syntax    Lbinds ::= Lbind ";" Lbind                               // 2 liner listens
                     | Lbind ";" Lbinds                              // N linear listens, N > 2

  syntax     Pbind ::= Name  "<!" Name                               // peek for 1-tuple
                     | Names "<!" Name                               // peek for N-tuple, N > 1

  syntax    Pbinds ::= Pbind "<!" Pbind                              // 2 peeks
                     | Pbind "<!" Pbinds                             // N peeks, N > 1

  syntax     Rbind ::= Name  "<=" Name                               // 1-tuple
                     | Names "<=" Name                               // N-tuple, N > 1

  syntax    Rbinds ::= Rbind ";" Rbind                               // 2 repeated listens
                     | Rbind ";" Rbinds                              // N repeated listens, N > 2

// Send
  syntax      Send ::= Name "!"  RhoTuple                            // _!_: Name x RhoTuple ---> Send, single send
                     | Name "!!" RhoTuple                            // _!_: Name x RhoTuple ---> Send, repeated send

// Eval
  syntax      Eval ::= "*" Name                                      // *_: Name ---> Eval 

// Several Processes
  syntax     Procs ::= Proc  "," Proc                       [strict] // _,_: Proc x Proc ----> Procs
                     | Proc  "," Procs                      [strict] // _,_: Proc x Procs ---> Procs

// New
  syntax       New ::= "new" Name  "in" "{" Proc "}"        [binder] //
                     | "new" Names "in" "{" Proc "}"        [binder] //

// Collections
  syntax
        Collection ::= RhoList
                     | RhoMap
                     | RhoSet
                     | RhoTuple

// Process lists
  syntax   RhoList ::= "[" Proc  "]"                                 // singleton list
                     | "[" Procs "]"                                 // length > 1

// Process maps
  syntax    RhoMap ::= "{" RhoKVPairs "}"                            //

  syntax
        RhoKVPairs ::= Proc ":" Proc                                 // single key-value
                     | Proc ":" Proc "," RhoKVPairs                  // size > 1

// Process sets
  syntax    RhoSet ::= "Set" "(" Proc  ")"                           // singleton
                     | "Set" "(" Procs ")"                           // size > 1

// Process tuples
  syntax  RhoTuple ::= "(" Proc  ")"                                 // 1-tuple
                     | "(" Procs ")"                                 // N-tuple, N > 1

// Ground terms
  syntax    Ground ::= Bool                                          //   Bool < Ground
                     | Int                                           //    Int < Ground
                     | String                                        // String < Ground
                     | Uri                                           //    Uri < Ground

  syntax       Uri ::= "uri(" String      ")"                        // 

// AExp & BExp resolve to ground terms
// Arithmetic
  syntax      AExp ::= "{" AExp "}"                                  //     (_): AExp ------> AExp
                     | Int                                           //    Int < AExp
                     | Eval                                          //   Eval < AExp , for interesting message passing, e.g. for( y <- x ){ *y + 5 }
                     | String                                        // String < AExp (S1 + S2 => S1 +String S2)
                     > AExp "*" AExp                        [strict] // _*_: AExp x AExp ---> AExp
                     > AExp "+" AExp                        [strict] // _+_: AExp x AExp ---> AExp
                     | AExp "-" AExp                        [strict] // _-_: AExp x AExp ---> AExp

// Boolean
  syntax      BExp ::= Bool                                          //   Bool < BExp
                     | "{" BExp "}"                                  //  (_): BExp ----------> BExp
                     | Eval                                          //   Eval < BExp
                     | String                                        // String < BExp
                     | AExp  "<=" AExp                   [seqstrict] // _<=_: AExp x AExp ---> BExp
                     | "not" BExp                           [strict] // not_: BExp ----------> BExp
                     > BExp "and" BExp                   [strict(1)] //  and: BExp ----------> BExp
                     > BExp  "or" BExp                      [strict] //   or: BExp ----------> BExp

// Bundles
  syntax    Bundle ::= "bundle+" "{" Proc "}"
                     | "bundle-" "{" Proc "}"
                     | "bundle0" "{" Proc "}"
                     | "bundle"  "{" Proc "}"

  syntax KVariable ::= Name | Names

  syntax     KItem ::= Name | Names | Proc | Procs

endmodule

// SEMANTICS MODULE
module GRHO
  import GRHO-SYNTAX
  import SUBSTITUTION
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
        <sends color="teal">                                         //**sends**
          <send color="cyan" multiplicity="*">                       //
            // guard for type of message?                            //
            <schan> .K </schan>                                      // sending channel (many messages on same channel)
            <msg>   .K   </msg>                                      // sent message
            <tuple> .K </tuple>                                      // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
            <sper>  .K  </sper>                                      // 0 for single send (consumed), 1 for persistent send (not consumed)
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      //
            // guard for allowed type(s)?                            //
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
                  <schan>      X      </schan>                       //sending channel X
                  <msg>        P        </msg>                       //sending message P
                  <tuple>      1      </tuple>                       //1-tuple = ( Proc )
                  <sper>       0       </sper>                       //single send => consumed in comm
                </send>)                                             //

// N-tuple messages, N > 1
  rule <k> X:Name ! ( P:Procs ) => . ...</k>                         //dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X      </schan>                       //sending channel X
                  <msg>        P        </msg>                       //sending messages P, two or more
                  <tuple> #length (P) </tuple>                       //length of tuple - how many messages
                  <sper>       0       </sper>                       //single send => consumed in comm
                </send>)                                             //

//--- Persistent Sends ---
// Process message <=> 1-tuple
  rule <k> X:Name !! ( P:Proc ) => . ...</k>                         //dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        //sending channel X
                  <msg>        P       </msg>                        //sending message P
                  <tuple>      1     </tuple>                        //1-tuple
                  <sper>       1      </sper>                        //repeated send => NOT consumed in comm
                </send>)                                             //

// N-tuple messages, N > 1
  rule <k> X:Name !! ( P:Procs ) => . ...</k>                        //dissolve send in <threads/> and spawn <send/>
       (.Bag => <send>                                               //
                  <schan>      X     </schan>                        //sending channel X
                  <msg>        P       </msg>                        //sending messages P, two or more
                  <tuple> #length(P) </tuple>                        //length of tuple
                  <sper>       1      </sper>                        //repeated send
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
                  <rper>      0      </rper>                         //single listen => consumed in comm
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

// Listen for N-tuple, N > 1
  rule <k> for ( Y:Names <- X:Name ) { P:Proc } => . ...</k>         //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //comma-separated list of patterns Y binding in continuation P
                  <bnum>  #length Y  </bnum>                         //
                  <rper>      0      </rper>                         //single listen => consumed in comm
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

//--- Persistent Receives ---
// Listen for 1-tuple
  rule <k> for ( Y:Name <= X:Name ) { P:Proc } => . ...</k>          //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variable Y binding in continuation P
                  <bnum>      1      </bnum>                         //
                  <rper>      1      </rper>                         //repeated listen
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

// Listen for N-tuple, N > 1
  rule <k> for ( Y:Names <= X:Name ) { P:Proc } => . ...</k>         //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variables Y binding in continuation P
                  <bnum>  #length Y  </bnum>                         //
                  <rper>      1      </rper>                         //repeated listen
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

//--- Peek ---
// Peek for 1-tuple
  rule <k> for ( Y:Name <! X:Name ) { P:Proc } => . ...</k>          //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variable Y binding in continuation P
                  <bnum>      1      </bnum>                         //
                  <rper>      2      </rper>                         //peek
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

// Listen for N-tuple, N > 1
  rule <k> for ( Y:Names <! X:Name ) { P:Proc } => . ...</k>         //dissolve Rec in <threads/> and spawn <rec/>
       (.Bag => <rec>                                                //
                  <rchan>     X     </rchan>                         //receiving channel X
                  <bvars>     Y     </bvars>                         //variables Y binding in continuation P
                  <bnum>  #length Y  </bnum>                         //
                  <rper>      2      </rper>                         //peek
                  <cont>      P      </cont>                         //continuation P
                </rec>)                                              //

//-------------
//--- Joins ---
//-------------
// Linear
  rule <k> for ( B:Lbinds ){ P:Proc } => . ...</k>                   //
       (.Bag => <rec>                                                //
                  <rchan> #chans   (B) </rchan>                      //
                  <bvars> #bvars   (B) </bvars>                      //
                  <bnum>  #lengths (B)  </bnum>                      //
                  <rper>        0       </rper>                      //
                  <cont>        P       </cont>                      //
                </rec>)                                              //

// Repeated
  rule <k> for ( B:Rbinds ){ P:Proc } => . ...</k>                   //
       (.Bag => <rec>                                                //
                  <rchan> #chans   (B) </rchan>                      //
                  <bvars> #bvars   (B) </bvars>                      //
                  <bnum>  #lengths (B)  </bnum>                      //
                  <rper>        1       </rper>                      //
                  <cont>        P       </cont>                      //
                </rec>)                                              //

// Peek
  rule <k> for ( B:Pbinds ){ P:Proc } => . ...</k>                   //
       (.Bag => <rec>                                                //
                  <rchan> #chans   (B) </rchan>                      //
                  <bvars> #bvars   (B) </bvars>                      //
                  <bnum>  #lengths (B)  </bnum>                      //
                  <rper>        2       </rper>                      //
                  <cont>        P       </cont>                      //
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
    </reaction>                                               [strict]

  rule
    <reaction>
      <who>   P:Proc          => .K   </who>
      <what>  Q:Proc , R:Proc => .K  </what>
      <where> Y:Name , Z:Name => .K </where>
    </reaction>
   (.Bag => <thread> <k> P[@ Q / Y][@ R / Z] </k> </thread>)

  rule
    <reaction>
      <who>   P:Proc => .K   </who>
      <what>  Q:Proc => .K  </what>
      <where> Y:Name => .K </where>
    </reaction>
   (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)

// Comm semantics
// Single listen, single send
// 1-tuple message
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name </rchan>                                           // channel X
     <bvars> Y:Name </bvars>                                           // binding variable Y
     <bnum>  1       </bnum>                                           // one name to bind
     <rper>  0       </rper>                                           // single listen
     <cont>  P:Proc  </cont>                                           // continuation P
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X      </schan>                                           // channel X
     <msg>   Q:Proc   </msg>                                           // message Q
     <tuple> 1      </tuple>                                           // 1-tuple
     <sper>  0       </sper>                                           // single send
   </send> => .Bag)                                                    //
  (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)                     //spawn single <thread/> holding sub P[@Q / Y]
                                                                [comm] //tagged "comm" for tracking nondeterminism

// 2-tuple (base case for several processes)
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name          </rchan>                                  // channel X
     <bvars> Y:Name , Z:Name </bvars>                                  // binding variables Y, Z
     <bnum>  2                </bnum>                                  // N names to bind
     <rper>  0                </rper>                                  // single listen
     <cont>  P:Proc           </cont>                                  // continuation P
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X              </schan>                                   // channel X
     <msg>   Q:Proc , R:Proc  </msg>                                   // message(s) Q, R
     <tuple> 2              </tuple>                                   // 2-tuple
     <sper>  0               </sper>                                   // single send
   </send> => .Bag)                                                    //
  (.Bag => <thread> <k> P[@ Q / Y][@ R / Z] </k> </thread>)            //spawn single <thread/> holding substituted continuation
                                                                [comm]

// N-tuple, N > 2
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name           </rchan>                                 // channel X
     <bvars> Y:Name , Z:Names </bvars>                                 // binding variable Y
     <bnum>  N:Int             </bnum>                                 // N names to bind
     <rper>  0                 </rper>                                 // single listen
     <cont>  P:Proc            </cont>                                 // continuation P
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X                </schan>                                 // channel
     <msg>   Q:Proc , R:Procs   </msg>                                 // message
     <tuple> N                </tuple>                                 // N-tuple
     <sper>  0                 </sper>                                 // single send
   </send> => .Bag)
   <reaction>
     <who>   .K => P       </who>
     <what>  .K => Q , R  </what>
     <where> .K => Y , Z </where>
   </reaction>                                                  [comm]

// Persistent listen, single send
  rule                                                                 //consume single send, keep persistent receive
   <rec>                                                               //DON'T consume persistent receive
     <rchan> X:Name </rchan>                                           // channel X
     <bvars> Y:Name </bvars>                                           // binding variable Y
     <bnum>  1       </bnum>                                           // one name to bind
     <rper>  1       </rper>                                           // single listen
     <cont>  P:Proc  </cont>                                           // continuation P
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X      </schan>                                           // channel X
     <msg>   Q:Proc   </msg>                                           // message
     <tuple> 1      </tuple>                                           // 1-tuple
     <sper>  0       </sper>                                           // single send
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>
     <where> .K => Y </where>
   </reaction>                                                  [comm]

// 2-tuple (base case for several processes)
  rule                                                                 //consume send and keep persistent receive
   <rec>                                                               //DON'T consume receive
     <rchan> X:Name          </rchan>                                  // channel X
     <bvars> Y:Name , Z:Name </bvars>                                  // binding variables Y, Z
     <bnum>  2                </bnum>                                  // N names to bind
     <rper>  1                </rper>                                  // single listen
     <cont>  P:Proc           </cont>                                  // continuation P
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X              </schan>                                   // channel X
     <msg>   Q:Proc , R:Proc  </msg>                                   // message(s)
     <tuple> 2              </tuple>                                   // 2-tuple
     <sper>  0               </sper>                                   // single send
   </send> => .Bag)                                                    //
   <reaction>
     <who>   .K => P       </who>
     <what>  .K => Q , R  </what>
     <where> .K => Y , Z </where>
   </reaction>                                                  [comm]

// N-tuple, N > 2
  rule                                                                 //consume single send, keep persistent receive
   <rec>                                                               //DON'T consume persistent receive
     <rchan> X:Name           </rchan>                                 // channel X
     <bvars> Y:Name , Z:Names </bvars>                                 // binding variables Y, Z
     <bnum>  N:Int             </bnum>                                 // N names to bind
     <rper>  1                 </rper>                                 // single listen
     <cont>  P:Proc            </cont>                                 // continuation P
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X                </schan>                                 // channel X
     <msg>   Q:Proc , R:Procs   </msg>                                 // message(s)
     <tuple> N                </tuple>                                 // N-tuple
     <sper>  0                 </sper>                                 // single send
   </send> => .Bag)
   <reaction>
     <who>   .K => P       </who>
     <what>  .K => Q , R  </what>
     <where> .K => Y , Z </where>
   </reaction>                                           [comm,strict]

// Single listen, persistent send
  rule                                                                 //consume single receive, keep persistent send
  (<rec>                                                               //consume single receive
     <rchan> X:Name </rchan>                                           // channel X
     <bvars> Y:Name </bvars>                                           // binding variable(s)
     <bnum>  1       </bnum>                                           // one name to bind
     <rper>  0       </rper>                                           // single listen
     <cont>  P:Proc  </cont>                                           // continuation
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X      </schan>                                           // channel X
     <msg>   Q:Proc   </msg>                                           // message Q
     <tuple> 1      </tuple>                                           // 1-tuple
     <sper>  1       </sper>                                           // single send
   </send>                                                             //
   <reaction>
     <who>   .K => P   </who>
     <what>  .K => Q  </what>
     <where> .K => Y </where>
   </reaction>                                                  [comm]

// 2-tuple (base case for several processes)
  rule                                                                 //consume single receive and keep single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name          </rchan>                                  // channel X
     <bvars> Y:Name , Z:Name </bvars>                                  // binding variables Y,Z
     <bnum>  2                </bnum>                                  // N names to bind
     <rper>  0                </rper>                                  // single listen => consumed
     <cont>  P:Proc           </cont>                                  // continuation
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X              </schan>                                   // channel X
     <msg>   Q:Proc , R:Proc  </msg>                                   // messages
     <tuple> 2              </tuple>                                   // 2-tuple
     <sper>  1               </sper>                                   // single send
   </send>                                                             //
   <reaction>
     <who>   .K => P       </who>
     <what>  .K => Q , R  </what>
     <where> .K => Y , Z </where>
   </reaction>                                                  [comm]

// N-tuple, N > 2
  rule                                                                 //consume single receive and keep single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name           </rchan>                                 // channel X
     <bvars> Y:Name , Z:Names </bvars>                                 // binding variable(s)
     <bnum>  N:Int             </bnum>                                 // N names to bind
     <rper>  0                 </rper>                                 // single listen
     <cont>  P:Proc            </cont>                                 // continuation
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X                </schan>                                 // channel X
     <msg>   Q:Proc , R:Procs   </msg>                                 // messages
     <tuple> N                </tuple>                                 // N-tuple
     <sper>  1                 </sper>                                 // persistent send
   </send>                                                             //
   <reaction>
     <who>   .K => P       </who>
     <what>  .K => Q , R  </what>
     <where> .K => Y , Z </where>
   </reaction>                                           [comm,strict]

// Peek semantics
// 1-tuple message
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name </rchan>                                           // channel X
     <bvars> Y:Name </bvars>                                           // binding variable Y
     <bnum>  1       </bnum>                                           // one name to bind
     <rper>  2       </rper>                                           // peek
     <cont>  P:Proc  </cont>                                           // continuation P
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X      </schan>                                           // channel X
     <msg>   Q:Proc   </msg>                                           // message Q
     <tuple> 1      </tuple>                                           // 1-tuple
     <sper>  _       </sper>                                           // single or repeated send
   </send>                                                             //
  (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)                     //spawn single <thread/> holding sub P[@Q / Y]

// 2-tuple (base case for several processes)
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name          </rchan>                                  // channel X
     <bvars> Y:Name , Z:Name </bvars>                                  // binding variables Y, Z
     <bnum>  2                </bnum>                                  // N names to bind
     <rper>  2                </rper>                                  // peek
     <cont>  P:Proc           </cont>                                  // continuation P
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X              </schan>                                   // channel X
     <msg>   Q:Proc , R:Proc  </msg>                                   // message(s) Q, R
     <tuple> 2              </tuple>                                   // 2-tuple
     <sper>  _               </sper>                                   // single or repeated send
   </send>                                                             //
  (.Bag => <thread> <k> P[@ Q / Y][@ R / Z] </k> </thread>)            //spawn single <thread/> holding substituted continuation

// N-tuple, N > 2
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name           </rchan>                                 // channel X
     <bvars> Y:Name , Z:Names </bvars>                                 // binding variable Y
     <bnum>  N:Int             </bnum>                                 // N names to bind
     <rper>  2                 </rper>                                 // peek
     <cont>  P:Proc            </cont>                                 // continuation P
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X                </schan>                                 // channel
     <msg>   Q:Proc , R:Procs   </msg>                                 // message
     <tuple> N                </tuple>                                 // N-tuple
     <sper>  _                 </sper>                                 // single or repeated send
   </send>
   <reaction>
     <who>   .K => P       </who>
     <what>  .K => Q , R  </what>
     <where> .K => Y , Z </where>
   </reaction>

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

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

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION

// Free & Bound Names
/*rule FN(   Nil    ) => .Set
  rule FN( _:Bool   ) => .Set
  rule FN( _:Int    ) => .Set
  rule FN( _:String ) => .Set
  rule FN( X:Name ( Y:Name )  { P:Proc } ) => SetItem(X) (FN(P) -Set SetItem(Y))
  rule FN( X:Name ! ( P:Proc ) )  => SetItem(X) FN(P)
  rule FN( P:Proc | Q:Proc )      => FN(P) FN(Q)
  rule FN( * X:Name )             => SetItem(X)
*/
endmodule
