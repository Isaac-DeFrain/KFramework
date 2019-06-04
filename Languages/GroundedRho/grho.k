// RHO CALCULUS with Bool, Int, String ground terms and Rholang features in a polyadic style
/*
TODO:
 - Matching (patterns & wildcard)
 - add TypedName ::= Name [":" Proc ]
 - Method semantics
 - Invocation semantics - syntactic sugar for cell pattern(?)
 - Sequential Listen syntax
 - NativeChan semantics

**V1.1 features**
 - New & improved for-comprehension:
   for( ptrn 11 <- src 11 & ... & ptrn 1n <- src 1n ;
        ...
        ptrn m1 <- src m1 & ... & ptrn mn <- src mn ;
      ){P}
   where src ::= x | x?! | x!?( a 1 , ..., a k ) and ‘&’ replaces the old meaning of ‘;’
   ⟦for( ptrn ← x?! ){P}⟧ = for( ( ptrn, r ) ← x ){ r!() | ⟦P⟧ }
   ⟦for( ptrn ← x!?( a 1 , ..., a k )){P}⟧ = new r in { x!( a 1 , ..., a k , *r) | for( ptrn ← r ){ ⟦P⟧ } }

 - Sequential output:
   - x!?(v);P
    ⟦x!?(v);P⟧ = new r in x!((v,*r)) | for( _ ← r ){ ⟦P⟧ }
   - x!?(v).
    ⟦x!?(v).⟧ = x!?(v);0

 - Sequential let expressions: let ptrn_1 ← v_1 ; ... ; ptrn_m ← v_m in P
   ⟦let ptrn_1 ← v_1 ; ... ; ptrn_n ← v_n in P ⟧ = new x in { x!(v_1) | for( ptrn_1 ← x_1 ){ ⟦let ptrn_2 ← v_2 ; ... ; ptrn_n ← v_n in P ⟧ } }

 - Simultaneous let expressions: let ptrn_1 ← v_1 & ... & ptrn_m ← v m in P
   ⟦let ptrn_1 ← v_1 & ... & ptrn_n ← v_n in P ⟧ = new x_1 , ... , x_n in { x_1 !(v_1) | ... | x_n!(v_n) | for( ptrn_1 ← x_1 & ... & ptrn_n ← x_n ){ ⟦P⟧ }
*/

require "domains.k"
require "AuxFun/auxfun.k"
require "Match/match.k"
require "Names_Variables/namevar.k"
require "Substitute/sub.k"
require "StructuralEquiv/struct.k"

// SYNTAX MODULE
module GRHO-SYNTAX
  import DOMAINS

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
  syntax          NameVar ::= Var
  syntax        EmptyName ::= "EmptyN" // listening for empty messages
  syntax           NewUri ::= NameVar "(" Uri ")"

// Several Names
  syntax            Names ::= Name "," Name
                            | Name "," Names [right]

// For pattern binding
//  syntax          NamePat ::= Name | Pattern
//  syntax         NamePats ::= NamePat "," NamePat
//                            | NamePat "," NamePats

//-----------------
//--- PROCESSES ---
//-----------------
// TODO: Finalize precedence
  syntax             Proc ::= "{" Proc "}"    [bracket]
                            > New             // New name declaration(s)
                            > Ground          // Ground terms - Bool, Int, Nil, String, Uri
                            | Collection      // Data structures - List, Map, Set, Tuple
                            | ProcVar         // Process variable
                            > VarRef          // Variable references - Name/Process variable shadowing
                            > Eval            // Evaluation
                            > MethodProc      // Methods
                            > Exp             // Arithmetic & Boolean expressions
                            > Match           // Process matching
                            > Select          // Nondeterministic selection
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
                            | Proc "," Procs [right]

// Parallel composition
  // Par should be a multiset of processes
    // each nonPar Proc is put into it's own <k/> cell in GRHO 
    // implemented as a multiset in STRUCT
  syntax              Par ::= Proc "|" Proc  [right]

// Receives - no mixed linear/peek/repeated/sequential
// TODO: add Name patterns
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
  syntax     GuardedBinds ::= Binds Guard // instead Lbinds Guard | Pbinds Guard | Rbinds Guard?
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
  syntax              New ::= "new" Name  "in" "{" Proc "}"
                            | "new" Names "in" "{" Proc "}"

// Match
  syntax            Match ::= "match" "{" Proc "}" "{" MatchCases "}"
                            | "match" "{" Proc "}" "{" MatchCase  "}"
  // TODO: make MatchCase ::= "{" "{" PrcoPat "}" ":=>" Proc "}"
  syntax        MatchCase ::= "{" Proc "}" "|=>" Proc
  syntax       MatchCases ::= MatchCase MatchCase
                            | MatchCase MatchCases

// Select
  syntax            Select ::= "select" "{" Branch   "}"
                             | "select" "{" Branches "}"

  syntax            Branch ::= "{" Lbind "}" "|=>" Proc
  syntax          Branches ::= Branch Branch
                             | Branch Branches

// Variable Reference - allows for shadowing
  syntax           VarRef ::= "=" "*" NameVar
                            | "=" ProcVar

// Conditional
  syntax      Conditional ::= IfThen | Else

  syntax           IfThen ::= "if" "(" BExp ")" Proc  [strict(1)]
  syntax             Else ::= IfThen "else" Proc

// Contract - syntactic sugar for persistent receive
  syntax         Contract ::= "contract" Name "(" Names ")" "=" "{" Proc "}"
                            | "contract" Name "(" Name  ")" "=" "{" Proc "}"
                            | "contract" Name "(" ")" "=" "{" Proc "}"

// Contract Invocation
  // keyword "invoke" added to disambiguate from NewUri
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
  syntax           RhoSet ::= "Set(" Procs ")"
                            | "Set(" Proc  ")"
                            | "Set(" ")"

  // Process tuples
  syntax         RhoTuple ::= "(" Procs ")"  [klabel(tuple)]
                            | "(" Proc ",)"
                         // | "(" ")"        [klabel(tuple)]

// Ground terms
  syntax           Ground ::= Bool | Int | String // built-in
                            | "Nil"        // stopped process
                            | Unforgeable | Uri
  syntax      Unforgeable ::= "unforgeable(" Int ")"

  syntax              Uri ::= "`" NativeChan "`"
  syntax       NativeChan ::= NativeIO
// TODO: add other native channels
  syntax         NativeIO ::= "rho:io:stdout"
                            | "rho:io:stdoutAck"

// Expressions resolve to ground terms
  syntax              Exp ::= "{" Exp "}" [bracket]
                            | AExp
                            | StringExp
                            > BExp


// Arithmetic
  syntax         IntOrVar ::= Int | ProcVar | Eval
  syntax             AExp ::= "{" AExp "}" [bracket]
                            > IntOrVar
                            > "-" AExp       [strict]
                            > AExp "%" AExp  [strict] // mod reduction
                            > AExp "*" AExp  [strict, left]
                            | AExp "/" AExp  [strict, left]
                            > AExp "+" AExp  [strict, left]
                            | AExp "-" AExp  [strict, left]

// String
  syntax      StringOrVar ::= String | ProcVar | Eval
  syntax        StringExp ::= "{" StringExp "}" [bracket]
                            > StringOrVar
                            | Concat  // string concatenation
                            | Interp  // string interpolation: "${key}rest" %% { key:value , ... } => "value" ++ "rest"

  syntax           Concat ::= StringOrVar ConcatExp
  syntax        ConcatExp ::= "++" StringOrVar
                            | "++" StringOrVar ConcatExp

  syntax           Interp ::= StringOrVar "%%" InterpMaps
  syntax       InterpMaps ::= RhoMap
                            | RhoMap "%%" InterpMaps

// Boolean
  syntax             BExp ::= "{" BExp "}"   [bracket]
                            > Bool                // boolean output
                            | ProcVar             // e.g. \x == Proc or not \x
                            | Eval                // e.g. *x == Proc or not *x
                            > AExp "<=" AExp      [seqstrict]
                            | AExp "<"  AExp      [seqstrict]
                            | AExp ">=" AExp      [seqstrict]
                            > AExp ">"  AExp      [seqstrict]
                            | Name "==" Name      // name equivalence
                            | Name "!=" Name      // not ( Name == Name )
                            | Proc "==" Proc      // structural equivalence
                            | Proc "!=" Proc      // not ( Proc == Proc )
                            > "not" BExp          [strict]
                            > BExp "and" BExp     [strict(1), right]
                            > BExp "or"  BExp     [strict(1), right]
                            > Proc "matches" Proc // P matches Q is syntactic sugar for: match P { { Q :=> true } { P :=> false } }

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}"   // write-only
                            | "bundle-" "{" Proc "}"   // read-only
                            | "bundle0" "{" Proc "}"   // neither read/write
                            | "bundle"  "{" Proc "}"   // both read/write

// #isProc Predicate
  syntax             Bool ::= "#isProc(" K ")" // tests if term has type Proc and no free variables
                            | "#isName(" K ")" // tests if term has type Name and no free variables

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

// Patterns
//  syntax          Pattern ::= "#"
//                            | "@" "#"

// For De Bruijn indices & alpha/structural equivalence
  syntax             Name ::= BoundName
  syntax        BoundName ::= "boundN(" Int ")"
  syntax        BoundName ::= "boundN(" Int "," Int ")"

  syntax             Proc ::= BoundProc
  syntax        BoundProc ::= "boundP(" Int ")"
  syntax        BoundProc ::= "boundP(" Int "," Int ")"

  syntax             AExp ::= BoundProc // for substitution of variables in AExps
  syntax             BExp ::= BoundProc // for substitution of variables in BExps

// For substitution
  syntax              Sub ::= "sub"
  syntax             Name ::= "@" Sub
  syntax             Proc ::= Sub

// Builtins are processes too
  syntax             Proc ::= List | Map | Set
  syntax              Map ::= RhoMap
  syntax              Set ::= RhoSet

// For K
  syntax            KItem ::= Name | Names | Proc | Procs | RhoKVPair

endmodule

// SEMANTICS MODULE
module GRHO
  import AUXFUN
  import MATCH
  import NAMEVAR
  import SUB
  import ALPHA
  import STRUCT

//---------------------
//--- CONFIGURATION ---
//---------------------
  configuration
    <T color="purple">                                  //
      <activity color="red">                            //**activity threads**
        <task color="green" multiplicity="*">           // collection of concurrent tasks
//        <k> Error: FreeVars! ~> $PGM:Proc </k>        // Free variable program execution guard (part of type system)
          <k> $PGM:Proc </k>                            // programs and computations are process-based
        </task>                                         //
      </activity>                                       //**tuplespace**
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
      <nextLoc color="gray"> 0 </nextLoc>               //
      <original color="pink">                           //
        $PGM                                            // parsed original program
      </original>                                       //
      <OGfreevar color="pink">                          //
        FV($PGM)                                        // set of free variables of original program
      </OGfreevar>                                      //
      <OGdeBruijn color="pink">                         //
        #deBruijn(0;$PGM;.Map)                          // De Bruijn indexed original program
      </OGdeBruijn>                                     //
    </T>                                                //

  syntax KResult ::= Ground | Eval | List | Map | Set   // final output of strict operations

// Free variable execution guard
//  syntax KItem ::= "Error: FreeVars!"
// Remove free variable error guard if program is closed
//  rule <k> (Error: FreeVars! ~> P:Proc) => P </k>
//       <free> .Set </free>

// Arithmetic & Boolean expressions are evaluated as soon as they can be
  // Arithmetic expressions
  rule I:Int + J:Int => I +Int J                     [anywhere, structural] // addition
  rule I:Int - J:Int => I -Int J                     [anywhere, structural] // subtraction
  rule I:Int * J:Int => I *Int J                     [anywhere, structural] // multiplication
  rule I:Int / J:Int => I /Int J requires J =/=Int 0 [anywhere, structural] // division
  rule I:Int % J:Int => I %Int J requires J =/=Int 0 [anywhere, structural] // modular reduction
  rule - I:Int => 0 -Int I                           [anywhere, structural] // negation
  
  // string concatenation
  rule S:String ++ T:String => S +String T [anywhere, structural]
  rule S:String ++ T:String U:ConcatExp => S +String T U [anywhere, structural]
  // string interpolation: "begin${key}rest" %% { ..., key:value ,... } => "begin" ++ "value" ++ "rest"
  rule S:String %% R:RhoMap => #interpolate(S;R) [anywhere, structural]
  rule S:String %% R:RhoMap %% T:InterpMaps => #interpolate(S;R) %% T [anywhere, structural]

  // Boolean expressions
  rule I1:Int <= I2:Int => I1 <=Int I2 [anywhere, structural]
  rule I1:Int <  I2:Int => I1  <Int I2 [anywhere, structural]
  rule I1:Int >= I2:Int => I1 >=Int I2 [anywhere, structural]
  rule I1:Int >  I2:Int => I1  >Int I2 [anywhere, structural]
  rule not B:Bool => notBool B         [anywhere, structural]
    // short-circuited
  rule true  and B:Bool => B     [anywhere, structural]
  rule false and _:Bool => false [anywhere, structural]
  rule true  or  _:Bool => true  [anywhere, structural]
  rule false or  B:Bool => B     [anywhere, structural]

// Structural Equivalence
  // Syntactic equality of Ground terms -- checked immediately
  rule A:Ground == B:Ground => A ==K  B [anywhere, structural]
  rule A:Ground != B:Ground => A =/=K B [anywhere, structural]
  // if only one term is Ground, we wait for the other -- e.g. in *x == true, we must wait on a value for x before computing
  // if both terms are not Ground, check structural equivalence immediately
  rule P:Proc == Q:Proc => #structEq(P;Q) requires notBool (isGround(P) orBool isGround(Q)) [anywhere, structural]
  rule P:Proc != Q:Proc => notBool #structEq(P;Q) requires notBool (isGround(P) orBool isGround(Q)) [anywhere, structural]
  rule M:Name == N:Name => #nameEq(M;N) [anywhere, structural]
  rule M:Name != N:Name => notBool #nameEq(M;N) [anywhere, structural]

// Conditionals -- short-circuited
  rule if ( true  ) P:Proc => P              [structural]
  rule if ( false ) _:Proc => Nil            [structural]
  rule if ( true  ) P:Proc else _:Proc => P  [structural]
  rule if ( false ) _:Proc else Q:Proc => Q  [structural]

// Matching -- #match predicate is still rather primative...
  // "matches" binop desugars into "match" statement
  rule P:Proc matches Q:Proc => #match(P;Q) [structural]
  // TODO: replace P ==K Q with P #isIn Q
  rule match { P:Proc } { { Q:Proc } |=> R:Proc } => #if #match(P;Q) #then #sub(P;Q;R) #else Nil #fi
  rule match { P:Proc } { { Q:Proc } |=> R:Proc M:MatchCase  } => #if #match(P;Q) #then #sub(P;Q;R) #else match {P}{M} #fi
  rule match { P:Proc } { { Q:Proc } |=> R:Proc M:MatchCases } => #if #match(P;Q) #then #sub(P;Q;R) #else match {P}{M} #fi

// New Operator Semantics
  rule <k> new M:NameVar in { P:Proc } => #sub(@unforgeable(L);M;P) ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  // TODO: special channel map needed for Uri?
  rule <k> new M:NameVar ( _:Uri ) in { P:Proc } => #sub(@unforgeable(L);M;P) ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  
  rule <k> new M:NameVar , N:Name  in { P:Proc } => new N in {#sub(@unforgeable(L);M;P)} ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  rule <k> new M:NameVar ( _:Uri ) , N:Name  in { P:Proc } => new N in {#sub(@unforgeable(L);M;P)} ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
       
  rule <k> new M:NameVar , N:Names in { P:Proc } => new N in {#sub(@unforgeable(L);M;P)} ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>
  rule <k> new M:NameVar ( _:Uri ) , N:Names in { P:Proc } => new N in {#sub(@unforgeable(L);M;P)} ...</k>
       <nextLoc> L => L +Int 1 </nextLoc>

// TODO: is this what I want?
// Syntactic sugar - contract desugars into unconsumable receive
  rule contract X:Name ( Y:Names ) = { P:Proc } => for( Y <= X ){ P }  [anywhere, structural]
  rule contract X:Name ( Y:Name  ) = { P:Proc } => for( Y <= X ){ P }  [anywhere, structural]
  rule contract X:Name (         ) = { P:Proc } => for(   <= X ){ P }  [anywhere, structural]

// Par Operator Semantics - concurrent execution of processes
  rule <task>
         <k> P:Proc | Q:Proc => Q ...</k>
       </task>
       (.Bag => <task> <k> P </k> </task>)
       requires notBool isPar(P)

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
  rule (<task> <k> S:Send </k> </task> => .Bag) // dissolve send in <activity/> and spawn <send/>
       (.Bag => <send>
                  <schan>   #chan(S) </schan>  // sending channel
                  <msg>      #msg(S)   </msg>  // sending message(s)
                  <tuple> #msglen(S) </tuple>  // number of messages
                  <stype>  #stype(S) </stype>  // send type
                </send>)

//----------------------------------
//--- Receive Operator Semantics ---
//----------------------------------
  rule (<task> <k> R:SingleRec </k> </task> => .Bag) // dissolve Rec in <activity/> and spawn <rec/>
       (.Bag => <rec>
                  <rchan>  #chan(R) </rchan>  // receiving channel
                  <bvars>  #bvar(R) </bvars>  // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>  // number of binding variables
                  <rtype> #rtype(R) </rtype>  // receive type
                  <guard> #guard(R) </guard>  // input guard - restricts acceptable inputs
                  <cont>   #cont(R)  </cont>  // continuation
                </rec>)

// Joins
  rule (<task> <k> R:MultiRec </k> </task> => .Bag)
       (.Bag => <rec>
                  <rchan>  #chan(R) </rchan>  // receiving channel
                  <bvars>  #bvar(R) </bvars>  // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>  // number of variables to bind
                  <rtype> #rtype(R) </rtype>  // receive type
                  <cont>   #cont(R)  </cont>  // continuation
                  <guard> #guard(R) </guard>  // input guard - restricts acceptable inputs
                </rec>)

//-------------------
//--- COMM EVENTS ---
//-------------------
// Communication over name equivalent channels
// x!(Q) | for( z <- y ){P} => #sub(@Q;z;P) requires #nameEq(x;y)

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
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>) 
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
/*  andBool #match(@Q;Y) */ [comm]         // checks if sent messages match the variable being listened for

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
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
/*  andBool #match(#quotes(Q);Y) */ [comm] // checks if sent messages match the variables being listened for

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
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
/*  andBool #match(@Q;Y) */ [comm]         // checks if sent messages match the variable being listened for

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
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 0       </stype>              // linear send
   </send> => .Bag)                        //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
/*  andBool #match(#quotes(Q);Y) */ [comm] // checks if sent messages match the variables being listened for

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
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 1       </stype>              // persistent send
   </send>                                 //
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
/*  andBool #match(@Q;Y) */ [comm]         // checks if sent messages match the variable being listened for

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
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> 1       </stype>              // persistent send
   </send>                                 //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
/*  andBool #match(#quotes(Q);Y) */ [comm] // checks if sent messages match the variables being listened for

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
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Proc    </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> _       </stype>              // any kind of send
   </send>                                 // 
   (.Bag => <task> <k> #sub(@Q;Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
/*  andBool #match(@Q;Y) */ [comm]         // checks if sent messages match the variable being listened for

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
     <schan> Z:Name  </schan>              // channel Z
     <msg>   Q:Procs   </msg>              // message(s) Q
     <tuple> N       </tuple>              // number of messages matches number of names to bind
     <stype> _       </stype>              // any kind of send
   </send>                                 //
   (.Bag => <task> <k> #sub(#quotes(Q);Y;P) </k> </task>)
   requires #subGuard(Q;Y;B)               // checks if input guard is satisfied
    andBool #nameEq(X;Z)                   // checks if channels are name equivalent
/*  andBool #match(#quotes(Q);Y) */ [comm] // checks if sent messages match the variables being listened for

// Join semantics seem to be much more complicated than single listens...
// moved progress to join.k

// Eliminate Nil in parallel compositions
  rule    Nil | P:Proc => P  [structural]
  rule P:Proc | Nil    => P  [structural]

// Dissolve computationally meaningless activity
  rule <task> <k> .K  </k> </task> => .Bag  [structural]
  rule <task> <k> Nil </k> </task> => .Bag  [structural]

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q
  rule @ * N:Name => N  [anywhere, structural]
  rule * @ P:Proc => P  [anywhere, structural]

// Predicates for closed terms
  rule #isProc( A:Proc ) => FV(A) <=Set .Set
  rule #isProc( A:K    ) => false [owise]

  rule #isName( A:Name ) => FV(A) <=Set .Set
  rule #isName( A:K    ) => false [owise]

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