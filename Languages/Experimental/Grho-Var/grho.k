// RHO CALCULUS with Bool, Int, String ground terms and Rholang features in a monadic style
/*
TODO:
 - Par as set with number of occurrences of each element
 - Matching (patterns & wildcard)
 - Environments for new declarations, global store for location, & location counter cell
 - Finish method semantics
 - add contract invocation(?): Name "(" ProcList ")" - syntactic sugar for cell pattern
 - add sequential listen semantics
*/

require "domains.k"
require "substitution.k"
require "AuxFun/auxfun.k"
require "Substitute/sub.k"
require "Names_Variables/namevar.k"

// SYNTAX MODULE
module GRHO-SYNTAX
  import DOMAINS
  import SUBSTITUTION

// Variables
  syntax             Var ::= Id

//-------------
//--- NAMES ---
//-------------
  syntax             Name ::= Quote
                            | NameVar  // name variable
                            | EmptyName
                            | NewUri
  syntax            Quote ::= "@" Proc
  syntax          NameVar ::= "$" Var
  syntax        EmptyName ::= "EmptyN" // listening for empty messages
  syntax           NewUri ::= NameVar "(" Uri ")"

// Several Names
  syntax            Names ::= Name "," Name
                            | Name "," Names

//-----------------
//--- PROCESSES ---
//-----------------
  syntax             Proc ::= "{" Proc "}"    [bracket]
                            > New             // New name declaration(s)
                            > Ground          // Ground terms - Bool, Int, Nil, String, Uri
                            | Collection      // Data structures - List, Map, Set, Tuple
                            | ProcVar         // Process variable
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
                            > Par             // Parallel composition

  syntax          ProcVar ::= "\\" Var

// Several Processes
  syntax            Procs ::= Proc "," Proc
                            | Proc "," Procs

// Parallel composition
// Pars should be like a multiset of processes...
  syntax              Par ::= Proc "|" Proc  [left]

// Receives - no mixed linear/peek/repeated/sequential
// TODO: Input guards - e.g. for( @\y <- x if \y > 0 ){ ... }
  syntax          Receive ::= SingleRec | MultiRec

  // Single listen receives
  syntax        SingleRec ::= "for" "(" Bind ")" "{" Proc "}"
                            | GuardedSingleRec
  syntax GuardedSingleRec ::= "for" "(" GuardedBind ")" "{" Proc "}"
  syntax            Guard ::= "if" BExp
  // Linear listen
  syntax            Lbind ::= Names "<-" Name
                            | Name  "<-" Name
                            |       "<-" Name
  // Peek listen
  syntax            Pbind ::= Names "<!" Name
                            | Name  "<!" Name
                            |       "<!" Name
  // Repeated/Persistent listen
  syntax            Rbind ::= Names "<=" Name
                            | Name  "<=" Name
                            |       "<=" Name

  syntax             Bind ::= Lbind | Pbind | Rbind
  syntax      GuardedBind ::= Bind Guard
  syntax          AnyBind ::= Bind | GuardedBind

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

  syntax            Binds ::= Lbinds | Pbinds | Rbinds
  syntax     GuardedBinds ::= Binds Guard
  syntax         AnyBinds ::= Binds | GuardedBinds

// Sends
  syntax             Send ::= ConsumableSend | UnconsumableSend
  syntax   ConsumableSend ::= Name "!"  "(" Procs ")"
                            | Name "!"  "(" Proc  ")"
                            | Name "!"  "(" ")"
  syntax UnconsumableSend ::= Name "!!" "(" Procs ")"
                            | Name "!!" "(" Proc  ")"
                            | Name "!!" "(" ")"

// Eval
  syntax             Eval ::= "*" Name

// New - creates unforgeable names
  syntax              New ::= "new" Name  "in" "{" Proc "}" // [binder]
                            | "new" Names "in" "{" Proc "}" // [binder]

// Match
  syntax            Match ::= "match" Proc "{" MatchCases "}"
                            | "match" Proc "{" MatchCase  "}"
  syntax        MatchCase ::= Proc ":=>" Proc
  syntax       MatchCases ::= MatchCase MatchCase
                            | MatchCase MatchCases

// Variable Reference - allows for shadowing
  syntax           VarRef ::= "=" "*" NameVar
                            | "=" ProcVar

// Conditional
  syntax      Conditional ::= IfThen | Else

  syntax           IfThen ::= "if" "(" BExp ")" Proc  [strict(1)]
  syntax             Else ::= IfThen "else" Proc

// Contract
  syntax         Contract ::= "contract" Name "(" Names ")" "=" "{" Proc "}"  // sugar for persistent receive
                            | "contract" Name "(" Name  ")" "=" "{" Proc "}"
                            | "contract" Name "(" ")" "=" "{" Proc "}"

// Contract Invocation
  syntax       Invocation ::= "invoke" Name "(" Procs ")"
                            | "invoke" Name "(" Proc  ")"
                            | "invoke" Name "(" ")"

// Collections - data structures
  syntax       Collection ::= RhoList | RhoMap | RhoSet | RhoTuple

  // Process lists
  syntax          RhoList ::= "[" Procs "]"
                            | "[" Proc  "]"
                            | "[" "]"

  // Process maps
  syntax           RhoMap ::= "{" RhoKVPairs "}"
                            | "{" RhoKVPair  "}"
                            | "{" "}"

  syntax        RhoKVPair ::= Proc ":" Proc
  syntax       RhoKVPairs ::= RhoKVPair "," RhoKVPair
                            | RhoKVPair "," RhoKVPairs

  // Process sets
  syntax           RhoSet ::= "Set" "(" Procs ")"
                            | "Set" "(" Proc  ")"
                            | "Set" "(" ")"

  // Process tuples
  syntax         RhoTuple ::= "(" Procs ")"  [klabel(tuple)]
                            | "(" Proc  ")"  [klabel(tuple)]
                            | "(" ")"        [klabel(tuple)]

// Ground terms
  syntax           Ground ::= Bool | Int | String // built-in
                            | "Nil"        // stopped process
                            | Unforgeable | Uri
  syntax      Unforgeable ::= "unforgeable(" Int ")"
  syntax              Uri ::= "uri(" String ")"

// AExp & BExp resolve to ground terms
// Arithmetic
  syntax             AExp ::= "{" AExp "}"   [bracket]
                            > Int
                            | ProcVar         // for interesting message passing, e.g. for( @\y <- x ){ \y + 5 }
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
  syntax             BExp ::= "{" BExp "}"   [bracket]
                            > Bool
                            | ProcVar
                            | Eval
                            | String
                            | AExp "<=" AExp        [seqstrict]
                            | AExp "<"  AExp        [seqstrict]
                            | AExp ">=" AExp        [seqstrict]
                            | AExp ">"  AExp        [seqstrict]
                            | Proc "matches" Proc   // P matches Q is syntactic sugar for: match P { Q :=> true P :=> false }
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
  syntax       MethodProc ::= Proc MethodAndArgs
  syntax    MethodAndArgs ::= "." Method "(" Procs ")"
                            | "." Method "(" Proc  ")"
                            | "." Method "(" ")"

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

// For empty content & args
  syntax             Proc ::= EmptyProc
  syntax        EmptyProc ::= "EmptyP"

// Builtins are processes too
  syntax             Proc ::= List | Map | Set
  syntax              Map ::= RhoMap
  syntax              Set ::= RhoSet

// For K
  syntax        KVariable ::= NameVar | ProcVar 
                            | Name | Proc  // still testing for necessity
                            | Send | Receive | Quote | Eval | Par | Collection  // for deep pattern-matching
                            | Int  // for map substitutions
  syntax            KItem ::= Name | Names | Proc | Procs

endmodule

// SEMANTICS MODULE
module GRHO
//  import GRHO-SYNTAX
  import AUXFUN
  import SUB
  import NAMEVAR

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                  //
      <threads color="red">                             //**activity threads**
        <thread color="green" multiplicity="*">         // collection of threads (concurrent activity)
//        <k> Error: FreeVars! ~> $PGM:Proc </k>        // Free variable program execution guard
          <k> $PGM:Proc </k>                            // programs and computations are process-based
        </thread>                                       //
      </threads>                                        //**tuplespace**
      <tuplespace color="blue">                         // stores sends and receives
        <sends>                                         //**sends**
          <send color="cyan" multiplicity="*">          //
            <schan> .K </schan>                         // sending channel (many messages on same channel)
            <msg>   .K   </msg>                         // sent message
            <tuple> .K </tuple>                         // equals N if N-tuple - for arity matching
            <stype> .K </stype>                         // 0 for single send (consumed), 1 for persistent send (not consumed)
          </send>                                       //
        </sends>                                        //
        <receives>                                      //
          <rec color="yellow" multiplicity="*">         //
            <rchan> .K </rchan>                         // receiving channel (many messages on same channel)
            <bvars> .K </bvars>                         // binding varible(s) in continuation
            <bnum>  .K  </bnum>                         // number of bindings
            <rtype> .K </rtype>                         // 0 for single listen (consumed), 1 for persistent listen (not consumed), 2 for peek
            <guard> .K </guard>                         // input guard
            <cont>  .K  </cont>                         // continuation
          </rec>                                        // 
        </receives>                                     // 
      </tuplespace>                                     // 
      <reaction color="violet">                         //**comm events are processed here before being released back into the wild**
        <who>   .K   </who>                             // continuation process
        <what>  .K  </what>                             // msg process(es)
        <where> .K </where>                             // binding variable(s)
      </reaction>                                       // all comms are processed here
      <nextLoc color="gray"> 0 </nextLoc>               // 
      <freeVars color="purple">                         // 
        FV($PGM:Proc)                                   // set of free variables
      </freeVars>                                       // 
    </T>                                                // 

  syntax KResult ::= Ground | Eval | List | Map | Set   // final output of strict operations

// Free variable execution guard
//  syntax KItem ::= "Error: FreeVars!"
// Remove free variable error guard if program is closed
//  rule <k> (Error: FreeVars! ~> P:Proc) => P </k>
//       <free> .Set </free>

// Arithmetic expressions
  rule I1:Int + I2:Int => I1 +Int I2                      [anywhere] // addition
  rule I1:Int - I2:Int => I1 -Int I2                      [anywhere] // subtraction
  rule I1:Int * I2:Int => I1 *Int I2                      [anywhere] // multiplication
  rule I1:Int / I2:Int => I1 /Int I2 requires I2 =/=Int 0 [anywhere] // division
  rule I1:Int % I2:Int => I1 %Int I2 requires I2 =/=Int 0 [anywhere] // modular reduction
  rule - I:Int => 0 -Int I                                [anywhere] // negation
  
  rule S1:String ++ S2:String => S1 +String S2  [anywhere] // string concatenation

// Boolean expressions
  rule I1:Int <= I2:Int => I1 <=Int I2   [anywhere] // 
  rule I1:Int <  I2:Int => I1  <Int I2   [anywhere] // 
  rule I1:Int >= I2:Int => I1 >=Int I2   [anywhere] // 
  rule I1:Int >  I2:Int => I1  >Int I2   [anywhere] // 
  rule not B:Bool => notBool B           [anywhere] // 
  rule true  and B:Bool => B             [anywhere] // short-circuited 
  rule false and _:Bool => false         [anywhere] // short-circuited 
  rule true  or  _:Bool => true          [anywhere] // short-circuited 
  rule false or  B:Bool => B             [anywhere] // short-circuited 

// Structural Equivalence
  // Syntactic equality of Ground terms
  rule A:Ground == B:Ground => A ==K  B  [anywhere] // equality of ground terms
  rule A:Ground != B:Ground => A =/=K B  [anywhere] // inequality of ground terms
  // TODO: define structural equivalence for nonGround processes
  rule  P:Proc == Q:Proc => P ==K Q requires notBool isGround(P)
  rule @P:Proc == @Q:Proc => P == Q

// Conditionals - short-circuited
  rule if ( true  ) P:Proc => P              [structural]
  rule if ( false ) _:Proc => Nil            [structural]
  rule if ( true  ) P:Proc else _:Proc => P  [structural]
  rule if ( false ) _:Proc else Q:Proc => Q  [structural]

// Matching
  // "matches" binop desugars into "match" statement
  rule P:Proc matches Q:Proc => match P { Q :=> true P :=> false }  [anywhere]
  
  rule match P:Proc { Q:Proc :=> R:Proc } => #if (P ==K Q) #then R #else Nil #fi
  rule match P:Proc { Q:Proc :=> R:Proc M:MatchCase  } => #if (P ==K Q) #then R #else match P { M } #fi
  rule match P:Proc { Q:Proc :=> R:Proc M:MatchCases } => #if (P ==K Q) #then R #else match P { M } #fi

// New Operator Semantics
// TODO: swap builtin substitution _[_/_] for #sub(_;_;_)
  rule <k> new M:NameVar in { P:Proc } => P[@unforgeable(L) / M] ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  
  rule <k> new M:NameVar , N:Name  in { P:Proc } => new N in {P}[@unforgeable(L) / M] ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
       
  rule <k> new M:NameVar , N:Names in { P:Proc } => new N in {P}[@unforgeable(L) / M] ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>

// Syntactic sugar - contract desugars into unconsumable receive
  rule contract X:Name ( Y:Names ) = { P:Proc } => for( Y <= X ){ P }  [anywhere, structural]
  rule contract X:Name ( Y:Name  ) = { P:Proc } => for( Y <= X ){ P }  [anywhere, structural]
  rule contract X:Name (         ) = { P:Proc } => for(   <= X ){ P }  [anywhere, structural]

// Par Operator Semantics - concurrent execution of processes
  rule <thread>
         <k> P:Proc | Q:Proc => . ...</k>
       </thread>
       (.Bag => <thread> <k> P </k> </thread>)
       (.Bag => <thread> <k> Q </k> </thread>)

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule <thread>
         <k> S:Send => . ...</k>   // dissolve send in <threads/> and spawn <send/>
       </thread>
       (.Bag => <send>
                  <schan>   #chan(S) </schan>  // sending channel
                  <msg>      #msg(S)   </msg>  // sending message(s)
                  <tuple> #length(S) </tuple>  // number of messages
                  <stype>  #stype(S) </stype>  // send type
                </send>)

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
  rule <thread>
         <k> R:SingleRec => . ...</k>  // dissolve Rec in <threads/> and spawn <rec/>
       </thread>
       (.Bag => <rec>
                  <rchan>  #chan(R) </rchan>  // receiving channel
                  <bvars>  #bvar(R) </bvars>  // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>  // 
                  <rtype> #rtype(R) </rtype>  // receive type
                  <guard> #guard(R) </guard>  // input guard
                  <cont>   #cont(R)  </cont>  // continuation
                </rec>)

// Joins
  rule <thread>
         <k> R:MultiRec => . ...</k>
       </thread>
       (.Bag => <rec>
                  <rchan>  #chan(R) </rchan>  // receiving channel
                  <bvars>  #bvar(R) </bvars>  // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>  // number of variables to bind
                  <rtype> #rtype(R) </rtype>  // receive type
                  <cont>   #cont(R)  </cont>  // continuation
                  <guard> #guard(R) </guard>  // input guard
                </rec>)

//-------------------
//--- COMM EVENTS ---
//-------------------
// x!(Q) | for( z <- y ){P} /\ x equivN y => #sub(@Q;z;P)

// TODO: replace builtin substitution _[_/_] for #sub(_;_;_)

// Reaction Cell Semantics - quarantined reaction cell for processing comm events
// N substitutions, N > 2
  rule
    <reaction>
      <who>    P:Proc => P[@Q / $Y]     </who>
      <what>   Q:Proc , R:Proc  => R   </what>
      <where>  ($Y):Name , Z:Names => Z  </where>
    </reaction>                                [react]

  rule
    <reaction>
      <who>    P:Proc => P[Q / \Y]     </who>
      <what>   Q:Proc , R:Proc   => R   </what>
      <where>  @\Y:Var , Z:Names => Z  </where>
    </reaction>                                [react]

  rule
    <reaction>
      <who>    P:Proc => P     </who>
      <what>   Q:Proc , R:Proc => R   </what>
      <where>  @Q , Z:Names => Z  </where>
    </reaction>
   requires notBool isProcVar(Q)  [react]

// 2 substitutions
  rule
    <reaction>
      <who>    P:Proc => P[@Q / $Y]     </who>
      <what>   Q:Proc , R:Proc => R   </what>
      <where>  ($Y):Name , Z:Name => Z  </where>
    </reaction>                                [react]

  rule
    <reaction>
      <who>    P:Proc => P[Q / \Y]     </who>
      <what>   Q:Proc , R:Proc => R   </what>
      <where>  @\Y:Var , Z:Name => Z  </where>
    </reaction>                                [react]

  rule
    <reaction>
      <who>    P:Proc => P     </who>
      <what>   Q:Proc , R:Proc => R   </what>
      <where>  @Q , Z:Name => Z  </where>
    </reaction>
   requires notBool isProcVar(Q)  [react]

// Final substitution: spawn in a new thread holding the fully substituted continuation
  rule
    <reaction>
      <who>    P:Proc => .K   </who>
      <what>   Q:Proc => .K  </what>
      <where>  $Y:Var => .K </where>
    </reaction>
   //spawn single <thread/> holding fully substituted continuation
   (.Bag => <thread> <k> P[@Q / $Y] </k> </thread>)  [react]

  rule
    <reaction>
      <who>    P:Proc => .K   </who>
      <what>   Q:Proc => .K  </what>
      <where>  @\Y:Var => .K </where>
    </reaction>
   //spawn single <thread/> holding fully substituted continuation
   (.Bag => <thread> <k> P[Q / \Y] </k> </thread>)  [react]

  rule
    <reaction>
      <who>    P:Proc => .K   </who>
      <what>   Q:Proc => .K  </what>
      <where>  @Q     => .K </where>
    </reaction>
   //spawn single <thread/> holding fully substituted continuation
   (.Bag => <thread> <k> P </k> </thread>)
   requires notBool isProcVar(Q)  [react]

// Comm semantics
// Linear listen, linear send
  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Name  </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of names to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
  (<send>                                  //consume single send
     <schan> X       </schan>              // channel X
     <msg>   Q:Proc    </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   <reaction>                              //
     <who>   .K => P   </who>              // 
     <what>  .K => Q  </what>              // 
     <where> .K => Y </where>              // 
   </reaction>                             // 
   requires B[@Q / Y]               [comm]

  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Names </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of names to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
  (<send>                                  //consume single send
     <schan> X       </schan>              // channel X
     <msg>   Q:Procs   </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   <reaction>                              // 
     <who>   .K => P   </who>              // 
     <what>  .K => Q  </what>              // 
     <where> .K => Y </where>              // 
   </reaction>                             // 
//   requires B[#quotes(Q) / Y]       [comm]

// Persistent listen, linear send
  rule                                     //consume single send, keep persistent receive
   <rec>                                   //DON'T consume persistent receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Name  </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 1       </rtype>              // repeated listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec>                                  //
  (<send>                                  //consume single send
     <schan> X       </schan>              // channel X
     <msg>   Q:Proc    </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   <reaction>                              //
     <who>   .K => P   </who>              //
     <what>  .K => Q  </what>              //
     <where> .K => Y </where>              //
   </reaction>                             // 
   requires B[@Q / Y]               [comm]

  rule                                     //consume single send, keep persistent receive
   <rec>                                   //DON'T consume persistent receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Names </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 1       </rtype>              // repeated listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec>                                  //
  (<send>                                  //consume single send
     <schan> X       </schan>              // channel X
     <msg>   Q:Procs   </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   <reaction>                              //
     <who>   .K => P   </who>              //
     <what>  .K => Q  </what>              //
     <where> .K => Y </where>              //
   </reaction>                             // 
   requires B[#quotes(Q) / Y]       [comm]

// Linear listen, persistent send
  rule                                     //consume single receive and keep single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Name  </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation
   </rec> => .Bag)                         //
   <send>                                  //DON'T consume persistent send
     <schan> X       </schan>              // channel X
     <msg>   Q:Proc    </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 1       </stype>              // persistent send
   </send>                                 //
   <reaction>                              //
     <who>   .K => P   </who>              //
     <what>  .K => Q  </what>              //
     <where> .K => Y </where>              //
   </reaction>                             // 
   requires B[@Q / Y]               [comm]

  rule                                     //consume single receive and keep single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Names </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 0       </rtype>              // linear listen
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation
   </rec> => .Bag)                         //
   <send>                                  //DON'T consume persistent send
     <schan> X       </schan>              // channel X
     <msg>   Q:Procs   </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 1       </stype>              // persistent send
   </send>                                 //
   <reaction>                              //
     <who>   .K => P   </who>              //
     <what>  .K => Q  </what>              //
     <where> .K => Y </where>              //
   </reaction>                             // 
   requires B[#quotes(Q) / Y]       [comm]

// Peek semantics
  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Name  </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 2       </rtype>              // peek
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
   <send>                                  //consume single send
     <schan> X       </schan>              // channel X
     <msg>   Q:Proc    </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> _       </stype>              // any kind of send
   </send>                                 //
   <reaction>                              //
     <who>   .K => P   </who>              //
     <what>  .K => Q  </what>              //
     <where> .K => Y </where>              //
   </reaction>                             // 
   requires B[@Q / Y]               [comm]

  rule                                     //consume single send, single receive
  (<rec>                                   //consume single receive
     <rchan> X:Name  </rchan>              // channel X
     <bvars> Y:Names </bvars>              // binding variable(s) Y
     <bnum>  N:Int    </bnum>              // number of name(s) to bind
     <rtype> 2       </rtype>              // peek
     <guard> B:BExp  </guard>              // input guard
     <cont>  P:Proc   </cont>              // continuation P
   </rec> => .Bag)                         //
   <send>                                  //consume single send
     <schan> X       </schan>              // channel X
     <msg>   Q:Procs   </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> _       </stype>              // any kind of send
   </send>                                 //
   <reaction>                              //
     <who>   .K => P   </who>              //
     <what>  .K => Q  </what>              //
     <where> .K => Y </where>              //
   </reaction>                             // 
   requires B[#quotes(Q) / Y]       [comm]

// Join semantics seem to be much more complicated than single listens...
// moved progress to join.k

// Eliminate Nil in parallel compositions
  rule    Nil | P:Proc => P  [anywhere, structural]
  rule P:Proc | Nil    => P  [anywhere, structural]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag  [structural] //empty threads
  rule <thread> <k> Nil </k> </thread> => .Bag  [structural] //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule @ * N:Name => N  [anywhere, structural]
  rule * @ P:Proc => P  [anywhere, structural]

  rule #isProc( A:K ) => isProc(A)
  rule #isName( A:K ) => isName(A)

// Relation to built-ins
//  syntax List ::= "#makeList(" RhoList ")"    [function]
/*
// Collections
  //context (HOLE:RhoList => #makeList(HOLE)) . _:Method ( _:MethodArgs )
  rule L:RhoList => #makeList(L)
  rule #makeList([ ]) => .List
  rule #makeList([ P:Proc ]) => ListItem(P)
  rule #makeList([ P:Proc , Q:Proc  ]) => ListItem(P) ListItem(Q)
  rule #makeList([ P:Proc , Q:Procs ]) => ListItem(P) #makeList([Q])

  // RhoMaps are interpreted as built-in Maps
  //  context HOLE:RhoMap => #makeMap(HOLE)
  rule { }:RhoMap => .Map                                       [anywhere, structural]
  rule { P:Proc : Q:Proc } => P |-> Q                           [anywhere, structural]
  rule { P:Proc : Q:Proc , R:Proc : S:Proc } => P |-> Q R |-> S [anywhere, structural]
  rule { P:Proc : Q:Proc , R:RhoKVPairs    } => P |-> Q {R}     [anywhere, structural]

  // RhoSets are interpreted as built-in Sets
  //  context HOLE:RhoSet => #makeSet(HOLE)
  rule Set( ) => .Set                                   [anywhere, structural]
  rule Set( P:Proc ) => SetItem(P)                      [anywhere, structural]
  rule Set( P:Proc , Q:Proc  ) => SetItem(P) SetItem(Q) [anywhere, structural]
  rule Set( P:Proc , Q:Procs ) => SetItem(P) Set(Q)     [anywhere, structural]

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

// Syntactic sugar - quoted tuple listens desugar into regular listen
// included here (instead of in sytax module) because #quotes is defined in AUXFUN
  rule for( @ ( A:Proc  ) <- X:Name ){ P:Proc } => for( @A <- X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ) <= X:Name ){ P:Proc } => for( @A <= X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ) <! X:Name ){ P:Proc } => for( @A <! X ){ P }  [anywhere, structural]
  rule for( @ ( A:Proc  ) << X:Name ){ P:Proc } => for( @A << X ){ P }  [anywhere, structural]
  rule for( @ ( A:Procs ) <- X:Name ){ P:Proc } => for( #quotes(A) <- X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) <= X:Name ){ P:Proc } => for( #quotes(A) <= X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) <! X:Name ){ P:Proc } => for( #quotes(A) <! X ){ P } [anywhere, structural]
  rule for( @ ( A:Procs ) << X:Name ){ P:Proc } => for( #quotes(A) << X ){ P } [anywhere, structural]
*/
endmodule