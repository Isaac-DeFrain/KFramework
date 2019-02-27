// RHO CALCULUS with additional Ground terms

require "domains.k"
require "../StructuralTypes/stype.k"

module NAMEVAR-SYNTAX
  import DOMAINS
  import SET
  import STYPE-SYNTAX

  syntax     Arg ::= OrPat
                   | OrPats
                   | Bind
                   | Binds
                   | BindNamePat
                   | BindNamePats
                   | RhoKVPairs

// Sets
  syntax     Set ::=   "(" Set ")"                     [bracket]
                   > "FN(" Arg ")"                    [function]  // free names
                   | "FV(" Arg ")"                    [function]  // free variables
                   | "BN(" Arg ")"                    [function]  // bound names
                   | "BV(" Arg ")"                    [function]  // bound variables
                   | "RN(" Arg ")"                    [function]  // receive names
                   | "RC(" Arg ")"                    [function]  // receive channels
                   | "RV(" Arg ")"                    [function]  // receive variables
                   | "SN(" Arg ")"                    [function]  // send names
                   | "SC(" Arg ")"                    [function]  // send channels
                   | "SV(" Arg ")"                    [function]  // send variables
                   |  "N(" Arg ")"                    [function]  // names
                   |  "V(" Arg ")"                    [function]  // variables
                   | "NV(" Arg ")"                    [function]  // name variables
// For sets...
syntax     KItem ::= Arg

endmodule


module NAMEVAR
  import NAMEVAR-SYNTAX

  configuration
    <T>
      <k> $PGM:Set </k>
    </T>

syntax KResult ::= Ground | Eval | Set

//-------------
//--- Names ---
//-------------
rule N( { P:OrPat } ) => N(P)
rule N(   Nil       ) => .Set
rule N( _:Bool      ) => .Set
rule N( _:Int       ) => .Set
rule N( _:String    ) => .Set
rule N( _:Uri       ) => .Set
rule N( WildName    ) => .Set
rule N( P:ProcVar   ) => .Set
rule N( WildProc    ) => .Set

// Name/NamePat
rule N( X:Name      ) => SetItem(X)
rule N( @ P:ProcPat ) => N(P)
rule N( A:Name , B:Name  ) => SetItem(A) SetItem(B)
rule N( A:Name , B:Names ) => SetItem(A) N(B)

// Receives
rule N( for( B:Bind  ) { P:Proc    } ) => N(B) N(P)
rule N( for( B:Bind  ) { P:ProcPat } ) => N(B) N(P)
rule N( for( B:Binds ) { P:Proc    } ) => N(B) N(P)
rule N( for( B:Binds ) { P:ProcPat } ) => N(B) N(P)
rule N( _:BindNamePat  <- X:Name ) => SetItem(X)
rule N( _:BindNamePats <- X:Name ) => SetItem(X)
rule N( _:BindNamePat  <! X:Name ) => SetItem(X)
rule N( _:BindNamePats <! X:Name ) => SetItem(X)
rule N( _:BindNamePat  <= X:Name ) => SetItem(X)
rule N( _:BindNamePats <= X:Name ) => SetItem(X)
rule N( A:Lbind ; B:Lbind  ) => N(A) N(B)
rule N( A:Lbind ; B:Lbinds ) => N(A) N(B)
rule N( A:Pbind ; B:Pbind  ) => N(A) N(B)
rule N( A:Pbind ; B:Pbinds ) => N(A) N(B)
rule N( A:Rbind ; B:Rbind  ) => N(A) N(B)
rule N( A:Rbind ; B:Rbinds ) => N(A) N(B)

// Sends
rule N( X:Name    !  ( P:Proc    ) ) => SetItem(X) N(P)
rule N( X:NamePat !  ( P:Proc    ) ) => N(X) N(P)
rule N( X:Name    !  ( P:ProcPat ) ) => SetItem(X) N(P)
rule N( X:NamePat !  ( P:ProcPat ) ) => N(X) N(P)
rule N( X:Name    !! ( P:Proc    ) ) => SetItem(X) N(P)
rule N( X:NamePat !! ( P:Proc    ) ) => N(X) N(P)
rule N( X:Name    !! ( P:ProcPat ) ) => SetItem(X) N(P)
rule N( X:NamePat !! ( P:ProcPat ) ) => N(X) N(P)

// Par
rule N( P:Proc    | Q:Proc    ) => N(P) N(Q)
rule N( P:ProcPat | Q:Proc    ) => N(P) N(Q)
rule N( P:Proc    | Q:ProcPat ) => N(P) N(Q)
rule N( P:ProcPat | Q:ProcPat ) => N(P) N(Q)

// Eval
rule N( * X:Name    ) => SetItem(X)
rule N( * X:NamePat ) => N(X)

// Procs
rule N( P:Proc , Q:Proc  ) => N(P) N(Q)
rule N( P:Proc , Q:Procs ) => N(P) N(Q)

// RhoTuple
rule N( tuple1( P:Proc  ) ) => N(P)
rule N( tuplen( P:Procs ) ) => N(P)

// RhoList
rule N( [ P:Proc  ] ) => N(P)
rule N( [ P:Procs ] ) => N(P)

// RhoSet
rule N( Set( P:Proc  ) ) => N(P)
rule N( Set( P:Procs ) ) => N(P)

// RhoMap - keep all names present?
rule N( { R:RhoKVPairs } ) => N(R)
rule N( P:Proc : Q:Proc  ) => N(P) N(Q)
rule N( P:Proc : Q:Proc , R:RhoKVPairs ) => N(P) N(Q) N(R)

// Bundles - only keep names from write bundles?
rule N( bundle+{ P:Proc } ) => N(P)
rule N( bundle-{ P:Proc } ) => .Set  // read-only
rule N( bundle0{ P:Proc } ) => N(P)
rule N( bundle { P:Proc } ) => .Set  // no read/write

// New
rule N( new X:NameDeclaration  in { P:Proc } ) => SetItem(X) N(P)
rule N( new X:NameDeclarations in { P:Proc } ) => N(X) N(P)

//-----------------
//--- Free Name ---
//-----------------
rule FN( { P:OrPat } ) => FN(P)  [strict]
rule FN(   Nil    ) => .Set  [anywhere]
rule FN( _:Bool   ) => .Set  [anywhere]
rule FN( _:Int    ) => .Set  [anywhere]
rule FN( _:String ) => .Set  [anywhere]

rule FN( _:Name    ) => .Set        [strict]
rule FN( N:NamePat ) => SetItem(N)  [strict]

rule FN( for( Y:BindNamePat <- X:Name    ) { P:Proc    } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )  [strict(2)]
rule FN( for( Y:BindNamePat <- X:Name    ) { P:ProcPat } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )  [strict(2)]

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
rule V( @ P:ProcVar ) => SetItem(@P)
rule V( @ P:ProcPat ) => V(P)                     [strict]

rule V( for( _:BindNamePat <- X:Name ) { _:Proc    } ) => V(X)                     [strict]
rule V( for( Y:BindNamePat <- X:Name ) { P:ProcPat } ) => V(X) ( V(P) -Set V(Y) )  [strict(2,3)]

rule V( N:NamePat ! ( _:Proc    ) ) => V(N)       [strict]
rule V( _:Name    ! ( P:ProcPat ) ) => V(P)       [strict]
rule V( N:NamePat ! ( P:ProcPat ) ) => V(N) V(P)  [strict]

rule V( P:ProcPat | _:Proc    ) => V(P)           [strict]
rule V( _:Proc    | Q:ProcPat ) => V(Q)           [strict]
rule V( P:ProcPat | Q:ProcPat ) => V(P) V(Q)      [strict]

rule V( * X:NamePat ) => V(X)  [strict]

// Name variables
/*
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
*/
// Bound Variable set
rule BV( { P:OrPat } ) => BV(P)  [strict]
rule BV( P:ProcPat   ) => intersectSet( BN(P) , V(P) )  [strict(1,2)]

// Receive Name set
rule RN( { P:OrPat } ) => RN(P)  [strict]
rule RN(   Nil    ) => .Set
rule RN( _:Bool   ) => .Set
rule RN( _:Int    ) => .Set
rule RN( _:String ) => .Set

rule RN( for( Y:BindNamePat <- X:Name ) { P:Proc    } )  => SetItem(X) ( RN(P) -Set SetItem(Y) )  [strict(2)]
rule RN( for( Y:BindNamePat <- X:Name ) { P:ProcPat } )  => SetItem(X) ( RN(P) -Set SetItem(Y) )  [strict(2)]

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

rule RV( for( Y:BindNamePat <- X:Name ) { P:ProcPat } ) => RV(X) ( RV(P)-Set SetItem(Y) )  [strict(2)]

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

rule SN( for( Y:BindNamePat <- _:Name ) { P:Proc    }  ) => SN(P) -Set SetItem(Y)  [strict(1)]
rule SN( for( Y:BindNamePat <- _:Name ) { P:ProcPat }  ) => SN(P) -Set SetItem(Y)  [strict(1)]

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

rule SV( for( _:BindNamePat <- _:Name    ) { P:ProcPat } )  => SV(P)  [strict]

rule SV( X:NamePat ! ( _:Proc    ) ) => SetItem(X)
rule SV( _:Name    ! ( P:ProcPat ) ) => SV(P)             [strict]
rule SV( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) SV(P)  [strict(2)]

rule SV( P:ProcPat | _:Proc    ) => SV(P)        [strict]
rule SV( _:Proc    | P:ProcPat ) => SV(P)        [strict]
rule SV( P:ProcPat | Q:ProcPat ) => SV(P) SV(Q)  [strict]

rule SV( * _:NamePat ) => .Set

endmodule
