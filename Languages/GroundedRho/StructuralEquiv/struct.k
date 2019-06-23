// Structural & Name Equivalence for Rholang

/*
TODO:
 - NonPar Proc
 - #structEq(ConSend;ConSend), #structEq(UnconSend;UnconSend)
 - Patterns
 - Normalize before checking structural equiv (then notBool isPar(...) and notBool isEval(...) can be removed)
*/

require "../grho.k"
require "../AlphaEquiv/alpha.k"

module STRUCT-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Structural equivalence relation
  syntax   Bool ::=   "#structEq(" Proc     ";" Proc     ")" [function]
                  |   "#structEq(" Procs    ";" Procs    ")" [function]
                  |   "#structEq(" ProcPat  ";" ProcPat  ")" [function]
                  |   "#structEq(" ProcPats ";" ProcPats ")" [function]
                  | "#structEqif(" Procs    ";" Procs    ")" [function]
                  | "#structEqif(" ProcPats ";" ProcPats ")" [function]

  syntax   Bool ::= "#structEq(" RhoKVPair  ";" RhoKVPair  ")" [function]
                  | "#structEq(" RhoKVPairs ";" RhoKVPairs ")" [function]

// Name equivalence relation
  syntax   Bool ::=   "#nameEq(" Name     ";" Name     ")" [function]
                  |   "#nameEq(" Names    ";" Names    ")" [function]
                  |   "#nameEq(" NamePat  ";" NamePat  ")" [function]
                  |   "#nameEq(" NamePats ";" NamePats ")" [function]
                  | "#nameEqif(" Names    ";" Names    ")" [function]
                  | "#nameEqif(" NamePats ";" NamePats ")" [function]

// par normalization functions
  syntax    Int ::=  "#parCount(" Proc  ";" Proc  ")" [function]
  syntax   Proc ::= "#parRemove(" Proc  ";" Proc  ")" [function]
                  | "#removeNil(" Proc  ")"           [function]
  syntax    Set ::=    "#setify(" Proc  ")"           [function]

  syntax   Bool ::=   "#order(" Proc  ";" Proc  ")" [function]
                  |   "#order(" Procs ";" Procs ")" [function]
                  |   "#order(" Name  ";" Name  ")" [function]
                  |   "#order(" Names ";" Names ")" [function]
                  | "#orderif(" Procs ";" Procs ")" [function]
                  | "#orderif(" Names ";" Names ")" [function]
  syntax   Proc ::= "#parnorm(" Proc ")" [function]
                  | "#reorder(" Proc ")" [function]
                  | "#reorder(" Proc ";" Proc  ";" Proc  ")" [function] // #reorder(Nil;A:Proc;Nil) => A
  syntax  Procs ::= "#reorder(" Procs ")" [function]
                  | "#reorder(" Proc ";" Proc  ";" Proc  ")" [function] // #reorder(A:Proc;B:Proc;Nil) => A,B or B,A
                  | "#reorder(" Proc ";" Proc  ";" Procs ")" [function]
                  | "#reorder(" Proc ";" Procs ";" Proc  ")" [function]
                  | "#reorder(" Proc ";" Procs ";" Procs ")" [function]


// Translation to built-ins -- other half in AuxFun
  syntax   List ::= "#rho2list(" RhoList ")" [function]
  syntax    Map ::=  "#rho2map(" RhoMap  ")" [function]
  syntax    Set ::=  "#rho2set(" RhoSet  ")" [function]

  syntax   Bool ::=    "#structEqs(" Proc ";" Procs      ")" [function] // seq of left arg against all right arg Procs
                  | "#key_structEq(" Proc ";" RhoKVPair  ")" [function] // seq of left arg with key of RhoKVPair
                  | "#key_structEq(" Proc ";" RhoKVPairs ")" [function] // seq of left arg against all keys of RhoKVPairs
                  | "#SeqSetIn(" Set ";" Set ")" [function] // structural equivalence Set inclusion
                  | "#SeqMapIn(" Map ";" Map ")" [function] // structural equivalence Map inclusion

endmodule

module STRUCT
  import STRUCT-SYNTAX
  import ALPHA

  syntax KResult ::= Proc | Procs | Bool | Int | Set

// counts number of structurally eq appearances of a nonPar Proc in a Par
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #parCount( A:Proc ; B:Proc ) => #if #structEq(A;B) #then 1 #else 0 #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #parCount( A:Proc ; B:Proc | C:Proc ) => #if #structEq(A;B) #then 1 +Int #parCount(A;C) #else #parCount(A;C) #fi
       requires notBool isPar(B)

// traverses Par removing structurally eq nonPar Proc
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #parRemove( A:Proc ; B:Proc ) => #if #structEq(A;B) #then Nil #else B #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #parRemove( A:Proc ; B:Proc | C:Proc ) => #if #structEq(A;B) #then #parRemove(A;C) #else B | #parRemove(A;C) #fi
       requires notBool isPar(B)

// computes par set of a Proc
  // par set of a nonPar Proc contains only one appearance of that Proc
  rule #setify(   Nil  ) => .Set
  rule #setify( A:Proc ) => SetItem(A,1) requires notBool (isPar(A) orBool A ==K Nil)
  rule #setify( A:Proc | B:Proc ) 
    => #if A ==K Nil
       #then #setify(B) // Nil is the unit of | -- forget about it!
       #else
         #if #parCount(A;B) >Int 0
         // remove Nil introduced by #parRemove
         #then SetItem(A,1 +Int #parCount(A;B)) #setify(#parRemove(A;B))
         #else SetItem(A,1) #setify(B)
         #fi 
       #fi requires notBool isPar(A)

// Order -- think of #order( A:Proc ; B:Proc ) as order(A) <= order(B) for some order(_): Proc -> Real
// #removeNil( Nil | Proc ) => Proc
  rule #removeNil( A:Proc ) => A requires notBool isPar(A) // TODO: extend to NonPar Proc and Name
  rule #removeNil( A:Proc | Nil ) => A requires notBool isPar(A)
  rule #removeNil( A:Proc | B:Proc ) => #if A ==K Nil
                                        #then #removeNil(B)
                                        #else A | #removeNil(B) #fi
                                        requires notBool (isPar(A) orBool B ==K Nil)

  // check length first
  rule #orderif( A:Procs ; B:Procs ) => #length(A) ==Int #length(B) andBool #order(A;B)
  rule #orderif( A:Names ; B:Names ) => #length(A) ==Int #length(B) andBool #order(A;B)

  // dictionary order
  rule #order( A:Proc , B:Proc ; C:Proc , D:Proc ) => #if #order(A;C)
                                                      #then #if #order(C;A)
                                                            #then #order(B;D)
                                                            #else true #fi
                                                      #else false #fi
  rule #order( A:Proc , B:Procs ; C:Proc , D:Procs ) => #if #order(A;C)
                                                        #then #if #order(C;A)
                                                              #then #order(B;D)
                                                              #else true #fi
                                                        #else false #fi

  rule #order( A:Name , B:Name ; C:Name , D:Name ) => #if #order(A;C)
                                                      #then #if #order(C;A)
                                                            #then #order(B;D)
                                                            #else true #fi
                                                      #else false #fi

  rule #order( A:Name , B:Names ; C:Name , D:Names ) => #if #order(A;C)
                                                        #then #if #order(C;A)
                                                              #then #order(B;D)
                                                              #else true #fi
                                                        #else false #fi

  rule #order( A:Proc ; A ) => true // reflexive
  // Ground
    // Nil
  rule #order( A:Proc ; Nil    ) => A ==K Nil
  rule #order( Nil    ; _:Proc ) => true
    // Bool
  rule #order( _:Bool ; A:Proc ) => true  requires notBool (A ==K Nil orBool isBool(A))
  rule #order( A:Proc ; _:Bool ) => false requires notBool (A ==K Nil orBool isBool(A))
  rule #order( true   ; A:Bool ) => notBool A
  rule #order( false  ; A:Bool ) => A
    // Int
  rule #order( _:Int  ; A:Proc ) => true  requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A))
  rule #order( A:Proc ; _:Int  ) => false requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A))
  rule #order( I:Int  ; J:Int  ) => I <=Int J
    // String
  rule #order( _:String ; A:Proc   ) => true  requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A) orBool isString(A))
  rule #order( A:Proc   ; _:String ) => false requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A) orBool isString(A))
  rule #order( A:String ; B:String ) => #set2procs(#procs2set(A,B)) ==K (A,B)
    // Unforgeable
  rule #order( _:Unforgeable ; A:Proc   ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A) orBool isString(A) orBool isUnforgeable(A))
  rule #order( A:Proc   ; _:Unforgeable ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A) orBool isString(A) orBool isUnforgeable(A))
  rule #order( unforgeable( I:Int ) ; unforgeable( J:Int ) ) => I <=Int J
    // Uri
  rule #order( _:Uri  ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A) orBool isString(A) orBool isUnforgeable(A) orBool isUri(A))
  rule #order( A:Proc ; _:Uri  ) => false
       requires notBool (A ==K Nil orBool isBool(A) orBool isInt(A) orBool isString(A) orBool isUnforgeable(A) orBool isUri(A))
  rule #order( A:Uri ; B:Uri ) => #set2procs(#procs2set(A,B)) ==K (A,B)

  // Variables -- need mapping from 
  rule #order( _:ProcVar ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A))
  rule #order( A:Proc ; _:ProcVar ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A))
  rule #order( A:ProcVar ; B:ProcVar ) => #set2procs(#procs2set(A,B)) ==K (A,B)
    // Eval
  rule #order( *_:NameVar ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A) orBool isEval(A))
  rule #order( A:Proc ; *_:NameVar ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A) orBool isEval(A))
  rule #order( *A:NameVar ; *B:NameVar ) => #set2procs(#procs2set(*A,*B)) ==K (*A,*B)

  // VarRef
  rule #order( _:VarRef ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A) orBool isEval(A) orBool isVarRef(A))
  rule #order( A:Proc ; _:VarRef ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A) orBool isEval(A) orBool isVarRef(A))
  rule #order( = *A:NameVar ; = *B:NameVar ) => #order(A;B)
  rule #order( =  A:ProcVar ; =  B:ProcVar ) => #order(A;B)

  // New
  rule #order( _:New ; A:Proc ) => true
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A) orBool isEval(A) orBool isVarRef(A) orBool isNew(A))
  rule #order( A:Proc ; _:New ) => false
       requires notBool (A ==K Nil orBool isGround(A) orBool isProcVar(A) orBool isEval(A) orBool isVarRef(A) orBool isNew(A))
  rule #order( new A:Name in { B:Proc } ; new C:Name in { D:Proc } )
    => #if #order(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi
  rule #order( new A:Names in { B:Proc } ; new C:Names in { D:Proc } )
    => #if #orderif(A;C)
       #then #if #order(C;A)
             #then #order(B;D)
             #else true #fi
       #else false #fi

// TODO
  // MethodProc: Proc . Method ( Args ) dictionary order by Method , Args , Proc
  // Exp: BExp < AExp <StringExp
  // Matching: dictionary order by # of MatchCases, Proc, MatchCases
  // Contract: dictionary order by Chan , NamePat
  // Receive: dictionary order by Type , Chans , Bvars , Cont
  // Send: dictionary order by Type , # of msgs , Chan , Procs
  // Bundle:  < 0 < - < + and #order(Proc;Proc)
  // Conditional: dictionary order by BExp , then Proc [, else Proc]
  // Collection: List < Map < Set < Tuple

// TODO: #order( Name[s] )
  rule #order( @A:Proc   ; @B:Proc   ) => #order(A;B)
  rule #order( A:NameVar ; B:NameVar ) => #set2procs(#procs2set(*A,*B)) ==K (*A,*B)
  rule #order( @A:Proc   ; B:NameVar ) => #order(A;*B)
  rule #order( A:NameVar ; @B:Proc   ) => #order(*A;B)

// Reorder
  // check order of left arg against all middle args and insert,
  // then move the head of the right arg list to the left arg and repeat
  // applied after #removeNil -- so no Nils will be present but "requires" needed to prevent infinite looping

    // #reorder( Proc[s] )
  rule #reorder(   Nil   ) => .K
  rule #reorder( A:Proc  ) => A requires notBool (isPar(A) orBool A==K Nil)
  rule #reorder( A:Procs ) => #reorder(Nil;Nil;A)

    // #reorder( Nil ; Nil ; Procs )
  rule #reorder( Nil ; Nil ; A:Proc , B:Proc  ) => #reorder(Nil;A;B) requires A =/=K Nil andBool B =/=K Nil
  rule #reorder( Nil ; Nil ; A:Proc , B:Procs ) => #reorder(Nil;A;B) requires A =/=K Nil

    // #reorder( Nil ; Proc /\ ~Nil ; Proc[s] /\ ~Nil )
  rule #reorder( Nil ; A:Proc ; B:Proc           ) => #reorder(B;A;Nil) requires A =/=K Nil andBool B =/=K Nil
  rule #reorder( Nil ; A:Proc ; B:Proc , C:Proc  ) => #reorder(B;A;C)   requires A =/=K Nil andBool B =/=K Nil andBool C =/=K Nil
  rule #reorder( Nil ; A:Proc ; B:Proc , C:Procs ) => #reorder(B;A;C)   requires A =/=K Nil andBool B =/=K Nil

    // #reorder( Nil ; Procs ; Proc[s] )
  rule #reorder( Nil ; A:Procs ; Nil ) => A
  rule #reorder( Nil ; A:Proc , B:Proc  ; C:Proc           ) => #reorder(C;A,B;Nil) requires C =/=K Nil
  rule #reorder( Nil ; A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #reorder(C;A,B;D)   requires C =/=K Nil andBool D =/=K Nil
  rule #reorder( Nil ; A:Proc , B:Proc  ; C:Proc , D:Procs ) => #reorder(C;A,B;D)   requires C =/=K Nil
  rule #reorder( Nil ; A:Proc , B:Procs ; C:Proc           ) => #reorder(C;A,B;Nil) requires C =/=K Nil
  rule #reorder( Nil ; A:Proc , B:Procs ; C:Proc , D:Proc  ) => #reorder(C;A,B;D)   requires C =/=K Nil andBool D =/=K Nil
  rule #reorder( Nil ; A:Proc , B:Procs ; C:Proc , D:Procs ) => #reorder(C;A,B;D)   requires C =/=K Nil

    // #reorder( Proc /\ ~Nil ; Proc /\ ~Nil \/ Procs ; Nil )
  rule #reorder( A:Proc ; B:Proc ; Nil ) => #if #order(A;B) #then A,B #else B,A #fi
                                            requires A =/=K Nil andBool B =/=K Nil
  rule #reorder( A:Proc ; B:Proc , C:Proc  ; Nil ) => #if #order(A;B)
                                                      #then #append(A;B,C)
                                                      #else #append(B;#reorder(A;C;Nil)) #fi
                                                      requires A =/=K Nil andBool C =/=K Nil
  rule #reorder( A:Proc ; B:Proc , C:Procs ; Nil ) => #if #order(A;B)
                                                      #then #append(A;B,C)
                                                      #else #append(B;#reorder(A;C;Nil)) #fi
                                                      requires A =/=K Nil andBool C =/=K Nil
    // #reorder( Proc ; Proc /\ ~Nil ; Proc /\ ~Nil \/ Procs )
  rule #reorder( A:Proc ; B:Proc ; C:Proc           ) => #reorder(C;#reorder(A;B;Nil);Nil) requires A =/=K Nil andBool B =/=K Nil andBool C =/=K Nil
  rule #reorder( A:Proc ; B:Proc ; C:Proc , D:Proc  ) => #reorder(C;#reorder(A;B;Nil);D)   requires A =/=K Nil andBool B =/=K Nil andBool C =/=K Nil andBool D =/=K Nil
  rule #reorder( A:Proc ; B:Proc ; C:Proc , D:Procs ) => #reorder(C;#reorder(A;B;Nil);D)   requires A =/=K Nil andBool B =/=K Nil andBool C =/=K Nil
    // #reorder( Proc ; Procs ; Proc /\ ~Nil \/ Procs )
  rule #reorder( A:Proc ; B:Procs ; C:Proc           ) => #reorder(C;#reorder(A;B;Nil);Nil) requires A =/=K Nil andBool C =/=K Nil
  rule #reorder( A:Proc ; B:Procs ; C:Proc , D:Proc  ) => #reorder(C;#reorder(A;B;Nil);D)   requires A =/=K Nil andBool C =/=K Nil andBool D =/=K Nil
  rule #reorder( A:Proc ; B:Procs ; C:Proc , D:Procs ) => #reorder(C;#reorder(A;B;Nil);D)   requires A =/=K Nil andBool C =/=K Nil

  // Par normalization
  rule #parnorm( A:Par  ) => #procs2par(#reorder(#par2procs(#removeNil(A))))
  rule #parnorm( A:Proc ) => A requires notBool isPar(A)

// checks par set structural equality of deBruijnified Procs
  rule #structEq( A:Proc ; B:Proc ) => #setify(#deBruijn(A)) ==K #setify(#deBruijn(B))
       requires isPar(A) orBool isPar(B)
  rule #structEq( A:Proc , B:Proc  ; C:Proc , D:Proc  ) => #structEq(A;C) andBool #structEq(B;D)
  rule #structEq( A:Proc , B:Procs ; C:Proc , D:Procs ) => #structEq(A;C) andBool #structEq(B;D)

  rule #structEqif( A:Procs ; B:Procs ) => #length(A) ==Int #length(B) andBool #structEq(A;B)

// NonPar Proc Structural Equivalence
  // Ground
  rule #structEq( A:Ground ; B:Ground ) => A ==K B
  rule #structEq( _:Ground ; B:Proc   ) => false requires notBool (isGround(B) orBool isPar(B) orBool isEval(B))
  rule #structEq( A:Proc   ; _:Ground ) => false requires notBool (isGround(A) orBool isPar(A) orBool isEval(A))

  // Send
  rule #structEq( A:Name !  (         ) ; C:Name !  (         ) ) => #nameEq(A;C)
  rule #structEq( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ) => #nameEq(A;C) andBool   #structEq(B;D)
  rule #structEq( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ) => #nameEq(A;C) andBool #structEqif(B;D)
  rule #structEq( A:Name !! (         ) ; C:Name !! (         ) ) => #nameEq(A;C)
  rule #structEq( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ) => #nameEq(A;C) andBool   #structEq(B;D)
  rule #structEq( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ) => #nameEq(A;C) andBool #structEqif(B;D)
  rule #structEq( A:Proc ; _:Send ) => false requires notBool (isSend(A) orBool isPar(A) orBool isEval(A))
  rule #structEq( _:Send ; A:Proc ) => false requires notBool (isSend(A) orBool isPar(A) orBool isEval(A))

  // Receive -- checks equivalence of listening variables, channels, and continuations
    // SRec
  rule #structEq( for( Y:NamePats <- X:Name ){ P:Proc } ; for( V:NamePats <- U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:NamePat  <- X:Name ){ P:Proc } ; for( V:NamePat  <- U:Name ){ Q:Proc } )
    => #nameEq(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Names    <- X:Name ){ P:Proc } ; for( V:Names    <- U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Name     <- X:Name ){ P:Proc } ; for( V:Name     <- U:Name ){ Q:Proc } )
    => #nameEq(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for(            <- X:Name ){ P:Proc } ; for(            <- U:Name ){ Q:Proc } )
    => #nameEq(X;U) andBool #structEq(P;Q)

  rule #structEq( for( Y:NamePats <! X:Name ){ P:Proc } ; for( V:NamePats <! U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:NamePat  <! X:Name ){ P:Proc } ; for( V:NamePat  <! U:Name ){ Q:Proc } )
    => #nameEq(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Names    <! X:Name ){ P:Proc } ; for( V:Names    <! U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Name     <! X:Name ){ P:Proc } ; for( V:Name     <! U:Name ){ Q:Proc } )
    => #nameEq(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for(            <! X:Name ){ P:Proc } ; for(            <! U:Name ){ Q:Proc } )
    => #nameEq(X;U) andBool #structEq(P;Q)

  rule #structEq( for( Y:NamePats <= X:Name ){ P:Proc } ; for( V:NamePats <= U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:NamePat  <= X:Name ){ P:Proc } ; for( V:NamePat  <= U:Name ){ Q:Proc } )
    => #nameEq(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Names    <= X:Name ){ P:Proc } ; for( V:Names    <= U:Name ){ Q:Proc } )
    => #nameEqif(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for( Y:Name     <= X:Name ){ P:Proc } ; for( V:Name     <= U:Name ){ Q:Proc } )
    => #nameEq(Y;V) andBool #nameEq(X;U) andBool #structEq(P;#sub(Y;V;Q))
  rule #structEq( for(            <= X:Name ){ P:Proc } ; for(            <= U:Name ){ Q:Proc } )
    => #nameEq(X;U) andBool #structEq(P;Q)

    // MRec -- TODO

  // Collection
    // RhoList
  rule #structEq( [ ] ; [ ] ) => true
  rule #structEq( [ A:Proc  ] ; [ B:Proc  ] ) =>   #structEq(A;B)
  rule #structEq( [ A:Procs ] ; [ B:Procs ] ) => #structEqif(A;B)
  rule #structEq( _:RhoList   ; _:RhoList   ) => false [owise]

    // RhoMap
  rule #structEq( A:RhoMap ; B:RhoMap ) => #structEq(#rho2map(A);#rho2map(B))
  rule #structEq( A:Proc   ; _:RhoMap ) => false requires notBool (isRhoMap(A) orBool isPar(A))
  rule #structEq( _:RhoMap ; A:Proc   ) => false requires notBool (isRhoMap(A) orBool isPar(A))

    // RhoSet
  rule #structEq( A:RhoSet ; B:RhoSet ) => #structEq(#rho2set(A);#rho2set(B))
  rule #structEq( A:Proc   ; _:RhoSet ) => false requires notBool (isRhoSet(A) orBool isPar(A))
  rule #structEq( _:RhoSet ; A:Proc   ) => false requires notBool (isRhoSet(A) orBool isPar(A))

    // RhoTuple
  rule #structEq( ( A:Proc  ,) ; ( B:Proc  ,) ) =>   #structEq(A;B)
  rule #structEq( ( A:Procs ,) ; ( B:Procs ,) ) => #structEqif(A;B)
  rule #structEq( _:RhoTuple   ; _:RhoTuple   ) => false [owise]

//----------------
//--- #SeqSetIn --
//----------------
// Structural equivalence of sets
  rule #structEq( A:Set ; B:Set ) => #SeqSetIn(A;B) andBool #SeqSetIn(B;A)
  rule #structEq( A:Map ; B:Map ) => #SeqMapIn(A;B) andBool #SeqMapIn(B;A)

// Structural equivalence set inclusion
  // left arg set empty
  rule #SeqSetIn(  .Set ; _:Set ) => true
  // right arg set empty
  rule #SeqSetIn( A:Set ;  .Set ) => false requires A =/=K .Set

// TODO: turn each element into least order seq term so this can become syntactic equality i.e. normalize term
  // #SeqSetIn( {e} S:Set ; T:Set ) => #SeqSetIn({e};T) and #SeqSetIn(S;T)
  // each element of the left arg set must be contained in the right arg set
  // and-branch over all left arg set elements:
  rule #SeqSetIn( SetItem( A:Proc ) S:Set ; T:Set )
    => #SeqSetIn( SetItem(A);T) andBool #SeqSetIn(S;T)
       requires S =/=K .Set

  // #SeqSetIn( {e} ; {e'} T:Set ) => #SeqSetIn({e};{e'}) or #SeqSetIn({e};T)
  // left arg set element is contained in right arg set if there's at least one struct equiv right arg set element
  // or-brach over right arg set elements:
  rule #SeqSetIn( SetItem( A:Proc ) ; SetItem( B:Proc ) T:Set )
    => #SeqSetIn(SetItem(A);SetItem(B)) orBool #SeqSetIn(SetItem(A);T)
       requires T =/=K .Set
  rule #SeqSetIn( SetItem( A:Proc ) ; SetItem( B:Proc ) ) => #structEq(A;B)

  // left arg Map empty
  rule #SeqMapIn(  .Map ; _:Map ) => true
  // right arg Map empty
  rule #SeqMapIn( A:Map ;  .Map ) => false requires A =/=K .Map
// TODO: turn each element into least order seq term so this can become syntactic equality
  rule #SeqMapIn( A:Proc |-> B:Proc M:Map ; N:Map )
    => #SeqMapIn( A |-> B;N) andBool #SeqMapIn(M;N)
       requires M =/=K .Map
  rule #SeqMapIn( A:Proc |-> B:Proc ; C:Proc |-> D:Proc N:Map ) // struct equiv of keys and values
    => #SeqMapIn(A|->B;C|->D) orBool #SeqMapIn(A|->B;N)
       requires N =/=K .Map
  rule #SeqMapIn( A:Proc |-> B:Proc ; C:Proc |-> D:Proc ) => #structEq(A;C) andBool #structEq(B;D)

//------------------------
//--- Name Equivalence ---
//------------------------
  // mainly for NameVars
  rule #nameEq( A:Name ; B:Name ) => A ==K B requires notBool (isQuote(A) andBool isQuote(B))
  rule #nameEq( A:Name ; A ) => true
  rule #nameEq( @P:Proc ; @Q:Proc ) => #structEq(P;Q)

  // several Names
  rule #nameEq( A:Name , B:Name  ; C:Name , D:Name  ) => #nameEq(A;C) andBool #nameEq(B;D)
  rule #nameEq( A:Name , B:Names ; C:Name , D:Names ) => #nameEq(A;C) andBool #nameEq(B;D)

  rule #nameEqif( A:Names ; B:Names ) => #length(A) ==Int #length(B) andBool #nameEq(A;B)

//-----------------
//--- Built-ins ---
//-----------------
// #rho2list -- throws [Error] Internal: Uncaught exception thrown of type AssertionError.
  rule #rho2list( [ ] ) => .List
  rule #rho2list( [ A:Proc ] ) => ListItem(A)
  rule #rho2list( [ A:Proc , B:Proc  ] ) => ListItem(A) #rho2list([B])
  rule #rho2list( [ A:Proc , B:Procs ] ) => ListItem(A) #rho2list([B])

// #rho2map
// produces Map with unique keys for structurally equivalent keys in RhoMap
  rule #rho2map( { } ) => .Map
  rule #rho2map( { A:Proc : B:Proc } ) => A |-> B
  rule #rho2map( { A:Proc : B:Proc , C:RhoKVPair } )
    => #if #key_structEq(A;C)
       #then #rho2map({C}) // forget about KV pair if the key is struct eq to another key
       #else A |-> B #rho2map({C}) #fi
  rule #rho2map( { A:Proc : B:Proc , C:RhoKVPairs } )
    => #if #key_structEq(A;C)
       #then #rho2map({C})
       #else A |-> B #rho2map({C}) #fi

// #rho2set
  rule #rho2set( Set( ) ) => .Set
  rule #rho2set( Set( A:Proc ) ) => SetItem(A)
  rule #rho2set( Set( A:Proc , B:Proc ) )
    => #if #structEq(A;B)
       #then SetItem(B) // if #structEq(A;B), discard A (want to keep lowest order term)
       #else SetItem(A) SetItem(B) // otherwise keep everything
       #fi
  rule #rho2set( Set( A:Proc , B:Procs ) )
    => #if #structEqs(A;B)
       #then #rho2set(Set(B)) // if #structEq(A;C) for some C in B, discard A
       #else SetItem(A) #rho2set(Set(B)) // otherwise keep A and traverse remaining set
       #fi

  // #key_structEq( key ; RhoKVPair )
  rule #key_structEq( A:Proc ; B:Proc : _:Proc ) => #structEq(A;B)
  // #key_structEq( key ; RhoKVPairs )
  rule #key_structEq( A:Proc ; B:Proc : _:Proc , C:RhoKVPair  ) => #structEq(A;B) orBool #key_structEq(A;C)
  rule #key_structEq( A:Proc ; B:Proc : _:Proc , C:RhoKVPairs ) => #structEq(A;B) orBool #key_structEq(A;C)

  rule #structEqs( A:Proc ; B:Proc , C:Proc  ) => #structEq(A;B) orBool  #structEq(A;C)
  rule #structEqs( A:Proc ; B:Proc , C:Procs ) => #structEq(A;B) orBool #structEqs(A;C)

endmodule