// RHO CALCULUS with contexts and locations

require "domains.k"
require "substitution.k"

// SYNTAX MODULE
module STRHO-SYNTAX
  import DOMAINS
  import SUBSTITUTION

//-------------
//--- NAMES ---
//-------------
  syntax             Name ::= Chan                                          // 
                            | NameVar                                       // 

  syntax             Chan ::= "@" "<" Context "," Proc ">"                  //  

  syntax          NameVar ::= Id                                            // 

//-----------------
//--- PROCESSES ---
//-----------------  
  syntax           Ground ::= Bool | Int | String
  
  syntax             Proc ::= "{" Proc "}"                               [bracket]
                            > "Nil"
	        | Ground
                            | "U(" Name ")"
                            | Receive
	        | Send
	        | Eval
	        | "COMM(" Context ")"
	        > Proc "|" Proc                              [assoc, comm]

  syntax             Proc ::= Context "[" Proc "]"
                            | "#sub(" Proc ";" Name "/" Name ")"         [function]
  
  syntax          Receive ::= InputGuard "{" Proc "}"
  
  syntax       InputGuard ::= "for" "(" Name ListenType Name ")"
  
  syntax       ListenType ::= "<-" //| "<=" | "<!"
  
  syntax             Send ::= Name SendType "(" Proc ")"
  
  syntax         SendType ::= "!" //| "!!"
  
  syntax             Eval ::= "*" Name

//----------------
//--- CONTEXTS ---
//----------------
  syntax      Placeholder ::= "[]"

  syntax          Context ::= Placeholder
                            | InputGuard "{" Context "}"
	        | Name SendType "(" Context ")"
	        > Proc "|" Context                           [assoc, comm]

  syntax        KVariable ::= Name | Placeholder

endmodule

// SEMANTICS MODULE
module STRHO
  import STRHO-SYNTAX

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                               //
      <threads color="red">                                          //**activity threads**
        <thread color="green" multiplicity="*">                      // collection of threads (concurrent activity)
          <k>   $PGM:Proc  </k>                                      // programs and computations are process-based
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
            <rtype>  .K  </rtype>                                    // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
            <cont>   .K   </cont>                                    // continuation
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <catalysts>                                                    // 
        <context color="teal" multiplicity="*"> .K </context>        // 
      </catalysts>                                                   // 
      <locations>                                                    // 
        <location color="orange" multiplicity="*"> .K </location>    // 
      </locations>                                                   // 
// Needed once we can send lists of processes
      <reaction>                                                     //**where the magic happens**
        <who>   .K   </who>                                          // continuation process
        <what>  .K  </what>                                          // msg process(es)
        <where> .K </where>                                          // binding variable(s)
        <how>   .K   </how>                                          // substitution context
      </reaction>                                                    // all comms are processed here
    </T>

  syntax KResult ::= Ground | Eval
  
// Par Operator Semantics
  rule <thread>
         <k> P:Proc | Q:Proc => . ... </k>                           // 
       </thread>                                                     // 
       (.Bag => <thread> <k> P </k> </thread>)                       // 
       (.Bag => <thread> <k> Q </k> </thread>)                       // 

// COMM Catalyst
  rule (<thread> <k> COMM(C:Context) </k> </thread> => .Bag)         // 
       (.Bag => <context> C </context>)                              // 

// Location Update
  rule (<thread> <k> U( X:Name ) </k> </thread> => .Bag)             // 
       (.Bag => <location> X </location>)                            // 
       
  rule <thread>
         <k> * @ < C:Context , P:Proc > => . ...</k>
       </thread>
       <locations>...
        (<location> X:Name </location> => .Bag)
       </locations>
      (.Bag => <thread> <k> COMM(C) | X!(P) </k> </thread>)  [update]
  
// U( X:Name ) | * @ < C:Context , P:Proc > => COMM(C) | X!(P)  

// Send Operator Semantics
  rule <thread>
         <k> X:Name ! ( P:Proc ) => . ...</k>                        // dissolve send in <threads/> and spawn <send/>
       </thread>                                                     // 
       (.Bag => <send>                                               //
                  <schan>  X  </schan>                               // sending channel
                  <msg>    P    </msg>                               // sending message(s)
                  <tuple>  1  </tuple>                               // number of messages
                  <stype>  0  </stype>                               // send type
                </send>)                                             //

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
//TODO: sequential listen
  rule <thread>
         <k> for( Y:Name <- X:Name ){ P:Proc } => . ...</k>          // dissolve Rec in <threads/> and spawn <rec/>
       </thread>                                                     // 
       (.Bag => <rec>                                                // 
                  <rchan>  X  </rchan>                               // receiving channel
                  <bvars>  Y  </bvars>                               // variable(s) to be substituted in continuation
                  <bnum>   1   </bnum>                               // 
                  <rtype>  0  </rtype>                               // receive type
                  <cont>   P   </cont>                               // continuation
                </rec>)                                              //

// Comm semantics
// X!(Q) | for( Y <- X ){ P } | COMM( C ) => P[ @<C,Q> / Y ]
// Linear listen, linear send
  rule                                                               //consume single send, single receive
  (<rec>                                                             //consume single receive
     <rchan> X:Name  </rchan>                                        // channel X
     <bvars> Y:Name  </bvars>                                        // binding variable(s) Y
     <bnum>  N:Int    </bnum>                                        // number of names to bind
     <rtype> 0       </rtype>                                        // linear listen
     <cont>  P:Proc   </cont>                                        // continuation P
   </rec> => .Bag)                                                   //
  (<send>                                                            //consume single send
     <schan> X       </schan>                                        // channel X
     <msg>   Q:Proc    </msg>                                        // message(s) Q
     <tuple> N       </tuple>                                        // number of messages matches number of names to bind
     <stype> 0       </stype>                                        // linear send
   </send> => .Bag)                                                  //
   <catalysts>...                                                    // 
     (<context> C:Context </context> => .Bag)                        // 
   </catalysts>                                                      // 
  (.Bag => <thread>                                                  // 
             <k> #sub( P ; @ <C,Q> / Y ) </k>                        // 
           </thread>)                                         [comm] //spawn single <thread/> holding fully substituted continuation

// Semantic Substituion
  rule #sub( (* X):Eval ; @ < C:Context , P:Proc > / X ) => C[P]
  rule #sub( P:Proc ; A:Name / B:Name ) => P[A/B] requires #sort(P) =/=String "Eval" orBool #sort(A) =/=String "Chan"

  rule C:Context [ P:Proc ] => C[ P / [] ]        [anywhere, structural]
  
  rule <thread> <k> .K  </k> </thread> => .Bag    [structural]
  rule <thread> <k> Nil </k> </thread> => .Bag    [structural]

endmodule