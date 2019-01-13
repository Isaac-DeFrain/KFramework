// RHOGUELANG (a.k.a. RHO-CALC++)

//%%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%% MODULE REQUIREMENTS %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%%
require "substitution.k"

//%%%%%%%%%%%%%%%%%%%%%
//%%% SYNTAX MODULE %%%
//%%%%%%%%%%%%%%%%%%%%%
module RHOGUE-SYNTAX
  import ID
  import DOMAINS
  import SUBSTITUTION

//*******************
//*** NAME SYNTAX ***
//*******************
  syntax    Name ::= Id                                                   //     Id: -----------------> Name
                   | "@" Proc                                             //  Quote: Proc ------------> Name
                   | "{" Name "}"                              [bracket]
                   | "(" Name ")"                              [bracket]

//syntax NameVar ::= Id                                                   //name variable
//                 | List{Id,","}                                         //name variables


//**********************
//*** PROCESS SYNTAX ***
//**********************
  syntax    Proc ::= "Nil"                                                //    Nil: -----------------> Proc
                   | "(" Name "<-" Name "){" Proc "}"        [binder(2)]  //    Rec: Name*Name*Proc --> Proc
                   | "(" Name "<=" Name "){" Proc "}"        [binder(2)]  //   pRec: Name*Name*Proc --> Proc
                   | Proc  "|"  Proc                              [left]  //    Par: Proc*Proc -------> Proc
                   | Name "!("  Proc ")"                                  //   Send: Name*Proc -------> Proc
                   | Name "!!(" Proc ")"                                  //  pSend: Name*Proc -------> Proc
                   | "*" Name                                             //  Reify: Name ------------> Proc
                   | "{" Proc "}"                              [bracket]
                   | "(" Proc ")"                              [bracket]

//syntax  Ground ::= Int                                                  //Ground terms
//                 | String
//                 | Bool

//syntax ProcVar ::= Id                                                   //process variable
//                 | List{Id,","}                                         //process variables

endmodule

//%%%%%%%%%%%%%%%%%%%%%%%%
//%%% SEMANTICS MODULE %%%
//%%%%%%%%%%%%%%%%%%%%%%%%

module RHOGUE
  import RHOGUE-SYNTAX
  import SUBSTITUTION

//<<<<<<<<<<<<<<<<<<<<<
//<<< CONFIGURATION >>>
//>>>>>>>>>>>>>>>>>>>>>

  configuration
    <T>                                                       //<top> : < <processpool> <tuplespace> >
      <processpool color="orange">                            //<processpool> : < <thread*> >
        <thread color="orange" multiplicity="*">              //<thread> : < <k> >
          <k>                                                 // concurrent compututaional threads
            $PGM:Proc                                         // programs and computations are both processes
          </k>                                                // end k
        </thread>                                             // end thread
      </processpool>                                          // end processpool
      <tuplespace color="blue">                               //<tuplespace> : < <rpackages> <spackages> >
        <rpackages color="red">                               //<rpackages> : < <rpackage*> >
          <rpackage color="red" multiplicity="*">             //<rpackage> : < <receives> <cont> >
            <receives color="purple">                         //<receives> : < <receive*> >
              <receive color="purple" multiplicity="*">       //<receive> : < <rchan> <bvars> <rpers> >
                <rchan color="purple"> .K </rchan>            // receive channel(s)
                <bvars color="purple"> .K </bvars>            // binding variable(s) in continuation
                <rpers color="purple"> .K </rpers>            // persistent (y/n)
              </receive>                                      // end receive
            </receives>                                       // end receives
            <cont color="orange"> .K </cont>                  //<cont> : < <k> >
          </rpackage>                                         // end rpackage
        </rpackages>                                          // end rpackages
        <spackages color="green">                             //<spackages> : < <spackage*> >
          <spackage color="teal" multiplicity="*">            //<spackage> : < <sends> >
            <sends color="cyan">                              //<sends> : < <send*> >
              <send color="cyan" multiplicity="*">            //<send> : < <schan> <msgs> <spers> >
                <schan color="cyan"> .K  </schan>             // send channel(s)
                <msgs color="cyan">   .K  </msgs>             // message(s) being sent
                <spers color="cyan">  .K </spers>             // persistent (yes = Nil / no = @Nil)
              </send>                                         // end send
            </sends>                                          // end sends
          </spackage>                                         // end spackage
        </spackages>                                          // end spackages
      </tuplespace>                                           // end tuplespace
    </T>                                                      // end of configuration

  syntax KVariable ::= Name

//syntax   KResult ::= Ground

//%%%%%%%%%%%%%%%%%%%%%%%%%%
//%%% OPERATOR SEMANTICS %%%
//%%%%%%%%%%%%%%%%%%%%%%%%%%

// implement join as packet of sends/receives to a single continuation

//-----------
//--- PAR ---
//-----------

  rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>  //dissolve par in <thread/>
       (.Bag => <thread> <k> P1 </k> </thread>)               //  spawn two new <thread/>s
       (.Bag => <thread> <k> P2 </k> </thread>)               //[structural] or [macro]

//-------------
//--- SENDS ---
//-------------

//Linear send
  rule <k> X:Name !( P:Proc ) => . ...</k>                    //dissolve send in <thread/> and spawn <spackage/>
    (.Bag => <spackage>                                       //spawn spackage:
               <send>                                         //
                 <schan>  X   </schan>                        //  sending channel(s) X
                 <msgs>  @P    </msgs>                        //  message(s) sent @P
                 <spers> @Nil </spers>                        //  not persistent
               </send>                                        //
             </spackage>)                                     //[macro]

//Persistent send
  rule <k> X:Name !!( P:Proc ) => . ...</k>                   //dissolve send and spawn persistent <spackage/>
    (.Bag => <spackage>                                       //spawn spackage:
               <send>                                         //
                 <schan>  X  </schan>                         //  sending channel(s) X
                 <msgs>  @P   </msgs>                         //  message(s) sent @P
                 <spers> Nil </spers>                         //  persistent
               </send>                                        //
             </spackage>)                                     //[macro]  

//----------------
//--- RECEIVES ---
//----------------

//Linear receive
  rule <k> ( Y:Name <- X:Name ){ P:Proc } => . ...</k>        //dissolve receive and spawn <rpackage/>
    (.Bag => <rpackage>                                       //spawn linear rpackage:
               <receive>                                      //  receive:
                 <rchan>  X   </rchan>                        //    receiving channel(s) X
                 <bvars>  Y   </bvars>                        //    variable(s) Y binding in continuation
                 <rpers> @Nil </rpers>                        //    not persistent (only consumed once)
               </receive>                                     //
               <cont>     P   </cont>                         //  continuation P
             </rpackage>)                                     //[macro]

//Persistent receive
  rule <k> ( Y:Name <= X:Name ){ P:Proc } => . ...</k>        //dissolve receive and spawn <rpackage/>
    (.Bag => <rpackage>                                       //spawn persistent rpackage:
               <receive>                                      //  receive:
                 <rchan>  X  </rchan>                         //    receiving channel(s) X
                 <bvars>  Y  </bvars>                         //    variable(s) Y binding in continuation
                 <rpers> Nil </rpers>                         //    persistent (consumed many times)
               </receive>                                     //
               <cont>    P    </cont>                         //  continuation P
             </rpackage>)                                     //[macro]

//%%%%%%%%%%%%%%%%%%%%%%%
//%%% REDUCTION RULES %%%
//%%%%%%%%%%%%%%%%%%%%%%%

//------------------
//--- COMM EVENT ---
//------------------

//Comm: x!(Q) | x(y){P} => P[@Q / y]

//Linear comm
  rule                                                        //dissolve both rpackage and spackage
  (<rpackage>                                                 //
     <receive>                                                //  dissolve rpackage:
       <rchan> X:Name </rchan>                                //    channel(s) X
       <bvars> Y:Name </bvars>                                //    binding variable(s) Y
       <rpers>   Nil  </rpers>                                //    not persistent
     </receive>                                               //
     <cont> P:Proc </cont>                                    //    continuation P
   </rpackage> => .Bag)                                       //
  (<spackage>                                                 //
     <send>                                                   //  dissolve spackage:
       <schan> X     </schan>                                 //    channel(s) X
       <msgs>  Z:Name </msgs>                                 //    message(s) Z
       <spers> Nil   </spers>                                 //    not persistent
     </send>                                                  //
   </spackage> => .Bag)                                       //
  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn thread for substituted cont P[Z / Y]
  [comm]                                                      //tagged "comm" for tracking nondeterminism

//Persistent receive comm
//  rule                                                      //persistent receives
//    <rpackage>                                              //
//      <receive>                                             //comm event but rpackage persists:
//        <rchan> X:Name </rchan>                             //  channel(s) X
//        <bvars> Y:Name  </bvars>                            //  binding variable(s) Y
//        <rpers>   Nil   </rpers>                            //  persistent
//      </receive>                                            //
//      <cont> P:Proc </cont>                                 //  continuation P
//    </rpackage>                                             //
//   (<spackage>                                              //dissolve spackage:
//      <send>                                                //
//        <schan> X     </schan>                              //  channel(s) X
//        <msgs>  Z:Name </msgs>                              //  message(s) Z
//        <spers>  @Nil </spers>                              //  not persistent
//      </send>                                               //
//    </spackage> => .Bag)                                    //  
//  (.Bag => <thread> <k> P[Z / Y] </k> </thread>)            //spawn <thread/> holding substitution P[Z / Y]
//  [commpr]                                                  //tagged "commpr" for tracking nondeterminism

//Persistent send comm
//  rule                                                      //persistent sends
// (<rpackage>                                                //
//    <receive>                                               //dissolve rpackage:
//      <rchan> X:Name </rchan>                               //  channel(s) X
//      <bvars> Y:Name </bvars>                               //  binding variable(s) Y
//      <rpers>  @Nil  </rpers>                               //  not persistent
//    </receive>                                              //
//  <cont> P:Proc </cont>                                     //  continuation P
//</rpackage> => .Bag)                                        //
//<spackage>                                                  //comm event and spackage persists:
//  <send>                                                    //
//    <schan> X     </schan>                                  //  channel(s) X
//    <msgs>  Z:Name </msgs>                                  //  message(s) Z
//    <spers>   Nil </spers>                                  //  persistent
//  </send>                                                   //
//</spackage>                                                 //  
//(.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn <thread/> holding substitution P[Z / Y]
//[commps]                                                    //tagged "commps" for tracking nondeterminism

//**DON'T DO BOTH PERSISTENT RECEIVE AND SEND ON SAME CHANNEL!

//Clean up parred expressions
//rule        P:Proc | Nil    => P              [structural]  //Nils in <k/>

//rule           Nil | P:Proc => P              [structural]  //Nils in <k/>

//rule <cont> P:Proc | Nil    => P </cont>      [structural]  //Nils in <cont/>

//rule <cont>    Nil | P:Proc => P </cont>      [structural]  //Nils in <cont/>

//Dissolve computationally empty threads
  rule <thread> <k>  .  </k> </thread> => .Bag  [structural]  //dissolve empty threads

  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //dissolve Nil threads

//  NAME REDUCTIONS
//context    @ * _:Name => _                                  //write as single context reduction?

  rule  <msgs>  @ * X:Name => X  </msgs>        [structural]  //in message(s)

  rule  <rchan> @ * X:Name => X </rchan>        [structural]  //in receiving channel(s)

  rule  <schan> @ * X:Name => X </schan>        [structural]  //in sending channel(s)

// * AND @ ARE INVERSE OPERATORS                              
//context       * @ _:Proc => _                               //write as single context reduction?
                                                              //split between contexts:
  rule          * @ P:Proc => P                 [structural]  //reduce *@s

  rule   <cont> * @ P:Proc => P </cont>         [structural]  // in <cont/>

endmodule
