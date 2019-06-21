// Structural & Name Equivalence for Rholang

/*
TODO:
 - NonPar Proc
 - #structEq(ConSend;ConSend), #structEq(UnconSend;UnconSend)
 - Patterns
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
  syntax    Set ::=    "#setify(" Proc  ")"           [function]

// Translation to built-ins -- other half in AuxFun
  syntax     List ::= "#rho2list(" RhoList ")" [function]
  syntax      Map ::=  "#rho2map(" RhoMap  ")" [function]
  syntax      Set ::=  "#rho2set(" RhoSet  ")" [function]

  syntax     Bool ::=    "#structEqs(" Proc ";" Procs      ")" [function]
                    | "#key_structEq(" Proc ";" RhoKVPair  ")" [function]
                    | "#key_structEq(" Proc ";" RhoKVPairs ")" [function]
                    | "#SeqSetIn(" Set ";" Set ")" [function]
                    | "#SeqMapIn(" Map ";" Map ")" [function]

endmodule

module STRUCT
  import STRUCT-SYNTAX
  import ALPHA

  syntax KResult ::= Proc /*| Bool | Int | Set <: Proc*/

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

// TODO: #structEq( A:Proc ; B:Proc ) => #ProcSeq(A;B) requires notBool
// checks par set structural equality of deBruijnified Procs
  rule #structEq( A:Proc ; B:Proc ) => #setify(#deBruijn(0;A;.Map)) ==K #setify(#deBruijn(0;B;.Map))
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
  rule #structEq( _:Proc ; _:Send ) => false [owise]

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
       #else A |-> B #rho2map({C})
       #fi
  rule #rho2map( { A:Proc : B:Proc , C:RhoKVPairs } )
    => #if #key_structEq(A;C)
       #then #rho2map({C})
       #else A |-> B #rho2map({C})
       #fi

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