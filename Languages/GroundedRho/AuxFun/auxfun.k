// Auxilary functions for GRHO configuration
// #lengths of RhoTuple | Names | Procs | Binds
// #chans of Binds
// #bvars of Binds

requires "../grho.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

  syntax    Int ::= "#length"        RhoTuple                [function]  // #length: RhoTuple ------------------> Int
                  | "#length"    "(" Name  ")"               [function]  // #length(_): Name -------------------> Int
                  | "#length"    "(" Names ")"               [function]  // #length(_): Names ------------------> Int
                  | "#length"    "(" Bind  ")"               [function]  // #length(_): Bind -------------------> Int
                  | "#length"    "(" Binds ")"               [function]  // #length(_): Binds ------------------> Int
                  | "#chanmany"  "(" Name     ":" Set   ")"  [function]  // #chanmany(_:_): Name x Set ---------> Int
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

  syntax  Procs ::= "#lengths"   "(" Binds ")"               [function]  //   #length(_): Binds ------> Procs

  syntax   Name ::= "#chan"      "(" Bind  ")"               [function]  //     #chan(_): Bind -------> Name
                  | "#bvar"      "(" Bind  ")"               [function]  //     #bvar(_): Bind -------> Name

  syntax  Names ::= "#chan"      "(" Binds ")"               [function]  //    #chans(_): Binds ------> Names
                  | "#bvar"      "(" Bind  ")"               [function]  //     #bvar(_): Bind -------> Name
                  | "#bvar"      "(" Binds ")"               [function]  //    #bvars(_): Binds ------> Names

  syntax   Bool ::= Int   "#in"      RhoTuple                [function]  // _#in_: Int x RhoTuple ---> Bool
                  | Name  "#in"  "(" Name  ")"               [function]  // _#in_: Name x Name  -----> Bool
                  | Name  "#in"  "(" Names ")"               [function]  // _#in_: Name x Names -----> Bool
                  | Bind  "#in"  "(" Bind  ")"               [function]  // _#in_: Bind  x Bind -----> Bool
                  | Bind  "#in"  "(" Binds ")"               [function]  // _#in_: Bind  x Binds ----> Bool
                  | Binds "#in"  "(" Binds ")"               [function]  // _#in_: Binds x Binds ----> Bool
                  | Bind  "#ine" "(" Bind  ")"               [function]  // _#ine_: Bind x Bind -----> Bool
                  | Bind  "#ine" "(" Binds ")"               [function]  // _#ine_: Bind x Binds ----> Bool
                  | Binds "#ine" "(" Binds ")"               [function]  // _#ine_: Binds x Binds ---> Bool

  syntax String ::= "toString("      Proc  ")"
                  | "toString("      Name  ")"
                  | "toString("      Bind  ")"
                  | "toString("      Binds ")"

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= Int | Procs | Name

//-----------
//--- #in ---
//-----------
// Int #in RhoTuple
  rule A:Int #in ( B:Int           ) => A ==Int B
  rule A:Int #in ( B:Int , C:Int   ) => A ==Int B orBool A ==Int C
  rule A:Int #in ( B:Int , C:Procs ) => A ==Int B orBool A #in  (C)

// Name #in NameTuple
  rule A:Name #in ( B:Name           ) => toString(A) ==String toString(B)
  rule A:Name #in ( B:Name , C:Name  ) => toString(A) ==String toString(B) orBool toString(A) ==String toString(C)
  rule A:Name #in ( B:Name , C:Names ) => toString(A) ==String toString(B) orBool A #in (C)

// Bind(s) #in BindTuple
// checks binding occurence set inclusion
  rule A:Bind  #in  ( B:Bind  ) => #bindocc(A) <=Set #bindocc(B)
  rule A:Bind  #in  ( B:Binds ) => #bindocc(A) <=Set #bindocc(B)
  rule A:Binds #in  ( B:Binds ) => #bindocc(A) <=Set #bindocc(B)

// checks explicit binding occurence set inclusion
  rule A:Bind  #ine ( B:Bind  ) => #bindocce(A) <=Set #bindocce(B)
  rule A:Bind  #ine ( B:Binds ) => #bindocce(A) <=Set #bindocce(B)
  rule A:Binds #ine ( B:Binds ) => #bindocce(A) <=Set #bindocce(B)

//---------------
//--- #length ---
//---------------
// RhoTuple
  rule #length ( _:Proc           ) => 1
  rule #length ( _:Proc , _:Proc  ) => 2
  rule #length ( _:Proc , P:Procs ) => 1 +Int #length (P)

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
// comma-separated list of channels involved in bindings
  rule #chan ( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Lbind ; C:Lbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Rbind ; C:Rbinds ) => #chan(B) , #chan(C)

  rule #chan ( B:Pbind ; C:Pbind  ) => #chan(B) , #chan(C)
  rule #chan ( B:Pbind ; C:Pbinds ) => #chan(B) , #chan(C)

//-------------
//--- #bvar ---
//-------------
// binding variables
  rule #bvar ( N:Name  <- _:Name ) => N
  rule #bvar ( N:Names <- _:Name ) => N
  rule #bvar ( N:Name  <= _:Name ) => N
  rule #bvar ( N:Names <= _:Name ) => N
  rule #bvar ( N:Name  <! _:Name ) => N
  rule #bvar ( N:Names <! _:Name ) => N

  rule #bvar ( B:Lbind ; C:Lbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Lbind ; C:Lbinds ) => #bvar(B) , #bvar(C)

  rule #bvar ( B:Rbind ; C:Rbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Rbind ; C:Rbinds ) => #bvar(B) , #bvar(C)

  rule #bvar ( B:Pbind ; C:Pbind  ) => #bvar(B) , #bvar(C)
  rule #bvar ( B:Pbind ; C:Pbinds ) => #bvar(B) , #bvar(C)

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
  rule #bindocc ( A:Bind ) => SetItem( #chan(A) ; #length(A) ;; 1 )

// Linear join
  rule #bindocc ( A:Lbind ; B:Lbind  )
       => #if #bindocc(A) <=Set #bindocc(B)
          #then SetItem( #chan(A) ; #length(A) ;; 2 ) (#bindocc(B) -Set #bindocc(A) )
          #else #bindocc(A) #bindocc(B)
          #fi
  rule #bindocc ( A:Lbind ; B:Lbinds )
       => #if #chanmany((#chan(A) ; #length(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #length(A) ;; 1 +Int #chanmany((#chan(A);#length(A)):B) ) (#bindocc(B) -Set SetItem( #chan(A) ; #length(A) ;; #chanmany((#chan(A);#length(A)):B)))
          #else #bindocc(A) #bindocc(B)
          #fi

// Repeated join
  rule #bindocc ( A:Rbind ; B:Rbind  )
       => #if #bindocc(A) <=Set #bindocc(B)
          #then SetItem( #chan(A) ; #length(A) ;; 2 ) (#bindocc(B) -Set #bindocc(A) )
          #else #bindocc(A) #bindocc(B)
          #fi
  rule #bindocc ( A:Rbind ; B:Rbinds )
       => #if #chanmany((#chan(A) ; #length(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #length(A) ;; 1 +Int #chanmany((#chan(A);#length(A)):B) ) (#bindocc(B) -Set SetItem( #chan(A) ; #length(A) ;; #chanmany((#chan(A);#length(A)):B)))
          #else #bindocc(A) #bindocc(B)
          #fi

// Peek join
  rule #bindocc ( A:Pbind ; B:Pbind  )
       => #if #bindocc(A) <=Set #bindocc(B)
          #then SetItem( #chan(A) ; #length(A) ;; 2 ) (#bindocc(B) -Set #bindocc(A) )
          #else #bindocc(A) #bindocc(B)
          #fi
  rule #bindocc ( A:Pbind ; B:Pbinds )
       => #if #chanmany((#chan(A) ; #length(A)) : B ) =/=Int 0
          #then SetItem( #chan(A) ; #length(A) ;; 1 +Int #chanmany((#chan(A);#length(A)):B) ) (#bindocc(B) -Set SetItem( #chan(A) ; #length(A) ;; #chanmany((#chan(A);#length(A)):B)))
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

endmodule