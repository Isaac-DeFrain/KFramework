// RHO CALCULUS with Bool, Int, String ground terms and Rholang features in a monadic style
/*
TODO:
 - Par as multiset
 - Unite process & name variables
 - Matching (patterns & wildcard)
 - Environments for new declarations, global store for location, & location counter cell
 - Finish methods
 - add contract invocation(?): Name "(" ProcList ")" - syntactic sugar for cell pattern
 - add sequential listen semantics
 - write functions to extract the list of variables requiring substitution from the listening list 
   and the corresponding list of values to substitute, given the listening list (binding variables) 
   and substitution values (messages)
*/

require "domains.k"
require "substitution.k"
//require "AuxFun/auxfun.k"

// SYNTAX MODULE
module GRHO-SYNTAX
  import DOMAINS
  import SUBSTITUTION
  import KAST
  import KSEQ-SYMBOLIC

// Variables
  syntax             Var ::= Id

//-------------
//--- NAMES ---
//-------------
  syntax             Name ::= Quote
                            | NorQVar
                            | "EmptyMsg"     // listening for empty messages
  syntax          NameVar ::= Var            // name variable
  syntax            Quote ::= "@" Proc
  syntax         QuoteVar ::= "@" ProcVar  [klabel(qv)]
  syntax          NorQVar ::= NameVar | QuoteVar

// Several Names
  syntax            Names ::= Name "," Name
                            | Name "," Names

  syntax         NameVars ::= NameVar "," NameVar   [klabel(nv)]
                            | NameVar "," NameVars  [klabel(nv)]

  syntax         NorQVars ::= NorQVar "," NorQVar   [klabel(nqv)]
                            | NorQVar "," NorQVars  [klabel(nqv)]

  syntax         NameList ::= Name | Names | NameVarList | NorQVarList
  syntax      NameVarList ::= NameVar | NameVars
  syntax      NorQVarList ::= NorQVar | NorQVars

//-----------------
//--- PROCESSES ---
//-----------------
  syntax             Proc ::= NonParProc > Par

  syntax       NonParProc ::= "{" Proc "}"    [bracket]
                            > New             // New name declaration(s)
                            > "Nil"           // Stopped process
                            | Collection      // Data structures - List, Map, Set, Tuple
                            | Ground          // Ground terms - Bool, Int, String, Uri
                            | ProcVar         // Process variable
                            | EvalVar         // Process variable
                            > VarRef          // Variable references - Name/Process variable shadowing
                            > Eval            // Evaluation
                            > MethodProc      // Methods
                            > AExp            // Arithmetic expressions
                            > BExp            // Boolean expressions
                            > Match           // Process matching
                            > Receive         // Receive messages
                            | Contract        // Contract
                            | Invocation      // Contract invocation
                            | Send            // Send messages
                            | Bundle          // Process bundle
                            > Conditional     // If...then(...else)

// Process Variables
  syntax          ProcVar ::= Var
  syntax         ProcVars ::= ProcVar "," ProcVar   [klabel(pv)]
                            | ProcVar "," ProcVars  [klabel(pv)]

  syntax      ProcVarList ::= ProcVar | ProcVars

// Several Processes
  syntax            Procs ::= Proc "," Proc   [strict]
                            | Proc "," Procs  [strict]
                            | ProcVars

  syntax         ProcList ::= Proc | Procs | ProcVarList

// Parallel composition
// Pars should be like a multiset of processes...
  syntax              Par ::= Proc "|" Proc  [left]

// Receives - no mixed linear/peek/repeated/sequential
// TODO: Input guards - e.g. for( y <- x if *y > 0 ){ ... }
  syntax          Receive ::= SingleRec | MultiRec

  // Single listen receives
  syntax        SingleRec ::= "for" "(" Bind  ")" "{" Proc "}"
                            | GuardedSingleRec
  syntax GuardedSingleRec ::= "for" "(" GuardedBind ")" "{" Proc "}"
  syntax            Guard ::= "if" BExp           [strict]
  // Linear listen
  syntax            Lbind ::= NameList "<-" Name  [strict(2)]
                            |          "<-" Name  [strict]
  // Peek listen
  syntax            Pbind ::= NameList "<!" Name  [strict(2)]
                            |          "<!" Name  [strict]
  // Repeated/Persistent listen
  syntax            Rbind ::= NameList "<=" Name  [strict(2)]
                            |          "<=" Name  [strict]
  // Sequential listen
  syntax            Sbind ::= NameList "<<" Name  [strict(2)]
                            |          "<<" Name  [strict]

  syntax             Bind ::= Lbind | Pbind | Rbind | Sbind

  // Multiple listen receives
  syntax         MultiRec ::= "for" "(" Binds ")" "{" Proc "}"
                            | GuardedMultiRec
  syntax  GuardedMultiRec ::= "for" "(" GuardedBinds ")" "{" Proc "}"

  syntax           Lbinds ::= Lbind ";" Lbind
                            | Lbind ";" Lbinds
  syntax           Pbinds ::= Pbind ";" Pbind
                            | Pbind ";" Pbinds
  syntax           Rbinds ::= Rbind ";" Rbind
                            | Rbind ";" Rbinds
  syntax           Sbinds ::= Sbind ";" Sbind
                            | Sbind ";" Sbinds

  syntax            Binds ::= Lbinds | Pbinds | Rbinds | Sbinds
  syntax         BindList ::= Bind | Binds
  syntax      GuardedBind ::= Bind Guard
  syntax     GuardedBinds ::= Binds Guard
  syntax         AnyBinds ::= Bind | Binds | GuardedBind | GuardedBinds

// Sends
  syntax             Send ::= ConsumableSend | UnconsumableSend
  syntax   ConsumableSend ::= Name "!"  "(" ProcList ")"
                            | Name "!"  "(" ")"
  syntax UnconsumableSend ::= Name "!!" "(" ProcList ")"
                            | Name "!!" "(" ")"

// Eval
  syntax             Eval ::= "*" Name     [strict]
  syntax          EvalVar ::= "*" NameVar  [klabel(ev)]

// New - creates unforgeable names
  syntax              New ::= "new" NameVarList "in" "{" Proc "}"  [binder]

// Match
  syntax            Match ::= "match" Proc "{" MatchCaseList "}"
  syntax        MatchCase ::= Proc ":=>" Proc       [strict(2)]
  syntax       MatchCases ::= MatchCase MatchCase
                            | MatchCase MatchCases
  syntax    MatchCaseList ::= MatchCase | MatchCases

// Variable Reference - allows for shadowing
  syntax           VarRef ::= "=" "*" NameVar
                            | "=" ProcVar

// Conditional
  syntax      Conditional ::= IfThen | Else

  syntax           IfThen ::= "if" "(" BExp ")" "then" Proc  [strict(1)]
  syntax             Else ::= IfThen "else" Proc

// Contract
  syntax         Contract ::= "contract" Name "(" NameList ")" "=" "{" Proc "}"  // sugar for persistent receive
                            | "contract" Name "(" ")" "=" "{" Proc "}"

// Contract Invocation
  syntax       Invocation ::= Name "(" ProcList ")"
                            | Name "(" ")"

// Collections - data structures
  syntax       Collection ::= RhoList | RhoMap | RhoSet | RhoTuple

  // Process lists
  syntax          RhoList ::= "[" ProcList "]"
                            | "[" "]"

  // Process maps
  syntax           RhoMap ::= "{" RhoKVPairList "}"
                            | "{" "}"

  syntax        RhoKVPair ::= Proc ":" Proc
  syntax       RhoKVPairs ::= RhoKVPair "," RhoKVPair
                            | RhoKVPair "," RhoKVPairs
  syntax    RhoKVPairList ::= RhoKVPair | RhoKVPairs

  // Process sets
  syntax           RhoSet ::= "Set" "(" ProcList ")"
                            | "Set" "(" ")"

  // Process tuples
  syntax         RhoTuple ::= "(" ProcList ")"  [klabel(tuple)]
                            | "(" ")"           [klabel(tuple)]

// Ground terms
  syntax           Ground ::= Bool | Int | String | Uri
  syntax              Uri ::= "uri(" String ")"

// AExp & BExp resolve to ground terms
// Arithmetic
  syntax             AExp ::= "{" AExp "}"
                            > Int
                            | Eval            // for interesting message passing, e.g. for( y <- x ){ *y + 5 }
                            | String
                            | AExp "++" AExp  // string concatenation, e.g. for( y <- x1 ; z <- x2 ){ *y ++ *z }
                            > "-" AExp        [strict]
                            > AExp "*"  AExp  [strict]
                            | AExp "/"  AExp  [strict]
                            > AExp "+"  AExp  [strict]
                            | AExp "-"  AExp  [strict]
                            | AExp "%"  AExp  [strict] // mod reduction
                           // String interpolation: "${key}rest" %% { key:value , ... } => "value" ++ "rest"

// Boolean
  syntax             BExp ::= "{" BExp "}"
                            > Bool
                            | Eval
                            | String
                            | AExp "<=" AExp        [seqstrict]
                            | AExp "<"  AExp        [seqstrict]
                            | AExp ">=" AExp        [seqstrict]
                            | AExp ">"  AExp        [seqstrict]
                            | Proc "matches" Proc   // P matches Q is syntactic sugar for: match P { Q :=> true _ :=> false }
                            | Name "==" Name        // name equivalence
                            | Name "!=" Name        // not ( Name == Name )
                            | Proc "==" Proc        // structural equivalence
                            | Proc "!=" Proc        // not ( Proc == Proc )
                            > "not" BExp            [strict]
                            > BExp "and" BExp       [strict(1)]
                            > BExp "or"  BExp       [strict(1)]

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}"   // write-only
                            | "bundle-" "{" Proc "}"   // read-only
                            | "bundle0" "{" Proc "}"   // neither read/write
                            | "bundle"  "{" Proc "}"   // both read/write

// #isProc Predicate
  syntax             Bool ::= "#isProc(" K ")"
                            | "#isName(" K ")"

// Methods
  syntax       MethodProc ::= Proc "." Method "(" ProcList ")" [strict(1)]
                            | Proc "." Method "(" ")"          [strict(1)]  

  syntax           Method ::= "nth"          // nth element - list, string(?), tuple - Proc.nth( Int ) 
                            | "toByteArray"  // transform to bytearray - Data.toByteArray( )
                            | "hexToBytes"   // hex string -> bytes
                            | "union"        // map, set union - Map.union( Map ) , Set.union( Set )
                            | "diff"         // difference - map, set?
                            | "add"          // add - like single element concat? - list, map, set?
                            | "delete"       // delete element? - list, map, set
                            | "contains"     // contains predicate
                            | "get"          // get - get value corresponding to key - Map.get( Key )
                            | "getOrElse"    // getOrElse - get or side condition - Map.getOrElse( Key , SideCondition )
                            | "set"          // set - Map.set( Key , Value )
                            | "contains"     // contains predicate - list, map, set?
                            | "keys"         // set of keys of a map - map.keys( )
                            | "values"       // list of values of a map - map.values( )
                            | "size"         // number of elements in unordered structures - Map.size(), Set.size()
                            | "length"       // length of list, tuple - List.length() , Tuple.length()
                            | "slice"        // slice of list, string - List.slice(I1,I2) , String.slice(I1,I2)
                            | "iterate"      // semantics? - list and tuple?
                            | "confine"      // semantics?

// Builtins are processes too
  syntax             Proc ::= List | Map | Set
  syntax              Map ::= RhoMap
  syntax              Set ::= RhoSet

// For handling joins in configuration
  syntax         JoinList ::= "{[" Proc ";" Int     "]}"     // for uniform join id
  syntax          ChanLen ::= "("  Name ";" Int      ")"     // (listening channel ; number of variables to bind)
  syntax         ChanList ::= "("  Name ";" NameList ")"     // (listening channel ; variable(s) to bind)
  syntax            IdNum ::= Int ";" Int                    // _;_: Int x Int ------> IdNum < KItem
  syntax          BindOcc ::= Name ";" Int       ";;" Int    // listening channel; number of variables to bind; number of occurences
                            | Name ";" NameList  ";;" Int    // listening channel; variable(s) to bind; number of occurences
  syntax             Proc ::= ChanLen | BindOcc | JoinList   // definitions

  syntax        KVariable ::= NameVar | ProcVar
                            | Int  // for map substitutions

  syntax            KItem ::= Name | Names | Proc | Procs | IdNum

// For #parmatch predicate
  syntax ThreadsCell
  syntax ThreadsCellFragment

  syntax Proc ::= "#compare(" Proc ";" Proc ")"
                | "#compare(" Proc ")"
                | "#compare(" ThreadsCellFragment ")"
                | "#compare(" ThreadsCellFragment ";" ThreadsCellFragment ")"
                | "#parremove(" NonParProc ";" Proc ")" [function]

  syntax  Int ::= "#parcount(" NonParProc ";" Proc ")" [function]
  syntax  Set ::= "#setify(" Proc ")" [function]

  syntax Bool ::= "#parmatch(" Proc ";" Proc ")" [function]

endmodule

// SEMANTICS MODULE
module GRHO
  import GRHO-SYNTAX
//  import AUXFUN

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">
      <k> $PGM:Proc </k>
      <threads color="red">
        <thread color="green" multiplicity="*">
          .K
        </thread>
      </threads>
    </T> 

  syntax KResult ::= Ground | Eval | List | Map | Set

  syntax      Ground ::= Unforgeable
  syntax Unforgeable ::= "unforgeable(" Int ")"

// Par Operator Semantics - concurrent execution of processes
/*  rule <k> P:Proc | Q:Proc => . ...</k>
       (.Bag => <thread> P </thread>)
       (.Bag => <thread> Q </thread>)
  rule <thread> P:Proc | Q:Proc => P ...</thread>
       (.Bag => <thread> Q </thread>)

  rule #compare( P:Proc ; Q:Proc ) => P ~> #compare(Q)
  rule #compare( P:Proc ; Q:Proc ) => Q ~> #compare(P)

  rule <k> #compare( Q:Proc ) => Q ~> #compare(T) ...</k>
       <threads> T => .Bag </threads>
  rule <k> #compare( S:ThreadsCellFragment ) => #compare( S ; T ) ...</k>
       <threads> T => .Bag </threads>

  rule #compare( S:ThreadsCellFragment ; T:ThreadsCellFragment ) => S ==K T
*/
//---------------
//--- #parmatch ---
//---------------
  rule #parcount( A ; B:NonParProc ) => #if A ==K B #then 1 #else 0 #fi
  rule #parcount( A ; B | C:NonParProc ) => #if A ==K C #then 1 +Int #parcount(A;B) #else #parcount(A;B) #fi

  rule #parremove( A ; B:NonParProc ) => #if A ==K B #then Nil #else B #fi
  rule #parremove( A ; B | C:NonParProc ) => #if A ==K C #then #parremove(A;B) #else #parremove(A;B) | C #fi

  rule #setify( A:NonParProc ) => SetItem(A,1)
  rule #setify( A | B:NonParProc ) 
    => #if B ==K Nil
       #then #setify(A)
       #else
         #if #parcount(B;A) >Int 0 
         #then SetItem(B, 1 +Int #parcount(B;A)) (#setify(#parremove(B;A)) -Set SetItem(Nil,1))
         #else SetItem(B,1) (#setify(A) -Set SetItem(Nil,1)) 
         #fi 
       #fi

  rule #parmatch( P:Proc ; Q:Proc ) => #setify(P) <=Set #setify(Q) andBool #setify(Q) <=Set #setify(P)

/*
//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule <thread>
         <k> S:Send => . ...</k>   // dissolve send in <threads/> and spawn <send/>
         <env> B:Map </env>        // thread environment
       </thread> 
       <store> M:Map </store>      // global store
       (.Bag => <send>
                  <schan>   #chan(S)[B[M]] </schan>  // sending channel
                  <msg>      #msg(S)[B[M]]   </msg>  // sending message(s)
                  <tuple> #length(#msg(S)) </tuple>  // number of messages
                  <stype>       #stype(S)  </stype>  // send type
                  <sbind>              B   </sbind>
                </send>)

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
//TODO: environments
  rule <thread>
         <k> R:SingleRec => . ...</k>  // dissolve Rec in <threads/> and spawn <rec/>
         <env>  B:Map  </env>
       </thread>
       <store> M:Map </store>
       (.Bag => <rec>
                  <rchan>  #chan(R)[B[M]] </rchan>  // receiving channel
                  <bvars>  #bvar(R)[B[M]] </bvars>  // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)        </bnum>  // 
                  <rtype> #rtype(R)       </rtype>  // receive type
                  <cont>   #cont(R)[B[M]]  </cont>  // continuation
                  <rbind>        B        </rbind>
                </rec>)

// Joins
  rule <thread>
         <k> R:MultiRec => . ...</k>
         <env>  B:Map  </env>
       </thread>
       <store> M:Map </store>
       (.Bag => <rec>
                  <rchan>  #chan(R)[B[M]] </rchan>  // receiving channel
                  <bvars>  #bvar(R)[B[M]] </bvars>  // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)        </bnum>  // number of variables to bind
                  <rtype> #rtype(R)       </rtype>  // receive type
                  <cont>   #cont(R)[B[M]]  </cont>  // continuation
                  <rbind>        B        </rbind>
                </rec>)

//-------------------
//--- COMM EVENTS ---
//-------------------
// x!(Q) | y(z){P} /\ x equivN y => P[@Q / y]

// TODO: what should be done with environment maps?
// TODO: how can we only substitute for variables and not values?
// Reaction Cell Semantics - quarantined reaction cell for processing comm events
// N substitutions, N > 2
  rule 
    <reaction>
      <who>    P:Proc => P[@ Q / Y]    </who>  // substitute @Q for Y
      <what>   Q:Proc , R:Procs => R  </what>  // delete Q from list of values to substitute
      <where>  Y:Name , Z:Names => Z </where>  // delete Y from list of variables needing substitution
      <update> M => M[ Y <-undef ]  </update>  // delete Y |-> M[Y] from the map
    </reaction>
    <store>... M[Y] |-> (_ => @Q) ...</store>  [react]

// 2 substitutions
  rule
    <reaction>
      <who>    P:Proc => P[@ Q / Y]    </who>
      <what>   Q:Proc , R:Proc => R   </what>
      <where>  Y:Name , Z:Name => Z  </where>
      <update> M => M[ Y <- undef ] </update>  // delete Y |-> M[Y] from the map
    </reaction>
    <store>... M[Y] |-> (_ => @Q) ...</store>  [react]

// Final substitution: spawn in a new thread holding the fully substituted continuation
  rule
    <reaction>
      <who>    P:Proc =>  .K     </who>
      <what>   Q:Proc =>  .K    </what>
      <where>  Y:Name =>  .K   </where>
      <update> M:Map  => .Map </update>
    </reaction>
    <store>... M[Y] |-> (_ => @Q) ...</store>
   (.Bag => <thread> <k> P[@ Q / Y] </k> <env> M </env> </thread>)  [react]

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
*/
// Join semantics seem to be much more complicated than single listens...
// moved progress to join.k
/*
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
  rule L:List .length( ) => size(L)

  rule ( ):RhoTuple .length( ) => 0
  rule tuple( P:ProcList ) .length( ) => #length(P)

  // mapkeys (maps)
  rule M:Map .keys( ) => keys( M )
  
  // nth (lists & tuples)
  rule L:List .nth( I:Int ) => L[I]

  rule ( ):RhoTuple.nth( _ ) => Nil
  rule tuple( P:Proc ).nth( I:Int ) => #if I ==Int 0 #then P #else Nil #fi
  rule tuple( P:Proc , Q:Proc  ).nth( I:Int ) => #if I ==Int 0 #then P #else tuple( Q ).nth( I -Int 1 ) #fi
  rule tuple( P:Proc , Q:Procs ).nth( I:Int ) => #if I ==Int 0 #then P #else tuple( Q ).nth( I -Int 1 ) #fi
  
  // set (maps)
  rule M:Map .set( Key:Proc , Val:Proc ) => updateMap( M , Key |-> Val)
  
  // size (maps & sets)
  rule M:Map .size( ) => size(M)
  rule S:Set .size( ) => size(S)

  // slice (lists & strings)
  rule S:String .slice( A:Int , B:Int ) => substrString( S , A , B )
  rule L:List .slice( A:Int , B:Int ) => range( L , A , B )

  // toByteArray
  
  // values (maps)
  rule M:Map .values( ) => values(M)

  // union (maps & sets)
  rule M1:Map .union( M2:Map ) => M1 M2
  rule S1:Set .union( S2:Set ) => S1 S2
*/
// Eliminate unnecessary Nils
  rule Nil => .K  [structural]

// Dissolve computationally meaningless threads
  rule <thread> .K </thread> => .Bag  [structural] //empty threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

  rule #isProc( A:K ) => isProc(A)
  rule #isName( A:K ) => isName(A)

endmodule