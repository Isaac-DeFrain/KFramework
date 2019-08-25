// De Bruijn Index/Levels & Alpha Equivalence for Rholang

/*
TODO:
 - #deBruijn(Int,Int;Int;;Binds) -- nested Binds
*/

require "../grho.k"
require "../Substitute/sub.k"

module ALPHA-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

//--- Top level ---//
  // Procs
  syntax         Proc ::= "#deBruijn(" Proc ")"          [function, poly(0,1)]
                        | "#deBruijn(" Int ";" Proc  ")" [function, poly(0,2)]
                        |   "#dBound(" Int ";" Proc  ")" [function]
  syntax        Procs ::= "#deBruijn(" Int ";" Procs ")" [function]
                        |   "#dBound(" Int ";" Procs ")" [function]
  // ProcPats
  syntax      ProcPat ::= "#deBruijn(" Int ";" ProcPat  ")" [function]
                        |   "#dBound(" Int ";" ProcPat  ")" [function]
  syntax     ProcPats ::= "#deBruijn(" Int ";" ProcPats ")" [function]
                        |   "#dBound(" Int ";" ProcPats ")" [function]
  // Names
  syntax         Name ::= "#deBruijn(" Int ";" Name  ")" [function]
                        |   "#dBound(" Int ";" Name  ")" [function]
  syntax        Names ::= "#deBruijn(" Int ";" Names ")" [function]
                        |   "#dBound(" Int ";" Names ")" [function]
  // NamePats
  syntax      NamePat ::= "#deBruijn(" Int ";" NamePat  ")" [function]
                        |   "#dBound(" Int ";" NamePat  ")" [function]
  syntax     NamePats ::= "#deBruijn(" Int ";" NamePats ")" [function]
                        |   "#dBound(" Int ";" NamePats ")" [function]
  // VarDecs
  syntax      VarDecs ::= "#dbNew(" Int ";" VarDecs ")" [function]

//--- Nested ---//
// Int params: level, index
  // Procs
  syntax         Proc ::= "#deBruijn(" Int "," Int ";" Proc  ")" [function, poly(0,3)]
                        |   "#dBound(" Int "," Int ";" Proc  ")" [function]
  syntax        Procs ::= "#deBruijn(" Int "," Int ";" Procs ")" [function]
                        |   "#dBound(" Int "," Int ";" Procs ")" [function]
  // ProcPats
  syntax      ProcPat ::= "#deBruijn(" Int "," Int ";" ProcPat  ")" [function]
                        |   "#dBound(" Int "," Int ";" ProcPat  ")" [function]
  syntax     ProcPats ::= "#deBruijn(" Int "," Int ";" ProcPats ")" [function]
                        |   "#dBound(" Int "," Int ";" ProcPats ")" [function]
  // Names
  syntax         Name ::= "#deBruijn(" Int "," Int ";" Name  ")" [function]
                        |   "#dBound(" Int "," Int ";" Name  ")" [function]
  syntax        Names ::= "#deBruijn(" Int "," Int ";" Names ")" [function]
                        |   "#dBound(" Int "," Int ";" Names ")" [function]
  // NamePats
  syntax      NamePat ::= "#deBruijn(" Int "," Int ";" NamePat  ")" [function]
                        |   "#dBound(" Int "," Int ";" NamePat  ")" [function]
  syntax     NamePats ::= "#deBruijn(" Int "," Int ";" NamePats ")" [function]
                        |   "#dBound(" Int "," Int ";" NamePats ")" [function]
  // VarDecs
  syntax      VarDecs ::= "#dbNew(" Int "," Int ";" VarDecs ")" [function]

// Recursive functions
  // TODO: add BindPats
  // can Lbind, Pbind, Rbind be combined into a single Bind with [poly]???
  syntax        Lbind ::= "#deBruijn(" Int         ";;" Lbind   ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" Lbind   ")" [function] // for multiple binds, channel index ; variable index
                        | "#deBruijn(" Int "," Int ";;" Lbind   ")" [function]
                        |   "#dBound(" Int         ";;" Lbind   ")" [function]
                        |   "#dBound(" Int "," Int ";;" Lbind   ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Lbind   ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Lbind   ")" [function]
  syntax       Lbinds ::= "#deBruijn(" Int         ";;" Lbinds  ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" Lbinds  ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Lbinds  ")" [function]
                        |   "#dBound(" Int         ";;" Lbinds  ")" [function]
                        |   "#dBound(" Int "," Int ";;" Lbinds  ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Lbinds  ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Lbinds  ")" [function]
  syntax       GLbind ::= "#deBruijn(" Int         ";;" GLbind  ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" GLbind  ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GLbind  ")" [function]
                        |   "#dBound(" Int         ";;" GLbind  ")" [function]
                        |   "#dBound(" Int "," Int ";;" GLbind  ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GLbind  ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GLbind  ")" [function]
  syntax      GLbinds ::= "#deBruijn(" Int         ";;" GLbinds ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" GLbinds ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GLbinds ")" [function]
                        |   "#dBound(" Int         ";;" GLbinds ")" [function]
                        |   "#dBound(" Int "," Int ";;" GLbinds ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GLbinds ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GLbinds ")" [function]
  syntax        Pbind ::= "#deBruijn(" Int         ";;" Pbind   ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" Pbind   ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Pbind   ")" [function]
                        |   "#dBound(" Int         ";;" Pbind   ")" [function]
                        |   "#dBound(" Int "," Int ";;" Pbind   ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Pbind   ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Pbind   ")" [function]
  syntax       Pbinds ::= "#deBruijn(" Int         ";;" Pbinds  ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" Pbinds  ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Pbinds  ")" [function]
                        |   "#dBound(" Int         ";;" Pbinds  ")" [function]
                        |   "#dBound(" Int "," Int ";;" Pbinds  ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Pbinds  ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Pbinds  ")" [function]
  syntax       GPbind ::= "#deBruijn(" Int         ";;" GPbind  ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" GPbind  ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GPbind  ")" [function]
                        |   "#dBound(" Int         ";;" GPbind  ")" [function]
                        |   "#dBound(" Int "," Int ";;" GPbind  ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GPbind  ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GPbind  ")" [function]
  syntax      GPbinds ::= "#deBruijn(" Int         ";;" GPbinds ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" GPbinds ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GPbinds ")" [function]
                        |   "#dBound(" Int         ";;" GPbinds ")" [function]
                        |   "#dBound(" Int "," Int ";;" GPbinds ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GPbinds ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GPbinds ")" [function]
  syntax        Rbind ::= "#deBruijn(" Int         ";;" Rbind   ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" Rbind   ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Rbind   ")" [function]
                        |   "#dBound(" Int         ";;" Rbind   ")" [function]
                        |   "#dBound(" Int "," Int ";;" Rbind   ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Rbind   ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Rbind   ")" [function]
  syntax       Rbinds ::= "#deBruijn(" Int         ";;" Rbinds  ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" Rbinds  ")" [function]
                        | "#deBruijn(" Int "," Int ";;" Rbinds  ")" [function]
                        |   "#dBound(" Int         ";;" Rbinds  ")" [function]
                        |   "#dBound(" Int "," Int ";;" Rbinds  ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" Rbinds  ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" Rbinds  ")" [function]
  syntax       GRbind ::= "#deBruijn(" Int         ";;" GRbind  ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" GRbind  ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GRbind  ")" [function]
                        |   "#dBound(" Int         ";;" GRbind  ")" [function]
                        |   "#dBound(" Int "," Int ";;" GRbind  ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GRbind  ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GRbind  ")" [function]
  syntax      GRbinds ::= "#deBruijn(" Int         ";;" GRbinds ")" [function]
                        | "#deBruijn(" Int ";" Int ";;" GRbinds ")" [function]
                        | "#deBruijn(" Int "," Int ";;" GRbinds ")" [function]
                        |   "#dBound(" Int         ";;" GRbinds ")" [function]
                        |   "#dBound(" Int "," Int ";;" GRbinds ")" [function]
                        |  "#dBound+(" Int         ";" Int ";;" GRbinds ")" [function]
                        |  "#dBound+(" Int "," Int ";" Int ";;" GRbinds ")" [function]

  // KV pairs
  syntax    RhoKVPair ::= "#deBruijn(" Int         ";" RhoKVPair  ")" [function]
                        |   "#dBound(" Int         ";" RhoKVPair  ")" [function]
                        |   "#dBound(" Int         ";" RhoKVPair  ")" [function]
                        | "#deBruijn(" Int "," Int ";" RhoKVPair  ")" [function]
                        |   "#dBound(" Int "," Int ";" RhoKVPair  ")" [function]
                        |   "#dBound(" Int "," Int ";" RhoKVPair  ")" [function]
  syntax   RhoKVPairs ::= "#deBruijn(" Int         ";" RhoKVPairs ")" [function]
                        |   "#dBound(" Int         ";" RhoKVPairs ")" [function]
                        |   "#dBound(" Int         ";" RhoKVPairs ")" [function]
                        | "#deBruijn(" Int "," Int ";" RhoKVPairs ")" [function]
                        |   "#dBound(" Int "," Int ";" RhoKVPairs ")" [function]
  syntax     RhoKVPat ::= "#deBruijn(" Int         ";" RhoKVPat   ")" [function]
                        |   "#dBound(" Int         ";" RhoKVPat   ")" [function]
                        | "#deBruijn(" Int "," Int ";" RhoKVPat   ")" [function]
                        |   "#dBound(" Int "," Int ";" RhoKVPat   ")" [function]
  syntax    RhoKVPats ::= "#deBruijn(" Int         ";" RhoKVPats  ")" [function]
                        |   "#dBound(" Int         ";" RhoKVPats  ")" [function]
                        | "#deBruijn(" Int "," Int ";" RhoKVPats  ")" [function]
                        |   "#dBound(" Int "," Int ";" RhoKVPats  ")" [function]

  // InterpMaps
  syntax   InterpMaps ::= "#deBruijn(" Int         ";" InterpMaps ")" [function]
                        |   "#dBound(" Int         ";" InterpMaps ")" [function]
                        | "#deBruijn(" Int "," Int ";" InterpMaps ")" [function]
                        |   "#dBound(" Int "," Int ";" InterpMaps ")" [function]

// MatchCases
  syntax    MatchCase ::= "#deBruijn(" Int         ";" MatchCase  ")" [function]
                        |   "#dBound(" Int         ";" MatchCase  ")" [function]
                        | "#deBruijn(" Int "," Int ";" MatchCase  ")" [function]
                        |   "#dBound(" Int "," Int ";" MatchCase  ")" [function]
  syntax   MatchCases ::= "#deBruijn(" Int         ";" MatchCases ")" [function]
                        |   "#dBound(" Int         ";" MatchCases ")" [function]
                        | "#deBruijn(" Int "," Int ";" MatchCases ")" [function]
                        |   "#dBound(" Int "," Int ";" MatchCases ")" [function]

// Select Branches
  syntax       Branch ::= "#deBruijn(" Int         ";" Branch   ")" [function]
                        |   "#dBound(" Int         ";" Branch   ")" [function]
                        | "#deBruijn(" Int "," Int ";" Branch   ")" [function]
                        |   "#dBound(" Int "," Int ";" Branch   ")" [function]
  syntax     Branches ::= "#deBruijn(" Int         ";" Branches ")" [function]
                        |   "#dBound(" Int         ";" Branches ")" [function]
                        | "#deBruijn(" Int "," Int ";" Branches ")" [function]
                        |   "#dBound(" Int "," Int ";" Branches ")" [function]

// Top level DeBruijn index map for substitutions
  // New Name declarations
  syntax          Map ::= "#mapNew(" Int         ";" Names ")" [function]
                        | "#mapNew(" Int "," Int ";" Names ")" [function]
  //
  syntax          Map ::= "#mapify(" Names    ")"          [function]
                        | "#mapify(" NamePats ")"          [function]
                        | "#mapify(" Procs    ")"          [function]
                        | "#mapify(" ProcPats ")"          [function]
                        | "#mapify(" Int ";"  Names    ")" [function]
                        | "#mapify(" Int ";"  NamePats ")" [function]
                        | "#mapify(" Int ";"  Procs    ")" [function]
                        | "#mapify(" Int ";"  ProcPats ")" [function]
                        | "#mapify(" Int ";;" AnyBind  ")" [function]
                        | "#mapify(" Int ";;" AnyBinds ")" [function]

  syntax          Map ::= "#mapify(" Int ";" RhoKVPairs ")" [function]
                        | "#mapify(" Int ";" RhoKVPats  ")" [function]
                        | "#mapify(" Int ";" Branches   ")" [function]
                        | "#mapify(" Int ";" MatchCases ")" [function]

// Nested Map updates
  syntax          Map ::= "#mapify(" Int "," Int ";"  Names    ")" [function]
                        | "#mapify(" Int "," Int ";"  NamePats ")" [function]
                        | "#mapify(" Int "," Int ";"  Procs    ")" [function]
                        | "#mapify(" Int "," Int ";"  ProcPats ")" [function]
                        | "#mapify(" Int "," Int ";;" AnyBind  ")" [function]
                        | "#mapify(" Int "," Int ";;" AnyBinds ")" [function]

// Alpha equivalence predicate
  syntax         Bool ::= Proc "#alpha" Proc [function]

endmodule

module ALPHA
  import ALPHA-SYNTAX
  import SUB

  syntax KResult ::= Proc | Procs | ProcPat | ProcPats
                   | Name | Names | NamePat | NamePats
                   | Bind | Binds | BindPat | BindPats
                   | RhoKVPair | RhoKVPairs | InterpMaps | Map

// sugar for #deBruijn function call
  rule #deBruijn( P:Proc ) => #deBruijn(0;P) // #FV(P) should be .Set if we are applying #deBruijn

// completely trivial cases -- no variables in expression
//  rule #deBruijn( A:Name    ) => A requires #V(A) ==K .Set
//  rule #deBruijn( A:NamePat ) => A requires #V(A) ==K .Set
//  rule #deBruijn( A:Proc    ) => A requires #V(A) ==K .Set
//  rule #deBruijn( A:ProcPat ) => A requires #V(A) ==K .Set

//----------------------------
//--- Top Level Constructs ---
//----------------------------
// New
  rule #deBruijn( I:Int ; new A:VarDecs in { B:Proc } )
    => new #dbNew(I;#indecs(A)) in { #deBruijn(I +Int size(#DV(A));#sub(#mapNew(I;#indecs(A));B)) }

  rule #dbNew( I:Int ; A:VarDec ) => n(I)
  rule #dbNew( I:Int ; A:VarDec , B:VarDecs ) => n(I) , #dbNew(I +Int 1;B)

  // Nested New -- mapify only variables
  rule #deBruijn( I:Int , J:Int ; new A:VarDecs in { B:Proc } )
    => new #dbNew(I,J;#indecs(A)) in { #deBruijn(I,J +Int size(#DV(A));#sub(#mapNew(I,J;#indecs(A));B)) }

  rule #dbNew( I:Int , J:Int ; A:VarDec ) => n(I,J)
  rule #dbNew( I:Int , J:Int ; A:VarDec , B:VarDecs ) => n(I,J) , #dbNew(I,J +Int 1;B)

// Ground & Bound Terms
  rule #deBruijn( _:Int ; A:Ground    ) => A
  rule #deBruijn( _:Int ; A:BoundName ) => A
  rule #deBruijn( _:Int ; A:BoundProc ) => A

// Parallel Composition
// Index propogates to both branches
  rule #deBruijn( I:Int ; P:Proc | Q:Proc ) => #deBruijn(I;P) | #deBruijn(I;Q)

// Receives
  // listening variables are indexed and substituted into continuation
  // Linear
    // Single
  rule #deBruijn( I:Int ; for( B:Lbind ){ C:Proc } )
    => for( #deBruijn(I;I;;B) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
  rule #deBruijn( I:Int ; for( B:Lbind if G:BExp ){ C:Proc } )
    => for( #deBruijn(I;I;;B if G) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
    // Multi
  rule #deBruijn( I:Int ; for( B:Lbinds ){ C:Proc } )
    => for( #deBruijn(I;I;;B) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
  rule #deBruijn( I:Int ; for( B:Lbinds if G:BExp ){ C:Proc } )
    => for( #deBruijn(I;I;;B if G) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
  // Peek
    // Single
  rule #deBruijn( I:Int ; for( B:Pbind ){ C:Proc } )
    => for( #deBruijn(I;I;;B) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
  rule #deBruijn( I:Int ; for( B:Pbind if G:BExp ){ C:Proc } )
    => for( #deBruijn(I;I;;B if G) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
    // Multi
  rule #deBruijn( I:Int ; for( B:Pbinds ){ C:Proc } )
    => for( #deBruijn(I;I;;B) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
  rule #deBruijn( I:Int ; for( B:Pbinds if G:BExp ){ C:Proc } )
    => for( #deBruijn(I;I;;B if G) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
  // Repeat
    // Single
  rule #deBruijn( I:Int ; for( B:Rbind ){ C:Proc } )
    => for( #deBruijn(I;I;;B) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
  rule #deBruijn( I:Int ; for( B:Rbind if G:BExp ){ C:Proc } )
    => for( #deBruijn(I;I;;B if G) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }
    // Multi
  rule #deBruijn( I:Int ; for( B:Rbinds ){ C:Proc } )
    => for( #deBruijn(I;I;;B) ){
         #deBruijn(I +Int size(#LV(B)) ;
           #sub(#mapify(I;#bvar(B));C)) }
  rule #deBruijn( I:Int ; for( B:Rbinds if G:BExp ){ C:Proc } )
    => for( #deBruijn(I;I;;B if G) ){
              #deBruijn(I +Int size(#LV(B)) ;
              #sub(#mapify(I;#bvar(B));C)) }

  // Binds -- increase index for listening variables, not for channels
    // unguarded
  rule #deBruijn( I:Int ; _:Int ;; <- A:Name ) => <- #deBruijn(I;A)
  rule #deBruijn( I:Int ; J:Int ;; A:Lbind   )
    => #dBound(J;#bvar(A)) <-  #deBruijn(I;#chan(A)) requires notBool isEmptyLbind(A)
  rule #deBruijn( I:Int ; J:Int ;; A:Lbind & B:Lbind  )
    => #deBruijn(I;J;;A) & #deBruijn(I;J +Int size(#LV(A));;B)
  rule #deBruijn( I:Int ; J:Int ;; A:Lbind & B:Lbinds )
    => #deBruijn(I;J;;A) & #deBruijn(I;J +Int size(#LV(A));;B)

  rule #deBruijn( I:Int ; _:Int ;; <<- A:Name ) => <<- #deBruijn(I;A)
  rule #deBruijn( I:Int ; J:Int ;; A:Pbind    )
    => #dBound(J;#bvar(A)) <<- #deBruijn(I;#chan(A)) requires notBool isEmptyPbind(A)
  rule #deBruijn( I:Int ; J:Int ;; A:Pbind & B:Pbind  )
    => #deBruijn(J;;A) & #deBruijn(I;J +Int size(#LV(A));;B)
  rule #deBruijn( I:Int ; J:Int ;; A:Pbind & B:Pbinds )
    => #deBruijn(J;;A) & #deBruijn(I;J +Int size(#LV(A));;B)

  rule #deBruijn( I:Int ; _:Int ;; <= A:Name ) => <= #deBruijn(I;A)
  rule #deBruijn( I:Int ; J:Int ;; A:Rbind   )
    => #dBound(J;#bvar(A)) <=  #deBruijn(I;#chan(A)) requires notBool isEmptyRbind(A)
  rule #deBruijn( I:Int ; J:Int ;; A:Rbind & B:Rbind  )
    => #deBruijn(I;J;;A) & #deBruijn(I;J +Int size(#LV(A));;B)
  rule #deBruijn( I:Int ; J:Int ;; A:Rbind & B:Rbinds )
    => #deBruijn(I;J;;A) & #deBruijn(I;J +Int size(#LV(A));;B)

  // guarded
  rule #deBruijn( I:Int ; J:Int ;; B:Lbind  if G:BExp )
    => #deBruijn(I;J;;B) if #deBruijn(J +Int size(#LV(B));#sub(#mapify(J;#bvar(B));G))
  rule #deBruijn( I:Int ; J:Int ;; B:Lbinds if G:BExp )
    => #deBruijn(I;J;;B) if #deBruijn(J +Int size(#LV(B));#sub(#mapify(J;#bvar(B));G))
  rule #deBruijn( I:Int ; J:Int ;; B:Pbind  if G:BExp )
    => #deBruijn(I;J;;B) if #deBruijn(J +Int size(#LV(B));#sub(#mapify(J;#bvar(B));G))
  rule #deBruijn( I:Int ; J:Int ;; B:Pbinds if G:BExp )
    => #deBruijn(I;J;;B) if #deBruijn(J +Int size(#LV(B));#sub(#mapify(J;#bvar(B));G))
  rule #deBruijn( I:Int ; J:Int ;; B:Rbind  if G:BExp )
    => #deBruijn(I;J;;B) if #deBruijn(J +Int size(#LV(B));#sub(#mapify(J;#bvar(B));G))
  rule #deBruijn( I:Int ; J:Int ;; B:Rbinds if G:BExp )
    => #deBruijn(I;J;;B) if #deBruijn(J +Int size(#LV(B));#sub(#mapify(J;#bvar(B));G))

// Sends
// no free variables left once #deBruijn arrives at a Send -- map & index constant on channel and message
  rule #deBruijn( I:Int ; A:Name !  ( B:Procs ) ) => #deBruijn(I;A) !  ( #deBruijn(I;B) )
  rule #deBruijn( I:Int ; A:Name !  (         ) ) => #deBruijn(I;A) !  ( )
  rule #deBruijn( I:Int ; A:Name !! ( B:Procs ) ) => #deBruijn(I;A) !! ( #deBruijn(I;B) )
  rule #deBruijn( I:Int ; A:Name !! (         ) ) => #deBruijn(I;A) !! ( )

// Eval
  rule #deBruijn( I:Int ; *A:Name ) => *#deBruijn(I;A)

// Variables
  // Typed Name
  rule #deBruijn( I:Int ; (@A:BoundProc) :: B:ProcPat ) => (@A) :: #deBruijn(I;B)
  rule #deBruijn( I:Int ;   A:BoundName  :: B:ProcPat ) =>   A  :: #deBruijn(I;B)

  // Typed Proc
  rule #deBruijn( I:Int ;   A:BoundProc  :: B:ProcPat ) =>   A  :: #deBruijn(I;B)
  rule #deBruijn( I:Int ; (*A:BoundName) :: B:ProcPat ) => (*A) :: #deBruijn(I;B)

// Collections
  // RhoList
  rule #deBruijn( _:Int ; [ ] ) => [ ]
  rule #deBruijn( I:Int ; [ A:Procs ] ) => [ #deBruijn(I;A) ]

  // RhoMap
  rule #deBruijn( _:Int ; { } ) => { }
  rule #deBruijn( I:Int ; { A:RhoKVPairs } ) => { #deBruijn(I;A) }
    // KVPairs
  rule #deBruijn( I:Int ; A:Proc : B:Proc ) => #deBruijn(I;A) : #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:RhoKVPair , B:RhoKVPairs ) => #deBruijn(I;A) , #deBruijn(I;B)

  // RhoSet
  rule #deBruijn( _:Int ; Set( ) ) => Set( )
  rule #deBruijn( I:Int ; Set( A:Procs ) ) => Set( #deBruijn(I;A) )

  // RhoTuple
  rule #deBruijn( I:Int ; ( A:Procs ,) ) => ( #deBruijn(I;A) ,)

// Quotes
  rule #deBruijn( I:Int ; @A:Proc ) => @#deBruijn(I;A)

// Expressions
  // Arithmetic Exps
  rule #deBruijn( I:Int ; - A:AExp ) => - #deBruijn(I;A)
  rule #deBruijn( I:Int ; A:AExp * B:AExp ) => #deBruijn(I;A) * #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:AExp / B:AExp ) => #deBruijn(I;A) / #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:AExp + B:AExp ) => #deBruijn(I;A) + #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:AExp - B:AExp ) => #deBruijn(I;A) - #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:AExp % B:AExp ) => #deBruijn(I;A) % #deBruijn(I;B)

  // List & String Expressions
  rule #deBruijn( I:Int ; A:ListOrVar   ++ B:ListOrVar   ) => #deBruijn(I;A) ++ #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:ListOrVar   ++ B:ConcatList  ) => #deBruijn(I;A) ++ #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:StringOrVar ++ B:StringOrVar ) => #deBruijn(I;A) ++ #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:StringOrVar ++ B:ConcatStr   ) => #deBruijn(I;A) ++ #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:StringOrVar %% B:InterpMaps  ) => #deBruijn(I;A) %% #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:RhoMap      %% B:InterpMaps  ) => #deBruijn(I;A) %% #deBruijn(I;B)

  // Boolean Exps
  rule #deBruijn( I:Int ; not A:BExp ) => not #deBruijn(I;A)
  rule #deBruijn( I:Int ; A:BExp and B:BExp ) => #deBruijn(I;A) and #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:BExp or  B:BExp ) => #deBruijn(I;A) or  #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:AExp <=  B:AExp ) => #deBruijn(I;A) <=  #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:AExp <   B:AExp ) => #deBruijn(I;A) <   #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:AExp >=  B:AExp ) => #deBruijn(I;A) >=  #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:AExp >   B:AExp ) => #deBruijn(I;A) >   #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:Name ==  B:Name ) => #deBruijn(I;A) ==  #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:Name !=  B:Name ) => #deBruijn(I;A) !=  #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:Proc ==  B:Proc ) => #deBruijn(I;A) ==  #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:Proc !=  B:Proc ) => #deBruijn(I;A) !=  #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:Proc    matches B:Proc    ) => #deBruijn(I;A) matches #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:Proc    matches B:ProcPat ) => #deBruijn(I;A) matches #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:ProcPat matches B:ProcPat ) => #deBruijn(I;A) matches #deBruijn(I;B)

// Match
  rule #deBruijn( I:Int ; match A:Proc { B:MatchCases } ) => match #deBruijn(I;A) { #deBruijn(I;B) }
  // MatchCases
  rule #deBruijn( I:Int ; A:MatchCase B:MatchCases ) => #deBruijn(I;A) #deBruijn(I;B)
  rule #deBruijn( I:Int ; { A:Proc    } |=> B:Proc )
    => {#dBound(I;A)} |=> #deBruijn(I +Int size(#FV(A));#sub(#mapify(I;A);B))
  rule #deBruijn( I:Int ; { A:ProcPat } |=> B:Proc )
    => {#dBound(I;A)} |=> #deBruijn(I +Int size(#FV(A));#sub(#mapify(I;A);B))

// Select
  rule #deBruijn( I:Int ; select { A:Branches } ) => select { #deBruijn(I;A) }
  // Branches
  rule #deBruijn( I:Int ; A:Branch B:Branches ) => #deBruijn(I;A) #deBruijn(I;B)
  rule #deBruijn( I:Int ; { A:Lbind  } |=> B:Proc )
    => {#deBruijn(I;I;;A)} |=> #deBruijn(I +Int size(#LV(A));#sub(#mapify(I;#bvar(A));B))
  rule #deBruijn( I:Int ; { A:Lbinds } |=> B:Proc )
    => {#deBruijn(I;I;;A)} |=> #deBruijn(I +Int size(#LV(A));#sub(#mapify(I;#bvar(A));B))

// Bundle
  rule #deBruijn( I:Int ;  bundle{ A:Proc } ) =>  bundle{ #deBruijn(I;A) }
  rule #deBruijn( I:Int ; bundle+{ A:Proc } ) => bundle+{ #deBruijn(I;A) }
  rule #deBruijn( I:Int ; bundle-{ A:Proc } ) => bundle-{ #deBruijn(I;A) }
  rule #deBruijn( I:Int ; bundle0{ A:Proc } ) => bundle0{ #deBruijn(I;A) }

// Conditional
  rule #deBruijn( I:Int ; if (A:BExp)   B:Proc ) => if (#deBruijn(I;A)) #deBruijn(I;B)
  rule #deBruijn( I:Int ; A:IfThen else B:Proc ) => #deBruijn(I;A) else #deBruijn(I;B)

// Several Procs -- appear in Collections and Sends
  rule #deBruijn( I:Int ; A:Proc , B:Procs ) => #deBruijn(I;A) , #deBruijn(I;B)

//-------------------------
//--- Nested Constructs ---
//-------------------------
// Ground & bound terms
  rule #deBruijn( _:Int , _:Int ; A:Ground    ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundName ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundProc ) => A

// Parallel Composition
// Level and index propogates to both branchs
  rule #deBruijn( I:Int , J:Int ; P:Proc | Q:Proc ) => #deBruijn(I,J;P) | #deBruijn(I,J;Q)

// Receives -- TODO: clean this up with #deBruijn(_:Int,_:Int;_:Int;;Binds)
  // listening variables are indexed and substituted into continuation
  // SRec
    // Linear
/*
  rule #deBruijn( I:Int , J:Int ; for( <- X:Name ){ P:Proc } )
    => for( <- #deBruijn(I,J;X) ){ #deBruijn(I,J;P) }
  rule #deBruijn( I:Int , J:Int ; for( B:Lbind   ){ P:Proc } )
    => for( #dBound(I,J;#bvar(B);.Map) <- #deBruijn(I,J;#chan(B)) ){
              #deBruijn(I,J +Int size(#LV(B)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P)) }
       requires notBool isEmptyLbind(B)
  rule #deBruijn( I:Int , J:Int ; for( <- X:Name if G:BExp ){ P:Proc } )
    => for( <- #deBruijn(I,J;X) if #deBruijn(I,J;G) ){ #deBruijn(I,J;P) }
  rule #deBruijn( I:Int , J:Int ; for( B:Lbind   if G:BExp ){ P:Proc } )
    => for( #dBound(I,J;#bvar(B);.Map) <- #deBruijn(I,J;#chan(B)) if #sub(#mapify(I,J;#bvar(B);.Map);G) ){
              #deBruijn(I,J +Int size(#LV(B)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P)) }
       requires notBool isEmptyLbind(B)
    // Peek
  rule #deBruijn( I:Int , J:Int ; for( <<- X:Name ){ P:Proc } )
    => for( <<- #deBruijn(I,J;X) ){ #deBruijn(I,J;P) }
  rule #deBruijn( I:Int , J:Int ; for( B:Pbind   ){ P:Proc } )
    => for( #dBound(I,J;#bvar(B);.Map) <<- #deBruijn(I,J +Int size(#LV(B));#chan(B)) ){
              #deBruijn(I,J +Int size(#LV(B)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P)) }
       requires notBool isEmptyPbind(B)
  rule #deBruijn( I:Int , J:Int ; for( <<- X:Name if G:BExp ){ P:Proc } )
    => for( <<- #deBruijn(I,J;X) if #deBruijn(I,J +Int size(#BV(X));G) ){ #deBruijn(I,J;P) }
  rule #deBruijn( I:Int , J:Int ; for( B:Pbind   if G:BExp ){ P:Proc } )
    => for( #dBound(I,J;#bvar(B);.Map) <<- #deBruijn(I,J +Int size(#LV(B));#chan(B)) if #sub(#mapify(I,J;#bvar(B);.Map);G) ){
              #deBruijn(I,J +Int size(#LV(B)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P)) }
       requires notBool isEmptyPbind(B)
    // Repeat
  rule #deBruijn( I:Int , J:Int ; for( <= X:Name ){ P:Proc } )
    => for( <= #deBruijn(I,J;X) ){ #deBruijn(I,J;P) }
  rule #deBruijn( I:Int , J:Int ; for( B:Rbind   ){ P:Proc } )
    => for( #dBound(I,J;#bvar(B);.Map) <= #deBruijn(I,J;#chan(B)) ){
              #deBruijn(I,J +Int size(#LV(B)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P)) }
       requires notBool isEmptyRbind(B)
  rule #deBruijn( I:Int , J:Int ; for( <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( <= #deBruijn(I,J;X) if #deBruijn(I,J;G) ){ #deBruijn(I,J;P) }
  rule #deBruijn( I:Int , J:Int ; for( B:Rbind   if G:BExp ){ P:Proc } ; Mem:Map )
    => for( #dBound(I,J;#bvar(B);.Map) <= #deBruijn(I,J;#chan(B)) if #sub(#mapify(I,J;#bvar(B);.Map);G) ){
              #deBruijn(I,J +Int size(#LV(B)) ;
              #sub(#mapify(I,J;#bvar(B);.Map);P)) }
       requires notBool isEmptyRbind(B)

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
*/
// Sends
// map constant on channel and message(s) -- check channel for bound variables
  rule #deBruijn( I:Int , J:Int ; X:Name !  ( P:Procs ) ) => #deBruijn(I,J;X) !  ( #deBruijn(I,J;P) )
  rule #deBruijn( I:Int , J:Int ; X:Name !  (         ) ) => #deBruijn(I,J;X) !  ( )
  rule #deBruijn( I:Int , J:Int ; X:Name !! ( P:Procs ) ) => #deBruijn(I,J;X) !! ( #deBruijn(I,J;P) )
  rule #deBruijn( I:Int , J:Int ; X:Name !! (         ) ) => #deBruijn(I,J;X) !! ( )

// Eval -- just goes inside
  rule #deBruijn( I:Int , J:Int ; *X:Name ) => *#deBruijn(I,J;X)

// Variables -- TODO: needed???
  // Vars
    // nothing happens if Var is free w.r.t. Mem
    // if Var is bound w.r.t. Mem, replace it with its value
/*
  rule #deBruijn( _:Int , _:Int ;    N:Var ; Mem:Map ) => #sub(Mem;N)
  rule #deBruijn( _:Int , _:Int ;    A:Var  :: B:ProcPat ; Mem:Map ) =>   #sub(Mem; A)  :: #sub(Mem;B)
  rule #deBruijn( _:Int , _:Int ; (@\A:Var) :: B:ProcPat ; Mem:Map ) => (@#sub(Mem;\A)) :: #sub(Mem;B)

  // ProcVars
    // nothing happens if ProcVar is free w.r.t. Mem
    // if ProcVar is bound w.r.t. Mem, replace it with its value
  rule #deBruijn( _:Int , _:Int ;  \P:Var ; Mem:Map ) => #sub(Mem;\P)
  rule #deBruijn( _:Int , _:Int ;  \A:Var  :: B:ProcPat ; Mem:Map ) =>   #sub(Mem;\A)  :: #sub(Mem;B)
  rule #deBruijn( _:Int , _:Int ; (*A:Var) :: B:ProcPat ; Mem:Map ) => (*#sub(Mem; A)) :: #sub(Mem;B)
*/

// Collections
  // RhoList
  rule #deBruijn( _:Int , _:Int ; [ ]         ) => [ ]
  rule #deBruijn( I:Int , J:Int ; [ P:Procs ] ) => [ #deBruijn(I,J;P) ]

  // RhoMap -- TODO

  // RhoSet
  rule #deBruijn( _:Int , _:Int ; Set( )         ) => Set( )
  rule #deBruijn( I:Int , J:Int ; Set( P:Procs ) ) => Set( #deBruijn(I,J;P) )

  // RhoTuple
  rule #deBruijn( I:Int , J:Int ; ( P:Procs ,) ) => ( #deBruijn(I,J;P) ,)

// Quote
  rule #deBruijn( I:Int , J:Int ; @P:Proc ) => @#deBruijn(I,J;P)

// Expressions -- TODO: size(#BV) needed???
  // Arithmetic Expressions
  rule #deBruijn( I:Int , J:Int ; - A:AExp ) => - #deBruijn(I,J;A)
  rule #deBruijn( I:Int , J:Int ; A:AExp * B:AExp ) => #deBruijn(I,J;A) *  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:AExp / B:AExp ) => #deBruijn(I,J;A) /  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:AExp + B:AExp ) => #deBruijn(I,J;A) +  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:AExp - B:AExp ) => #deBruijn(I,J;A) -  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:AExp % B:AExp ) => #deBruijn(I,J;A) %  #deBruijn(I,J;B)

  // String Expressions
  rule #deBruijn( I:Int , J:Int ; A:ListOrVar   ++ B:ListOrVar   )
    => #deBruijn(I,J;A) ++ #deBruijn(I,J +Int size(#BV(A));B)
  rule #deBruijn( I:Int , J:Int ; A:ListOrVar   ++ B:ConcatList  )
    => #deBruijn(I,J;A) ++ #deBruijn(I,J +Int size(#BV(A));B)
  rule #deBruijn( I:Int , J:Int ; A:StringOrVar ++ B:StringOrVar )
    => #deBruijn(I,J;A) ++ #deBruijn(I,J +Int size(#BV(A));B)
  rule #deBruijn( I:Int , J:Int ; A:StringOrVar ++ B:ConcatStr   )
    => #deBruijn(I,J;A) ++ #deBruijn(I,J +Int size(#BV(A));B)
  rule #deBruijn( I:Int , J:Int ; A:StringOrVar %% B:InterpMaps  )
    => #deBruijn(I,J;A) %% #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:RhoMap      %% B:InterpMaps  )
    => #deBruijn(I,J;A) %% #deBruijn(I,J;B)

  // Boolean Expressions
  rule #deBruijn( I:Int , J:Int ; not A:BExp ) => not #deBruijn(I,J;A)
  rule #deBruijn( I:Int , J:Int ; A:BExp and B:BExp ) => #deBruijn(I,J;A) and #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:BExp or  B:BExp ) => #deBruijn(I,J;A) or  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:AExp <=  B:AExp ) => #deBruijn(I,J;A) <=  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:AExp <   B:AExp ) => #deBruijn(I,J;A) <   #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:AExp >=  B:AExp ) => #deBruijn(I,J;A) >=  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:AExp >   B:AExp ) => #deBruijn(I,J;A) >   #deBruijn(I,J;B)
    // may contain general Names & Procs -- check for bound variables to index
  rule #deBruijn( I:Int , J:Int ; A:Name ==  B:Name ) => #deBruijn(I,J;A) ==  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:Name !=  B:Name ) => #deBruijn(I,J;A) !=  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:Proc ==  B:Proc ) => #deBruijn(I,J;A) ==  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:Proc !=  B:Proc ) => #deBruijn(I,J;A) !=  #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:Proc    matches B:Proc    ) => #deBruijn(I,J;A) matches #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:Proc    matches B:ProcPat ) => #deBruijn(I,J;A) matches #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:ProcPat matches B:ProcPat ) => #deBruijn(I,J;A) matches #deBruijn(I,J;B)

// Match -- TODO: test
  rule #deBruijn( I:Int , J:Int ; match A:Proc { B:MatchCases } )
    => match #deBruijn(I,J;A) { #deBruijn(I,J;B) }
  // MatchCases
  rule #deBruijn( I:Int , J:Int ; A:MatchCase B:MatchCases ) => #deBruijn(I,J;A) #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; { A:Proc    } |=> B:Proc )
    => {#dBound(I,J;A)} |=> #deBruijn(I,J +Int size(#FV(A));#sub(#mapify(I,J;A);B))
  rule #deBruijn( I:Int , J:Int ; { A:ProcPat } |=> B:Proc )
    => {#dBound(I,J;A)} |=> #deBruijn(I,J +Int size(#FV(A));#sub(#mapify(I,J;A);B))

// Select -- TODO: test
  rule #deBruijn( I:Int , J:Int ; select { A:Branches } ) => select { #deBruijn(I,J;A) }
  // Branches
  rule #deBruijn( I:Int , J:Int ; A:Branch B:Branches ) => #deBruijn(I,J;A) #deBruijn(I,J;B)
  // TODO: indexing??
//  rule #deBruijn( I:Int , J:Int ; { A:Lbind  } |=> B:Proc )
//    => {#deBruijn(I;I;;A)} |=> #deBruijn(I,J +Int size(#LV(A));#sub(#mapify(I,J;#bvar(A));B))
//  rule #deBruijn( I:Int , J:Int ; { A:Lbinds } |=> B:Proc )
//    => {#deBruijn(I;I;;A)} |=> #deBruijn(I,J +Int size(#LV(A));#sub(#mapify(I,J;#bvar(A));B))

// Bundle
  rule #deBruijn( I:Int , J:Int ;  bundle{ A:Proc } ) =>  bundle{ #deBruijn(I,J;A) }
  rule #deBruijn( I:Int , J:Int ; bundle+{ A:Proc } ) => bundle+{ #deBruijn(I,J;A) }
  rule #deBruijn( I:Int , J:Int ; bundle-{ A:Proc } ) => bundle-{ #deBruijn(I,J;A) }
  rule #deBruijn( I:Int , J:Int ; bundle0{ A:Proc } ) => bundle0{ #deBruijn(I,J;A) }

// Conditional
  rule #deBruijn( I:Int , J:Int ; if (A:BExp)   B:Proc ) => if (#deBruijn(I,J;A)) #deBruijn(I,J;B)
  rule #deBruijn( I:Int , J:Int ; A:IfThen else B:Proc ) => #deBruijn(I,J;A) else #deBruijn(I,J;B)

// Several Procs
  // Lists of to-be-bound Procs appear in Collections and Sends...
  // want to do something like
  rule #deBruijn( I:Int , J:Int ; A:Proc , B:Procs ) => #deBruijn(I,J;A) , #deBruijn(I,J;B)

//--------------
//--- #alpha ---
//--------------

// Alpha Equivalence Predicate
  // checks synactic equality of De Bruijn indexed terms
  rule P:Proc #alpha Q:Proc => #deBruijn(P) ==K #deBruijn(Q)

//---------------
//--- #dBound ---
//---------------
// assigns DeBruijn indices to variables bound by a listen in a Receive/Select or to-be-matched Proc/Pattern in a Match
// TODO: finish

// Trivial cases
//  #dBound( A:Names    ) => A requires #V(A) ==K .Set
//  #dBound( A:NamePats ) => A requires #V(A) ==K .Set
//  #dBound( A:Procs    ) => A requires #V(A) ==K .Set
//  #dBound( A:ProcPats ) => A requires #V(A) ==K .Set

// Name
  rule #dBound( I:Int ;    _:Var     ) => @x(I)
  rule #dBound( I:Int ; @\(_:Var)    ) => @x(I)
  rule #dBound( I:Int ; @P:Proc      ) => @#dBound(I;P) requires notBool isProcVar(P)
  rule #dBound( I:Int ; @P:ProcPat   ) => @#dBound(I;P) requires notBool isProcVar(P)
  rule #dBound( _:Int ;  A:BoundName ) => A
  rule #dBound( _:Int ; \_           ) => \_

  rule #dBound( _:Int ; A:SimplePat ) => A
  rule #dBound( I:Int ; A:Proc    /\ B:ProcPat ) => #dBound(I;A) /\ #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:ProcPat /\ B:Proc    ) => #dBound(I;A) /\ #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:ProcPat /\ B:ProcPat ) => #dBound(I;A) /\ #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:Proc    \/ B:ProcPat ) => #dBound(I;A) \/ #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:ProcPat \/ B:Proc    ) => #dBound(I;A) \/ #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:ProcPat \/ B:ProcPat ) => #dBound(I;A) \/ #dBound(I +Int size(#FV(A));B)

  // several Name[Pat]s
  rule #dBound( I:Int ; A:Name    , B:Names    ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:NamePat , B:Names    ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:Name    , B:NamePats ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:NamePat , B:NamePats ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)

// TODO: finish!!! need another Int param for channel index
// Binds -- increase level for listening variables, constant level for channels
  // Linear
    // unguarded
  rule #dBound( I:Int ;; <- A:Name  ) =>  <- #dBound(I;A)
  rule #dBound( I:Int ;;    B:Lbind ) => #dBound(1,0;#bvar(B)) <- #dBound(I;#chan(B))
       requires notBool isEmptyLbind(B)
  rule #dBound( I:Int ;; A:Lbind & B:Lbind )
    => #dBound(I;;A) & #dBound+(I +Int size(#RV(A));size(#LV(A));;B)
  rule #dBound( I:Int ;; A:Lbind & B:Lbinds )
    => #dBound(I;;A) & #dBound+(I +Int size(#RV(A));size(#LV(A));;B)
  rule #dBound+( I:Int ; _:Int ;; <- A:Name  ) =>  <- #dBound(I;A)
  rule #dBound+( I:Int ; J:Int ;;    B:Lbind ) => #dBound(1,J;#bvar(B)) <- #dBound(I;#chan(B))
       requires notBool isEmptyLbind(B)
  rule #dBound+( I:Int ; J:Int ;; A:Lbind & B:Lbind )
    => #dBound(1,J;#bvar(A)) <- #dBound(I;#chan(A)) &
       #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B)
  rule #dBound+( I:Int ; J:Int ;; A:Lbind & B:Lbinds )
    => #dBound(1,J;#bvar(A)) <- #dBound(I;#chan(A)) &
       #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B)
    // guarded
//  rule #dBound( I:Int ;; B:Lbind  if G:BExp )
//    => #dBound(I;;B) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));G))
//  rule #dBound( I:Int ;; B:Lbinds if G:BExp )
//    => #dBound(I;;B) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));G))

  // Peek
    // unguarded
  rule #dBound( I:Int ;; <<- A:Name  ) =>  <<- #dBound(I;A)
  rule #dBound( I:Int ;;     B:Pbind ) => #dBound(1,0;#bvar(B)) <<- #dBound(I;#chan(B))
       requires notBool isEmptyPbind(B)
  rule #dBound( I:Int ;; A:Pbind & B:Pbind )
    => #dBound(I;;A) & #dBound+(I +Int size(#RV(A));size(#LV(A));;B)
  rule #dBound( I:Int ;; A:Pbind & B:Pbinds )
    => #dBound(I;;A) & #dBound+(I +Int size(#RV(A));size(#LV(A));;B)
  rule #dBound+( I:Int ; _:Int ;; <<- A:Name  ) => <<- #dBound(I;A)
  rule #dBound+( I:Int ; J:Int ;;     B:Pbind )=> #dBound(1,J;#bvar(B)) <<- #dBound(I;#chan(B))
       requires notBool isEmptyPbind(B)
  rule #dBound+( I:Int ; J:Int ;; A:Pbind & B:Pbind )
    => #dBound(1,J;#bvar(A)) <<- #dBound(I;#chan(A)) &
       #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B)
  rule #dBound+( I:Int ; J:Int ;; A:Pbind & B:Pbinds )
    => #dBound(1,J;#bvar(A)) <<- #dBound(I;#chan(A)) &
       #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B)
    // guarded
//  rule #dBound( I:Int ;; B:Pbind  if G:BExp )
//    => #dBound(I;;B) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));G))
//  rule #dBound( I:Int ;; B:Pbinds if G:BExp )
//    => #dBound(I;;B) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));G))

  // Repeat
    // unguarded
  rule #dBound( I:Int ;; <= A:Name  ) =>  <= #dBound(I;A)
  rule #dBound( I:Int ;;    B:Rbind ) => #dBound(1,0;#bvar(B)) <= #dBound(I;#chan(B))
       requires notBool isEmptyRbind(B)
  rule #dBound( I:Int ;; A:Rbind & B:Rbind )
    => #dBound(I;;A) & #dBound+(I +Int size(#RV(A));size(#LV(A));;B)
  rule #dBound( I:Int ;; A:Rbind & B:Rbinds )
    => #dBound(I;;A) & #dBound+(I +Int size(#RV(A));size(#LV(A));;B)
  rule #dBound+( I:Int ; _:Int ;; <= A:Name  ) => <= #dBound(I;A)
  rule #dBound+( I:Int ; J:Int ;;    B:Rbind ) => #dBound(1,J;#bvar(B)) <= #dBound(I;#chan(B))
       requires notBool isEmptyRbind(B)
  rule #dBound+( I:Int ; J:Int ;; A:Rbind & B:Rbind )
    => #dBound(1,J;#bvar(A)) <= #dBound(I;#chan(A)) &
       #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B)
  rule #dBound+( I:Int ; J:Int ;; A:Rbind & B:Rbinds )
    => #dBound(1,J;#bvar(A)) <= #dBound(I;#chan(A)) &
       #dBound+(I +Int size(#RV(A));J +Int size(#LV(A));;B)
    // guarded
//  rule #dBound( I:Int ;; B:Rbind  if G:BExp )
//    => #dBound(I;;B) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));G))
//  rule #dBound( I:Int ;; B:Rbinds if G:BExp )
//    => #dBound(I;;B) if #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));G))

// Proc
  rule #dBound( _:Int ;  A:Ground    ) =>  A
  rule #dBound( I:Int ; \(_:Var)     ) =>  x(I)
  rule #dBound( I:Int ; *_:Var       ) =>  x(I)
  rule #dBound( I:Int ; *A:Name      ) => *#dBound(I;A)
  rule #dBound( _:Int ;  A:BoundProc ) =>  A

  // Send
  rule #dBound( I:Int ; A:Name    !  ( B:ProcPats ) ) => #dBound(I;A) !  ( #dBound(I +Int size(#FV(A));B) )
  rule #dBound( I:Int ; A:Name    !  ( B:Procs    ) ) => #dBound(I;A) !  ( #dBound(I +Int size(#FV(A));B) )
  rule #dBound( I:Int ; A:Name    !  (            ) ) => #dBound(I;A) !  ( )
  rule #dBound( I:Int ; A:NamePat !  ( B:ProcPats ) ) => #dBound(I;A) !  ( #dBound(I +Int size(#FV(A));B) )
  rule #dBound( I:Int ; A:NamePat !  ( B:Procs    ) ) => #dBound(I;A) !  ( #dBound(I +Int size(#FV(A));B) )
  rule #dBound( I:Int ; A:NamePat !  (            ) ) => #dBound(I;A) !  ( )
  rule #dBound( I:Int ; A:Name    !! ( B:ProcPats ) ) => #dBound(I;A) !! ( #dBound(I +Int size(#FV(A));B) )
  rule #dBound( I:Int ; A:Name    !! ( B:Procs    ) ) => #dBound(I;A) !! ( #dBound(I +Int size(#FV(A));B) )
  rule #dBound( I:Int ; A:Name    !! (            ) ) => #dBound(I;A) !! ( )
  rule #dBound( I:Int ; A:NamePat !! ( B:ProcPats ) ) => #dBound(I;A) !! ( #dBound(I +Int size(#FV(A));B) )
  rule #dBound( I:Int ; A:NamePat !! ( B:Procs    ) ) => #dBound(I;A) !! ( #dBound(I +Int size(#FV(A));B) )
  rule #dBound( I:Int ; A:NamePat !! (            ) ) => #dBound(I;A) !! ( )

  // Receive -- increase level for listening variables, constant for channel variables -- TODO: fix
  // Linear
    // Single
      // unguarded
  rule #dBound( I:Int ; for( B:Lbind ){ C:Proc } )
    => for( #dBound(I;;B) ){#dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));C))}
      // guarded
  rule #dBound( I:Int ; for( B:Lbind if G:BExp ){ C:Proc } )
    => for( #dBound(I;;B) if #sub(#mapify(1,0;#bvar(B));G) ){
       #dBound(I +Int size(#RV(B)) +Int size(#FV(G));#sub(#mapify(1,0;#bvar(B));C)) }
    // Multi
      // unguarded
  rule #dBound( I:Int ; for( B:Lbinds ){ C:Proc } )
    => for( #dBound(I;;B) ){
       #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));C)) }
      // guarded
  rule #dBound( I:Int ; for( B:Lbinds if G:BExp ){ C:Proc } )
    => for( #dBound(I;;B if G) ){
       #dBound(I +Int size(#RV(B)) +Int size(#FV(G));#sub(#mapify(1,0;#bvar(B));C)) }

  // Peek
    // Single
      // unguarded
  rule #dBound( I:Int ; for( B:Pbind ){ C:Proc } )
    => for( #dBound(I;;B) ){
       #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));C)) }
      // guarded
  rule #dBound( I:Int ; for( B:Pbind if G:BExp ){ C:Proc } )
    => for( #dBound(I;;B if G) ){
       #dBound(I +Int size(#RV(B)) +Int size(#FV(G));#sub(#mapify(1,0;#bvar(B));C)) }
    // Multi
      // unguarded
  rule #dBound( I:Int ; for( B:Pbinds ){ C:Proc } )
    => for( #dBound(I;;B) ){
       #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));C)) }
      // guarded
  rule #dBound( I:Int ; for( B:Pbinds if G:BExp ){ C:Proc } )
    => for( #dBound(I;;B if G) ){
       #dBound(I +Int size(#RV(B)) +Int size(#FV(G));#sub(#mapify(1,0;#bvar(B));C)) }

  // Repeated
    // Single
      // unguarded
  rule #dBound( I:Int ; for( B:Rbind ){ C:Proc } )
    => for( #dBound(I;;B) ){
       #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));C)) }
      // guarded
  rule #dBound( I:Int ; for( B:Rbind if G:BExp ){ C:Proc } )
    => for( #dBound(I;;B if G) ){
       #dBound(I +Int size(#RV(B)) +Int size(#FV(G));#sub(#mapify(1,0;#bvar(B));C)) }
    // Multi
      // unguarded
  rule #dBound( I:Int ; for( B:Rbinds ){ C:Proc } )
    => for( #dBound(I;;B) ){
       #dBound(I +Int size(#RV(B));#sub(#mapify(1,0;#bvar(B));C)) }
      // guarded
  rule #dBound( I:Int ; for( B:Rbinds if G:BExp ){ C:Proc } )
    => for( #dBound(I;;B if G) ){
       #dBound(I +Int size(#RV(B)) +Int size(#FV(G));#sub(#mapify(1,0;#bvar(B));C)) }

  // Par -- index A & increase index for B by size(#FV(A))
  rule #dBound( I:Int ; A:Proc | B:Proc ) => #dBound(I;A) | #dBound(I +Int size(#FV(A));B)
       requires notBool isPar(A)

  // New -- increase level for declared variables -- TODO: test
  rule #dBound( I:Int ; new A:VarDecs in { B:Proc    } )
    => new #dbNew(1,0;#indecs(A)) in { #dBound(I;#sub(#mapNew(1,0;#indecs(A));B)) }
  rule #dBound( I:Int ; new A:VarDecs in { B:ProcPat } )
    => new #dbNew(1,0;#indecs(A)) in { #dBound(I;#sub(#mapNew(1,0;#indecs(A));B)) }
    // only applied after #indecs
  rule #mapNew( I:Int ; A:Var                ) => A |-> n(I)
  rule #mapNew( I:Int ; A:Var ( _:Uri )      ) => A |-> n(I)
  rule #mapNew( I:Int ; A:VarDec , B:VarDecs ) => #mapNew(I;A) #mapNew(I +Int 1;B)

 // Collection
  // RhoLists -- TODO: other ListPats
  rule #dBound( _:Int ; [ ] ) => [ ]
  rule #dBound( I:Int ; [ A:Procs ] ) => [ #dBound(I;A) ]
  // RhoMaps -- TODO: other MapPats
    // applied after normalization
  rule #dBound( _:Int ; { } ) => { }
  rule #dBound( I:Int ; { A:RhoKVPairs } ) => { #dBound(I;A) }
  rule #dBound( I:Int ; { A:RhoKVPats  } ) => { #dBound(I;A) }
    // KVPairs
  rule #dBound( I:Int ; A:Proc    : B:Proc    ) => #dBound(I;A) : #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:Proc    : B:ProcPat ) => #dBound(I;A) : #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:ProcPat : B:Proc    ) => #dBound(I;A) : #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:ProcPat : B:ProcPat ) => #dBound(I;A) : #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:RhoKVPair , B:RhoKVPairs ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:RhoKVPair , B:RhoKVPats  ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:RhoKVPat  , B:RhoKVPairs ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:RhoKVPat  , B:RhoKVPats  ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  // RhoSets -- TODO: other SetPats
    // applied after normalization
  rule #dBound( _:Int ; Set( ) ) => Set( )
  rule #dBound( I:Int ; Set( A:Procs    ) ) => Set( #dBound(I;A) )
  rule #dBound( I:Int ; Set( A:ProcPats ) ) => Set( #dBound(I;A) )
  // RhoTuples
  rule #dBound( I:Int ; ( A:Procs    ,) ) => ( #dBound(I;A) ,)
  rule #dBound( I:Int ; ( A:ProcPats ,) ) => ( #dBound(I;A) ,)

  // several Names -- increase index for each free variable
  rule #dBound( I:Int ; A:Name    , B:Names    ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:Name    , B:NamePats ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:NamePat , B:Names    ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:NamePat , B:NamePats ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)

  // several Procs -- increase index for each free variable
  rule #dBound( I:Int ; A:Proc    , B:Procs    ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:Proc    , B:ProcPats ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:ProcPat , B:Procs    ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)
  rule #dBound( I:Int ; A:ProcPat , B:ProcPats ) => #dBound(I;A) , #dBound(I +Int size(#FV(A));B)

// Match -- TODO

// Select -- TODO

//--- Nested ---//
  // Name
  rule #dBound( I:Int , J:Int ;  _:Var       ) => @x(I,J)
  rule #dBound( I:Int , J:Int ; @A:Proc      ) => @#dBound(I,J;A)
  rule #dBound( _:Int , _:Int ;  A:BoundName ) => A

    // several Names
  rule #dBound( I:Int , J:Int ; A:Name , B:Names )
    => #dBound(I,J;A) , #dBound(I,J +Int size(#FV(A));B)

// Binds -- TODO: guards & simplify
  // single -- increase level & restart index at new level on variables
    // unguarded
  rule #dBound( I:Int , J:Int ;; Y:NamePats <-  X:Name )
    => #dBound(I +Int 1,0;Y) <- #dBound(I,J;X)
  rule #dBound( I:Int , J:Int ;; Y:Names    <-  X:Name )
    => #dBound(I +Int 1,0;Y) <- #dBound(I,J;X)
  rule #dBound( I:Int , J:Int ;; <-  X:Name ) =>  <- #dBound(I,J;X)
  rule #dBound( I:Int , J:Int ;; Y:NamePats <=  X:Name )
    => #dBound(I +Int 1,0;Y) <= #dBound(I,J;X)
  rule #dBound( I:Int , J:Int ;; Y:Names    <=  X:Name )
    => #dBound(I +Int 1,0;Y) <= #dBound(I,J;X)
  rule #dBound( I:Int , J:Int ;; <=  X:Name ) =>  <= #dBound(I,J;X)
  rule #dBound( I:Int , J:Int ;; Y:NamePats <<- X:Name )
    => #dBound(I +Int 1,0;Y) <<- #dBound(I,J;X)
  rule #dBound( I:Int , J:Int ;; Y:Names    <<- X:Name )
    => #dBound(I +Int 1,0;Y) <<- #dBound(I,J;X)
  rule #dBound( I:Int , J:Int ;; <<- X:Name ) => <<- #dBound(I,J;X)
    // guarded
//  rule #dBound( I:Int , J:Int ;; B:Lbind if G:BExp )
//    => #dBound(I,J;;B) if #dBound(I,J +Int size(#BV(#chan(B)));#sub(#mapify(I +Int 1,0;#bvar(B));G))

//  rule #dBound( I:Int , J:Int ;; B:Pbind if G:BExp )
//    => #dBound(I,J;;B) if #dBound(I,J +Int size(#BV(#chan(B)));#sub(#mapify(I +Int 1,0;#bvar(B));G))

//  rule #dBound( I:Int , J:Int ;; B:Rbind if G:BExp )
//    => #dBound(I,J;;B) if #dBound(I,J +Int size(#BV(#chan(B)));#sub(#mapify(I +Int 1,0;#bvar(B));G))

  // multiple -- TODO: check levels & channels
    // unguarded
  rule #dBound( I:Int , J:Int ;; A:Lbind & B:Lbind  )
    => #dBound(I,J;;A) & #dBound(I,J +Int size(#LV(A));;B)
  rule #dBound( I:Int , J:Int ;; A:Lbind & B:Lbinds )
    => #dBound(I,J;;A) & #dBound(I,J +Int size(#LV(A));;B)
  rule #dBound( I:Int , J:Int ;; A:Pbind & B:Pbind  )
    => #dBound(I,J;;A) & #dBound(I,J +Int size(#LV(A));;B)
  rule #dBound( I:Int , J:Int ;; A:Pbind & B:Pbinds )
    => #dBound(I,J;;A) & #dBound(I,J +Int size(#LV(A));;B)
  rule #dBound( I:Int , J:Int ;; A:Rbind & B:Rbind  )
    => #dBound(I,J;;A) & #dBound(I,J +Int size(#LV(A));;B)
  rule #dBound( I:Int , J:Int ;; A:Rbind & B:Rbinds )
    => #dBound(I,J;;A) & #dBound(I,J +Int size(#LV(A));;B)
    // guarded
//  rule #dBound( I:Int , J:Int ;; A:Lbinds if G:BExp )
//    => #dBound(I,J;;A) if #dBound(I,J +Int size(#LV(A));#sub(#dBound(I,J;#bvar(A));#bvar(A);G))

//  rule #dBound( I:Int , J:Int ;; A:Pbinds if G:BExp )
//    => #dBound(I,J;;A) if #dBound(I,J +Int size(#LV(A));#sub(#dBound(I,J;#bvar(A));#bvar(A);G))

//  rule #dBound( I:Int , J:Int ;; A:Rbinds if G:BExp )
//    => #dBound(I,J;;A) if #dBound(I,J +Int size(#LV(A));#sub(#dBound(I,J;#bvar(A));#bvar(A);G))

  // Proc
  rule #dBound( _:Int , _:Int ;   A:Ground    ) =>  A
  rule #dBound( I:Int , J:Int ; \(_:Var)      ) =>  x(I,J)
  rule #dBound( I:Int , J:Int ;  *A:Name      ) => *#dBound(I,J;A)
  rule #dBound( _:Int , _:Int ;   A:BoundProc ) =>  A

    // Send
  rule #dBound( I:Int , J:Int ; A:Name    !  ( B:ProcPats ) ) => #dBound(I,J;A) ! ( #dBound(I,J +Int size(#FV(A));B) )
  rule #dBound( I:Int , J:Int ; A:Name    !  ( B:Procs    ) ) => #dBound(I,J;A) ! ( #dBound(I,J +Int size(#FV(A));B) )
  rule #dBound( I:Int , J:Int ; A:Name    !  (            ) ) => #dBound(I,J;A) ! (  )
  rule #dBound( I:Int , J:Int ; A:NamePat !  ( B:ProcPats ) ) => #dBound(I,J;A) ! ( #dBound(I,J +Int size(#FV(A));B) )
  rule #dBound( I:Int , J:Int ; A:NamePat !  ( B:Procs    ) ) => #dBound(I,J;A) ! ( #dBound(I,J +Int size(#FV(A));B) )
  rule #dBound( I:Int , J:Int ; A:NamePat !  (            ) ) => #dBound(I,J;A) ! (  )
  rule #dBound( I:Int , J:Int ; A:Name    !! ( B:ProcPats ) ) => #dBound(I,J;A) !!( #dBound(I,J +Int size(#FV(A));B) )
  rule #dBound( I:Int , J:Int ; A:Name    !! ( B:Procs    ) ) => #dBound(I,J;A) !!( #dBound(I,J +Int size(#FV(A));B) )
  rule #dBound( I:Int , J:Int ; A:Name    !! (            ) ) => #dBound(I,J;A) !!(  )
  rule #dBound( I:Int , J:Int ; A:NamePat !! ( B:ProcPats ) ) => #dBound(I,J;A) !!( #dBound(I,J +Int size(#FV(A));B) )
  rule #dBound( I:Int , J:Int ; A:NamePat !! ( B:Procs    ) ) => #dBound(I,J;A) !!( #dBound(I,J +Int size(#FV(A));B) )
  rule #dBound( I:Int , J:Int ; A:NamePat !! (            ) ) => #dBound(I,J;A) !!(  )
/*
    // Receive -- increase nesting index for bound Names -- TODO: simplify
  // linear
    // no listening variables
  rule #dBound( I:Int , J:Int ; for( B:Lbind ){ P:Proc } )
    => for( #dBound(I,J;;B) ){ #dBound(I,J;#sub(#mapify(I,J;;B);P)) }
    // listening for Var
      // if Var is fresh w.r.t. Mem, do usual substitution for Var
      // if Var is not fresh w.r.t. Mem, substitute for the value associated with Var
  rule #dBound( I:Int , J:Int ; for( Y:Var <- X:Name ){ P:Proc } )
    => for( @x(I +Int 1,0) <- #dBound(I,J;X) ){
            #dBound(I,J; #sub(@x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> @x(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Var <- X:Name if B:BExp ){ P:Proc } )
    => for( @x(I +Int 1,0) <- #dBound(I,J;X;Mem) if #sub(@x(I +Int 1,0);#sub(Mem;Y);B) ){
            #dBound( I,J +Int size(#FV(X)) ; #sub(@x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> @x(I +Int 1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @x(I +Int 1,0) <- #dBound(I,J;X;Mem) ){
            #dBound( I,J +Int size(#FV(X)); #sub(x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> x(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @x(I +Int 1,0) <- #dBound(I,J;X;Mem) if #sub(x(I +Int 1,0);#sub(Mem;Y);B) ){
            #dBound( I,J +Int size(#FV(X)) ; #sub(x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> x(I +Int 1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <- X:Name ){ P:Proc } ; Mem:Map )
    => for( @#dBound(I +Int 1,0;Y;.Map) <- #dBound(I,J;X;Mem) ){
             #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <- X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @#dBound(I +Int 1,0;Y;.Map) <- #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;B) ){
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
    => for( @x(I +Int 1,0) <= #dBound(I,J;X;Mem) ){
            #dBound( I,J +Int size(#FV(X)) ; #sub(@x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> @x(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Var <= X:Name if B:BExp ){ P:Proc } ; Mem:Map )
    => for( @x(I +Int 1,0) <= #dBound(I,J;X;Mem) if #sub(@x(I +Int 1,0);#sub(Mem;Y);B) ){
            #dBound( I,J +Int size(#FV(X)) ; #sub(@x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> @x(I +Int 1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @x(I +Int 1,0) <= #dBound(I,J;X;Mem) ){
            #dBound( I,J +Int size(#FV(X)); #sub(x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> x(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @x(I +Int 1,0) <= #dBound(I,J;X;Mem) if #sub(x(I +Int 1,0);#sub(Mem;Y);G) ){
            #dBound( I,J +Int size(#FV(X)) ; #sub(x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> x(I +Int 1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <= X:Name ){ P:Proc } ; Mem:Map )
    => for( @#dBound(I +Int 1,0;Y;.Map) <= #dBound(I,J;X;Mem) ){
             #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <= X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @#dBound(I +Int 1,0;Y;.Map) <= #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;G) ){
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
    => for( @x(I +Int 1,0) <<- #dBound(I,J;X;Mem) ){
            #dBound( I,J +Int size(#FV(X)) ; #sub(@x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> @x(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( Y:Var <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @x(I +Int 1,0) <<- #dBound(I,J;X;Mem) if #sub(@x(I +Int 1,0);#sub(Mem;Y);G) ){
            #dBound( I,J +Int size(#FV(X)) ; #sub(@x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> @x(I +Int 1,0) ) ) }
    // listening for @ProcVar
      // if ProcVar is fresh w.r.t. Mem, do usual substitution for ProcVar
      // if ProcVar is not fresh w.r.t. Mem, substitute for the value associated with ProcVar
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <<- X:Name ){ P:Proc } ; Mem:Map )
    => for( @x(I +Int 1,0) <<- #dBound(I,J;X;Mem) ){
            #dBound( I,J +Int size(#FV(X)); #sub(x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> x(I +Int 1,0) ) ) }
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:ProcVar <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @x(I +Int 1,0) <<- #dBound(I,J;X;Mem) if #sub(x(I +Int 1,0);#sub(Mem;Y);G) ){
            #dBound( I,J +Int size(#FV(X)) ; #sub(x(I +Int 1,0);#sub(Mem;Y);P) ; updateMap( Mem , Y |-> x(I +Int 1,0) ) ) }
    // listening for @Proc for general Proc -- free variables in Proc are bound in the continuation
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <<- X:Name ){ P:Proc } ; Mem:Map )
    => for( @#dBound(I +Int 1,0;Y;.Map) <<- #dBound(I,J;X;Mem) ){
             #dBound( I,J +Int size(#FV(X)) ; #sub(#dBound(I +Int 1,0;Y;.Map);Y;P) ; updateMap( Mem , #mapify(I +Int 1,0;Y;.Map) ) ) }
       requires notBool isProcVar(Y)
        // guarded
  rule #dBound( I:Int , J:Int ; for( @Y:Proc <<- X:Name if G:BExp ){ P:Proc } ; Mem:Map )
    => for( @#dBound(I +Int 1,0;Y;.Map) <<- #dBound(I,J;X;Mem) if #sub(#dBound(I +Int 1,0;Y;.Map);Y;G) ){
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
*/
  // Par
  rule #dBound( I:Int , J:Int ; A:Proc | B:Proc ) => #dBound(I,J;A) | #dBound(I,J +Int size(#FV(A));B)
       requires notBool isPar(A)

  // New -- TODO: test
    // if new A:VarDecs in { B:Proc[Pat] } appears in a matching pattern,
    // the index level is increased for the declared variables A,
    // and remains unchanged for variables appearing in the Proc[Pat] B
  rule #dBound( I:Int , J:Int ; new A:VarDecs in { B:Proc    } )
    => new #dbNew(I +Int 1,0;#indecs(A)) in { #dBound(I,J;#sub(#mapNew(I +Int 1,0;#indecs(A));B)) }
  rule #dBound( I:Int , J:Int ; new A:VarDecs in { B:ProcPat } )
    => new #dbNew(I +Int 1,0;#indecs(A)) in { #dBound(I,J;#sub(#mapNew(I +Int 1,0;#indecs(A));B)) }
    // only applied after #indecs
  rule #mapNew( I:Int , J:Int  ; A:Var                ) => A |-> n(I,J)
  rule #mapNew( I:Int , J:Int  ; A:Var ( _:Uri )      ) => A |-> n(I,J)
  rule #mapNew( I:Int , J:Int  ; A:VarDec , B:VarDecs ) => #mapNew(I,J;A) #mapNew(I,J +Int 1; B)

  // Procs
  rule #dBound( I:Int , J:Int ; A:Proc , B:Procs ) => #dBound(I,J;A) , #dBound(I,J +Int size(#FV(A));B)

  // Collections
    // RhoLists
  rule #dBound( _:Int , _:Int ; [ ] ) => [ ]
  rule #dBound( I:Int , J:Int ; [ A:Procs    ] ) => [ #dBound(I,J;A) ]
  rule #dBound( I:Int , J:Int ; [ A:ProcPats ] ) => [ #dBound(I,J;A) ]
    // RhoMaps
  rule #dBound( _:Int , _:Int ; { } ) => { }
  rule #dBound( I:Int , J:Int ; { A:RhoKVPairs } ) => { #dBound(I,J;A) }
  rule #dBound( I:Int , J:Int ; { A:RhoKVPats  } ) => { #dBound(I,J;A) }
    // KVPairs
  rule #dBound( I:Int , J:Int ; A:Proc    : B:Proc    ) => #dBound(I,J;A) : #dBound(I,J +Int size(#FV(A));B)
  rule #dBound( I:Int , J:Int ; A:Proc    : B:ProcPat ) => #dBound(I,J;A) : #dBound(I,J +Int size(#FV(A));B)
  rule #dBound( I:Int , J:Int ; A:ProcPat : B:Proc    ) => #dBound(I,J;A) : #dBound(I,J +Int size(#FV(A));B)
  rule #dBound( I:Int , J:Int ; A:ProcPat : B:ProcPat ) => #dBound(I,J;A) : #dBound(I,J +Int size(#FV(A));B)
  rule #dBound( I:Int , J:Int ; A:RhoKVPair , B:RhoKVPairs ) => #dBound(I,J;A) , #dBound(I,J +Int size(#FV(A));B)
  rule #dBound( I:Int , J:Int ; A:RhoKVPair , B:RhoKVPats  ) => #dBound(I,J;A) , #dBound(I,J +Int size(#FV(A));B)
  rule #dBound( I:Int , J:Int ; A:RhoKVPat  , B:RhoKVPairs ) => #dBound(I,J;A) , #dBound(I,J +Int size(#FV(A));B)
  rule #dBound( I:Int , J:Int ; A:RhoKVPat  , B:RhoKVPats  ) => #dBound(I,J;A) , #dBound(I,J +Int size(#FV(A));B)
  // RhoSets
  rule #dBound( _:Int , _:Int ; Set( ) ) => Set( )
  rule #dBound( I:Int , J:Int ; Set( A:Procs    ) ) => Set( #dBound(I,J;A) )
  rule #dBound( I:Int , J:Int ; Set( A:ProcPats ) ) => Set( #dBound(I,J;A) )
  // RhoTuples
  rule #dBound( I:Int , J:Int ; ( A:Procs    ,) ) => ( #dBound(I,J;A) ,)
  rule #dBound( I:Int , J:Int ; ( A:ProcPats ,) ) => ( #dBound(I,J;A) ,)

// Match -- TODO
// Select -- TODO

//---------------
//--- #mapify ---
//---------------
// returns map from top-level variables to (dBound) DeBruijn indices
// input always comes from a matching pattern in a Receive, Match, or Select
  rule #mapify( A:Names    ) => #mapify(0;A)
  rule #mapify( A:Procs    ) => #mapify(0;A)
  rule #mapify( A:NamePats ) => #mapify(0;A)
  rule #mapify( A:ProcPats ) => #mapify(0;A)

  // WildCard does not add any bindings
  rule #mapify( _:Int ; \_ ) => .Map

  // Empty Name & Proc
  rule #mapify( _:Int ; EmptyN ) => .Map
  rule #mapify( _:Int ; EmptyP ) => .Map

// Name
  rule #mapify( I:Int ; A:Var       ) => A |-> @x(I)
  rule #mapify( _:Int ; _:BoundName ) => .Map
  rule #mapify( I:Int ; @A:Proc     ) => #mapify(I;A)
  rule #mapify( I:Int ; @A:ProcPat  ) => #mapify(I;A)
  rule #mapify( _:Int ; @sub        ) => .Map

  // several Names -- channels in Binds
  rule #mapify( I:Int ; A:Name    , B:Names    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Name    , B:NamePats ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:NamePat , B:Names    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:NamePat , B:NamePats ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)

// Proc
  rule #mapify( _:Int ;  _:Ground    ) => .Map
  rule #mapify( I:Int ; \A:Var       ) => \A |-> x(I)
  rule #mapify( _:Int ;  _:BoundProc ) => .Map
  rule #mapify( I:Int ; *A:Name      ) => #mapify(I;A)
  rule #mapify( _:Int ;    sub       ) => .Map

  // several Procs
  rule #mapify( I:Int ; A:Proc    , B:Procs    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Proc    , B:ProcPats ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:ProcPat , B:Procs    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:ProcPat , B:ProcPats ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)

  // New
    // if @{new A:VarDecs in { B:Proc[Pat] }} appears in a listen pattern,
    // the only listen-level binding variables come from #FV(B) -Set #DV(A)
    // so the declared variables are hidden from #mapify
  rule #mapify( I:Int ; new A:VarDecs in { B:Proc    } ) => #mapify(I;#sub(#mapSub(#DV(A));B))
  rule #mapify( I:Int ; new A:VarDecs in { B:ProcPat } ) => #mapify(I;#sub(#mapSub(#DV(A));B))

  // Par
  rule #mapify( I:Int ; A:Proc    | B:Proc    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
       requires notBool isPar(A)
  rule #mapify( I:Int ; A:Proc    | B:ProcPat ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
       requires notBool isPar(A)
  rule #mapify( I:Int ; A:ProcPat | B:Proc    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
       requires notBool isParPat(A)
  rule #mapify( I:Int ; A:ProcPat | B:ProcPat ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
       requires notBool isParPat(A)

// TODO: Match & Select

  // Send
  rule #mapify( I:Int ; A:Name    !  ( B:ProcPats ) ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Name    !  ( B:Procs    ) ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Name    !  (            ) ) => #mapify(I;A)
  rule #mapify( I:Int ; A:NamePat !  ( B:ProcPats ) ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:NamePat !  ( B:Procs    ) ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:NamePat !  (            ) ) => #mapify(I;A)
  rule #mapify( I:Int ; A:Name    !! ( B:ProcPats ) ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Name    !! ( B:Procs    ) ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Name    !! (            ) ) => #mapify(I;A)
  rule #mapify( I:Int ; A:NamePat !! ( B:ProcPats ) ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:NamePat !! ( B:Procs    ) ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:NamePat !! (            ) ) => #mapify(I;A)

  // Receive
    // TODO: more testing & simplify?
    // mapSub used to hide listening variables from generating additional substitution mappings
       // collect variables from the channel first, then from the guard with listening variables hidden,
       // then from the continuation with listen variables hidden
  rule #mapify( I:Int ; A:Receive )
    => #mapify(I;#chan(A)) #mapify(I +Int size(#RV(A));#sub(#mapSub(#LV(A));#guard(A)))
       #mapify(I +Int size(#RV(A)) +Int size(#FV(#guard(A)) -Set #LV(A));#sub(#mapSub(#LV(A));#cont(A)))
  rule #mapify( I:Int ; A:RecPat )
    => #mapify(I;#chan(A)) #mapify(I +Int size(#RV(A));#sub(#mapSub(#LV(A));#guard(A)))
       #mapify(I +Int size(#RV(A)) +Int size(#FV(#guard(A)) -Set #LV(A));#sub(#mapSub(#LV(A));#cont(A)))

  rule #mapify( I:Int ;; A:Bind ) => #mapify(I;#chan(A))
  rule #mapify( I:Int ;; A:Bind & B:Bind  ) => #mapify(I;#chan(A)) #mapify(I +Int size(#LV(A));;B)
  rule #mapify( I:Int ;; A:Bind & B:Binds ) => #mapify(I;#chan(A)) #mapify(I +Int size(#LV(A));;B)
//  rule #mapify( I:Int ;; A:Pbind ) => updateMap( Mem , #mapify(I;#chan(A);Mem) )
//  rule #mapify( I:Int ;; A:Pbind & B:Pbind  ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )
//  rule #mapify( I:Int ;; A:Pbind & B:Pbinds ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )
//  rule #mapify( I:Int ;; A:Rbind ) => updateMap( Mem , #mapify(I;#chan(A);Mem) )
//  rule #mapify( I:Int ;; A:Rbind & B:Rbind  ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )
//  rule #mapify( I:Int ;; A:Rbind & B:Rbinds ) => updateMap( Mem , #mapify(I;#chan(A);Mem) #mapify(I +Int size(#LV(A));;B;;Mem) )

// Collection
  // RhoLists
  rule #mapify( _:Int ; [ ] ) => .Map
  rule #mapify( I:Int ; [ A:Procs    ] ) => #mapify(I;A)
  rule #mapify( I:Int ; [ A:ProcPats ] ) => #mapify(I;A)
  // RhoMaps
    // applied after normalization
  rule #mapify( _:Int ; { } ) => .Map
  rule #mapify( I:Int ; { A:RhoKVPairs } ) => #mapify(I;A)
  rule #mapify( I:Int ; { A:RhoKVPats  } ) => #mapify(I;A)
    // KV Pairs
  rule #mapify( I:Int ; A:Proc    : B:Proc    ) => #mapify(I;A) #mapify(I;B)
  rule #mapify( I:Int ; A:Proc    : B:ProcPat ) => #mapify(I;A) #mapify(I;B)
  rule #mapify( I:Int ; A:ProcPat : B:Proc    ) => #mapify(I;A) #mapify(I;B)
  rule #mapify( I:Int ; A:ProcPat : B:ProcPat ) => #mapify(I;A) #mapify(I;B)
  rule #mapify( I:Int ; A:RhoKVPair , B:RhoKVPairs ) => #mapify(I;A) #mapify(I;B)
  rule #mapify( I:Int ; A:RhoKVPair , B:RhoKVPats  ) => #mapify(I;A) #mapify(I;B)
  rule #mapify( I:Int ; A:RhoKVPat  , B:RhoKVPairs ) => #mapify(I;A) #mapify(I;B)
  rule #mapify( I:Int ; A:RhoKVPat  , B:RhoKVPats  ) => #mapify(I;A) #mapify(I;B)
  // RhoSets
    // applied after normalization
  rule #mapify( _:Int ; Set( ) ) => .Map
  rule #mapify( I:Int ; Set( A:Procs    ) ) => #mapify(I;A)
  rule #mapify( I:Int ; Set( A:ProcPats ) ) => #mapify(I;A)
  // RhoTuples
  rule #mapify( I:Int ; ( A:Procs    ,) ) => #mapify(I;A)
  rule #mapify( I:Int ; ( A:ProcPats ,) ) => #mapify(I;A)

// Expressions -- TODO: AExp, List, String
  // BExp
  rule #mapify( I:Int ; not A:BExp ) => #mapify(I;A)
  rule #mapify( I:Int ; A:BExp and B:BExp ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:BExp or  B:BExp ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:AExp <=  B:AExp ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:AExp <   B:AExp ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:AExp >=  B:AExp ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:AExp >   B:AExp ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Name ==  B:Name ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Name !=  B:Name ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Proc ==  B:Proc ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Proc !=  B:Proc ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Proc    matches B:Proc    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Proc    matches B:ProcPat ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:ProcPat matches B:ProcPat ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)

  // Pattern expressions
  rule #mapify( _:Int ; _:SimplePat ) => .Map
  rule #mapify( I:Int ; ~ A:Proc    ) => #mapify(I;A)
  rule #mapify( I:Int ; ~ A:ProcPat ) => #mapify(I;A)
  rule #mapify( I:Int ; A:Proc    /\ B:ProcPat ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:ProcPat /\ B:Proc    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:ProcPat /\ B:ProcPat ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Proc    \/ B:Proc    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:Proc    \/ B:ProcPat ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:ProcPat \/ B:Proc    ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)
  rule #mapify( I:Int ; A:ProcPat \/ B:ProcPat ) => #mapify(I;A) #mapify(I +Int size(#FV(A));B)

  // NamePat
  rule #mapify( _:Int ; _:SimpleNamePat ) => .Map
  rule #mapify( I:Int ; @A:ProcPat ) => #mapify(I;A)

//----------------------
//--- Nested #mapify ---
//----------------------
  rule #mapify( _:Int , _:Int ; \_               ) => .Map
  rule #mapify( _:Int , _:Int ;  _:SimplePat     ) => .Map
  rule #mapify( _:Int , _:Int ;  _:SimpleNamePat ) => .Map

  // Empty Name & Proc
  rule #mapify( _:Int , _:Int ; EmptyN ) => .Map
  rule #mapify( _:Int , _:Int ; EmptyP ) => .Map

  // Name
  rule #mapify( I:Int , J:Int ;  A:Var      ) => A |-> @x(I,J)
  rule #mapify( I:Int , J:Int ; @A:Proc     ) => #mapify(I,J;A)
  rule #mapify( _:Int , _:Int ; @sub        ) => .Map
  rule #mapify( _:Int , _:Int ; _:BoundName ) => .Map

    // several Name[Pat]s
  rule #mapify( I:Int , J:Int ; A:Name    , B:Names    ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:NamePat , B:Names    ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:Name    , B:NamePats ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:NamePat , B:NamePats ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)

  // Proc
  rule #mapify( _:Int , _:Int ;  _:Ground    ) => .Map
  rule #mapify( I:Int , J:Int ; \A:Var       ) => \A |-> x(I,J)
  rule #mapify( _:Int , _:Int ;  _:BoundProc ) => .Map
  rule #mapify( I:Int , J:Int ; *A:Name      ) => #mapify(I,J;A)
  rule #mapify( _:Int , _:Int ;    sub       ) => .Map
    // several Proc[Pat]s
  rule #mapify( I:Int , J:Int ; A:Proc    , B:Procs    ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:ProcPat , B:Procs    ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:Proc    , B:ProcPats ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:ProcPat , B:ProcPats ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)

  // New
    // if @{new A:VarDecs in { B:Proc[Pat] }} appears in a listen pattern,
    // the only listen-level binding variables come from #FV(B) -Set #DV(A)
    // so the declared variables are hidden from #mapify
  rule #mapify( I:Int , J:Int ; new A:VarDecs in { B:Proc    } ) => #mapify(I,J;#sub(#mapSub(#DV(A));B))
  rule #mapify( I:Int , J:Int ; new A:VarDecs in { B:ProcPat } ) => #mapify(I,J;#sub(#mapSub(#DV(A));B))

  // Par
  rule #mapify( I:Int , J:Int ; A:Proc | B:Proc ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
       requires notBool isPar(A)

  // Send
  rule #mapify( I:Int , J:Int ; A:Name    !  ( B:ProcPats ) ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:Name    !  ( B:Procs    ) ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:Name    !  (            ) ) => #mapify(I,J;A)
  rule #mapify( I:Int , J:Int ; A:NamePat !  ( B:ProcPats ) ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:NamePat !  ( B:Procs    ) ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:NamePat !  (            ) ) => #mapify(I,J;A)
  rule #mapify( I:Int , J:Int ; A:Name    !! ( B:ProcPats ) ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:Name    !! ( B:Procs    ) ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:Name    !! (            ) ) => #mapify(I,J;A)
  rule #mapify( I:Int , J:Int ; A:NamePat !! ( B:ProcPats ) ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:NamePat !! ( B:Procs    ) ) => #mapify(I,J;A) #mapify(I,J +Int size(#FV(A));B)
  rule #mapify( I:Int , J:Int ; A:NamePat !! (            ) ) => #mapify(I,J;A)

  // Receive -- TODO: MRec
    // TODO: more testing
    // mapSub used to hide listening variables from generating additional substitution mappings
    // unguarded
  rule #mapify( I:Int , J:Int ; for( B:Lbind  ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));C))
  rule #mapify( I:Int , J:Int ; for( B:Lbinds ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));C))

  rule #mapify( I:Int , J:Int ; for( B:Pbind  ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));C))
  rule #mapify( I:Int , J:Int ; for( B:Pbinds ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));C))

  rule #mapify( I:Int , J:Int ; for( B:Rbind  ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));C))
  rule #mapify( I:Int , J:Int ; for( B:Rbinds ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));C))

    // guarded
       // collect variables from the channel first, then from the guard with listening variables hidden,
       // then from the continuation with listen variables hidden
  rule #mapify( I:Int , J:Int ; for( B:Lbind  if G:BExp ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));G))
       #mapify(I,J +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B));#sub(#mapSub(#LV(B));C))
  rule #mapify( I:Int , J:Int ; for( B:Lbinds if G:BExp ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));G))
       #mapify(I,J +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B));#sub(#mapSub(#LV(B));C))

  rule #mapify( I:Int , J:Int ; for( B:Pbind  if G:BExp ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));G))
       #mapify(I,J +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B));#sub(#mapSub(#LV(B));C))
  rule #mapify( I:Int , J:Int ; for( B:Pbinds if G:BExp ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));G))
       #mapify(I,J +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B));#sub(#mapSub(#LV(B));C))

  rule #mapify( I:Int , J:Int ; for( B:Rbind  if G:BExp ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));G))
       #mapify(I,J +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B));#sub(#mapSub(#LV(B));C))
  rule #mapify( I:Int , J:Int ; for( B:Rbinds if G:BExp ){ C:Proc } )
    => #mapify(I,J;#chan(B)) #mapify(I,J +Int size(#RV(B));#sub(#mapSub(#LV(B));G))
       #mapify(I,J +Int size(#RV(B)) +Int size(#FV(G) -Set #LV(B));#sub(#mapSub(#LV(B));C))

  rule #mapify( I:Int , J:Int ;; A:Bind ) => #mapify(I,J;#chan(A))
  rule #mapify( I:Int , J:Int ;; A:Bind & B:Bind  ) => #mapify(I,J;#chan(A)) #mapify(I,J +Int size(#LV(A));;B)
  rule #mapify( I:Int , J:Int ;; A:Bind & B:Binds ) => #mapify(I,J;#chan(A)) #mapify(I,J +Int size(#LV(A));;B)


  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]
//  rule   A:Name    !  ( EmptyP ) => A!  ( )  [anywhere, structural]
//  rule   A:Name    !! ( EmptyP ) => A!! ( )  [anywhere, structural]
//  rule   A:NamePat !  ( EmptyP ) => A!  ( )  [anywhere, structural]
//  rule   A:NamePat !! ( EmptyP ) => A!  ( )  [anywhere, structural]

endmodule
