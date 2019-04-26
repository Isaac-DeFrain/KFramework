// Auxilary functions for JOIN configuration

requires "../join.k"

module AUXFUN-SYNTAX
  import JOIN-SYNTAX

  syntax    Int ::= "#length" "(" ProcList ")"     [function]  // #length(_): ProcList ---------------> Int
                  | "#length" "("          ")"     [function]  // #length( ):  -----------------------> Int
                  | "#length" "(" Name     ")"     [function]  // #length(_): Name -------------------> Int
                  | "#length" "(" Names    ")"     [function]  // #length(_): Names ------------------> Int
                  | "#length" "(" Binds    ")"     [function]  // #length(_): Binds ------------------> Int
//                  | "#length" "(" GuardedBinds ")" [function]  // #length(_): GuardedBinds -----------> Int
                  | "#bnum"   "(" Bind     ")"     [function]  //   #bnum(_): Bind -------------------> Int
//                  | "#bnum"   "(" GuardedBind  ")" [function]  //   #bnum(_): GuardedBind ------------> Int
                  | "#bnum"   "(" Receive ")"      [function]  //   #bnum(_): Receive ----------------> Int
                  | "#stype"  "(" Send     ")"     [function]  //  #stype(_): Send -------------------> Int
                  | "#rtype"  "(" BindList ")"     [function]  //  #rtype(_): Bind -------------------> Int
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
//                  | "#chan"   "(" GuardedBind ")"     [function]  //     #chan(_): Bind -------> Name
                  | "#bvar"   "("   Bind  ")"         [function]  //     #bvar(_): Bind -------> Name
//                  | "#bvar"   "(" GuardedBind ")"     [function]  //     #bvar(_): Bind -------> Name
                  | "#bvar"   "(" Receive ")"         [function]  //     #bvar(_): Receive ----> Name

  syntax  Names ::= "#chan"   "("   Binds ")"         [function]  //     #chan(_): Binds ------> Names
//                  | "#chan"   "(" GuardedBinds ")"    [function]  //     #chan(_): Binds ------> Names
                  | "#chan"   "(" Receive  ")"        [function]  //     #chan(_): Receive ----> Names
                  | "#bvar"   "(" Bind     ")"        [function]  //     #bvar(_): Bind -------> Names
                  | "#bvar"   "(" Binds    ")"        [function]  //     #bvar(_): Binds ------> Names
                  | "#bvar"   "(" Receive  ")"        [function]  //     #bvar(_): Receive ----> Names
                  | "#quotes" "(" Procs    ")"        [function]  //   #quotes(_): Procs ------> Names
                  | "#append" "(" Name  ";" Name  ")" [function]  //     #bvar(_): Name  x Name -------> Names
                  | "#append" "(" Names ";" Name  ")" [function]  //     #bvar(_): Names x Name -------> Names
                  | "#append" "(" Name  ";" Names ")" [function]  //     #bvar(_): Name  x Names ------> Names
                  | "#append" "(" Names ";" Names ")" [function]  //     #bvar(_): Names x Names ------> Names
  
  syntax   BExp ::= "#guard" "(" Receive ")"          [function]  // #guard(_): Receive -------> BExp

  syntax    Map ::= "#rbind" "(" Receive  ")"         [function]
                  | "#rbind" "(" Binds    ")"         [function]
//                  | "#rbind" "(" AnyBinds ")"         [function]

  syntax RhoSet ::= "#keys" RhoMap                    [function]
                  | RhoSet "#union" RhoSet            [function]

  syntax   Bool ::= Int   "#in"      RhoTuple                [function]  // _#in_: Int x RhoTuple ----> Bool
                  | Name  "#in"  "(" Name  ")"               [function]  // _#in_: Name x Name  ------> Bool
                  | Name  "#in"  "(" Names ")"               [function]  // _#in_: Name x Names ------> Bool

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= Int | Name | Names | Proc | Procs

// Sends
  rule #chan  ( N:Name !  ( _:ProcList ) ) => N
  rule #chan  ( N:Name !! ( _:ProcList ) ) => N

  rule #msg   ( _:Name !  ( P:Proc     ) ) => P
  rule #msg   ( _:Name !  ( P:Procs    ) ) => P
  rule #msg   ( _:Name !! ( P:Proc     ) ) => P
  rule #msg   ( _:Name !! ( P:Procs    ) ) => P
  
  rule #length( S:Send ) => #length(#msg(S))

  rule #stype ( _:Name !  ( _:ProcList ) ) => 0
  rule #stype ( _:Name !! ( _:ProcList ) ) => 1

// Receives
  rule #bind  ( for ( B:Bind  ){ _:Proc } ) => B
  rule #bind  ( for ( B:Binds ){ _:Proc } ) => B
//  rule #bind  ( for ( B:Bind  _:Guard ){ _:Proc } ) => B
//  rule #bind  ( for ( B:Binds _:Guard ){ _:Proc } ) => B

  rule #bvar  ( for ( B:Bind  ){ _:Proc } ) => #bvar(B)
  rule #bvar  ( for ( B:Binds ){ _:Proc } ) => #bvar(B)
//  rule #bvar  ( for ( B:Bind  _:Guard ){ _:Proc } ) => #bvar(B)
//  rule #bvar  ( for ( B:Binds _:Guard ){ _:Proc } ) => #bvar(B)

  rule #chan  ( for ( B:Bind  ){ _:Proc } ) => #chan(B)
  rule #chan  ( for ( B:Binds ){ _:Proc } ) => #chan(B)
//  rule #chan  ( for ( B:Bind  _:Guard ){ _:Proc } ) => #chan(B)
//  rule #chan  ( for ( B:Binds _:Guard ){ _:Proc } ) => #chan(B)

  rule #cont  ( for ( _:Bind  ){ P:Proc } ) => P
  rule #cont  ( for ( _:Binds ){ P:Proc } ) => P
//  rule #cont  ( for ( _:Bind  _:Guard ){ P:Proc } ) => P
//  rule #cont  ( for ( _:Binds _:Guard ){ P:Proc } ) => P

  rule #bnum  ( for ( B:Bind  ){ _:Proc } ) => #bnum(B)
  rule #bnum  ( for ( B:Binds ){ _:Proc } ) => #length(B)
//  rule #bnum  ( for ( B:Bind  _:Guard ){ _:Proc } ) => #bnum(B)
//  rule #bnum  ( for ( B:Binds _:Guard ){ _:Proc } ) => #length(B)

// receive types - receive
  rule #rtype ( for ( _:Lbind  ){ _:Proc } ) => 0
  rule #rtype ( for ( _:Lbinds ){ _:Proc } ) => 0
//  rule #rtype ( for ( _:Lbind  _:Guard ){ _:Proc } ) => 0
//  rule #rtype ( for ( _:Lbinds _:Guard ){ _:Proc } ) => 0
  rule #rtype ( for ( _:Rbind  ){ _:Proc } ) => 1
  rule #rtype ( for ( _:Rbinds ){ _:Proc } ) => 1
//  rule #rtype ( for ( _:Rbind  _:Guard ){ _:Proc } ) => 1
//  rule #rtype ( for ( _:Rbinds _:Guard ){ _:Proc } ) => 1
  rule #rtype ( for ( _:Pbind  ){ _:Proc } ) => 2
  rule #rtype ( for ( _:Pbinds ){ _:Proc } ) => 2
//  rule #rtype ( for ( _:Pbind  _:Guard ){ _:Proc } ) => 2
//  rule #rtype ( for ( _:Pbinds _:Guard ){ _:Proc } ) => 2

  rule #rtype ( _:Lbind  ) => 0
  rule #rtype ( _:Lbinds ) => 0
//  rule #rtype ( _:Lbind  _:Guard ) => 0
//  rule #rtype ( _:Lbinds _:Guard ) => 0
  rule #rtype ( _:Rbind  ) => 1
  rule #rtype ( _:Rbinds ) => 1
//  rule #rtype ( _:Rbind  _:Guard ) => 1
//  rule #rtype ( _:Rbinds _:Guard ) => 1
  rule #rtype ( _:Pbind  ) => 2
  rule #rtype ( _:Pbinds ) => 2
//  rule #rtype ( _:Pbind  _:Guard ) => 2
//  rule #rtype ( _:Pbinds _:Guard ) => 2

// Guards
//  rule #guard ( for( _:Bind  ){ _:Proc } ) => true
//  rule #guard ( for( _:Binds ){ _:Proc } ) => true
//  rule #guard ( for( _:Bind  if B:BExp ){ _:Proc } ) => B
//  rule #guard ( for( _:Binds if B:BExp ){ _:Proc } ) => B
  
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

//-----------
//--- #in ---
//-----------
// Int #in RhoTuple
  rule A:Int #in ( B:Int           ) => A ==Int B
  rule A:Int #in ( B:Int , C:Int   ) => A ==Int B orBool A ==Int C
  rule A:Int #in ( B:Int , C:Procs ) => A ==Int B orBool A #in  (C)

// Name #in NameTuple
  rule A:Name #in ( B:Name           ) => A ==K B
  rule A:Name #in ( B:Name , C:Name  ) => A ==K B orBool A ==K C
  rule A:Name #in ( B:Name , C:Names ) => A ==K B orBool A #in (C)
  
//-------------
//--- #size ---
//-------------
  rule #size Set( ) => 0
  rule #size Set( P:ProcList ) => #length(P)
  
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
  rule #length [ P:ProcList ] => #length(P)

// Name(s)
  rule #length ( _:Name           ) => 1
  rule #length ( _:Name , _:Name  ) => 2
  rule #length ( _:Name , N:Names ) => 1 +Int #length (N)

//--- Binds ---
// Binds - number of listens in a join
  rule #length ( _:Lbind ; _:Lbind  ) => 2
  rule #length ( _:Lbind ; C:Lbinds ) => 1 +Int #length (C)

  rule #length ( _:Rbind ; _:Rbind  ) => 2
  rule #length ( _:Rbind ; C:Rbinds ) => 1 +Int #length (C)

  rule #length ( _:Pbind ; _:Pbind  ) => 2
  rule #length ( _:Pbind ; C:Pbinds ) => 1 +Int #length (C)
  
//  rule #length ( B:Binds _:Guard ) => #length (B)

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
//  rule #chan (         <- N:Name ) => N
  rule #chan ( _:Name  <- N:Name ) => N
  rule #chan ( _:Names <- N:Name ) => N
//  rule #chan (         <= N:Name ) => N
  rule #chan ( _:Name  <= N:Name ) => N
  rule #chan ( _:Names <= N:Name ) => N
//  rule #chan (         <! N:Name ) => N
  rule #chan ( _:Name  <! N:Name ) => N
  rule #chan ( _:Names <! N:Name ) => N
  
//  rule #chan ( B:Bind _:Guard ) => #chan (B)

// comma-separated list of channels involved in bindings
  rule #chan ( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Lbind ; C:Lbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Rbind ; C:Rbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Pbind ; C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Pbind ; C:Pbinds ) => #chan(B) , #chan(C)
  
//  rule #chan ( B:Binds _:Guard ) => #chan (B)

//-------------
//--- #bnum ---
//-------------
// number of binding variables in a listen
//  rule #bnum (         <- N:Name ) => 0
  rule #bnum ( _:Name  <- _:Name ) => 1
  rule #bnum ( N:Names <- _:Name ) => #length(N)
//  rule #bnum (         <= N:Name ) => 0
  rule #bnum ( _:Name  <= _:Name ) => 1
  rule #bnum ( N:Names <= _:Name ) => #length(N)
//  rule #bnum (         <! N:Name ) => 0
  rule #bnum ( _:Name  <! _:Name ) => 1
  rule #bnum ( N:Names <! _:Name ) => #length(N)
  
//  rule #bnum ( B:Bind _:Guard ) => #bnum (B)

//-------------
//--- #bvar ---
//-------------
// binding variables
//  rule #bvar (         <- N:Name ) => EmptyMsg
  rule #bvar ( N:Name  <- _:Name ) => N
  rule #bvar ( N:Names <- _:Name ) => N
//  rule #bvar (         <= N:Name ) => EmptyMsg
  rule #bvar ( N:Name  <= _:Name ) => N
  rule #bvar ( N:Names <= _:Name ) => N
//  rule #bvar (         <! N:Name ) => EmptyMsg
  rule #bvar ( N:Name  <! _:Name ) => N
  rule #bvar ( N:Names <! _:Name ) => N
  
//  rule #bvar ( B:Bind _:Guard ) => #bvar(B)

  rule #bvar ( B:Lbind ; C:Lbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Lbind ; C:Lbinds ) => #bvar(B) , #bvar(C)

  rule #bvar ( B:Rbind ; C:Rbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Rbind ; C:Rbinds ) => #bvar(B) , #bvar(C)

  rule #bvar ( B:Pbind ; C:Pbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Pbind ; C:Pbinds ) => #bvar(B) , #bvar(C)
  
//  rule #bvar ( B:Binds _:Guard ) => #bvar (B)
  
//---------------
//--- #quotes ---  
//---------------
  rule #quotes ( A:Proc , B:Proc  ) => @A , @B
  rule #quotes ( A:Proc , B:Procs ) => @A , #quotes( B )

endmodule