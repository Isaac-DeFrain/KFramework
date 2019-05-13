// Auxilary functions for GRHO configuration

requires "../grho.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

  syntax    Int ::= "#length"     RhoTuple         [function]  //    #length: RhoTuple ---------------> Int
                  | "#length"     Name             [function]  //    #length: Name -------------------> Int
                  | "#length"     Names            [function]  //    #length: Names ------------------> Int
                  | "#length" "(" Binds    ")"     [function]  // #length(_): Binds ------------------> Int
                  | "#length" "(" GuardedBinds ")" [function]  // #length(_): GuardedBinds -----------> Int
                  | "#bnum"   "(" Bind     ")"     [function]  //   #bnum(_): Bind -------------------> Int
                  | "#bnum"   "(" GuardedBind  ")" [function]  //   #bnum(_): GuardedBind ------------> Int
                  | "#bnum"   "(" Receive ")"      [function]  //   #bnum(_): Receive ----------------> Int
                  | "#stype"  "(" Send     ")"     [function]  //  #stype(_): Send -------------------> Int
                  | "#rtype"  "(" AnyBinds ")"     [function]  //  #rtype(_): Bind -------------------> Int
                  | "#rtype"  "(" Receive  ")"     [function]  //  #rtype(_): Receive ----------------> Int

  syntax    Int ::= "#size"   RhoMap               [function]  // #size: RhoMap ----------------------> Int
                  | "#size"   RhoSet               [function]  // #size: RhoSet ----------------------> Int
                  | "#length" RhoList              [function]  // #length: RhoList -------------------> Int

  syntax   Bind ::= "#bind" "(" Receive ")"        [function]  // #bind(_): Receive --------> Bind

  syntax  Binds ::= "#bind" "(" Receive ")"        [function]  // #bind(_): Receive --------> Binds

  syntax   Proc ::= "#cont" "(" Receive ")"        [function]  // #cont(_): Receive --------> Proc
                  | "#msg"  "("   Send  ")"        [function]  // #msg(_): Send ------------> Proc

  syntax  Procs ::= "#lengths" "(" Binds ")"          [function]  // #length(_): Binds --------> Procs
                  | "#msg"     "(" Send  ")"          [function]  // #msg(_): Send ------------> Procs
                  | "#append" "(" Proc  ";" Proc  ")" [function]  // #append(_;_): Proc  x Proc ---------> Procs
                  | "#append" "(" Procs ";" Proc  ")" [function]  // #append(_;_): Procs x Proc ---------> Procs
                  | "#append" "(" Proc  ";" Procs ")" [function]  // #append(_;_): Proc  x Procs --------> Procs
                  | "#append" "(" Procs ";" Procs ")" [function]  // #append(_;_): Procs x Procs --------> Procs

  syntax   Name ::= "#chan"   "("   Send  ")"         [function]  //     #chan(_): Send -------> Name
                  | "#chan"   "(" Receive ")"         [function]  //     #chan(_): Receive ----> Name
                  | "#chan"   "("   Bind  ")"         [function]  //     #chan(_): Bind -------> Name
                  | "#chan"   "(" GuardedBind ")"     [function]  //     #chan(_): Bind -------> Name
                  | "#bvar"   "("   Bind  ")"         [function]  //     #bvar(_): Bind -------> Name
                  | "#bvar"   "(" GuardedBind ")"     [function]  //     #bvar(_): Bind -------> Name
                  | "#bvar"   "(" Receive ")"         [function]  //     #bvar(_): Receive ----> Name
                  | "#msg"    "(" Send    ")"         [function]  // #msg(_): Send ------------> Name
                  | "#dec"    "(" New     ")"         [function]

  syntax  Names ::= "#chan"   "("   Binds ")"         [function]  //     #chan(_): Binds ------> Names
                  | "#chan"   "(" GuardedBinds ")"    [function]  //     #chan(_): Binds ------> Names
                  | "#chan"   "(" Receive  ")"        [function]  //     #chan(_): Receive ----> Names
                  | "#bvar"   "(" AnyBinds ")"        [function]  //     #bvar(_): Binds ------> Names
                  | "#bvar"   "(" Receive  ")"        [function]  //     #bvar(_): Receive ----> Names
                  | "#quotes" "(" Procs    ")"        [function]  //   #quotes(_): Procs ------> Names
                  | "#append" "(" Name  ";" Name  ")" [function]
                  | "#append" "(" Names ";" Name  ")" [function]
                  | "#append" "(" Name  ";" Names ")" [function]
                  | "#append" "(" Names ";" Names ")" [function]
                  | "#dec"    "(" New     ")"         [function]

  syntax    Map ::= "#listenmap" "(" SingleRec ")"    [function]
                  | "#listenmap" "(" Bind      ")"    [function]
                  | "#mapify(" Name  ";" Name  ")"    [function]
                  | "#mapify(" Names ";" Name  ")"    [function]

  syntax   Maps ::= "#listenmap" "(" MultiRec  ")"    [function]
                  | "#listenmap" "(" Binds     ")"    [function]
                  | "#mapify(" Names ";" Names ")"    [function]
  
  syntax   BExp ::= "#guard" "(" Receive ")"          [function]

  syntax RhoSet ::= "#keys" RhoMap                    [function]
                  | RhoSet "#union" RhoSet            [function]

  syntax RhoList ::= "#slice(" RhoList "," Int "," Int ")"   [function]
                   | "#truncate(" RhoList "," Int ")"        [function]

  syntax   Bool ::= Int   "#in"      RhoTuple                [function]  // _#in_: Int x RhoTuple ----> Bool
                  | Name  "#in" Name                         [function]  // _#in_: Name x Name  ------> Bool
                  | Name  "#in" Names                        [function]  // _#in_: Name x Names ------> Bool
                  | Bind  "#in"  "(" Bind  ")"               [function]  // _#in_: Bind  x Bind ------> Bool
                  | Bind  "#in"  "(" Binds ")"               [function]  // _#in_: Bind  x Binds -----> Bool
                  | Binds "#in"  "(" Binds ")"               [function]  // _#in_: Binds x Binds -----> Bool
                  | Bind  "#ine" "(" Bind  ")"               [function]  // _#ine_: Bind x Bind ------> Bool
                  | Bind  "#ine" "(" Binds ")"               [function]  // _#ine_: Bind x Binds -----> Bool
                  | Binds "#ine" "(" Binds ")"               [function]  // _#ine_: Binds x Binds ----> Bool
                  | Proc "#in_keys" RhoMap                   [function]
                  | Proc "#in_set"  RhoSet                   [function]
/*
  syntax    Int ::= "#chanmany"  "(" Name     ":" Set   ")"  [function]  // #chanmany(_:_): Name x Set ---------> Int
                  | "#chanmany"  "(" ChanLen  ":" Bind  ")"  [function]  // #chanmany(_:_): ChanLen  x Bind ----> Int
                  | "#chanmany"  "(" ChanLen  ":" Binds ")"  [function]  // #chanmany(_:_): ChanLen  x Binds ---> Int
                  | "#chanmany"  "(" ChanList ":" Bind  ")"  [function]  // #chanmany(_:_): ChanList x Bind ----> Int
                  | "#chanmany"  "(" ChanList ":" Binds ")"  [function]  // #chanmany(_:_): ChanList x Binds ---> Int

  syntax    Set ::= "#chanlen"   "(" Bind  ")"               [function]  //  #chanlen(_): Bind -------> Set
                  | "#chanlen"   "(" Binds ")"               [function]  //  #chanlen(_): Binds ------> Set
                  | "#chanlist"  "(" Bind  ")"               [function]  // #chanlist(_): Bind -------> Set
                  | "#chanlist"  "(" Binds ")"               [function]  // #chanlist(_): Binds ------> Set
                  | "#bindocc"   "(" Bind  ")"               [function]  //  #bindocc(_): Bind -------> Set
                  | "#bindocc"   "(" Binds ")"               [function]  //  #bindocc(_): Binds ------> Set
                  | "#bindocce"  "(" Bind  ")"               [function]  // #bindocce(_): Bind -------> Set
                  | "#bindocce"  "(" Binds ")"               [function]  // #bindocce(_): Binds ------> Set

  syntax   Bind ::= "#bind" "(" BindOcc ")" [function]  // #bind(_): BindOcc --------> Bind
*/
endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= Int | Name

// Sends
  rule #chan  ( N:Name !  _:RhoTuple ) => N
  rule #chan  ( N:Name !! _:RhoTuple ) => N

  rule #msg   ( _:Name !  ( ) ) => EmptyMsg
  rule #msg   ( _:Name !  ( P:Proc     ) ) => P
  rule #msg   ( _:Name !  ( P:Procs    ) ) => P
  rule #msg   ( _:Name !! ( ) ) => EmptyMsg
  rule #msg   ( _:Name !! ( P:Proc     ) ) => P
  rule #msg   ( _:Name !! ( P:Procs    ) ) => P
  
  rule #length( S:Send ) => #length tuple(#msg(S)) requires #msg(S) =/=K EmptyMsg

  rule #stype ( _:Name !  _:RhoTuple ) => 0
  rule #stype ( _:Name !! _:RhoTuple ) => 1

// Receives
  rule #bind  ( for ( B:Bind  ){ _:Proc } ) => B
  rule #bind  ( for ( B:Binds ){ _:Proc } ) => B
  rule #bind  ( for ( B:Bind  _:Guard ){ _:Proc } ) => B
  rule #bind  ( for ( B:Binds _:Guard ){ _:Proc } ) => B

  rule #bvar  ( for ( B:Bind  ){ _:Proc } ) => #bvar(B)
  rule #bvar  ( for ( B:Binds ){ _:Proc } ) => #bvar(B)
  rule #bvar  ( for ( B:Bind  _:Guard ){ _:Proc } ) => #bvar(B)
  rule #bvar  ( for ( B:Binds _:Guard ){ _:Proc } ) => #bvar(B)

  rule #chan  ( for ( B:Bind  ){ _:Proc } ) => #chan(B)
  rule #chan  ( for ( B:Binds ){ _:Proc } ) => #chan(B)
  rule #chan  ( for ( B:Bind  _:Guard ){ _:Proc } ) => #chan(B)
  rule #chan  ( for ( B:Binds _:Guard ){ _:Proc } ) => #chan(B)

  rule #cont  ( for ( _:Bind  ){ P:Proc } ) => P
  rule #cont  ( for ( _:Binds ){ P:Proc } ) => P
  rule #cont  ( for ( _:Bind  _:Guard ){ P:Proc } ) => P
  rule #cont  ( for ( _:Binds _:Guard ){ P:Proc } ) => P

  rule #bnum  ( for ( B:Bind  ){ _:Proc } ) => #bnum(B)
  rule #bnum  ( for ( B:Binds ){ _:Proc } ) => #length(B)
  rule #bnum  ( for ( B:Bind  _:Guard ){ _:Proc } ) => #bnum(B)
  rule #bnum  ( for ( B:Binds _:Guard ){ _:Proc } ) => #length(B)

// receive types - receive
  rule #rtype ( for ( _:Lbind  ){ _:Proc } ) => 0
  rule #rtype ( for ( _:Lbinds ){ _:Proc } ) => 0
  rule #rtype ( for ( _:Lbind  _:Guard ){ _:Proc } ) => 0
  rule #rtype ( for ( _:Lbinds _:Guard ){ _:Proc } ) => 0
  rule #rtype ( for ( _:Rbind  ){ _:Proc } ) => 1
  rule #rtype ( for ( _:Rbinds ){ _:Proc } ) => 1
  rule #rtype ( for ( _:Rbind  _:Guard ){ _:Proc } ) => 1
  rule #rtype ( for ( _:Rbinds _:Guard ){ _:Proc } ) => 1
  rule #rtype ( for ( _:Pbind  ){ _:Proc } ) => 2
  rule #rtype ( for ( _:Pbinds ){ _:Proc } ) => 2
  rule #rtype ( for ( _:Pbind  _:Guard ){ _:Proc } ) => 2
  rule #rtype ( for ( _:Pbinds _:Guard ){ _:Proc } ) => 2

  rule #rtype ( _:Lbind  ) => 0
  rule #rtype ( _:Lbinds ) => 0
  rule #rtype ( _:Lbind  _:Guard ) => 0
  rule #rtype ( _:Lbinds _:Guard ) => 0
  rule #rtype ( _:Rbind  ) => 1
  rule #rtype ( _:Rbinds ) => 1
  rule #rtype ( _:Rbind  _:Guard ) => 1
  rule #rtype ( _:Rbinds _:Guard ) => 1
  rule #rtype ( _:Pbind  ) => 2
  rule #rtype ( _:Pbinds ) => 2
  rule #rtype ( _:Pbind  _:Guard ) => 2
  rule #rtype ( _:Pbinds _:Guard ) => 2

// Guards
  rule #guard ( for( _:Bind  ){ _:Proc } ) => true
  rule #guard ( for( _:Binds ){ _:Proc } ) => true
  rule #guard ( for( _:Bind  if B:BExp ){ _:Proc } ) => B
  rule #guard ( for( _:Binds if B:BExp ){ _:Proc } ) => B
/*
// Listen maps
  rule #listenmap( R:SingleRec ) => #mapify( #bvar(R) ; #chan(R) )
  rule #listenmap( B:Bind ) => #mapify( #bvar(B) ; #chan(B) )
  rule #mapify( A:Name ; B:Name ) => A |-> B
  rule #mapify( A:Name , B:Name  ; C:Name ) => A |-> C #mapify(B;C)
  rule #mapify( A:Name , B:Names ; C:Name ) => A |-> C #mapify(B;C)

  rule #listenmap( for( B:Binds ){ _:Proc } ) => #listenmap(B)
  rule #listenmap( A:Lbind ; B:Lbind  ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #listenmap(B))
  rule #listenmap( A:Lbind ; B:Lbinds ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #listenmap(B))
  rule #listenmap( A:Pbind ; B:Pbind  ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #listenmap(B))
  rule #listenmap( A:Pbind ; B:Pbinds ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #listenmap(B))
  rule #listenmap( A:Rbind ; B:Rbind  ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #listenmap(B))
  rule #listenmap( A:Rbind ; B:Rbinds ) => maps(#mapify( #bvar(A) ; #chan(A) ) , #listenmap(B))
*/
//---------------
//--- #append ---
//---------------
  rule #append ( A:Name           ; B:Name  ) => A,B
  rule #append ( A:Name , B:Name  ; C:Name  ) => A,#append(B;C)
  rule #append ( A:Name , B:Names ; C:Name  ) => A,#append(B;C)
  rule #append ( A:Name           ; B:Names ) => A,B
  rule #append ( A:Name , B:Name  ; C:Names ) => A,#append(B;C)
  rule #append ( A:Name , B:Names ; C:Names ) => A,#append(B;C)

  rule #append ( A:Proc           ; B:Proc  ) => A,B
  rule #append ( A:Proc , B:Proc  ; C:Proc  ) => A,#append(B;C)
  rule #append ( A:Proc , B:Procs ; C:Proc  ) => A,#append(B;C)
  rule #append ( A:Proc           ; B:Procs ) => A,B
  rule #append ( A:Proc , B:Proc  ; C:Procs ) => A,#append(B;C)
  rule #append ( A:Proc , B:Procs ; C:Procs ) => A,#append(B;C)

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
  rule A:Int #in ( B:Int , C:Procs ) => A ==Int B orBool A #in  (C)

// Name #in NameTuple
  rule _:Name #in EmptyMsg => false
  rule A:Name #in B:Name           => A ==K B requires B =/=K EmptyMsg
  rule A:Name #in B:Name , C:Name  => A ==K B orBool A ==K C
  rule A:Name #in B:Name , C:Names => A ==K B orBool A #in C
/*
// Bind(s) #in BindTuple
// checks binding occurence set inclusion
  rule A:Bind  #in  ( B:Bind  ) => #bindocc(A) <=Set #bindocc(B)
  rule A:Bind  #in  ( B:Binds ) => #bindocc(A) <=Set #bindocc(B)
  rule A:Binds #in  ( B:Binds ) => #bindocc(A) <=Set #bindocc(B)

// checks explicit binding occurence set inclusion
  rule A:Bind  #ine ( B:Bind  ) => #bindocce(A) <=Set #bindocce(B)
  rule A:Bind  #ine ( B:Binds ) => #bindocce(A) <=Set #bindocce(B)
  rule A:Binds #ine ( B:Binds ) => #bindocce(A) <=Set #bindocce(B)
*/
//----------------
//--- #dec ---
//----------------
  rule #dec( new A:Name  in { _:Proc } ) => A
  rule #dec( new A:Names in { _:Proc } ) => A


//-------------
//--- #size ---
//-------------
  rule #size Set( ) => 0
  rule #size Set( P:Proc  ) => #length (P)
  rule #size Set( P:Procs ) => #length (P)
  
  rule #size { }:RhoMap => 0
  rule #size { _:Proc : _:Proc } => 1
  rule #size { _:Proc : _:Proc , _:Proc : _:Proc } => 2
  rule #size { _:Proc : _:Proc , R:RhoKVPairs    } => 1 +Int #size {R}

//---------------
//--- #length ---
//---------------
// RhoTuple/ProcList
  rule #length ( ) => 0
  rule #length ( _:Proc           ) => 1
  rule #length ( _:Proc , _:Proc  ) => 2
  rule #length ( _:Proc , P:Procs ) => 1 +Int #length (P)

// RhoList
  rule #length [ ] => 0
  rule #length [ P:Proc  ] => #length(P)
  rule #length [ P:Procs ] => #length(P)

// Name(s)
  rule #length EmptyMsg => 0
  rule #length A:Name           => 1 requires A =/=K EmptyMsg
  rule #length _:Name , _:Name  => 2
  rule #length _:Name , N:Names => 1 +Int #length N

//--- Binds ---
// Binds - number of listens in a join
  rule #length ( _:Lbind ; _:Lbind  ) => 2
  rule #length ( _:Lbind ; C:Lbinds ) => 1 +Int #length (C)

  rule #length ( _:Rbind ; _:Rbind  ) => 2
  rule #length ( _:Rbind ; C:Rbinds ) => 1 +Int #length (C)

  rule #length ( _:Pbind ; _:Pbind  ) => 2
  rule #length ( _:Pbind ; C:Pbinds ) => 1 +Int #length (C)
  
  rule #length ( B:Binds _:Guard ) => #length (B)

//----------------
//--- #lengths ---
//----------------
// Binds
  rule #lengths ( B:Lbind ; C:Lbind  ) => #bnum(B) , #bnum (C)
  rule #lengths ( B:Lbind ; C:Lbinds ) => #bnum(B) , #lengths(C)

  rule #lengths ( B:Rbind ; C:Rbind  ) => #bnum(B) , #bnum (C)
  rule #lengths ( B:Rbind ; C:Rbinds ) => #bnum(B) , #lengths(C)

  rule #lengths ( B:Pbind ; C:Pbind  ) => #bnum(B) , #bnum (C)
  rule #lengths ( B:Pbind ; C:Pbinds ) => #bnum(B) , #lengths(C)

//-------------
//--- #chan ---
//-------------
// Bind
  rule #chan (         <- N:Name ) => N
  rule #chan ( _:Name  <- N:Name ) => N
  rule #chan ( _:Names <- N:Name ) => N
  rule #chan (         <= N:Name ) => N
  rule #chan ( _:Name  <= N:Name ) => N
  rule #chan ( _:Names <= N:Name ) => N
  rule #chan (         <! N:Name ) => N
  rule #chan ( _:Name  <! N:Name ) => N
  rule #chan ( _:Names <! N:Name ) => N
  
  rule #chan ( B:Bind _:Guard ) => #chan (B)

// comma-separated list of channels involved in bindings
  rule #chan ( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Lbind ; C:Lbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Rbind ; C:Rbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Pbind ; C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Pbind ; C:Pbinds ) => #chan(B) , #chan(C)
  
  rule #chan ( B:Binds _:Guard ) => #chan (B)

//-------------
//--- #bnum ---
//-------------
// number of binding variables in a listen
  rule #bnum (         <- N:Name ) => 0
  rule #bnum ( _:Name  <- _:Name ) => 1
  rule #bnum ( N:Names <- _:Name ) => #length(N)
  rule #bnum (         <= N:Name ) => 0
  rule #bnum ( _:Name  <= _:Name ) => 1
  rule #bnum ( N:Names <= _:Name ) => #length(N)
  rule #bnum (         <! N:Name ) => 0
  rule #bnum ( _:Name  <! _:Name ) => 1
  rule #bnum ( N:Names <! _:Name ) => #length(N)
  
  rule #bnum ( B:Bind _:Guard ) => #bnum (B)

//-------------
//--- #bvar ---
//-------------
// binding variables
  rule #bvar (         <- N:Name ) => EmptyMsg
  rule #bvar ( N:Name  <- _:Name ) => N
  rule #bvar ( N:Names <- _:Name ) => N
  rule #bvar (         <= N:Name ) => EmptyMsg
  rule #bvar ( N:Name  <= _:Name ) => N
  rule #bvar ( N:Names <= _:Name ) => N
  rule #bvar (         <! N:Name ) => EmptyMsg
  rule #bvar ( N:Name  <! _:Name ) => N
  rule #bvar ( N:Names <! _:Name ) => N
  
  rule #bvar ( B:Bind _:Guard ) => #bvar(B)

  rule #bvar ( B:Lbind ; C:Lbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Lbind ; C:Lbinds ) => #bvar(B) , #bvar(C)

  rule #bvar ( B:Rbind ; C:Rbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Rbind ; C:Rbinds ) => #bvar(B) , #bvar(C)

  rule #bvar ( B:Pbind ; C:Pbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Pbind ; C:Pbinds ) => #bvar(B) , #bvar(C)
  
  rule #bvar ( B:Binds _:Guard ) => #bvar (B)
  
//---------------
//--- #quotes ---  
//---------------
  rule #quotes ( A:Proc , B:Proc  ) => @A , @B
  rule #quotes ( A:Proc , B:Procs ) => @A , #quotes( B )

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

//----------------
//--- #chanlen ---
//----------------
// how many variables are we listening for in each binding
  rule #chanlen ( A:Name  <- B:Name   ) => SetItem((B; #length (A)))
  rule #chanlen ( A:Names <- B:Name   ) => SetItem((B; #length (A)))
  rule #chanlen ( A:Lbind ;  B:Lbind  ) => #chanlen(A) #chanlen(B)
  rule #chanlen ( A:Lbind ;  B:Lbinds ) => #chanlen(A) #chanlen(B)

  rule #chanlen ( A:Name  <= B:Name   ) => SetItem((B; #length (A)))
  rule #chanlen ( A:Names <= B:Name   ) => SetItem((B; #length (A)))
  rule #chanlen ( A:Rbind ;  B:Rbind  ) => #chanlen(A) #chanlen(B)
  rule #chanlen ( A:Rbind ;  B:Rbinds ) => #chanlen(A) #chanlen(B)

  rule #chanlen ( A:Name  <! B:Name   ) => SetItem((B; #length (A)))
  rule #chanlen ( A:Names <! B:Name   ) => SetItem((B; #length (A)))
  rule #chanlen ( A:Pbind ;  B:Pbind  ) => #chanlen(A) #chanlen(B)
  rule #chanlen ( A:Pbind ;  B:Pbinds ) => #chanlen(A) #chanlen(B)

//-----------------
//--- #chanmany ---
//-----------------

// #chanmany( ChanLen : Bind(s) )
// gievn a channel and chanlength, how many occurrences are in Bind(s) 
  rule #chanmany ( (A:Name ; I:Int) : B:Bind             ) => #if (A;I) in #chanlen(B) #then 1                         #else 0                  #fi
  rule #chanmany ( (A:Name ; I:Int) : B:Lbind ; C:Lbind  ) => #if (A;I) in #chanlen(B) #then 1 +Int #chanmany((A;I):C) #else #chanmany((A;I):C) #fi
  rule #chanmany ( (A:Name ; I:Int) : B:Lbind ; C:Lbinds ) => #if (A;I) in #chanlen(B) #then 1 +Int #chanmany((A;I):C) #else #chanmany((A;I):C) #fi

  rule #chanmany ( (A:Name ; I:Int) : B:Rbind ; C:Rbind  ) => #if (A;I) in #chanlen(B) #then 1 +Int #chanmany((A;I):C) #else #chanmany((A;I):C) #fi
  rule #chanmany ( (A:Name ; I:Int) : B:Rbind ; C:Rbinds ) => #if (A;I) in #chanlen(B) #then 1 +Int #chanmany((A;I):C) #else #chanmany((A;I):C) #fi

  rule #chanmany ( (A:Name ; I:Int) : B:Pbind ; C:Pbind  ) => #if (A;I) in #chanlen(B) #then 1 +Int #chanmany((A;I):C) #else #chanmany((A;I):C) #fi
  rule #chanmany ( (A:Name ; I:Int) : B:Pbind ; C:Pbinds ) => #if (A;I) in #chanlen(B) #then 1 +Int #chanmany((A;I):C) #else #chanmany((A;I):C) #fi

// #chanmany( ChanList : Bind(s) )
  rule #chanmany ( (A:Name ; B:Name  ) : C:Lbind ) => #if B <- A #ine (C) #then 1 #else 0 #fi
  rule #chanmany ( (A:Name ; B:Names ) : C:Lbind ) => #if B <- A #ine (C) #then 1 #else 0 #fi
  rule #chanmany ( (A:Name ; B:Name  ) : C:Rbind ) => #if B <= A #ine (C) #then 1 #else 0 #fi
  rule #chanmany ( (A:Name ; B:Names ) : C:Rbind ) => #if B <- A #ine (C) #then 1 #else 0 #fi
  rule #chanmany ( (A:Name ; B:Name  ) : C:Pbind ) => #if B <! A #ine (C) #then 1 #else 0 #fi
  rule #chanmany ( (A:Name ; B:Names ) : C:Pbind ) => #if B <- A #ine (C) #then 1 #else 0 #fi

  rule #chanmany ( (A:Name ; B:Name  ) : C:Lbind ; D:Lbind  ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Names ) : C:Lbind ; D:Lbind  ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Name  ) : C:Lbind ; D:Lbinds ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Names ) : C:Lbind ; D:Lbinds ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)

  rule #chanmany ( (A:Name ; B:Name  ) : C:Rbind ; D:Rbind  ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Names ) : C:Rbind ; D:Rbind  ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Name  ) : C:Rbind ; D:Rbinds ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Names ) : C:Rbind ; D:Rbinds ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)

  rule #chanmany ( (A:Name ; B:Name  ) : C:Pbind ; D:Pbind  ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Names ) : C:Pbind ; D:Pbind  ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Name  ) : C:Pbind ; D:Pbinds ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)
  rule #chanmany ( (A:Name ; B:Names ) : C:Pbind ; D:Pbinds ) => #chanmany((A;B):C) +Int #chanmany((A;B):D)

// #chanmany( Name : Set )
// given a channel and set of binding occurrences, how many total occurrences involving that channel
  rule #chanmany( N:Name : .Set ) => 0
  rule #chanmany( N:Name : SetItem( M:Name ; _:Int ;; I:Int )       ) => #if N #in (M) #then I #else 0 #fi
  rule #chanmany( N:Name : SetItem( M:Name ; _:Int ;; I:Int ) S:Set ) => #if N #in (M) #then I +Int #chanmany(N:S) #else #chanmany(N:S) #fi

//----------------
//--- #bindocc ---
//----------------

// set of binding occurrences and number of appearences i.e. (channel ; chanlength ;; how many occurrences of channel/chanlength pair)
  rule #bindocc ( A:Bind ) => SetItem( #chan(A) ; #bnum(A) ;; 1 )

// Linear join
  rule #bindocc ( A:Lbind ; B:Lbind  )
       => #if #bindocc(A) <=Set #bindocc(B)
          #then SetItem( #chan(A) ; #bnum(A) ;; 2 ) (#bindocc(B) -Set #bindocc(A) )
          #else #bindocc(A) #bindocc(B)
          #fi
  rule #bindocc ( A:Lbind ; B:Lbinds )
       => #if #chanmany((#chan(A) ; #bnum(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #bnum(A) ;; 1 +Int #chanmany((#chan(A);#bnum(A)):B) ) (#bindocc(B) -Set SetItem( #chan(A) ; #bnum(A) ;; #chanmany((#chan(A);#bnum(A)):B)))
          #else #bindocc(A) #bindocc(B)
          #fi

// Repeated join
  rule #bindocc ( A:Rbind ; B:Rbind  )
       => #if #bindocc(A) <=Set #bindocc(B)
          #then SetItem( #chan(A) ; #bnum(A) ;; 2 ) (#bindocc(B) -Set #bindocc(A) )
          #else #bindocc(A) #bindocc(B)
          #fi
  rule #bindocc ( A:Rbind ; B:Rbinds )
       => #if #chanmany((#chan(A) ; #bnum(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #bnum(A) ;; 1 +Int #chanmany((#chan(A);#bnum(A)):B) ) (#bindocc(B) -Set SetItem( #chan(A) ; #bnum(A) ;; #chanmany((#chan(A);#bnum(A)):B)))
          #else #bindocc(A) #bindocc(B)
          #fi

// Peek join
  rule #bindocc ( A:Pbind ; B:Pbind  )
       => #if #bindocc(A) <=Set #bindocc(B)
          #then SetItem( #chan(A) ; #bnum(A) ;; 2 ) (#bindocc(B) -Set #bindocc(A) )
          #else #bindocc(A) #bindocc(B)
          #fi
  rule #bindocc ( A:Pbind ; B:Pbinds )
       => #if #chanmany((#chan(A) ; #bnum(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #bnum(A) ;; 1 +Int #chanmany((#chan(A);#bnum(A)):B) ) (#bindocc(B) -Set SetItem( #chan(A) ; #bnum(A) ;; #chanmany((#chan(A);#bnum(A)):B)))
          #else #bindocc(A) #bindocc(B)
          #fi

//-----------------
//--- #bindocce ---
//-----------------
// set of explicit binding occurrences and number of appearences i.e. (channel ; chanlength ;; how many occurrences of channel/chanlength pair)
  rule #bindocce ( A:Bind ) => SetItem( #chan(A) ; #bvar(A) ;; 1 )

// Linear join
  rule #bindocce ( A:Lbind ; B:Lbind  )
       => #if #bindocce(A) <=Set #bindocce(B)
          #then SetItem( #chan(A) ; #bvar(A) ;; 2 ) (#bindocce(B) -Set #bindocce(A) )
          #else #bindocce(A) #bindocce(B)
          #fi
  rule #bindocce ( A:Lbind ; B:Lbinds )
       => #if #chanmany((#chan(A) ; #bvar(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #bvar(A) ;; 1 +Int #chanmany((#chan(A);#bvar(A)):B) ) (#bindocce(B) -Set SetItem( #chan(A) ; #bvar(A) ;; #chanmany((#chan(A);#bvar(A)):B)))
          #else #bindocce(A) #bindocce(B)
          #fi

// Repeated join
  rule #bindocce ( A:Rbind ; B:Rbind  )
       => #if #bindocce(A) <=Set #bindocce(B)
          #then SetItem( #chan(A) ; #bvar(A) ;; 2 ) (#bindocce(B) -Set #bindocce(A) )
          #else #bindocce(A) #bindocce(B)
          #fi
  rule #bindocce ( A:Rbind ; B:Rbinds )
       => #if #chanmany((#chan(A) ; #bvar(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #bvar(A) ;; 1 +Int #chanmany((#chan(A);#bvar(A)):B) ) (#bindocce(B) -Set SetItem( #chan(A) ; #bvar(A) ;; #chanmany((#chan(A);#bvar(A)):B)))
          #else #bindocce(A) #bindocce(B)
          #fi

// Peek join
  rule #bindocce ( A:Pbind ; B:Pbind  )
       => #if #bindocce(A) <=Set #bindocce(B)
          #then SetItem( #chan(A) ; #bvar(A) ;; 2 ) (#bindocce(B) -Set #bindocce(A) )
          #else #bindocce(A) #bindocce(B)
          #fi
  rule #bindocce ( A:Rbind ; B:Rbinds )
       => #if #chanmany((#chan(A) ; #bvar(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #bvar(A) ;; 1 +Int #chanmany((#chan(A);#bvar(A)):B) ) (#bindocce(B) -Set SetItem( #chan(A) ; #bvar(A) ;; #chanmany((#chan(A);#bvar(A)):B)))
          #else #bindocce(A) #bindocce(B)
          #fi
*/
endmodule