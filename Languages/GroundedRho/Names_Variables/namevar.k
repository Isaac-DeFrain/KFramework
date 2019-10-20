// Names and Variables for RHO CALCULUS with additional Ground terms

require "domains.k"
require "../grho.k"
require "../AuxFun/auxfun.k"

module NAMEVAR-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Arguments
  syntax     Arg ::= NamePats
                   | ProcPats
                   | RhoKVPats
                   | AnyBindPat
                   | AnyBindPats
                   | MCasePats
                   | BranchPats
                   | MethodArgPats
                   | InterpMaps
                   | LetBind
                   | SeqLetBinds
                   | SimLetBinds
                   | SeqSimLetBinds
                   | Set
                   | Map

// Typed Sets
  syntax     Set ::=  "FV("   Arg     ")" [function] // free variables
                   | "FV+("   Arg     ")" [function] // auxiliary for bound variables
                   |  "BV("   Arg     ")" [function] // bound variables
                   |  "RV("   Arg     ")" [function] // receive variables
                   | "RV+("   Arg     ")" [function] // auxiliary for bound variables
                   |  "RN("   Arg     ")" [function] // receive names
                   |  "SV("   Arg     ")" [function] // send variables
                   | "SV+("   Arg     ")" [function] // auxiliary for bound variables
                   |  "SN("   Arg     ")" [function] // send names
                   |   "V("   Arg     ")" [function] // variables
                   |  "Vn("  Name     ")" [function] // Name variables
                   |  "Vp("  Proc     ")" [function] // Proc variables
                   |  "Vn("  NamePat  ")" [function] // NamePat variables
                   |  "Vp("  ProcPat  ")" [function] // ProcPat variables
                   |  "LV("   Arg     ")" [function] // listening variables
                   | "LV+("   Arg     ")" [function] // auxiliary for bound variables

// Untyped Sets
  syntax     Set ::=  "#FV("  Arg  ")" [function] // free variables
                   |  "#DV("  Arg  ")" [function] // declared variables
                   |  "#BV("  Arg  ")" [function] // bound variables
                   |  "#RV("  Arg  ")" [function] // receive variables
                   |  "#RN("  Arg  ")" [function] // receive names
                   |  "#SV("  Arg  ")" [function] // send variables
                   |  "#SN("  Arg  ")" [function] // send names
                   |   "#V("  Arg  ")" [function] // variables
                   |  "#LV("  Arg  ")" [function] // listening variables
                   | "#RN+("  Arg  ")" [function] // nested receive names
                   | "#FNV("  Arg  ")" [function] // free Name variables
                   |  "#NV("  Arg  ")" [function] // Name variables
                   | "#FPV("  Arg  ")" [function] // free Proc variables
                   |  "#PV("  Arg  ")" [function] // Proc variables

  syntax     Set ::=     "#VarContext(" Proc ")" [function] // common Name & Proc variables
                   | "#FreeVarContext(" Proc ")" [function] // common free Name & Proc variables

  syntax     Set ::= "Msg(" Name ";" Names    ";" Proc ")" [function] // messages on Name matching Names in state Proc
                   | "Msg(" Name ";" NamePats ";" Proc ")" [function] // messages on Name matching NamePats in state Proc

  syntax    Name ::= "flatten(" Set ")" [function]
  syntax   Names ::= "flatten(" Set ")" [function]
  syntax    Proc ::= "flatten(" Set ")" [function]
  syntax   Procs ::= "flatten(" Set ")" [function]

// For sets
  syntax    Kind ::= "name" | "proc" | "namepat" | "procpat"
  syntax KindArg ::= Arg ":" Kind
  syntax   KItem ::= Var | ProcVar | TypedName | TypedProc | KindArg

endmodule


module NAMEVAR
  import NAMEVAR-SYNTAX
  import AUXFUN

  syntax KResult ::= Set

//-----------------
//--- Variables ---
//-----------------
// Ground & Bound
  rule  V( _:Ground    ) => .Set
  rule  V(   EmptyN    ) => .Set
  rule  V(   EmptyP    ) => .Set
  rule #V( _:Ground    ) => .Set
  rule #V(   EmptyN    ) => .Set
  rule #V(   EmptyP    ) => .Set

  rule  V( A:BoundName ) => SetItem(A)
  rule  V( A:BoundProc ) => SetItem(A)
  rule #V( A:BoundName ) => SetItem(A)
  rule #V( A:BoundProc ) => SetItem(A)

// Pattern
  // WildCard
  rule  V( \_ ) => .Set
  rule #V( \_ ) => .Set
  // Simple patterns
  rule  V( _:SimplePat     ) => .Set
  rule  V( _:SimpleNamePat ) => .Set
  rule #V( _:SimplePat     ) => .Set
  rule #V( _:SimpleNamePat ) => .Set

// Variables
  rule Vn( A:Var     ) => SetItem(A : name)
  rule Vp( A:ProcVar ) => SetItem(A : proc)
//  rule Vn( A:PatVar  ) => SetItem(A : namepat) requires notBool     isVar(A)
//  rule Vp( A:PatVar  ) => SetItem(A : procpat) requires notBool isProcVar(A)
  rule Vn( A:Name    ) => V(A) requires notBool     isVar(A)
  rule Vp( A:Proc    ) => V(A) requires notBool isProcVar(A)

  rule  V( A:ProcVar ) => Vp(A)      requires notBool isBoundProc(A)
  rule #V( A:ProcVar ) => SetItem(A) requires notBool isBoundProc(A)

  // TypedProcs
  rule  V( (*A:Var)    :: B:ProcPat ) => Vn(A)  V(B)
  rule  V(   A:ProcVar :: B:Proc    ) => Vp(A)  V(B)
  rule  V(   A:ProcVar :: B:ProcPat ) => Vp(A)  V(B)
  rule #V( (*A:Var)    :: B:ProcPat ) => #V(A) #V(B)
  rule #V(   A:ProcVar :: B:ProcPat ) => #V(A) #V(B)

// Names
  // Primitive Names
  rule  V( A:Var           ) => Vn(A)
  rule  V( A:Var ( _:Uri ) ) => Vn(A)
  rule #V( A:Var           ) => SetItem(A)
  rule #V( A:Var ( _:Uri ) ) => SetItem(A)

  // TypedNames
  rule  V(    A:Var     :: B:NamePat ) => Vn(A)  V(B)
  rule  V( (@A:ProcVar) :: B:NamePat ) => Vp(A)  V(B)
  rule #V(    A:Var     :: B:NamePat ) => #V(A) #V(B)
  rule #V( (@A:ProcVar) :: B:NamePat ) => #V(A) #V(B)

// Quote
  rule  V( @A:ProcVar ) => Vp(A)
  rule #V( @A:ProcVar ) => SetItem(A)

  rule  V( @A:ProcPat ) =>  V(A) requires notBool isProcVar(A)
  rule #V( @A:ProcPat ) => #V(A) requires notBool isProcVar(A)

  // NamePats
  rule  V( A:NamePat , B:NamePats ) =>  V(A)  V(B)
  rule #V( A:NamePat , B:NamePats ) => #V(A) #V(B)

// Pattern Expressions
  rule  V( ~ A:ProcPat ) =>  V(A)
  rule  V( A:ProcPat /\ B:ProcPat ) =>  V(A)  V(B)
  rule  V( A:ProcPat \/ B:ProcPat ) =>  V(A)  V(B)
  rule #V( ~ A:ProcPat ) => #V(A)
  rule #V( A:ProcPat /\ B:ProcPat ) => #V(A) #V(B)
  rule #V( A:ProcPat \/ B:ProcPat ) => #V(A) #V(B)

// Receives, Binds, Contracts
  // Guard variables should be contained in the listening variables, i.e. #FV(Guard) <=Set #LV(Rec)
  // Receive pattern
  rule  V( for( B:LbindPat            ) { C:ProcPat } ) =>  V(B)   V(C)
  rule  V( for( B:LbindPat  if G:BExp ) { C:ProcPat } ) =>  V(B)  (V(G)  V(C))
  rule  V( for( B:PbindPat            ) { C:ProcPat } ) =>  V(B)   V(C)
  rule  V( for( B:PbindPat  if G:BExp ) { C:ProcPat } ) =>  V(B)  (V(G)  V(C))
  rule  V( for( B:RbindPat            ) { C:ProcPat } ) =>  V(B)   V(C)
  rule  V( for( B:RbindPat  if G:BExp ) { C:ProcPat } ) =>  V(B)  (V(G)  V(C))
  rule  V( for( B:LbindPats           ) { C:ProcPat } ) =>  V(B)   V(C)
  rule  V( for( B:LbindPats if G:BExp ) { C:ProcPat } ) =>  V(B)  (V(G)  V(C))
  rule  V( for( B:PbindPats           ) { C:ProcPat } ) =>  V(B)   V(C)
  rule  V( for( B:PbindPats if G:BExp ) { C:ProcPat } ) =>  V(B)  (V(G)  V(C))
  rule  V( for( B:RbindPats           ) { C:ProcPat } ) =>  V(B)   V(C)
  rule  V( for( B:RbindPats if G:BExp ) { C:ProcPat } ) =>  V(B)  (V(G)  V(C))
  rule #V( for( B:LbindPat            ) { C:ProcPat } ) => #V(B)  #V(C)
  rule #V( for( B:LbindPat  if G:BExp ) { C:ProcPat } ) => #V(B) (#V(G) #V(C))
  rule #V( for( B:PbindPat            ) { C:ProcPat } ) => #V(B)  #V(C)
  rule #V( for( B:PbindPat  if G:BExp ) { C:ProcPat } ) => #V(B) (#V(G) #V(C))
  rule #V( for( B:RbindPat            ) { C:ProcPat } ) => #V(B)  #V(C)
  rule #V( for( B:RbindPat  if G:BExp ) { C:ProcPat } ) => #V(B) (#V(G) #V(C))
  rule #V( for( B:LbindPats           ) { C:ProcPat } ) => #V(B)  #V(C)
  rule #V( for( B:LbindPats if G:BExp ) { C:ProcPat } ) => #V(B) (#V(G) #V(C))
  rule #V( for( B:PbindPats           ) { C:ProcPat } ) => #V(B)  #V(C)
  rule #V( for( B:PbindPats if G:BExp ) { C:ProcPat } ) => #V(B) (#V(G) #V(C))
  rule #V( for( B:RbindPats           ) { C:ProcPat } ) => #V(B)  #V(C)
  rule #V( for( B:RbindPats if G:BExp ) { C:ProcPat } ) => #V(B) (#V(G) #V(C))

  // BindPat
  rule  V( B:NamePats <-  A:NamePat ) =>  V(A)  V(B)
  rule  V(            <-  A:NamePat ) =>  V(A)
  rule  V( B:NamePats <<- A:NamePat ) =>  V(A)  V(B)
  rule  V(            <<- A:NamePat ) =>  V(A)
  rule  V( B:NamePats <=  A:NamePat ) =>  V(A)  V(B)
  rule  V(            <=  A:NamePat ) =>  V(A)
  rule #V( B:NamePats <-  A:NamePat ) => #V(A) #V(B)
  rule #V(            <-  A:NamePat ) => #V(A)
  rule #V( B:NamePats <<- A:NamePat ) => #V(A) #V(B)
  rule #V(            <<- A:NamePat ) => #V(A)
  rule #V( B:NamePats <=  A:NamePat ) => #V(A) #V(B)
  rule #V(            <=  A:NamePat ) => #V(A)
  // BindPats
  rule  V( A:LbindPat & B:LbindPat  ) =>  V(A)  V(B)
  rule  V( A:LbindPat & B:LbindPats ) =>  V(A)  V(B)
  rule  V( A:PbindPat & B:PbindPat  ) =>  V(A)  V(B)
  rule  V( A:PbindPat & B:PbindPats ) =>  V(A)  V(B)
  rule  V( A:RbindPat & B:RbindPat  ) =>  V(A)  V(B)
  rule  V( A:RbindPat & B:RbindPats ) =>  V(A)  V(B)
  rule #V( A:LbindPat & B:LbindPat  ) => #V(A) #V(B)
  rule #V( A:LbindPat & B:LbindPats ) => #V(A) #V(B)
  rule #V( A:PbindPat & B:PbindPat  ) => #V(A) #V(B)
  rule #V( A:PbindPat & B:PbindPats ) => #V(A) #V(B)
  rule #V( A:RbindPat & B:RbindPat  ) => #V(A) #V(B)
  rule #V( A:RbindPat & B:RbindPats ) => #V(A) #V(B)

  // ContractPat
  rule #V( contract A:NamePat ( B:NamePats ) = { C:ProcPat } ) => #V(A) (#V(B) #V(C))
  rule #V( contract A:NamePat (            ) = { C:ProcPat } ) => #V(A)  #V(C)

  // InvocationPat
  rule  V( A:NamePat ( B:NamePats ) ) =>  V(A)  V(B)
  rule  V( A:NamePat (            ) ) =>  V(A)
  rule #V( A:NamePat ( B:NamePats ) ) => #V(A) #V(B)
  rule #V( A:NamePat (            ) ) => #V(A)

// SendPat
  rule  V( A:NamePat !  ( B:ProcPats ) ) =>  V(A)  V(B)
  rule  V( A:NamePat !  (            ) ) =>  V(A)
  rule #V( A:NamePat !  ( B:ProcPats ) ) => #V(A) #V(B)
  rule #V( A:NamePat !  (            ) ) => #V(A)

// ParPat
  rule  V( A:ProcPat | B:ProcPat ) =>  V(A)  V(B)
  rule #V( A:ProcPat | B:ProcPat ) => #V(A) #V(B)

// EvalPat
  rule  V( *A:Var     ) => Vn(A)
  rule  V( *A:NamePat ) =>  V(A) requires notBool isVar(A)
  rule #V( *A:Var     ) => SetItem(A)
  rule #V( *A:NamePat ) => #V(A) requires notBool isVar(A)

// ProcPats
  rule  V( A:ProcPat , B:ProcPats ) =>  V(A)  V(B)
  rule #V( A:ProcPat , B:ProcPats ) => #V(A) #V(B)

//Collections
  // RhoList
  rule  V( [ A:ProcPats ... B:ProcVar ] ) =>  V(A) V(B)
  rule  V( [ A:ProcPats ] ) =>  V(A)
  rule  V(  EmptyListPat  ) => .Set
  rule  V( [            ] ) => .Set
  rule #V( [ A:ProcPats ... B:ProcVar ] ) => #V(A) SetItem(B)
  rule #V( [ A:ProcPats ] ) => #V(A)
  rule #V(  EmptyListPat  ) => .Set
  rule #V( [ ] ) => .Set
  // RhoMap
  rule  V( { A:RhoKVPats ... B:ProcVar } ) =>  V(A) V(B)
  rule  V( { A:RhoKVPats } ) =>  V(A)
  rule  V(   EmptyMapPat   ) => .Set
  rule  V( {             } ) => .Set
  rule #V( { A:RhoKVPats ... B:ProcVar } ) => #V(A) SetItem(B)
  rule #V( { A:RhoKVPats } ) => #V(A)
  rule #V(   EmptyMapPat   ) => .Set
  rule #V( {             } ) => .Set
    // KV pairs
  rule  V( A:ProcPat  : B:ProcPat   ) =>  V(A)  V(B)
  rule  V( A:RhoKVPat , B:RhoKVPats ) =>  V(A)  V(B)
  rule #V( A:ProcPat  : B:ProcPat   ) => #V(A) #V(B)
  rule #V( A:RhoKVPat , B:RhoKVPats ) => #V(A) #V(B)
  // RhoSet
  rule  V( Set( A:ProcPats ... B:ProcVar ) ) =>  V(A) V(B)
  rule  V( Set( A:ProcPats ) ) =>  V(A)
  rule  V(     EmptySetPat   ) => .Set
  rule  V( Set(            ) ) => .Set
  rule #V( Set( A:ProcPats ... B:ProcVar ) ) => #V(A) SetItem(B)
  rule #V( Set( A:ProcPats ) ) => #V(A)
  rule #V(     EmptySetPat   ) => .Set
  rule #V( Set(            ) ) => .Set
  // RhoTuple
  rule  V( ( A:ProcPats ,) ) =>  V(A)
  rule #V( ( A:ProcPats ,) ) => #V(A)

// Variable Reference
  rule  V( =  A:ProcVar ) => Vp(A)
  rule  V( =* A:Var     ) => Vn(A)
  rule #V( =  A:ProcVar ) => SetItem(A)
  rule #V( =* A:Var     ) => SetItem(A)

// Bundles
  rule  V( bundle+{ A:Proc } ) =>  V(A)
  rule  V( bundle-{ A:Proc } ) =>  .Set
  rule  V( bundle0{ A:Proc } ) =>  .Set
  rule  V(  bundle{ A:Proc } ) =>  V(A)
  rule #V( bundle+{ A:Proc } ) => #V(A)
  rule #V( bundle-{ A:Proc } ) =>  .Set
  rule #V( bundle0{ A:Proc } ) =>  .Set
  rule #V(  bundle{ A:Proc } ) => #V(A)

// NewPat
  rule  V( new A:VarDecs in { B:ProcPat } ) =>  V(A)  V(B)
  rule #V( new A:VarDecs in { B:ProcPat } ) => #V(A) #V(B)

// CondPat
  rule  V( if  ( A:BExp )   B:ProcPat ) =>  V(A)  V(B)
  rule  V( A:IfThenPat else B:ProcPat ) =>  V(A)  V(B)
  rule #V( if  ( A:BExp )   B:ProcPat ) => #V(A) #V(B)
  rule #V( A:IfThenPat else B:ProcPat ) => #V(A) #V(B)

// MatchPat
  rule  V( match A:ProcPat { B:MCasePats  } ) =>  V(A)  V(B)
  rule #V( match A:ProcPat { B:MCasePats  } ) => #V(A) #V(B)
  // MCasePats
  rule  V( { A:ProcPat } |=> B:ProcPat ) =>  V(A)  V(B)
  rule  V(   A:MCasePat  B:MCasePats   ) =>  V(A)  V(B)
  rule #V( { A:ProcPat } |=> B:ProcPat ) => #V(A) #V(B)
  rule #V(   A:MCasePat  B:MCasePats   ) => #V(A) #V(B)

// SelectPat
  rule  V(    select {    B:BranchPats }  ) =>  V(B)
  rule  V(   A:BranchPat  B:BranchPats    ) =>  V(A)  V(B)
  rule  V( { A:LbindPat   } |=> B:ProcPat ) =>  V(A)  V(B)
  rule  V( { A:GLbindPat  } |=> B:ProcPat ) =>  V(A)  V(B)
  rule  V( { A:LbindPats  } |=> B:ProcPat ) =>  V(A)  V(B)
  rule  V( { A:GLbindPats } |=> B:ProcPat ) =>  V(A)  V(B)
  rule #V(    select {    B:BranchPats }  ) => #V(B)
  rule #V(   A:BranchPat  B:BranchPats    ) => #V(A) #V(B)
  rule #V( { A:LbindPat   } |=> B:ProcPat ) => #V(A) #V(B)
  rule #V( { A:GLbindPat  } |=> B:ProcPat ) => #V(A) #V(B)
  rule #V( { A:LbindPats  } |=> B:ProcPat ) => #V(A) #V(B)
  rule #V( { A:GLbindPats } |=> B:ProcPat ) => #V(A) #V(B)

// MethodPat
  rule  V( A:ProcPat B:MethodArgPats ) =>  V(A)  V(B)
  rule  V( . _:Method ( A:ProcPats ) ) =>  V(A)
  rule  V( . _:Method (            ) ) => .Set
  rule #V( A:ProcPat B:MethodArgPats ) => #V(A) #V(B)
  rule #V( . _:Method ( A:ProcPats ) ) => #V(A)
  rule #V( . _:Method (            ) ) => .Set

// Arithmetic Expressions
  rule  V( - A:AExp        ) => V(A)
  rule  V( A:AExp * B:AExp ) => V(A) V(B)
  rule  V( A:AExp / B:AExp ) => V(A) V(B)
  rule  V( A:AExp + B:AExp ) => V(A) V(B)
  rule  V( A:AExp - B:AExp ) => V(A) V(B)
  rule  V( A:AExp % B:AExp ) => V(A) V(B)
  rule  V( A:StringOrVar ++ B:StringOrVar ) => V(A) V(B)
  rule  V( A:StringOrVar ++ B:ConcatStr   ) => V(A) V(B)
  rule  V( A:ListOrVar   ++ B:ListOrVar   ) => V(A) V(B)
  rule  V( A:ListOrVar   ++ B:ConcatList  ) => V(A) V(B)
  rule  V( A:StringOrVar %% B:InterpMaps  ) => V(A) V(B)
  rule  V( A:RhoMap      %% B:InterpMaps  ) => V(A) V(B)
  rule #V( - A:AExp        ) => #V(A)
  rule #V( A:AExp * B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp / B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp + B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp - B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp % B:AExp ) => #V(A) #V(B)
  rule #V( A:StringOrVar ++ B:StringOrVar ) => #V(A) #V(B)
  rule #V( A:StringOrVar ++ B:ConcatStr   ) => #V(A) #V(B)
  rule #V( A:ListOrVar   ++ B:ListOrVar   ) => #V(A) #V(B)
  rule #V( A:ListOrVar   ++ B:ConcatList  ) => #V(A) #V(B)
  rule #V( A:StringOrVar %% B:InterpMaps  ) => #V(A) #V(B)
  rule #V( A:RhoMap      %% B:InterpMaps  ) => #V(A) #V(B)

// Boolean Expressions
  rule  V( not B:BExp        ) =>  V(B)
  rule  V( A:BExp and B:BExp ) =>  V(A)  V(B)
  rule  V( A:BExp or  B:BExp ) =>  V(A)  V(B)
  rule  V( A:AExp <=  B:AExp ) =>  V(A)  V(B)
  rule  V( A:AExp <   B:AExp ) =>  V(A)  V(B)
  rule  V( A:AExp >=  B:AExp ) =>  V(A)  V(B)
  rule  V( A:AExp >   B:AExp ) =>  V(A)  V(B)
  rule  V( A:Proc ==  B:Proc ) =>  V(A)  V(B)
  rule  V( A:Proc !=  B:Proc ) =>  V(A)  V(B)
  rule  V( A:Name ==  B:Name ) =>  V(A)  V(B)
  rule  V( A:Name !=  B:Name ) =>  V(A)  V(B)
  rule  V( A:Proc    matches B:Proc    ) => V(A) V(B)
  rule  V( A:Proc    matches B:ProcPat ) => V(A) V(B)
  rule  V( A:ProcPat matches B:ProcPat ) => V(A) V(B)
  rule #V( not B:BExp        ) => #V(B)
  rule #V( A:BExp and B:BExp ) => #V(A) #V(B)
  rule #V( A:BExp or  B:BExp ) => #V(A) #V(B)
  rule #V( A:AExp <=  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp <   B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp >=  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp >   B:AExp ) => #V(A) #V(B)
  rule #V( A:Proc ==  B:Proc ) => #V(A) #V(B)
  rule #V( A:Proc !=  B:Proc ) => #V(A) #V(B)
  rule #V( A:Name ==  B:Name ) => #V(A) #V(B)
  rule #V( A:Name !=  B:Name ) => #V(A) #V(B)
  rule #V( A:Proc    matches B:Proc    ) => #V(A) #V(B)
  rule #V( A:Proc    matches B:ProcPat ) => #V(A) #V(B)
  rule #V( A:ProcPat matches B:ProcPat ) => #V(A) #V(B)
/*
// Nullity
  rule #V( Null ) => .Set
// Recursion
  rule #V( rec A:PatVar . B:ProcPat ) => SetItem(A) #V(B)
// Quantification
  rule #V( \forall A:Var     :: B:NamePat . C:ProcPat ) => SetItem(A) (#V(B) #V(C))
  rule #V( \forall A:ProcVar :: B:ProcPat . C:ProcPat ) => SetItem(A) (#V(B) #V(C))
  rule #V( \forall A:Var      . B:ProcPat ) => SetItem(A) #V(B)
  rule #V( \forall A:ProcVar  . B:ProcPat ) => SetItem(A) #V(B)
*/
// TODO: other Pattern expressions

//----------------------
//--- Free Variables ---
//----------------------
// Auxiliary function for bindings in Receives, New, Match & Select
  rule FV+( A:Var           ) => SetItem(A : name) SetItem(*A : proc) requires notBool isBoundName(A)
  rule FV+( A:Var ( _:Uri ) ) => SetItem(A : name) SetItem(*A : proc) requires notBool isBoundName(A)

  // TypedNames
  rule FV+(   A:Var      :: B:NamePat ) => FV+(A) FV+(B)
  rule FV+( (@A:ProcVar) :: B:NamePat ) => FV+(A) FV+(B)

  // Ground, Bound
  rule FV+( _:Ground    ) => .Set
  rule FV+( _:BoundName ) => .Set
  rule FV+( _:BoundProc ) => .Set

// Pattern
  rule FV+( \_ ) => .Set
  rule FV+( _:SimplePat     ) => .Set
  rule FV+( _:SimpleNamePat ) => .Set

  // PatExp
  rule FV+( ~ A:ProcPat ) => FV+(A)
  rule FV+( A:ProcPat /\ B:ProcPat ) => FV+(A) FV+(B)
  rule FV+( A:ProcPat \/ B:ProcPat ) => FV+(A) FV+(B)

  // ProcVar
  rule FV+( \X:Var ) => SetItem(\X : proc) SetItem(@\X : name)

  // TypedProcs
  rule FV+( (*A:Var)    :: B:ProcPat ) => FV+(*A) FV+(B)
  rule FV+(   A:ProcVar :: B:ProcPat ) => FV+( A) FV+(B)

  // QuotePat
  rule FV+( @A:ProcPat ) => FV+(A)

  // Receives, Binds, Contract, Invocation
    // free variables of a Receive are the receive variables (i.e. free variables of the channel) and
    // the free variables of the continuation that are not also listening variables
  rule FV+( for( B:LbindPat  ) { C:ProcPat } ) => RV+(B) (FV+(C) -Set LV+(B))
  rule FV+( for( B:LbindPats ) { C:ProcPat } ) => RV+(B) (FV+(C) -Set LV+(B))
  rule FV+( for( B:PbindPat  ) { C:ProcPat } ) => RV+(B) (FV+(C) -Set LV+(B))
  rule FV+( for( B:PbindPats ) { C:ProcPat } ) => RV+(B) (FV+(C) -Set LV+(B))
  rule FV+( for( B:RbindPat  ) { C:ProcPat } ) => RV+(B) (FV+(C) -Set LV+(B))
  rule FV+( for( B:RbindPats ) { C:ProcPat } ) => RV+(B) (FV+(C) -Set LV+(B))
    // Guarded -- free variables of the Receive or free variables of the Guard or continuation that are not listening variables
  rule FV+( for( B:LbindPat  if G:BExp ) { C:ProcPat } ) => RV+(B) ((FV+(G) FV+(C)) -Set LV+(B))
  rule FV+( for( B:LbindPats if G:BExp ) { C:ProcPat } ) => RV+(B) ((FV+(G) FV+(C)) -Set LV+(B))
  rule FV+( for( B:PbindPat  if G:BExp ) { C:ProcPat } ) => RV+(B) ((FV+(G) FV+(C)) -Set LV+(B))
  rule FV+( for( B:PbindPats if G:BExp ) { C:ProcPat } ) => RV+(B) ((FV+(G) FV+(C)) -Set LV+(B))
  rule FV+( for( B:RbindPat  if G:BExp ) { C:ProcPat } ) => RV+(B) ((FV+(G) FV+(C)) -Set LV+(B))
  rule FV+( for( B:RbindPats if G:BExp ) { C:ProcPat } ) => RV+(B) ((FV+(G) FV+(C)) -Set LV+(B))

    // ContractPat -- same as persistent Receive
  rule FV+( contract X:NamePat ( Y:NamePats ) = { P:ProcPat } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:NamePat (            ) = { P:ProcPat } ) => FV+(for(  <= X){P})

    // InvocationPat
  rule FV+( X:NamePat ( Y:NamePats ) ) => FV+(X) FV+(Y)
  rule FV+( X:NamePat (            ) ) => FV+(X)

  // SendPat
  rule FV+( A:NamePat !  ( B:ProcPats ) ) => FV+(A) FV+(B)
  rule FV+( A:NamePat !  (            ) ) => FV+(A)
  rule FV+( A:NamePat !! ( B:ProcPats ) ) => FV+(A) FV+(B)
  rule FV+( A:NamePat !! (            ) ) => FV+(A)

  // ParPat
  rule FV+( A:ProcPat | B:ProcPat ) => FV+(A) FV+(B) requires notBool isParPat(B)

  // EvalPat
  rule FV+( *A:NamePat ) => FV+(A) requires notBool isVar(A)
    // can use *X as Proc or X as Name
  rule FV+( *A:Var ) => SetItem(*A : proc) SetItem(A : name) requires notBool isBoundName(A)

  // Collections
    // RhoList
  rule FV+( [ A:ProcPats ... B:ProcVar ] ) => FV+(A) FV+(B)
  rule FV+( [ A:ProcPats ] ) => FV+(A)
  rule FV+(  EmptyListPat  ) => .Set
  rule FV+( [            ] ) => .Set
    // RhoMap
  rule FV+( { A:RhoKVPats ... B:ProcVar } ) => FV+(A) FV+(B)
  rule FV+( { A:RhoKVPats } ) => FV+(A)
  rule FV+(   EmptyMapPat   ) => .Set
  rule FV+( {             } ) => .Set
      // KV pairs
  rule FV+( A:ProcPat  : B:ProcPat   ) => FV+(A) FV+(B)
  rule FV+( A:RhoKVPat , B:RhoKVPats ) => FV+(A) FV+(B)
    // RhoSet
  rule FV+( Set( A:ProcPats ... B:ProcVar ) ) => FV+(A) FV+(B)
  rule FV+( Set( A:ProcPats ) ) => FV+(A)
  rule FV+(    EmptySetPat    ) => .Set
  rule FV+( Set(            ) ) => .Set
    // RhoTuple
  rule FV+( ( A:ProcPats ,) ) => FV+(A)

  // Variable Reference
  rule FV+( =  A:ProcVar ) => FV+(@A) // FVp(X)
  rule FV+( =* A:Var     ) => FV+(*A) // FVn(X)

  // NewPat
  rule FV+( new A:VarDecs in { B:ProcPat } ) => FV+(A) -Set FV+(B)

  // CondPat
  rule FV+( if ( A:BExp )    B:ProcPat ) => FV+(A) FV+(B)
  rule FV+( A:IfThenPat else B:ProcPat ) => FV+(A) FV+(B)

  // MatchPat
  rule FV+( match A:ProcPat { B:MCasePats } ) => FV+(A) FV+(B)
    // MCasePats -- free variables in to be matched Proc P are bound in resulting Proc Q ???
  rule FV+( { A:ProcPat } |=> B:ProcPat ) => FV+(A) -Set FV+(B)
  rule FV+(   A:MCasePat B:MCasePats    ) => FV+(A) FV+(B)

  // MethodPat
  rule FV+( A:ProcPat B:MethodArgPats ) => FV+(A) FV+(B)
  rule FV+( . _:Method ( A:ProcPats ) ) => FV+(A)
  rule FV+( . _:Method (            ) ) => .Set

  // Bundles -- TODO: bindings?
  rule FV+( bundle+{ A:Proc } ) => RV+(A)  // write-only => only send names available -- receive variables are free?
  rule FV+( bundle-{ A:Proc } ) => SV+(A)  // read-only  => only receive names available -- send variables are free?
  rule FV+( bundle0{ A:Proc } ) => .Set    // no read/write => no names available
  rule FV+(  bundle{ A:Proc } ) => FV+(A)  // read/write => both send & receive names available

  // Arithmetic Expressions
  rule FV+( - A:AExp         ) => FV+(A)
  rule FV+( A:AExp *  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp /  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp +  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp -  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp %  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:StringOrVar ++ B:StringOrVar ) => FV+(A) FV+(B)
  rule FV+( A:StringOrVar ++ B:ConcatStr   ) => FV+(A) FV+(B)
  rule FV+( A:ListOrVar   ++ B:ListOrVar   ) => FV+(A) FV+(B)
  rule FV+( A:ListOrVar   ++ B:ConcatList  ) => FV+(A) FV+(B)
  rule FV+( A:StringOrVar %% B:InterpMaps  ) => FV+(A) FV+(B)
  rule FV+( A:RhoMap      %% B:InterpMaps  ) => FV+(A) FV+(B)

  // Boolean Expressions
  rule FV+( not A:BExp        ) => FV+(A)
  rule FV+( A:BExp and B:BExp ) => FV+(A) FV+(B)
  rule FV+( A:BExp or  B:BExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp <=  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp <   B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp >=  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp >   B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:Proc ==  B:Proc ) => FV+(A) FV+(B)
  rule FV+( A:Proc !=  B:Proc ) => FV+(A) FV+(B)
  rule FV+( A:Name ==  B:Name ) => FV+(A) FV+(B)
  rule FV+( A:Name !=  B:Name ) => FV+(A) FV+(B)
  rule FV+( A:Proc    matches B:Proc    ) => FV+(A) FV+(B)
  rule FV+( A:Proc    matches B:ProcPat ) => FV+(A) FV+(B)
  rule FV+( A:ProcPat matches B:ProcPat ) => FV+(A) FV+(B)

  // NamePats
  rule FV+( A:NamePat , B:NamePats ) => FV+(A) FV+(B)

  // ProcPats
  rule FV+( A:ProcPat , B:ProcPats ) => FV+(A) FV+(B)

// Ground, Bound
  rule  FV( _:Ground    ) => .Set
  rule  FV( _:BoundName ) => .Set
  rule  FV( _:BoundProc ) => .Set
  rule  FV(   EmptyN    ) => .Set
  rule  FV(   EmptyP    ) => .Set
  rule  FV(   sub       ) => .Set
  rule  FV(   \_        ) => .Set
  rule  FV( _:SimplePat ) => .Set
  rule #FV( _:Ground    ) => .Set
  rule #FV( _:BoundName ) => .Set
  rule #FV( _:BoundProc ) => .Set
  rule #FV(   EmptyN    ) => .Set
  rule #FV(   EmptyP    ) => .Set
  rule #FV(   sub       ) => .Set
  rule #FV(   \_        ) => .Set
  rule #FV( _:SimplePat ) => .Set

// Bundles
  rule  FV( _:Bundle ) => .Set
  rule #FV( _:Bundle ) => .Set

// VarDecs
  rule  FV( A:Var           ) => Vn(A) requires notBool isBoundName(A)
  rule  FV( A:Var ( _:Uri ) ) => Vn(A) requires notBool isBoundName(A)
  rule #FV( A:Var           ) => SetItem(A) requires notBool isBoundName(A)
  rule #FV( A:Var ( _:Uri ) ) => SetItem(A) requires notBool isBoundName(A)

  // TypedNames
  rule  FV(   A:Var      :: B:NamePat ) => Vn(A) FV(B)
  rule  FV( (@A:ProcVar) :: B:NamePat ) => Vp(A) FV(B)
  rule #FV(   A:Var      :: B:NamePat ) => SetItem(A) #FV(B) requires notBool isBoundName(A)
  rule #FV( (@A:ProcVar) :: B:NamePat ) => SetItem(A) #FV(B) requires notBool isBoundProc(A)

// Indexed variables
  rule #FV( A:IndexNVar ) => SetItem(A)
  rule #FV( A:IndexPVar ) => SetItem(A)

// ProcVar
  rule  FV( \X:Var ) => Vp(\X)
  rule #FV( \X:Var ) => SetItem(\X)

  // TypedProcs
  rule  FV(  \A:Var  :: B:Proc    ) => Vp(\A) FV(B)
  rule  FV(  \A:Var  :: B:ProcPat ) => Vp(\A) FV(B)
  rule  FV( (*A:Var) :: B:Proc    ) => Vn( A) FV(B)
  rule  FV( (*A:Var) :: B:ProcPat ) => Vn( A) FV(B)
  rule #FV(  \A:Var  :: B:Proc    ) => SetItem(\A) #FV(B)
  rule #FV(  \A:Var  :: B:ProcPat ) => SetItem(\A) #FV(B)
  rule #FV( (*A:Var) :: B:Proc    ) => SetItem( A) #FV(B)
  rule #FV( (*A:Var) :: B:ProcPat ) => SetItem( A) #FV(B)

// PatVar
//  rule FV( $X:Var ) => Vpat(X)

// Quote
  rule  FV( @A:ProcVar ) =>  Vp(A)
  rule  FV( @A:ProcPat ) =>  FV(A) requires notBool isProcVar(A)
  rule #FV( @A:ProcPat ) => #FV(A)

// Receives, Binds, Contract, Invocation
  // free variables of a Receive are the receive variables or free variables of the continuation that are not listening variables
  rule  FV( for( B:LbindPat  ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:LbindPats ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:PbindPat  ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:PbindPats ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:RbindPat  ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:RbindPats ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule #FV( for( B:LbindPat  ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:LbindPats ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:PbindPat  ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:PbindPats ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:RbindPat  ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:RbindPats ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  // Guarded -- free variables of the Receive or free variables of the Guard or continuation that are not listening variables
  rule  FV( for( B:LbindPat  if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:LbindPats if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:PbindPat  if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:PbindPats if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:RbindPat  if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:RbindPats if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule #FV( for( B:LbindPat  if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:LbindPats if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:PbindPat  if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:PbindPats if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:RbindPat  if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:RbindPats if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  // Contract -- same as Receive
  rule  FV( contract X:NamePat ( Y:NamePats ) = { P:ProcPat } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:NamePat (            ) = { P:ProcPat } ) =>  FV(for(  <= X){P})
  rule #FV( contract X:NamePat ( Y:NamePats ) = { P:ProcPat } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:NamePat (            ) = { P:ProcPat } ) => #FV(for(  <= X){P})
  // Invocation
  rule  FV( X:NamePat ( Y:NamePats ) ) =>  FV(X)  FV(Y)
  rule  FV( X:NamePat (            ) ) =>  FV(X)
  rule #FV( X:NamePat ( Y:NamePats ) ) => #FV(X) #FV(Y)
  rule #FV( X:NamePat (            ) ) => #FV(X)

// Send
  rule  FV( X:NamePat !  ( P:ProcPats ) ) =>  FV(X)  FV(P)
  rule  FV( X:NamePat !  (            ) ) =>  FV(X)
  rule #FV( X:NamePat !  ( P:ProcPats ) ) => #FV(X) #FV(P)
  rule #FV( X:NamePat !  (            ) ) => #FV(X)

// ParPat
  rule  FV( P:ProcPat | Q:ProcPat ) =>  FV(P)  FV(Q)
  rule #FV( P:ProcPat | Q:ProcPat ) => #FV(P) #FV(Q)

// EvalPat
  rule  FV( *X:NamePat ) =>  FV(X)
  rule #FV( *X:NamePat ) => #FV(X)

// LetExp
  rule  FV( let A:LetBind        in { B:Proc } ) =>  RV(A) ( FV(B) -Set LV+(A))
  rule  FV( let A:SimLetBinds    in { B:Proc } ) =>  RV(A) ( FV(B) -Set LV+(A))
  rule  FV( let A:SeqLetBinds    in { B:Proc } ) =>  RV(A) ( FV(B) -Set LV+(A))
  rule  FV( let A:SeqSimLetBinds in { B:Proc } ) =>  RV(A) ( FV(B) -Set LV+(A))
  rule #FV( let A:LetBind        in { B:Proc } ) => #RV(A) (#FV(B) -Set #LV(A))
  rule #FV( let A:SimLetBinds    in { B:Proc } ) => #RV(A) (#FV(B) -Set #LV(A))
  rule #FV( let A:SeqLetBinds    in { B:Proc } ) => #RV(A) (#FV(B) -Set #LV(A))
  rule #FV( let A:SeqSimLetBinds in { B:Proc } ) => #RV(A) (#FV(B) -Set #LV(A))
  // LetBind
  rule  FV( A:LetBind        ) =>  RV(A)
  rule  FV( A:SeqLetBinds    ) =>  RV(A)
  rule  FV( A:SimLetBinds    ) =>  RV(A)
  rule  FV( A:SeqSimLetBinds ) =>  RV(A)
  rule #FV( A:LetBind        ) => #RV(A)
  rule #FV( A:SeqLetBinds    ) => #RV(A)
  rule #FV( A:SimLetBinds    ) => #RV(A)
  rule #FV( A:SeqSimLetBinds ) => #RV(A)

// Collection
  // RhoList
  rule  FV( [            ] ) => .Set
  rule  FV( [ A:ProcPats ] ) =>  FV(A)
  rule  FV( [ A:ProcPats ... B:ProcVar ] ) =>  FV(A) FV(B)
  rule #FV( [            ] ) => .Set
  rule #FV( [ A:ProcPats ] ) => #FV(A)
  rule #FV( [ A:ProcPats ... B:ProcVar ] ) => #FV(A) SetItem(B)
  // RhoMap
  rule  FV( {             } ) => .Set
  rule  FV( { A:RhoKVPats } ) =>  FV(A)
  rule  FV( { A:RhoKVPats ... B:ProcVar } ) =>  FV(A) FV(B)
  rule #FV( {             } ) => .Set
  rule #FV( { A:RhoKVPats } ) => #FV(A)
  rule #FV( { A:RhoKVPats ... B:ProcVar } ) => #FV(A) SetItem(B)
    // KV pairs
  rule  FV( P:ProcPat  : Q:ProcPat   ) =>  FV(P)  FV(Q)
  rule  FV( R:RhoKVPat , S:RhoKVPats ) =>  FV(R)  FV(S)
  rule #FV( P:ProcPat  : Q:ProcPat   ) => #FV(P) #FV(Q)
  rule #FV( R:RhoKVPat , S:RhoKVPats ) => #FV(R) #FV(S)
  // RhoSet
  rule  FV( Set(            ) ) => .Set
  rule  FV( Set( A:ProcPats ) ) =>  FV(A)
  rule  FV( Set( A:ProcPats ... B:ProcVar ) ) =>  FV(A) FV(B)
  rule #FV( Set(            ) ) => .Set
  rule #FV( Set( A:ProcPats ) ) => #FV(A)
  rule #FV( Set( A:ProcPats ... B:ProcVar ) ) => #FV(A) SetItem(B)
  // RhoTuple
  rule  FV( ( A:ProcPats ,) ) =>  FV(A)
  rule #FV( ( A:ProcPats ,) ) => #FV(A)

// Variable Reference
  rule  FV( =  A:ProcVar ) => Vp(A) requires notBool isBoundProc(A)
  rule  FV( =* A:Var     ) => Vn(A) requires notBool isBoundName(A)
  rule #FV( =  A:ProcVar ) => SetItem(A) requires notBool isBoundProc(A)
  rule #FV( =* A:Var     ) => SetItem(A) requires notBool isBoundName(A)

// New[Pat]
  rule  FV( new X:VarDecs in { P:ProcPat } ) =>  FV(P) -Set FV+(X)
  rule #FV( new X:VarDecs in { P:ProcPat } ) => #FV(P) -Set #FV(X)

// Conditionals
  rule  FV(   if ( B:BExp )  P:ProcPat ) =>  FV(B)  FV(P)
  rule  FV( A:IfThenPat else P:ProcPat ) =>  FV(A)  FV(P)
  rule #FV(   if ( B:BExp )  P:ProcPat ) => #FV(B) #FV(P)
  rule #FV( A:IfThenPat else P:ProcPat ) => #FV(A) #FV(P)

// MatchPat
  rule  FV( match P:ProcPat { M:MCasePats } ) =>  FV(P)  FV(M)
  rule #FV( match P:ProcPat { M:MCasePats } ) => #FV(P) #FV(M)
  // MatchCases -- free variables in to be matched Proc P are bound in resulting Proc Q
    // must be empty for each MatchCase for Match to be closed, i.e. #FV(Q) <=Set #FV(P)
  rule  FV( { P:ProcPat } |=> Q:ProcPat ) =>  FV(Q) -Set FV+(P)
  rule  FV(   A:MCasePat  B:MCasePats   ) =>  FV(A)  FV(B)
  rule #FV( { P:ProcPat } |=> Q:ProcPat ) => #FV(Q) -Set #FV(P)
  rule #FV(   A:MCasePat  B:MCasePats   ) => #FV(A) #FV(B)

// SelectPat
  rule  FV(    select {    B:BranchPats }  ) =>  FV(B)
  rule  FV(   A:BranchPat  B:BranchPats    ) =>  FV(A)   FV(B)
  rule  FV( { A:LbindPat   } |=> B:ProcPat ) =>  RV(A)  (FV(B) -Set LV+(A))
  rule  FV( { A:LbindPats  } |=> B:ProcPat ) =>  RV(A)  (FV(B) -Set LV+(A))
  rule  FV( { A:GLbindPat  } |=> B:ProcPat ) =>  RV(A)  (FV(B) -Set LV+(A))
  rule  FV( { A:GLbindPats } |=> B:ProcPat ) =>  RV(A)  (FV(B) -Set LV+(A))
  rule #FV(    select {    B:BranchPats }  ) => #FV(B)
  rule #FV(   A:BranchPat  B:BranchPats    ) => #FV(A)  #FV(B)
  rule #FV( { A:LbindPat   } |=> B:ProcPat ) => #RV(A) (#FV(B) -Set #LV(A))
  rule #FV( { A:LbindPats  } |=> B:ProcPat ) => #RV(A) (#FV(B) -Set #LV(A))
  rule #FV( { A:GLbindPat  } |=> B:ProcPat ) => #RV(A) (#FV(B) -Set #LV(A))
  rule #FV( { A:GLbindPats } |=> B:ProcPat ) => #RV(A) (#FV(B) -Set #LV(A))

// Method
  rule  FV( P:ProcPat M:MethodArgPats ) =>  FV(P)  FV(M)
  rule  FV( . _:Method ( A:ProcPats ) ) =>  FV(A)
  rule  FV( . _:Method (            ) ) => .Set
  rule #FV( P:ProcPat M:MethodArgPats ) => #FV(P) #FV(M)
  rule #FV( . _:Method ( A:ProcPats ) ) => #FV(A)
  rule #FV( . _:Method (            ) ) => .Set

// Arithmetic Expressions
  rule  FV( - A:AExp         ) => FV(A)
  rule  FV( A:AExp *  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp /  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp +  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp -  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp %  B:AExp ) => FV(A) FV(B)
  rule  FV( A:StringOrVar ++ B:StringOrVar ) => FV(A) FV(B)
  rule  FV( A:StringOrVar ++ B:ConcatStr   ) => FV(A) FV(B)
  rule  FV( A:ListOrVar   ++ B:ListOrVar   ) => FV(A) FV(B)
  rule  FV( A:ListOrVar   ++ B:ConcatList  ) => FV(A) FV(B)
  rule  FV( A:StringOrVar %% B:InterpMaps  ) => FV(A) FV(B)
  rule  FV( A:RhoMap      %% B:InterpMaps  ) => FV(A) FV(B)
  rule #FV( - A:AExp         ) => #FV(A)
  rule #FV( A:AExp *  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp /  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp +  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp -  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp %  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:StringOrVar ++ B:StringOrVar ) => #FV(A) #FV(B)
  rule #FV( A:StringOrVar ++ B:ConcatStr   ) => #FV(A) #FV(B)
  rule #FV( A:ListOrVar   ++ B:ListOrVar   ) => #FV(A) #FV(B)
  rule #FV( A:ListOrVar   ++ B:ConcatList  ) => #FV(A) #FV(B)
  rule #FV( A:StringOrVar %% B:InterpMaps  ) => #FV(A) #FV(B)
  rule #FV( A:RhoMap      %% B:InterpMaps  ) => #FV(A) #FV(B)
// Boolean Expressions
  rule  FV( not B:BExp        ) => FV(B)
  rule  FV( A:BExp and B:BExp ) => FV(A) FV(B)
  rule  FV( A:BExp or  B:BExp ) => FV(A) FV(B)
  rule  FV( A:AExp <=  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp <   B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp >=  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp >   B:AExp ) => FV(A) FV(B)
  rule  FV( A:Proc ==  B:Proc ) => FV(A) FV(B)
  rule  FV( A:Proc !=  B:Proc ) => FV(A) FV(B)
  rule  FV( A:Name ==  B:Name ) => FV(A) FV(B)
  rule  FV( A:Name !=  B:Name ) => FV(A) FV(B)
  rule  FV( A:Proc    matches B:Proc    ) => FV(A) FV(B)
  rule  FV( A:Proc    matches B:ProcPat ) => FV(A) FV(B)
  rule  FV( A:ProcPat matches B:ProcPat ) => FV(A) FV(B)
  rule #FV( not B:BExp        ) => #FV(B)
  rule #FV( A:BExp and B:BExp ) => #FV(A) #FV(B)
  rule #FV( A:BExp or  B:BExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp <=  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp <   B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp >=  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp >   B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:Proc ==  B:Proc ) => #FV(A) #FV(B)
  rule #FV( A:Proc !=  B:Proc ) => #FV(A) #FV(B)
  rule #FV( A:Name ==  B:Name ) => #FV(A) #FV(B)
  rule #FV( A:Name !=  B:Name ) => #FV(A) #FV(B)
  rule #FV( A:ProcPat matches B:ProcPat ) => #FV(A) #FV(B)

// NamePats
  rule  FV( A:NamePat , B:NamePats ) =>  FV(A)  FV(B)
  rule #FV( A:NamePat , B:NamePats ) => #FV(A) #FV(B)

// ProcPats
  rule  FV( A:ProcPat , B:ProcPats ) =>  FV(A)  FV(B)
  rule #FV( A:ProcPat , B:ProcPats ) => #FV(A) #FV(B)

// ProcPat
  // SimplePat
  rule  FV( _:SimplePat ) => .Set
  rule #FV( _:SimplePat ) => .Set

  // PatExp
  rule  FV( ~ A:ProcPat ) =>  FV(A)
  rule  FV( A:ProcPat /\ B:ProcPat ) =>  FV(A)  FV(B)
  rule  FV( A:ProcPat \/ B:ProcPat ) =>  FV(A)  FV(B)
  rule #FV( ~ A:ProcPat ) => #FV(A)
  rule #FV( A:ProcPat /\ B:ProcPat ) => #FV(A) #FV(B)
  rule #FV( A:ProcPat \/ B:ProcPat ) => #FV(A) #FV(B)
/*
// Nullity
  rule #FV( Null ) => .Set
// Recursion
  rule #FV( rec A:PatVar . B:ProcPat ) => #FV(B) -Set SetItem(A)
// Quantification
  rule #FV( \forall A:Var     :: B:NamePat . C:ProcPat ) => #FV(B) (#FV(C) -Set SetItem(A))
  rule #FV( \forall A:ProcVar :: B:ProcPat . C:ProcPat ) => #FV(B) (#FV(C) -Set SetItem(A))
  rule #FV( \forall A:Var      . B:ProcPat ) => #FV(B) -Set SetItem(A)
  rule #FV( \forall A:ProcVar  . B:ProcPat ) => #FV(B) -Set SetItem(A)
*/
//-----------------------
//--- Bound Variables ---
//-----------------------
  rule  BV( A:ProcPats ) =>  V(A) -Set  FV(A)
  rule  BV( A:NamePats ) =>  V(A) -Set  FV(A)
  rule #BV( A:ProcPats ) => #V(A) -Set #FV(A)
  rule #BV( A:NamePats ) => #V(A) -Set #FV(A)

//---------------------------
//--- Listening Variables ---
//---------------------------
// Auxiliary function for bindings in Receives, New, & Match
  // BindPat
  rule LV+( Y:NamePats <-  _:NamePat ) => FV+(Y)
  rule LV+(            <-  _:NamePat ) => .Set
  rule LV+( Y:NamePats <=  _:NamePat ) => FV+(Y)
  rule LV+(            <=  _:NamePat ) => .Set
  rule LV+( Y:NamePats <<- _:NamePat ) => FV+(Y)
  rule LV+(            <<- _:NamePat ) => .Set
  // BindPats
  rule LV+( A:LbindPat & B:LbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:LbindPat & B:LbindPats ) => LV+(A) LV+(B)
  rule LV+( A:PbindPat & B:PbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:PbindPat & B:PbindPats ) => LV+(A) LV+(B)
  rule LV+( A:RbindPat & B:RbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:RbindPat & B:RbindPats ) => LV+(A) LV+(B)

// LetBinds
  rule LV+( A:ProcVar <- _:Proc ) => FV+(A)
  rule LV+( A:LetBind ; B:LetBind     ) => LV+(A) LV+(B)
  rule LV+( A:LetBind ; B:SeqLetBinds ) => LV+(A) LV+(B)
  rule LV+( A:LetBind & B:SimLetBinds ) => LV+(A) LV+(B)
  rule LV+( A:SeqLetBinds > B:SimLetBinds    ) => LV+(A) LV+(B)
  rule LV+( A:SimLetBinds > B:SeqLetBinds    ) => LV+(A) LV+(B)
  rule LV+( A:SimLetBinds > B:SimLetBinds    ) => LV+(A) LV+(B)
  rule LV+( A:SeqLetBinds > B:SeqSimLetBinds ) => LV+(A) LV+(B)
  rule LV+( A:SimLetBinds > B:SeqSimLetBinds ) => LV+(A) LV+(B)

// Variables being listened for by a RecPat
  // unguarded
  rule  LV( for( B:LbindPat  ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:LbindPats ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:PbindPat  ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:PbindPats ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:RbindPat  ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:RbindPats ) { _:ProcPat } ) =>  LV(B)
  rule #LV( for( B:LbindPat  ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:LbindPats ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:PbindPat  ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:PbindPats ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:RbindPat  ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:RbindPats ) { _:ProcPat } ) => #LV(B)
  // guarded
  rule  LV( for( B:LbindPat  _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:LbindPats _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:PbindPat  _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:PbindPats _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:RbindPat  _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:RbindPats _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule #LV( for( B:LbindPat  _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:LbindPats _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:PbindPat  _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:PbindPats _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:RbindPat  _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:RbindPats _:Guard ) { _:ProcPat } ) => #LV(B)

// ContractPat
  rule  LV( contract _:NamePat ( A:NamePats ) = { _:ProcPat } ) =>  FV(A)
  rule  LV( contract _:NamePat (            ) = { _:ProcPat } ) => .Set
  rule #LV( contract _:NamePat ( A:NamePats ) = { _:ProcPat } ) => #FV(A)
  rule #LV( contract _:NamePat (            ) = { _:ProcPat } ) => .Set

// BindPats -- variables being listened for
  // single
  rule  LV( A:NamePats <-  _:NamePat ) =>  FV(A)
  rule  LV(            <-  _:NamePat ) => .Set
  rule  LV( A:NamePats <=  _:NamePat ) =>  FV(A)
  rule  LV(            <=  _:NamePat ) => .Set
  rule  LV( A:NamePats <<- _:NamePat ) =>  FV(A)
  rule  LV(            <<- _:NamePat ) => .Set
  rule #LV( A:NamePats <-  _:NamePat ) => #FV(A)
  rule #LV(            <-  _:NamePat ) => .Set
  rule #LV( A:NamePats <=  _:NamePat ) => #FV(A)
  rule #LV(            <=  _:NamePat ) => .Set
  rule #LV( A:NamePats <<- _:NamePat ) => #FV(A)
  rule #LV(            <<- _:NamePat ) => .Set
  // multiple
  rule  LV( A:LbindPat & B:LbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:LbindPat & B:LbindPats ) =>  LV(A)  LV(B)
  rule  LV( A:PbindPat & B:PbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:PbindPat & B:PbindPats ) =>  LV(A)  LV(B)
  rule  LV( A:RbindPat & B:RbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:RbindPat & B:RbindPats ) =>  LV(A)  LV(B)
  rule #LV( A:LbindPat & B:LbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:LbindPat & B:LbindPats ) => #LV(A) #LV(B)
  rule #LV( A:PbindPat & B:PbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:PbindPat & B:PbindPats ) => #LV(A) #LV(B)
  rule #LV( A:RbindPat & B:RbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:RbindPat & B:RbindPats ) => #LV(A) #LV(B)

// Select & Branches
  rule  LV(  select { A:BranchPats } ) =>  LV(A)
  rule  LV( A:BranchPat B:BranchPats ) =>  LV(A)  LV(B)
  rule  LV( { A:LbindPat   } |=> _:ProcPat ) =>   LV(A)
  rule  LV( { A:GLbindPat  } |=> _:ProcPat ) =>   LV(A)
  rule  LV( { A:LbindPats  } |=> _:ProcPat ) =>   LV(A)
  rule  LV( { A:GLbindPats } |=> _:ProcPat ) =>   LV(A)
  rule #LV(  select { A:BranchPats } ) => #LV(A)
  rule #LV( A:BranchPat B:BranchPats ) => #LV(A) #LV(B)
  rule #LV( { A:LbindPat   } |=> _:ProcPat ) =>  #LV(A)
  rule #LV( { A:GLbindPat  } |=> _:ProcPat ) =>  #LV(A)
  rule #LV( { A:LbindPats  } |=> _:ProcPat ) =>  #LV(A)
  rule #LV( { A:GLbindPats } |=> _:ProcPat ) =>  #LV(A)

// LetExp
  rule  LV( let A:LetBind        in { _:Proc } ) =>  LV(A)
  rule  LV( let A:SeqLetBinds    in { _:Proc } ) =>  LV(A)
  rule  LV( let A:SimLetBinds    in { _:Proc } ) =>  LV(A)
  rule  LV( let A:SeqSimLetBinds in { _:Proc } ) =>  LV(A)
  rule #LV( let A:LetBind        in { _:Proc } ) => #LV(A)
  rule #LV( let A:SeqLetBinds    in { _:Proc } ) => #LV(A)
  rule #LV( let A:SimLetBinds    in { _:Proc } ) => #LV(A)
  rule #LV( let A:SeqSimLetBinds in { _:Proc } ) => #LV(A)
  // LetBind
  rule  LV( A:ProcVar <- _:Proc ) => Vp(A)
  rule #LV( A:ProcVar <- _:Proc ) => SetItem(A)
  // SeqLetBind
  rule  LV( A:LetBind ; B:LetBind     ) =>  LV(A)  LV(B)
  rule  LV( A:LetBind ; B:SeqLetBinds ) =>  LV(A)  LV(B)
  rule #LV( A:LetBind ; B:LetBind     ) => #LV(A) #LV(B)
  rule #LV( A:LetBind ; B:SeqLetBinds ) => #LV(A) #LV(B)
  // SimLetBind
  rule  LV( A:LetBind & B:SimLetBinds ) =>  LV(A)  LV(B)
  rule #LV( A:LetBind & B:SimLetBinds ) => #LV(A) #LV(B)
  // SeqSimLetBind
  rule  LV( A:SeqLetBinds > B:SimLetBinds    ) =>  LV(A)  LV(B)
  rule  LV( A:SimLetBinds > B:SeqLetBinds    ) =>  LV(A)  LV(B)
  rule  LV( A:SimLetBinds > B:SimLetBinds    ) =>  LV(A)  LV(B)
  rule  LV( A:SeqLetBinds > B:SeqSimLetBinds ) =>  LV(A)  LV(B)
  rule  LV( A:SimLetBinds > B:SeqSimLetBinds ) =>  LV(A)  LV(B)
  rule #LV( A:SeqLetBinds > B:SimLetBinds    ) => #LV(A) #LV(B)
  rule #LV( A:SimLetBinds > B:SeqLetBinds    ) => #LV(A) #LV(B)
  rule #LV( A:SimLetBinds > B:SimLetBinds    ) => #LV(A) #LV(B)
  rule #LV( A:SeqLetBinds > B:SeqSimLetBinds ) => #LV(A) #LV(B)
  rule #LV( A:SimLetBinds > B:SeqSimLetBinds ) => #LV(A) #LV(B)

//---------------------
//--- Receive Names ---
//---------------------
// Excluded Proc[Pat]
  rule  RN( A:Proc    ) => .Set
       requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A))
  rule  RN( A:ProcPat ) => .Set
       requires notBool (isNewPat(A) orBool isRecPat(A) orBool isParPat(A))
  rule #RN( A:Proc    ) => .Set
       requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A))
  rule #RN( A:ProcPat ) => .Set
       requires notBool (isNewPat(A) orBool isRecPat(A) orBool isParPat(A))

  // Receives -- free variables in channel
    // unguarded
  rule  RN( for( B:Lbind     ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Lbinds    ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Pbind     ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Pbinds    ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Rbind     ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Rbinds    ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Lbind     ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Lbinds    ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Pbind     ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Pbinds    ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Rbind     ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Rbinds    ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:LbindPat  ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:LbindPats ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:PbindPat  ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:PbindPats ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:RbindPat  ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:RbindPats ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:LbindPat  ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:LbindPats ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:PbindPat  ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:PbindPats ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:RbindPat  ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:RbindPats ) { _:ProcPat } ) =>  RN(B)
  rule #RN( for( B:Lbind     ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Lbinds    ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Pbind     ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Pbinds    ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Rbind     ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Rbinds    ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Lbind     ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Lbinds    ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Pbind     ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Pbinds    ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Rbind     ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Rbinds    ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:LbindPat  ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:LbindPats ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:PbindPat  ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:PbindPats ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:RbindPat  ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:RbindPats ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:LbindPat  ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:LbindPats ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:PbindPat  ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:PbindPats ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:RbindPat  ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:RbindPats ) { _:ProcPat } ) => #RN(B)
    // guarded
  rule  RN( for( B:Lbind     _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Lbinds    _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Pbind     _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Pbinds    _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Rbind     _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Rbinds    _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:Lbind     _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Lbinds    _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Pbind     _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Pbinds    _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Rbind     _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:Rbinds    _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:LbindPat  _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:LbindPats _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:PbindPat  _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:PbindPats _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:RbindPat  _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:RbindPats _:Guard ) { _:Proc    } ) =>  RN(B)
  rule  RN( for( B:LbindPat  _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:LbindPats _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:PbindPat  _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:PbindPats _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:RbindPat  _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule  RN( for( B:RbindPats _:Guard ) { _:ProcPat } ) =>  RN(B)
  rule #RN( for( B:Lbind     _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Lbinds    _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Pbind     _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Pbinds    _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Rbind     _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Rbinds    _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:Lbind     _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Lbinds    _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Pbind     _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Pbinds    _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Rbind     _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:Rbinds    _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:LbindPat  _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:LbindPats _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:PbindPat  _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:PbindPats _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:RbindPat  _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:RbindPats _:Guard ) { _:Proc    } ) => #RN(B)
  rule #RN( for( B:LbindPat  _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:LbindPats _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:PbindPat  _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:PbindPats _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:RbindPat  _:Guard ) { _:ProcPat } ) => #RN(B)
  rule #RN( for( B:RbindPats _:Guard ) { _:ProcPat } ) => #RN(B)

  // Bind[Pat]s
    // Bind[Pat]
  rule  RN( _:NamePats <-  X:Name    ) => SetItem(X : name)
  rule  RN( _:Names    <-  X:Name    ) => SetItem(X : name)
  rule  RN(            <-  X:Name    ) => SetItem(X : name)
  rule  RN( _:NamePats <=  X:Name    ) => SetItem(X : name)
  rule  RN( _:Names    <=  X:Name    ) => SetItem(X : name)
  rule  RN(            <=  X:Name    ) => SetItem(X : name)
  rule  RN( _:NamePats <<- X:Name    ) => SetItem(X : name)
  rule  RN( _:Names    <<- X:Name    ) => SetItem(X : name)
  rule  RN(            <<- X:Name    ) => SetItem(X : name)
  rule  RN( _:NamePats <-  X:NamePat ) => SetItem(X : namepat)
  rule  RN( _:Names    <-  X:NamePat ) => SetItem(X : namepat)
  rule  RN(            <-  X:NamePat ) => SetItem(X : namepat)
  rule  RN( _:NamePats <=  X:NamePat ) => SetItem(X : namepat)
  rule  RN( _:Names    <=  X:NamePat ) => SetItem(X : namepat)
  rule  RN(            <=  X:NamePat ) => SetItem(X : namepat)
  rule  RN( _:NamePats <<- X:NamePat ) => SetItem(X : namepat)
  rule  RN( _:Names    <<- X:NamePat ) => SetItem(X : namepat)
  rule  RN(            <<- X:NamePat ) => SetItem(X : namepat)
  rule #RN( _:NamePats <-  X:Name    ) => SetItem(X)
  rule #RN( _:Names    <-  X:Name    ) => SetItem(X)
  rule #RN(            <-  X:Name    ) => SetItem(X)
  rule #RN( _:NamePats <=  X:Name    ) => SetItem(X)
  rule #RN( _:Names    <=  X:Name    ) => SetItem(X)
  rule #RN(            <=  X:Name    ) => SetItem(X)
  rule #RN( _:NamePats <<- X:Name    ) => SetItem(X)
  rule #RN( _:Names    <<- X:Name    ) => SetItem(X)
  rule #RN(            <<- X:Name    ) => SetItem(X)
  rule #RN( _:NamePats <-  X:NamePat ) => SetItem(X)
  rule #RN( _:Names    <-  X:NamePat ) => SetItem(X)
  rule #RN(            <-  X:NamePat ) => SetItem(X)
  rule #RN( _:NamePats <=  X:NamePat ) => SetItem(X)
  rule #RN( _:Names    <=  X:NamePat ) => SetItem(X)
  rule #RN(            <=  X:NamePat ) => SetItem(X)
  rule #RN( _:NamePats <<- X:NamePat ) => SetItem(X)
  rule #RN( _:Names    <<- X:NamePat ) => SetItem(X)
  rule #RN(            <<- X:NamePat ) => SetItem(X)
    // Bind[Pat]s
  rule  RN( A:Lbind    & B:Lbind     ) =>  RN(A)  RN(B)
  rule  RN( A:Lbind    & B:LbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:LbindPat & B:Lbind     ) =>  RN(A)  RN(B)
  rule  RN( A:LbindPat & B:LbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:Lbind    & B:Lbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:Lbind    & B:LbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:LbindPat & B:Lbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:LbindPat & B:LbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind    & B:Pbind     ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind    & B:PbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:PbindPat & B:Pbind     ) =>  RN(A)  RN(B)
  rule  RN( A:PbindPat & B:PbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind    & B:Pbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind    & B:PbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:PbindPat & B:Pbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:PbindPat & B:PbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind    & B:Rbind     ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind    & B:RbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:RbindPat & B:Rbind     ) =>  RN(A)  RN(B)
  rule  RN( A:RbindPat & B:RbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind    & B:Rbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind    & B:RbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:RbindPat & B:Rbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:RbindPat & B:RbindPats ) =>  RN(A)  RN(B)
  rule #RN( A:Lbind    & B:Lbind     ) => #RN(A) #RN(B)
  rule #RN( A:Lbind    & B:LbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:LbindPat & B:Lbind     ) => #RN(A) #RN(B)
  rule #RN( A:LbindPat & B:LbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:Lbind    & B:Lbinds    ) => #RN(A) #RN(B)
  rule #RN( A:Lbind    & B:LbindPats ) => #RN(A) #RN(B)
  rule #RN( A:LbindPat & B:Lbinds    ) => #RN(A) #RN(B)
  rule #RN( A:LbindPat & B:LbindPats ) => #RN(A) #RN(B)
  rule #RN( A:Pbind    & B:Pbind     ) => #RN(A) #RN(B)
  rule #RN( A:Pbind    & B:PbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:PbindPat & B:Pbind     ) => #RN(A) #RN(B)
  rule #RN( A:PbindPat & B:PbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:Pbind    & B:Pbinds    ) => #RN(A) #RN(B)
  rule #RN( A:Pbind    & B:PbindPats ) => #RN(A) #RN(B)
  rule #RN( A:PbindPat & B:Pbinds    ) => #RN(A) #RN(B)
  rule #RN( A:PbindPat & B:PbindPats ) => #RN(A) #RN(B)
  rule #RN( A:Rbind    & B:Rbind     ) => #RN(A) #RN(B)
  rule #RN( A:Rbind    & B:RbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:RbindPat & B:Rbind     ) => #RN(A) #RN(B)
  rule #RN( A:RbindPat & B:RbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:Rbind    & B:Rbinds    ) => #RN(A) #RN(B)
  rule #RN( A:Rbind    & B:RbindPats ) => #RN(A) #RN(B)
  rule #RN( A:RbindPat & B:Rbinds    ) => #RN(A) #RN(B)
  rule #RN( A:RbindPat & B:RbindPats ) => #RN(A) #RN(B)

  // Par[Pat] -- receive variables in each Proc
  rule  RN( A:Proc | B:Proc ) =>  RN(A)  RN(B) requires notBool isPar(A)
  rule #RN( A:Proc | B:Proc ) => #RN(A) #RN(B) requires notBool isPar(A)

// TODO: New[Pat]

//-------------------------
//--- Receive Variables ---
//-------------------------
// Auxiliary function for receive variables
  // Excluded Proc[Pat]
  rule RV+( A:Proc    ) => .Set
       requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A))
  rule RV+( A:ProcPat ) => .Set
       requires notBool (isNewPat(A) orBool  isRecPat(A) orBool isParPat(A))

  // Receives -- free variables in listening channels
    // unguarded
  rule RV+( for( B:Lbind     ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Lbinds    ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Lbind     ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Lbinds    ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:LbindPat  ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:LbindPats ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:LbindPat  ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:LbindPats ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Pbind     ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Pbinds    ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Pbind     ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Pbinds    ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:PbindPat  ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:PbindPats ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:PbindPat  ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:PbindPats ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Rbind     ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Rbinds    ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Rbind     ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Rbinds    ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:RbindPat  ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:RbindPats ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:RbindPat  ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:RbindPats ) { _:ProcPat } ) => RV+(B)
    // guarded
  rule RV+( for( B:Lbind     _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Lbinds    _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Pbind     _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Pbinds    _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Rbind     _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Rbinds    _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:Lbind     _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Lbinds    _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Pbind     _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Pbinds    _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Rbind     _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:Rbinds    _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:LbindPat  _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:LbindPats _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:PbindPat  _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:PbindPats _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:RbindPat  _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:RbindPats _:Guard ) { _:Proc    } ) => RV+(B)
  rule RV+( for( B:LbindPat  _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:LbindPats _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:PbindPat  _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:PbindPats _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:RbindPat  _:Guard ) { _:ProcPat } ) => RV+(B)
  rule RV+( for( B:RbindPats _:Guard ) { _:ProcPat } ) => RV+(B)

  // Bind[Pat]s
    // Bind[Pat]
  rule RV+( _:NamePats <-  X:Name    ) => FV+(X)
  rule RV+( _:Names    <-  X:Name    ) => FV+(X)
  rule RV+(            <-  X:Name    ) => FV+(X)
  rule RV+( _:NamePats <=  X:Name    ) => FV+(X)
  rule RV+( _:Names    <=  X:Name    ) => FV+(X)
  rule RV+(            <=  X:Name    ) => FV+(X)
  rule RV+( _:NamePats <<- X:Name    ) => FV+(X)
  rule RV+( _:Names    <<- X:Name    ) => FV+(X)
  rule RV+(            <<- X:Name    ) => FV+(X)
  rule RV+( _:NamePats <-  X:NamePat ) => FV+(X)
  rule RV+( _:Names    <-  X:NamePat ) => FV+(X)
  rule RV+(            <-  X:NamePat ) => FV+(X)
  rule RV+( _:NamePats <=  X:NamePat ) => FV+(X)
  rule RV+( _:Names    <=  X:NamePat ) => FV+(X)
  rule RV+(            <=  X:NamePat ) => FV+(X)
  rule RV+( _:NamePats <<- X:NamePat ) => FV+(X)
  rule RV+( _:Names    <<- X:NamePat ) => FV+(X)
  rule RV+(            <<- X:NamePat ) => FV+(X)
    // multiple Binds
  rule RV+( A:Lbind    & B:Lbind     ) => RV+(A) RV+(B)
  rule RV+( A:Lbind    & B:LbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:LbindPat & B:Lbind     ) => RV+(A) RV+(B)
  rule RV+( A:LbindPat & B:LbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:Lbind    & B:LbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Lbind    & B:Lbinds    ) => RV+(A) RV+(B)
  rule RV+( A:LbindPat & B:Lbinds    ) => RV+(A) RV+(B)
  rule RV+( A:LbindPat & B:LbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Pbind    & B:Pbind     ) => RV+(A) RV+(B)
  rule RV+( A:Pbind    & B:PbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:PbindPat & B:Pbind     ) => RV+(A) RV+(B)
  rule RV+( A:PbindPat & B:PbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:Pbind    & B:PbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Pbind    & B:Pbinds    ) => RV+(A) RV+(B)
  rule RV+( A:PbindPat & B:Pbinds    ) => RV+(A) RV+(B)
  rule RV+( A:PbindPat & B:PbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Rbind    & B:Rbind     ) => RV+(A) RV+(B)
  rule RV+( A:Rbind    & B:RbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:RbindPat & B:Rbind     ) => RV+(A) RV+(B)
  rule RV+( A:RbindPat & B:RbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:Rbind    & B:RbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Rbind    & B:Rbinds    ) => RV+(A) RV+(B)
  rule RV+( A:RbindPat & B:Rbinds    ) => RV+(A) RV+(B)
  rule RV+( A:RbindPat & B:RbindPats ) => RV+(A) RV+(B)

  // Par[Pat] -- receive variables in each Proc
  rule RV+( A:Proc    | B:Proc    ) => RV+(A) RV+(B) requires notBool isPar(A)
  rule RV+( A:Proc    | B:ProcPat ) => RV+(A) RV+(B) requires notBool isPar(A)
  rule RV+( A:ProcPat | B:Proc    ) => RV+(A) RV+(B) requires notBool isParPat(A)
  rule RV+( A:ProcPat | B:ProcPat ) => RV+(A) RV+(B) requires notBool isParPat(A)

  // TODO: New[Pat]


// Excluded Proc
  rule  RV( A:Proc    ) => .Set
       requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A))
  rule  RV( A:ProcPat ) => .Set
       requires notBool (isNewPat(A) orBool isRecPat(A) orBool isParPat(A))
  rule #RV( A:Proc    ) => .Set
       requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A))
  rule #RV( A:ProcPat ) => .Set
       requires notBool (isNewPat(A) orBool isRecPat(A) orBool isParPat(A))

// Receives -- free variables in channel
  // unguarded
  rule  RV( for( B:Lbind     ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Lbinds    ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Pbind     ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Pbinds    ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Rbind     ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Rbinds    ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Lbind     ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Lbinds    ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Pbind     ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Pbinds    ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Rbind     ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Rbinds    ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:LbindPat  ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:LbindPats ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:PbindPat  ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:PbindPats ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:RbindPat  ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:RbindPats ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:LbindPat  ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:LbindPats ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:PbindPat  ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:PbindPats ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:RbindPat  ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:RbindPats ) { _:ProcPat } ) =>  RV(B)
  rule #RV( for( B:Lbind     ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Lbinds    ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Pbind     ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Pbinds    ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Rbind     ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Rbinds    ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Lbind     ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Lbinds    ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Pbind     ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Pbinds    ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Rbind     ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Rbinds    ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:LbindPat  ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:LbindPats ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:PbindPat  ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:PbindPats ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:RbindPat  ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:RbindPats ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:LbindPat  ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:LbindPats ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:PbindPat  ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:PbindPats ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:RbindPat  ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:RbindPats ) { _:ProcPat } ) => #RV(B)
  // guarded
  rule  RV( for( B:Lbind     _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Lbinds    _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Pbind     _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Pbinds    _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Rbind     _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Rbinds    _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:Lbind     _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Lbinds    _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Pbind     _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Pbinds    _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Rbind     _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:Rbinds    _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:LbindPat  _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:LbindPats _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:PbindPat  _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:PbindPats _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:RbindPat  _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:RbindPats _:Guard ) { _:Proc    } ) =>  RV(B)
  rule  RV( for( B:LbindPat  _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:LbindPats _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:PbindPat  _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:PbindPats _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:RbindPat  _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule  RV( for( B:RbindPats _:Guard ) { _:ProcPat } ) =>  RV(B)
  rule #RV( for( B:Lbind     _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Lbinds    _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Pbind     _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Pbinds    _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Rbind     _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Rbinds    _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:Lbind     _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Lbinds    _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Pbind     _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Pbinds    _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Rbind     _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:Rbinds    _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:LbindPat  _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:LbindPats _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:PbindPat  _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:PbindPats _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:RbindPat  _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:RbindPats _:Guard ) { _:Proc    } ) => #RV(B)
  rule #RV( for( B:LbindPat  _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:LbindPats _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:PbindPat  _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:PbindPats _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:RbindPat  _:Guard ) { _:ProcPat } ) => #RV(B)
  rule #RV( for( B:RbindPats _:Guard ) { _:ProcPat } ) => #RV(B)

// Binds
  // BindPat
  rule  RV( _:NamePats <-  X:NamePat ) =>  FV(X)
  rule  RV( _:Names    <-  X:NamePat ) =>  FV(X)
  rule  RV(            <-  X:NamePat ) =>  FV(X)
  rule  RV( _:NamePats <<- X:NamePat ) =>  FV(X)
  rule  RV( _:Names    <<- X:NamePat ) =>  FV(X)
  rule  RV(            <<- X:NamePat ) =>  FV(X)
  rule  RV( _:NamePats <=  X:NamePat ) =>  FV(X)
  rule  RV( _:Names    <=  X:NamePat ) =>  FV(X)
  rule  RV(            <=  X:NamePat ) =>  FV(X)
  rule #RV( _:NamePats <-  X:NamePat ) => #FV(X)
  rule #RV( _:Names    <-  X:NamePat ) => #FV(X)
  rule #RV(            <-  X:NamePat ) => #FV(X)
  rule #RV( _:NamePats <<- X:NamePat ) => #FV(X)
  rule #RV( _:Names    <<- X:NamePat ) => #FV(X)
  rule #RV(            <<- X:NamePat ) => #FV(X)
  rule #RV( _:NamePats <=  X:NamePat ) => #FV(X)
  rule #RV( _:Names    <=  X:NamePat ) => #FV(X)
  rule #RV(            <=  X:NamePat ) => #FV(X)
  // BindPats
  rule  RV( A:LbindPat & B:LbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:LbindPat & B:LbindPats ) =>  RV(A)  RV(B)
  rule  RV( A:PbindPat & B:PbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:PbindPat & B:PbindPats ) =>  RV(A)  RV(B)
  rule  RV( A:RbindPat & B:RbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:RbindPat & B:RbindPats ) =>  RV(A)  RV(B)
  rule #RV( A:LbindPat & B:LbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:LbindPat & B:LbindPats ) => #RV(A) #RV(B)
  rule #RV( A:PbindPat & B:PbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:PbindPat & B:PbindPats ) => #RV(A) #RV(B)
  rule #RV( A:RbindPat & B:RbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:RbindPat & B:RbindPats ) => #RV(A) #RV(B)

// LetExp
  // LetBind
  rule  RV( _:ProcVar <- A:Proc ) =>  FV(A)
  rule #RV( _:ProcVar <- A:Proc ) => #FV(A)
  // SeqLetBinds
  rule  RV( A:LetBind ; B:LetBind     ) =>  RV(A) ( RV(B) -Set  LV(A))
  rule  RV( A:LetBind ; B:SeqLetBinds ) =>  RV(A) ( RV(B) -Set  LV(A))
  rule #RV( A:LetBind ; B:LetBind     ) => #RV(A) (#RV(B) -Set #LV(A))
  rule #RV( A:LetBind ; B:SeqLetBinds ) => #RV(A) (#RV(B) -Set #LV(A))
  // SimLetBinds
  rule  RV( A:LetBind & B:SimLetBinds ) =>  RV(A)  RV(B)
  rule #RV( A:LetBind & B:SimLetBinds ) => #RV(A) #RV(B)
  // SeqSimLetBinds
  rule  RV( A:SeqLetBinds > B:SimLetBinds    ) =>  RV(A) ( RV(B) -Set  LV(A))
  rule  RV( A:SimLetBinds > B:SimLetBinds    ) =>  RV(A) ( RV(B) -Set  LV(A))
  rule  RV( A:SimLetBinds > B:SeqLetBinds    ) =>  RV(A) ( RV(B) -Set  LV(A))
  rule  RV( A:SimLetBinds > B:SeqSimLetBinds ) =>  RV(A) ( RV(B) -Set  LV(A))
  rule  RV( A:SeqLetBinds > B:SeqSimLetBinds ) =>  RV(A) ( RV(B) -Set  LV(A))
  rule #RV( A:SeqLetBinds > B:SimLetBinds    ) => #RV(A) (#RV(B) -Set #LV(A))
  rule #RV( A:SimLetBinds > B:SimLetBinds    ) => #RV(A) (#RV(B) -Set #LV(A))
  rule #RV( A:SimLetBinds > B:SeqLetBinds    ) => #RV(A) (#RV(B) -Set #LV(A))
  rule #RV( A:SimLetBinds > B:SeqSimLetBinds ) => #RV(A) (#RV(B) -Set #LV(A))
  rule #RV( A:SeqLetBinds > B:SeqSimLetBinds ) => #RV(A) (#RV(B) -Set #LV(A))

// ParPat -- receive variables in each ProcPat
  rule  RV( A:ProcPat | B:ProcPat ) =>  RV(A)  RV(B) requires notBool isParPat(A)
  rule #RV( A:ProcPat | B:ProcPat ) => #RV(A) #RV(B) requires notBool isParPat(A)

// NewPat
  rule  RV( new _:VarDecs in { A:ProcPat } ) =>  RV(A) //  RV(subNew(A)) ???
  rule #RV( new _:VarDecs in { A:ProcPat } ) => #RV(A) // #RV(subNew(A)) ???

// Send Names

//----------------------
//--- Send Variables ---
//----------------------
// Auxiliary function for bound variables
  // Excluded Proc[Pat]
  rule SV+( A:Proc    ) => .Set
       requires notBool (isNew(A) orBool isSend(A) orBool isPar(A))
  rule SV+( A:ProcPat ) => .Set
       requires notBool (isNewPat(A) orBool isSendPat(A) orBool isParPat(A))

  // Send[Pat]
  rule SV+( A:Name    !  ( _:ProcPats ) ) => FV+(A)
  rule SV+( A:Name    !  ( _:Procs    ) ) => FV+(A)
  rule SV+( A:Name    !  (            ) ) => FV+(A)
  rule SV+( A:NamePat !  ( _:ProcPats ) ) => FV+(A)
  rule SV+( A:NamePat !  ( _:Procs    ) ) => FV+(A)
  rule SV+( A:NamePat !  (            ) ) => FV+(A)
  rule SV+( A:Name    !! ( _:ProcPats ) ) => FV+(A)
  rule SV+( A:Name    !! ( _:Procs    ) ) => FV+(A)
  rule SV+( A:Name    !! (            ) ) => FV+(A)
  rule SV+( A:NamePat !! ( _:ProcPats ) ) => FV+(A)
  rule SV+( A:NamePat !! ( _:Procs    ) ) => FV+(A)
  rule SV+( A:NamePat !! (            ) ) => FV+(A)

  // Par[Pat]
  rule SV+( A:Proc    | B:Proc    ) => SV+(A) SV+(B) requires notBool isPar(A)
  rule SV+( A:Proc    | B:ProcPat ) => SV+(A) SV+(B) requires notBool isPar(A)
  rule SV+( A:ProcPat | B:Proc    ) => SV+(A) SV+(B) requires notBool isParPat(A)
  rule SV+( A:ProcPat | B:ProcPat ) => SV+(A) SV+(B) requires notBool isParPat(A)

// Excluded Proc[Pat]
  rule  SV( A:Proc    ) => .Set
        requires notBool (isNew(A) orBool isSend(A) orBool isPar(A))
  rule  SV( A:ProcPat ) => .Set
        requires notBool (isNewPat(A) orBool isSendPat(A) orBool isParPat(A))
  rule #SV( A:Proc    ) => .Set
       requires notBool (isNew(A) orBool isSend(A) orBool isPar(A))
  rule #SV( A:ProcPat ) => .Set
       requires notBool (isNewPat(A) orBool isSendPat(A) orBool isParPat(A))

// Send[Pat]
  rule  SV( A:Name    !  ( _:ProcPats ) ) =>  FV(A)
  rule  SV( A:Name    !  ( _:Procs    ) ) =>  FV(A)
  rule  SV( A:Name    !  (            ) ) =>  FV(A)
  rule  SV( A:NamePat !  ( _:ProcPats ) ) =>  FV(A)
  rule  SV( A:NamePat !  ( _:Procs    ) ) =>  FV(A)
  rule  SV( A:NamePat !  (            ) ) =>  FV(A)
  rule  SV( A:Name    !! ( _:ProcPats ) ) =>  FV(A)
  rule  SV( A:Name    !! ( _:Procs    ) ) =>  FV(A)
  rule  SV( A:Name    !! (            ) ) =>  FV(A)
  rule  SV( A:NamePat !! ( _:ProcPats ) ) =>  FV(A)
  rule  SV( A:NamePat !! ( _:Procs    ) ) =>  FV(A)
  rule  SV( A:NamePat !! (            ) ) =>  FV(A)
  rule #SV( A:Name    !  ( _:ProcPats ) ) => #FV(A)
  rule #SV( A:Name    !  ( _:Procs    ) ) => #FV(A)
  rule #SV( A:Name    !  (            ) ) => #FV(A)
  rule #SV( A:NamePat !  ( _:ProcPats ) ) => #FV(A)
  rule #SV( A:NamePat !  ( _:Procs    ) ) => #FV(A)
  rule #SV( A:NamePat !  (            ) ) => #FV(A)
  rule #SV( A:Name    !! ( _:ProcPats ) ) => #FV(A)
  rule #SV( A:Name    !! ( _:Procs    ) ) => #FV(A)
  rule #SV( A:Name    !! (            ) ) => #FV(A)
  rule #SV( A:NamePat !! ( _:ProcPats ) ) => #FV(A)
  rule #SV( A:NamePat !! ( _:Procs    ) ) => #FV(A)
  rule #SV( A:NamePat !! (            ) ) => #FV(A)

// Par[Pat]
  rule  SV( A:Proc    | B:Proc    ) =>  SV(A)  SV(B) requires notBool isPar(A)
  rule  SV( A:Proc    | B:ProcPat ) =>  SV(A)  SV(B) requires notBool isPar(A)
  rule  SV( A:ProcPat | B:Proc    ) =>  SV(A)  SV(B) requires notBool isParPat(A)
  rule  SV( A:ProcPat | B:ProcPat ) =>  SV(A)  SV(B) requires notBool isParPat(A)
  rule #SV( A:Proc    | B:Proc    ) => #SV(A) #SV(B) requires notBool isPar(A)
  rule #SV( A:Proc    | B:ProcPat ) => #SV(A) #SV(B) requires notBool isPar(A)
  rule #SV( A:ProcPat | B:Proc    ) => #SV(A) #SV(B) requires notBool isParPat(A)
  rule #SV( A:ProcPat | B:ProcPat ) => #SV(A) #SV(B) requires notBool isParPat(A)

  // New[Pat]
  rule  SV( new _:VarDecs in { A:Proc    } ) =>  SV(A) //  SV(subNew(A)) ???
  rule  SV( new _:VarDecs in { A:ProcPat } ) =>  SV(A) //  SV(subNew(A)) ???
  rule #SV( new _:VarDecs in { A:Proc    } ) => #SV(A) // #SV(subNew(A)) ???
  rule #SV( new _:VarDecs in { A:ProcPat } ) => #SV(A) // #SV(subNew(A)) ???

//--------------------------
//--- Declared Variables ---
//--------------------------
  // #DV: New[Pat] -> Set(Var)
  rule #DV( new A:VarDecs in { _:ProcPat } ) => #vardecs2set(A) // Vn(A)
  rule #DV( A:ProcPat | B:ProcPat ) => #DV(A) #DV(B) requires notBool isParPat(A)
  rule #DV( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool isParPat(A))

  // #DV: Names -> Set(Var)
  rule #DV( A:VarDecs  ) => #vardecs2set(A) [structural]
  rule #DV( A:NamePats ) => .Set requires notBool isVarDecs(A)

//----------------------------
//--- Nested Receive Names ---
//----------------------------
  rule #RN+( for( A:Lbind  ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Lbinds ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Pbind  ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Pbinds ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Rbind  ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Rbinds ){ _:Proc } ) => SetItem( #RN(A) )
// guarded
  rule #RN+( for( A:Lbind  _:Guard ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Lbinds _:Guard ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Pbind  _:Guard ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Pbinds _:Guard ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Rbind  _:Guard ){ _:Proc } ) => SetItem( #RN(A) )
  rule #RN+( for( A:Rbinds _:Guard ){ _:Proc } ) => SetItem( #RN(A) )

  rule #RN+( A:Proc | B:Proc ) => #RN+(A) #RN+(B) requires notBool isPar(A)

  rule #RN+( A:Proc ) => .Set requires notBool (isReceive(A) orBool isPar(A))

//------------------------------
//--- Name/Process Variables ---
//------------------------------
  rule #FNV(  .Set     ) => .Set
  rule #FNV( P:Proc    ) => #NV(FV(P))
  rule #FNV( P:ProcPat ) => #NV(FV(P))

  rule #NV(  .Set     ) => .Set
  rule #NV( P:Proc    ) => #NV(V(P))
  rule #NV( P:ProcPat ) => #NV(V(P))
  rule #NV(  SetItem( A:Var     : name ) S:Set ) => SetItem(A) #NV(S) // includes name kind Vars
  rule #NV(  SetItem( _:ProcVar : proc ) S:Set ) => #NV(S) // filters out proc kind Vars
//  rule #NV(  SetItem(  _:PatVar : namepat ) S:Set ) => #NV(S) // filters out namepat kind Vars
//  rule #NV(  SetItem(  _:PatVar : procpat ) S:Set ) => #NV(S) // filters out procpat kind Vars

  rule #FPV(  .Set     ) => .Set
  rule #FPV( P:Proc    ) => #PV(FV(P))
  rule #FPV( P:ProcPat ) => #PV(FV(P))

  rule #PV(  .Set     ) => .Set
  rule #PV( P:Proc    ) => #PV(V(P))
  rule #PV( P:ProcPat ) => #PV(V(P))
  rule #PV(  SetItem( \A:Var : proc ) S:Set ) => SetItem(\A) #PV(S) // includes proc kind Vars
  rule #PV(  SetItem(  _:Var : name ) S:Set ) => #PV(S) // filters out name kind Vars
//  rule #PV(  SetItem(  _:PatVar : namepat ) S:Set ) => #PV(S) // filters out namepat kind Vars
//  rule #PV(  SetItem(  _:PatVar : procpat ) S:Set ) => #PV(S) // filters out procpat kind Vars

//---------------
//--- flatten ---
//---------------
  rule flatten( .Set ) => .K

  // flatten: Set(Names) -> Names
  rule flatten( SetItem( A:Name ) ) => A
  rule flatten( SetItem( A:Name ) S:Set ) => A , flatten(S) requires S =/=K .Set

  // flatten: Set(Procs) -> Procs
  rule flatten( SetItem( A:Proc ) ) => A
  rule flatten( SetItem( A:Proc ) S:Set ) => A , flatten(S) requires S =/=K .Set

//-------------------
//--- #VarContext ---
//-------------------
  // intersection of Name variables & Proc variables
  // used to check for variables playing both roles -- should be empty
//  rule     #VarContext( A:Proc ) => intersectSet( #NV(A), #PV(A))
  // same for free variables
//  rule #FreeVarContext( A:Proc ) => intersectSet(#FNV(A),#FPV(A))

//------------------
//--- Structural ---
//------------------
// Nil = unit of |
  rule Nil       | A:ProcPat => A [anywhere, structural]
  rule A:ProcPat | Nil       => A [anywhere, structural]
// @* = Id_NamePat & *@ = Id_ProcPat
  rule @ * A:NamePat => A [anywhere, structural]
  rule * @ A:ProcPat => A [anywhere, structural]
// ~~ = Id_ProcPat
  rule ~ ~ A:ProcPat => A [anywhere, structural]

endmodule
