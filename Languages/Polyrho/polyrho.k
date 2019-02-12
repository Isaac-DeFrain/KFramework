// Polyadic Rho-Calculus

require "domains.k"
require "kast.k"
require "substitution.k"

module POLYRHO-SYNTAX
  import DOMAINS
  import KAST
  import KSEQ-SYMBOLIC
  import SUBSTITUTION

//-----------------
//--- PROCESSES ---
//-----------------

//--- Processes ---
syntax          Proc ::= "{" Proc "}"                              [bracket]
                       | "Nil"                                                // stopped process
                       | Collection                                           // process list, map, set, tuple
                       > Eval                                                 // inert unless input-guarded (semantic substitution)
                       > Send                                                 // output (no continuation - asynchronous)
                       | Rec                                                  // input (continuation)
                       > Par                                                  // parallel composition

//--- Parallel ---
syntax           Par ::= Proc "|" Proc                                [left]

//--- Receive/Input ---
syntax           Rec ::= "for" "(" Receipt ")" "{" Proc "}"         [binder]

syntax       Receipt ::= Lbinds
                       | Rbinds

// Linear bind
syntax         Lbind ::= NamePat "<-" Name                                    // linear bind - consumed once

syntax        Lbinds ::= Lbind                                                // single linear bind
                       | Lbind  ";" Lbinds                                    // head cons linear bind list
                       | Lbinds ";" Lbind                                     // tail cons linear bind list
                       | Lbinds ";" Lbinds                                    // for linear bind list concat

// Persistent bind
syntax         Rbind ::= NamePat "<=" Name                                    // repeated bind - persistent

syntax        Rbinds ::= Rbind                                                // single repeated bind
                       | Rbind  ";" Rbinds                                    // head cons repeated bind list
                       | Rbinds ";" Rbind                                     // tail cons repeated bind list
                       | Rbinds ";" Rbinds                                    // for repeated bind list concat

//--- Send/Output ---
syntax          Send ::= Name "!" Content                                     // send content on name

syntax       Content ::= "(" Proc ")"                                         // send a process
                       | RhoTuple                                             // or a tuple of processes

//--- Evaluation ---
syntax          Eval ::= "*" Name                                             // evaluation of a name

//--- Collections ---
syntax    Collection ::= RhoList                                              // list of processes
                       | RhoMap                                               // set of process key-value pairs
                       | RhoSet                                               // set of processes
                       | RhoTuple                                             // tuple of processes

syntax         Procs ::= Proc                                                 // single process
                       | Proc  "," Procs                                      // head cons list
                       | Procs "," Proc                                       // tail cons list
                       | Procs "," Procs                                      // for list concat

syntax       RhoList ::= ".RhoList"                                           // empty list
                       | "[" Procs "]"
                       | RhoList RhoList                              [left]  // list concat

syntax        RhoMap ::= ".RhoMap"                                            // empty map (currently a multimap)
                       | "{" RhoKVPairs "}"                                   // map of RhoKVPairs enclosed in {...}
                       | RhoMap RhoMap                                [left]  // map union

syntax     RhoKVPair ::= Proc ":" Proc

syntax    RhoKVPairs ::= RhoKVPair
                       | RhoKVPair  "," RhoKVPairs
                       | RhoKVPairs "," RhoKVPair
                       | RhoKVPairs "," RhoKVPairs

syntax        RhoSet ::= ".RhoSet"                                            // multiset
                       | "Set" "(" Procs ")"
                       | RhoSet RhoSet                                [left]

syntax      RhoTuple ::= "(" Proc ",)"
                       | "(" Proc "," Procs ")"

//-------------
//--- NAMES ---
//-------------
syntax          Name ::= "{" Name "}"                              [bracket]
                       | "@" Proc

syntax         Names ::= "{" Names "}"                             [bracket]
                       | Name
                       | Name  "," Names
                       | Names "," Name
                       | Names "," Names

//----------------
//--- PATTERNS ---
//----------------

//--- Pure Process Patterns ---
syntax       ProcVar ::= Id                                [klabel(procvar)]

syntax      ProcVars ::= "{" ProcVars "}"                          [bracket]
                       | ProcVar
                       | ProcVar  "," ProcVars
                       | ProcVars "," ProcVar
                       | ProcVars "," ProcVars

syntax       ProcPat ::= "{" ProcPat "}"                           [bracket]
                       | CollectionPat
                       | ProcVar
                       > EvalPat
                       > SendPat
                       | RecPat
                       > ParPat

syntax      ProcPats ::= "{" ProcPats "}"                          [bracket]
                       | ProcPat
                       | ProcPat  "," ProcPats
                       | ProcPats "," ProcPat
                       | ProcPats "," ProcPats

// ParPat
syntax        ParPat ::= Proc    "|" ProcPat
                       | ProcPat "|" Proc
                       | ProcPat "|" ProcPat

// RecPat
syntax        RecPat ::= "for" "(" Receipt    ")" "{" ProcPat "}"      [binder]
                       | "for" "(" ReceiptPat ")" "{" Proc    "}"      [binder]
                       | "for" "(" ReceiptPat ")" "{" ProcPat "}"      [binder]

syntax    ReceiptPat ::= LbindPats
                       | RbindPats

syntax      LbindPat ::= NamePat "<-" NamePat

syntax     LbindPats ::= LbindPat
                       | LbindPat  ";" LbindPats
                       | LbindPats ";" LbindPat
                       | LbindPats ";" LbindPats

syntax      RbindPat ::= NamePat "<=" NamePat

syntax     RbindPats ::= RbindPat
                       | RbindPat  ";" RbindPats
                       | RbindPats ";" RbindPat
                       | RbindPats ";" RbindPats

// SendPat
syntax       SendPat ::= NamePat "!" "(" Content    ")"
                       | Name    "!" "(" ContentPat ")"
                       | NamePat "!" "(" ContentPat ")"

syntax    ContentPat ::= ProcPat
                       | RhoTuplePat

// EvalPat
syntax       EvalPat ::= "*" NamePat

//--- Collection Patterns ---
syntax CollectionPat ::= RhoListPat
                       | RhoMapPat
                       | RhoSetPat
                       | RhoTuplePat

// List Pattern
syntax    RhoListPat ::= ".RhoListPat"
                       | "[" ProcPats "]"
                       | RhoListPat RhoListPat                        [left]
// Map Pattern
syntax     RhoMapPat ::= ".RhoMapPat"
                       | "{" RhoKVPairPats "}"
                       | RhoMapPat RhoMapPat                          [left]

syntax  RhoKVPairPat ::= Proc    ":" ProcPat
                       | ProcPat ":" Proc
                       | ProcPat ":" ProcPat

syntax RhoKVPairPats ::= RhoKVPairPat
                       | RhoKVPairPat  "," RhoKVPairPats
                       | RhoKVPairPats "," RhoKVPairPat
                       | RhoKVPairPats "," RhoKVPairPats

// Set of Patterns
syntax     RhoSetPat ::= ".RhoSetPat"                                         // multiset
                       | "Set" "(" ProcPats ")"
                       | RhoSetPat RhoSetPat                          [left]

// Tuple of Patterns
syntax   RhoTuplePat ::= "(" ProcPat ",)"
                       | "(" ProcPat "," ProcPats ")"

//--- Process Or Pattern ---
syntax     ProcOrPat ::= "{" ProcOrPat "}"
                       | Proc
                       | ProcPat
/*
syntax    ProcOrPats ::= "{" ProcOrPats "}"
                       | ProcOrPat
                       | ProcOrPat  "," ProcOrPats
                       | ProcOrPats "," ProcOrPat
                       | ProcOrPats "," ProcOrPats
*/
//--- Name Patterns ---
syntax       NameVar ::= #LowerId                          [klabel(namevar)]

syntax      NameVars ::= "{" NameVars "}"
                       | NameVar
                       | NameVar  "," NameVars
                       | NameVars "," NameVar
                       | NameVars "," NameVars

syntax       NamePat ::= "{" NamePat "}"
                       | NameVar
                       | "@" ProcPat

syntax      NamePats ::= "{" NamePats "}"
                       | NamePat
                       | NamePat  "," NamePats
                       | NamePats "," NamePat
                       | NamePats "," NamePats

endmodule

module POLYRHO
  import POLYRHO-SYNTAX

  configuration
    <T>
      <threadpool color="red">
        <thread multiplicity="*">                               //collection of threads
          <k> $PGM:ProcOrPat </k>                                    //programs and computations are process-based
        </thread>                                               //
      </threadpool>                                             //tuplespace stores sends and receives
      <tuplespace color="blue">                                 //
        <sends color="teal">                                    //**sends**
          <send color="cyan" multiplicity="*">                  //
            <schan> .K </schan>                                 //sending channel (many messages on same channel)
            <msg>   .K   </msg>                                 //message
          </send>                                               //
        </sends>                                                //
        <receives color="green">                                //**receives**
          <rec color="yellow" multiplicity="*">                 //
            <bind> .K </bind>                                 //binding varible in continuation
            <cont> .K </cont>                                 //continuation
          </rec>
        </receives>
      </tuplespace>
    </T>

//--- Collections and Patterns ---
// RhoList & Pat
  rule L:RhoList .RhoList => L
  rule .RhoList L:RhoList => L
  rule [ P:Proc  ] [ Q:Procs ] => [ P , Q ]
  rule [ P:Procs ] [ Q:Proc  ] => [ P , Q ]
  rule [ P:Procs ] [ Q:Procs ] => [ P , Q ]

// RhoList & Pat
  rule L:RhoListPat .RhoListPat => L
  rule .RhoListPat L:RhoListPat => L
  rule [ P:ProcPat  ] [ Q:ProcPats ] => [ P , Q ]
  rule [ P:ProcPats ] [ Q:ProcPat  ] => [ P , Q ]
  rule [ P:ProcPats ] [ Q:ProcPats ] => [ P , Q ]

// RhoMap
  rule M:RhoMap .RhoMap => M
  rule .RhoMap M:RhoMap => M
  rule { K:RhoKVPair  } { L:RhoKVPairs } => { K , L }
  rule { K:RhoKVPairs } { L:RhoKVPair  } => { K , L }
  rule { K:RhoKVPairs } { L:RhoKVPairs } => { K , L }

// RhoMapPat
  rule M:RhoMapPat .RhoMapPat => M
  rule .RhoMapPat M:RhoMapPat => M
  rule { K:RhoKVPairPat  } { L:RhoKVPairPats } => { K , L }
  rule { K:RhoKVPairPats } { L:RhoKVPairPat  } => { K , L }
  rule { K:RhoKVPairPats } { L:RhoKVPairPats } => { K , L }

// RhoSet
  rule S:RhoSet .RhoSet => S
  rule .RhoSet S:RhoSet => S
  rule Set( P:Proc  ) Set( Q:Procs ) => Set( P , Q )
  rule Set( P:Procs ) Set( Q:Proc  ) => Set( P , Q )
  rule Set( P:Procs ) Set( Q:Procs ) => Set( P , Q )

// RhoSetPat
  rule S:RhoSetPat .RhoSetPat => S
  rule .RhoSetPat S:RhoSetPat => S
  rule Set( P:ProcPat  ) Set( Q:ProcPats ) => Set( P , Q )
  rule Set( P:ProcPats ) Set( Q:ProcPat  ) => Set( P , Q )
  rule Set( P:ProcPats ) Set( Q:ProcPats ) => Set( P , Q )

// RhoTuple

// PAR OPERATOR SEMANTICS
  rule <thread> <k> P1:Proc | P2:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P1 </k> </thread>)
       (.Bag => <thread> <k> P2 </k> </thread>)               //[structural]

  rule <thread> <k> P1:ProcPat | P2:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P1 </k> </thread>)
       (.Bag => <thread> <k> P2 </k> </thread>)               //[structural]

  rule <thread> <k> P1:Proc | P2:ProcPat => . ...</k> </thread>
       (.Bag => <thread> <k> P1 </k> </thread>)
       (.Bag => <thread> <k> P2 </k> </thread>)               //[structural]


  rule <thread> <k> P1:ProcPat | P2:ProcPat => . ...</k> </thread>
       (.Bag => <thread> <k> P1 </k> </thread>)
       (.Bag => <thread> <k> P2 </k> </thread>)               //[structural]

// SEND OPERATOR SEMANTICS
  rule <k> X:Name ! ( P:Proc ) =>  . ...</k>                  //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>
                  <schan> X </schan>                          //sending channel X
                  <msg>   P   </msg>                          //message sent @P
                </send>)                                      //[structural]

  rule <k> X:Name ! T:RhoTuple =>  . ...</k>                  //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>
                  <schan> X </schan>                          //sending channel X
                  <msg>   T   </msg>                          //message sent @P
                </send>)                                      //[structural]

// RECEIVE OPERATOR SEMANTICS
  rule <k>  for( R:Receipt ) { P:Proc } => . ...</k> //dissolve Rec in <threadpool/> and spawn <rec/>
       (.Bag => <rec>
                  <bind> R </bind>
                  <cont> P  </cont>                           //continuation P
                </rec>)                                       //[structural]

// REDUCTION RULES

// COMM EVENT
// Comm: x!(Q) | x(y){P} => P[@Q / y]
  rule                                                        //dissolve send and receive on "same" channel
  (<rec>                                                      //dissolve receive:
     <rchan> X:Name </rchan>                                  // channel X
     <bvar>  Y:Name  </bvar>                                  // binding variable Y
     <cont>  P:Proc  </cont>                                  // continuation P
   </rec> => .Bag)
  (<send>                                                     //dissolve send:
     <schan> X    </schan>                                    // channel X
     <msg>   Z:Proc </msg>                                    // message Z
   </send> => .Bag)
  (.Bag => <thread> <k> P[@Z / Y] </k> </thread>)             //spawn single <thread/> holding sub P[Z / Y]
  [comm]                                                      //tagged "comm" for tracking nondeterminism

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

// Clean up parred expressions
  rule        P:Proc | Nil => P                 [structural]  //Nils in <k/>
  rule <cont> P:Proc | Nil => P </cont>         [structural]  //Nils in <cont/>

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag  [structural]  //empty threads
  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)

// NAME REDUCTIONS
rule @ * N:Name => N                              [anywhere]

endmodule
