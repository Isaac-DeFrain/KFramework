// Auxilary functions for GRHO configuration
// #lengths of RhoTuple | Names | Procs | Binds
// #chans of Binds
// #bvars of Binds

requires "../grho.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

  syntax    Int ::= "#length"       RhoTuple   [function]  // #length: RhoTuple --------> Int
                  | "#length"       JoinList   [function]  // #length: JoinList --------> Int
                  | "#length"   "(" Name  ")"  [function]  // #length(_): Name ---------> Int
                  | "#length"   "(" Names ")"  [function]  // #length(_): Names --------> Int
                  | "#length"   "(" Bind  ")"  [function]  // #length(_): Bind ---------> Int
                  | "#length"   "(" Binds ")"  [function]  // #length(_): Binds --------> Int
                  | "#chanmany" "(" ChanLen ":" Bind  ")"  [function]  // 
                  | "#chanmany" "(" ChanLen ":" Binds ")"  [function]  // 

  syntax    Set ::= "#chanlen" "(" Bind  ")"  [function]  // #chanlen(_): Bind --------> Procs
								  | "#chanlen" "(" Binds ")"  [function]  // #chanlen(_): Binds -------> Procs

  syntax  Procs ::= "#lengths" "(" Binds ")"  [function]  // #length(_): Binds --------> Procs

  syntax   Name ::= "#chan"    "(" Bind  ")"  [function]  // #chan(_): Bind -----------> Name
                  | "#bvar"    "(" Bind  ")"  [function]  // #bvar(_): Bind -----------> Name

  syntax  Names ::= "#chan"   "(" Binds ")"  [function]  //  #chans(_): Binds --------> Names
                  | "#bvar"    "(" Bind  ")"  [function]  //  #bvar(_): Bind ----------> Names
                  | "#bvars"   "(" Binds ")"  [function]  //  #bvars(_): Binds --------> Names

  syntax   Bool ::= Int  "#in"     RhoTuple   [function]  // _#in_: Int  x RhoTuple ---> Bool
                  | Name "#in" "(" Name  ")"  [function]  // _#in_: Name x Name  ------> Bool
                  | Name "#in" "(" Names ")"  [function]  // _#in_: Name x Names ------> Bool

  syntax String ::= "toString("    Proc  ")"
                  | "toString("    Name  ")"

  syntax
        ChanLen ::= "(" Name "," Int ")"

  syntax   Proc ::= ChanLen

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= Int | Procs | Name

//-----------
//--- #in ---
//-----------
// Int #in RhoTuple
  rule A:Int #in ( B:Int             ) => A ==Int B
  rule A:Int #in ( B:Int , C:Int     ) => A ==Int B orBool A ==Int C
  rule A:Int #in ( B:Int , C:Procs   ) => A ==Int B orBool A #in  (C)

// Name #in NameTuple
  rule A:Name #in ( B:Name           ) => toString(A) ==String toString(B)
  rule A:Name #in ( B:Name , C:Name  ) => toString(A) ==String toString(B) orBool toString(A) ==String toString(C)
  rule A:Name #in ( B:Name , C:Names ) => toString(A) ==String toString(B) orBool A #in (C)

//---------------
//--- #length ---
//---------------
// RhoTuple
  rule #length ( _:Proc           ) => 1
  rule #length ( _:Proc , _:Proc  ) => 2
  rule #length ( _:Proc , P:Procs ) => 1 +Int #length (P)

// Join send id list {[ Int ; ... ]}
  rule #length {[ _:Int ;                  ]} => 0
  rule #length {[ _:Int ; _:Proc           ]} => 1
  rule #length {[ _:Int ; _:Proc , _:Proc  ]} => 2
  rule #length {[ I:Int ; _:Proc , P:Procs ]} => 1 +Int #length {[ I ; P ]}

// Name(s)
  rule #length ( _:Name           ) => 1
  rule #length ( _:Name , _:Name  ) => 2
  rule #length ( _:Name , N:Names ) => 1 +Int #length (N)

//--- Binds ---
// Linear
  rule #length ( _:Name  <- _:Name ) => 1
  rule #length ( N:Names <- _:Name ) => #length (N)

// Repeated
  rule #length ( _:Name  <= _:Name ) => 1
  rule #length ( N:Names <= _:Name ) => #length (N)

// Peek
  rule #length ( _:Name  <! _:Name ) => 1
  rule #length ( N:Names <! _:Name ) => #length (N)

// Binds
  rule #length ( B:Lbind ; C:Lbind  ) => 2
  rule #length ( B:Lbind ; C:Lbinds ) => 1 +Int #length (C)

  rule #length ( B:Rbind ; C:Rbind  ) => 2
  rule #length ( B:Rbind ; C:Rbinds ) => 1 +Int #length (C)

  rule #length ( B:Pbind ; C:Pbind  ) => 2
  rule #length ( B:Pbind ; C:Pbinds ) => 1 +Int #length (C)

//----------------
//--- #lengths ---
//----------------
// Binds
  rule #lengths ( B:Lbind ; C:Lbind  ) => #length(B) , #length (C)
  rule #lengths ( B:Lbind ; C:Lbinds ) => #length(B) , #lengths(C)

  rule #lengths ( B:Rbind ; C:Rbind  ) => #length(B) , #length (C)
  rule #lengths ( B:Rbind ; C:Rbinds ) => #length(B) , #lengths(C)

  rule #lengths ( B:Pbind ; C:Pbind  ) => #length(B) , #length (C)
  rule #lengths ( B:Pbind ; C:Pbinds ) => #length(B) , #lengths(C)

//-------------
//--- #chan ---
//-------------
// Bind
  rule #chan ( _:Name  <- N:Name ) => N
  rule #chan ( _:Names <- N:Name ) => N

  rule #chan ( _:Name  <= N:Name ) => N
  rule #chan ( _:Names <= N:Name ) => N

  rule #chan ( _:Name  <! N:Name ) => N
  rule #chan ( _:Names <! N:Name ) => N

//--------------
//--- #chans ---
//--------------
// Binds
  rule #chan ( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Lbind ; C:Lbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Rbind ; C:Rbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Pbind ; C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Pbind ; C:Pbinds ) => #chan(B) , #chan(C)

//-------------
//--- #bvar ---
//-------------
// Bind
  rule #bvar ( M:Name           <- _:Name ) => M
  rule #bvar ( M:Name , N:Name  <- _:Name ) => M , N
  rule #bvar ( M:Name , N:Names <- L:Name ) => M , #bvar ( N <- L )

  rule #bvar ( N:Name           <= _:Name ) => N
  rule #bvar ( M:Name , N:Name  <= _:Name ) => M , N
  rule #bvar ( M:Name , N:Names <= L:Name ) => M , #bvar ( N <= L )

  rule #bvar ( N:Name           <! _:Name ) => N
  rule #bvar ( M:Name , N:Name  <! _:Name ) => M , N
  rule #bvar ( M:Name , N:Names <! L:Name ) => M , #bvar ( N <! L )

//--------------
//--- #bvars ---
//--------------
  rule #bvars ( B:Lbind ; C:Lbind  ) => #bvar(B) , #bvar (C)
  rule #bvars ( B:Lbind ; C:Lbinds ) => #bvar(B) , #bvars(C)

  rule #bvars ( B:Rbind ; C:Rbind  ) => #bvar(B) , #bvar (C)
  rule #bvars ( B:Rbind ; C:Rbinds ) => #bvar(B) , #bvars(C)

  rule #bvars ( B:Pbind ; C:Pbind  ) => #bvar(B) , #bvar (C)
  rule #bvars ( B:Pbind ; C:Pbinds ) => #bvar(B) , #bvars(C)

//-------------------
//--- #chanlen ---
//-------------------
  rule #chanlen ( A:Name  <- B:Name   ) => SetItem((B, #length (A)))
  rule #chanlen ( A:Names <- B:Name   ) => SetItem((B, #length (A)))
  rule #chanlen ( A:Lbind ;  B:Lbind  ) => #chanlen(A) #chanlen(B)
  rule #chanlen ( A:Lbind ;  B:Lbinds ) => #chanlen(A) #chanlen(B)

  rule #chanlen ( A:Name  <= B:Name   ) => SetItem((B, #length (A)))
  rule #chanlen ( A:Names <= B:Name   ) => SetItem((B, #length (A)))
  rule #chanlen ( A:Rbind ;  B:Rbind  ) => #chanlen(A) #chanlen(B)
  rule #chanlen ( A:Rbind ;  B:Rbinds ) => #chanlen(A) #chanlen(B)

  rule #chanlen ( A:Name  <! B:Name   ) => SetItem((B, #length (A)))
  rule #chanlen ( A:Names <! B:Name   ) => SetItem((B, #length (A)))
  rule #chanlen ( A:Pbind ;  B:Pbind  ) => #chanlen(A) #chanlen(B)
  rule #chanlen ( A:Pbind ;  B:Pbinds ) => #chanlen(A) #chanlen(B)

  rule #chanmany ( (A:Name , I:Int) : B:Bind             ) => #if (A,I) in #chanlen(B) #then 1                         #else 0                  #fi
  rule #chanmany ( (A:Name , I:Int) : B:Lbind ; C:Lbind  ) => #if (A,I) in #chanlen(B) #then 1 +Int #chanmany((A,I):C) #else #chanmany((A,I):C) #fi
  rule #chanmany ( (A:Name , I:Int) : B:Lbind ; C:Lbinds ) => #if (A,I) in #chanlen(B) #then 1 +Int #chanmany((A,I):C) #else #chanmany((A,I):C) #fi

  rule #chanmany ( (A:Name , I:Int) : B:Rbind ; C:Rbind  ) => #if (A,I) in #chanlen(B) #then 1 +Int #chanmany((A,I):C) #else #chanmany((A,I):C) #fi
  rule #chanmany ( (A:Name , I:Int) : B:Rbind ; C:Rbinds ) => #if (A,I) in #chanlen(B) #then 1 +Int #chanmany((A,I):C) #else #chanmany((A,I):C) #fi

  rule #chanmany ( (A:Name , I:Int) : B:Pbind ; C:Pbind  ) => #if (A,I) in #chanlen(B) #then 1 +Int #chanmany((A,I):C) #else #chanmany((A,I):C) #fi
  rule #chanmany ( (A:Name , I:Int) : B:Pbind ; C:Pbinds ) => #if (A,I) in #chanlen(B) #then 1 +Int #chanmany((A,I):C) #else #chanmany((A,I):C) #fi

endmodule