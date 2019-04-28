// SUBSTITUTION FOR GRHO
/*
TODO:
 - add remaining features
 - more testing
*/

require "domains.k"
require "substitution.k"
require "../grho.k"

module SUB-SYNTAX
  import GRHO-SYNTAX
  import DOMAINS
  import SUBSTITUTION

  syntax   Proc ::= "#sub(" Proc  ";" Proc  ")"   [function]
                  | "#subcont(" Proc  ";" Proc  ";" Proc ")" [function]
                  | "#subcont(" Procs ";" Procs ";" Proc ")" [function]
                  | "#subcont(" Name  ";" Name  ";" Proc ")" [function]
                  | "#subcont(" Names ";" Names ";" Proc ")" [function]
  syntax  Procs ::= "#sub(" Procs ";" Procs ")"   [function]
  syntax   Name ::= "#sub(" Name  ";" Name  ")"   [function]
  syntax  Names ::= "#sub(" Names ";" Names ")"   [function]

endmodule

module SUB
  import SUB-SYNTAX

  syntax KResult ::= Name | Names | Proc | Procs

  configuration
    <T color="purple">
      <k> $PGM:K </k>
    </T>

  rule #sub( A:Name ; A ) => A
  rule #sub( A:Name ; _:NameVar ) => A
  rule #sub( A:Name ; @ _:ProcVar ) => A
  rule #sub( @ A:Proc ; @ B:Proc ) => @ #sub(A;B)
  rule #sub( A:Proc ; A ) => A
  rule #sub( A:Proc ; _:ProcVar ) => A
  rule #sub( A:Proc ; * _:NameVar ) => A
  rule #sub( * A:Name ; * B:Name ) => * #sub(A;B)

  rule #sub( A:Name !  ( B:Proc  ) ; C:Name ! ( D:Proc  ) ) => #sub(A;C) !  ( #sub(B;D) )
  rule #sub( A:Name !  ( B:Procs ) ; C:Name ! ( D:Procs ) ) => #sub(A;C) !  ( #sub(B;D) )
  rule #sub( A:Name !! ( B:Proc  ) ; C:Name ! ( D:Proc  ) ) => #sub(A;C) !! ( #sub(B;D) )
  rule #sub( A:Name !! ( B:Procs ) ; C:Name ! ( D:Procs ) ) => #sub(A;C) !! ( #sub(B;D) )

  rule #sub( for( Y <- A:Name ){ B:Proc } ; for( _ <- C:Name ){ D:Proc } ) => for( Y <- #sub(A;C) ){ #sub(B;D) }

  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ) => #sub(A;C) | #sub(B;D)
// not sure about these par rules...
//  rule #sub( A:Proc ; B:Proc | C:Proc ) => #sub(A;B) | #sub(A;C)
//  rule #sub( A:Proc | B:Proc ; C:Proc ) => #sub(A;C) | #sub(B;C)

  rule #sub( [ A:Proc  ] ; [ B:Proc  ] ) => [ #sub(A;B) ]
  rule #sub( [ A:Procs ] ; [ B:Procs ] ) => [ #sub(A;B) ]

  rule #sub( tuple( A:Proc  ) ; tuple( B:Proc  ) ) => tuple( #sub(A;B) )
  rule #sub( tuple( A:Procs ) ; tuple( B:Procs ) ) => tuple( #sub(A;B) )

  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ) => #sub(A;C) , #sub(B;D)
  rule #sub( A:Name , B:Names ; C:Name , D:Names ) => #sub(A;C) , #sub(B;D)
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #sub(A;C) , #sub(B;D)
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ) => #sub(A;C) , #sub(B;D)

  rule #subcont( A:Proc ; B:ProcVar ; P:Proc ) => P[A/B] // single proc sub in continuation
  rule #subcont( A:Proc ; B:Ground  ; P:Proc ) => P requires A ==K B // single proc sub in continuation
  rule #subcont( A:Proc ; * B:NameVar ; P:Proc ) => P[@A/B]
  rule #subcont( A:Proc | B:Proc ; C:Proc | D:Proc ; P:Proc ) => #subcont( A ; C ; #subcont(B;D;P) )
  rule #subcont( A:Proc , B:Proc  ; C:Proc , D:Proc  ; P:Proc ) => #subcont( #sub(B;D) ; D ; #subcont(A;C;P) ) // two proc sub in continuation
  rule #subcont( A:Proc , B:Procs ; C:Proc , D:Procs ; P:Proc ) => #subcont( #sub(B;D) ; D ; #subcont(A;C;P) ) // N proc sub, N > 2, in continuation
  rule #subcont( A:Name ! ( B:Proc ) ; C:Name ! ( D:Proc ) ; P:Proc ) => #subcont( #sub(B;D) ; D ; #subcont(A;C;P) )

  rule #subcont( A:Name ; A ; P:Proc ) => P
  rule #subcont( A:Name ; B:NameVar ; P:Proc ) => P[A/B]
  rule #subcont( A:Name ; @ B:ProcVar ; P:Proc ) => P[*A/B]
  rule #subcont( @ A:Proc ; B:NameVar ; P:Proc ) => P[@A/B]
  rule #subcont( @ A:Proc ; @ B:Proc ; P:Proc ) => #subcont(A;B;P)
  rule #subcont( A:Name ; B:Name  ; P:Proc | Q:Proc ) => #subcont(A;B;P) | #subcont(A;B;Q)
  rule #subcont( A:Name , B:Name  ; C:Name , D:Name  ; P:Proc ) => #subcont( #sub(B;D) ; D ; #subcont(A;C;P) ) // two name sub in continuation
  rule #subcont( A:Name , B:Names ; C:Name , D:Names ; P:Proc ) => #subcont( #sub(B;D) ; D ; #subcont(A;C;P) ) // N name sub, N > 2, in continuation

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule