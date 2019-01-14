// RHOGUELANG (a.k.a. RHO-CALC++)

//%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%% MODULE REQUIREMENTS %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%
require "substitution.k"

//:=::=::=::=::=::=::=:
//:=: SYNTAX MODULE :=:
//:=::=::=::=::=::=::=:
module RHOGUE-SYNTAX
  import ID
  import DOMAINS
  import SUBSTITUTION

//@@@@@@@@@@@@@@@@@@@@@@@@@
//@@@ NAME CONSTRUCTORS @@@
//@@@@@@@@@@@@@@@@@@@@@@@@@
  syntax   Quote ::= "@" Proc                                                   //Quote: Proc -------------> Name

  syntax NameVar ::= Id                                                         //   Id: Char -------------> Name
//                 | List{Id,","}                                               //name variables

  syntax    Name ::= Quote
                   | NameVar
                   | "{" Name "}"                                    [bracket]
                   | "(" Name ")"                                    [bracket]


//****************************
//*** PROCESS CONSTRUCTORS ***
//****************************
  syntax  Ground ::= "Nil"                                                       //Ground terms
//                 | Int     //not sure
//                 | String  //about this
//                 | Bool    //syntax

  syntax     Par ::= Proc  "|"  Proc                                     [left]  //  Par: Proc*Proc -------> Proc

  syntax     Rec ::= "for" "("  Name "<-" Name "){" Proc "}"        [binder(2)]  //  Rec: Name*Name*Proc --> Proc
                   | "for" "("  Name "<=" Name "){" Proc "}"        [binder(2)]  // pRec: Name*Name*Proc --> Proc

  syntax    Send ::= Name "!("  Proc ")"                                         // Send: Name*Proc -------> Proc
                   | Name "!!(" Proc ")"                                         //pSend: Name*Proc -------> Proc

  syntax   Reify ::= "*" Name                                                    //Reify: Name ------------> Proc

  syntax  Atomic ::= Rec
                   | Send

//syntax ProcVar ::= Id                                                          //   Id: Char ------------> Proc
//                 | List{Id,","}                                                //process variables

  syntax    Proc ::= Ground
                   | Atomic
                   | Par
                   | Reify
//                 | ProcVar
                   | "{" Proc "}"                                     [bracket]
                   | "(" Proc ")"                                     [bracket]


endmodule

//=>=>=>=>=>=>=>=>=>=>=>=>
//>=> SEMANTICS MODULE >=>
//=>=>=>=>=>=>=>=>=>=>=>=>

module RHOGUE
  import RHOGUE-SYNTAX
  import SUBSTITUTION

//><><><><><><><><><><>
//<>< CONFIGURATION ><>
//><><><><><><><><><><>

  configuration
    <T>                                                       //<top> : < <processpool> <tuplespace> >
      <processpool color="red">                               //<processpool> : < <thread*> >
        <thread color="red" multiplicity="*">                 //<thread> : < <k> >
          <k>                                                 // concurrent compututaional threads
            $PGM:Proc                                         // programs and computations are both processes
          </k>                                                // end k
        </thread>                                             // end thread
      </processpool>                                          // end processpool
      <tuplespace color="blue">                               //<tuplespace> : < <rpackages> <spackages> >
        <rpackages color="orange">                            //<rpackages> : < <rpackage*> >
          <rpackage color="orange" multiplicity="*">          //<rpackage> : < <receives> <cont> >
            <receives color="purple">                         //<receives> : < <receive*> >
              <receive color="purple" multiplicity="*">       //<receive> : < <rchan> <bvars> <rpers> >
                <rchan color="purple"> .K </rchan>            // receive channel(s)
                <bvar color="purple">  .K  </bvar>            // binding variable(s) in continuation
                <rper color="purple">  .K  </rper>            // persistent (y/n)
              </receive>                                      // end receive
            </receives>                                       // end receives
            <cont color="red"> .K </cont>                     //<cont> : < <k> >
          </rpackage>                                         // end rpackage
        </rpackages>                                          // end rpackages
        <spackages color="green">                             //<spackages> : < <spackage*> >
          <spackage color="teal" multiplicity="*">            //<spackage> : < <sends> >
            <sends color="cyan">                              //<sends> : < <send*> >
              <send color="cyan" multiplicity="*">            //<send> : < <schan> <msgs> <spers> >
                <schan color="cyan"> .K  </schan>             // send channel(s)
                <msg color="cyan">   .K    </msg>             // message(s) being sent
                <sper color="cyan">  .K   </sper>             // persistent (yes = Nil / no = @Nil)
              </send>                                         // end send
            </sends>                                          // end sends
          </spackage>                                         // end spackage
        </spackages>                                          // end spackages
      </tuplespace>                                           // end tuplespace
      <msgprocessed> .List </msgprocessed>                    // list of messages processed for testing
    </T>                                                      // end of configuration

  syntax KVariable ::= Name

//syntax KResult ::= Name | Atomic

//%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%% OPERATOR SEMANTICS %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%

// implement join as packet of sends/receives to a single continuation

//-----------
//--- PAR ---
//-----------

  rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>  //dissolve par in <thread/>
       (.Bag => <thread> <k> P1 </k> </thread>)               //  spawn two new <thread/>s
       (.Bag => <thread> <k> P2 </k> </thread>)  [structural] //or [macro]

//-------------
//--- SENDS ---
//-------------

//Linear send
  rule <k> X:Name !( P:Proc ) => . ...</k>                    //dissolve send in <thread/> and spawn <spackage/>
    (.Bag => <spackage>                                       //spawn spackage:
               <send>                                         //
                 <schan>  X   </schan>                        //  sending channel(s) X
                 <msg>   @P     </msg>                        //  message(s) sent @P
                 <sper>  @Nil  </sper>                        //  not persistent
               </send>                                        //
             </spackage>)                                     //[macro]

//Persistent send
  rule <k> X:Name !!( P:Proc ) => . ...</k>                   //dissolve send and spawn persistent <spackage/>
    (.Bag => <spackage>                                       //spawn spackage:
               <send>                                         //
                 <schan>  X  </schan>                         //  sending channel(s) X
                 <msg>   @P    </msg>                         //  message(s) sent @P
                 <sper>  Nil  </sper>                         //  persistent
               </send>                                        //
             </spackage>)                                     //[macro]  

//----------------
//--- RECEIVES ---
//----------------

//Linear receive
  rule <k> for ( Y:Name <- X:Name ){ P:Proc } => . ...</k>    //dissolve receive and spawn <rpackage/>
    (.Bag => <rpackage>                                       //spawn linear rpackage:
               <receive>                                      //  receive:
                 <rchan>  X   </rchan>                        //    receiving channel(s) X
                 <bvar>   Y    </bvar>                        //    variable(s) Y binding in continuation
                 <rper>  @Nil  </rper>                        //    not persistent (only consumed once)
               </receive>                                     //
               <cont>     P   </cont>                         //  continuation P
             </rpackage>)                                     //[macro]

//Persistent receive
  rule <k> for ( Y:Name <= X:Name ){ P:Proc } => . ...</k>    //dissolve receive and spawn <rpackage/>
    (.Bag => <rpackage>                                       //spawn persistent rpackage:
               <receive>                                      //  receive:
                 <rchan>  X  </rchan>                         //    receiving channel(s) X
                 <bvar>   Y   </bvar>                         //    variable(s) Y binding in continuation
                 <rper>  Nil  </rper>                         //    persistent (consumed many times)
               </receive>                                     //
               <cont>     P   </cont>                         //  continuation P
             </rpackage>)                                     //[macro]

//%%%%%%%%%%%%%%%%%%%%%%%
//%%% REDUCTION RULES %%%
//%%%%%%%%%%%%%%%%%%%%%%%

//------------------
//--- COMM EVENT ---
//------------------

//Comm: x!(Q) | x(y){P} => P[@Q / y]

//Linear comm
  rule                                                        //consume both rpackage and spackage
  (<rpackage>                                                 //
     <receive>                                                //  consume rpackage:
       <rchan> X:Name </rchan>                                //    channel(s) X
       <bvar>  Y:Name  </bvar>                                //    binding variable(s) Y
       <rper>  Nil     </rper>                                //    not persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //    continuation P
   </rpackage> => .Bag)                                       //
  (<spackage>                                                 //
     <send>                                                   //  consume spackage:
       <schan> X     </schan>                                 //    channel(s) X
       <msg>   Z:Name  </msg>                                 //    message(s) Z
       <sper>  Nil    </sper>                                 //    not persistent
     </send>                                                  //
   </spackage> => .Bag)                                       //
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn thread for substituted cont P[Z / Y]
  [comm]                                                      //tagged "comm" for tracking nondeterminism

//Persistent receive comm
  rule                                                        //persistent receives (rpackage persists)
    <rpackage>                                                //
      <receive>                                               //rpackage persists:
        <rchan> X:Name </rchan>                               //  channel(s) X
        <bvar>  Y:Name  </bvar>                               //  binding variable(s) Y
        <rper>  Nil     </rper>                               //  persistent
      </receive>                                              //
      <cont> P:Proc </cont>                                   //  continuation P
    </rpackage>                                               //
   (<spackage>                                                //consume spackage:
      <send>                                                  //
        <schan> X     </schan>                                //  channel(s) X
        <msg>   Z:Name  </msg>                                //  message(s) Z
        <sper>  @Nil   </sper>                                //  not persistent
      </send>                                                 //
    </spackage> => .Bag)                                      //  
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn <thread/> holding substitution P[Z / Y]
  [commpr]                                                    //tagged "commpr" for tracking nondeterminism

//Persistent send comm
  rule                                                        //persistent sends (spackage persists)
   (<rpackage>                                                //
      <receive>                                               //consume rpackage:
        <rchan> X:Name </rchan>                               //  channel(s) X
        <bvar>  Y:Name  </bvar>                               //  binding variable(s) Y
        <rper>  @Nil    </rper>                               //  not persistent
      </receive>                                              //
    <cont> P:Proc </cont>                                     //  continuation P
  </rpackage> => .Bag)                                        //
  <spackage>                                                  //spackage persists:
    <send>                                                    //
      <schan> X     </schan>                                  //  channel(s) X
      <msg>   Z:Name  </msg>                                  //  message(s) Z
      <sper>  Nil    </sper>                                  //  persistent
    </send>                                                   //
  </spackage>                                                 //  
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn <thread/> holding substitution P[Z / Y]
  [commps]                                                    //tagged "commps" for tracking nondeterminism

//**NEVER DO PERSISTENT RECEIVE AND PERSISTENT SEND ON SAME CHANNEL!

//Clean up parred expressions
//context     P:Proc | Nil    => P
//context        Nil | P:Proc => P
 
//rule        P:Proc | Nil    => P              [structural]  //Nils in <k/>

//rule           Nil | P:Proc => P              [structural]  //Nils in <k/>

//rule <cont> P:Proc | Nil    => P </cont>      [structural]  //Nils in <cont/>

//rule <cont>    Nil | P:Proc => P </cont>      [structural]  //Nils in <cont/>

//Dissolve computationally empty threads
  rule <thread> <k>  .  </k> </thread> => .Bag  [structural]  //dissolve empty threads

  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //dissolve Nil threads

//  NAME REDUCTIONS
//context    @ * _:Name => _                                  //write as single context reduction?

  rule  <msg>   @ * X:Name => X   </msg>        [structural]  //in message(s)

  rule  <rchan> @ * X:Name => X </rchan>        [structural]  //in receiving channel(s)

  rule  <schan> @ * X:Name => X </schan>        [structural]  //in sending channel(s)

// * AND @ ARE INVERSE OPERATORS                              
//context       * @ _:Proc => _                               //write as single context reduction?
                                                              //split between contexts:
  rule          * @ P:Proc => P                 [structural]  //reduce *@s

  rule   <cont> * @ P:Proc => P </cont>         [structural]  // in <cont/>

endmodule
