// Names and Variables for RHO CALCULUS with additional Ground terms

// TODO: how to handle BoundName & BoundProc

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
                   | ConcatExp
                   | InterpMaps

// Variable types
  syntax    Kind ::= "name" | "proc"

// Kind Sets
  syntax     Set ::= "FV("    Arg  ")" [function] // free variables
                   | "FV+("   Arg  ")" [function] // auxiliary for bound variables
                   | "BV("    Arg  ")" [function] // bound variables
                   | "RV("    Arg  ")" [function] // receive variables
                   | "RV+("   Arg  ")" [function] // auxiliary for bound variables
                   | "RN("    Arg  ")" [function] // receive names
                   | "SV("    Arg  ")" [function] // send variables
                   | "SV+("   Arg  ")" [function] // auxiliary for bound variables
                   | "SN("    Arg  ")" [function] // send names
                   | "V("     Arg  ")" [function] // variables
                   | "LV("    Arg  ")" [function] // listening variables
                   | "LV+("   Arg  ")" [function] // auxiliary for bound variables
                   | "ILV("   Arg  ")" [function] // indexed listening variables

// Unkind Sets
  syntax     Set ::= "#FV("   Arg  ")" [function] // free variables
                   | "#DV("   Arg  ")" [function] // declared variables
                   | "#BV("   Arg  ")" [function] // bound variables
                   | "#RV("   Arg  ")" [function] // receive variables
                   | "#RN("   Arg  ")" [function] // receive names
                   | "#SV("   Arg  ")" [function] // send variables
                   | "#SN("   Arg  ")" [function] // send names
                   | "#V("    Arg  ")" [function] // variables
                   | "#LV("   Arg  ")" [function] // listening variables
                   | "#ILV("  Arg  ")" [function] // indexed listening variables
                   | "#RN+("  Arg  ")" [function] // nested receive names

// For sets...
syntax     KItem ::= Arg
                   | Arg ":" Kind

endmodule


module NAMEVAR
  import NAMEVAR-SYNTAX

  syntax KResult ::= Set

//-----------------
//--- Variables ---
//-----------------
// Ground Terms
  rule  V( _:Ground    ) => .Set
  rule  V( B:BoundProc ) => SetItem(B : proc) // ???
  rule #V( _:Ground    ) => .Set
  rule #V( B:BoundProc ) => .Set

// ProcVar
  rule  V( X:ProcVar ) => SetItem(X : proc)
  rule #V( X:ProcVar ) => SetItem(X)

// Names
  // Primitive names
  rule  V( X:NameVar ) => SetItem(X : name)
  rule #V( X:NameVar ) => SetItem(X)

  rule  V( X:NameVar ( _:Uri ) ) => SetItem(X : name)
  rule #V( X:NameVar ( _:Uri ) ) => SetItem(X)

  rule  V( @P:BoundProc ) => SetItem(@P : name) SetItem(P : proc) // ???
  rule  V(  B:BoundName ) => SetItem( B : name) // ???
  rule #V(  B:BoundName ) => .Set // ???
    // can use @P as Name or P as Proc
  rule  V( @P:ProcVar   ) => SetItem(@P : name) SetItem(P : proc)
  rule #V( @P:ProcVar   ) => SetItem( P )

  rule  V( @P:Proc ) =>  V(P) requires notBool (isProcVar(P) orBool isBoundProc(P))
  rule #V( @P:Proc ) => #V(P) requires notBool isProcVar(P)

  rule  V( A:Name , B:Name  ) =>  V(A)  V(B)
  rule  V( A:Name , B:Names ) =>  V(A)  V(B)
  rule #V( A:Name , B:Name  ) => #V(A) #V(B)
  rule #V( A:Name , B:Names ) => #V(A) #V(B)

// Receives, Binds, Contracts
  // Guard variables should be contained in the listening variables, i.e. #FV(Guard) <=Set #BV(Rec)
  rule  V( for( B:Bind            ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:Bind  if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:Binds           ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:Binds if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule #V( for( B:Bind            ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:Bind  if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:Binds           ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:Binds if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  // single bind
  rule  V( Y:Names <- X:Name ) =>  V(X)  V(Y)
  rule  V( Y:Name  <- X:Name ) =>  V(X)  V(Y)
  rule  V(         <- X:Name ) =>  V(X)
  rule  V( Y:Names <! X:Name ) =>  V(X)  V(Y)
  rule  V( Y:Name  <! X:Name ) =>  V(X)  V(Y)
  rule  V(         <! X:Name ) =>  V(X)
  rule  V( Y:Names <= X:Name ) =>  V(X)  V(Y)
  rule  V( Y:Name  <= X:Name ) =>  V(X)  V(Y)
  rule  V(         <= X:Name ) =>  V(X)
  rule #V( Y:Names <- X:Name ) => #V(X) #V(Y)
  rule #V( Y:Name  <- X:Name ) => #V(X) #V(Y)
  rule #V(         <- X:Name ) => #V(X)
  rule #V( Y:Names <! X:Name ) => #V(X) #V(Y)
  rule #V( Y:Name  <! X:Name ) => #V(X) #V(Y)
  rule #V(         <! X:Name ) => #V(X)
  rule #V( Y:Names <= X:Name ) => #V(X) #V(Y)
  rule #V( Y:Name  <= X:Name ) => #V(X) #V(Y)
  rule #V(         <= X:Name ) => #V(X)
  // multiple binds
  rule  V( A:Lbind ; B:Lbind  ) =>  V(A)  V(B)
  rule  V( A:Lbind ; B:Lbinds ) =>  V(A)  V(B)
  rule  V( A:Pbind ; B:Pbind  ) =>  V(A)  V(B)
  rule  V( A:Pbind ; B:Pbinds ) =>  V(A)  V(B)
  rule  V( A:Rbind ; B:Rbind  ) =>  V(A)  V(B)
  rule  V( A:Rbind ; B:Rbinds ) =>  V(A)  V(B)
  rule #V( A:Lbind ; B:Lbind  ) => #V(A) #V(B)
  rule #V( A:Lbind ; B:Lbinds ) => #V(A) #V(B)
  rule #V( A:Pbind ; B:Pbind  ) => #V(A) #V(B)
  rule #V( A:Pbind ; B:Pbinds ) => #V(A) #V(B)
  rule #V( A:Rbind ; B:Rbind  ) => #V(A) #V(B)
  rule #V( A:Rbind ; B:Rbinds ) => #V(A) #V(B)
  // Contract
  rule  V( contract X:Name ( Y:Names ) = { P:Proc } ) =>  V(X)  (V(Y)  V(P))
  rule  V( contract X:Name ( Y:Name  ) = { P:Proc } ) =>  V(X)  (V(Y)  V(P))
  rule  V( contract X:Name (         ) = { P:Proc } ) =>  V(X)   V(P)
  rule #V( contract X:Name ( Y:Names ) = { P:Proc } ) => #V(X) (#V(Y) #V(P))
  rule #V( contract X:Name ( Y:Name  ) = { P:Proc } ) => #V(X) (#V(Y) #V(P))
  rule #V( contract X:Name (         ) = { P:Proc } ) => #V(X)  #V(P)

// Sends
  rule  V( X:Name !  ( P:Procs ) ) =>  V(X)  V(P)
  rule  V( X:Name !  ( P:Proc  ) ) =>  V(X)  V(P)
  rule  V( X:Name !  (         ) ) =>  V(X)
  rule  V( X:Name !! ( P:Procs ) ) =>  V(X)  V(P)
  rule  V( X:Name !! ( P:Proc  ) ) =>  V(X)  V(P)
  rule  V( X:Name !! (         ) ) =>  V(X)
  rule #V( X:Name !  ( P:Procs ) ) => #V(X) #V(P)
  rule #V( X:Name !  ( P:Proc  ) ) => #V(X) #V(P)
  rule #V( X:Name !  (         ) ) => #V(X)
  rule #V( X:Name !! ( P:Procs ) ) => #V(X) #V(P)
  rule #V( X:Name !! ( P:Proc  ) ) => #V(X) #V(P)
  rule #V( X:Name !! (         ) ) => #V(X)

// Par
  rule  V( P:Proc | Q:Proc ) =>  V(P)  V(Q) requires notBool isPar(P)
  rule #V( P:Proc | Q:Proc ) => #V(P) #V(Q) requires notBool isPar(P)

// Eval
  rule  V( *X:Name ) => V(X) requires notBool (isNameVar(X) orBool isBoundName(X))
  // can use *X as Proc or X as Name
  rule  V( *X:NameVar   ) => SetItem(*X : proc) SetItem(X : name)
  rule  V( *X:BoundName ) => SetItem(*X : proc) SetItem(X : name) // ???
  rule #V( *X:Name ) => #V(X) requires notBool (isNameVar(X) orBool isBoundName(X))
  rule #V( *X:NameVar   ) => SetItem(X)

// Procs
  rule  V( P:Proc , Q:Proc  ) =>  V(P)  V(Q)
  rule  V( P:Proc , Q:Procs ) =>  V(P)  V(Q)
  rule #V( P:Proc , Q:Proc  ) => #V(P) #V(Q)
  rule #V( P:Proc , Q:Procs ) => #V(P) #V(Q)

//Collections
  // RhoList
  rule  V( [ P:Procs ] ) =>  V(P)
  rule  V( [ P:Proc  ] ) =>  V(P)
  rule  V( [ ] ) => .Set
  rule #V( [ P:Procs ] ) => #V(P)
  rule #V( [ P:Proc  ] ) => #V(P)
  rule #V( [ ] ) => .Set
  // RhoMap
  rule  V( { } ) => .Set
  rule  V( { R:RhoKVPair } ) => V(R)
  rule  V( { R:RhoKVPair , S:RhoKVPair  } ) => V(R) V(S)
  rule  V( { R:RhoKVPair , S:RhoKVPairs } ) => V(R) V(S)
  rule #V( { } ) => .Set
  rule #V( { R:RhoKVPair } ) => #V(R)
  rule #V( { R:RhoKVPair , S:RhoKVPair  } ) => #V(R) #V(S)
  rule #V( { R:RhoKVPair , S:RhoKVPairs } ) => #V(R) #V(S)
    // KV pairs
  rule  V( P:Proc : Q:Proc ) => V(P) V(Q)
  rule  V( R:RhoKVPair , S:RhoKVPair  ) => V(R) V(S)
  rule  V( R:RhoKVPair , S:RhoKVPairs ) => V(R) V(S)
  rule #V( P:Proc : Q:Proc ) => #V(P) #V(Q)
  rule #V( R:RhoKVPair , S:RhoKVPair  ) => #V(R) #V(S)
  rule #V( R:RhoKVPair , S:RhoKVPairs ) => #V(R) #V(S)
  // RhoSet
  rule  V( Set( P:Procs ) ) =>  V(P)
  rule  V( Set( P:Proc  ) ) =>  V(P)
  rule  V( Set( ) ) => .Set
  rule #V( Set( P:Procs ) ) => #V(P)
  rule #V( Set( P:Proc  ) ) => #V(P)
  rule #V( Set( ) ) => .Set
  // RhoTuple
  rule  V( tuple( P:Procs ) ) =>  V(P)
  rule  V( tuple( P:Proc  ) ) =>  V(P)
//  rule  V( ( ) ) => .Set
  rule #V( tuple( P:Procs ) ) => #V(P)
  rule #V( tuple( P:Proc  ) ) => #V(P)
//  rule #V( ( ) ) => .Set

// Variable Reference
  rule  V( =  X:ProcVar ) => SetItem(X : proc)
  rule  V( =* X:NameVar ) => V(*X) // can use *X as Proc or X as Name
  rule #V( =  X:ProcVar ) => SetItem(X)
  rule #V( =* X:NameVar ) => SetItem(X)

// Bundles
  rule  V( bundle+{ P:Proc } ) =>  V(P)
  rule  V( bundle-{ P:Proc } ) =>  V(P)
  rule  V( bundle0{ P:Proc } ) =>  V(P)
  rule  V( bundle { P:Proc } ) =>  V(P)
  rule #V( bundle+{ P:Proc } ) => #V(P)
  rule #V( bundle-{ P:Proc } ) => #V(P)
  rule #V( bundle0{ P:Proc } ) => #V(P)
  rule #V( bundle { P:Proc } ) => #V(P)

// New
  rule  V( new X:Name  in { P:Proc } ) =>  V(X)  V(P)
  rule  V( new X:Names in { P:Proc } ) =>  V(X)  V(P)
  rule #V( new X:Name  in { P:Proc } ) => #V(X) #V(P)
  rule #V( new X:Names in { P:Proc } ) => #V(X) #V(P)

// Conditional
  rule  V( if ( B:BExp ) P:Proc ) =>  V(B)  V(P)
  rule  V( A:IfThen else P:Proc ) =>  V(A)  V(P)
  rule #V( if ( B:BExp ) P:Proc ) => #V(B) #V(P)
  rule #V( A:IfThen else P:Proc ) => #V(A) #V(P)

// Match
  rule  V( match { P:Proc } { M:MatchCase  } ) =>  V(P)  V(M)
  rule  V( match { P:Proc } { M:MatchCases } ) =>  V(P)  V(M)
  rule #V( match { P:Proc } { M:MatchCase  } ) => #V(P) #V(M)
  rule #V( match { P:Proc } { M:MatchCases } ) => #V(P) #V(M)
  // MatchCases
  rule  V( { P:Proc } |=> Q:Proc    ) =>  V(P)  V(Q)
  rule  V( A:MatchCase B:MatchCase  ) =>  V(A)  V(B)
  rule  V( A:MatchCase B:MatchCases ) =>  V(A)  V(B)
  rule #V( { P:Proc } |=> Q:Proc    ) => #V(P) #V(Q)
  rule #V( A:MatchCase B:MatchCase  ) => #V(A) #V(B)
  rule #V( A:MatchCase B:MatchCases ) => #V(A) #V(B)

// Method
  rule  V( P:Proc M:MethodAndArgs ) =>  V(P)  V(M)
  rule  V( . _:Method ( A:Procs ) ) =>  V(A)
  rule  V( . _:Method ( A:Proc  ) ) =>  V(A)
  rule  V( . _:Method ( ) ) => .Set
  rule #V( P:Proc M:MethodAndArgs ) => #V(P) #V(M)
  rule #V( . _:Method ( A:Procs ) ) => #V(A)
  rule #V( . _:Method ( A:Proc  ) ) => #V(A)
  rule #V( . _:Method ( ) ) => .Set

// Arithmetic Expressions
  rule  V( - A:AExp         ) => V(A)
  rule  V( A:AExp *  B:AExp ) => V(A) V(B)
  rule  V( A:AExp /  B:AExp ) => V(A) V(B)
  rule  V( A:AExp +  B:AExp ) => V(A) V(B)
  rule  V( A:AExp -  B:AExp ) => V(A) V(B)
  rule  V( A:AExp %  B:AExp ) => V(A) V(B)
  rule  V( A:StringOrVar B:ConcatExp ) => V(A) V(B)
  rule  V( ++ A:StringOrVar ) => V(A)
  rule  V( ++ A:StringOrVar B:ConcatExp  ) => V(A) V(B)
  rule  V( A:StringOrVar %% B:InterpMaps ) => V(A) V(B)
  rule  V( A:RhoMap %% B:InterpMaps ) => V(A) V(B)
  rule #V( - A:AExp         ) => #V(A)
  rule #V( A:AExp *  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp /  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp +  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp -  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp %  B:AExp ) => #V(A) #V(B)
  rule #V( A:StringOrVar B:ConcatExp ) => #V(A) #V(B)
  rule #V( ++ A:StringOrVar ) => #V(A)
  rule #V( ++ A:StringOrVar B:ConcatExp  ) => #V(A) #V(B)
  rule #V( A:StringOrVar %% B:InterpMaps ) => #V(A) #V(B)
  rule #V( A:RhoMap %% B:InterpMaps ) => #V(A) #V(B)

// Boolean Expressions
  rule  V( not B:BExp        ) =>  V(B)
  rule  V( A:BExp and B:BExp ) =>  V(A)  V(B)
  rule  V( A:BExp or  B:BExp ) =>  V(A)  V(B)
  rule  V( A:AExp <=  B:AExp ) =>  V(A)  V(B)
  rule  V( A:AExp <   B:AExp ) =>  V(A)  V(B)
  rule  V( A:AExp >=  B:AExp ) =>  V(A)  V(B)
  rule  V( A:AExp >   B:AExp ) =>  V(A)  V(B)
  rule  V( A:Proc ==  B:Proc ) =>  V(A)  V(B)
  rule  V( A:Proc !=  B:Proc ) =>  V(A)  V(B)
  rule  V( A:Name ==  B:Name ) =>  V(A)  V(B)
  rule  V( A:Name !=  B:Name ) =>  V(A)  V(B)
  rule  V( A:Proc matches B:Proc ) => V(A) V(B)
  rule #V( not B:BExp        ) => #V(B)
  rule #V( A:BExp and B:BExp ) => #V(A) #V(B)
  rule #V( A:BExp or  B:BExp ) => #V(A) #V(B)
  rule #V( A:AExp <=  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp <   B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp >=  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp >   B:AExp ) => #V(A) #V(B)
  rule #V( A:Proc ==  B:Proc ) => #V(A) #V(B)
  rule #V( A:Proc !=  B:Proc ) => #V(A) #V(B)
  rule #V( A:Name ==  B:Name ) => #V(A) #V(B)
  rule #V( A:Name !=  B:Name ) => #V(A) #V(B)
  rule #V( A:Proc matches B:Proc ) => #V(A) #V(B)

//----------------------
//--- Free Variables ---
//----------------------
// Auxiliary function for bindings in Receives, New, & Match
  rule FV+( X:NameVar ) => SetItem(X : name) SetItem(*X : proc)
  rule FV+( X:NameVar ( _:Uri ) ) => SetItem(X : name) SetItem(*X : proc)

  // Ground, Bound
  rule FV+( _:Ground    ) => .Set
  rule FV+( _:BoundName ) => .Set
  rule FV+( _:BoundProc ) => .Set

  // ProcVar
  rule FV+( X:ProcVar ) => SetItem(X : proc) SetItem(@X : name)

  // Quote
  rule FV+( @A:Proc ) => FV+(A)

  // Receives, Binds, Contract, Invocation
    // free variables of a Receive are the receive variables or free variables of the continuation that are not listening variables
  rule FV+( for( B:Lbind  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Lbinds ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Pbind  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Pbinds ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Rbind  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Rbinds ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
    // Guarded -- free variables of the Receive or free variables of the Guard or continuation that are not listening variables
  rule FV+( for( B:Lbind  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Lbinds if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Pbind  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Pbinds if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Rbind  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Rbinds if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
    // Contract -- same as Receive
  rule FV+( contract X:Name ( Y:Names ) = { P:Proc } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:Name ( Y:Name  ) = { P:Proc } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:Name (         ) = { P:Proc } ) => FV+(for(  <= X){P})
    // Invocation -- // ???
  rule FV+( invoke X:Name ( Y:Procs ) ) => FV+(X) FV+(Y)
  rule FV+( invoke X:Name ( Y:Proc  ) ) => FV+(X) FV+(Y)
  rule FV+( invoke X:Name (         ) ) => FV+(X)

  // Send
  rule FV+( A:Name !  ( B:Procs ) ) => FV+(A) FV+(B)
  rule FV+( A:Name !  ( B:Proc  ) ) => FV+(A) FV+(B)
  rule FV+( A:Name !  (         ) ) => FV+(A)
  rule FV+( A:Name !! ( B:Procs ) ) => FV+(A) FV+(B)
  rule FV+( A:Name !! ( B:Proc  ) ) => FV+(A) FV+(B)
  rule FV+( A:Name !! (         ) ) => FV+(A)

  // Par
  rule FV+( P:Proc | Q:Proc ) => FV+(P) FV+(Q) requires notBool isPar(P)

  // Eval
  rule FV+( *X:Name ) => FV+(X) requires notBool isNameVar(X)
    // can use *X as Proc or X as Name
  rule FV+( *X:NameVar ) => SetItem(*X : proc) SetItem(X : name)

  // Collections
    // RhoTuple
  rule FV+( tuple( P:Procs ) ) => FV+(P)
  rule FV+( tuple( P:Proc  ) ) => FV+(P)
//  rule FV+( ( ) ) => .Set
    // RhoList
  rule FV+( [ P:Procs ] ) => FV+(P)
  rule FV+( [ P:Proc  ] ) => FV+(P)
  rule FV+( [ ] ) => .Set
    // RhoSet
  rule FV+( Set( P:Procs ) ) => FV+(P)
  rule FV+( Set( P:Proc  ) ) => FV+(P)
  rule FV+( Set( ) ) => .Set
    // RhoMap
  rule FV+( { } ) => .Set
  rule FV+( { R:RhoKVPair } ) => FV+(R)
  rule FV+( { R:RhoKVPair , S:RhoKVPair  } ) => FV+(R) FV+(S)
  rule FV+( { R:RhoKVPair , S:RhoKVPairs } ) => FV+(R) FV+(S)
      // KV pairs
  rule FV+( P:Proc : Q:Proc ) => FV+(P) FV+(Q)
  rule FV+( R:RhoKVPair , S:RhoKVPair  ) => FV+(R) FV+(S)
  rule FV+( R:RhoKVPair , S:RhoKVPairs ) => FV+(R) FV+(S)

  // Variable Reference
  rule FV+( =  X:ProcVar ) => FV+(@X)
  rule FV+( =* X:NameVar ) => FV+(*X)

  // New
  rule FV+( new X:Name  in { P:Proc } ) => FV+(P) -Set FV+(X)
  rule FV+( new X:Names in { P:Proc } ) => FV+(P) -Set FV+(X)

  // Conditionals
  rule FV+( if ( B:BExp ) P:Proc ) => FV+(B) FV+(P)
  rule FV+( A:IfThen else P:Proc ) => FV+(A) FV+(P)

  // Match
  rule FV+( match { P:Proc } { M:MatchCase  } ) => FV+(P) FV+(M)
  rule FV+( match { P:Proc } { M:MatchCases } ) => FV+(P) FV+(M)
    // MatchCases -- free variables in to be matched Proc P are bound in resulting Proc Q ???
  rule FV+( { P:Proc } |=> Q:Proc    ) => FV+(Q) -Set FV+(P)
  rule FV+( A:MatchCase B:MatchCase  ) => FV+(A) FV+(B)
  rule FV+( A:MatchCase B:MatchCases ) => FV+(A) FV+(B)

  // Method
  rule FV+( P:Proc M:MethodAndArgs ) => FV+(P) FV+(M)
  rule FV+( . _:Method ( A:Procs ) ) => FV+(A)
  rule FV+( . _:Method ( A:Proc  ) ) => FV+(A)
  rule FV+( . _:Method (         ) ) => .Set

  // Bundles -- TODO: bindings?
  rule FV+( bundle+{ P:Proc } ) => RV+(P)  // write-only => only send names available -- receive variables are free?
  rule FV+( bundle-{ P:Proc } ) => SV+(P)  // read-only  => only receive names available -- send variables are free?
  rule FV+( bundle0{ P:Proc } ) => .Set   // no read/write => no names available
  rule FV+( bundle { P:Proc } ) => FV+(P)  // read/write => both send & receive names available

  // Arithmetic Expressions
  rule FV+( - A:AExp         ) => FV+(A)
  rule FV+( A:AExp *  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp /  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp +  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp -  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp %  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:StringOrVar B:ConcatExp ) => FV+(A) FV+(B)
  rule FV+( ++ A:StringOrVar ) => FV+(A)
  rule FV+( ++ A:StringOrVar B:ConcatExp  ) => FV+(A) FV+(B)
  rule FV+( A:StringOrVar %% B:InterpMaps ) => FV+(A) FV+(B)
  rule FV+( A:RhoMap      %% B:InterpMaps ) => FV+(A) FV+(B)

  // Boolean Expressions
  rule FV+( not A:BExp        ) => FV+(A)
  rule FV+( A:BExp and B:BExp ) => FV+(A) FV+(B)
  rule FV+( A:BExp or  B:BExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp <=  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp <   B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp >=  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp >   B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:Proc ==  B:Proc ) => FV+(A) FV+(B)
  rule FV+( A:Proc !=  B:Proc ) => FV+(A) FV+(B)
  rule FV+( A:Name ==  B:Name ) => FV+(A) FV+(B)
  rule FV+( A:Name !=  B:Name ) => FV+(A) FV+(B)
  rule FV+( A:Proc matches B:Proc ) => FV+(A) FV+(B)

  // Names
  rule FV+( A:Name , B:Name  ) => FV+(A) FV+(B)
  rule FV+( A:Name , B:Names ) => FV+(A) FV+(B)

  // Procs
  rule FV+( A:Proc , B:Proc  ) => FV+(A) FV+(B)
  rule FV+( A:Proc , B:Procs ) => FV+(A) FV+(B)

// Ground, Bound
  rule  FV( _:Ground    ) => .Set
  rule  FV( _:BoundName ) => .Set
  rule  FV( _:BoundProc ) => .Set
  rule #FV( _:Ground    ) => .Set
  rule #FV( _:BoundName ) => .Set
  rule #FV( _:BoundProc ) => .Set

// NameVar
  rule  FV( X:NameVar ) => SetItem(X : name)
  rule  FV( X:NameVar ( _:Uri ) ) => SetItem(X : name)
  rule #FV( X:NameVar ) => SetItem(X)
  rule #FV( X:NameVar ( _:Uri ) ) => SetItem(X)

// ProcVar
  rule  FV( X:ProcVar ) => SetItem(X : proc)
  rule #FV( X:ProcVar ) => SetItem(X)

// Quote
  rule  FV( @P:Proc ) =>  FV(P) requires notBool isProcVar(P)
  rule #FV( @P:Proc ) => #FV(P)
  // can use @P as Name or P as Proc
  rule  FV( @P:ProcVar ) => SetItem(@P : name) SetItem(P : proc)

// Receives, Binds, Contract, Invocation
  // free variables of a Receive are the receive variables or free variables of the continuation that are not listening variables
  rule  FV( for( B:Lbind  ) { P:Proc } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Lbinds ) { P:Proc } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Pbind  ) { P:Proc } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Pbinds ) { P:Proc } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Rbind  ) { P:Proc } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Rbinds ) { P:Proc } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule #FV( for( B:Lbind  ) { P:Proc } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Lbinds ) { P:Proc } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Pbind  ) { P:Proc } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Pbinds ) { P:Proc } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Rbind  ) { P:Proc } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Rbinds ) { P:Proc } ) => #RV(B) (#FV(P) -Set #LV(B))
  // Guarded -- free variables of the Receive or free variables of the Guard or continuation that are not listening variables
  rule  FV( for( B:Lbind  if G:BExp ) { P:Proc } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Lbinds if G:BExp ) { P:Proc } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Pbind  if G:BExp ) { P:Proc } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Pbinds if G:BExp ) { P:Proc } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Rbind  if G:BExp ) { P:Proc } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Rbinds if G:BExp ) { P:Proc } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule #FV( for( B:Lbind  if G:BExp ) { P:Proc } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Lbinds if G:BExp ) { P:Proc } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Pbind  if G:BExp ) { P:Proc } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Pbinds if G:BExp ) { P:Proc } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Rbind  if G:BExp ) { P:Proc } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Rbinds if G:BExp ) { P:Proc } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  // Contract -- same as Receive
  rule  FV( contract X:Name ( Y:Names ) = { P:Proc } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:Name ( Y:Name  ) = { P:Proc } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:Name (         ) = { P:Proc } ) =>  FV(for(  <= X){P})
  rule #FV( contract X:Name ( Y:Names ) = { P:Proc } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:Name ( Y:Name  ) = { P:Proc } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:Name (         ) = { P:Proc } ) => #FV(for(  <= X){P})
  // Invocation -- // ???
  rule  FV( invoke X:Name ( Y:Procs ) ) =>  FV(X)  FV(Y)
  rule  FV( invoke X:Name ( Y:Proc  ) ) =>  FV(X)  FV(Y)
  rule  FV( invoke X:Name (         ) ) =>  FV(X)
  rule #FV( invoke X:Name ( Y:Procs ) ) => #FV(X) #FV(Y)
  rule #FV( invoke X:Name ( Y:Proc  ) ) => #FV(X) #FV(Y)
  rule #FV( invoke X:Name (         ) ) => #FV(X)

// Send
  rule  FV( X:Name ! ( P:Procs ) ) =>  FV(X)  FV(P)
  rule  FV( X:Name ! ( P:Proc  ) ) =>  FV(X)  FV(P)
  rule  FV( X:Name ! (         ) ) =>  FV(X)
  rule  FV( X:Name !!( P:Procs ) ) =>  FV(X)  FV(P)
  rule  FV( X:Name !!( P:Proc  ) ) =>  FV(X)  FV(P)
  rule  FV( X:Name !!(         ) ) =>  FV(X)
  rule #FV( X:Name ! ( P:Procs ) ) => #FV(X) #FV(P)
  rule #FV( X:Name ! ( P:Proc  ) ) => #FV(X) #FV(P)
  rule #FV( X:Name ! (         ) ) => #FV(X)
  rule #FV( X:Name !!( P:Procs ) ) => #FV(X) #FV(P)
  rule #FV( X:Name !!( P:Proc  ) ) => #FV(X) #FV(P)
  rule #FV( X:Name !!(         ) ) => #FV(X)

// Par
  rule  FV( P:Proc | Q:Proc ) =>  FV(P)  FV(Q) requires notBool isPar(P)
  rule #FV( P:Proc | Q:Proc ) => #FV(P) #FV(Q) requires notBool isPar(P)

// Eval
  rule  FV( *X:Name ) => FV(X) requires notBool isNameVar(X)
  // can use *X as Proc or X as Name
  rule  FV( *X:NameVar ) => SetItem(*X : proc) SetItem(X : name)
  rule #FV( *X:Name    ) => #FV(X) requires notBool isNameVar(X)
  rule #FV( *X:NameVar ) => SetItem(X)

// Collections
  // RhoTuple
  rule  FV( tuple( P:Procs ) ) =>  FV(P)
  rule  FV( tuple( P:Proc  ) ) =>  FV(P)
//  rule  FV( ( ) ) => .Set
  rule #FV( tuple( P:Procs ) ) => #FV(P)
  rule #FV( tuple( P:Proc  ) ) => #FV(P)
//  rule #FV( ( ) ) => .Set
  // RhoList
  rule  FV( [ P:Procs ] ) =>  FV(P)
  rule  FV( [ P:Proc  ] ) =>  FV(P)
  rule  FV( [ ] ) => .Set
  rule #FV( [ P:Procs ] ) => #FV(P)
  rule #FV( [ P:Proc  ] ) => #FV(P)
  rule #FV( [ ] ) => .Set
  // RhoSet
  rule  FV( Set( P:Procs ) ) =>  FV(P)
  rule  FV( Set( P:Proc  ) ) =>  FV(P)
  rule  FV( Set( ) ) => .Set
  rule #FV( Set( P:Procs ) ) => #FV(P)
  rule #FV( Set( P:Proc  ) ) => #FV(P)
  rule #FV( Set( ) ) => .Set
  // RhoMap
  rule  FV( { } ) => .Set
  rule  FV( { R:RhoKVPair } ) => FV(R)
  rule  FV( { R:RhoKVPair , S:RhoKVPair  } ) => FV(R) FV(S)
  rule  FV( { R:RhoKVPair , S:RhoKVPairs } ) => FV(R) FV(S)
  rule #FV( { } ) => .Set
  rule #FV( { R:RhoKVPair } ) => #FV(R)
  rule #FV( { R:RhoKVPair , S:RhoKVPair  } ) => #FV(R) #FV(S)
  rule #FV( { R:RhoKVPair , S:RhoKVPairs } ) => #FV(R) #FV(S)
    // KV pairs
  rule  FV( P:Proc : Q:Proc ) => FV(P) FV(Q)
  rule  FV( R:RhoKVPair , S:RhoKVPair  ) => FV(R) FV(S)
  rule  FV( R:RhoKVPair , S:RhoKVPairs ) => FV(R) FV(S)
  rule #FV( P:Proc : Q:Proc ) => #FV(P) #FV(Q)
  rule #FV( R:RhoKVPair , S:RhoKVPair  ) => #FV(R) #FV(S)
  rule #FV( R:RhoKVPair , S:RhoKVPairs ) => #FV(R) #FV(S)

// Variable Reference -- TODO: binding?
  rule  FV( =  X:ProcVar ) => SetItem(X : proc)
  rule  FV( =* X:NameVar ) => FV(*X)
  rule #FV( =  X:ProcVar ) => SetItem(X)
  rule #FV( =* X:NameVar ) => #FV(X)

// New
  rule  FV( new X:Name  in { P:Proc } ) =>  FV(P) -Set FV+(X)
  rule  FV( new X:Names in { P:Proc } ) =>  FV(P) -Set FV+(X)
  rule #FV( new X:Name  in { P:Proc } ) => #FV(P) -Set #FV(X)
  rule #FV( new X:Names in { P:Proc } ) => #FV(P) -Set #FV(X)

// Conditionals
  rule  FV( if ( B:BExp ) P:Proc ) =>  FV(B)  FV(P)
  rule  FV( A:IfThen else P:Proc ) =>  FV(A)  FV(P)
  rule #FV( if ( B:BExp ) P:Proc ) => #FV(B) #FV(P)
  rule #FV( A:IfThen else P:Proc ) => #FV(A) #FV(P)

// Match
  rule  FV( match { P:Proc } { M:MatchCase  } ) =>  FV(P)  FV(M)
  rule  FV( match { P:Proc } { M:MatchCases } ) =>  FV(P)  FV(M)
  rule #FV( match { P:Proc } { M:MatchCase  } ) => #FV(P) #FV(M)
  rule #FV( match { P:Proc } { M:MatchCases } ) => #FV(P) #FV(M)
  // MatchCases -- free variables in to be matched Proc P are bound in resulting Proc Q ???
  rule  FV( { P:Proc } |=> Q:Proc    ) =>  FV(Q) -Set FV+(P) // must be empty for each MatchCase for Match to be closed, i.e. FV(Q) <=Set FV+(P)
  rule  FV( A:MatchCase B:MatchCase  ) =>  FV(A)  FV(B)
  rule  FV( A:MatchCase B:MatchCases ) =>  FV(A)  FV(B)
  rule #FV( { P:Proc } |=> Q:Proc    ) => #FV(Q) -Set #FV(P) // must be empty for each MatchCase for Match to be closed, i.e. #FV(Q) <=Set #FV(P)
  rule #FV( A:MatchCase B:MatchCase  ) => #FV(A) #FV(B)
  rule #FV( A:MatchCase B:MatchCases ) => #FV(A) #FV(B)

// Method
  rule  FV( P:Proc M:MethodAndArgs ) =>  FV(P)  FV(M)
  rule  FV( . _:Method ( A:Procs ) ) =>  FV(A)
  rule  FV( . _:Method ( A:Proc  ) ) =>  FV(A)
  rule  FV( . _:Method (         ) ) => .Set
  rule #FV( P:Proc M:MethodAndArgs ) => #FV(P) #FV(M)
  rule #FV( . _:Method ( A:Procs ) ) => #FV(A)
  rule #FV( . _:Method ( A:Proc  ) ) => #FV(A)
  rule #FV( . _:Method (         ) ) => .Set

// Bundles -- TODO: bindings?
  rule  FV( bundle+{ P:Proc } ) =>  RV(P)  // write-only => only send names available -- receive variables are free?
  rule  FV( bundle-{ P:Proc } ) =>  SV(P)  // read-only  => only receive names available -- send variables are free?
  rule  FV( bundle0{ P:Proc } ) => .Set   // no read/write => no names available
  rule  FV( bundle { P:Proc } ) =>  FV(P)  // read/write => both send & receive names available
  rule #FV( bundle+{ P:Proc } ) => #RV(P)
  rule #FV( bundle-{ P:Proc } ) => #SV(P)
  rule #FV( bundle0{ P:Proc } ) => .Set
  rule #FV( bundle { P:Proc } ) => #FV(P)

// Arithmetic Expressions
  rule  FV( - A:AExp         ) => FV(A)
  rule  FV( A:AExp *  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp /  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp +  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp -  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp %  B:AExp ) => FV(A) FV(B)
  rule  FV( A:StringOrVar B:ConcatExp ) => FV(A) FV(B)
  rule  FV( ++ A:StringOrVar ) => FV(A)
  rule  FV( ++ A:StringOrVar B:ConcatExp  ) => FV(A) FV(B)
  rule  FV( A:StringOrVar %% B:InterpMaps ) => FV(A) FV(B)
  rule  FV( A:RhoMap %% B:InterpMaps ) => FV(A) FV(B)
  rule #FV( - A:AExp         ) => #FV(A)
  rule #FV( A:AExp *  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp /  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp +  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp -  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp %  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:StringOrVar B:ConcatExp ) => #FV(A) #FV(B)
  rule #FV( ++ A:StringOrVar ) => #FV(A)
  rule #FV( ++ A:StringOrVar B:ConcatExp  ) => #FV(A) #FV(B)
  rule #FV( A:StringOrVar %% B:InterpMaps ) => #FV(A) #FV(B)
  rule #FV( A:RhoMap %% B:InterpMaps ) => #FV(A) #FV(B)

// Boolean Expressions
  rule  FV( not B:BExp        ) => FV(B)
  rule  FV( A:BExp and B:BExp ) => FV(A) FV(B)
  rule  FV( A:BExp or  B:BExp ) => FV(A) FV(B)
  rule  FV( A:AExp <=  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp <   B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp >=  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp >   B:AExp ) => FV(A) FV(B)
  rule  FV( A:Proc ==  B:Proc ) => FV(A) FV(B)
  rule  FV( A:Proc !=  B:Proc ) => FV(A) FV(B)
  rule  FV( A:Name ==  B:Name ) => FV(A) FV(B)
  rule  FV( A:Name !=  B:Name ) => FV(A) FV(B)
  rule  FV( A:Proc matches B:Proc ) => FV(A) FV(B)
  rule #FV( not B:BExp        ) => #FV(B)
  rule #FV( A:BExp and B:BExp ) => #FV(A) #FV(B)
  rule #FV( A:BExp or  B:BExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp <=  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp <   B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp >=  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp >   B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:Proc ==  B:Proc ) => #FV(A) #FV(B)
  rule #FV( A:Proc !=  B:Proc ) => #FV(A) #FV(B)
  rule #FV( A:Name ==  B:Name ) => #FV(A) #FV(B)
  rule #FV( A:Name !=  B:Name ) => #FV(A) #FV(B)
  rule #FV( A:Proc matches B:Proc ) => #FV(A) #FV(B)

// Names
  rule  FV( X:Name , Y:Name  ) =>  FV(X)  FV(Y)
  rule  FV( X:Name , Y:Names ) =>  FV(X)  FV(Y)
  rule #FV( X:Name , Y:Name  ) => #FV(X) #FV(Y)
  rule #FV( X:Name , Y:Names ) => #FV(X) #FV(Y)

// Procs
  rule  FV( P:Proc , Q:Proc  ) =>  FV(P)  FV(Q)
  rule  FV( P:Proc , Q:Procs ) =>  FV(P)  FV(Q)
  rule #FV( P:Proc , Q:Proc  ) => #FV(P) #FV(Q)
  rule #FV( P:Proc , Q:Procs ) => #FV(P) #FV(Q)

//-----------------------
//--- Bound Variables ---
//-----------------------
  rule  BV( P:Proc ) =>  V(P) -Set  FV(P)
  rule #BV( P:Proc ) => #V(P) -Set #FV(P)
  rule  BV( N:Name ) =>  V(N) -Set  FV(N)
  rule #BV( N:Name ) => #V(N) -Set #FV(N)

//---------------------------
//--- Listening Variables ---
//---------------------------
// Auxiliary function for bindings in Receives, New, & Match
  rule LV+( Y:Names <- _:Name ) => FV+(Y)
  rule LV+( Y:Name  <- _:Name ) => FV+(Y)
  rule LV+(         <- _:Name ) => .Set
  rule LV+( Y:Names <= _:Name ) => FV+(Y)
  rule LV+( Y:Name  <= _:Name ) => FV+(Y)
  rule LV+(         <= _:Name ) => .Set
  rule LV+( Y:Names <! _:Name ) => FV+(Y)
  rule LV+( Y:Name  <! _:Name ) => FV+(Y)
  rule LV+(         <! _:Name ) => .Set
  rule LV+( A:Lbind ; B:Lbind  ) => LV+(A) LV+(B)
  rule LV+( A:Lbind ; B:Lbinds ) => LV+(A) LV+(B)
  rule LV+( A:Pbind ; B:Pbind  ) => LV+(A) LV+(B)
  rule LV+( A:Pbind ; B:Pbinds ) => LV+(A) LV+(B)
  rule LV+( A:Rbind ; B:Rbind  ) => LV+(A) LV+(B)
  rule LV+( A:Rbind ; B:Rbinds ) => LV+(A) LV+(B)

// Variables being listened for by a Receive
  // unguarded
  rule  LV( for( B:Lbind  ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Lbinds ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Pbind  ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Pbinds ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Rbind  ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Rbinds ) { _:Proc } ) =>  LV(B)
  rule #LV( for( B:Lbind  ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Lbinds ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Pbind  ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Pbinds ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Rbind  ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Rbinds ) { _:Proc } ) => #LV(B)
  // guarded
  rule  LV( for( B:Lbind  _:Guard ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Lbinds _:Guard ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Pbind  _:Guard ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Pbinds _:Guard ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Rbind  _:Guard ) { _:Proc } ) =>  LV(B)
  rule  LV( for( B:Rbinds _:Guard ) { _:Proc } ) =>  LV(B)
  rule #LV( for( B:Lbind  _:Guard ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Lbinds _:Guard ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Pbind  _:Guard ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Pbinds _:Guard ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Rbind  _:Guard ) { _:Proc } ) => #LV(B)
  rule #LV( for( B:Rbinds _:Guard ) { _:Proc } ) => #LV(B)

// Binds -- variables being listened for
  // single
  rule  LV( Y:Names <- _:Name ) => FV(Y)
  rule  LV( Y:Name  <- _:Name ) => FV(Y)
  rule  LV(         <- _:Name ) => .Set
  rule  LV( Y:Names <= _:Name ) => FV(Y)
  rule  LV( Y:Name  <= _:Name ) => FV(Y)
  rule  LV(         <= _:Name ) => .Set
  rule  LV( Y:Names <! _:Name ) => FV(Y)
  rule  LV( Y:Name  <! _:Name ) => FV(Y)
  rule  LV(         <! _:Name ) => .Set
  rule #LV( Y:Names <- _:Name ) => #FV(Y)
  rule #LV( Y:Name  <- _:Name ) => #FV(Y)
  rule #LV(         <- _:Name ) => .Set
  rule #LV( Y:Names <= _:Name ) => #FV(Y)
  rule #LV( Y:Name  <= _:Name ) => #FV(Y)
  rule #LV(         <= _:Name ) => .Set
  rule #LV( Y:Names <! _:Name ) => #FV(Y)
  rule #LV( Y:Name  <! _:Name ) => #FV(Y)
  rule #LV(         <! _:Name ) => .Set
  // multiple
  rule  LV( A:Lbind ; B:Lbind  ) =>  LV(A)  LV(B)
  rule  LV( A:Lbind ; B:Lbind  ) =>  LV(A)  LV(B)
  rule  LV( A:Pbind ; B:Pbind  ) =>  LV(A)  LV(B)
  rule  LV( A:Pbind ; B:Pbind  ) =>  LV(A)  LV(B)
  rule  LV( A:Rbind ; B:Rbind  ) =>  LV(A)  LV(B)
  rule  LV( A:Rbind ; B:Rbind  ) =>  LV(A)  LV(B)
  rule #LV( A:Lbind ; B:Lbind  ) => #LV(A) #LV(B)
  rule #LV( A:Lbind ; B:Lbind  ) => #LV(A) #LV(B)
  rule #LV( A:Pbind ; B:Pbind  ) => #LV(A) #LV(B)
  rule #LV( A:Pbind ; B:Pbind  ) => #LV(A) #LV(B)
  rule #LV( A:Rbind ; B:Rbind  ) => #LV(A) #LV(B)
  rule #LV( A:Rbind ; B:Rbind  ) => #LV(A) #LV(B)

//---------------------
//--- Receive Names ---
//---------------------
// Excluded Proc
  rule  RN( A:Proc ) => .Set requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A) orBool isBundle(A))
  rule #RN( A:Proc ) => .Set requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A) orBool isBundle(A))

  // Receives -- free variables in channel
    // unguarded
  rule  RN( for( B:Lbind  ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Lbinds ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Pbind  ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Pbinds ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Rbind  ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Rbinds ) { _:Proc } ) =>  RN(B)
  rule #RN( for( B:Lbind  ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Lbinds ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Pbind  ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Pbinds ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Rbind  ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Rbinds ) { _:Proc } ) => #RN(B)
    // guarded
  rule  RN( for( B:Lbind  _:Guard ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Lbinds _:Guard ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Pbind  _:Guard ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Pbinds _:Guard ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Rbind  _:Guard ) { _:Proc } ) =>  RN(B)
  rule  RN( for( B:Rbinds _:Guard ) { _:Proc } ) =>  RN(B)
  rule #RN( for( B:Lbind  _:Guard ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Lbinds _:Guard ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Pbind  _:Guard ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Pbinds _:Guard ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Rbind  _:Guard ) { _:Proc } ) => #RN(B)
  rule #RN( for( B:Rbinds _:Guard ) { _:Proc } ) => #RN(B)

  // Binds
    // single Bind
  rule  RN( _:Names <- X:Name ) => SetItem(X : name)
  rule  RN( _:Name  <- X:Name ) => SetItem(X : name)
  rule  RN(         <- X:Name ) => SetItem(X : name)
  rule  RN( _:Names <= X:Name ) => SetItem(X : name)
  rule  RN( _:Name  <= X:Name ) => SetItem(X : name)
  rule  RN(         <= X:Name ) => SetItem(X : name)
  rule  RN( _:Names <! X:Name ) => SetItem(X : name)
  rule  RN( _:Name  <! X:Name ) => SetItem(X : name)
  rule  RN(         <! X:Name ) => SetItem(X : name)
  rule #RN( _:Names <- X:Name ) => SetItem(X)
  rule #RN( _:Name  <- X:Name ) => SetItem(X)
  rule #RN(         <- X:Name ) => SetItem(X)
  rule #RN( _:Names <= X:Name ) => SetItem(X)
  rule #RN( _:Name  <= X:Name ) => SetItem(X)
  rule #RN(         <= X:Name ) => SetItem(X)
  rule #RN( _:Names <! X:Name ) => SetItem(X)
  rule #RN( _:Name  <! X:Name ) => SetItem(X)
  rule #RN(         <! X:Name ) => SetItem(X)
    // multiple Binds
  rule  RN( A:Lbind ; B:Lbind  ) =>  RN(A)  RN(B)
  rule  RN( A:Lbind ; B:Lbinds ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind ; B:Rbind  ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind ; B:Rbinds ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind ; B:Pbind  ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind ; B:Pbinds ) =>  RN(A)  RN(B)
  rule #RN( A:Lbind ; B:Lbind  ) => #RN(A) #RN(B)
  rule #RN( A:Lbind ; B:Lbinds ) => #RN(A) #RN(B)
  rule #RN( A:Rbind ; B:Rbind  ) => #RN(A) #RN(B)
  rule #RN( A:Rbind ; B:Rbinds ) => #RN(A) #RN(B)
  rule #RN( A:Pbind ; B:Pbind  ) => #RN(A) #RN(B)
  rule #RN( A:Pbind ; B:Pbinds ) => #RN(A) #RN(B)

  // Par -- receive variables in each Proc
  rule  RN( A:Proc | B:Proc ) =>  RN(A)  RN(B) requires notBool isPar(A)
  rule #RN( A:Proc | B:Proc ) => #RN(A) #RN(B) requires notBool isPar(A)

// TODO: New & Bundle



//-------------------------
//--- Receive Variables ---
//-------------------------
// Auxiliary function for bound variables
  // Excluded Proc
  rule RV+( A:Proc ) => .Set requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A) orBool isBundle(A))

  // Receives -- free variables in channel
    // unguarded
  rule RV+( for( B:Lbind  ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Lbinds ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Pbind  ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Pbinds ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Rbind  ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Rbinds ) { _:Proc } ) => RV+(B)
    // guarded
  rule RV+( for( B:Lbind  _:Guard ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Lbinds _:Guard ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Pbind  _:Guard ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Pbinds _:Guard ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Rbind  _:Guard ) { _:Proc } ) => RV+(B)
  rule RV+( for( B:Rbinds _:Guard ) { _:Proc } ) => RV+(B)

  // Binds
    // single Bind
  rule RV+( _:Names <- X:Name ) => FV+(X)
  rule RV+( _:Name  <- X:Name ) => FV+(X)
  rule RV+(         <- X:Name ) => FV+(X)
  rule RV+( _:Names <= X:Name ) => FV+(X)
  rule RV+( _:Name  <= X:Name ) => FV+(X)
  rule RV+(         <= X:Name ) => FV+(X)
  rule RV+( _:Names <! X:Name ) => FV+(X)
  rule RV+( _:Name  <! X:Name ) => FV+(X)
  rule RV+(         <! X:Name ) => FV+(X)
    // multiple Binds
  rule RV+( A:Lbind ; B:Lbind  ) => RV+(A) RV+(B)
  rule RV+( A:Lbind ; B:Lbinds ) => RV+(A) RV+(B)
  rule RV+( A:Pbind ; B:Pbind  ) => RV+(A) RV+(B)
  rule RV+( A:Pbind ; B:Pbinds ) => RV+(A) RV+(B)
  rule RV+( A:Rbind ; B:Rbind  ) => RV+(A) RV+(B)
  rule RV+( A:Rbind ; B:Rbinds ) => RV+(A) RV+(B)

  // Par -- receive variables in each Proc
  rule RV+( A:Proc | B:Proc ) => RV+(A) RV+(B) requires notBool isPar(A)

  // TODO: New & Bundle


// Excluded Proc
  rule  RV( A:Proc ) => .Set requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A) orBool isBundle(A))
  rule #RV( A:Proc ) => .Set requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A) orBool isBundle(A))

// Receives -- free variables in channel
  // unguarded
  rule  RV( for( B:Lbind  ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Lbinds ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Pbind  ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Pbinds ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Rbind  ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Rbinds ) { _:Proc } ) =>  RV(B)
  rule #RV( for( B:Lbind  ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Lbinds ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Pbind  ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Pbinds ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Rbind  ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Rbinds ) { _:Proc } ) => #RV(B)
  // guarded
  rule  RV( for( B:Lbind  _:Guard ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Lbinds _:Guard ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Pbind  _:Guard ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Pbinds _:Guard ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Rbind  _:Guard ) { _:Proc } ) =>  RV(B)
  rule  RV( for( B:Rbinds _:Guard ) { _:Proc } ) =>  RV(B)
  rule #RV( for( B:Lbind  _:Guard ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Lbinds _:Guard ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Pbind  _:Guard ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Pbinds _:Guard ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Rbind  _:Guard ) { _:Proc } ) => #RV(B)
  rule #RV( for( B:Rbinds _:Guard ) { _:Proc } ) => #RV(B)

// Binds
  // single Bind
  rule  RV( _:Names <- X:Name ) =>  FV(X)
  rule  RV( _:Name  <- X:Name ) =>  FV(X)
  rule  RV(         <- X:Name ) =>  FV(X)
  rule  RV( _:Names <= X:Name ) =>  FV(X)
  rule  RV( _:Name  <= X:Name ) =>  FV(X)
  rule  RV(         <= X:Name ) =>  FV(X)
  rule  RV( _:Names <! X:Name ) =>  FV(X)
  rule  RV( _:Name  <! X:Name ) =>  FV(X)
  rule  RV(         <! X:Name ) =>  FV(X)
  rule #RV( _:Names <- X:Name ) => #FV(X)
  rule #RV( _:Name  <- X:Name ) => #FV(X)
  rule #RV(         <- X:Name ) => #FV(X)
  rule #RV( _:Names <= X:Name ) => #FV(X)
  rule #RV( _:Name  <= X:Name ) => #FV(X)
  rule #RV(         <= X:Name ) => #FV(X)
  rule #RV( _:Names <! X:Name ) => #FV(X)
  rule #RV( _:Name  <! X:Name ) => #FV(X)
  rule #RV(         <! X:Name ) => #FV(X)
  // multiple Binds
  rule  RV( A:Lbind ; B:Lbind  ) =>  RV(A)  RV(B)
  rule  RV( A:Lbind ; B:Lbinds ) =>  RV(A)  RV(B)
  rule  RV( A:Pbind ; B:Pbind  ) =>  RV(A)  RV(B)
  rule  RV( A:Pbind ; B:Pbinds ) =>  RV(A)  RV(B)
  rule  RV( A:Rbind ; B:Rbind  ) =>  RV(A)  RV(B)
  rule  RV( A:Rbind ; B:Rbinds ) =>  RV(A)  RV(B)
  rule #RV( A:Lbind ; B:Lbind  ) => #RV(A) #RV(B)
  rule #RV( A:Lbind ; B:Lbinds ) => #RV(A) #RV(B)
  rule #RV( A:Pbind ; B:Pbind  ) => #RV(A) #RV(B)
  rule #RV( A:Pbind ; B:Pbinds ) => #RV(A) #RV(B)
  rule #RV( A:Rbind ; B:Rbind  ) => #RV(A) #RV(B)
  rule #RV( A:Rbind ; B:Rbinds ) => #RV(A) #RV(B)

// Par -- receive variables in each Proc
  rule  RV( A:Proc | B:Proc ) =>  RV(A)  RV(B) requires notBool isPar(A)
  rule #RV( A:Proc | B:Proc ) => #RV(A) #RV(B) requires notBool isPar(A)

// New
  rule  RV( new _:Name  in { A:Proc } ) =>  RV(A)
  rule  RV( new _:Names in { A:Proc } ) =>  RV(A)
  rule #RV( new _:Name  in { A:Proc } ) => #RV(A)
  rule #RV( new _:Names in { A:Proc } ) => #RV(A)

// TODO: Bundle



// Send Names

//----------------------
//--- Send Variables ---
//----------------------
// Auxiliary function for bound variables
  // Excluded Proc
  rule SV+( A:Proc ) => .Set requires notBool (isNew(A) orBool isSend(A) orBool isPar(A) orBool isBundle(A))

  // Send
  rule SV+( A:Name !  ( _:Procs ) ) => FV+(A)
  rule SV+( A:Name !  ( _:Proc  ) ) => FV+(A)
  rule SV+( A:Name !  (         ) ) => FV+(A)
  rule SV+( A:Name !! ( _:Procs ) ) => FV+(A)
  rule SV+( A:Name !! ( _:Proc  ) ) => FV+(A)
  rule SV+( A:Name !! (         ) ) => FV+(A)

  // Par
  rule SV+( A:Proc | B:Proc ) => SV+(A) SV+(B) requires notBool isPar(A)

  // TODO: New & Bundle


// Excluded Proc
  rule  SV( A:Proc ) => .Set requires notBool (isNew(A) orBool isSend(A) orBool isPar(A) orBool isBundle(A))
  rule #SV( A:Proc ) => .Set requires notBool (isNew(A) orBool isSend(A) orBool isPar(A) orBool isBundle(A))

// Send
  rule  SV( A:Name !  ( _:Procs ) ) =>  FV(A)
  rule  SV( A:Name !  ( _:Proc  ) ) =>  FV(A)
  rule  SV( A:Name !  (         ) ) =>  FV(A)
  rule  SV( A:Name !! ( _:Procs ) ) =>  FV(A)
  rule  SV( A:Name !! ( _:Proc  ) ) =>  FV(A)
  rule  SV( A:Name !! (         ) ) =>  FV(A)
  rule #SV( A:Name !  ( _:Procs ) ) => #FV(A)
  rule #SV( A:Name !  ( _:Proc  ) ) => #FV(A)
  rule #SV( A:Name !  (         ) ) => #FV(A)
  rule #SV( A:Name !! ( _:Procs ) ) => #FV(A)
  rule #SV( A:Name !! ( _:Proc  ) ) => #FV(A)
  rule #SV( A:Name !! (         ) ) => #FV(A)

// Par
  rule  SV( A:Proc | B:Proc ) =>  SV(A)  SV(B) requires notBool isPar(A)
  rule #SV( A:Proc | B:Proc ) => #SV(A) #SV(B) requires notBool isPar(A)

// New
  rule  SV( new _:Name  in { A:Proc } ) =>  SV(A)
  rule  SV( new _:Names in { A:Proc } ) =>  SV(A)
  rule #SV( new _:Name  in { A:Proc } ) => #SV(A)
  rule #SV( new _:Names in { A:Proc } ) => #SV(A)

// TODO: Bundle



// Index listening variables in Binds



//--------------------------
//--- Declared Variables ---
//--------------------------
  rule #DV( new A:NameVar in { _:Proc } ) => SetItem(A)
  rule #DV( new A:NameVar , B:Name  in { P:Proc } ) => SetItem(A) #DV(new B in {P})
  rule #DV( new A:NameVar , B:Names in { P:Proc } ) => SetItem(A) #DV(new B in {P})
  rule #DV( new A:NameVar ( _:Uri ) in { _:Proc } ) => SetItem(A)
  rule #DV( new A:NameVar ( _:Uri ) , B:Name  in { P:Proc } ) => SetItem(A) #DV(new B in {P})
  rule #DV( new A:NameVar ( _:Uri ) , B:Names in { P:Proc } ) => SetItem(A) #DV(new B in {P})

  rule #DV( A:Proc | B:Proc ) => #DV(A) #DV(B) requires notBool isPar(A)

  rule #DV( A:Proc ) => .Set requires notBool (isPar(A) orBool isNew(A))

//----------------------------
//--- Nested Receive Names ---
//----------------------------
  rule #RN+( for( A:Lbind  ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Lbinds ){ _:Proc } ) => SetItem( #RN(A) )

  rule #RN+( A:Proc | B:Proc ) => #RN+(A) #RN+(B) requires notBool isPar(A)

  rule #RN+( A:Proc ) => .Set requires notBool (isReceive(A) orBool isPar(A))

endmodule