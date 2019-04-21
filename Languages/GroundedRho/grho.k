// RHO CALCULUS with Bool, Int, String ground terms and Rholang features in a monadic style
/*
TODO:
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

//-------------
//--- NAMES ---
//-------------
  syntax             Name ::= Chan                                          //    Chan < Name
                            | NameVar                                       // NaveVar < Name
	        | "Empty"                                       //   Empty < Name // for listening for empty messages

  syntax          NameVar ::= Id                                            // Id < NameVar

  syntax             Chan ::= Quote                                         //       Quote < Name
                            | Unforgeable                                   // Unforgeable < Name

  syntax            Quote ::= "@" Proc                                      // @_: Proc ---> Quote

  syntax      Unforgeable ::= "unforgeable(" Int ")"                        // unforgeable(_): Int ---> Unforgeable

  syntax            Names ::= Name "," Name                                 // _,_: Name x Name ------> Names
                            | Name "," Names                                // _,_: Name x Names -----> Names

  syntax         NameList ::= Name                                          //  Name < NameList
                            | Names                                         // Names < NameList

//-----------------
//--- PROCESSES ---
//-----------------
  syntax             Proc ::= "{" Proc "}"                        [bracket] // {_}: Proc --> Proc
                            > New                                           //         New < Proc
                            > "Nil"                                         // Nil: -------> Proc
                            | Collection                                    //  Collection < Proc
                            | Ground                                        //      Ground < Proc
	        > VarRef                                        //      VarRef < Proc
                            > Eval                                          //        Eval < Proc
                            > MethodProc                                    //  MethodProc < Proc
                            > AExp                                          //        AExp < Proc
                            > BExp                                          //        BExp < Proc
                            > Match                                         //       Match < Proc
                            > Receive                                       //     Receive < Proc
                            | Contract                                      //    Contract < Proc
	        | Invocation                                    //  Invocation < Proc
                            | Send                                          //        Send < Proc
                            | Bundle                                        //      Bundle < Proc
                            > Conditional                                   // Conditional < Proc
                            > Par                                           //         Par < Proc

// Parallel composition
// Pars should be like a multiset of processes...
  syntax              Par ::= Proc "|" Proc                          [left] // _|_: Proc x Proc ---> Par

// Receives - no mixed linear/peek/repeated/sequential
// TODO: Input guards - e.g. for( y <- x if x > 0 ){ ... }

  syntax          Receive ::= SingleRec                                     // SingleRec < Receive, single listen receive
                            | MultiRec                                      //  MultiRec < Receive, multi-listen receive = join

  syntax        SingleRec ::= "for" "(" Bind  ")" "{" Proc "}"              // for(_){_}: Bind x Proc ----> SingleRec; one listen
                            | GuardedSingleRec                              // GuardedSingleRec < SingleRec

  syntax GuardedSingleRec ::= "for" "(" GuardedBind ")" "{" Proc "}"        // for(_){_}: Bind x Proc ----> SingleRec; one listen

  syntax         MultiRec ::= "for" "(" Binds ")" "{" Proc "}"              // for(_){_}: Binds x Proc ---> MultiRec; several listens
                            | GuardedMultiRec                               // GuardedMultiRec < MultiRec

  syntax  GuardedMultiRec ::= "for" "(" GuardedBinds ")" "{" Proc "}"       // for(_){_}: Binds x Proc ---> MultiRec; several listens
  
  syntax            Guard ::= "if" BExp                                     // conditional

  syntax            Lbind ::= NameList "<-" Name                [strict(2)] // for( y1,...,yN <- x ){ P } (explicit)
                            |          "<-" Name                   [strict] // for(  <- x ){ P } (explicit)

  syntax           Lbinds ::= Lbind ";" Lbind                               // 2 linear listens 
                            | Lbind ";" Lbinds                              // N liner listens, N > 2

  syntax            Pbind ::= NameList "<!" Name                [strict(2)] // for( y1,...,yN <! x ){ P } (explicit)
                            |          "<!" Name                   [strict] // for( y1,...,yN <! x ){ P } (explicit)

  syntax           Pbinds ::= Pbind ";" Pbind                               // 2 peeks
                            | Pbind ";" Pbinds                              // N peeks, N > 2

  syntax            Rbind ::= NameList "<=" Name                [strict(2)] // for( y1,...,yN <= x ){ P } (explicit)
                            |          "<=" Name                   [strict] // for( y1,...,yN <= x ){ P } (explicit)

  syntax           Rbinds ::= Rbind ";" Rbind                               // 2 repeated listens
                            | Rbind ";" Rbinds                              // N repeated listens, N > 2

  syntax            Sbind ::= NameList "<<" Name                [strict(2)] // for( y1,...,yN << x ){ P } (explicit)
                            |          "<<" Name                   [strict] // for( y1,...,yN << x ){ P } (explicit)

  syntax           Sbinds ::= Sbind ";" Sbind                               // 2 sequential listens
                            | Sbind ";" Sbinds                              // N sequential listens, N > 2

  syntax             Bind ::= Lbind                                         // single linear listen (implicit)
                            | Pbind                                         // single peek listen (implicit)
                            | Rbind                                         // single repated listen (implicit)
	        | Sbind                                         // single sequential listen (implict)

  syntax            Binds ::= Lbinds                                        // linear binds ----- for( y1 <- x1 ; ... ; yN <- xN ){ P }, implicit
                            | Pbinds                                        // peek binds ------- for( y1 <! x1 ; ... ; yN <! xN ){ P }, implicit
                            | Rbinds                                        // repeated binds --- for( y1 <= x1 ; ... ; yN <= xN ){ P }, implicit
	        | Sbinds                                        // sequential binds - for( y1 << x1 ; ... ; yN << xN ){ P }, implicit

  syntax         BindList ::= Bind
                            | Binds

  syntax      GuardedBind ::= Bind Guard
  
  syntax     GuardedBinds ::= Binds Guard
  
  syntax         AnyBinds ::= Bind
                            | Binds
	        | GuardedBind
	        | GuardedBinds

// Send
  syntax             Send ::= ConsumableSend                                //   ConsumableSend < Send
                            | UnconsumableSend                              // UnconsumableSend < Send

  syntax   ConsumableSend ::= Name "!"  "(" ProcList ")"                    //  _!(_): Name x ProcList ---> ConsumableSend
                            | Name "!"  "(" ")"

  syntax UnconsumableSend ::= Name "!!" "(" ProcList ")"                    // _!!(_): Name x ProcList ---> UnconsumableSend
                            | Name "!!" "(" ")"

// Eval
  syntax             Eval ::= "*" Name                             [strict] // *_: Name ---> Eval 

// Several Processes
  syntax            Procs ::= Proc "," Proc                        [strict] // _,_: Proc x Proc ----> Procs
                            | Proc "," Procs                       [strict] // _,_: Proc x Procs ---> Procs

  syntax         ProcList ::= Proc                                          //  Proc < ProcList
                            | Procs                                         // Procs < ProcList

// New
  syntax              New ::= "new" NameList "in" "{" Proc "}"     [binder] // new _ in {_}: NameList x Proc ---> New; creates unforgeable names

// Match
  syntax            Match ::= "match" Proc "{" MatchCaseList "}"            // match_{_}: Proc x MatchCaseList ---> Match

  syntax        MatchCase ::= Proc ":=>" Proc                   [strict(2)] // _:=>_: Proc x Proc -------------> MatchCase

  syntax       MatchCases ::= MatchCase MatchCase                           // _ _: MatchCase x MatchCase -----> MatchCases
                            | MatchCase MatchCases                          // _ _: MatchCase x MatchCases ----> MatchCases

  syntax    MatchCaseList ::= MatchCase                                     //  MatchCase < MatchCaseList
                            | MatchCases                                    // MatchCases < MatchCaseList

// Variable Reference
  syntax           VarRef ::= "=" "*" NameVar                               // =*_: NameVar ---> VarRef

// Conditional
  syntax      Conditional ::= IfThen                                        // if ... then ...
                            | Else                                          // if ... then ... else

  syntax           IfThen ::= "if" "(" BExp ")" "then" Proc    [strict(1)]  // if ... then ...
 
  syntax             Else ::= IfThen "else" Proc                            // if ... then ... else ...

// Contract
  syntax         Contract ::= "contract" Name "(" NameList ")" "=" "{" Proc "}"  // syntactic sugar => for( NameList <= Name ){ Proc }
                            | "contract" Name "(" ")" "=" "{" Proc "}"      // empty name declaration list

// Contract Invocation
  syntax       Invocation ::= Name "(" ProcList ")"                         // _(_): Name x ProcList ---> Invocation
                            | Name "(" ")"

// Collections
  syntax       Collection ::= RhoList                                       //  RhoList < Collection
                            | RhoMap                                        //   RhoMap < Collection
                            | RhoSet                                        //   RhoMap < Collection
                            | RhoTuple                                      // RhoTuple < Collection

// Process lists
  syntax          RhoList ::= "[" ProcList ",]"                              // [_]: ProcList ----> RhoList
                            | "[" ",]"                                       // empty list

// Process maps
  syntax           RhoMap ::= "{" RhoKVPairList "}"                         // {_}: RhoKVPairList ---> RhoMap
                            | "{" "}"                                       // empty map

  syntax        RhoKVPair ::= Proc ":" Proc                                 // _:_: Proc x Proc --------------> RhoKVPair
  
  syntax       RhoKVPairs ::= RhoKVPair "," RhoKVPair                       // _,_: RhoKVPair x RhoKVPair ----> RhoKVPairs, map size = 2
                            | RhoKVPair "," RhoKVPairs                      // _,_: RhoKVPair x RhoKVPairs ---> RhoKVPairs, map size > 2
  
  syntax    RhoKVPairList ::= RhoKVPair                                     //  RhoKVPair < RhoKVPairList
                            | RhoKVPairs                                    // RhoKVPairs < RhoKVPairList

// Process sets
  syntax           RhoSet ::= "Set" "(" ProcList ")"                        // Set(_): ProcList ----> RhoSet
                            | "Set" "(" ")"                                 // empty set

// Process tuples
  syntax         RhoTuple ::= "(" ProcList ",)"                             // (_,): ProcList ----> RhoTuple
                            | "(" ",)"                                      // empty tuple

// Ground terms
  syntax           Ground ::= Bool                                          //   Bool < Ground
                            | Int                                           //    Int < Ground
                            | String                                        // String < Ground
                            | Uri                                           //    Uri < Ground

  syntax              Uri ::= "uri(" String ")"                             // uri(_): String -----> Uri

// AExp & BExp resolve to ground terms
// Arithmetic
  syntax             AExp ::= "{" AExp "}"                                  //     (_): AExp ------> AExp
                            > Int                                           //    Int < AExp
                            | Eval                                          //   Eval < AExp , for interesting message passing, e.g. for( y <- x ){ *y + 5 }
	        | String                                        // String < AExp
	        | AExp "++" AExp                                // _++_: AExp x AExp ---> AExp (string concatenation)
	        > "-" AExp                             [strict] //  -_: AExp -----------> AExp (negation)
                            > AExp "*"  AExp                       [strict] // _*_: AExp x AExp ----> AExp (multiplication)
	        | AExp "/"  AExp                       [strict] // _/_: AExp x AExp ----> AExp (division)
                            > AExp "+"  AExp                       [strict] // _+_: AExp x AExp ----> AExp (addition)
                            | AExp "-"  AExp                       [strict] // _-_: AExp x AExp ----> AExp (subtraction)
	        | AExp "%"  AExp                       [strict] // _%_: AExp x AExp ----> AExp (mod reduction)
                           // String interpolation: "${key}..." %% { key:value } => "value" ++ "..."

// Boolean
  syntax             BExp ::= "{" BExp "}"                                  //  (_): BExp ----------> BExp
                            > Bool                                          //   Bool < BExp
                            | Eval                                          //   Eval < BExp
                            | String                                        // String < BExp
                            | AExp "<=" AExp                    [seqstrict] // _<=_: AExp x AExp ---> BExp
	        | AExp "<"  AExp                    [seqstrict] // 
	        | AExp ">=" AExp                    [seqstrict] // 
	        | AExp ">"  AExp                    [seqstrict] // 
	        | Proc "matches" Proc                           // _matches_: Proc x Proc ---> BExp // P matches Q is syntactic sugar for: match P { Q :=> true _ :=> false }
	        | Name "==" Name                                // _==_: Name x Name ---> BExp (name equivalence) // currently in progress
	        | Name "!=" Name                                // _!=_: Name x Name ---> BExp (name equivalence) // currently in progress
	        | Proc "==" Proc                                // _==_: Proc x Proc ---> BExp (structural equivalence) // currently in progress
	        | Proc "!=" Proc                                // _==_: Proc x Proc ---> BExp (structural equivalence) // currently in progress
                            > "not" BExp                           [strict] // not_: BExp ----------> BExp
                            > BExp "and" BExp                   [strict(1)] //  and: BExp ----------> BExp
                            > BExp "or"  BExp                   [strict(1)] //   or: BExp ----------> BExp

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}"                        // write-only
                            | "bundle-" "{" Proc "}"                        // read-only
                            | "bundle0" "{" Proc "}"                        // neither read/write
                            | "bundle"  "{" Proc "}"                        // both read/write

// #isProc Predicate
  syntax             Bool ::= "#isProc(" K ")"                              // #isProc(_): K ---> Bool
                            | "#isName(" K ")"                              // #isName(_): K ---> Bool

// Methods
  syntax       MethodProc ::= Proc "." Method "(" MethodArgs ")" [strict(1)]// _._(_): Proc x Method x MethodArgs ---> MethodProc

  syntax       MethodArgs ::= ProcList
                            | ""

  syntax           Method ::= "nth"                                         // nth element in list, string, tuple // syntax: Thing.nth( Int ) 
                            | "toByteArray"                                 // transform to bytearray - Thing.toByteArray( )
                            | "hexToBytes"                                  // hex string -> bytes
                            | "union"                                       // map, set union - Map.union( Map ) , Set.union( Set )
                            | "diff"                                        // map, set difference?
                            | "add"                                         // add proc/ like single element concat? - list, set?
                            | "delete"                                      // delete element? - list, map, set
                            | "contains"                                    // contains predicate
                            | "get"                                         // get - map - get value corresponding to key or Nil
                            | "getOrElse"                                   // getOrElse - map - get or side condition
                            | "set"                                         // set - map.set( Key , Value )
	        | "contains"                                    // contains predicate - 
                            | "keys"                                        // set of keys of a map - map.keys( )
	        | "values"                                      // list of values of a map - map.values( )
                            | "size"                                        // number of elements in unordered structures - Map.size(), Set.size()
                            | "length"                                      // length of list, tuple - List.length() , Tuple.length()
                            | "slice"                                       // slice of list, string - List.slice(I1,I2) , String.slice(I1,I2)
	        | "iterate"                                     // semantics? - list
                            | "confine"                                     // semantics?

// Builtins are processes too
  syntax             Proc ::= List | Map | Set
  syntax              Map ::= RhoMap
  syntax              Set ::= RhoSet

// For handling joins in configuration
  syntax         JoinList ::= "{[" Proc ";" Int     "]}"                    // for uniform join id

  syntax          ChanLen ::= "("  Name ";" Int      ")"                    // (listening channel ; number of variables to bind)

  syntax         ChanList ::= "("  Name ";" NameList ")"                    // (listening channel ; variable(s) to bind)
  
  syntax            IdNum ::= Int ";" Int                                   // _;_: Int x Int ------> IdNum < KItem

  syntax          BindOcc ::= Name ";" Int       ";;" Int                   // listening channel; number of variables to bind; number of occurences
                            | Name ";" NameList  ";;" Int                   // listening channel; variable(s) to bind; number of occurences

  syntax             Proc ::= ChanLen                                       // for
                            | BindOcc                                       // auxfun
                            | JoinList                                      // definitions

  syntax        KVariable ::= Name | Int

  syntax            KItem ::= Name | Names | Proc | Procs | IdNum

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
            <msg>    .K    </msg>                                    // sent message
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

  syntax KResult ::= Ground | Eval | List | Map | Set                // final output of strict operations

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
  rule L:RhoList => #makeList(L)
  rule #makeList([ ]) => .List
  rule #makeList([ P:Proc ]) => ListItem(P)
  rule #makeList([ P:Proc , Q:Proc  ]) => ListItem(P) ListItem(Q)
  rule #makeList([ P:Proc , Q:Procs ]) => ListItem(P) #makeList([Q,])

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

// Conditionals - short-circuited
  rule if ( true  ) then P:Proc => P              [structural]
  rule if ( false ) then _:Proc => Nil            [structural]
  rule if ( true  ) then P:Proc else _:Proc => P  [structural]
  rule if ( false ) then _:Proc else Q:Proc => Q  [structural]

// Matching
  // "matches" binop desugars into "match" statement
  rule P:Proc matches Q:Proc => match P { Q :=> true P :=> false }  [anywhere]
  
  // TODO: replace ==K with structural equivalence
  rule match P:Proc { Q:Proc :=> R:Proc } => #if P ==K Q #then R #else Nil #fi
  rule match P:Proc { Q:Proc :=> R:Proc M:MatchCase  } => #if P ==K Q #then R #else match P { M } #fi
  rule match P:Proc { Q:Proc :=> R:Proc M:MatchCases } => #if P ==K Q #then R #else match P { M } #fi

// New Operator Semantics
// like blocks with local variable declarations
// nested variable declarations will shadow each other
  syntax KItem ::= "undefined"  // declared as a variable, but not assigned a value yet

  rule <k> new N:NameVar in { P:Proc } => P ~> setEnv(Env) ...</k>
       <env> Env => Env[N <- L] </env>
       <store>... .Map => L |-> undefined ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>
  
  rule <k> new M:NameVar , N:NameVar  in { P:Proc } => new N in { P } ...</k>
       <env> Env => Env[M <- L] </env>
       <store>... .Map => L |-> undefined ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>
       
  rule <k> new M:NameVar , N:Names in { P:Proc } => new N in { P } ...</k>
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
  rule contract X:Name ( Y:NameList ) = { P:Proc } => for ( Y <= X ){ P }  [anywhere, structural]
  rule contract X:Name (  ) = { P:Proc }           => for (   <= X ){ P }  [anywhere, structural]

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
  rule T:RhoTuple .length( ) => #length T

  // mapkeys (maps)
  rule M:Map .keys( ) => keys( M )
  
  // nth (lists & tuples)
  rule L:List .nth( I:Int ) => L[I]

  rule ( ,).nth( _ ) => Nil
  rule ( P:Proc ,).nth( I:Int ) => #if I ==Int 0 #then P #else Nil #fi
  rule ( P:Proc , Q:Proc  ,).nth( I:Int ) => #if I ==Int 0 #then P #else ( Q ,).nth( I -Int 1 ) #fi
  rule ( P:Proc , Q:Procs ,).nth( I:Int ) => #if I ==Int 0 #then P #else ( Q ,).nth( I -Int 1 ) #fi
  
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