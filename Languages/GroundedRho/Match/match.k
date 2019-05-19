// Preliminary pattern-matching for GRHO
// Types must be the same for match to be successful -- #check handles this step

require "domains.k"
require "../AuxFun/auxfun.k"
require "../grho.k"

module MATCH-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// #check predicate checks that the input types match
  syntax   Bool ::= "#check(" Proc  ";" Proc ")"  [function]
                  | "#check(" Name  ";" Name ")"  [function]
                  | "#check(" Procs ";" Procs ")" [function]
                  | "#check(" Names ";" Names ")" [function]

// #checkNmatch predicate calls #check then calls #match
  syntax   Bool ::= "#checkNmatch(" Proc  ";" Proc ")"  [function]
                  | "#checkNmatch(" Name  ";" Name ")"  [function]
                  | "#checkNmatch(" Procs ";" Procs ")" [function]
                  | "#checkNmatch(" Names ";" Names ")" [function]

// #match predicate checks that the terms match
  syntax   Bool ::= "#match(" Proc  ";" Proc ")"  [function]
                  | "#match(" Name  ";" Name ")"  [function]
                  | "#match(" Procs ";" Procs ")" [function]
                  | "#match(" Names ";" Names ")" [function]

endmodule

module MATCH
  import MATCH-SYNTAX
  import AUXFUN
//  import SUB

  syntax KResult ::= Bool

// don't want to check individually... does soemthing like this work? -- TODO: tests!
// Check types
  rule #check( A:Name ; B:Name ) => #sort(A) ==String #sort(B)
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
// Check then match
  rule #checkNmatch( A:Name  ; B:Name  ) => #if #check(A;B) #then #match(A;B) #else false #fi
  rule #checkNmatch( A:Names ; B:Names ) => #if #length A ==Int #length B
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

// Process matching
  rule #match( A:Ground ; B:Ground ) => A ==K B
  rule #match( A:Proc ; A ) => true
  rule #match( A:Proc ;  _:ProcVar ) => true
  rule #match( A:Proc ; *_:NameVar ) => true
  rule #match( *A:Name ; *B:Name   ) => #match(A;B)

// ProcVar only matches ProcVar
  rule #match( _:ProcVar ; A:Proc ) => false requires notBool isProcVar(A)

  // send matching
  rule #match( A:Name !  (         ) ; C:Name !  (         ) ) => #match(A;C)
  rule #match( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !! (         ) ; C:Name !! (         ) ) => #match(A;C)
  rule #match( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #match(A;C) andBool #match(B;D)

  // Receive matching -- TODO: how to handle listen names?
  rule #match( for(         <- A:Name ){ B:Proc } ; for(         <- C:Name ){ D:Proc } ) => #match(A;C) andBool #match(B;D)
/*  rule #match( for( _:Name  <- A:Name ){ B:Proc } ; for( Y:Name  <- C:Name ){ D:Proc } ) => ???
    rule #match( for( X:Names <- A:Name ){ B:Proc } ; for( Y:Names <- C:Name ){ D:Proc } ) => ???
       requires #length(X) ==Int #length(Y)
*/
  rule #match( for(         <= A:Name ){ B:Proc } ; for(         <= C:Name ){ D:Proc } ) => #match(A;C) andBool #match(B;D)
/*  rule #match( for( _:Name  <= A:Name ){ B:Proc } ; for( Y:Name  <= C:Name ){ D:Proc } ) => ???
    rule #match( for( X:Names <= A:Name ){ B:Proc } ; for( Y:Names <= C:Name ){ D:Proc } ) => ???
       requires #length(X) ==Int #length(Y)
*/
  rule #match( for(         <! A:Name ){ B:Proc } ; for(         <! C:Name ){ D:Proc } ) => #match(A;C) andBool #match(B;D)
/*  rule #match( for( _:Name  <! A:Name ){ B:Proc } ; for( Y:Name  <! C:Name ){ D:Proc } ) => ???
    rule #match( for( X:Names <! A:Name ){ B:Proc } ; for( Y:Names <! C:Name ){ D:Proc } ) => ???
       requires #length(X) ==Int #length(Y)
*/
/* TODO:
 Lbinds only match Lbinds
 Pbinds only match Pbinds
 Rbinds only match Rbinds
*/
// Par match - apply after normalization
  rule #match( A:Proc | B:Proc ; C:Proc | D:Proc ) => #match(A;C) andBool #match(B;D)

// Collection matching - empty structures are accomodated by the first rule
  // RhoLists
  rule #match( [ A:Proc  ] ; [ B:Proc  ] ) => #match(A;B)
  rule #match( [ A:Procs ] ; [ B:Procs ] ) => #match(A;B)

  // RhoMaps & RhoSets are unordered -> assume canonical ordering
  // TODO: define for KV pairs?
  rule #match( { A:Proc : B:Proc } ; { C:Proc : D:Proc } ) => #match(A;C) andBool #match(B;D)
  //rule #match( { A:RhoKVPair , B:RhoKVPair  } ; { C:RhoKVPair , D:RhoKVPair  } ) => #match({A};{C}) andBool #match({B};{D})
  //rule #match( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs } ) => #match({A};{C}) andBool #match({B};{D})

  rule #match( Set( A:Proc  ) ; Set( B:Proc  ) ) => #match(A;B)
  rule #match( Set( A:Procs ) ; Set( B:Procs ) ) => #match(A;B)

  // RhoTuples
  rule #match( tuple( A:Proc  ) ; tuple( B:Proc  ) ) => #match(A;B)
  rule #match( tuple( A:Procs ) ; tuple( B:Procs ) ) => #match(A;B)

  // several Procs matching
  rule #match( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Procs ; C:Proc , D:Procs ) => #match(A;C) andBool #match(B;D)

// New matching -- TODO
// Arithmetic Exps matching
// Boolean Exps matching

//---------------------
//--- Name matching ---
//---------------------

// Primitive matchstitutions
  rule #match( A:Name ; A ) => true
  rule #match( A:Name ; _:NameVar ) => true
  rule #match( A:Name ; @ _:ProcVar ) => true
  rule #match( @A:Proc ; @B:Proc ) => #match(A;B)

// NameVar only matches NameVar
  rule #match( _:NameVar ; A:Name ) => false requires notBool isNameVar(A)

// several Names
  rule #match( A:Name , B:Name  ; C:Name , D:Name  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name , B:Names ; C:Name , D:Names ) => #match(A;C) andBool #match(B;D)

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule