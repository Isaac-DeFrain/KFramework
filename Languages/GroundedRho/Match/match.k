// Preliminary pattern-matching for GRHO
// Types must be the same for match to be successful
// Lengths of messages are checked in GRHO

require "domains.k"
require "../AuxFun/auxfun.k"
require "../grho.k"
require "../Substitute/sub.k"

module MATCH-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// #match predicate checks that the terms match
  syntax   Bool ::= "#match("   Proc  ";" Proc  ")" [function]
                  | "#match("   Name  ";" Name  ")" [function]
                  | "#match("   Procs ";" Procs ")" [function]
                  | "#match("   Names ";" Names ")" [function]
                  | "#matchif(" Procs ";" Procs ")" [function]
                  | "#matchif(" Names ";" Names ")" [function]
                  | "#match(" ConcatExp  ";" ConcatExp  ")" [function]
                  | "#match(" InterpMaps ";" InterpMaps ")" [function]

  syntax   Bool ::= "#match(" RhoKVPair  ";" RhoKVPair  ")" [function]
                  | "#match(" RhoKVPairs ";" RhoKVPairs ")" [function]

endmodule

module MATCH
  import MATCH-SYNTAX
  import AUXFUN
  import SUB

//  syntax KResult ::= Bool

// #matchif
  rule #matchif( A:Names ; B:Names ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Procs ; B:Procs ) => #length(A) ==Int #length(B) andBool #match(A;B)

// Name matching
  rule #match( A:Name    ;  A ) => true // any Name matches itself
  rule #match( A:Name    ;  B:NameVar ) => true // any Name matches a NameVar
  rule #match( A:Name    ; @B:ProcVar ) => true // any Name matches a @ProcVar
  rule #match( A:NameVar ;  B:Name    ) => true requires isNameVar(B) // NameVar can only match a NameVar...
  rule #match( @EmptyP   ;  EmptyN    ) => true // empty send/empty listen matching
  rule #match( A:Name    ;  B:Name    ) => false [owise]

// Process matching
  rule #match( A:Proc    ;  A ) => true // any Proc matches itself
  rule #match( A:Proc    ;  B:ProcVar ) => true // any Proc matches a ProcVar
  rule #match( A:Proc    ; *B:NameVar ) => true // any Proc matches a *NameVar
  rule #match( A:ProcVar ;  B:Proc    ) => true requires isProcVar(B) // ProcVar can only match a ProcVar
  rule #match( A:Proc    ;  B:Proc    ) => false [owise]

// same is true of WildCard

  // Ground only matches itself
  rule #match( A:Ground ; B:Ground ) => A ==K B

  // ProcVar only matches ProcVar or *NameVar
  rule #match( _:ProcVar ; B:Proc ) => false requires notBool (isProcVar(B) orBool isEval(B) orBool isPar(B))

  // Eval matches Eval
  rule #match( *A:Name ; *B:Name ) => #match(A;B) // underlying Names must match
  rule #match(  _:Eval ;  B:Proc ) => false requires notBool (isProcVar(B) orBool isEval(B) orBool isPar(B))

  // Send matching
  rule #match( A:Name !  (         ) ; C:Name !  (         ) ) => #match(A;C)
  rule #match( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! (         ) ; C:Name !! (         ) ) => #match(A;C)
  rule #match( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( _:Send ; B:Proc ) => false requires notBool (isProcVar(B) orBool isEval(B) orBool isPar(B) orBool isSend(B))
  rule #match( A:Proc ; _:Send ) => false requires notBool isSend(A)

  // Receive matching -- TODO: how to handle listen names?
  rule #match( for(         <- A:Name ){ B:Proc } ; for(         <- C:Name ){ D:Proc } ) =>   #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name  <- A:Name ){ B:Proc } ; for( Y:Name  <- C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;D)
  rule #match( for( X:Names <- A:Name ){ B:Proc } ; for( Y:Names <- C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;D)
  rule #match( _:Receive ; _:Par  ) => true
  rule #match( _:Receive ; B:Proc ) => false requires notBool (isReceive(B) andBool isProcVar(B) andBool isPar(B)) [owise]

  rule #match( for(         <= A:Name ){ B:Proc } ; for(         <= C:Name ){ D:Proc } ) =>   #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name  <= A:Name ){ B:Proc } ; for( Y:Name  <= C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;D)
  rule #match( for( X:Names <= A:Name ){ B:Proc } ; for( Y:Names <= C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;D)

  rule #match( for(         <! A:Name ){ B:Proc } ; for(         <! C:Name ){ D:Proc } ) =>   #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name  <! A:Name ){ B:Proc } ; for( Y:Name  <! C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;D)
  rule #match( for( X:Names <! A:Name ){ B:Proc } ; for( Y:Names <! C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;D)

/* TODO:
 Lbinds only match Lbinds
 Pbinds only match Pbinds
 Rbinds only match Rbinds
*/
// Par match - apply after normalization
  rule #match( A:Proc | B:Proc ; C:Proc | D:Proc ) => #match(A;C) andBool #match(B;D) requires notBool (isPar(A) orBool isPar(C))

// Collection matching - empty structures are accomodated by the first rule
  // RhoList matches RhoList (if underlying Procs match), nothing else matches RhoList
  rule #match( [ A:Proc  ] ; [ B:Proc  ] ) => #match(A;B)
  rule #match( [ A:Procs ] ; [ B:Procs ] ) => #matchif(A;B)
  rule #match( A:Proc ; _:RhoList ) => false requires notBool isRhoList(A)
  rule #match( _:RhoList ; A:Proc ) => false requires notBool isRhoList(A)

  // RhoMaps & RhoSets are unordered -> assume canonical ordering
  // RhoMap matches RhoMap (if underlying Procs match), nothing else matches RhoMap
  // TODO: define for KV pairs?
  rule #match( { A:Proc : B:Proc } ; { C:Proc : D:Proc } ) => #match(A;C) andBool #match(B;D)
  // order of KVPairs should not matter!!!
  rule #match( { A:RhoKVPair , B:RhoKVPair  } ; { C:RhoKVPair , D:RhoKVPair  } ) => #match(A;C) andBool #match(B;D)
  rule #match( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs } ) => #match(A;C) andBool #match(B;D) // #matchif (need to count KVPairs)

  // RhoSet matches RhoSet (if underlying Procs match), nothing else matches RhoSet
  rule #match( Set( A:Proc  ) ; Set( B:Proc  ) ) => #match(A;B)
  rule #match( Set( A:Procs ) ; Set( B:Procs ) ) => #matchif(A;B) // order should not matter!!!
  rule #match( A:Proc ; _:RhoSet ) => false requires notBool isRhoSet(A)
  rule #match( _:RhoSet ; A:Proc ) => false requires notBool isRhoSet(A)

  // RhoTuple matches RhoTuple (if underlying Procs match), nothing else matches RhoTuple
  rule #match( ( A:Proc  ,) ; ( B:Proc  ,) ) => #match(A;B)
  rule #match( ( A:Procs ,) ; ( B:Procs ,) ) => #matchif(A;B)
  rule #match( A:Proc ; _:RhoTuple ) => false requires notBool isRhoTuple(A)
  rule #match( _:RhoTuple ; A:Proc ) => false requires notBool isRhoTuple(A)

  // several Procs matching -- used in many other contexts
  rule #match( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Procs ; C:Proc , D:Procs ) => #match(A;C) andBool #matchif(B;D)

// New matching
  // New matches New (if same number of Names declared and Procs match), nothing else matches New
  rule #match( new A:NameVar in { B:Proc } ; new C:NameVar in { D:Proc } ) => #match(B;#sub(A;C;D))
  rule #match( new A:Names   in { B:Proc } ; new C:Names   in { D:Proc } ) => #match(B;#sub(A;C;D))
  rule #match( _:New ; A:Proc ) => false requires notBool isNew(A)
  rule #match( A:Proc ; _:New ) => false requires notBool isNew(A)

// Arithmetic Exps matching
  // AExp matches AExp with matching subexpressions, nothing else matches AExp
  rule #match( - A:AExp ; - B:AExp ) => #match(A;B)
  rule #match( A:AExp *  B:AExp ; C:AExp *  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp /  B:AExp ; C:AExp /  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp +  B:AExp ; C:AExp +  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp -  B:AExp ; C:AExp -  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp %  B:AExp ; C:AExp %  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( _:AExp ; A:Proc ) => false requires notBool isAExp(A)
  rule #match( A:Proc ; _:AExp ) => false requires notBool isAExp(A)

// String Exps
  // only Concat matches Concat
  rule #match( A:StringOrVar B:ConcatExp ; C:StringOrVar D:ConcatExp ) => #match(A;C) andBool #match(B;D) // length ???
  rule #match( ++ A:StringOrVar ; ++ B:StringOrVar ) => #match(A;B)
//  rule #matchif( ++ A:StringOrVar B:ConcatExp ; ++ C:StringOrVar D:ConcatExp  ) => #length(B) ==Int #length(D) andBool #match(A;C) andBool #match(B;D)
  // only Interp matches Interp
  rule #match( A:StringOrVar %% B:InterpMaps ; C:StringOrVar %% D:InterpMaps ) => #match(A;C) andBool #match(B;D) // length ???
  rule #match( A:RhoMap %% B:InterpMaps ; C:RhoMap %% D:InterpMaps ) => #match(A;C) andBool #match(B;D) // length ??
  // only StringExp matches StringExp
  rule #match( _:StringExp ; A:Proc      ) => false requires notBool isStringExp(A)
  rule #match( A:Proc      ; _:StringExp ) => false requires notBool isStringExp(A)

// Boolean Exps matching
  // BExp matches BExp with matching subexpressions, nothing else matches BExp
  rule #match( not A:BExp ; not B:BExp ) => #match(A;B)
  rule #match( A:BExp and B:BExp ; C:BExp and D:BExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:BExp or  B:BExp ; C:BExp or  D:BExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:AExp <=  B:AExp ; C:AExp <=  D:AExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:AExp <   B:AExp ; C:AExp <   D:AExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:AExp >=  B:AExp ; C:AExp >=  D:AExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:AExp >   B:AExp ; C:AExp >   D:AExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Proc ==  B:Proc ; C:Proc ==  D:Proc ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Proc !=  B:Proc ; C:Proc !=  D:Proc ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Name ==  B:Name ; C:Name ==  D:Name ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Name !=  B:Name ; C:Name !=  D:Name ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Proc matches B:Proc ; C:Proc matches D:Proc ) => #match(A;B) andBool #match(C;D)
  rule #match( _:BExp ; A:Proc ) => false requires notBool isBExp(A)
  rule #match( A:Proc ; _:BExp ) => false requires notBool isBExp(A)

// Every Proc matches Par, ProcVar/*NameVar, and itself
// anything matches Par
// Send matches other Send (if underlying channels and messages match), but only Send matches Send
// Receive matches Receive (if the underlying channels, listening variables, and continuations match?), but only Receive matches Receive
// every Proc matches ProcVar, but ProcVar only matches ProcVar
// VarRef matches any VarRef (because underlying variables match), nothing else matches VarRef? 
// Method matches same Method (if Proc and arguments match), nothing else matches Method?
  rule #match( A:Proc . B:Method ( C:Procs ) ; D:Proc . E:Method ( F:Procs ) ) => #match(A;D) andBool B ==K E andBool #match(C;F)
  rule #match( A:Proc . B:Method ( C:Proc  ) ; D:Proc . E:Method ( F:Proc  ) ) => #match(A;D) andBool B ==K E andBool #match(C;F)
  rule #match( A:Proc . B:Method (         ) ; D:Proc . E:Method (         ) ) => #match(A;D) andBool B ==K E
  rule #match( A:Proc ; _:MethodProc ) => false requires notBool isMethodProc(A) [owise]

// Match matching?
// Contract matches Contract like Receive, nothing else matches Contract
// Invocation matches Invocation like Contract, nothing else matches Invocation
// Bundle matches Bundle (if sign & underlying Procs match), nothing else matches Bundle
// Conditional matches Conditional (if underlying BExp and Procs match), nothing else matches Conditional

//---------------------
//--- Name matching ---
//---------------------

// Primitive matching
  rule #match( A:Name  ;  A ) => true // any Name matches itself
  rule #match( A:Name  ;  B:Name ) => true requires isNameVar(B) // any Name matches a NameVar
  rule #match( A:Name  ; @B:Proc ) => true requires isProcVar(B) // any Name matches a quoted ProcVar
  rule #match( @A:Proc ; @B:Proc ) => #match(A;B) // underlying Procs must match

// NameVar only matches NameVar
  rule #match( _:NameVar ; A:Name  ) => true  requires isNameVar(A)
  rule #match( _:NameVar ; @B:Proc ) => false requires notBool isProcVar(B)
  rule #match( _:NameVar ; _:Name  ) => false [owise]

// several Names
  rule #match( A:Name , B:Name  ; C:Name , D:Name  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name , B:Names ; C:Name , D:Names ) => #length(B) ==Int #length(D) andBool #match(A;C) andBool #match(B;D)
  rule #match( _:Name , _:Name  ; _:Name , _:Names ) => false [owise] // two Names can't match more than two
  rule #match( _:Name , _:Names ; _:Name , _:Name  ) => false [owise] // more than two Names can't match two

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]
  rule Nil | P:Proc => P  [anywhere, structural]
  rule P:Proc | Nil => P  [anywhere, structural]

endmodule