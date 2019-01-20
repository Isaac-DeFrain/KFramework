//........................
//... SEMANTICS MODULE ...
//........................

require "../syntax/rhoguesyntax.k"

module RHOGUE
import RHOGUE-SYNTAX
import SUBSTITUTION

//---------------------
//--- CONFIGURATION ---
//---------------------

configuration
  <T>                                                         //<top> contains cells <processpool> & <tuplespace>
    <threadpool color="red">                                  //<threadpool> conatains zero or more <thread> cells
      <thread color="red" multiplicity="*">                   //<thread> contains one <k> cell
        <k>                                                   // concurrent compututaional threads
          $PGM:Proc                                           // programs and computations are both processes
        </k>                                                  // end k
      </thread>                                               // end thread
    </threadpool>                                             // end threadpool
    <tuplespace color="blue">                                 //<tuplespace> contains cells <rpackages> & <spackages>
      <rpackages color="orange">                              //<rpackages> contains zero or more <rpackage> cells
        <rpackage color="orange" multiplicity="*">            //<rpackage> contains cells <receives> & <cont>
          <receives color="purple">                           //<receives> contains zero or more <receive> cells
            <receive color="purple" multiplicity="*">         //<receive> contains cells <rchan>, <bvars>, & <rpers>
              <rchan color="purple"> .K </rchan>              // receive channel(s)
              <bvar color="purple">  .K  </bvar>              // binding variable(s) in continuation
              <rper color="purple">  .K  </rper>              // persistent (y/n?) (y=1 / n=0)
            </receive>                                        // end receive
          </receives>                                         // end receives
          <cont color="red"> .K </cont>                       //<cont> contains the continuation
        </rpackage>                                           // end rpackage
      </rpackages>                                            // end rpackages
      <spackages color="green">                               //<spackages> contains zero or more <spackage> cells
        <spackage color="teal" multiplicity="*">              //<spackage> contains one <sends> cell
          <sends color="cyan">                                //<sends> contains zero or more <send> cells
            <send color="cyan" multiplicity="*">              //<send> contains cells <schan>, <msgs>, & <spers>
              <schan color="cyan"> .K  </schan>               // send channel(s)
              <msg color="cyan">   .K    </msg>               // message(s) being sent
              <sper color="cyan">  .K   </sper>               // persistent (y/n?)
            </send>                                           // end send
          </sends>                                            // end sends
        </spackage>                                           // end spackage
      </spackages>                                            // end spackages
    </tuplespace>                                             // end tuplespace
  </T>                                                        // end configuration

//-----------------------------
//--- KResults & KVariables ---
//-----------------------------

syntax KVariable ::= Var | NameVar | ProcVar                  //variables for substitution

syntax   KResult ::= Bool | Int                               //strictness only for BExp & AExp

//.................
//... SEMANTICS ...
//.................

//-----------
//--- PAR ---
//-----------
rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>    //dissolve par in <thread/>
     (.Bag => <thread> <k> P1 </k> </thread>)                 //  spawn two new <thread/>s
     (.Bag => <thread> <k> P2 </k> </thread>)  [structural]

//-------------
//--- SENDS ---
//-------------

//--- Linear ---
// Single - Proc
rule <k> X:Name !( P:Proc ) => . ...</k>                      //dissolve send & spawn nonpersistent <spackage/>
  (.Bag => <send>                                             //
             <schan>  X  </schan>                             //  sending channel X
             <msg>   @P    </msg>                             //  message sent @P
             <sper>   0   </sper>                             //  not persistent
           </send>)                            [structural]

// Multiple - RhoTuple
rule <k> X:Name !( P:Proc ,) => . ...</k>                     //dissolve send & spawn nonpersistent <spackage/>
  (.Bag => <send>                                             //
             <schan>  X  </schan>                             //  sending channel X
             <msg>   @P    </msg>                             //  message sent @P
             <sper>   0   </sper>                             //  not persistent
           </send>)                            [structural]

rule <k> X:Name !( P:Proc , Q:Procs ) => X !( Q ) ...</k>     //dissolve send & spawn nonpersistent <spackage/>
  (.Bag => <send>                                             //
             <schan>  X  </schan>                             //  sending channel X
             <msg>   @P    </msg>                             //  messages sent @[P,Q]
             <sper>   0   </sper>                             //  not persistent
           </send>)                            [structural]

//--- Persistent ---
// Single - Proc
rule <k> X:Name !!( P:Proc ) => . ...</k>                     //dissolve send & spawn persistent <spackage/>
  (.Bag => <send>                                             //
             <schan>  X  </schan>                             //  sending channel X
             <msg>   @P    </msg>                             //  message sent @P
             <sper>   1   </sper>                             //  persistent
           </send>)                            [structural]

// Multiple - RhoTuple
rule <k> X:Name !!( P:Proc ,) => . ...</k>                    //dissolve send & spawn persistent <spackage/>
  (.Bag => <send>                                             //
             <schan>  X  </schan>                             //  sending channel X
             <msg>   @P    </msg>                             //  message sent @P
             <sper>   1   </sper>                             //  persistent
           </send>)                            [structural]

rule <k> X:Name !!( P:Proc , Q:Procs ) => X !!( Q ) ...</k>   //dissolve send & spawn persistent <spackage/>
  (.Bag => <send>                                             //
             <schan>  X  </schan>                             //  sending channel X
             <msg>   @P    </msg>                             //  message sent @P
             <sper>   1   </sper>                             //  persistent
           </send>)                            [structural]

//----------------
//--- RECEIVES ---
//----------------

//--- Linear ---
// Single
rule <k> for ( Y:NamePats <- X:Name ){ P:Proc } => . ...</k>
  (.Bag => <rpackage>                                         //spawn linear rpackage:
             <receive>                                        //  receive:
               <rchan>  X   </rchan>                          //    receiving channel(s) X
               <bvar>   Y    </bvar>                          //    variable(s) Y binding in continuation
               <rper>   0    </rper>                          //    not persistent (only consumed once)
             </receive>                                       //
             <cont>     P   </cont>                           //  continuation P
           </rpackage>)                        [structural]

// Multiple
rule <k> for ( Y:NamePats <- X:Name ; LinearBinds ){ P:Proc } => for ( LinearBinds ){ P:Proc } ...</k>
  (.Bag => <rpackage>                                         //spawn linear rpackage:
             <receive>                                        //  receive:
               <rchan>  X   </rchan>                          //    receiving channel(s) X
               <bvar>   Y    </bvar>                          //    variable(s) Y binding in continuation
               <rper>   0    </rper>                          //    not persistent (only consumed once)
             </receive>                                       //
             <cont>     P   </cont>                           //  continuation P
           </rpackage>)                        [structural]

//--- Persistent ---
// Single
rule <k> for ( Y:NamePats <= X:Name ){ P:Proc } => . ...</k>
  (.Bag => <rpackage>                                         //spawn persistent rpackage:
             <receive>                                        //  receive:
               <rchan>  X  </rchan>                           //    receiving channel(s) X
               <bvar>   Y   </bvar>                           //    variable(s) Y binding in continuation
               <rper>   1   </rper>                           //    persistent (consumed many times)
             </receive>                                       //
             <cont>     P   </cont>                           //  continuation P
           </rpackage>)                        [structural]

// Multiple
rule <k> for ( Y:NamePats <= X:Name ; LinearBinds ){ P:Proc } => for ( LinearBinds ){ P:Proc } ...</k>
  (.Bag => <rpackage>                                         //spawn persistent rpackage:
             <receive>                                        //  receive:
               <rchan>  X  </rchan>                           //    receiving channel(s) X
               <bvar>   Y   </bvar>                           //    variable(s) Y binding in continuation
               <rper>   1   </rper>                           //    persistent (consumed many times)
             </receive>                                       //
             <cont>     P   </cont>                           //  continuation P
           </rpackage>)                        [structural]

//Bool, Int, String operations

//.......................
//... REDUCTION RULES ...
//.......................

//------------------
//--- COMM EVENT ---
//------------------

//Comm: x!(Q) | x(y){P} => P[@Q / y]

//--- Linear ---
// Single
rule                                                          //consume both rpackage and spackage
  (<rpackage>                                                 //
     <receive>                                                //  consume rpackage:
       <rchan> X:Name </rchan>                                //    channel(s) X
       <bvar>  Y:Name  </bvar>                                //    binding variable(s) Y
       <rper>    0     </rper>                                //    not persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //    continuation P
   </rpackage> => .Bag)                                       //
  (<spackage>                                                 //
     <send>                                                   //  consume spackage:
       <schan> X     </schan>                                 //    channel(s) X
       <msg>   Z:Name  </msg>                                 //    message(s) Z
       <sper>    0    </sper>                                 //    not persistent
     </send>                                                  //
   </spackage> => .Bag)                                       //
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn thread for substituted cont P[Z / Y]
  [comm]                                                      //tagged "comm" for tracking nondeterminism

// Multiple
rule                                                          //consume both rpackage and spackage
  (<rpackage>                                                 //
     <receive>                                                //  consume rpackage:
       <rchan> X:Name </rchan>                                //    channel(s) X
       <bvar>  Y:Name  </bvar>                                //    binding variable(s) Y
       <rper>    0     </rper>                                //    not persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //    continuation P
   </rpackage> => .Bag)                                       //
  (<spackage>                                                 //
     <send>                                                   //  consume spackage:
       <schan> X     </schan>                                 //    channel(s) X
       <msg>   Z:Name  </msg>                                 //    message(s) Z
       <sper>    0    </sper>                                 //    not persistent
     </send>                                                  //
   </spackage> => .Bag)                                       //
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn thread for substituted cont P[Z / Y]
  [comm]                                                      //tagged "comm" for tracking nondeterminism

//--- Persistent receive ---
rule                                                          //persistent receives (rpackage persists)
   <rpackage>                                                 //
     <receive>                                                //rpackage persists:
       <rchan> X:Name </rchan>                                //  channel(s) X
       <bvar>  Y:Name  </bvar>                                //  binding variable(s) Y
       <rper>    1     </rper>                                //  persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //  continuation P
   </rpackage>                                                //
  (<spackage>                                                 //consume spackage:
     <send>                                                   //
       <schan>   X   </schan>                                 //  channel(s) X
       <msg>   Z:Name  </msg>                                 //  message(s) Z
       <sper>    0    </sper>                                 //  not persistent
     </send>                                                  //
   </spackage> => .Bag)                                       //  
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn <thread/> holding substitution P[Z / Y]
  [comm]

//--- Persistent send ---
rule                                                          //persistent sends (spackage persists)
  (<rpackage>                                                 //
     <receive>                                                //consume rpackage:
       <rchan> X:Name </rchan>                                //  channel(s) X
       <bvar>  Y:Name  </bvar>                                //  binding variable(s) Y
       <rper>    0     </rper>                                //  not persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //  continuation P
  </rpackage> => .Bag)                                        //
  <spackage>                                                  //spackage persists:
    <send>                                                    //
      <schan>   X   </schan>                                  //  channel(s) X
      <msg>   Z:Name  </msg>                                  //  message(s) Z
      <sper>    1    </sper>                                  //  persistent
    </send>                                                   //
  </spackage>                                                 //  
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn <thread/> holding substitution P[Z / Y]
  [comm]

//**NEVER DO PERSISTENT RECEIVE AND PERSISTENT SEND ON SAME CHANNEL!
rule contract Y:Name ( X:Name ) { P:Proc } => for ( Y <- X ){ P }                [structural]
rule <cont> contract Y:Name ( X:Name ) { P:Proc } => for ( Y <- X ){ P } </cont> [structural]

//--- Peek ---
rule <k> for ( Y:NamePats <! X:Name ){ P:Proc } => . ...</k>
      <send>                                                  //  receive:
        <schan> X </schan>                                    //
        ...
      </send>

rule <k> for ( Y:NamePats <! X:Name ; PeekBinds ){ P:Proc } => for ( PeekBinds ){ P:Proc } ...</k>
      <send>                                                  //  receive:
        <schan> X </schan>                                    //
        ...
      </send>

//Clean up parred expressions
//context     P:Proc | Nil    => P
//context        Nil | P:Proc => P
//rule        P:Proc | Nil    => P              [structural]  //Nils in <k/>
//rule           Nil | P:Proc => P              [structural]  //Nils in <k/>
//rule <cont> P:Proc | Nil    => P </cont>      [structural]  //Nils in <cont/>
//rule <cont>    Nil | P:Proc => P </cont>      [structural]  //Nils in <cont/>

//Dissolve computationally empty threads
rule <thread> <k>  .  </k> </thread> => .Bag    [structural]  //dissolve empty threads
rule <thread> <k> Nil </k> </thread> => .Bag    [structural]  //dissolve Nil threads

// * AND @ ARE INVERSE OPERATORS
//context       * @ []                                        //write as single context reduction?
//context       @ * []                                        //write as single context reduction?

rule  <msg>   @ * X:Name => X   </msg>          [structural]  //in message(s)
rule  <rchan> @ * X:Name => X </rchan>          [structural]  //in receiving channel(s)
rule  <schan> @ * X:Name => X </schan>          [structural]  //in sending channel(s)
                             
//rule          * @ P:Proc => P                 [structural]  //reduce *@s
//rule   <cont> * @ P:Proc => P </cont>         [structural]  // in <cont/>

//The patterns in:
//
//for( NamePat <- Name ){ Body }
//for( NamePat <= Name ){ Body }
//
//Match against the processes in:
//
//Name!(Process)
//Name!!(Process)
//
//
//Each NamePat_i in:
//
//for( NamePat_1 <- Name_1 ; ... ; NamePat_N <- Name_N ){ Body }
//for( NamePat_1 <= Name_1 ; ... ; NamePat_N <= Name_N ){ Body }
//
//Matches against a Process_i in:
//
//Name_1!(Process_1) | ... | Name_N!(Process_N)
//Name_1!!(Process_1) | ... | Name_N!!(Process_N)
//
//
//Tries to match Process against each Pattern_i until it finds a match (or doesn’t):
//match Process { Pattern_1 => { Body_1 } ... Pattern_N => { Body_N } }

endmodule
