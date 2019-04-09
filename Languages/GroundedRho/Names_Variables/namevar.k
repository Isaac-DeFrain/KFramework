// Names and Variables for RHO CALCULUS with additional Ground terms

require "domains.k"
require "../grho.k"

module NAMEVAR-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

  syntax     Arg ::= NameListOrEmpty
                   | ProcListOrEmpty
                   | RhoKVPairsOrEmpty
                   | BindList
                   | MatchCaseList
                   | MethodAndArgs

// Sets
  syntax     Set ::=  "FN(" Arg ")"                   [function]  // free names
                   |  "FV(" Arg ")"                   [function]  // free variables
                   |  "BV(" Arg ")"                   [function]  // bound variables
                   |  "RN(" Arg ")"                   [function]  // receive names
                   |  "RC(" Arg ")"                   [function]  // receive channels
                   |  "RV(" Arg ")"                   [function]  // receive variables
                   |  "SN(" Arg ")"                   [function]  // send names
                   |  "SC(" Arg ")"                   [function]  // send channels
                   |  "SV(" Arg ")"                   [function]  // send variables
                   |   "N(" Arg ")"                   [function]  // names
                   |   "V(" Arg ")"                   [function]  // variables
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

// Ground Terms
rule N(   Nil     ) => .Set
rule N( _:Ground  ) => .Set
rule N(   #       ) => .Set

// NameList
rule N( X:NameVar     ) => SetItem(X)
rule N( @ P:Proc      ) => SetItem(@P) N(P)
rule N( U:Unforgeable ) => SetItem(U)

rule N( A:Name , B:Name  ) => SetItem(A) SetItem(B)
rule N( A:Name , B:Names ) => SetItem(A) N(B)

// Receives
rule N( for( B:Bind  ) { P:Proc } ) => N(B) N(P)
rule N( for( B:Binds ) { P:Proc } ) => N(B) N(P)
rule N( _:NameList <- X:Name ) => SetItem(X)
rule N(          # <- X:Name ) => SetItem(X)
rule N( _:NameList <! X:Name ) => SetItem(X)
rule N(          # <! X:Name ) => SetItem(X)
rule N( _:NameList <= X:Name ) => SetItem(X)
rule N(          # <= X:Name ) => SetItem(X)
rule N( A:Lbind ; B:Lbind  ) => N(A) N(B)
rule N( A:Lbind ; B:Lbinds ) => N(A) N(B)
rule N( A:Pbind ; B:Pbind  ) => N(A) N(B)
rule N( A:Pbind ; B:Pbinds ) => N(A) N(B)
rule N( A:Rbind ; B:Rbind  ) => N(A) N(B)
rule N( A:Rbind ; B:Rbinds ) => N(A) N(B)
rule N( contract X:Name ( Y:NameList ) = { P:Proc } ) => N( for( Y <= X ){ P } )

// Sends
rule N( X:Name !  ( P:Proc ) ) => SetItem(X) N(P)
rule N( X:Name !! ( P:Proc ) ) => SetItem(X) N(P)

// Par
rule N( P:Proc | Q:Proc ) => N(P) N(Q)

// Eval
rule N( * X:Name ) => N(X)

// Procs
rule N( P:Proc , Q:Proc  ) => N(P) N(Q)
rule N( P:Proc , Q:Procs ) => N(P) N(Q)

// RhoTuple
rule N( tuple( P:ProcList ) ) => N(P)

// RhoList
rule N( [ P:ProcList ] ) => N(P)
rule N( [ # ] ) => .Set

// RhoSet
rule N( Set( P:ProcList ) ) => N(P)
rule N( Set( # ) ) => .Set

// RhoMap
rule N( { # } ) => .Set
rule N( { R:RhoKVPairs } ) => N(R)
rule N( P:Proc : Q:Proc  ) => N(P) N(Q)
rule N( P:Proc : Q:Proc , R:RhoKVPairs ) => N(P:Q) N(R)

// Bundles
rule N( bundle+{ P:Proc } ) => SN(P)  // write-only => only send names available
rule N( bundle-{ P:Proc } ) => RN(P)  // read-only  => only receive names available
rule N( bundle0{ P:Proc } ) => .Set   // no read/write => no names available
rule N( bundle { P:Proc } ) => N(P)   // read/write => both send & receive names available

// New
rule N( new X:NameList in { P:Proc } ) => N(X) N(P)  // X is a list of bound names

// Arithmetic Expressions
rule N( A:AExp * B:AExp ) => N(A) N(B)
rule N( A:AExp / B:AExp ) => N(A) N(B)
rule N( A:AExp + B:AExp ) => N(A) N(B)
rule N( A:AExp - B:AExp ) => N(A) N(B)

// Boolean Expressions
rule N( not B:BExp        ) => N(B)
rule N( A:BExp and B:BExp ) => N(A) N(B)
rule N( A:BExp or  B:BExp ) => N(A) N(B)
rule N( A:AExp <=  B:AExp ) => N(A) N(B)

// Conditional
rule N( if (B:BExp) then P:Proc  ) => N(B) N(P)
rule N( A:IfThen  else P:Proc  ) => N(A) N(P)

// Match
rule N( match P:Proc { M:MatchCaseList } ) => N(P) N(M)

rule N( P:Proc :=> Q:Proc        ) => N(P) N(Q)
rule N( A:MatchCase B:MatchCase  ) => N(A) N(B)
rule N( A:MatchCase B:MatchCases ) => N(A) N(B)

// Method
rule N( P:Proc . M:MethodAndArgs ) => N(P) N(M)
rule N( _:Method ( A:ProcListOrEmpty )) => N(A)

// Variable Reference
rule N( X:NameVar = Y:NameVar ) => SetItem(X) SetItem(Y)

// Resolving brackets
rule N( { P:Proc } ) => N(P)

//----------------------
//--- Free Variables ---
//----------------------

rule FV(   Nil         ) => .Set
rule FV( _:Ground      ) => .Set
rule FV(   #           ) => .Set
rule FV( _:Unforgeable ) => .Set

rule FV( X:NameVar ) => SetItem(X)
rule FV( @ P:Proc  ) => FV(P)

rule FV( X:Name , Y:Name  ) => FV(X) FV(Y)
rule FV( X:Name , Y:Names ) => FV(X) FV(Y)

rule FV( P:Proc , Q:Proc  ) => FV(P) FV(Q)
rule FV( P:Proc , Q:Procs ) => FV(P) FV(Q)

rule FV( for( Y:NameList <- X:Name ) { P:Proc } ) => SetItem(X) ( FV(P) -Set FV(Y) )
rule FV( for(          # <- X:Name ) { P:Proc } ) => SetItem(X) FV(P)
rule FV( for( Y:NameList <= X:Name ) { P:Proc } ) => SetItem(X) ( FV(P) -Set FV(Y) )
rule FV( for(          # <= X:Name ) { P:Proc } ) => SetItem(X) FV(P)
rule FV( for( Y:NameList <! X:Name ) { P:Proc } ) => SetItem(X) ( FV(P) -Set FV(Y) )
rule FV( for(          # <! X:Name ) { P:Proc } ) => SetItem(X) FV(P)
rule FV( for( Y:NameList << X:Name ) { P:Proc } ) => SetItem(X) ( FV(P) -Set FV(Y) )
rule FV( for(          # << X:Name ) { P:Proc } ) => SetItem(X) FV(P)
rule FV( contract X:Name ( Y:NameListOrEmpty ) = { P:Proc } ) => SetItem(X) ( FV(P) -Set FV(Y) )

rule FV( X:Name ! ( P:Proc ) ) => FV(X) FV(P)
rule FV( X:Name !!( P:Proc ) ) => FV(X) FV(P)

rule FV( P:Proc | Q:Proc ) => FV(P) FV(Q)

rule FV( * X:Name ) => FV(X)

rule FV( { P:Proc } ) => FV(P)
/*
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

// Bound Variable set
rule BV( { P:OrPat } ) => BV(P)
rule BV( P:ProcPat   ) => intersectSet( BN(P) , V(P) )
*/

// Receive Names
rule RN( { P:Proc } ) => RN(P)

rule RN( for( _:NameListOrEmpty <- X:Name ) { _:Proc } ) => SetItem(X)
rule RN( for( _:NameListOrEmpty <= X:Name ) { _:Proc } ) => SetItem(X)
rule RN( for( _:NameListOrEmpty <! X:Name ) { _:Proc } ) => SetItem(X)
rule RN( for( _:NameListOrEmpty << X:Name ) { _:Proc } ) => SetItem(X)

rule RN( for( _:NameListOrEmpty <- X:Name ; A:Lbind  ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameListOrEmpty <- X:Name ; A:Lbinds ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameListOrEmpty <= X:Name ; A:Rbind  ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameListOrEmpty <= X:Name ; A:Rbinds ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameListOrEmpty <! X:Name ; A:Pbind  ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameListOrEmpty <! X:Name ; A:Pbinds ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameListOrEmpty << X:Name ; A:Sbind  ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameListOrEmpty << X:Name ; A:Sbinds ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )

rule RN( _:Name ! ( P:Proc ) ) => .Set

rule RN( P:Proc | Q:Proc ) => RN(P) RN(Q)

rule RN( * _:Name  ) => .Set

// Send Names
rule SN( { P:Proc } ) => SN(P)

rule SN( _:Receive )  => .Set

rule SN( X:Name ! ( _:Proc ) ) => SetItem(X)

rule SN( P:Proc | Q:Proc ) => SN(P) SN(Q)

rule SN( * _:Name ) => .Set

endmodule
