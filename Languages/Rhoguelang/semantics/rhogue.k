require "../syntax/rhoguesyntax.k"

module RHOGUE-SYNTAX
import RHOGUESYNTAX-SYNTAX
import SUBSTITUTION

endmodule

//........................
//... SEMANTICS MODULE ...
//........................
module RHOGUE
import RHOGUE-SYNTAX

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
            </receive>                                        // end receive
          </receives>                                         // end receives
          <rper color="purple"> .K </rper>                    // persistent (y/n?) (y=1 / n=0)
          <cont color="red">    .K </cont>                    //<cont> contains the continuation
        </rpackage>                                           // end rpackage
      </rpackages>                                            // end rpackages
      <spackages>                                             //<spackages> conatains zero or more <spackage> cells
        <spacakge color="teal" multiplicity="*">              //<spackage> contains one <sends> cell
          <sends color="green">                               //<sends> contains zero or more <send> cells
            <send color="teal" multiplicity="*">              //<send> contains cells <schan>, <msgs>, & <spers>
              <schan color="cyan"> .K  </schan>               // send channel(s)
              <msg color="cyan">   .K    </msg>               // message(s) being sent
            </send>                                           // end send
            <sper color="cyan">  .K   </sper>                 // persistent?
          </sends>                                            // end sends
        </spackage>                                           // end spackage
      </spackages>                                            // end spackages
    </tuplespace>                                             // end tuplespace
  </T>                                                        // end configuration

//-----------------------------
//--- KResults & KVariables ---
//-----------------------------

syntax KVariable ::= Var | Name | ProcVar                     //variables for substitution

syntax   KResult ::= Bool | Int                               //strictness only for BExp & AExp

//.................
//... SEMANTICS ...
//.................

//---------------------------
//--- COMPUTATION THREADS ---
//---------------------------
rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>      //dissolve par
     (.Bag => <thread> <k> P </k> </thread>)                  //  spawn new thread containing only P
     (.Bag => <thread> <k> Q </k> </thread>)    [structural]  //  spawn new thread containing only Q

//-------------
//--- SENDS ---
//-------------

//--- Linear ---
// Single - Proc
rule <k> X:Name !( P:Proc ) => . ...</k>                      //dissolve send & spawn nonpersistent <spackage/>
  (.Bag => <send>                                             //
             <schan> X </schan>                               //  sending channel X
             <msg>  @P   </msg>                               //  message sent @P
           </send>)
  (.Bag => <sper>    0  </sper>)                [structural]  //  not persistent

// Multiple - RhoTuple
rule X:Name !( P:Proc ,) => X !( P )                 [macro]  //syntactic sugar for monadic single send

rule <k> X:Name !( P:Proc , Q:Procs ) => X !( Q ) ...</k>     //dissolve send & spawn nonpersistent <spackage/>
  (.Bag => <send>                                             //
             <schan> X </schan>                               //  sending channel X
             <msg>  @P   </msg>                               //  messages sent @[P,Q]
           </send>)                             [structural]

//--- Persistent ---
// Single - Proc
rule <k> X:Name !!( P:Proc ) => . ...</k>                     //dissolve send & spawn persistent <spackage/>
  (.Bag => <send>                                             //
             <schan>  X  </schan>                             //  sending channel X
             <msg>   @P    </msg>                             //  message sent @P
             <sper>   1   </sper>                             //  persistent
           </send>)                             [structural]

// Multiple - RhoTuple
rule X:Name !!( P:Proc ,) => X !!( P )               [macro]  //syntactic sugar for monadic persistent send

rule <k> X:Name !!( P:Proc , Q:Procs ) => X !!( Q ) ...</k>   //dissolve send & spawn persistent <spackage/>
  (.Bag => <send>                                             //
             <schan> X  </schan>                              //  sending channel X
             <msg>  @P    </msg>                              //  message sent @P
           </send>)                             [structural]

//-----------------
//--- RPACKAGES ---
//-----------------

//--- Linear ---
// Single
rule <k> for ( Y:NamePats <- X:Name ){ P:Proc } => . ...</k>
  (.Bag => <receive>                                          //  receive:
             <rchan>  X   </rchan>                            //    receiving channel(s) X
             <bvar>   Y    </bvar>                            //    variable(s) Y binding in continuation
           </receive>)                                        //
  (.Bag => <rper>     0    </rper>)                           //    not persistent (only consumed once)
  (.Bag => <cont>     P    </cont>)             [structural]  //  continuation P

// Multiple
rule <k> for ( Y:NamePats <- X:Name ; LinearBinds ){ P:Proc } => for ( LinearBinds ){ P:Proc } ...</k>
  (.Bag => <receive>                                          //  receive:
             <rchan>  X   </rchan>                            //    receiving channel(s) X
             <bvar>   Y    </bvar>                            //    variable(s) Y binding in continuation
           </receive>)                          [structural]

//--- Persistent ---
// Single
rule <k> for ( Y:NamePats <= X:Name ){ P:Proc } => . ...</k>
  (.Bag => <receive>                                          //  receive:
             <rchan>  X  </rchan>                             //    receiving channel(s) X
             <bvar>   Y   </bvar>                             //    variable(s) Y binding in continuation  
           </receive>)                                        //
  (.Bag => <rper>     1   </rper>)                            //    persistent (consumed many times)
  (.Bag => <cont>     P   </cont>)              [structural]  //  continuation P

// Multiple - single <receives> cell contains each <receive> and <rper> & <cont>
rule <k> for ( Y:NamePat <= X:Name ; RepeatedBinds ){ P:Proc } => for ( RepeatedBinds ){ P:Proc } ...</k>
  (.Bag => <receive>                                          //  receive:
             <rchan>  X  </rchan>                             //    receiving channel(s) X
             <bvar>   Y   </bvar>                             //    variable(s) Y binding in continuation
           </receive>)                          [structural]

//-----------
//--- NEW ---
//-----------
rule new X:NameDeclare in { P:Proc }
  => P[unforgeable( !I:Int ) / X] }                  [macro]  //single unforgeable name declaration

rule X:NameDeclare , N:NameDeclares in { P:Proc }             //unforgeable name declarations
  => new N in { new X in {P} }                  [structural]  //recursive substitution

//.......................
//... REDUCTION RULES ...
//.......................

//------------------
//--- COMM EVENT ---
//------------------

//--- Linear ---
// Single comm
rule                                                          //consume both rpackage and send
  (<rpackage>                                                 //
     <receive>                                                //  consume rpackage:
       <rchan> X:Name    </rchan>                             //    channel X
       <bvar>  Y:NamePat  </bvar>                             //    binding variable(s) Y
       <rper>     0       </rper>                             //    not persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //    continuation P
   </rpackage> => .Bag)                                       //
  (<send>                                                     //  consume send:
     <schan>     X    </schan>                                //    channel X
     <msg>   Z:NameVar  </msg>                                //    message(s) Z
     <sper>    0    </sper>                                   //    not persistent
   </send> => .Bag)                                           //
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn thread for substituted cont P[Z / Y]
  [comm]

// Multiple
rule                                                          //consume both rpackage and send
  (<rpackage>                                                 //
     <receive>                                                //  consume rpackage:
       <rchan> X:Name </rchan>                                //    channel(s) X
       <bvar>  Y:Name  </bvar>                                //    binding variable(s) Y
       <rper>    0     </rper>                                //    not persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //    continuation P
   </rpackage> => .Bag)                                       //
  (<send>                                                     //  consume send:
     <schan>   X   </schan>                                   //    channel X
     <msg>   Z:Name  </msg>                                   //    message(s) Z
     <sper>    0    </sper>                                   //    not persistent
   </send> => .Bag)                                           //
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
  (<send>                                                     //
     <schan>   X   </schan>                                   //  channel X
     <msg>   Z:Name  </msg>                                   //  message(s) Z
     <sper>    0    </sper>                                   //  not persistent
   </send> => .Bag)                                           //  
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn <thread/> holding substitution P[Z / Y]
  [comm]

//--- Persistent send ---
rule                                                          //persistent sends (send persists)
  (<rpackage>                                                 //
     <receive>                                                //consume rpackage:
       <rchan> X:Name </rchan>                                //  channel(s) X
       <bvar>  Y:Name  </bvar>                                //  binding variable(s) Y
       <rper>    0     </rper>                                //  not persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //  continuation P
   </rpackage> => .Bag)                                       //
   <send>                                                     //
     <schan>   X   </schan>                                   //  channel X
     <msg>   Z:Name  </msg>                                   //  message(s) Z
     <sper>    1    </sper>                                   //  persistent
   </send>                                                    //
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn <thread/> holding substitution P[Z / Y]
  [comm]

//**NEVER DO PERSISTENT RECEIVE AND PERSISTENT SEND ON SAME CHANNEL!
rule contract X:Name ( Y:NamePat ) { P:Proc } => for ( Y <= X ){ P }                  [macro]

//rule contract X:Name , N:Name ( Y:NamePat , Pt:NamePat ) { P:Proc }
//  => for ( Y <= X ; Pt <= N)                                                        [macro] 

rule <cont> contract X:Names ( Y:NamePats ) { P:Proc } => for ( Y <- X ){ P } </cont>     [macro]

//------------
//--- Peek ---
//------------

// Single
rule <k> for ( Y:NamePats <! X:Name ){ P:Proc } => P[Z / Y] ...</k>
      <send>
        <schan>    X   </schan>                               //peek at Y on channel X
        <msg>   Z:Names  </msg>
      </send>

//---------------
//--- METHODS ---
//---------------


//------------------------------
//--- ARITHMETIC EXPRESSIONS ---
//------------------------------


//---------------------------
//--- BOOLEAN EXPRESSIONS ---
//---------------------------


//--------------------
//--- CONDITIONALS ---
//--------------------
rule if ( true ) P:Proc => P

rule if ( true  ) P:Proc else _ => P
rule if ( false ) _ else P:Proc => P

//-------------
//--- MATCH ---
//-------------

// Single match case
rule match P:ProcVar { Pat1:ProcPat => P1:Proc }
  => if ( type(P) isIn type(ProcPat) ) { P1[P / Pat1] }                         [macro]  //syntactic sugar

// Multiple match cases
rule match P:ProcVar { Pat1:ProcPat => P1:Proc M:MatchCases }
  => if ( type(P) isIn type(ProcPat) ) { P1[P / Pat1] } else match P { M }      [macro]  //syntactic sugar

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
//for( NamePat_1 <- Name_1 ; ... ; NamePat_N <- Name_N ){ Body }
//or
//for( NamePat_1 <= Name_1 ; ... ; NamePat_N <= Name_N ){ Body }
//Matches against a Proc_i in:
//Name_1!(Proc_1) | ... | Name_N!(Proc_N)
//or
//Name_1!!(Proc_1) | ... | Name_N!!(Proc_N)
//
//
//Tries to match Proc against each ProcPat_i until it finds a match (or doesn’t):
//match Proc { ProcPat_1 => { Proc_1 } ... ProcPat_N => { Proc_N } }

endmodule
