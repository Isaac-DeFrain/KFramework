// De Bruijn Index/Levels & Alpha Equivalence for Rholang
// Need to call #deBruijn($PGM) in program to index

/*
TODO:
 - how to handle listens with several names & joins? -- Mem values for several Names/Procs in #dBound
 - more tests for substitutions in continuations for listens on chan
 - add remaining productions - MRec, Conditional, Bundle, etc.
 - extend compositional definition
*/

require "../grho.k"
require "../Substitute/sub.k"

module ALPHA-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

//--- Top level ---
  // Proc
  syntax         Proc ::= "#deBruijn(" Int ";" Proc     ";" Map ")" [function, poly(0,2)]
                        |   "#dBound(" Int ";" Proc     ";" Map ")" [function]
                        | "#deBruijn(" Proc ")"                     [function, poly(0,1)]

  syntax        Procs ::= "#deBruijn(" Int ";" Procs    ";" Map ")" [function]
                        |   "#dBound(" Int ";" Procs    ";" Map ")" [function]
  // ProcPat
  syntax      ProcPat ::= "#deBruijn(" Int ";" ProcPat  ";" Map ")" [function, poly(0,2)]
                        |   "#dBound(" Int ";" ProcPat  ";" Map ")" [function]

  syntax     ProcPats ::= "#deBruijn(" Int ";" ProcPats ";" Map ")" [function]
                        |   "#dBound(" Int ";" ProcPats ";" Map ")" [function]
  // Name
  syntax         Name ::= "#deBruijn(" Int ";" Name ";" Map ")" [function]
                        |   "#dBound(" Int ";" Name ";" Map ")" [function]

  syntax        Names ::= "#deBruijn(" Int ";" Names ";" Map ")" [function]
                        |   "#dBound(" Int ";" Names ";" Map ")" [function]
                        |    "#dbNew(" Int ";" Names ")"         [function]
  // NamePat
  syntax      NamePat ::= "#deBruijn(" Int ";" NamePat  ";" Map ")" [function]
                        |   "#dBound(" Int ";" NamePat  ";" Map ")" [function]

  syntax     NamePats ::= "#deBruijn(" Int ";" NamePats ";" Map ")" [function]
                        |   "#dBound(" Int ";" NamePats ";" Map ")" [function]

//--- Nested ---
  // Proc
  syntax         Proc ::= "#deBruijn(" Int "," Int ";" Proc     ";" Map ")" [function, poly(0,3)]
                        |   "#dBound(" Int "," Int ";" Proc     ";" Map ")" [function]

  syntax        Procs ::= "#deBruijn(" Int "," Int ";" Procs    ";" Map ")" [function]
                        |   "#dBound(" Int "," Int ";" Procs    ";" Map ")" [function]
  // ProcPat
  syntax      ProcPat ::= "#deBruijn(" Int "," Int ";" ProcPat  ";" Map ")" [function, poly(0,3)]
                        |   "#dBound(" Int "," Int ";" ProcPat  ";" Map ")" [function]

  syntax     ProcPats ::= "#deBruijn(" Int "," Int ";" ProcPats ";" Map ")" [function]
                        |   "#dBound(" Int "," Int ";" ProcPats ";" Map ")" [function]

  // Name
  syntax         Name ::= "#deBruijn(" Int "," Int ";" Name     ";" Map ")" [function]
                        |   "#dBound(" Int "," Int ";" Name     ";" Map ")" [function]

  syntax        Names ::= "#deBruijn(" Int "," Int ";" Names    ";" Map ")" [function]
                        |   "#dBound(" Int "," Int ";" Names    ";" Map ")" [function]
  // NamePat
  syntax      NamePat ::= "#deBruijn(" Int "," Int ";" NamePat  ";" Map ")" [function]
                        |   "#dBound(" Int "," Int ";" NamePat  ";" Map ")" [function]

  syntax     NamePats ::= "#deBruijn(" Int "," Int ";" NamePats ";" Map ")" [function]
                        |   "#dBound(" Int "," Int ";" NamePats ";" Map ")" [function]

// Recursive functions -- TODO: finish including
  // can Lbind, Pbind, Rbind be combined into a single Bind with [poly]???
  syntax        Lbind ::= "#deBruijn(" Int         ";;" Lbind   ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Lbind   ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" Lbind   ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" Lbind   ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Lbind   ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Lbind   ";;" Map ")" [function]
  syntax       Lbinds ::= "#deBruijn(" Int         ";;" Lbinds  ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Lbinds  ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" Lbinds  ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" Lbinds  ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Lbinds  ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Lbinds  ";;" Map ")" [function]
  syntax       GLbind ::= "#deBruijn(" Int         ";;" GLbind  ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GLbind  ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" GLbind  ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" GLbind  ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GLbind  ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GLbind  ";;" Map ")" [function]
  syntax      GLbinds ::= "#deBruijn(" Int         ";;" GLbinds ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GLbinds ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" GLbinds ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" GLbinds ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GLbinds ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GLbinds ";;" Map ")" [function]
  syntax        Pbind ::= "#deBruijn(" Int         ";;" Pbind   ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Pbind   ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" Pbind   ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" Pbind   ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Pbind   ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Pbind   ";;" Map ")" [function]
  syntax       Pbinds ::= "#deBruijn(" Int         ";;" Pbinds  ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Pbinds  ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" Pbinds  ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" Pbinds  ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Pbinds  ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Pbinds  ";;" Map ")" [function]
  syntax       GPbind ::= "#deBruijn(" Int         ";;" GPbind  ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GPbind  ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" GPbind  ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" GPbind  ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GPbind  ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GPbind  ";;" Map ")" [function]
  syntax      GPbinds ::= "#deBruijn(" Int         ";;" GPbinds ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GPbinds ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" GPbinds ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" GPbinds ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GPbinds ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GPbinds ";;" Map ")" [function]
  syntax        Rbind ::= "#deBruijn(" Int         ";;" Rbind   ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Rbind   ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" Rbind   ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" Rbind   ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Rbind   ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Rbind   ";;" Map ")" [function]
  syntax       Rbinds ::= "#deBruijn(" Int         ";;" Rbinds  ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Rbinds  ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" Rbinds  ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" Rbinds  ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Rbinds  ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Rbinds  ";;" Map ")" [function]
  syntax       GRbind ::= "#deBruijn(" Int         ";;" GRbind  ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GRbind  ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" GRbind  ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" GRbind  ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GRbind  ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GRbind  ";;" Map ")" [function]
  syntax      GRbinds ::= "#deBruijn(" Int         ";;" GRbinds ";;" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GRbinds ";;" Map ")" [function]
                        |   "#dBound(" Int         ";;" GRbinds ";;" Map ")" [function]
                        |   "#dBound(" Int "," Int ";;" GRbinds ";;" Map ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GRbinds ";;" Map ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GRbinds ";;" Map ")" [function]

  // KV pairs
  syntax    RhoKVPair ::= "#deBruijn(" Int ";"         RhoKVPair  ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" RhoKVPair  ";" Map ")" [function]
  syntax   RhoKVPairs ::= "#deBruijn(" Int ";"         RhoKVPairs ";" Map ")" [function]
                        | "#deBruijn(" Int "," Int ";" RhoKVPairs ";" Map ")" [function]

  // String expressions
  syntax    ConcatExp ::= "#dBconcat(" Int ";"         ConcatExp  ";" Map ")" [function]
                        | "#dBconcat(" Int "," Int ";" ConcatExp  ";" Map ")" [function]
  syntax   InterpMaps ::= "#dBinterp(" Int ";"         InterpMaps ";" Map ")" [function]
                        | "#dBinterp(" Int "," Int ";" InterpMaps ";" Map ")" [function]

// Top level Map updates
  // New Name declarations
  syntax          Map ::= "#mapNew(" Int         ";" Names ")" [function]
                        | "#mapNew(" Int "," Int ";" Names ")" [function]

  syntax          Map ::= "#mapify(" Names    ")" [function]
                        | "#mapify(" NamePats ")" [function]
                        | "#mapify(" Procs    ")" [function]
                        | "#mapify(" ProcPats ")" [function]
                        | "#mapify(" Int ";" Name      ";" Map ")" [function]
                        | "#mapify(" Int ";" Names     ";" Map ")" [function]
                        | "#mapify(" Int ";" NamePat   ";" Map ")" [function]
                        | "#mapify(" Int ";" NamePats  ";" Map ")" [function]
                        | "#mapify(" Int ";" Proc      ";" Map ")" [function]
                        | "#mapify(" Int ";" Procs     ";" Map ")" [function]
                        | "#mapify(" Int ";" ProcPat   ";" Map ")" [function]
                        | "#mapify(" Int ";" ProcPats  ";" Map ")" [function]
                        | "#mapify(" Int ";;" Lbind   ";;" Map ")" [function]
                        | "#mapify(" Int ";;" Lbinds  ";;" Map ")" [function]
                        | "#mapify(" Int ";;" GLbind  ";;" Map ")" [function]
                        | "#mapify(" Int ";;" GLbinds ";;" Map ")" [function]
                        | "#mapify(" Int ";;" Pbind   ";;" Map ")" [function]
                        | "#mapify(" Int ";;" Pbinds  ";;" Map ")" [function]
                        | "#mapify(" Int ";;" GPbind  ";;" Map ")" [function]
                        | "#mapify(" Int ";;" GPbinds ";;" Map ")" [function]
                        | "#mapify(" Int ";;" Rbind   ";;" Map ")" [function]
                        | "#mapify(" Int ";;" Rbinds  ";;" Map ")" [function]
                        | "#mapify(" Int ";;" GRbind  ";;" Map ")" [function]
                        | "#mapify(" Int ";;" GRbinds ";;" Map ")" [function]
//                      | "#mapify(" Int ";;" AnyBinds ";;" Map ")" [function]

// Nested Map updates
  syntax          Map ::= "#mapify(" Int "," Int ";"  Name      ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";"  Names     ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";"  NamePat   ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";"  NamePats  ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";"  Proc      ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";"  Procs     ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";"  ProcPat   ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";"  ProcPats  ";" Map ")" [function]
                        | "#mapify(" Int "," Int ";;" AnyBind  ";;" Map ")" [function]
                        | "#mapify(" Int "," Int ";;" AnyBinds ";;" Map ")" [function]

// Number of indexed variables in a [G]Bind[s]
  // #deBruijn
  syntax          Int ::= "#dBsize(" Bind      ")" [function]
                        | "#dBsize(" Binds     ")" [function]
                        | "#dBsize(" GBind     ")" [function]
                        | "#dBsize(" GBinds    ")" [function]
                        | "#dBsize(" BindPat   ")" [function]
                        | "#dBsize(" BindPats  ")" [function]
                        | "#dBsize(" GBindPat  ")" [function]
                        | "#dBsize(" GBindPats ")" [function]
  // #dBound
  syntax          Int ::= "#dBoundSize(" Bind      ")" [function]
                        | "#dBoundSize(" Binds     ")" [function]
                        | "#dBoundSize(" GBind     ")" [function]
                        | "#dBoundSize(" GBinds    ")" [function]
                        | "#dBoundSize(" BindPat   ")" [function]
                        | "#dBoundSize(" BindPats  ")" [function]
                        | "#dBoundSize(" GBindPat  ")" [function]
                        | "#dBoundSize(" GBindPats ")" [function]

// Alpha equivalence predicate
  syntax         Bool ::= Proc "#alpha" Proc [function]

endmodule

module ALPHA
  import ALPHA-SYNTAX
  import SUB

  syntax KResult ::= Proc | Procs | ProcPat | ProcPats
                   | Name | Names | NamePat | NamePats
                   | Bind | Binds | BindPat | BindPats
                   | RhoKVPair | RhoKVPairs | ConcatExp | InterpMaps | Map

  rule #deBruijn( P:Proc ) => #deBruijn(0;P;.Map) // #FV(P) should be .Set if we are applying #deBruijn

//----------------------------
//--- Top Level Constructs ---
//----------------------------
  rule #deBruijn( I:Int ; new A:Names in { P:Proc } ; Mem:Map )
    => new #dbNew(I;A) in { #deBruijn( I +Int size(#DV(A)) ; #sub(#mapNew(I;A);P) ; updateMap( Mem , #mapNew(I;A) ) ) }

// Nested
  // single name declaration
  rule #deBruijn( I:Int , J:Int ; new A:Var in { P:Proc } ; Mem:Map ) 
    => new boundN(I,J) in { #deBruijn( I,J +Int 1 ; #sub(boundN(I,J);A;P) ; updateMap( Mem , A |-> boundN(I,J) ) ) }
  // handles several name declarations all at once
  rule #deBruijn( I:Int , J:Int ; new A:Names in { P:Proc } ; Mem:Map )
    => new #dBound(I,J;A;.Map) in { #deBruijn( I,J +Int #length(A) ; #sub(#mapify(I,J;A;.Map);P) ; updateMap( Mem , #mapify(I,J;A;.Map) ) ) }

// Ground & Bound Terms
  rule #deBruijn( _:Int ; A:Ground    ; _:Map ) => A
  rule #deBruijn( _:Int ; A:BoundName ; _:Map ) => A
  rule #deBruijn( _:Int ; A:BoundProc ; _:Map ) => A

// Parallel Composition
// Mem map propogates to both branchs
  rule #deBruijn( I:Int ; P:Proc | Q:Proc ; Mem:Map ) => #deBruijn(I;P;Mem) | #deBruijn(I +Int size(#BV(P));Q;Mem) requires notBool isPar(P)

// Receives
  // listening variables become boundN(I) with the appropriate index and are guarded during De Bruijn indexing
  // Linear
    // Single
      // unguarded
  rule #deBruijn( I:Int ; for( <- X:Name ){ P:Proc } ; Mem:Map )
    => for( <- #deBruijn(I;X;Mem) ){ #deBruijn(I +Int size(#BV(X));P;Mem) }
  rule #deBruijn( I:Int ; for( B:Lbind   ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;#bvar(B);.Map) <- #deBruijn(I +Int size(#LV(B));#chan(B);Mem) ){
              #deBruijn(I +Int #dBsize(B) ;
              #sub(#mapify(I;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I;#bvar(B);.Map) )) } [owise]
      // guarded
  rule #deBruijn( I:Int ; for( <- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( <- #deBruijn(I;X;Mem) if #deBruijn(I +Int size(#BV(X));G;Mem) ){ #deBruijn(I +Int size(#BV(X)) +Int size(#BV(G));P;Mem) }
  rule #deBruijn( I:Int ; for( B:Lbind   if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;#bvar(B);.Map) <- #deBruijn(I +Int size(#LV(B));#chan(B);Mem) if #sub(#mapify(I;#bvar(B);.Map);G) ){
              #deBruijn(I +Int #dBsize(B) +Int size(#BV(G)) ;
              #sub(#mapify(I;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I;#bvar(B);.Map) )) } [owise]
    // Multi
      // unguarded
  rule #deBruijn( I:Int ; for( A:Lbinds ){ P:Proc } ; Mem:Map )
    => for( #deBruijn(I;;A;;.Map) ){ 
         #deBruijn(I +Int #dBsize(A) ;
           #sub(#mapify(I;#bvar(A);.Map);P) ;
           updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
      // guarded
  rule #deBruijn( I:Int ; for( A:Lbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #deBruijn(I;;A if G;;.Map) ){ 
         #deBruijn(I +Int #dBsize(A) +Int size(#BV(G)) ;
         #sub(#mapify(I;#bvar(A);.Map);P) ; 
         updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
  // Peek
    // Single
      // unguarded
  rule #deBruijn( I:Int ; for( <<- X:Name ){ P:Proc } ; Mem:Map )
    => for( <<- #deBruijn(I;X;Mem) ){ #deBruijn(I +Int size(#BV(X));P;Mem) }
  rule #deBruijn( I:Int ; for( B:Pbind   ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;#bvar(B);.Map) <<- #deBruijn(I +Int size(#LV(B));#chan(B);Mem) ){
              #deBruijn(I +Int #dBsize(B) ;
              #sub(#mapify(I;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I;#bvar(B);.Map) )) } [owise]
      // guarded
  rule #deBruijn( I:Int ; for( <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( <<- #deBruijn(I;X;Mem) if #deBruijn(I +Int size(#BV(X));G;Mem) ){ #deBruijn(I +Int size(#BV(X)) +Int size(#BV(G));P;Mem) }
  rule #deBruijn( I:Int ; for( B:Pbind   if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;#bvar(B);.Map) <<- #deBruijn(I +Int size(#LV(B));#chan(B);Mem) if #sub(#mapify(I;#bvar(B);.Map);G) ){
              #deBruijn(I +Int #dBsize(B) +Int size(#BV(G)) ;
              #sub(#mapify(I;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I;#bvar(B);.Map) )) } [owise]
    // Multi
      // unguarded
  rule #deBruijn( I:Int ; for( A:Pbinds ){ P:Proc } ; Mem:Map )
    => for( #deBruijn(I;;A;;.Map) ){ 
         #deBruijn(I +Int #dBsize(A) ;
           #sub(#mapify(I;#bvar(A);.Map);P) ;
           updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
      // guarded
  rule #deBruijn( I:Int ; for( A:Pbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #deBruijn(I;;A if G;;.Map) ){ 
         #deBruijn(I +Int #dBsize(A) +Int size(#BV(G)) ;
           #sub(#mapify(I;#bvar(A);.Map);P) ; 
           updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
  // Repeat
    // Single
      // unguarded
  rule #deBruijn( I:Int ; for( <= X:Name ){ P:Proc } ; Mem:Map )
    => for( <= #deBruijn(I;X;Mem) ){ #deBruijn(I +Int size(#BV(X));P;Mem) }
  rule #deBruijn( I:Int ; for( B:Rbind ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;#bvar(B);.Map) <= #deBruijn(I +Int size(#LV(B));#chan(B);Mem) ){
              #deBruijn(I +Int #dBsize(B) ;
              #sub(#mapify(I;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I;#bvar(B);.Map) )) } [owise]
      // guarded
  rule #deBruijn( I:Int ; for( <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( <= #deBruijn(I;X;Mem) if #deBruijn(I +Int size(#BV(X));G;Mem) ){ #deBruijn(I +Int size(#BV(X)) +Int size(#BV(G));P;Mem) }
  rule #deBruijn( I:Int ; for( B:Rbind if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;#bvar(B);.Map) <= #deBruijn(I +Int size(#LV(B));#chan(B);Mem) if #sub(#mapify(I;#bvar(B);.Map);G) ){
         #deBruijn(I +Int #dBsize(B) +Int size(#BV(G)) ;
           #sub(#mapify(I;#bvar(B);.Map);P) ;
           updateMap( Mem , #mapify(I;#bvar(B);.Map) )) } [owise]
    // Multi
      // unguarded
  rule #deBruijn( I:Int ; for( A:Rbinds ){ P:Proc } ; Mem:Map )
    => for( #deBruijn(I;;A;;.Map) ){ 
         #deBruijn(I +Int #dBsize(A) ;
           #sub(#mapify(I;#bvar(A);.Map);P) ;
           updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }
      // guarded
  rule #deBruijn( I:Int ; for( A:Rbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #deBruijn(I;;A if G;;.Map) ){ #deBruijn(I +Int #dBsize(A) +Int size(#BV(G)) ;
                                            #sub(#mapify(I;#bvar(A);.Map);P) ; 
                                            updateMap(Mem,#mapify(I;#bvar(A);.Map)) ) }

  // Binds
  rule #deBruijn( I:Int ;; <- X:Name ;; Mem:Map ) => <- #deBruijn(I;X;Mem)
  rule #deBruijn( I:Int ;; A:Lbind   ;; Mem:Map )
    => #dBound(I;#bvar(A);.Map) <- #deBruijn(I +Int size(#LV(A));#chan(A);Mem) [owise]
  rule #deBruijn( I:Int ;; A:Lbind ; B:Lbind  ;; Mem:Map )
    => #deBruijn(I;;A;;Mem) ; #deBruijn(I +Int #dBsize(A);;B;;Mem)
  rule #deBruijn( I:Int ;; A:Lbind ; B:Lbinds ;; Mem:Map )
    => #deBruijn(I;;A;;Mem) ; #deBruijn(I +Int #dBsize(A);;B;;Mem)

  rule #deBruijn( I:Int ;; <<- X:Name ;; Mem:Map ) => <<- #deBruijn(I;X;Mem)
  rule #deBruijn( I:Int ;; A:Pbind   ;; Mem:Map )
    => #dBound(I;#bvar(A);.Map) <<- #deBruijn(I +Int size(#LV(A));#chan(A);Mem) [owise]
  rule #deBruijn( I:Int ;; A:Pbind ; B:Pbind  ;; Mem:Map )
    => #deBruijn(I;;A;;Mem) ; #deBruijn(I +Int #dBsize(A);;B;;Mem)
  rule #deBruijn( I:Int ;; A:Pbind ; B:Pbinds ;; Mem:Map )
    => #deBruijn(I;;A;;Mem) ; #deBruijn(I +Int #dBsize(A);;B;;Mem)

  rule #deBruijn( I:Int ;; <= X:Name ;; Mem:Map ) => <= #deBruijn(I;X;Mem)
  rule #deBruijn( I:Int ;; A:Rbind   ;; Mem:Map )
    => #dBound(I;#bvar(A);.Map) <= #deBruijn(I +Int size(#LV(A));#chan(A);Mem) [owise]
  rule #deBruijn( I:Int ;; A:Rbind ; B:Rbind  ;; Mem:Map )
    => #deBruijn(I;;A;;Mem) ; #deBruijn(I +Int #dBsize(A);;B;;Mem)
  rule #deBruijn( I:Int ;; A:Rbind ; B:Rbinds ;; Mem:Map )
    => #deBruijn(I;;A;;Mem) ; #deBruijn(I +Int #dBsize(A);;B;;Mem)

  rule #deBruijn( I:Int ;; B:Lbind if G:BExp ;; Mem:Map )
    => #deBruijn(I;;B;;Mem)
       if #deBruijn(I +Int #dBsize(B);#sub(#mapify(I;#bvar(B);.Map);G);Mem)
  rule #deBruijn( I:Int ;; B:Lbinds if G:BExp ;; Mem:Map )
    => #deBruijn(I;;B;;Mem)
       if #deBruijn(I +Int #dBsize(B);#sub(#mapify(I;#bvar(B);.Map);G);Mem)
  rule #deBruijn( I:Int ;; B:Pbind if G:BExp ;; Mem:Map )
    => #deBruijn(I;;B;;Mem)
       if #deBruijn(I +Int #dBsize(B);#sub(#mapify(I;#bvar(B);.Map);G);Mem)
  rule #deBruijn( I:Int ;; B:Pbinds if G:BExp ;; Mem:Map )
    => #deBruijn(I;;B;;Mem)
       if #deBruijn(I +Int #dBsize(B);#sub(#mapify(I;#bvar(B);.Map);G);Mem)
  rule #deBruijn( I:Int ;; B:Rbind if G:BExp ;; Mem:Map )
    => #deBruijn(I;;B;;Mem)
       if #deBruijn(I +Int #dBsize(B);#sub(#mapify(I;#bvar(B);.Map);G);Mem)
  rule #deBruijn( I:Int ;; B:Rbinds if G:BExp ;; Mem:Map )
    => #deBruijn(I;;B;;Mem)
       if #deBruijn(I +Int #dBsize(B);#sub(#mapify(I;#bvar(B);.Map);G);Mem)

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
  // Vars
    // nothing happens if Var is free/fresh w.r.t. Mem
    // if Var is bound w.r.t. Mem (i.e. is a key), replace it with the corresponding value
    // #sub(Map;Name) takes care of both situations
  rule #deBruijn( _:Int ; N:Var ; Mem:Map ) => #sub(Mem;N)
  rule #deBruijn( _:Int ; N:Var ( _:Uri ) ; Mem:Map ) => #sub(Mem;N)

  // ProcVar
    // nothing happens if ProcVar is free/fresh w.r.t. Mem
    // if ProcVar is bound w.r.t. Mem (i.e. is a key), replace it with the corresponding value
  rule #deBruijn( _:Int ; \P:Var ; Mem:Map ) => #sub(Mem;\P)

// Collections
  // RhoList
  rule #deBruijn( _:Int ; [ ] ; _:Map ) => [ ]
  rule #deBruijn( I:Int ; [ P:Procs ] ; Mem:Map ) => [ #deBruijn(I;P;Mem) ]

  // RhoMap
  rule #deBruijn( _:Int ; { } ; _:Map ) => { }
  rule #deBruijn( I:Int ; { KVs:RhoKVPairs } ; Mem:Map ) => { #deBruijn(I;KVs;Mem) }
    // KVPairs
  rule #deBruijn( I:Int ;  A:Proc : B:Proc ; Mem:Map ) => #deBruijn(I;A;Mem) : #deBruijn(I +Int size(#BV(A));B;Mem)
  rule #deBruijn( I:Int ;  A:RhoKVPair , B:RhoKVPairs ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)

  // RhoSet
  rule #deBruijn( _:Int ; Set( ) ; _:Map ) => Set( )
  rule #deBruijn( I:Int ; Set( P:Procs ) ; Mem:Map ) => Set( #deBruijn(I;P;Mem) )

  // RhoTuple
//  rule #deBruijn( _:Int ; ( ) ; _:Map ) => ( )
  rule #deBruijn( I:Int ; ( P:Procs ,) ; Mem:Map ) => ( #deBruijn(I;P;Mem) ,)

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
  rule #deBruijn( I:Int ; A:Name , B:Names ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)

// Several Procs
  // Lists of to-be-bound Procs appear in Collections and Sends...
  // want to do something like
  rule #deBruijn( I:Int ; A:Proc , B:Procs ; Mem:Map ) => #deBruijn(I;A;Mem) , #deBruijn(I +Int size(#BV(A));B;Mem)

//-------------------------
//--- Nested Constructs ---
//-------------------------
// Ground & bound terms
  rule #deBruijn( _:Int , _:Int ; A:Ground    ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundName ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundProc ; _:Map ) => A

// Parallel Composition
// Mem map propogates to both branchs
  rule #deBruijn( I:Int , J:Int ; P:Proc | Q:Proc ; Mem:Map ) => #deBruijn(I,J;P;Mem) | #deBruijn(I,J +Int size(#BV(P));Q;Mem)

// Receives
  // listening variables become boundN(I) with the appropriate index and are guarded during De Bruijn indexing
  // SRec
    // Linear
  rule #deBruijn( I:Int , J:Int ; for( <- X:Name ){ P:Proc } ; Mem:Map )
    => for( <- #deBruijn(I,J;X;Mem) ){ #deBruijn(I,J +Int size(#BV(X));P;Mem) }
  rule #deBruijn( I:Int , J:Int ; for( B:Lbind   ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;#bvar(B);.Map) <- #deBruijn(I,J +Int size(#LV(B));#chan(B);Mem) ){
              #deBruijn(I,J +Int #dBsize(B) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I,J;#bvar(B);.Map) )) } [owise]
  rule #deBruijn( I:Int , J:Int ; for( <- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( <- #deBruijn(I,J;X;Mem) if #deBruijn(I,J +Int size(#BV(X));G;Mem) ){ #deBruijn(I,J +Int size(#BV(X)) +Int size(#BV(G));P;Mem) }
  rule #deBruijn( I:Int , J:Int ; for( B:Lbind   if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;#bvar(B);.Map) <- #deBruijn(I,J +Int size(#LV(B));#chan(B);Mem) if #sub(#mapify(I,J;#bvar(B);.Map);G) ){
              #deBruijn(I,J +Int #dBsize(B) +Int size(#BV(G)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I,J;#bvar(B);.Map) )) } [owise]
    // Peek
  rule #deBruijn( I:Int , J:Int ; for( <<- X:Name ){ P:Proc } ; Mem:Map )
    => for( <<- #deBruijn(I,J;X;Mem) ){ #deBruijn(I,J +Int size(#BV(X));P;Mem) }
  rule #deBruijn( I:Int , J:Int ; for( B:Pbind   ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;#bvar(B);.Map) <<- #deBruijn(I,J +Int size(#LV(B));#chan(B);Mem) ){
              #deBruijn(I,J +Int #dBsize(B) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I,J;#bvar(B);.Map) )) } [owise]
  rule #deBruijn( I:Int , J:Int ; for( <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( <<- #deBruijn(I,J;X;Mem) if #deBruijn(I,J +Int size(#BV(X));G;Mem) ){ #deBruijn(I,J +Int size(#BV(X)) +Int size(#BV(G));P;Mem) }
  rule #deBruijn( I:Int , J:Int ; for( B:Pbind   if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;#bvar(B);.Map) <<- #deBruijn(I,J +Int size(#LV(B));#chan(B);Mem) if #sub(#mapify(I,J;#bvar(B);.Map);G) ){
              #deBruijn(I,J +Int #dBsize(B) +Int size(#BV(G)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I,J;#bvar(B);.Map) )) } [owise]
    // Repeat
  rule #deBruijn( I:Int , J:Int ; for( <= X:Name ){ P:Proc } ; Mem:Map )
    => for( <= #deBruijn(I,J;X;Mem) ){ #deBruijn(I,J +Int size(#BV(X));P;Mem) }
  rule #deBruijn( I:Int , J:Int ; for( B:Rbind   ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;#bvar(B);.Map) <= #deBruijn(I,J +Int size(#LV(B));#chan(B);Mem) ){
              #deBruijn(I,J +Int #dBsize(B) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I,J;#bvar(B);.Map) )) } [owise]
  rule #deBruijn( I:Int , J:Int ; for( <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( <= #deBruijn(I,J;X;Mem) if #deBruijn(I,J +Int size(#BV(X));G;Mem) ){ #deBruijn(I,J +Int size(#BV(X)) +Int size(#BV(G));P;Mem) }
  rule #deBruijn( I:Int , J:Int ; for( B:Rbind   if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;#bvar(B);.Map) <= #deBruijn(I,J +Int size(#LV(B));#chan(B);Mem) if #sub(#mapify(I,J;#bvar(B);.Map);G) ){
              #deBruijn(I,J +Int #dBsize(B) +Int size(#BV(G)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(I,J;#bvar(B);.Map) )) } [owise]

  // MRec
    // unguarded
  rule #deBruijn( I:Int , J:Int ; for( A:Lbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A;;.Map) ){ #deBruijn(I,J +Int #dBoundSize(A) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int , J:Int ; for( A:Pbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A;;.Map) ){ #deBruijn(I,J +Int #dBoundSize(A) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int , J:Int ; for( A:Rbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A;;.Map) ){ #deBruijn(I,J +Int #dBoundSize(A) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
    // guarded
  rule #deBruijn( I:Int , J:Int ; for( A:Lbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A if G;;.Map) ){ #deBruijn(I,J +Int #dBoundSize(A) +Int size(#BV(G)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int , J:Int ; for( A:Pbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A if G;;.Map) ){ #deBruijn(I,J +Int #dBoundSize(A) +Int size(#BV(G)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }
  rule #deBruijn( I:Int , J:Int ; for( A:Rbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;;A if G;;.Map) ){ #deBruijn(I,J +Int #dBoundSize(A) +Int size(#BV(G)) ;
                                             #sub( #dBound(I,J;#bvar(A);.Map) ; #bvar(A) ; P ) ;
                                             updateMap(Mem,#mapify(I,J;#bvar(A);.Map)) ) }

// Sends
// map constant on channel and message(s) -- check channel for bound variables
  rule #deBruijn( I:Int , J:Int ; X:Name !  ( P:Procs ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !  ( #deBruijn(I,J +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !  (         ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !  ( )
  rule #deBruijn( I:Int , J:Int ; X:Name !! ( P:Procs ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !! ( #deBruijn(I,J +Int size(#BV(X));P;Mem) )
  rule #deBruijn( I:Int , J:Int ; X:Name !! (         ) ; Mem:Map ) => #deBruijn(I,J;X;Mem) !! ( )

// Eval -- just goes inside
  rule #deBruijn( I:Int , J:Int ; *X:Name ; Mem:Map ) => * #deBruijn(I,J;X;Mem)

// Variables
  // Vars
    // nothing happens if Var is free w.r.t. Mem
    // if Var is bound w.r.t. Mem, replace it with its value
  rule #deBruijn( _:Int , _:Int ; N:Var ; Mem:Map ) => #sub(Mem;N)

  // ProcVars
    // nothing happens if ProcVar is free w.r.t. Mem
    // if ProcVar is bound w.r.t. Mem, replace it with its value
  rule #deBruijn( _:Int , _:Int ; \P:Var ; Mem:Map ) => #sub(Mem;\P)

// Collections
  // RhoList
  rule #deBruijn( _:Int , _:Int ; [ ] ; _:Map ) => [ ]
  rule #deBruijn( I:Int , J:Int ; [ P:Procs ] ; Mem:Map ) => [ #deBruijn(I,J;P;Mem) ]

  // RhoMap

  // RhoSet
  rule #deBruijn( _:Int , _:Int ; Set( ) ; _:Map ) => Set( )
  rule #deBruijn( I:Int , J:Int ; Set( P:Procs ) ; Mem:Map ) => Set( #deBruijn(I,J;P;Mem) )

  // RhoTuple
  rule #deBruijn( I:Int , J:Int ; ( P:Procs ,) ; Mem:Map ) => ( #deBruijn(I,J;P;Mem) ,)

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
  rule #deBruijn( I:Int , J:Int ; A:Name , B:Names ; Mem:Map ) => #deBruijn(I,J;A;Mem) , #deBruijn(I,J +Int size(#BV(A));B;Mem)

// Several Procs
  // Lists of to-be-bound Procs appear in Collections and Sends...
  // want to do something like
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
  rule #dBound( I:Int ;    _:Var     ;   _:Map ) =>  boundN(I)
  rule #dBound( I:Int ; @\(_:Var)    ;   _:Map ) => @boundP(I)
  rule #dBound( I:Int ; @P:Proc      ; Mem:Map ) => @#dBound(I;P;Mem) requires notBool isProcVar(P)
  rule #dBound( I:Int ; @P:ProcPat   ; Mem:Map ) => @#dBound(I;P;Mem) requires notBool isProcVar(P)
  rule #dBound( _:Int ;  B:BoundName ;   _:Map ) => B
  rule #dBound( _:Int ; \_           ;   _:Map ) => \_

  rule #dBound( _:Int ; A:SimplePat  ; _:Map ) => A
  rule #dBound( I:Int ; A:Proc    /\ B:ProcPat ; Mem:Map ) => #dBound(I;A;Mem) /\ #dBound(I;B;Mem)
  rule #dBound( I:Int ; A:ProcPat /\ B:Proc    ; Mem:Map ) => #dBound(I;A;Mem) /\ #dBound(I;B;Mem)
  rule #dBound( I:Int ; A:ProcPat /\ B:ProcPat ; Mem:Map ) => #dBound(I;A;Mem) /\ #dBound(I;B;Mem)
  rule #dBound( I:Int ; A:Proc    \/ B:ProcPat ; Mem:Map ) => #dBound(I;A;Mem) \/ #dBound(I;B;Mem)
  rule #dBound( I:Int ; A:ProcPat \/ B:Proc    ; Mem:Map ) => #dBound(I;A;Mem) \/ #dBound(I;B;Mem)
  rule #dBound( I:Int ; A:ProcPat \/ B:ProcPat ; Mem:Map ) => #dBound(I;A;Mem) \/ #dBound(I;B;Mem)

  // several Names
  rule #dBound( I:Int ; A:Name    , B:Names    ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:NamePat , B:Names    ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:Name    , B:NamePats ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:NamePat , B:NamePats ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)

// Binds
  // Linear
    // unguarded
  rule #dBound( I:Int ;; <- X:Name  ;; Mem:Map ) =>  <- #dBound(I;X;Mem)
  rule #dBound( I:Int ;;    B:Lbind ;; Mem:Map ) => #dBound(1,0;#bvar(B);.Map) <- #dBound(I;#sub(Mem;#chan(B));Mem) [owise]
  rule #dBound( I:Int ;; A:Lbind ; B:Lbind  ;; Mem:Map ) => #dBound(I;;A;;.Map) ; #dBound+(I +Int size(#RV(A));size(#LV(A));;B;;Mem)
  rule #dBound( I:Int ;; A:Lbind ; B:Lbinds ;; Mem:Map ) => #dBound(I;;A;;.Map) ; #dBound+(I +Int size(#RV(A));size(#LV(A));;B;;Mem)
  rule #dBound+( I:Int ; _:Int ;; <- X:Name ;; Mem:Map ) =>  <- #dBound(I;X;Mem)
  rule #dBound+( I:Int ; J:Int ;; A:Lbind   ;; Mem:Map ) => #dBound(1,J;#bvar(A);.Map) <- #dBound(I;#sub(Mem;#chan(A));Mem) [owise]
  rule #dBound+( I:Int ; J:Int ;; A:Lbind ; B:Lbind  ;; Mem:Map )
    => #dBound(1,J;#bvar(A);.Map) <- #dBound(I;#chan(A);Mem) ; #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B;;Mem)
  rule #dBound+( I:Int ; J:Int ;; A:Lbind ; B:Lbinds ;; Mem:Map )
    => #dBound(1,J;#bvar(A);.Map) <- #dBound(I;#chan(A);Mem) ; #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B;;Mem)
    // guarded
//  rule #dBound( I:Int ;; B:Lbind  if G:BExp ;; Mem:Map )
//    => #dBound(I;;B;;.Map) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B);.Map);G);Mem)
//  rule #dBound( I:Int ;; B:Lbinds if G:BExp ;; Mem:Map )
//    => #dBound(I;;B;;.Map) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B);.Map);G);Mem)

  // Peek
    // unguarded
  rule  #dBound( I:Int ;; <<- X:Name ;; Mem:Map ) =>  <<- #dBound(I;X;Mem)
  rule  #dBound( I:Int ;;    B:Pbind ;; Mem:Map ) => #dBound(1,0;#bvar(B);.Map) <<- #dBound(I;#sub(Mem;#chan(B));Mem) [owise]
  rule  #dBound( I:Int ;; A:Pbind ; B:Pbind  ;; Mem:Map ) => #dBound(I;;A;;.Map) ; #dBound+(I +Int size(#RV(A));size(#LV(A));;B;;Mem)
  rule  #dBound( I:Int ;; A:Pbind ; B:Pbinds ;; Mem:Map ) => #dBound(I;;A;;.Map) ; #dBound+(I +Int size(#RV(A));size(#LV(A));;B;;Mem)
  rule #dBound+( I:Int ; _:Int ;; <<- X:Name ;; Mem:Map ) =>  <<- #dBound(I;X;Mem)
  rule #dBound+( I:Int ; J:Int ;; A:Pbind    ;; Mem:Map ) => #dBound(1,J;#bvar(A);.Map) <<- #dBound(I;#sub(Mem;#chan(A));Mem) [owise]
  rule #dBound+( I:Int ; J:Int ;; A:Pbind ; B:Pbind  ;; Mem:Map )
    =>  #dBound(1,J;#bvar(A);.Map) <<- #dBound(I;#chan(A);Mem) ; #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B;;Mem)
  rule #dBound+( I:Int ; J:Int ;; A:Pbind ; B:Pbinds ;; Mem:Map )
    =>  #dBound(1,J;#bvar(A);.Map) <<- #dBound(I;#chan(A);Mem) ; #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B;;Mem)
    // guarded
//  rule #dBound( I:Int ;; B:Pbind  if G:BExp ;; Mem:Map )
//    => #dBound(I;;B;;.Map) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B);.Map);G);Mem)
//  rule #dBound( I:Int ;; B:Pbinds if G:BExp ;; Mem:Map )
//    => #dBound(I;;B;;.Map) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B);.Map);G);Mem)

  // Repeat
    // unguarded
  rule  #dBound( I:Int ;; <= X:Name  ;; Mem:Map ) =>  <= #dBound(I;X;Mem)
  rule  #dBound( I:Int ;;    B:Rbind ;; Mem:Map ) => #dBound(1,0;#bvar(B);.Map) <= #dBound(I;#sub(Mem;#chan(B));Mem) [owise]
  rule  #dBound( I:Int ;; A:Rbind ; B:Rbind  ;; Mem:Map ) => #dBound(I;;A;;.Map) ; #dBound+(I +Int size(#RV(A));size(#LV(A));;B;;Mem)
  rule  #dBound( I:Int ;; A:Rbind ; B:Rbinds ;; Mem:Map ) => #dBound(I;;A;;.Map) ; #dBound+(I +Int size(#RV(A));size(#LV(A));;B;;Mem)
  rule #dBound+( I:Int ; _:Int ;; <= X:Name  ;; Mem:Map ) =>  <= #dBound(I;X;Mem)
  rule #dBound+( I:Int ; J:Int ;; A:Rbind    ;; Mem:Map ) => #dBound(1,J;#bvar(A);.Map) <= #dBound(I;#sub(Mem;#chan(A));Mem) [owise]
  rule #dBound+( I:Int ; J:Int ;; A:Rbind ; B:Rbind  ;; Mem:Map )
    =>  #dBound(1,J;#bvar(A);.Map) <= #dBound(I;#chan(A);Mem) ; #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B;;Mem)
  rule #dBound+( I:Int ; J:Int ;; A:Rbind ; B:Rbinds ;; Mem:Map )
    =>  #dBound(1,J;#bvar(A);.Map) <= #dBound(I;#chan(A);Mem) ; #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B;;Mem)
    // guarded
//  rule #dBound( I:Int ;; B:Rbind  if G:BExp ;; Mem:Map )
//    => #dBound(I;;B;;.Map) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B);.Map);G);Mem)
//  rule #dBound( I:Int ;; B:Rbinds if G:BExp ;; Mem:Map )
//    => #dBound(I;;B;;.Map) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B);.Map);G);Mem)

// Proc
  rule #dBound( _:Int ;  G:Ground    ; _:Map   ) =>  G
  rule #dBound( I:Int ; \(_:Var)     ; _:Map   ) =>  boundP(I)
  rule #dBound( I:Int ; *N:Var       ; _:Map   ) => *boundN(I)
  rule #dBound( I:Int ; *N:Name      ; Mem:Map ) => *#dBound(I;N;Mem)
  rule #dBound( _:Int ;  B:BoundProc ; _:Map   ) =>  B

  // Send
  rule #dBound( I:Int ; A:Name    !  ( B:ProcPats ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:Name    !  ( B:Procs    ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:Name    !  (            ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( )
  rule #dBound( I:Int ; A:NamePat !  ( B:ProcPats ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:NamePat !  ( B:Procs    ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:NamePat !  (            ) ; Mem:Map ) => #dBound(I;A;Mem) !  ( )
  rule #dBound( I:Int ; A:Name    !! ( B:ProcPats ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:Name    !! ( B:Procs    ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:Name    !! (            ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( )
  rule #dBound( I:Int ; A:NamePat !! ( B:ProcPats ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:NamePat !! ( B:Procs    ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( #dBound(I +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int ; A:NamePat !! (            ) ; Mem:Map ) => #dBound(I;A;Mem) !! ( )

  // Receive -- increase nesting index for bound Names
  // Linear
    // Single
      // unguarded
  rule #dBound( I:Int ; for( B:Lbind ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;;B;;Mem) ){
         #dBound(I +Int size(#RV(B)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ;
           updateMap( Mem , #mapify(1,0;#bvar(B);.Map) #mapify(I;;B;;.Map) )) }
      // guarded
  rule #dBound( I:Int ; for( B:Lbind if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;;B;;Mem) if #sub(#mapify(1,0;#bvar(B);.Map);G) ){
         #dBound(I +Int size(#RV(B)) +Int size(#FV(G)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ;
           updateMap( Mem , #mapify(1,0;#bvar(B);.Map) )) }
    // Multi
      // unguarded
  rule #dBound( I:Int ; for( B:Lbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;B;;.Map) ){ 
         #dBound(I +Int size(#RV(B)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ;
           updateMap(Mem,#mapify(1,0;#bvar(B);.Map)) ) }
      // guarded
  rule #dBound( I:Int ; for( B:Lbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;B if G;;.Map) ){ 
         #dBound(I +Int size(#RV(B)) +Int size(#FV(G)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ; 
           updateMap(Mem,#mapify(1,0;#bvar(B);.Map)) ) }

  // Repeated
    // Single
      // unguarded
  rule #dBound( I:Int ; for( B:Rbind ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;;B;;Mem) ){
              #dBound(I +Int size(#RV(B)) ;
              #sub(#mapify(1,0;#bvar(B);.Map);P) ;
              updateMap( Mem , #mapify(1,0;#bvar(B);.Map) )) }
      // guarded
  rule #dBound( I:Int ; for( B:Rbind if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;;B if G;;Mem) ){
         #dBound(I +Int size(#RV(B)) +Int size(#FV(G)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ;
           updateMap( Mem , #mapify(1,0;#bvar(B);.Map) )) }
    // Multi
      // unguarded
  rule #dBound( I:Int ; for( B:Rbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;B;;.Map) ){ 
         #dBound(I +Int size(#RV(B)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ;
           updateMap(Mem,#mapify(1,0;#bvar(B);.Map)) ) }
      // guarded
  rule #dBound( I:Int ; for( B:Rbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;B if G;;.Map) ){ 
         #dBound(I +Int size(#RV(B)) +Int size(#FV(G)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ; 
           updateMap(Mem,#mapify(1,0;#bvar(B);.Map)) ) }

  // Peek
    // Single
      // unguarded
  rule #dBound( I:Int ; for( B:Pbind ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;;B;;Mem) ){
         #dBound(I +Int size(#RV(B)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ;
           updateMap( Mem , #mapify(1,0;#bvar(B);.Map) )) }
      // guarded
  rule #dBound( I:Int ; for( B:Pbind if G:BExp ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I;;B if G;;Mem) ){
         #dBound(I +Int size(#RV(B)) +Int size(#FV(G)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ;
           updateMap( Mem , #mapify(1,0;#bvar(B);.Map) )) }
    // Multi
      // unguarded
  rule #dBound( I:Int ; for( B:Pbinds ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;B;;.Map) ){ 
         #dBound(I +Int size(#RV(B)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ;
           updateMap(Mem,#mapify(1,0;#bvar(B);.Map)) ) }
      // guarded
  rule #dBound( I:Int ; for( B:Pbinds if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I;;B if G;;.Map) ){ 
         #dBound(I +Int size(#RV(B)) +Int size(#FV(G)) ;
           #sub(#mapify(1,0;#bvar(B);.Map);P) ; 
           updateMap(Mem,#mapify(1,0;#bvar(B);.Map)) ) }

  // Par -- index A & increase index for B by size(#FV(A))
  rule #dBound( I:Int ; A:Proc | B:Proc ; Mem:Map ) => #dBound(I;A;Mem) | #dBound(I +Int size(#FV(A));B;Mem) requires notBool isPar(A)

  // New -- increase level
  rule #dBound( _:Int ; A:New ; Mem:Map ) => #deBruijn(1,0;A;.Map)

  rule #dbNew( I:Int ; A:Names ) => #dBound(I;#set2names(#names2set(A));.Map)

 // Collection
  rule #dBound( _:Int ; [ ] ; _:Map ) => [ ]
  rule #dBound( I:Int ; [ A:Procs ]  ; Mem:Map ) => [ #dBound(I;A;Mem) ]

  // applied after normalization
  rule #dBound( _:Int ; { } ; _:Map ) => { }
//rule #mapify( I:Int ; { A:RhoKVPairs } ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

  // applied after normalization
  rule #dBound( _:Int ; Set( ) ; _:Map ) => Set( )
  rule #dBound( I:Int ; Set( A:Procs )  ; Mem:Map ) => Set( #dBound(I;A;Mem) )
//  rule #dBound( I:Int ; Set( A:ProcPats )  ; Mem:Map ) => Set( #dBound(I;A;Mem) )

  rule #dBound( I:Int ; ( A:Procs ,) ; Mem:Map ) => ( #dBound(I;A;Mem) ,)
//  rule #dBound( I:Int ; ( A:ProcPatss ,) ; Mem:Map ) => ( #dBound(I;A;Mem) ,)

  // several Names -- increase index for each name (if not already bound)
  rule #dBound( I:Int ; A:Name    , B:Names    ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:Name    , B:NamePats ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:NamePat , B:Names    ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:NamePat , B:NamePats ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)

  // several Procs -- increase index for each name (if not already bound)
  rule #dBound( I:Int ; A:Proc    , B:Procs    ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:Proc    , B:ProcPats ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:ProcPat , B:Procs    ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)
  rule #dBound( I:Int ; A:ProcPat , B:ProcPats ; Mem:Map ) => #dBound(I;A;Mem) , #dBound(I +Int size(#FV(A));B;Mem)

// Nested
  // Name
  rule #dBound( I:Int , J:Int ;  _:Var       ;   _:Map ) =>   boundN(I,J)
  rule #dBound( I:Int , J:Int ; @P:Proc      ; Mem:Map ) => @#dBound(I,J;P;Mem)
  rule #dBound( _:Int , _:Int ;  B:BoundName ;   _:Map ) =>   B

    // several Names
  rule #dBound( I:Int , J:Int ; A:Name , B:Names ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound(I,J +Int size(#FV(A));B;Mem)

// Binds -- TODO: guards
  // single -- increase level & restart index at new level on variables
    // unguarded
  rule #dBound( I:Int , J:Int ;; Y:NamePats <-  X:Name ;; Mem:Map ) => #dBound(I +Int 1,0;Y;Mem) <- #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:Names    <-  X:Name ;; Mem:Map ) => #dBound(I +Int 1,0;Y;Mem) <- #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;;            <-  X:Name ;; Mem:Map ) =>  <- #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:NamePats <=  X:Name ;; Mem:Map ) => #dBound(I +Int 1,0;Y;Mem) <= #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:Names    <=  X:Name ;; Mem:Map ) => #dBound(I +Int 1,0;Y;Mem) <= #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;;            <=  X:Name ;; Mem:Map ) =>  <= #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:NamePats <<- X:Name ;; Mem:Map ) => #dBound(I +Int 1,0;Y;Mem) <<- #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;; Y:Names    <<- X:Name ;; Mem:Map ) => #dBound(I +Int 1,0;Y;Mem) <<- #dBound(I,J;X;Mem)
  rule #dBound( I:Int , J:Int ;;            <<- X:Name ;; Mem:Map ) =>  <<- #dBound(I,J;X;Mem)
    // guarded
//  rule #dBound( I:Int , J:Int ;; B:Lbind if G:BExp ;; Mem:Map )
//    => #dBound(I,J;;B;;Mem) if #dBound(I,J +Int size(#BV(#chan(B)));#sub(#mapify(I +Int 1,0;#bvar(B);.Map);G);Mem)

//  rule #dBound( I:Int , J:Int ;; B:Pbind if G:BExp ;; Mem:Map )
//    => #dBound(I,J;;B;;Mem) if #dBound(I,J +Int size(#BV(#chan(B)));#sub(#mapify(I +Int 1,0;#bvar(B);.Map);G);Mem)

//  rule #dBound( I:Int , J:Int ;; B:Rbind if G:BExp ;; Mem:Map )
//    => #dBound(I,J;;B;;Mem) if #dBound(I,J +Int size(#BV(#chan(B)));#sub(#mapify(I +Int 1,0;#bvar(B);.Map);G);Mem)

  // multiple -- TODO: check levels
    // unguarded
  rule #dBound( I:Int , J:Int ;; A:Lbind ; B:Lbind  ;; Mem:Map ) => #dBound(I,J;;A;;Mem) ; #dBound(I,J +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Lbind ; B:Lbinds ;; Mem:Map ) => #dBound(I,J;;A;;Mem) ; #dBound(I,J +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Pbind ; B:Pbind  ;; Mem:Map ) => #dBound(I,J;;A;;Mem) ; #dBound(I,J +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Pbind ; B:Pbinds ;; Mem:Map ) => #dBound(I,J;;A;;Mem) ; #dBound(I,J +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Rbind ; B:Rbind  ;; Mem:Map ) => #dBound(I,J;;A;;Mem) ; #dBound(I,J +Int size(#LV(A));;B;;Mem)
  rule #dBound( I:Int , J:Int ;; A:Rbind ; B:Rbinds ;; Mem:Map ) => #dBound(I,J;;A;;Mem) ; #dBound(I,J +Int size(#LV(A));;B;;Mem)
    // guarded
//  rule #dBound( I:Int , J:Int ;; A:Lbinds if G:BExp ;; Mem:Map )
//    => #dBound(I,J;;A;;Mem) if #dBound(I,J +Int #dBoundSize(A);#sub(#dBound(I,J;#bvar(A);Mem);#bvar(A);G);Mem)

//  rule #dBound( I:Int , J:Int ;; A:Pbinds if G:BExp ;; Mem:Map )
//    => #dBound(I,J;;A;;Mem) if #dBound(I,J +Int #dBoundSize(A);#sub(#dBound(I,J;#bvar(A);Mem);#bvar(A);G);Mem)

//  rule #dBound( I:Int , J:Int ;; A:Rbinds if G:BExp ;; Mem:Map )
//    => #dBound(I,J;;A;;Mem) if #dBound(I,J +Int #dBoundSize(A);#sub(#dBound(I,J;#bvar(A);Mem);#bvar(A);G);Mem)

  // Proc
  rule #dBound( _:Int , _:Int ;   G:Ground    ;   _:Map ) =>   G
  rule #dBound( I:Int , J:Int ; \(_:Var)      ;   _:Map ) =>   boundP(I,J)
  rule #dBound( I:Int , J:Int ;  *N:Name      ; Mem:Map ) => *#dBound(I,J;N;Mem)
  rule #dBound( _:Int , _:Int ;   B:BoundProc ;   _:Map ) =>   B

    // Send
  rule #dBound( I:Int , J:Int ; A:Name !  ( B:ProcPats ) ; Mem:Map ) => #dBound(I,J;A;Mem) ! ( #dBound(I,J +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int , J:Int ; A:Name !  ( B:Procs    ) ; Mem:Map ) => #dBound(I,J;A;Mem) ! ( #dBound(I,J +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int , J:Int ; A:Name !  (            ) ; Mem:Map ) => #dBound(I,J;A;Mem) ! (  )
  rule #dBound( I:Int , J:Int ; A:Name !! ( B:ProcPats ) ; Mem:Map ) => #dBound(I,J;A;Mem) !!( #dBound(I,J +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int , J:Int ; A:Name !! ( B:Procs    ) ; Mem:Map ) => #dBound(I,J;A;Mem) !!( #dBound(I,J +Int size(#FV(A));B;Mem) )
  rule #dBound( I:Int , J:Int ; A:Name !! (            ) ; Mem:Map ) => #dBound(I,J;A;Mem) !!(  )

    // Receive -- increase nesting index for bound Names
  // linear
    // no listening variables
  rule #dBound( I:Int , J:Int ; for( B:Lbind ){ P:Proc } ; Mem:Map ) 
    => for( #dBound(I,J;;B;;Mem) ){ #dBound(I,J +Int size(#RV(B));#sub(#mapify(I,J;;B;;Mem);P); updateMap( Mem , #mapify(I,J;;B;;Mem) )) }
    // listening for Var
      // if Var is fresh w.r.t. Mem, do usual substitution for Var
      // if Var is not fresh w.r.t. Mem, substitute for the value associated with Var
  rule #dBound( I:Int , J:Int ; for( Y:Var <- X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <- #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Var <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
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
    // listening for Var
      // if Var is fresh w.r.t. Mem, do usual substitution for Var
      // if Var is not fresh w.r.t. Mem, substitute for the value associated with Var
  rule #dBound( I:Int , J:Int ; for( Y:Var <= X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <= #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Var <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <= #dBound(I,J;X;Mem) if #sub(boundN(I +Int 1,0);#sub(Mem;Y);B) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <= #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)); #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <= #dBound(I,J;X;Mem) if #sub(boundP(I +Int 1,0);#sub(Mem;Y);G) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <= #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <= #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;G) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
    // several Name listens
  rule #dBound( I:Int , J:Int ; for( Y:Names <= X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <= #dBound(I +Int 1,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Names <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <= #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;G) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }

  // peek
    // no listening variables
  rule #dBound( I:Int , J:Int ; for(  <<- X:Name ){ P:Proc } ; Mem:Map ) 
    => for( <<- #dBound(I,J;X;Mem) ){ #dBound(I,J +Int size(#FV(X));P;Mem) }
    // listening for Var
      // if Var is fresh w.r.t. Mem, do usual substitution for Var
      // if Var is not fresh w.r.t. Mem, substitute for the value associated with Var
  rule #dBound( I:Int , J:Int ; for( Y:Var <<- X:Name ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <<- #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Var <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( boundN(I +Int 1,0) <<- #dBound(I,J;X;Mem) if #sub(boundN(I +Int 1,0);#sub(Mem;Y);G) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundN(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundN(I +Int 1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <<- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <<- #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)); #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ boundP(I +Int 1,0) <<- #dBound(I,J;X;Mem) if #sub(boundP(I +Int 1,0);#sub(Mem;Y);G) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(boundP(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> boundP(I +Int 1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <<- X:Name ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <<- #dBound(I,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @ #dBound(I +Int 1,0;Y;.Map) <<- #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;G) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
    // several Name listens
  rule #dBound( I:Int , J:Int ; for( Y:Names <<- X:Name ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <<- #dBound(I +Int 1,J;X;Mem) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Names <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I +Int 1,0;Y;.Map) <<- #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;G) ){ 
            #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }

  // Par
  rule #dBound( I:Int , J:Int ; A:Proc | B:Proc ; Mem:Map ) => #dBound(I,J;A;Mem) | #dBound(I,J +Int size(#FV(A));B;Mem) requires notBool isPar(A)

  // New
  rule #dBound( I:Int , _:Int ; A:New ; Mem:Map ) => #deBruijn(I +Int 1,0;A;.Map)

  // Procs
  rule #dBound( I:Int , J:Int ; A:Proc , B:Procs ; Mem:Map ) => #dBound(I,J;A;Mem) , #dBound(I,J +Int size(#FV(A));B;Mem)

//---------------
//--- #mapify ---
//---------------
// returns map from variables to De Bruijn indices

  // WildCard does not add any bindings
  rule #mapify( _:Int ; \_ ; Mem:Map ) => Mem

// Name
  rule #mapify( I:Int ; A:Var       ; Mem:Map ) => updateMap( Mem , A |-> boundN(I) )
  rule #mapify( _:Int ; _:BoundName ; Mem:Map ) => Mem
  rule #mapify( I:Int ; @A:Proc     ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )
  rule #mapify( _:Int ; @sub        ; Mem:Map ) => Mem

  // several Names -- updated maps because of New delcarations
  rule #mapify( I:Int ; A:Name    , B:Names    ; Mem:Map ) => updateMap( Mem , updateMap( #mapify(I;A;Mem) , #mapify(I +Int size(#FV(A));B;Mem) ) )
  rule #mapify( I:Int ; A:NamePat , B:Names    ; Mem:Map ) => updateMap( Mem , updateMap( #mapify(I;A;Mem) , #mapify(I +Int size(#FV(A));B;Mem) ) )
  rule #mapify( I:Int ; A:Name    , B:NamePats ; Mem:Map ) => updateMap( Mem , updateMap( #mapify(I;A;Mem) , #mapify(I +Int size(#FV(A));B;Mem) ) )
  rule #mapify( I:Int ; A:NamePat , B:NamePats ; Mem:Map ) => updateMap( Mem , updateMap( #mapify(I;A;Mem) , #mapify(I +Int size(#FV(A));B;Mem) ) )

// Proc
  rule #mapify( _:Int ;  _:Ground    ; Mem:Map ) => Mem
  rule #mapify( I:Int ; \A:Var       ; Mem:Map ) => updateMap( Mem , \A |-> boundP(I) )
  rule #mapify( _:Int ;  _:BoundProc ; Mem:Map ) => Mem
  rule #mapify( I:Int ; *A:Name      ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )
  rule #mapify( _:Int ;    sub       ; Mem:Map ) => Mem

  // several Procs -- no shadowing
  rule #mapify( I:Int ; A:Proc    , B:Procs    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:ProcPat , B:Procs    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Proc    , B:ProcPats ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:ProcPat , B:ProcPats ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )

  // New -- TODO: pattern
  rule #mapNew( I:Int ; A:Var           ) => A |-> boundN(I)
  rule #mapNew( I:Int ; A:Var ( _:Uri ) ) => A |-> boundN(I)
  rule #mapNew( I:Int ; A:Names ) => #mapify(I;#set2names(#names2set(A));.Map)

//  rule #mapify( I:Int ; new A:Var in { B:ProcPat } ; Mem:Map ) 
//    => updateMap( Mem , A |-> boundN(I) #mapify( I +Int 1 ; #sub(boundN(I);A;B) ; Mem ) )
//  rule #mapify( I:Int ; new A:Names   in { B:ProcPat } ; Mem:Map ) 
//    => updateMap( Mem , #mapify(I;A;.Map) #mapify( I +Int #length(A) ; #sub(#mapify(I;A;.Map);B) ; Mem ) )

  // Par
  rule #mapify( I:Int ; A:Proc    | B:Proc    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
       requires notBool isPar(A)
  rule #mapify( I:Int ; A:Proc    | B:ProcPat ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
       requires notBool isPar(A)
  rule #mapify( I:Int ; A:ProcPat | B:Proc    ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
       requires notBool isParPat(A)
  rule #mapify( I:Int ; A:ProcPat | B:ProcPat ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
       requires notBool isParPat(A)

  // Send
  rule #mapify( I:Int ; A:Name    !  ( B:ProcPats ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name    !  ( B:Procs    ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name    !  (            ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )
  rule #mapify( I:Int ; A:NamePat !  ( B:ProcPats ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:NamePat !  ( B:Procs    ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:NamePat !  (            ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )
  rule #mapify( I:Int ; A:Name    !! ( B:ProcPats ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name    !! ( B:Procs    ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:Name    !! (            ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )
  rule #mapify( I:Int ; A:NamePat !! ( B:ProcPats ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:NamePat !! ( B:Procs    ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int ; A:NamePat !! (            ) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

  // Receive
    // TODO: more testing
    // mapSub used to guard listening variables from generating additional substitution mappings
    // unguarded
  rule #mapify( I:Int ; for( <- X:Name  ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int ; for(   B:Lbind  ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B));#sub(#mapSub(#LV(B));P);updateMap(Mem,#mapify(I;#chan(B);.Map))) [owsie]
  rule #mapify( I:Int ; for(  B:Lbinds  ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B));#sub(#mapSub(#LV(B));P);updateMap(Mem,#mapify(I;#chan(B);.Map)))

  rule #mapify( I:Int ; for( <<- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int ; for(   B:Pbind ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B));#sub(#mapSub(#LV(B));P);updateMap(Mem,#mapify(I;#chan(B);.Map))) [owsie]
  rule #mapify( I:Int ; for(  B:Pbinds ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B));#sub(#mapSub(#LV(B));P);updateMap(Mem,#mapify(I;#chan(B);.Map)))

  rule #mapify( I:Int ; for( <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int ; for(   B:Rbind ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B));#sub(#mapSub(#LV(B));P);updateMap(Mem,#mapify(I;#chan(B);.Map))) [owsie]
  rule #mapify( I:Int ; for(  B:Rbinds ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B));#sub(#mapSub(#LV(B));P);updateMap(Mem,#mapify(I;#chan(B);.Map)))

    // guarded
  rule #mapify( I:Int ; for( <- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#FV(G));P;Mem)
  rule #mapify( I:Int ; for(   B:Lbind if G:BExp ){ P:Proc } ; Mem:Map )
    => #mapify(I +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B)) ;
               #sub(#mapSub(#LV(B));P) ;
               updateMap( Mem , #mapify(I;#chan(B);.Map) #mapify(I +Int size(#RV(B));#sub(#mapSub(#FV(G));G);.Map) )) [owsie]
  rule #mapify( I:Int ; for(  B:Lbinds if G:BExp ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B)) ;
               #sub(#mapSub(#LV(B));P) ;
               updateMap( Mem , #mapify(I;#chan(B);.Map) #mapify(I +Int size(#RV(B));#sub(#mapSub(#FV(G));G);.Map) ))

  rule #mapify( I:Int ; for( <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#FV(G));P;Mem)
  rule #mapify( I:Int ; for(   B:Pbind if G:BExp ){ P:Proc } ; Mem:Map )
    => #mapify(I +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B)) ;
               #sub(#mapSub(#LV(B));P) ;
               updateMap( Mem , #mapify(I;#chan(B);.Map) #mapify(I +Int size(#RV(B));#sub(#mapSub(#FV(G));G);.Map) )) [owsie]
  rule #mapify( I:Int ; for(  B:Pbinds if G:BExp ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B)) ;
               #sub(#mapSub(#LV(B));P) ;
               updateMap( Mem , #mapify(I;#chan(B);.Map) #mapify(I +Int size(#RV(B));#sub(#mapSub(#FV(G));G);.Map) ))

  rule #mapify( I:Int ; for( <= X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I +Int size(#FV(X)) +Int size(#FV(G));P;Mem)
  rule #mapify( I:Int ; for(   B:Rbind if G:BExp ){ P:Proc } ; Mem:Map )
    => #mapify(I +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B)) ;
               #sub(#mapSub(#LV(B));P) ;
               updateMap( Mem , #mapify(I;#chan(B);.Map) #mapify(I +Int size(#RV(B));#sub(#mapSub(#FV(G));G);.Map) )) [owsie]
  rule #mapify( I:Int ; for(  B:Rbinds if G:BExp ){ P:Proc } ; Mem:Map ) 
    => #mapify(I +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B)) ;
               #sub(#mapSub(#LV(B));P) ;
               updateMap( Mem , #mapify(I;#chan(B);.Map) #mapify(I +Int size(#RV(B));#sub(#mapSub(#FV(G));G);.Map) ))

  rule #mapify( I:Int ;; <- X:Name ;; Mem:Map ) => updateMap( Mem , #mapify(I;X;Mem) )
  rule #mapify( I:Int ;; A:Lbind   ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) )
  rule #mapify( I:Int ;; A:Lbind ; B:Lbind  ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )
  rule #mapify( I:Int ;; A:Lbind ; B:Lbinds ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )
  rule #mapify( I:Int ;; <<- X:Name ;; Mem:Map ) => updateMap( Mem , #mapify(I;X;Mem) )
  rule #mapify( I:Int ;; A:Pbind   ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) )
  rule #mapify( I:Int ;; A:Pbind ; B:Pbind  ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )
  rule #mapify( I:Int ;; A:Pbind ; B:Pbinds ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )
  rule #mapify( I:Int ;; <= X:Name ;; Mem:Map ) => updateMap( Mem , #mapify(I;X;Mem) )
  rule #mapify( I:Int ;; A:Rbind   ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) )
  rule #mapify( I:Int ;; A:Rbind ; B:Rbind  ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )
  rule #mapify( I:Int ;; A:Rbind ; B:Rbinds ;; Mem:Map ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )

// Collection
  rule #mapify( _:Int ; [ ] ; Mem:Map ) => Mem
  rule #mapify( I:Int ; [ A:Procs ]  ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

  // applied after normalization
  rule #mapify( _:Int ; { } ; Mem:Map ) => Mem
//rule #mapify( I:Int ; { A:RhoKVPairs } ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

  // applied after normalization
  rule #mapify( _:Int ; Set( ) ; Mem:Map ) => Mem
  rule #mapify( I:Int ; Set( A:Procs )  ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

  rule #mapify( I:Int ; ( A:Procs ,) ; Mem:Map ) => updateMap( Mem , #mapify(I;A;Mem) )

// BExp
  rule #mapify( I:Int ;        not A:BExp ; Mem:Map ) => #mapify(I;A;Mem)
  rule #mapify( I:Int ; A:BExp and B:BExp ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:BExp or  B:BExp ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:AExp <=  B:AExp ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:AExp <   B:AExp ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:AExp >=  B:AExp ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:AExp >   B:AExp ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
// TODO: ???
  rule #mapify( I:Int ; A:Name ==  B:Name ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:Name !=  B:Name ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:Proc ==  B:Proc ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:Proc !=  B:Proc ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
  rule #mapify( I:Int ; A:Proc matches B:Proc    ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)
//  rule #mapify( I:Int ; A:Proc matches B:ProcPat ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I +Int size(#FV(A));#sub(#mapSub(#FV(A));B);Mem)

// Pattern
  rule #mapify( _:Int ; _:SimplePat ; _:Map ) => .Map

  rule #mapify( I:Int ; ~ A:Proc    ; Mem:Map ) => #mapify(I;A;Mem)
  rule #mapify( I:Int ; ~ A:ProcPat ; Mem:Map ) => #mapify(I;A;Mem)
  rule #mapify( I:Int ; A:Proc    /\ B:ProcPat ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I;B;Mem)
  rule #mapify( I:Int ; A:ProcPat /\ B:Proc    ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I;B;Mem)
  rule #mapify( I:Int ; A:ProcPat /\ B:ProcPat ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I;B;Mem)
  rule #mapify( I:Int ; A:Proc    \/ B:Proc    ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I;B;Mem)
  rule #mapify( I:Int ; A:Proc    \/ B:ProcPat ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I;B;Mem)
  rule #mapify( I:Int ; A:ProcPat \/ B:Proc    ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I;B;Mem)
  rule #mapify( I:Int ; A:ProcPat \/ B:ProcPat ; Mem:Map ) => #mapify(I;A;Mem) #mapify(I;B;Mem)

  // NamePat
rule #mapify( I:Int ; @A:ProcPat ; Mem:Map ) => #mapify(I;A;Mem)

//----------------------
//--- Nested #mapify ---
//----------------------
  rule #mapify( _:Int , _:Int ; \_           ; Mem:Map ) => Mem
  rule #mapify( _:Int , _:Int ;  _:SimplePat ; Mem:Map ) => Mem
  // Name
  rule #mapify( I:Int , J:Int ;  A:Var       ; Mem:Map ) => updateMap( Mem , A |-> boundN(I,J) )
  rule #mapify( _:Int , _:Int ;  _:BoundName ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; @A:Proc      ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )
  rule #mapify( _:Int , _:Int ; @sub         ; Mem:Map ) => Mem


    // several Names
  rule #mapify( I:Int , J:Int ; A:Name    , B:Names    ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:NamePat , B:Names    ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name    , B:NamePats ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:NamePat , B:NamePats ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )

  // Proc
  rule #mapify( _:Int , _:Int ;  _:Ground    ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; \A:Var       ; Mem:Map ) => updateMap( Mem , \A |-> boundP(I,J) )
  rule #mapify( _:Int , _:Int ;  _:BoundProc ; Mem:Map ) => Mem
  rule #mapify( I:Int , J:Int ; *A:Name      ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )
  rule #mapify( _:Int , _:Int ;    sub       ; Mem:Map ) => Mem

    // several Procs
  rule #mapify( I:Int , J:Int ; A:Proc    , B:Procs    ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:ProcPat , B:Procs    ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Proc    , B:ProcPats ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:ProcPat , B:ProcPats ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )

    // New
  rule #mapNew( I:Int , J:Int  ; A:Var            ) => A |-> boundN(I,J)
  rule #mapNew( I:Int , J:Int  ; A:Var ( _:Uri )  ) => A |-> boundN(I,J)
  rule #mapNew( I:Int , J:Int  ; A:Names ) => #mapify(I,J;#set2names(#names2set(A));.Map)

    // Par
  rule #mapify( I:Int , J:Int ; A:Proc | B:Proc ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
       requires notBool isPar(A)

    // Send
  rule #mapify( I:Int , J:Int ; A:Name    !  ( B:ProcPats ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name    !  ( B:Procs    ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name    !  (            ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )
  rule #mapify( I:Int , J:Int ; A:NamePat !  ( B:ProcPats ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:NamePat !  ( B:Procs    ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:NamePat !  (            ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name    !! ( B:ProcPats ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name    !! ( B:Procs    ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:Name    !! (            ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )
  rule #mapify( I:Int , J:Int ; A:NamePat !! ( B:ProcPats ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:NamePat !! ( B:Procs    ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) #mapify(I,J +Int size(#FV(A));B;Mem) )
  rule #mapify( I:Int , J:Int ; A:NamePat !! (            ) ; Mem:Map ) => updateMap( Mem , #mapify(I,J;A;Mem) )

    // Receive -- TODO: MRec
      // TODO: more testing
  rule #mapify( I:Int , J:Int ; for( <- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int , J:Int ; for( B:Lbind   ){ P:Proc } ; Mem:Map )
    => #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#RV(B));P);updateMap(Mem,#mapify(I,J;#bvar(B);Mem))) [owise]

  rule #mapify( I:Int , J:Int ; for( <= X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int , J:Int ; for( B:Pbind   ){ P:Proc } ; Mem:Map )
    => #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#RV(B));P);updateMap(Mem,#mapify(I,J;#bvar(B);Mem))) [owise]

  rule #mapify( I:Int , J:Int ; for( <<- X:Name ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X));P;Mem)
  rule #mapify( I:Int , J:Int ; for( B:Rbind   ){ P:Proc } ; Mem:Map )
    => #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#RV(B));P);updateMap(Mem,#mapify(I,J;#bvar(B);Mem))) [owise]
    // guarded
  rule #mapify( I:Int , J:Int ; for( <- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int , J:Int ; for( B:GLbind  ){ P:Proc } ; Mem:Map )
    => #mapify(I,J +Int size(#RV(B)) +Int size(#BV(#guard(B)));#sub(#mapSub(#RV(B));P);updateMap(Mem,#mapify(I,J;#bvar(B);Mem)))

  rule #mapify( I:Int , J:Int ; for( <= X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int , J:Int ; for( B:GPbind  ){ P:Proc } ; Mem:Map )
    => #mapify(I,J +Int size(#RV(B)) +Int size(#BV(#guard(B)));#sub(#mapSub(#RV(B));P);updateMap(Mem,#mapify(I,J;#bvar(B);Mem)))

  rule #mapify( I:Int , J:Int ; for( <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map ) => #mapify(I,J +Int size(#FV(X)) +Int size(#BV(G));P;Mem)
  rule #mapify( I:Int , J:Int ; for( B:GRbind  ){ P:Proc } ; Mem:Map ) 
    => #mapify(I,J +Int size(#RV(B)) +Int size(#BV(#guard(B)));#sub(#mapSub(#RV(B));P);updateMap(Mem,#mapify(I,J;#bvar(B);Mem)))

//---------------
//--- #dBsize ---
//---------------
// sum of sizes of listening variables and bound channel variables -- for #deBruijn
  rule #dBsize( A:Lbind     ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Pbind     ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Rbind     ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Lbinds    ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Pbinds    ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Rbinds    ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:LbindPat  ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:PbindPat  ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:RbindPat  ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:LbindPats ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:PbindPats ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:RbindPats ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Lbind     _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Pbind     _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Rbind     _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Lbinds    _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Pbinds    _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:Rbinds    _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:LbindPat  _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:PbindPat  _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:RbindPat  _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:LbindPats _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:PbindPats _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))
  rule #dBsize( A:RbindPats _:Guard ) => size(#LV(A)) +Int size(#BV(#chan(A)))

//-------------------
//--- #dBoundSize ---
//-------------------
// sum of sizes of listening variables & receive variables (i.e. free channel variables)
  rule #dBoundSize( A:Lbind     ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Pbind     ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Rbind     ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Lbinds    ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Pbinds    ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Rbinds    ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:LbindPat  ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:PbindPat  ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:RbindPat  ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:LbindPats ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:PbindPats ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:RbindPats ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Lbind     _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Pbind     _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Rbind     _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Lbinds    _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Pbinds    _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:Rbinds    _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:LbindPat  _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:PbindPat  _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:RbindPat  _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:LbindPats _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:PbindPats _:Guard ) => size(#LV(A)) +Int size(#RV(A))
  rule #dBoundSize( A:RbindPats _:Guard ) => size(#LV(A)) +Int size(#RV(A))


  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule