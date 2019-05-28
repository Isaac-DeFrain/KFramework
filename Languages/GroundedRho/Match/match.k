// Preliminary pattern-matching for GRHO
// Types must be the same for match to be successful

require "domains.k"
require "../AuxFun/auxfun.k"
require "../grho.k"

module MATCH-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// #check predicate checks that the input types match
  syntax   Bool ::= "#check(" Proc  ";" Proc  ")" [function]
                  | "#check(" Name  ";" Name  ")" [function]
                  | "#check(" Procs ";" Procs ")" [function]
                  | "#check(" Names ";" Names ")" [function]

// #checkNmatch predicate calls #check then calls #match
  syntax   Bool ::= "#checkNmatch(" Proc  ";" Proc  ")" [function]
                  | "#checkNmatch(" Name  ";" Name  ")" [function]
                  | "#checkNmatch(" Procs ";" Procs ")" [function]
                  | "#checkNmatch(" Names ";" Names ")" [function]

// #match predicate checks that the terms match
  syntax   Bool ::= "#match(" Proc  ";" Proc  ")" [function]
                  | "#match(" Name  ";" Name  ")" [function]
                  | "#match(" Procs ";" Procs ")" [function]
                  | "#match(" Names ";" Names ")" [function]

endmodule

module MATCH
  import MATCH-SYNTAX
  import AUXFUN
//  import SUB

//  K-REFLECTION 
// contains the #sort(K) syntax but doesn't return the sort/type of a term even with KResult ::= String

  syntax KResult ::= Bool
/*
// Is there a good way to capture the right type inclusions without going through every pair individually???
// Check then match
  rule #checkNmatch( A:Name  ; B:Name  ) => #if #check(A;B) #then #match(A;B) #else false #fi
  rule #checkNmatch( A:Names ; B:Names ) => #if #length(A) ==Int #length(B)
                                            #then #if #check(A;B)
                                                  #then #match(A;B)
                                                  #else false
                                                  #fi
                                            #else false
                                            #fi
  rule #checkNmatch( A:Proc  ; B:Proc  ) => #if #check(A;B) #then #match(A;B) #else false #fi
  rule #checkNmatch( A:Procs ; B:Procs ) => #if #length(A) ==Int #length(B)
                                            #then #if #check(A;B)
                                                  #then #match(A;B)
                                                  #else false
                                                  #fi
                                            #else false
                                            #fi

// Check types
  // Names
  rule #check( A:Name ; A ) => true  // same Names match
  rule #check( _:Name ; B:Name ) => true requires isNameVar(B)  // any Name matches a NameVar
  rule #check( A:Name , B:Name  ; C:Name , D:Name  ) => #check(A;C) andBool #check(B;D) 
  rule #check( A:Name , B:Names ; C:Name , D:Names ) => #if #check(A;C)
                                                        #then #check(B;D)
                                                        #else false
                                                        #fi
  rule #check( A:Proc ; B:Proc ) => #sort(A) ==String #sort(B)
  rule #check( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #check(A;C) andBool #check(B;D)
  rule #check( A:Proc , B:Procs ; C:Proc , D:Procs ) => #if #check(A;C)
                                                        #then #check(B;D)
                                                        #else false
                                                        #fi
*/

// Process matching
  rule #match( A:Proc  ;  A ) => true // any Proc matches itself
  rule #match( A:Proc  ;  B:ProcVar ) => true // any Proc matches a ProcVar
  rule #match( A:Proc  ; *B:NameVar ) => true // any Proc matches a *NameVar

  // Ground only matches itself
  rule #match( A:Ground ; B:Ground ) => A ==K B

  // ProcVar only matches ProcVar or *NameVar
  rule #match( _:ProcVar ; B:Proc ) => false requires notBool (isProcVar(B) orBool isEval(B) orBool isPar(B)) [owise]

  // Eval matches Eval
  rule #match( *A:Name ; *B:Name ) => #match(A;B) // underlying Names must match
  rule #match(  _:Eval ;  B:Proc ) => false requires notBool (isProcVar(B) orBool isEval(B) orBool isPar(B)) [owise]

  // Send matching
  rule #match( A:Name !  (         ) ; C:Name !  (         ) ) => #match(A;C)
  rule #match( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !! (         ) ; C:Name !! (         ) ) => #match(A;C)
  rule #match( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #match(A;C) andBool #match(B;D)
  rule #match( _:Send ; B:Proc ) => false requires notBool (isProcVar(B) orBool isEval(B) orBool isPar(B) orBool isSend(B)) [owise]
  rule #match( A:Proc ; _:Send ) => false requires notBool isSend(A) [owise]

  // Receive matching -- TODO: how to handle listen names?
  rule #match( for(         <- A:Name ){ B:Proc } ; for(         <- C:Name ){ D:Proc } ) => #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name  <- A:Name ){ B:Proc } ; for( Y:Name  <- C:Name ){ D:Proc } ) => #match(X;Y) andBool #match(A;C) andBool #match(B;D)
  rule #match( for( X:Names <- A:Name ){ B:Proc } ; for( Y:Names <- C:Name ){ D:Proc } ) => #match(X;Y) andBool #match(A;C) andBool #match(B;D)
  rule #match( _:Receive ; _:Par  ) => true
  rule #match( _:Receive ; B:Proc ) => false requires notBool (isReceive(B) andBool isProcVar(B) andBool isPar(B)) [owise]

  rule #match( for(         <= A:Name ){ B:Proc } ; for(         <= C:Name ){ D:Proc } ) => #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name  <= A:Name ){ B:Proc } ; for( Y:Name  <= C:Name ){ D:Proc } ) => #match(X;Y) andBool #match(A;C) andBool #match(B;D)
  rule #match( for( X:Names <= A:Name ){ B:Proc } ; for( Y:Names <= C:Name ){ D:Proc } ) => #match(X;Y) andBool #match(A;C) andBool #match(B;D)

  rule #match( for(         <! A:Name ){ B:Proc } ; for(         <! C:Name ){ D:Proc } ) => #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name  <! A:Name ){ B:Proc } ; for( Y:Name  <! C:Name ){ D:Proc } ) => #match(X;Y) andBool #match(A;C) andBool #match(B;D)
  rule #match( for( X:Names <! A:Name ){ B:Proc } ; for( Y:Names <! C:Name ){ D:Proc } ) => #match(X;Y) andBool #match(A;C) andBool #match(B;D)

/* TODO:
 Lbinds only match Lbinds
 Pbinds only match Pbinds
 Rbinds only match Rbinds
*/
// Par match - apply after normalization
  rule #match( A:Proc | B:Proc ; C:Proc | D:Proc ) => #match(A;C) andBool #match(B;D) requires notBool (isPar(A) andBool isPar(C))

// Collection matching - empty structures are accomodated by the first rule
  // RhoList matches RhoList (if underlying Procs match), nothing else matches RhoList
  rule #match( [ A:Proc  ] ; [ B:Proc  ] ) => #match(A;B)
  rule #match( [ A:Procs ] ; [ B:Procs ] ) => #match(A;B)
  rule #match( A:Proc ; _:RhoList ) => false requires notBool isRhoList(A) [owise]

  // RhoMaps & RhoSets are unordered -> assume canonical ordering
  // RhoMap matches RhoMap (if underlying Procs match), nothing else matches RhoMap
  // TODO: define for KV pairs?
  rule #match( { A:Proc : B:Proc } ; { C:Proc : D:Proc } ) => #match(A;C) andBool #match(B;D)
  //rule #match( { A:RhoKVPair , B:RhoKVPair  } ; { C:RhoKVPair , D:RhoKVPair  } ) => #match({A};{C}) andBool #match({B};{D})
  //rule #match( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs } ) => #match({A};{C}) andBool #match({B};{D})

  // RhoSet matches RhoSet (if underlying Procs match), nothing else matches RhoSet
  rule #match( Set( A:Proc  ) ; Set( B:Proc  ) ) => #match(A;B)
  rule #match( Set( A:Procs ) ; Set( B:Procs ) ) => #match(A;B)
  rule #match( A:Proc ; _:RhoSet ) => false requires notBool isRhoSet(A) [owise]

  // RhoTuple matches RhoTuple (if underlying Procs match), nothing else matches RhoTuple
  rule #match( tuple( A:Proc  ) ; tuple( B:Proc  ) ) => #match(A;B)
  rule #match( tuple( A:Procs ) ; tuple( B:Procs ) ) => #match(A;B)
  rule #match( A:Proc ; _:RhoTuple ) => false requires notBool isRhoTuple(A) [owise]

  // several Procs matching -- used in many other contexts
  rule #match( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Procs ; C:Proc , D:Procs ) => #length(B) ==Int #length(D) andBool #match(A;C) andBool #match(B;D)
  rule #match( _:Proc , _:Proc  ; _:Proc , _:Procs ) => false [owise] // two Procs don't match more than two
  rule #match( _:Proc , _:Procs ; _:Proc , _:Proc  ) => false [owise] // more than two Procs don't match two

// New matching -- TODO
// Arithmetic Exps matching
// Boolean Exps matching

// Every Proc matches Par, ProcVar/*NameVar, and itself
// anything matches Par
// Send matches other Send (if underlying channels and messages match), but only Send matches Send
// Receive matches Receive (if the underlying channels, listening variables, and continuations match?), but only Receive matches Receive
// New matches New (if same number of Names declared and Procs match), nothing else matches New?
// every Proc matches ProcVar, but ProcVar only matches ProcVar
// VarRef matches any VarRef (because underlying variables match), nothing else matches VarRef? 
// Method matches same Method (if Proc and arguments match), nothing else matches Method?
  rule #match( A:Proc . B:Method ( C:Procs ) ; D:Proc . E:Method ( F:Procs ) ) => #match(A;D) andBool B ==K E andBool #match(C;F)
  rule #match( A:Proc . B:Method ( C:Proc  ) ; D:Proc . E:Method ( F:Proc  ) ) => #match(A;D) andBool B ==K E andBool #match(C;F)
  rule #match( A:Proc . B:Method (         ) ; D:Proc . E:Method (         ) ) => #match(A;D) andBool B ==K E
  rule #match( A:Proc ; _:MethodProc ) => false requires notBool isMethodProc(A) [owise]

// AExp matches AExp with matching subexpressions, nothing else matches AExp
// BExp matches BExp with matching subexpressions, nothing else matches BExp
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

endmodule