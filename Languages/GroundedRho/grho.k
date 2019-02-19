// RHO CALCULUS with Bool, Int, String ground terms and tuple messages in a monadic style
// No patterns, only name variables

require "domains.k"
require "substitution.k"
require "TupLen/tuplen.k"

module GRHO-SYNTAX
  import DOMAINS
  import SET
  import SUBSTITUTION


//-------------
//--- NAMES ---
//-------------
  syntax       Var ::= Id                                            //    Id < Var

  syntax   NameVar ::= Var                                           //   Var < NameVar

  syntax      Name ::= Quote                                         // Quote < Name
                     | "{" Name "}"                        [bracket] //    {_}: Name -----> Name
                     | NameVar

  syntax     Quote ::= "@" Proc                                      //      @: Proc ----> Quote

  syntax     Names ::= Name "," Name                                 // _,_: Name x Name ----> Names
                     | Name "," Names                                // _,_: Name x Names ---> Names
                     | "@" Procs                                     // for tuple comms

//-----------------
//--- PROCESSES ---
//-----------------
  syntax      Proc ::= "{" Proc "}"                        [bracket] // {_}: Proc --------> Proc
                     | "Nil"                                         // Nil: -------------> Proc
                     | Collection                                    // Collection of processes
                     | Ground                                        // Bool, Int, String < Proc
                     | AExp                                          // Arithmetic expressions: AExp < Proc
                     | BExp                                          //    Boolean expressions: BExp < Proc
                     | Eval                                          //    Eval < Proc
                     | Receive                                       // Receive < Proc
                     | Send                                          //    Send < Proc
                     | Par                                           //     Par < Proc

// Parallel
  syntax       Par ::= Proc "|" Proc                          [left] // _|_: Proc x Proc ---> Par

// Receive
  syntax   Receive ::= "for" "(" Bind  ")" "{" Proc "}"  [binder(2)] // _(_){_}: Bind  x Proc ---> Receive, single pattern
                     | "for" "(" Binds ")" "{" Proc "}"  [binder(2)] // _(_){_}: Binds x Proc ---> Receive, several patterns

  syntax      Bind ::= Lbind                                         // single linear bind, for( y <- x ){ P }
                     | Rbind                                         // single repeated bind, for( y <= x ){ P }

  syntax     Binds ::= Lbinds                                        // several linear binds, for( y1 <- x1 ; ... ; yN <- xN ){ P }
                     | Rbinds                                        // several repeated binds for( y1 <= x1 ; ... ; yN <= xN ){ P }

  syntax     Lbind ::= Name  "<-" Name                               // 1-tuple
                     | Names "<-" Name                               // N-tuple, N > 1

  syntax    Lbinds ::= Lbind ";" Lbind                               // 2 liner listens
                     | Lbind ";" Lbinds                              // N linear listens, N > 2

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
  syntax     Procs ::= Proc "," Proc                        [strict] // _,_: Proc x Proc ----> Procs
                     | Proc "," Procs                       [strict] // _,_: Proc x Procs ---> Procs

// Collections
  syntax
        Collection ::= RhoList
                     | RhoMap
                     | RhoSet
                     | RhoTuple

// Process lists
  syntax   RhoList ::= "[" Proc  "]"                        [strict]
                     | "[" Procs "]"                        [strict]

// Process maps
  syntax    RhoMap ::= "{" RhoKVPairs "}"

  syntax
        RhoKVPairs ::= Proc ":" Proc
                     | Proc ":" Proc "," RhoKVPairs

// Process sets
  syntax    RhoSet ::= "Set" "(" Proc  ")"                  [strict]
                     | "Set" "(" Procs ")"                  [strict]

// Process tuples
  syntax  RhoTuple ::= "(" Proc  ")"                                 // 1-tuple
                     | "(" Procs ")"                                 // N-tuple, N > 1

// Ground terms
  syntax    Ground ::= Int | Bool | String                           //Int, Bool, String < Ground

// AExp & BExp resolve to ground terms
// Arithmetic
  syntax      AExp ::= "(" AExp ")"                                  //     (_): AExp ------> AExp
                     | Int                                           //    Int < AExp
                     | Eval                                          //   Eval < AExp , for interesting message passing, e.g. for( y <- x ){ *y + 5 }
                     | String                                        // String < AExp (S1 + S2 => S1 +String S2)
                     > AExp "*" AExp                        [strict] // _*_: AExp x AExp ---> AExp
                     > AExp "+" AExp                        [strict] // _+_: AExp x AExp ---> AExp
                     | AExp "-" AExp                        [strict] // _-_: AExp x AExp ---> AExp

// Boolean
  syntax      BExp ::= Bool                                          //   Bool < BExp
                     | "(" BExp ")"                                  //  (_): BExp ----------> BExp
                     | Eval                                          //   Eval < BExp
                     | String                                        // String < BExp
                     | AExp  "<=" AExp                   [seqstrict] // _<=_: AExp x AExp ---> BExp
                     | "not" BExp                           [strict] // not_: BExp ----------> BExp
                     > BExp "and" BExp                   [strict(1)] //  and: BExp ----------> BExp
                     > BExp  "or" BExp                      [strict] //   or: BExp ----------> BExp

// Structural & Name Equivalences - not finished yet
  syntax      Bool ::= Proc "equiv"  Proc
                     | Name "equivN" Name

  syntax KVariable ::= Name | Names

  syntax     KItem ::= Name | Names | Proc | Procs

endmodule


module GRHO
  import GRHO-SYNTAX
  import SUBSTITUTION
  import TUPLEN

  configuration
    <T color="purple">                                        //
      <threadpool color="red">                                //
        <thread multiplicity="*">                             // collection of threads
          <k> $PGM:Proc </k>                                  // programs and computations are process-based
        </thread>                                             //
      </threadpool>                                           // tuplespace stores sends and receives
      <tuplespace color="blue">                               //
        <sends color="teal">                                  //**sends**
          <send color="cyan" multiplicity="*">                //
            // guard for type of message?                     //
            <schan> .K </schan>                               // sending channel (many messages on same channel)
            <msg>   .K   </msg>                               // sent message
            <tuple> .K </tuple>                               // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
            <sper>  .K  </sper>                               // 1 for persistent send (not dissolved), 0 for single send (dissolved)
          </send>                                             //
        </sends>                                              //
        <receives>                                            //
          <rec color="yellow" multiplicity="*">               //
            // guard for allowed type(s)?                     //
            <rchan> .K </rchan>                               // receiving channel (many messages on same channel)
            <bvars> .K </bvars>                               // binding varible in continuation
            <bnum>  .K  </bnum>                               // number of bindings
            <rper>  .K  </rper>                               // 1 for persistent listen, 0 for single listen
            <cont>  .K  </cont>                               // continuation
          </rec>                                              //
        </receives>                                           //
      </tuplespace>                                           //
      <reaction>                                              // put comming <send/> & <receive/> info here
        <who>   .K   </who>                                   // continuation process
        <what>  .K  </what>                                   // msg process(es)
        <where> .K </where>                                   // binding variable(s)
      </reaction>                                             //
    </T>                                                      //

  syntax KResult ::= Ground | Eval

// Arithmetic
  rule I1:Int + I2:Int => I1 +Int I2                [anywhere]
  rule I1:Int - I2:Int => I1 -Int I2                [anywhere]
  rule I1:Int * I2:Int => I1 *Int I2                [anywhere]

// Boolean
  rule I1:Int <= I2:Int => I1 <=Int I2              [anywhere]
  rule not B:Bool => notBool B                      [anywhere]
  rule true and B:Bool => B                         [anywhere]
  rule false and _ => false                         [anywhere]

// Set
//rule S1:Set + S2:Set => S1 S2
//rule S1:Set - S2:Set => S1 -Set S2

// String
  rule S1:String + S2:String => S1 +String S2       [anywhere]

// PAR OPERATOR SEMANTICS
  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P </k> </thread>)
       (.Bag => <thread> <k> Q </k> </thread>)                  //[structural]

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------

// Add <send/> cell to <tuplespace/>

//--- Single Sends ---
// Process message = 1-tuple
  rule <k> X:Name ! ( P:Proc ) => . ...</k>                     //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>                                          //
                  <schan>      X      </schan>                  //sending channel X
                  <msg>        P        </msg>                  //message sent P
                  <tuple>      1      </tuple>                  //1-tuple
                  <sper>       0       </sper>                  //single send
                </send>)                                        //[structural]

// N-tuple messages, N > 1
  rule <k> X:Name ! ( P:Procs ) => . ...</k>                    //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>                                          //
                  <schan>      X      </schan>                  //sending channel X
                  <msg>        P        </msg>                  //message sent P
                  <tuple> #length (P) </tuple>                  //length of tuple
                  <sper>       0       </sper>                  //single send
                </send>)                                        //[structural]

//--- Persistent Sends ---
// Process message = 1-tuple
  rule <k> X:Name !! ( P:Proc ) => . ...</k>                    //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>                                          //
                  <schan>      X     </schan>                   //sending channel X
                  <msg>        P       </msg>                   //message sent P
                  <tuple>      1     </tuple>                   //1-tuple
                  <sper>       1      </sper>                   //single send
                </send>)                                        //[structural]

// N-tuple messages, N > 1
  rule <k> X:Name !! ( P:Procs ) => . ...</k>                   //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>                                          //
                  <schan>      X     </schan>                   //sending channel X
                  <msg>        P       </msg>                   //message sent P
                  <tuple> #length(P) </tuple>                   //length of tuple
                  <sper>       1      </sper>                   //single send
                </send>)                                        //[structural]

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------

//--- Single Receives ---
// Listen for 1-tuple
  rule <k> for ( Y:Name <- X:Name ) { P:Proc } => . ...</k>     //dissolve Rec in <threadpool/> and spawn <rec/>
       (.Bag => <rec>                                           //
                  <rchan>     X     </rchan>                    //receiving channel X
                  <bvars>     Y     </bvars>                    //variable Y binding in continuation P
                  <bnum>      1      </bnum>                    //
                  <rper>      0      </rper>                    //single listen
                  <cont>      P      </cont>                    //continuation P
                </rec>)                                         //[structural]

// Listen for N-tuple, N > 1
  rule <k> for ( Y:Names <- X:Name ) { P:Proc } => . ...</k>    //dissolve Rec in <threadpool/> and spawn <rec/>
       (.Bag => <rec>                                           //
                  <rchan>     X     </rchan>                    //receiving channel X
                  <bvars>     Y     </bvars>                    //variable Y binding in continuation P
                  <bnum>  #length Y  </bnum>                    //
                  <rper>      0      </rper>                    //single listen
                  <cont>      P      </cont>                    //continuation P
                </rec>)                                         //[structural]

//--- Persistent Receives ---
// Listen for 1-tuple
  rule <k> for ( Y:Name <= X:Name ) { P:Proc } => . ...</k>     //dissolve Rec in <threadpool/> and spawn <rec/>
       (.Bag => <rec>                                           //
                  <rchan>     X     </rchan>                    //receiving channel X
                  <bvars>     Y     </bvars>                    //variable Y binding in continuation P
                  <bnum>      1      </bnum>                    //
                  <rper>      1      </rper>                    //single listen
                  <cont>      P      </cont>                    //continuation P
                </rec>)                                         //[structural]

// Listen for N-tuple, N > 2
  rule <k> for ( Y:Names <= X:Name ) { P:Proc } => . ...</k>    //dissolve Rec in <threadpool/> and spawn <rec/>
       (.Bag => <rec>                                           //
                  <rchan>     X     </rchan>                    //receiving channel X
                  <bvars>     Y     </bvars>                    //variable Y binding in continuation P
                  <bnum>  #length Y  </bnum>                    //
                  <rper>      1      </rper>                    //single listen
                  <cont>      P      </cont>                    //continuation P
                </rec>)                                         //[structural]

//--- Joins ---
/*rule <k> for ( L:Lbinds ){ P:Proc } => . ...</k>
       (.Bag => <rec>
                  <rbind>    L    </rbind>
                  <bnum> #length L </bnum>
                  <rper>     0     </rper>
                  <cont>     P     </cont>
                </rec>)
*/
//-------------------
//--- COMM EVENTS ---
//-------------------
// x!(Q) | y(z){P} and x equivN y => P[@Q / y]

// Single listen, single send
// 1-tuple message
  rule                                                          //consume single send, single receive
  (<rec>                                                        //consume single receive
     <rchan> X:Name </rchan>                                    // channel X
     <bvars> Y:Name </bvars>                                    // binding variable Y
     <bnum>  1       </bnum>                                    // one name to bind
     <rper>  0       </rper>                                    // single listen
     <cont>  P:Proc  </cont>                                    // continuation P
   </rec> => .Bag)                                              //
  (<send>                                                       //consume single send
     <schan> X      </schan>                                    // channel X
     <msg>   Q:Proc   </msg>                                    // message Q
     <tuple> 1      </tuple>                                    // 1-tuple
     <sper>  0       </sper>                                    // single send
   </send> => .Bag)                                             //
  (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)              //spawn single <thread/> holding sub P[@Q / Y]
                                                        [comm]  //tagged "comm" for tracking nondeterminism

// 2-tuple (base case for several processes)
  rule                                                          //consume single send, single receive
  (<rec>                                                        //consume single receive
     <rchan> X:Name          </rchan>                           // channel X
     <bvars> Y:Name , Z:Name </bvars>                           // binding variables Y, Z
     <bnum>  2                </bnum>                           // N names to bind
     <rper>  0                </rper>                           // single listen
     <cont>  P:Proc           </cont>                           // continuation P
   </rec> => .Bag)                                              //
  (<send>                                                       //consume single send
     <schan> X              </schan>                            // channel X
     <msg>   Q:Proc , R:Proc  </msg>                            // message(s) Q, R
     <tuple> 2              </tuple>                            // 2-tuple
     <sper>  0               </sper>                            // single send
   </send> => .Bag)                                             //
  (.Bag => <thread> <k> P[@ Q / Y][@ R / Z] </k> </thread>)     //spawn single <thread/> holding substituted continuation
                                                        [comm]

// N-tuple, N > 2
  rule                                                          //consume single send, single receive
  (<rec>                                                        //consume single receive
     <rchan> X:Name           </rchan>                     // channel X
     <bvars> Y:Name , Z:Names </bvars>                     // binding variable Y
     <bnum>  N:Int             </bnum>                     // N names to bind
     <rper>  0                 </rper>                     // single listen
     <cont>  P:Proc            </cont>                     // continuation P
   </rec> => .Bag)                                                       //
  (<send>                                                       //consume single send
     <schan> X                </schan>                     // channel
     <msg>   Q:Proc , R:Procs   </msg>                     // message
     <tuple> N                </tuple>                     // N-tuple
     <sper>  0                 </sper>                     // single send
   </send> => .Bag)
   <reaction>
     <who>   .K => P       </who>
     <what>  .K => Q , R  </what>
     <where> .K => Y , Z </where>
   </reaction>                                        [comm]

  rule 
    <reaction>
      <who>   P:Proc => P[@ Q / Y]    </who>
      <what>  Q:Proc , R:Procs => R  </what>
      <where> Y:Name , Z:Names => Z </where>
    </reaction>                                     [strict]

  rule
    <reaction>
      <who>   P:Proc          => .K   </who>
      <what>  Q:Proc , R:Proc => .K  </what>
      <where> Y:Name , Z:Name => .K </where>
    </reaction>
   (.Bag => <thread> <k> P[@ Q / Y][@ R / Z] </k> </thread>)

/*
// Persistent listen, single send
  rule                                                          //consume single send, keep persistent receive
   <rec>                                                        //DON'T consume persistent receive
     <rchan> X:Name </rchan>                                    // channel X
     <bvars> Y:Name </bvars>                                    // binding variable Y
     <bnum>  1       </bnum>                                    // one name to bind
     <rper>  1       </rper>                                    // single listen
     <cont>  P:Proc  </cont>                                    // continuation P
   </rec>                                                       //
   <send>                                                       //consume single send
     <schan> X      </schan>                                    // channel X
     <msg>   _:Proc   </msg>                                    // message
     <tuple> 1      </tuple>                                    // 1-tuple
     <sper>  0       </sper>                                    // single send
   </send>                                                      //
   (.Bag => <rec>                                               //produce single receive to be consumed in comm
              <rchan> X </rchan>                                // channel
              <bvars> Y </bvars>                                // binding variable
              <bnum>  1  </bnum>                                // one name to bind
              <rper>  0  </rper>                                // single listen
              <cont>  P  </cont>                                // continuation
            </rec>)                                             //[structural]

// 2-tuple (base case for several processes)
  rule                                                          //consume send and keep persistent receive
   <rec>                                                        //DON'T consume receive
     <rchan> X:Name          </rchan>                           // channel X
     <bvars> Y:Name , Z:Name </bvars>                           // binding variables Y, Z
     <bnum>  2                </bnum>                           // N names to bind
     <rper>  1                </rper>                           // single listen
     <cont>  P:Proc           </cont>                           // continuation P
   </rec>                                                       //
   (.Bag => <rec>                                               //produce single receive to consume in comm
              <rchan> X     </rchan>                            // channel
              <bvars> Y , Z </bvars>                            // binding variables
              <bnum>  2      </bnum>                            // names to bind
              <rper>  0      </rper>                            // single listen
              <cont>  P      </cont>                            // continuation
            </rec>)                                             //
   <send>                                                       //consume single send
     <schan> X              </schan>                            // channel X
     <msg>   _:Proc , _:Proc  </msg>                            // message(s)
     <tuple> 2              </tuple>                            // 2-tuple
     <sper>  0               </sper>                            // single send
   </send>                                                      //[structural]

// N-tuple, N > 2
  rule                                                          //consume single send, keep persistent receive
   <rec>                                                        //DON'T consume persistent receive
     <rchan> X:Name           </rchan>                          // channel X
     <bvars> Y:Name , Z:Names </bvars>                          // binding variables Y, Z
     <bnum>  N:Int             </bnum>                          // N names to bind
     <rper>  1                 </rper>                          // single listen
     <cont>  P:Proc            </cont>                          // continuation P
   </rec>                                                       //
   (.Bag => <rec>                                               //produce single receive to dissolve in comm
              <rchan> X       </rchan>                          // channel
              <bvars> Y , Z   </bvars>                          // binding variables
              <bnum>  N        </bnum>                          // N names to bind
              <rper>  0        </rper>                          // single listen
              <cont>  P        </cont>                          // continuation
            </rec>)                                             //
   <send>                                                       //consume single send
     <schan> X                </schan>                          // channel X
     <msg>   _:Proc , _:Procs   </msg>                          // message(s)
     <tuple> N                </tuple>                          // N-tuple
     <sper>  0                 </sper>                          // single send
   </send>                                            //[strict]

// Single listen, persistent send
  rule                                                          //consume single receive, keep persistent send
   <rec>                                                        //consume single receive
     <rchan> X:Name </rchan>                                    // channel X
     <bvars> _:Name </bvars>                                    // binding variable(s)
     <bnum>  1       </bnum>                                    // one name to bind
     <rper>  0       </rper>                                    // single listen
     <cont>  _:Proc  </cont>                                    // continuation
   </rec>                                                       //
   <send>                                                       //DON'T consume persistent send
     <schan> X      </schan>                                    // channel X
     <msg>   Q:Proc   </msg>                                    // message Q
     <tuple> 1      </tuple>                                    // 1-tuple
     <sper>  1       </sper>                                    // single send
   </send>                                                      //
  (.Bag => <send>                                               //produce single send to consume in comm
             <schan> X </schan>                                 // channel
             <msg>   Q   </msg>                                 // message
             <tuple> 1 </tuple>                                 // 1-tuple
             <sper>  0  </sper>                                 // single send
           </send>)                                             //[structural]

// 2-tuple (base case for several processes)
  rule                                                          //consume single receive and keep single receive
   <rec>                                                        //consume single receive
     <rchan> X:Name          </rchan>                           // channel X
     <bvars> _:Name , _:Name </bvars>                           // binding variables
     <bnum>  2                </bnum>                           // N names to bind
     <rper>  0                </rper>                           // single listen
     <cont>  _:Proc           </cont>                           // continuation
   </rec>                                                       //
   <send>                                                       //DON'T consume persistent send
     <schan> X              </schan>                            // channel X
     <msg>   Q:Proc , R:Proc  </msg>                            // messages
     <tuple> 2              </tuple>                            // 2-tuple
     <sper>  1               </sper>                            // single send
   </send>                                                      //
  (.Bag => <send>                                               //produce single send to consume in comm
             <schan> X   </schan>                               // channel
             <msg>   Q , R </msg>                               // messages
             <tuple> 2   </tuple>                               // 2-tuple
             <sper>  0    </sper>                               // single send
           </send>)                                             //[structural]

// N-tuple, N > 2
  rule                                                          //consume single receive and keep single receive
   <rec>                                                        //consume single receive
     <rchan> X:Name           </rchan>                          // channel X
     <bvars> _:Name , _:Names </bvars>                          // binding variable(s)
     <bnum>  N:Int             </bnum>                          // N names to bind
     <rper>  0                 </rper>                          // single listen
     <cont>  _:Proc            </cont>                          // continuation
   </rec>                                                       //
   <send>                                                       //DON'T consume persistent send
     <schan> X                </schan>                          // channel X
     <msg>   Q:Proc , R:Procs   </msg>                          // messages
     <tuple> N                </tuple>                          // N-tuple
     <sper>  1                 </sper>                          // persistent send
   </send>                                                      //
   (.Bag => <send>                                              //produce single send to consume in comm
              <schan> X </schan>                                // channel
              <msg> Q , R </msg>                                // messages
              <tuple> N </tuple>                                // N-tuple
              <sper>  0  </sper>                                // single send
            </send>)                                  //[strict]
*/
// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P                                     //[anywhere]
  rule P:Proc | Nil    => P                                     //[anywhere]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag    [structural]  //empty threads
  rule <thread> <k> Nil </k> </thread> => .Bag    [structural]  //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N                            [anywhere]

// INVERSES
  rule   * @ P:Proc => P                            [anywhere]

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
