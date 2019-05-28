// Auxilary functions for GRHO configuration

/*
TODO:
 - #toK( RhoList/RhoMap/RhoSet ) => List/Map/Set to utilize builtin functionality for methods
 - #fromK( List/Map/Set ) => RhoList/RhoMap/RhoSet
*/

require "../grho.k"
require "../AlphaEquiv/alpha.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

  syntax    Int ::= "#length(" Name     ")"        [function]  // #length(_): Name -------------------> Int
                  | "#length(" Names    ")"        [function]  // #length(_): Names ------------------> Int
                  | "#length(" Proc     ")"        [function]  // #length(_): Proc -------------------> Int
                  | "#length(" Procs    ")"        [function]  // #length(_): Procs ------------------> Int
                  | "#length(" AnyBinds ")"        [function]  // #length(_): AnyBinds ---------------> Int
                  | "#msglen(" Send     ")"        [function]  // #msglen(_): Send -------------------> Int
                  | "#bnum("   AnyBind  ")"        [function]  //   #bnum(_): AnyBind ----------------> Int
                  | "#bnum("   Receive  ")"        [function]  //   #bnum(_): Receive ----------------> Int
                  | "#stype("  Send     ")"        [function]  //  #stype(_): Send -------------------> Int
                  | "#rtype("  AnyBind  ")"        [function]  //  #rtype(_): AnyBind ----------------> Int
                  | "#rtype("  AnyBinds ")"        [function]  //  #rtype(_): AnyBinds ---------------> Int
                  | "#rtype("  Receive  ")"        [function]  //  #rtype(_): Receive ----------------> Int

  syntax    Int ::= "#size"   RhoMap                  [function]  // #size: RhoMap ----------------------> Int
                  | "#size"   RhoSet                  [function]  // #size: RhoSet ----------------------> Int
                  | "#length" RhoList                 [function]  // #length: RhoList -------------------> Int

  syntax   Bind ::= "#bind" "(" Receive ")"           [function]  // #bind(_): Receive --------> Bind

  syntax  Binds ::= "#bind" "(" Receive ")"           [function]  // #bind(_): Receive --------> Binds

  syntax   Proc ::= "#cont" "(" Receive ")"           [function]  // #cont(_): Receive --------> Proc
                  | "#msg"  "("   Send  ")"           [function]  // #msg(_): Send ------------> Proc

  syntax  Procs ::= "#lengths" "(" AnyBinds ")"       [function]  // #length(_): AnyBinds -----> Procs
                  | "#msg"     "(" Send     ")"       [function]  // #msg(_): Send ------------> Procs
                  | "#append" "(" Proc  ";" Proc  ")" [function]  // #append(_;_): Proc  x Proc ---------> Procs
                  | "#append" "(" Procs ";" Proc  ")" [function]  // #append(_;_): Procs x Proc ---------> Procs
                  | "#append" "(" Proc  ";" Procs ")" [function]  // #append(_;_): Proc  x Procs --------> Procs
                  | "#append" "(" Procs ";" Procs ")" [function]  // #append(_;_): Procs x Procs --------> Procs

  syntax   Name ::= "#chan"   "("   Send  ")"         [function]  //     #chan(_): Send -------> Name
                  | "#chan"   "(" Receive ")"         [function]  //     #chan(_): Receive ----> Name
                  | "#chan"   "(" AnyBind ")"         [function]  //     #chan(_): AnyBind ----> Name
                  | "#bvar"   "(" AnyBind ")"         [function]  //     #bvar(_): AnyBind ----> Name
                  | "#bvar"   "(" Receive ")"         [function]  //     #bvar(_): Receive ----> Name
                  | "#dec"    "(" New     ")"         [function]

  syntax  Names ::= "#chan"   "(" AnyBinds ")"        [function]  //     #chan(_): AnyBinds ---> Names
                  | "#chan"   "(" Receive  ")"        [function]  //     #chan(_): Receive ----> Names
                  | "#bvar"   "(" AnyBind  ")"        [function]  //     #bvar(_): AnyBind  ---> Names
                  | "#bvar"   "(" AnyBinds ")"        [function]  //     #bvar(_): AnyBinds ---> Names
                  | "#bvar"   "(" Receive  ")"        [function]  //     #bvar(_): Receive ----> Names
                  | "#quotes" "(" Procs    ")"        [function]  //   #quotes(_): Procs ------> Names
                  | "#append" "(" Name  ";" Name  ")" [function]
                  | "#append" "(" Names ";" Name  ")" [function]
                  | "#append" "(" Name  ";" Names ")" [function]
                  | "#append" "(" Names ";" Names ")" [function]
                  | "#dec"    "(" New     ")"         [function]

// For input guards
  syntax   BExp ::= "#guard" "(" Receive ")"          [function]

// For string interpolation
  syntax String ::= "#interpolate(" String ";" RhoMap ")" [function]

// Methods
  syntax RhoSet ::= "#keys" RhoMap                    [function]
                  | RhoSet "#union" RhoSet            [function]

  syntax RhoList ::= "#slice(" RhoList "," Int "," Int ")" [function]
                   | "#truncate(" RhoList "," Int ")"      [function]

// Predicates
  syntax   Bool ::= Int   "#in" RhoTuple      [function]
                  | Name  "#in" Name          [function]
                  | Name  "#in" Names         [function]
                  | Bind  "#in" "(" Bind  ")" [function]
                  | Bind  "#in" "(" Binds ")" [function]
                  | Binds "#in" "(" Binds ")" [function]
                  | Proc  "#in_keys" RhoMap   [function]
                  | Proc  "#in_set"  RhoSet   [function]
/*
  syntax    Map ::= "#lisMap(" SingleRec ")"          [function]
                  | "#lisMap(" AnyBind   ")"          [function]
                  | "#lisMap(" Name  ";" Int ")"      [function]
                  | "#lisMap(" Names ";" Int ")"      [function]
                  | "#msgMap(" Send ")"               [function]
                  | "#msgMap(" Proc  ";" Int ")"      [function]
                  | "#msgMap(" Procs ";" Int ")"      [function]

  syntax   Maps ::= "#lisMap" "(" MultiRec ")"        [function]
                  | "#lisMap" "(" AnyBinds ")"        [function]
                  | "#mapify(" Names ";" Names ")"    [function]
*/

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= Int | Name | Names | Proc | Procs

// Sends
  rule #chan( N:Name !  ( ) ) => N
  rule #chan( N:Name !  ( _:Proc  ) ) => N
  rule #chan( N:Name !  ( _:Procs ) ) => N
  rule #chan( N:Name !! ( ) ) => N
  rule #chan( N:Name !! ( _:Proc  ) ) => N
  rule #chan( N:Name !! ( _:Procs ) ) => N

  rule #msg( _:Name !  ( ) ) => EmptyP
  rule #msg( _:Name !  ( P:Proc  ) ) => P
  rule #msg( _:Name !  ( P:Procs ) ) => P
  rule #msg( _:Name !! ( ) ) => EmptyP
  rule #msg( _:Name !! ( P:Proc  ) ) => P
  rule #msg( _:Name !! ( P:Procs ) ) => P
  
  rule #msglen( S:Send ) => #length(#msg(S))

  rule #stype( _:ConsumableSend   ) => 0
  rule #stype( _:UnconsumableSend ) => 1

// Receives
  rule #bind( for ( B:Bind  ){ _:Proc } ) => B
  rule #bind( for ( B:Binds ){ _:Proc } ) => B
  rule #bind( for ( B:Bind  _:Guard ){ _:Proc } ) => B
  rule #bind( for ( B:Binds _:Guard ){ _:Proc } ) => B

  rule #bvar( for ( B:Bind  ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Binds ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Bind  _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar( for ( B:Binds _:Guard ){ _:Proc } ) => #bvar(B)

  rule #chan( for ( B:Bind  ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Binds ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Bind  _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan( for ( B:Binds _:Guard ){ _:Proc } ) => #chan(B)

  rule #cont( for ( _:Bind  ){ P:Proc } ) => P
  rule #cont( for ( _:Binds ){ P:Proc } ) => P
  rule #cont( for ( _:Bind  _:Guard ){ P:Proc } ) => P
  rule #cont( for ( _:Binds _:Guard ){ P:Proc } ) => P

  rule #bnum( for ( B:Bind  ){ _:Proc } ) => #bnum(B)
  rule #bnum( for ( B:Binds ){ _:Proc } ) => #length(B)
  rule #bnum( for ( B:Bind  _:Guard ){ _:Proc } ) => #bnum(B)
  rule #bnum( for ( B:Binds _:Guard ){ _:Proc } ) => #length(B)

// receive types - receive
  rule #rtype( for ( _:Lbind  ){ _:Proc } ) => 0
  rule #rtype( for ( _:Lbinds ){ _:Proc } ) => 0
  rule #rtype( for ( _:Lbind  _:Guard ){ _:Proc } ) => 0
  rule #rtype( for ( _:Lbinds _:Guard ){ _:Proc } ) => 0
  rule #rtype( for ( _:Rbind  ){ _:Proc } ) => 1
  rule #rtype( for ( _:Rbinds ){ _:Proc } ) => 1
  rule #rtype( for ( _:Rbind  _:Guard ){ _:Proc } ) => 1
  rule #rtype( for ( _:Rbinds _:Guard ){ _:Proc } ) => 1
  rule #rtype( for ( _:Pbind  ){ _:Proc } ) => 2
  rule #rtype( for ( _:Pbinds ){ _:Proc } ) => 2
  rule #rtype( for ( _:Pbind  _:Guard ){ _:Proc } ) => 2
  rule #rtype( for ( _:Pbinds _:Guard ){ _:Proc } ) => 2

  rule #rtype( _:Lbind  ) => 0
  rule #rtype( _:Lbinds ) => 0
  rule #rtype( _:Lbind  _:Guard ) => 0
  rule #rtype( _:Lbinds _:Guard ) => 0
  rule #rtype( _:Rbind  ) => 1
  rule #rtype( _:Rbinds ) => 1
  rule #rtype( _:Rbind  _:Guard ) => 1
  rule #rtype( _:Rbinds _:Guard ) => 1
  rule #rtype( _:Pbind  ) => 2
  rule #rtype( _:Pbinds ) => 2
  rule #rtype( _:Pbind  _:Guard ) => 2
  rule #rtype( _:Pbinds _:Guard ) => 2

// Guards
  rule #guard( for( _:Bind  ){ _:Proc } ) => true
  rule #guard( for( _:Binds ){ _:Proc } ) => true
  rule #guard( for( _:Bind  if B:BExp ){ _:Proc } ) => B
  rule #guard( for( _:Binds if B:BExp ){ _:Proc } ) => B

/* these are not as useful as I had originally hoped...
// Listen maps
  // maps location to listening variable/name
  rule #lisMap( R:SingleRec ) => #lisMap(#bvar(R);0)
//  rule #lisMap( B:Bind ) => #lisMap(#bvar(B);0)
  rule #lisMap( A:Name ; I:Int ) => I |-> A
  rule #lisMap( A:Name , B:Name  ; I:Int ) => I |-> A #lisMap(B;I +Int 1)
  rule #lisMap( A:Name , B:Names ; I:Int ) => I |-> A #lisMap(B;I +Int 1)

// Message maps
  rule #msgMap( S:Send ) => #msgMap(#msg(S);0)
  rule #msgMap( A:Proc ; I:Int ) => $I |-> @A
  rule #msgMap( A:Proc , B:Proc  ; I:Int ) => I |-> @A #msgMap(B;I +Int 1)
  rule #msgMap( A:Proc , B:Procs ; I:Int ) => I |-> @A #msgMap(B;I +Int 1)

  // not sure how to handle multiple listen receives yet...
  rule #lisMap( for( B:Binds ){ _:Proc } ) => #lisMap(B)
  rule #lisMap( A:Lbind ; B:Lbind  ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #lisMap(B))
  rule #lisMap( A:Lbind ; B:Lbinds ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #lisMap(B))
  rule #lisMap( A:Pbind ; B:Pbind  ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #lisMap(B))
  rule #lisMap( A:Pbind ; B:Pbinds ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #lisMap(B))
  rule #lisMap( A:Rbind ; B:Rbind  ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #lisMap(B))
  rule #lisMap( A:Rbind ; B:Rbinds ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #lisMap(B))
*/
//---------------
//--- #append ---
//---------------
  rule #append( A:Name           ; B:Name  ) => A,B
  rule #append( A:Name , B:Name  ; C:Name  ) => A,#append(B;C)
  rule #append( A:Name , B:Names ; C:Name  ) => A,#append(B;C)
  rule #append( A:Name           ; B:Names ) => A,B
  rule #append( A:Name , B:Name  ; C:Names ) => A,#append(B;C)
  rule #append( A:Name , B:Names ; C:Names ) => A,#append(B;C)

  rule #append( A:Proc           ; B:Proc  ) => A,B
  rule #append( A:Proc , B:Proc  ; C:Proc  ) => A,#append(B;C)
  rule #append( A:Proc , B:Procs ; C:Proc  ) => A,#append(B;C)
  rule #append( A:Proc           ; B:Procs ) => A,B
  rule #append( A:Proc , B:Proc  ; C:Procs ) => A,#append(B;C)
  rule #append( A:Proc , B:Procs ; C:Procs ) => A,#append(B;C)

//-------------
//--- #bind ---
//-------------
// Reconstruct listen from listen info
/*  rule #bind ( A:Name ; B:Name  ;; 0 ) => B <- A
  rule #bind ( A:Name ; B:Names ;; 0 ) => B <- A
  rule #bind ( A:Name ; B:Name  ;; 1 ) => B <= A
  rule #bind ( A:Name ; B:Names ;; 1 ) => B <= A
  rule #bind ( A:Name ; B:Name  ;; 2 ) => B <! A
  rule #bind ( A:Name ; B:Names ;; 2 ) => B <! A
*/
//-----------
//--- #in ---
//-----------
// Int #in RhoTuple
  rule A:Int #in ( B:Int           ) => A ==Int B
  rule A:Int #in ( B:Int , C:Int   ) => A ==Int B orBool A ==Int C
  rule A:Int #in ( B:Int , C:Procs ) => A ==Int B orBool A #in (C)

// Name #in Names
  rule _:Name #in EmptyN => false
  rule A:Name #in B:Name           => A ==K B requires B =/=K EmptyN
  rule A:Name #in B:Name , C:Name  => A ==K B orBool A ==K C
  rule A:Name #in B:Name , C:Names => A ==K B orBool A #in C

//------------
//--- #dec ---
//------------
// New name declarations
  rule #dec( new A:Name  in { _:Proc } ) => A
  rule #dec( new A:Names in { _:Proc } ) => A

//-------------
//--- #size ---
//-------------
  rule #size Set( ) => 0
  rule #size Set( P:Proc  ) => #length(P)
  rule #size Set( P:Procs ) => #length(P)
  
  rule #size { }:RhoMap => 0
  rule #size { _:Proc : _:Proc } => 1
  rule #size { _:Proc : _:Proc , _:RhoKVPair  } => 2
  rule #size { _:Proc : _:Proc , R:RhoKVPairs } => 1 +Int #size {R}

//---------------
//--- #length ---
//---------------
// Procs
  rule #length( EmptyP ) => 0
  rule #length( A:Proc ) => 1 requires A =/=K EmptyP
  rule #length( _:Proc , _:Proc  ) => 2
  rule #length( _:Proc , P:Procs ) => 1 +Int #length(P)

// RhoList
  rule #length [ ] => 0
  rule #length [ P:Proc  ] => #length(P)
  rule #length [ P:Procs ] => #length(P)

// Name(s)
  rule #length( EmptyN ) => 0
  rule #length( A:Name ) => 1 requires A =/=K EmptyN
  rule #length( _:Name , _:Name  ) => 2
  rule #length( _:Name , N:Names ) => 1 +Int #length(N)

//--- Binds ---
// Binds - number of listens in a join
  rule #length( _:Lbind ; _:Lbind  ) => 2
  rule #length( _:Lbind ; C:Lbinds ) => 1 +Int #length(C)

  rule #length( _:Rbind ; _:Rbind  ) => 2
  rule #length( _:Rbind ; C:Rbinds ) => 1 +Int #length(C)

  rule #length( _:Pbind ; _:Pbind  ) => 2
  rule #length( _:Pbind ; C:Pbinds ) => 1 +Int #length(C)
  
  rule #length( B:Binds _:Guard ) => #length(B)

//----------------
//--- #lengths ---
//----------------
// Binds
  rule #lengths( B:Lbind ; C:Lbind  ) => #bnum(B) , #bnum(C)
  rule #lengths( B:Lbind ; C:Lbinds ) => #bnum(B) , #lengths(C)

  rule #lengths( B:Rbind ; C:Rbind  ) => #bnum(B) , #bnum(C)
  rule #lengths( B:Rbind ; C:Rbinds ) => #bnum(B) , #lengths(C)

  rule #lengths( B:Pbind ; C:Pbind  ) => #bnum(B) , #bnum(C)
  rule #lengths( B:Pbind ; C:Pbinds ) => #bnum(B) , #lengths(C)

//-------------
//--- #chan ---
//-------------
// Bind
  rule #chan(         <- N:Name ) => N
  rule #chan( _:Name  <- N:Name ) => N
  rule #chan( _:Names <- N:Name ) => N
  rule #chan(         <= N:Name ) => N
  rule #chan( _:Name  <= N:Name ) => N
  rule #chan( _:Names <= N:Name ) => N
  rule #chan(         <! N:Name ) => N
  rule #chan( _:Name  <! N:Name ) => N
  rule #chan( _:Names <! N:Name ) => N
  
  rule #chan( B:Bind _:Guard ) => #chan (B)

// comma-separated list of channels involved in bindings
  rule #chan( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Lbind ; C:Lbinds ) => #chan(B) , #chan(C)

  rule #chan( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind ; C:Rbinds ) => #chan(B) , #chan(C)

  rule #chan( B:Pbind ; C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind ; C:Pbinds ) => #chan(B) , #chan(C)
  
  rule #chan( B:Binds _:Guard ) => #chan (B)

//-------------
//--- #bnum ---
//-------------
// number of binding variables in a listen
  rule #bnum(         <- N:Name ) => 0
  rule #bnum( _:Name  <- _:Name ) => 1
  rule #bnum( N:Names <- _:Name ) => #length(N)
  rule #bnum(         <= N:Name ) => 0
  rule #bnum( _:Name  <= _:Name ) => 1
  rule #bnum( N:Names <= _:Name ) => #length(N)
  rule #bnum(         <! N:Name ) => 0
  rule #bnum( _:Name  <! _:Name ) => 1
  rule #bnum( N:Names <! _:Name ) => #length(N)
  
  rule #bnum( B:Bind _:Guard ) => #bnum(B)

//-------------
//--- #bvar ---
//-------------
// binding variables
  rule #bvar(         <- N:Name ) => EmptyN
  rule #bvar( N:Name  <- _:Name ) => N
  rule #bvar( N:Names <- _:Name ) => N
  rule #bvar(         <= N:Name ) => EmptyN
  rule #bvar( N:Name  <= _:Name ) => N
  rule #bvar( N:Names <= _:Name ) => N
  rule #bvar(         <! N:Name ) => EmptyN
  rule #bvar( N:Name  <! _:Name ) => N
  rule #bvar( N:Names <! _:Name ) => N
  
  rule #bvar( B:Bind _:Guard ) => #bvar(B)

  // multiple bindings -- TODO: is this right?
  rule #bvar( B:Lbind ; C:Lbind  ) => #bvar(B) , #bvar(C)
  rule #bvar( B:Lbind ; C:Lbinds ) => #bvar(B) , #bvar(C)

  rule #bvar( B:Rbind ; C:Rbind  ) => #bvar(B) , #bvar(C)
  rule #bvar( B:Rbind ; C:Rbinds ) => #bvar(B) , #bvar(C)

  rule #bvar( B:Pbind ; C:Pbind  ) => #bvar(B) , #bvar(C)
  rule #bvar( B:Pbind ; C:Pbinds ) => #bvar(B) , #bvar(C)
  
  rule #bvar( B:Binds _:Guard ) => #bvar(B)
  
//---------------
//--- #quotes ---  
//---------------
  rule #quotes( A:Proc , B:Proc  ) => @A , @B
  rule #quotes( A:Proc , B:Procs ) => @A , #quotes(B)

// #interpolate
  rule #interpolate( S:String ; { A:String : B:String } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)),                                  
                substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)), B) // this part substitutes B for A
          +String substrString(S,findChar(S,"}",0) +Int 1, lengthString(S))
          #else S
          #fi
  rule #interpolate( S:String ; { A:String : B:String , KV:RhoKVPair } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)) ==String A
          #then substrString(S,0,findString(S,"${",0)) +String
                replaceAll(substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)),
                substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)), B) +String
                substrString(S,findChar(S,"}",0) +Int 1, lengthString(S))
          #else #interpolate(S;{KV})
          #fi
  rule #interpolate( S:String ; { A:String : B:String , KVs:RhoKVPairs } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)) ==String A
          #then substrString(S,0,findString(S,"${",0)) +String
                replaceAll(substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)),
                substrString(S,findString(S,"${",0) +Int 2,findChar(S,"}",0)), B) +String
                substrString(S,findChar(S,"}",0) +Int 1, lengthString(S))
          #else #interpolate(S;{KVs})
          #fi
  // if key is not a string, bypass it
  rule #interpolate(S:String ; { A:Proc : _:Proc ,  KV:RhoKVPair  } ) => #interpolate(S;{KV})  requires notBool isString(A)
  rule #interpolate(S:String ; { A:Proc : _:Proc , KVs:RhoKVPairs } ) => #interpolate(S;{KVs}) requires notBool isString(A)
  // if all else fails, return the original string
  rule #interpolate(S:String ; _:RhoMap ) => S [owise]

//------------------
//--- Predicates ---
//------------------
// Maps
  rule _:Proc #in_keys { }:RhoMap => false
  rule A:Proc #in_keys { Key:Proc : Val:Proc } => A ==K Key
  rule A:Proc #in_keys { Key:Proc : Val:Proc , KV:RhoKVPair   } => A ==K Key orBool A #in_keys { KV  }
  rule A:Proc #in_keys { Key:Proc : Val:Proc , KVs:RhoKVPairs } => A ==K Key orBool A #in_keys { KVs }
  
// Sets
  rule _:Proc #in_set Set( ) => false
  rule A:Proc #in_set Set( Elm:Proc ) => A ==K Elm
  rule A:Proc #in_set Set( Elm1:Proc , Elm2:Proc  ) => A ==K Elm1 orBool A ==K Elm2
  rule A:Proc #in_set Set( Elm1:Proc , Rest:Procs ) => A ==K Elm1 orBool A #in_set Set( Rest )

/*
// Methods
//--------------
//--- #slice ---
//--------------
  rule #truncate( R:RhoList , Fin:Int ) => R requires (Fin >=Int #length R)
  rule #truncate( [ A:Proc ] , Fin:Int ) => #if Fin <=Int 0 #then [ ] #else [A] #fi

  rule #slice( [ ] , _ , _ ) => [ ]
  rule #slice( [ A:Proc ] , St:Int , Fin:Int ) => #if ( St ==Int 0 andBool Fin ==Int 0 ) #then [A] #else [ ] #fi
  rule #slice( [ A:Proc ] , St:Int , Fin:Int ) => #if ( St ==Int 0 andBool Fin ==Int 0 ) #then [A] #else [ ] #fi
  
//-------------
//--- #keys ---
//-------------
  rule #keys { }:RhoMap => Set( )
  rule #keys { A:Proc : _:Proc } => Set( A )
  rule #keys { A:Proc : _:Proc , B:Proc : _:Proc } => Set( A , B )
  rule #keys { A:Proc : _:Proc , R:RhoKVPairs } => SetItem(A) #keys {R}

//--------------
//--- #union ---
//--------------
  rule Set( ) #union S:RhoSet => S
  rule S:RhoSet #union Set( ) => S
  rule Set( A:Proc ) #union Set( B:Proc ) => #if A ==K B #then Set( A ) #else Set( A , B ) #fi
  rule Set( A:Proc ) #union Set( B:Proc , C:Proc ) => #if A ==K B
*/

endmodule