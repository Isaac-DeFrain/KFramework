// Names and Variables for RHO CALCULUS with additional Ground terms

require "domains.k"
require "../grho.k"

module NAMEVAR-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Arguments
  syntax     Arg ::= Name
                   | Names
                   | Proc
                   | Procs
                   | RhoKVPair
                   | RhoKVPairs
                   | AnyBind
                   | AnyBinds
                   | MatchCase
                   | MatchCases
                   | MethodAndArgs

// Variable types
  syntax    Type ::= "name"
                   | "proc"

// Sets
  syntax     Set ::=  "FV(" Arg ")" [function] // free variables
                   | "FV-(" Arg ")" [function] // auxiliary for bound variables
                   |  "BV(" Arg ")" [function] // bound variables
                   |  "RV(" Arg ")" [function] // receive variables
                   |  "SV(" Arg ")" [function] // send variables
                   |   "V(" Arg ")" [function] // variables
                   | "Agg(" Set ")" [function] // aggregator
// For sets...
syntax     KItem ::= Arg ":" Type
                   | KItem "," KItem

endmodule


module NAMEVAR
  import NAMEVAR-SYNTAX

  configuration
    <T>
      <k> $PGM:Set </k>
    </T>
//    <T>
//      <k> Agg($PGM:Set) </k>
//    </T>

  syntax KResult ::= Ground | Eval | Set

// Aggregates common name and process variables 
// i.e. if x & *x are free, we combine them into (x,*x)
//  rule Agg( SetItem( X:NameVar : name ) SetItem( *X : proc ) S:Set ) => SetItem(X : name , *X : proc) Agg(S)
//  rule Agg( SetItem( X:ProcVar : proc ) SetItem( @X : name ) S:Set ) => SetItem(X : proc , @X : name) Agg(S)
//  rule Agg( S:Set ) => S [owise]

//-----------------
//--- Variables ---
//-----------------

// Ground Terms
  rule V( _:Ground  ) => .Set

// ProcVar
  rule V( X:ProcVar ) => SetItem(X)
//  rule V( X:ProcVar ) => SetItem(X : proc)

// Names
  rule V( X:NameVar ) => SetItem(X)
  rule V( X:NameVar ( _:Uri ) ) => SetItem(X)
  rule V( @ P:ProcVar ) => SetItem(@P) SetItem(P)
  rule V( @ P:Proc    ) => V(P) requires notBool isProcVar(P)
//  rule V( X:NameVar ) => SetItem(X : name)
//  rule V( X:NameVar ( _:Uri ) ) => SetItem(X : name)
//  rule V( @ P:ProcVar ) => SetItem(@P : name) SetItem(P : proc)
//  rule V( @ P:Proc    ) => V(P) requires notBool isProcVar(P)

  rule V( A:Name , B:Name  ) => V(A) V(B)
  rule V( A:Name , B:Names ) => V(A) V(B)

// Receives, Binds, Contracts
  rule V( for( B:Bind          ) { P:Proc } ) => V(B) V(P)
  rule V( for( B:Bind  _:Guard ) { P:Proc } ) => V(B) V(P)
  rule V( for( B:Binds         ) { P:Proc } ) => V(B) V(P)
  rule V( for( B:Binds _:Guard ) { P:Proc } ) => V(B) V(P)
  // single bind
  rule V( _:Names <- X:Name ) => V(X)
  rule V( _:Name  <- X:Name ) => V(X)
  rule V(         <- X:Name ) => V(X)
  rule V( _:Names <! X:Name ) => V(X)
  rule V( _:Name  <! X:Name ) => V(X)
  rule V(         <! X:Name ) => V(X)
  rule V( _:Names <= X:Name ) => V(X)
  rule V( _:Name  <= X:Name ) => V(X)
  rule V(         <= X:Name ) => V(X)
  // multiple binds
  rule V( A:Lbind ; B:Lbind  ) => V(A) V(B)
  rule V( A:Lbind ; B:Lbinds ) => V(A) V(B)
  rule V( A:Pbind ; B:Pbind  ) => V(A) V(B)
  rule V( A:Pbind ; B:Pbinds ) => V(A) V(B)
  rule V( A:Rbind ; B:Rbind  ) => V(A) V(B)
  rule V( A:Rbind ; B:Rbinds ) => V(A) V(B)

  rule V( contract X:Name ( Y:Names ) = { P:Proc } ) => V(Y<=X) V(P)
  rule V( contract X:Name ( Y:Name  ) = { P:Proc } ) => V(Y<=X) V(P)
  rule V( contract X:Name (         ) = { P:Proc } ) => V(X) V(P)

// Sends
  rule V( X:Name !  ( P:Procs ) ) => V(X) V(P)
  rule V( X:Name !  ( P:Proc  ) ) => V(X) V(P)
  rule V( X:Name !  (         ) ) => V(X)
  rule V( X:Name !! ( P:Procs ) ) => V(X) V(P)
  rule V( X:Name !! ( P:Proc  ) ) => V(X) V(P)
  rule V( X:Name !! (         ) ) => V(X)

// Par
  rule V( P:Proc | Q:Proc ) => V(P) V(Q)

// Eval
  rule V( * X:Name    ) => V(X) requires notBool isNameVar(X)
  rule V( * X:NameVar ) => SetItem(*X) SetItem(X)
//  rule V( * X:Name    ) => V(X) requires notBool isNameVar(X)
//  rule V( * X:NameVar ) => SetItem(*X : proc) SetItem(X : name)

// Procs
  rule V( P:Proc , Q:Proc  ) => V(P) V(Q)
  rule V( P:Proc , Q:Procs ) => V(P) V(Q)

// RhoTuple
  rule V( tuple( P:Procs ) ) => V(P)
  rule V( tuple( P:Proc  ) ) => V(P)
  rule V( ( ) ) => .Set

// RhoList
  rule V( [ P:Procs ] ) => V(P)
  rule V( [ P:Proc  ] ) => V(P)
  rule V( [ ] ) => .Set

// RhoSet
  rule V( Set( P:Procs ) ) => V(P)
  rule V( Set( P:Proc  ) ) => V(P)
  rule V( Set( ) ) => .Set

// RhoMap
  rule V( { } ) => .Set
  rule V( { R:RhoKVPair } ) => V(R)
  rule V( { R:RhoKVPair , S:RhoKVPair  } ) => V(R) V(S)
  rule V( { R:RhoKVPair , S:RhoKVPairs } ) => V(R) V(S)
  // KV pairs
  rule V( P:Proc : Q:Proc ) => V(P) V(Q)
  rule V( R:RhoKVPair , S:RhoKVPair  ) => V(R) V(S)
  rule V( R:RhoKVPair , S:RhoKVPairs ) => V(R) V(S)

// VarRef
  rule V( =  X:ProcVar ) => SetItem(X)
  rule V( =* X:NameVar ) => SetItem(X)
//  rule V( =  X:ProcVar ) => SetItem(X : proc)
//  rule V( =* X:NameVar ) => SetItem(X : name) // ???

// TODO
// Bundles
  rule V( bundle+{ P:Proc } ) => V(P)  // write-only => only send names available
  rule V( bundle-{ P:Proc } ) => V(P)  // read-only  => only receive names available
  rule V( bundle0{ P:Proc } ) => V(P)  // no read/write => no names available
  rule V( bundle { P:Proc } ) => V(P)  // read/write => both send & receive names available

// New
  rule V( new X:Name  in { P:Proc } ) => V(X) V(P)
  rule V( new X:Names in { P:Proc } ) => V(X) V(P)

// Arithmetic Expressions
  rule V( A:AExp * B:AExp ) => V(A) V(B)
  rule V( A:AExp / B:AExp ) => V(A) V(B)
  rule V( A:AExp + B:AExp ) => V(A) V(B)
  rule V( A:AExp - B:AExp ) => V(A) V(B)

// Boolean Expressions
  rule V( not B:BExp        ) => V(B)
  rule V( A:BExp and B:BExp ) => V(A) V(B)
  rule V( A:BExp or  B:BExp ) => V(A) V(B)
  rule V( A:AExp <=  B:AExp ) => V(A) V(B)

// Conditional
  rule V( if ( B:BExp ) P:Proc ) => V(B) V(P)
  rule V( A:IfThen else P:Proc ) => V(A) V(P)

// Match
  rule V( match P:Proc { M:MatchCase  } ) => V(P) V(M)
  rule V( match P:Proc { M:MatchCases } ) => V(P) V(M)
  // MatchCases
  rule V( P:Proc :=> Q:Proc        ) => V(P) V(Q)
  rule V( A:MatchCase B:MatchCase  ) => V(A) V(B)
  rule V( A:MatchCase B:MatchCases ) => V(A) V(B)

// Method
  rule V( P:Proc M:MethodAndArgs ) => V(P) V(M)
  rule V( . _:Method ( A:Procs ) ) => V(A)
  rule V( . _:Method ( A:Proc  ) ) => V(A)
  rule V( . _:Method ( ) ) => .Set

//----------------------
//--- Free Variables ---
//----------------------

  rule FV-( X:NameVar ) => FV(*X)
  rule FV-( A:Name , B:Name  ) => FV-(A) FV-(B)
  rule FV-( A:Name , B:Names ) => FV-(A) FV-(B)
  rule FV-( A:Arg ) => FV(A) [owise]

// Nil, Ground, Unforgeable
  rule FV( _:Ground ) => .Set

// NameVar
//  rule FV( X:NameVar ) => SetItem(X)
  rule FV( X:NameVar ) => SetItem(X : name)

// ProcVar
//  rule FV( X:ProcVar ) => SetItem(X)
  rule FV( X:ProcVar ) => SetItem(X : proc)

// Quote
//  rule FV( @ P:Proc    ) => FV(P) requires notBool isProcVar(P)
//  rule FV( @ P:ProcVar ) => SetItem(@P) SetItem(P)
  rule FV( @ P:Proc    ) => FV(P) requires notBool isProcVar(P)
  rule FV( @ P:ProcVar ) => SetItem(@P : name) SetItem(P : proc)

// Names
  rule FV( X:Name , Y:Name  ) => FV(X) FV(Y)
  rule FV( X:Name , Y:Names ) => FV(X) FV(Y)

// Procs
  rule FV( P:Proc , Q:Proc  ) => FV(P) FV(Q)
  rule FV( P:Proc , Q:Procs ) => FV(P) FV(Q)

// Receives, Binds, Contract
  rule FV( for( Y:Names <- X:Name ) { P:Proc } ) => FV(X) (FV(P) -Set FV-(Y))
  rule FV( for( Y:Name  <- X:Name ) { P:Proc } ) => FV(X) (FV(P) -Set FV-(Y))
  rule FV( for(         <- X:Name ) { P:Proc } ) => FV(X)  FV(P)
  rule FV( for( Y:Names <= X:Name ) { P:Proc } ) => FV(X) (FV(P) -Set FV-(Y))
  rule FV( for( Y:Name  <= X:Name ) { P:Proc } ) => FV(X) (FV(P) -Set FV-(Y))
  rule FV( for(         <= X:Name ) { P:Proc } ) => FV(X)  FV(P)
  rule FV( for( Y:Names <! X:Name ) { P:Proc } ) => FV(X) (FV(P) -Set FV-(Y))
  rule FV( for( Y:Name  <! X:Name ) { P:Proc } ) => FV(X) (FV(P) -Set FV-(Y))
  rule FV( for(         <! X:Name ) { P:Proc } ) => FV(X)  FV(P)

  rule FV( for( Y:Names <- X:Name ; B:Lbind  ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for( Y:Name  <- X:Name ; B:Lbind  ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for(         <- X:Name ; B:Lbind  ) { P:Proc } ) => FV(X)  FV(for(B){P})
  rule FV( for( Y:Names <- X:Name ; B:Lbinds ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for( Y:Name  <- X:Name ; B:Lbinds ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for(         <- X:Name ; B:Lbinds ) { P:Proc } ) => FV(X)  FV(for(B){P})
  rule FV( for( Y:Names <= X:Name ; B:Rbind  ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for( Y:Name  <= X:Name ; B:Rbind  ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for(         <= X:Name ; B:Rbind  ) { P:Proc } ) => FV(X)  FV(for(B){P})
  rule FV( for( Y:Names <= X:Name ; B:Rbinds ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for( Y:Name  <= X:Name ; B:Rbinds ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for(         <= X:Name ; B:Rbinds ) { P:Proc } ) => FV(X)  FV(for(B){P})
  rule FV( for( Y:Names <! X:Name ; B:Pbind  ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for( Y:Name  <! X:Name ; B:Pbind  ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for(         <! X:Name ; B:Pbind  ) { P:Proc } ) => FV(X)  FV(for(B){P})
  rule FV( for( Y:Names <! X:Name ; B:Pbinds ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for( Y:Name  <! X:Name ; B:Pbinds ) { P:Proc } ) => FV(X) (FV(for(B){P}) -Set FV-(Y))
  rule FV( for(         <! X:Name ; B:Pbinds ) { P:Proc } ) => FV(X)  FV(for(B){P})

  rule FV( contract X:Name ( Y:Names ) = { P:Proc } ) => FV( for(Y <= X){P} )
  rule FV( contract X:Name ( Y:Name  ) = { P:Proc } ) => FV( for(Y <= X){P} )
  rule FV( contract X:Name (         ) = { P:Proc } ) => FV( for(  <= X){P} )

// Send
  rule FV( X:Name ! ( P:Procs ) ) => FV(X) FV(P)
  rule FV( X:Name ! ( P:Proc  ) ) => FV(X) FV(P)
  rule FV( X:Name ! (         ) ) => FV(X)
  rule FV( X:Name !!( P:Procs ) ) => FV(X) FV(P)
  rule FV( X:Name !!( P:Proc  ) ) => FV(X) FV(P)
  rule FV( X:Name !!(         ) ) => FV(X)

// Par
  rule FV( P:Proc | Q:Proc ) => FV(P) FV(Q)

// Eval
//  rule FV( * X:Name    ) => FV(X) requires notBool isNameVar(X)
//  rule FV( * X:NameVar ) => SetItem(*X) SetItem(X)
  rule FV( * X:Name    ) => FV(X) requires notBool isNameVar(X)
  rule FV( * X:NameVar ) => SetItem(*X : proc) SetItem(X : name)

// RhoTuple
  rule FV( tuple( P:Procs ) ) => FV(P)
  rule FV( tuple( P:Proc  ) ) => FV(P)
  rule FV( ( ) ) => .Set

// RhoList
  rule FV( [ P:Procs ] ) => FV(P)
  rule FV( [ P:Proc  ] ) => FV(P)
  rule FV( [ ] ) => .Set

// RhoSet
  rule FV( Set( P:Procs ) ) => FV(P)
  rule FV( Set( P:Proc  ) ) => FV(P)
  rule FV( Set( ) ) => .Set

// RhoMap
  rule FV( { } ) => .Set
  rule FV( { R:RhoKVPair } ) => FV(R)
  rule FV( { R:RhoKVPair , S:RhoKVPair  } ) => FV(R) FV(S)
  rule FV( { R:RhoKVPair , S:RhoKVPairs } ) => FV(R) FV(S)
  // KV pairs
  rule FV( P:Proc : Q:Proc ) => FV(P) FV(Q)
  rule FV( R:RhoKVPair , S:RhoKVPair  ) => FV(R) FV(S)
  rule FV( R:RhoKVPair , S:RhoKVPairs ) => FV(R) FV(S)

// New
  rule FV( new X:Name  in { P:Proc } ) => FV(P) -Set FV-(X)
  rule FV( new X:Names in { P:Proc } ) => FV(P) -Set FV-(X)

// Arithmetic Expressions
  rule FV( A:AExp * B:AExp ) => FV(A) FV(B)
  rule FV( A:AExp / B:AExp ) => FV(A) FV(B)
  rule FV( A:AExp + B:AExp ) => FV(A) FV(B)
  rule FV( A:AExp - B:AExp ) => FV(A) FV(B)

// Boolean Expressions
  rule FV( not B:BExp        ) => FV(B)
  rule FV( A:BExp and B:BExp ) => FV(A) FV(B)
  rule FV( A:BExp or  B:BExp ) => FV(A) FV(B)
  rule FV( A:AExp <=  B:AExp ) => FV(A) FV(B)
// Conditionals

// Match

// Methods

// Variable Reference

// Bundles
rule FV( bundle+{ P:Proc } ) => FV(P) // ???
rule FV( bundle-{ P:Proc } ) => FV(P)
rule FV( bundle0{ P:Proc } ) => FV(P)
rule FV( bundle { P:Proc } ) => FV(P) 

/*
// Bound Name set
rule BV( { P:OrPat } ) => BV(P)
rule BV( P:Proc      ) => V(P) -Set FV(P)
rule BV( P:ProcPat   ) => V(P) -Set FV(P)

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
rule BV( P:ProcPat   ) => intersectSet( BV(P) , V(P) )


// Receive Names
rule RV( { P:Proc } ) => RV(P)

rule RV( for( _:NameList <- X:Name ) { _:Proc } ) => SetItem(X)
rule RV( for( _:NameList <= X:Name ) { _:Proc } ) => SetItem(X)
rule RV( for( _:NameList <! X:Name ) { _:Proc } ) => SetItem(X)

rule RV( for( _:NameList <- X:Name ; A:Lbind  ){ P:Proc } ) => SetItem(X) RV( for( A ){ P:Proc } )
rule RV( for( _:NameList <- X:Name ; A:Lbinds ){ P:Proc } ) => SetItem(X) RV( for( A ){ P:Proc } )
rule RV( for( _:NameList <= X:Name ; A:Rbind  ){ P:Proc } ) => SetItem(X) RV( for( A ){ P:Proc } )
rule RV( for( _:NameList <= X:Name ; A:Rbinds ){ P:Proc } ) => SetItem(X) RV( for( A ){ P:Proc } )
rule RV( for( _:NameList <! X:Name ; A:Pbind  ){ P:Proc } ) => SetItem(X) RV( for( A ){ P:Proc } )
rule RV( for( _:NameList <! X:Name ; A:Pbinds ){ P:Proc } ) => SetItem(X) RV( for( A ){ P:Proc } )

rule RV( _:Send ) => .Set

rule RV( P:Proc | Q:Proc ) => RV(P) RV(Q)

rule RV( * _:Name  ) => .Set

// Send Names
rule SV( { P:Proc } ) => SV(P)

rule SV( _:Receive )  => .Set

rule SV( X:Name ! ( _:ProcList ) ) => SetItem(X)

rule SV( P:Proc | Q:Proc ) => SV(P) SV(Q)

rule SV( * _:Name ) => .Set
*/
endmodule
