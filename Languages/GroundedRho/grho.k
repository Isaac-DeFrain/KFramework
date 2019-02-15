// RHO CALCULUS with Bool, Int, String ground terms and free name function
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
                     | "{" Name "}"                       [bracket]  //    {_}: Name -----> Name
                     | NameVar

  syntax     Quote ::= "@" Proc                                      //      @: Proc ----> Quote

	syntax     Names ::= Name "," Name                                 // _,_: Name x Name ----> Names
	                   | Name "," Names                                // _,_: Name x Names ---> Names
										 | "@" Procs                                     // for tuple comms

//-----------------
//--- PROCESSES ---
//-----------------
  syntax      Proc ::= "{" Proc "}"                       [bracket]  // {_}: Proc --------> Proc
                     | "Nil"                                         // Nil: -------------> Proc
                     | Collection                                    // Collection of processes
                     | Ground                                        // Bool, Int, String < Proc
                     | AExp                                          // Arithmetic expressions: AExp < Proc
                     | BExp                                          //    Boolean expressions: BExp < Proc
                     | Eval                                          //    Eval < Proc
                     | Receive                                       // Receive < Proc
                     | Send                                          //    Send < Proc
                     > Par                                           //     Par < Proc

  syntax       Par ::= Proc "|" Proc                         [left]  //     _|_: Proc x Proc --------------> Par

	syntax   Receive ::= "for" "(" Name  "<-" Name ")" "{" Proc "}"  [binder(2)]  // _(_){_}: Name x Name  x Proc ---> Receive, single pattern
	                   | "for" "(" Names "<-" Name ")" "{" Proc "}"  [binder(2)]  // _(_){_}: Name x Names x Proc ---> Receive, several patterns
/*
  syntax   Receive ::= "for" "(" Bind  ")" "{" Proc "}"  [binder(2)]  // for(_){_}: Bind  x Proc ---> Receive, monadic
	                   | "for" "(" Binds ")" "{" Proc "}"  [binder(2)]  // for(_){_}: Binds x Proc ---> Receive, polyadic

	syntax      Bind ::= Lbind                                         // linear bind, for( y <- x ){ P }
	                   | Rbind                                         // repeated bind, for( y <= x ){ P }

  syntax     Binds ::= Lbinds
	                   | Rbinds

	syntax     Lbind ::= Name  "<-" Name
	                   | Names "<-" Name

	syntax    Lbinds ::= Lbind
	                   | Lbind ";" Lbinds

	syntax     Rbind ::= Name  "<=" Name
	                   | Names "<=" Name

 	syntax    Rbinds ::= Rbind
 	                   | Rbind ";" Rbinds
*/
  syntax      Send ::= Name "!" "(" Proc ")"                         // _!(_): Name x Proc -------------> Send, monadic
                     | Name "!" RhoTuple                             //   _!_: Name x RhoTuple ---------> Send, polyadic

  syntax      Eval ::= "*" Name

  syntax       Set ::= "FN(" Proc ")"                    [function]  // FN: Proc ------------> Set

// Sets
  syntax      Proc ::= Set                                           // Set < Proc
                     | "(" Set ")"                        [bracket]  // (_): Set ------------> Set

  syntax     Procs ::= Proc "," Proc                       [strict]  // _,_: Proc x Proc ----> Procs
                     | Proc "," Procs                      [strict]  // _,_: Proc x Procs ---> Procs

// Collection
  syntax
        Collection ::= RhoList
                     | RhoMap
                     | RhoSet
                     | RhoTuple

  syntax   RhoList ::= "[" Proc  "]"                       [strict]
                     | "[" Procs "]"                       [strict]

  syntax    RhoMap ::= "{" RhoKVPairs "}"

  syntax
        RhoKVPairs ::= Proc ":" Proc
                     | Proc ":" Proc "," RhoKVPairs

  syntax    RhoSet ::= "Set" "(" Proc  ")"                 [strict]
                     | "Set" "(" Procs ")"                 [strict]

  syntax  RhoTuple ::= "(" Proc ",)"                                  // 1-tuple
                     | "(" Procs ")"                                  // n-tuple, n > 2

// Ground terms
  syntax    Ground ::= Int | Bool | String                           //Int, Bool, String < Ground

// AExp & BExp resolve to ground terms
// Arithmetic
  syntax      AExp ::= "(" AExp ")"                                  //     (_): AExp ------> AExp
                     | Int                                           //    Int < AExp
                     | Eval                                          //   Eval < AExp , for interesting message passing: for( y <- x ){ *y + 5 }
                     | String                                        // String < AExp (S1 + S2 => S1 +String S2)
                     > AExp "*" AExp                       [strict]  // _*_: AExp x AExp ---> AExp
                     > AExp "+" AExp                       [strict]  // _+_: AExp x AExp ---> AExp
										 | AExp "-" AExp                       [strict]

// Boolean
  syntax      BExp ::= Bool                                          //   Bool < BExp
                     | "(" BExp ")"                                  //  (_): BExp ----------> BExp
                     | Eval                                          //   Eval < BExp
                     | String                                        // String < BExp
                     | AExp  "<=" AExp                  [seqstrict]  // _<=_: AExp x AExp ---> BExp
                     | "not" BExp                          [strict]  // not_: BExp ----------> BExp
                     > BExp "and" BExp                  [strict(1)]  //  and: BExp ----------> BExp
                     > BExp  "or" BExp                     [strict]  //   or: BExp ----------> BExp

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
    <T color="purple">
      <threadpool color="red">
        <thread multiplicity="*">                             // collection of threads
          <k> $PGM:Proc </k>                                  // programs and computations are process-based
        </thread>                                             //
      </threadpool>                                           // tuplespace stores sends and receives
      <tuplespace color="blue">                               //
        <sends color="teal">                                  //**sends**
          <send color="cyan" multiplicity="*">                //
					// type of message?
            <schan> .K </schan>                               // sending channel (many messages on same channel)
            <msg>   .K   </msg>                               // sent message
						<tuple> .K </tuple>                               // equals N if N-tuple (Proc is "0-tuple") - this will ensure matching with the right pattern
						<sper>  .K  </sper>                               // 1 for persistent send, 0 for single send
          </send>                                             //
        </sends>                                              //
        <receives color="green">                              //**receives** - add join cell with fresh int from same join
          <rec color="yellow" multiplicity="*">               //
					// allowed type(s)?
            <rchan> .K </rchan>                               // receiving channel (many messages on same channel)
            <bvar>  .K  </bvar>                               // binding varible in continuation
						<bnum>  .K  </bnum>                               // number of bindings
						<join>  .K  </join>                               // 0 for linear listen, else all listens in join get the same fresh int upon entering the tuplespace
						<rper>  .K  </rper>                               // 1 for persistent listen, 0 for single listen
            <cont>  .K  </cont>                               // continuation
          </rec>
        </receives>
      </tuplespace>
    </T>

  syntax KResult ::= Ground | Eval | Set

// Arithmetic
  rule I1:Int + I2:Int => I1 +Int I2    [anywhere]
	rule I1:Int - I2:Int => I1 -Int I2    [anywhere]
  rule I1:Int * I2:Int => I1 *Int I2    [anywhere]

// Boolean
  rule I1:Int <= I2:Int => I1 <=Int I2  [anywhere]
  rule not B:Bool => notBool B          [anywhere]
  rule true and B:Bool => B             [anywhere]
  rule false and _ => false             [anywhere]

// Set
//rule S1:Set + S2:Set => S1 S2
//rule S1:Set - S2:Set => S1 -Set S2

// String
  rule S1:String + S2:String => S1 +String S2  [anywhere]

// PAR OPERATOR SEMANTICS
  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P </k> </thread>)
       (.Bag => <thread> <k> Q </k> </thread>)                  //[structural]

//--- Send Operator Semantics ---
// Process messages
  rule <k> X:Name ! ( P:Proc ) => . ...</k>                     //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>                                          //
                  <schan> X </schan>                            //sending channel X
                  <msg>   P   </msg>                            //message sent P
									<tuple> 0 </tuple>                            //"0-tuple"
									<sper>  0  </sper>                            //single send
                </send>)                                        //[structural]

// Tuple messages
// 1-tuple messages = Process messages?
  rule <k> X:Name ! ( P:Proc ,) => . ...</k>                    //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>                                          //
                  <schan> X </schan>                            //sending channel X
                  <msg>   P   </msg>                            //message sent P
									<tuple> 1 </tuple>                            //1-tuple
									<sper>  0  </sper>                            //single send
                </send>)                                        //[structural]

// N-tuple messages, N > 1
  rule <k> X:Name ! ( P:Procs ) => . ...</k>                    //dissolve send in <threadpool/> and spawn <send/>
			 (.Bag => <send>                                          //
			            <schan>      X      </schan>                  //sending channel X
			            <msg>        P        </msg>                  //message sent P
									<tuple> #length (P) </tuple>                  //length of tuple
									<sper>       0       </sper>                  //single send
			          </send>)                                        //[structural]

//--- Receive Operator Semantics ---
  rule <k> for ( Y:Name <- X:Name ) { P:Proc } => . ...</k>     //dissolve Rec in <threadpool/> and spawn <rec/>
       (.Bag => <rec>                                           //
                  <rchan> X </rchan>                            //receiving channel X
                  <bvar>  Y  </bvar>                            //variable Y binding in continuation P
									<bnum>  1  </bnum>                            //
									<join>  0  </join>                            //no join
									<rper>  0  </rper>                            //single listen
                  <cont>  P  </cont>                            //continuation P
                </rec>)                                         //[structural]

	rule <k> for ( Y:Names <- X:Name ) { P:Proc } => . ...</k>    //dissolve Rec in <threadpool/> and spawn <rec/>
	     (.Bag => <rec>                                           //
	                <rchan>     X     </rchan>                    //receiving channel X
	                <bvar>      Y      </bvar>                    //variable Y binding in continuation P
									<bnum>  #length Y  </bnum>                    //number of binding names
									<join>      0      </join>                    //no join
									<rper>      0      </rper>                    //single listen
	                <cont>      P      </cont>                    //continuation P
	              </rec>)                                         //[structural]

// COMM EVENT: x!(Q) | y(z){P} and x equivN y => P[@Q / y]
//--- Process messages ---
  rule                                                          //dissolve send and receive on "same" channel
  (<rec>                                                        //dissolve receive:
     <rchan> X:Name </rchan>                                    // channel X
     <bvar>  Y:Name  </bvar>                                    // binding variable Y
		 <bnum>  1       </bnum>                                    // one name to bind
		 <join>  0       </join>                                    // no join
		 <rper>  0       </rper>                                    // single listen
     <cont>  P:Proc  </cont>                                    // continuation P
   </rec> => .Bag)                                              //
  (<send>                                                       //dissolve send:
     <schan> X     </schan>                                     // channel X
     <msg>   Q:Proc  </msg>                                     // message Q
		 <tuple> 0     </tuple>                                     // 0-tuple
		 <sper>  0      </sper>                                     // single send
   </send> => .Bag)                                             //
  (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)              //spawn single <thread/> holding sub P[@Q / Y]
  [comm]                                                        //tagged "comm" for tracking nondeterminism

//--- Tuple messages ---
// requires binding variable Y to be a tuple of the same length as T
// substitution is done by mapping the coordinates
// 1-tuple
  rule                                                          //dissolve send and receive on "same" channel
  (<rec>                                                        //dissolve receive:
     <rchan> X:Name </rchan>                                    // channel X
     <bvar>  Y:Name  </bvar>                                    // binding variable Y
		 <bnum>  1       </bnum>                                    // one name to bind
		 <join>  0       </join>                                    // no join
		 <rper>  0       </rper>                                    // single listen
     <cont>  P:Proc  </cont>                                    // continuation P
   </rec> => .Bag)                                              //
  (<send>                                                       //dissolve send:
     <schan> X      </schan>                                    // channel X
     <msg>   T:Proc   </msg>                                    // message T
		 <tuple> 1      </tuple>                                    // 1-tuple
		 <sper>  0       </sper>                                    // single send
   </send> => .Bag)                                             // FIRST create the map {T_i |-> Y_i} and THEN use it for substitution (may require another module)
  (.Bag => <thread> <k> P[@ T / Y] </k> </thread>)              //spawn single <thread/> holding sub P[@Q / Y]
  [comm]                                                        //tagged "comm" for tracking nondeterminism

// N-tuple, N > 1
  rule                                                          //dissolve send and receive on "same" channel
  (<rec>                                                        //dissolve receive:
  	 <rchan> X:Name </rchan>                                    // channel X
  	 <bvar>  Y:Name , Z:Name </bvar>                            // binding variables Y, Z
  	 <bnum>  2       </bnum>                                    // N names to bind
	   <join>  0       </join>                                    // no join
  	 <rper>  0       </rper>                                    // single listen
  	 <cont>  P:Proc  </cont>                                    // continuation P
   </rec> => .Bag)                                              //
  (<send>                                                       //dissolve send:
  	 <schan> X             </schan>                             // channel X
  	 <msg>   Q:Proc , R:Proc </msg>                             // message(s) Q, R
  	 <tuple> 2             </tuple>                             // 2-tuple
  	 <sper>  0              </sper>                             // single send
   </send> => .Bag)                                             // FIRST create the map {T_i |-> Y_i} and THEN use it for substitution (may require another module)
  (.Bag => <thread> <k> P[@ Q / Y][@ R / Z] </k> </thread>)     //spawn single <thread/> holding sub P[@Q / Y]
  [comm]                                                        //tagged "comm" for tracking nondeterminism

	rule                                                          //dissolve send and receive on "same" channel
   <rec>                                                        //dissolve receive:
  	 <rchan> X:Name                </rchan>                     // channel X
  	 <bvar> Y:Name , Z:Names => Z </bvar>                     // binding variable Y
  	 <bnum> N:Int => N - 1     </bnum>                     // N names to bind
	   <join>  0                      </join>                     // no join
  	 <rper>  0                      </rper>                     // single listen
  	 <cont> P:Proc => P[@ Q / Y]  </cont>                     // continuation P
   </rec>                                                       //
   <send>                                                       //
  	 <schan>  X                    </schan>                     // channel X
  	 <msg>   Q:Proc , R:Procs => R </msg>                     // message
  	 <tuple> N => N - 1       </tuple>                     // N-tuple
  	 <sper>   0                     </sper>                     // single send
   </send>                                                      // FIRST create the map {T_i |-> Y_i} and THEN use it for substitution (may require another module)
  [comm]                                                        //tagged "comm" for tracking nondeterminism

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P                   //  [anywhere]
  rule P:Proc | Nil    => P                   //  [anywhere]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag  [structural]  //empty threads
  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N                          [anywhere]

// INVERSES
  rule   * @ P:Proc => P                          [anywhere]

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
