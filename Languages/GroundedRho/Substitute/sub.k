// SUBSTITUTION FOR GRHO
/*
TODO:
 - sub EmptyN for EmptyN
 - add remaining features - Methods, Bundles, Match
 - more testing
 - sub for Uri for #match
*/
/*
  This substitution function is needed to make distinct the notions of name variables and process variables.
  The builtin substitution does not make this distinction.
  E.g. we want the substitution (x!(\x))[@Nil / x] to result in @Nil!(\x) since we only substitute for x:NameVar, NOT \x:ProcVar
    the definitions of NameVar ::= Var and ProcVar ::= "\\" Var don't allow for this with the the builtin substitution
*/

require "domains.k"
require "../AuxFun/auxfun.k"
require "../Names_Variables/namevar.k"
require "../grho.k"

module SUB-SYNTAX
  import GRHO-SYNTAX
  import DOMAINS

  syntax   Proc ::= "#sub(" Proc  ";" Proc  ";" Proc ")"     [function, poly(0,3)]
                  | "#sub(" Procs ";" Procs ";" Proc ")"     [function, poly(0,3)]
                  | "#sub(" Name  ";" Name  ";" Proc ")"     [function, poly(0,3)]
                  | "#sub(" Names ";" Names ";" Proc ")"     [function, poly(0,3)]
                  | "#subRec("  Proc  ";" Proc  ";" Proc ")" [function]
                  | "#subRec("  Procs ";" Procs ";" Proc ")" [function]
                  | "#subRec("  Name  ";" Name  ";" Proc ")" [function]
                  | "#subRec("  Names ";" Names ";" Proc ")" [function]
                  | "#subChan(" Proc  ";" Proc  ";" Proc ")" [function]
                  | "#subChan(" Procs ";" Procs ";" Proc ")" [function]
                  | "#subChan(" Name  ";" Name  ";" Proc ")" [function]
                  | "#subChan(" Names ";" Names ";" Proc ")" [function]
                  | "#subNew("  Proc  ";" Proc  ";" New  ")" [function]
                  | "#subNew("  Procs ";" Procs ";" New  ")" [function]
                  | "#subNew("  Name  ";" Name  ";" New  ")" [function]
                  | "#subNew("  Names ";" Names ";" New  ")" [function]

  syntax   Name ::= "#sub(" Name  ";" Name  ";" Name ")"     [function]
                  | "#sub(" Names ";" Names ";" Name ")"     [function]
                  | "#sub(" Proc  ";" Proc  ";" Name ")"     [function]
                  | "#sub(" Procs ";" Procs ";" Name ")"     [function]
                  | "#sub(" Map   ";" Name  ")"              [function]

  syntax  Procs ::= "#sub(" Proc  ";" Proc  ";" Procs ")"    [function]
                  | "#sub(" Procs ";" Procs ";" Procs ")"    [function]
                  | "#sub(" Name  ";" Name  ";" Procs ")"    [function]
                  | "#sub(" Names ";" Names ";" Procs ")"    [function]

  syntax  Names ::= "#sub(" Proc  ";" Proc  ";" Names ")"    [function]
                  | "#sub(" Procs ";" Procs ";" Names ")"    [function]
                  | "#sub(" Name  ";" Name  ";" Names ")"    [function]
                  | "#sub(" Names ";" Names ";" Names ")"    [function]

  syntax  Lbind ::= "#subBind(" Proc  ";" Proc  ";;" Lbind  ")" [function]
                  | "#subBind(" Procs ";" Procs ";;" Lbind  ")" [function]
                  | "#subBind(" Name  ";" Name  ";;" Lbind  ")" [function]
                  | "#subBind(" Names ";" Names ";;" Lbind  ")" [function]
  syntax Lbinds ::= "#subBind(" Proc  ";" Proc  ";;" Lbinds ")" [function]
                  | "#subBind(" Procs ";" Procs ";;" Lbinds ")" [function]
                  | "#subBind(" Name  ";" Name  ";;" Lbinds ")" [function]
                  | "#subBind(" Names ";" Names ";;" Lbinds ")" [function]
  syntax  Pbind ::= "#subBind(" Proc  ";" Proc  ";;" Pbind  ")" [function]
                  | "#subBind(" Procs ";" Procs ";;" Pbind  ")" [function]
                  | "#subBind(" Name  ";" Name  ";;" Pbind  ")" [function]
                  | "#subBind(" Names ";" Names ";;" Pbind  ")" [function]
  syntax Pbinds ::= "#subBind(" Proc  ";" Proc  ";;" Pbinds ")" [function]
                  | "#subBind(" Procs ";" Procs ";;" Pbinds ")" [function]
                  | "#subBind(" Name  ";" Name  ";;" Pbinds ")" [function]
                  | "#subBind(" Names ";" Names ";;" Pbinds ")" [function]
  syntax  Rbind ::= "#subBind(" Proc  ";" Proc  ";;" Rbind  ")" [function]
                  | "#subBind(" Procs ";" Procs ";;" Rbind  ")" [function]
                  | "#subBind(" Name  ";" Name  ";;" Rbind  ")" [function]
                  | "#subBind(" Names ";" Names ";;" Rbind  ")" [function]
  syntax Rbinds ::= "#subBind(" Proc  ";" Proc  ";;" Rbinds ")" [function]
                  | "#subBind(" Procs ";" Procs ";;" Rbinds ")" [function]
                  | "#subBind(" Name  ";" Name  ";;" Rbinds ")" [function]
                  | "#subBind(" Names ";" Names ";;" Rbinds ")" [function]


  syntax  RhoKVPair ::= "#subKV(" Proc  ";" Proc  ";" RhoKVPair  ")" [function]
                      | "#subKV(" Procs ";" Procs ";" RhoKVPair  ")" [function]
                      | "#subKV(" Name  ";" Name  ";" RhoKVPair  ")" [function]
                      | "#subKV(" Names ";" Names ";" RhoKVPair  ")" [function]
  syntax RhoKVPairs ::= "#subKV(" Proc  ";" Proc  ";" RhoKVPairs ")" [function]
                      | "#subKV(" Procs ";" Procs ";" RhoKVPairs ")" [function]
                      | "#subKV(" Name  ";" Name  ";" RhoKVPairs ")" [function]
                      | "#subKV(" Names ";" Names ";" RhoKVPairs ")" [function]

  syntax  ConcatExp ::= "#subConcat(" Name  ";" Name  ";" ConcatExp ")" [function]
                      | "#subConcat(" Names ";" Names ";" ConcatExp ")" [function]
                      | "#subConcat(" Proc  ";" Proc  ";" ConcatExp ")" [function]
                      | "#subConcat(" Procs ";" Procs ";" ConcatExp ")" [function]

  syntax InterpMaps ::= "#subInterp(" Name  ";" Name  ";" InterpMaps ")" [function]
                      | "#subInterp(" Names ";" Names ";" InterpMaps ")" [function]
                      | "#subInterp(" Proc  ";" Proc  ";" InterpMaps ")" [function]
                      | "#subInterp(" Procs ";" Procs ";" InterpMaps ")" [function]

// Map substitutions
  syntax       Name ::= "#sub(" Map ";" Name  ")" [function]
  syntax      Names ::= "#sub(" Map ";" Names ")" [function]
  syntax       Proc ::= "#sub(" Map ";" Proc  ")" [function]
  syntax      Procs ::= "#sub(" Map ";" Procs ")" [function]

// Input guard satisfaction predicate for comm
  syntax       Bool ::= "#subGuard(" Proc  ";" Name  ";" BExp ")" [function]
  syntax       Bool ::= "#subGuard(" Procs ";" Names ";" BExp ")" [function]

endmodule

module SUB
  import SUB-SYNTAX
  import AUXFUN
  import NAMEVAR

  syntax KResult ::= Name | Names | Proc | Procs

// BoundName/Proc subs for ALPHA
  // requirements of #sub function on BoundNames/Procs for finishing De Bruijn index substitutions
  rule #sub( A:Name ; B:Name ;  C:BoundName ) =>  C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ;  C:BoundName ) =>  C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:Name ; B:Name ; *C:BoundName ) => *C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ; *C:BoundName ) => *C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:BoundName ; _:BoundName ;  _:BoundName ) =>  A
  rule #sub( A:BoundName ; _:BoundName ; *_:BoundName ) => *A
  rule #sub( A:BoundName ; _:BoundName ;  _:NameVar   ) =>  A
  rule #sub( A:BoundName ; _:BoundName ; *_:NameVar   ) => *A
  // no sub BoundName for BoundName in ProcVar
  rule #sub( _:BoundName ; _:BoundName ;  C:ProcVar   ) =>  C
  rule #sub( _:BoundName ; _:BoundName ; @C:ProcVar   ) => @C
  // no sub BoundName for BoundName in BoundProc
  rule #sub( _:BoundName ; _:BoundName ;  C:BoundProc ) =>  C
  rule #sub( _:BoundName ; _:BoundName ; @C:BoundProc ) => @C

  rule #sub( A:Name ; B:Name ;  C:BoundProc ) =>  C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ;  C:BoundProc ) =>  C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:Name ; B:Name ; @C:BoundProc ) => @C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ; @C:BoundProc ) => @C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:BoundProc ; _:BoundProc ;  _:BoundProc ) =>  A
  rule #sub( A:BoundProc ; _:BoundProc ; @_:BoundProc ) => @A
  rule #sub( A:BoundProc ; _:BoundProc ;  _:ProcVar   ) =>  A
  rule #sub( A:BoundProc ; _:BoundProc ; @_:ProcVar   ) => @A
  // no sub BoundProc for BoundProc in NameVar
  rule #sub( _:BoundProc ; _:BoundProc ;  C:NameVar   ) =>  C
  rule #sub( _:BoundProc ; _:BoundProc ; *C:NameVar   ) => *C
  // no sub BoundProc for BoundProc in BoundName
  rule #sub( _:BoundProc ; _:BoundProc ;  C:BoundName ) =>  C
  rule #sub( _:BoundProc ; _:BoundProc ; *C:BoundName ) => *C

// For #mapSub -- de Bruijn indexing for Receive 
  rule #sub( _:Name ; @sub ; N:Name ) => N
  rule #sub( _:Name ; @sub ; P:Proc ) => P
  rule #sub( _:Proc ;  sub ; N:Name ) => N
  rule #sub( _:Proc ;  sub ; P:Proc ) => P

//------------------------------------------------
//--- Substitute Proc for Proc in Proc or Name ---
//------------------------------------------------
// Trivial cases
  rule #sub( A:Proc ; A ; N:Name ) => N
  rule #sub( A:Proc ; A ; P:Proc ) => P
  rule #sub( _:Proc ; _:Proc ; G:Ground ) => G

// Fundamental cases -- variables
  // sub Proc for ProcVar in ProcVar or NameVar
  rule #sub( A:Proc ; B:ProcVar ; C:ProcVar ) => A requires B ==K C
  rule #sub( A:Proc ; B:ProcVar ; C:ProcVar ) => C requires B =/=K C
  rule #sub( _:Proc ; _:ProcVar ; A:NameVar ) => A

  // sub Proc for *NameVar in NameVar or ProcVar
  rule #sub( A:Proc ; *B:NameVar ; C:NameVar ) => @A requires B ==K C
  rule #sub( A:Proc ; *B:NameVar ; C:NameVar ) =>  C requires B =/=K C
  rule #sub( _:Proc ; *_:NameVar ; A:ProcVar ) =>  A

  // TODO: sub for Uri for #match

// Recusive cases -- destructuring substitution Proc or Name
  // sub Proc for Proc in @Proc
  rule #sub( A:Proc ; B:Proc ; @C:Proc ) => @ #sub(A;B;C)

  // sub Proc for Proc in *Name
  rule #sub( A:Proc ; B:Proc ; *C:Name ) => * #sub(A;B;C)

  // sub *Name for *Name in Proc
  rule #sub( *A:Name ; *B:Name ; C:Proc ) => #sub(A;B;C)

  // sub Proc for Proc in Send -- sub in channel and continuation
  rule #sub( A:Proc ; B:Proc ; C:Name !  (         ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Proc  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! (         ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Proc  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Proc for Proc in Receive -- only substitute free variables in channel and continuation
    // if substitution variables are all listening variables and not receive variables, then no substitution occurs
  rule #sub( _:Proc ;  B:Proc    ; Rec:Receive ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
    // if substitution variables are distinct from free variables in Rec, then no substitution occurs
  rule #sub( _:Proc ;  B:Proc    ; Rec:Receive ) => Rec requires intersectSet(#FV(B),#FV(Rec)) <=Set .Set
    // substituting for a ProcVar -- if ProcVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Proc ;  B:ProcVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
    // substituting for *NameVar -- if NameVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Proc ; *B:NameVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(@A;B;Rec) #else #subRec(@A;B;Rec) #fi

    // if substitution variable is a listening variable, then it is only substituted in the channel (not in the guard or continuation)
  rule #subChan( A:Proc ; B:ProcVar ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ Cont }
    // guarded
  rule #subChan( A:Proc ; B:ProcVar ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs)  if #sub(A;B;G)){ Cont }

    // if NameVar to be substituted not a listening variable, then it is substituted in the channel and continuation (and guard)
  rule #subRec( A:Proc ; B:ProcVar ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ #sub(A;B;Cont) }
      // guarded
  rule #subRec( A:Proc ; B:ProcVar ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }

  // Binds
    // Linear
  rule #subBind( A:Proc ; B:Proc ;;         <- X:Name  ) =>   <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Name  <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind ; D:Lbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind ; D:Lbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
    // Repeated
  rule #subBind( A:Proc ; B:Proc ;;         <= X:Name  ) =>   <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Name  <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind ; D:Rbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind ; D:Rbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
    // Peek
  rule #subBind( A:Proc ; B:Proc ;;         <! X:Name  ) =>   <! #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Name  <! X:Name  ) => Y <! #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names <! X:Name  ) => Y <! #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind ; D:Pbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind ; D:Pbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)

// MultiRec
  rule #subRec( A:Proc ; B:ProcVar ; for(         <- X:Name ; L:Lbind ){ P:Proc } ) => for(   <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:ProcVar ; for( Y:Name  <- X:Name ; L:Lbind ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:ProcVar ; for( Y:Names <- X:Name ; L:Lbind ){ P:Proc } ) => for( Y <- #sub(A;B;X) ){ #sub(A;B;P) }

  // sub Proc for Proc in Par -- apply after normalization
  rule #sub( A:Proc ; B:Proc ; C:Proc | D:Proc ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isPar(A)

// sub Proc for Proc in Collections
  // RhoList
  rule #sub( _:Proc ; _:Proc ; [ ] ) => [ ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc  ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc , D:Proc  ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc , D:Procs ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]

  // RhoMap
  rule #sub( _:Proc ; _:Proc ; { } ) => { }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair  } ) => { #subKV(A;B;C) }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair , D:RhoKVPair  } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair , D:RhoKVPairs } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
    // RhoKVPairs
  rule #subKV( A:Proc ; B:Proc ; C:Proc : D:Proc ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)

  // RhoSet
  rule #sub( _:Proc ; _:Proc ; Set( ) ) => Set( )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc  ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc , D:Proc  ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc , D:Procs ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )

  // RhoTuple
  rule #sub( A:Proc ; B:Proc ; ( C:Proc  ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Proc ; B:Proc ; ( C:Procs ,) ) => ( #sub(A;B;C) ,)

// sub Proc for Proc in New
  rule #sub( A:Proc ; B:ProcVar ; P:New ) => #if (@B #in (#dec(P))) #then P #else #subNew(A;B;P) #fi

  rule #subNew( A:Proc ; B:Proc ; new C:Name  in { D:Proc } ) => new C in { #sub(A;B;D) }
  rule #subNew( A:Proc ; B:Proc ; new C:Names in { D:Proc } ) => new C in { #sub(A;B;D) }

// Arithmetic Exps
  rule #sub( A:Proc ; B:Proc ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
// String expressions
  rule #sub( A:Proc ; B:Proc ; C:StringOrVar D:ConcatExp ) => #sub(A;B;C) #subConcat(A;B;D)
  rule #subConcat( A:Proc ; B:Proc ; ++ C:StringOrVar ) => ++ #sub(A;B;C)
  rule #subConcat( A:Proc ; B:Proc ; ++ C:StringOrVar D:ConcatExp ) => ++ #sub(A;B;C) #subConcat(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:StringOrVar %% D:InterpMaps ) => #sub(A;B;C) %% #subInterp(A;B;D)
  rule #subInterp( A:Proc ; B:Proc ; C:RhoMap ) => #sub(A;B;C)
  rule #subInterp( A:Proc ; B:Proc ; C:RhoMap %% D:InterpMaps ) => #sub(A;B;C) %% #subInterp(A;B;D)

// Boolean Exps
  rule #sub( A:Proc ; B:Proc ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc matches D:Proc ) => #sub(A;B;C) matches #sub(A;B;D)

// sub Proc for Proc in Names
  rule #sub( A:Proc ; B:Proc ; C:Name , D:Name  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name , D:Names ) => #sub(A;B;C) , #sub(A;B;D)
// sub Proc for Proc in Procs
  rule #sub( A:Proc ; B:Proc ; C:Proc , D:Proc  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc , D:Procs ) => #sub(A;B;C) , #sub(A;B;D)

// Several Procs substitutions
  // sub Procs for Procs in Name -- applies after #match predicate so lengths are assumed equal
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; N:Name ) => #sub(B;D;#sub(A;C;N))
  // sub Procs for Procs in Proc
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  // sub Procs for Procs in Names
  rule #sub( A:Procs ; B:Procs ; M:Name , N:Name  ) => #append(#sub(A;B;M);#sub(A;B;N))
  rule #sub( A:Procs ; B:Procs ; M:Name , N:Names ) => #append(#sub(A;B;M);#sub(A;B;N))
// sub Procs for Procs in Procs
  rule #sub( A:Procs ; B:Procs ; P:Proc , Q:Proc  ) => #append(#sub(A;B;P);#sub(A;B;Q))
  rule #sub( A:Procs ; B:Procs ; P:Proc , Q:Procs ) => #append(#sub(A;B;P);#sub(A;B;Q))

// sub Proc for Proc in Map
  rule #sub( _:Proc ; _:Proc ; .Map ) => .Map
  rule #sub( A:Proc ; B:Proc ; C:Proc |-> D:Proc E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Proc ; B:Proc ; C:Name |-> D:Name E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)

//-----------------------
//--- Deeper Patterns ---
//-----------------------
// sub Send for Send in Proc - sub channel for channel and message(s) for message(s)
  rule #sub( A:Name !  (         ) ; B:Name !  (         ) ; P:Proc ) => #sub(A;B;P)
  rule #sub( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name !! (         ) ; B:Name !! (         ) ; P:Proc ) => #sub(A;B;P)
  rule #sub( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
// sub Send for Send in Name - sub channel for channel and message(s) for message(s)
  rule #sub( A:Name !  (         ) ; B:Name !  (         ) ; N:Name ) => #sub(A;B;N)
  rule #sub( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name !! (         ) ; B:Name !! (         ) ; N:Name ) => #sub(A;B;N)
  rule #sub( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ; N:Name ) => #sub(B;D;#sub(A;C;N))

// TODO: more testing!!!
// sub Receive for Receive in Proc or Name
  // single
    // unguarded -- channel free variables substituted into Proc first, then continuation free variables substituted into that
  rule #sub( for( A:Lbind ){ C:Proc } ; for( B:Lbind ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Pbind ){ C:Proc } ; for( B:Pbind ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Rbind ){ C:Proc } ; for( B:Rbind ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Lbind ){ C:Proc } ; for( B:Lbind ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
  rule #sub( for( A:Pbind ){ C:Proc } ; for( B:Pbind ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
  rule #sub( for( A:Rbind ){ C:Proc } ; for( B:Rbind ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
    // guarded

  // multi
    // unguarded
  rule #sub( for( A:Lbinds ){ C:Proc } ; for( B:Lbinds ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Pbinds ){ C:Proc } ; for( B:Pbinds ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Rbinds ){ C:Proc } ; for( B:Rbinds ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Lbinds ){ C:Proc } ; for( B:Lbinds ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
  rule #sub( for( A:Pbinds ){ C:Proc } ; for( B:Pbinds ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
  rule #sub( for( A:Rbinds ){ C:Proc } ; for( B:Rbinds ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
    // guarded -- sub guard free variables after channels and before continuations

// sub Par for Par in Name or Proc -- applied after normalization
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; N:Name ) => #sub(B;D;#sub(A;C;N)) requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; P:Proc ) => #sub(B;D;#sub(A;C;P)) requires notBool (isPar(A) orBool isPar(C))

// TODO: other productions



//------------------------------------------------
//--- Substitute Name for Name in Name or Proc ---
//------------------------------------------------
// Trivial cases
  rule #sub( A:Name ; A ; N:Name ) => N
  rule #sub( A:Name ; A ; P:Proc ) => P
  rule #sub( _:Name ; _:Name ; G:Ground ) => G

// Fundamental cases
  // sub Name for NameVar in NameVar or ProcVar
  rule #sub( A:Name ; B:NameVar ; C:NameVar ) => A requires B ==K C
  rule #sub( A:Name ; B:NameVar ; C:NameVar ) => C requires B =/=K C
  rule #sub( _:Name ; _:NameVar ; A:ProcVar ) => A

  // sub Name for @ProcVar in NameVar
  rule #sub( A:Name ; @B:ProcVar ; C:ProcVar ) => *A requires B ==K C
  rule #sub( A:Name ; @B:ProcVar ; C:ProcVar ) =>  C requires B =/=K C
  rule #sub( _:Name ; @_:ProcVar ; A:NameVar ) =>  A

// Recursive cases
  // sub Name for Name in @Proc
  rule #sub( A:Name ; B:Name ; @C:Proc ) => @ #sub(A;B;C)

  // sub Name for Name in *Name
  rule #sub( A:Name ; B:Name ; *C:Name ) => * #sub(A;B;C)

  rule #sub( A:NameVar ; @B:Proc ; C:Proc ) => #sub(*A;B;C)

  // sub @Proc for @Proc in Name & Proc - drop quotes
  rule #sub( @A:Proc ; @B:Proc ; C:Name ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:Proc ; C:Proc ) => #sub(A;B;C)

  // sub Name for Name in Receive -- only substitute free variables in channel and continuation
    // if substitution variables are all listening variables and not receive variables, then no substitution occurs
  rule #sub( _:Name ;  B:Name    ; Rec:Receive ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
    // if substitution variables are distinct from free variables in Rec, then no substitution occurs
  rule #sub( _:Name ;  B:Name    ; Rec:Receive ) => Rec requires intersectSet(#FV(B),#FV(Rec)) <=Set .Set
    // substituting for a ProcVar -- if ProcVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Name ;  B:NameVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
    // substituting for *NameVar -- if NameVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Name ; @B:ProcVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(*A;B;Rec) #else #subRec(*A;B;Rec) #fi

    // if substitution variable is a listening variable, then it is only substituted in the channel (not in the guard or continuation)
  rule #subChan( A:Name ; B:NameVar ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ Cont }
    // guarded
  rule #subChan( A:Name ; B:NameVar ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs)  if #sub(A;B;G)){ Cont }

    // if NameVar to be substituted not a listening variable, then it is substituted in the channel and continuation (and guard)
  rule #subRec( A:Name ; B:NameVar ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ #sub(A;B;Cont) }
      // guarded
  rule #subRec( A:Name ; B:NameVar ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }

  // Binds
    // Linear
  rule #subBind( A:Name ; B:Name ;;         <- X:Name  ) =>   <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Name  <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Lbind ; D:Lbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Lbind ; D:Lbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
    // Repeated
  rule #subBind( A:Name ; B:Name ;;         <= X:Name  ) =>   <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Name  <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Rbind ; D:Rbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Rbind ; D:Rbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
    // Peek
  rule #subBind( A:Name ; B:Name ;;         <! X:Name  ) =>   <! #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Name  <! X:Name  ) => Y <! #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names <! X:Name  ) => Y <! #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Pbind ; D:Pbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Pbind ; D:Pbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)

  // sub Name for Name in Send
  rule #sub( A:Name ; B:Name ; C:Name !  (         ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Name ; B:Name ; C:Name !  ( D:Proc  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; C:Name !! (         ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Name ; B:Name ; C:Name !! ( D:Proc  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Name for Name in Par
  rule #sub( A:Name ; B:Name ; C:Proc | D:Proc ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isPar(A)

  // sub Name for Name in Collections
    // RhoList
  rule #sub( _:Name ; _:Name ; [ ] ) => [ ]
  rule #sub( A:Name ; B:Name ; [ C:Proc ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Name ; B:Name ; [ C:Proc , D:Proc  ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]
  rule #sub( A:Name ; B:Name ; [ C:Proc , D:Procs ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]

    // RhoMap
  rule #sub( _:Name ; _:Name ; { } ) => { }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair } ) => { #subKV(A;B;C) }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair , D:RhoKVPair  } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair , D:RhoKVPairs } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
      // RhoKVPairs
  rule #subKV( A:Name ; B:Name ; C:Proc : D:Proc ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:Name ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:Name ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)

    // RhoSet
  rule #sub( _:Name ; _:Name ; Set( ) ) => Set( )
  rule #sub( A:Name ; B:Name ; Set( C:Proc ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Name ; B:Name ; Set( C:Proc , D:Proc  ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; Set( C:Proc , D:Procs ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )

    // RhoTuple
//  rule #sub( _:Name ; _:Name ; ( ) ) => ( )
  rule #sub( A:Name ; B:Name ; ( C:Proc  ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Name ; B:Name ; ( C:Procs ,) ) => ( #sub(A;B;C) ,)

  // sub Name for Name in New -- if substitution variable is bound, no substitution occurs, else substitute in Proc
  rule #sub( A:Name ; B:NameVar ; P:New ) => #if (B #in (#dec(P))) #then P #else #subNew(A;B;P) #fi

  rule #subNew( A:Name ; B:Name ; new C:Name  in { D:Proc } ) => new C in { #sub(A;B;D) }
  rule #subNew( A:Name ; B:Name ; new C:Names in { D:Proc } ) => new C in { #sub(A;B;D) }

// Arithmetic Exps
  rule #sub( A:Name ; B:Name ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Name ; B:Name ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
// String expressions
  rule #sub( A:Name ; B:Name ; C:StringOrVar D:ConcatExp ) => #sub(A;B;C) #subConcat(A;B;D)
  rule #subConcat( A:Name ; B:Name ; ++ C:StringOrVar ) => ++ #sub(A;B;C)
  rule #subConcat( A:Name ; B:Name ; ++ C:StringOrVar D:ConcatExp ) => ++ #sub(A;B;C) #subConcat(A;B;D)

  rule #sub( A:Name ; B:Name ; C:StringOrVar %% D:RhoMap ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:StringOrVar %% D:RhoMap %% E:InterpMaps ) => #sub(A;B;C) %% #subInterp(A;B;D %% E)
  rule #subInterp( A:Name ; B:Name ; C:RhoMap ) => #sub(A;B;C)
  rule #subInterp( A:Name ; B:Name ; C:RhoMap %% D:InterpMaps ) => #sub(A;B;C) %% #subInterp(A;B;D)

// Boolean Exps
  rule #sub( A:Name ; B:Name ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Name ; B:Name ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc matches D:Proc ) => #sub(A;B;C) matches #sub(A;B;D)

// Condtionals
  rule #sub( A:Name ; B:Name ; if (C:BExp) D:Proc   ) => if (#sub(A;B;C)) #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:IfThen else D:Proc ) => #sub(A;B;C) else #sub(A;B;D)

// sub Names for Names in Name
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; N:Name ) => #sub(B;D;#sub(A;C;N))
// sub Names for Names in Proc
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; P:Proc ) => #sub(B;D;#sub(A;C;P))
// sub Name for Name in Names
  rule #sub( A:Name ; B:Name ; C:Name , D:Name  ) => #append(#sub(A;B;C);#sub(A;B;D))
  rule #sub( A:Name ; B:Name ; C:Name , D:Names ) => #append(#sub(A;B;C);#sub(A;B;D))
// sub Name for Name in Procs
  rule #sub( A:Name ; B:Name ; C:Proc , D:Proc  ) => #append(#sub(A;B;C);#sub(A;B;D))
  rule #sub( A:Name ; B:Name ; C:Proc , D:Procs ) => #append(#sub(A;B;C);#sub(A;B;D))
// sub Names for Names in Names
  rule #sub( A:Names ; B:Names ; M:Name , N:Name  ) => #append(#sub(A;B;M);#sub(A;B;N))
  rule #sub( A:Names ; B:Names ; M:Name , N:Names ) => #append(#sub(A;B;M);#sub(A;B;N))
// sub Names for Names in Procs
  rule #sub( A:Names ; B:Names ; P:Proc , Q:Proc  ) => #append(#sub(A;B;P);#sub(A;B;Q))
  rule #sub( A:Names ; B:Names ; P:Proc , Q:Procs ) => #append(#sub(A;B;P);#sub(A;B;Q))

// sub Name for Name in Map
  rule #sub( _:Name ; _:Name ; .Map ) => .Map
  rule #sub( A:Name ; B:Name ; C:Proc |-> D:Proc M:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;M)
  rule #sub( A:Name ; B:Name ; C:Name |-> D:Name M:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;M)

//-------------------------
//--- Map substitutions ---
//-------------------------
  // if no variables are map keys, then no substitution happens
  rule #sub( M:Map ; N:Name ) => N requires intersectSet(#FV(N),keys(M)) <=Set .Set
  rule #sub( M:Map ; A:Name , B:Name  ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) <=Set .Set
  rule #sub( M:Map ; A:Name , B:Names ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) <=Set .Set
  // if variables appear as map keys, substitute value for key
  rule #sub( Key:Name |-> Val:Name M:Map ; N:Name  ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Name |-> Val:Name M:Map ; N:Names ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:Name  ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:Names ) => #sub(M;#sub(Val;Key;N))

  // if no variables are map keys, then no substitution happens
  rule #sub( M:Map ; P:Proc ) => P requires intersectSet(#FV(P),keys(M)) <=Set .Set
  rule #sub( M:Map ; A:Proc , B:Proc  ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) <=Set .Set
  rule #sub( M:Map ; A:Proc , B:Procs ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) <=Set .Set
  // if variables appear as map keys, substitute value for key
  rule #sub( Key:Name |-> Val:Name M:Map ; P:Proc  ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Name |-> Val:Name M:Map ; P:Procs ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:Proc  ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:Procs ) => #sub(M;#sub(Val;Key;P))

//-----------------
//--- #subGuard ---
//-----------------
  rule #subGuard( P:Proc  ; N:Name  ; B:BExp ) => #sub(@P;N;B)
  rule #subGuard( P:Procs ; N:Names ; B:BExp ) => #sub(#quotes(P);N;B)


  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule