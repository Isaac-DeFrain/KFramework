// Pattern Matching (Structural Type Inclusion) Predicate for Rholang
  // In general, structural types must be the same for match to be successful
  // except in the case of variables, i.e. any Proc matches a PVar or EvalVar,
  // any Name matches a Var or @PVar, etc.

  // Comm events only call #match(Name;Name[Pat]) and #match(Proc;Proc[Pat])
  // #match(NamePat;NamePat) and #match(ProcPat;ProcPat) are needed for structural equivalence

require "domains.k"
require "../AlphaEquiv/alpha.k"
require "../AuxFun/auxfun.k"
require "../grho.k"
require "../Substitute/sub.k"

module MATCH-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// #match predicate checks structural type inclusion of terms
// Names & Procs
  syntax   Bool ::=   "#match(" Procs ";" Procs ")" [function]
                  |   "#match(" Names ";" Names ")" [function]
                  | "#matchif(" Procs ";" Procs ")" [function]
                  | "#matchif(" Names ";" Names ")" [function]
// Patterns
  syntax   Bool ::=   "#match(" Procs    ";" ProcPats ")" [function]
                  |   "#match(" ProcPats ";" Procs    ")" [function]
                  |   "#match(" ProcPats ";" ProcPats ")" [function]
                  |   "#match(" Names    ";" NamePats ")" [function]
                  |   "#match(" NamePats ";" Names    ")" [function]
                  |   "#match(" NamePats ";" NamePats ")" [function]
                  | "#matchif(" Procs    ";" ProcPats ")" [function]
                  | "#matchif(" ProcPats ";" Procs    ")" [function]
                  | "#matchif(" ProcPats ";" ProcPats ")" [function]
                  | "#matchif(" Names    ";" NamePats ")" [function]
                  | "#matchif(" NamePats ";" Names    ")" [function]
                  | "#matchif(" NamePats ";" NamePats ")" [function]

// Par[Pat]
  syntax   Bool ::= "#matchif+(" Proc    ";" Proc     ")" [function]
                  | "#matchif+(" Proc    ";" ProcPat  ")" [function]
                  | "#matchif+(" ProcPat ";" Proc     ")" [function]
                  | "#matchif+(" ProcPat ";" ProcPat  ")" [function]

  // BindPat[s]
  syntax   Bool ::=   "#match(" LbindPat  ";" LbindPat  ")" [function]
                  |   "#match(" PbindPat  ";" PbindPat  ")" [function]
                  |   "#match(" RbindPat  ";" RbindPat  ")" [function]
                  | "#matchif(" BindPat   ";" BindPat   ")" [function]
  syntax   Bool ::=   "#match(" LbindPats ";" LbindPats ")" [function]
                  |   "#match(" PbindPats ";" PbindPats ")" [function]
                  |   "#match(" RbindPats ";" RbindPats ")" [function]
                  | "#matchif(" BindPats  ";" BindPats  ")" [function]

// Matching Binds set -- collects indices of matching binds
  syntax    Set ::= "#matchBindSet(" MRecPat  ";;" MRecPat  ")"                          [function]
  syntax    Set ::= "#matchBindSet(" BindPats ";;" BindPats ")"                          [function]
                  | "#matchBindSet(" BindPat  ";;" BindPat  ";;" Int ";" Int ")"         [function]
                  | "#matchBindSet(" BindPat  ";;" BindPats ";;" Int ";" Int ")"         [function]
                  | "#matchBindSet(" BindPats ";;" BindPats ";;" Int ";" Int ")"         [function]
                  | "#matchBindSet(" BindPat  ";;" BindPat  ";;" Int ";" Int ";" Int ")" [function]
                  | "#matchBindSet(" BindPat  ";;" BindPats ";;" Int ";" Int ";" Int ")" [function]
                  | "#matchBindSet(" BindPats ";;" BindPats ";;" Int ";" Int ";" Int ")" [function]
  // matchBindSet Set union
  syntax    Set ::= "#unionMBS(" Set ";" Set ")" [function]
  // Check #matchBindSet
    // checks that each candidate bind matches a to-be-matched bind
  syntax   Bool ::=  "#checkMBS(" Set ")" [function]
    // checks that each to-be-matched bind is matched by a candidate bind
  syntax   Bool ::= "#checkMBS+(" Set ")"                 [function]
                  | "#checkMBS+(" Set ";" Set ";" Int ")" [function]

// subexpressions
  syntax   Bool ::=    "#match(" InterpMaps ";" InterpMaps ")" [function]
                  |    "#match(" RhoKVPairs ";" RhoKVPairs ")" [function]
                  |    "#match(" RhoKVPairs ";" RhoKVPats  ")" [function]
                  |    "#match(" RhoKVPats  ";" RhoKVPats  ")" [function]
                  |  "#matchif(" RhoKVPairs ";" RhoKVPairs ")" [function]
                  |  "#matchif(" RhoKVPairs ";" RhoKVPats  ")" [function]
                  |  "#matchif(" RhoKVPats  ";" RhoKVPats  ")" [function]
                  | "#matchif+(" ConcatList ";" ConcatList ")" [function]
                  | "#matchif+(" ConcatStr  ";" ConcatStr  ")" [function]
                  | "#matchif+(" InterpMaps ";" InterpMaps ")" [function]

  syntax   Bool ::= "#matchBind(" Send ";;" AnyBind ")" [function]

  syntax   Bool ::= "#includedIn(" Map  ";" Map ")" [function]

// Matching Par
  syntax   Bool ::= "#includedIn(" Set     ";" Set     ")" [function]
  syntax   Proc ::= "#removeProc(" ProcPat ";" ProcPat ")" [function]
  syntax    Int ::=  "#countProc(" ProcPat ";" ProcPat ")" [function]
  syntax    Set ::=    "#par2set(" ProcPat ")"             [function]

  syntax  KItem ::= Name | Names | NamePat | NamePats
                  | Proc | Procs | ProcPat | ProcPats
                  | IndexedBinds | IndexedNames | IndexedSet

endmodule

module MATCH
  import MATCH-SYNTAX
  import ALPHA
  import AUXFUN
  import SUB

  syntax KResult ::= Bool | Int | Proc | Set

// #matchif
  rule #matchif( A:NamePats  ; B:NamePats  ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:ProcPats  ; B:ProcPats  ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:RhoKVPats ; B:RhoKVPats ) => #length(A) ==Int #length(B) andBool #match(A;B)
  // BindPat[s] ; BindPat[s]
  rule #matchif( A:LbindPat  ; B:LbindPat  ) => #length(#bvar(A)) ==Int #length(#bvar(B)) andBool #match(A;B)
  rule #matchif( A:PbindPat  ; B:PbindPat  ) => #length(#bvar(A)) ==Int #length(#bvar(B)) andBool #match(A;B)
  rule #matchif( A:RbindPat  ; B:RbindPat  ) => #length(#bvar(A)) ==Int #length(#bvar(B)) andBool #match(A;B)
  rule #matchif( A:LbindPats ; B:LbindPats ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:PbindPats ; B:PbindPats ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:RbindPats ; B:RbindPats ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( _:LbindPats ; B:BindPats  ) => false requires notBool isLbindPats(B)
  rule #matchif( _:PbindPats ; B:BindPats  ) => false requires notBool isPbindPats(B)
  rule #matchif( _:RbindPats ; B:BindPats  ) => false requires notBool isRbindPats(B)
  rule #matchif( _:LbindPat  ; B:BindPat   ) => false requires notBool  isLbindPat(B)
  rule #matchif( _:PbindPat  ; B:BindPat   ) => false requires notBool  isPbindPat(B)
  rule #matchif( _:RbindPat  ; B:BindPat   ) => false requires notBool  isRbindPat(B)

//----------------------------
//--- Name & Proc Matching ---
//----------------------------
// Name matching
  rule #match( A:Name  ;  A      ) => true
  rule #match( _:Name  ;  A:Var  ) => true requires notBool isBoundName(A)
  rule #match( A:Name  ; @B:Proc ) => #match(*A;B)
  rule #match( @EmptyP ;  EmptyN ) => true // empty send/empty listen matching
  rule #match(  EmptyN ; @EmptyP ) => true // empty send/empty listen matching
  // declared name variables -- BoundName
  rule #match( n( I:Int )         ; n( J:Int )         ) => I ==Int J // TODO: is this right???
  rule #match( n( L:Int , I:Int ) ; n( M:Int , J:Int ) ) => I ==Int J andBool L ==Int M
  rule #match( A:Name      ; _:BoundName ) => false requires notBool isBoundName(A)
  rule #match( _:BoundName ; A:Name      ) => false requires notBool isBoundName(A)
//  rule #match( n( I:Int ) ; @x( J:Int ) ) => I ==Int J // TODO ???

// Proc matching
  rule #match( A:Proc  ; A       ) => true
  rule #match( _:Proc  ; A:PVar  ) => true requires notBool isBoundProc(A)
  rule #match( A:Proc  ; *B:Name ) => #match(@A;B)
  rule #match(  EmptyP ; *EmptyN ) => true // empty send/empty listen matching
  rule #match( *EmptyN ;  EmptyP ) => true // empty send/empty listen matching
  // bound process variables -- BoundProc
  rule #match(  x( I:Int )         ;  x( J:Int )         ) => I ==Int J
  rule #match(  x( L:Int , I:Int ) ;  x( M:Int , J:Int ) ) => I ==Int J andBool L ==Int M
  rule #match( A:Proc      ; _:BoundProc ) => false requires notBool isBoundProc(A)
  rule #match( _:BoundProc ; A:Proc      ) => false requires notBool isBoundProc(A)
// rule #match( x( I:Int ) ; *n( J:Int ) ) => I ==Int J // TODO ???

  // the only Ground a Ground matches is itself
  // Ground ::= "Nil" | Bool | Int | String | Unforgeable | Uri
  rule #match( A:Ground ; B:Ground ) => A ==K B
  rule #match( A:Ground ; B:Proc   ) => false
       requires notBool (isGround(B) orBool isPVar(B) orBool isEvalVar(B))
  rule #match( A:Proc   ; B:Ground ) => false requires notBool isGround(A)

  // Eval matches Eval
  rule #match( *A:Name ; *B:Name ) => #match(A;B) // underlying Names must match
  rule #match(  _:Eval ;  A:Proc ) => false
       requires notBool (isPVar(A) orBool isEvalVar(A) orBool isNameRef(A))

  // Send matching -- TODO: add patterns
  // Send matches Send (if channels, type, and messages match), but only Send matches Send
  rule #match( A:Name !  (         ) ; C:Name !  (         ) ) => #match(A;C)
  rule #match( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! (         ) ; C:Name !! (         ) ) => #match(A;C)
  rule #match( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #match(A;C) andBool #matchif(B;D)
    // message length or send type mismatch
//  rule #match( _:Send ; _:Send ) => false [owise]
    // type mismatch
  rule #match( _:ConSend   ; A:Proc      ) => false
       requires notBool (isPVar(A) orBool isEvalVar(A) orBool isConSend(A))
  rule #match( A:Proc      ; _:ConSend   ) => false requires notBool isConSend(A)
  rule #match( _:UnconSend ; A:Proc      ) => false
       requires notBool (isPVar(A) orBool isEvalVar(A) orBool isUnconSend(A))
  rule #match( A:Proc      ; _:UnconSend ) => false
       requires notBool isUnconSend(A)

  // Receive matching
  // Receive matches Receive (if channels, listening variable length, and appropriately
  // substituted and indexed continuations match), but only Receive matches Receive
    // Binds -- corresponding listening variables and channels match (bvar length equality checked in #matchif)
  rule #match( A:LbindPat  ; B:LbindPat  ) => #match(#chan(A);#chan(B)) andBool   #match(#bvar(A);#bvar(B))
  rule #match( A:PbindPat  ; B:PbindPat  ) => #match(#chan(A);#chan(B)) andBool   #match(#bvar(A);#bvar(B))
  rule #match( A:RbindPat  ; B:RbindPat  ) => #match(#chan(A);#chan(B)) andBool   #match(#bvar(A);#bvar(B))
  rule #match( A:LbindPats ; B:LbindPats ) => #match(#chan(A);#chan(B)) andBool #matchif(#bvar(A);#bvar(B))
  rule #match( A:PbindPats ; B:PbindPats ) => #match(#chan(A);#chan(B)) andBool #matchif(#bvar(A);#bvar(B))
  rule #match( A:RbindPats ; B:RbindPats ) => #match(#chan(A);#chan(B)) andBool #matchif(#bvar(A);#bvar(B))

    // UGSRec
    // match bind and DeBruijnified substituted continuation
  rule #match( A:UGSRec ; B:UGSRec ) => #matchif(#bind(A);#bind(B)) andBool
       #match(#sub(#mapify(#bvar(A));#cont(A));#sub(#mapify(#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))
  rule #match( _:UGSRec ; A:Proc ) => false
       requires notBool (isUGSRec(A) orBool isPVar(A) orBool isEvalVar(A))
  rule #match( A:Proc ; _:UGSRec ) => false requires notBool isUGSRec(A)

    // GSRec
    // match bind, guard, and DeBruijnified substituted continuation
  rule #match( A:GSRec ; B:GSRec ) => #matchif(#bind(A);#bind(B)) andBool
       #match(#sub(#mapify(#bvar(A));#guard(A));#sub(#mapify(#bvar(A));#sub(#bvar(A);#bvar(B);#guard(B)))) andBool
       #match(#sub(#mapify(#bvar(A));#cont(A));#sub(#mapify(#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))
  rule #match( _:GSRec ; A:Proc ) => false
       requires notBool (isGSRec(A) orBool isPVar(A) orBool isEvalVar(A))
  rule #match( A:Proc ; _:GSRec ) => false requires notBool isGSRec(A)

/*
    // UGMRec
    // match binds and DeBruijnified "appropriately" substituted continuations
  rule #match( A:UGMRec ; B:UGMRec ) => #matchif(#bind(A);#bind(B)) andBool
       #match(#sub(#mapify(#bvar(A));#cont(A));#sub(#mapify(#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))
  rule #match( _:UGMRec ; A:Proc   ) => false
       requires notBool (isUGMRec(A) orBool isPVar(A) orBool isEval(A))
  rule #match( A:Proc   ; _:UGMRec ) => false requires notBool isUGMRec(A)
*/
  // Guarded
    // GSRec
  rule #match( for( A:Lbind if B:BExp ){ C:Proc } ; for( D:Lbind if E:BExp ){ F:Proc } )
    => #match(for(A){C};for(D){F}) andBool #match(B;E)
  rule #match( for( A:Pbind if B:BExp ){ C:Proc } ; for( D:Pbind if E:BExp ){ F:Proc } )
    => #match(for(A){C};for(D){F}) andBool #match(B;E)
  rule #match( for( A:Rbind if B:BExp ){ C:Proc } ; for( D:Rbind if E:BExp ){ F:Proc } )
    => #match(for(A){C};for(D){F}) andBool #match(B;E)

  rule #match( _:GSRec ; A:Proc ) => false
       requires notBool (isGSRec(A) orBool isPVar(A) orBool isEvalVar(A))
  rule #match( A:Proc ; _:GSRec ) => false requires notBool isGSRec(A)
/*
    // GMRec
  rule #match( _:GMRec ; A:Proc ) => false
       requires notBool (isGMRec(A) orBool isPVar(A) orBool isEval(A))
  rule #match( A:Proc ; _:GMRec ) => false requires notBool isGMRec(A)
*/

// TODO: ContractPat -- ContractPat matches ContractPat, nothing else matches ContractPat

// TODO: InvocationPat -- InvocationPat matches InvocationPat like Contract, nothing else matches InvocationPat

// VarRef
  rule #match( A:Proc    ; _:NameRef ) => false
       requires notBool (isNameRef(A) orBool isEvalVar(A))
  rule #match( _:NameRef ;   A:Proc  ) => false
       requires notBool (isNameRef(A) orBool isEvalVar(A) orBool isPVar(A))
  rule #match(  *A:Var   ; =*B:Var   ) => A ==K B  // only *x & =*x match =*x
  rule #match( =*A:Var   ; =*B:Var   ) => A ==K B

  rule #match( A:Proc    ; _:ProcRef ) => false
       requires notBool (isProcRef(A) orBool isPVar(A))
  rule #match( _:ProcRef ;   A:Proc  ) => false
       requires notBool (isProcRef(A) orBool isEvalVar(A) orBool isPVar(A))
  rule #match(  \A:Var   ; =\B:Var   ) => A ==K B // only \x matches =\x
  rule #match( =\A:Var   ; =\B:Var   ) => A ==K B

// Par match - apply after normalization
  // Par should only match Par[Pat] with matching terms of same length after normalization
    // check Par lengths
//  rule #matchif+( A:Proc    ; B:Proc    ) => #parlength(A) ==Int #parlength(B)
//  rule #matchif+( A:ProcPat ; B:Proc    ) => #parlength(A) ==Int #parlength(B)
//  rule #matchif+( A:Proc    ; B:ProcPat ) => #parlength(A) ==Int #parlength(B)
//  rule #matchif+( A:ProcPat ; B:ProcPat ) => #parlength(A) ==Int #parlength(B)
//  rule #match( A:Par ; B:Par  ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))

  // any ProcPat can match a ParPat -- TODO: test
    // nonParPat must match first Parand
  rule #match( A:ProcPat ; B:ProcPat | _:ProcPat ) => #match(A;B) requires notBool (isParPat(A) orBool isParPat(B))
    // ParPat
  rule #match( _:ProcPat | _:ProcPat  ;  _:PVar    | _:ProcPat ) => true
  rule #match( _:ProcPat | _:ProcPat  ; *_:Var     | _:ProcPat ) => true
  rule #match( A:ProcPat | B:ProcPat  ;  C:ProcPat | D:ProcPat )
    => #match(A;C) andBool #match(B;D) requires notBool (isParPat(A) orBool isParPat(C)) [owise]

// Collection matching - empty structures are accomodated by the first rule
  // RhoList matches RhoList (if underlying Procs match), nothing else matches RhoList
  rule #match( A:RhoList   ; _:EmptyList ) => false requires notBool isEmptyList(A)
  rule #match( _:EmptyList ; A:RhoList   ) => false requires notBool isEmptyList(A)
  rule #match( [ A:Procs ] ; [ B:Procs ] ) => #matchif(A;B)
  rule #match( A:Proc ; _:RhoList ) => false requires notBool isRhoList(A)
  rule #match( _:RhoList ; A:Proc ) => false
       requires notBool (isRhoList(A) orBool isPVar(A) orBool isEvalVar(A))

  // RhoMaps & RhoSets are unordered -> assume normalized
  // RhoMap matches RhoMap (if underlying Procs match), nothing else matches RhoMap
  rule #match( A:RhoMap   ; _:EmptyMap ) => false requires notBool isEmptyMap(A)
  rule #match( _:EmptyMap ; A:RhoMap   ) => false requires notBool isEmptyMap(A)
  rule #match( { A:RhoKVPairs } ; { B:RhoKVPairs } ) => #matchif(A;B)
//  rule #match( A:RhoMap   ; B:MapPat ) => #includedIn(#KVs2map(#rho2KVs(A));#KVs2map(#rho2KVs(B)))
//  rule #match( A:MapPat   ; B:MapPat ) => #includedIn(#KVs2map(#rho2KVs(A));#KVs2map(#rho2KVs(B)))

  rule #match( A:Proc : B:Proc ; C:Proc : D:Proc   ) => #match(A;C) andBool #match(B;D)
  rule #match( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs )
    => #match(A;C) andBool #match(B;D)

  // RhoSet matches RhoSet (if underlying Procs match)
  rule #match( Set( A:Procs ) ; Set( B:Procs ) ) => #matchif(A;B)
//  rule #match( Set( A:Procs ) ; Set( B:Procs    ) ) => #includedIn(#procs2set(A);#procs2set(B))
  rule #match( A:Proc ; _:RhoSet ) => false requires notBool isRhoSet(A)
  rule #match( _:RhoSet ; A:Proc ) => false
       requires notBool (isRhoSet(A) orBool isEvalVar(A) orBool isPVar(A))

  // RhoTuple matches RhoTuple (if underlying Procs match)
  rule #match( ( A:Procs ,) ; ( B:Procs ,) ) => #matchif(A;B)
  rule #match( A:Proc ; _:RhoTuple ) => false requires notBool isRhoTuple(A)
  rule #match( _:RhoTuple ; A:Proc ) => false
       requires notBool (isRhoTuple(A) orBool isEvalVar(A) orBool isPVar(A))

  // several Procs matching -- used in many other contexts
  rule #match( A:Proc , B:Procs ; C:Proc , D:Procs ) => #match(A;C) andBool #match(B;D)

// New matching
  // New matches New (if same "effective" number of Names declared and DeBruijnified Procs match)
  // nothing else matches New
  rule #match( A:New ; B:New ) => size(#DV(A)) ==Int size(#DV(B)) andBool
       #match(#subNew(0;#indecs(A);#newproc(A));#subNew(0;#indecs(B);#newproc(B)))
  rule #match( _:New ; A:Proc ) => false
       requires notBool (isNew(A) orBool isEvalVar(A) orBool isPVar(A))
  rule #match( A:Proc ; _:New ) => false requires notBool isNew(A)

// Arithmetic Exps matching
  // AExp matches AExp with matching subexpressions, nothing else matches AExp
  rule #match( - A:AExp ; - B:AExp ) => #match(A;B)
  rule #match( A:AExp * B:AExp ; C:AExp * D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp / B:AExp ; C:AExp / D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp + B:AExp ; C:AExp + D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp - B:AExp ; C:AExp - D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp % B:AExp ; C:AExp % D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp ; B:Proc ) => false
       requires notBool (isIntOrVar(A) orBool isAExp(B))
  rule #match( A:Proc ; B:AExp ) => false
       requires notBool (isAExp(A) orBool isIntOrVar(B))

// List & String Exps
  // only Concat matches Concat
  rule #match( A:ListOrVar ++ B:ListOrVar  ; C:ListOrVar ++ D:ListOrVar  )
    => #match(A;C) andBool #match(B;D)
  rule #match( A:ListOrVar ++ B:ConcatList ; C:ListOrVar ++ D:ConcatList )
    => #match(A;C) andBool #matchif+(B;D)
  rule #matchif+( A:ConcatList ; B:ConcatList )
    => #length+(A) ==Int #length+(B) andBool #match(A;B)
  // only Concat matches Concat
  rule #match( A:StringOrVar ++ B:StringExp ; C:StringOrVar ++ D:StringExp )
    => #match(A;C) andBool #match(B;D)
  rule #matchif+( A:ConcatStr ; B:ConcatStr   )
    => #length+(A) ==Int #length+(B) andBool #match(A;B)
  // only Interp matches Interp
  rule #match( A:StringOrVar %% B:InterpMaps ; C:StringOrVar %% D:InterpMaps )
    => #match(A;C) andBool #matchif+(B;D)
  rule #matchif+( A:InterpMaps ; B:InterpMaps )
    => #length+(A) ==Int #length+(B) andBool #match(A;B)
  // only StringExp matches StringExp
  rule #match( A:ListExp   ; B:Proc      ) => false
       requires notBool (isListOrVar(A) orBool isListExp(B))
  rule #match( A:Proc      ; B:ListExp   ) => false
       requires notBool (isListOrVar(A) orBool isListExp(B))
  rule #match( A:StringExp ; B:Proc      ) => false
       requires notBool (isStringOrVar(A) orBool isStringExp(B))
  rule #match( A:Proc      ; B:StringExp ) => false
       requires notBool ( isStringExp(A) orBool isStringOrVar(B))

// Boolean Exps matching
  // BExp matches BExp with matching subexpressions, nothing else matches BExp
  rule #match( not A:BExp ; not B:BExp ) => #match(A;B)
  rule #match( A:BExp and B:BExp ; C:BExp and D:BExp ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:BExp or  B:BExp ; C:BExp or  D:BExp ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:AExp <=  B:AExp ; C:AExp <=  D:AExp ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:AExp <   B:AExp ; C:AExp <   D:AExp ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:AExp >=  B:AExp ; C:AExp >=  D:AExp ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:AExp >   B:AExp ; C:AExp >   D:AExp ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:Proc ==  B:Proc ; C:Proc ==  D:Proc ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:Proc !=  B:Proc ; C:Proc !=  D:Proc ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:Name ==  B:Name ; C:Name ==  D:Name ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:Name !=  B:Name ; C:Name !=  D:Name ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:ProcPat matches B:ProcPat ; C:ProcPat matches D:ProcPat )
    => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:BExp ; B:Proc ) => false
       requires notBool (isBoolOrVar(A) orBool isBExp(B))
  rule #match( A:Proc ; B:BExp ) => false
       requires notBool (isBExp(A) orBool isBoolOrVar(B))

// MethodPat
  rule #match( A:ProcPat . B:Method ( C:ProcPats ) ; D:ProcPat . E:Method ( F:ProcPats ) )
    => #match(A;D) andBool B ==K E andBool #matchif(C;F)
  rule #match( A:ProcPat . B:Method ( ) ; D:ProcPat . E:Method ( ) )
    => #match(A;D) andBool B ==K E
  // empty args and nonempty args can't match
  rule #match( _:MethodPat ; _:MethodPat ) => false [owise]
  rule #match( A:ProcPat   ; _:MethodPat ) => false
       requires notBool isMethodPat(A)
  rule #match( _:MethodProc ; A:ProcPat  ) => false
       requires notBool (isMethodPat(A) orBool isPVar(A) orBool isEvalVar(A))
  rule #match( _:MethodProc ; *A:Name ) => false requires notBool isVar(A)

// TODO
// Match
// Select
// LetExp
// Bundle matches Bundle (if sign & underlying Procs match), nothing else matches Bundle
// Conditional matches Conditional (if underlying BExp and Procs match), nothing else matches Conditional

// several Names
  rule #match( A:Name , B:Names ; C:Name , D:Names ) => #match(A;C) andBool #match(B;D)

//------------------------
//--- Pattern Matching ---
//------------------------
// Pattern variables -- every name/proc/pattern matches any PatVar
//  rule #match( _:ProcPat ; _:PatVar ) => true
//  rule #match( _:NamePat ; _:PatVar ) => true
//  rule #match( _:Proc    ; _:PatVar ) => true
//  rule #match( _:Name    ; _:PatVar ) => true

// Every pattern matches itself
  rule #match( A:ProcPat ; A ) => true
  rule #match( A:NamePat ; A ) => true

// TODO: #match( A:Proc ; Null ) => #structEq(A;Nil)

// Name pattern
  // every Name matches WildCard
  rule #match(  _:Name ; \_ ) => true
  rule #match( \_  ; _:Name ) => false
  // every NamePat matches WildCard
  rule #match( _:NamePat ; \_ ) => true
  rule #match( A:NamePat ; @B:ProcPat ) => #match(*A;B)

// Process pattern
  // every Proc matches WildCard
  rule #match(  _:Proc ; \_ ) => true
  rule #match( \_  ; _:Proc ) => false
  rule #match( *A:Name ; *B:NamePat ) => #match(A;B)
  // every ProcPat matches WildCard
  rule #match(  _:ProcPat ; \_ ) => true
  rule #match( *A:NamePat ; *B:NamePat ) => #match(A;B)

// Simpe patterns
  rule #match( _:BoolExp       ; B:SimplePat   ) => B ==K Bool
  rule #match( _:IntExp        ; B:SimplePat   ) => B ==K Int
  rule #match( _:StringExp     ; B:SimplePat   ) => B ==K String
  rule #match( _:ConcatRhoList ; B:SimplePat   ) => B ==K List
  rule #match( _:RhoMap        ; B:SimplePat   ) => B ==K Map
  rule #match( _:RhoSet        ; B:SimplePat   ) => B ==K Set
  rule #match( _:RhoTuple      ; B:SimplePat   ) => B ==K Tuple
  rule #match( _:Unforgeable   ; B:SimplePat   ) => B ==K Unforgeable
  rule #match( _:Uri           ; B:SimplePat   ) => B ==K Uri
  rule #match( A:Proc          ; ClosedProc    ) => #FV(A) ==K .Set
  rule #match( A:Name          ; ClosedName    ) => #FV(A) ==K .Set
  rule #match( A:ProcPat       ; ClosedProcPat ) => #FV(A) ==K .Set
  rule #match( A:NamePat       ; ClosedNamePat ) => #FV(A) ==K .Set
  rule #match( A:SimplePat     ; B:SimplePat   ) => A ==K B
// TODO: contexts
  rule #match( _:ListPat   ; List  ) => true
  rule #match( _:TuplePat  ; Tuple ) => true
  rule #match( A:SimplePat ; B:SimplePat ) => A ==K B
  rule #match( A:ProcPat   ; _:SimplePat ) => false
       requires notBool (isSimplePat(A) orBool isCollectionPat(A) orBool isPatExp(A))
  rule #match( A:NamePat   ; ClosedName  ) => A ==K ClosedName
  rule #match( A:ProcPat   ; ClosedProc  ) => A ==K ClosedProc
  // empty collections & patterns
  rule #match( A:Proc    ; EmptyListPat ) => isEmptyList(A)
  rule #match( A:ProcPat ; EmptyListPat ) => A ==K EmptyListPat
  rule #match( A:Proc    ; EmptyMapPat  ) =>  isEmptyMap(A)
  rule #match( A:ProcPat ; EmptyMapPat  ) => A ==K EmptyMapPat
  rule #match( A:Proc    ; EmptySetPat  ) =>  isEmptySet(A)
  rule #match( A:ProcPat ; EmptySetPat  ) => A ==K EmptySetPat

// Pattern expressions
  // match PatExp with Proc
  rule #match(   A:Proc /\ _:SimplePat  ; B:Proc ) => #match( A;B)
  // match NamePat with Name
  rule #match( @{A:Proc /\ _:SimplePat} ; B:Name ) => #match(@A;B)

  // match Proc[Pat] with PatExp
  // Negation
  rule #match( A:ProcPat ; ~ \_ ) => false requires notBool A ==K ~\_
  rule #match( A:Proc    ; ~ B:Proc    ) => notBool #match(A;B)
  rule #match( A:Proc    ; ~ B:ProcPat ) => notBool #match(A;B)
       requires notBool isWildCard(B)
//  rule #match( A:SimplePat ; ~ B:Proc    ) => notBool #match(B;A)
//  rule #match( A:SimplePat ; ~ B:ProcPat ) => notBool #match(B;A)
//       requires notBool isWildCard(B)
  // And
  rule #match( A:Proc ; B:Proc    /\ C:Proc    ) => #match(A;B) andBool #match(A;C)
  rule #match( A:Proc ; B:Proc    /\ C:ProcPat ) => #match(A;B) andBool #match(A;C)
  rule #match( A:Proc ; B:ProcPat /\ C:Proc    ) => #match(A;B) andBool #match(A;C)
  rule #match( A:Proc ; B:ProcPat /\ C:ProcPat ) => #match(A;B) andBool #match(A;C)

  // Or
  rule #match( A:Proc ; B:Proc    \/ C:Proc    ) => #match(A;B) orBool  #match(A;C)
  rule #match( A:Proc ; B:Proc    \/ C:ProcPat ) => #match(A;B) orBool  #match(A;C)
  rule #match( A:Proc ; B:ProcPat \/ C:Proc    ) => #match(A;B) orBool  #match(A;C)
  rule #match( A:Proc ; B:ProcPat \/ C:ProcPat ) => #match(A;B) orBool  #match(A;C)

  // match PatExp with ProcPat -- TODO
  rule #match( A:Proc ; ~ B:Proc    ) => notBool #match(A;B)
  rule #match( A:Proc ; ~ B:ProcPat ) => notBool #match(A;B)

// ???
  rule #match( A:Proc    /\ B:ProcPat ; C:Proc    ) => #match(A;C) orBool #match(B;C)
  rule #match( A:ProcPat /\ B:Proc    ; C:Proc    ) => #match(A;C) orBool #match(B;C)

  rule #match( A:Proc    /\ B:ProcPat ; C:ProcPat ) => #match(A;C) orBool #match(B;C)
  rule #match( A:ProcPat /\ B:Proc    ; C:ProcPat ) => #match(A;C) orBool #match(B;C)

  rule #match( A:Proc \/ B:Proc ; C:ProcPat ) => #match(A;C) andBool #match(A;B)


// ParPat -- TODO: pat2set???
//  rule #match( A:Proc    ; B:ParPat  ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:Par     ; B:ProcPat ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:ProcPat ; B:Par     ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:ParPat  ; B:Proc    ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:ProcPat ; B:ParPat  ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:ParPat  ; B:ProcPat ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))

//  rule #match( _:Par    ; A:ProcPat ) => false requires notBool (isParPat(A) orBool isWildCard(A))
//  rule #match( _:ParPat ; A:ProcPat ) => false requires notBool (isParPat(A) orBool isWildCard(A)) // ParPat only matches ParPat or WildCard

// RecPat -- TODO
//  rule #match( for( A:Lbind ){ P:ProcPat } ; for( B:Lbind ){ Q:ProcPat } ) => ???

// SendPat
  // Consumable
    // match Send[Pat] with SendPat
      // Send = Name!( )
  rule #match( A:Name ! ( ) ; C:NamePat ! ( ) ) => #match(A;C)
      // Send = Name!(Procs)
  rule #match( A:Name ! ( B:Procs ) ; C:NamePat ! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name ! ( B:Procs ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name ! ( B:Procs ) ; C:Name    ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // Send = Name!(ProcPats)
  rule #match( A:Name ! ( B:ProcPats ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name ! ( B:ProcPats ) ; C:Name    ! ( D:ProcPats ) ) => #match(A;C) andBool #match(B;D)
    // SendPat = NamePat!( )
  rule #match( A:NamePat ! (  ) ; C:NamePat ! (  ) ) => #match(A;C)
    // SendPat = NamePat!(Procs)
  rule #match( A:NamePat ! ( B:Procs ) ; C:NamePat ! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:NamePat ! ( B:Procs ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // SendPat = NamePat!(ProcPats)
  rule #match( A:NamePat ! ( B:ProcPats ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)

  rule #match( A:Send     ; _:CSendPat ) => false [owise]
  rule #match( A:Proc     ; _:CSendPat ) => false requires notBool   isConSend(A)
  rule #match( A:ProcPat  ; _:CSendPat ) => false requires notBool  isCSendPat(A)
  rule #match( _:ConSend  ; A:ProcPat  ) => false requires notBool (isCSendPat(A) orBool isWildCard(A) orBool isPatExp(A))
  rule #match( _:CSendPat ; A:ProcPat  ) => false requires notBool (isCSendPat(A) orBool isWildCard(A) orBool isPatExp(A))

  // Unconsumable
    // Send = Name!!( )
  rule #match( A:Name !! (  ) ; C:NamePat !! (  ) ) => #match(A;C)
    // Send = Name!!(Procs)
  rule #match( A:Name !! ( B:Procs ) ; C:NamePat !! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:Name    !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // SendPat = NamePat!!( )
  rule #match( A:NamePat !! (      ) ; C:NamePat !! (            ) ) => #match(A;C)
    // Send = NamePat!!(Procs)
  rule #match( A:NamePat !! ( B:Procs ) ; C:NamePat !! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:NamePat !! ( B:Procs ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // Send = NamePat!!(ProcPats)
  rule #match( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)

  rule #match( _:Send      ; _:USendPat ) => false [owise]
  rule #match( A:Proc      ; _:USendPat ) => false requires notBool  isUnconSend(A)
  rule #match( A:ProcPat   ; _:USendPat ) => false requires notBool   isUSendPat(A)
  rule #match( _:UnconSend ; A:ProcPat  ) => false requires notBool  (isUSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))
  rule #match( _:USendPat  ; A:ProcPat  ) => false requires notBool  (isUSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))

// EvalPat
  rule #match( A:Proc    ;  _:EvalPat ) => false requires notBool (   isEval(A) orBool isPVar(A))
  rule #match( A:ProcPat ;  _:EvalPat ) => false requires notBool (isEvalPat(A) orBool isPVar(A))
  rule #match( _:Eval    ;  A:ProcPat ) => false
       requires notBool (isEvalPat(A) orBool isWildCard(A) orBool isPatExp(A) orBool isPVar(A))
  rule #match( _:EvalPat ;  A:ProcPat ) => false
       requires notBool (isEvalPat(A) orBool isWildCard(A) orBool isPatExp(A) orBool isPVar(A))

// NewPat
  rule #match( A:New    ; B:NewPat ) => size(#DV(A)) ==Int size(#DV(B)) andBool
       #match(#subNew(0;#indecs(A);#newproc(A));#subNew(0;#indecs(B);#newproc(B)))
  rule #match( A:NewPat ; B:NewPat ) => size(#DV(A)) ==Int size(#DV(B)) andBool
       #match(#subNew(0;#indecs(A);#newproc(A));#subNew(0;#indecs(B);#newproc(B)))
  // declaration length/type mismatch
  rule #match( A:Proc    ; _:NewPat ) => false requires notBool isNew(A)
  rule #match( A:ProcPat ; _:NewPat ) => false requires notBool isNewPat(A)

// CollectionPat
  // List Pattern
  rule #match( [ A:Procs    ] ; [ B:ProcPats ] ) => #matchif(A;B)
  rule #match( [ A:ProcPats ] ; [ B:ProcPats ] ) => #matchif(A;B)
  rule #match( [ A:Proc , _:Procs ] ; [ C:Proc                 ... _:ProcVar ] ) => #match(A;C)
  rule #match( [ A:Proc , _:Procs ] ; [ C:ProcPat              ... _:ProcVar ] ) => #match(A;C)
  rule #match( [ A:Proc , B:Procs ] ; [ C:Proc    , D:Procs    ... E:ProcVar ] ) => #match(A;C) andBool #match([B];[D...E])
  rule #match( [ A:Proc , B:Procs ] ; [ C:Proc    , D:ProcPats ... E:ProcVar ] ) => #match(A;C) andBool #match([B];[D...E])
  rule #match( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:Procs    ... E:ProcVar ] ) => #match(A;C) andBool #match([B];[D...E])
  rule #match( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:ProcPats ... E:ProcVar ] ) => #match(A;C) andBool #match([B];[D...E])

  // Map Pattern
  rule #match( { A:RhoKVPairs } ; { B:RhoKVPats } ) => #matchif(A;B)
  rule #match( { A:RhoKVPats  } ; { B:RhoKVPats } ) => #matchif(A;B)
  rule #match( { A:RhoKVPair , _:RhoKVPairs } ; { C:RhoKVPair                ... _:ProcVar } ) => #match(A;C)
  rule #match( { A:RhoKVPair , _:RhoKVPairs } ; { C:RhoKVPat                 ... _:ProcVar } ) => #match(A;C)
  rule #match( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  rule #match( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPats  ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  rule #match( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPairs ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  rule #match( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPats  ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  rule #match( { A:RhoKVPair , _:RhoKVPats  } ; { C:RhoKVPair                ... _:ProcVar } ) => #match(A;C)
  rule #match( { A:RhoKVPat  , _:RhoKVPairs } ; { C:RhoKVPat                 ... _:ProcVar } ) => #match(A;C)
  rule #match( { A:RhoKVPair , _:RhoKVPats  } ; { C:RhoKVPat                 ... _:ProcVar } ) => #match(A;C)
  rule #match( { A:RhoKVPat  , _:RhoKVPats  } ; { C:RhoKVPat                 ... _:ProcVar } ) => #match(A;C)
  rule #match( { A:RhoKVPair , B:RhoKVPats  } ; { C:RhoKVPair , D:RhoKVPats  ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  rule #match( { A:RhoKVPat  , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPairs ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  rule #match( { A:RhoKVPat  , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPats  ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  rule #match( { A:RhoKVPat  , B:RhoKVPats  } ; { C:RhoKVPat  , D:RhoKVPats  ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  rule #match( { A:RhoKVPair , B:RhoKVPats  } ; { C:RhoKVPat  , D:RhoKVPats  ... E:ProcVar } ) => #match(A;C) andBool #match({B};{D...E})
  // KVPairs/Pats
  rule #match( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPats  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPairs ) => #match(A;C) andBool #match(B;D)
  rule #match( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPats  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:RhoKVPat  , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPairs ) => #match(A;C) andBool #match(B;D)
  rule #match( A:RhoKVPat  , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPats  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:RhoKVPat  , B:RhoKVPats  ; C:RhoKVPat  , D:RhoKVPats  ) => #match(A;C) andBool #match(B;D)

  // Set Pattern
  rule #match( Set( A:Procs    ) ; Set( B:ProcPats ) ) => #matchif(A;B)
  rule #match( Set( A:ProcPats ) ; Set( B:ProcPats ) ) => #matchif(A;B)
  rule #match( Set( A:Proc , _:Procs ) ; Set( C:Proc                 ... _:ProcVar ) ) => #match(A;C)
  rule #match( Set( A:Proc , _:Procs ) ; Set( C:ProcPat              ... _:ProcVar ) ) => #match(A;C)
  rule #match( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:Procs    ... E:ProcVar ) ) => #match(A;C) andBool #match(Set(B);Set(D...E))
  rule #match( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:ProcPats ... E:ProcVar ) ) => #match(A;C) andBool #match(Set(B);Set(D...E))
  rule #match( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:Procs    ... E:ProcVar ) ) => #match(A;C) andBool #match(Set(B);Set(D...E))
  rule #match( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:ProcPats ... E:ProcVar ) ) => #match(A;C) andBool #match(Set(B);Set(D...E))
//  rule #match( A:RhoSet ; B:RhoSet ) => #includedIn(#procs2set(#rho2procs(A));#procs2set(#rho2procs(B)))
//  rule #match( A:RhoSet ; B:SetPat ) => #includedIn(#procs2set(#rho2procs(A)); #pats2set( #rho2pats(B)))
//  rule #match( A:SetPat ; B:SetPat ) => #includedIn( #pats2set( #rho2pats(A)); #pats2set( #rho2pats(B)))

  // Tuple Pattern
  rule #match( ( A:ProcPats ,) ; ( B:ProcPats ,) ) => #matchif(A;B)

// match ProcPats with ProcPats
  rule #match( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)
// match NamePats with NamePats
  rule #match( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)

//--- Name & NamePat ---
  rule #match( _:Name    ; \_ ) => true
  rule #match( _:NamePat ; \_ ) => true

// MatchBind
  rule #matchBind( A:Send ;; B:AnyBind ) => #matchif(#quotes(#msg(A));#bvar(B))

//--------------------
//--- matchBindSet ---
//--------------------
// matchBindSet -- returns indexedSet of possible matching Bind indices
  rule #matchBindSet( for( A:LbindPats ){ _:ProcPat } ;; for( B:LbindPats ){ _:ProcPat } ) => #matchBindSet(A;;B)
  rule #matchBindSet( for( A:PbindPats ){ _:ProcPat } ;; for( B:PbindPats ){ _:ProcPat } ) => #matchBindSet(A;;B)
  rule #matchBindSet( for( A:RbindPats ){ _:ProcPat } ;; for( B:RbindPats ){ _:ProcPat } ) => #matchBindSet(A;;B)
  rule #matchBindSet( for( A:LbindPats _:Guard ){ _:ProcPat } ;; for( B:LbindPats _:Guard ){ _:ProcPat } ) => #matchBindSet(A;;B)
  rule #matchBindSet( for( A:PbindPats _:Guard ){ _:ProcPat } ;; for( B:PbindPats _:Guard ){ _:ProcPat } ) => #matchBindSet(A;;B)
  rule #matchBindSet( for( A:RbindPats _:Guard ){ _:ProcPat } ;; for( B:RbindPats _:Guard ){ _:ProcPat } ) => #matchBindSet(A;;B)

  // matching LbindPat[s] with LbindPat[s]
    // if Binds match, add appropriate pair of indices to the set
  rule #matchBindSet( A:LbindPat ;; B:LbindPat ;; I:Int ; J:Int ) // A is Ith bind in first receive, B is Jth bind in second receive
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J))
       #else SetItem(I;.Set) #fi
  rule #matchBindSet( A:LbindPat ;; B:LbindPat & C:LbindPat  ;; I:Int ; J:Int )
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J)) #matchBindSet(A;;C;;I;J +Int 1)
       #else #matchBindSet(A;;C;;I;J +Int 1) #fi
  rule #matchBindSet( A:LbindPat ;; B:LbindPat & C:LbindPats ;; I:Int ; J:Int )
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J)) #matchBindSet(A;;C;;I;J +Int 1)
       #else #matchBindSet(A;;C;;I;J +Int 1) #fi
    // recurse over 2nd arg Binds, keeping track of positions
  rule #matchBindSet( A:LbindPat ;; B:LbindPat  ;; I:Int ; J:Int ; 0 ) => #matchBindSet(A;;B;;I;J)
  rule #matchBindSet( A:LbindPat ;; B:LbindPat & C:LbindPat  ;; I:Int ; J:Int ; 0 )
    => #unionMBS(#matchBindSet(A;;B;;I;J);#matchBindSet(A;;C;;I;J +Int 1;0))
  rule #matchBindSet( A:LbindPat ;; B:LbindPat & C:LbindPats ;; I:Int ; J:Int ; 0 )
    => #unionMBS(#matchBindSet(A;;B;;I;J);#matchBindSet(A;;C;;I;J +Int 1;0))
    // initialize -- start matching at 0th bind in each receive
  rule #matchBindSet( A:LbindPat & B:LbindPat  ;; C:LbindPats ) => #matchBindSet(A;;C;;0;0;0) #matchBindSet(B;;C;;1;0;0)
  rule #matchBindSet( A:LbindPat & B:LbindPats ;; C:LbindPats ) => #matchBindSet(A;;C;;0;0;0) #matchBindSet(B;;C;;1;0;0)
  rule #matchBindSet( A:LbindPat & B:LbindPat  ;; C:LbindPats ;; I:Int ; 0 ; 0 ) => #matchBindSet(A;;C;;I;0;0) #matchBindSet(B;;C;;I +Int 1;0;0)
  rule #matchBindSet( A:LbindPat & B:LbindPats ;; C:LbindPats ;; I:Int ; 0 ; 0 ) => #matchBindSet(A;;C;;I;0;0) #matchBindSet(B;;C;;I +Int 1;0;0)

  // matching PbindPat[s] with PbindPat[s]
  rule #matchBindSet( A:PbindPat ;; B:PbindPat ;; I:Int ; J:Int ) // A is Ith bind in first receive, B is Jth bind in second receive
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J))
       #else SetItem(I;.Set) #fi
  rule #matchBindSet( A:PbindPat ;; B:PbindPat & C:PbindPat  ;; I:Int ; J:Int )
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J)) #matchBindSet(A;;C;;I;J +Int 1)
       #else #matchBindSet(A;;C;;I;J +Int 1) #fi
  rule #matchBindSet( A:PbindPat ;; B:PbindPat & C:PbindPats ;; I:Int ; J:Int )
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J)) #matchBindSet(A;;C;;I;J +Int 1)
       #else #matchBindSet(A;;C;;I;J +Int 1) #fi
  rule #matchBindSet( A:PbindPat ;; B:PbindPat  ;; I:Int ; J:Int ; 0 ) => #matchBindSet(A;;B;;I;J)
  rule #matchBindSet( A:PbindPat ;; B:PbindPat & C:PbindPat  ;; I:Int ; J:Int ; 0 )
    => #unionMBS(#matchBindSet(A;;B;;I;J);#matchBindSet(A;;C;;I;J +Int 1;0))
  rule #matchBindSet( A:PbindPat ;; B:PbindPat & C:PbindPats ;; I:Int ; J:Int ; 0 )
    => #unionMBS(#matchBindSet(A;;B;;I;J);#matchBindSet(A;;C;;I;J +Int 1;0))
    // initializing
  rule #matchBindSet( A:PbindPat & B:PbindPat  ;; C:PbindPats ) => #matchBindSet(A;;C;;0;0;0) #matchBindSet(B;;C;;1;0;0)
  rule #matchBindSet( A:PbindPat & B:PbindPats ;; C:PbindPats ) => #matchBindSet(A;;C;;0;0;0) #matchBindSet(B;;C;;1;0;0)
  rule #matchBindSet( A:PbindPat & B:PbindPat  ;; C:PbindPats ;; I:Int ; 0 ; 0 ) => #matchBindSet(A;;C;;I;0;0) #matchBindSet(B;;C;;I +Int 1;0;0)
  rule #matchBindSet( A:PbindPat & B:PbindPats ;; C:PbindPats ;; I:Int ; 0 ; 0 ) => #matchBindSet(A;;C;;I;0;0) #matchBindSet(B;;C;;I +Int 1;0;0)

  // matching RbindPat[s] with RbindPat[s]
  rule #matchBindSet( A:RbindPat ;; B:RbindPat ;; I:Int ; J:Int ) // A is Ith bind in first receive, B is Jth bind in second receive
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J))
       #else SetItem(I;.Set) #fi
  rule #matchBindSet( A:RbindPat ;; B:RbindPat & C:RbindPat  ;; I:Int ; J:Int )
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J)) #matchBindSet(A;;C;;I;J +Int 1)
       #else #matchBindSet(A;;C;;I;J +Int 1) #fi
  rule #matchBindSet( A:RbindPat ;; B:RbindPat & C:RbindPats ;; I:Int ; J:Int )
    => #if #matchif(A;B)
       #then SetItem(I;SetItem(J)) #matchBindSet(A;;C;;I;J +Int 1)
       #else #matchBindSet(A;;C;;I;J +Int 1) #fi
  rule #matchBindSet( A:RbindPat ;; B:RbindPat  ;; I:Int ; J:Int ; 0 ) => #matchBindSet(A;;B;;I;J)
  rule #matchBindSet( A:RbindPat ;; B:RbindPat & C:RbindPat  ;; I:Int ; J:Int ; 0 )
    => #unionMBS(#matchBindSet(A;;B;;I;J);#matchBindSet(A;;C;;I;J +Int 1;0))
  rule #matchBindSet( A:RbindPat ;; B:RbindPat & C:RbindPats ;; I:Int ; J:Int ; 0 )
    => #unionMBS(#matchBindSet(A;;B;;I;J);#matchBindSet(A;;C;;I;J +Int 1;0))
    // initializing
  rule #matchBindSet( A:RbindPat & B:RbindPat  ;; C:RbindPats ) => #matchBindSet(A;;C;;0;0;0) #matchBindSet(B;;C;;1;0;0)
  rule #matchBindSet( A:RbindPat & B:RbindPats ;; C:RbindPats ) => #matchBindSet(A;;C;;0;0;0) #matchBindSet(B;;C;;1;0;0)
  rule #matchBindSet( A:RbindPat & B:RbindPat  ;; C:RbindPats ;; I:Int ; 0 ; 0 ) => #matchBindSet(A;;C;;I;0;0) #matchBindSet(B;;C;;I +Int 1;0;0)
  rule #matchBindSet( A:RbindPat & B:RbindPats ;; C:RbindPats ;; I:Int ; 0 ; 0 ) => #matchBindSet(A;;C;;I;0;0) #matchBindSet(B;;C;;I +Int 1;0;0)

// Binds Matching Set union
  rule #unionMBS( S:Set ;  .Set ) => S
  rule #unionMBS(  .Set ; S:Set ) => S
  // if indices match, union inside
  rule #unionMBS( SetItem( I:Int ; A:Set ) ; SetItem( I ; C:Set ) ) => SetItem(I;A C)
  // if indices do not match, union outside
  rule #unionMBS( SetItem( I:Int ; A:Set ) ; SetItem( J:Int ; C:Set ) D:Set ) => SetItem(I;A) SetItem(J;C) D requires I =/=Int J

// Check #matchBindSet -- checks that each candidate bind matches a to-be-matched bind
  rule #checkMBS( .Set ) => true
  rule #checkMBS( SetItem( _:Int ; A:Set ) B:Set ) => #if A =/=K .Set #then #checkMBS(B) #else false #fi

// Check #matchBindSet -- checks that each to-be-matched bind is matched by a candidate bind
  // initialize
  rule #checkMBS+( A:Set ) => #checkMBS+(A;.Set;size(A))
  // union indexed sets and compare size with original
  rule #checkMBS+( SetItem( _:Int ; A:Set ) B:Set ; C:Set ; I:Int ) => #checkMBS+(B;A C;I)
  rule #checkMBS+( .Set ; A:Set ; I:Int ) => size(A) ==Int I

//------------------
//--- #includedIn --
//------------------
  // left arg empty
  rule #includedIn(  .Map ; _:Map ) => true
  rule #includedIn(  .Set ; _:Set ) => true
  // right arg empty
  rule #includedIn( A:Map ;  .Map ) => false requires A =/=K .Map
  rule #includedIn( A:Set ;  .Set ) => false requires A =/=K .Set

  // #includedIn( {e} S:Set ; T:Set ) => #includedIn({e};T) and #includedIn(S;T) & #includedIn( A|->B S:Map ; T:Map ) => #includedIn(A|->B;T) and #includedIn(S;T)
  // each element of the left arg must be contained in the right arg
  // and-branch over all left arg elements:
  rule #includedIn( A:ProcPat |-> B:ProcPat M:Map ; N:Map )
    => #includedIn(A|->B;N) andBool #includedIn(M;N)
       requires M =/=K .Map andBool N =/=K .Map

  rule #includedIn( SetItem( A:ProcPat ) S:Set ; T:Set )
    => #includedIn(SetItem(A);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set
  rule #includedIn( SetItem( I:Int ; A:ProcPat ) S:Set ; T:Set )
    => #includedIn(SetItem(I;A);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set

  // #includedIn( {e} ; {e'} T:Set ) => #includedIn({e};{e'}) or #includedIn({e};T) & #includedIn( A|->B ; C|->D N:Map ) => #includedIn(A|->B;C|->D) or #includedIn(A|->B;N)
  // left arg set element is included in right arg if there's at least one matching right arg element
  // or-brach over right arg elements:
  rule #includedIn( A:ProcPat |-> B:ProcPat ; C:ProcPat |-> D:ProcPat N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map

  rule #includedIn( SetItem( A:ProcPat ) ; SetItem( B:ProcPat ) T:Set )
    => #includedIn(SetItem(A);SetItem(B)) orBool #includedIn(SetItem(A);T)
       requires T =/=K .Set
  rule #includedIn( SetItem( I:Int ; A:ProcPat ) ; SetItem( J:Int ; B:ProcPat ) T:Set )
    => #includedIn(SetItem(I;A);SetItem(J;B)) orBool #includedIn(SetItem(I;A);T)
       requires T =/=K .Set

  // #includedIn( {I;A} ; {J;B} ) => #match(A;B) and I <= J & #includedIn( A|->B ; C|->D ) => #match(A;C) and #match(B;D)
  // element inclusion -- matching and fewer occurrences in the left arg element
  rule #includedIn( A:ProcPat |-> B:ProcPat  ; C:ProcPat |-> D:ProcPat  ) => #match(A;C) andBool #match(B;D)

  rule #includedIn( SetItem( A:ProcPat ) ; SetItem( B:ProcPat ) ) => #match(A;B)
  rule #includedIn( SetItem( I:Int ; A:ProcPat ) ; SetItem( J:Int ; B:ProcPat ) ) => I <=Int J andBool #match(A;B)

  // nonPar Proc
  rule #countProc( A:Proc ; B:Proc ) => #if #match(A;B) #then 1 #else 0 #fi requires notBool isPar(B)
//  rule #countProc( A:Proc    ; B:ProcPat ) => #if #match(A;B) #then 1 #else 0 #fi requires notBool isPar(A)
//  rule #countProc( A:ProcPat ; B:ProcPat ) => #if #match(A;B) #then 1 #else 0 #fi requires notBool isParPat(A)
  // multiple Proc Par
  rule #countProc( A:Proc ; B:Proc | C:Proc )
    => #if #match(A;B) #then 1 +Int #countProc(A;C) #else #countProc(A;C) #fi requires notBool isPar(B)
// TODO: #countProc(Proc;ParPat)
// TODO: #countProc(ProcPat;ParPat)

  // single Proc Par i.e. a nonPar Proc
  rule #removeProc( A:Proc ; B:Proc ) => #if #match(A;B) #then Nil #else B #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #removeProc( A:Proc ; B:Proc | C:Proc ) => #if #match(A;B) #then #removeProc(A;C) #else B | #removeProc(A;C) #fi
       requires notBool isPar(B)

  rule #par2set(   Nil  ) => .Set
  rule #par2set( A:Proc ) => SetItem(A,1) requires notBool (isPar(A) orBool A ==K Nil)
  rule #par2set( A:Proc | B:Proc )
    => #if #countProc(A;B) >Int 0
       #then SetItem(A, 1 +Int #countProc(A;B)) #par2set(#removeProc(A;B))
       #else SetItem(A,1) #par2set(B)
       #fi requires notBool isPar(A)

// Typed Names & Procs
//  rule #sub( A:Name ;   B:Var   :: C:Name    ; D:Var  )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Name ;   B:Var   :: C:NamePat ; D:Var  )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Name ; (@B:PVar) :: C:Name    ; D:Var  )
//    => #sub(A;@B;D) requires #match(A;C)
//  rule #sub( A:Name ; (@B:PVar) :: C:NamePat ; D:Var  )
//    => #sub(A;@B;D) requires #match(A;C)
//  rule #sub( A:Proc ;   B:PVar  :: C:Proc    ; D:Var  )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Proc ;   B:PVar  :: C:ProcPat ; D:Var  )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Proc ; (*B:Var)  :: C:Proc    ; D:Var  )
//    => #sub(A;*B;D) requires #match(A;C)
//  rule #sub( A:Proc ; (*B:Var)  :: C:ProcPat ; D:Var  )
//    => #sub(A;*B;D) requires #match(A;C)
//  rule #sub( A:Name ;   B:Var   :: C:Name    ; D:PVar )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Name ;   B:Var   :: C:NamePat ; D:PVar )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Name ; (@B:PVar) :: C:Name    ; D:PVar )
//    => #sub(A;@B;D) requires #match(A;C)
//  rule #sub( A:Name ; (@B:PVar) :: C:NamePat ; D:PVar )
//    => #sub(A;@B;D) requires #match(A;C)
//  rule #sub( A:Proc ;   B:PVar  :: C:Proc    ; D:PVar )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Proc ;   B:PVar  :: C:ProcPat ; D:PVar )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Proc ; (*B:Var)     :: C:Proc    ; D:PVar )
//    => #sub(A;*B;D) requires #match(A;C)
//  rule #sub( A:Proc ; (*B:Var)     :: C:ProcPat ; D:PVar )
//    => #sub(A;*B;D) requires #match(A;C)

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

endmodule
