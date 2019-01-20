// RHOGUELANG (a.k.a. RHO-CALC++)

require "substitution.k"

//.....................
//... SYNTAX MODULE ...
//.....................
module RHOGUE-SYNTAX
  import ID
  import DOMAINS-syntax
  import SUBSTITUTION

//-----------------------------
//--- PROCESSES & VARIABLES ---
//-----------------------------

//--- Process ---
syntax          Proc ::= "{" Proc "}"                                       [bracket]  //bracket for process
                       | "Nil"                                                         //stopped process
                       | Ground                                                        //boolean, integer, string, unforgeable int, uri
                       | Collection                                                    //process tuple, list, set, map
                       | ProcVar                                                       //process variables
                       > VarRef                                                        //variable references
                       > "*" Name                                                      //evaluate/reify
                       > Proc "." Method "(" MethodArgs ")"                            //method
                       > AExp                                                          //arithmetic expression
                       > BExp                                                          //boolean expression
                       > Name Send                                                     //send on channel
                       > "contract" Names "(" NamePats ")" "=" "{" Proc "}"            //contract: needs to be given an alias which binds
                       | "for" "(" Receipt ")" "{" Proc "}"                  [binder]  //listen
                       | "match" Proc "{" MatchCases "}"                               //match
                       | Bundle "{" Proc "}"                                           //bundle
                       > "if" "(" Bool ")" Proc                           [strict(1)]  //if...then...
                       | "if" "(" Bool ")" Proc "else" Proc               [strict(1)]  //if...then...else...
                       | "new" NameDeclarations "in" "{" Proc "}"            [binder]  //unforgeable names
                       > Proc "|" Proc                                         [left]  //parallel composition

//--- Ground ---
//Basic Data Structures
syntax        Ground ::= Bool                                                          //boolean
                       | Int                                                           //integer
                       | String                                                        //string
                       | "unforgeable(" Int ")"                                        //unforgeable integer
                       | Uri                                                           //uri

//--- Collection ---
syntax    Collection ::= RhoList                                                       //process list
                       | RhoMap                                                        //process map
                       | RhoSet                                                        //process set
                       | RhoTuple                                                      //process tuple

// Lists
syntax      RhoList ::= "[" Procs "]"                                                  //list of preocesses

// Maps
syntax       RhoMap ::= "{" RhoKVPairs "}"                                             //map = { key-value pairs }

// Key-Value Pairs
syntax   RhoKVPairs ::= Proc ":" Proc                                                  //single key-value pair
                      | Proc ":" Proc "," RhoKVPairs                                   //multiple key-value pairs

// Sets
syntax          Set ::= "Set" "(" Procs ")"                                            //set of processes

// Tuples
syntax     RhoTuple ::= "(" Proc ",)"                                                  //1-tuple, note the ",)"
                      | "(" Proc "," Procs ")"                                         //n-tuple, n >= 2

//---Process Variables---
// General Variables
syntax          Var ::= Id                                                             //name or process variable
syntax         Vars ::= Var                                                            //single variable
                      | Var "," Vars                                                   //multiple variables

// Process Variables
syntax      ProcVar ::= Var                                                            //process variable

syntax     ProcVars ::= ProcVar                                                        //monadic
                      | ProcVar "," ProcVars                                           //polyadic

// Variable References - so we don't shadow the variable referenced
syntax       VarRef ::= "=" ProcVar                                                    //process variable reference
                      | "=" "*" NameVar                                                //evaluated name variable reference

//--- Methods ---
syntax   MethodArgs ::= Procs                                                          //one or more processes
                      | ""                                                             //zero arguments

// List of current methods
syntax       Method ::= "method(nth)"                                                  //nth element: list, string, & tuple
                      | "method(toByteArray)"                                          //to byte array: all
                      | "method(hexToBytes)"                                           //hex to bytes: string
                      | "method(union)"                                                //union: map & set
                      | "method(diff)"                                                 //difference: not tuple
                      | "method(add)"                                                  //add: not tuple
                      | "method(delete)"                                               //delete: not tuple
                      | "method(contains)"                                             //contains: not tuple
                      | "method(get)"                                                  //get value: map
                      | "method(getOrElse)"                                            //get value or else: map
                      | "method(set)"                                                  //set value: map
                      | "method(keys)"                                                 //set of keys: map
                      | "method(size)"                                                 //size: not tuple
                      | "method(lenth)"                                                //length: list & string
                      | "method(slice)"                                                //slice: list & string
                      | "method(confine)"                                              //not currently in interpreter?

//--- Expressions ---
// expressions are anything that necessarily resolves to a ground term or collection
syntax          Exp ::= Collection
                      | Ground
                      | AExp

// Arithmetic Expressions
syntax         AExp ::= "(" AExp ")"                                                   //parentheses for arithmetic expression
                      > AExp "*"  AExp                                       [strict]  //multiplication
                      | AExp "/"  AExp                                       [strict]  //division
                      | AExp "%"  AExp                                       [strict]  //remainders
                      > AExp "+"  AExp                                       [strict]  //addition
                      | AExp "-"  AExp                                       [strict]  //subtraction
                      | AExp "++" AExp                                       [strict]  //plus plus
                      > AExp "--" AExp                                       [strict]  //minus minus

// Boolean Expressions
syntax         BExp ::= "(" BExp ")"                                        [bracket]  //parentheses for boolean expression
                      | Bool                                                           //true or false
                     // Arithmetic                                                     //arithmetic predicates
                      > AExp "<"  AExp                                    [seqstrict]  //strictly less than
                      | AExp "<=" AExp                                    [seqstrict]  //less than
                      | AExp ">"  AExp                                    [seqstrict]  //strictly greater than
                      | AExp ">=" AExp                                    [seqstrict]  //greater than
                     // Processes                                                      //process predicates
                      > Proc "matches" Proc                                            //process matching
                      | Proc "==" Proc                                                 //process equality
                      | Proc "!=" Proc                                                 //process inequlaity
                     // Connectives                                                    //boolean connectives
                      | "not" BExp                                           [strict]  //not
                      > BExp "and" BExp                                   [seqstrict]  //and
                      > BExp "or"  BExp                                   [strict(1)]  //or

//--- Sends ---
syntax          Send ::= SendSingle                                                    //single
                       | SendMultiple                                                  //persistent

// Single Send
syntax    SendSingle ::= "!"  SendContent

// Persistent Send
syntax  SendMultiple ::= "!!" SendContent

// Content of send
syntax   SendContent ::= "(" Proc ")"                                                  //monadic send
                       | RhoTuple                                                      //poladic send

//--- Listens ---
// Receipts
syntax       Receipt ::= LinearBinds
                       | RepeatedBinds

// Linear binds
syntax    LinearBind ::= NamePats  "<-" Name                                           //for( y <- x ){ P }
                       | NamePats  "<!" Name                                           //peek

syntax   LinearBinds ::= LinearBind                                                    //single linear bind
                       | LinearBind ";" LinearBinds                                    //multiple linear binds (join)

// Repeated binds
syntax  RepeatedBind ::= NamePats "<=" Name                                            //for( y <= x ){ P }

syntax RepeatedBinds ::= RepeatedBind                                                  //single repeated bind
                       | RepeatedBind ";" RepeatedBinds                                //multiple repeated binds (join)

//--- Matches ---
syntax     MatchCase ::= ProcPat "=>" Proc                                      [binder]  //match case

syntax    MatchCases ::= MatchCase                                                     //single match case
                       | MathCase MatchCases                                           //multiple match cases

//--- Bundles ---
// cannot be destructured by pattern matching                                          // | can read? | can write? |
syntax        Bundle ::= "bundle0"                                                     // | no        | no         |
                       | "bundle-"                                                     // | yes       | no         |
                       | "bundle+"                                                     // | no        | yes        |
                       | "bundle"                                                      // | yes       | yes        |


//------------------------
//--- PROCESS PATTERNS ---
//------------------------

//--- Process Patterns ---
syntax       ProcPat ::= "{" ProcPat "}"     [bracket]                                 //bracket for process pattern
                       | CollectionPat                                                 //collection pattern
                       | SimpleType                                                    //simple type
                       > "~" ProcPat                                                   //logical negation
                       > ProcPat "/\\" ProcPat  [left]                                 //logical "and"
                       > ProcPat "\\/" ProcPat  [left]                                 //logical "or"
                       > Proc                                                          //process patterns can be ordinary pattern
                       > ProcPat "|" ProcPat    [left]                                 //parallel compsition

syntax      ProcPats ::= Procs                                                         //process patterns can be ordinary patterns
                       | ProcPat                                                       //single process pattern
                       | ProcPat "," ProcPats                                          //multiple process patterns

//---Simple Types---
syntax    SimpleType ::= "Bool"
                       | "ByteArray"
                       | "Int"
                       | "List"
                       | "Map"
                       | "String"
                       | "Tuple"
                       | "Uri"

//------------------------------
//--- NAMES & NAME VARIABLES ---
//------------------------------

//--- Name Variables ---
syntax       NameVar ::= Var                                                           //name variable

syntax      NameVars ::= NameVar                                                       //single variable
                       | NameVar "," NameVars                                          //multiple variables

//--- Names ---
syntax          Name ::= "@" Proc                                                          //quoted process
                       | NameVar

syntax         Names ::= Name
                       | Name "," Names
                       | NameVars

//---------------------
//--- NAME PATTERNS ---
//---------------------
syntax  NamePat ::= ???

syntax NamePats ::= NamePat
                  | NamePat "," NamePats

endmodule

//........................
//... SEMANTICS MODULE ...
//........................

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

syntax KVariable ::= Id | NameVars | ProcVars

syntax KResult ::= Bool | Int                                 //results for strictness

//..........................
//... OPERATOR SEMANTICS ...
//..........................

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

//Linear receive
rule <k> for ( Y:Names <- X:Names ){ P:Proc } => . ...</k>    //dissolve receive and spawn <rpackage/>
  (.Bag => <rpackage>                                         //spawn linear rpackage:
             <receive>                                        //  receive:
               <rchan>  X   </rchan>                          //    receiving channel(s) X
               <bvar>   Y    </bvar>                          //    variable(s) Y binding in continuation
               <rper>   0    </rper>                          //    not persistent (only consumed once)
             </receive>                                       //
             <cont>     P   </cont>                           //  continuation P
           </rpackage>)                        [structural]

//Persistent receive
rule <k> for ( Y:Names <= X:Names ){ P:Proc } => . ...</k>    //dissolve receive and spawn <rpackage/>
  (.Bag => <rpackage>                                         //spawn persistent rpackage:
             <receive>                                        //  receive:
               <rchan>  X  </rchan>                           //    receiving channel(s) X
               <bvar>   Y   </bvar>                           //    variable(s) Y binding in continuation
               <rper>   1   </rper>                           //    persistent (consumed many times)
             </receive>                                       //
             <cont>     P   </cont>                           //  continuation P
           </rpackage>)                        [structural]

//Bool, Int, String operations

//>=>=>=>=>=>=>=>=>=>=>=>
//<=> REDUCTION RULES <=>
//>=>=>=>=>=>=>=>=>=>=>=>

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
  [comm]                                                      //tagged "commpr" for tracking nondeterminism

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
  [comm]                                                      //tagged "commps" for tracking nondeterminism

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
//context       @ * []                                        //write as single context reduction?

  rule  <msg>   @ * X:Name => X   </msg>        [structural]  //in message(s)

  rule  <rchan> @ * X:Name => X </rchan>        [structural]  //in receiving channel(s)

  rule  <schan> @ * X:Name => X </schan>        [structural]  //in sending channel(s)

// * AND @ ARE INVERSE OPERATORS                              
//context       * @ []                                        //write as single context reduction?
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
