// RHO CALCULUS with Bool, Int, String ground terms and Rholang features in a monadic style
// No patterns, only name variables

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

  syntax  NameListOrEmpty ::= "#"                       [klabel(emptyName)] //  #: -----> NameListOrEmpty
	        | NameList                                      // NameList < NameListOrEmpty

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

// Parallel
  syntax              Par ::= Proc "|" Proc                          [left] // _|_: Proc x Proc ---> Par

// Receives - no mixed linear/peek/repeated/sequential
// TODO: Input guards - e.g. for( y <- x if x > 0 ){ ... }

  syntax          Receive ::= SingleRec                                     // SingleRec < Receive, single listen receive
                            | MultiRec                                      //  MultiRec < Receive, multi-listen receive = join

  syntax        SingleRec ::= "for" "(" Bind  ")" "{" Proc "}"              // for(_){_}: Bind x Proc ----> SingleRec; one listen
                            | GuardedSingleRec                              // GuardedSingleRec < SingleRec

  syntax GuardedSingleRec ::= "for" "(" Bind Guard ")" "{" Proc "}"         // for(_){_}: Bind x Proc ----> SingleRec; one listen

  syntax         MultiRec ::= "for" "(" Binds ")" "{" Proc "}"              // for(_){_}: Binds x Proc ---> MultiRec; several listens
                            | GuardedMultiRec                               // GuardedMultiRec < MultiRec

  syntax  GuardedMultiRec ::= "for" "(" Binds Guard ")" "{" Proc "}"        // for(_){_}: Binds x Proc ---> MultiRec; several listens
  
  syntax            Guard ::= "if" BExp                                     // conditional

  syntax            Lbind ::= NameListOrEmpty "<-" Name         [strict(2)] // for( y1,...,yN <- x ){ P } (explicit)

  syntax           Lbinds ::= Lbind ";" Lbind                               // 2 linear listens 
                            | Lbind ";" Lbinds                              // N liner listens, N > 2

  syntax            Pbind ::= NameListOrEmpty "<!" Name         [strict(2)] // for( y1,...,yN <! x ){ P } (explicit)

  syntax           Pbinds ::= Pbind ";" Pbind                               // 2 peeks
                            | Pbind ";" Pbinds                              // N peeks, N > 2

  syntax            Rbind ::= NameListOrEmpty "<=" Name         [strict(2)] // for( y1,...,yN <= x ){ P } (explicit)

  syntax           Rbinds ::= Rbind ";" Rbind                               // 2 repeated listens
                            | Rbind ";" Rbinds                              // N repeated listens, N > 2

  syntax            Sbind ::= NameListOrEmpty "<<" Name         [strict(2)] // for( y1,...,yN << x ){ P } (explicit)

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

  syntax        LbindList ::= Lbind                                         // single linear listen, implicit
                            | Lbinds                                        // multiple linear listens, implicit

  syntax        PbindList ::= Pbind                                         // single peek, implicit
                            | Pbinds                                        // multiple peeks, implicit

  syntax        RbindList ::= Rbind                                         // single repeated listen, implicit
                            | Rbinds                                        // multiple repeated listens, implicit

  syntax        SbindList ::= Sbind                                         // single sequential listen, implicit
                            | Sbinds                                        // several sequential listens, implicit

  syntax         BindList ::= Bind                                          // one listen
                            | Binds                                         // several listens

// Send
  syntax             Send ::= ConsumableSend                                //   ConsumableSend < Send
                            | UnconsumableSend                              // UnconsumableSend < Send

  syntax   ConsumableSend ::= Name "!"  "(" ProcListOrEmpty ")"    [strict] //  _!(_): Name x ProcListOrEmpty ---> ConsumableSend

  syntax UnconsumableSend ::= Name "!!" "(" ProcListOrEmpty ")"    [strict] // _!!(_): Name x ProcListOrEmpty ---> UnconsumableSend

// Eval
  syntax             Eval ::= "*" Name                                      // *_: Name ---> Eval 

// Several Processes
  syntax            Procs ::= Proc "," Proc                                 // _,_: Proc x Proc ----> Procs
                            | Proc "," Procs                                // _,_: Proc x Procs ---> Procs

  syntax         ProcList ::= Proc                                          //  Proc < ProcList
                            | Procs                                         // Procs < ProcList

  syntax  ProcListOrEmpty ::= "#"                       [klabel(emptyProc)] //        # < ProcListOrEmpty; 0 processes
                            | ProcList                                      // ProcList < ProcListOrEmpty; 1 or more processes

// New
  syntax              New ::= "new" NameList "in" "{" Proc "}"     [binder] // new _ in {_}: NameList x Proc ---> New; creates unforgeable names

// Match
  syntax            Match ::= "match" Proc "{" MatchCaseList "}"            // match_{_}: Proc x MatchCaseList ---> Match

  syntax        MatchCase ::= Proc ":=>" Proc                               // _:=>_: Proc x Proc -------------> MatchCase

  syntax       MatchCases ::= MatchCase MatchCase                           // _ _: MatchCase x MatchCase -----> MatchCases
                            | MatchCase MatchCases                          // _ _: MatchCase x MatchCases ----> MatchCases

  syntax    MatchCaseList ::= MatchCase                                     //  MatchCase < MatchCaseList
                            | MatchCases                                    // MatchCases < MatchCaseList

// Methods
  syntax       MethodProc ::= Proc "." MethodAndArgs                        // _._(_): Proc x MethodAndArgs ---> MethodProc

  syntax    MethodAndArgs ::= Method "(" ProcListOrEmpty ")"                // _(_): Method x MethodArgs ------> MethodAndArgs

  syntax           Method ::= "nth"                                         // nth element in list, tuple // syntax: Thing.nth(Int, ack) 
                            | "toByteArray"                                 // bytearray
                            | "hexToBytes"                                  // hex -> bytes
                            | "union"                                       // map, set union
                            | "diff"                                        // map, set difference
                            | "add"                                         // concat list?
                            | "delete"                                      // delete element from 
                            | "contains"                                    // contains predicate
                            | "get"                                         // get - get element or Nil
                            | "getOrElse"                                   // getOrElse - get element or side condition
                            | "set"                                         // set - substitution?
                            | "keys"                                        // return set of keys of a map
                            | "size"                                        // number of elements in list, map, set, tuple
                            | "length"                                      // length of list, tuple - different from size?
                            | "slice"                                       // slice of list, map, or set
                            | "confine"                                     // semantics?

// Variable Reference
  syntax           VarRef ::= "=" "*" NameVar                               // =*_: NameVar ---> VarRef

// Conditional
  syntax      Conditional ::= IfThen                                        // if ... then ...
                            | Else                                          // if ... then ... else

  syntax           IfThen ::= "if" "(" BExp ")" "then" Proc    [strict(1)]  // if ... then ...
 
  syntax             Else ::= IfThen "else" Proc                            // if ... then ... else ...

// Contract
  syntax         Contract ::= "contract" Name "(" NameListOrEmpty ")" "=" "{" Proc "}"  // syntactic sugar => for( NameList <= Name ){ Proc }

// Contract Invocation
  syntax       Invocation ::= Name RhoTuple                                 // _ _: Name x RhoTuple

// Collections
  syntax       Collection ::= RhoList                                       //  RhoList < Collection
                            | RhoMap                                        //   RhoMap < Collection
                            | RhoSet                                        //   RhoMap < Collection
                            | RhoTuple                                      // RhoTuple < Collection

// Process lists
  syntax          RhoList ::= "[" ProcListOrEmpty "]"                       // [_]: ProcListOrEmpty ----> RhoList

// Process maps
  syntax           RhoMap ::= "{" RhoKVPairsOrEmpty "}"                     // {_}: RhoKVPairsOrEmpty ---> RhoMap

  syntax       RhoKVPairs ::= Proc ":" Proc                                 //   _:_: Proc x Proc ----------------> RhoKVPairs, single key-value pair
                            | Proc ":" Proc "," RhoKVPairs                  // _:_,_: Proc x Proc x RhoKVPairs ---> RhoKVPairs, map size > 1

  syntax
        RhoKVPairsOrEmpty ::= "#"                         [klabel(emptyKV)] //            < RhoKVPairsOrEmpty; empty map
                            | RhoKVPairs                                    // RhoKVPairs < RhoKVPairsOrEmpty; 1 or more key-value pairs

// Process sets
  syntax           RhoSet ::= "Set" "(" ProcListOrEmpty ")"                 // Set(_): ProcList ----> RhoSet

// Process tuples
  syntax         RhoTuple ::= "(" ProcListOrEmpty ")"       [klabel(tuple)] // (_): ProcList ----> RhoTuple

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
                            > AExp "*" AExp                        [strict] // _*_: AExp x AExp ---> AExp
	        | AExp "/" AExp                        [strict] // _/_: AExp x AExp ---> AExp
                            > AExp "+" AExp                        [strict] // _+_: AExp x AExp ---> AExp
                            | AExp "-" AExp                        [strict] // _-_: AExp x AExp ---> AExp
	       // AExp "%" AExp                        [strict] // _%_: AExp x AExp ---> AExp
  
  syntax           String ::= String "++" String                            // _++_: String x String ---> String (concatenation)
            // Interpolation: "${key}..." %% { key:value } => "value" ++ "..."
            // Slice:         "abcdefgh".slice(2,5) => "cde"
            // hexToBytes: interpret input as hex => bytes

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
	        | Proc "==" Proc                                // _==_: Proc x Proc ---> BExp (sturtural equivalence) // currently in progress
                            > "not" BExp                           [strict] // not_: BExp ----------> BExp
                            > BExp "and" BExp                   [strict(1)] //  and: BExp ----------> BExp
                            > BExp  "or" BExp                      [strict] //   or: BExp ----------> BExp

// Bundles
  syntax           Bundle ::= "bundle+" "{" Proc "}"                        // write-only
                            | "bundle-" "{" Proc "}"                        // read-only
                            | "bundle0" "{" Proc "}"                        // neither read/write
                            | "bundle"  "{" Proc "}"                        // both read/write

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

  syntax            KItem ::= Name | Names | Proc | Procs | Set | IdNum | "free"
  
/* TODO: add contract invocation(?): Name "(" ProcList ")"
             process field(?) -- like records?
             other specs???
*/

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
          <k>   $PGM:Proc  </k>                                      // programs and computations are process-based
          <lenv>  .Map  </lenv>                                      // thread local environment
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
            <cont>   .K   </cont>                                    // continuation
            <rbind> .Map </rbind>                                    // 
          </rec>                                                     // 
        </receives>                                                  // 
      </tuplespace>                                                  // 
      <reaction>                                                     //**where the magic happens**
        <who>     .K     </who>                                      // continuation process
        <what>    .K    </what>                                      // msg process(es)
        <where>   .K   </where>                                      // binding variable(s)
        <update> .Map </update>                                      // updated variable binding(s)
      </reaction>                                                    // all comms are processed here
    </T>                                                             // 

  syntax KResult ::= Ground | Eval                                   // final output of strict operations

// Arithmetic
  rule I1:Int + I2:Int => I1 +Int I2                      [anywhere] //
  rule I1:Int - I2:Int => I1 -Int I2                      [anywhere] //
  rule I1:Int * I2:Int => I1 *Int I2                      [anywhere] //
  
  rule S1:String ++ S2:String => S1 +String S2            [anywhere] //

// Boolean
  rule I1:Int <= I2:Int => I1 <=Int I2                    [anywhere] //
  rule I1:Int <  I2:Int => I1  <Int I2                    [anywhere] //
  rule I1:Int >= I2:Int => I1 >=Int I2                    [anywhere] //
  rule I1:Int >  I2:Int => I1  >Int I2                    [anywhere] //
  rule not B:Bool => notBool B                            [anywhere] //
  rule A:Bool and B:Bool => A andBool B                   [anywhere] //

// Conditionals
  rule if ( B:Bool ) then P:Proc             => #if B #then P #else Nil #fi
  rule if ( B:Bool ) then P:Proc else Q:Proc => #if B #then P #else Q   #fi

// New Operator Semantics
  rule new N:Name           in { P:Proc } => P[ unforgeable(!I:Int) / N ] // 
  rule new M:Name , N:Name  in { P:Proc } => new N in { P[ unforgeable(!I:Int) / M ] } // 
  rule new M:Name , N:Names in { P:Proc } => new N in { P[ unforgeable(!I:Int) / M ] } // 

// Par Operator Semantics
  rule <thread>
         <k> P:Proc | Q:Proc => . ...</k>                                  // 
         <lenv>       B:Map       </lenv>                                  // 
       </thread>                                                           // 
       (.Bag => <thread> <k> P </k> <lenv> B </lenv> </thread>)            // 
       (.Bag => <thread> <k> Q </k> <lenv> B </lenv> </thread>)  [unravel] // 

// Contract
  rule contract X:Name ( Y:NameList ) = { P:Proc } => for ( Y <= X ){ P }  [macro]  // syntactic sugar

//-------------------------------
//--- Send Operator Semantics ---
//-------------------------------
// TODO: handle variable reference/assignment before sending to tuplespace
  rule <thread>
         <k> S:Send => . ...</k>                                     // dissolve send in <threads/> and spawn <send/>
         <lenv>  B:Map  </lenv>                                      // 
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
//TODO: sequential listen
  rule <thread>
         <k> R:SingleRec => . ...</k>                                // dissolve Rec in <threads/> and spawn <rec/>
         <lenv>  B:Map  </lenv>                                      // 
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
         <lenv>  B:Map  </lenv>                                      // 
       </thread>                                                     // 
       (.Bag => <rec>                                                // 
                  <rchan>  #chan(R) </rchan>                         // receiving channel
                  <bvars>  #bvar(R) </bvars>                         // variable(s) to be substituted in continuation
                  <bnum>   #bnum(R)  </bnum>                         // 
                  <rtype> #rtype(R) </rtype>                         // receive type
                  <cont>   #cont(R)  </cont>                         // continuation
                  <rbind>        B  </rbind>                         // 
                </rec>)                                              //

//-------------------
//--- COMM EVENTS ---
//-------------------
// x!(Q) | y(z){P} and x equivN y => P[@Q / y]

// Reaction Cell Semantics - quarantined reaction cell for processing comm events
// N substitutions, N > 2
  rule 
    <reaction>
      <who>    P:Proc => P[@ Q / Y]      </who>  // instead of directly substituting, update bindings(?)
      <what>   Q:Proc , R:Procs => R    </what>
      <where>  Y:Name , Z:Names => Z   </where>
      <update> B:Map  => B[ Y <- @Q ] </update>
    </reaction>                                      [react]

// 2 substitutions
  rule
    <reaction>
      <who>    P:Proc => P[@ Q / Y]      </who>  // instead of directly substituting, update bindings(?)
      <what>   Q:Proc , R:Proc => R     </what>
      <where>  Y:Name , Z:Name => Z    </where>
      <update> B:Map  => B[ Y <- @Q ] </update>
    </reaction>                                      [react]

// Final substitution spawn in a new thread holding the fully substituted continuation
  rule
    <reaction>
      <who>    P:Proc =>  .K     </who>
      <what>   Q:Proc =>  .K    </what>
      <where>  Y:Name =>  .K   </where>
      <update> B:Map  => .Map </update>
    </reaction>
   (.Bag => <thread> <k> P[@ Q / Y] </k> <lenv> B[ Y <- @Q ] </lenv> </thread>)  [react]  // instead of directly substituting, update bindings(?)

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

// Join semantics seem to be much more complicated...
// moved progress to join.k

// Methods
// nth
  // List
  rule [ # ].nth( _:ProcListOrEmpty ) => Nil
  rule _:RhoList .nth( # ) => Nil
  rule [ P:Proc ].nth( I:Int , A:Proc ) => #if I ==Int 0 #then @A!(P) #else Nil #fi
  rule [ P:Proc , Q:Proc  ].nth( I:Int , A:Proc ) => #if I ==Int 0 #then @A!(P) #else [ Q ].nth( I -Int 1 , A ) #fi
  rule [ P:Proc , Q:Procs ].nth( I:Int , A:Proc ) => #if I ==Int 0 #then @A!(P) #else [ Q ].nth( I -Int 1 , A ) #fi
  
  // Tuple
  rule (#):RhoTuple .nth( _:ProcListOrEmpty ) => Nil
  rule _:RhoTuple .nth( # ) => Nil
  rule ( P:Proc ):RhoTuple .nth( I:Int , A:Proc ) => #if I ==Int 0 #then @A!(P) #else Nil #fi
  rule ( P:Proc , Q:Proc  ):RhoTuple .nth( I:Int , A:Proc ) => #if I ==Int 0 #then @A!(P) #else tuple( Q ).nth( I -Int 1 , A ) #fi
  rule ( P:Proc , Q:Procs ):RhoTuple .nth( I:Int , A:Proc ) => #if I ==Int 0 #then @A!(P) #else tuple( Q ).nth( I -Int 1 , A ) #fi

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P                               [structural]
  rule P:Proc | Nil    => P                               [structural]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> <lenv> .Map </lenv> </thread> => .Bag  [structural] //empty threads
  rule <thread> <k> Nil </k> <lenv> .Map </lenv> </thread> => .Bag  [structural] //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)
  rule   @ * N:Name => N                         [anywhere,structural] //

// INVERSES
  rule   * @ P:Proc => P                         [anywhere,structural] //

endmodule