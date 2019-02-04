
require "../Names_Variables/namevar.k"
require "../StructuralTypes/stype.k"

module IS-PROC-SYNTAX
  import NAMEVAR-SYNTAX
// the #isProc predicate
// currently checks to see if a ProcOrPat corresponds to a process
// will ultimately check to see if the type corresponds to a process, i.e. only has one inhabitant.

// Why is the type needed here instead of using the process/pattern directly?

  syntax BExp ::= "#isProc" ProcOrPat  [function]
        //    | "#isProc" Type       [function]

endmodule

module IS-PROC
  import IS-PROC-SYNTAX

  configuration
  <T>
    <k> $PGM:ProcOrPat </k>
  </T>

  rule #isProc P:Proc => FV( P ) == .Set  [strict]

  // Free Name set
  rule FN(   Nil    ) => .Set
  rule FN( _:Bool   ) => .Set
  rule FN( _:Int    ) => .Set
  rule FN( _:String ) => .Set

  rule FN( X:Name ( Y:Name )  { P:Proc } ) => SetItem(X) (FN(P) -Set SetItem(Y))

  rule FN( X:Name ! ( P:Proc ) )           => FN(P) SetItem(X)

  rule FN( P:Proc | Q:Proc )               => FN(P) FN(Q)

  rule FN( * X:Name )                      => SetItem(X)

  rule FN( A1:AExp +  A2:AExp )            => FN(A1) FN(A2)
  rule FN( A1:AExp -  A2:AExp )            => FN(A1) FN(A2)
  rule FN( A1:AExp *  A2:AExp )            => FN(A1) FN(A2)
  rule FN( A1:AExp <= A2:AExp )            => FN(A1) FN(A2)

  rule FN( not B:BExp )                    => FN(B)
  rule FN( B1:BExp && B2:BExp )            => FN(B1) FN(B2)

  // Bound Name set
  rule BN( P:Proc ) => N(P) -Set FN(P)

  // Variable set
  rule V(   Nil    ) => .Set
  rule V( _:Bool   ) => .Set
  rule V( _:Int    ) => .Set
  rule V( _:String ) => .Set

  rule V( X:Var  ( Y:Var  )  { P:Proc } )  => SetItem(X) SetItem(Y) V(P)
  rule V( X:Var  ( _:Chan )  { P:Proc } )  => SetItem(X) V(P)
  rule V( _:Chan ( Y:Var  )  { P:Proc } )  => SetItem(Y) V(P)
  rule V( _:Chan ( _:Chan )  { P:Proc } )  => V(P)

  rule V( X:Var  ! ( P:Proc ) )            => SetItem(X) V(P)
  rule V( _:Chan ! ( P:Proc ) )            => V(P)

  rule V( P:Proc | Q:Proc )                => V(P) V(Q)

  rule V( * X:Var  )                       => SetItem(X)
  rule V( * _:Chan )                       => .Set

  rule V( A1:AExp  + A2:AExp )             => V(A1) V(A2)
  rule V( A1:AExp  - A2:AExp )             => V(A1) V(A2)
  rule V( A1:AExp  * A2:AExp )             => V(A1) V(A2)

  rule V( not B:BExp )                     => V(B)
  rule V( B1:BExp && B2:BExp )             => V(B1) V(B2)

  // Free Variable set
  rule FV( P:Proc ) => intersectSet( FN(P) , V(P) )

// Semantics
// StrProc =/=String "quote" and not a pattern

endmodule
