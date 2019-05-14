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
require "../AuxFun/auxfun.k"
require "../grho.k"

module SUB-SYNTAX
  import GRHO-SYNTAX
  import DOMAINS

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
                  | "#subNew(" Name  ";" Name  ";" New ")" [function]
                  | "#subNew(" Names ";" Names ";" New ")" [function]

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

  // sveral Procs
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #sub(A;C) , #sub(B;D)
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ) => #sub(A;C) , #sub(B;D)

//------------------------------------------------
//--- Substitute Proc for Proc in Proc or Name ---
//------------------------------------------------
  // trivial cases
  rule #sub( A:Proc ; A ; P:Proc ) => P
  rule #sub( _:Proc ; _:Proc ; G:Ground ) => G

  // sub Proc for ProcVar in ProcVar or NameVar
  rule #sub( A:Proc ; B:ProcVar ; C:ProcVar ) => A requires B ==K C
  rule #sub( A:Proc ; B:ProcVar ; C:ProcVar ) => C requires B =/=K C
  rule #sub( _:Proc ; _:ProcVar ; A:NameVar ) => A

  // sub Proc for *NameVar in NameVar or ProcVar
  rule #sub( A:Proc ; *B:NameVar ; C:NameVar ) => @A requires B ==K C
  rule #sub( A:Proc ; *B:NameVar ; C:NameVar ) => C requires B =/=K C
  rule #sub( _:Proc ; *_:NameVar ; A:ProcVar ) => A

  // sub Proc for Proc in @Proc
  rule #sub( A:Proc ; B:Proc ; @C:Proc ) => @ #sub(A;B;C)

  // sub Proc for Proc in *Name
  rule #sub( A:Proc ; B:Proc ; *C:Name ) => * #sub(A;B;C)

  // sub *Name for *Name in Proc
  rule #sub( *A:Name ; *B:Name ; C:Proc ) => #sub(A;B;C)

  // sub Proc for Proc in Send
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Proc  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Proc  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Proc for ProcVar in Receive -- only substitute variables that DO NOT appear as binding variables
  rule #sub( A:Proc ; B:Proc ; C:Receive ) => #if (@B #in #bvar(C)) #then #subChan(A;B;C) #else #subRec(A;B;C) #fi
    // substitute free variables - in channel and continuation
  rule #subRec( A:Proc ; B:Proc ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:Proc ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }
    // substitute free variables - only in channel
  rule #subChan( A:Proc ; B:Proc ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ P }
  rule #subChan( A:Proc ; B:Proc ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ P }

  // sub Proc for Proc in Par
  rule #sub( A:Proc ; B:Proc ; C:Proc | D:Proc ) => #sub(A;B;C) | #sub(A;B;D)  // after normalization

// sub Proc for Proc in Names
  rule #sub( A:Proc ; B:Proc ; C:Name , D:Name  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name , D:Names ) => #sub(A;B;C) , #sub(A;B;D)

// sub Proc for Proc in Procs
  rule #sub( A:Proc ; B:Proc ; C:Proc , D:Proc  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc , D:Procs ) => #sub(A;B;C) , #sub(A;B;D)

// sub Procs for Procs
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #sub(A;C) , #sub(B;D)
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ) => #sub(A;C) , #sub(B;D)

// sub Procs for Procs in Proc
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:Proc ) => #sub(B;D;#sub(A;C;P))

  // sub Send for Send in Proc - sub Name for Name and Proc(s) for Proc(s) in Proc
  rule #sub( A:Name ! ( B:Proc  ) ; C:Name ! ( D:Proc  ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name ! ( B:Procs ) ; C:Name ! ( D:Procs ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))

  // sub Par for Par in Name or Proc
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; P:Proc ) => #sub(B;D;#sub(A;C;P))

//--------------------------
//--- Name substitutions ---
//--------------------------
  rule #sub( A:Name ; A ) => A
  rule #sub( A:Name ; _:NameVar ) => A
  rule #sub( A:Name ; @ _:ProcVar ) => A
  rule #sub( @ A:Proc ; @ B:Proc ) => @ #sub(A;B)

  // several Names
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ) => #sub(A;C) , #sub(B;D)
  rule #sub( A:Name , B:Names ; C:Name , D:Names ) => #sub(A;C) , #sub(B;D)

//------------------------------------------------
//--- Substitute Name for Name in Name or Proc ---
//------------------------------------------------
  // trivial cases
  rule #sub( A:Name ; A ; N:Name ) => N
  rule #sub( A:Name ; A ; P:Proc ) => P
  rule #sub( _:Name ; _:Name ; G:Ground ) => G

  // sub Name for NameVar in NameVar or ProcVar
  rule #sub( A:Name ; B:NameVar ; C:NameVar ) => A requires B ==K C
  rule #sub( A:Name ; B:NameVar ; C:NameVar ) => C requires B =/=K C
  rule #sub( _:Name ; _:NameVar ; A:ProcVar ) => A

  // sub Name for @ProcVar in NameVar
  rule #sub( A:Name ; @B:ProcVar ; C:ProcVar ) => *A requires B ==K C
  rule #sub( A:Name ; @B:ProcVar ; C:ProcVar ) => C requires B =/=K C
  rule #sub( _:Name ; @_:ProcVar ; A:NameVar ) => A

  // sub Name for NameVar in @Proc
  rule #sub( A:Name ; B:NameVar ; @C:Proc ) => @ #sub(A;B;C)

  // sub Name for NameVar in *Name
  rule #sub( A:Name ; B:NameVar ; *C:Name ) => * #sub(A;B;C)

  rule #sub( A:NameVar ; @B:Proc ; C:Proc ) => #sub(*A;B;C)

// sub @Proc for @Proc in Name & Proc - drop quotes
  rule #sub( @A:Proc ; @B:Proc ; C:Name ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:Proc ; C:Proc ) => #sub(A;B;C)

  // sub Name for Name in Receive
  rule #sub( A:Name ; B:Name ; Rec:Receive ) => #if (B #in #bvar(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
    // if name to substitute is free, then it is substituted in the channel and continuation
  rule #subRec( A:Name ; B:Name ; for(         <- Chan:Name ){ Cont:Proc } ) => for(   <- #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Name ; for( Y:Name  <- Chan:Name ){ Cont:Proc } ) => for( Y <- #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Name ; for( Y:Names <- Chan:Name ){ Cont:Proc } ) => for( Y <- #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Name ; for(         <= Chan:Name ){ Cont:Proc } ) => for(   <= #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Name ; for( Y:Name  <= Chan:Name ){ Cont:Proc } ) => for( Y <= #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Name ; for( Y:Names <= Chan:Name ){ Cont:Proc } ) => for( Y <= #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Name ; for(         <! Chan:Name ){ Cont:Proc } ) => for(   <! #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Name ; for( Y:Name  <! Chan:Name ){ Cont:Proc } ) => for( Y <! #sub(A;B;Chan) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Name ; for( Y:Names <! Chan:Name ){ Cont:Proc } ) => for( Y <! #sub(A;B;Chan) ){ #sub(A;B;Cont) }
    // if name to be substituted is bound, then it is only substituted in the channel
  rule #subChan( A:Name ; B:Name ; for( Y:Name  <- Chan:Name ){ Cont:Proc } ) => for( Y <- #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:Name ; for( Y:Names <- Chan:Name ){ Cont:Proc } ) => for( Y <- #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:Name ; for( Y:Name  <= Chan:Name ){ Cont:Proc } ) => for( Y <= #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:Name ; for( Y:Names <= Chan:Name ){ Cont:Proc } ) => for( Y <= #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:Name ; for( Y:Name  <! Chan:Name ){ Cont:Proc } ) => for( Y <! #sub(A;B;Chan) ){ Cont }
  rule #subChan( A:Name ; B:Name ; for( Y:Names <! Chan:Name ){ Cont:Proc } ) => for( Y <! #sub(A;B;Chan) ){ Cont }

  // sub Name for Name in Send
  rule #sub( A:Name ; B:Name ; Chan:Name !  ( Msg:Proc  ) ) => #sub(A;B;Chan) !  ( #sub(A;B;Msg) )
  rule #sub( A:Name ; B:Name ; Chan:Name !  ( Msg:Procs ) ) => #sub(A;B;Chan) !  ( #sub(A;B;Msg) )
  rule #sub( A:Name ; B:Name ; Chan:Name !! ( Msg:Proc  ) ) => #sub(A;B;Chan) !! ( #sub(A;B;Msg) )
  rule #sub( A:Name ; B:Name ; Chan:Name !! ( Msg:Procs ) ) => #sub(A;B;Chan) !! ( #sub(A;B;Msg) )

  // sub Name for Name in Par
  rule #sub( A:Name ; B:Name ; Left:Proc | Right:Proc ) => #sub(A;B;Left) | #sub(A;B;Right)

  // sub Name for Name in RhoTuple
  rule #sub( _:Name ; _:Name ; ( ):RhoTuple ) => ( )
  rule #sub( A:Name ; B:Name ; tuple( C:Proc  ) ) => tuple( #sub(A;B;C) )
  rule #sub( A:Name ; B:Name ; tuple( C:Procs ) ) => tuple( #sub(A;B;C) )

  // sub Name for Name in New
  rule #sub( A:Name ; B:Name ; P:New ) => #if (B #in #dec(P)) #then P #else #subNew(A;B;P) #fi
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; P:New ) => #if (C #in #dec(P)) #then #sub(B;D;P) #else #sub(B;D;#subNew(A;C;P)) #fi
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; P:New ) => #if (C #in #dec(P)) #then #sub(B;D;P) #else #sub(B;D;#subNew(A;C;P)) #fi
  rule #subNew( A:Name ; B:Name ; new C:Name  in { D:Proc } ) => new C in { #sub(A;B;D) }
  rule #subNew( A:Name ; B:Name ; new C:Names in { D:Proc } ) => new C in { #sub(A;B;D) }

// Several Names sub
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; P:Proc ) => #sub(B;D;#sub(A;C;P)) // two name sub in continuation
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; P:Proc ) => #sub(B;D;#sub(A;C;P)) // N name sub, N > 2, in continuation

  rule #sub( A:Name ; B:Name ; C:Proc , D:Proc  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc , D:Procs ) => #sub(A;B;C) , #sub(A;B;D)

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule