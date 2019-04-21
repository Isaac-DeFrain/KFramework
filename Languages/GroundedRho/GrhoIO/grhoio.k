// RHO CALCULUS with Bool, Int, String ground terms and Rholang features with I/O

require "domains.k"
require "substitution.k"
require "../AuxFun/auxfun.k"
require "../grho.k"

// SYNTAX MODULE
module GRHOIO-SYNTAX
  import DOMAINS
  import SUBSTITUTION
  import GRHO-SYNTAX

endmodule

// SEMANTICS MODULE
module GRHOIO
  import GRHOIO-SYNTAX
  import AUXFUN

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                               //
      <threads color="red">                                          //**activity threads**
        <thread color="green" multiplicity="*">                      // collection of threads (concurrent activity)
          <k> $PGM:Proc /* ~> output msg ~> read() */ </k>                                // programs and computations are process-based
        </thread>                                                    //
      </threads>                                                     //**tuplespace**
      <tuplespace color="blue">                                      // stores sends and receives
        <sends>                                                      //**sends**
          <send color="cyan" multiplicity="*">                       //
            <schan>  .K  </schan>                                    // sending channel (many messages on same channel)
            <msg>    .K    </msg>                                    // sent message
            <tuple>  .K  </tuple>                                    // equals N if N-tuple - for arity matching
            <stype>  .K  </stype>                                    // 0 for single send (consumed), 1 for persistent send (not consumed)
          </send>                                                    //
        </sends>                                                     //
        <receives>                                                   //
          <rec color="yellow" multiplicity="*">                      //
            <rchan>  .K  </rchan>                                    // receiving channel (many messages on same channel)
            <bvars>  .K  </bvars>                                    // binding varible(s) in continuation
            <bnum>   .K   </bnum>                                    // number of bindings
            <rtype>  .K  </rtype>                                    // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek, (3 for sequential?)
//            <guard>  .K  </guard>                                    // input guard
            <cont>   .K   </cont>                                    // continuation
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction color="green">                                       //**where the magic happens**
        <who>     .K     </who>                                      // continuation process
        <what>    .K    </what>                                      // msg process(es)
        <where>   .K   </where>                                      // binding variable(s)
      </reaction>                                                    // all comms are processed here
      <input color="magenta" stream="stdin"> .List </input>          //
      <output color="brown" stream="stdout"> .List </output>         // 
    </T>                                                             // 

  syntax KResult ::= Ground | Eval                                   // final output of strict operations

// Arithmetic
  rule I1:Int + I2:Int => I1 +Int I2                      [anywhere] // addition
  rule I1:Int - I2:Int => I1 -Int I2                      [anywhere] // subtraction
  rule I1:Int * I2:Int => I1 *Int I2                      [anywhere] // multiplication
  rule I1:Int / I2:Int => I1 /Int I2 requires I2 =/=Int 0 [anywhere] // division
  rule I1:Int % I2:Int => I1 %Int I2 requires I2 =/=Int 0 [anywhere] // modular reduction
  rule - I:Int => 0 -Int I                                [anywhere] // negation
  
  rule S1:String ++ S2:String => S1 +String S2            [anywhere] // string concatenation

// Boolean
  rule I1:Int <= I2:Int => I1 <=Int I2                    [anywhere] // 
  rule I1:Int <  I2:Int => I1  <Int I2                    [anywhere] // 
  rule I1:Int >= I2:Int => I1 >=Int I2                    [anywhere] // 
  rule I1:Int >  I2:Int => I1  >Int I2                    [anywhere] // 
  rule not B:Bool => notBool B                            [anywhere] // 
  rule true  and B:Bool => B                              [anywhere] // short-circuited 
  rule false and _:Bool => false                          [anywhere] // short-circuited 
  rule true  or  _:Bool => true                           [anywhere] // short-circuited 
  rule false or  B:Bool => B                              [anywhere] // short-circuited 
  
  rule A:Ground == B:Ground => A ==K  B                   [anywhere] // equality of ground terms
  rule A:Ground != B:Ground => A =/=K B                   [anywhere] // inequality of ground terms

// Collections
// TODO: what is up with lists?
/*rule [ ]:RhoList => .List                             [anywhere, structural]
  rule [ P:Proc ] => ListItem(P)                        [anywhere, structural]
  rule [ P:Proc , Q:Proc  ] => ListItem(P) ListItem(Q)  [anywhere, structural]
  rule [ P:Proc , Q:Procs ] => ListItem(P) [Q ]         [anywhere, structural]
*/
  // RhoMaps are interpreted as built-in Maps
  rule { }:RhoMap => .Map                                       [anywhere, structural]
  rule { P:Proc : Q:Proc } => P |-> Q                           [anywhere, structural]
  rule { P:Proc : Q:Proc , R:Proc : S:Proc } => P |-> Q R |-> S [anywhere, structural]
  rule { P:Proc : Q:Proc , R:RhoKVPairs    } => P |-> Q {R}     [anywhere, structural]

  // RhoSets are interpreted as built-in Sets
  rule Set( ) => .Set                                     [anywhere, structural]
  rule Set( P:Proc ) => SetItem(P)                        [anywhere, structural]
  rule Set( P:Proc , Q:Proc  ) => SetItem(P) SetItem(Q)   [anywhere, structural]
  rule Set( P:Proc , Q:Procs ) => SetItem(P) Set(Q)       [anywhere, structural]

// Conditionals - desugar into built-in conditionals
  rule if ( B:Bool ) then P:Proc             => #if B #then P #else Nil #fi  [anywhere, structural]
  rule if ( B:Bool ) then P:Proc else Q:Proc => #if B #then P #else Q   #fi  [anywhere, structural]

// Matching
  // "matches" binop desugars into "match" statement
  rule P:Proc matches Q:Proc => match P { Q :=> true P :=> false }  [anywhere, structural]
  
  rule match P:Proc { Q:Proc :=> R:Proc } => #if P ==K Q #then R #else Nil #fi
  rule match P:Proc { Q:Proc :=> R:Proc M:MatchCase  } => #if P ==K Q #then R #else match P { M } #fi
  rule match P:Proc { Q:Proc :=> R:Proc M:MatchCases } => #if P ==K Q #then R #else match P { M } #fi

// New Operator Semantics - like blocks with local variables in an imperative language
// nested variable declarations shadow each other
  rule new N:Name           in { P:Proc } => P[ unforgeable(!I:Int) / N ]
  rule new M:Name , N:Name  in { P:Proc } => new N in { P[ unforgeable(!I:Int) / M ] }
  rule new M:Name , N:Names in { P:Proc } => new N in { P[ unforgeable(!I:Int) / M ] }

// Syntactic sugar - quoted tuple listens desugar into regular listen
// included here (instead of in sytax module) because #quotes is defined in AUXFUN
/*rule for( @ ( A:Proc  ,) <- X:Name ){ P:Proc } => for( @A <- X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ,) <= X:Name ){ P:Proc } => for( @A <= X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ,) <! X:Name ){ P:Proc } => for( @A <! X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ,) << X:Name ){ P:Proc } => for( @A << X ){ P }  [anywhere, structural]
  rule for( @ ( A:Procs ,) <- X:Name ){ P:Proc } => for( #quotes(A) <- X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ,) <= X:Name ){ P:Proc } => for( #quotes(A) <= X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ,) <! X:Name ){ P:Proc } => for( #quotes(A) <! X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ,) << X:Name ){ P:Proc } => for( #quotes(A) << X ){ P } [anywhere, structural]
*/
// Syntactic sugar - contract desugars into unconsumable receive
  rule contract X:Name ( Y:NameList ) = { P:Proc } => for ( Y <= X ){ P }  [anywhere, structural]
  rule contract X:Name (  ) = { P:Proc }           => for (   <= X ){ P }  [anywhere, structural]

// Par Operator Semantics - concurrent execution of processes
  rule <thread>
         <k> P:Proc | Q:Proc => . ...</k>
         <env>       B:Map       </env>
       </thread>
       (.Bag => <thread> <k> P </k> <env> B </env> </thread>)
       (.Bag => <thread> <k> Q </k> <env> B </env> </thread>)  [unravel]

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
// TODO: handle variable reference/assignment before sending to tuplespace
  rule <thread>
         <k> S:Send => . ...</k>                                     // dissolve send in <threads/> and spawn <send/>
         <env>  B:Map  </env>                                        // 
       </thread>                                                     // 
       (.Bag => <send>                                               //
                  <schan>        #chan(S)  </schan>                  // sending channel
                  <msg>           #msg(S)    </msg>                  // sending message(s)
                  <tuple> #length(#msg(S)) </tuple>                  // number of messages
                  <stype>       #stype(S)  </stype>                  // send type
                  <sbind>              B   </sbind>                  // 
                </send>)                                             //

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
//TODO: sequential listen
  rule <thread>
         <k> R:SingleRec => . ...</k>                                // dissolve Rec in <threads/> and spawn <rec/>
         <env>  B:Map  </env>                                        // 
       </thread>                                                     // 
       (.Bag => <rec>                                                // 
                  <rchan>  #chan(R) </rchan>                         // receiving channel
                  <bvars>  #bvar(R) </bvars>                         // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>                         // 
                  <rtype> #rtype(R) </rtype>                         // receive type
                  <cont>   #cont(R)  </cont>                         // continuation
                  <rbind>        B  </rbind>                         // 
                </rec>)                                              //

// Joins
  rule <thread>
         <k> R:MultiRec => . ...</k>                                 //
         <env>  B:Map  </env>                                        // 
       </thread>                                                     // 
       (.Bag => <rec>                                                // 
                  <rchan>  #chan(R) </rchan>                         // receiving channel
                  <bvars>  #bvar(R) </bvars>                         // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>                         // number of variables to bind
                  <rtype> #rtype(R) </rtype>                         // receive type
                  <cont>   #cont(R)  </cont>                         // continuation
                  <rbind>        B  </rbind>                         // 
                </rec>)                                              //

//-------------------
//--- COMM EVENTS ---
//-------------------
// x!(Q) | y(z){P} /\ x equivN y => P[@Q / y]

// Reaction Cell Semantics - quarantined reaction cell for processing comm events
// N substitutions, N > 2
  rule 
    <reaction>
      <who>    P:Proc => P[@ Q / Y]      </who>  // instead of directly substituting, update bindings(?)
      <what>   Q:Proc , R:Procs => R    </what>
      <where>  Y:Name , Z:Names => Z   </where>
      <update> B:Map  => B[ Y <- @Q ] </update>
    </reaction>                                      [react]

// 2 substitutions
  rule
    <reaction>
      <who>    P:Proc => P[@ Q / Y]      </who>  // instead of directly substituting, update bindings(?)
      <what>   Q:Proc , R:Proc => R     </what>
      <where>  Y:Name , Z:Name => Z    </where>
      <update> B:Map  => B[ Y <- @Q ] </update>
    </reaction>                                      [react]

// Final substitution spawn in a new thread holding the fully substituted continuation
  rule
    <reaction>
      <who>    P:Proc =>  .K     </who>
      <what>   Q:Proc =>  .K    </what>
      <where>  Y:Name =>  .K   </where>
      <update> B:Map  => .Map </update>
    </reaction>
   (.Bag => <thread> <k> P[@ Q / Y] </k> <env> B[ Y <- @Q ] </env> </thread>)  [react]  // instead of directly substituting, update bindings(?)

// Comm semantics
// Linear listen, linear send
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of names to bind
     <rtype> 0       </rtype>                                          // linear listen
     <cont>  P:Proc   </cont>                                          // continuation P
     <rbind> A:Map   </rbind>                                          // 
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Proc    </msg>                                          // message(s) Q
     <tuple> N       </tuple>                                          // number of messages matches number of names to bind
     <stype> 0       </stype>                                          // linear send
     <sbind> B:Map   </sbind>                                          // 
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>      .K => P      </who>                                    // 
     <what>     .K => Q     </what>                                    // 
     <where>    .K => Y    </where>                                    // 
     <update> .Map => A B </update>                                    // 
   </reaction>                                                  [comm] //spawn single <thread/> holding fully substituted continuation

  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of names to bind
     <rtype> 0       </rtype>                                          // linear listen
     <cont>  P:Proc   </cont>                                          // continuation P
     <rbind> A:Map   </rbind>                                          // 
   </rec> => .Bag)                                                     //
  (<send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Procs   </msg>                                          // message(s) Q
     <tuple> N       </tuple>                                          // number of messages matches number of names to bind
     <stype> 0       </stype>                                          // linear send
     <sbind> B:Map   </sbind>                                          // 
   </send> => .Bag)                                                    //
   <reaction>                                                          // 
     <who>   .K => P   </who>                                          // 
     <what>  .K => Q  </what>                                          // 
     <where> .K => Y </where>                                          // 
     <update> .Map => A B </update>                                    // 
   </reaction>                                                  [comm] //spawn single <thread/> holding fully substituted continuation

// Persistent listen, linear send
  rule                                                                 //consume single send, keep persistent receive
   <rec>                                                               //DON'T consume persistent receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 1       </rtype>                                          // repeated listen
     <cont>  P:Proc   </cont>                                          // continuation P
     <rbind> A:Map   </rbind>                                          // 
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Proc    </msg>                                          // message(s) Q
     <tuple> N       </tuple>                                          // number of messages matches number of names to bind
     <stype> 0       </stype>                                          // linear send
     <sbind> B:Map   </sbind>                                          // 
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
     <update> .Map => A B </update>                                    // 
   </reaction>                                                  [comm] // 

  rule                                                                 //consume single send, keep persistent receive
   <rec>                                                               //DON'T consume persistent receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 1       </rtype>                                          // repeated listen
     <cont>  P:Proc   </cont>                                          // continuation P
     <rbind> A:Map   </rbind>                                          // 
   </rec>                                                              //
  (<send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Procs   </msg>                                          // message(s) Q
     <tuple> N       </tuple>                                          // number of messages matches number of names to bind
     <stype> 0       </stype>                                          // linear send
     <sbind> B:Map   </sbind>                                          // 
   </send> => .Bag)                                                    //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
     <update> .Map => A B </update>                                    // 
   </reaction>                                                  [comm] //

// Linear listen, persistent send
  rule                                                                 //consume single receive and keep single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 0       </rtype>                                          // linear listen
     <cont>  P:Proc   </cont>                                          // continuation
     <rbind> A:Map   </rbind>                                          // 
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Proc    </msg>                                          // message(s) Q
     <tuple> N       </tuple>                                          // number of messages matches number of names to bind
     <stype> 1       </stype>                                          // persistent send
     <sbind> B:Map   </sbind>                                          // 
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
     <update> .Map => A B </update>                                    // 
   </reaction>                                                  [comm] // 

  rule                                                                 //consume single receive and keep single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 0       </rtype>                                          // linear listen
     <cont>  P:Proc   </cont>                                          // continuation
     <rbind> A:Map   </rbind>                                          // 
   </rec> => .Bag)                                                     //
   <send>                                                              //DON'T consume persistent send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Procs   </msg>                                          // message(s) Q
     <tuple> N       </tuple>                                          // number of messages matches number of names to bind
     <stype> 1       </stype>                                          // persistent send
     <sbind> B:Map   </sbind>                                          // 
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
     <update> .Map => A B </update>                                    // 
   </reaction>                                                  [comm] // 

// Peek semantics
  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Name  </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 2       </rtype>                                          // peek
     <cont>  P:Proc   </cont>                                          // continuation P
     <rbind> A:Map   </rbind>                                          // 
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Proc    </msg>                                          // message(s) Q
     <tuple> N       </tuple>                                          // number of messages matches number of names to bind
     <stype> _       </stype>                                          // any kind of send
     <sbind> B:Map   </sbind>                                          // 
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
     <update> .Map => A B </update>                                    // 
   </reaction>                                                  [comm] // 

  rule                                                                 //consume single send, single receive
  (<rec>                                                               //consume single receive
     <rchan> X:Name  </rchan>                                          // channel X
     <bvars> Y:Names </bvars>                                          // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                          // number of name(s) to bind
     <rtype> 2       </rtype>                                          // peek
     <cont>  P:Proc   </cont>                                          // continuation P
     <rbind> A:Map   </rbind>                                          // 
   </rec> => .Bag)                                                     //
   <send>                                                              //consume single send
     <schan> X       </schan>                                          // channel X
     <msg>   Q:Procs   </msg>                                          // message(s) Q
     <tuple> N       </tuple>                                          // number of messages matches number of names to bind
     <stype> _       </stype>                                          // any kind of send
     <sbind> B:Map   </sbind>                                          // 
   </send>                                                             //
   <reaction>                                                          //
     <who>   .K => P   </who>                                          //
     <what>  .K => Q  </what>                                          //
     <where> .K => Y </where>                                          //
     <update> .Map => A B </update>                                    // 
   </reaction>                                                  [comm] // 

// Join semantics seem to be much more complicated...
// moved progress to join.k

// Methods
  // add

  // confine

  // contains (maps & sets)
  rule M:Map .contains( Key:Proc ) => Key in_keys(M)
  rule S:Set .contains( Elm:Proc ) => Elm in S
  
  // delete (maps & sets)
  rule M:Map .delete( Key:Proc ) => M[ Key <- undef ]
  rule S:Set .delete( Elm:Proc ) => S -Set SetItem(Elm)

  // diff (maps & sets)
  rule M1:Map .diff( M2:Map ) => removeAll( M1 , keys(M2) )
  rule S1:Set .diff( S2:Set ) => S1 -Set S2
  
  // get (maps)
  rule M:Map .get( Key:Proc ) => #if ( Key in_keys(M) ) #then M[Key] #else Nil #fi

  //getOrElse (maps)
  rule M:Map .getOrElse( Key:Proc , Else:Proc ) => #if ( Key in_keys(M) ) #then M[Key] #else Else #fi

  // hexToBtyes

  // iterate

  // legnth (list & tuple)
  rule L:RhoList  .length( ) => #length L
  rule T:RhoTuple .length( ) => #length T

  // mapkeys (maps)
  rule M:Map .keys( ) => keys( M )
  
  // nth (lists & tuples)
  rule [ ] .nth( _ ) => Nil
  rule [ A:Proc ] .nth( I:Int ) => #if I ==Int 0 #then A #else Nil #fi
  rule [ A:Proc , B:Proc  ].nth( I:Int ) => #if I ==Int 0 #then A #else [ B ].nth( I -Int 1 ) #fi
  rule [ A:Proc , B:Procs ].nth( I:Int ) => #if I ==Int 0 #then A #else [ B ].nth( I -Int 1 ) #fi

  rule ( ,) .nth( _ ) => Nil
  rule ( P:Proc ,).nth( I:Int ) => #if I ==Int 0 #then P #else Nil #fi
  rule ( P:Proc , Q:Proc  ,).nth( I:Int ) => #if I ==Int 0 #then P #else ( Q ,).nth( I -Int 1 ) #fi
  rule ( P:Proc , Q:Procs ,).nth( I:Int ) => #if I ==Int 0 #then P #else ( Q ,).nth( I -Int 1 ) #fi
  
  // set (maps)
  rule M:Map .set( Key:Proc , Val:Proc ) => updateMap( M , Key |-> Val)
  
  // size (maps & sets)
  rule M:Map .size( ) => size(M)
  rule S:Set .size( ) => size(S)

  // slice (lists & strings)
  rule S:String  .slice( A:Int , B:Int ) => substrString( S , A , B )
  rule L:RhoList .slice( A:Int , B:Int ) => #slice( L , A , B )

  // toByteArray

  // union (maps & sets)
  rule M1:Map .union( M2:Map ) => M1 M2
  rule S1:Set .union( S2:Set ) => S1 S2

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P  [anywhere, structural]
  rule P:Proc | Nil    => P  [anywhere, structural]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> <env> .Map </env> </thread> => .Bag  [structural] //empty threads
  rule <thread> <k> Nil </k> <env> .Map </env> </thread> => .Bag  [structural] //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

  rule #isProc( A:K ) => isProc(A)
  rule #isName( A:K ) => isName(A)

endmodule