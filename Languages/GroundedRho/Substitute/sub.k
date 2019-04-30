// SUBSTITUTION FOR GRHO
/*
TODO:
 - add remaining features
 - more testing
*/

require "domains.k"
require "substitution.k"
require "../AuxFun/auxfun.k"
require "../grho.k"

module SUB-SYNTAX
  import GRHO-SYNTAX
  import DOMAINS
  import SUBSTITUTION

  syntax   Proc ::= "#sub(" Proc  ";" Proc  ")"   [function]
                  | "#sub(" Proc  ";" Proc  ";" Proc ")" [function]
                  | "#sub(" Procs ";" Procs ";" Proc ")" [function]
                  | "#sub(" Name  ";" Name  ";" Proc ")" [function]
                  | "#sub(" Names ";" Names ";" Proc ")" [function]
  syntax   Name ::= "#sub(" Name  ";" Name  ";" Name ")" [function]
                  | "#sub(" Names ";" Names ";" Name ")" [function]
                  | "#sub(" Proc  ";" Proc  ";" Name ")" [function]
                  | "#sub(" Procs ";" Procs ";" Name ")" [function]
                  | "#sub(" Name  ";" Name  ")"   [function]
  syntax  Procs ::= "#sub(" Procs ";" Procs ")"   [function]
  syntax  Names ::= "#sub(" Names ";" Names ")"   [function]

endmodule

module SUB
  import SUB-SYNTAX
  import AUXFUN

  syntax KResult ::= Name | Names | Proc | Procs

  configuration
    <T color="purple">
      <k> $PGM:K </k>
    </T>

// Process substitution
  rule #sub( A:Proc ; B:Proc ) => A requires A ==K B
  rule #sub( A:Proc ; _:ProcVar ) => A
  rule #sub( A:Proc ; * _:NameVar ) => A
  rule #sub( * A:Name ; * B:Name ) => * #sub(A;B)

  rule #sub( A:Name !  ( B:Proc  ) ; C:Name ! ( D:Proc  ) ) => #sub(A;C) !  ( #sub(B;D) )
  rule #sub( A:Name !  ( B:Procs ) ; C:Name ! ( D:Procs ) ) => #sub(A;C) !  ( #sub(B;D) )
  rule #sub( A:Name !! ( B:Proc  ) ; C:Name ! ( D:Proc  ) ) => #sub(A;C) !! ( #sub(B;D) )
  rule #sub( A:Name !! ( B:Procs ) ; C:Name ! ( D:Procs ) ) => #sub(A;C) !! ( #sub(B;D) )

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
  rule #sub( A:Proc ; B:Proc ; P:Proc ) => P requires A ==K B
  rule #sub( A:Proc ; B:ProcVar ; P:Proc ) => P[A/B]
  rule #sub( A:Proc ; * B:NameVar ; P:Proc ) => P[@A/B]
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; P:Proc ) => #sub( A ; C ; #sub(B;D;P) )
  rule #sub( A:Name ! ( B:Proc ) ; C:Name ! ( D:Proc ) ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) )

// Several Procs sub
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #sub(A;C) , #sub(B;D)
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ) => #sub(A;C) , #sub(B;D)

// Several Procs sub with continuation
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) )
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) )

// Name substitution
  rule #sub( A:Name ; B:Name ) => A requires A ==K B
  rule #sub( A:Name ; _:NameVar ) => A
  rule #sub( A:Name ; @ _:ProcVar ) => A
  rule #sub( @ A:Proc ; @ B:Proc ) => @ #sub(A;B)

// Several Names sub with continuation
  rule #sub( A:Name ; A ; N:Name ) => N
  rule #sub( A:Name ; A ; P:Proc ) => P
  rule #sub( A:Name ; B:NameVar ; P:Proc ) => P[A/B]
  rule #sub( A:Name ; @ B:ProcVar ; P:Proc ) => P[*A/B]
  rule #sub( @ A:Proc ; B:NameVar ; P:Proc ) => P[@A/B]
  rule #sub( @ A:Proc ; @ B:Proc ; P:Proc ) => #sub(A;B;P)

  rule #sub( A:Name ; B:Name ; for(         <- X:Name ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #sub( A:Name ; B:Name ; for( Y:Name  <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #sub( A:Name ; B:Name ; for( Y:Names <- X:Name ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #sub( A:Name ; B:Name ; for(         <= X:Name ){ P:Proc } ) => for(   <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #sub( A:Name ; B:Name ; for( Y:Name  <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #sub( A:Name ; B:Name ; for( Y:Names <= X:Name ){ P:Proc } ) => for( Y <= #sub(A;B;X) ){ #sub(A;B;P) }
  rule #sub( A:Name ; B:Name ; for(         <! X:Name ){ P:Proc } ) => for(   <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #sub( A:Name ; B:Name ; for( Y:Name  <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }
  rule #sub( A:Name ; B:Name ; for( Y:Names <! X:Name ){ P:Proc } ) => for( Y <! #sub(A;B;X) ){ #sub(A;B;P) }

  rule #sub( A:Name ; B:Name  ; P:Proc | Q:Proc ) => #sub(A;B;P) | #sub(A;B;Q)

// Several Names sub
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) ) // two name sub in continuation
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; P:Proc ) => #sub( #sub(B;D) ; D ; #sub(A;C;P) ) // N name sub, N > 2, in continuation

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule