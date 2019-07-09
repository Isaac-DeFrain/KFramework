// Names and Variables for RHO CALCULUS with additional Ground terms

// TODO: Patterns

require "domains.k"
require "../grho.k"

module NAMEVAR-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX

// Arguments
  syntax     Arg ::= Var
                   | Names
                   | NamePats
                   | Procs
                   | ProcPats
                   | RhoKVPairs
                   | AnyBind
                   | AnyBinds
                   | AnyBindPat
                   | AnyBindPats
                   | MatchCases
                   | MCasePats
                   | MethodAndArgs
                   | ConcatExp
                   | InterpMaps
                   | Set
                   | Map

// Variable types
  syntax    Kind ::= "name" | "proc" | "pat"
  syntax KindArg ::= Arg ":" Kind

// Kind Sets
  syntax     Set ::=  "FV("   Arg  ")" [function] // free variables
                   | "FV+("   Arg  ")" [function] // auxiliary for bound variables
                   |  "BV("   Arg  ")" [function] // bound variables
                   |  "RV("   Arg  ")" [function] // receive variables
                   | "RV+("   Arg  ")" [function] // auxiliary for bound variables
                   |  "RN("   Arg  ")" [function] // receive names
                   |  "SV("   Arg  ")" [function] // send variables
                   | "SV+("   Arg  ")" [function] // auxiliary for bound variables
                   |  "SN("   Arg  ")" [function] // send names
                   |   "V("   Arg  ")" [function] // variables
                   |  "Vn("   Var  ")" [function] // Name variables
                   |  "Vp("   Var  ")" [function] // Proc variables
                   |  "LV("   Arg  ")" [function] // listening variables
                   | "LV+("   Arg  ")" [function] // auxiliary for bound variables

// Unkind Sets
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

// For sets...
syntax     KItem ::= Arg | Var | ProcVar | KindArg

endmodule


module NAMEVAR
  import NAMEVAR-SYNTAX

  syntax KResult ::= Set

//-----------------
//--- Variables ---
//-----------------
// Ground Terms
  rule  V( _:Ground    ) => .Set
  rule  V( B:BoundProc ) => .Set
  rule #V( _:Ground    ) => .Set
  rule #V( B:BoundProc ) => .Set

// Pattern
  rule  V( \_ ) => .Set
  rule #V( \_ ) => .Set

  rule  V( _:SimplePat ) => .Set
  rule #V( _:SimplePat ) => .Set

// ProcVar -- TODO
  rule Vn( X:Var ) => SetItem(X : name)
  rule Vp( X:Var ) => SetItem(X : proc)
//rule  V( X:Name[Pat] ) => Vn(X)
//rule  V( X:Proc[Pat] ) => Vp(X)

  rule  V( \X:Var ) => Vp(X)
  rule #V( \X:Var ) => SetItem(X)

// Names
  // Primitive names
  rule  V( X:Var ) => Vn(X)
  rule #V( X:Var ) => SetItem(X)

  rule  V( X:Var ( _:Uri ) ) => Vn(X)
  rule #V( X:Var ( _:Uri ) ) => SetItem(X)

  rule  V( @B:BoundProc ) => .Set // Vn(@B) Vp(B)???
  rule  V(  B:BoundName ) => .Set // Vn(B)???
  rule #V( @B:BoundProc ) => .Set
  rule #V(  B:BoundName ) => .Set
    // can use @P as Name or P as Proc
  rule  V( @\X:Var   ) => Vp(X)
  rule #V( @\X:Var   ) => SetItem(X)

  rule  V( @P:Proc    ) =>  V(P) requires notBool (isProcVar(P) orBool isBoundProc(P))
  rule  V( @P:ProcPat ) =>  V(P)
  rule #V( @P:Proc    ) => #V(P) requires notBool isProcVar(P)
  rule #V( @P:ProcPat ) => #V(P)

  // Name[Pat]s
  rule  V( A:Name    , B:Names    ) =>  V(A)  V(B)
  rule  V( A:NamePat , B:Names    ) =>  V(A)  V(B)
  rule  V( A:Name    , B:NamePats ) =>  V(A)  V(B)
  rule  V( A:NamePat , B:NamePats ) =>  V(A)  V(B)
  rule #V( A:Name    , B:Names    ) => #V(A) #V(B)
  rule #V( A:NamePat , B:Names    ) => #V(A) #V(B)
  rule #V( A:Name    , B:NamePats ) => #V(A) #V(B)
  rule #V( A:NamePat , B:NamePats ) => #V(A) #V(B)

// Receives, Binds, Contracts -- TODO: simplify to B:Bind[s] & B:Bind[s] if G:BExp
  // Guard variables should be contained in the listening variables, i.e. #FV(Guard) <=Set #LV(Rec)
  rule  V( for( B:Lbind            ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:Lbind  if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:Pbind            ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:Pbind  if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:Rbind            ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:Rbind  if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:Lbinds           ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:Lbinds if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:Pbinds           ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:Pbinds if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:Rbinds           ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:Rbinds if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule #V( for( B:Lbind            ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:Lbind  if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:Pbind            ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:Pbind  if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:Rbind            ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:Rbind  if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:Lbinds           ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:Lbinds if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:Pbinds           ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:Pbinds if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:Rbinds           ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:Rbinds if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  // Receive pattern -- TODO: simplify to B:BindPat[s] & B:BindPat[s] if G:BExp
  rule  V( for( B:LbindPat            ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:LbindPat  if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:PbindPat            ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:PbindPat  if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:RbindPat            ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:RbindPat  if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:LbindPats           ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:LbindPats if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:PbindPats           ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:PbindPats if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule  V( for( B:RbindPats           ) { P:Proc } ) =>  V(B)   V(P)
  rule  V( for( B:RbindPats if G:BExp ) { P:Proc } ) =>  V(B)  (V(G)  V(P))
  rule #V( for( B:LbindPat            ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:LbindPat  if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:PbindPat            ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:PbindPat  if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:RbindPat            ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:RbindPat  if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:LbindPats           ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:LbindPats if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:PbindPats           ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:PbindPats if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))
  rule #V( for( B:RbindPats           ) { P:Proc } ) => #V(B)  #V(P)
  rule #V( for( B:RbindPats if G:BExp ) { P:Proc } ) => #V(B) (#V(G) #V(P))

  // Bind & BindPat
  rule  V( Y:NamePats <-  X:Name    ) =>  V(X)  V(Y)
  rule  V( Y:Names    <-  X:Name    ) =>  V(X)  V(Y)
  rule  V(            <-  X:Name    ) =>  V(X)
  rule  V( Y:NamePats <<- X:Name    ) =>  V(X)  V(Y)
  rule  V( Y:Names    <<- X:Name    ) =>  V(X)  V(Y)
  rule  V(            <<- X:Name    ) =>  V(X)
  rule  V( Y:NamePats <=  X:Name    ) =>  V(X)  V(Y)
  rule  V( Y:Names    <=  X:Name    ) =>  V(X)  V(Y)
  rule  V(            <=  X:Name    ) =>  V(X)
  rule  V( Y:NamePats <-  X:NamePat ) =>  V(X)  V(Y)
  rule  V( Y:Names    <-  X:NamePat ) =>  V(X)  V(Y)
  rule  V(            <-  X:NamePat ) =>  V(X)
  rule  V( Y:NamePats <<- X:NamePat ) =>  V(X)  V(Y)
  rule  V( Y:Names    <<- X:NamePat ) =>  V(X)  V(Y)
  rule  V(            <<- X:NamePat ) =>  V(X)
  rule  V( Y:NamePats <=  X:NamePat ) =>  V(X)  V(Y)
  rule  V( Y:Names    <=  X:NamePat ) =>  V(X)  V(Y)
  rule  V(            <=  X:NamePat ) =>  V(X)
  rule #V( Y:NamePats <-  X:Name    ) => #V(X) #V(Y)
  rule #V( Y:Names    <-  X:Name    ) => #V(X) #V(Y)
  rule #V(            <-  X:Name    ) => #V(X)
  rule #V( Y:NamePats <<- X:Name    ) => #V(X) #V(Y)
  rule #V( Y:Names    <<- X:Name    ) => #V(X) #V(Y)
  rule #V(            <<- X:Name    ) => #V(X)
  rule #V( Y:NamePats <=  X:Name    ) => #V(X) #V(Y)
  rule #V( Y:Names    <=  X:Name    ) => #V(X) #V(Y)
  rule #V(            <=  X:Name    ) => #V(X)
  rule #V( Y:NamePats <-  X:NamePat ) => #V(X) #V(Y)
  rule #V( Y:Names    <-  X:NamePat ) => #V(X) #V(Y)
  rule #V(            <-  X:NamePat ) => #V(X)
  rule #V( Y:NamePats <<- X:NamePat ) => #V(X) #V(Y)
  rule #V( Y:Names    <<- X:NamePat ) => #V(X) #V(Y)
  rule #V(            <<- X:NamePat ) => #V(X)
  rule #V( Y:NamePats <=  X:NamePat ) => #V(X) #V(Y)
  rule #V( Y:Names    <=  X:NamePat ) => #V(X) #V(Y)
  rule #V(            <=  X:NamePat ) => #V(X)
  // Binds & BindPats
  rule  V( A:Lbind    ; B:Lbind     ) =>  V(A)  V(B)
  rule  V( A:LbindPat ; B:Lbind     ) =>  V(A)  V(B)
  rule  V( A:Lbind    ; B:LbindPat  ) =>  V(A)  V(B)
  rule  V( A:LbindPat ; B:LbindPat  ) =>  V(A)  V(B)
  rule  V( A:Lbind    ; B:Lbinds    ) =>  V(A)  V(B)
  rule  V( A:LbindPat ; B:Lbinds    ) =>  V(A)  V(B)
  rule  V( A:Lbind    ; B:LbindPats ) =>  V(A)  V(B)
  rule  V( A:LbindPat ; B:LbindPats ) =>  V(A)  V(B)
  rule  V( A:Pbind    ; B:Pbind     ) =>  V(A)  V(B)
  rule  V( A:PbindPat ; B:Pbind     ) =>  V(A)  V(B)
  rule  V( A:Pbind    ; B:PbindPat  ) =>  V(A)  V(B)
  rule  V( A:PbindPat ; B:PbindPat  ) =>  V(A)  V(B)
  rule  V( A:Pbind    ; B:Pbinds    ) =>  V(A)  V(B)
  rule  V( A:PbindPat ; B:Pbinds    ) =>  V(A)  V(B)
  rule  V( A:Pbind    ; B:PbindPats ) =>  V(A)  V(B)
  rule  V( A:PbindPat ; B:PbindPats ) =>  V(A)  V(B)
  rule  V( A:Rbind    ; B:Rbind     ) =>  V(A)  V(B)
  rule  V( A:RbindPat ; B:Rbind     ) =>  V(A)  V(B)
  rule  V( A:Rbind    ; B:RbindPat  ) =>  V(A)  V(B)
  rule  V( A:RbindPat ; B:RbindPat  ) =>  V(A)  V(B)
  rule  V( A:Rbind    ; B:Rbinds    ) =>  V(A)  V(B)
  rule  V( A:RbindPat ; B:Rbinds    ) =>  V(A)  V(B)
  rule  V( A:Rbind    ; B:RbindPats ) =>  V(A)  V(B)
  rule  V( A:RbindPat ; B:RbindPats ) =>  V(A)  V(B)
  rule #V( A:Lbind    ; B:Lbind     ) => #V(A) #V(B)
  rule #V( A:LbindPat ; B:Lbind     ) => #V(A) #V(B)
  rule #V( A:Lbind    ; B:LbindPat  ) => #V(A) #V(B)
  rule #V( A:LbindPat ; B:LbindPat  ) => #V(A) #V(B)
  rule #V( A:Lbind    ; B:Lbinds    ) => #V(A) #V(B)
  rule #V( A:LbindPat ; B:Lbinds    ) => #V(A) #V(B)
  rule #V( A:Lbind    ; B:LbindPats ) => #V(A) #V(B)
  rule #V( A:LbindPat ; B:LbindPats ) => #V(A) #V(B)
  rule #V( A:Pbind    ; B:Pbind     ) => #V(A) #V(B)
  rule #V( A:PbindPat ; B:Pbind     ) => #V(A) #V(B)
  rule #V( A:Pbind    ; B:PbindPat  ) => #V(A) #V(B)
  rule #V( A:PbindPat ; B:PbindPat  ) => #V(A) #V(B)
  rule #V( A:Pbind    ; B:Pbinds    ) => #V(A) #V(B)
  rule #V( A:PbindPat ; B:Pbinds    ) => #V(A) #V(B)
  rule #V( A:Pbind    ; B:PbindPats ) => #V(A) #V(B)
  rule #V( A:PbindPat ; B:PbindPats ) => #V(A) #V(B)
  rule #V( A:Rbind    ; B:Rbind     ) => #V(A) #V(B)
  rule #V( A:RbindPat ; B:Rbind     ) => #V(A) #V(B)
  rule #V( A:Rbind    ; B:RbindPat  ) => #V(A) #V(B)
  rule #V( A:RbindPat ; B:RbindPat  ) => #V(A) #V(B)
  rule #V( A:Rbind    ; B:Rbinds    ) => #V(A) #V(B)
  rule #V( A:RbindPat ; B:Rbinds    ) => #V(A) #V(B)
  rule #V( A:Rbind    ; B:RbindPats ) => #V(A) #V(B)
  rule #V( A:RbindPat ; B:RbindPats ) => #V(A) #V(B)

  // Contract -- TODO: patternize
  rule  V( contract X:Name ( Y:Names ) = { P:Proc } ) =>  V(X)  (V(Y)  V(P))
  rule  V( contract X:Name (         ) = { P:Proc } ) =>  V(X)   V(P)
  rule #V( contract X:Name ( Y:Names ) = { P:Proc } ) => #V(X) (#V(Y) #V(P))
  rule #V( contract X:Name (         ) = { P:Proc } ) => #V(X)  #V(P)

// Send & SendPat
  rule  V( X:NamePat !  ( P:ProcPats ) ) =>  V(X)  V(P)
  rule  V( X:NamePat !  ( P:Procs    ) ) =>  V(X)  V(P)
  rule  V( X:NamePat !  (            ) ) =>  V(X)
  rule  V( X:Name    !  ( P:ProcPats ) ) =>  V(X)  V(P)
  rule  V( X:Name    !  ( P:Procs    ) ) =>  V(X)  V(P)
  rule  V( X:Name    !  (            ) ) =>  V(X)
  rule  V( X:NamePat !! ( P:ProcPats ) ) =>  V(X)  V(P)
  rule  V( X:NamePat !! ( P:Procs    ) ) =>  V(X)  V(P)
  rule  V( X:NamePat !! (            ) ) =>  V(X)
  rule  V( X:Name    !! ( P:ProcPats ) ) =>  V(X)  V(P)
  rule  V( X:Name    !! ( P:Procs    ) ) =>  V(X)  V(P)
  rule  V( X:Name    !! (            ) ) =>  V(X)
  rule #V( X:NamePat !  ( P:ProcPats ) ) => #V(X) #V(P)
  rule #V( X:NamePat !  ( P:Procs    ) ) => #V(X) #V(P)
  rule #V( X:NamePat !  (            ) ) => #V(X)
  rule #V( X:Name    !  ( P:ProcPats ) ) => #V(X) #V(P)
  rule #V( X:Name    !  ( P:Procs    ) ) => #V(X) #V(P)
  rule #V( X:Name    !  (            ) ) => #V(X)
  rule #V( X:NamePat !! ( P:ProcPats ) ) => #V(X) #V(P)
  rule #V( X:NamePat !! ( P:Procs    ) ) => #V(X) #V(P)
  rule #V( X:NamePat !! (            ) ) => #V(X)
  rule #V( X:Name    !! ( P:ProcPats ) ) => #V(X) #V(P)
  rule #V( X:Name    !! ( P:Procs    ) ) => #V(X) #V(P)
  rule #V( X:Name    !! (            ) ) => #V(X)

// Par & ParPat
  rule  V( P:Proc    | Q:Proc    ) =>  V(P)  V(Q) requires notBool isPar(P)
  rule  V( P:Proc    | Q:ProcPat ) =>  V(P)  V(Q) requires notBool isPar(P)
  rule  V( P:ProcPat | Q:Proc    ) =>  V(P)  V(Q) requires notBool isParPat(P)
  rule  V( P:ProcPat | Q:ProcPat ) =>  V(P)  V(Q) requires notBool isParPat(P)
  rule #V( P:Proc    | Q:Proc    ) => #V(P) #V(Q) requires notBool isPar(P)
  rule #V( P:Proc    | Q:ProcPat ) => #V(P) #V(Q) requires notBool isPar(P)
  rule #V( P:ProcPat | Q:Proc    ) => #V(P) #V(Q) requires notBool isParPat(P)
  rule #V( P:ProcPat | Q:ProcPat ) => #V(P) #V(Q) requires notBool isParPat(P)

// Eval & EvalPat
  rule  V( *X:Name ) => V(X) requires notBool (isVar(X) orBool isBoundName(X))
  // can use *X as Proc or X as Name
  rule  V( *X:Var  ) => Vn(X)
  rule  V( *X:BoundName ) => SetItem(X : name) // ???
  rule  V( *X:NamePat   ) => V(X)
  rule #V( *X:Name ) => #V(X) requires notBool isVar(X)
  rule #V( *X:Var  ) => SetItem(X)
  rule #V( *X:NamePat ) => #V(X)

// Procs & ProcPats
  rule  V( P:Proc    , Q:Procs    ) =>  V(P)  V(Q)
  rule  V( P:ProcPat , Q:Procs    ) =>  V(P)  V(Q)
  rule  V( P:Proc    , Q:ProcPats ) =>  V(P)  V(Q)
  rule  V( P:ProcPat , Q:ProcPats ) =>  V(P)  V(Q)
  rule #V( P:Proc    , Q:Procs    ) => #V(P) #V(Q)
  rule #V( P:ProcPat , Q:Procs    ) => #V(P) #V(Q)
  rule #V( P:Proc    , Q:ProcPats ) => #V(P) #V(Q)
  rule #V( P:ProcPat , Q:ProcPats ) => #V(P) #V(Q)

//Collections
  // RhoList -- TODO: add other patterns
  rule  V( [ P:ProcPats ] ) =>  V(P)
  rule  V( [ P:Procs    ] ) =>  V(P)
  rule  V( [ ] ) => .Set
  rule #V( [ P:ProcPats ] ) => #V(P)
  rule #V( [ P:Procs    ] ) => #V(P)
  rule #V( [ ] ) => .Set
  // RhoMap
  rule  V( { } ) => .Set
  rule  V( { R:RhoKVPairs } ) => V(R)
  rule #V( { } ) => .Set
  rule #V( { R:RhoKVPairs } ) => #V(R)
    // KV pairs
  rule  V( P:Proc : Q:Proc ) => V(P) V(Q)
  rule  V( R:RhoKVPair , S:RhoKVPairs ) => V(R) V(S)
  rule #V( P:Proc : Q:Proc ) => #V(P) #V(Q)
  rule #V( R:RhoKVPair , S:RhoKVPairs ) => #V(R) #V(S)
  // RhoSet
//rule  V( Set( P:ProcPats ) ) =>  V(P)
  rule  V( Set( P:Procs ) ) =>  V(P)
  rule  V( Set( ) ) => .Set
//rule #V( Set( P:ProcPats ) ) => #V(P)
  rule #V( Set( P:Procs ) ) => #V(P)
  rule #V( Set( ) ) => .Set
  // RhoTuple -- TODO: add other patterns
  rule  V( ( P:ProcPats ,) ) =>  V(P)
  rule  V( ( P:Procs    ,) ) =>  V(P)
  rule #V( ( P:ProcPats ,) ) => #V(P)
  rule #V( ( P:Procs    ,) ) => #V(P)

// Variable Reference
  rule  V( =  \X:Var ) => Vp(X)
  rule  V( =*  X:Var ) => Vn(X)
  rule #V( =  \X:Var ) => SetItem(X)
  rule #V( =*  X:Var ) => SetItem(X)

// Bundles
  rule  V( bundle+{ P:Proc } ) =>  V(P)
  rule  V( bundle-{ P:Proc } ) =>  V(P)
  rule  V( bundle0{ P:Proc } ) =>  V(P)
  rule  V(  bundle{ P:Proc } ) =>  V(P)
  rule #V( bundle+{ P:Proc } ) => #V(P)
  rule #V( bundle-{ P:Proc } ) => #V(P)
  rule #V( bundle0{ P:Proc } ) => #V(P)
  rule #V(  bundle{ P:Proc } ) => #V(P)

// New & NewPat
  rule  V( new X:Names in { P:Proc    } ) =>  V(X)  V(P)
  rule  V( new X:Names in { P:ProcPat } ) =>  V(X)  V(P)
  rule #V( new X:Names in { P:Proc    } ) => #V(X) #V(P)
  rule #V( new X:Names in { P:ProcPat } ) => #V(X) #V(P)

// Conditional & CondPat
  rule  V( if  ( B:BExp )   P:Proc    ) =>  V(B)  V(P)
  rule  V( if  ( B:BExp )   P:ProcPat ) =>  V(B)  V(P)
  rule  V( A:IfThen    else P:Proc    ) =>  V(A)  V(P)
  rule  V( A:IfThen    else P:ProcPat ) =>  V(A)  V(P)
  rule  V( A:IfThenPat else P:ProcPat ) =>  V(A)  V(P)
  rule #V( if  ( B:BExp )   P:Proc    ) => #V(B) #V(P)
  rule #V( if  ( B:BExp )   P:ProcPat ) => #V(B) #V(P)
  rule #V( A:IfThen    else P:Proc    ) => #V(A) #V(P)
  rule #V( A:IfThen    else P:ProcPat ) => #V(A) #V(P)
  rule #V( A:IfThenPat else P:ProcPat ) => #V(A) #V(P)

// Match -- TODO: MatchPat
  rule  V( match { P:Proc } { M:MatchCases } ) =>  V(P)  V(M)
  rule #V( match { P:Proc } { M:MatchCases } ) => #V(P) #V(M)
  // MatchCases
  rule  V( { P:Proc    } |=> Q:Proc ) =>  V(P)  V(Q)
  rule  V( { P:ProcPat } |=> Q:Proc ) =>  V(P)  V(Q)
  rule  V( A:MatchCase B:MatchCases ) =>  V(A)  V(B)
  rule #V( { P:Proc    } |=> Q:Proc ) => #V(P) #V(Q)
  rule #V( { P:ProcPat } |=> Q:Proc ) => #V(P) #V(Q)
  rule #V( A:MatchCase B:MatchCases ) => #V(A) #V(B)

// TODO: select & SelectPat

// Method
  rule  V( P:Proc M:MethodAndArgs ) =>  V(P)  V(M)
  rule  V( . _:Method ( A:Procs ) ) =>  V(A)
  rule  V( . _:Method ( ) ) => .Set
  rule #V( P:Proc M:MethodAndArgs ) => #V(P) #V(M)
  rule #V( . _:Method ( A:Procs ) ) => #V(A)
  rule #V( . _:Method ( ) ) => .Set

// Arithmetic Expressions
  rule  V( - A:AExp         ) => V(A)
  rule  V( A:AExp *  B:AExp ) => V(A) V(B)
  rule  V( A:AExp /  B:AExp ) => V(A) V(B)
  rule  V( A:AExp +  B:AExp ) => V(A) V(B)
  rule  V( A:AExp -  B:AExp ) => V(A) V(B)
  rule  V( A:AExp %  B:AExp ) => V(A) V(B)
  rule  V( A:StringOrVar B:ConcatExp ) => V(A) V(B)
  rule  V( ++ A:StringOrVar ) => V(A)
  rule  V( ++ A:StringOrVar B:ConcatExp  ) => V(A) V(B)
  rule  V( A:StringOrVar %% B:InterpMaps ) => V(A) V(B)
  rule  V( A:RhoMap %% B:InterpMaps ) => V(A) V(B)
  rule #V( - A:AExp         ) => #V(A)
  rule #V( A:AExp *  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp /  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp +  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp -  B:AExp ) => #V(A) #V(B)
  rule #V( A:AExp %  B:AExp ) => #V(A) #V(B)
  rule #V( A:StringOrVar B:ConcatExp ) => #V(A) #V(B)
  rule #V( ++ A:StringOrVar ) => #V(A)
  rule #V( ++ A:StringOrVar B:ConcatExp  ) => #V(A) #V(B)
  rule #V( A:StringOrVar %% B:InterpMaps ) => #V(A) #V(B)
  rule #V( A:RhoMap %% B:InterpMaps ) => #V(A) #V(B)

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

// TODO: other Pattern expressions

//----------------------
//--- Free Variables ---
//----------------------
// Auxiliary function for bindings in Receives, New, & Match
  rule FV+( X:Var ) => SetItem(X : name) SetItem(*X : proc)
  rule FV+( X:Var ( _:Uri ) ) => SetItem(X : name) SetItem(*X : proc)

  // Ground, Bound
  rule FV+( _:Ground    ) => .Set
  rule FV+( _:BoundName ) => .Set
  rule FV+( _:BoundProc ) => .Set

// Pattern
  rule FV+( \_ ) => .Set
  rule FV+( _:SimplePat ) => .Set

  // PatExp
  rule FV+( ~ A:Proc    ) => FV+(A)
  rule FV+( ~ A:ProcPat ) => FV+(A)
  rule FV+( A:Proc    /\ B:Proc    ) => FV+(A) FV+(B)
  rule FV+( A:Proc    /\ B:ProcPat ) => FV+(A) FV+(B)
  rule FV+( A:ProcPat /\ B:Proc    ) => FV+(A) FV+(B)
  rule FV+( A:ProcPat /\ B:ProcPat ) => FV+(A) FV+(B)
  rule FV+( A:Proc    \/ B:Proc    ) => FV+(A) FV+(B)
  rule FV+( A:Proc    \/ B:ProcPat ) => FV+(A) FV+(B)
  rule FV+( A:ProcPat \/ B:Proc    ) => FV+(A) FV+(B)
  rule FV+( A:ProcPat \/ B:ProcPat ) => FV+(A) FV+(B)


  // ProcVar
  rule FV+( \X:Var ) => Vp(X)

  // Quote & QuotePat
  rule FV+( @A:Proc    ) => FV+(A)
  rule FV+( @A:ProcPat ) => FV+(A)

  // Receives, Binds, Contract, Invocation
    // free variables of a Receive are the receive variables or free variables of the continuation that are not listening variables
  rule FV+( for( B:Lbind  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Lbinds ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Pbind  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Pbinds ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Rbind  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:Rbinds ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
    // Guarded -- free variables of the Receive or free variables of the Guard or continuation that are not listening variables
  rule FV+( for( B:Lbind  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Lbinds if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Pbind  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Pbinds if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Rbind  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:Rbinds if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))

// BindPat(s)
  rule FV+( for( B:LbindPat  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:LbindPats ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:PbindPat  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:PbindPats ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:RbindPat  ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  rule FV+( for( B:RbindPats ) { P:Proc } ) => RV+(B) (FV+(P) -Set LV+(B))
  // Guarded
  rule FV+( for( B:LbindPat  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:LbindPats if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:PbindPat  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:PbindPats if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:RbindPat  if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))
  rule FV+( for( B:RbindPats if G:BExp ) { P:Proc } ) => RV+(B) ((FV+(G) FV+(P)) -Set LV+(B))

    // Contract -- same as Receive
  rule FV+( contract X:NamePat ( Y:NamePats ) = { P:ProcPat } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:NamePat ( Y:Names    ) = { P:ProcPat } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:NamePat (            ) = { P:ProcPat } ) => FV+(for(  <= X){P})
  rule FV+( contract X:NamePat ( Y:NamePats ) = { P:Proc    } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:NamePat ( Y:Names    ) = { P:Proc    } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:NamePat (            ) = { P:Proc    } ) => FV+(for(  <= X){P})
  rule FV+( contract X:Name    ( Y:NamePats ) = { P:ProcPat } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:Name    ( Y:Names    ) = { P:ProcPat } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:Name    (            ) = { P:ProcPat } ) => FV+(for(  <= X){P})
  rule FV+( contract X:Name    ( Y:NamePats ) = { P:Proc    } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:Name    ( Y:Names    ) = { P:Proc    } ) => FV+(for(Y <= X){P})
  rule FV+( contract X:Name    (            ) = { P:Proc    } ) => FV+(for(  <= X){P})
    // Invocation -- // ???
  rule FV+( invoke X:Name ( Y:Procs ) ) => FV+(X) FV+(Y)
  rule FV+( invoke X:Name (         ) ) => FV+(X)

  // Send
  rule FV+( A:NamePat !  ( B:ProcPats ) ) => FV+(A) FV+(B)
  rule FV+( A:NamePat !  ( B:Procs    ) ) => FV+(A) FV+(B)
  rule FV+( A:NamePat !  (            ) ) => FV+(A)
  rule FV+( A:Name    !  ( B:ProcPats ) ) => FV+(A) FV+(B)
  rule FV+( A:Name    !  ( B:Procs    ) ) => FV+(A) FV+(B)
  rule FV+( A:Name    !  (            ) ) => FV+(A)
  rule FV+( A:NamePat !! ( B:ProcPats ) ) => FV+(A) FV+(B)
  rule FV+( A:NamePat !! ( B:Procs    ) ) => FV+(A) FV+(B)
  rule FV+( A:NamePat !! (            ) ) => FV+(A)
  rule FV+( A:Name    !! ( B:ProcPats ) ) => FV+(A) FV+(B)
  rule FV+( A:Name    !! ( B:Procs    ) ) => FV+(A) FV+(B)
  rule FV+( A:Name    !! (            ) ) => FV+(A)

  // Par
  rule FV+( A:Proc    | B:Proc    ) => FV+(A) FV+(B) requires notBool isPar(B)
  rule FV+( A:Proc    | B:ProcPat ) => FV+(A) FV+(B) requires notBool isPar(B)
  rule FV+( A:ProcPat | B:Proc    ) => FV+(A) FV+(B) requires notBool isParPat(B)
  rule FV+( A:ProcPat | B:ProcPat ) => FV+(A) FV+(B) requires notBool isParPat(B)

  // Eval
  rule FV+( *X:Name    ) => FV+(X) requires notBool isVar(X)
  rule FV+( *X:NamePat ) => FV+(X)
    // can use *X as Proc or X as Name
  rule FV+( *X:Var ) => SetItem(*X : proc) SetItem(X : name)

  // Collections
    // RhoTuple
  rule FV+( ( P:ProcPats ,) ) => FV+(P)
  rule FV+( ( P:Procs    ,) ) => FV+(P)
    // RhoList
  rule FV+( [ P:ProcPats ] ) => FV+(P)
  rule FV+( [ P:Procs    ] ) => FV+(P)
  rule FV+( [ ] ) => .Set
    // RhoSet
  rule FV+( Set( P:Procs ) ) => FV+(P)
  rule FV+( Set( ) ) => .Set
    // RhoMap
  rule FV+( { } ) => .Set
  rule FV+( { R:RhoKVPairs } ) => FV+(R)
      // KV pairs
  rule FV+( P:Proc : Q:Proc ) => FV+(P) FV+(Q)
  rule FV+( R:RhoKVPair , S:RhoKVPairs ) => FV+(R) FV+(S)

  // Variable Reference
  rule FV+( = \X:Var ) => FV+(@\X) // FVp(X)
  rule FV+( =* X:Var ) => FV+(*X)  // FVn(X)

  // New
  rule FV+( new X:Names in { P:Proc    } ) => FV+(P) -Set FV+(X)
  rule FV+( new X:Names in { P:ProcPat } ) => FV+(P) -Set FV+(X)

  // Conditionals
  rule FV+( if ( B:BExp )    P:Proc    ) => FV+(B) FV+(P)
  rule FV+( if ( B:BExp )    P:ProcPat ) => FV+(B) FV+(P)
  rule FV+( A:IfThen    else P:Proc    ) => FV+(A) FV+(P)
  rule FV+( A:IfThen    else P:ProcPat ) => FV+(A) FV+(P)
  rule FV+( A:IfThenPat else P:Proc    ) => FV+(A) FV+(P)
  rule FV+( A:IfThenPat else P:ProcPat ) => FV+(A) FV+(P)

  // Match -- TODO: add patterns!!!
  rule FV+( match { P:Proc } { M:MatchCases } ) => FV+(P) FV+(M)
    // MatchCases -- free variables in to be matched Proc P are bound in resulting Proc Q ???
  rule FV+( { P:Proc } |=> Q:Proc    ) => FV+(Q) -Set FV+(P)
  rule FV+( A:MatchCase B:MatchCases ) => FV+(A) FV+(B)

  // Method
  rule FV+( P:Proc M:MethodAndArgs ) => FV+(P) FV+(M)
  rule FV+( . _:Method ( A:Procs ) ) => FV+(A)
  rule FV+( . _:Method (         ) ) => .Set

  // Bundles -- TODO: bindings?
  rule FV+( bundle+{ P:Proc } ) => RV+(P)  // write-only => only send names available -- receive variables are free?
  rule FV+( bundle-{ P:Proc } ) => SV+(P)  // read-only  => only receive names available -- send variables are free?
  rule FV+( bundle0{ P:Proc } ) => .Set   // no read/write => no names available
  rule FV+(  bundle{ P:Proc } ) => FV+(P)  // read/write => both send & receive names available

  // Arithmetic Expressions
  rule FV+( - A:AExp         ) => FV+(A)
  rule FV+( A:AExp *  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp /  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp +  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp -  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:AExp %  B:AExp ) => FV+(A) FV+(B)
  rule FV+( A:StringOrVar B:ConcatExp ) => FV+(A) FV+(B)
  rule FV+( ++ A:StringOrVar ) => FV+(A)
  rule FV+( ++ A:StringOrVar B:ConcatExp  ) => FV+(A) FV+(B)
  rule FV+( A:StringOrVar %% B:InterpMaps ) => FV+(A) FV+(B)
  rule FV+( A:RhoMap      %% B:InterpMaps ) => FV+(A) FV+(B)

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

  // Name[Pats
  rule FV+( A:Name    , B:Names    ) => FV+(A) FV+(B)
  rule FV+( A:NamePat , B:Names    ) => FV+(A) FV+(B)
  rule FV+( A:Name    , B:NamePats ) => FV+(A) FV+(B)
  rule FV+( A:NamePat , B:NamePats ) => FV+(A) FV+(B)

  // Proc[Pat]s
  rule FV+( A:Proc    , B:Procs    ) => FV+(A) FV+(B)
  rule FV+( A:ProcPat , B:Procs    ) => FV+(A) FV+(B)
  rule FV+( A:Proc    , B:ProcPats ) => FV+(A) FV+(B)
  rule FV+( A:ProcPat , B:ProcPats ) => FV+(A) FV+(B)

// Ground, Bound
  rule  FV( _:Ground    ) => .Set
  rule  FV( _:BoundName ) => .Set
  rule  FV( _:BoundProc ) => .Set
  rule  FV(   sub       ) => .Set
  rule  FV(   \_        ) => .Set
  rule  FV( _:SimplePat ) => .Set
  rule #FV( _:Ground    ) => .Set
  rule #FV( _:BoundName ) => .Set
  rule #FV( _:BoundProc ) => .Set
  rule #FV(   sub       ) => .Set
  rule #FV(   \_        ) => .Set
  rule #FV( _:SimplePat ) => .Set

// Var -- TODO: FV( X:Name ) => FVn(X) & FV( X:Proc ) => FVp(X)
  rule  FV( X:Var           ) => Vn(X)
  rule  FV( X:Var ( _:Uri ) ) => Vn(X)
  rule #FV( X:Var           ) => SetItem(X)
  rule #FV( X:Var ( _:Uri ) ) => SetItem(X)

// ProcVar
  rule  FV( \X:Var ) => Vp(X)
  rule #FV( \X:Var ) => SetItem(X)

// Quote
  rule  FV( @\X:Var    ) =>  Vp(X)
  rule  FV( @P:Proc    ) =>  FV(P) requires notBool isProcVar(P)
  rule  FV( @P:ProcPat ) =>  FV(P)
  rule #FV( @P:Proc    ) => #FV(P)
  rule #FV( @P:ProcPat ) => #FV(P)

// Receives, Binds, Contract, Invocation
  // free variables of a Receive are the receive variables or free variables of the continuation that are not listening variables
  rule  FV( for( B:Lbind     ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Lbinds    ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Pbind     ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Pbinds    ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Rbind     ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Rbinds    ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Lbind     ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Lbinds    ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Pbind     ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Pbinds    ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Rbind     ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:Rbinds    ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:LbindPat  ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:LbindPats ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:PbindPat  ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:PbindPats ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:RbindPat  ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:RbindPats ) { P:Proc    } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:LbindPat  ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:LbindPats ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:PbindPat  ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:PbindPats ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:RbindPat  ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule  FV( for( B:RbindPats ) { P:ProcPat } ) =>  RV(B)  (FV(P) -Set LV+(B))
  rule #FV( for( B:Lbind     ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Lbinds    ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Pbind     ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Pbinds    ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Rbind     ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Rbinds    ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Lbind     ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Lbinds    ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Pbind     ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Pbinds    ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Rbind     ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:Rbinds    ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:LbindPat  ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:LbindPats ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:PbindPat  ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:PbindPats ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:RbindPat  ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:RbindPats ) { P:Proc    } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:LbindPat  ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:LbindPats ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:PbindPat  ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:PbindPats ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:RbindPat  ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  rule #FV( for( B:RbindPats ) { P:ProcPat } ) => #RV(B) (#FV(P) -Set #LV(B))
  // Guarded -- free variables of the Receive or free variables of the Guard or continuation that are not listening variables
  rule  FV( for( B:Lbind  if G:BExp ) { P:Proc    } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Lbinds if G:BExp ) { P:Proc    } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Pbind  if G:BExp ) { P:Proc    } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Pbinds if G:BExp ) { P:Proc    } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Rbind  if G:BExp ) { P:Proc    } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Rbinds if G:BExp ) { P:Proc    } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Lbind  if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Lbinds if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Pbind  if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Pbinds if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Rbind  if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule  FV( for( B:Rbinds if G:BExp ) { P:ProcPat } ) =>  RV(B)  ((FV(G)  FV(P)) -Set LV+(B))
  rule #FV( for( B:Lbind  if G:BExp ) { P:Proc    } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Lbinds if G:BExp ) { P:Proc    } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Pbind  if G:BExp ) { P:Proc    } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Pbinds if G:BExp ) { P:Proc    } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Rbind  if G:BExp ) { P:Proc    } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Rbinds if G:BExp ) { P:Proc    } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Lbind  if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Lbinds if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Pbind  if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Pbinds if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Rbind  if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  rule #FV( for( B:Rbinds if G:BExp ) { P:ProcPat } ) => #RV(B) ((#FV(G) #FV(P)) -Set #LV(B))
  // Contract -- same as Receive
  rule  FV( contract X:NamePat ( Y:NamePats ) = { P:ProcPat } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:NamePat ( Y:Names    ) = { P:ProcPat } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:NamePat (            ) = { P:ProcPat } ) =>  FV(for(  <= X){P})
  rule  FV( contract X:NamePat ( Y:NamePats ) = { P:Proc    } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:NamePat ( Y:Names    ) = { P:Proc    } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:NamePat (            ) = { P:Proc    } ) =>  FV(for(  <= X){P})
  rule  FV( contract X:Name    ( Y:NamePats ) = { P:Proc    } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:Name    ( Y:Names    ) = { P:Proc    } ) =>  FV(for(Y <= X){P})
  rule  FV( contract X:Name    (            ) = { P:Proc    } ) =>  FV(for(  <= X){P})
  rule #FV( contract X:NamePat ( Y:NamePats ) = { P:ProcPat } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:NamePat ( Y:Names    ) = { P:ProcPat } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:NamePat (            ) = { P:ProcPat } ) => #FV(for(  <= X){P})
  rule #FV( contract X:NamePat ( Y:NamePats ) = { P:Proc    } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:NamePat ( Y:Names    ) = { P:Proc    } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:NamePat (            ) = { P:Proc    } ) => #FV(for(  <= X){P})
  rule #FV( contract X:Name    ( Y:NamePats ) = { P:Proc    } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:Name    ( Y:Names    ) = { P:Proc    } ) => #FV(for(Y <= X){P})
  rule #FV( contract X:Name    (            ) = { P:Proc    } ) => #FV(for(  <= X){P})
  // Invocation -- // ???
  rule  FV( invoke X:NamePat ( Y:ProcPats ) ) =>  FV(X)  FV(Y)
  rule  FV( invoke X:NamePat ( Y:Procs    ) ) =>  FV(X)  FV(Y)
  rule  FV( invoke X:NamePat (            ) ) =>  FV(X)
  rule  FV( invoke X:Name    ( Y:ProcPats ) ) =>  FV(X)  FV(Y)
  rule  FV( invoke X:Name    ( Y:Procs    ) ) =>  FV(X)  FV(Y)
  rule  FV( invoke X:Name    (            ) ) =>  FV(X)
  rule #FV( invoke X:NamePat ( Y:ProcPats ) ) => #FV(X) #FV(Y)
  rule #FV( invoke X:NamePat ( Y:Procs    ) ) => #FV(X) #FV(Y)
  rule #FV( invoke X:NamePat (            ) ) => #FV(X)
  rule #FV( invoke X:Name    ( Y:ProcPats ) ) => #FV(X) #FV(Y)
  rule #FV( invoke X:Name    ( Y:Procs    ) ) => #FV(X) #FV(Y)
  rule #FV( invoke X:Name    (            ) ) => #FV(X)

// Send
  rule  FV( X:NamePat !  ( P:ProcPats ) ) =>  FV(X)  FV(P)
  rule  FV( X:NamePat !  ( P:Procs    ) ) =>  FV(X)  FV(P)
  rule  FV( X:NamePat !  (            ) ) =>  FV(X)
  rule  FV( X:Name    !  ( P:ProcPats ) ) =>  FV(X)  FV(P)
  rule  FV( X:Name    !  ( P:Procs    ) ) =>  FV(X)  FV(P)
  rule  FV( X:Name    !  (            ) ) =>  FV(X)
  rule  FV( X:NamePat !! ( P:ProcPats ) ) =>  FV(X)  FV(P)
  rule  FV( X:NamePat !! ( P:Procs    ) ) =>  FV(X)  FV(P)
  rule  FV( X:NamePat !! (            ) ) =>  FV(X)
  rule  FV( X:Name    !! ( P:ProcPats ) ) =>  FV(X)  FV(P)
  rule  FV( X:Name    !! ( P:Procs    ) ) =>  FV(X)  FV(P)
  rule  FV( X:Name    !! (            ) ) =>  FV(X)
  rule #FV( X:NamePat !  ( P:ProcPats ) ) => #FV(X) #FV(P)
  rule #FV( X:NamePat !  ( P:Procs    ) ) => #FV(X) #FV(P)
  rule #FV( X:NamePat !  (            ) ) => #FV(X)
  rule #FV( X:Name    !  ( P:ProcPats ) ) => #FV(X) #FV(P)
  rule #FV( X:Name    !  ( P:Procs    ) ) => #FV(X) #FV(P)
  rule #FV( X:Name    !  (            ) ) => #FV(X)
  rule #FV( X:NamePat !! ( P:ProcPats ) ) => #FV(X) #FV(P)
  rule #FV( X:NamePat !! ( P:Procs    ) ) => #FV(X) #FV(P)
  rule #FV( X:NamePat !! (            ) ) => #FV(X)
  rule #FV( X:Name    !! ( P:ProcPats ) ) => #FV(X) #FV(P)
  rule #FV( X:Name    !! ( P:Procs    ) ) => #FV(X) #FV(P)
  rule #FV( X:Name    !! (            ) ) => #FV(X)

// Par
  rule  FV( P:Proc    | Q:Proc    ) =>  FV(P)  FV(Q) requires notBool isPar(P)
  rule  FV( P:Proc    | Q:ProcPat ) =>  FV(P)  FV(Q) requires notBool isPar(P)
  rule  FV( P:ProcPat | Q:Proc    ) =>  FV(P)  FV(Q) requires notBool isParPat(P)
  rule  FV( P:ProcPat | Q:ProcPat ) =>  FV(P)  FV(Q) requires notBool isParPat(P)
  rule #FV( P:Proc    | Q:Proc    ) => #FV(P) #FV(Q) requires notBool isPar(P)
  rule #FV( P:Proc    | Q:ProcPat ) => #FV(P) #FV(Q) requires notBool isPar(P)
  rule #FV( P:ProcPat | Q:Proc    ) => #FV(P) #FV(Q) requires notBool isParPat(P)
  rule #FV( P:ProcPat | Q:ProcPat ) => #FV(P) #FV(Q) requires notBool isParPat(P)

// Eval
  rule  FV( *X:Name    ) =>  FV(X) // requires notBool isVar(X)
  rule  FV( *X:NamePat ) =>  FV(X)
  rule #FV( *X:Name    ) => #FV(X) // requires notBool isVar(X)
  rule #FV( *X:NamePat ) => #FV(X)

// Collections
  // RhoTuple
  rule  FV( ( P:ProcPats ,) ) =>  FV(P)
  rule  FV( ( P:Procs    ,) ) =>  FV(P)
  rule #FV( ( P:ProcPats ,) ) => #FV(P)
  rule #FV( ( P:Procs    ,) ) => #FV(P)
  // RhoList
  rule  FV( [ P:ProcPats ] ) =>  FV(P)
  rule  FV( [ P:Procs    ] ) =>  FV(P)
  rule  FV( [ ] ) => .Set
  rule #FV( [ P:ProcPats ] ) => #FV(P)
  rule #FV( [ P:Procs    ] ) => #FV(P)
  rule #FV( [ ] ) => .Set
  // RhoSet
  rule  FV( Set( P:Procs ) ) =>  FV(P)
  rule  FV( Set( ) ) => .Set
  rule #FV( Set( P:Procs ) ) => #FV(P)
  rule #FV( Set( ) ) => .Set
  // RhoMap
  rule  FV( { } ) => .Set
  rule  FV( { R:RhoKVPairs } ) => FV(R)
  rule #FV( { } ) => .Set
  rule #FV( { R:RhoKVPairs } ) => #FV(R)
    // KV pairs
  rule  FV( P:Proc : Q:Proc ) => FV(P) FV(Q)
  rule  FV( R:RhoKVPair , S:RhoKVPairs ) => FV(R) FV(S)
  rule #FV( P:Proc : Q:Proc ) => #FV(P) #FV(Q)
  rule #FV( R:RhoKVPair , S:RhoKVPairs ) => #FV(R) #FV(S)

// Variable Reference -- TODO: binding?
  rule  FV( = \X:Var ) => Vp(X)
  rule  FV( =* X:Var ) => Vn(X)
  rule #FV( = \X:Var ) => SetItem(X)
  rule #FV( =* X:Var ) => SetItem(X)

// New
  rule  FV( new X:Names in { P:Proc    } ) =>  FV(P) -Set FV+(X)
  rule  FV( new X:Names in { P:ProcPat } ) =>  FV(P) -Set FV+(X)
  rule #FV( new X:Names in { P:Proc    } ) => #FV(P) -Set #FV(X)
  rule #FV( new X:Names in { P:ProcPat } ) => #FV(P) -Set #FV(X)

// Conditionals
  rule  FV(   if ( B:BExp )  P:Proc    ) =>  FV(B)  FV(P)
  rule  FV(   if ( B:BExp )  P:ProcPat ) =>  FV(B)  FV(P)
  rule  FV( A:IfThen    else P:Proc    ) =>  FV(A)  FV(P)
  rule  FV( A:IfThenPat else P:Proc    ) =>  FV(A)  FV(P)
  rule  FV( A:IfThenPat else P:ProcPat ) =>  FV(A)  FV(P)
  rule #FV(   if ( B:BExp )  P:Proc    ) => #FV(B) #FV(P)
  rule #FV(   if ( B:BExp )  P:ProcPat ) => #FV(B) #FV(P)
  rule #FV( A:IfThen    else P:Proc    ) => #FV(A) #FV(P)
  rule #FV( A:IfThenPat else P:Proc    ) => #FV(A) #FV(P)
  rule #FV( A:IfThenPat else P:ProcPat ) => #FV(A) #FV(P)

// Match -- TODO: patterns
  rule  FV( match { P:Proc } { M:MatchCases } ) =>  FV(P)  FV(M)
  rule #FV( match { P:Proc } { M:MatchCases } ) => #FV(P) #FV(M)
  // MatchCases -- free variables in to be matched Proc P are bound in resulting Proc Q ???
  rule  FV( { P:Proc    } |=> Q:Proc ) =>  FV(Q) -Set FV+(P) // must be empty for each MatchCase for Match to be closed, i.e. FV(Q) <=Set FV+(P)
  rule  FV( { P:ProcPat } |=> Q:Proc ) =>  FV(Q) -Set FV+(P) // must be empty for each MatchCase for Match to be closed, i.e. #FV(Q) <=Set #FV(P)
  rule  FV( A:MatchCase B:MatchCases ) =>  FV(A)  FV(B)
  rule #FV( { P:Proc    } |=> Q:Proc ) => #FV(Q) -Set #FV(P) // must be empty for each MatchCase for Match to be closed, i.e. #FV(Q) <=Set #FV(P)
  rule #FV( { P:ProcPat } |=> Q:Proc ) => #FV(Q) -Set #FV(P) // must be empty for each MatchCase for Match to be closed, i.e. #FV(Q) <=Set #FV(P)
  rule #FV( A:MatchCase B:MatchCases ) => #FV(A) #FV(B)

// Method
  rule  FV( P:Proc M:MethodAndArgs ) =>  FV(P)  FV(M)
  rule  FV( . _:Method ( A:Procs ) ) =>  FV(A)
  rule  FV( . _:Method (         ) ) => .Set
  rule #FV( P:Proc M:MethodAndArgs ) => #FV(P) #FV(M)
  rule #FV( . _:Method ( A:Procs ) ) => #FV(A)
  rule #FV( . _:Method (         ) ) => .Set

// Bundles -- TODO: bindings?
  rule  FV( bundle+{ P:Proc } ) =>  RV(P)  // write-only => only send names available -- receive variables are free?
  rule  FV( bundle-{ P:Proc } ) =>  SV(P)  // read-only  => only receive names available -- send variables are free?
  rule  FV( bundle0{ P:Proc } ) => .Set   // no read/write => no names available
  rule  FV(  bundle{ P:Proc } ) =>  FV(P)  // read/write => both send & receive names available
  rule #FV( bundle+{ P:Proc } ) => #RV(P)
  rule #FV( bundle-{ P:Proc } ) => #SV(P)
  rule #FV( bundle0{ P:Proc } ) => .Set
  rule #FV(  bundle{ P:Proc } ) => #FV(P)

// Arithmetic Expressions
  rule  FV( - A:AExp         ) => FV(A)
  rule  FV( A:AExp *  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp /  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp +  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp -  B:AExp ) => FV(A) FV(B)
  rule  FV( A:AExp %  B:AExp ) => FV(A) FV(B)
  rule  FV( A:StringOrVar B:ConcatExp ) => FV(A) FV(B)
  rule  FV( ++ A:StringOrVar ) => FV(A)
  rule  FV( ++ A:StringOrVar B:ConcatExp  ) => FV(A) FV(B)
  rule  FV( A:StringOrVar %% B:InterpMaps ) => FV(A) FV(B)
  rule  FV( A:RhoMap %% B:InterpMaps ) => FV(A) FV(B)
  rule #FV( - A:AExp         ) => #FV(A)
  rule #FV( A:AExp *  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp /  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp +  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp -  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:AExp %  B:AExp ) => #FV(A) #FV(B)
  rule #FV( A:StringOrVar B:ConcatExp ) => #FV(A) #FV(B)
  rule #FV( ++ A:StringOrVar ) => #FV(A)
  rule #FV( ++ A:StringOrVar B:ConcatExp  ) => #FV(A) #FV(B)
  rule #FV( A:StringOrVar %% B:InterpMaps ) => #FV(A) #FV(B)
  rule #FV( A:RhoMap %% B:InterpMaps ) => #FV(A) #FV(B)

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
  rule #FV( A:Proc    matches B:Proc    ) => #FV(A) #FV(B)
  rule #FV( A:Proc    matches B:ProcPat ) => #FV(A) #FV(B)
  rule #FV( A:ProcPat matches B:ProcPat ) => #FV(A) #FV(B)

// Name[Pat]s
  rule  FV( X:Name    , Y:Names    ) =>  FV(X)  FV(Y)
  rule  FV( X:Name    , Y:NamePats ) =>  FV(X)  FV(Y)
  rule  FV( X:NamePat , Y:Names    ) =>  FV(X)  FV(Y)
  rule  FV( X:NamePat , Y:NamePats ) =>  FV(X)  FV(Y)
  rule #FV( X:Name    , Y:Names    ) => #FV(X) #FV(Y)
  rule #FV( X:Name    , Y:NamePats ) => #FV(X) #FV(Y)
  rule #FV( X:NamePat , Y:Names    ) => #FV(X) #FV(Y)
  rule #FV( X:NamePat , Y:NamePats ) => #FV(X) #FV(Y)

// Procs
  rule  FV( P:Proc    , Q:Procs    ) =>  FV(P)  FV(Q)
  rule  FV( P:Proc    , Q:ProcPats ) =>  FV(P)  FV(Q)
  rule  FV( P:ProcPat , Q:Procs    ) =>  FV(P)  FV(Q)
  rule  FV( P:ProcPat , Q:ProcPats ) =>  FV(P)  FV(Q)
  rule #FV( P:Proc    , Q:Procs    ) => #FV(P) #FV(Q)
  rule #FV( P:Proc    , Q:ProcPats ) => #FV(P) #FV(Q)
  rule #FV( P:ProcPat , Q:Procs    ) => #FV(P) #FV(Q)
  rule #FV( P:ProcPat , Q:ProcPats ) => #FV(P) #FV(Q)

// ProcPat
  // SimplePat
  rule #FV( _:SimplePat ) => .Set

  // PatExp
  rule  FV( ~ A:Proc    ) =>  FV(A)
  rule  FV( ~ A:ProcPat ) =>  FV(A)
  rule  FV( A:Proc    /\ B:Proc    ) =>  FV(A)  FV(B)
  rule  FV( A:Proc    /\ B:ProcPat ) =>  FV(A)  FV(B)
  rule  FV( A:ProcPat /\ B:Proc    ) =>  FV(A)  FV(B)
  rule  FV( A:ProcPat /\ B:ProcPat ) =>  FV(A)  FV(B)
  rule  FV( A:Proc    \/ B:Proc    ) =>  FV(A)  FV(B)
  rule  FV( A:Proc    \/ B:ProcPat ) =>  FV(A)  FV(B)
  rule  FV( A:ProcPat \/ B:Proc    ) =>  FV(A)  FV(B)
  rule  FV( A:ProcPat \/ B:ProcPat ) =>  FV(A)  FV(B)
  rule #FV( ~ A:Proc    ) => #FV(A)
  rule #FV( ~ A:ProcPat ) => #FV(A)
  rule #FV( A:Proc    /\ B:Proc    ) => #FV(A) #FV(B)
  rule #FV( A:Proc    /\ B:ProcPat ) => #FV(A) #FV(B)
  rule #FV( A:ProcPat /\ B:Proc    ) => #FV(A) #FV(B)
  rule #FV( A:ProcPat /\ B:ProcPat ) => #FV(A) #FV(B)
  rule #FV( A:Proc    \/ B:Proc    ) => #FV(A) #FV(B)
  rule #FV( A:Proc    \/ B:ProcPat ) => #FV(A) #FV(B)
  rule #FV( A:ProcPat \/ B:Proc    ) => #FV(A) #FV(B)
  rule #FV( A:ProcPat \/ B:ProcPat ) => #FV(A) #FV(B)

//-----------------------
//--- Bound Variables ---
//-----------------------
  rule  BV( P:Procs    ) =>  V(P) -Set  FV(P)
  rule  BV( P:ProcPats ) =>  V(P) -Set  FV(P)
  rule  BV( N:Names    ) =>  V(N) -Set  FV(N)
  rule  BV( N:NamePats ) =>  V(N) -Set  FV(N)
  rule #BV( P:Procs    ) => #V(P) -Set #FV(P)
  rule #BV( P:ProcPats ) => #V(P) -Set #FV(P)
  rule #BV( N:Names    ) => #V(N) -Set #FV(N)
  rule #BV( N:NamePats ) => #V(N) -Set #FV(N)

//---------------------------
//--- Listening Variables ---
//---------------------------
// Auxiliary function for bindings in Receives, New, & Match
  // Bind
  rule LV+( Y:NamePats <-  _:Name    ) => FV+(Y)
  rule LV+( Y:Names    <-  _:Name    ) => FV+(Y)
  rule LV+(            <-  _:Name    ) => .Set
  rule LV+( Y:NamePats <=  _:Name    ) => FV+(Y)
  rule LV+( Y:Names    <=  _:Name    ) => FV+(Y)
  rule LV+(            <=  _:Name    ) => .Set
  rule LV+( Y:NamePats <<- _:Name    ) => FV+(Y)
  rule LV+( Y:Names    <<- _:Name    ) => FV+(Y)
  rule LV+(            <<- _:Name    ) => .Set
  rule LV+( Y:NamePats <-  _:NamePat ) => FV+(Y)
  rule LV+( Y:Names    <-  _:NamePat ) => FV+(Y)
  rule LV+(            <-  _:NamePat ) => .Set
  rule LV+( Y:NamePats <=  _:NamePat ) => FV+(Y)
  rule LV+( Y:Names    <=  _:NamePat ) => FV+(Y)
  rule LV+(            <=  _:NamePat ) => .Set
  rule LV+( Y:NamePats <<- _:NamePat ) => FV+(Y)
  rule LV+( Y:Names    <<- _:NamePat ) => FV+(Y)
  rule LV+(            <<- _:NamePat ) => .Set
  // Binds
  rule LV+( A:Lbind    ; B:Lbind     ) => LV+(A) LV+(B)
  rule LV+( A:Lbind    ; B:Lbinds    ) => LV+(A) LV+(B)
  rule LV+( A:Pbind    ; B:Pbind     ) => LV+(A) LV+(B)
  rule LV+( A:Pbind    ; B:Pbinds    ) => LV+(A) LV+(B)
  rule LV+( A:Rbind    ; B:Rbind     ) => LV+(A) LV+(B)
  rule LV+( A:Rbind    ; B:Rbinds    ) => LV+(A) LV+(B)
  rule LV+( A:Lbind    ; B:LbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:LbindPat ; B:Lbind     ) => LV+(A) LV+(B)
  rule LV+( A:LbindPat ; B:LbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:Lbind    ; B:LbindPats ) => LV+(A) LV+(B)
  rule LV+( A:LbindPat ; B:Lbinds    ) => LV+(A) LV+(B)
  rule LV+( A:LbindPat ; B:LbindPats ) => LV+(A) LV+(B)
  rule LV+( A:Pbind    ; B:PbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:PbindPat ; B:Pbind     ) => LV+(A) LV+(B)
  rule LV+( A:PbindPat ; B:PbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:Pbind    ; B:PbindPats ) => LV+(A) LV+(B)
  rule LV+( A:PbindPat ; B:Pbinds    ) => LV+(A) LV+(B)
  rule LV+( A:PbindPat ; B:PbindPats ) => LV+(A) LV+(B)
  rule LV+( A:Rbind    ; B:RbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:RbindPat ; B:Rbind     ) => LV+(A) LV+(B)
  rule LV+( A:RbindPat ; B:RbindPat  ) => LV+(A) LV+(B)
  rule LV+( A:Rbind    ; B:RbindPats ) => LV+(A) LV+(B)
  rule LV+( A:RbindPat ; B:Rbinds    ) => LV+(A) LV+(B)
  rule LV+( A:RbindPat ; B:RbindPats ) => LV+(A) LV+(B)

// Variables being listened for by a Receive
  // unguarded
  rule  LV( for( B:Lbind     ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Lbinds    ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Pbind     ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Pbinds    ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Rbind     ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Rbinds    ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Lbind     ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Lbinds    ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Pbind     ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Pbinds    ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Rbind     ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Rbinds    ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:LbindPat  ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:LbindPats ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:PbindPat  ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:PbindPats ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:RbindPat  ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:RbindPats ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:LbindPat  ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:LbindPats ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:PbindPat  ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:PbindPats ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:RbindPat  ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:RbindPats ) { _:ProcPat } ) =>  LV(B)
  rule #LV( for( B:Lbind     ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Lbinds    ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Pbind     ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Pbinds    ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Rbind     ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Rbinds    ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Lbind     ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Lbinds    ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Pbind     ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Pbinds    ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Rbind     ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Rbinds    ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:LbindPat  ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:LbindPats ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:PbindPat  ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:PbindPats ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:RbindPat  ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:RbindPats ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:LbindPat  ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:LbindPats ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:PbindPat  ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:PbindPats ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:RbindPat  ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:RbindPats ) { _:ProcPat } ) => #LV(B)
  // guarded
  rule  LV( for( B:Lbind     _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Lbinds    _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Pbind     _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Pbinds    _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Rbind     _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Rbinds    _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:Lbind     _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Lbinds    _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Pbind     _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Pbinds    _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Rbind     _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:Rbinds    _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:LbindPat  _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:LbindPats _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:PbindPat  _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:PbindPats _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:RbindPat  _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:RbindPats _:Guard ) { _:Proc    } ) =>  LV(B)
  rule  LV( for( B:LbindPat  _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:LbindPats _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:PbindPat  _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:PbindPats _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:RbindPat  _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule  LV( for( B:RbindPats _:Guard ) { _:ProcPat } ) =>  LV(B)
  rule #LV( for( B:Lbind     _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Lbinds    _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Pbind     _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Pbinds    _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Rbind     _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Rbinds    _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:Lbind     _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Lbinds    _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Pbind     _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Pbinds    _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Rbind     _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:Rbinds    _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:LbindPat  _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:LbindPats _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:PbindPat  _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:PbindPats _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:RbindPat  _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:RbindPats _:Guard ) { _:Proc    } ) => #LV(B)
  rule #LV( for( B:LbindPat  _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:LbindPats _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:PbindPat  _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:PbindPats _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:RbindPat  _:Guard ) { _:ProcPat } ) => #LV(B)
  rule #LV( for( B:RbindPats _:Guard ) { _:ProcPat } ) => #LV(B)

// Binds -- variables being listened for
  // single
  rule  LV( Y:NamePats <-  _:Name ) => FV(Y)
  rule  LV( Y:Names    <-  _:Name ) => FV(Y)
  rule  LV(            <-  _:Name ) => .Set
  rule  LV( Y:NamePats <=  _:Name ) => FV(Y)
  rule  LV( Y:Names    <=  _:Name ) => FV(Y)
  rule  LV(            <=  _:Name ) => .Set
  rule  LV( Y:NamePats <<- _:Name ) => FV(Y)
  rule  LV( Y:Names    <<- _:Name ) => FV(Y)
  rule  LV(            <<- _:Name ) => .Set
  rule #LV( Y:NamePats <-  _:Name ) => #FV(Y)
  rule #LV( Y:Names    <-  _:Name ) => #FV(Y)
  rule #LV(            <-  _:Name ) => .Set
  rule #LV( Y:NamePats <=  _:Name ) => #FV(Y)
  rule #LV( Y:Names    <=  _:Name ) => #FV(Y)
  rule #LV(            <=  _:Name ) => .Set
  rule #LV( Y:NamePats <<- _:Name ) => #FV(Y)
  rule #LV( Y:Names    <<- _:Name ) => #FV(Y)
  rule #LV(            <<- _:Name ) => .Set
  // multiple
  rule  LV( A:Lbind ; B:Lbind  ) =>  LV(A)  LV(B)
  rule  LV( A:Lbind ; B:Lbinds ) =>  LV(A)  LV(B)
  rule  LV( A:Pbind ; B:Pbind  ) =>  LV(A)  LV(B)
  rule  LV( A:Pbind ; B:Pbinds ) =>  LV(A)  LV(B)
  rule  LV( A:Rbind ; B:Rbind  ) =>  LV(A)  LV(B)
  rule  LV( A:Rbind ; B:Rbinds ) =>  LV(A)  LV(B)
  rule #LV( A:Lbind ; B:Lbind  ) => #LV(A) #LV(B)
  rule #LV( A:Lbind ; B:Lbinds ) => #LV(A) #LV(B)
  rule #LV( A:Pbind ; B:Pbind  ) => #LV(A) #LV(B)
  rule #LV( A:Pbind ; B:Pbinds ) => #LV(A) #LV(B)
  rule #LV( A:Rbind ; B:Rbind  ) => #LV(A) #LV(B)
  rule #LV( A:Rbind ; B:Rbinds ) => #LV(A) #LV(B)

  rule  LV( A:Lbind    ; B:LbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:LbindPat ; B:Lbind     ) =>  LV(A)  LV(B)
  rule  LV( A:LbindPat ; B:LbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:LbindPat ; B:Lbinds    ) =>  LV(A)  LV(B)
  rule  LV( A:Lbind    ; B:LbindPats ) =>  LV(A)  LV(B)
  rule  LV( A:LbindPat ; B:LbindPats ) =>  LV(A)  LV(B)
  rule  LV( A:Pbind    ; B:PbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:PbindPat ; B:Pbind     ) =>  LV(A)  LV(B)
  rule  LV( A:PbindPat ; B:PbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:PbindPat ; B:Pbinds    ) =>  LV(A)  LV(B)
  rule  LV( A:Pbind    ; B:PbindPats ) =>  LV(A)  LV(B)
  rule  LV( A:PbindPat ; B:PbindPats ) =>  LV(A)  LV(B)
  rule  LV( A:Rbind    ; B:RbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:RbindPat ; B:Rbind     ) =>  LV(A)  LV(B)
  rule  LV( A:RbindPat ; B:RbindPat  ) =>  LV(A)  LV(B)
  rule  LV( A:RbindPat ; B:Rbinds    ) =>  LV(A)  LV(B)
  rule  LV( A:Rbind    ; B:RbindPats ) =>  LV(A)  LV(B)
  rule  LV( A:RbindPat ; B:RbindPats ) =>  LV(A)  LV(B)
  rule #LV( A:Lbind    ; B:LbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:LbindPat ; B:Lbind     ) => #LV(A) #LV(B)
  rule #LV( A:LbindPat ; B:LbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:LbindPat ; B:Lbinds    ) => #LV(A) #LV(B)
  rule #LV( A:Lbind    ; B:LbindPats ) => #LV(A) #LV(B)
  rule #LV( A:LbindPat ; B:LbindPats ) => #LV(A) #LV(B)
  rule #LV( A:Pbind    ; B:PbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:PbindPat ; B:Pbind     ) => #LV(A) #LV(B)
  rule #LV( A:PbindPat ; B:PbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:PbindPat ; B:Pbinds    ) => #LV(A) #LV(B)
  rule #LV( A:Pbind    ; B:PbindPats ) => #LV(A) #LV(B)
  rule #LV( A:PbindPat ; B:PbindPats ) => #LV(A) #LV(B)
  rule #LV( A:Rbind    ; B:RbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:RbindPat ; B:Rbind     ) => #LV(A) #LV(B)
  rule #LV( A:RbindPat ; B:RbindPat  ) => #LV(A) #LV(B)
  rule #LV( A:RbindPat ; B:Rbinds    ) => #LV(A) #LV(B)
  rule #LV( A:Rbind    ; B:RbindPats ) => #LV(A) #LV(B)
  rule #LV( A:RbindPat ; B:RbindPats ) => #LV(A) #LV(B)

//---------------------
//--- Receive Names ---
//---------------------
// Excluded Proc[Pat]
  rule  RN( A:Proc    ) => .Set requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A) orBool isBundle(A))
  rule  RN( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool isRecPat(A) orBool isParPat(A) /*orBool isBundlePat(A)*/)
  rule #RN( A:Proc    ) => .Set requires notBool (isNew(A) orBool isReceive(A) orBool isPar(A) orBool isBundle(A))
  rule #RN( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool isRecPat(A) orBool isParPat(A) /*orBool isBundlePat(A)*/)

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

  // Bind[Pat]s -- TODO: add patterns
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
  rule  RN( _:NamePats <-  X:NamePat ) => SetItem(X : pat)
  rule  RN( _:Names    <-  X:NamePat ) => SetItem(X : pat)
  rule  RN(            <-  X:NamePat ) => SetItem(X : pat)
  rule  RN( _:NamePats <=  X:NamePat ) => SetItem(X : pat)
  rule  RN( _:Names    <=  X:NamePat ) => SetItem(X : pat)
  rule  RN(            <=  X:NamePat ) => SetItem(X : pat)
  rule  RN( _:NamePats <<- X:NamePat ) => SetItem(X : pat)
  rule  RN( _:Names    <<- X:NamePat ) => SetItem(X : pat)
  rule  RN(            <<- X:NamePat ) => SetItem(X : pat)
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
  rule  RN( A:Lbind    ; B:Lbind     ) =>  RN(A)  RN(B)
  rule  RN( A:Lbind    ; B:LbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:LbindPat ; B:Lbind     ) =>  RN(A)  RN(B)
  rule  RN( A:LbindPat ; B:LbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:Lbind    ; B:Lbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:Lbind    ; B:LbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:LbindPat ; B:Lbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:LbindPat ; B:LbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind    ; B:Pbind     ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind    ; B:PbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:PbindPat ; B:Pbind     ) =>  RN(A)  RN(B)
  rule  RN( A:PbindPat ; B:PbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind    ; B:Pbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:Pbind    ; B:PbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:PbindPat ; B:Pbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:PbindPat ; B:PbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind    ; B:Rbind     ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind    ; B:RbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:RbindPat ; B:Rbind     ) =>  RN(A)  RN(B)
  rule  RN( A:RbindPat ; B:RbindPat  ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind    ; B:Rbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:Rbind    ; B:RbindPats ) =>  RN(A)  RN(B)
  rule  RN( A:RbindPat ; B:Rbinds    ) =>  RN(A)  RN(B)
  rule  RN( A:RbindPat ; B:RbindPats ) =>  RN(A)  RN(B)
  rule #RN( A:Lbind    ; B:Lbind     ) => #RN(A) #RN(B)
  rule #RN( A:Lbind    ; B:LbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:LbindPat ; B:Lbind     ) => #RN(A) #RN(B)
  rule #RN( A:LbindPat ; B:LbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:Lbind    ; B:Lbinds    ) => #RN(A) #RN(B)
  rule #RN( A:Lbind    ; B:LbindPats ) => #RN(A) #RN(B)
  rule #RN( A:LbindPat ; B:Lbinds    ) => #RN(A) #RN(B)
  rule #RN( A:LbindPat ; B:LbindPats ) => #RN(A) #RN(B)
  rule #RN( A:Pbind    ; B:Pbind     ) => #RN(A) #RN(B)
  rule #RN( A:Pbind    ; B:PbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:PbindPat ; B:Pbind     ) => #RN(A) #RN(B)
  rule #RN( A:PbindPat ; B:PbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:Pbind    ; B:Pbinds    ) => #RN(A) #RN(B)
  rule #RN( A:Pbind    ; B:PbindPats ) => #RN(A) #RN(B)
  rule #RN( A:PbindPat ; B:Pbinds    ) => #RN(A) #RN(B)
  rule #RN( A:PbindPat ; B:PbindPats ) => #RN(A) #RN(B)
  rule #RN( A:Rbind    ; B:Rbind     ) => #RN(A) #RN(B)
  rule #RN( A:Rbind    ; B:RbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:RbindPat ; B:Rbind     ) => #RN(A) #RN(B)
  rule #RN( A:RbindPat ; B:RbindPat  ) => #RN(A) #RN(B)
  rule #RN( A:Rbind    ; B:Rbinds    ) => #RN(A) #RN(B)
  rule #RN( A:Rbind    ; B:RbindPats ) => #RN(A) #RN(B)
  rule #RN( A:RbindPat ; B:Rbinds    ) => #RN(A) #RN(B)
  rule #RN( A:RbindPat ; B:RbindPats ) => #RN(A) #RN(B)

  // Par[Pat] -- receive variables in each Proc
  rule  RN( A:Proc | B:Proc ) =>  RN(A)  RN(B) requires notBool isPar(A)
  rule #RN( A:Proc | B:Proc ) => #RN(A) #RN(B) requires notBool isPar(A)

// TODO: New[Pat]

//-------------------------
//--- Receive Variables ---
//-------------------------
// Auxiliary function for receive variables
  // Excluded Proc[Pat]
  rule RV+( A:Proc    ) => .Set requires notBool    (isNew(A) orBool isReceive(A) orBool    isPar(A) orBool isBundle(A))
  rule RV+( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool  isRecPat(A) orBool isParPat(A))

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
  rule RV+( A:Lbind    ; B:Lbind     ) => RV+(A) RV+(B)
  rule RV+( A:Lbind    ; B:LbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:LbindPat ; B:Lbind     ) => RV+(A) RV+(B)
  rule RV+( A:LbindPat ; B:LbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:Lbind    ; B:LbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Lbind    ; B:Lbinds    ) => RV+(A) RV+(B)
  rule RV+( A:LbindPat ; B:Lbinds    ) => RV+(A) RV+(B)
  rule RV+( A:LbindPat ; B:LbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Pbind    ; B:Pbind     ) => RV+(A) RV+(B)
  rule RV+( A:Pbind    ; B:PbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:PbindPat ; B:Pbind     ) => RV+(A) RV+(B)
  rule RV+( A:PbindPat ; B:PbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:Pbind    ; B:PbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Pbind    ; B:Pbinds    ) => RV+(A) RV+(B)
  rule RV+( A:PbindPat ; B:Pbinds    ) => RV+(A) RV+(B)
  rule RV+( A:PbindPat ; B:PbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Rbind    ; B:Rbind     ) => RV+(A) RV+(B)
  rule RV+( A:Rbind    ; B:RbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:RbindPat ; B:Rbind     ) => RV+(A) RV+(B)
  rule RV+( A:RbindPat ; B:RbindPat  ) => RV+(A) RV+(B)
  rule RV+( A:Rbind    ; B:RbindPats ) => RV+(A) RV+(B)
  rule RV+( A:Rbind    ; B:Rbinds    ) => RV+(A) RV+(B)
  rule RV+( A:RbindPat ; B:Rbinds    ) => RV+(A) RV+(B)
  rule RV+( A:RbindPat ; B:RbindPats ) => RV+(A) RV+(B)

  // Par[Pat] -- receive variables in each Proc
  rule RV+( A:Proc    | B:Proc    ) => RV+(A) RV+(B) requires notBool isPar(A)
  rule RV+( A:Proc    | B:ProcPat ) => RV+(A) RV+(B) requires notBool isPar(A)
  rule RV+( A:ProcPat | B:Proc    ) => RV+(A) RV+(B) requires notBool isParPat(A)
  rule RV+( A:ProcPat | B:ProcPat ) => RV+(A) RV+(B) requires notBool isParPat(A)

  // TODO: New[Pat]


// Excluded Proc
  rule  RV( A:Proc    ) => .Set requires notBool    (isNew(A) orBool isReceive(A) orBool    isPar(A) orBool isBundle(A))
  rule  RV( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool  isRecPat(A) orBool isParPat(A))
  rule #RV( A:Proc    ) => .Set requires notBool    (isNew(A) orBool isReceive(A) orBool    isPar(A) orBool isBundle(A))
  rule #RV( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool  isRecPat(A) orBool isParPat(A))

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
  // Bind[Pat]
  rule  RV( _:NamePats <-  X:Name    ) =>  FV(X)
  rule  RV( _:Names    <-  X:Name    ) =>  FV(X)
  rule  RV(            <-  X:Name    ) =>  FV(X)
  rule  RV( _:NamePats <<- X:Name    ) =>  FV(X)
  rule  RV( _:Names    <<- X:Name    ) =>  FV(X)
  rule  RV(            <<- X:Name    ) =>  FV(X)
  rule  RV( _:NamePats <=  X:Name    ) =>  FV(X)
  rule  RV( _:Names    <=  X:Name    ) =>  FV(X)
  rule  RV(            <=  X:Name    ) =>  FV(X)
  rule  RV( _:NamePats <-  X:NamePat ) =>  FV(X)
  rule  RV( _:Names    <-  X:NamePat ) =>  FV(X)
  rule  RV(            <-  X:NamePat ) =>  FV(X)
  rule  RV( _:NamePats <<- X:NamePat ) =>  FV(X)
  rule  RV( _:Names    <<- X:NamePat ) =>  FV(X)
  rule  RV(            <<- X:NamePat ) =>  FV(X)
  rule  RV( _:NamePats <=  X:NamePat ) =>  FV(X)
  rule  RV( _:Names    <=  X:NamePat ) =>  FV(X)
  rule  RV(            <=  X:NamePat ) =>  FV(X)
  rule #RV( _:NamePats <-  X:Name    ) => #FV(X)
  rule #RV( _:Names    <-  X:Name    ) => #FV(X)
  rule #RV(            <-  X:Name    ) => #FV(X)
  rule #RV( _:NamePats <<- X:Name    ) => #FV(X)
  rule #RV( _:Names    <<- X:Name    ) => #FV(X)
  rule #RV(            <<- X:Name    ) => #FV(X)
  rule #RV( _:NamePats <=  X:Name    ) => #FV(X)
  rule #RV( _:Names    <=  X:Name    ) => #FV(X)
  rule #RV(            <=  X:Name    ) => #FV(X)
  rule #RV( _:NamePats <-  X:NamePat ) => #FV(X)
  rule #RV( _:Names    <-  X:NamePat ) => #FV(X)
  rule #RV(            <-  X:NamePat ) => #FV(X)
  rule #RV( _:NamePats <<- X:NamePat ) => #FV(X)
  rule #RV( _:Names    <<- X:NamePat ) => #FV(X)
  rule #RV(            <<- X:NamePat ) => #FV(X)
  rule #RV( _:NamePats <=  X:NamePat ) => #FV(X)
  rule #RV( _:Names    <=  X:NamePat ) => #FV(X)
  rule #RV(            <=  X:NamePat ) => #FV(X)
  // Bind[Pat]s
  rule  RV( A:Lbind    ; B:Lbind     ) =>  RV(A)  RV(B)
  rule  RV( A:LbindPat ; B:Lbind     ) =>  RV(A)  RV(B)
  rule  RV( A:Lbind    ; B:LbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:LbindPat ; B:LbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:Lbind    ; B:Lbinds    ) =>  RV(A)  RV(B)
  rule  RV( A:Lbind    ; B:LbindPats ) =>  RV(A)  RV(B)
  rule  RV( A:LbindPat ; B:Lbinds    ) =>  RV(A)  RV(B)
  rule  RV( A:LbindPat ; B:LbindPats ) =>  RV(A)  RV(B)
  rule  RV( A:Pbind    ; B:Pbind     ) =>  RV(A)  RV(B)
  rule  RV( A:PbindPat ; B:Pbind     ) =>  RV(A)  RV(B)
  rule  RV( A:Pbind    ; B:PbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:PbindPat ; B:PbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:Pbind    ; B:Pbinds    ) =>  RV(A)  RV(B)
  rule  RV( A:Pbind    ; B:PbindPats ) =>  RV(A)  RV(B)
  rule  RV( A:PbindPat ; B:Pbinds    ) =>  RV(A)  RV(B)
  rule  RV( A:PbindPat ; B:PbindPats ) =>  RV(A)  RV(B)
  rule  RV( A:Rbind    ; B:Rbind     ) =>  RV(A)  RV(B)
  rule  RV( A:RbindPat ; B:Rbind     ) =>  RV(A)  RV(B)
  rule  RV( A:Rbind    ; B:RbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:RbindPat ; B:RbindPat  ) =>  RV(A)  RV(B)
  rule  RV( A:Rbind    ; B:Rbinds    ) =>  RV(A)  RV(B)
  rule  RV( A:Rbind    ; B:RbindPats ) =>  RV(A)  RV(B)
  rule  RV( A:RbindPat ; B:Rbinds    ) =>  RV(A)  RV(B)
  rule  RV( A:RbindPat ; B:RbindPats ) =>  RV(A)  RV(B)
  rule #RV( A:Lbind    ; B:Lbind     ) => #RV(A) #RV(B)
  rule #RV( A:LbindPat ; B:Lbind     ) => #RV(A) #RV(B)
  rule #RV( A:Lbind    ; B:LbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:LbindPat ; B:LbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:Lbind    ; B:Lbinds    ) => #RV(A) #RV(B)
  rule #RV( A:Lbind    ; B:LbindPats ) => #RV(A) #RV(B)
  rule #RV( A:LbindPat ; B:Lbinds    ) => #RV(A) #RV(B)
  rule #RV( A:LbindPat ; B:LbindPats ) => #RV(A) #RV(B)
  rule #RV( A:Pbind    ; B:Pbind     ) => #RV(A) #RV(B)
  rule #RV( A:PbindPat ; B:Pbind     ) => #RV(A) #RV(B)
  rule #RV( A:Pbind    ; B:PbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:PbindPat ; B:PbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:Pbind    ; B:Pbinds    ) => #RV(A) #RV(B)
  rule #RV( A:Pbind    ; B:PbindPats ) => #RV(A) #RV(B)
  rule #RV( A:PbindPat ; B:Pbinds    ) => #RV(A) #RV(B)
  rule #RV( A:PbindPat ; B:PbindPats ) => #RV(A) #RV(B)
  rule #RV( A:Rbind    ; B:Rbind     ) => #RV(A) #RV(B)
  rule #RV( A:RbindPat ; B:Rbind     ) => #RV(A) #RV(B)
  rule #RV( A:Rbind    ; B:RbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:RbindPat ; B:RbindPat  ) => #RV(A) #RV(B)
  rule #RV( A:Rbind    ; B:Rbinds    ) => #RV(A) #RV(B)
  rule #RV( A:Rbind    ; B:RbindPats ) => #RV(A) #RV(B)
  rule #RV( A:RbindPat ; B:Rbinds    ) => #RV(A) #RV(B)
  rule #RV( A:RbindPat ; B:RbindPats ) => #RV(A) #RV(B)

// Par[Pat] -- receive variables in each Proc[Pat]
  rule  RV( A:Proc    | B:Proc    ) =>  RV(A)  RV(B) requires notBool isPar(A)
  rule  RV( A:Proc    | B:ProcPat ) =>  RV(A)  RV(B) requires notBool isPar(A)
  rule  RV( A:ProcPat | B:Proc    ) =>  RV(A)  RV(B) requires notBool isParPat(A)
  rule  RV( A:ProcPat | B:ProcPat ) =>  RV(A)  RV(B) requires notBool isParPat(A)
  rule #RV( A:Proc    | B:Proc    ) => #RV(A) #RV(B) requires notBool isPar(A)
  rule #RV( A:Proc    | B:ProcPat ) => #RV(A) #RV(B) requires notBool isPar(A)
  rule #RV( A:ProcPat | B:Proc    ) => #RV(A) #RV(B) requires notBool isParPat(A)
  rule #RV( A:ProcPat | B:ProcPat ) => #RV(A) #RV(B) requires notBool isParPat(A)

// New[Pat]
  rule  RV( new _:Names in { A:Proc    } ) =>  RV(A) //  RV(subNew(A)) ???
  rule  RV( new _:Names in { A:ProcPat } ) =>  RV(A) //  RV(subNew(A)) ???
  rule #RV( new _:Names in { A:Proc    } ) => #RV(A) // #RV(subNew(A)) ???
  rule #RV( new _:Names in { A:ProcPat } ) => #RV(A) // #RV(subNew(A)) ???


// Send Names

//----------------------
//--- Send Variables ---
//----------------------
// Auxiliary function for bound variables
  // Excluded Proc[Pat]
  rule SV+( A:Proc    ) => .Set requires notBool    (isNew(A) orBool    isSend(A) orBool    isPar(A))
  rule SV+( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool isSendPat(A) orBool isParPat(A))

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
  rule  SV( A:Proc    ) => .Set requires notBool    (isNew(A) orBool    isSend(A) orBool    isPar(A))
  rule  SV( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool isSendPat(A) orBool isParPat(A))
  rule #SV( A:Proc    ) => .Set requires notBool    (isNew(A) orBool    isSend(A) orBool    isPar(A))
  rule #SV( A:ProcPat ) => .Set requires notBool (isNewPat(A) orBool isSendPat(A) orBool isParPat(A))

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
  rule  SV( new _:Names in { A:Proc    } ) =>  SV(A) //  SV(subNew(A)) ???
  rule  SV( new _:Names in { A:ProcPat } ) =>  SV(A) //  SV(subNew(A)) ???
  rule #SV( new _:Names in { A:Proc    } ) => #SV(A) // #SV(subNew(A)) ???
  rule #SV( new _:Names in { A:ProcPat } ) => #SV(A) // #SV(subNew(A)) ???

//--------------------------
//--- Declared Variables --- TODO: add patterns
//--------------------------
  // #DV: New[Pat] -> Set(Var)
  rule #DV( new A:Var                     in { _:Proc    } ) => SetItem(A) // Vn(A)
  rule #DV( new A:Var                     in { _:ProcPat } ) => SetItem(A) // Vn(A)
  rule #DV( new A:Var , B:Names           in { _:Proc    } ) => SetItem(A) #DV(new B in {Nil})
  rule #DV( new A:Var , B:Names           in { _:ProcPat } ) => SetItem(A) #DV(new B in {\_ })
  rule #DV( new A:Var ( _:Uri )           in { _:Proc    } ) => SetItem(A) // Vn(A)
  rule #DV( new A:Var ( _:Uri )           in { _:ProcPat } ) => SetItem(A) // Vn(A)
  rule #DV( new A:Var ( _:Uri ) , B:Names in { _:Proc    } ) => SetItem(A) #DV(new B in {Nil})
  rule #DV( new A:Var ( _:Uri ) , B:Names in { _:ProcPat } ) => SetItem(A) #DV(new B in {\_ })
//  rule #DV( A:Proc | B:Proc ) => #DV(A) #DV(B) requires notBool isPar(A)
  rule #DV( A:Proc  ) => .Set requires notBool isNew(A) // (isPar(A) orBool isNew(A))

  // #DV: Names -> Set(Var)
  rule #DV( A:Names ) => #DV(new A in {Nil})

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
  rule #NV(  SetItem(  A:Var : name ) S:Set ) => SetItem(A) #NV(S) // includes name kind Vars // TODO: include kind?
  rule #NV(  SetItem(  _:Var : proc ) S:Set ) => #NV(S) // filters out proc kind Vars

  rule #FPV(  .Set     ) => .Set
  rule #FPV( P:Proc    ) => #PV(FV(P))
  rule #FPV( P:ProcPat ) => #PV(FV(P))

  rule #PV(  .Set     ) => .Set
  rule #PV( P:Proc    ) => #PV(V(P))
  rule #PV( P:ProcPat ) => #PV(V(P))
  rule #PV(  SetItem( A:Var : proc ) S:Set ) => SetItem(A) #PV(S) // includes proc kind Vars // TODO: include kind?
  rule #PV(  SetItem( _:Var : name ) S:Set ) => #PV(S) // filters out name kind Vars
  rule #PV(  SetItem( A:Var : proc ) S:Set ) => SetItem(A) #PV(S) // includes proc kind Vars // TODO: include kind?
  rule #PV(  SetItem( _:Var : name ) S:Set ) => #PV(S) // filters out name kind Vars

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
  rule     #VarContext( A:Proc ) => intersectSet( #NV(A), #PV(A))
  rule #FreeVarContext( A:Proc ) => intersectSet(#FNV(A),#FPV(A))

endmodule