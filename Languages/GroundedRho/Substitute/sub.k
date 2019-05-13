// SUBSTITUTION FOR GRHO
/*
TODO:
 - add remaining features
 - more testing
*/
/*
  This substitution function is needed to make distinct the notions of name variables and process variables.
  The builtin substitution does not make this distinction.
  E.g. we want the substitution (x!(\x))[@Nil / x] to result in @Nil!(\x) since we only substitute for x:NameVar, NOT \x:ProcVar
    the definitions of NameVar ::= Var and ProcVar ::= "\\" Var don't allow for this with the the builtin substitution
*/

require "domains.k"
require "substitution.k"
require "../AuxFun/auxfun.k"
require "../grho.k"

module SUB-SYNTAX
  import GRHO-SYNTAX
  import DOMAINS
  import SUBSTITUTION

  syntax   Proc ::= "#sub(" Proc  ";" Proc ")"   [function]
                  | "#sub(" Proc  ";" Proc  ";" Proc ")" [function]
                  | "#sub(" Procs ";" Procs ";" Proc ")" [function]
                  | "#sub(" Name  ";" Name  ";" Proc ")" [function]
                  | "#sub(" Names ";" Names ";" Proc ")" [function]
                  | "#subRec(" Proc  ";" Proc  ";" Proc ")" [function]
                  | "#subRec(" Procs ";" Procs ";" Proc ")" [function]
                  | "#subRec(" Name  ";" Name  ";" Proc ")" [function]
                  | "#subRec(" Names ";" Names ";" Proc ")" [function]
                  | "#subChan(" Proc  ";" Proc  ";" Proc ")" [function]
                  | "#subChan(" Procs ";" Procs ";" Proc ")" [function]
                  | "#subChan(" Name  ";" Name  ";" Proc ")" [function]
                  | "#subChan(" Names ";" Names ";" Proc ")" [function]
                  | "#subIf(" Name  ";" Name  ";" Proc ")" [function]
                  | "#subIf(" Names ";" Names ";" Proc ")" [function]
                  | "#subNew(" New ")" [function]

  syntax   Name ::= "#sub(" Name  ";" Name  ";" Name ")" [function]
                  | "#sub(" Names ";" Names ";" Name ")" [function]
                  | "#sub(" Proc  ";" Proc  ";" Name ")" [function]
                  | "#sub(" Procs ";" Procs ";" Name ")" [function]
                  | "#sub(" Name  ";" Name  ")"   [function]

  syntax  Procs ::= "#sub(" Procs ";" Procs ")"   [function]
                  | "#sub(" Proc  ";" Proc ";" Procs ")" [function]
                  | "#sub(" Name  ";" Name ";" Procs ")" [function]

  syntax  Names ::= "#sub(" Names ";" Names ")"   [function]
                  | "#sub(" Proc  ";" Proc ";" Names ")" [function]
                  | "#sub(" Name  ";" Name ";" Names ")" [function]

  syntax   Proc ::= "#subDB(" Proc  ";" Proc  ";" Proc ")" [function]
                  | "#subDB(" Procs ";" Procs ";" Proc ")" [function]
                  | "#subDB(" Name  ";" Name  ";" Proc ")" [function]
                  | "#subDB(" Names ";" Names ";" Proc ")" [function]

endmodule

module SUB
  import SUB-SYNTAX
  import AUXFUN

// Remove before importing into GRHO
//  syntax Ground ::= "unforgeable(" Int ")"

  syntax KResult ::= Name | Names | Proc | Procs

// Process substitution
  rule #sub( A:Proc ; A ) => A
  rule #sub( A:Proc ; _:ProcVar ) => A
  rule #sub( A:Proc ; * _:NameVar ) => A
  rule #sub( * A:Name ; * B:Name ) => * #sub(A;B)

  // send substitutions
  rule #sub( A:Name !  (         ) ; C:Name !  (         ) ) => #sub(A;C) !  (           )
  rule #sub( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ) => #sub(A;C) !  ( #sub(B;D) )
  rule #sub( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #sub(A;C) !  ( #sub(B;D) )
  rule #sub( A:Name !! (         ) ; C:Name !! (         ) ) => #sub(A;C) !! (           )
  rule #sub( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ) => #sub(A;C) !! ( #sub(B;D) )
  rule #sub( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #sub(A;C) !! ( #sub(B;D) )

  // receive substitutions
  rule #sub( for(         <- A:Name ){ B:Proc } ; for(         <- C:Name ){ D:Proc } ) => for(   <- #sub(A;C) ){ #sub(B;D) }
  rule #sub( for( _:Name  <- A:Name ){ B:Proc } ; for( Y:Name  <- C:Name ){ D:Proc } ) => for( Y <- #sub(A;C) ){ #sub(B;D) }
  rule #sub( for( X:Names <- A:Name ){ B:Proc } ; for( Y:Names <- C:Name ){ D:Proc } ) => for( Y <- #sub(A;C) ){ #sub(B;D) } requires #length(X) ==Int #length(Y)

// Par sub - intended to apply after normalization
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ) => #sub(A;C) | #sub(B;D)

// Collection substitutions - empty structures are accomodated by the first rule
  // RhoLists
  rule #sub( [ A:Proc  ] ; [ B:Proc  ] ) => [ #sub(A;B) ]
  rule #sub( [ A:Procs ] ; [ B:Procs ] ) => [ #sub(A;B) ]

  // RhoMaps & RhoSets are unordered -> assume canonical ordering
  rule #sub( { A:Proc : B:Proc } ; { C:Proc : D:Proc } ) => { #sub(A;C) : #sub(B;D) }
//  rule #sub( { A:RhoKVPair , B:RhoKVPair  } ; { C:RhoKVPair , D:RhoKVPair  } ) => { #sub({A};{C}) , #sub({B};{D}) }
//  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs } ) => { #sub({A};{C}) , #sub({B};{D}) }

  rule #sub( Set( A:Proc  ) ; Set( B:Proc  ) ) => Set( #sub(A;B) )
  rule #sub( Set( A:Procs ) ; Set( B:Procs ) ) => Set( #sub(A;B) )

  // RhoTuples
  rule #sub( tuple( A:Proc  ) ; tuple( B:Proc  ) ) => tuple( #sub(A;B) )
  rule #sub( tuple( A:Procs ) ; tuple( B:Procs ) ) => tuple( #sub(A;B) )

// Single Proc sub with continuation
  // trivial cases
  rule #sub( A:Proc ; A ; P:Proc ) => P
  rule #sub( _:Proc ; _:Proc ; Nil ) => Nil
  rule #sub( _:Proc ; _:Proc ; G:Ground ) => G
  rule #sub( _:Proc ; _:Proc ; N:NameVar ) => N

  // sub Proc for ProcVar in ProcVar
  rule #sub( A:Proc ; B:ProcVar ;  C:ProcVar ) =>  A requires B ==K C
  rule #sub( A:Proc ; B:ProcVar ;  C:ProcVar ) =>  C requires B =/=K C

  // sub Proc for ProcVar in @ProcVar
  rule #sub( A:Proc ; B:ProcVar ; @C:ProcVar ) => @A requires B ==K C
  rule #sub( A:Proc ; B:ProcVar ; @C:ProcVar ) => @C requires B =/=K C

  // sub Proc for ProcVar in Quote
  rule #sub( A:Proc ; B:ProcVar ; @C:Proc ) => @ #sub(A;B;C)

  // sub Proc for ProcVar in Eval
  rule #sub( A:Proc ; B:ProcVar ; *C:Name ) => * #sub(A;B;C)

  // sub Proc for ProcVar in Send
  rule #sub( A:Proc ; B:ProcVar ; C:Name !  ( D:Proc  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcVar ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcVar ; C:Name !! ( D:Proc  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcVar ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Proc for ProcVar in Receive -- only substitute variables that DO NOT appear as binding variables
  rule #sub( A:Proc ; B:Proc ; C:Receive ) => #if (@B #in #bvar(C)) #then #subChan(A;B;C) #else #subRec(A;B;C) #fi
  rule #subRec( A:Proc ; B:Proc ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }

  rule #subChan( A:Proc ; B:Proc ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ P }

  rule #sub( A:Proc ; B:Proc ; C:Proc | D:Proc ) => #sub(A;B;C) | #sub(A;B;D)  // after normalization
  rule #sub( A:Name ! ( B:Proc ) ; C:Name ! ( D:Proc ) ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) )

// Several Procs sub
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #sub(A;C) , #sub(B;D)
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ) => #sub(A;C) , #sub(B;D)

// Several Procs sub with continuation
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) )
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) )

// Name substitution
  rule #sub( A:Name ; A ) => A
  rule #sub( A:Name ; _:NameVar ) => A
  rule #sub( A:Name ; @ _:ProcVar ) => A
  rule #sub( @ A:Proc ; @ B:Proc ) => @ #sub(A;B)

// Name sub with continuation
  // trivial cases
  rule #sub( A:Name ; A ; N:Name ) => N
  rule #sub( A:Name ; A ; P:Proc ) => P
  rule #sub( _:Name ; _:Name ; Nil ) => Nil
  rule #sub( _:Name ; _:Name ; G:Ground ) => G
  rule #sub( _:Name ; _:Name ; P:ProcVar ) => P

  // sub Name for NameVar in NameVar
  rule #sub( A:Name ; B:NameVar ;  C:NameVar ) =>  A requires B ==K C
  rule #sub( A:Name ; B:NameVar ;  C:NameVar ) =>  C requires B =/=K C

  // sub Name for NameVar in *NameVar
  rule #sub( A:Name ; B:NameVar ; *C:NameVar ) => *A requires B ==K C
  rule #sub( A:Name ; B:NameVar ; *C:NameVar ) => *C requires B =/=K C
  rule #sub( A:Name ; B:NameVar ; @ C:Proc ) => @ #sub(A;B;C)

  rule #sub( A:Name ; @B:ProcVar ; C:Proc ) => #sub(*A;B;C)

  rule #sub( @ A:Proc ; @ B:Proc  ; P:Proc ) => #sub(A;B;P)

  // sub Name for Name in Receive
  rule #sub( A:Name ; B:Name ; C:Receive ) => #if (B #in #bvar(C)) #then #subChan(A;B;C) #else #subRec(A;B;C) #fi
  rule #subRec( A:Name ; B:Name ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Name ; B:Name ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Name ; B:Name ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Name ; B:Name ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Name ; B:Name ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Name ; B:Name ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Name ; B:Name ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Name ; B:Name ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Name ; B:Name ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }

  rule #subChan( A:Name ; B:Name ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ P }
  rule #subChan( A:Name ; B:Name ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ P }
  rule #subChan( A:Name ; B:Name ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ P }
  rule #subChan( A:Name ; B:Name ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ P }
  rule #subChan( A:Name ; B:Name ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ P }
  rule #subChan( A:Name ; B:Name ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ P }
  rule #subChan( A:Name ; B:Name ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ P }
  rule #subChan( A:Name ; B:Name ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ P }
  rule #subChan( A:Name ; B:Name ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ P }

  rule #sub( A:Name ; B:Name ; C:Name !  ( D:Proc ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; C:Name !! ( D:Proc ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  rule #sub( A:Name ; B:Name  ; Left:Proc | Right:Proc ) => #sub(A;B;Left) | #sub(A;B;Right)

  rule #sub( _:Name ; _:Name ; ( ):RhoTuple ) => ( )
  rule #sub( A:Name ; B:Name ; tuple( C:Proc  ) ) => tuple( #sub(A;B;C) )
  rule #sub( A:Name ; B:Name ; tuple( C:Procs ) ) => tuple( #sub(A;B;C) )

// is this what we want?
  rule #sub( A:Name ; B:Name ; new C:Name  in { D:Proc } ) => new C in { #sub(A;B;D) }
  rule #sub( A:Name ; B:Name ; new C:Names in { D:Proc } ) => new C in { #sub(A;B;D) }

  rule #subIf( A:Name ; B:Name ; C:New ) => #if (B #in #dec(C)) #then C #else #sub(A;B;C) #fi

  rule #subNew( new A:Name in { P:Proc } ) => #sub(@unforgeable(!I:Int);A;P)
  rule #subNew( new A:Name , B:Name  in { P:Proc } ) => #subNew( new B in { #sub(@unforgeable(!I:Int);A;P) } )
  rule #subNew( new A:Name , B:Names in { P:Proc } ) => #subNew( new B in { #sub(@unforgeable(!I:Int);A;P) } )

// Several Names sub
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) ) // two name sub in continuation
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) ) // N name sub, N > 2, in continuation

  rule #sub( A:Name ; B:Name ; C:Proc , D:Proc  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc , D:Procs ) => #sub(A;B;C) , #sub(A;B;D)

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

// Substitution for De Bruijn
  // when substituting a new
//  rule #subDB(  )

endmodule