// Names and Variables for RHO CALCULUS with additional Ground terms

require "domains.k"
require "../grho.k"

module NAMEVAR-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

  syntax     Arg ::= NameList
                   | ProcList
                   | RhoKVPairList
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

// Nil, Ground Terms
rule N(   Nil     ) => .Set
rule N( _:Ground  ) => .Set

// NameLists
rule N( X:NameVar     ) => SetItem(X)
rule N( @ P:Proc      ) => SetItem(@P) N(P)
rule N( U:Unforgeable ) => SetItem(U)

rule N( A:Name , B:Name  ) => SetItem(A) SetItem(B)
rule N( A:Name , B:Names ) => SetItem(A) N(B)

// Receives, Binds, Contracts
rule N( for( B:Bind  ) { P:Proc } ) => N(B) N(P)
rule N( for( B:Binds ) { P:Proc } ) => N(B) N(P)

rule N( _:NameList <- X:Name ) => SetItem(X)
rule N(            <- X:Name ) => SetItem(X)
rule N( _:NameList <! X:Name ) => SetItem(X)
rule N(            <! X:Name ) => SetItem(X)
rule N( _:NameList <= X:Name ) => SetItem(X)
rule N(            <= X:Name ) => SetItem(X)
rule N( _:NameList << X:Name ) => SetItem(X)
rule N(            << X:Name ) => SetItem(X)
rule N( A:Lbind ; B:Lbind  ) => N(A) N(B)
rule N( A:Lbind ; B:Lbinds ) => N(A) N(B)
rule N( A:Pbind ; B:Pbind  ) => N(A) N(B)
rule N( A:Pbind ; B:Pbinds ) => N(A) N(B)
rule N( A:Rbind ; B:Rbind  ) => N(A) N(B)
rule N( A:Rbind ; B:Rbinds ) => N(A) N(B)
rule N( A:Sbind ; B:Sbind  ) => N(A) N(B)
rule N( A:Sbind ; B:Sbinds ) => N(A) N(B)
rule N( contract X:Name ( Y:NameList ) = { P:Proc } ) => N( for( Y <= X ){ P } )
rule N( contract X:Name (  ) = { P:Proc } ) => N( for(  <= X ){ P } )


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
rule N( ( ):RhoTuple ) => .Set

// RhoList
rule N( [ P:ProcList ] ) => N(P)
rule N( [  ] ) => .Set

// RhoSet
rule N( Set( P:ProcList ) ) => N(P)
rule N( Set(  ) ) => .Set

// RhoMap
rule N( {  } ) => .Set
rule N( { R:RhoKVPairs } ) => N(R)
rule N( P:Proc : Q:Proc  ) => N(P) N(Q)
rule N( P:Proc : Q:Proc , R:RhoKVPairs ) => N(P:Q) N(R)

/* TODO
// Bundles
rule N( bundle+{ P:Proc } ) => SN(P)  // write-only => only send names available
rule N( bundle-{ P:Proc } ) => RN(P)  // read-only  => only receive names available
rule N( bundle0{ P:Proc } ) => .Set   // no read/write => no names available
rule N( bundle { P:Proc } ) => N(P)   // read/write => both send & receive names available
*/

// New
rule N( new X:NameList in { P:Proc } ) => N(X) N(P)

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
rule N( _:Method ( A:ProcList )) => N(A)
rule N( _:Method ( ) ) => .Set

// Variable Reference
rule N( =* X:NameVar ) => SetItem(X)

// Resolving brackets
rule N( { P:Proc } ) => N(P)

//----------------------
//--- Free Variables ---
//----------------------

// Nil, Ground, Unforgeable
rule FV(   Nil         ) => .Set
rule FV( _:Ground      ) => .Set
rule FV( _:Unforgeable ) => .Set

// NameVar
rule FV( X:NameVar ) => SetItem(X)

// Quote
rule FV( @ P:Proc  ) => FV(P)

// NameList
rule FV( X:Name , Y:Name  ) => FV(X) FV(Y)
rule FV( X:Name , Y:Names ) => FV(X) FV(Y)

// ProcList
rule FV( P:Proc , Q:Proc  ) => FV(P) FV(Q)
rule FV( P:Proc , Q:Procs ) => FV(P) FV(Q)

// Receives, Binds, Contract
// TODO: all receive rules are the same, just desugar to linear listen
rule FV( for( Y:NameList <- X:Chan    ) { P:Proc } ) => FV(X) ( FV(P) -Set FV(Y) )
rule FV( for( Y:NameList <- X:NameVar ) { P:Proc } ) => SetItem(X) ( FV(P) -Set FV(Y) )
rule FV( for(            <- X:Chan    ) { P:Proc } ) => FV(X) FV(P)
rule FV( for(            <- X:NameVar ) { P:Proc } ) => SetItem(X) FV(P)
rule FV( for( Y:NameList <= X:Name    ) { P:Proc } ) => FV( for(Y <- X){P} )
rule FV( for(            <= X:Name    ) { P:Proc } ) => FV( for(  <- X){P} )
rule FV( for( Y:NameList <= X:Name    ) { P:Proc } ) => FV( for(Y <- X){P} )
rule FV( for(            <= X:Name    ) { P:Proc } ) => FV( for(  <- X){P} )
rule FV( for( Y:NameList <= X:Name    ) { P:Proc } ) => FV( for(Y <- X){P} )
rule FV( for(            <= X:Name    ) { P:Proc } ) => FV( for(  <- X){P} )

rule FV( for( Y:NameList <- X:NameVar ; B:Lbind  ) { P:Proc } ) => SetItem(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <- X:Chan    ; B:Lbind  ) { P:Proc } ) => FV(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <- X:NameVar ; B:Lbinds ) { P:Proc } ) => SetItem(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <- X:Chan    ; B:Lbinds ) { P:Proc } ) => FV(X) ( FV( for(B){P} ) -Set FV(Y) )
/*
rule FV( for( Y:NameList <= X:NameVar ; B:Rbind  ) { P:Proc } ) => SetItem(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <= X:Chan    ; B:Rbind  ) { P:Proc } ) => FV(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <= X:NameVar ; B:Rbinds ) { P:Proc } ) => SetItem(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <= X:Chan    ; B:Rbinds ) { P:Proc } ) => FV(X) ( FV( for(B){P} ) -Set FV(Y) )

rule FV( for( Y:NameList <! X:NameVar ; B:Pbind  ) { P:Proc } ) => SetItem(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <! X:Chan    ; B:Pbind  ) { P:Proc } ) => FV(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <! X:NameVar ; B:Pbinds ) { P:Proc } ) => SetItem(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList <! X:Chan    ; B:Pbinds ) { P:Proc } ) => FV(X) ( FV( for(B){P} ) -Set FV(Y) )

rule FV( for( Y:NameList << X:NameVar ; B:Sbind  ) { P:Proc } ) => SetItem(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList << X:Chan    ; B:Sbind  ) { P:Proc } ) => FV(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList << X:NameVar ; B:Sbinds ) { P:Proc } ) => SetItem(X) ( FV( for(B){P} ) -Set FV(Y) )
rule FV( for( Y:NameList << X:Chan    ; B:Sbinds ) { P:Proc } ) => FV(X) ( FV( for(B){P} ) -Set FV(Y) )
*/
rule FV( contract X:Name ( Y:NameList ) = { P:Proc } ) => FV( for(Y <- X){P} )
rule FV( contract X:Name (  ) = { P:Proc } ) => FV( for(  <- X){P} )

// Send
rule FV( X:Name ! ( P:ProcList ) ) => FV(X) FV(P)
rule FV( X:Name !!( P:ProcList ) ) => FV(X) FV(P)

// Par
rule FV( P:Proc | Q:Proc ) => FV(P) FV(Q)

// Eval
rule FV( * X:Name ) => FV(X)

// RhoTuple
rule FV( tuple( P:ProcList ) ) => FV(P)
rule FV( ( ):RhoTuple ) => .Set

// RhoList
rule FV( [ P:ProcList ] ) => FV(P)
rule FV( [  ] ) => .Set

// RhoSet
rule FV( Set( P:ProcList ) ) => FV(P)
rule FV( Set(  ) ) => .Set

// RhoMap
rule FV( {  } ) => .Set
rule FV( { R:RhoKVPairs } ) => FV(R)
rule FV( P:Proc : Q:Proc  ) => FV(P) FV(Q)
rule FV( P:Proc : Q:Proc , R:RhoKVPairs ) => FV(P:Q) FV(R)
// New
rule FV( new X:NameList in { P:Proc } ) => FV(P) -Set FV(X)

// Expressions

// Conditionals

// Match

// Methods

// Variable Reference

// Bundles
rule N( bundle+{ P:Proc } ) => FV(P)
rule N( bundle-{ P:Proc } ) => FV(P)
rule N( bundle0{ P:Proc } ) => FV(P)
rule N( bundle { P:Proc } ) => FV(P) 

// Resolving brackets
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

rule RN( for( _:NameList <- X:Name ) { _:Proc } ) => SetItem(X)
rule RN( for( _:NameList <= X:Name ) { _:Proc } ) => SetItem(X)
rule RN( for( _:NameList <! X:Name ) { _:Proc } ) => SetItem(X)
rule RN( for( _:NameList << X:Name ) { _:Proc } ) => SetItem(X)

rule RN( for( _:NameList <- X:Name ; A:Lbind  ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameList <- X:Name ; A:Lbinds ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameList <= X:Name ; A:Rbind  ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameList <= X:Name ; A:Rbinds ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameList <! X:Name ; A:Pbind  ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameList <! X:Name ; A:Pbinds ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameList << X:Name ; A:Sbind  ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )
rule RN( for( _:NameList << X:Name ; A:Sbinds ){ P:Proc } ) => SetItem(X) RN( for( A ){ P:Proc } )

rule RN( _:Send ) => .Set

rule RN( P:Proc | Q:Proc ) => RN(P) RN(Q)

rule RN( * _:Name  ) => .Set

// Send Names
rule SN( { P:Proc } ) => SN(P)

rule SN( _:Receive )  => .Set

rule SN( X:Name ! ( _:ProcList ) ) => SetItem(X)

rule SN( P:Proc | Q:Proc ) => SN(P) SN(Q)

rule SN( * _:Name ) => .Set

endmodule
