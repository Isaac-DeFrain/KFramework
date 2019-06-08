// Auxilary functions for GRHO configuration

/*
TODO:
 - #toK( RhoList/RhoMap/RhoSet ) => List/Map/Set to utilize builtin functionality for methods
 - #fromK( List/Map/Set ) => RhoList/RhoMap/RhoSet

 - #length( RhoKVPairs ), #length( ConcatExp ), & #length( InterpMaps )
*/

require "../grho.k"
require "../AlphaEquiv/alpha.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

// Length of object lists
  syntax    Int ::= "#length(" Name     ")" [function]
                  | "#length(" Names    ")" [function]
                  | "#length(" Proc     ")" [function]
                  | "#length(" Procs    ")" [function]
                  | "#length(" AnyBinds ")" [function]
  syntax    Int ::=   "#size(" RhoMap   ")" [function]
                  |   "#size(" RhoSet   ")" [function]
                  | "#length(" RhoList  ")" [function]
                  | "#length(" RhoTuple ")" [function]

// Send/Rec classification & destructuring
  syntax    Int ::= "#msglen(" Send     ")" [function]  // #msglen(_): Send -------------------> Int
                  | "#lislen(" AnyBind  ")" [function]  // #lislen(_): AnyBind ----------------> Int
                  | "#lislen(" Receive  ")" [function]  // #lislen(_): Receive ----------------> Int
                  |  "#stype(" Send     ")" [function]  //  #stype(_): Send -------------------> Int
                  |  "#rtype(" AnyBind  ")" [function]  //  #rtype(_): AnyBind ----------------> Int
                  |  "#rtype(" AnyBinds ")" [function]  //  #rtype(_): AnyBinds ---------------> Int
                  |  "#rtype(" Receive  ")" [function]  //  #rtype(_): Receive ----------------> Int

  syntax   Bind ::= "#bind(" Receive ")" [function]  // #bind(_): Receive --------> Bind
  syntax  Binds ::= "#bind(" Receive ")" [function]  // #bind(_): Receive --------> Binds

  syntax   Proc ::= "#cont(" Receive ")" [function, poly(0,1)]  // #cont(_): Receive --------> Proc
                  |  "#msg(" Send    ")" [function, poly(0,1)]  // #msg(_): Send ------------> Proc
  syntax  Procs ::=  "#msg(" Send    ")" [function]  // #msg(_): Send ------------> Procs

  syntax  Procs ::= "#lengths(" AnyBinds ")"        [function]  // #length(_): AnyBinds -----> Procs
                  |  "#append(" Proc  ";" Proc  ")" [function]  // #append(_;_): Proc  x Proc ---------> Procs
                  |  "#append(" Procs ";" Proc  ")" [function]  // #append(_;_): Procs x Proc ---------> Procs
                  |  "#append(" Proc  ";" Procs ")" [function]  // #append(_;_): Proc  x Procs --------> Procs
                  |  "#append(" Procs ";" Procs ")" [function]  // #append(_;_): Procs x Procs --------> Procs

  syntax   Name ::= "#chan(" Send    ")"  [function]  // #chan(_): Send -------> Name
                  | "#chan(" Receive ")"  [function]  // #chan(_): Receive ----> Name
                  | "#chan(" AnyBind ")"  [function]  // #chan(_): AnyBind ----> Name
                  | "#bvar(" AnyBind ")"  [function]  // #bvar(_): AnyBind ----> Name
                  | "#bvar(" Receive ")"  [function]  // #bvar(_): Receive ----> Name
                  |  "#dec(" New     ")"  [function]
  syntax  Names ::= "#chan(" AnyBinds ")" [function]  // #chan(_): AnyBinds ---> Names
                  | "#chan(" Receive  ")" [function]  // #chan(_): Receive ----> Names
                  | "#bvar(" AnyBind  ")" [function]  // #bvar(_): AnyBind  ---> Names
                  | "#bvar(" AnyBinds ")" [function]  // #bvar(_): AnyBinds ---> Names
                  | "#bvar(" Receive  ")" [function]  // #bvar(_): Receive ----> Names
                  |  "#dec(" New      ")" [function]
  // Input Guards
  syntax   BExp ::= "#guard(" Receive ")" [function]


  syntax  Procs ::= "#par2procs(" Par ")" [function]

  syntax  Names ::= "#quotes(" Procs ")"           [function]  //   #quotes(_): Procs ------> Names
                  | "#append(" Name  ";" Name  ")" [function]
                  | "#append(" Names ";" Name  ")" [function]
                  | "#append(" Name  ";" Names ")" [function]
                  | "#append(" Names ";" Names ")" [function]

  syntax RhoKVPairs ::= "#append(" RhoKVPair  ";" RhoKVPair  ")" [function]
                      | "#append(" RhoKVPairs ";" RhoKVPair  ")" [function]
                      | "#append(" RhoKVPair  ";" RhoKVPairs ")" [function]
                      | "#append(" RhoKVPairs ";" RhoKVPairs ")" [function]

// Methods
  syntax RhoSet ::=  "#keys(" RhoMap ")"            [function]
                  | "#union(" RhoSet ";" RhoSet ")" [function]

  syntax RhoList ::=    "#slice(" RhoList "," Int "," Int ")" [function]
                   | "#truncate(" RhoList "," Int ")"         [function]

// Substitution
  syntax    Map ::= "#mapSub(" Set ")" [function]

// Par Normalization
  syntax   Proc ::=   "#normPar(" Proc ")"          [function, poly(0,1)]
                  |   "#set2Par(" Set  ")"          [function]
                  | "#removePar(" Proc ";" Proc ")" [function]
                  |    "#parDup(" Proc ";" Int  ")" [function]
  syntax    Set ::=   "#par2Set(" Proc ")"          [function]
  syntax    Int ::=  "#countPar(" Proc ";" Proc ")" [function]

// String Interpolation
  syntax String ::= "#interpolate(" String ";" RhoMap ")" [function]

// De Bruijn indexing
  syntax  Proc ::= "#val2Key(" Proc ";" Map ")" [function]
  syntax  Name ::= "#val2Key(" Name ";" Map ")" [function]

// Predicates
  syntax   Bool ::= Int   "#in"  "(" Procs ")" [function]
                  | Int   "#in"  "(" Proc  ")" [function]
                  | Name  "#in"  "(" Names ")" [function]
                  | Name  "#in"  "(" Name  ")" [function]
                  | Bind  "#in"  "(" Bind  ")" [function]
                  | Bind  "#in"  "(" Binds ")" [function]
                  | Binds "#in"  "(" Binds ")" [function]
                  | Proc  "#in_keys" RhoMap    [function]
                  | Proc  "#in_set"  RhoSet    [function]

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

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

  rule #lislen( for ( B:Bind  ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:Binds ){ _:Proc } ) => #length(B)
  rule #lislen( for ( B:Bind  _:Guard ){ _:Proc } ) => #lislen(B)
  rule #lislen( for ( B:Binds _:Guard ){ _:Proc } ) => #length(B)

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
  // Names
  rule #append( A:Name           ; B:Name  ) => A,B
  rule #append( A:Name , B:Name  ; C:Name  ) => A,#append(B;C)
  rule #append( A:Name , B:Names ; C:Name  ) => A,#append(B;C)
  rule #append( A:Name           ; B:Names ) => A,B
  rule #append( A:Name , B:Name  ; C:Names ) => A,#append(B;C)
  rule #append( A:Name , B:Names ; C:Names ) => A,#append(B;C)

  // Procs
  rule #append( A:Proc           ; B:Proc  ) => A,B
  rule #append( A:Proc , B:Proc  ; C:Proc  ) => A,#append(B;C)
  rule #append( A:Proc , B:Procs ; C:Proc  ) => A,#append(B;C)
  rule #append( A:Proc           ; B:Procs ) => A,B
  rule #append( A:Proc , B:Proc  ; C:Procs ) => A,#append(B;C)
  rule #append( A:Proc , B:Procs ; C:Procs ) => A,#append(B;C)

  // RhoKVPairs
  rule #append( A:RhoKVPair ; B:RhoKVPair  ) => A,B
  rule #append( A:RhoKVPair ; B:RhoKVPairs ) => A,B
  rule #append( A:RhoKVPair , B:RhoKVPair  ; C:RhoKVPair  ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair  ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPair  ; C:RhoKVPairs ) => A,#append(B;C)
  rule #append( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPairs ) => A,#append(B;C)
//-------------
//--- #bind ---
//-------------
// Reconstruct listen from listen info
/*
  rule #bind ( A:Name ; B:Name  ;; 0 ) => B <- A
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
  rule _:Name #in ( EmptyN           ) => false
  rule A:Name #in ( B:Name           ) => A ==K B requires B =/=K EmptyN
  rule A:Name #in ( B:Name , C:Name  ) => A ==K B orBool A ==K C
  rule A:Name #in ( B:Name , C:Names ) => A ==K B orBool A #in (C)

//------------
//--- #dec ---
//------------
// New name declarations
  rule #dec( new A:Name  in { _:Proc } ) => A
  rule #dec( new A:Names in { _:Proc } ) => A

//-------------
//--- #size ---
//-------------
  rule #size( Set( ) ) => 0
  rule #size( Set( P:Proc  ) ) => #length(P)
  rule #size( Set( P:Procs ) ) => #length(P)
  
  rule #size( { } ) => 0
  rule #size( { _:Proc : _:Proc } ) => 1
  rule #size( { _:Proc : _:Proc , _:RhoKVPair  } ) => 2
  rule #size( { _:Proc : _:Proc , R:RhoKVPairs } ) => 1 +Int #size({R})

//---------------
//--- #length ---
//---------------
// Procs
  rule #length( EmptyP ) => 0
  rule #length( A:Proc ) => 1 requires A =/=K EmptyP
  rule #length( _:Proc , _:Proc  ) => 2
  rule #length( _:Proc , P:Procs ) => 1 +Int #length(P)

// RhoList
  rule #length( [ ] ) => 0
  rule #length( [ P:Proc  ] ) => #length(P)
  rule #length( [ P:Procs ] ) => #length(P)

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
  rule #lengths( B:Lbind ; C:Lbind  ) => #lislen(B) , #lislen(C)
  rule #lengths( B:Lbind ; C:Lbinds ) => #lislen(B) , #lengths(C)

  rule #lengths( B:Rbind ; C:Rbind  ) => #lislen(B) , #lislen(C)
  rule #lengths( B:Rbind ; C:Rbinds ) => #lislen(B) , #lengths(C)

  rule #lengths( B:Pbind ; C:Pbind  ) => #lislen(B) , #lislen(C)
  rule #lengths( B:Pbind ; C:Pbinds ) => #lislen(B) , #lengths(C)

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
  
  rule #chan( B:Bind _:Guard ) => #chan(B)

// comma-separated list of channels involved in bindings
  rule #chan( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Lbind ; C:Lbinds ) => #chan(B) , #chan(C)

  rule #chan( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Rbind ; C:Rbinds ) => #chan(B) , #chan(C)

  rule #chan( B:Pbind ; C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan( B:Pbind ; C:Pbinds ) => #chan(B) , #chan(C)
  
  rule #chan( B:Binds _:Guard ) => #chan(B)

//-------------
//--- #lislen ---
//-------------
// number of binding variables in a listen
  rule #lislen(         <- N:Name ) => 0
  rule #lislen( _:Name  <- _:Name ) => 1
  rule #lislen( N:Names <- _:Name ) => #length(N)
  rule #lislen(         <= N:Name ) => 0
  rule #lislen( _:Name  <= _:Name ) => 1
  rule #lislen( N:Names <= _:Name ) => #length(N)
  rule #lislen(         <! N:Name ) => 0
  rule #lislen( _:Name  <! _:Name ) => 1
  rule #lislen( N:Names <! _:Name ) => #length(N)
  
  rule #lislen( B:Bind _:Guard ) => #lislen(B)

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

  // multiple bindings
  rule #bvar( B:Lbind ; C:Lbind  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Lbind ; C:Lbinds ) => #append(#bvar(B);#bvar(C))

  rule #bvar( B:Rbind ; C:Rbind  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Rbind ; C:Rbinds ) => #append(#bvar(B);#bvar(C))

  rule #bvar( B:Pbind ; C:Pbind  ) => #append(#bvar(B);#bvar(C))
  rule #bvar( B:Pbind ; C:Pbinds ) => #append(#bvar(B);#bvar(C))
  
  rule #bvar( B:Binds _:Guard ) => #bvar(B)
  
//---------------
//--- #quotes ---  
//---------------
  rule #quotes( A:Proc , B:Proc  ) => @A , @B
  rule #quotes( A:Proc , B:Procs ) => @A , #quotes(B)

//--------------------
//--- #interpolate ---
//--------------------
  // substitutes string in first occurrence of ${...} and ignores all } before ${
  rule #interpolate( S:String ; { A:String : B:String } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)),                                  
                substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)), B) // this part substitutes B for A
          +String substrString(S,findString(S,"}",findString(S,"${",0) +Int 2) +Int 1, lengthString(S))
          #else S
          #fi
  rule #interpolate( S:String ; { A:String : B:String , KV:RhoKVPair } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)),                                  
                substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)), B) // this part substitutes B for A
          +String substrString(S,findString(S,"}",findString(S,"${",0) +Int 2) +Int 1, lengthString(S))
          #else #interpolate(S;{KV})
          #fi
  rule #interpolate( S:String ; { A:String : B:String , KVs:RhoKVPairs } )
       => #if substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)) ==String A
          #then substrString(S,0,findString(S,"${",0)) // this part extracts A from original string
          +String replaceAll(substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)),                                  
                substrString(S,findString(S,"${",0) +Int 2,findString(S,"}",findString(S,"${",0) +Int 2)), B) // this part substitutes B for A
          +String substrString(S,findString(S,"}",findString(S,"${",0) +Int 2) +Int 1, lengthString(S))
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

//---------------
//--- #mapSub ---
//---------------
  rule #mapSub( .Set ) => .Map
  rule #mapSub( SetItem( A:Name ) S:Set ) => A |-> @sub #mapSub(S)
  rule #mapSub( SetItem( A:Proc ) S:Set ) => A |->  sub #mapSub(S)

//------------------
//--- #normPar ---
//------------------
  rule #normPar( A:Proc ) => A requires notBool isPar(A)
  rule #normPar( A:Par  ) => #set2Par(#par2Set(A))

// Essentially identical to functions in STRUCT except that #par2Set does not delete Nil from the Par
// counts appearances in Par
  // nonPar Proc
  rule #countPar( A:Proc ; B:Proc ) => #if A ==K B #then 1 #else 0 #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #countPar( A:Proc ; B:Proc | C:Proc ) => #if A ==K B #then 1 +Int #countPar(A;C) #else #countPar(A;C) #fi
       requires notBool isPar(B)

// removes a nonPar Proc from a Par and preserves order
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #removePar( A:Proc ; B:Proc ) => #if A ==K B #then .K #else B #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #removePar( A:Proc ; B:Proc | C:Proc ) => #if A ==K B #then #removePar(A;C) #else B | #removePar(A;C) #fi
       requires notBool isPar(B)

// computes Par Set of a Proc
  // par set of a nonPar Proc contains only one appearance of that Proc
  rule #par2Set( A:Proc ) => SetItem(A,1) requires notBool isPar(A)
  rule #par2Set( A:Proc | B:Proc ) 
    => #if #countPar(A;B) >Int 0
       #then SetItem(A, 1 +Int #countPar(A;B)) #par2Set(#removePar(A;B))
       #else SetItem(A,1) #par2Set(B)
       #fi requires notBool isPar(A)

  // duplicator
  rule #parDup( A:Proc ; 1 ) => A
  rule #parDup( A:Proc ; N:Int ) => A | #parDup(A;N -Int 1) requires N >Int 1

  // turns Set into normPard Par
  rule #set2Par( SetItem( A:Proc , N:Int )  .Set ) => #parDup(A;N)
  rule #set2Par( SetItem( A:Proc , N:Int ) S:Set ) => #parDup(A;N) | #set2Par( S ) requires notBool S <=Set .Set

//----------------
//--- #val2Key ---
//----------------
// requires each KV pair of the form: Proc |-> Proc or Name |-> Name & requested value uniquely in values(Map)
  rule #val2Key( A:Proc ; B:Proc |-> A _:Map ) => B // if value matches, return key
  rule #val2Key( A:Proc ; _:Proc |-> C:Proc M:Map ) => #val2Key(A;M) requires A =/=K C // if value doesn't match, traverse map
  rule #val2Key( A:Proc ; _:Name |-> _:Name M:Map ) => #val2Key(A;M) // if value has wrong type, traverse map

  rule #val2Key( A:Name ; B:Name |-> A _:Map ) => B // if value matches, return key
  rule #val2Key( A:Name ; _:Name |-> C:Name M:Map ) => #val2Key(A;M) requires A =/=K C // if value doesn't match, traverse map
  rule #val2Key( A:Name ; _:Proc |-> _:Proc M:Map ) => #val2Key(A;M) // if value has wrong type, traverse map

//------------------
//--- #par2procs ---
//------------------
  rule #par2procs( A:Proc | B:Proc ) => A,B requires notBool (isPar(A) orBool isPar(B))
  rule #par2procs( A:Proc | B:Par  ) => A,#par2procs(B) requires notBool isPar(A)

endmodule