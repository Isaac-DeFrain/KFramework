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
                   | NameDeclaration
                   | NameDeclarations

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
                   | "CC(" Arg ")"                    [function]  // comm channels
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

// Ground/Leaves
rule N(   Nil     ) => .Set
rule N( _:Bool    ) => .Set
rule N( _:Int     ) => .Set
rule N( _:String  ) => .Set
rule N( _:Uri     ) => .Set
rule N( WildName  ) => .Set
rule N( _:ProcVar ) => .Set
rule N( WildProc  ) => .Set

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

// RhoMap - keep all names?
rule N( { R:RhoKVPairs } ) => N(R)
rule N( P:Proc : Q:Proc  ) => N(P) N(Q)
rule N( P:Proc : Q:Proc , R:RhoKVPairs ) => N(P:Q) N(R)

// Bundles
rule N( bundle+{ P:Proc } ) => SN(P)  // write-only => only send names available
rule N( bundle-{ P:Proc } ) => RN(P)  // read-only  => only receive names available
rule N( bundle0{ P:Proc } ) => .Set   // no read/write => no names available
rule N( bundle { P:Proc } ) => N(P)   // read/write => both send & receive names available

// New
rule N( new X:NameDeclaration  in { P:Proc } ) => SetItem(X) N(P)  // X is a bound name
rule N( new X:NameDeclarations in { P:Proc } ) => N(X) N(P)        // X is a list of bound names

// Resolving brackets
rule N( { P:OrPat } ) => N(P)

//---------------------
//--- Receive Names ---
//---------------------

// Ground/Leaves
rule RN(   Nil     ) => .Set
rule RN( _:Bool    ) => .Set
rule RN( _:Int     ) => .Set
rule RN( _:String  ) => .Set
rule RN( _:Uri     ) => .Set
rule RN( _:ProcVar ) => .Set
rule RN( WildName  ) => .Set
rule RN( WildProc  ) => .Set

// Name/NamePat
rule RN( _:Name      ) => .Set
rule RN( _:Names     ) => .Set
rule RN( _:NamePat   ) => .Set

// Receives
rule RN( for( B:Bind  ) { P:Proc    } ) => RN(B) RN(P)
rule RN( for( B:Bind  ) { P:ProcPat } ) => RN(B) RN(P)
rule RN( for( B:Binds ) { P:Proc    } ) => RN(B) RN(P)
rule RN( for( B:Binds ) { P:ProcPat } ) => RN(B) RN(P)
rule RN( _:BindNamePat  <- X:Name ) => SetItem(X)
rule RN( _:BindNamePats <- X:Name ) => SetItem(X)
rule RN( _:BindNamePat  <! X:Name ) => SetItem(X)
rule RN( _:BindNamePats <! X:Name ) => SetItem(X)
rule RN( _:BindNamePat  <= X:Name ) => SetItem(X)
rule RN( _:BindNamePats <= X:Name ) => SetItem(X)
rule RN( A:Lbind ; B:Lbind  ) => RN(A) RN(B)
rule RN( A:Lbind ; B:Lbinds ) => RN(A) RN(B)
rule RN( A:Pbind ; B:Pbind  ) => RN(A) RN(B)
rule RN( A:Pbind ; B:Pbinds ) => RN(A) RN(B)
rule RN( A:Rbind ; B:Rbind  ) => RN(A) RN(B)
rule RN( A:Rbind ; B:Rbinds ) => RN(A) RN(B)

// Sends - discard NamePat?
rule RN( _:Name    !  ( P:Proc    ) ) => RN(P)
rule RN( _:NamePat !  ( P:Proc    ) ) => RN(P)
rule RN( _:Name    !  ( P:ProcPat ) ) => RN(P)
rule RN( _:NamePat !  ( P:ProcPat ) ) => RN(P)
rule RN( _:Name    !! ( P:Proc    ) ) => RN(P)
rule RN( _:NamePat !! ( P:Proc    ) ) => RN(P)
rule RN( _:Name    !! ( P:ProcPat ) ) => RN(P)
rule RN( _:NamePat !! ( P:ProcPat ) ) => RN(P)

// Par
rule RN( P:Proc    | Q:Proc    ) => RN(P) RN(Q)
rule RN( P:ProcPat | Q:Proc    ) => RN(P) RN(Q)
rule RN( P:Proc    | Q:ProcPat ) => RN(P) RN(Q)
rule RN( P:ProcPat | Q:ProcPat ) => RN(P) RN(Q)

// Eval
rule RN( * _:Name    ) => .Set
rule RN( * X:NamePat ) => RN(X)

// Procs
rule RN( P:Proc , Q:Proc  ) => RN(P) RN(Q)
rule RN( P:Proc , Q:Procs ) => RN(P) RN(Q)

// RhoTuple
rule RN( tuple1( P:Proc  ) ) => RN(P)
rule RN( tuplen( P:Procs ) ) => RN(P)

// RhoList
rule RN( [ P:Proc  ] ) => RN(P)
rule RN( [ P:Procs ] ) => RN(P)

// RhoSet
rule RN( Set( P:Proc  ) ) => RN(P)
rule RN( Set( P:Procs ) ) => RN(P)

// RhoMap - keep all names?
rule RN( { R:RhoKVPairs } ) => RN(R)
rule RN( P:Proc : Q:Proc  ) => RN(P) RN(Q)
rule RN( P:Proc : Q:Proc , R:RhoKVPairs ) => RN(P:Q) RN(R)

// Bundles
rule RN( bundle+{ _:Proc } ) => .Set   // write-only => only send names available
rule RN( bundle-{ P:Proc } ) => RN(P)  // read-only  => only receive names available
rule RN( bundle0{ _:Proc } ) => .Set   // no read/write => no names available
rule RN( bundle { P:Proc } ) => RN(P)  // read/write => both send & receive names available

// New
rule RN( new _:NameDeclaration  in { P:Proc } ) => RN(P)
rule RN( new _:NameDeclarations in { P:Proc } ) => RN(P)

// Resolving brackets
rule RN( { P:OrPat  } ) => RN(P)

//------------------
//--- Send Names ---
//------------------

// Ground/Leaves
rule SN(   Nil     ) => .Set
rule SN( _:Bool    ) => .Set
rule SN( _:Int     ) => .Set
rule SN( _:String  ) => .Set
rule SN( _:Uri     ) => .Set
rule SN( _:ProcVar ) => .Set
rule SN( WildName  ) => .Set
rule SN( WildProc  ) => .Set

// Name/NamePat
rule SN( _:Name      ) => .Set
rule SN( _:Names     ) => .Set
rule SN( @ P:ProcPat ) => SN(P)

// Receives
rule SN( for( B:Bind  ) { P:Proc    } ) => SN(P)
rule SN( for( B:Bind  ) { P:ProcPat } ) => SN(P)
rule SN( for( B:Binds ) { P:Proc    } ) => SN(P)
rule SN( for( B:Binds ) { P:ProcPat } ) => SN(P)
rule SN( _:BindNamePat  <- _:Name ) => .Set
rule SN( _:BindNamePats <- _:Name ) => .Set
rule SN( _:BindNamePat  <! _:Name ) => .Set
rule SN( _:BindNamePats <! _:Name ) => .Set
rule SN( _:BindNamePat  <= _:Name ) => .Set
rule SN( _:BindNamePats <= _:Name ) => .Set
rule SN( _:Lbinds ) => .Set
rule SN( _:Pbinds ) => .Set
rule SN( _:Rbinds ) => .Set

// Sends - include NamePat as element or ?
rule SN( X:Name    !  ( P:Proc    ) ) => SetItem(X) SN(P)
rule SN( X:NamePat !  ( P:Proc    ) ) => SetItem(X) SN(P)
rule SN( X:Name    !  ( P:ProcPat ) ) => SetItem(X) SN(P)
rule SN( X:NamePat !  ( P:ProcPat ) ) => SetItem(X) SN(P)
rule SN( X:Name    !! ( P:Proc    ) ) => SetItem(X) SN(P)
rule SN( X:NamePat !! ( P:Proc    ) ) => SetItem(X) SN(P)
rule SN( X:Name    !! ( P:ProcPat ) ) => SetItem(X) SN(P)
rule SN( X:NamePat !! ( P:ProcPat ) ) => SetItem(X) SN(P)

// Par
rule SN( P:Proc    | Q:Proc    ) => SN(P) SN(Q)
rule SN( P:ProcPat | Q:Proc    ) => SN(P) SN(Q)
rule SN( P:Proc    | Q:ProcPat ) => SN(P) SN(Q)
rule SN( P:ProcPat | Q:ProcPat ) => SN(P) SN(Q)

// Eval
rule SN( * X:Name    ) => .Set
rule SN( * X:NamePat ) => SN(X)

// Procs
rule SN( P:Proc , Q:Proc  ) => SN(P) SN(Q)
rule SN( P:Proc , Q:Procs ) => SN(P) SN(Q)

// RhoTuple
rule SN( tuple1( P:Proc  ) ) => SN(P)
rule SN( tuplen( P:Procs ) ) => SN(P)

// RhoList
rule SN( [ P:Proc  ] ) => SN(P)
rule SN( [ P:Procs ] ) => SN(P)

// RhoSet
rule SN( Set( P:Proc  ) ) => SN(P)
rule SN( Set( P:Procs ) ) => SN(P)

// RhoMap
rule SN( { R:RhoKVPairs } ) => SN(R)
rule SN( P:Proc : Q:Proc  ) => SN(P) SN(Q)
rule SN( P:Proc : Q:Proc , R:RhoKVPairs ) => SN(P:Q) SN(R)

// Bundles
rule SN( bundle+{ P:Proc } ) => SN(P)  // write-only => only send names available
rule SN( bundle-{ P:Proc } ) => .Set   // read-only  => only receive names available
rule SN( bundle0{ P:Proc } ) => .Set   // no read/write => no names available
rule SN( bundle { P:Proc } ) => SN(P)  // read/write => both send & receive names available

// New
rule SN( new _:NameDeclaration  in { P:Proc } ) => SN(P)
rule SN( new _:NameDeclarations in { P:Proc } ) => SN(P)

// Resolving brackets
rule SN( { P:OrPat } ) => SN(P)

//---------------------
//--- Comm Channels ---
//---------------------
 rule CC( A:Arg ) => intersectSet ( SN(A) , RN(A) )

//-----------------
//--- Free Name ---
//-----------------
/*
rule FN( { P:OrPat } ) => FN(P)
rule FN(   Nil    ) => .Set
rule FN( _:Bool   ) => .Set
rule FN( _:Int    ) => .Set
rule FN( _:String ) => .Set

rule FN( _:Name    ) => .Set
rule FN( N:NamePat ) => SetItem(N)

rule FN( for( Y:BindNamePat <- X:Name    ) { P:Proc    } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )
rule FN( for( Y:BindNamePat <- X:Name    ) { P:ProcPat } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )

rule FN( X:Name    ! ( P:Proc    ) ) => SetItem(X) FN(P)
rule FN( X:NamePat ! ( P:Proc    ) ) => SetItem(X) FN(P)
rule FN( X:Name    ! ( P:ProcPat ) ) => SetItem(X) FN(P)
rule FN( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) FN(P)

rule FN( P:Proc    | Q:Proc    ) => FN(P) FN(Q)
rule FN( P:ProcPat | Q:Proc    ) => FN(P) FN(Q)
rule FN( P:Proc    | Q:ProcPat ) => FN(P) FN(Q)
rule FN( P:ProcPat | Q:ProcPat ) => FN(P) FN(Q)

rule FN( * X:Name    ) => SetItem(X)
rule FN( * X:NamePat ) => SetItem(X)

// Bound Name set
rule BN( { P:OrPat } ) => BN(P)
rule BN( P:Proc      ) => N(P) -Set FN(P)
rule BN( P:ProcPat   ) => N(P) -Set FN(P)

// Process and name variables in an OrPat
rule V( { P:OrPat } ) => V(P)
rule V(   _:Proc    ) => .Set
rule V(   _:Name    ) => .Set
rule V( @ P:ProcVar ) => SetItem(@P)
rule V( @ P:ProcPat ) => V(P)

rule V( for( _:BindNamePat <- X:Name ) { _:Proc    } ) => V(X)
rule V( for( Y:BindNamePat <- X:Name ) { P:ProcPat } ) => V(X) ( V(P) -Set V(Y) )

rule V( N:NamePat ! ( _:Proc    ) ) => V(N)
rule V( _:Name    ! ( P:ProcPat ) ) => V(P)
rule V( N:NamePat ! ( P:ProcPat ) ) => V(N) V(P)

rule V( P:ProcPat | _:Proc    ) => V(P)
rule V( _:Proc    | Q:ProcPat ) => V(Q)
rule V( P:ProcPat | Q:ProcPat ) => V(P) V(Q)

rule V( * X:NamePat ) => V(X)

// Name variables

rule NV( { P:OrPat } ) => NV(P)
rule NV(   _:Proc    ) => .Set
rule NV(   _:Name    ) => .Set
rule NV(   X:NameVar ) => SetItem(X)
rule NV(   P:ProcVar ) => .Set
rule NV( @ P:ProcPat ) => NV(P)

rule NV( for( _:NamePat <- X:NamePat ) { _:Proc    } ) => NV(X)
rule NV( for( Y:NamePat <- _:Name    ) { P:ProcPat } ) => NV(P) -Set NV(Y)
rule NV( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => NV(X) ( NV(P) -Set NV(Y) )

rule NV( N:NamePat ! ( _:Proc    ) ) => NV(N)
rule NV( _:Name    ! ( P:ProcPat ) ) => NV(P)
rule NV( N:NamePat ! ( P:ProcPat ) ) => NV(N) NV(P)

rule NV( P:ProcPat | _:Proc    ) => NV(P)
rule NV( _:Proc    | Q:ProcPat ) => NV(Q)
rule NV( P:ProcPat | Q:ProcPat ) => NV(P) NV(Q)

rule NV( * X:NamePat ) => NV(X)

// Bound Variable set
rule BV( { P:OrPat } ) => BV(P)
rule BV( P:ProcPat   ) => intersectSet( BN(P) , V(P) )

// Receive Variable set
rule RV( { P:OrPat } ) => RV(P)

rule RV( for( Y:BindNamePat <- X:Name ) { P:ProcPat } ) => RV(X) ( RV(P)-Set SetItem(Y) )

rule RV( _:NamePat ! ( _:Proc    ) ) => .Set
rule RV( _:Name    ! ( P:ProcPat ) ) => RV(P)
rule RV( _:NamePat ! ( P:ProcPat ) ) => RV(P)

rule RV( P:ProcPat | _:Proc    ) => RV(P)
rule RV( _:Proc    | P:ProcPat ) => RV(P)
rule RV( P:ProcPat | Q:ProcPat ) => RV(P) RV(Q)

rule RV( * _:NamePat  ) => .Set

// Send Variable set
rule SV( { P:OrPat } ) => SV(P)

rule SV( for( _:BindNamePat <- _:Name    ) { P:ProcPat } )  => SV(P)

rule SV( X:NamePat ! ( _:Proc    ) ) => SetItem(X)
rule SV( _:Name    ! ( P:ProcPat ) ) => SV(P)
rule SV( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) SV(P)

rule SV( P:ProcPat | _:Proc    ) => SV(P)
rule SV( _:Proc    | P:ProcPat ) => SV(P)
rule SV( P:ProcPat | Q:ProcPat ) => SV(P) SV(Q)

rule SV( * _:NamePat ) => .Set
*/
endmodule
