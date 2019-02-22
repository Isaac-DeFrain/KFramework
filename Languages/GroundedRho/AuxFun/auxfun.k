// Auxilary functions for GRHO configuration
// #lengths of RhoTuple | Names | Procs | Binds
// #chans of Binds
// #bvars of Binds

requires "../grho.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

  syntax   Int ::= "#length" RhoTuple        [function]  // #length: RhoTuple ----> Int
                 | "#length" Name            [function]  // #length: Name --------> Int
                 | "#length" Names           [function]  // #length: Names -------> Int
                 | "#length"  "(" Bind  ")"  [function]  // #length (_): Bind ----> Int

  syntax Procs ::= "#lengths" "(" Binds ")"  [function]  // #length (_): Binds ---> Procs

  syntax  Name ::= "#chan"  "(" Bind  ")"    [function]  //   #chan (_): Bind ----> Name
                 | "#bvar"  "(" Bind  ")"    [function]  //   #bvar (_): Bind ----> Name

  syntax Names ::= "#chans" "(" Binds ")"    [function]  //  #chans (_): Binds ---> Names
                 | "#bvar"  "(" Bind  ")"    [function]  //   #bvar (_): Bind ----> Names
                 | "#bvars" "(" Binds ")"    [function]  //  #bvars (_): Binds ---> Names

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= Int | Procs | Name

//---------------
//--- #length ---
//---------------
// RhoTuple
  rule #length ( _:Proc ) => 1
  rule #length ( _:Proc , _:Proc  ) => 2
  rule #length ( _:Proc , P:Procs ) => 1 +Int #length ( P )         [strict]

// Name(s)
  rule #length _:Name => 1
  rule #length _:Name , _:Name  => 2
  rule #length _:Name , N:Names => 1 +Int #length N                 [strict]

// Bind
  rule #length ( _:Name  <- _:Name ) => 1
  rule #length ( N:Names <- _:Name ) => #length N                   [strict]
  rule #length ( _:Name  <= _:Name ) => 1
  rule #length ( N:Names <= _:Name ) => #length N                   [strict]

//----------------
//--- #lengths ---
//----------------
// Binds
  rule #lengths ( B:Lbind ; C:Lbind  ) => #length(B) , #length(C)   [strict]
  rule #lengths ( B:Lbind ; C:Lbinds ) => #length(B) , #lengths(C)  [strict]
  rule #lengths ( B:Rbind ; C:Rbind  ) => #length(B) , #length(C)   [strict]
  rule #lengths ( B:Rbind ; C:Rbinds ) => #length(B) , #lengths(C)  [strict]

//-------------
//--- #chan ---
//-------------
// Bind
  rule #chan ( _:Name  <- N:Name ) => N
  rule #chan ( _:Names <- N:Name ) => N
  rule #chan ( _:Name  <= N:Name ) => N
  rule #chan ( _:Names <= N:Name ) => N

//--------------
//--- #chans ---
//--------------
// Binds
  rule #chans ( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)         [strict]
  rule #chans ( B:Lbind ; C:Lbinds ) => #chan(B) , #chans(C)        [strict]
  rule #chans ( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)         [strict]
  rule #chans ( B:Rbind ; C:Rbinds ) => #chan(B) , #chans(C)        [strict]

//-------------
//--- #bvar ---
//-------------
// Bind
  rule #bvar ( M:Name           <- _:Name ) => M
  rule #bvar ( M:Name , N:Name  <- _:Name ) => M , N
  rule #bvar ( M:Name , N:Names <- L:Name ) => M , #bvar ( N <- L )  [strict]

  rule #bvar ( N:Name           <= _:Name ) => N
  rule #bvar ( M:Name , N:Name  <= _:Name ) => M , N
  rule #bvar ( M:Name , N:Names <= L:Name ) => M , #bvar ( N <= L )  [strict]

//--------------
//--- #bvars ---
//--------------
// Binds
  rule #bvars ( B:Lbind ; C:Lbind  ) => #bvar(B) , #bvar(C)         [strict]
  rule #bvars ( B:Lbind ; C:Lbinds ) => #bvar(B) , #bvars(C)        [strict]
  rule #bvars ( B:Rbind ; C:Rbind  ) => #bvar(B) , #bvar(C)         [strict]
  rule #bvars ( B:Rbind ; C:Rbinds ) => #bvar(B) , #bvars(C)        [strict]

endmodule
