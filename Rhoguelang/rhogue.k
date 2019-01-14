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

  syntax NameVar ::= Id                                                         //   Id: Char' ------------> Name
                   | List{Id,";"}                            [klabel(NameVar)]  //name variables
                   | "[" NameVar "]"

  syntax    Name ::= Quote
                   | NameVar
                   | "{" Name "}"                                    [bracket]
                   | "(" Name ")"                                    [bracket]


//****************************
//*** PROCESS CONSTRUCTORS ***
//****************************
  syntax  Ground ::= "Nil"                                                       //Ground terms
                   | Bool
                   | Int
                   | String

  syntax  Atomic ::= Ground
                   | Rec
                   | Send

       // Bundle cannot be destructured by pattern matching                      //| read? | write? |
  syntax  Bundle ::= "bundle-" "{" Proc "}"                                      //| yes   | no     |
                   | "bundle+" "{" Proc "}"                                      //| no    | yes    |
                   | "bundle0" "{" Proc "}"                                      //| no    | no     |
                   | "bundle"  "{" Proc "}"                                      //| yes   | yes    |

  syntax   Smart ::= "contract" Name "(" Name ")" "{" Proc "}"

  syntax     New ::= "new" Name "in"  "{" Proc "}"                     [binder]  //  New: Name*Proc -------> Proc

  syntax   Reify ::=   "*" Name                                                  //Reify: Name ------------> Proc

  syntax     Rec ::= "for" "("  Name "<-" Name "){" Proc "}"        [binder(2)]  //  Rec: Name*Name*Proc --> Proc
                   | "for" "("  Name "<=" Name "){" Proc "}"        [binder(2)]  // pRec: Name*Name*Proc --> Proc

  syntax    Send ::= Name "!("  Proc ")"                                         // Send: Name*Proc -------> Proc
                   | Name "!!(" Proc ")"                                         //pSend: Name*Proc -------> Proc

  syntax     Par ::= Proc  "|"  Proc                                             //  Par: Proc*Proc -------> Proc



  syntax ProcVar ::= Id                                                          //   Id: Char' -----------> Proc
//                 | List{Id,";"}                             [klabel(ProcVar)]  //process variables
//                 | "[" ProcVar "]"

  syntax    Proc ::= Atomic
                   | Bundle
                   | Par
                   | New
                   | Smart
                   | Reify
                   | ProcVar
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
    </T>                                                      // end of configuration

  syntax KVariable ::= Name | ProcVar

//syntax KResult ::= Name | Atomic

//=>=>=>=>=>=>=>=>=>=>=>=>=>
//<=> OPERATOR SEMANTICS >=>
//=>=>=>=>=>=>=>=>=>=>=>=>=>

//-----------
//--- PAR ---
//-----------

  rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>  //dissolve par in <thread/>
       (.Bag => <thread> <k> P1 </k> </thread>)               //  spawn two new <thread/>s
       (.Bag => <thread> <k> P2 </k> </thread>)  [structural]

//-------------
//--- SENDS ---
//-------------

//Linear send (recursion not currently working)
  rule <k> [Hd; Tl]:NameVar !( P:Proc ) => Tl !( P:Proc ) ...</k>
    (.Bag => <send>                                           //
               <schan> Hd </schan>                            //  sending channel(s) X
               <msg>   @P   </msg>                            //  message(s) sent @P
               <sper>   0  </sper>                            //  not persistent
             </send>)                            [structural]

  rule <k> .NameVar !( P:Proc ) => . ...</k>

//Persistent send
  rule <k> X:Name !!( P:Proc ) => . ...</k>                   //dissolve send and spawn persistent <spackage/>
    (.Bag => <spackage>                                       //spawn spackage:
               <send>                                         //
                 <schan>  X  </schan>                         //  sending channel(s) X
                 <msg>   @P    </msg>                         //  message(s) sent @P
                 <sper>   1   </sper>                         //  persistent
               </send>                                        //
             </spackage>)                        [structural]  

//----------------
//--- RECEIVES ---
//----------------

//Linear receive
  rule <k> for ( Y:Name <- X:Name ){ P:Proc } => . ...</k>    //dissolve receive and spawn <rpackage/>
    (.Bag => <rpackage>                                       //spawn linear rpackage:
               <receive>                                      //  receive:
                 <rchan>  X   </rchan>                        //    receiving channel(s) X
                 <bvar>   Y    </bvar>                        //    variable(s) Y binding in continuation
                 <rper>   0    </rper>                        //    not persistent (only consumed once)
               </receive>                                     //
               <cont>     P   </cont>                         //  continuation P
             </rpackage>)                        [structural]

//Persistent receive
  rule <k> for ( Y:Name <= X:Name ){ P:Proc } => . ...</k>    //dissolve receive and spawn <rpackage/>
    (.Bag => <rpackage>                                       //spawn persistent rpackage:
               <receive>                                      //  receive:
                 <rchan>  X  </rchan>                         //    receiving channel(s) X
                 <bvar>   Y   </bvar>                         //    variable(s) Y binding in continuation
                 <rper>   1   </rper>                         //    persistent (consumed many times)
               </receive>                                     //
               <cont>     P   </cont>                         //  continuation P
             </rpackage>)                        [structural]

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

//Linear comm list i.e. join
//rule                                                        //consume both rpackage and spackage
//(<rpackage>                                                 //
//   <receive>                                                //  consume rpackage:
//     <rchan> X:Name </rchan>                                //    channel(s) X
//     <bvar>  Y:Name  </bvar>                                //    binding variable(s) Y
//     <rper>    0     </rper>                                //    not persistent
//   </receive>                                               //
//   <cont> P:Proc </cont>                                    //    continuation P
// </rpackage> => .Bag)                                       //
//(<spackage>                                                 //
//   <send>                                                   //  consume spackage:
//     <schan> X     </schan>                                 //    channel(s) X
//     <msg>   Z:Name  </msg>                                 //    message(s) Z
//     <sper>    0    </sper>                                 //    not persistent
//   </send>                                                  //
// </spackage> => .Bag)                                       //
//(.Bag => <thread> <k> P[Z / Y] </k> </thread>)              //spawn thread for substituted cont P[Z / Y]
//[comm]                                                      //tagged "comm" for tracking nondeterminism

//Persistent receive comm
  rule                                                        //persistent receives (rpackage persists)
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
  [comm]                                                    //tagged "commpr" for tracking nondeterminism

//Persistent send comm
  rule                                                        //persistent sends (spackage persists)
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
  [comm]                                                    //tagged "commps" for tracking nondeterminism

//**NEVER DO PERSISTENT RECEIVE AND PERSISTENT SEND ON SAME CHANNEL!

  rule contract Y:Name ( X:Name ) { P:Proc } => for ( Y <- X ){ P }                [structural]

  rule <cont> contract Y:Name ( X:Name ) { P:Proc } => for ( Y <- X ){ P } </cont> [structural]

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
