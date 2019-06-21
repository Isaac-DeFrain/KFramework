// Preliminary Pattern-Matching Predicate for Rholang
  // Types must be the same for match to be successful
  // Lengths are checked only once

require "domains.k"
require "../AlphaEquiv/alpha.k"
require "../AuxFun/auxfun.k"
require "../grho.k"
require "../Substitute/sub.k"

module MATCH-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// #match predicate checks that the terms match
// Name & Proc
  syntax   Bool ::=   "#match(" Proc  ";" Proc  ")" [function]
                  |   "#match(" Name  ";" Name  ")" [function]
                  |   "#match(" Procs ";" Procs ")" [function]
                  |   "#match(" Names ";" Names ")" [function]
                  | "#matchif(" Procs ";" Procs ")" [function]
                  | "#matchif(" Names ";" Names ")" [function]

// subexpressions
  syntax   Bool ::= "#match(" ConcatExp  ";" ConcatExp  ")" [function]
                  | "#match(" InterpMaps ";" InterpMaps ")" [function]
                  | "#match(" RhoKVPair  ";" RhoKVPair  ")" [function]
                  | "#match(" RhoKVPairs ";" RhoKVPairs ")" [function]

// Patterns
  syntax   Bool ::=   "#match(" ProcPats ";" Procs    ")" [function]
                  |   "#match(" Procs    ";" ProcPats ")" [function]
                  |   "#match(" ProcPats ";" ProcPats ")" [function]
                  |   "#match(" ProcPat  ";" Proc     ")" [function]
                  |   "#match(" Proc     ";" ProcPat  ")" [function]
                  |   "#match(" ProcPat  ";" ProcPat  ")" [function]
                  |   "#match(" NamePats ";" Names    ")" [function]
                  |   "#match(" Names    ";" NamePats ")" [function]
                  |   "#match(" NamePats ";" NamePats ")" [function]
                  |   "#match(" NamePat  ";" Name     ")" [function]
                  |   "#match(" Name     ";" NamePat  ")" [function]
                  |   "#match(" NamePat  ";" NamePat  ")" [function]
                  | "#matchif(" Procs    ";" ProcPats ")" [function]
                  | "#matchif(" ProcPats ";" Procs    ")" [function]
                  | "#matchif(" ProcPats ";" ProcPats ")" [function]
                  | "#matchif(" Names    ";" NamePats ")" [function]
                  | "#matchif(" NamePats ";" Names    ")" [function]
                  | "#matchif(" NamePats ";" NamePats ")" [function]

// Matching Par
  syntax   Bool ::= "#includedIn(" Set  ";" Set  ")" [function]
  syntax   Proc ::= "#removeProc(" Proc ";" Proc ")" [function]
  syntax    Int ::=  "#countProc(" Proc ";" Proc ")" [function]
  syntax    Set ::=    "#par2set(" Proc ")" [function]


endmodule

module MATCH
  import MATCH-SYNTAX
  import ALPHA
  import AUXFUN
  import SUB

  syntax KResult ::= Bool | Set

// #matchif
  rule #matchif( A:Names    ; B:Names    ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Names    ; B:NamePats ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:NamePats ; B:NamePats ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Procs    ; B:Procs    ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:Procs    ; B:ProcPats ) => #length(A) ==Int #length(B) andBool #match(A;B)
  rule #matchif( A:ProcPats ; B:ProcPats ) => #length(A) ==Int #length(B) andBool #match(A;B)

// Name matching
  rule #match( A:Name    ;  A ) => true // any Name matches itself
  rule #match( _:Name    ;  _:NameVar ) => true // any Name matches a NameVar
  rule #match( _:Name    ; @_:ProcVar ) => true // any Name matches a @ProcVar
  rule #match( _:NameVar ;  B:Name    ) => true requires isNameVar(B) // NameVar can only match a NameVar...
  rule #match( @EmptyP   ;  EmptyN    ) => true // empty send/empty listen matching

// Process matching
  rule #match( A:Proc    ;  A ) => true // any Proc matches itself
  rule #match( _:Proc    ;  _:ProcVar ) => true // any Proc matches a ProcVar
  rule #match( _:Proc    ; *_:NameVar ) => true // any Proc matches a *NameVar
  rule #match( _:ProcVar ;  B:Proc    ) => true requires isProcVar(B) // ProcVar can only match a ProcVar

// same is true of WildCard

  // Ground only matches itself
  rule #match( A:Ground ; B:Ground ) => A ==K B

  // ProcVar only matches ProcVar or *NameVar or Par
  rule #match( _:ProcVar ; B:Proc ) => false requires notBool (isProcVar(B) orBool isEval(B) orBool isPar(B))

  // Eval matches Eval
  rule #match( *A:Name ; *B:Name ) => #match(A;B) // underlying Names must match
  rule #match(  _:Eval ;  A:Proc ) => false requires notBool (isProcVar(A) orBool isEval(A) orBool isPar(A))
  rule #match(  A:Proc ; *B:Name ) => false requires notBool (isNameVar(B) orBool isEval(A))

  // Send matching
  rule #match( A:Name !  (         ) ; C:Name !  (         ) ) => #match(A;C)
  rule #match( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! (         ) ; C:Name !! (         ) ) => #match(A;C)
  rule #match( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #match(A;C) andBool #matchif(B;D)
    // message length mismatch
  rule #match( _:Send ; _:Send ) => false [owise]
    // type mismatch
  rule #match( _:ConSend   ; A:Proc      ) => false requires notBool  (isProcVar(A) orBool isEval(A) orBool isPar(A) orBool isConSend(A))
  rule #match( A:Proc      ; _:ConSend   ) => false requires notBool  (isConSend(A) orBool isPar(A))
  rule #match( _:UnconSend ; A:Proc      ) => false requires notBool  (isProcVar(A) orBool isEval(A) orBool isPar(A) orBool isUnconSend(A))
  rule #match( A:Proc      ; _:UnconSend ) => false requires notBool (isUnconSend(A) orBool isPar(A))

  // Receive matching
    // SRec
  rule #match( for(            <- A:Name ){ B:Proc } ; for(            <- C:Name ){ D:Proc } ) =>   #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name     <- A:Name ){ B:Proc } ; for( Y:Name     <- C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:Names    <- A:Name ){ B:Proc } ; for( Y:Names    <- C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:NamePat  <- A:Name ){ B:Proc } ; for( Y:NamePat  <- C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:NamePats <- A:Name ){ B:Proc } ; for( Y:NamePats <- C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))

  rule #match( for(            <= A:Name ){ B:Proc } ; for(            <= C:Name ){ D:Proc } ) =>   #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name     <= A:Name ){ B:Proc } ; for( Y:Name     <= C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:Names    <= A:Name ){ B:Proc } ; for( Y:Names    <= C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:NamePat  <= A:Name ){ B:Proc } ; for( Y:NamePat  <= C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:NamePats <= A:Name ){ B:Proc } ; for( Y:NamePats <= C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))

  rule #match( for(            <! A:Name ){ B:Proc } ; for(            <! C:Name ){ D:Proc } ) =>   #match(A;C) andBool #match(B;D)
  rule #match( for( X:Name     <! A:Name ){ B:Proc } ; for( Y:Name     <! C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:Names    <! A:Name ){ B:Proc } ; for( Y:Names    <! C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:NamePat  <! A:Name ){ B:Proc } ; for( Y:NamePat  <! C:Name ){ D:Proc } ) =>   #match(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))
  rule #match( for( X:NamePats <! A:Name ){ B:Proc } ; for( Y:NamePats <! C:Name ){ D:Proc } ) => #matchif(X;Y) andBool #match(A;C) andBool #match(B;#sub(X;Y;D))

  rule #match( _:Receive ; A:Proc ) => false requires notBool (isReceive(A) orBool isProcVar(A) orBool isPar(A))
  rule #match( A:Proc ; _:Receive ) => false requires notBool (isReceive(A) orBool isPar(A))

  // MRec -- TODO


// Par match - apply after normalization
//old: rule #match( A:Proc | B:Proc ; C:Proc | D:Proc ) => #match(A;C) andBool #match(B;D) requires notBool (isPar(A) orBool isPar(C))
  // works for A/\Par and A/\(~Par/\Proc)
  rule #match( A:Proc ; B:Par  ) => #includedIn(#par2set(A);#par2set(B))
  rule #match( _:Par  ; A:Proc ) => false requires notBool (isPar(A) orBool isProcVar(A) orBool isEval(A))

// Collection matching - empty structures are accomodated by the first rule
  // RhoList matches RhoList (if underlying Procs match), nothing else matches RhoList
  rule #match( [ A:Proc  ] ; [ B:Proc  ] ) => #match(A;B)
  rule #match( [ A:Procs ] ; [ B:Procs ] ) => #matchif(A;B)
  rule #match( A:Proc ; _:RhoList ) => false requires notBool (isRhoList(A) orBool isPar(A))
  rule #match( _:RhoList ; A:Proc ) => false requires notBool (isRhoList(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))

  // RhoMaps & RhoSets are unordered -> assume canonical ordering
  // RhoMap matches RhoMap (if underlying Procs match), nothing else matches RhoMap
  // TODO: define for KV pairs?
  rule #match( { A:Proc : B:Proc } ; { C:Proc : D:Proc } ) => #match(A;C) andBool #match(B;D)
  // order of KVPairs should not matter!!!
  rule #match( { A:RhoKVPair , B:RhoKVPair  } ; { C:RhoKVPair , D:RhoKVPair  } ) => #match(A;C) andBool #match(B;D)
  rule #match( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs } ) => #match(A;C) andBool #match(B;D) // #matchif (need to count KVPairs)

  // RhoSet matches RhoSet (if underlying Procs match), nothing else matches RhoSet
  rule #match( Set( A:Proc  ) ; Set( B:Proc  ) ) => #match(A;B)
  rule #match( Set( A:Procs ) ; Set( B:Procs ) ) => #matchif(A;B) // order should not matter!!!
  rule #match( A:Proc ; _:RhoSet ) => false requires notBool (isRhoSet(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))
  rule #match( _:RhoSet ; A:Proc ) => false requires notBool (isRhoSet(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))

  // RhoTuple matches RhoTuple (if underlying Procs match), nothing else matches RhoTuple
  rule #match( ( A:Proc  ,) ; ( B:Proc  ,) ) => #match(A;B)
  rule #match( ( A:Procs ,) ; ( B:Procs ,) ) => #matchif(A;B)
  rule #match( A:Proc ; _:RhoTuple ) => false requires notBool (isRhoTuple(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))
  rule #match( _:RhoTuple ; A:Proc ) => false requires notBool (isRhoTuple(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))

  // several Procs matching -- used in many other contexts
  rule #match( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Procs ; C:Proc , D:Procs ) => #match(A;C) andBool #matchif(B;D)

// New matching
  // New matches New (if same number of Names declared and Procs match), nothing else matches New
  rule #match( new A:Name  in { P:Proc } ; new B:Name  in { Q:Proc } ) => #match(P;#sub(A;B;Q))
  rule #match( new A:Names in { P:Proc } ; new B:Names in { Q:Proc } ) => #match(P;#sub(A;B;Q))
  rule #match( _:New ; A:Proc ) => false requires notBool (isNew(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))
  rule #match( A:Proc ; _:New ) => false requires notBool (isNew(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))

// Arithmetic Exps matching
  // AExp matches AExp with matching subexpressions, nothing else matches AExp
  rule #match( - A:AExp ; - B:AExp ) => #match(A;B)
  rule #match( A:AExp *  B:AExp ; C:AExp *  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp /  B:AExp ; C:AExp /  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp +  B:AExp ; C:AExp +  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp -  B:AExp ; C:AExp -  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( A:AExp %  B:AExp ; C:AExp %  D:AExp ) => #match(A;C) andBool #match(B;D)
  rule #match( _:AExp ; A:Proc ) => false requires notBool (isAExp(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))
  rule #match( A:Proc ; _:AExp ) => false requires notBool (isAExp(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))

// String Exps
  // only Concat matches Concat
  rule #match( A:StringOrVar B:ConcatExp ; C:StringOrVar D:ConcatExp ) => #match(A;C) andBool #match(B;D) // length ???
  rule #match( ++ A:StringOrVar ; ++ B:StringOrVar ) => #match(A;B)
//  rule #matchif( ++ A:StringOrVar B:ConcatExp ; ++ C:StringOrVar D:ConcatExp  ) => #length(B) ==Int #length(D) andBool #match(A;C) andBool #match(B;D)
  // only Interp matches Interp
  rule #match( A:StringOrVar %% B:InterpMaps ; C:StringOrVar %% D:InterpMaps ) => #match(A;C) andBool #match(B;D) // length ???
  rule #match( A:RhoMap %% B:InterpMaps ; C:RhoMap %% D:InterpMaps ) => #match(A;C) andBool #match(B;D) // length ??
  // only StringExp matches StringExp
  rule #match( _:StringExp ; A:Proc      ) => false requires notBool (isStringExp(A) orBool isPar(A))
  rule #match( A:Proc      ; _:StringExp ) => false requires notBool (isStringExp(A) orBool isPar(A))

// Boolean Exps matching
  // BExp matches BExp with matching subexpressions, nothing else matches BExp
  rule #match( not A:BExp ; not B:BExp ) => #match(A;B)
  rule #match( A:BExp and B:BExp ; C:BExp and D:BExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:BExp or  B:BExp ; C:BExp or  D:BExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:AExp <=  B:AExp ; C:AExp <=  D:AExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:AExp <   B:AExp ; C:AExp <   D:AExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:AExp >=  B:AExp ; C:AExp >=  D:AExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:AExp >   B:AExp ; C:AExp >   D:AExp ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Proc ==  B:Proc ; C:Proc ==  D:Proc ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Proc !=  B:Proc ; C:Proc !=  D:Proc ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Name ==  B:Name ; C:Name ==  D:Name ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Name !=  B:Name ; C:Name !=  D:Name ) => #match(A;B) andBool #match(C;D)
  rule #match( A:Proc matches B:Proc ; C:Proc matches D:Proc ) => #match(A;B) andBool #match(C;D)
  rule #match( _:BExp ; A:Proc ) => false requires notBool (isBExp(A) orBool isPar(A))
  rule #match( A:Proc ; _:BExp ) => false requires notBool (isBExp(A) orBool isPar(A))

// Every Proc matches Par, ProcVar/*NameVar, and itself
// anything matches Par
// Send matches other Send (if underlying channels and messages match), but only Send matches Send
// Receive matches Receive (if the underlying channels, listening variables, and continuations match?), but only Receive matches Receive
// every Proc matches ProcVar, but ProcVar only matches ProcVar
// VarRef matches any VarRef (because underlying variables match), nothing else matches VarRef? 
// Method matches same Method (if Proc and arguments match), nothing else matches Method?
  rule #match( A:Proc . B:Method ( C:Procs ) ; D:Proc . E:Method ( F:Procs ) ) => #match(A;D) andBool B ==K E andBool #matchif(C;F)
  rule #match( A:Proc . B:Method ( C:Proc  ) ; D:Proc . E:Method ( F:Proc  ) ) => #match(A;D) andBool B ==K E andBool #match(C;F)
  rule #match( A:Proc . B:Method (         ) ; D:Proc . E:Method (         ) ) => #match(A;D) andBool B ==K E
  rule #match( _:MethodProc ; _:MethodProc ) => false [owise]
  rule #match( A:Proc ; _:MethodProc ) => false requires notBool (isMethodProc(A) orBool isPar(A))
  rule #match( _:MethodProc ; A:Proc ) => false requires notBool (isMethodProc(A) orBool isProcVar(A) orBool isEval(A) orBool isPar(A))

// Match matching?
// Contract matches Contract like Receive, nothing else matches Contract
// Invocation matches Invocation like Contract, nothing else matches Invocation
// Bundle matches Bundle (if sign & underlying Procs match), nothing else matches Bundle
// Conditional matches Conditional (if underlying BExp and Procs match), nothing else matches Conditional

//---------------------
//--- Name matching ---
//---------------------

// Primitive matching
  rule #match( A:Name  ;  A ) => true // any Name matches itself
  rule #match( A:Name  ;  B:Name ) => true requires isNameVar(B) // any Name matches a NameVar
  rule #match( A:Name  ; @B:Proc ) => true requires isProcVar(B) // any Name matches a quoted ProcVar
  rule #match( @A:Proc ; @B:Proc ) => #match(A;B) // underlying Procs must match

// NameVar only matches NameVar
  rule #match( _:NameVar ; A:Name  ) => true  requires isNameVar(A)
  rule #match( _:NameVar ; @B:Proc ) => false requires notBool (isProcVar(B) orBool isEval(B) orBool isPar(A))
  rule #match( _:NameVar ; _:Name  ) => false [owise]

// several Names
  rule #match( A:Name , B:Name  ; C:Name , D:Name  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name , B:Names ; C:Name , D:Names ) => #match(A;C) andBool #match(B;D) // length is checked beforehand
  rule #match( _:Name , _:Name  ; _:Name , _:Names ) => false [owise] // two Names can't match more than two
  rule #match( _:Name , _:Names ; _:Name , _:Name  ) => false [owise] // more than two Names can't match two

//------------------------
//--- Pattern Matching ---
//------------------------
// Patterns cannot match concrete Proc(s) or Name(s)
  rule #match( A:ProcPat  ; _:Proc  ) => false requires notBool (isPatExp(A) orBool isParPat(A))
//  rule #match( A:ProcPats ; _:Procs ) => false
  rule #match( @A:ProcPat ; _:Name  ) => false requires notBool (isPatExp(A) orBool isEvalPat(A) orBool isParPat(A))
//  rule #match( A:NamePats ; _:Names ) => false

// Every pattern matches itself
  rule #match( A:ProcPat  ; A ) => true
  rule #match( A:NamePat  ; A ) => true

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

// Simpe pattern
  rule #match( _:Bool        ; B:SimplePat  ) => B ==K Bool
  rule #match( _:Int         ; B:SimplePat  ) => B ==K Int
  rule #match( _:String      ; B:SimplePat  ) => B ==K String
  rule #match( _:RhoList     ; B:SimplePat  ) => B ==K List
  rule #match( _:RhoMap      ; B:SimplePat  ) => B ==K Map
  rule #match( _:RhoSet      ; B:SimplePat  ) => B ==K Set
  rule #match( _:RhoTuple    ; B:SimplePat  ) => B ==K Tuple
  rule #match( _:Unforgeable ; B:SimplePat  ) => B ==K Unforgeable
  rule #match( _:Uri         ; B:SimplePat  ) => B ==K Uri
  rule #match( A:Proc        ; ConcreteProc ) => #FV(A) ==K .Set
  rule #match( A:Name        ; ConcreteName ) => #FV(A) ==K .Set
//  rule #match( A:Proc        ; _:SimplePat  ) => false requires notBool (isGround(A) orBool isCollection(A))
//  rule #match( A:NamePat     ; ConcreteName ) => A ==K ConcreteName
//  rule #match( A:SimplePat   ; B:SimplePat  ) => A ==K B
  rule #match( _:ListPat   ; List  ) => true
  rule #match( _:TuplePat  ; Tuple ) => true
  rule #match( A:SimplePat ; B:SimplePat  ) => A ==K B
  rule #match( A:ProcPat   ; _:SimplePat  ) => false requires notBool (isSimplePat(A) orBool isCollectionPat(A) orBool isPatExp(A) orBool isParPat(A))
  rule #match( A:NamePat   ; ConcreteName ) => A ==K ConcreteName

// #match(Contravariant;Covariant)
// Pattern expression
  // match Proc[Pat] with PatExp
  // Negation
  rule #match( _:Proc    ; ~ \_ ) => false
  rule #match( _:ProcPat ; ~ \_ ) => false
  rule #match( A:Proc    ; ~ B:Proc    ) => notBool #match(A;B)
  rule #match( A:Proc    ; ~ B:ProcPat ) => notBool #match(A;B) requires notBool isWildCard(B)
  rule #match( _:ProcPat ; ~ _:Proc    ) => true
  rule #match( A:ProcPat ; ~ B:ProcPat ) => notBool #match(A;B) requires notBool (isWildCard(B) orBool isPatExp(A))
  // And
  rule #match( A:Proc    ; B:Proc    /\ C:Proc    ) => #match(A;B) andBool #match(A;C)
  rule #match( A:Proc    ; B:Proc    /\ C:ProcPat ) => #match(A;B) andBool #match(A;C)
  rule #match( A:Proc    ; B:ProcPat /\ C:Proc    ) => #match(A;B) andBool #match(A;C)
  rule #match( A:Proc    ; B:ProcPat /\ C:ProcPat ) => #match(A;B) andBool #match(A;C)
  rule #match( A:ProcPat ; B:ProcPat /\ C:ProcPat ) => #match(A;B) andBool #match(A;C) requires notBool isPatExp(A)
  rule #match( _:ProcPat ; _:Proc    /\ _:Proc    ) => false
  rule #match( _:ProcPat ; _:Proc    /\ _:ProcPat ) => false
  rule #match( _:ProcPat ; _:ProcPat /\ _:Proc    ) => false
  // Or -- TODO
//  rule #match( A:Proc    ; B:Proc    \/ C:Proc    ) => #match(A;B) orBool  #match(A;C)
//  rule #match( A:Proc    ; B:Proc    \/ C:ProcPat ) => #match(A;B) orBool  #match(A;C)
//  rule #match( A:Proc    ; B:ProcPat \/ C:Proc    ) => #match(A;B) orBool  #match(A;C)
//  rule #match( A:Proc    ; B:ProcPat \/ C:ProcPat ) => #match(A;B) orBool  #match(A;C)
//  rule #match( A:ProcPat ; B:ProcPat \/ C:ProcPat ) => #match(A;B) orBool  #match(A;C) requires notBool isPatExp(A)
//  rule #match( A:ProcPat ; B:ProcPat \/ _:Proc    ) => #match(A;B) requires notBool isPatExp(A)
//  rule #match( A:ProcPat ; _:Proc    \/ C:ProcPat ) => #match(A;C) requires notBool isPatExp(A)
//  rule #match( _:ProcPat ; _:Proc    \/ _:Proc    ) => false

  // match PatExp with ProcPat -- TODO
//  rule #match( ~ A:Proc    ; ~ B:Proc  ) => #match(B;A)
//  rule #match( ~ A:Proc    ; B:ProcPat ) => false [owise]
//  rule #match( ~ A:ProcPat ; ~ B:ProcPat ) => #match(B;A)
//  rule #match( ~ A:ProcPat ; B:ProcPat \/ C:PatOr ) => #match(B;A)

//  rule #match(  A:Proc    /\ B:Proc    ; C:ProcPat ) => #match(A;B) orBool  #match(A;C)
//  rule #match(  A:Proc    /\ B:ProcPat ; C:ProcPat ) => #match(A;B) orBool  #match(A;C)
//  rule #match(  A:ProcPat /\ B:Proc    ; C:ProcPat ) => #match(A;B) orBool  #match(A;C)
//  rule #match(  A:ProcPat /\ B:ProcPat ; C:ProcPat ) => #match(A;B) orBool  #match(A;C)

  rule #match(  A:Proc    \/ B:Proc    ; C:ProcPat ) => #match(A;B) andBool #match(A;C)
  rule #match(  A:Proc    \/ B:ProcPat ; C:ProcPat ) => #match(A;B) andBool #match(A;C)
  rule #match(  A:ProcPat \/ B:Proc    ; C:ProcPat ) => #match(A;B) andBool #match(A;C)
  rule #match(  A:ProcPat \/ B:ProcPat ; C:ProcPat ) => #match(A;B) andBool #match(A;C)

//#match(A;B) = A <= B
//A \/ B <=Set C

// ParPat
//  rule #match( A:Proc    ; B:Proc    | C:ProcPat ) => #match(A;B) orBool #match(A;C) requires notBool (   isPar(B) orBool isPar(A))
//  rule #match( A:Proc    ; B:ProcPat | C:Proc    ) => #match(A;B) orBool #match(A;C) requires notBool (isParPat(B) orBool isPar(A))
//  rule #match( A:Proc    ; B:ProcPat | C:ProcPat ) => #match(A;B) orBool #match(A;C) requires notBool (isParPat(B) orBool isPar(A))
//  rule #match( A:ProcPat ; _:Proc    | C:ProcPat ) => #match(A;C)
//  rule #match( A:ProcPat ; B:ProcPat | _:Proc    ) => #match(A;B) requires notBool (isParPat(B) orBool isParPat(A))
//  rule #match( A:ProcPat ; B:ProcPat | C:ProcPat ) => #match(A;B) orBool #match(A;C) requires notBool (isParPat(B) orBool isParPat(A))

//  rule #match( _:Par    ; A:ProcPat ) => false requires notBool (isParPat(A) orBool isWildCard(A))
//  rule #match( _:ParPat ; A:ProcPat ) => false requires notBool (isParPat(A) orBool isWildCard(A)) // ParPat only matches ParPat or WildCard

// RecPat
//  rule #match( for(A:Lbind){P:Proc} ; for(B:Lbind){Q:Proc} ) => ???

// SendPat
  // Consumable
    // match Send with SendPat
      // Send = Name!( )
  rule #match( _:Name ! (  ) ; _:CSendPat ) => false [owise]
  rule #match( A:Name ! (  ) ; C:NamePat ! (  ) ) => #match(A;C)
      // Send = Name!(Proc)
  rule #match( _:Name ! ( _:Proc  ) ; _:CSendPat ) => false [owise]
  rule #match( A:Name ! ( B:Proc  ) ; C:NamePat ! ( D:Proc     ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name ! ( B:Proc  ) ; C:NamePat ! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name ! ( B:Proc  ) ; C:Name    ! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
      // Send = Name!(Procs)
  rule #match( _:Name ! ( _:Procs ) ; _:CSendPat ) => false [owise]
  rule #match( A:Name ! ( B:Procs ) ; C:NamePat ! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name ! ( B:Procs ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name ! ( B:Procs ) ; C:Name    ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // Send = Name!(ProcPat)
  rule #match( _:Name ! ( _:ProcPat  ) ; _:CSendPat ) => false [owise]
  rule #match( A:Name ! ( B:ProcPat  ) ; C:NamePat ! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name ! ( B:ProcPat  ) ; C:Name    ! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
    // Send = Name!(ProcPats)
  rule #match( _:Name ! ( _:ProcPats ) ; _:CSendPat ) => false [owise]
  rule #match( A:Name ! ( B:ProcPats ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name ! ( B:ProcPats ) ; C:Name    ! ( D:ProcPats ) ) => #match(A;C) andBool #match(B;D)
    // SendPat = NamePat!( )
  rule #match( _:NamePat ! (  ) ; _:CSendPat ) => false [owise]
  rule #match( A:NamePat ! (  ) ; C:NamePat ! (  ) ) => #match(A;C)
    // SendPat = NamePat!(Proc)
  rule #match( _:NamePat ! ( _:Proc  ) ; _:CSendPat ) => false [owise]
  rule #match( A:NamePat ! ( B:Proc  ) ; C:NamePat ! ( D:Proc     ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat ! ( B:Proc  ) ; C:NamePat ! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
    // SendPat = NamePat!(Procs)
  rule #match( _:NamePat ! ( _:Procs ) ; _:CSendPat ) => false [owise]
  rule #match( A:NamePat ! ( B:Procs ) ; C:NamePat ! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:NamePat ! ( B:Procs ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // SendPat = NamePat!(ProcPat)
  rule #match( _:NamePat ! ( _:ProcPat  ) ; _:CSendPat ) => false [owise]
  rule #match( A:NamePat ! ( B:ProcPat  ) ; C:NamePat ! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
    // SendPat = NamePat!(ProcPats)
  rule #match( _:NamePat ! ( _:ProcPats ) ; _:CSendPat ) => false [owise]
  rule #match( A:NamePat ! ( B:ProcPats ) ; C:NamePat ! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)

  rule #match( A:Proc     ; _:CSendPat ) => false requires notBool  (isConSend(A) orBool isPar(A))
  rule #match( A:ProcPat  ; _:CSendPat ) => false requires notBool (isCSendPat(A) orBool isParPat(A))
  rule #match( _:ConSend  ; A:ProcPat  ) => false requires notBool (isCSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))
  rule #match( _:CSendPat ; A:ProcPat  ) => false requires notBool (isCSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))

  // Unconsumable
    // Send = Name!!( )
  rule #match( _:Name !! (  ) ; _:USendPat ) => false [owise]
  rule #match( A:Name !! (  ) ; C:NamePat !! (  ) ) => #match(A;C)
    // Send = Name!!(Proc)
  rule #match( _:Name !! ( _:Proc  ) ; _:USendPat ) => false [owise]
  rule #match( A:Name !! ( B:Proc  ) ; C:NamePat !! ( D:Proc     ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !! ( B:Proc  ) ; C:NamePat !! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name !! ( B:Proc  ) ; C:Name    !! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
    // Send = Name!!(Procs)
  rule #match( _:Name !! ( _:Procs ) ; _:USendPat ) => false
  rule #match( A:Name !! ( B:Procs ) ; C:NamePat !! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:Name !! ( B:Procs ) ; C:Name    !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
    // SendPat = NamePat!!( )
  rule #match( A:NamePat !! (         ) ; C:NamePat !! (            ) ) => #match(A;C)
  rule #match( _:NamePat !! (         ) ; _:NamePat !! ( _:Proc     ) ) => false
  rule #match( _:NamePat !! (         ) ; _:NamePat !! ( _:Procs    ) ) => false
  rule #match( _:NamePat !! (         ) ; _:NamePat !! ( _:ProcPat  ) ) => false
  rule #match( _:NamePat !! (         ) ; _:NamePat !! ( _:ProcPats ) ) => false
  rule #match( _:NamePat !! (         ) ; _:Name    !! ( _:ProcPat  ) ) => false
  rule #match( _:NamePat !! (         ) ; _:Name    !! ( _:ProcPats ) ) => false
    // SendPat = NamePat!!(Proc)
  rule #match( A:NamePat !! ( B:Proc  ) ; C:NamePat !! ( D:Proc     ) ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat !! ( B:Proc  ) ; C:NamePat !! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( _:NamePat !! ( _:Proc  ) ; _:NamePat !! (            ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:Proc  ) ; _:NamePat !! ( _:Procs    ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:Proc  ) ; _:NamePat !! ( _:ProcPats ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:Proc  ) ; _:Name    !! ( _:ProcPat  ) ) => false // NamePat can't match Name
  rule #match( _:NamePat !! ( _:Proc  ) ; _:Name    !! ( _:ProcPats ) ) => false
    // Send = NamePat!!(Procs)
  rule #match( A:NamePat !! ( B:Procs ) ; C:NamePat !! ( D:Procs    ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( A:NamePat !! ( B:Procs ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( _:NamePat !! ( _:Procs ) ; _:NamePat !! (            ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:Procs ) ; _:NamePat !! ( _:Proc     ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:Procs ) ; _:NamePat !! ( _:ProcPat  ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:Procs ) ; _:Name    !! ( _:ProcPats ) ) => false // NamePat can't match Name
  rule #match( _:NamePat !! ( _:Procs ) ; _:Name    !! ( _:ProcPat  ) ) => false
    // SendPat = NamePat!!(ProcPat)
  rule #match( A:NamePat !! ( B:ProcPat  ) ; C:NamePat !! ( D:ProcPat  ) ) => #match(A;C) andBool #match(B;D)
  rule #match( _:NamePat !! ( _:ProcPat  ) ; _:NamePat !! ( _:Proc     ) ) => false // ProcPat can't match Proc
  rule #match( _:NamePat !! ( _:ProcPat  ) ; _:NamePat !! (            ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:ProcPat  ) ; _:NamePat !! ( _:Procs    ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:ProcPat  ) ; _:NamePat !! ( _:ProcPats ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:ProcPat  ) ; _:Name    !! ( _:ProcPat  ) ) => false // NamePat can't match Name
  rule #match( _:NamePat !! ( _:ProcPat  ) ; _:Name    !! ( _:ProcPats ) ) => false
    // Send = NamePat!!(ProcPats)
  rule #match( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ) => #match(A;C) andBool #matchif(B;D)
  rule #match( _:NamePat !! ( _:ProcPats ) ; _:NamePat !! (            ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:ProcPats ) ; _:NamePat !! ( _:Proc     ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:ProcPats ) ; _:NamePat !! ( _:Procs    ) ) => false // ProcPats can't match Procs
  rule #match( _:NamePat !! ( _:ProcPats ) ; _:NamePat !! ( _:ProcPat  ) ) => false // message length mismatch
  rule #match( _:NamePat !! ( _:ProcPats ) ; _:Name    !! ( _:ProcPats ) ) => false // NamePat can't match Name
  rule #match( _:NamePat !! ( _:ProcPats ) ; _:Name    !! ( _:ProcPat  ) ) => false

  rule #match( A:Proc      ; _:USendPat ) => false requires notBool (isUnconSend(A) orBool isPar(A))
  rule #match( A:ProcPat   ; _:USendPat ) => false requires notBool  (isUSendPat(A) orBool isParPat(A))
  rule #match( _:UnconSend ; A:ProcPat  ) => false requires notBool  (isUSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))
  rule #match( _:USendPat  ; A:ProcPat  ) => false requires notBool  (isUSendPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))

// EvalPat
  rule #match( *A:Name    ; *B:NamePat ) => #match(A;B)
  rule #match( *A:NamePat ; *B:NamePat ) => #match(A;B)

  rule #match(  A:Proc    ;  _:EvalPat ) => false requires notBool (isEval(A) orBool isPar(A))
  rule #match(  A:ProcPat ;  _:EvalPat ) => false requires notBool (isEvalPat(A) orBool isParPat(A))
  rule #match(  _:Eval    ;  A:ProcPat ) => false requires notBool (isEvalPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))
  rule #match(  _:EvalPat ;  A:ProcPat ) => false requires notBool (isEvalPat(A) orBool isWildCard(A) orBool isParPat(A) orBool isPatExp(A))

// NewPat
  rule #match( new A:Name  in { P:Proc    } ; new B:Name  in { Q:ProcPat } ) => #match(P;#sub(A;B;Q))
  rule #match( new A:Name  in { P:ProcPat } ; new B:Name  in { Q:ProcPat } ) => #match(P;#sub(A;B;Q))
  rule #match( new A:Names in { P:Proc    } ; new B:Names in { Q:ProcPat } ) => #length(A) ==Int #length(B) andBool #match(P;#sub(A;B;Q))
  rule #match( new A:Names in { P:ProcPat } ; new B:Names in { Q:ProcPat } ) => #length(A) ==Int #length(B) andBool #match(P;#sub(A;B;Q))
  // declaration length/type mismatch
  rule #match( _:Proc    ; _:NewPat ) => false [owise]
  rule #match( _:ProcPat ; _:NewPat ) => false [owise]

// CollectionPat
  // List Pattern
  rule #match( [ A:Proc     ] ; [ B:ProcPat  ] ) => #match(A;B)
  rule #match( [ A:ProcPat  ] ; [ B:ProcPat  ] ) => #match(A;B)
  rule #match( [ A:Procs    ] ; [ B:ProcPats ] ) => #matchif(A;B)
  rule #match( [ A:ProcPats ] ; [ B:ProcPats ] ) => #matchif(A;B)

  // Tuple Pattern
  rule #match( ( A:Proc     ,) ; ( B:ProcPat  ,) ) => #match(A;B)
  rule #match( ( A:ProcPat  ,) ; ( B:ProcPat  ,) ) => #match(A;B)
  rule #match( ( A:Procs    ,) ; ( B:ProcPats ,) ) => #matchif(A;B)
  rule #match( ( A:ProcPats ,) ; ( B:ProcPats ,) ) => #matchif(A;B)

// match Procs with ProcPats
  rule #match( A:Proc , B:Proc  ; C:ProcPat , D:Proc     ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Proc  ; C:Proc    , D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Proc  ; C:ProcPat , D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Procs ; C:ProcPat , D:Procs    ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Procs ; C:Proc    , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc , B:Procs ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)

// match ProcPats with ProcPats
  rule #match( A:ProcPat , B:Proc     ; C:ProcPat , D:Proc     ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:Proc     ; C:Proc    , D:ProcPat  ) => false // ProcPat does not match Proc
  rule #match( A:ProcPat , B:Proc     ; C:ProcPat , D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc    , B:ProcPat  ; C:Proc    , D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc    , B:ProcPat  ; C:ProcPat , D:Proc     ) => false // ProcPat does not match Proc
  rule #match( A:Proc    , B:ProcPat  ; C:ProcPat , D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:ProcPat  ; C:Proc    , D:ProcPat  ) => false // ProcPat does not match Proc
  rule #match( A:ProcPat , B:ProcPat  ; C:ProcPat , D:Proc     ) => false // ProcPat does not match Proc
  rule #match( A:ProcPat , B:ProcPat  ; C:ProcPat , D:ProcPat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:Procs    ; C:ProcPat , D:Procs    ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:Procs    ; C:Proc    , D:ProcPats ) => false // ProcPat does not match Proc
  rule #match( A:ProcPat , B:Procs    ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc    , B:ProcPats ; C:ProcPat , D:Procs    ) => false // ProcPats does not match Procs
  rule #match( A:Proc    , B:ProcPats ; C:Proc    , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Proc    , B:ProcPats ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:ProcPat , B:ProcPats ; C:ProcPat , D:Procs    ) => false // ProcPats does not match Procs
  rule #match( A:ProcPat , B:ProcPats ; C:Proc    , D:ProcPats ) => false // ProcPat does not match Proc
  rule #match( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ) => #match(A;C) andBool #match(B;D)

//--- Name & NamePat ---
  rule #match( _:Name    ; \_ ) => true
  rule #match( _:NamePat ; \_ ) => true

// match Names with NamePats
  rule #match( A:Name , B:Name  ; C:NamePat , D:Name     ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name , B:Name  ; C:Name    , D:NamePat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name , B:Name  ; C:NamePat , D:NamePat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name , B:Names ; C:NamePat , D:Names    ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name , B:Names ; C:Name    , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name , B:Names ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)

// match NamePats with NamePats
  rule #match( A:NamePat , B:Name     ; C:NamePat , D:Name     ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:Name     ; C:Name    , D:NamePat  ) => false
  rule #match( A:NamePat , B:Name     ; C:NamePat , D:NamePat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name    , B:NamePat  ; C:Name    , D:NamePat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name    , B:NamePat  ; C:NamePat , D:Name     ) => false
  rule #match( A:Name    , B:NamePat  ; C:NamePat , D:NamePat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:NamePat  ; C:Name    , D:NamePat  ) => false
  rule #match( A:NamePat , B:NamePat  ; C:NamePat , D:Name     ) => false
  rule #match( A:NamePat , B:NamePat  ; C:NamePat , D:NamePat  ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:Names    ; C:NamePat , D:Names    ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:Names    ; C:Name    , D:NamePats ) => false
  rule #match( A:NamePat , B:Names    ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name    , B:NamePats ; C:NamePat , D:Names    ) => false
  rule #match( A:Name    , B:NamePats ; C:Name    , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:Name    , B:NamePats ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)
  rule #match( A:NamePat , B:NamePats ; C:NamePat , D:Names    ) => false
  rule #match( A:NamePat , B:NamePats ; C:Name    , D:NamePats ) => false
  rule #match( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ) => #match(A;C) andBool #match(B;D)

//------------------
//--- #includedIn --
//------------------
  // left arg set empty
  rule #includedIn(  .Set ; _:Set ) => true
  // right arg set empty
  rule #includedIn( A:Set ;  .Set ) => false requires A =/=K .Set
//rule #includedIn( _:Set ; _:Set ) => false [owise]

  // #includedIn( {e} S:Set ; T:Set ) => #includedIn({e};T) and #includedIn(S;T)
  // each element of the left arg set must be contained in the right arg set
  // and-branch over all left arg set elements:
  rule #includedIn( SetItem( A:Proc    , I:Int ) S:Set ; T:Set )
    => #includedIn(SetItem(A,I);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set
  rule #includedIn( SetItem( A:Proc    , I:Int ) S:Set ; T:Set )
    => #includedIn(SetItem(A,I);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set
  rule #includedIn( SetItem( A:ProcPat , I:Int ) S:Set ; T:Set )
    => #includedIn(SetItem(A,I);T) andBool #includedIn(S;T)
       requires S =/=K .Set andBool T =/=K .Set

  // #includedIn( {e} ; {e'} T:Set ) => #includedIn({e};{e'}) or #includedIn({e};T)
  // left arg set element is included in right arg set if there's at least one matching right arg set element
  // or-brach over right arg set elements:
  rule #includedIn( SetItem( A:Proc    , I:Int ) ; SetItem( B:Proc    , J:Int ) T:Set )
    => #includedIn(SetItem(A,I);SetItem(B,J)) orBool #includedIn(SetItem(A,I);T)
       requires T =/=K .Set
  rule #includedIn( SetItem( A:Proc    , I:Int ) ; SetItem( B:ProcPat , J:Int ) T:Set )
    => #includedIn(SetItem(A,I);SetItem(B,J)) orBool #includedIn(SetItem(A,I);T)
       requires T =/=K .Set
  rule #includedIn( SetItem( A:ProcPat , I:Int ) ; SetItem( B:ProcPat , J:Int ) T:Set )
    => #includedIn(SetItem(A,I);SetItem(B,J)) orBool #includedIn(SetItem(A,I);T)
       requires T =/=K .Set

  // #includedIn( {A,I} ; {B,J} ) => #match(A;B) and I <= J
  // element inclusion -- matching and fewer occurrences in the left arg set element
  rule #includedIn( SetItem( A:Proc    , I:Int ) ; SetItem( B:Proc    , J:Int ) ) => I <=Int J andBool #match(A;B)
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