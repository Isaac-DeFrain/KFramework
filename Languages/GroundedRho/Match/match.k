// Pattern Matching (Structural Type Inclusion) Predicate for Rholang
  // In general, structural types must be the same for match to be successful
  // except in the case of variables, i.e. any Proc matches a ProcVar, etc.

/*
  How to turn chanRelSet into predicate:
  #makePred(Set(i;Set(m,n,...))) => #match(#chan(A;m);#sub(#chan(A;i);#chan(B;i);#chan(B;m))) andBool #makePred(Set(i;n,...))
*/

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
                  | "#matchif+(" ProcPat ";" Proc     ")" [function]
                  | "#matchif+(" Proc    ";" ProcPat  ")" [function]
                  | "#matchif+(" ProcPat ";" ProcPat  ")" [function]

// Binds
  syntax   Bool ::=   "#match(" Lbind ";" Lbind ")" [function]
                  |   "#match(" Pbind ";" Pbind ")" [function]
                  |   "#match(" Rbind ";" Rbind ")" [function]
                  | "#matchif(" Bind  ";" Bind  ")" [function]

  syntax   Bool ::=   "#match(" Lbinds ";" Lbinds ")" [function]
                  |   "#match(" Pbinds ";" Pbinds ")" [function]
                  |   "#match(" Rbinds ";" Rbinds ")" [function]
                  | "#matchif(" Binds  ";" Binds  ")" [function]

// subexpressions
  syntax   Bool ::=    "#match(" InterpMaps ";" InterpMaps ")" [function]
                  |    "#match(" RhoKVPairs ";" RhoKVPairs ")" [function]
                  |  "#matchif(" RhoKVPairs ";" RhoKVPairs ")" [function]
                  | "#matchif+(" ConcatList ";" ConcatList ")" [function]
                  | "#matchif+(" ConcatStr  ";" ConcatStr  ")" [function]
                  | "#matchif+(" InterpMaps ";" InterpMaps ")" [function]

  syntax   Bool ::= "#matchBind(" Send ";;" AnyBind ")" [function]

  syntax   Bool ::= "#includedIn(" Map  ";" Map  ")" [function]

// Matching Par
  syntax   Bool ::= "#includedIn(" Set  ";" Set  ")" [function]
  syntax   Proc ::= "#removeProc(" Proc ";" Proc ")" [function]
  syntax    Int ::=  "#countProc(" Proc ";" Proc ")" [function]
  syntax    Set ::=    "#par2set(" Proc ")"          [function]

  syntax  KItem ::= Name | Names | NamePat | NamePats
                  | Proc | Procs | ProcPat | ProcPats

endmodule

module MATCH
  import MATCH-SYNTAX
  import ALPHA
  import AUXFUN
  import SUB

  syntax KResult ::= Bool | Int | Proc | Set

// #matchif
  rule #matchif( A:Names      ; B:Names      ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Names      ; B:NamePats   ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:NamePats   ; B:Names      ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:NamePats   ; B:NamePats   ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Procs      ; B:Procs      ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Procs      ; B:ProcPats   ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:ProcPats   ; B:Procs      ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:ProcPats   ; B:ProcPats   ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:RhoKVPairs ; B:RhoKVPairs ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Lbinds     ; B:Lbinds     ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Pbinds     ; B:Pbinds     ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Rbinds     ; B:Rbinds     ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( _:Lbinds     ; B:Binds      ) => false requires notBool isLbinds(B)
  rule #matchif( _:Pbinds     ; B:Binds      ) => false requires notBool isPbinds(B)
  rule #matchif( _:Rbinds     ; B:Binds      ) => false requires notBool isRbinds(B)
  rule #matchif( _:Lbind      ; B:Bind       ) => false requires notBool isLbind(B)
  rule #matchif( _:Pbind      ; B:Bind       ) => false requires notBool isPbind(B)
  rule #matchif( _:Rbind      ; B:Bind       ) => false requires notBool isRbind(B)
  rule #matchif( A:Lbind      ; B:Lbind      ) => #length(#bvar(A)) ==Int #length(#bvar(B)) andBool #match(A;B)
  rule #matchif( A:Pbind      ; B:Pbind      ) => #length(#bvar(A)) ==Int #length(#bvar(B)) andBool #match(A;B)
  rule #matchif( A:Rbind      ; B:Rbind      ) => #length(#bvar(A)) ==Int #length(#bvar(B)) andBool #match(A;B)

//----------------------------
//--- Name & Proc Matching ---
//----------------------------
// Name matching
  rule #match( A:Name  ;  A      ) => true // any Name matches itself
  rule #match( _:Name  ;  _:Var  ) => true // any Name matches a Var
  rule #match( A:Name  ; @B:Proc ) => #match(*A;B)
  rule #match( @EmptyP ;  EmptyN ) => true // empty send/empty listen matching
  rule #match(  EmptyN ; @EmptyP ) => true // empty send/empty listen matching

  rule #match(  boundN( I:Int ) ;  boundN( J:Int ) ) => I ==Int J
  rule #match(  boundN( I:Int ) ; @boundP( J:Int ) ) => I ==Int J
  rule #match( @boundP( I:Int ) ;  boundN( J:Int ) ) => I ==Int J

// Proc matching
  rule #match( A:Proc  ; A         ) => true // every Proc matches itself
  rule #match( _:Proc  ; _:ProcVar ) => true // every Proc matches a ProcVar
  rule #match( A:Proc  ; *B:Name   ) => #match(@A;B)
  rule #match(  EmptyP ; *EmptyN   ) => true // empty send/empty listen matching
  rule #match( *EmptyN ;  EmptyP   ) => true // empty send/empty listen matching

  rule #match(  boundP( I:Int ) ;  boundP( J:Int ) ) => I ==Int J
  rule #match(  boundP( I:Int ) ; *boundN( J:Int ) ) => I ==Int J
  rule #match( *boundN( I:Int ) ;  boundP( J:Int ) ) => I ==Int J

  // the only Ground a Ground matches is itself
  // Ground ::= "Nil" | Bool | Int | String | Unforgeable | Uri
  rule #match( A:Ground ; B:Ground ) => A ==K B
  rule #match( A:Ground ; B:Proc   ) => false
       requires notBool (isGround(B) orBool isProcVar(B) orBool isEval(B))
  rule #match( A:Proc   ; B:Ground ) => false requires notBool isGround(A)

  // Eval matches Eval
  rule #match( *A:Name ; *B:Name ) => #match(A;B) // underlying Names must match
  rule #match(  _:Eval ;  A:Proc ) => false
       requires notBool (isProcVar(A) orBool isEval(A) orBool isNameRef(A))

  // Send matching
  // Send matches Send (if channels, type, and messages match), but only Send matches Send
  rule #match( A:Name !  (         ) ; C:Name !  (         ) ) => #match(A;C)
  rule #match( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! (         ) ; C:Name !! (         ) ) => #match(A;C)
  rule #match( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #match(A;C) andBool #matchif(B;D)
    // message length or send type mismatch
  rule #match( _:Send ; _:Send ) => false [owise]
    // type mismatch
  rule #match( _:ConSend   ; A:Proc      ) => false
       requires notBool (isProcVar(A) orBool isEval(A) orBool isConSend(A))
  rule #match( A:Proc      ; _:ConSend   ) => false requires notBool isConSend(A)
  rule #match( _:UnconSend ; A:Proc      ) => false
       requires notBool (isProcVar(A) orBool isEval(A) orBool isUnconSend(A))
  rule #match( A:Proc      ; _:UnconSend ) => false
       requires notBool isUnconSend(A)

  // Receive matching
  // Receive matches Receive (if channels, listening variable length, and appropriately
  // substituted continuations match), but only Receive matches Receive
    // Binds -- corresponding listening variables and channels match
  rule #match( A:Lbind ; B:Lbind ) => #match(#chan(A);#chan(B)) andBool #match(#bvar(A);#bvar(B))
  rule #match( A:Pbind ; B:Pbind ) => #match(#chan(A);#chan(B)) andBool #match(#bvar(A);#bvar(B))
  rule #match( A:Rbind ; B:Rbind ) => #match(#chan(A);#chan(B)) andBool #match(#bvar(A);#bvar(B))

  // TODO: order should not matter
  rule #match( A:Lbinds ; B:Lbinds ) => #match(#chan(A);#chan(B)) andBool #matchif(#bvar(A);#bvar(B))
  rule #match( A:Pbinds ; B:Pbinds ) => #match(#chan(A);#chan(B)) andBool #matchif(#bvar(A);#bvar(B))
  rule #match( A:Rbinds ; B:Rbinds ) => #match(#chan(A);#chan(B)) andBool #matchif(#bvar(A);#bvar(B))

    // UGSRec
    // match bind and DeBruijnified substituted continuation
  rule #match( A:UGSRec ; B:UGSRec ) => #matchif(#bind(A);#bind(B)) andBool
       #match(#sub(#mapify(#bvar(A));#cont(A));#sub(#mapify(#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))
  rule #match( _:UGSRec ; A:Proc ) => false
       requires notBool (isUGSRec(A) orBool isProcVar(A) orBool isEval(A))
  rule #match( A:Proc ; _:UGSRec ) => false requires notBool isUGSRec(A)

    // GSRec
    // match bind, guard, and DeBruijnified substituted continuation
  rule #match( A:GSRec ; B:GSRec ) => #matchif(#bind(A);#bind(B)) andBool
       #match(#sub(#mapify(#bvar(A));#guard(A));#sub(#mapify(#bvar(A));#sub(#bvar(A);#bvar(B);#guard(B)))) andBool
       #match(#sub(#mapify(#bvar(A));#cont(A));#sub(#mapify(#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))
  rule #match( _:GSRec ; A:Proc ) => false
       requires notBool (isGSRec(A) orBool isProcVar(A) orBool isEval(A))
  rule #match( A:Proc ; _:GSRec ) => false requires notBool isGSRec(A)

    // UGMRec
    // match binds and DeBruijnified "appropriately" substituted continuations
  rule #match( A:UGMRec ; B:UGMRec ) => #matchif(#bind(A);#bind(B)) andBool
       #match(#sub(#mapify(#bvar(A));#cont(A));#sub(#mapify(#bvar(A));#sub(#bvar(A);#bvar(B);#cont(B))))
  rule #match( _:UGMRec ; A:Proc   ) => false
       requires notBool (isUGMRec(A) orBool isProcVar(A) orBool isEval(A))
  rule #match( A:Proc   ; _:UGMRec ) => false requires notBool isUGMRec(A)

  // Guarded
    // GSRec
  rule #match( for( A:Lbind if B:BExp ){ C:Proc } ; for( D:Lbind if E:BExp ){ F:Proc } )
    => #match(for(A){C};for(D){F}) andBool #match(B;E)
  rule #match( for( A:Pbind if B:BExp ){ C:Proc } ; for( D:Pbind if E:BExp ){ F:Proc } )
    => #match(for(A){C};for(D){F}) andBool #match(B;E)
  rule #match( for( A:Rbind if B:BExp ){ C:Proc } ; for( D:Rbind if E:BExp ){ F:Proc } )
    => #match(for(A){C};for(D){F}) andBool #match(B;E)

  rule #match( _:GSRec ; A:Proc ) => false
       requires notBool (isGSRec(A) orBool isProcVar(A) orBool isEval(A))
  rule #match( A:Proc ; _:GSRec ) => false requires notBool isGSRec(A)

    // GMRec
  rule #match( _:GMRec ; A:Proc ) => false
       requires notBool (isGMRec(A) orBool isProcVar(A) orBool isEval(A))
  rule #match( A:Proc ; _:GMRec ) => false requires notBool isGMRec(A)

// VarRef
  rule #match( A:Proc    ; _:NameRef ) => false
       requires notBool (isNameRef(A) orBool isEval(A))
  rule #match( _:NameRef ;   A:Proc  ) => false
       requires notBool (isNameRef(A) orBool isEval(A) orBool isProcVar(A))
  rule #match(  *A:Var   ; =*B:Var   ) => A ==K B  // only *x & =*x match =*x
  rule #match( =*A:Var   ; =*B:Var   ) => A ==K B

  rule #match( A:Proc    ; _:ProcRef ) => false
       requires notBool (isProcRef(A) orBool isProcVar(A))
  rule #match( _:ProcRef ;   A:Proc  ) => false
       requires notBool (isProcRef(A) orBool isEval(A) orBool isProcVar(A))
  rule #match(  \A:Var   ; =\B:Var   ) => A ==K B // only \x matches =\x
  rule #match( =\A:Var   ; =\B:Var   ) => A ==K B

// Par match - apply after normalization
  // works for A/\Par and A/\(~Par/\Proc)
  // Par should only match Par[Pat] with matching terms of same length after normalization
    // check Par lengths
  rule #matchif+( A:Proc    ; B:Proc    ) => #parlength(A) ==Int #parlength(B)
  rule #matchif+( A:ProcPat ; B:Proc    ) => #parlength(A) ==Int #parlength(B)
  rule #matchif+( A:Proc    ; B:ProcPat ) => #parlength(A) ==Int #parlength(B)
  rule #matchif+( A:ProcPat ; B:ProcPat ) => #parlength(A) ==Int #parlength(B)

  rule #match( A:Proc ; B:Par  ) => false requires notBool isPar(A)
  rule #match( A:Par  ; B:Proc ) => false requires notBool isPar(B)
  rule #match( A:Par  ; B:Par  ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))

// Collection matching - empty structures are accomodated by the first rule
  // RhoList matches RhoList (if underlying Procs match), nothing else matches RhoList
  rule #match( A:RhoList   ; _:EmptyList ) => false requires notBool isEmptyList(A)
  rule #match( _:EmptyList ; A:RhoList   ) => false requires notBool isEmptyList(A)
  rule #match( [ A:Procs ] ; [ B:Procs ] ) => #matchif(A;B)
  rule #match( A:Proc ; _:RhoList ) => false requires notBool isRhoList(A)
  rule #match( _:RhoList ; A:Proc ) => false
       requires notBool (isRhoList(A) orBool isProcVar(A)
         orBool isEval(A) orBool isPar(A))

  // RhoMaps & RhoSets are unordered -> assume canonical ordering
  // RhoMap matches RhoMap (if underlying Procs match), nothing else matches RhoMap
  rule #match( A:RhoMap   ; _:EmptyMap ) => false requires notBool isEmptyMap(A)
  rule #match( _:EmptyMap ; A:RhoMap   ) => false requires notBool isEmptyMap(A)
  rule #match( A:RhoMap   ; B:RhoMap   ) => #includedIn(#KVs2map(#rho2KVs(A));#KVs2map(#rho2KVs(B)))
       requires notBool (isEmptyMap(A) orBool isEmptyMap(B))
  rule #match( A:RhoMap   ; B:MapPat   ) => #includedIn(#KVs2map(#rho2KVs(A));#KVs2map(#rho2KVs(B)))
  rule #match( A:MapPat   ; B:MapPat   ) => #includedIn(#KVs2map(#rho2KVs(A));#KVs2map(#rho2KVs(B)))

  rule #match( A:Proc : B:Proc ; C:Proc : D:Proc   ) => #match(A;C) andBool #match(B;D)
  rule #match( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs )
    => #match(A;C) andBool #match(B;D)

  // RhoSet matches RhoSet (if underlying Procs match)
  rule #match( Set( A:Procs ) ; Set( B:Procs ) ) => #includedIn(#procs2set(A);#procs2set(B))
  rule #match( A:Proc ; _:RhoSet ) => false requires notBool isRhoSet(A)
  rule #match( _:RhoSet ; A:Proc ) => false
       requires notBool (isRhoSet(A) orBool isEval(A)
         orBool isProcVar(A) orBool isPar(A))

  // RhoTuple matches RhoTuple (if underlying Procs match)
  rule #match( ( A:Procs ,) ; ( B:Procs ,) ) => #matchif(A;B)
  rule #match( A:Proc ; _:RhoTuple ) => false requires notBool isRhoTuple(A)
  rule #match( _:RhoTuple ; A:Proc ) => false
       requires notBool (isRhoTuple(A) orBool isProcVar(A)
         orBool isEval(A) orBool isPar(A))

  // several Procs matching -- used in many other contexts
  rule #match( A:Proc , B:Procs ; C:Proc , D:Procs )
    => #match(A;C) andBool #match(B;D)

// New matching
  // New matches New (if same "effective" number of Names declared and DeBruijnified Procs match)
  // nothing else matches New
  rule #match( new A:VarDecs in { P:Proc } ; new B:VarDecs in { Q:Proc } )
    => size(#DV(A)) ==Int size(#DV(B)) andBool #match(#subNew(0;#DV(A);P);#subNew(0;#DV(B);Q))
  rule #match( _:New  ; A:Proc ) => false
       requires notBool (isNew(A) orBool isEval(A) orBool isPar(A)
         orBool isProcVar(A))
  rule #match( A:Proc ; _:New  ) => false requires notBool isNew(A)

// Arithmetic Exps matching
  // AExp matches AExp with matching subexpressions, nothing else matches AExp
  rule #match( - A:AExp ; - B:AExp ) => #match(A;B)
  rule #match( A:AExp * B:AExp ; C:AExp * D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp / B:AExp ; C:AExp / D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp + B:AExp ; C:AExp + D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp - B:AExp ; C:AExp - D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp % B:AExp ; C:AExp % D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp ; B:Proc ) => false
       requires notBool (isIntOrVar(A) orBool (isPar(B) andBool isAExp(B)))
  rule #match( A:Proc ; B:AExp ) => false
       requires notBool (isAExp(A) orBool isIntOrVar(B))

// List & String Exps
  // only Concat matches Concat
  rule #match( A:ListOrVar   ++ B:ListOrVar  ; C:ListOrVar ++ D:ListOrVar  )
    => #match(A;C) andBool #match(B;D)
  rule #match( A:ListOrVar   ++ B:ConcatList ; C:ListOrVar ++ D:ConcatList )
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
       requires notBool (isListOrVar(A) orBool (isPar(B) andBool isListExp(B)))
  rule #match( A:Proc      ; B:ListExp   ) => false
       requires notBool (isListExp(A) orBool isListOrVar(B))
  rule #match( A:StringExp ; B:Proc      ) => false
       requires notBool (isStringOrVar(A) orBool (isPar(B) andBool isStringExp(B)))
  rule #match( A:Proc      ; B:StringExp ) => false
       requires notBool (isStringExp(A) orBool isStringOrVar(B))

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
  rule #match( A:Proc matches B:Proc    ; C:Proc matches D:Proc    ) => (#match(A;C) andBool #match(B;D)) orBool (#match(A;D) andBool #match(B;C))
  rule #match( A:Proc matches B:Proc    ; C:Proc matches D:ProcPat ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc matches B:ProcPat ; C:Proc matches D:ProcPat ) => #match(A;C) andBool #match(B;D)
  rule #match( A:BExp ; B:Proc ) => false
       requires notBool (isBoolOrVar(A) orBool (isPar(B) andBool isBExp(B)))
  rule #match( A:Proc ; B:BExp ) => false
       requires notBool (isBExp(A) orBool isBoolOrVar(B))

// only Par matches Par
// every Proc matches ProcVar, but ProcVar only matches ProcVar
// Method matches same Method (if Proc and arguments match), nothing else matches Method?
//  rule #match( A:Proc . B:Method ( C:ProcPats )
//             ; D:Proc . E:Method ( F:ProcPats ) )
//    => #match(A;D) andBool B ==K E andBool #matchif(C;F)
//  rule #match( A:Proc . B:Method ( C:Procs    )
//             ; D:Proc . E:Method ( F:ProcPats ) )
//    => #match(A;D) andBool B ==K E andBool #matchif(C;F)
  rule #match( A:Proc . B:Method ( C:Procs    )
             ; D:Proc . E:Method ( F:Procs    ) )
    => #match(A;D) andBool B ==K E andBool #matchif(C;F)
  rule #match( A:Proc . B:Method (            )
             ; D:Proc . E:Method (            ) )
    => #match(A;D) andBool B ==K E
  rule #match( _:MethodProc ; _:MethodProc ) => false [owise]
  rule #match( A:Proc       ; _:MethodProc ) => false
       requires notBool isMethodProc(A)
  rule #match( _:MethodProc ; A:Proc       ) => false
       requires notBool (isMethodProc(A) orBool isProcVar(A)
         orBool isEval(A) orBool isPar(A))

// TODO
// Match matching?
// Contract matches Contract like Receive, nothing else matches Contract
// Invocation matches Invocation like Contract, nothing else matches Invocation
// Bundle matches Bundle (if sign & underlying Procs match), nothing else matches Bundle
// Conditional matches Conditional (if underlying BExp and Procs match), nothing else matches Conditional

// several Names
  rule #match( A:Name , B:Names ; C:Name , D:Names ) => #match(A;C) andBool #match(B;D)

//------------------------
//--- Pattern Matching ---
//------------------------
// TODO: assess neccessity of patterns matching patterns
// Patterns cannot match concrete Proc(s) or Name(s)
  rule #match(  A:ProcPat ; _:Proc  ) => false
       requires notBool (isPatExp(A) orBool isEvalPat(A) orBool isParPat(A))

  rule #match( @A:ProcPat ; B:Name  ) => false
       requires notBool (isPatExp(A) orBool isEvalPat(A)
         orBool isParPat(A) orBool isQuote(B))

// Pattern variables -- every name/proc/pattern matches any PatVar
  rule #match( _:ProcPat ; _:PatVar ) => true
  rule #match( _:NamePat ; _:PatVar ) => true
  rule #match( _:Proc    ; _:PatVar ) => true
  rule #match( _:Name    ; _:PatVar ) => true

// Every pattern matches itself
  rule #match( A:ProcPat ; A ) => true
  rule #match( A:NamePat ; A ) => true

// TODO: #match( A:Proc ; Null ) => #structEq(A;Nil)

// Name pattern
  // every Name matches WildCard
  rule #match(  _:Name ; \_ ) => true
  rule #match( \_  ; _:Name ) => false
  rule #match( @A:Proc ; @B:ProcPat ) => #match(A;B)
  // every NamePat matches WildCard
  rule #match(  _:NamePat ; \_ ) => true
  rule #match( @A:ProcPat ; @B:ProcPat ) => #match(A;B)

// Process pattern
  // every Proc matches WildCard
  rule #match(  _:Proc ; \_ ) => true
  rule #match( \_  ; _:Proc ) => false
  rule #match( *A:Name ; *B:NamePat ) => #match(A;B)
  // every ProcPat matches WildCard
  rule #match(  _:ProcPat ; \_ ) => true
  rule #match( *A:NamePat ; *B:NamePat ) => #match(A;B)

// Simpe patterns
  rule #match( _:Bool        ; B:SimplePat ) => B ==K Bool
  rule #match( _:Int         ; B:SimplePat ) => B ==K Int
  rule #match( _:String      ; B:SimplePat ) => B ==K String
  rule #match( _:RhoList     ; B:SimplePat ) => B ==K List
  rule #match( _:RhoMap      ; B:SimplePat ) => B ==K Map
  rule #match( _:RhoSet      ; B:SimplePat ) => B ==K Set
  rule #match( _:RhoTuple    ; B:SimplePat ) => B ==K Tuple
  rule #match( _:Unforgeable ; B:SimplePat ) => B ==K Unforgeable
  rule #match( _:Uri         ; B:SimplePat ) => B ==K Uri
  rule #match( A:Proc        ; ClosedProc  ) => #FV(A) ==K .Set
  rule #match( A:Name        ; ClosedName  ) => #FV(A) ==K .Set
//  rule #match( A:ProcPat   ; ClosedProcPat ) => A ==K ClosedProcPat
//  rule #match( A:NamePat   ; ClosedNamePat ) => A ==K ClosedNamePat
//  rule #match( A:SimplePat ; B:SimplePat ) => A ==K B
// TODO: contexts
  rule #match( _:ListPat   ; List  ) => true
  rule #match( _:TuplePat  ; Tuple ) => true
  rule #match( A:SimplePat ; B:SimplePat ) => A ==K B
  rule #match( A:ProcPat   ; _:SimplePat ) => false
       requires notBool (isSimplePat(A) orBool isCollectionPat(A)
         orBool isPatExp(A) orBool isParPat(A))
  rule #match( A:NamePat   ; ClosedName  ) => A ==K ClosedName

  rule #match( A:Proc    ; _EmptyList ) => isEmptyList(A)
  rule #match( A:ProcPat ; _EmptyList ) => A ==K _EmptyList
  rule #match( A:Proc    ; _EmptyMap  ) =>  isEmptyMap(A)
  rule #match( A:ProcPat ; _EmptyMap  ) => A ==K _EmptyMap
  rule #match( A:Proc    ; _EmptySet  ) =>  isEmptySet(A)
  rule #match( A:ProcPat ; _EmptySet  ) => A ==K _EmptySet

// Pattern expressions
  // match PatExp with Proc
  rule #match(   A:Proc /\ _:SimplePat  ; B:Proc ) => #match( A;B)
  rule #match( @{A:Proc /\ _:SimplePat} ; B:Name ) => #match(@A;B)

  // match Proc[Pat] with PatExp
  // Negation
  rule #match( A:ProcPat   ; ~ \_ ) => false requires notBool A ==K ~\_
  rule #match( A:Proc      ; ~ B:Proc    ) => notBool #match(A;B)
  rule #match( A:Proc      ; ~ B:ProcPat ) => notBool #match(A;B)
       requires notBool isWildCard(B)
  rule #match( A:SimplePat ; ~ B:Proc    ) => notBool #match(B;A)
  rule #match( A:SimplePat ; ~ B:ProcPat ) => notBool #match(B;A)
       requires notBool isWildCard(B)
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
  rule #match(  A:Proc      /\ B:SimplePat ; C:ProcPat ) => #match(A;C) orBool #match(B;C)
  rule #match(  A:SimplePat /\ B:Proc      ; C:ProcPat ) => #match(A;C) orBool #match(B;C)

  rule #match(  A:Proc  \/ B:Proc ; C:ProcPat ) => #match(A;C) andBool #match(A;B)


// ParPat -- TODO: pat2set???
//  rule #match( A:Proc    ; B:ParPat  ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:Par     ; B:ProcPat ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:ProcPat ; B:Par     ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:ParPat  ; B:Proc    ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:ProcPat ; B:ParPat  ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))
//  rule #match( A:ParPat  ; B:ProcPat ) => #matchif+(A;B) andBool #includedIn(#par2set(A);#par2set(B))

//  rule #match( _:Par    ; A:ProcPat ) => false requires notBool (isParPat(A) orBool isWildCard(A))
//  rule #match( _:ParPat ; A:ProcPat ) => false requires notBool (isParPat(A) orBool isWildCard(A)) // ParPat only matches ParPat or WildCard

// RecPat
//  rule #match( for( A:Lbind ){ P:ProcPat } ; for( B:Lbind ){ Q:ProcPat } ) => ???

// SendPat
  // Consumable
    // match Send with SendPat
      // Send = Name!( )
//  rule #match( _:Name ! ( ) ; _:CSendPat ) => false [owise]
  rule #match( A:Name ! ( ) ; C:NamePat ! ( ) ) => #match(A;C)
      // Send = Name!(Procs)
//  rule #match( _:Name ! ( _:Procs ) ; _:CSendPat ) => false [owise]
  rule #match( A:Name ! ( B:Procs ) ; C:NamePat ! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name ! ( B:Procs ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name ! ( B:Procs ) ; C:Name    ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // Send = Name!(ProcPats)
//  rule #match( _:Name ! ( _:ProcPats ) ; _:CSendPat ) => false [owise]
  rule #match( A:Name ! ( B:ProcPats ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name ! ( B:ProcPats ) ; C:Name    ! ( D:ProcPats ) ) => #match(A;C) andBool #match(B;D)
    // SendPat = NamePat!( )
//  rule #match( _:NamePat ! (  ) ; _:CSendPat ) => false [owise]
  rule #match( A:NamePat ! (  ) ; C:NamePat ! (  ) ) => #match(A;C)
    // SendPat = NamePat!(Procs)
//  rule #match( _:NamePat ! ( _:Procs ) ; _:CSendPat ) => false [owise]
  rule #match( A:NamePat ! ( B:Procs ) ; C:NamePat ! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:NamePat ! ( B:Procs ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // SendPat = NamePat!(ProcPats)
//  rule #match( _:NamePat ! ( _:ProcPats ) ; _:CSendPat ) => false [owise]
  rule #match( A:NamePat ! ( B:ProcPats ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)

  rule #match( A:Send     ; _:CSendPat ) => false [owise]
  rule #match( A:Proc     ; _:CSendPat ) => false requires notBool     (isSend(A) orBool isPar(A))
  rule #match( A:ProcPat  ; _:CSendPat ) => false requires notBool (isCSendPat(A) orBool isParPat(A))
  rule #match( _:ConSend  ; A:ProcPat  ) => false requires notBool (isCSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))
  rule #match( _:CSendPat ; A:ProcPat  ) => false requires notBool (isCSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))

  // Unconsumable
    // Send = Name!!( )
//  rule #match( _:Name !! (  ) ; _:USendPat ) => false [owise]
  rule #match( A:Name !! (  ) ; C:NamePat !! (  ) ) => #match(A;C)
    // Send = Name!!(Procs)
//  rule #match( _:Name !! ( _:Procs ) ; _:USendPat ) => false
  rule #match( A:Name !! ( B:Procs ) ; C:NamePat !! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:Name    !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // SendPat = NamePat!!( )
  rule #match( A:NamePat !! (      ) ; C:NamePat !! (            ) ) => #match(A;C)
//rule #match( _:NamePat !! (      ) ; _:SendPat ) => false [owise]
    // Send = NamePat!!(Procs)
  rule #match( A:NamePat !! ( B:Procs ) ; C:NamePat !! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:NamePat !! ( B:Procs ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
//  rule #match( _:NamePat !! ( _:Procs ) ; _:SendPat ) => false [owise]
    // Send = NamePat!!(ProcPats)
  rule #match( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
//  rule #match( _:NamePat !! ( _:ProcPats ) ; _:SendPat ) => false [owise]

  rule #match( _:Send ; _:USendPat ) => false [owise]
  rule #match( A:Proc      ; _:USendPat ) => false requires notBool      (isSend(A) orBool isPar(A))
  rule #match( A:ProcPat   ; _:USendPat ) => false requires notBool  (isUSendPat(A) orBool isParPat(A))
  rule #match( _:UnconSend ; A:ProcPat  ) => false requires notBool  (isUSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))
  rule #match( _:USendPat  ; A:ProcPat  ) => false requires notBool  (isUSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))

// EvalPat
  rule #match( *A:Name    ; *B:NamePat ) => #match(A;B)
  rule #match( *A:NamePat ; *B:NamePat ) => #match(A;B)

  rule #match(  A:Proc    ;  _:EvalPat ) => false requires notBool isEval(A)
  rule #match(  A:ProcPat ;  _:EvalPat ) => false requires notBool isEvalPat(A)
  rule #match(  _:Eval    ;  A:ProcPat ) => false
       requires notBool (isEvalPat(A) orBool isWildCard(A)
         orBool isParPat(A) orBool isPatExp(A))
  rule #match(  _:EvalPat ;  A:ProcPat ) => false
       requires notBool (isEvalPat(A) orBool isWildCard(A)
         orBool isParPat(A) orBool isPatExp(A))

// NewPat
  rule #match( new A:VarDecs in { P:Proc    } ; new B:VarDecs in { Q:ProcPat } )
    => size(#DV(A)) ==Int size(#DV(B)) andBool #match(#subNew(0;#DV(A);P);#subNew(0;#DV(B);Q))
  rule #match( new A:VarDecs in { P:ProcPat } ; new B:VarDecs in { Q:ProcPat } )
    => size(#DV(A)) ==Int size(#DV(B)) andBool #match(#subNew(0;#DV(A);P);#subNew(0;#DV(B);Q))
  // declaration length/type mismatch
  rule #match( _:Proc    ; _:NewPat ) => false [owise]
  rule #match( _:ProcPat ; _:NewPat ) => false [owise]

// CollectionPat
  // List Pattern
  rule #match( [ A:Procs    ] ; [ B:ProcPats ] ) => #matchif(A;B)
  rule #match( [ A:ProcPats ] ; [ B:ProcPats ] ) => #matchif(A;B)

  // Map Pattern

  // Set Pattern
  rule #match( A:RhoSet ; B:RhoSet ) => #includedIn(#procs2set(#rho2procs(A));#procs2set(#rho2procs(B)))
  rule #match( A:RhoSet ; B:SetPat ) => #includedIn(#procs2set(#rho2procs(A)); #pats2set( #rho2pats(B)))
  rule #match( A:SetPat ; B:SetPat ) => #includedIn( #pats2set( #rho2pats(A)); #pats2set( #rho2pats(B)))

  // Tuple Pattern
  rule #match( ( A:Procs    ,) ; ( B:ProcPats ,) ) => #matchif(A;B)
  rule #match( ( A:ProcPats ,) ; ( B:ProcPats ,) ) => #matchif(A;B)

// match Proc[Pat]s with ProcPats
  rule #match( A:Proc    , B:Procs    ; C:ProcPat , D:Procs    ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc    , B:Procs    ; C:Proc    , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc    , B:Procs    ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:Procs    ; C:ProcPat , D:Procs    ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:Procs    ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc    , B:ProcPats ; C:Proc    , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc    , B:ProcPats ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:Procs    ; C:Proc    , D:ProcPats ) => false
  rule #match( A:Proc    , B:ProcPats ; C:ProcPat , D:Procs    ) => false
  rule #match( A:ProcPat , B:ProcPats ; C:ProcPat , D:Procs    ) => false
  rule #match( A:ProcPat , B:ProcPats ; C:Proc    , D:ProcPats ) => false

//--- Name & NamePat ---
  rule #match( _:Name    ; \_ ) => true
  rule #match( _:NamePat ; \_ ) => true

// match Name[Pat]s with NamePats
  rule #match( A:Name    , B:Names    ; C:NamePat , D:Names    ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name    , B:Names    ; C:Name    , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name    , B:Names    ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:Names    ; C:NamePat , D:Names    ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:Names    ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name    , B:NamePats ; C:Name    , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name    , B:NamePats ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:Names    ; C:Name    , D:NamePats ) => false
  rule #match( A:Name    , B:NamePats ; C:NamePat , D:Names    ) => false
  rule #match( A:NamePat , B:NamePats ; C:NamePat , D:Names    ) => false
  rule #match( A:NamePat , B:NamePats ; C:Name    , D:NamePats ) => false

// MatchBind
  rule #matchBind( A:Send ;; B:AnyBind ) => #matchif(#quotes(#msg(A));#bvar(B))

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
  rule #includedIn( A:Proc |-> B:Proc M:Map ; N:Map )
    => #includedIn(A|->B;N) andBool #includedIn(M;N)
       requires M =/=K .Map andBool N =/=K .Map
  rule #includedIn( A:Proc |-> B:ProcPat M:Map ; N:Map )
    => #includedIn(A|->B;N) andBool #includedIn(M;N)
       requires M =/=K .Map andBool N =/=K .Map
  rule #includedIn( A:ProcPat |-> B:Proc M:Map ; N:Map )
    => #includedIn(A|->B;N) andBool #includedIn(M;N)
       requires M =/=K .Map andBool N =/=K .Map
  rule #includedIn( A:ProcPat |-> B:ProcPat M:Map ; N:Map )
    => #includedIn(A|->B;N) andBool #includedIn(M;N)
       requires M =/=K .Map andBool N =/=K .Map

  rule #includedIn( SetItem( A:Proc ) S:Set ; T:Set )
    => #includedIn(SetItem(A);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set
  rule #includedIn( SetItem( A:Proc , I:Int ) S:Set ; T:Set )
    => #includedIn(SetItem(A,I);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set
  rule #includedIn( SetItem( A:Proc , I:Int ) S:Set ; T:Set )
    => #includedIn(SetItem(A,I);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set
  rule #includedIn( SetItem( A:ProcPat , I:Int ) S:Set ; T:Set )
    => #includedIn(SetItem(A,I);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set

  // #includedIn( {e} ; {e'} T:Set ) => #includedIn({e};{e'}) or #includedIn({e};T) & #includedIn( A|->B ; C|->D N:Map ) => #includedIn(A|->B;C|->D) or #includedIn(A|->B;N)
  // left arg set element is included in right arg if there's at least one matching right arg element
  // or-brach over right arg elements:
  rule #includedIn(    A:Proc |-> B:Proc    ; C:Proc    |-> D:Proc    N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map
  rule #includedIn(    A:Proc |-> B:Proc    ; C:Proc    |-> D:ProcPat N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map
  rule #includedIn(    A:Proc |-> B:Proc    ; C:ProcPat |-> D:Proc    N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map
  rule #includedIn(    A:Proc |-> B:Proc    ; C:ProcPat |-> D:ProcPat N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map
  rule #includedIn(    A:Proc |-> B:ProcPat ; C:Proc    |-> D:ProcPat N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map
  rule #includedIn(    A:Proc |-> B:ProcPat ; C:ProcPat |-> D:ProcPat N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map
  rule #includedIn( A:ProcPat |-> B:Proc    ; C:ProcPat |-> D:Proc    N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map
  rule #includedIn( A:ProcPat |-> B:Proc    ; C:ProcPat |-> D:ProcPat N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map
  rule #includedIn( A:ProcPat |-> B:ProcPat ; C:ProcPat |-> D:ProcPat N:Map )
    => #includedIn(A|->B;C|->D) andBool #includedIn(A|->B;N)
       requires N =/=K .Map

  rule #includedIn( SetItem( A:Proc ) ; SetItem( B:Proc ) T:Set )
    => #includedIn(SetItem(A);SetItem(B)) orBool #includedIn(SetItem(A);T)
       requires T =/=K .Set
  rule #includedIn( SetItem( A:Proc , I:Int ) ; SetItem( B:Proc , J:Int ) T:Set )
    => #includedIn(SetItem(A,I);SetItem(B,J)) orBool #includedIn(SetItem(A,I);T)
       requires T =/=K .Set
  rule #includedIn( SetItem( A:Proc , I:Int ) ; SetItem( B:ProcPat , J:Int ) T:Set )
    => #includedIn(SetItem(A,I);SetItem(B,J)) orBool #includedIn(SetItem(A,I);T)
       requires T =/=K .Set
  rule #includedIn( SetItem( A:ProcPat , I:Int ) ; SetItem( B:ProcPat , J:Int ) T:Set )
    => #includedIn(SetItem(A,I);SetItem(B,J)) orBool #includedIn(SetItem(A,I);T)
       requires T =/=K .Set

  // #includedIn( {A,I} ; {B,J} ) => #match(A;B) and I <= J & #includedIn( A|->B ; C|->D ) => #match(A;C) and #match(B;D)
  // element inclusion -- matching and fewer occurrences in the left arg element
  rule #includedIn( A:Proc    |-> B:Proc     ; C:Proc    |-> D:Proc     ) => #match(A;C) andBool #match(B;D)
  rule #includedIn( A:Proc    |-> B:Proc     ; C:Proc    |-> D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #includedIn( A:Proc    |-> B:Proc     ; C:ProcPat |-> D:Proc     ) => #match(A;C) andBool #match(B;D)
  rule #includedIn( A:Proc    |-> B:Proc     ; C:ProcPat |-> D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #includedIn( A:Proc    |-> B:ProcPat  ; C:Proc    |-> D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #includedIn( A:Proc    |-> B:ProcPat  ; C:ProcPat |-> D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #includedIn( A:ProcPat |-> B:Proc     ; C:ProcPat |-> D:Proc     ) => #match(A;C) andBool #match(B;D)
  rule #includedIn( A:ProcPat |-> B:Proc     ; C:ProcPat |-> D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #includedIn( A:ProcPat |-> B:ProcPat  ; C:ProcPat |-> D:ProcPat  ) => #match(A;C) andBool #match(B;D)

  rule #includedIn( SetItem( A:Proc ) ; SetItem( B:Proc ) ) => #match(A;B)
  rule #includedIn( SetItem( A:Proc    , I:Int ) ; SetItem( B:Proc    , J:Int ) )
    => I <=Int J andBool #match(A;B)
  rule #includedIn( SetItem( A:Proc    , I:Int ) ; SetItem( B:ProcPat , J:Int ) ) => I <=Int J andBool #match(A;B)
  rule #includedIn( SetItem( A:ProcPat , I:Int ) ; SetItem( B:ProcPat , J:Int ) ) => I <=Int J andBool #match(A;B)

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
//  rule #sub( A:Name ;   B:Var      :: C:ProcPat ; D:Var )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Name ; (@B:ProcVar) :: C:ProcPat ; D:Var )
//    => #sub(A;@B;D) requires #match(A;C)
//  rule #sub( A:Proc ;   B:ProcVar  :: C:ProcPat ; D:ProcVar )
//    => #sub(A;B;D) requires #match(A;@C)
//  rule #sub( A:Proc ; (*B:Var)     :: C:ProcPat ; D:ProcVar )
//    => #sub(A;*B;D) requires #match(A;C)

// Nil unit of |
  rule Nil       | P:Proc    => P  [anywhere, structural]
  rule Nil       | P:ProcPat => P  [anywhere, structural]
  rule P:Proc    | Nil       => P  [anywhere, structural]
  rule P:ProcPat | Nil       => P  [anywhere, structural]
// @* = Id_Name & *@ = Id_Proc
  rule   @ * N:Name    => N  [anywhere, structural]
  rule   @ * N:NamePat => N  [anywhere, structural]
  rule   * @ P:Proc    => P  [anywhere, structural]
  rule   * @ P:ProcPat => P  [anywhere, structural]
// ~~ = Id_ProcPat
  rule ~ ~ P:Proc    => P [anywhere, structural]
  rule ~ ~ P:ProcPat => P [anywhere, structural]

endmodule
