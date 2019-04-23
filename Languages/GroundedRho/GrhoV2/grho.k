// RHO CALCULUS with Bool, Int, String ground terms and Rholang features in a monadic style
/*
TODO:
 - Remove store cell
 - Par
 - Unite process & name variables
 - Matching (patterns & wildcard)
 - Environments for new declarations, global store for location, & location counter cell
 - Finish methods
 - handle variable reference before sending to tuplespace
 - add contract invocation(?): Name "(" ProcList ")" - syntactic sugar for cell pattern
 - add sequential listen semantics
 - move Unforgeables to semantics module?
*/

require "domains.k"
require "substitution.k"
require "AuxFun/auxfun.k"

// SYNTAX MODULE
module GRHO-SYNTAX
  import DOMAINS
  import SUBSTITUTION

//-----------------
//--- VARIABLES ---
//-----------------
  syntax  Var ::= Id
  syntax  Ids ::= List{Id,","}
  syntax Vars ::= List{Var,","} | Ids
  
  syntax ProcOrNameVar ::= ProcVar | NameVar

//-------------
//--- NAMES ---
//-------------
  syntax             Name ::= Chan                    // quoted process
                            | NameVar                 // name variable
                            | "EmptyMsg"              // for listening for empty messages

  syntax          NameVar ::= Var
                            | QuoteVar
  syntax             Chan ::= Quote
                            | Unforgeable
  syntax            Quote ::= "@" Proc                [klabel(chan)]
  syntax         QuoteVar ::= "@" ProcVar             [klabel(qvar)]
  syntax      Unforgeable ::= "unforgeable(" Int ")"

  syntax            Names ::= List{Name,","}
                            | NameVars
  syntax         NameVars ::= List{NameVar,","}
                            | Vars

//-----------------
//--- PROCESSES ---
//-----------------
  syntax             Proc ::= "{" Proc "}"    [bracket]
                            > New
                            > "Nil"
                            | Collection
                            | Ground
                            > ProcVar
                            > VarRef
                            > Eval
                            > MethodProc
                            > AExp
                            | BExp
                            > Match
                            > Receive
                            | Contract
                            | Invocation
                            | Send
                            | Bundle
                            > Conditional
                            > Par

  syntax          ProcVar ::= Var | EvalVar
  syntax         ProcVars ::= List{ProcVar,","} | Vars
  syntax            Procs ::= List{Proc,","} | ProcVars

// Eval
  syntax             Eval ::= "*" Name      [klabel(eval)]
  syntax          EvalVar ::= "*" NameVar   [klabel(evar)]

// Parallel composition
// Pars should be like a multiset of processes
  syntax              Par ::= Proc "|" Proc   [left]

// Receives
// TODO: Input guards - e.g. for( y <- x if *y > 0 ){ ... } - so comm only occurs for certain messages
  syntax          Receive ::= SingleRec | MultiRec

  syntax        SingleRec ::= "for" "(" Bind  ")" "{" Proc "}"
                            | GuardedSingleRec

  syntax GuardedSingleRec ::= "for" "(" GuardedBind ")" "{" Proc "}"
  syntax         MultiRec ::= "for" "(" Binds ")" "{" Proc "}"
                            | GuardedMultiRec

  syntax  GuardedMultiRec ::= "for" "(" GuardedBinds ")" "{" Proc "}"
  syntax            Guard ::= "if" BExp

  syntax            Lbind ::= Names "<-" Name
                            |       "<-" Name
  syntax           Lbinds ::= Lbind ";" Lbind
                            | Lbind ";" Lbinds

  syntax            Pbind ::= Names "<!" Name
                            |       "<!" Name
  syntax           Pbinds ::= Pbind ";" Pbind
                            | Pbind ";" Pbinds

  syntax            Rbind ::= Names "<=" Name
                            |       "<=" Name
  syntax           Rbinds ::= Rbind ";" Rbind
                            | Rbind ";" Rbinds

  syntax            Sbind ::= Names "<<" Name
                            |       "<<" Name
  syntax           Sbinds ::= Sbind ";" Sbind
                            | Sbind ";" Sbinds

  syntax             Bind ::= Lbind | Pbind | Rbind | Sbind
  syntax            Binds ::= Lbinds | Pbinds | Rbinds | Sbinds

  syntax         BindList ::= Bind | Binds

  syntax      GuardedBind ::= Bind Guard
  syntax     GuardedBinds ::= Binds Guard
  
  syntax         AnyBinds ::= Bind
                            | Binds
                            | GuardedBind
                            | GuardedBinds

// Sends
  syntax             Send ::= ConsumableSend | UnconsumableSend

  syntax   ConsumableSend ::= Name "!"  "(" Procs ")"
                            | Name "!"  "(" ")"

  syntax UnconsumableSend ::= Name "!!" "(" Procs ")"
                            | Name "!!" "(" ")"

// New
  syntax              New ::= "new" NameVars "in" "{" Proc "}"  [binder] // creates unforgeable names

// Match
  syntax            Match ::= "match" Proc "{" MatchCases "}"
  syntax        MatchCase ::= Proc ":=>" Proc     [strict(2)]
  syntax       MatchCases ::= List{MatchCase," "}

// Variable Reference
  syntax           VarRef ::= "=" ProcVar
                            | "=" "*" NameVar

// Conditional
  syntax      Conditional ::= IfThen | Else
  syntax           IfThen ::= "if" "(" BExp ")" "then" Proc  [strict(1)]
  syntax             Else ::= IfThen "else" Proc

// Contract
  syntax         Contract ::= "contract" Name "(" Names ")" "=" "{" Proc "}"
                            | "contract" Name "(" ")" "=" "{" Proc "}"

// Contract Invocation
  syntax       Invocation ::= Name "(" Procs ")"
                            | Name "(" ")"

// Collections
  syntax       Collection ::= RhoList | RhoMap | RhoSet | RhoTuple

  syntax          RhoList ::= "[" Procs "]"  [klabel(list)]

  syntax           RhoMap ::= "{" RhoKVPairs "}"   [strict]
  syntax        RhoKVPair ::= Proc ":" Proc       // key-value pair
  syntax       RhoKVPairs ::= List{RhoKVPair,","}  [strict]

  syntax           RhoSet ::= "Set" "(" Procs ")"  [strict]

  syntax         RhoTuple ::= "(" Procs ")"  [strict, klabel(tuple)]

// Ground terms
  syntax           Ground ::= Bool | Int | String | Uri

  syntax              Uri ::= "uri(" String ")"

// AExp & BExp resolve to ground terms
// Arithmetic
  syntax             AExp ::= "{" AExp "}"
                            > Int
                            | Eval                // for interesting message passing, e.g. for( y <- x ){ *y + 5 }
                            | String
                            | AExp "++" AExp      // string concatenation
                            > "-" AExp            [strict]
                            > AExp "*"  AExp      [strict]
                            | AExp "/"  AExp      [strict]
                            > AExp "+"  AExp      [strict]
                            | AExp "-"  AExp      [strict]
                            | AExp "%"  AExp      [strict] // mod reduction
                           // String interpolation: "${key}..." %% { key:value } => "value" ++ "..."

// Boolean
  syntax             BExp ::= "{" BExp "}"
                            > Bool
                            | Eval
                            | String
                            | AExp "<=" AExp      [seqstrict]
                            | AExp "<"  AExp      [seqstrict]
                            | AExp ">=" AExp      [seqstrict]
                            | AExp ">"  AExp      [seqstrict]
                            | Proc "matches" Proc  // P matches Q is syntactic sugar for: match P { Q :=> true _ :=> false }
                            | Name "==" Name      // name equivalence
                            | Name "!=" Name
                            | Proc "==" Proc      // structural equivalence
                            | Proc "!=" Proc
                            > "not" BExp          [strict]
                            > BExp "and" BExp     [strict(1)]
                            > BExp "or"  BExp     [strict(1)]

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}" // write-only
                            | "bundle-" "{" Proc "}" // read-only
                            | "bundle0" "{" Proc "}" // neither read/write
                            | "bundle"  "{" Proc "}" // both read/write

// #isProc Predicate
  syntax             Bool ::= "#isProc(" K ")"  // sort predicate
                            | "#isName(" K ")"  // sort predicate

// Methods
  syntax       MethodProc ::= Proc "." Method "(" Procs ")" [strict(1)]
                            | Proc "." Method "("  ")"      [strict(1)]

  syntax           Method ::= "nth"           // nth element in list, string, tuple // syntax: Thing.nth( Int ) 
                            | "toByteArray"   // transform to bytearray - Thing.toByteArray( )
                            | "hexToBytes"    // hex string -> bytes
                            | "union"         // map, set union - Map.union( Map ) , Set.union( Set )
                            | "diff"          // map, set difference?
                            | "add"           // add proc/ like single element concat? - list, set?
                            | "delete"        // delete element? - list, map, set
                            | "contains"      // contains predicate
                            | "get"           // get - map - get value corresponding to key or Nil
                            | "getOrElse"     // getOrElse - map - get or side condition
                            | "set"           // set - map.set( Key , Value )
                            | "contains"      // contains predicate - 
                            | "keys"          // set of keys of a map - map.keys( )
                            | "values"        // list of values of a map - map.values( )
                            | "size"          // number of elements in unordered structures - Map.size(), Set.size()
                            | "length"        // length of list, tuple - List.length() , Tuple.length()
                            | "slice"         // slice of list, string - List.slice(I1,I2) , String.slice(I1,I2)
                            | "iterate"       // semantics? - list
                            | "confine"       // semantics?

// Builtins are processes too
  syntax             Proc ::= List | Map | Set
  syntax              Map ::= RhoMap
  syntax              Set ::= RhoSet

// KVariables & KItems
  syntax        KVariable ::= Proc | Procs | Var | Vars
  syntax            KItem ::= Name | Names | Proc | Procs | IdNum

// For handling joins in the configuration
  syntax         JoinList ::= "{[" Proc ";" Int   "]}"  // for uniform join id
  syntax          ChanLen ::= "("  Name ";" Int   ")"   // (listening channel ; number of variables to bind)
  syntax         ChanList ::= "("  Name ";" Names ")"   // (listening channel ; variable(s) to bind)
  syntax            IdNum ::= Int ";" Int
  syntax          BindOcc ::= Name ";" Int    ";;" Int  // listening channel; number of variables to bind; number of occurences
                            | Name ";" Names  ";;" Int  // listening channel; variable(s) to bind; number of occurences

  syntax             Proc ::= ChanLen | BindOcc | JoinList  // for auxfun definitions

endmodule

// SEMANTICS MODULE
module GRHO
  import GRHO-SYNTAX
  import AUXFUN

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                               //
      <threads color="red">                                          //**activity threads**
        <thread color="green" multiplicity="*">                      // collection of threads (concurrent activity)
          <k>  $PGM:Proc </k>                                        // programs and computations are process-based
          <env>  .Map  </env>                                        // thread local environment
        </thread>                                                    //
      </threads>                                                     //**tuplespace**
      <tuplespace color="blue">                                      // stores sends and receives
        <sends>                                                      //**sends**
          <send color="cyan" multiplicity="*">                       //
            <schan>  .K  </schan>                                    // sending channel (many messages on same channel)
            <msg>    .K    </msg>                                    // sent messages
            <tuple>  .K  </tuple>                                    // equals N if N-tuple - for arity matching
            <stype>  .K  </stype>                                    // 0 for single send (consumed), 1 for persistent send (not consumed)
            <sbind> .Map </sbind>                                    // 
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
            <rbind> .Map </rbind>                                    // 
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction color="violet">                                      //**comm events are processed here before being released back into the wild**
        <who>     .K     </who>                                      // continuation process
        <what>    .K    </what>                                      // msg process(es)
        <where>   .K   </where>                                      // binding variable(s)
        <update> .Map </update>                                      // updated variable binding(s)
      </reaction>                                                    // all comms are processed here
      <store color="pink"> .Map  </store>                            // 
      <nextLoc color="gray"> 0 </nextLoc>                            // 
    </T>                                                             // 

  syntax KResult ::= Ground | Eval | Proc | Procs 
                   | Name | Names | List | Map | Set

// Relation to built-ins
  syntax List ::= "#makeList(" RhoList ")"    [function]

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

// Syntactic equality
  rule A:Ground == B:Ground => A ==K  B                   [anywhere] // equality of ground terms
  rule A:Ground != B:Ground => A =/=K B                   [anywhere] // inequality of ground terms

// Collections
  //context (HOLE:RhoList => #makeList(HOLE)) . _:Method ( _:MethodArgs )
  rule [ P:Procs ] => #makeList([P])
  rule #makeList([ .Procs ]) => .List
  rule #makeList([ P:Proc , Q:Procs ]) => ListItem(P) #makeList([Q])

  // RhoMaps are interpreted as built-in Maps
  //  context HOLE:RhoMap => #makeMap(HOLE)
  rule { .RhoKVPairs }:RhoMap => .Map                     [structural]
  rule { P:Proc : Q:Proc , R:RhoKVPairs } => P |-> Q {R}  [structural]

  // RhoSets are interpreted as built-in Sets
  //  context HOLE:RhoSet => #makeSet(HOLE)
  rule Set( .Procs ) => .Set                         [structural]
  rule Set( P:Proc , Q:Procs ) => SetItem(P) Set(Q)  [structural]

// Conditionals - short-circuited
  rule if ( true  ) then P:Proc => P              [structural]
  rule if ( false ) then _:Proc => Nil            [structural]
  rule if ( true  ) then P:Proc else _:Proc => P  [structural]
  rule if ( false ) then _:Proc else Q:Proc => Q  [structural]

// Matching
  // "matches" binop desugars into "match" statement
  rule P:Proc matches Q:Proc => match P { Q :=> true P :=> false }  [structural]
  
  // TODO: replace ==K with structural equivalence
  rule match P:Proc { .MatchCases } => Nil
  rule match P:Proc { Q:Proc :=> R:Proc M:MatchCases } => #if P ==K Q #then R #else match P { M } #fi

// New Operator Semantics
// like blocks with local variable declarations
// nested variable declarations will shadow each other
  syntax KItem ::= "undefined"  // declared as a variable, but not assigned a value yet

  rule <k> new .NameVars in { P:Proc } => P ~> setEnv(Env) ...</k>
       <env> Env </env>
       
  rule <k> new M:NameVar , N:NameVars in { P:Proc } => new N in { P } ...</k>
       <env> Env => Env[M <- L] </env>
       <store>... .Map => L |-> undefined ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

// Resetting the environment
  syntax KItem ::= setEnv(Map)
  rule <k> setEnv(Env) => . ...</k> <env> _ => Env </env>  [structural]
  
  // if there are multiple sequential Env resets
  rule (setEnv(_) => .) ~> setEnv(_)  [structural]

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
  rule contract X:Name ( Y:Names ) = { P:Proc } => for (      Y <= X ){ P }  [anywhere, structural]
  rule contract X:Name (  ) = { P:Proc }        => for ( .Names <= X ){ P }  [anywhere, structural]

// Par Operator Semantics - concurrent execution of processes
  rule <thread>
         <k> P:Proc | Q:Proc => . ...</k>
         <env> Env </env>
       </thread>
       (.Bag => <thread> <k> P </k> <env> Env </env> </thread>)
       (.Bag => <thread> <k> Q </k> <env> Env </env> </thread>)

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
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
//TODO: 
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
/*
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
*/
//-------------------
//--- COMM EVENTS ---
//-------------------
// x!(Q) | y(z){P} /\ x equivN y => P[@Q / y]

// TODO: what should be done with environment maps?
// Reaction Cell Semantics - quarantined reaction cell for processing comm events
// N substitutions, N > 2
  rule 
    <reaction>
      <who>    P:Proc => P[@ Q / Y]    </who>
      <what>   Q:Proc , R:Procs => R  </what>
      <where>  Y:Name , Z:Names => Z </where>
      <update> M => M[ Y <-undef ]  </update>
    </reaction>
    <store>... M[Y] |-> (_ => @Q) ...</store>  [react]

// 2 substitutions
  rule
    <reaction>
      <who>    P:Proc => P[@ Q / Y]    </who>
      <what>   Q:Proc , R:Proc => R   </what>
      <where>  Y:Name , Z:Name => Z  </where>
      <update> M => M[ Y <- undef ] </update>
    </reaction>
    <store>... M[Y] |-> (_ => @Q) ...</store>  [react]

// Final substitution spawn in a new thread holding the fully substituted continuation
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

// Join semantics seem to be much more complicated than single listens...
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
  rule L:List .length( ) => size(L)
  rule ( P:Procs ).length( ) => #length(P)

  // mapkeys (maps)
  rule M:Map .keys( ) => keys( M )
  
  // nth (lists & tuples)
  rule L:List .nth( I:Int ) => L[I]

  rule ( .Procs ).nth( _ ) => Nil
  rule ( P:Proc , Q:Procs ).nth( I:Int ) => #if I ==Int 0 #then P #else ( Q ).nth( I -Int 1 ) #fi
  
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

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P  [anywhere, structural]
  rule P:Proc | Nil    => P  [anywhere, structural]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> <env> _ </env> </thread> => .Bag  [structural] //empty threads
  rule <thread> <k> Nil </k> <env> _ </env> </thread> => .Bag  [structural] //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

  rule #isProc( A:K ) => isProc(A)
  rule #isName( A:K ) => isName(A)

endmodule