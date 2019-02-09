// RHO CALCULUS with additional Ground terms

require "domains.k"
require "kast.k"
require "../StructuralTypes/stype.k"

module NAMEVAR-SYNTAX
import DOMAINS
import KAST
import KSEQ-SYMBOLIC
import SET
import STYPE-SYNTAX

// Sets
syntax       Set ::= "FN(" OrPat ")"                    [function]  // free names
                   | "FV(" OrPat ")"                    [function]  // free variables
                   | "BN(" OrPat ")"                    [function]  // bound names
                   | "BV(" OrPat ")"                    [function]  // bound variables
                   | "RN(" OrPat ")"                    [function]  // receive names
                   | "RC(" OrPat ")"                    [function]  // receive channels
                   | "RV(" OrPat ")"                    [function]  // receive variables
                   | "SN(" OrPat ")"                    [function]  // send names
                   | "SC(" OrPat ")"                    [function]  // send channels
                   | "SV(" OrPat ")"                    [function]  // send variables
                   |  "N(" OrPat ")"                    [function]  // names
                   |  "V(" OrPat ")"                    [function]  // variables
                   | "NV(" OrPat ")"                    [function]  // name variables
                   | "PV(" OrPat ")"                    [function]  // process variables
                   |   "(" Set   ")"                     [bracket]

// For sets...
syntax     KItem ::= OrPat
                   | ProcVar "," "procvar"
                   | NameVar "," "namevar"

endmodule


module NAMEVAR
import NAMEVAR-SYNTAX
import SUBSTITUTION

  configuration
    <T>
      <k> $PGM:Set </k>
    </T>

syntax KResult ::= Ground | Reify | Set

// NameOrPats in an OrPat
rule N( { P:OrPat } ) => N(P)  [strict]
rule N(   Nil       ) => .Set
rule N( _:Bool      ) => .Set
rule N( _:Int       ) => .Set
rule N( _:String    ) => .Set
rule N( N:Name      ) => SetItem(N)
rule N( N:NamePat   ) => SetItem(N)

rule N( for( Y:NamePat <- X:Name    ) { P:Proc    } )  => SetItem(X) N(P)  [strict(2)]
rule N( for( Y:NamePat <- X:Name    ) { P:ProcPat } )  => SetItem(X) N(P)  [strict(2)]
rule N( for( Y:NamePat <- X:NamePat ) { P:ProcPat } )  => SetItem(X) N(P)  [strict(2)]

rule N( X:Name    ! ( P:Proc    ) ) => SetItem(X) N(P)  [strict(1)]
rule N( X:NamePat ! ( P:Proc    ) ) => SetItem(X) N(P)  [strict(1)]
rule N( X:Name    ! ( P:ProcPat ) ) => SetItem(X) N(P)  [strict(1)]
rule N( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) N(P)  [strict(1)]

rule N( P:Proc    | Q:Proc    ) => N(P) N(Q)  [strict]
rule N( P:ProcPat | Q:Proc    ) => N(P) N(Q)  [strict]
rule N( P:Proc    | Q:ProcPat ) => N(P) N(Q)  [strict]
rule N( P:ProcPat | Q:ProcPat ) => N(P) N(Q)  [strict]

rule N( * X:Name    ) => SetItem(X)
rule N( * X:NamePat ) => SetItem(X)
/*
rule N( A1:AExp  + A2:AExp ) => N(A1) N(A2)  [strict]
rule N( A1:AExp  - A2:AExp ) => N(A1) N(A2)  [strict]
rule N( A1:AExp  * A2:AExp ) => N(A1) N(A2)  [strict]

rule N( not B:BExp )         => N(B)         [strict]
rule N( B1:BExp && B2:BExp ) => N(B1) N(B2)  [strict]
*/
// Free Name set
rule FN( { P:OrPat } ) => FN(P)  [strict]
rule FN(   Nil    ) => .Set  [anywhere]
rule FN( _:Bool   ) => .Set  [anywhere]
rule FN( _:Int    ) => .Set  [anywhere]
rule FN( _:String ) => .Set  [anywhere]

rule FN( _:Name    ) => .Set        [strict]
rule FN( N:NamePat ) => SetItem(N)  [strict]

rule FN( for( Y:NamePat <- X:Name    ) { P:Proc    } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )  [strict(2)]
rule FN( for( Y:NamePat <- X:Name    ) { P:ProcPat } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )  [strict(2)]
rule FN( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )  [strict(2)]

rule FN( X:Name    ! ( P:Proc    ) ) => SetItem(X) FN(P)  [strict(2)]
rule FN( X:NamePat ! ( P:Proc    ) ) => SetItem(X) FN(P)  [strict(2)]
rule FN( X:Name    ! ( P:ProcPat ) ) => SetItem(X) FN(P)  [strict(2)]
rule FN( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) FN(P)  [strict(2)]

rule FN( P:Proc    | Q:Proc    ) => FN(P) FN(Q)  [strict]
rule FN( P:ProcPat | Q:Proc    ) => FN(P) FN(Q)  [strict]
rule FN( P:Proc    | Q:ProcPat ) => FN(P) FN(Q)  [strict]
rule FN( P:ProcPat | Q:ProcPat ) => FN(P) FN(Q)  [strict]

rule FN( * X:Name    ) => SetItem(X)
rule FN( * X:NamePat ) => SetItem(X)

// Bound Name set
rule BN( { P:OrPat } ) => BN(P)                   [strict]
rule BN( P:Proc      ) => N(P) -Set FN(P)         [strict]
rule BN( P:ProcPat   ) => N(P) -Set FN(P)         [strict]

// Process and name variables in an OrPat
rule V( { P:OrPat } ) => V(P)                     [strict]
rule V(   _:Proc    ) => .Set
rule V(   _:Name    ) => .Set
rule V(   X:NameVar ) => SetItem(X , namevar)
rule V(   P:ProcVar ) => SetItem(P , procvar)
rule V( @ P:ProcPat ) => V(P)                     [strict]

rule V( for( _:NamePat <- X:NamePat ) { _:Proc    } ) => V(X)                     [strict]
rule V( for( Y:NamePat <- _:Name    ) { P:ProcPat } ) => V(P) -Set V(Y)           [strict]
rule V( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => V(X) ( V(P) -Set V(Y) )  [strict(2,3)]

rule V( N:NamePat ! ( _:Proc    ) ) => V(N)       [strict]
rule V( _:Name    ! ( P:ProcPat ) ) => V(P)       [strict]
rule V( N:NamePat ! ( P:ProcPat ) ) => V(N) V(P)  [strict]

rule V( P:ProcPat | _:Proc    ) => V(P)           [strict]
rule V( _:Proc    | Q:ProcPat ) => V(Q)           [strict]
rule V( P:ProcPat | Q:ProcPat ) => V(P) V(Q)      [strict]

rule V( * X:NamePat ) => V(X)  [strict]

// Name variables
rule NV( { P:OrPat } ) => NV(P)      [strict]
rule NV(   _:Proc    ) => .Set
rule NV(   _:Name    ) => .Set
rule NV(   X:NameVar ) => SetItem(X)
rule NV(   P:ProcVar ) => .Set
rule NV( @ P:ProcPat ) => NV(P)      [strict]

rule NV( for( _:NamePat <- X:NamePat ) { _:Proc    } ) => NV(X)                       [strict]
rule NV( for( Y:NamePat <- _:Name    ) { P:ProcPat } ) => NV(P) -Set NV(Y)            [strict]
rule NV( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => NV(X) ( NV(P) -Set NV(Y) )  [strict(2,3)]

rule NV( N:NamePat ! ( _:Proc    ) ) => NV(N)        [strict]
rule NV( _:Name    ! ( P:ProcPat ) ) => NV(P)        [strict]
rule NV( N:NamePat ! ( P:ProcPat ) ) => NV(N) NV(P)  [strict]

rule NV( P:ProcPat | _:Proc    ) => NV(P)            [strict]
rule NV( _:Proc    | Q:ProcPat ) => NV(Q)            [strict]
rule NV( P:ProcPat | Q:ProcPat ) => NV(P) NV(Q)      [strict]

rule NV( * X:NamePat ) => NV(X)  [strict]

// Process variables

// Bound Variable set
rule BV( { P:OrPat } ) => BV(P)  [strict]
rule BV( _:Proc      ) => .Set
rule BV( P:ProcPat   ) => intersectSet( BN(P) , V(P) )  [strict(1,2)]

// Receive Name set
rule RN( { P:OrPat } ) => RN(P)  [strict]
rule RN(   Nil    ) => .Set
rule RN( _:Bool   ) => .Set
rule RN( _:Int    ) => .Set
rule RN( _:String ) => .Set

rule RN( for( Y:NamePat <- X:Name    ) { P:Proc    } )  => SetItem(X) ( RN(P) -Set SetItem(Y) )  [strict(2)]
rule RN( for( Y:NamePat <- X:Name    ) { P:ProcPat } )  => SetItem(X) ( RN(P) -Set SetItem(Y) )  [strict(2)]
rule RN( for( Y:NamePat <- X:NamePat ) { P:ProcPat } )  => SetItem(X) ( RN(P) -Set SetItem(Y) )  [strict(2)]

rule RN( _:Name    ! ( P:Proc    ) ) => RN(P)  [strict]
rule RN( _:NamePat ! ( P:Proc    ) ) => RN(P)  [strict]
rule RN( _:Name    ! ( P:ProcPat ) ) => RN(P)  [strict]
rule RN( _:NamePat ! ( P:ProcPat ) ) => RN(P)  [strict]

rule RN( P:Proc    | Q:Proc    ) => RN(P) RN(Q)  [strict]
rule RN( P:ProcPat | Q:Proc    ) => RN(P) RN(Q)  [strict]
rule RN( P:Proc    | Q:ProcPat ) => RN(P) RN(Q)  [strict]
rule RN( P:ProcPat | Q:ProcPat ) => RN(P) RN(Q)  [strict]

rule RN( * _:Name    ) => .Set
rule RN( * _:NamePat ) => .Set

// Receive Variable set
rule RV( { P:OrPat } ) => RV(P)  [strict]
rule RV( _:Proc ) => .Set

rule RV( for( Y:NamePat <- _:Name    ) { P:ProcPat } ) => RV(P) -Set SetItem( Y )              [strict(1)]
rule RV( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => SetItem(X) ( RV(P)-Set SetItem(Y) )  [strict(2)]

rule RV( _:NamePat ! ( _:Proc    ) ) => .Set
rule RV( _:Name    ! ( P:ProcPat ) ) => RV(P)  [strict]
rule RV( _:NamePat ! ( P:ProcPat ) ) => RV(P)  [strict]

rule RV( P:ProcPat | _:Proc    ) => RV(P)        [strict]
rule RV( _:Proc    | P:ProcPat ) => RV(P)        [strict]
rule RV( P:ProcPat | Q:ProcPat ) => RV(P) RV(Q)  [strict]

rule RV( * _:NamePat  ) => .Set  [anywhere]

// Send Names
rule SN( { P:OrPat } ) => SN(P)  [strict]
rule SN(   Nil    ) => .Set
rule SN( _:Bool   ) => .Set
rule SN( _:Int    ) => .Set
rule SN( _:String ) => .Set

rule SN( for( Y:NamePat <- _:Name    ) { P:Proc    }  ) => SN(P) -Set SetItem(Y)  [strict(1)]
rule SN( for( Y:NamePat <- _:Name    ) { P:ProcPat }  ) => SN(P) -Set SetItem(Y)  [strict(1)]
rule SN( for( Y:NamePat <- _:NamePat ) { P:ProcPat }  ) => SN(P) -Set SetItem(Y)  [strict(1)]

rule SN( X:Name    ! ( P:Proc    ) ) => SetItem(X) SN(P)  [strict(2)]
rule SN( X:NamePat ! ( P:Proc    ) ) => SetItem(X) SN(P)  [strict(2)]
rule SN( X:Name    ! ( P:ProcPat ) ) => SetItem(X) SN(P)  [strict(2)]
rule SN( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) SN(P)  [strict(2)]

rule SN( P:Proc    | Q:Proc    ) => SN(P) SN(Q)  [strict]
rule SN( P:ProcPat | Q:Proc    ) => SN(P) SN(Q)  [strict]
rule SN( P:Proc    | Q:ProcPat ) => SN(P) SN(Q)  [strict]
rule SN( P:ProcPat | Q:ProcPat ) => SN(P) SN(Q)  [strict]

rule SN( * _:Name    ) => .Set
rule SN( * _:NamePat ) => .Set

// Send Variable set
rule SV( { P:OrPat } ) => SV(P)  [strict]
rule SV( _:Proc ) => .Set

rule SV( for( _:NamePat <- _:Name    ) { P:ProcPat } )  => SV(P)  [strict]
rule SV( for( _:NamePat <- _:NamePat ) { P:ProcPat } )  => SV(P)  [strict]

rule SV( X:NamePat ! ( _:Proc    ) ) => SetItem(X)
rule SV( _:Name    ! ( P:ProcPat ) ) => SV(P)             [strict]
rule SV( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) SV(P)  [strict(2)]

rule SV( P:ProcPat | _:Proc    ) => SV(P)        [strict]
rule SV( _:Proc    | P:ProcPat ) => SV(P)        [strict]
rule SV( P:ProcPat | Q:ProcPat ) => SV(P) SV(Q)  [strict]

rule SV( * _:NamePat ) => .Set

endmodule
