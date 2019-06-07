// Auxilary functions for GRHO configuration
// #lengths of RhoTuple | Names | Procs | Binds
// #chans of Binds
// #bvars of Binds

requires "../altgrho.k"

module AUXFUN-SYNTAX
  import ALTGRHO-SYNTAX

  syntax    Int ::= "#length" "(" Send    ")"               [function]  // #length: Send ----------------------> Int
                  | "#length" "(" Procs   ")"               [function]  // #length(_): Procs ------------------> Int
                  | "#length" "(" Names   ")"               [function]  // #length(_): Names ------------------> Int
                  | "#length" "(" Binds   ")"               [function]  // #length(_): Binds ------------------> Int
                  | "#bnum"   "(" Bind    ")"               [function]  // #bnum(_): Bind ---------------------> Int
                  | "#bnum"   "(" Receive ")"               [function]  // #bnum(_): Receive ------------------> Int
                  | "#stype"  "(" Send    ")"               [function]  // #stype(_): Send --------------------> Int
                  | "#rtype"  "(" Bind    ")"               [function]  // #rtype(_): Bind --------------------> Int
                  | "#rtype"  "(" Binds   ")"               [function]  // #rtype(_): Bind --------------------> Int
                  | "#rtype"  "(" Receive ")"               [function]  // #rtype(_): Receive -----------------> Int

  syntax   Bind ::= "#bind"    "(" Receive ")"               [function]  // #bind(_): Receive --------> Bind

  syntax  Binds ::= "#bind"    "(" Receive ")"               [function]  // #bind(_): Receive --------> Binds

  syntax   Proc ::= "#cont"    "(" Receive ")"               [function]  // #cont(_): Receive --------> Proc

  syntax  Procs ::= "#lengths" "("   Binds ")"               [function]  // #length(_): Binds --------> Procs
                  | "#msg"     "("   Send  ")"               [function]  // #msg(_): Send ------------> Procs

  syntax   Name ::= "#chan"    "("   Send  ")"               [function]  //     #chan(_): Send -------> Name
                  | "#chan"    "(" Receive ")"               [function]  //     #chan(_): Receive ----> Name
                  | "#chan"    "("   Bind  ")"               [function]  //     #chan(_): Bind -------> Name
                  | "#bvar"    "("   Bind  ")"               [function]  //     #bvar(_): Bind -------> Name
                  | "#bvar"    "(" Receive ")"               [function]  //     #bvar(_): Receive ----> Name

  syntax  Names ::= "#chan"    "("   Binds ")"               [function]  //     #chan(_): Binds ------> Names
                  | "#chan"    "(" Receive ")"               [function]  //     #chan(_): Receive ----> Names
                  | "#bvar"    "("   Binds ")"               [function]  //     #bvar(_): Binds ------> Names
                  | "#bvar"    "("   Bind  ")"               [function]  //     #bvar(_): Bind -------> Names
                  | "#bvar"    "(" Receive ")"               [function]  //     #bvar(_): Receive ----> Names

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= Proc | Procs | Name | Names

// Sends
  rule #chan  ( N:Name !  ( _:Procs ) ) => N
  rule #chan  ( N:Name !! ( _:Procs ) ) => N

  rule #msg   ( _:Name !  ( P:Procs ) ) => P
  rule #msg   ( _:Name !! ( P:Procs ) ) => P

  rule #stype ( _:CSend ) => 0
  rule #stype ( _:USend ) => 1
  
  rule #length( _:Name !  ( P:Procs ) ) => #length(P)
  rule #length( _:Name !! ( P:Procs ) ) => #length(P)

// Receives
  rule #bind  ( for ( B:Bind   ){ _:Proc } ) => B
  rule #bind  ( for ( B:Binds  ){ _:Proc } ) => B

  rule #bvar  ( for ( B:Bind   ){ _:Proc } ) => #bvar(B)
  rule #bvar  ( for ( B:Binds  ){ _:Proc } ) => #bvar(B)

  rule #chan  ( for ( B:Bind   ){ _:Proc } ) => #chan(B)
  rule #chan  ( for ( B:Binds  ){ _:Proc } ) => #chan(B)

  rule #cont  ( for ( _:Bind   ){ P:Proc } ) => P
  rule #cont  ( for ( _:Binds  ){ P:Proc } ) => P

  rule #bnum  ( for ( B:Bind   ){ _:Proc } ) => #bnum(B)
  rule #bnum  ( for ( B:Binds  ){ _:Proc } ) => #length(B)

  rule #rtype ( for ( _:Lbind  ){ _:Proc } ) => 0
  rule #rtype ( for ( _:Lbinds ){ _:Proc } ) => 0
  rule #rtype ( for ( _:Rbind  ){ _:Proc } ) => 1
  rule #rtype ( for ( _:Rbinds ){ _:Proc } ) => 1
  rule #rtype ( for ( _:Pbind  ){ _:Proc } ) => 2
  rule #rtype ( for ( _:Pbinds ){ _:Proc } ) => 2

  rule #rtype ( _:Lbind  ) => 0
  rule #rtype ( _:Lbinds ) => 0
  rule #rtype ( _:Rbind  ) => 1
  rule #rtype ( _:Rbinds ) => 1
  rule #rtype ( _:Pbind  ) => 2
  rule #rtype ( _:Pbinds ) => 2

//---------------
//--- #length ---
//---------------
// Procs
  rule #length (  .Procs          ) => 0
  rule #length ( _:Proc , .Procs  ) => 1
  rule #length ( _:Proc , P:Procs ) => 1 +Int #length(P)

// Names
  rule #length (  .Names          ) => 0
  rule #length ( _:Name , .Names  ) => 1
  rule #length ( _:Name , N:Names ) => 1 +Int #length(N)

//--- Binds ---
  rule #length (  .Lbinds           ) => 0
  rule #length ( _:Lbind            ) => 1
  rule #length ( _:Lbind ; B:Lbinds ) => 1 +Int #length(B)

  rule #length (  .Pbinds           ) => 0
  rule #length ( _:Pbind            ) => 1
  rule #length ( _:Pbind ; B:Pbinds ) => 1 +Int #length(B)
  
  rule #length (  .Rbinds           ) => 0
  rule #length ( _:Rbind            ) => 1
  rule #length ( _:Rbind ; B:Rbinds ) => 1 +Int #length(B)

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
  rule #chan ( _:Names <- N:Name ) => N
  rule #chan ( _:Names <= N:Name ) => N
  rule #chan ( _:Names <! N:Name ) => N

// comma-separated list of channels involved in bindings
  rule #chan ( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Lbind ; C:Lbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Rbind ; C:Rbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Pbind ; C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Pbind ; C:Pbinds ) => #chan(B) , #chan(C)

//-------------
//--- #bnum ---
//-------------
// number of binding variables in a listen
  rule #bnum ( N:Names <- _:Name ) => #length(N)
  rule #bnum ( N:Names <= _:Name ) => #length(N)
  rule #bnum ( N:Names <! _:Name ) => #length(N)

//-------------
//--- #bvar ---
//-------------
// binding variables
  rule #bvar ( .Lbinds ) => .Names
  rule #bvar ( .Pbinds ) => .Names
  rule #bvar ( .Rbinds ) => .Names

  rule #bvar ( N:Names <- _:Name ) => N
  rule #bvar ( N:Names <= _:Name ) => N
  rule #bvar ( N:Names <! _:Name ) => N

  rule #bvar ( B:Lbind ; C:Lbinds ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Rbind ; C:Rbinds ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Pbind ; C:Pbinds ) => #bvar(B) , #bvar(C)

endmodule