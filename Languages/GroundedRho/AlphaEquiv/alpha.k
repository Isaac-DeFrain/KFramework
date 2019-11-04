// De Bruijn Index/Levels & Alpha Equivalence for Rholang

require "../grho.k"
require "../Substitute/sub.k"

module ALPHA-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Int params: level, index
// Map: current indexing environment map
  // Procs
  syntax         Proc ::= "#deBruijn(" Proc ")"                          [function, poly(0,1)]
                        | "#deBruijn(" Int "," Int ";" Proc  ";" Map ")" [function, poly(0,3)]
  syntax        Procs ::= "#deBruijn(" Int "," Int ";" Procs ";" Map ")" [function]
  // ProcPats
  syntax      ProcPat ::= "#deBruijn(" ProcPat ")"                          [function]
                        | "#deBruijn(" Int "," Int ";" ProcPat ";" Map  ")" [function]
  syntax     ProcPats ::= "#deBruijn(" Int "," Int ";" ProcPats ";" Map ")" [function]
  // Names
  syntax         Name ::= "#deBruijn(" Int "," Int ";" Name  ";" Map ")" [function]
  syntax        Names ::= "#deBruijn(" Int "," Int ";" Names ";" Map ")" [function]
  // NamePats
  syntax      NamePat ::= "#deBruijn(" Int "," Int ";" NamePat  ";" Map ")" [function]
  syntax     NamePats ::= "#deBruijn(" Int "," Int ";" NamePats ";" Map ")" [function]
  // VarDecs
  syntax       VarDec ::= "#dbNew(" Int "," Int ";" VarDec  ")" [function]
  syntax      VarDecs ::= "#dbNew(" Int "," Int ";" VarDecs ")" [function]

// Recursive functions
  // Bind[Pat]s
    // Int params: level , channel index ; binding variable index
  syntax        Lbind ::= "#deBruijn(" Int "," Int ";" Int ";;" Lbind      ";;" Map ")" [function]
  syntax       Lbinds ::= "#deBruijn(" Int "," Int ";" Int ";;" Lbinds     ";;" Map ")" [function]
  syntax     LbindPat ::= "#deBruijn(" Int "," Int ";" Int ";;" LbindPat   ";;" Map ")" [function]
  syntax    LbindPats ::= "#deBruijn(" Int "," Int ";" Int ";;" LbindPats  ";;" Map ")" [function]
  syntax       GLbind ::= "#deBruijn(" Int "," Int ";" Int ";;" GLbind     ";;" Map ")" [function]
  syntax      GLbinds ::= "#deBruijn(" Int "," Int ";" Int ";;" GLbinds    ";;" Map ")" [function]
  syntax    GLbindPat ::= "#deBruijn(" Int "," Int ";" Int ";;" GLbindPat  ";;" Map ")" [function]
  syntax   GLbindPats ::= "#deBruijn(" Int "," Int ";" Int ";;" GLbindPats ";;" Map ")" [function]
  syntax        Pbind ::= "#deBruijn(" Int "," Int ";" Int ";;" Pbind      ";;" Map ")" [function]
  syntax       Pbinds ::= "#deBruijn(" Int "," Int ";" Int ";;" Pbinds     ";;" Map ")" [function]
  syntax     PbindPat ::= "#deBruijn(" Int "," Int ";" Int ";;" PbindPat   ";;" Map ")" [function]
  syntax    PbindPats ::= "#deBruijn(" Int "," Int ";" Int ";;" PbindPats  ";;" Map ")" [function]
  syntax       GPbind ::= "#deBruijn(" Int "," Int ";" Int ";;" GPbind     ";;" Map ")" [function]
  syntax      GPbinds ::= "#deBruijn(" Int "," Int ";" Int ";;" GPbinds    ";;" Map ")" [function]
  syntax    GPbindPat ::= "#deBruijn(" Int "," Int ";" Int ";;" GPbindPat  ";;" Map ")" [function]
  syntax   GPbindPats ::= "#deBruijn(" Int "," Int ";" Int ";;" GPbindPats ";;" Map ")" [function]
  syntax        Rbind ::= "#deBruijn(" Int "," Int ";" Int ";;" Rbind      ";;" Map ")" [function]
  syntax       Rbinds ::= "#deBruijn(" Int "," Int ";" Int ";;" Rbinds     ";;" Map ")" [function]
  syntax     RbindPat ::= "#deBruijn(" Int "," Int ";" Int ";;" RbindPat   ";;" Map ")" [function]
  syntax    RbindPats ::= "#deBruijn(" Int "," Int ";" Int ";;" RbindPats  ";;" Map ")" [function]
  syntax       GRbind ::= "#deBruijn(" Int "," Int ";" Int ";;" GRbind     ";;" Map ")" [function]
  syntax      GRbinds ::= "#deBruijn(" Int "," Int ";" Int ";;" GRbinds    ";;" Map ")" [function]
  syntax    GRbindPat ::= "#deBruijn(" Int "," Int ";" Int ";;" GRbindPat  ";;" Map ")" [function]
  syntax   GRbindPats ::= "#deBruijn(" Int "," Int ";" Int ";;" GRbindPats ";;" Map ")" [function]
  // LetBinds
  syntax      LetBind ::= "#deBruijn(" Int "," Int ";;" LetBind     ";;" Map ")" [function]
  syntax  SeqLetBinds ::= "#deBruijn(" Int "," Int ";;" SeqLetBinds ";;" Map ")" [function]
  syntax  SimLetBinds ::= "#deBruijn(" Int "," Int ";;" SimLetBinds ";;" Map ")" [function]
  syntax
       SeqSimLetBinds ::= "#deBruijn(" Int "," Int ";;" SeqSimLetBinds ";;" Map ")" [function]
  // KVPairs/KVPats
  syntax    RhoKVPair ::= "#deBruijn(" Int "," Int ";" RhoKVPair  ";" Map ")" [function]
  syntax   RhoKVPairs ::= "#deBruijn(" Int "," Int ";" RhoKVPairs ";" Map ")" [function]
  syntax     RhoKVPat ::= "#deBruijn(" Int "," Int ";" RhoKVPat   ";" Map ")" [function]
  syntax    RhoKVPats ::= "#deBruijn(" Int "," Int ";" RhoKVPats  ";" Map ")" [function]
  // InterpMaps
  syntax   InterpMaps ::= "#deBruijn(" Int "," Int ";" InterpMaps ";" Map ")" [function]
// MatchCases
  syntax    MatchCase ::= "#deBruijn(" Int "," Int ";" MatchCase  ";" Map ")" [function]
  syntax   MatchCases ::= "#deBruijn(" Int "," Int ";" MatchCases ";" Map ")" [function]
  syntax     MCasePat ::= "#deBruijn(" Int "," Int ";" MCasePat   ";" Map ")" [function]
  syntax    MCasePats ::= "#deBruijn(" Int "," Int ";" MCasePats  ";" Map ")" [function]
// Select Branches
  syntax       Branch ::= "#deBruijn(" Int "," Int ";" Branch     ";" Map ")" [function]
  syntax     Branches ::= "#deBruijn(" Int "," Int ";" Branches   ";" Map ")" [function]
  syntax    BranchPat ::= "#deBruijn(" Int "," Int ";" BranchPat  ";" Map ")" [function]
  syntax   BranchPats ::= "#deBruijn(" Int "," Int ";" BranchPats ";" Map ")" [function]

// Top level DeBruijn index map for substitutions
  syntax          Map ::= "#mapNew(" Int "," Int ";" VarDecs ")"   [function]
  syntax          Map ::= "#mapify(" Names    ")"                  [function]
                        | "#mapify(" NamePats ")"                  [function]
                        | "#mapify(" Procs    ")"                  [function]
                        | "#mapify(" ProcPats ")"                  [function]
                        | "#mapify(" Int "," Int ";"  Names    ")" [function]
                        | "#mapify(" Int "," Int ";"  NamePats ")" [function]
                        | "#mapify(" Int "," Int ";"  Procs    ")" [function]
                        | "#mapify(" Int "," Int ";"  ProcPats ")" [function]
                        | "#mapify(" Int "," Int ";;" AnyBind  ")" [function]
                        | "#mapify(" Int "," Int ";;" AnyBinds ")" [function]

  syntax          Map ::= "#mapify(" Int "," Int ";" RhoKVPairs ")" [function]
                        | "#mapify(" Int "," Int ";" RhoKVPats  ")" [function]
                        | "#mapify(" Int "," Int ";" Branches   ")" [function]
                        | "#mapify(" Int "," Int ";" BranchPats ")" [function]
                        | "#mapify(" Int "," Int ";" MatchCases ")" [function]
                        | "#mapify(" Int "," Int ";" MCasePats  ")" [function]

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

// sugar for top level #deBruijn function call
  rule #deBruijn( A:Proc    ) => #deBruijn(0,0;A;.Map)
  rule #deBruijn( A:ProcPat ) => #deBruijn(0,0;A;.Map)
  // #deBruijn(L:Int,I:Int;A:Proc;M:Map) // #FV(A) <=Set keys(M) if we are applying #deBruijn

// completely trivial indexing cases -- no variables in expression
//  rule #deBruijn( A:Name    ) => A requires #V(A) ==K .Set
//  rule #deBruijn( A:NamePat ) => A requires #V(A) ==K .Set
//  rule #deBruijn( A:Proc    ) => A requires #V(A) ==K .Set
//  rule #deBruijn( A:ProcPat ) => A requires #V(A) ==K .Set

// New
  rule #deBruijn( L:Int , I:Int ; new A:VarDecs in { B:Proc } ; M:Map )
    => new #dbNew(L,I;#indecs(A)) in { #deBruijn(L,I +Int size(#DV(A));#sub(updateMap(M,#mapNew(L,I;#indecs(A)));B);updateMap(M,#mapNew(L,I;#indecs(A)))) }
  rule  #dbNew( L:Int , I:Int ; A:VarDec ) => #if L ==Int 0 #then n(I) #else n(L,I) #fi
  rule  #dbNew( L:Int , I:Int ; A:VarDec , B:VarDecs ) => #dbNew(L,I;A) , #dbNew(L,I +Int 1;B)
  rule #mapNew( L:Int , I:Int ; A:VarDec ) => #if L ==Int 0 #then #var(A) |-> n(I) #else #var(A) |-> n(L,I) #fi
  rule #mapNew( L:Int , I:Int ; A:VarDec , B:VarDecs ) => #mapNew(L,I;A) #mapNew(L,I +Int 1;B)

// Ground & Bound Terms
  rule #deBruijn( _:Int , _:Int ; A:Ground    ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundName ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:BoundProc ; _:Map ) => A

// Parallel Composition
// substitute indices in current indexing environment in each process,
// then continue from current value for bound terms
  rule #deBruijn( L:Int , I:Int ; A:Proc    | B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) | #deBruijn(L,I;#sub(M;B);M) requires notBool    isPar(A)
  rule #deBruijn( L:Int , I:Int ; A:Proc    | B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) | #deBruijn(L,I;#sub(M;B);M) requires notBool    isPar(A)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat | B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) | #deBruijn(L,I;#sub(M;B);M) requires notBool isParPat(A)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat | B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) | #deBruijn(L,I;#sub(M;B);M) requires notBool isParPat(A)

// Receive/RecPat
  // unguarded
    // SRec
  rule #deBruijn( L:Int , I:Int ; for( B:Lbind  ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Pbind  ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Rbind  ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
    // MRec
  rule #deBruijn( L:Int , I:Int ; for( B:Lbinds ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Pbinds ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Rbinds ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
    // SRecPat
  rule #deBruijn( L:Int , I:Int ; for( B:LbindPat  ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:PbindPat  ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:RbindPat  ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Lbind     ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Pbind     ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Rbind     ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:LbindPat  ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:PbindPat  ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:RbindPat  ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
    // MRecPat
  rule #deBruijn( L:Int , I:Int ; for( B:LbindPats ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:PbindPats ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:RbindPats ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Lbinds    ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Pbinds    ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:Rbinds    ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:LbindPats ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:PbindPats ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:RbindPats ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  // guarded
    // SRec
  rule #deBruijn( L:Int , I:Int ; for( B:GLbind  ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GPbind  ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GRbind  ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
    // MRec
  rule #deBruijn( L:Int , I:Int ; for( B:GLbinds ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GPbinds ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GRbinds ){ C:Proc } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
    // SRecPat
  rule #deBruijn( L:Int , I:Int ; for( B:GLbindPat  ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GPbindPat  ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GRbindPat  ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GLbind     ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GPbind     ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GRbind     ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GLbindPat  ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GPbindPat  ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GRbindPat  ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
    // MRecPat
  rule #deBruijn( L:Int , I:Int ; for( B:GLbindPats ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GPbindPats ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GRbindPats ){ C:Proc    } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GLbinds    ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GPbinds    ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GRbinds    ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GLbindPats ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GPbindPats ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }
  rule #deBruijn( L:Int , I:Int ; for( B:GRbindPats ){ C:ProcPat } ; M:Map )
    => for( #deBruijn(L,I;I;;B;;M) ){
            #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));C);updateMap(M,#mapify(L,I;#bvar(B)))) }

  // Bind[Pat][s]
    // unguarded
    // binding variables: index starting from current value in binds, increase level for bound terms
    // channel: substitute indices in environment, continue from current value for bound terms
      // Lbind[s]
  rule #deBruijn( L:Int , I:Int ; _:Int ;; <-  A:Name  ;; M:Map )
    => <-  #deBruijn(L,I;A;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;;     A:Lbind ;; M:Map )
    => #deBruijn(L +Int 1,0;#sub(#mapify(L,J;#bvar(A));#bvar(A));#mapify(L,J;#bvar(A))) <-
       #deBruijn(L,I;#sub(M;#chan(A));M) requires notBool isEmptyLbind(A)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Lbind & B:Lbind  ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Lbind & B:Lbinds ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
      // LbindPat[s]
  rule #deBruijn( L:Int , I:Int ; _:Int ;; <-  A:NamePat  ;; M:Map )
    => <-  #deBruijn(L,I;A;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;;     A:LbindPat ;; M:Map )
    => #deBruijn(L +Int 1,0;#sub(#mapify(L,J;#bvar(A));#bvar(A));#mapify(L,J;#bvar(A))) <-
       #deBruijn(L,I;#sub(M;#chan(A));M) requires notBool isEmptyLbindPat(A)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Lbind    & B:LbindPat  ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:LbindPat & B:Lbind     ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:LbindPat & B:LbindPat  ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Lbind    & B:LbindPats ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:LbindPat & B:Lbinds    ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:LbindPat & B:LbindPats ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
      // Pbind[s]
  rule #deBruijn( L:Int , I:Int ; _:Int ;; <<- A:Name  ;; M:Map )
    => <<- #deBruijn(L,I;A;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;;     A:Pbind ;; M:Map )
    => #deBruijn(L +Int 1,0;#sub(#mapify(L,J;#bvar(A));#bvar(A));#mapify(L,J;#bvar(A))) <<-
       #deBruijn(L,I;#sub(M;#chan(A));M) requires notBool isEmptyPbind(A)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Pbind & B:Pbind  ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Pbind & B:Pbinds ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
      // PbindPat[s]
  rule #deBruijn( L:Int , I:Int ; _:Int ;; <<- A:NamePat  ;; M:Map )
    => <<- #deBruijn(L,I;A;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;;     A:PbindPat ;; M:Map )
    => #deBruijn(L +Int 1,0;#sub(#mapify(L,J;#bvar(A));#bvar(A));#mapify(L,J;#bvar(A))) <<-
       #deBruijn(L,I;#sub(M;#chan(A));M) requires notBool isEmptyPbindPat(A)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Pbind    & B:PbindPat  ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:PbindPat & B:Pbind     ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:PbindPat & B:PbindPat  ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Pbind    & B:PbindPats ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:PbindPat & B:Pbinds    ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:PbindPat & B:PbindPats ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
      // Rbind[s]
  rule #deBruijn( L:Int , I:Int ; _:Int ;; <=  A:Name  ;; M:Map )
    => <=  #deBruijn(L,I;A;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;;     A:Rbind ;; M:Map )
    => #deBruijn(L +Int 1,0;#sub(#mapify(L,J;#bvar(A));#bvar(A));#mapify(L,J;#bvar(A))) <=
       #deBruijn(L,I;#sub(M;#chan(A));M) requires notBool isEmptyRbind(A)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Rbind & B:Rbind  ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Rbind & B:Rbinds ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
      // RbindPat[s]
  rule #deBruijn( L:Int , I:Int ; _:Int ;; <=  A:NamePat  ;; M:Map )
    => <=  #deBruijn(L,I;A;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;;     A:RbindPat ;; M:Map )
    => #deBruijn(L +Int 1,0;#sub(#mapify(L,J;#bvar(A));#bvar(A));#mapify(L,J;#bvar(A))) <=
       #deBruijn(L,I;#sub(M;#chan(A));M) requires notBool isEmptyRbindPat(A)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Rbind    & B:RbindPat  ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:RbindPat & B:Rbind     ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:RbindPat & B:RbindPat  ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:Rbind    & B:RbindPats ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
//  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:RbindPat & B:Rbinds    ;; M:Map )
//    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  rule #deBruijn( L:Int , I:Int ; J:Int ;; A:RbindPat & B:RbindPats ;; M:Map )
    => #deBruijn(L,I;J;;A;;M) & #deBruijn(L,I;J +Int size(#LV(A));;B;;M)
  // guarded
    // bind[s]: indexed in the usual way
    // guard: substitute indices in environment updated with the binding variable indices
      // GLbind[Pat][s]
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:Lbind     if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:Lbinds    if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:LbindPat  if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:LbindPats if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
      // GPbind[Pat][s]
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:Pbind     if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:Pbinds    if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:PbindPat  if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:PbindPats if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
      // GRbind[Pat][s]
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:Rbind     if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:Rbinds    if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:RbindPat  if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))
  rule #deBruijn( L:Int , I:Int ; J:Int ;; B:RbindPats if G:BExp ;; M:Map )
    => #deBruijn(L,I;J;;B;;M) if
       #deBruijn(L,I +Int size(#LV(B));#sub(updateMap(M,#mapify(L,I;#bvar(B)));G);updateMap(M,#mapify(L,I;#bvar(B))))

// Contract[Pat]
  rule #deBruijn( L:Int , I:Int ; contract A:NamePat ( B:NamePats ) = { C:ProcPat } ; M:Map )
    => contract #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L +Int 1,0;#sub(#mapify(L,I;B);B);#mapify(L,I;B))) =
       {#deBruijn(L,I +Int size(#FV(B));#sub(updateMap(M,#mapify(L,I;B));C);updateMap(M,#mapify(L,I;B)))}
//  rule #deBruijn( L:Int , I:Int ; contract A:NamePat ( B:Names    ) = { C:ProcPat } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L +Int 1,0;#sub(#mapify(L,I;B);B);#mapify(L,I;B))) =
//       {#deBruijn(L,I +Int size(#FV(B));#sub(updateMap(M,#mapify(L,I;B));C);updateMap(M,#mapify(L,I;B)))}
  rule #deBruijn( L:Int , I:Int ; contract A:NamePat (            ) = { C:ProcPat } ; M:Map )
    => contract #deBruijn(L,I;#sub(M;A);M) ( ) = { #deBruijn(L,I;#sub(M;C);M) }
//  rule #deBruijn( L:Int , I:Int ; contract A:NamePat ( B:NamePats ) = { C:Proc    } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L +Int 1,0;#sub(#mapify(L,I;B);B);#mapify(L,I;B))) =
//       {#deBruijn(L,I +Int size(#FV(B));#sub(updateMap(M,#mapify(L,I;B));C);updateMap(M,#mapify(L,I;B)))}
//  rule #deBruijn( L:Int , I:Int ; contract A:NamePat ( B:Names    ) = { C:Proc    } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L +Int 1,0;#sub(#mapify(L,I;B);B);#mapify(L,I;B))) =
//       {#deBruijn(L,I +Int size(#FV(B));#sub(updateMap(M,#mapify(L,I;B));C);updateMap(M,#mapify(L,I;B)))}
//  rule #deBruijn( L:Int , I:Int ; contract A:NamePat (            ) = { C:Proc    } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) ( ) = { #deBruijn(L,I;#sub(M;C);M) }
//  rule #deBruijn( L:Int , I:Int ; contract A:Name    ( B:NamePats ) = { C:ProcPat } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L +Int 1,0;#sub(#mapify(L,I;B);B);#mapify(L,I;B))) =
//       {#deBruijn(L,I +Int size(#FV(B));#sub(updateMap(M,#mapify(L,I;B));C);updateMap(M,#mapify(L,I;B)))}
//  rule #deBruijn( L:Int , I:Int ; contract A:Name    ( B:Names    ) = { C:ProcPat } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L +Int 1,0;#sub(#mapify(L,I;B);B);#mapify(L,I;B))) =
//       {#deBruijn(L,I +Int size(#FV(B));#sub(updateMap(M,#mapify(L,I;B));C);updateMap(M,#mapify(L,I;B)))}
//  rule #deBruijn( L:Int , I:Int ; contract A:Name    (            ) = { C:ProcPat } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) ( ) = { #deBruijn(L,I;#sub(M;C);M) }
//  rule #deBruijn( L:Int , I:Int ; contract A:Name    ( B:NamePats ) = { C:Proc    } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L +Int 1,0;#sub(#mapify(L,I;B);B);#mapify(L,I;B))) =
//       {#deBruijn(L,I +Int size(#FV(B));#sub(updateMap(M,#mapify(L,I;B));C);updateMap(M,#mapify(L,I;B)))}
//  rule #deBruijn( L:Int , I:Int ; contract A:Name    ( B:Names    ) = { C:Proc    } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L +Int 1,0;#sub(#mapify(L,I;B);B);#mapify(L,I;B))) =
//       {#deBruijn(L,I +Int size(#FV(B));#sub(updateMap(M,#mapify(L,I;B));C);updateMap(M,#mapify(L,I;B)))}
//  rule #deBruijn( L:Int , I:Int ; contract A:Name    (            ) = { C:Proc    } ; M:Map )
//    => contract #deBruijn(L,I;#sub(M;A);M) ( ) = { #deBruijn(L,I;#sub(M;C);M) }

// InvocationPat
  rule #deBruijn( L:Int , I:Int ; A:NamePat ( B:NamePats ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L,I;#sub(M;B);M))
//  rule #deBruijn( L:Int , I:Int ; A:NamePat ( B:Names    ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:NamePat (            ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) (                          )
//  rule #deBruijn( L:Int , I:Int ; A:Name    ( B:NamePats ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L,I;#sub(M;B);M))
//  rule #deBruijn( L:Int , I:Int ; A:Name    ( B:Names    ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) (#deBruijn(L,I;#sub(M;B);M))
//  rule #deBruijn( L:Int , I:Int ; A:Name    (            ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) (                          )

// VarRef
  rule #deBruijn( L:Int , I:Int ; =  A:ProcVar ; M:Map ) => #deBruijn(L,I;#sub(M;= A);M)
  rule #deBruijn( L:Int , I:Int ; =* A:Var     ; M:Map ) => #deBruijn(L,I;#sub(M;=*A);M)

// LetExp
  rule #deBruijn( L:Int , I:Int ; let A:LetBind        in { B:Proc } ; M:Map ) => let #deBruijn(L,I;;A;;M) in {
       #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));#sub(updateMap(M,#mapify(L,I;#letvar(A)));B);updateMap(M,#mapify(L,I;#letvar(A)))) }
  rule #deBruijn( L:Int , I:Int ; let A:SeqLetBinds    in { B:Proc } ; M:Map ) => let #deBruijn(L,I;;A;;M) in {
       #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));#sub(updateMap(M,#mapify(L,I;#letvar(A)));B);updateMap(M,#mapify(L,I;#letvar(A)))) }
  rule #deBruijn( L:Int , I:Int ; let A:SimLetBinds    in { B:Proc } ; M:Map ) => let #deBruijn(L,I;;A;;M) in {
       #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));#sub(updateMap(M,#mapify(L,I;#letvar(A)));B);updateMap(M,#mapify(L,I;#letvar(A)))) }
  rule #deBruijn( L:Int , I:Int ; let A:SeqSimLetBinds in { B:Proc } ; M:Map ) => let #deBruijn(L,I;;A;;M) in {
       #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));#sub(updateMap(M,#mapify(L,I;#letvar(A)));B);updateMap(M,#mapify(L,I;#letvar(A)))) }
  // LetBind
  rule #deBruijn( L:Int , I:Int ;; A:ProcVar <- B:Proc ;; M:Map ) => #sub(#mapify(L,I;A);A) <- #deBruijn(L,I +Int 1;#sub(M;B);M)
  // SeqLetBinds -- update index map with previous LetBind variable indices
  rule #deBruijn( L:Int , I:Int ;; A:LetBind ; B:LetBind     ;; M:Map )
    => #deBruijn(L,I;;A;;M) ; #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));;B;;updateMap(M,#mapify(L,I;#letvar(A))))
  rule #deBruijn( L:Int , I:Int ;; A:LetBind ; B:SeqLetBinds ;; M:Map )
    => #deBruijn(L,I;;A;;M) ; #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));;B;;updateMap(M,#mapify(L,I;#letvar(A))))
  // SimLetBinds -- simultaneous LetBinds do not update the index map
  rule #deBruijn( L:Int , I:Int ;; A:LetBind & B:SimLetBinds ;; M:Map )
    => #deBruijn(L,I;;A;;M) & #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));;B;;M)
  // SeqSimLetBinds -- TODO: sub Map in subsequent binds
  rule #deBruijn( L:Int , I:Int ;; A:SeqLetBinds > B:SimLetBinds    ;; M:Map )
    => #deBruijn(L,I;;A;;M) > #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));;B;;updateMap(M,#mapify(L,I;#letvar(A))))
  rule #deBruijn( L:Int , I:Int ;; A:SimLetBinds > B:SeqLetBinds    ;; M:Map )
    => #deBruijn(L,I;;A;;M) > #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));;B;;updateMap(M,#mapify(L,I;#letvar(A))))
  rule #deBruijn( L:Int , I:Int ;; A:SimLetBinds > B:SimLetBinds    ;; M:Map )
    => #deBruijn(L,I;;A;;M) > #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));;B;;updateMap(M,#mapify(L,I;#letvar(A))))
  rule #deBruijn( L:Int , I:Int ;; A:SeqLetBinds > B:SeqSimLetBinds ;; M:Map )
    => #deBruijn(L,I;;A;;M) > #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));;B;;updateMap(M,#mapify(L,I;#letvar(A))))
  rule #deBruijn( L:Int , I:Int ;; A:SimLetBinds > B:SeqSimLetBinds ;; M:Map )
    => #deBruijn(L,I;;A;;M) > #deBruijn(L,I +Int 1 +Int size(#FV(A) -Set keys(M));;B;;updateMap(M,#mapify(L,I;#letvar(A))))

// Send[Pat]
// substitute indices in current environment into channel & message[s]
  rule #deBruijn( L:Int , I:Int ; A:NamePat !  ( B:ProcPats ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !  (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:NamePat !  ( B:Procs    ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !  (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:NamePat !  (            ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !  (                          )
  rule #deBruijn( L:Int , I:Int ; A:Name    !  ( B:ProcPats ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !  (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:Name    !  ( B:Procs    ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !  (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:Name    !  (            ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !  (                          )
  rule #deBruijn( L:Int , I:Int ; A:NamePat !! ( B:ProcPats ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !! (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:NamePat !! ( B:Procs    ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !! (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:NamePat !! (            ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !! (                          )
  rule #deBruijn( L:Int , I:Int ; A:Name    !! ( B:ProcPats ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !! (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:Name    !! ( B:Procs    ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !! (#deBruijn(L,I;#sub(M;B);M))
  rule #deBruijn( L:Int , I:Int ; A:Name    !! (            ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !! (                          )

// Eval[Pat]
  // substitute indices in current environment
  rule #deBruijn( L:Int , I:Int ; *A:Name    ; M:Map ) => *#deBruijn(L,I;#sub(M;A);M)
  rule #deBruijn( L:Int , I:Int ; *A:NamePat ; M:Map ) => *#deBruijn(L,I;#sub(M;A);M)

// Variables
  // Typed Name
  rule #deBruijn( L:Int , I:Int ; (@A:BoundProc) :: B:Name    ; M:Map ) => (@A) :: #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; (@A:BoundProc) :: B:NamePat ; M:Map ) => (@A) :: #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ;   A:BoundName  :: B:Name    ; M:Map ) =>   A  :: #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ;   A:BoundName  :: B:NamePat ; M:Map ) =>   A  :: #deBruijn(L,I;#sub(M;B);M)

  // Typed Proc
  rule #deBruijn( L:Int , I:Int ;   A:BoundProc  :: B:Proc    ; M:Map ) =>   A  :: #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ;   A:BoundProc  :: B:ProcPat ; M:Map ) =>   A  :: #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; (*A:BoundName) :: B:Proc    ; M:Map ) => (*A) :: #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; (*A:BoundName) :: B:ProcPat ; M:Map ) => (*A) :: #deBruijn(L,I;#sub(M;B);M)

// Collection[Pat]
  // RhoList/ListPat
  rule #deBruijn( _:Int , _:Int ; [ ] ; _:Map ) => [ ]
  rule #deBruijn( L:Int , I:Int ; [ A:Procs    ] ; M:Map ) => [ #deBruijn(L,I;#sub(M;A);M) ]
  rule #deBruijn( L:Int , I:Int ; [ A:ProcPats ] ; M:Map ) => [ #deBruijn(L,I;#sub(M;A);M) ]
  rule #deBruijn( L:Int , I:Int ; [ A:Procs    ... B:ProcVar ] ; M:Map ) => [ #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) ]
  rule #deBruijn( L:Int , I:Int ; [ A:Procs    ... B:EvalVar ] ; M:Map ) => [ #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) ]
  rule #deBruijn( L:Int , I:Int ; [ A:ProcPats ... B:ProcVar ] ; M:Map ) => [ #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) ]
  rule #deBruijn( L:Int , I:Int ; [ A:ProcPats ... B:EvalVar ] ; M:Map ) => [ #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) ]
  // RhoMap/MapPat
  rule #deBruijn( _:Int , _:Int ; { } ; _:Map ) => { }
  rule #deBruijn( L:Int , I:Int ; { A:RhoKVPairs } ; M:Map ) => { #deBruijn(L,I;#sub(M;A);M) }
  rule #deBruijn( L:Int , I:Int ; { A:RhoKVPats  } ; M:Map ) => { #deBruijn(L,I;#sub(M;A);M) }
  rule #deBruijn( L:Int , I:Int ; { A:RhoKVPairs ... B:ProcVar } ; M:Map ) => { #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) }
  rule #deBruijn( L:Int , I:Int ; { A:RhoKVPairs ... B:EvalVar } ; M:Map ) => { #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) }
  rule #deBruijn( L:Int , I:Int ; { A:RhoKVPats  ... B:ProcVar } ; M:Map ) => { #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) }
  rule #deBruijn( L:Int , I:Int ; { A:RhoKVPats  ... B:EvalVar } ; M:Map ) => { #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) }
    // KVPairs/KVPats
      // single KVPair/KVPat
  rule #deBruijn( L:Int , I:Int ; A:Proc    : B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) : #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc    : B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) : #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat : B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) : #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat : B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) : #deBruijn(L,I;#sub(M;B);M)
    // multiple KVPairs/KVPats
  rule #deBruijn( L:Int , I:Int ; A:RhoKVPair , B:RhoKVPairs ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:RhoKVPair , B:RhoKVPats  ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:RhoKVPat  , B:RhoKVPairs ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:RhoKVPat  , B:RhoKVPats  ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  // RhoSet/SetPat
  rule #deBruijn( _:Int , _:Int ; Set( ) ; _:Map ) => Set( )
  rule #deBruijn( L:Int , I:Int ; Set( A:Procs    ) ; M:Map ) => Set( #deBruijn(L,I;#sub(M;A);M) )
  rule #deBruijn( L:Int , I:Int ; Set( A:ProcPats ) ; M:Map ) => Set( #deBruijn(L,I;#sub(M;A);M) )
  rule #deBruijn( L:Int , I:Int ; Set( A:Procs    ... B:ProcVar ) ; M:Map ) => Set( #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) )
  rule #deBruijn( L:Int , I:Int ; Set( A:Procs    ... B:EvalVar ) ; M:Map ) => Set( #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) )
  rule #deBruijn( L:Int , I:Int ; Set( A:ProcPats ... B:ProcVar ) ; M:Map ) => Set( #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) )
  rule #deBruijn( L:Int , I:Int ; Set( A:ProcPats ... B:EvalVar ) ; M:Map ) => Set( #deBruijn(L,I;#sub(M;A);M) ... #deBruijn(L,I;#sub(M;B);.Map) )
  // RhoTuple/TuplePat
  rule #deBruijn( L:Int , I:Int ; ( A:Procs    ,) ; M:Map ) => ( #deBruijn(L,I;#sub(M;A);M) ,)
  rule #deBruijn( L:Int , I:Int ; ( A:ProcPats ,) ; M:Map ) => ( #deBruijn(L,I;#sub(M;A);M) ,)

// Quote[Pat]
  rule #deBruijn( L:Int , I:Int ; @A:Proc    ; M:Map ) => @#deBruijn(L,I;#sub(M;A);M)
  rule #deBruijn( L:Int , I:Int ; @A:ProcPat ; M:Map ) => @#deBruijn(L,I;#sub(M;A);M)

// Expressions
  // Arithmetic Exps
  rule #deBruijn( L:Int , I:Int ; - A:AExp ; M:Map ) => - #deBruijn(L,I;#sub(M;A);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp * B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) * #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp / B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) / #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp + B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) + #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp - B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) - #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp % B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) % #deBruijn(L,I;#sub(M;B);M)

  // Boolean Exps
  rule #deBruijn( L:Int , I:Int ; not A:BExp ; M:Map ) => not #deBruijn(L,I;#sub(M;A);M)
  rule #deBruijn( L:Int , I:Int ; A:BExp and B:BExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) and #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:BExp or  B:BExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) or  #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp <=  B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) <=  #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp <   B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) <   #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp >=  B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) >=  #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:AExp >   B:AExp ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) >   #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Name ==  B:Name ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) ==  #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Name !=  B:Name ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !=  #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc ==  B:Proc ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) ==  #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc !=  B:Proc ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) !=  #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc    matches B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) matches #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc    matches B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) matches #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat matches B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) matches #deBruijn(L,I;#sub(M;B);M)

  // List & String Expressions
  rule #deBruijn( L:Int , I:Int ; A:ListOrVar   ++ B:ListOrVar   ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) ++ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ListOrVar   ++ B:ConcatList  ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) ++ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:StringOrVar ++ B:StringOrVar ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) ++ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:StringOrVar ++ B:ConcatStr   ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) ++ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:StringOrVar %% B:InterpMaps  ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) %% #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:RhoMap      %% B:InterpMaps  ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) %% #deBruijn(L,I;#sub(M;B);M)

// Match[Pat]
  rule #deBruijn( L:Int , I:Int ; match A:Proc    { B:MatchCases } ; M:Map ) => match #deBruijn(L,I;#sub(M;A);.Map) { #deBruijn(L,I;B;M) }
  rule #deBruijn( L:Int , I:Int ; match A:Proc    { B:MCasePats  } ; M:Map ) => match #deBruijn(L,I;#sub(M;A);.Map) { #deBruijn(L,I;B;M) }
  rule #deBruijn( L:Int , I:Int ; match A:ProcPat { B:MatchCases } ; M:Map ) => match #deBruijn(L,I;#sub(M;A);.Map) { #deBruijn(L,I;B;M) }
  rule #deBruijn( L:Int , I:Int ; match A:ProcPat { B:MCasePats  } ; M:Map ) => match #deBruijn(L,I;#sub(M;A);.Map) { #deBruijn(L,I;B;M) }
  // multiple MatchCases/MCasePats
  rule #deBruijn( L:Int , I:Int ; A:MatchCase B:MatchCases ; M:Map ) => #deBruijn(L,I;A;M) #deBruijn(L,I;B;M)
  rule #deBruijn( L:Int , I:Int ; A:MatchCase B:MCasePats  ; M:Map ) => #deBruijn(L,I;A;M) #deBruijn(L,I;B;M)
  rule #deBruijn( L:Int , I:Int ; A:MCasePat  B:MatchCases ; M:Map ) => #deBruijn(L,I;A;M) #deBruijn(L,I;B;M)
  rule #deBruijn( L:Int , I:Int ; A:MCasePat  B:MCasePats  ; M:Map ) => #deBruijn(L,I;A;M) #deBruijn(L,I;B;M)
  // single MatchCase/MCasePat
    // binding Proc[Pat]: index free variables at current level, then increase level for bound terms
    // continuation: increase index according to corresponding binding Proc[Pat], then sub indices from outside environment updated by binding indices
  rule #deBruijn( L:Int , I:Int ; { A:Proc    } |=> B:Proc    ; M:Map )
    => {#deBruijn(L +Int 1,0;#sub(#mapify(L,I;A);A);.Map)} |=>
        #deBruijn(L,I +Int size(#FV(A));#sub(updateMap(M,#mapify(L,I;A));B);updateMap(M,#mapify(L,I;A)))
  rule #deBruijn( L:Int , I:Int ; { A:ProcPat } |=> B:Proc    ; M:Map )
    => {#deBruijn(L +Int 1,0;#sub(#mapify(L,I;A);A);.Map)} |=>
        #deBruijn(L,I +Int size(#FV(A));#sub(updateMap(M,#mapify(L,I;A));B);updateMap(M,#mapify(L,I;A)))
  rule #deBruijn( L:Int , I:Int ; { A:Proc    } |=> B:ProcPat ; M:Map )
    => {#deBruijn(L +Int 1,0;#sub(#mapify(L,I;A);A);.Map)} |=>
        #deBruijn(L,I +Int size(#FV(A));#sub(updateMap(M,#mapify(L,I;A));B);updateMap(M,#mapify(L,I;A)))
  rule #deBruijn( L:Int , I:Int ; { A:ProcPat } |=> B:ProcPat ; M:Map )
    => {#deBruijn(L +Int 1,0;#sub(#mapify(L,I;A);A);.Map)} |=>
        #deBruijn(L,I +Int size(#FV(A));#sub(updateMap(M,#mapify(L,I;A));B);updateMap(M,#mapify(L,I;A)))

// Select[Pat]
  rule #deBruijn( L:Int , I:Int ; select { A:Branches   } ; M:Map ) => select { #deBruijn(L,I;A;M) }
  rule #deBruijn( L:Int , I:Int ; select { A:BranchPats } ; M:Map ) => select { #deBruijn(L,I;A;M) }
  // multiple Branches/BranchPats
  rule #deBruijn( L:Int , I:Int ; A:Branch    B:Branches   ; M:Map ) => #deBruijn(L,I;A;M) #deBruijn(L,I;B;M)
  rule #deBruijn( L:Int , I:Int ; A:Branch    B:BranchPats ; M:Map ) => #deBruijn(L,I;A;M) #deBruijn(L,I;B;M)
  rule #deBruijn( L:Int , I:Int ; A:BranchPat B:Branches   ; M:Map ) => #deBruijn(L,I;A;M) #deBruijn(L,I;B;M)
  rule #deBruijn( L:Int , I:Int ; A:BranchPat B:BranchPats ; M:Map ) => #deBruijn(L,I;A;M) #deBruijn(L,I;B;M)
  // single Branch[Pat]
  rule #deBruijn( L:Int , I:Int ; { A:Lbind     } |=> B:Proc    ; M:Map )
    => {#deBruijn(L,I;I;;A;;M)} |=> #deBruijn(L,I +Int size(#LV(A));#sub(updateMap(M,#mapify(L,I;#bvar(A)));B);updateMap(M,#mapify(L,I;#bvar(A))))
  rule #deBruijn( L:Int , I:Int ; { A:Lbinds    } |=> B:Proc    ; M:Map )
    => {#deBruijn(L,I;I;;A;;M)} |=> #deBruijn(L,I +Int size(#LV(A));#sub(updateMap(M,#mapify(L,I;#bvar(A)));B);updateMap(M,#mapify(L,I;#bvar(A))))
  rule #deBruijn( L:Int , I:Int ; { A:Lbind     } |=> B:ProcPat ; M:Map )
    => {#deBruijn(L,I;I;;A;;M)} |=> #deBruijn(L,I +Int size(#LV(A));#sub(updateMap(M,#mapify(L,I;#bvar(A)));B);updateMap(M,#mapify(L,I;#bvar(A))))
  rule #deBruijn( L:Int , I:Int ; { A:Lbinds    } |=> B:ProcPat ; M:Map )
    => {#deBruijn(L,I;I;;A;;M)} |=> #deBruijn(L,I +Int size(#LV(A));#sub(updateMap(M,#mapify(L,I;#bvar(A)));B);updateMap(M,#mapify(L,I;#bvar(A))))
  rule #deBruijn( L:Int , I:Int ; { A:LbindPat  } |=> B:Proc    ; M:Map )
    => {#deBruijn(L,I;I;;A;;M)} |=> #deBruijn(L,I +Int size(#LV(A));#sub(updateMap(M,#mapify(L,I;#bvar(A)));B);updateMap(M,#mapify(L,I;#bvar(A))))
  rule #deBruijn( L:Int , I:Int ; { A:LbindPats } |=> B:Proc    ; M:Map )
    => {#deBruijn(L,I;I;;A;;M)} |=> #deBruijn(L,I +Int size(#LV(A));#sub(updateMap(M,#mapify(L,I;#bvar(A)));B);updateMap(M,#mapify(L,I;#bvar(A))))
  rule #deBruijn( L:Int , I:Int ; { A:LbindPat  } |=> B:ProcPat ; M:Map )
    => {#deBruijn(L,I;I;;A;;M)} |=> #deBruijn(L,I +Int size(#LV(A));#sub(updateMap(M,#mapify(L,I;#bvar(A)));B);updateMap(M,#mapify(L,I;#bvar(A))))
  rule #deBruijn( L:Int , I:Int ; { A:LbindPats } |=> B:ProcPat ; M:Map )
    => {#deBruijn(L,I;I;;A;;M)} |=> #deBruijn(L,I +Int size(#LV(A));#sub(updateMap(M,#mapify(L,I;#bvar(A)));B);updateMap(M,#mapify(L,I;#bvar(A))))

// Bundle
  rule #deBruijn( L:Int , I:Int ;  bundle{ A:Proc } ; M:Map ) =>  bundle{ #deBruijn(L,I;#sub(M;A);M) }
  rule #deBruijn( L:Int , I:Int ; bundle+{ A:Proc } ; M:Map ) => bundle+{ #deBruijn(L,I;#sub(M;A);M) }
  rule #deBruijn( L:Int , I:Int ; bundle-{ A:Proc } ; M:Map ) => bundle-{ #deBruijn(L,I;#sub(M;A);M) }
  rule #deBruijn( L:Int , I:Int ; bundle0{ A:Proc } ; M:Map ) => bundle0{ #deBruijn(L,I;#sub(M;A);M) }

// Conditional
  rule #deBruijn( L:Int , I:Int ; if (A:BExp)   B:Proc ; M:Map ) => if (#deBruijn(L,I;#sub(M;A);M)) #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:IfThen else B:Proc ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) else #deBruijn(L,I;#sub(M;B);M)
  // rule #deBruijn( L:Int , I:Int ; if (A:BExp)      B:ProcPat ; M:Map ) => if (#deBruijn(L,I;#sub(M;A);M)) #deBruijn(L,I;#sub(M;B);M)
  // rule #deBruijn( L:Int , I:Int ; A:IfThenPat else B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) else #deBruijn(L,I;#sub(M;B);M)

// Method[Pat]
  rule #deBruijn( L:Int , I:Int ; A:ProcPat . B:Method ( ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M).B( )
  rule #deBruijn( L:Int , I:Int ; A:ProcPat . B:Method ( C:ProcPats ) ; M:Map ) => #deBruijn(L,I;#sub(M;A);M).B( #deBruijn(L,I;#sub(M;C);M) )

  // Name[Pat]s
  rule #deBruijn( L:Int , I:Int ; A:Name    , B:Names    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:NamePat , B:Names    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Name    , B:NamePats ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:NamePat , B:NamePats ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)

// Proc[Pat]s
  rule #deBruijn( L:Int , I:Int ; A:Proc    , B:Procs    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc    , B:ProcPats ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat , B:Procs    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat , B:ProcPats ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) , #deBruijn(L,I;#sub(M;B);M)

// Simple patterns
  rule #deBruijn( _:Int , _:Int ; \_ ; _:Map ) => \_
  rule #deBruijn( _:Int , _:Int ; A:SimplePat     ; _:Map ) => A
  rule #deBruijn( _:Int , _:Int ; A:SimpleNamePat ; _:Map ) => A

// PatExp
  rule #deBruijn( L:Int , I:Int ; ~ A:Proc    ; M:Map ) => ~ #deBruijn(L,I;#sub(M;A);M)
  rule #deBruijn( L:Int , I:Int ; ~ A:ProcPat ; M:Map ) => ~ #deBruijn(L,I;#sub(M;A);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc    /\ B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) /\ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc    /\ B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) /\ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat /\ B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) /\ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat /\ B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) /\ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc    \/ B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) \/ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:Proc    \/ B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) \/ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat \/ B:Proc    ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) \/ #deBruijn(L,I;#sub(M;B);M)
  rule #deBruijn( L:Int , I:Int ; A:ProcPat \/ B:ProcPat ; M:Map ) => #deBruijn(L,I;#sub(M;A);M) \/ #deBruijn(L,I;#sub(M;B);M)

//---------------
//--- #mapify ---
//---------------
  rule #mapify( A:NamePats ) => #mapify(0,0;A)
  rule #mapify( A:ProcPats ) => #mapify(0,0;A)

// Empty Name & Proc
  rule #mapify( _:Int , _:Int ; EmptyN ) => .Map
  rule #mapify( _:Int , _:Int ; EmptyP ) => .Map

// NamePat
  rule #mapify( _:Int , _:Int ;   @sub      ) => .Map
  rule #mapify( _:Int , _:Int ; _:BoundName ) => .Map
  rule #mapify( L:Int , I:Int ;  A:Var      ) => #if L ==Int 0 #then A |-> @x(I) #else A |-> @x(L,I) #fi
       requires notBool isBoundName(A)
  rule #mapify( L:Int , I:Int ; @A:ProcPat  ) => #mapify(L,I;A)
  // NamePats
  rule #mapify( L:Int , I:Int ; A:NamePat , B:NamePats ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)

// ProcPat
  rule #mapify( _:Int , _:Int ;    sub       ) => .Map
  rule #mapify( _:Int , _:Int ;  _:Ground    ) => .Map
  rule #mapify( _:Int , _:Int ;  _:BoundProc ) => .Map
  rule #mapify( L:Int , I:Int ;  A:ProcVar   ) => #if L==Int 0 #then A |-> x(I) #else A |-> x(L,I) #fi
       requires notBool isBoundProc(A)
  rule #mapify( L:Int , I:Int ; *A:NamePat   ) => #mapify(L,I;A)
  // ProcPats
  rule #mapify( L:Int , I:Int ; A:ProcPat , B:ProcPats ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)

// NewPat
  // if @{new A:VarDecs in { B:Proc[Pat] }} appears in a listen pattern,
  // the only listen-level binding variables come from #FV(B) -Set #DV(A)
  // so the declared variables are hidden from #mapify
  rule #mapify( L:Int , I:Int ; new A:VarDecs in { B:ProcPat } ) => #mapify(L,I;#sub(#mapSub(#DV(A));B))

// ParPat
  rule #mapify( L:Int , I:Int ; A:ProcPat | B:ProcPat ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B) requires notBool isParPat(A)

// SendPat
  rule #mapify( L:Int , I:Int ; A:NamePat !  ( B:ProcPats ) ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:NamePat !  (            ) ) => #mapify(L,I;A)
  rule #mapify( L:Int , I:Int ; A:NamePat !! ( B:ProcPats ) ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:NamePat !! (            ) ) => #mapify(L,I;A)

// RecPat
  // mapSub hides listening variables from generating additional substitution mappings
  rule #mapify( L:Int , I:Int ; A:UGSRecPat )
    => #mapify(L,I;#chan(A)) #mapify(L,I +Int size(#RV(A));#sub(#mapSub(#LV(A));#cont(A)))
  rule #mapify( L:Int , I:Int ; A:UGMRecPat )
    => #mapify(L,I;#chan(A)) #mapify(L,I +Int size(#RV(A));#sub(#mapSub(#LV(A));#cont(A)))
  rule #mapify( L:Int , I:Int ; A:GSRecPat )
    => #mapify(L,I;#chan(A)) #mapify(L,I +Int size(#RV(A));#sub(#mapSub(#LV(A));#guard(A)))
       #mapify(L,I +Int size(#RV(A)) +Int size(#FV(#guard(A)) -Set #LV(A));#sub(#mapSub(#LV(A));#cont(A)))
  rule #mapify( L:Int , I:Int ; A:GMRecPat )
    => #mapify(L,I;#chan(A)) #mapify(L,I +Int size(#RV(A));#sub(#mapSub(#LV(A));#guard(A)))
       #mapify(L,I +Int size(#RV(A)) +Int size(#FV(#guard(A)) -Set #LV(A));#sub(#mapSub(#LV(A));#cont(A)))

// MatchPat -- free variables in MatchCase continuations must be distinct
  rule #mapify( L:Int , I:Int ; match A:ProcPat { B:MCasePats  } ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  // single MCasePat
  rule #mapify( L:Int , I:Int ; { A:ProcPat } |=> B:ProcPat ) => #mapify(L,I;#sub(#mapSub(#FV(A));B))
  // multiple MCasePats
  rule #mapify( L:Int , I:Int ; A:MCasePat  B:MCasePats  ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)

// SelectPat
  rule #mapify( L:Int , I:Int ; select { A:BranchPats } ) => #mapify(L,I;A)
  // single BranchPat
  rule #mapify( L:Int , I:Int ; { A:LbindPat   } |=> B:ProcPat ) => #mapify(L,I;#sub(#mapSub(#LV(A));B))
  rule #mapify( L:Int , I:Int ; { A:LbindPats  } |=> B:ProcPat ) => #mapify(L,I;#sub(#mapSub(#LV(A));B))
  rule #mapify( L:Int , I:Int ; { A:GLbindPat  } |=> B:ProcPat ) => #mapify(L,I;#sub(#mapSub(#LV(A));B))
  rule #mapify( L:Int , I:Int ; { A:GLbindPats } |=> B:ProcPat ) => #mapify(L,I;#sub(#mapSub(#LV(A));B))
  // multiple BranchPats
  rule #mapify( L:Int , I:Int ; A:BranchPat B:BranchPats ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)

// CollectionPat
  // RhoLists
  rule #mapify( _:Int , _:Int ; [ ] ) => .Map
  rule #mapify( L:Int , I:Int ; [ A:ProcPats ] ) => #mapify(L,I;A)
  rule #mapify( L:Int , I:Int ; [ A:ProcPats ... B:ProcVar ] ) => #mapify(L,I;B) #mapify(L,I +Int 1;A)
  // RhoMaps
    // applied after normalization
  rule #mapify( _:Int , _:Int ; { } ) => .Map
  rule #mapify( L:Int , I:Int ; { A:RhoKVPats  } ) => #mapify(L,I;A)
  rule #mapify( L:Int , I:Int ; { A:RhoKVPats  ... B:ProcVar } ) => #mapify(L,I;B) #mapify(L,I +Int 1;A)
    // KV Pairs
  rule #mapify( L:Int , I:Int ; A:ProcPat  : B:ProcPat   ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:RhoKVPat , B:RhoKVPats ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  // RhoSets
    // applied after normalization
  rule #mapify( _:Int , _:Int ; Set( ) ) => .Map
  rule #mapify( L:Int , I:Int ; Set( A:ProcPats ) ) => #mapify(L,I;A)
  rule #mapify( L:Int , I:Int ; Set( A:ProcPats ... B:ProcVar ) ) => #mapify(L,I;B) #mapify(L,I +Int 1;A)
  // RhoTuples
  rule #mapify( L:Int , I:Int ; ( A:ProcPats ,) ) => #mapify(L,I;A)

// Expressions -- TODO: AExp, List, String
  // BExp
  rule #mapify( L:Int , I:Int ; not A:BExp ) => #mapify(L,I;A)
  rule #mapify( L:Int , I:Int ; A:BExp and B:BExp ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:BExp or  B:BExp ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:AExp <=  B:AExp ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:AExp <   B:AExp ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:AExp >=  B:AExp ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:AExp >   B:AExp ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:Name ==  B:Name ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:Name !=  B:Name ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:Proc ==  B:Proc ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:Proc !=  B:Proc ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:ProcPat matches B:ProcPat ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)

// TODO: Bundle, Conditional, Contract, Invocation, VarRef, Method

// Patterns
  rule #mapify( _:Int , _:Int ; \_ ) => .Map
  rule #mapify( _:Int , _:Int ;  _:SimplePat     ) => .Map
  rule #mapify( _:Int , _:Int ;  _:SimpleNamePat ) => .Map

  // Pattern expressions
  rule #mapify( L:Int , I:Int ; ~ A:ProcPat ) => #mapify(L,I;A)
  rule #mapify( L:Int , I:Int ; A:ProcPat /\ B:ProcPat ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)
  rule #mapify( L:Int , I:Int ; A:ProcPat \/ B:ProcPat ) => #mapify(L,I;A) #mapify(L,I +Int size(#FV(A));B)

//--------------
//--- #alpha ---
//--------------
// Alpha Equivalence Predicate
  // checks synactic equality of indexed terms -- need to normalize terms first
  rule P:Proc #alpha Q:Proc => #deBruijn(P) ==K #deBruijn(Q)

//------------------
//--- Structural ---
//------------------
// Nil = unit of |
  rule Nil       | A:ProcPat => A [anywhere, structural]
  rule A:ProcPat | Nil       => A [anywhere, structural]
// @* = Id_NamePat & *@ = Id_ProcPat
  rule @ * A:NamePat => A [anywhere, structural]
  rule * @ A:ProcPat => A [anywhere, structural]
// ~~ = Id_ProcPat
  rule ~ ~ A:ProcPat => A [anywhere, structural]

//  rule   A:Name    !  ( EmptyP ) => A!  ( ) [anywhere, structural]
//  rule   A:Name    !! ( EmptyP ) => A!! ( ) [anywhere, structural]
//  rule   A:NamePat !  ( EmptyP ) => A!  ( ) [anywhere, structural]
//  rule   A:NamePat !! ( EmptyP ) => A!  ( ) [anywhere, structural]

endmodule
