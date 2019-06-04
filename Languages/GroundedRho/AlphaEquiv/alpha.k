// De Bruijn Index & Alpha Equisubence for Grounded Rho Calculus
// Need to call #deBruijn(0;$PGM;.Map) at the beginning of program execution

/*
TODO:
 - how to handle listens with several names & joins? -- Mem values for several Names/Procs in #dBound
 - more tests for substitutions in continuations for listens on chan
 - create #mapify: function which computes the final deBruijn map of a Name
 - add remaining productions - MultiRecs, Conditional, Bundles, 
*/

require "../grho.k"
require "../Substitute/sub.k"

module ALPHA-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Top level Procs
  syntax         Proc ::= "#deBruijn(" Int ";" Proc  ";" Map ")" [function, poly(0,2)]
                        | "#dBound("   Int ";" Proc  ";" Map ")" [function, poly(0,2)]
                        | "new" Name  "in" "{" DBProc "}"        [function]
                        | "new" Names "in" "{" DBProc "}"        [function]

  // New name declarations
  syntax       DBProc ::= "#deBruijn(" Int ";" Name  ";" Proc ";" Map ")" [function]
                        | "#deBruijn(" Int ";" Names ";" Proc ";" Map ")" [function]

  syntax        Procs ::= "#deBruijn(" Int ";" Procs ";" Map ")" [function]
                        | "#dBound("   Int ";" Procs ";" Map ")" [function]

// Nested Procs
  syntax         Proc ::= "#deBruijn(" Int "," Int ";" Proc  ";" Map ")" [function, poly(0,3)]
                        | "#dBound("   Int "," Int ";" Proc  ";" Map ")" [function, poly(0,3)]

  syntax       DBProc ::= "#deBruijn(" Int "," Int ";" Name  ";" Proc ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" Names ";" Proc ";" Map ")" [function]

  syntax        Procs ::= "#deBruijn(" Int "," Int  ";" Procs ";" Map ")" [function]
                        | "#dBound("   Int "," Int  ";" Procs ";" Map ")" [function]

// Top level Names
  syntax         Name ::= "#deBruijn(" Int ";" Name  ";" Map ")" [function]
                        | "#dBound("   Int ";" Name  ";" Map ")" [function]

  syntax        Names ::= "#deBruijn(" Int ";" Names ";" Map ")" [function]
                        | "#dBound("   Int ";" Names ";" Map ")" [function]

// Nested Names
  syntax         Name ::= "#deBruijn(" Int "," Int ";" Name  ";" Map ")" [function]
                        | "#dBound("   Int "," Int ";" Name  ";" Map ")" [function]

  syntax        Names ::= "#deBruijn(" Int "," Int ";" Names ";" Map ")" [function]
                        | "#dBound("   Int "," Int ";" Names ";" Map ")" [function]

// Recursive functions
  // can Lbind, Pbind, Rbind be combined into a single Bind with [poly]???
  syntax        Lbind ::= "#dBound("   Int         ";;" Lbind  ";;" Map ")" [function]
                        | "#dBound("   Int "," Int ";;" Lbind  ";;" Map ")" [function]
  syntax       Lbinds ::= "#dBound("   Int         ";;" Lbinds ";;" Map ")" [function]
                        | "#dBound("   Int "," Int ";;" Lbinds ";;" Map ")" [function]
  syntax        Pbind ::= "#dBound("   Int         ";;" Pbind  ";;" Map ")" [function]
                        | "#dBound("   Int "," Int ";;" Pbind  ";;" Map ")" [function]
  syntax       Pbinds ::= "#dBound("   Int         ";;" Pbinds ";;" Map ")" [function]
                        | "#dBound("   Int "," Int ";;" Pbinds ";;" Map ")" [function]
  syntax        Rbind ::= "#dBound("   Int         ";;" Rbind  ";;" Map ")" [function]
                        | "#dBound("   Int "," Int ";;" Rbind  ";;" Map ")" [function]
  syntax       Rbinds ::= "#dBound("   Int         ";;" Rbinds ";;" Map ")" [function]
                        | "#dBound("   Int "," Int ";;" Rbinds ";;" Map ")" [function]
  syntax  GuardedBind ::= "#dBound("   Int         ";;" GuardedBind  ";;" Map ")" [function, poly(0,2)]
                        | "#dBound("   Int "," Int ";;" GuardedBind  ";;" Map ")" [function, poly(0,3)]
  syntax GuardedBinds ::= "#dBound("   Int         ";;" GuardedBinds ";;" Map ")" [function]
                        | "#dBound("   Int "," Int ";;" GuardedBinds ";;" Map ")" [function]

  syntax    RhoKVPair ::= "#deBruijn(" Int ";"         RhoKVPair  ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" RhoKVPair  ";" Map ")" [function]
  syntax   RhoKVPairs ::= "#deBruijn(" Int ";"         RhoKVPairs ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" RhoKVPairs ";" Map ")" [function]

  syntax    ConcatExp ::= "#dBconcat(" Int ";"         ConcatExp  ";" Map ")" [function]
                        | "#dBconcat(" Int "," Int ";" ConcatExp  ";" Map ")" [function]
  syntax   InterpMaps ::= "#dBinterp(" Int ";"         InterpMaps ";" Map ")" [function]
                        | "#dBinterp(" Int "," Int ";" InterpMaps ";" Map ")" [function]

// Top level Map updates
  syntax          Map ::= "#mapify(" Name ")"
                        | "#mapify(" Proc ")"
                        | "#mapify(" Int ";" Name  ";" Map ")" [function]
                        | "#mapify(" Int ";" Names ";" Map ")" [function]
                        | "#mapify(" Int ";" Proc  ";" Map ")" [function]
                        | "#mapify(" Int ";" Procs ";" Map ")" [function]

// Nested Map updates
  syntax          Map ::= "#mapify(" Int "," Int ";" Name  ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";" Names ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";" Proc  ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";" Procs ";" Map ")" [function]

// Alpha equisubence predicate
  syntax         Bool ::= Proc "#alpha" Proc [function]

endmodule

module ALPHA
  import ALPHA-SYNTAX
  import SUB

  syntax KResult ::= Name | Names | Proc | Procs | Bool

//----------------------------
//--- Top Level Constructs ---
//----------------------------

// New Name Declarations - update mem map
  rule #deBruijn( I:Int ; new M:NameVar in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new M:NameVar , N:Name in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new M:NameVar , N:Names in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new M:NameVar ( _:Uri ) in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new M:NameVar ( _:Uri ) , N:Name in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; new M:NameVar ( _:Uri ) , N:Names in { P:Proc } ; Mem:Map )
    => new boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
  
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  // shadow and update Mem for already declared names
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  // shadow and update Mem for already declared names
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int ; M:NameVar , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  // shadow and update Mem for already declared names
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  // shadow and update Mem for already declared names
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int ; M:NameVar , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  // shadow and update Mem for already declared names
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  // shadow and update Mem for already declared names
  rule new A:Name in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:NameVar , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int ; M:NameVar , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);M;P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int ; M:NameVar ( _:Uri ) , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I)) in { #deBruijn( I +Int 1 ; N ; #sub(boundN(I);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I) ) ) }
       requires M in keys(Mem)

// Ground & Bound Terms
  rule #deBruijn( _:Int ; A:Ground    ; _:Map ) => A
  rule #deBruijn( _:Int ; A:BoundName ; _:Map ) => A
  rule #deBruijn( _:Int ; A:BoundProc ; _:Map ) => A

// Parallel Composition
// Mem map propogates to both branchs
  rule #deBruijn( I:Int ; P:Proc | Q:Proc ; Mem:Map ) => #deBruijn(I;P;Mem) | #deBruijn(I +Int size(#FV(P));Q;Mem)

// Receives
  // listening variables become boundN(I) with the appropriate index and are guarded during De Bruijn indexing
  // SingleRec
    // linear
    // unguarded
      // no listening variables -- no binding variables so nothing changes
  rule #deBruijn( I:Int ; for(  <- X:Name ){ P:Proc } ; Mem:Map ) => for( <- #deBruijn(I;X;Mem) ){ #deBruijn(I +Int size(#BV(X));P;Mem) }
      // listening for NameVar
        // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
        // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #deBruijn( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I) <- #deBruijn(I +Int 1;X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundN(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I) ) ) }
      // listening for @ProcVar
        // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
        // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #deBruijn( I:Int ; for( @Y:ProcVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I) <- #deBruijn(I +Int 1;X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundP(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I) ) ) }
      // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #deBruijn( I:Int ; for( @Y:Proc <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I;Y;.Map) <- #deBruijn(I +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
      // several Name listens
  rule #deBruijn( I:Int ; for( Y:Names <- X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;Y;.Map) <- #deBruijn(I +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }

    // guarded
  rule #deBruijn( I:Int ; for( Y:NameVar <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I) <- #deBruijn(I +Int 1;X;Mem) if #sub(boundN(I);#sub(Mem;Y);B) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundN(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; for( @Y:ProcVar <- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I) <- #deBruijn(I +Int 1;X;Mem) if #sub(boundP(I);#sub(Mem;Y);G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 +Int size(#BV(G)) ; #sub(boundP(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I) ) ) }

  rule #deBruijn( I:Int ; for( @Y:Proc <- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I;Y;.Map) <- #deBruijn(I +Int size(#FV(Y));X;Mem) if #sub(#dBound(I;Y;.Map);Y;G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
       requires notBool isProcVar(Y)

  rule #deBruijn( I:Int ; for( Y:Names <- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;Y;.Map) <- #deBruijn(I +Int size(#FV(Y));X;Mem) if #sub(#dBound(I;Y;.Map);Y;G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }

  // repeated
    // unguarded
      // no listening variables -- no binding variables so nothing changes
  rule #deBruijn( I:Int ; for(  <= X:Name ){ P:Proc } ; Mem:Map ) => for( <= #deBruijn(I;X;Mem) ){ #deBruijn(I +Int size(#BV(X));P;Mem) }
      // listening for NameVar
        // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
        // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #deBruijn( I:Int ; for( Y:NameVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I) <= #deBruijn(I +Int 1;X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundN(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I) ) ) }
      // listening for @ProcVar
        // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
        // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #deBruijn( I:Int ; for( @Y:ProcVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I) <= #deBruijn(I +Int 1;X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundP(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I) ) ) }
      // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #deBruijn( I:Int ; for( @Y:Proc <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I;Y;.Map) <= #deBruijn(I +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
      // several Name listens
  rule #deBruijn( I:Int ; for( Y:Names <= X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;Y;.Map) <= #deBruijn(I +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }

    // guarded
  rule #deBruijn( I:Int ; for( Y:NameVar <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I) <= #deBruijn(I +Int 1;X;Mem) if #sub(boundN(I);#sub(Mem;Y);B) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundN(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; for( @Y:ProcVar <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I) <= #deBruijn(I +Int 1;X;Mem) if #sub(boundP(I);#sub(Mem;Y);G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 +Int size(#BV(G)) ; #sub(boundP(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I) ) ) }

  rule #deBruijn( I:Int ; for( @Y:Proc <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I;Y;.Map) <= #deBruijn(I +Int size(#FV(Y));X;Mem) if #sub(#dBound(I;Y;.Map);Y;G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
       requires notBool isProcVar(Y)

  rule #deBruijn( I:Int ; for( Y:Names <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;Y;.Map) <= #deBruijn(I +Int size(#FV(Y));X;Mem) if #sub(#dBound(I;Y;.Map);Y;G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }

  // peek
    // unguarded
      // no listening variables -- no binding variables so nothing changes
  rule #deBruijn( I:Int ; for(  <! X:Name ){ P:Proc } ; Mem:Map ) => for( <! #deBruijn(I;X;Mem) ){ #deBruijn(I +Int size(#BV(X));P;Mem) }
      // listening for NameVar
        // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
        // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #deBruijn( I:Int ; for( Y:NameVar <! X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I) <! #deBruijn(I +Int 1;X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundN(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I) ) ) }
      // listening for @ProcVar
        // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
        // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #deBruijn( I:Int ; for( @Y:ProcVar <! X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I) <! #deBruijn(I +Int 1;X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundP(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I) ) ) }
      // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #deBruijn( I:Int ; for( @Y:Proc <! X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I;Y;.Map) <! #deBruijn(I +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
      // several Name listens
  rule #deBruijn( I:Int ; for( Y:Names <! X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;Y;.Map) <! #deBruijn(I +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }

    // guarded
  rule #deBruijn( I:Int ; for( Y:NameVar <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I) <! #deBruijn(I +Int 1;X;Mem) if #sub(boundN(I);#sub(Mem;Y);B) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 ; #sub(boundN(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I) ) ) }

  rule #deBruijn( I:Int ; for( @Y:ProcVar <! X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I) <! #deBruijn(I +Int 1;X;Mem) if #sub(boundP(I);#sub(Mem;Y);G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int 1 +Int size(#BV(G)) ; #sub(boundP(I);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I) ) ) }

  rule #deBruijn( I:Int ; for( @Y:Proc <! X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I;Y;.Map) <! #deBruijn(I +Int size(#FV(Y));X;Mem) if #sub(#dBound(I;Y;.Map);Y;G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }
       requires notBool isProcVar(Y)

  rule #deBruijn( I:Int ; for( Y:Names <! X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;Y;.Map) <! #deBruijn(I +Int size(#FV(Y));X;Mem) if #sub(#dBound(I;Y;.Map);Y;G) ){ 
            #deBruijn( I +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I;Y;.Map) ) ) }

  // MultiRec
    // unguarded
  rule #deBruijn( I:Int ; for( A:Lbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;A;;.Map) ){ #deBruijn(I +Int size(#LV(A)) +Int size(#RV(A)) ;
                                             #sub( #dBound(I;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int ; for( A:Pbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;A;;.Map) ){ #deBruijn(I +Int size(#LV(A)) +Int size(#RV(A)) ;
                                             #sub( #dBound(I;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int ; for( A:Rbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;A;;.Map) ){ #deBruijn(I +Int size(#LV(A)) +Int size(#RV(A)) ;
                                             #sub( #dBound(I;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
    // guarded
  rule #deBruijn( I:Int ; for( A:Lbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;A if G;;.Map) ){ #deBruijn(I +Int size(#LV(A)) +Int size(#RV(A)) +Int size(#BV(G)) ;
                                             #sub( #dBound(I;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int ; for( A:Pbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;A if G;;.Map) ){ #deBruijn(I +Int size(#LV(A)) +Int size(#RV(A)) +Int size(#BV(G)) ;
                                             #sub( #dBound(I;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int ; for( A:Rbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;A if G;;.Map) ){ #deBruijn(I +Int size(#LV(A)) +Int size(#RV(A)) +Int size(#BV(G)) ;
                                             #sub( #dBound(I;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }

// Sends
// no free variables left once #deBruijn arrives at a Send -- map constant on channel and message
  // still need to index top level bound names, hence the addition of the number of bound variables in the channel to the index of the message(s)
  rule #deBruijn( I:Int ; X:Name !  ( P:Procs ) ; Mem:Map ) => #deBruijn(I;X;Mem) !  ( #deBruijn(I +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int ; X:Name !  ( P:Proc  ) ; Mem:Map ) => #deBruijn(I;X;Mem) !  ( #deBruijn(I +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int ; X:Name !  (         ) ; Mem:Map ) => #deBruijn(I;X;Mem) !  ( )
  rule #deBruijn( I:Int ; X:Name !! ( P:Proc  ) ; Mem:Map ) => #deBruijn(I;X;Mem) !! ( #deBruijn(I +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int ; X:Name !! ( P:Procs ) ; Mem:Map ) => #deBruijn(I;X;Mem) !! ( #deBruijn(I +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int ; X:Name !! (         ) ; Mem:Map ) => #deBruijn(I;X;Mem) !! ( )

// Esubs -- just goes inside
  rule #deBruijn( I:Int ; *X:Name ; Mem:Map ) => * #deBruijn(I;X;Mem)

// Variables
  // NameVars
    // nothing happens if NameVar is free/fresh w.r.t. Mem
    // if NameVar is bound w.r.t. Mem (i.e. is a key), replace it with the corresponding value
    // #sub(Map;Name) takes care of both situations
  rule #deBruijn( _:Int ; N:NameVar ; Mem:Map ) => #sub(Mem;N)
  rule #deBruijn( _:Int ; N:NameVar ( _:Uri ) ; Mem:Map ) => #sub(Mem;N)

  // ProcVar
    // nothing happens if ProcVar is free/fresh w.r.t. Mem
    // if ProcVar is bound w.r.t. Mem (i.e. is a key), replace it with the corresponding value
  rule #deBruijn( _:Int ; P:ProcVar ; Mem:Map ) => #sub(Mem;P) requires P in keys(Mem)

// Collections
  // RhoList
  rule #deBruijn( _:Int ; [ ] ; _:Map ) => [ ]
  rule #deBruijn( I:Int ; [ P:Proc  ] ; Mem:Map ) => [ #deBruijn(I;P;Mem) ]
  rule #deBruijn( I:Int ; [ P:Procs ] ; Mem:Map ) => [ #deBruijn(I;P;Mem) ]

  // RhoMap
  rule #deBruijn( _:Int ; { } ; _:Map ) => { }
  rule #deBruijn( I:Int ; {  KV:RhoKVPair  } ; Mem:Map ) => { #deBruijn(I;KV ;Mem) }
  rule #deBruijn( I:Int ; { KVs:RhoKVPairs } ; Mem:Map ) => { #deBruijn(I;KVs;Mem) }
    // KVPairs
  rule #deBruijn( I:Int ;  A:Proc : B:Proc ; Mem:Map ) => #deBruijn(I;A;Mem) : #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ;  A:RhoKVPair , B:RhoKVPair  ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ;  A:RhoKVPair , B:RhoKVPairs ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)

  // RhoSet
  rule #deBruijn( _:Int ; Set( ) ; _:Map ) => Set( )
  rule #deBruijn( I:Int ; Set( P:Proc  ) ; Mem:Map ) => Set( #deBruijn(I;P;Mem) )
  rule #deBruijn( I:Int ; Set( P:Procs ) ; Mem:Map ) => Set( #deBruijn(I;P;Mem) )

  // RhoTuple
//  rule #deBruijn( _:Int ; ( ) ; _:Map ) => ( )
  rule #deBruijn( I:Int ;      ( P:Proc ,) ; Mem:Map ) =>      ( #deBruijn(I;P;Mem) ,)
  rule #deBruijn( I:Int ; tuple( P:Procs ) ; Mem:Map ) => tuple( #deBruijn(I;P;Mem)  )

// Quotes -- just goes inside (just like eval)
  rule #deBruijn( I:Int ; @P:Proc ; Mem:Map ) => @ #deBruijn(I;P;Mem)

// Expressions
  // Arithmetic Exps
  rule #deBruijn( I:Int ; - A:AExp ; Mem:Map ) => - #deBruijn(I;A;Mem)
  rule #deBruijn( I:Int ; A:AExp *  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) *  #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:AExp /  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) /  #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:AExp +  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) +  #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:AExp -  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) -  #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:AExp %  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) %  #deBruijn(I +Int size(#BV(A));B;Mem)

  // String Expressions
  rule #deBruijn( I:Int ; A:StringOrVar B:ConcatExp ; Mem:Map ) => #deBruijn(I;A;Mem) #dBconcat(I;B;Mem)
  rule #dBconcat( I:Int ; ++ A:StringOrVar ; Mem:Map ) => ++ #deBruijn(I;A;Mem)
  rule #dBconcat( I:Int ; ++ A:StringOrVar B:ConcatExp  ; Mem:Map ) => ++ #deBruijn(I;A;Mem) #dBconcat(I;B;Mem)
  rule #deBruijn( I:Int ; A:StringOrVar %% B:InterpMaps ; Mem:Map ) => #deBruijn(I;A;Mem) %% #dBinterp(I;B;Mem)
  rule #dBinterp( I:Int ; A:RhoMap      %% B:InterpMaps ; Mem:Map ) => #deBruijn(I;A;Mem) %% #dBinterp(I +Int size(#BV(A));B;Mem)

  // Boolean Exps
  rule #deBruijn( I:Int ; not A:BExp ; Mem:Map ) => not #deBruijn(I;A;Mem)
  rule #deBruijn( I:Int ; A:BExp and B:BExp ; Mem:Map ) => #deBruijn(I;A;Mem) and #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:BExp or  B:BExp ; Mem:Map ) => #deBruijn(I;A;Mem) or  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp <=  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) <=  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp <   B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) <   #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp >=  B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) >=  #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:AExp >   B:AExp ; Mem:Map ) => #deBruijn(I;A;Mem) >   #deBruijn(I;B;Mem)
  rule #deBruijn( I:Int ; A:Name ==  B:Name ; Mem:Map ) => #deBruijn(I;A;Mem) ==  #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:Name !=  B:Name ; Mem:Map ) => #deBruijn(I;A;Mem) !=  #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:Proc ==  B:Proc ; Mem:Map ) => #deBruijn(I;A;Mem) ==  #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:Proc !=  B:Proc ; Mem:Map ) => #deBruijn(I;A;Mem) !=  #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:Proc matches B:Proc ; Mem:Map ) => #deBruijn(I;A;Mem) matches #deBruijn(I +Int size(#BV(A));B;Mem)

// TODO: Other productions...

// Several Names
  // Lists of to-be-bound Names will only appear in listens (the Name declarations in New are dealt with separately)...
  // need to make the appropriate substitutions in the continuation too...
  // want to do something like 
  rule #deBruijn( I:Int ; A:Name , B:Name  ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:Name , B:Names ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)

// Several Procs
  // Lists of to-be-bound Procs appear in Collections and Sends...
  // want to do something like
  rule #deBruijn( I:Int ; A:Proc , B:Proc  ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ; A:Proc , B:Procs ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)

//-------------------------
//--- Nested Constructs ---
//-------------------------
// New Name Declarations - update mem map
  rule #deBruijn( I:Int , J:Int ; new M:NameVar in { P:Proc } ; Mem:Map )
    => new boundN(I,J) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
  rule #deBruijn( I:Int , J:Int ; new M:NameVar , N:Name in { P:Proc } ; Mem:Map )
    => new boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
  rule #deBruijn( I:Int , J:Int ; new M:NameVar , N:Names in { P:Proc } ; Mem:Map )
    => new boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
  rule #deBruijn( I:Int , J:Int ; new M:NameVar ( _:Uri ) in { P:Proc } ; Mem:Map )
    => new boundN(I,J) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
  rule #deBruijn( I:Int , J:Int ; new M:NameVar ( _:Uri ) , N:Name in { P:Proc } ; Mem:Map )
    => new boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
  rule #deBruijn( I:Int , J:Int ; new M:NameVar ( _:Uri ) , N:Names in { P:Proc } ; Mem:Map )
    => new boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
  
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) , N:Name ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Name in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) , N:Names ; P:Proc ; Mem:Map ) } 
    => new A , boundN(I,J) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) , N:Name ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);M;P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires notBool (M in keys(Mem))
  rule new A:Names in { #deBruijn( I:Int , J:Int ; M:NameVar ( _:Uri ) , N:Names ; P:Proc ; Mem:Map ) } 
    => new #append(A ; boundN(I,J)) in { #deBruijn( I,J +Int 1 ; N ; #sub(boundN(I,J);#sub(Mem;M);P) ; updateMap( Mem , M |-> boundN(I,J) ) ) }
       requires M in keys(Mem)

// Ground & bound terms
  rule #deBruijn( _:Int , _:Int ; A:Ground    ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundName ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundProc ; _:Map ) => A

// Parallel Composition
// Mem map propogates to both branchs
  rule #deBruijn( I:Int , J:Int ; P:Proc | Q:Proc ; Mem:Map ) => #deBruijn(I,J;P;Mem) | #deBruijn(I,J;Q;Mem)

// Receives
  // listening variables become boundN(I) with the appropriate index and are guarded during De Bruijn indexing
  // SingleRec
    // linear
    // unguarded
      // no listening variables -- no binding variables so nothing changes
  rule #deBruijn( I:Int , J:Int ; for(  <- X:Name ){ P:Proc } ; Mem:Map ) => for( <- #deBruijn(I,J;X;Mem) ){ #deBruijn(I,J +Int size(#BV(X));P;Mem) }
      // listening for NameVar
        // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
        // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #deBruijn( I:Int , J:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I,J) <- #deBruijn(I,J +Int 1;X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundN(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I,J) ) ) }
      // listening for @ProcVar
        // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
        // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #deBruijn( I:Int , J:Int ; for( @Y:ProcVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I,J) <- #deBruijn(I,J +Int 1;X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundP(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I,J) ) ) }
      // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #deBruijn( I:Int , J:Int ; for( @Y:Proc <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I,J;Y;.Map) <- #deBruijn(I,J +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
      // several Name listens
  rule #deBruijn( I:Int , J:Int ; for( Y:Names <- X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;Y;.Map) <- #deBruijn(I,J +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }

    // guarded
  rule #deBruijn( I:Int , J:Int ; for( Y:NameVar <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I,J) <- #deBruijn(I,J +Int 1;X;Mem) if #sub(boundN(I,J);#sub(Mem;Y);B) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundN(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I,J) ) ) }

  rule #deBruijn( I:Int , J:Int ; for( @Y:ProcVar <- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I,J) <- #deBruijn(I,J +Int 1;X;Mem) if #sub(boundP(I,J);#sub(Mem;Y);G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 +Int size(#BV(G)) ; #sub(boundP(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I,J) ) ) }

  rule #deBruijn( I:Int , J:Int ; for( @Y:Proc <- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I,J;Y;.Map) <- #deBruijn(I,J +Int size(#FV(Y));X;Mem) if #sub(#dBound(I,J;Y;.Map);Y;G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
       requires notBool isProcVar(Y)

  rule #deBruijn( I:Int , J:Int ; for( Y:Names <- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;Y;.Map) <- #deBruijn(I,J +Int size(#FV(Y));X;Mem) if #sub(#dBound(I,J;Y;.Map);Y;G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }

  // repeated
    // unguarded
      // no listening variables -- no binding variables so nothing changes
  rule #deBruijn( I:Int , J:Int ; for(  <= X:Name ){ P:Proc } ; Mem:Map ) => for( <= #deBruijn(I,J;X;Mem) ){ #deBruijn(I,J +Int size(#BV(X));P;Mem) }
      // listening for NameVar
        // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
        // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #deBruijn( I:Int , J:Int ; for( Y:NameVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I,J) <= #deBruijn(I,J +Int 1;X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundN(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I,J) ) ) }
      // listening for @ProcVar
        // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
        // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #deBruijn( I:Int , J:Int ; for( @Y:ProcVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I,J) <= #deBruijn(I,J +Int 1;X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundP(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I,J) ) ) }
      // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #deBruijn( I:Int , J:Int ; for( @Y:Proc <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I,J;Y;.Map) <= #deBruijn(I,J +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
      // several Name listens
  rule #deBruijn( I:Int , J:Int ; for( Y:Names <= X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;Y;.Map) <= #deBruijn(I,J +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }

    // guarded
  rule #deBruijn( I:Int , J:Int ; for( Y:NameVar <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I,J) <= #deBruijn(I,J +Int 1;X;Mem) if #sub(boundN(I,J);#sub(Mem;Y);B) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundN(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I,J) ) ) }

  rule #deBruijn( I:Int , J:Int ; for( @Y:ProcVar <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I,J) <= #deBruijn(I,J +Int 1;X;Mem) if #sub(boundP(I,J);#sub(Mem;Y);G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 +Int size(#BV(G)) ; #sub(boundP(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I,J) ) ) }

  rule #deBruijn( I:Int , J:Int ; for( @Y:Proc <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I,J;Y;.Map) <= #deBruijn(I,J +Int size(#FV(Y));X;Mem) if #sub(#dBound(I,J;Y;.Map);Y;G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
       requires notBool isProcVar(Y)

  rule #deBruijn( I:Int , J:Int ; for( Y:Names <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;Y;.Map) <= #deBruijn(I,J +Int size(#FV(Y));X;Mem) if #sub(#dBound(I,J;Y;.Map);Y;G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }

  // peek
    // unguarded
      // no listening variables -- no binding variables so nothing changes
  rule #deBruijn( I:Int , J:Int ; for(  <! X:Name ){ P:Proc } ; Mem:Map ) => for( <! #deBruijn(I,J;X;Mem) ){ #deBruijn(I,J +Int size(#BV(X));P;Mem) }
      // listening for NameVar
        // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
        // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #deBruijn( I:Int , J:Int ; for( Y:NameVar <! X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I,J) <! #deBruijn(I,J +Int 1;X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundN(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I,J) ) ) }
      // listening for @ProcVar
        // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
        // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #deBruijn( I:Int , J:Int ; for( @Y:ProcVar <! X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I,J) <! #deBruijn(I,J +Int 1;X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundP(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I,J) ) ) }
      // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #deBruijn( I:Int , J:Int ; for( @Y:Proc <! X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I,J;Y;.Map) <! #deBruijn(I,J +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
      // several Name listens
  rule #deBruijn( I:Int , J:Int ; for( Y:Names <! X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;Y;.Map) <! #deBruijn(I,J +Int size(#FV(Y));X;Mem) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }

    // guarded
  rule #deBruijn( I:Int , J:Int ; for( Y:NameVar <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I,J) <! #deBruijn(I,J +Int 1;X;Mem) if #sub(boundN(I,J);#sub(Mem;Y);B) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 ; #sub(boundN(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I,J) ) ) }

  rule #deBruijn( I:Int , J:Int ; for( @Y:ProcVar <! X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I,J) <! #deBruijn(I,J +Int 1;X;Mem) if #sub(boundP(I,J);#sub(Mem;Y);G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int 1 +Int size(#BV(G)) ; #sub(boundP(I,J);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I,J) ) ) }

  rule #deBruijn( I:Int , J:Int ; for( @Y:Proc <! X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I,J;Y;.Map) <! #deBruijn(I,J +Int size(#FV(Y));X;Mem) if #sub(#dBound(I,J;Y;.Map);Y;G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }
       requires notBool isProcVar(Y)

  rule #deBruijn( I:Int , J:Int ; for( Y:Names <! X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;Y;.Map) <! #deBruijn(I,J +Int size(#FV(Y));X;Mem) if #sub(#dBound(I,J;Y;.Map);Y;G) ){ 
            #deBruijn(I,J +Int size(#BV(X)) +Int size(#FV(Y)) +Int size(#BV(G)) ; #sub(#dBound(I,J;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I,J;Y;.Map) ) ) }

  // MultiRec
    // unguarded
  rule #deBruijn( I:Int , J:Int ; for( A:Lbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A;;.Map) ){ #deBruijn(I,J +Int size(#LV(A)) +Int size(#RV(A)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int , J:Int ; for( A:Pbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A;;.Map) ){ #deBruijn(I,J +Int size(#LV(A)) +Int size(#RV(A)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int , J:Int ; for( A:Rbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A;;.Map) ){ #deBruijn(I,J +Int size(#LV(A)) +Int size(#RV(A)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
    // guarded
  rule #deBruijn( I:Int , J:Int ; for( A:Lbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A if G;;.Map) ){ #deBruijn(I,J +Int size(#LV(A)) +Int size(#RV(A)) +Int size(#BV(G)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int , J:Int ; for( A:Pbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A if G;;.Map) ){ #deBruijn(I,J +Int size(#LV(A)) +Int size(#RV(A)) +Int size(#BV(G)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int , J:Int ; for( A:Rbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A if G;;.Map) ){ #deBruijn(I,J +Int size(#LV(A)) +Int size(#RV(A)) +Int size(#BV(G)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }

// Sends
// map constant on channel and message(s) -- check channel for bound variables
  rule #deBruijn( I:Int , J:Int ; X:Name !  ( P:Procs ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !  ( #deBruijn(I,J +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !  ( P:Proc  ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !  ( #deBruijn(I,J +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !  (         ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !  ( )
  rule #deBruijn( I:Int , J:Int ; X:Name !! ( P:Procs ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !! ( #deBruijn(I,J +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !! ( P:Proc  ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !! ( #deBruijn(I,J +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !! (         ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !! ( )

// Esubs -- just goes inside
  rule #deBruijn( I:Int , J:Int ; *X:Name ; Mem:Map ) => * #deBruijn(I,J;X;Mem)

// Variables
  // NameVars
    // nothing happens if NameVar is free w.r.t. Mem
    // if NameVar is bound w.r.t. Mem, replace it with its value
  rule #deBruijn( _:Int , _:Int ; N:NameVar ; Mem:Map ) => #sub(Mem;N)

  // ProcVars
    // nothing happens if ProcVar is free w.r.t. Mem
    // if ProcVar is bound w.r.t. Mem, replace it with its value
  rule #deBruijn( _:Int , _:Int ; P:ProcVar ; Mem:Map ) => #sub(Mem;P)

// Collections
  // RhoList
  rule #deBruijn( _:Int , _:Int ; [ ] ; _:Map ) => [ ]
  rule #deBruijn( I:Int , J:Int ; [ P:Proc  ] ; Mem:Map ) => [ #deBruijn(I,J;P;Mem) ]
  rule #deBruijn( I:Int , J:Int ; [ P:Procs ] ; Mem:Map ) => [ #deBruijn(I,J;P;Mem) ]

  // RhoMap

  // RhoSet
  rule #deBruijn( _:Int , _:Int ; Set( ) ; _:Map ) => Set( )
  rule #deBruijn( I:Int , J:Int ; Set( P:Proc  ) ; Mem:Map ) => Set( #deBruijn(I,J;P;Mem) )
  rule #deBruijn( I:Int , J:Int ; Set( P:Procs ) ; Mem:Map ) => Set( #deBruijn(I,J;P;Mem) )

  // RhoTuple
//  rule #deBruijn( _:Int , _:Int ; ( ) ; _:Map ) => ( )
  rule #deBruijn( I:Int , J:Int ;      ( P:Proc ,) ; Mem:Map ) =>      ( #deBruijn(I,J;P;Mem) ,)
  rule #deBruijn( I:Int , J:Int ; tuple( P:Procs ) ; Mem:Map ) => tuple( #deBruijn(I,J;P;Mem)  )

// Quotes -- just goes inside (just like eval)
  rule #deBruijn( I:Int , J:Int ; @P:Proc ; Mem:Map ) => @ #deBruijn(I,J;P;Mem)

// Expressions
  // Arithmetic Expressions -- only Var & Int
  rule #deBruijn( I:Int , J:Int ; - A:AExp ; Mem:Map ) => - #deBruijn(I,J;A;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp * B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) *  #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp / B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) /  #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp + B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) +  #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp - B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) -  #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp % B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) %  #deBruijn(I,J;B;Mem)

  // String Expressions -- only Var & String
  rule #deBruijn( I:Int , J:Int ; A:StringOrVar B:ConcatExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) #dBconcat(I,J;B;Mem)
  rule #dBconcat( I:Int , J:Int ; ++ A:StringOrVar ; Mem:Map ) => ++ #deBruijn(I,J;A;Mem)
  rule #dBconcat( I:Int , J:Int ; ++ A:StringOrVar B:ConcatExp  ; Mem:Map ) => ++ #deBruijn(I,J;A;Mem) #dBconcat(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:StringOrVar %% B:InterpMaps ; Mem:Map ) => #deBruijn(I,J;A;Mem) %% #dBinterp(I,J;B;Mem)
  rule #dBinterp( I:Int , J:Int ; A:RhoMap      %% B:InterpMaps ; Mem:Map ) => #deBruijn(I,J;A;Mem) %% #dBinterp(I,J;B;Mem)

  // Boolean Expressions
    // only Var & Bool
  rule #deBruijn( I:Int , J:Int ; not A:BExp ; Mem:Map ) => not #deBruijn(I,J;A;Mem)
  rule #deBruijn( I:Int , J:Int ; A:BExp and B:BExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) and #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:BExp or  B:BExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) or  #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp <=  B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) <=  #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp <   B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) <   #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp >=  B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) >=  #deBruijn(I,J;B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:AExp >   B:AExp ; Mem:Map ) => #deBruijn(I,J;A;Mem) >   #deBruijn(I,J;B;Mem)
    // may contain general Names & Procs -- check for bound variables to index
  rule #deBruijn( I:Int , J:Int ; A:Name ==  B:Name ; Mem:Map ) => #deBruijn(I,J;A;Mem) ==  #deBruijn(I,J +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:Name !=  B:Name ; Mem:Map ) => #deBruijn(I,J;A;Mem) !=  #deBruijn(I,J +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:Proc ==  B:Proc ; Mem:Map ) => #deBruijn(I,J;A;Mem) ==  #deBruijn(I,J +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:Proc !=  B:Proc ; Mem:Map ) => #deBruijn(I,J;A;Mem) !=  #deBruijn(I,J +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:Proc matches B:Proc ; Mem:Map ) => #deBruijn(I,J;A;Mem) matches #deBruijn(I,J +Int size(#BV(A));B;Mem)

// Several Names
  // Lists of to-be-bound Names will only appear in listens (the Name declarations in New are dealt with separately)...
  // need to make the appropriate substitutions in the continuation too...
  // want to do something like 
  rule #deBruijn( I:Int , J:Int ; A:Name , B:Name  ; Mem:Map ) => #deBruijn(I,J;A;Mem) , #deBruijn(I,J +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:Name , B:Names ; Mem:Map ) => #deBruijn(I,J;A;Mem) , #deBruijn(I,J +Int size(#BV(A));B;Mem)

// Several Procs
  // Lists of to-be-bound Procs appear in Collections and Sends...
  // want to do something like
  rule #deBruijn( I:Int , J:Int ; A:Proc , B:Proc  ; Mem:Map ) => #deBruijn(I,J;A;Mem) , #deBruijn(I,J +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int , J:Int ; A:Proc , B:Procs ; Mem:Map ) => #deBruijn(I,J;A;Mem) , #deBruijn(I,J +Int size(#BV(A));B;Mem)

//--------------
//--- #alpha ---
//--------------

// Alpha Equisubence Predicate
  // checks synactic equality of De Bruijn index substituted terms
//  rule #deBruijn(I:Int ; P:Proc #alpha Q:Proc ; Mem:Map) => #deBruijn(I;P;Mem) ==K #deBruijn(I;Q;Mem)
  rule P:Proc #alpha Q:Proc => #deBruijn(0;P;.Map) ==K #deBruijn(0;Q;.Map)

//---------------
//--- #dBound ---
//---------------
// assigns De Bruijn indices to variables bound by a listen in a receive
// TODO: finish writing/testing semantics for general Procs
// TODO: Mem values for several Names/Procs

// Name
  rule #dBound( I:Int ;  _:NameVar ; _:Map   ) => boundN(I)
  rule #dBound( I:Int ; @P:ProcVar ; _:Map   ) => @ boundP(I)
  rule #dBound( I:Int ; @P:Proc    ; Mem:Map ) => @ #dBound(I;P;Mem) requires notBool isProcVar(P)
  rule #dBound( I:Int ;  B:BoundName ; _:Map ) => B

  // several Names
  rule #dBound( I:Int ; A:Name , B:Name  ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:Name , B:Names ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)

// Proc
  rule #dBound( I:Int ;  B:BoundProc ; _:Map ) => B

// Binds
  // single
    // unguarded
  rule #dBound( I:Int ;; Y:Names <- X:Name ;; Mem:Map ) => #dBound(I;Y;Mem) <- #dBound(I +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int ;; Y:Name  <- X:Name ;; Mem:Map ) => #dBound(I;Y;Mem) <- #dBound(I +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int ;;         <- X:Name ;; Mem:Map ) =>  <- #dBound(I;X;Mem)
  rule #dBound( I:Int ;; Y:Names <= X:Name ;; Mem:Map ) => #dBound(I;Y;Mem) <= #dBound(I +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int ;; Y:Name  <= X:Name ;; Mem:Map ) => #dBound(I;Y;Mem) <= #dBound(I +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int ;;         <= X:Name ;; Mem:Map ) =>  <= #dBound(I;X;Mem)
  rule #dBound( I:Int ;; Y:Names <! X:Name ;; Mem:Map ) => #dBound(I;Y;Mem) <! #dBound(I +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int ;; Y:Name  <! X:Name ;; Mem:Map ) => #dBound(I;Y;Mem) <! #dBound(I +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int ;;         <! X:Name ;; Mem:Map ) =>  <! #dBound(I;X;Mem)
    // guarded
  rule #dBound( I:Int ;; B:Lbind if G:BExp ;; Mem:Map )
    => #dBound(I;;B;;Mem) if #dBound(I +Int size(#LV(B)) +Int size(#BV(#chan(B)));#sub(#dBound(I;#bvar(B);Mem);#bvar(B);G);Mem)

  rule #dBound( I:Int ;; B:Pbind if G:BExp ;; Mem:Map )
    => #dBound(I;;B;;Mem) if #dBound(I +Int size(#LV(B)) +Int size(#BV(#chan(B)));#sub(#dBound(I;#bvar(B);Mem);#bvar(B);G);Mem)

  rule #dBound( I:Int ;; B:Rbind if G:BExp ;; Mem:Map )
    => #dBound(I;;B;;Mem) if #dBound(I +Int size(#LV(B)) +Int size(#BV(#chan(B)));#sub(#dBound(I;#bvar(B);Mem);#bvar(B);G);Mem)

  // multiple -- TODO: check
    // unguarded
  rule #dBound( I:Int ;; A:Lbind ; B:Lbind  ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int ;; A:Lbind ; B:Lbinds ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int ;; A:Pbind ; B:Pbind  ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int ;; A:Pbind ; B:Pbinds ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int ;; A:Rbind ; B:Rbind  ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int ;; A:Rbind ; B:Rbinds ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
    // guarded
  rule #dBound( I:Int ;; A:Lbinds if G:BExp ;; Mem:Map )
    => #dBound(I;;A;;Mem) if #dBound(I +Int size(#LV(A)) +Int size(#RV(A));#sub(#dBound(I;#bvar(A);Mem);#bvar(A);G);Mem)

  rule #dBound( I:Int ;; A:Pbinds if G:BExp ;; Mem:Map )
    => #dBound(I;;A;;Mem) if #dBound(I +Int size(#LV(A)) +Int size(#RV(A));#sub(#dBound(I;#bvar(A);Mem);#bvar(A);G);Mem)

  rule #dBound( I:Int ;; A:Rbinds if G:BExp ;; Mem:Map )
    => #dBound(I;;A;;Mem) if #dBound(I +Int size(#LV(A)) +Int size(#RV(A));#sub(#dBound(I;#bvar(A);Mem);#bvar(A);G);Mem)

// Proc
  rule #dBound( _:Int ;  G:Ground  ; _:Map   ) => G
  rule #dBound( I:Int ;  _:ProcVar ; _:Map   ) => boundP(I)
  rule #dBound( I:Int ; *N:NameVar ; _:Map   ) => * boundN(I)
  rule #dBound( I:Int ; *N:Name    ; Mem:Map ) => * #dBound(I;N;Mem)

  // Send
  rule #dBound( I:Int ; A:Name !  ( B:Procs ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:Name !  ( B:Proc  ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:Name !  (         ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( )
  rule #dBound( I:Int ; A:Name !! ( B:Procs ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:Name !! ( B:Proc  ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:Name !! (         ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( )

// TODO: #V, #FV, or #BV??? & MultiRec
  // Receive -- increase nesting index for bound Names
  // linear
    // no listening variables
  rule #dBound( I:Int ; for(  <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( <- #dBound(I;X;Mem) ){ #dBound(I +Int size(#FV(X));P;Mem) }
    // listening for NameVar
      // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
      // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #dBound( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(1,0) <- #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundN(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(1,0) ) ) }
        // guarded
  rule #dBound( I:Int ; for( Y:NameVar <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(1,0) <- #dBound(I;X;Mem) if #sub(boundN(1,0);#sub(Mem;Y);B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundN(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int ; for( @Y:ProcVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(1,0) <- #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)); #sub(boundP(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(1,0) ) ) }
        // guarded
  rule #dBound( I:Int ; for( @Y:ProcVar <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(1,0) <- #dBound(I;X;Mem) if #sub(boundP(1,0);#sub(Mem;Y);B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundP(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int ; for( @Y:Proc <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(1,0;Y;.Map) <- #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int ; for( @Y:Proc <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(1,0;Y;.Map) <- #dBound(I;X;Mem) if #sub(#dBound(1,0;Y;.Map);Y;B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
    // several Name listens
  rule #dBound( I:Int ; for( Y:Names <- X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(1,0;Y;.Map) <- #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
        // guarded
  rule #dBound( I:Int ; for( Y:Names <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(1,0;Y;.Map) <- #dBound(I;X;Mem) if #sub(#dBound(1,0;Y;.Map);Y;B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }

  // repeated
    // no listening variables
  rule #dBound( I:Int ; for(  <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( <= #dBound(I;X;Mem) ){ #dBound(I +Int size(#FV(X));P;Mem) }
    // listening for NameVar
      // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar -- map union because Y is not in keys
      // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar -- map update because Y is in keys
  rule #dBound( I:Int ; for( Y:NameVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(1,0) <= #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundN(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(1,0) ) ) }
        // guarded
  rule #dBound( I:Int ; for( Y:NameVar <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(1,0) <= #dBound(I;X;Mem) if #sub(boundN(1,0);#sub(Mem;Y);B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundN(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int ; for( @Y:ProcVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(1,0) <= #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)); #sub(boundP(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(1,0) ) ) }
        // guarded
  rule #dBound( I:Int ; for( @Y:ProcVar <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(1,0) <= #dBound(I;X;Mem) if #sub(boundP(1,0);#sub(Mem;Y);B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundP(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int ; for( @Y:Proc <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(1,0;Y;.Map) <= #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int ; for( @Y:Proc <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(1,0;Y;.Map) <= #dBound(I;X;Mem) if #sub(#dBound(1,0;Y;.Map);Y;B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
    // several Name listens
  rule #dBound( I:Int ; for( Y:Names <= X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(1,0;Y;.Map) <= #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
        // guarded
  rule #dBound( I:Int ; for( Y:Names <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(1,0;Y;.Map) <= #dBound(I;X;Mem) if #sub(#dBound(1,0;Y;.Map);Y;B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }

  // peek
    // no listening variables
  rule #dBound( I:Int ; for(  <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( <! #dBound(I;X;Mem) ){ #dBound(I +Int size(#FV(X));P;Mem) }
    // listening for NameVar
      // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
      // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #dBound( I:Int ; for( Y:NameVar <! X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(1,0) <! #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundN(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(1,0) ) ) }
        // guarded
  rule #dBound( I:Int ; for( Y:NameVar <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(1,0) <! #dBound(I;X;Mem) if #sub(boundN(1,0);#sub(Mem;Y);B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundN(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int ; for( @Y:ProcVar <! X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(1,0) <! #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)); #sub(boundP(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(1,0) ) ) }
        // guarded
  rule #dBound( I:Int ; for( @Y:ProcVar <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(1,0) <! #dBound(I;X;Mem) if #sub(boundP(1,0);#sub(Mem;Y);B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(boundP(1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int ; for( @Y:Proc <! X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(1,0;Y;.Map) <! #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int ; for( @Y:Proc <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(1,0;Y;.Map) <! #dBound(I;X;Mem) if #sub(#dBound(1,0;Y;.Map);Y;B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
    // several Name listens
  rule #dBound( I:Int ; for( Y:Names <! X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(1,0;Y;.Map) <! #dBound(I;X;Mem) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }
        // guarded
  rule #dBound( I:Int ; for( Y:Names <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(1,0;Y;.Map) <! #dBound(I;X;Mem) if #sub(#dBound(1,0;Y;.Map);Y;B) ){ 
            #dBound( I +Int size(#FV(X)) ; #sub(#dBound(1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(1,0;Y;.Map) ) ) }

  // Par
  rule #dBound( I:Int ; A:Proc | B:Proc ; Mem:Map ) => #dBound(I;A;Mem) | #dBound(I +Int size(#FV(A));B;Mem) requires notBool isPar(A)

  // New
  rule #dBound( _:Int ; A:New ; Mem:Map ) => #deBruijn(1,0;A;.Map)

  // several Names -- increase index for each name (if not already bound)
  rule #dBound( I:Int ; A:Name , B:Name  ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:Name , B:Names ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  // several Procs -- increase index for each name (if not already bound)
  rule #dBound( I:Int ; A:Proc , B:Proc  ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:Proc , B:Procs ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)

// Nested
  // Name
  rule #dBound( I:Int , J:Int ; _:NameVar ; _:Map   ) => boundN(I,J)
  rule #dBound( I:Int , J:Int ; @P:Proc   ; Mem:Map ) => @ #dBound(I,J;P;Mem)

    // several Names
  rule #dBound( I:Int , J:Int ; A:Name , B:Name  ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound(I,J +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int , J:Int ; A:Name , B:Names ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound(I,J +Int size(#FV(A));B;Mem)

// Binds
  // single
    // unguarded
  rule #dBound( I:Int , J:Int ;; Y:Names <- X:Name ;; Mem:Map ) => #dBound(I,J;Y;Mem) <- #dBound(I,J +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:Name  <- X:Name ;; Mem:Map ) => #dBound(I,J;Y;Mem) <- #dBound(I,J +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int , J:Int ;;         <- X:Name ;; Mem:Map ) =>  <- #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:Names <= X:Name ;; Mem:Map ) => #dBound(I,J;Y;Mem) <= #dBound(I,J +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:Name  <= X:Name ;; Mem:Map ) => #dBound(I,J;Y;Mem) <= #dBound(I,J +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int , J:Int ;;         <= X:Name ;; Mem:Map ) =>  <= #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:Names <! X:Name ;; Mem:Map ) => #dBound(I,J;Y;Mem) <! #dBound(I,J +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:Name  <! X:Name ;; Mem:Map ) => #dBound(I,J;Y;Mem) <! #dBound(I,J +Int size(#FV(Y));X;Mem)
  rule #dBound( I:Int , J:Int ;;         <! X:Name ;; Mem:Map ) =>  <! #dBound(I,J;X;Mem)
    // guarded
  rule #dBound( I:Int , J:Int ;; B:Lbind if G:BExp ;; Mem:Map )
    => #dBound(I,J;;B;;Mem) if #dBound(I,J +Int size(#LV(B)) +Int size(#BV(#chan(B)));#sub(#dBound(I,J;#bvar(B);Mem);#bvar(B);G);Mem)

  rule #dBound( I:Int , J:Int ;; B:Pbind if G:BExp ;; Mem:Map )
    => #dBound(I,J;;B;;Mem) if #dBound(I,J +Int size(#LV(B)) +Int size(#BV(#chan(B)));#sub(#dBound(I,J;#bvar(B);Mem);#bvar(B);G);Mem)

  rule #dBound( I:Int , J:Int ;; B:Rbind if G:BExp ;; Mem:Map )
    => #dBound(I,J;;B;;Mem) if #dBound(I,J +Int size(#LV(B)) +Int size(#BV(#chan(B)));#sub(#dBound(I,J;#bvar(B);Mem);#bvar(B);G);Mem)

  // multiple -- TODO: check
    // unguarded
  rule #dBound( I:Int , J:Int ;; A:Lbind ; B:Lbind  ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Lbind ; B:Lbinds ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Pbind ; B:Pbind  ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Pbind ; B:Pbinds ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Rbind ; B:Rbind  ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Rbind ; B:Rbinds ;; Mem:Map ) => #dBound(I;;A;;Mem) ; #dBound(I +Int size(#LV(A));;B;;Mem)
    // guarded
  rule #dBound( I:Int , J:Int ;; A:Lbinds if G:BExp ;; Mem:Map )
    => #dBound(I,J;;A;;Mem) if #dBound(I,J +Int size(#LV(A)) +Int size(#RV(A));#sub(#dBound(I,J;#bvar(A);Mem);#bvar(A);G);Mem)

  rule #dBound( I:Int , J:Int ;; A:Pbinds if G:BExp ;; Mem:Map )
    => #dBound(I,J;;A;;Mem) if #dBound(I,J +Int size(#LV(A)) +Int size(#RV(A));#sub(#dBound(I,J;#bvar(A);Mem);#bvar(A);G);Mem)

  rule #dBound( I:Int , J:Int ;; A:Rbinds if G:BExp ;; Mem:Map )
    => #dBound(I,J;;A;;Mem) if #dBound(I,J +Int size(#LV(A)) +Int size(#RV(A));#sub(#dBound(I,J;#bvar(A);Mem);#bvar(A);G);Mem)

  // Proc
  rule #dBound( _:Int , _:Int ; G:Ground  ; _:Map   ) => G
  rule #dBound( I:Int , J:Int ; _:ProcVar ; _:Map   ) => boundP(I,J)
  rule #dBound( I:Int , J:Int ; *N:Name   ; Mem:Map ) => * #dBound(I,J;N;Mem)

    // Send
  rule #dBound( I:Int , J:Int ; A:Name ! ( B:Proc  ) ; Mem:Map ) => #dBound(I,J;A;Mem) ! ( #dBound(I,J +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int , J:Int ; A:Name ! ( B:Procs ) ; Mem:Map ) => #dBound(I,J;A;Mem) ! ( #dBound(I,J +Int size(#FV(A));B;Mem) )

    // Receive -- increase nesting index for bound Names
  // linear
    // no listening variables
  rule #dBound( I:Int , J:Int ; for(  <- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( <- #dBound(I,J;X;Mem) ){ #dBound(I,J +Int size(#FV(X));P;Mem) }
    // listening for NameVar
      // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
      // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #dBound( I:Int , J:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <- #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:NameVar <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <- #dBound(I,J;X;Mem) if #sub(boundN(I +Int 1,0);#sub(Mem;Y);B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <- #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)); #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <- #dBound(I,J;X;Mem) if #sub(boundP(I +Int 1,0);#sub(Mem;Y);B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <- #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <- #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
    // several Name listens
  rule #dBound( I:Int , J:Int ; for( Y:Names <- X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <- #dBound(I +Int 1,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Names <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <- #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }

  // repeated
    // no listening variables
  rule #dBound( I:Int , J:Int ; for(  <= X:Name ){ P:Proc } ; Mem:Map ) 
    => for( <= #dBound(I,J;X;Mem) ){ #dBound(I,J +Int size(#FV(X));P;Mem) }
    // listening for NameVar
      // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
      // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #dBound( I:Int , J:Int ; for( Y:NameVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <= #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:NameVar <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <= #dBound(I,J;X;Mem) if #sub(boundN(I +Int 1,0);#sub(Mem;Y);B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <= #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)); #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <= #dBound(I,J;X;Mem) if #sub(boundP(I +Int 1,0);#sub(Mem;Y);B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <= #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <= #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
    // several Name listens
  rule #dBound( I:Int , J:Int ; for( Y:Names <= X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <= #dBound(I +Int 1,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Names <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <= #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }

  // peek
    // no listening variables
  rule #dBound( I:Int , J:Int ; for(  <! X:Name ){ P:Proc } ; Mem:Map ) 
    => for( <! #dBound(I,J;X;Mem) ){ #dBound(I,J +Int size(#FV(X));P;Mem) }
    // listening for NameVar
      // if NameVar is fresh w.r.t. Mem, do usual substitution for NameVar
      // if NameVar is not fresh w.r.t. Mem, substitute for the value associated with NameVar
  rule #dBound( I:Int , J:Int ; for( Y:NameVar <! X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <! #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:NameVar <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <! #dBound(I,J;X;Mem) if #sub(boundN(I +Int 1,0);#sub(Mem;Y);B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <! X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <! #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)); #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <! #dBound(I,J;X;Mem) if #sub(boundP(I +Int 1,0);#sub(Mem;Y);B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <! X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <! #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <! #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
    // several Name listens
  rule #dBound( I:Int , J:Int ; for( Y:Names <! X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <! #dBound(I +Int 1,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Names <! X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <! #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }

  // New
  rule #dBound( I:Int , _:Int ; A:New ; Mem:Map ) => #deBruijn(I +Int 1,0;A;.Map)

    // several Procs
  rule #dBound( I:Int , J:Int ; A:Proc , B:Proc  ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound(I,J +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int , J:Int ; A:Proc , B:Procs ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound(I,J +Int size(#FV(A));B;Mem)

//---------------
//--- #mapify ---
//---------------
// returns map from variables to De Bruijn indices

// Name
  rule #mapify( I:Int ; A:NameVar   ; Mem:Map ) => updateMap( Mem , A |-> boundN(I) )
  rule #mapify( _:Int ; _:BoundName ; Mem:Map ) => Mem
  rule #mapify( I:Int ; @ A:Proc    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

  // several Names
  rule #mapify( I:Int ; A:Name , B:Name  ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name , B:Names ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )

// Proc
  rule #mapify( _:Int ; _:Ground    ; Mem:Map ) => Mem
  rule #mapify( I:Int ; A:ProcVar   ; Mem:Map ) => updateMap( Mem , A |-> boundP(I) )
  rule #mapify( _:Int ; _:BoundProc ; Mem:Map ) => Mem
  rule #mapify( I:Int ; * A:Name    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

  // several Procs
  rule #mapify( I:Int ; A:Proc , B:Proc  ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Proc , B:Procs ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )

  // New -- TODO: fix this
  rule #mapify( I:Int ; new A:NameVar in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; #sub(boundN(I);A;B) ; Mem ) ) requires notBool (A in values(Mem))
  rule #mapify( I:Int ; new A:NameVar in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; #sub(boundN(I);A;B) ; Mem ) ) requires A in values(Mem)

  // Par
  rule #mapify( I:Int ; A:Proc | B:Proc ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
       requires notBool isPar(A)

  // Send
  rule #mapify( I:Int ; A:Name !  ( B:Procs ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name !  ( B:Proc  ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name !  (         ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )
  rule #mapify( I:Int ; A:Name !! ( B:Procs ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name !! ( B:Proc  ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name !! (         ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

  // Receive -- TODO: MultiRec
    // TODO: more testing
    // sub @sub for listening variables so no binding from a listening variable is recorded
    // unguarded
  rule #mapify( I:Int ; for(         <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int ; for( Y:Name  <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for( Y:Names <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for(         <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int ; for( Y:Name  <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for( Y:Names <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for(         <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int ; for( Y:Name  <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for( Y:Names <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
    // guarded
  rule #mapify( I:Int ; for(         <- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int ; for( Y:Name  <- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for( Y:Names <- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for(         <= X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int ; for( Y:Name  <= X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for( Y:Names <= X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for(         <! X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int ; for( Y:Name  <! X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))
  rule #mapify( I:Int ; for( Y:Names <! X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I;Y;Mem)))

// Nested #mapify
  // Name
  rule #mapify( I:Int , J:Int ; A:NameVar   ; Mem:Map ) => updateMap( Mem , A |-> boundN(I,J) )
  rule #mapify( _:Int , _:Int ; _:BoundName ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; @ A:Proc    ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )


    // several Names
  rule #mapify( I:Int , J:Int ; A:Name , B:Name  ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name , B:Names ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )

  // Proc
  rule #mapify( _:Int , _:Int ; _:Ground    ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; A:ProcVar   ; Mem:Map ) => updateMap( Mem , A |-> boundP(I,J) )
  rule #mapify( _:Int , _:Int ; _:BoundProc ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; *A:Name     ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )

    // several Procs
  rule #mapify( I:Int , J:Int ; A:Proc , B:Proc  ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Proc , B:Procs ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )

    // New
  rule #mapify( I:Int , J:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I,J) #mapify( I,J +Int 1 ; #sub(boundN(I,J);A;B) ; Mem ) ) requires notBool (A in values(Mem))

  rule #mapify( I:Int , J:Int ; new A:Name in { B:Proc } ; Mem:Map ) 
    => updateMap( Mem , A |-> boundN(I,J) #mapify( I,J +Int 1 ; #sub(boundN(I,J);A;B) ; Mem ) ) requires A in values(Mem)

    // Par
  rule #mapify( I:Int , J:Int ; A:Proc | B:Proc ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
       requires notBool isPar(A)

    // Send
  rule #mapify( I:Int , J:Int ; A:Name !  ( B:Procs ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name !  ( B:Proc  ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name !  (         ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name !! ( B:Procs ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name !! ( B:Proc  ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name !! (         ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )

    // Receive -- TODO: MultiRec
      // TODO: more testing
  rule #mapify( I:Int , J:Int ; for(         <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int , J:Int ; for( Y:Name  <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Names <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for(         <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int , J:Int ; for( Y:Name  <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Names <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for(         <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int , J:Int ; for( Y:Name  <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Names <! X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
    // guarded
  rule #mapify( I:Int , J:Int ; for(         <- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int , J:Int ; for( Y:Name  <- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Names <- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for(         <= X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int , J:Int ; for( Y:Name  <= X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Names <= X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for(         <! X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int , J:Int ; for( Y:Name  <! X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))
  rule #mapify( I:Int , J:Int ; for( Y:Names <! X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));#sub(#mapSub(#FV(Y));P);updateMap(Mem,#mapify(I,J;Y;Mem)))

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule