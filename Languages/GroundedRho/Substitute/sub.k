// Rholang Substitution
/*
TODO:
 - add remaining features - Methods, Bundles
 - sub for Uri for #match
 - prove #sub(_;_;_) is safe substitution (capture free)
 - precondition #sub(A;B;C) with the check: intersectSet(#FV(B),#FV(C)) =/=K .Set
*/
/*
  This substitution function is needed to make distinct the notions of name variables and process variables.
  The built-in substitution does not make this distinction.
  E.g. we want the substitution (x!(\x))[@Nil / x] to result in @Nil!(\x) since we only substitute for x:Var, NOT \x:ProcVar
  the definitions of Var ::= Var and ProcVar ::= "\\" Var don't allow for this with the the builtin substitution
*/

require "domains.k"
require "../AuxFun/auxfun.k"
require "../Names_Variables/namevar.k"
require "../grho.k"

module SUB-SYNTAX
  import GRHO-SYNTAX
  import DOMAINS

// subs into Procs
  syntax       Proc ::= "#sub(" Procs    ";" Procs    ";" Proc  ")" [function, poly(0,3)]
                      | "#sub(" Procs    ";" ProcPats ";" Proc  ")" [function, poly(0,3)]
                      | "#sub(" ProcPats ";" Procs    ";" Proc  ")" [function, poly(0,3)]
                      | "#sub(" ProcPats ";" ProcPats ";" Proc  ")" [function, poly(0,3)]
                      | "#sub(" Names    ";" Names    ";" Proc  ")" [function, poly(0,3)]
                      | "#sub(" Names    ";" NamePats ";" Proc  ")" [function, poly(0,3)]
                      | "#sub(" NamePats ";" Names    ";" Proc  ")" [function, poly(0,3)]
                      | "#sub(" NamePats ";" NamePats ";" Proc  ")" [function, poly(0,3)]
  syntax      Procs ::= "#sub(" Procs    ";" Procs    ";" Procs ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" Procs ")" [function]
                      | "#sub(" ProcPats ";" Procs    ";" Procs ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" Procs ")" [function]
                      | "#sub(" Names    ";" Names    ";" Procs ")" [function]
                      | "#sub(" Names    ";" NamePats ";" Procs ")" [function]
                      | "#sub(" NamePats ";" Names    ";" Procs ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" Procs ")" [function]
// Receive subs
  // if substitution variables are not included in listening variables -- #subRec
  syntax       Proc ::= "#subRec(" Procs    ";" Procs    ";" Proc ")" [function]
                      | "#subRec(" Procs    ";" ProcPats ";" Proc ")" [function]
                      | "#subRec(" ProcPats ";" Procs    ";" Proc ")" [function]
                      | "#subRec(" ProcPats ";" ProcPats ";" Proc ")" [function]
                      | "#subRec(" Names    ";" Names    ";" Proc ")" [function]
                      | "#subRec(" Names    ";" NamePats ";" Proc ")" [function]
                      | "#subRec(" NamePats ";" Names    ";" Proc ")" [function]
                      | "#subRec(" NamePats ";" NamePats ";" Proc ")" [function]
  // if substitution variables are included in listening variables -- #subChan
  syntax       Proc ::= "#subChan(" Procs    ";" Procs    ";" Proc ")" [function]
                      | "#subChan(" Procs    ";" ProcPats ";" Proc ")" [function]
                      | "#subChan(" ProcPats ";" ProcPats ";" Proc ")" [function]
                      | "#subChan(" Names    ";" Names    ";" Proc ")" [function]
                      | "#subChan(" Names    ";" NamePats ";" Proc ")" [function]
                      | "#subChan(" NamePats ";" NamePats ";" Proc ")" [function]
  // substituting into a Receive Bind
  syntax      Lbind ::= "#subBind(" Procs    ";" Procs    ";;" Lbind  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Lbind  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Lbind  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Lbind  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Lbind  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Lbind  ")" [function]
  syntax     Lbinds ::= "#subBind(" Procs    ";" Procs    ";;" Lbinds ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Lbinds ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Lbinds ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Lbinds ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Lbinds ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Lbinds ")" [function]
  syntax      Pbind ::= "#subBind(" Procs    ";" Procs    ";;" Pbind  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Pbind  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Pbind  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Pbind  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Pbind  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Pbind  ")" [function]
  syntax     Pbinds ::= "#subBind(" Procs    ";" Procs    ";;" Pbinds ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Pbinds ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Pbinds ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Pbinds ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Pbinds ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Pbinds ")" [function]
  syntax      Rbind ::= "#subBind(" Procs    ";" Procs    ";;" Rbind  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Rbind  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Rbind  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Rbind  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Rbind  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Rbind  ")" [function]
  syntax     Rbinds ::= "#subBind(" Procs    ";" Procs    ";;" Rbinds ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Rbinds ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Rbinds ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Rbinds ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Rbinds ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Rbinds ")" [function]

  // New substitution
  syntax        New ::= "#subNew(" Procs    ";" Procs    ";" New ")" [function]
                      | "#subNew(" Procs    ";" ProcPats ";" New ")" [function]
                      | "#subNew(" ProcPats ";" ProcPats ";" New ")" [function]
                      | "#subNew(" Names    ";" Names    ";" New ")" [function]
                      | "#subNew(" Names    ";" NamePats ";" New ")" [function]
                      | "#subNew(" NamePats ";" NamePats ";" New ")" [function]

  syntax        New ::= "#subNew+(" Var ";" Var ";" New ")" [function]

  syntax        Var ::= "#subVar(" Var ";" Var ";" Var      ")" [function]
  syntax     VarDec ::= "#subDec(" Var ";" Var ";" VarDec   ")" [function]
  syntax    VarDecs ::= "#subDec(" Var ";" Var ";" VarDecs  ")" [function]
  syntax       Proc ::= "#subNew(" Int ";" VarDecs ";" Proc ")" [function]

  // Match substitution
  syntax  MatchCase ::= "#subMatch(" Procs    ";" Procs    ";" MatchCase  ")" [function]
                      | "#subMatch(" Procs    ";" ProcPats ";" MatchCase  ")" [function]
                      | "#subMatch(" ProcPats ";" ProcPats ";" MatchCase  ")" [function]
                      | "#subMatch(" Names    ";" Names    ";" MatchCase  ")" [function]
                      | "#subMatch(" Names    ";" NamePats ";" MatchCase  ")" [function]
                      | "#subMatch(" NamePats ";" NamePats ";" MatchCase  ")" [function]
  syntax MatchCases ::= "#subMatch(" Procs    ";" Procs    ";" MatchCases ")" [function]
                      | "#subMatch(" Procs    ";" ProcPats ";" MatchCases ")" [function]
                      | "#subMatch(" ProcPats ";" ProcPats ";" MatchCases ")" [function]
                      | "#subMatch(" Names    ";" Names    ";" MatchCases ")" [function]
                      | "#subMatch(" Names    ";" NamePats ";" MatchCases ")" [function]
                      | "#subMatch(" NamePats ";" NamePats ";" MatchCases ")" [function]
  syntax   MCasePat ::= "#subMatch(" Procs    ";" Procs    ";" MCasePat   ")" [function]
                      | "#subMatch(" Procs    ";" ProcPats ";" MCasePat   ")" [function]
                      | "#subMatch(" ProcPats ";" ProcPats ";" MCasePat   ")" [function]
                      | "#subMatch(" Names    ";" Names    ";" MCasePat   ")" [function]
                      | "#subMatch(" Names    ";" NamePats ";" MCasePat   ")" [function]
                      | "#subMatch(" NamePats ";" NamePats ";" MCasePat   ")" [function]
  syntax  MCasePats ::= "#subMatch(" Procs    ";" Procs    ";" MCasePats  ")" [function]
                      | "#subMatch(" Procs    ";" ProcPats ";" MCasePats  ")" [function]
                      | "#subMatch(" ProcPats ";" ProcPats ";" MCasePats  ")" [function]
                      | "#subMatch(" Names    ";" Names    ";" MCasePats  ")" [function]
                      | "#subMatch(" Names    ";" NamePats ";" MCasePats  ")" [function]
                      | "#subMatch(" NamePats ";" NamePats ";" MCasePats  ")" [function]

// Select substitution
  syntax     Branch ::= "#subBranch(" Proc     ";" Proc     ";" Branch     ")" [function]
                      | "#subBranch(" Procs    ";" ProcPats ";" Branch     ")" [function]
                      | "#subBranch(" ProcPats ";" ProcPats ";" Branch     ")" [function]
                      | "#subBranch(" Names    ";" Names    ";" Branch     ")" [function]
                      | "#subBranch(" Names    ";" NamePats ";" Branch     ")" [function]
                      | "#subBranch(" NamePats ";" NamePats ";" Branch     ")" [function]
  syntax   Branches ::= "#subBranch(" Proc     ";" Proc     ";" Branches   ")" [function]
                      | "#subBranch(" Procs    ";" ProcPats ";" Branches   ")" [function]
                      | "#subBranch(" ProcPats ";" ProcPats ";" Branches   ")" [function]
                      | "#subBranch(" Names    ";" Names    ";" Branches   ")" [function]
                      | "#subBranch(" Names    ";" NamePats ";" Branches   ")" [function]
                      | "#subBranch(" NamePats ";" NamePats ";" Branches   ")" [function]
  syntax  BranchPat ::= "#subBranch(" Proc     ";" Proc     ";" BranchPat  ")" [function]
                      | "#subBranch(" Procs    ";" ProcPats ";" BranchPat  ")" [function]
                      | "#subBranch(" ProcPats ";" ProcPats ";" BranchPat  ")" [function]
                      | "#subBranch(" Names    ";" Names    ";" BranchPat  ")" [function]
                      | "#subBranch(" Names    ";" NamePats ";" BranchPat  ")" [function]
                      | "#subBranch(" NamePats ";" NamePats ";" BranchPat  ")" [function]
  syntax BranchPats ::= "#subBranch(" Proc     ";" Proc     ";" BranchPats ")" [function]
                      | "#subBranch(" Procs    ";" ProcPats ";" BranchPats ")" [function]
                      | "#subBranch(" ProcPats ";" ProcPats ";" BranchPats ")" [function]
                      | "#subBranch(" Names    ";" Names    ";" BranchPats ")" [function]
                      | "#subBranch(" Names    ";" NamePats ";" BranchPats ")" [function]
                      | "#subBranch(" NamePats ";" NamePats ";" BranchPats ")" [function]

// Method substitution
  syntax
      MethodAndArgs ::= "#subMethod(" Proc     ";" Proc     ";" MethodAndArgs ")" [function]
                      | "#subMethod(" Procs    ";" ProcPats ";" MethodAndArgs ")" [function]
                      | "#subMethod(" ProcPats ";" ProcPats ";" MethodAndArgs ")" [function]
                      | "#subMethod(" Names    ";" Names    ";" MethodAndArgs ")" [function]
                      | "#subMethod(" Names    ";" NamePats ";" MethodAndArgs ")" [function]
                      | "#subMethod(" NamePats ";" NamePats ";" MethodAndArgs ")" [function]

// RhoMap/MapPat
  // substitution for key-values
  syntax  RhoKVPair ::= "#subKV(" Procs    ";" Procs    ";" RhoKVPair  ")" [function]
                      | "#subKV(" Procs    ";" ProcPats ";" RhoKVPair  ")" [function]
                      | "#subKV(" ProcPats ";" ProcPats ";" RhoKVPair  ")" [function]
                      | "#subKV(" Names    ";" Names    ";" RhoKVPair  ")" [function]
                      | "#subKV(" Names    ";" NamePats ";" RhoKVPair  ")" [function]
                      | "#subKV(" NamePats ";" NamePats ";" RhoKVPair  ")" [function]
  syntax RhoKVPairs ::= "#subKV(" Procs    ";" Procs    ";" RhoKVPairs ")" [function]
                      | "#subKV(" Procs    ";" ProcPats ";" RhoKVPairs ")" [function]
                      | "#subKV(" ProcPats ";" ProcPats ";" RhoKVPairs ")" [function]
                      | "#subKV(" Names    ";" Names    ";" RhoKVPairs ")" [function]
                      | "#subKV(" Names    ";" NamePats ";" RhoKVPairs ")" [function]
                      | "#subKV(" NamePats ";" NamePats ";" RhoKVPairs ")" [function]
  syntax   RhoKVPat ::= "#subKV(" Procs    ";" Procs    ";" RhoKVPat   ")" [function]
                      | "#subKV(" Procs    ";" ProcPats ";" RhoKVPat   ")" [function]
                      | "#subKV(" ProcPats ";" ProcPats ";" RhoKVPat   ")" [function]
                      | "#subKV(" Names    ";" Names    ";" RhoKVPat   ")" [function]
                      | "#subKV(" Names    ";" NamePats ";" RhoKVPat   ")" [function]
                      | "#subKV(" NamePats ";" NamePats ";" RhoKVPat   ")" [function]
  syntax  RhoKVPats ::= "#subKV(" Procs    ";" Procs    ";" RhoKVPats  ")" [function]
                      | "#subKV(" Procs    ";" ProcPats ";" RhoKVPats  ")" [function]
                      | "#subKV(" ProcPats ";" ProcPats ";" RhoKVPats  ")" [function]
                      | "#subKV(" Names    ";" Names    ";" RhoKVPats  ")" [function]
                      | "#subKV(" Names    ";" NamePats ";" RhoKVPats  ")" [function]
                      | "#subKV(" NamePats ";" NamePats ";" RhoKVPats  ")" [function]

  syntax       Proc ::= "#sub(" RhoKVPairs ";" RhoKVPairs ";" Proc    ")" [function, poly(0,3)]
                      | "#sub(" RhoKVPairs ";" RhoKVPats  ";" Proc    ")" [function, poly(0,3)]
                      | "#sub(" RhoKVPats  ";" RhoKVPats  ";" Proc    ")" [function, poly(0,3)]
  syntax    ProcPat ::= "#sub(" RhoKVPairs ";" RhoKVPairs ";" ProcPat ")" [function]
                      | "#sub(" RhoKVPairs ";" RhoKVPats  ";" ProcPat ")" [function]
                      | "#sub(" RhoKVPats  ";" RhoKVPats  ";" ProcPat ")" [function]
  syntax       Name ::= "#sub(" RhoKVPairs ";" RhoKVPairs ";" Name    ")" [function]
                      | "#sub(" RhoKVPairs ";" RhoKVPats  ";" Name    ")" [function]
                      | "#sub(" RhoKVPats  ";" RhoKVPats  ";" Name    ")" [function]
  syntax    NamePat ::= "#sub(" RhoKVPairs ";" RhoKVPairs ";" NamePat ")" [function]
                      | "#sub(" RhoKVPairs ";" RhoKVPats  ";" NamePat ")" [function]
                      | "#sub(" RhoKVPats  ";" RhoKVPats  ";" NamePat ")" [function]

// String expressions
  syntax InterpMaps ::= "#sub(" Procs    ";" Procs    ";" InterpMaps ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" InterpMaps ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" InterpMaps ")" [function]
                      | "#sub(" Names    ";" Names    ";" InterpMaps ")" [function]
                      | "#sub(" Names    ";" NamePats ";" InterpMaps ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" InterpMaps ")" [function]

// Name substitution
  syntax       Name ::= "#sub(" Procs    ";" Procs    ";" Name  ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" Name  ")" [function]
                      | "#sub(" ProcPats ";" Procs    ";" Name  ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" Name  ")" [function]
                      | "#sub(" Names    ";" Names    ";" Name  ")" [function]
                      | "#sub(" Names    ";" NamePats ";" Name  ")" [function]
                      | "#sub(" NamePats ";" Names    ";" Name  ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" Name  ")" [function]
  syntax      Names ::= "#sub(" Procs    ";" Procs    ";" Names ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" Names ")" [function]
                      | "#sub(" ProcPats ";" Procs    ";" Names ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" Names ")" [function]
                      | "#sub(" Names    ";" Names    ";" Names ")" [function]
                      | "#sub(" Names    ";" NamePats ";" Names ")" [function]
                      | "#sub(" NamePats ";" Names    ";" Names ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" Names ")" [function]

// Process Pattern substitution
  syntax    ProcPat ::= "#sub(" Procs    ";" Procs    ";" ProcPat ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" ProcPat ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" ProcPat ")" [function]
                      | "#sub(" Names    ";" Names    ";" ProcPat ")" [function]
                      | "#sub(" Names    ";" NamePats ";" ProcPat ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" ProcPat ")" [function]

  // Receive pattern
  syntax    ProcPat ::=  "#subRec(" Procs    ";" Procs    ";" ProcPat ")" [function]
                      |  "#subRec(" Procs    ";" ProcPats ";" ProcPat ")" [function]
                      |  "#subRec(" ProcPats ";" ProcPats ";" ProcPat ")" [function]
                      |  "#subRec(" Names    ";" Names    ";" ProcPat ")" [function]
                      |  "#subRec(" Names    ";" NamePats ";" ProcPat ")" [function]
                      |  "#subRec(" NamePats ";" NamePats ";" ProcPat ")" [function]
                      | "#subChan(" Procs    ";" Procs    ";" ProcPat ")" [function]
                      | "#subChan(" Procs    ";" ProcPats ";" ProcPat ")" [function]
                      | "#subChan(" ProcPats ";" ProcPats ";" ProcPat ")" [function]
                      | "#subChan(" Names    ";" Names    ";" ProcPat ")" [function]
                      | "#subChan(" Names    ";" NamePats ";" ProcPat ")" [function]
                      | "#subChan(" NamePats ";" NamePats ";" ProcPat ")" [function]

  syntax   LbindPat ::= "#subBind(" Procs    ";" Procs    ";;" LbindPat  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" LbindPat  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" LbindPat  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" LbindPat  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" LbindPat  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" LbindPat  ")" [function]
  syntax  LbindPats ::= "#subBind(" Procs    ";" Procs    ";;" LbindPats ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" LbindPats ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" LbindPats ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" LbindPats ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" LbindPats ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" LbindPats ")" [function]
  syntax   PbindPat ::= "#subBind(" Procs    ";" Procs    ";;" PbindPat  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" PbindPat  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" PbindPat  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" PbindPat  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" PbindPat  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" PbindPat  ")" [function]
  syntax  PbindPats ::= "#subBind(" Procs    ";" Procs    ";;" PbindPats ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" PbindPats ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" PbindPats ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" PbindPats ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" PbindPats ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" PbindPats ")" [function]
  syntax   RbindPat ::= "#subBind(" Procs    ";" Procs    ";;" RbindPat  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" RbindPat  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" RbindPat  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" RbindPat  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" RbindPat  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" RbindPat  ")" [function]
  syntax  RbindPats ::= "#subBind(" Procs    ";" Procs    ";;" RbindPats ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" RbindPats ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" RbindPats ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" RbindPats ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" RbindPats ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" RbindPats ")" [function]

  // New pattern
  syntax     NewPat ::= "#subNew(" Procs    ";" Procs    ";" NewPat ")" [function]
                      | "#subNew(" Procs    ";" ProcPats ";" NewPat ")" [function]
                      | "#subNew(" ProcPats ";" ProcPats ";" NewPat ")" [function]
                      | "#subNew(" Names    ";" Names    ";" NewPat ")" [function]
                      | "#subNew(" Names    ";" NamePats ";" NewPat ")" [function]
                      | "#subNew(" NamePats ";" NamePats ";" NewPat ")" [function]

  syntax    ProcPat ::= "#subNew(" Int ";" VarDecs ";" ProcPat ")" [function]

  // Match pattern
  syntax   MatchPat ::= "#subMatch(" Procs    ";" Procs    ";" MatchPat ")" [function]
                      | "#subMatch(" Procs    ";" ProcPats ";" MatchPat ")" [function]
                      | "#subMatch(" ProcPats ";" ProcPats ";" MatchPat ")" [function]
                      | "#subMatch(" Names    ";" Names    ";" MatchPat ")" [function]
                      | "#subMatch(" Names    ";" NamePats ";" MatchPat ")" [function]
                      | "#subMatch(" NamePats ";" NamePats ";" MatchPat ")" [function]

  syntax   ProcPats ::= "#sub(" Procs    ";" Procs    ";" ProcPats ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" ProcPats ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" ProcPats ")" [function]
                      | "#sub(" Names    ";" Names    ";" ProcPats ")" [function]
                      | "#sub(" Names    ";" NamePats ";" ProcPats ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" ProcPats ")" [function]

// Name Pattern substitution
  syntax    NamePat ::= "#sub(" Procs    ";" Procs    ";" NamePat  ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" NamePat  ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" NamePat  ")" [function]
                      | "#sub(" Names    ";" Names    ";" NamePat  ")" [function]
                      | "#sub(" Names    ";" NamePats ";" NamePat  ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" NamePat  ")" [function]

  syntax   NamePats ::= "#sub(" Procs    ";" Procs    ";" NamePats ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" NamePats ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" NamePats ")" [function]
                      | "#sub(" Names    ";" Names    ";" NamePats ")" [function]
                      | "#sub(" Names    ";" NamePats ";" NamePats ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" NamePats ")" [function]

  syntax        Map ::= "#sub(" Names ";" Names    ";" Map ")" [function]
                      | "#sub(" Names ";" NamePats ";" Map ")" [function]
                      | "#sub(" Procs ";" Procs    ";" Map ")" [function]
                      | "#sub(" Procs ";" ProcPats ";" Map ")" [function]

// Map substitutions
  syntax       Name ::= "#sub(" Map ";" Name     ")" [function]
  syntax      Names ::= "#sub(" Map ";" Names    ")" [function]
  syntax    NamePat ::= "#sub(" Map ";" NamePat  ")" [function]
  syntax   NamePats ::= "#sub(" Map ";" NamePats ")" [function]
  syntax       Proc ::= "#sub(" Map ";" Proc     ")" [function, poly(0,2)]
  syntax      Procs ::= "#sub(" Map ";" Procs    ")" [function]
  syntax    ProcPat ::= "#sub(" Map ";" ProcPat  ")" [function]
  syntax   ProcPats ::= "#sub(" Map ";" ProcPats ")" [function]
  // RhoMaps
  syntax  RhoKVPair ::= "#sub(" Map ";" RhoKVPair  ")" [function]
  syntax RhoKVPairs ::= "#sub(" Map ";" RhoKVPairs ")" [function]
  syntax   RhoKVPat ::= "#sub(" Map ";" RhoKVPat   ")" [function]
  syntax  RhoKVPats ::= "#sub(" Map ";" RhoKVPats  ")" [function]
  // Select
  syntax     Branch ::= "#sub(" Map ";" Branch     ")" [function]
  syntax   Branches ::= "#sub(" Map ";" Branches   ")" [function]
  syntax  BranchPat ::= "#sub(" Map ";" BranchPat  ")" [function]
  syntax BranchPats ::= "#sub(" Map ";" BranchPats ")" [function]
  // Match
  syntax  MatchCase ::= "#sub(" Map ";" MatchCase  ")" [function]
  syntax MatchCases ::= "#sub(" Map ";" MatchCases ")" [function]
  syntax   MCasePat ::= "#sub(" Map ";" MCasePat   ")" [function]
  syntax  MCasePats ::= "#sub(" Map ";" MCasePats  ")" [function]
  // InterpMaps
  syntax InterpMaps ::= "#sub(" Map ";" InterpMaps ")" [function]

  syntax        Map ::= "#sub2map(" Procs    ";" Procs    ")" [function]
                      | "#sub2map(" Procs    ";" ProcPats ")" [function]
                      | "#sub2map(" ProcPats ";" ProcPats ")" [function]
                      | "#sub2map(" Names    ";" Names    ")" [function]
                      | "#sub2map(" Names    ";" NamePats ")" [function]
                      | "#sub2map(" NamePats ";" NamePats ")" [function]

// Input guard satisfaction predicate for comm in Grho
  syntax       Bool ::= "#subGuard(" Procs ";" Names    ";" BExp ")" [function]
                      | "#subGuard(" Procs ";" NamePats ";" BExp ")" [function]

// variables to substitute for
  syntax        Map ::= "#mapVarSub(" NamePats ")"         [function]
                      | "#mapVarSub(" NamePats ";" Int ")" [function]
                      | "#mapVarSub(" ProcPats ")"         [function]
                      | "#mapVarSub(" ProcPats ";" Int ")" [function]
// patterns to substitute in
  syntax        Map ::= "#mapVarIn("  NamePats ")"         [function]
                      | "#mapVarIn("  NamePats ";" Int ")" [function]
                      | "#mapVarIn("  ProcPats ")"         [function]
                      | "#mapVarIn("  ProcPats ";" Int ")" [function]

// Substitution context checking
  syntax       Bool ::= "#subcontext(" Proc    ";" Proc ";" Proc    ")" [function]
                      | "#subcontext(" Proc    ";" Proc ";" ProcPat ")" [function]
                      | "#subcontext(" ProcPat ";" Proc ";" Proc    ")" [function]
                      | "#subcontext(" ProcPat ";" Proc ";" ProcPat ")" [function]
                      | "#subcontext(" Name    ";" Name ";" Proc    ")" [function]
                      | "#subcontext(" Name    ";" Name ";" ProcPat ")" [function]
                      | "#subcontext(" NamePat ";" Name ";" Proc    ")" [function]
                      | "#subcontext(" NamePat ";" Name ";" ProcPat ")" [function]

  syntax      KItem ::= Name | NamePat | Proc | ProcPat

endmodule

module SUB
  import SUB-SYNTAX
  import AUXFUN
  import NAMEVAR

  syntax KResult ::= Proc | Procs | ProcPat | ProcPats
                   | Name | Names | NamePat | NamePats
                   | Bind | Binds | BindPat | BindPats
                   | New  | Match | Select  | InterpMaps
                   | RhoKVPair | RhoKVPairs | RhoKVPat | RhoKVPats
                   | MatchCase | MatchCases | MCasePat | MCasePats
                   | Branch | Branches | BranchPat | BranchPats
                   | NewPat | MatchPat | SelectPat
                   | Map

// BoundName/Proc subs for indexing
  // requirements of #sub function on BoundNames/Procs for DeBruijn index substitutions
  rule #sub( _:Name ; _:Name ;  C:BoundName ) =>  C
  rule #sub( _:Proc ; _:Proc ;  C:BoundName ) =>  C
  rule #sub( _:Name ; _:Name ; *C:BoundName ) => *C
  rule #sub( _:Proc ; _:Proc ; *C:BoundName ) => *C
  rule #sub( A:Name ; _:Name ;  C:BoundProc ) =>  C
  rule #sub( A:Proc ; _:Proc ;  C:BoundProc ) =>  C
  rule #sub( A:Name ; _:Name ; @C:BoundProc ) => @C
  rule #sub( A:Proc ; _:Proc ; @C:BoundProc ) => @C
/*
// TODO: #subBound(...) for substituting bound variables?
  rule #sub( A:BoundName ; _:BoundName ;  _:BoundName ) =>  A
  rule #sub( A:BoundName ; _:BoundName ; *_:BoundName ) => *A
  rule #sub( A:BoundName ; _:BoundName ;  _:Var ) =>  A
  rule #sub( A:BoundName ; _:BoundName ; *_:Var ) => *A
  // no sub BoundName for BoundName in ProcVar
  rule #sub( _:BoundName ; _:BoundName ;  \C:Var ) =>  \C
  rule #sub( _:BoundName ; _:BoundName ; @\C:Var ) => @\C
  // no sub BoundName for BoundName in BoundProc
  rule #sub( _:BoundName ; _:BoundName ;  C:BoundProc ) =>  C
  rule #sub( _:BoundName ; _:BoundName ; @C:BoundProc ) => @C

  rule #sub( A:BoundProc ; _:BoundProc ;   _:BoundProc ) =>  A
  rule #sub( A:BoundProc ; _:BoundProc ;  @_:BoundProc ) => @A
  rule #sub( A:BoundProc ; _:BoundProc ;  \(_:Var) ) =>  A
  rule #sub( A:BoundProc ; _:BoundProc ; @\(_:Var) ) => @A
  // no sub BoundProc for BoundProc in Var
  rule #sub( _:BoundProc ; _:BoundProc ;  C:Var ) =>  C
  rule #sub( _:BoundProc ; _:BoundProc ; *C:Var ) => *C
  // no sub BoundProc for BoundProc in BoundName
  rule #sub( _:BoundProc ; _:BoundProc ;  C:BoundName ) =>  C
  rule #sub( _:BoundProc ; _:BoundProc ; *C:BoundName ) => *C
*/
// used in #mapSub -- for hiding variables while indexing
  rule #sub( _:Name ; @sub ; A:Name    ) => A
  rule #sub( _:Name ; @sub ; A:Proc    ) => A
  rule #sub( _:Proc ;  sub ; A:Name    ) => A
  rule #sub( _:Proc ;  sub ; A:Proc    ) => A
  rule #sub( _:Name ; @sub ; A:NamePat ) => A
  rule #sub( _:Name ; @sub ; A:ProcPat ) => A
  rule #sub( _:Proc ;  sub ; A:NamePat ) => A
  rule #sub( _:Proc ;  sub ; A:ProcPat ) => A

// hidden variables
  rule #sub( _:NamePat ; _:NamePat ; sub ) => sub
  rule #sub( _:ProcPat ; _:ProcPat ; sub ) => sub

//-------------------------------------
//--- Substitute Proc for Proc[Pat] ---
//-------------------------------------
// Trivial cases
  rule #sub( A:Proc ; A ; B:Name    ) => B
  rule #sub( A:Proc ; A ; B:NamePat ) => B
  rule #sub( A:Proc ; A ; B:Proc    ) => B
  rule #sub( A:Proc ; A ; B:ProcPat ) => B
  rule #sub( _:Proc ; _:Proc    ; B:Ground ) => B
  rule #sub( _:Proc ; _:ProcPat ; B:Ground ) => B

  // Empty proc subs
  rule #sub( _:Proc ;  EmptyP ; A:Name    ) => A [structural]
  rule #sub( _:Proc ;  EmptyP ; A:NamePat ) => A [structural]
  rule #sub( _:Proc ;  EmptyP ; A:Proc    ) => A [structural]
  rule #sub( _:Proc ;  EmptyP ; A:ProcPat ) => A [structural]
  rule #sub( _:Proc ; *EmptyN ; A:Name    ) => A [structural]
  rule #sub( _:Proc ; *EmptyN ; A:NamePat ) => A [structural]
  rule #sub( _:Proc ; *EmptyN ; A:Proc    ) => A [structural]
  rule #sub( _:Proc ; *EmptyN ; A:ProcPat ) => A [structural]

// Fundamental cases -- variables
  // sub Proc for ProcVar in ProcVar or Var
  rule #sub( A:Proc ; \B:Var   ; \B     ) =>  A
  rule #sub( _:Proc ; \B:Var   ; \C:Var ) => \C requires B =/=K C
  rule #sub( _:Proc ; \(_:Var) ;  A:Var ) =>  A
  // sub bound process variable in ProcVar or Var
  // Typed
  rule #sub( A:Proc ; \B:Var ;  \B     :: D:Proc    ) =>   A :: #sub(A;\B;D)
  rule #sub( A:Proc ; \B:Var ;  \B     :: D:ProcPat ) =>   A :: #sub(A;\B;D)
  rule #sub( A:Proc ; \B:Var ; @\B     :: D:Name    ) =>  @A :: #sub(A;\B;D)
  rule #sub( A:Proc ; \B:Var ; @\B     :: D:NamePat ) =>  @A :: #sub(A;\B;D)
  rule #sub( A:Proc ; \B:Var ;  \C:Var :: D:Proc    ) =>  \C :: #sub(A;\B;D) requires B =/=K C
  rule #sub( A:Proc ; \B:Var ;  \C:Var :: D:ProcPat ) =>  \C :: #sub(A;\B;D) requires B =/=K C
  rule #sub( A:Proc ; \B:Var ; @\C:Var :: D:Name    ) => @\C :: #sub(A;\B;D) requires B =/=K C
  rule #sub( A:Proc ; \B:Var ; @\C:Var :: D:NamePat ) => @\C :: #sub(A;\B;D) requires B =/=K C
  rule #sub( A:Proc ; \B:Var ;  *C:Var :: D:Proc    ) =>  *C :: #sub(A;\B;D)
  rule #sub( A:Proc ; \B:Var ;  *C:Var :: D:ProcPat ) =>  *C :: #sub(A;\B;D)
  rule #sub( A:Proc ; \B:Var ;   C:Var :: D:Name    ) =>   C :: #sub(A;\B;D)
  rule #sub( A:Proc ; \B:Var ;   C:Var :: D:NamePat ) =>   C :: #sub(A;\B;D)

  // sub Proc for *Var in Var or ProcVar
  rule #sub( A:Proc ; *B:Var ;  B     ) => @A
  rule #sub( A:Proc ; *B:Var ;  C:Var ) =>  C requires B =/=K C
  rule #sub( _:Proc ; *_:Var ; \A:Var ) => \A
  // Typed
  rule #sub( A:Proc ; *B:Var ;   B     :: D:Name    ) =>  @A :: #sub(A;*B;D)
  rule #sub( A:Proc ; *B:Var ;   B     :: D:NamePat ) =>  @A :: #sub(A;*B;D)
  rule #sub( A:Proc ; *B:Var ;  *B     :: D:Proc    ) =>   A :: #sub(A;*B;D)
  rule #sub( A:Proc ; *B:Var ;  *B     :: D:ProcPat ) =>   A :: #sub(A;*B;D)
  rule #sub( A:Proc ; *B:Var ;   C:Var :: D:Name    ) =>   C :: #sub(A;*B;D) requires B =/=K C
  rule #sub( A:Proc ; *B:Var ;   C:Var :: D:NamePat ) =>   C :: #sub(A;*B;D) requires B =/=K C
  rule #sub( A:Proc ; *B:Var ;  *C:Var :: D:Proc    ) =>  *C :: #sub(A;*B;D) requires B =/=K C
  rule #sub( A:Proc ; *B:Var ;  *C:Var :: D:ProcPat ) =>  *C :: #sub(A;*B;D) requires B =/=K C
  rule #sub( A:Proc ; *B:Var ;  \C:Var :: D:Proc    ) =>  \C :: #sub(A;*B;D)
  rule #sub( A:Proc ; *B:Var ;  \C:Var :: D:ProcPat ) =>  \C :: #sub(A;*B;D)
  rule #sub( A:Proc ; *B:Var ; @\C:Var :: D:Name    ) => @\C :: #sub(A;*B;D)
  rule #sub( A:Proc ; *B:Var ; @\C:Var :: D:NamePat ) => @\C :: #sub(A;*B;D)

  // TODO: sub for Uri for #match

// Recusive cases -- destructuring substitution Proc[Pat] or Name[Pat]
  // sub Proc for Proc[Pat] in @Proc[Pat]
  rule #sub( A:Proc ; B:Proc    ; @C:Proc    ) => @#sub(A;B;C)
  rule #sub( A:Proc ; B:Proc    ; @C:ProcPat ) => @#sub(A;B;C)
  rule #sub( A:Proc ; B:ProcPat ; @C:Proc    ) => @#sub(A;B;C)
  rule #sub( A:Proc ; B:ProcPat ; @C:ProcPat ) => @#sub(A;B;C)

  // sub Proc for Proc[Pat] in *Name[Pat]
  rule #sub( A:Proc ; B:Proc    ; *C:Name    ) => *#sub(A;B;C)
  rule #sub( A:Proc ; B:Proc    ; *C:NamePat ) => *#sub(A;B;C)
  rule #sub( A:Proc ; B:ProcPat ; *C:Name    ) => *#sub(A;B;C)
  rule #sub( A:Proc ; B:ProcPat ; *C:NamePat ) => *#sub(A;B;C)

  // sub *Name for *Name[Pat] in Proc[Pat]
  rule #sub( *A:Name ; *B:Name    ; C:Proc    ) => #sub(A;B;C) requires notBool isVar(B)
  rule #sub( *A:Name ; *B:Name    ; C:ProcPat ) => #sub(A;B;C) requires notBool isVar(B)
  rule #sub( *A:Name ; *B:NamePat ; C:Proc    ) => #sub(A;B;C) // requires notBool isPatVar(B)
  rule #sub( *A:Name ; *B:NamePat ; C:ProcPat ) => #sub(A;B;C) // requires notBool isPatVar(B)

  // sub Proc for Proc[Pat] in Send[Pat] -- sub in channel and message(s)
  rule #sub( A:Proc ; B:Proc    ; C:NamePat !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:NamePat !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:NamePat !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc    ; C:Name    !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:Name    !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:Name    !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc    ; C:NamePat !! ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:NamePat !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:NamePat !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Proc ; B:Proc    ; C:Name    !! ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:Name    !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:Name    !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat !! ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    !! ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    !! (            ) ) => #sub(A;B;C) !! (             )

  // sub Proc for Proc in Receive -- only substitute free variables in channel and continuation
    // if substitution variables are all listening variables and not receive variables, then no substitution occurs
  rule #sub( _:Proc ;  B:Proc    ; C:Receive ) => C requires #FV(B) <=Set (#LV(C) -Set #RV(C))
  rule #sub( _:Proc ;  B:ProcPat ; C:Receive ) => C requires #FV(B) <=Set (#LV(C) -Set #RV(C))
  rule #sub( _:Proc ;  B:Proc    ; C:RecPat  ) => C requires #FV(B) <=Set (#LV(C) -Set #RV(C))
  rule #sub( _:Proc ;  B:ProcPat ; C:RecPat  ) => C requires #FV(B) <=Set (#LV(C) -Set #RV(C))
    // if substitution variables are distinct from free variables in Rec, then no substitution occurs
  rule #sub( _:Proc ;  B:Proc    ; C:Receive ) => C requires intersectSet(#FV(B),#FV(C)) ==K .Set
  rule #sub( _:Proc ;  B:ProcPat ; C:Receive ) => C requires intersectSet(#FV(B),#FV(C)) ==K .Set
  rule #sub( _:Proc ;  B:Proc    ; C:RecPat  ) => C requires intersectSet(#FV(B),#FV(C)) ==K .Set
  rule #sub( _:Proc ;  B:ProcPat ; C:RecPat  ) => C requires intersectSet(#FV(B),#FV(C)) ==K .Set
    // substituting for a ProcVar -- if ProcVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Proc ;  B:ProcVar ; C:Receive ) => #if (B in #LV(C)) #then #subChan(A;B;C) #else #subRec(A;B;C) #fi
  rule #sub( A:Proc ;  B:ProcVar ; C:RecPat  ) => #if (B in #LV(C)) #then #subChan(A;B;C) #else #subRec(A;B;C) #fi
    // substituting for *Var -- if Var is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Proc ; *B:Var     ; C:Receive ) => #if (B in #LV(C)) #then #subChan(@A;B;C) #else #subRec(@A;B;C) #fi
  rule #sub( A:Proc ; *B:Var     ; C:RecPat  ) => #if (B in #LV(C)) #then #subChan(@A;B;C) #else #subRec(@A;B;C) #fi

    // if substitution variable is a listening variable, then it is only substituted in the channel (not in the guard or continuation)
  rule #subChan( A:Proc ; B:Proc ; C:UGRec    ) => for( #subBind(A;B;;#bind(C)) ){ #cont(C) }
  rule #subChan( A:Proc ; B:Proc ; C:UGRecPat ) => for( #subBind(A;B;;#bind(C)) ){ #cont(C) }
  rule #subChan( A:Proc ; B:Proc ; C:GRec     ) => for( #subBind(A;B;;#bind(C)) if #sub(A;B;#guard(C)) ){#cont(C)}
  rule #subChan( A:Proc ; B:Proc ; C:GRecPat  ) => for( #subBind(A;B;;#bind(C)) if #sub(A;B;#guard(C)) ){#cont(C)}
    // if substitution variable is not a listening variable, then it is substituted in the channel and continuation (and guard)
  rule #subRec(  A:Proc ; B:Proc ; C:UGRec    ) => for( #subBind(A;B;;#bind(C)) ){ #sub(A;B; #cont(C)) }
  rule #subRec(  A:Proc ; B:Proc ; C:UGRecPat ) => for( #subBind(A;B;;#bind(C)) ){ #sub(A;B; #cont(C)) }
  rule #subRec(  A:Proc ; B:Proc ; C:GRec     ) => for( #subBind(A;B;;#bind(C)) if #sub(A;B;#guard(C)) ){#sub(A;B;#cont(C))}
  rule #subRec(  A:Proc ; B:Proc ; C:GRecPat  ) => for( #subBind(A;B;;#bind(C)) if #sub(A;B;#guard(C)) ){#sub(A;B;#cont(C))}

  // Binds -- only substitute in the channel
    // Linear
  rule #subBind( A:Proc ; B:Proc ;; <-  C:Name    ) =>           <-  #sub(A;B;C)
  rule #subBind( A:Proc ; B:Proc ;; <-  C:NamePat ) =>           <-  #sub(A;B;C)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind       ) =>  #bvar(C) <-  #sub(A;B;#chan(C))
  rule #subBind( A:Proc ; B:Proc ;; C:LbindPat    ) =>  #bvar(C) <-  #sub(A;B;#chan(C))
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind    & D:Lbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind    & D:LbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:LbindPat & D:Lbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:LbindPat & D:LbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind    & D:Lbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind    & D:LbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:LbindPat & D:Lbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:LbindPat & D:LbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)
    // Peek
  rule #subBind( A:Proc ; B:Proc ;; <<- C:Name    ) =>           <<- #sub(A;B;C)
  rule #subBind( A:Proc ; B:Proc ;; <<- C:NamePat ) =>           <<- #sub(A;B;C)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind       ) =>  #bvar(C) <<- #sub(A;B;#chan(C))
  rule #subBind( A:Proc ; B:Proc ;; C:PbindPat    ) =>  #bvar(C) <<- #sub(A;B;#chan(C))
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind    & D:Pbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind    & D:PbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:PbindPat & D:Pbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:PbindPat & D:PbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind    & D:Pbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind    & D:PbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:PbindPat & D:Pbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:PbindPat & D:PbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)
    // Repeated
  rule #subBind( A:Proc ; B:Proc ;; <=  C:Name    ) =>           <=  #sub(A;B;C)
  rule #subBind( A:Proc ; B:Proc ;; <=  C:NamePat ) =>           <=  #sub(A;B;C)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind       ) =>  #bvar(C) <=  #sub(A;B;#chan(C))
  rule #subBind( A:Proc ; B:Proc ;; C:RbindPat    ) =>  #bvar(C) <=  #sub(A;B;#chan(C))
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind    & D:Rbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind    & D:RbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:RbindPat & D:Rbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:RbindPat & D:RbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind    & D:Rbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind    & D:RbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:RbindPat & D:Rbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:RbindPat & D:RbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)

// sub Proc for ProcVar in Contract[Pat]
  rule #sub( A:Proc ; B:ProcVar ; contract C:NamePat ( D:NamePats ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Proc ; B:ProcVar ; contract C:NamePat ( D:NamePats ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Proc ; B:ProcVar ; contract C:NamePat ( D:Names    ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Proc ; B:ProcVar ; contract C:NamePat ( D:Names    ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Proc ; B:ProcVar ; contract C:Name    ( D:NamePats ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Proc ; B:ProcVar ; contract C:Name    ( D:NamePats ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Proc ; B:ProcVar ; contract C:Name    ( D:Names    ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Proc ; B:ProcVar ; contract C:Name    ( D:Names    ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Proc ; B:ProcVar ; contract C:NamePat ( ) = { E:ProcPat } ) => contract #sub(A;B;C)( )={#sub(A;B;E)}
  rule #sub( A:Proc ; B:ProcVar ; contract C:NamePat ( ) = { E:Proc    } ) => contract #sub(A;B;C)( )={#sub(A;B;E)}
  rule #sub( A:Proc ; B:ProcVar ; contract C:Name    ( ) = { E:ProcPat } ) => contract #sub(A;B;C)( )={#sub(A;B;E)}
  rule #sub( A:Proc ; B:ProcVar ; contract C:Name    ( ) = { E:Proc    } ) => contract #sub(A;B;C)( )={#sub(A;B;E)}
// sub Proc for *Var in Contract[Pat]
  rule #sub( A:Proc ; *B:Var ; contract C:NamePat ( D:NamePats ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;*B;C)(D)={E} #else contract #sub(A;*B;C)(D)={#sub(A;*B;E)} #fi
  rule #sub( A:Proc ; *B:Var ; contract C:NamePat ( D:NamePats ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;*B;C)(D)={E} #else contract #sub(A;*B;C)(D)={#sub(A;*B;E)} #fi
  rule #sub( A:Proc ; *B:Var ; contract C:NamePat ( D:Names    ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;*B;C)(D)={E} #else contract #sub(A;*B;C)(D)={#sub(A;*B;E)} #fi
  rule #sub( A:Proc ; *B:Var ; contract C:NamePat ( D:Names    ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;*B;C)(D)={E} #else contract #sub(A;*B;C)(D)={#sub(A;*B;E)} #fi
  rule #sub( A:Proc ; *B:Var ; contract C:Name    ( D:NamePats ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;*B;C)(D)={E} #else contract #sub(A;*B;C)(D)={#sub(A;*B;E)} #fi
  rule #sub( A:Proc ; *B:Var ; contract C:Name    ( D:NamePats ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;*B;C)(D)={E} #else contract #sub(A;*B;C)(D)={#sub(A;*B;E)} #fi
  rule #sub( A:Proc ; *B:Var ; contract C:Name    ( D:Names    ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;*B;C)(D)={E} #else contract #sub(A;*B;C)(D)={#sub(A;*B;E)} #fi
  rule #sub( A:Proc ; *B:Var ; contract C:Name    ( D:Names    ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;*B;C)(D)={E} #else contract #sub(A;*B;C)(D)={#sub(A;*B;E)} #fi
  rule #sub( A:Proc ; *B:Var ; contract C:NamePat ( ) = { E:ProcPat } ) => contract #sub(A;*B;C)( )={#sub(A;*B;E)}
  rule #sub( A:Proc ; *B:Var ; contract C:NamePat ( ) = { E:Proc    } ) => contract #sub(A;*B;C)( )={#sub(A;*B;E)}
  rule #sub( A:Proc ; *B:Var ; contract C:Name    ( ) = { E:ProcPat } ) => contract #sub(A;*B;C)( )={#sub(A;*B;E)}
  rule #sub( A:Proc ; *B:Var ; contract C:Name    ( ) = { E:Proc    } ) => contract #sub(A;*B;C)( )={#sub(A;*B;E)}

// sub Proc for Proc[Pat] in Invocation[Pat]
  rule #sub( A:Proc ; B:Proc    ; C:NamePat ( D:NamePats ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:NamePat ( D:Names    ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:NamePat (            ) ) => #sub(A;B;C)(             )
  rule #sub( A:Proc ; B:Proc    ; C:Name    ( D:NamePats ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:Name    ( D:Names    ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; C:Name    (            ) ) => #sub(A;B;C)(             )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat ( D:NamePats ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat ( D:Names    ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat (            ) ) => #sub(A;B;C)(             )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    ( D:NamePats ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    ( D:Names    ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; C:Name    (            ) ) => #sub(A;B;C)(             )

// sub Proc for Proc[Pat] in Par
  rule #sub( A:Proc ; B:Proc    ; C:Proc    | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:Proc    | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:ProcPat | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:ProcPat | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Proc    | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Proc    | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:ProcPat | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:ProcPat | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D)

// sub Proc for ProcVar in Match[Pat]
  rule #sub( A:Proc ; \B:Var ; match C:Proc    { D:MatchCases } ) => match #sub(A;\B;C) {#subMatch(A;\B;D)}
  rule #sub( A:Proc ; \B:Var ; match C:Proc    { D:MCasePats  } ) => match #sub(A;\B;C) {#subMatch(A;\B;D)}
  rule #sub( A:Proc ; \B:Var ; match C:ProcPat { D:MatchCases } ) => match #sub(A;\B;C) {#subMatch(A;\B;D)}
  rule #sub( A:Proc ; \B:Var ; match C:ProcPat { D:MCasePats  } ) => match #sub(A;\B;C) {#subMatch(A;\B;D)}
  // MatchCases/MCasePats
  rule #subMatch( A:Proc ; \B:Var ; { C:Proc    } |=> D:Proc )
    => #if (\B in #FV(C)) #then {C}|=>D #else {C} |=> #sub(A;\B;D) #fi
  rule #subMatch( A:Proc ; \B:Var ; { C:Proc    } |=> D:ProcPat )
    => #if (\B in #FV(C)) #then {C}|=>D #else {C} |=> #sub(A;\B;D) #fi
  rule #subMatch( A:Proc ; \B:Var ; { C:ProcPat } |=> D:Proc )
    => #if (\B in #FV(C)) #then {C}|=>D #else {C} |=> #sub(A;\B;D) #fi
  rule #subMatch( A:Proc ; \B:Var ; { C:ProcPat } |=> D:ProcPat )
    => #if (\B in #FV(C)) #then {C}|=>D #else {C} |=> #sub(A;\B;D) #fi
  rule #subMatch( A:Proc ; B:Proc ; C:MatchCase D:MatchCases ) => #subMatch(A;B;C) #subMatch(A;B;D)
  rule #subMatch( A:Proc ; B:Proc ; C:MatchCase D:MCasePats  ) => #subMatch(A;B;C) #subMatch(A;B;D)
  rule #subMatch( A:Proc ; B:Proc ; C:MCasePat  D:MatchCases ) => #subMatch(A;B;C) #subMatch(A;B;D)
  rule #subMatch( A:Proc ; B:Proc ; C:MCasePat  D:MCasePats  ) => #subMatch(A;B;C) #subMatch(A;B;D)

// sub Proc for ProcVar in Select[Pat]
  rule #sub( A:Proc ; \B:Var ; select { C:Branches   } ) => select {#subBranch(A;\B;C)}
  rule #sub( A:Proc ; \B:Var ; select { C:BranchPats } ) => select {#subBranch(A;\B;C)}
  // Branches/BranchPats
  rule #subBranch( A:Proc ; \B:Var ; C:Branch )
    => #if (\B in #LV(C))
       #then {#subBind(A;\B;;#bind(C))} |=> #cont(C)
       #else {#subBind(A;\B;;#bind(C))} |=> #sub(A;\B;#cont(C)) #fi
  rule #subBranch( A:Proc ; \B:Var ; C:BranchPat )
    => #if (\B in #LV(C))
       #then {#subBind(A;\B;;#bind(C))} |=> #cont(C)
       #else {#subBind(A;\B;;#bind(C))} |=> #sub(A;\B;#cont(C)) #fi
  rule #subBranch( A:Proc ; B:Proc ; C:Branch    D:Branches   ) => #subBranch(A;B;C) #subBranch(A;B;D)
  rule #subBranch( A:Proc ; B:Proc ; C:Branch    D:BranchPats ) => #subBranch(A;B;C) #subBranch(A;B;D)
  rule #subBranch( A:Proc ; B:Proc ; C:BranchPat D:Branches   ) => #subBranch(A;B;C) #subBranch(A;B;D)
  rule #subBranch( A:Proc ; B:Proc ; C:BranchPat D:BranchPats ) => #subBranch(A;B;C) #subBranch(A;B;D)

// VarRef -- TODO: test
  rule #sub(  A:BoundProc ; B:ProcVar ; = B         ) => = A
  rule #sub( *A:BoundName ; B:ProcVar ; = B         ) => =*A
  rule #sub(  A:Proc      ; B:ProcVar ; = B         ) =>  A requires notBool isBoundProc(A)
  rule #sub( *A:Name      ; B:ProcVar ; = B         ) => *A requires notBool isBoundName(A)
  rule #sub(  A:Proc      ; B:ProcVar ; = C:ProcVar ) => =C requires B =/=K C
  rule #sub( *A:Name      ; B:ProcVar ; = C:ProcVar ) => =C requires B =/=K C

// Let expressions -- TODO: other Lets
  rule #sub( A:Proc ;  B:ProcVar ; let C:ProcVar <- D:Proc in { E:Proc } )
    => #if B ==K C #then let C <- #sub(A;B;D) in {E} #else let C <- #sub(A;B;D) in { #sub(A;B;E) } #fi
  rule #sub( A:Proc ; *B:Var     ; let C:ProcVar <- D:Proc in { E:Proc } ) => let C <- #sub(A;*B;D) in { #sub(A;*B;E) }

// sub Proc for Proc[Pat] in Method
  rule #sub( A:Proc ; B:Proc    ; C:Proc D:MethodAndArgs ) => #sub(A;B;C) #subMethod(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Proc D:MethodAndArgs ) => #sub(A;B;C) #subMethod(A;B;D)
  // MethodAndArgs sub
  rule #subMethod( _:Proc ; _:Proc    ; . C:Method ( ) ) => .C( )
  rule #subMethod( _:Proc ; _:ProcPat ; . C:Method ( ) ) => .C( )
  rule #subMethod( A:Proc ; B:Proc    ; . C:Method ( D:Procs ) ) => .C( #sub(A;B;D) )
  rule #subMethod( A:Proc ; B:ProcPat ; . C:Method ( D:Procs ) ) => .C( #sub(A;B;D) )

// sub Proc for Proc[Pat] in Collections
  // RhoList
  rule #sub( _:Proc ; _:Proc    ; [ ] ) => [ ]
  rule #sub( _:Proc ; _:ProcPat ; [ ] ) => [ ]
  rule #sub( _:Proc ; _:Proc    ;   EmptyListPat ) => EmptyListPat
  rule #sub( _:Proc ; _:ProcPat ;   EmptyListPat ) => EmptyListPat
  rule #sub( A:Proc ; B:Proc    ; [ C:Procs    ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Proc ; B:Proc    ; [ C:ProcPats ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Proc ; B:ProcPat ; [ C:Procs    ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Proc ; B:ProcPat ; [ C:ProcPats ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Proc ; B:Proc    ; [ C:Procs    ... D:ProcVar ] ) => [ #sub(A;B;C) ... #sub(A;B;D) ]
  rule #sub( A:Proc ; B:Proc    ; [ C:ProcPats ... D:ProcVar ] ) => [ #sub(A;B;C) ... #sub(A;B;D) ]
  rule #sub( A:Proc ; B:ProcPat ; [ C:Procs    ... D:ProcVar ] ) => [ #sub(A;B;C) ... #sub(A;B;D) ]
  rule #sub( A:Proc ; B:ProcPat ; [ C:ProcPats ... D:ProcVar ] ) => [ #sub(A;B;C) ... #sub(A;B;D) ]
  // RhoMap
  rule #sub( _:Proc ; _:Proc    ; { } ) => { }
  rule #sub( _:Proc ; _:ProcPat ; { } ) => { }
  rule #sub( _:Proc ; _:Proc    ;   EmptyMapPat    ) => EmptyMapPat
  rule #sub( _:Proc ; _:ProcPat ;   EmptyMapPat    ) => EmptyMapPat
  rule #sub( A:Proc ; B:Proc    ; { C:RhoKVPairs } ) => { #subKV(A;B;C) }
  rule #sub( A:Proc ; B:Proc    ; { C:RhoKVPats  } ) => { #subKV(A;B;C) }
  rule #sub( A:Proc ; B:ProcPat ; { C:RhoKVPairs } ) => { #subKV(A;B;C) }
  rule #sub( A:Proc ; B:ProcPat ; { C:RhoKVPats  } ) => { #subKV(A;B;C) }
  rule #sub( A:Proc ; B:Proc    ; { C:RhoKVPairs ... D:ProcVar } ) => { #subKV(A;B;C) ... #sub(A;B;D) }
  rule #sub( A:Proc ; B:Proc    ; { C:RhoKVPats  ... D:ProcVar } ) => { #subKV(A;B;C) ... #sub(A;B;D) }
  rule #sub( A:Proc ; B:ProcPat ; { C:RhoKVPairs ... D:ProcVar } ) => { #subKV(A;B;C) ... #sub(A;B;D) }
  rule #sub( A:Proc ; B:ProcPat ; { C:RhoKVPats  ... D:ProcVar } ) => { #subKV(A;B;C) ... #sub(A;B;D) }
    // RhoKVPairs/Pats
  rule #subKV( A:Proc ; B:Proc    ; C:Proc    : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc    ; C:Proc    : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc    ; C:ProcPat : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc    ; C:ProcPat : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:ProcPat ; C:Proc    : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:ProcPat ; C:Proc    : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:ProcPat ; C:ProcPat : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:ProcPat ; C:ProcPat : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc    ; C:RhoKVPair , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc    ; C:RhoKVPair , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc    ; C:RhoKVPat  , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc    ; C:RhoKVPat  , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:ProcPat ; C:RhoKVPair , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:ProcPat ; C:RhoKVPair , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:ProcPat ; C:RhoKVPat  , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:ProcPat ; C:RhoKVPat  , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
  // RhoSet
  rule #sub( _:Proc ; _:Proc    ; Set( ) ) => Set( )
  rule #sub( _:Proc ; _:ProcPat ; Set( ) ) => Set( )
  rule #sub( _:Proc ; _:Proc    ;   EmptySetPat     ) => EmptySetPat
  rule #sub( _:Proc ; _:ProcPat ;   EmptySetPat     ) => EmptySetPat
  rule #sub( A:Proc ; B:Proc    ; Set( C:Procs    ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Proc ; B:Proc    ; Set( C:ProcPats ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Proc ; B:ProcPat ; Set( C:Procs    ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Proc ; B:ProcPat ; Set( C:ProcPats ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Proc ; B:Proc    ; Set( C:Procs    ... D:ProcVar ) ) => Set( #sub(A;B;C) ... #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc    ; Set( C:ProcPats ... D:ProcVar ) ) => Set( #sub(A;B;C) ... #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; Set( C:Procs    ... D:ProcVar ) ) => Set( #sub(A;B;C) ... #sub(A;B;D) )
  rule #sub( A:Proc ; B:ProcPat ; Set( C:ProcPats ... D:ProcVar ) ) => Set( #sub(A;B;C) ... #sub(A;B;D) )
  // RhoTuple
  rule #sub( A:Proc ; B:Proc    ; ( C:Procs    ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Proc ; B:Proc    ; ( C:ProcPats ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Proc ; B:ProcPat ; ( C:Procs    ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Proc ; B:ProcPat ; ( C:ProcPats ,) ) => ( #sub(A;B;C) ,)

// sub Proc for Proc in New[Pat]
  rule #sub(    A:Proc ; \B:Var   ; P:New    ) => #subNew(A;\B;P)
  rule #sub(    A:Proc ; \B:Var   ; P:NewPat ) => #subNew(A;\B;P)
  rule #subNew( A:Proc ;  B:Proc  ; new C:VarDecs in { D:Proc    } ) => new C in { #sub(A;B;D) }
       requires intersectSet(#FV(B),#DV(C)) ==K .Set
  rule #subNew( A:Proc ;  B:Proc  ; new C:VarDecs in { D:ProcPat } ) => new C in { #sub(A;B;D) }
       requires intersectSet(#FV(B),#DV(C)) ==K .Set
  rule #subNew( I:Int  ; A:VarDec ; C:Proc    ) => #sub(@unforgeable(I);#var(A);C)
  rule #subNew( I:Int  ; A:VarDec , B:VarDecs ; C:Proc    )
    => #subNew(I +Int 1;B;#subNew(I;A;C))
  rule #subNew( I:Int  ; A:VarDec ; C:ProcPat ) => #sub(@unforgeable(I);A;C)
  rule #subNew( I:Int  ; A:VarDec , B:VarDecs ; C:ProcPat )
    => #subNew(I +Int 1;B;#sub(@unforgeable(I);A;C))

// sub Proc fpr Proc[Pat] in Exp
  // Arithmetic Exps
  rule #sub( A:Proc ; B:Proc    ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc    ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
  // List & String expressions
  rule #sub( A:Proc ; B:Proc    ; C:ListOrVar   ++ D:ListOrVar   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:ListOrVar   ++ D:ConcatList  ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:StringOrVar ++ D:StringOrVar ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:StringOrVar ++ D:ConcatStr   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:StringOrVar %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:RhoMap      %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:ListOrVar   ++ D:ListOrVar   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:ListOrVar   ++ D:ConcatList  ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:StringOrVar ++ D:StringOrVar ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:StringOrVar ++ D:ConcatStr   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:StringOrVar %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:RhoMap      %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  // Boolean Exps
  rule #sub( A:Proc ; B:Proc    ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc    ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:Proc    matches D:Proc    ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:Proc    matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc    ; C:ProcPat matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Proc ; B:ProcPat ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Proc    matches D:Proc    ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:Proc    matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:ProcPat matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)

// sub Proc for Proc[Pat] in Name[Pat]s
  rule #sub( A:Proc ; B:Proc    ; C:Name    , D:Names    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:NamePat , D:NamePats ) => #sub(A;B;C) , #sub(A;B;D)

// sub Proc for Proc[Pat] in Proc[Pat]s
  rule #sub( A:Proc ; B:Proc    ; C:Proc    , D:Procs    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:ProcPat ; C:ProcPat , D:ProcPats ) => #sub(A;B;C) , #sub(A;B;D)

// IndexPVar -- for simultaneous substitution
  rule #sub( A:ProcPat ; pvar( I:Int ) ; pvar( I )   ) => A
  rule #sub( _:ProcPat ; A:IndexPVar   ; B:ProcPat   ) => B requires A =/=K B
  rule #sub( _:ProcPat ; A:ProcPat     ; B:IndexPVar ) => B requires A =/=K B

// sub Procs for Proc[Pat]s
// only applies after successful #match so lengths are assumed equal
  // simultaneous subs
  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ; E:NamePat ) => #sub(#mapVarIn(A,B);#sub(#mapVarSub(C,D);E))
  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ; E:ProcPat ) => #sub(#mapVarIn(A,B);#sub(#mapVarSub(C,D);E))
  // sequential subs
//  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  // sub Procs for ProcPats in NamePats
  rule #sub( A:ProcPats ; B:ProcPats ; C:NamePat , D:NamePats ) => #sub(A;B;C) , #sub(A;B;D)
  // sub Procs for ProcPats in ProcPats
  rule #sub( A:ProcPats ; B:ProcPats ; C:ProcPat , D:ProcPats ) => #sub(A;B;C) , #sub(A;B;D)

// sub Proc for Proc[Pat] in Map -- sub key & value
  rule #sub( _:Proc ; _:Proc    ; .Map ) => .Map
  rule #sub( _:Proc ; _:ProcPat ; .Map ) => .Map
  rule #sub( A:Proc ; B:Proc    ; C:Proc |-> D:Proc E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Proc ; B:ProcPat ; C:Proc |-> D:Proc E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Proc ; B:Proc    ; C:Name |-> D:Name E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Proc ; B:ProcPat ; C:Name |-> D:Name E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)

//-------------------------------------
//--- Substitute Name for Name[Pat] ---
//-------------------------------------
// Trivial cases
  rule #sub( A:Name ; A ; B:Name    ) => B
  rule #sub( A:Name ; A ; B:NamePat ) => B
  rule #sub( A:Name ; A ; B:Proc    ) => B
  rule #sub( A:Name ; A ; B:ProcPat ) => B
  rule #sub( _:Name ; _:Name    ; B:Ground ) => B
  rule #sub( _:Name ; _:NamePat ; B:Ground ) => B

  // Empty name subs
  rule #sub( _:Name ;  EmptyN ; A:Name    ) => A [structural]
  rule #sub( _:Name ;  EmptyN ; A:NamePat ) => A [structural]
  rule #sub( _:Name ;  EmptyN ; A:Proc    ) => A [structural]
  rule #sub( _:Name ;  EmptyN ; A:ProcPat ) => A [structural]
  rule #sub( _:Name ; @EmptyP ; A:Name    ) => A [structural]
  rule #sub( _:Name ; @EmptyP ; A:NamePat ) => A [structural]
  rule #sub( _:Name ; @EmptyP ; A:Proc    ) => A [structural]
  rule #sub( _:Name ; @EmptyP ; A:ProcPat ) => A [structural]

// sub Name for Name[Pat] in SimplePat
  rule #sub( _:Name ; _:Name    ; A:SimplePat ) => A
  rule #sub( _:Name ; _:NamePat ; A:SimplePat ) => A

// Fundamental cases
  // sub Name for Var in Var or ProcVar
  rule #sub( A:Name ; B:Var ;  B     ) =>  A
  rule #sub( A:Name ; B:Var ;  C:Var ) =>  C requires B =/=K C
  rule #sub( _:Name ; _:Var ; \A:Var ) => \A
  // Typed
  rule #sub( A:Name ; B:Var ;   B     :: D:Name    ) =>   A :: #sub(A;B;D)
  rule #sub( A:Name ; B:Var ;   B     :: D:NamePat ) =>   A :: #sub(A;B;D)
  rule #sub( A:Name ; B:Var ;  *B     :: D:Proc    ) =>  *A :: #sub(A;B;D)
  rule #sub( A:Name ; B:Var ;  *B     :: D:ProcPat ) =>  *A :: #sub(A;B;D)
  rule #sub( A:Name ; B:Var ;   C:Var :: D:Name    ) =>   C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; B:Var ;   C:Var :: D:NamePat ) =>   C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; B:Var ;  *C:Var :: D:Proc    ) =>  *C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; B:Var ;  *C:Var :: D:ProcPat ) =>  *C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; B:Var ; @\C:Var :: D:Name    ) => @\C :: #sub(A;B;D)
  rule #sub( A:Name ; B:Var ; @\C:Var :: D:NamePat ) => @\C :: #sub(A;B;D)
  rule #sub( A:Name ; B:Var ;  \C:Var :: D:Proc    ) =>  \C :: #sub(A;B;D)
  rule #sub( A:Name ; B:Var ;  \C:Var :: D:ProcPat ) =>  \C :: #sub(A;B;D)

  // sub Name for @ProcVar in Var
  rule #sub( A:Name ; @\B:Var   ; \B     ) => *A
  rule #sub( A:Name ; @\B:Var   ; \C:Var ) => \C requires B =/=K C
  rule #sub( _:Name ; @\(_:Var) ;  A:Var ) =>  A
  // Typed
  rule #sub( A:Name ; @\B:Var ;  \B     :: D:Proc    ) =>  *A :: #sub(A;B;D)
  rule #sub( A:Name ; @\B:Var ;  \B     :: D:ProcPat ) =>  *A :: #sub(A;B;D)
  rule #sub( A:Name ; @\B:Var ; @\B     :: D:Name    ) =>   A :: #sub(A;B;D)
  rule #sub( A:Name ; @\B:Var ; @\B     :: D:NamePat ) =>   A :: #sub(A;B;D)
  rule #sub( A:Name ; @\B:Var ;  \C:Var :: D:Proc    ) =>  \C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; @\B:Var ;  \C:Var :: D:ProcPat ) =>  \C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; @\B:Var ; @\C:Var :: D:Name    ) => @\C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; @\B:Var ; @\C:Var :: D:NamePat ) => @\C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; @\B:Var ;  *C:Var :: D:Proc    ) =>  *C :: #sub(A;B;D)
  rule #sub( A:Name ; @\B:Var ;  *C:Var :: D:ProcPat ) =>  *C :: #sub(A;B;D)
  rule #sub( A:Name ; @\B:Var ;   C:Var :: D:Name    ) =>   C :: #sub(A;B;D)
  rule #sub( A:Name ; @\B:Var ;   C:Var :: D:NamePat ) =>   C :: #sub(A;B;D)

// Recursive cases
  // sub Name for Name[Pat] in Quote[Pat]
  rule #sub( A:Name ; B:Name    ; @C:Proc    ) => @#sub(A;B;C)
  rule #sub( A:Name ; B:Name    ; @C:ProcPat ) => @#sub(A;B;C)
  rule #sub( A:Name ; B:NamePat ; @C:Proc    ) => @#sub(A;B;C)
  rule #sub( A:Name ; B:NamePat ; @C:ProcPat ) => @#sub(A;B;C)

  // sub Name for Name[Pat] in Eval[Pat]
  rule #sub( A:Name ;  B:Name    ; *C:Name    ) => *#sub(A;B;C)
  rule #sub( A:Name ;  B:Name    ; *C:NamePat ) => *#sub(A;B;C)
  rule #sub( A:Name ;  B:NamePat ; *C:Name    ) => *#sub(A;B;C)
  rule #sub( A:Name ;  B:NamePat ; *C:NamePat ) => *#sub(A;B;C)
  rule #sub( A:Var  ; @B:Proc    ;  C:Proc    ) => #sub(*A;B;C)
  rule #sub( A:Var  ; @B:Proc    ;  C:ProcPat ) => #sub(*A;B;C)
  rule #sub( A:Var  ; @B:ProcPat ;  C:Proc    ) => #sub(*A;B;C)
  rule #sub( A:Var  ; @B:ProcPat ;  C:ProcPat ) => #sub(*A;B;C)

  // sub Quote for Quote[Pat] - drop quotes
  rule #sub( @A:Proc ; @B:Proc    ; C:Name    ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:ProcPat ; C:Name    ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:Proc    ; C:NamePat ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:ProcPat ; C:NamePat ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:Proc    ; C:Proc    ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:ProcPat ; C:Proc    ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:Proc    ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:ProcPat ; C:ProcPat ) => #sub(A;B;C)

  // sub Name for Name[Pat] in Receive -- only substitute free variables in channel and continuation
    // if substitution variables are all listening variables and not receive variables, then no substitution occurs
  rule #sub( _:Name ;  B:Name    ; Rec:Receive ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
  rule #sub( _:Name ;  B:Name    ; Rec:RecPat  ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
  rule #sub( _:Name ;  B:NamePat ; Rec:Receive ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
  rule #sub( _:Name ;  B:NamePat ; Rec:RecPat  ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
    // if substitution variables are distinct from free variables in Rec, then no substitution occurs
  rule #sub( _:Name ;  B:Name    ; Rec:Receive ) => Rec requires intersectSet(#FV(B),#FV(Rec)) ==K .Set
  rule #sub( _:Name ;  B:Name    ; Rec:RecPat  ) => Rec requires intersectSet(#FV(B),#FV(Rec)) ==K .Set
  rule #sub( _:Name ;  B:NamePat ; Rec:Receive ) => Rec requires intersectSet(#FV(B),#FV(Rec)) ==K .Set
  rule #sub( _:Name ;  B:NamePat ; Rec:RecPat  ) => Rec requires intersectSet(#FV(B),#FV(Rec)) ==K .Set
    // substituting for Var -- if Var is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Name ;  B:Var     ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
  rule #sub( A:Name ;  B:Var     ; Rec:RecPat  ) => #if (B in #LV(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
    // substituting for @ProcVar -- if ProcVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Name ; @B:ProcVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(*A;B;Rec) #else #subRec(*A;B;Rec) #fi
  rule #sub( A:Name ; @B:ProcVar ; Rec:RecPat  ) => #if (B in #LV(Rec)) #then #subChan(*A;B;Rec) #else #subRec(*A;B;Rec) #fi

    // if substitution variable is a listening variable,
    // then it is only substituted in the channel (not in the guard or continuation)
  rule #subChan( A:Name ; B:Var ; C:UGRec ) => for( #subBind(A;B;;#bind(C)) ){  #cont(C) }
  rule #subChan( A:Name ; B:Var ; C:GRec  ) => for( #subBind(A;B;;#bind(C)) if #guard(C) ){#cont(C)}
    // if substitution variable is not a listening variable, then it is substituted in the channel, (guard), and continuation
  rule #subRec(  A:Name ; B:Var ; C:UGRec ) => for( #subBind(A;B;;#bind(C)) ){ #sub(A;B; #cont(C)) }
  rule #subRec(  A:Name ; B:Var ; C:GRec  ) => for( #subBind(A;B;;#bind(C)) if #sub(A;B;#guard(C)) ){#sub(A;B; #cont(C))}

  // Binds
    // Linear
  rule #subBind( A:Name ; B:Name ;; <-  C:Name    ) =>          <- #sub(A;B;C)
  rule #subBind( A:Name ; B:Name ;; <-  C:NamePat ) =>          <- #sub(A;B;C)
  rule #subBind( A:Name ; B:Name ;; C:Lbind       ) => #bvar(C) <- #sub(A;B;#chan(C))
  rule #subBind( A:Name ; B:Name ;; C:LbindPat    ) => #bvar(C) <- #sub(A;B;#chan(C))
  rule #subBind( A:Name ; B:Name ;; C:Lbind    & D:Lbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:Lbind    & D:LbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:LbindPat & D:Lbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:LbindPat & D:LbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Lbind    & D:Lbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:Lbind    & D:LbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:LbindPat & D:Lbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:LbindPat & D:LbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)
    // Peek
  rule #subBind( A:Name ; B:Name ;; <<- C:Name    ) =>          <<- #sub(A;B;C)
  rule #subBind( A:Name ; B:Name ;; <<- C:NamePat ) =>          <<- #sub(A;B;C)
  rule #subBind( A:Name ; B:Name ;; C:Pbind       ) => #bvar(C) <<- #sub(A;B;#chan(C))
  rule #subBind( A:Name ; B:Name ;; C:PbindPat    ) => #bvar(C) <<- #sub(A;B;#chan(C))
  rule #subBind( A:Name ; B:Name ;; C:Pbind    & D:Pbind     ) =>  #subBind(A;B;;C) & #subBind(A;B;;D)
// rule #subBind( A:Name ; B:Name ;; C:Pbind    & D:PbindPat  ) =>  #subBind(A;B;;C) & #subBind(A;B;;D)
// rule #subBind( A:Name ; B:Name ;; C:PbindPat & D:Pbind     ) =>  #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:PbindPat & D:PbindPat  ) =>  #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Pbind    & D:Pbinds    ) =>  #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:Pbind    & D:PbindPats ) =>  #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:PbindPat & D:Pbinds    ) =>  #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:PbindPat & D:PbindPats ) =>  #subBind(A;B;;C) & #subBind(A;B;;D)
    // Repeated
  rule #subBind( A:Name ; B:Name ;; <=  C:Name    ) =>          <= #sub(A;B;C)
  rule #subBind( A:Name ; B:Name ;; <=  C:NamePat ) =>          <= #sub(A;B;C)
  rule #subBind( A:Name ; B:Name ;; C:Rbind       ) => #bvar(C) <= #sub(A;B;#chan(C))
  rule #subBind( A:Name ; B:Name ;; C:RbindPat    ) => #bvar(C) <= #sub(A;B;#chan(C))
  rule #subBind( A:Name ; B:Name ;; C:Rbind    & D:Rbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:Rbind    & D:RbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:RbindPat & D:Rbind     ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:RbindPat & D:RbindPat  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Rbind    & D:Rbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:Rbind    & D:RbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)
//  rule #subBind( A:Name ; B:Name ;; C:RbindPat & D:Rbinds    ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:RbindPat & D:RbindPats ) => #subBind(A;B;;C) & #subBind(A;B;;D)

// sub Name for Var in Contract[Pat]
  rule #sub( A:Name ; B:Var ; contract C:NamePat ( D:NamePats ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Name ; B:Var ; contract C:NamePat ( D:NamePats ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Name ; B:Var ; contract C:NamePat ( D:Names    ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Name ; B:Var ; contract C:NamePat ( D:Names    ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Name ; B:Var ; contract C:Name    ( D:NamePats ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Name ; B:Var ; contract C:Name    ( D:NamePats ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Name ; B:Var ; contract C:Name    ( D:Names    ) = { E:ProcPat } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Name ; B:Var ; contract C:Name    ( D:Names    ) = { E:Proc    } )
    => #if (B in #FV(D)) #then contract #sub(A;B;C)(D)={E} #else contract #sub(A;B;C)(D)={#sub(A;B;E)} #fi
  rule #sub( A:Name ; B:Var ; contract C:NamePat ( ) = { E:ProcPat } ) => contract #sub(A;B;C)( )={#sub(A;B;E)}
  rule #sub( A:Name ; B:Var ; contract C:NamePat ( ) = { E:Proc    } ) => contract #sub(A;B;C)( )={#sub(A;B;E)}
  rule #sub( A:Name ; B:Var ; contract C:Name    ( ) = { E:ProcPat } ) => contract #sub(A;B;C)( )={#sub(A;B;E)}
  rule #sub( A:Name ; B:Var ; contract C:Name    ( ) = { E:Proc    } ) => contract #sub(A;B;C)( )={#sub(A;B;E)}
// sub Name for @ProcVar in Contract[Pat]
  rule #sub( A:Name ; @\B:Var ; contract C:NamePat ( D:NamePats ) = { E:ProcPat } )
    => #if (\B in #FV(D)) #then contract #sub(A;@\B;C)(D)={E} #else contract #sub(A;@\B;C)(D)={#sub(A;@\B;E)} #fi
  rule #sub( A:Name ; @\B:Var ; contract C:NamePat ( D:NamePats ) = { E:Proc    } )
    => #if (\B in #FV(D)) #then contract #sub(A;@\B;C)(D)={E} #else contract #sub(A;@\B;C)(D)={#sub(A;@\B;E)} #fi
  rule #sub( A:Name ; @\B:Var ; contract C:NamePat ( D:Names    ) = { E:ProcPat } )
    => #if (\B in #FV(D)) #then contract #sub(A;@\B;C)(D)={E} #else contract #sub(A;@\B;C)(D)={#sub(A;@\B;E)} #fi
  rule #sub( A:Name ; @\B:Var ; contract C:NamePat ( D:Names    ) = { E:Proc    } )
    => #if (\B in #FV(D)) #then contract #sub(A;@\B;C)(D)={E} #else contract #sub(A;@\B;C)(D)={#sub(A;@\B;E)} #fi
  rule #sub( A:Name ; @\B:Var ; contract C:Name    ( D:NamePats ) = { E:ProcPat } )
    => #if (\B in #FV(D)) #then contract #sub(A;@\B;C)(D)={E} #else contract #sub(A;@\B;C)(D)={#sub(A;@\B;E)} #fi
  rule #sub( A:Name ; @\B:Var ; contract C:Name    ( D:NamePats ) = { E:Proc    } )
    => #if (\B in #FV(D)) #then contract #sub(A;@\B;C)(D)={E} #else contract #sub(A;@\B;C)(D)={#sub(A;@\B;E)} #fi
  rule #sub( A:Name ; @\B:Var ; contract C:Name    ( D:Names    ) = { E:ProcPat } )
    => #if (\B in #FV(D)) #then contract #sub(A;@\B;C)(D)={E} #else contract #sub(A;@\B;C)(D)={#sub(A;@\B;E)} #fi
  rule #sub( A:Name ; @\B:Var ; contract C:Name    ( D:Names    ) = { E:Proc    } )
    => #if (\B in #FV(D)) #then contract #sub(A;@\B;C)(D)={E} #else contract #sub(A;@\B;C)(D)={#sub(A;@\B;E)} #fi
  rule #sub( A:Name ; @\B:Var ; contract C:NamePat ( ) = { E:ProcPat } ) => contract #sub(A;@\B;C)( )={#sub(A;@\B;E)}
  rule #sub( A:Name ; @\B:Var ; contract C:NamePat ( ) = { E:Proc    } ) => contract #sub(A;@\B;C)( )={#sub(A;@\B;E)}
  rule #sub( A:Name ; @\B:Var ; contract C:Name    ( ) = { E:ProcPat } ) => contract #sub(A;@\B;C)( )={#sub(A;@\B;E)}
  rule #sub( A:Name ; @\B:Var ; contract C:Name    ( ) = { E:Proc    } ) => contract #sub(A;@\B;C)( )={#sub(A;@\B;E)}

// sub Name for Name[Pat] in Invocation[Pat]
  rule #sub( A:Name ; B:Name    ; C:NamePat ( D:NamePats ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:NamePat ( D:Names    ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:NamePat (            ) ) => #sub(A;B;C)(             )
  rule #sub( A:Name ; B:Name    ; C:Name    ( D:NamePats ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:Name    ( D:Names    ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:Name    (            ) ) => #sub(A;B;C)(             )
  rule #sub( A:Name ; B:NamePat ; C:NamePat ( D:NamePats ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:NamePat ( D:Names    ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:NamePat (            ) ) => #sub(A;B;C)(             )
  rule #sub( A:Name ; B:NamePat ; C:Name    ( D:NamePats ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:Name    ( D:Names    ) ) => #sub(A;B;C)( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:Name    (            ) ) => #sub(A;B;C)(             )

// sub Name for Var in Match[Pat]
  rule #sub( A:Name ; B:Var ; match C:Proc    { D:MatchCases } ) => match #sub(A;B;C) {#subMatch(A;B;D)}
  rule #sub( A:Name ; B:Var ; match C:Proc    { D:MCasePats  } ) => match #sub(A;B;C) {#subMatch(A;B;D)}
  rule #sub( A:Name ; B:Var ; match C:ProcPat { D:MatchCases } ) => match #sub(A;B;C) {#subMatch(A;B;D)}
  rule #sub( A:Name ; B:Var ; match C:ProcPat { D:MCasePats  } ) => match #sub(A;B;C) {#subMatch(A;B;D)}
  // MatchCases
  rule #subMatch( A:Name ; B:Var ; { C:Proc    } |=> D:Proc )
    => #if (B in #FV(C)) #then {C}|=>D #else {C} |=> #sub(A;B;D) #fi
  rule #subMatch( A:Name ; B:Var ; { C:Proc    } |=> D:ProcPat )
    => #if (B in #FV(C)) #then {C}|=>D #else {C} |=> #sub(A;B;D) #fi
  rule #subMatch( A:Name ; B:Var ; { C:ProcPat } |=> D:Proc )
    => #if (B in #FV(C)) #then {C}|=>D #else {C} |=> #sub(A;B;D) #fi
  rule #subMatch( A:Name ; B:Var ; { C:ProcPat } |=> D:ProcPat )
    => #if (B in #FV(C)) #then {C}|=>D #else {C} |=> #sub(A;B;D) #fi
  rule #subMatch( A:Name ; B:Name ; C:MatchCase D:MatchCases ) => #subMatch(A;B;C) #subMatch(A;B;D)
  rule #subMatch( A:Name ; B:Name ; C:MatchCase D:MCasePats  ) => #subMatch(A;B;C) #subMatch(A;B;D)
  rule #subMatch( A:Name ; B:Name ; C:MCasePat  D:MatchCases ) => #subMatch(A;B;C) #subMatch(A;B;D)
  rule #subMatch( A:Name ; B:Name ; C:MCasePat  D:MCasePats  ) => #subMatch(A;B;C) #subMatch(A;B;D)

// sub Name for Var in Select[Pat]
  rule #sub( A:Name ; B:Var ; select { C:Branches   } ) => select {#subBranch(A;B;C)}
  rule #sub( A:Name ; B:Var ; select { C:BranchPats } ) => select {#subBranch(A;B;C)}
  // Branches
  rule #subBranch( A:Name ; B:Var ; C:Branch )
    => #if (B in #LV(C))
       #then {#subBind(A;B;;#bind(C))} |=> #cont(C)
       #else {#subBind(A;B;;#bind(C))} |=> #sub(A;B;#cont(C)) #fi
  rule #subBranch( A:Name ; B:Var ; C:BranchPat )
    => #if (B in #LV(C))
       #then {#subBind(A;B;;#bind(C))} |=> #cont(C)
       #else {#subBind(A;B;;#bind(C))} |=> #sub(A;B;#cont(C)) #fi
  rule #subBranch( A:Name ; B:Name ; C:Branch    D:Branches   ) => #subBranch(A;B;C) #subBranch(A;B;D)
  rule #subBranch( A:Name ; B:Name ; C:Branch    D:BranchPats ) => #subBranch(A;B;C) #subBranch(A;B;D)
  rule #subBranch( A:Name ; B:Name ; C:BranchPat D:Branches   ) => #subBranch(A;B;C) #subBranch(A;B;D)
  rule #subBranch( A:Name ; B:Name ; C:BranchPat D:BranchPats ) => #subBranch(A;B;C) #subBranch(A;B;D)

// VarRef -- TODO: test
  rule #sub( @A:BoundProc ; B:Var ; =*B     ) => = A
  rule #sub(  A:BoundName ; B:Var ; =*B     ) => =*A
  rule #sub( @A:Proc      ; B:Var ; =*B     ) =>   A requires notBool isBoundProc(A)
  rule #sub(  A:Name      ; B:Var ; =*B     ) =>  *A requires notBool isBoundName(A)
  rule #sub( @A:Proc      ; B:Var ; =*C:Var ) => =*C requires B =/=K C
  rule #sub(  A:Name      ; B:Var ; =*C:Var ) => =*C requires B =/=K C

// Let expressions -- TODO: other LetExps
  rule #sub( A:Name ;  B:Var     ; let C:ProcVar <- D:Proc in { E:Proc } ) => let C <- #sub(A;B;D) in { #sub(A;B;E) }
  rule #sub( A:Name ; @B:ProcVar ; let C:ProcVar <- D:Proc in { E:Proc } )
    => #if B ==K C #then let C <- #sub(A;@B;D) in {E} #else let C <- #sub(A;@B;D) in { #sub(A;@B;E) } #fi

// sub Name for Name[Pat] in Method
  rule #sub( A:Name ; B:Name    ; C:Proc D:MethodAndArgs ) => #sub(A;B;C) #subMethod(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Proc D:MethodAndArgs ) => #sub(A;B;C) #subMethod(A;B;D)
  // MethodAndArgs sub
  rule #subMethod( _:Name ; _:Name    ; . C:Method ( ) ) => .C( )
  rule #subMethod( _:Name ; _:NamePat ; . C:Method ( ) ) => .C( )
  rule #subMethod( A:Name ; B:Name    ; . C:Method ( D:Procs ) ) => .C( #sub(A;B;D) )
  rule #subMethod( A:Name ; B:NamePat ; . C:Method ( D:Procs ) ) => .C( #sub(A;B;D) )

  // sub Name for Name[Pat] in Send[Pat]
  rule #sub( A:Name ; B:Name    ; C:NamePat !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:NamePat !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:NamePat !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Name ; B:Name    ; C:Name    !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:Name    !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:Name    !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Name ; B:Name    ; C:NamePat !! ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:NamePat !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:NamePat !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Name ; B:Name    ; C:Name    !! ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:Name    !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; C:Name    !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Name ; B:NamePat ; C:NamePat !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:NamePat !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:NamePat !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Name ; B:NamePat ; C:Name    !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:Name    !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:Name    !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Name ; B:NamePat ; C:NamePat !! ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:NamePat !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:NamePat !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Name ; B:NamePat ; C:Name    !! ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:Name    !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; C:Name    !! (            ) ) => #sub(A;B;C) !! (             )

  // sub Name for Name[Pat] in Par[Pat]
  rule #sub( A:Name ; B:Name    ; C:Proc    | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:Proc    | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:ProcPat | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:ProcPat | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Proc    | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Proc    | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:ProcPat | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:ProcPat | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D)

  // sub Name for Name[Pat] in Collections
    // RhoList
  rule #sub( _:Name ; _:Name    ; [ ] ) => [ ]
  rule #sub( _:Name ; _:NamePat ; [ ] ) => [ ]
  rule #sub( A:Name ; B:Name    ; [ C:Procs    ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Name ; B:Name    ; [ C:ProcPats ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Name ; B:NamePat ; [ C:Procs    ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Name ; B:NamePat ; [ C:ProcPats ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Name ; B:Name    ; [ C:Procs    ... D:ProcVar ] ) => [ #sub(A;B;C) ... #sub(A;B;D) ]
  rule #sub( A:Name ; B:Name    ; [ C:ProcPats ... D:ProcVar ] ) => [ #sub(A;B;C) ... #sub(A;B;D) ]
  rule #sub( A:Name ; B:NamePat ; [ C:Procs    ... D:ProcVar ] ) => [ #sub(A;B;C) ... #sub(A;B;D) ]
  rule #sub( A:Name ; B:NamePat ; [ C:ProcPats ... D:ProcVar ] ) => [ #sub(A;B;C) ... #sub(A;B;D) ]
    // RhoMap
  rule #sub( _:Name ; _:Name    ; { } ) => { }
  rule #sub( _:Name ; _:NamePat ; { } ) => { }
  rule #sub( A:Name ; B:Name    ; { C:RhoKVPairs } ) => { #subKV(A;B;C) }
  rule #sub( A:Name ; B:Name    ; { C:RhoKVPats  } ) => { #subKV(A;B;C) }
  rule #sub( A:Name ; B:NamePat ; { C:RhoKVPairs } ) => { #subKV(A;B;C) }
  rule #sub( A:Name ; B:NamePat ; { C:RhoKVPats  } ) => { #subKV(A;B;C) }
  rule #sub( A:Name ; B:Name    ; { C:RhoKVPairs ... D:ProcVar } ) => { #subKV(A;B;C) ... #sub(A;B;D) }
  rule #sub( A:Name ; B:Name    ; { C:RhoKVPats  ... D:ProcVar } ) => { #subKV(A;B;C) ... #sub(A;B;D) }
  rule #sub( A:Name ; B:NamePat ; { C:RhoKVPairs ... D:ProcVar } ) => { #subKV(A;B;C) ... #sub(A;B;D) }
  rule #sub( A:Name ; B:NamePat ; { C:RhoKVPats  ... D:ProcVar } ) => { #subKV(A;B;C) ... #sub(A;B;D) }
      // RhoKVPairs
  rule #subKV( A:Name ; B:Name    ; C:Proc    : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:Name    ; C:Proc    : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:Name    ; C:ProcPat : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:Name    ; C:ProcPat : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:NamePat ; C:Proc    : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:NamePat ; C:Proc    : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:NamePat ; C:ProcPat : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:NamePat ; C:ProcPat : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:Name    ; C:RhoKVPair , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:Name    ; C:RhoKVPair , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:Name    ; C:RhoKVPat  , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:Name    ; C:RhoKVPat  , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:NamePat ; C:RhoKVPair , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:NamePat ; C:RhoKVPair , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:NamePat ; C:RhoKVPat  , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:NamePat ; C:RhoKVPat  , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
    // RhoSet/SetPat
  rule #sub( _:Name ; _:Name    ; Set( ) ) => Set( )
  rule #sub( _:Name ; _:NamePat ; Set( ) ) => Set( )
  rule #sub( A:Name ; B:Name    ; Set( C:Procs    ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Name ; B:Name    ; Set( C:ProcPats ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Name ; B:NamePat ; Set( C:Procs    ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Name ; B:NamePat ; Set( C:ProcPats ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Name ; B:Name    ; Set( C:Procs    ... D:ProcVar ) ) => Set( #sub(A;B;C) ... #sub(A;B;D) )
  rule #sub( A:Name ; B:Name    ; Set( C:ProcPats ... D:ProcVar ) ) => Set( #sub(A;B;C) ... #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; Set( C:Procs    ... D:ProcVar ) ) => Set( #sub(A;B;C) ... #sub(A;B;D) )
  rule #sub( A:Name ; B:NamePat ; Set( C:ProcPats ... D:ProcVar ) ) => Set( #sub(A;B;C) ... #sub(A;B;D) )
    // RhoTuple/TuplePat
  rule #sub( A:Name ; B:Name    ; ( C:Procs    ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Name ; B:Name    ; ( C:ProcPats ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Name ; B:NamePat ; ( C:Procs    ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Name ; B:NamePat ; ( C:ProcPats ,) ) => ( #sub(A;B;C) ,)

  // sub Name for Name in New[Pat]
  // if substitution variable is bound, no substitution occurs, else substitute in Proc[Pat]
  rule #sub(    A:Name ; B:Var  ; C:New    ) => #if (B in #DV(C)) #then C #else #subNew(A;B;C) #fi
  rule #sub(    A:Name ; B:Var  ; C:NewPat ) => #if (B in #DV(C)) #then C #else #subNew(A;B;C) #fi
  rule #subNew( A:Name ; B:Name    ; new C:VarDecs in { D:Proc    } ) => new C in { #sub(A;B;D) }
       requires intersectSet(#FV(B),#DV(C)) ==K .Set
  rule #subNew( A:Name ; B:Name    ; new C:VarDecs in { D:ProcPat } ) => new C in { #sub(A;B;D) }
       requires intersectSet(#FV(B),#DV(C)) ==K .Set
  rule #subNew( A:Name ; B:NamePat ; new C:VarDecs in { D:Proc    } ) => new C in { #sub(A;B;D) }
       requires intersectSet(#FV(B),#DV(C)) ==K .Set
  rule #subNew( A:Name ; B:NamePat ; new C:VarDecs in { D:ProcPat } ) => new C in { #sub(A;B;D) }
       requires intersectSet(#FV(B),#DV(C)) ==K .Set

/* TODO: delete?
  rule #subNew+( A:Var ; B:Var ; C:New )
    => #if B in #DV(C)
       #then new #subDec(A;B;#dec(C)) in { #sub(A;B;#newproc(C)) }
       #else new #dec(C) in { #sub(A;B;#newproc(C)) } #fi
  rule #subDec( A:Var ; B:Var ; C:Var ) => #sub(A;B;C)
  rule #subDec( A:Var ; B:Var ; C:Var ( D:Uri ) ) => #subVar(A;B;C) (D)
  rule #subDec( A:Var ; B:Var ; C:VarDec , D:VarDecs ) => #subDec(A;B;C) , #subDec(A;B;D)
*/
// sub Name for Name[Pat] in Exp
// Arithmetic Exps
  rule #sub( A:Name ; B:Name    ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Name ; B:Name    ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Name ; B:NamePat ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
// String expressions
  rule #sub( A:Name ; B:Name    ; C:ListOrVar   ++ D:ListOrVar   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:ListOrVar   ++ D:ConcatList  ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:StringOrVar ++ D:StringOrVar ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:StringOrVar ++ D:ConcatStr   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:StringOrVar %% D:RhoMap      ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:StringOrVar %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:RhoMap      %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:ListOrVar   ++ D:ListOrVar   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:ListOrVar   ++ D:ConcatList  ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:StringOrVar ++ D:StringOrVar ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:StringOrVar ++ D:ConcatStr   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:StringOrVar %% D:RhoMap      ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:StringOrVar %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:RhoMap      %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)

// Boolean Exps
  rule #sub( A:Name ; B:Name    ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Name ; B:Name    ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:Proc    matches D:Proc    ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:Proc    matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:ProcPat matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Name ; B:NamePat ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Proc    matches D:Proc    ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:Proc    matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:ProcPat matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)

// Condtionals
  rule #sub( A:Name ; B:Name    ;   if (C:BExp) D:Proc ) => if (#sub(A;B;C)) #sub(A;B;D)
  rule #sub( A:Name ; B:Name    ; C:IfThen else D:Proc ) => #sub(A;B;C) else #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ;   if (C:BExp) D:Proc ) => if (#sub(A;B;C)) #sub(A;B;D)
  rule #sub( A:Name ; B:NamePat ; C:IfThen else D:Proc ) => #sub(A;B;C) else #sub(A;B;D)

// sub Names for Name[Pat]s
// only applies after successful #match so lengths are assumed equal
  // sub Names for Names in Name[Pat] & Proc[Pat]
  rule #sub( A:Name , B:Names ; C:Name    , D:Names    ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:Name    , D:Names    ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:Name    , D:Names    ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:Name    , D:Names    ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  // sub Names for Name[Pat]s in Name[Pat] & Proc[Pat]
  rule #sub( A:Name , B:Names ; C:Name    , D:NamePats ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:Names    ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:NamePats ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:Name    , D:NamePats ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:Names    ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:NamePats ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:Name    , D:NamePats ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:Names    ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:NamePats ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:Name    , D:NamePats ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:Names    ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:NamePats ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  // sub Names for Name[Pat]s in Name[Pat]s & Proc[Pat]s
  rule #sub( A:Names ; B:Names    ; C:Name    , D:Names    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:Names    ; C:Name    , D:NamePats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:Names    ; C:NamePat , D:Names    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:Names    ; C:NamePat , D:NamePats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:NamePats ; C:Name    , D:Names    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:NamePats ; C:Name    , D:NamePats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:NamePats ; C:NamePat , D:Names    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:NamePats ; C:NamePat , D:NamePats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:Names    ; C:Proc    , D:Procs    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:Names    ; C:Proc    , D:ProcPats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:Names    ; C:ProcPat , D:Procs    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:Names    ; C:ProcPat , D:ProcPats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:NamePats ; C:Proc    , D:Procs    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:NamePats ; C:Proc    , D:ProcPats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:NamePats ; C:ProcPat , D:Procs    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Names ; B:NamePats ; C:ProcPat , D:ProcPats ) => #sub(A;B;C) , #sub(A;B;D)

// sub Name for Name[Pat] in Map
  rule #sub( _:Name ; _:Name    ;  .Map ) => .Map
  rule #sub( _:Name ; _:NamePat ;  .Map ) => .Map
  rule #sub( A:Name ; B:Name    ; C:Proc |-> D:Proc E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Name ; B:NamePat ; C:Proc |-> D:Proc E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Name ; B:Name    ; C:Name |-> D:Name E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Name ; B:NamePat ; C:Name |-> D:Name E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)

//-----------------------
//--- Deeper Patterns ---
//-----------------------
// TODO: simplify
// sub Send for Send[Pat] - sub channel for channel and message(s) for message(s)
  rule #sub( A:Name    !  (            ) ; B:Name    !  (            ) ; E:Proc    ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:Procs    ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:Name    !  ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:NamePat !  (            ) ; E:Proc    ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  (            ) ; B:NamePat !  (            ) ; E:Proc    ) => #sub(A;B;E)
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:Name    !! (            ) ; E:Proc    ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:Procs    ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:Name    !! ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:NamePat !! (            ) ; E:Proc    ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! (            ) ; B:NamePat !! (            ) ; E:Proc    ) => #sub(A;B;E)
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:Name    !  (            ) ; E:ProcPat ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:Procs    ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:Name    !  ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:NamePat !  (            ) ; E:ProcPat ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  (            ) ; B:NamePat !  (            ) ; E:ProcPat ) => #sub(A;B;E)
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:Name    !! (            ) ; E:ProcPat ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:Procs    ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:Name    !! ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:NamePat !! (            ) ; E:ProcPat ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! (            ) ; B:NamePat !! (            ) ; E:ProcPat ) => #sub(A;B;E)
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:Name    !  (            ) ; E:Name    ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:Procs    ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:Name    !  ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:NamePat !  (            ) ; E:Name    ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  (            ) ; B:NamePat !  (            ) ; E:Name    ) => #sub(A;B;E)
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:Name    !! (            ) ; E:Name    ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:Procs    ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:Name    !! ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:NamePat !! (            ) ; E:Name    ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! (            ) ; B:NamePat !! (            ) ; E:Name    ) => #sub(A;B;E)
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:Name    !  (            ) ; E:NamePat ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:Procs    ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:Name    !  ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:NamePat !  (            ) ; E:NamePat ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  (            ) ; B:NamePat !  (            ) ; E:NamePat ) => #sub(A;B;E)
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:Name    !! (            ) ; E:NamePat ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:Procs    ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:Name    !! ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:NamePat !! (            ) ; E:NamePat ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! (            ) ; B:NamePat !! (            ) ; E:NamePat ) => #sub(A;B;E)
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:NamePat ) => #sub(B;D;#sub(A;C;E))

// TODO: simplify & more testing!!!
// sub Receive for Receive/RecPat
  // assumed to have passed #match -- matching binds, channels, and continuations
    // unguarded -- substitute channels, then continuations with listening variables hidden
  rule #sub( A:UGRec    ; B:UGRec    ; C:Name    )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRec    ; B:UGRecPat ; C:Name    )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRec    ; B:UGRec    ; C:NamePat )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRec    ; B:UGRecPat ; C:NamePat )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRec    ; B:UGRec    ; C:Proc    )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRec    ; B:UGRecPat ; C:Proc    )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRec    ; B:UGRec    ; C:ProcPat )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRec    ; B:UGRecPat ; C:ProcPat )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
    // guarded -- substitute channels, then guards with listening variables hidden,
    //            then continuations with listening variables hidden
  rule #sub( A:GRec     ; B:GRec     ; C:Name    )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRec     ; B:GRecPat  ; C:Name    )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRec     ; B:GRec     ; C:NamePat )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRec     ; B:GRecPat  ; C:NamePat )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRec     ; B:GRec     ; C:Proc    )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRec     ; B:GRecPat  ; C:Proc    )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRec     ; B:GRec     ; C:ProcPat )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRec     ; B:GRecPat  ; C:ProcPat )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))

// sub RecPat for RecPat
  // unguarded
  rule #sub( A:UGRecPat ; B:UGRecPat ; C:Name )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRecPat ; B:UGRecPat ; C:NamePat )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRecPat ; B:UGRecPat ; C:Proc )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  rule #sub( A:UGRecPat ; B:UGRecPat ; C:ProcPat )
    => #sub(#sub(#mapSub(#LV(A));#cont(A));#sub(#mapSub(#LV(B));#cont(B));#sub(#chan(A);#chan(B);C))
  // guarded
  rule #sub( A:GRecPat  ; B:GRecPat  ; C:Name    )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRecPat  ; B:GRecPat  ; C:NamePat )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRecPat  ; B:GRecPat  ; C:Proc    )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))
  rule #sub( A:GRecPat  ; B:GRecPat  ; C:ProcPat )
    => #sub(#sub(#mapSub(#LV(A)); #cont(A));#sub(#mapSub(#LV(B)); #cont(B));
       #sub(#sub(#mapSub(#LV(A));#guard(A));#sub(#mapSub(#LV(B));#guard(B));#sub(#chan(A);#chan(B);C)))

// sub Par for Par[Pat] -- applied after normalization; Pars match
  // order of substitution is irrelevant as all variables must be unique
  rule #sub( A:Proc | B:Proc ; C:Proc    | D:Proc    ; E:Name    ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:Proc    | D:ProcPat ; E:Name    ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:ProcPat | D:Proc    ; E:Name    ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isParPat(C))
  rule #sub( A:Proc | B:Proc ; C:ProcPat | D:ProcPat ; E:Name    ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isParPat(C))
  rule #sub( A:Proc | B:Proc ; C:Proc    | D:Proc    ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:Proc    | D:ProcPat ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:ProcPat | D:Proc    ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isParPat(C))
  rule #sub( A:Proc | B:Proc ; C:ProcPat | D:ProcPat ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isParPat(C))
  rule #sub( A:Proc | B:Proc ; C:Proc    | D:Proc    ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:Proc    | D:ProcPat ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:ProcPat | D:Proc    ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isParPat(C))
  rule #sub( A:Proc | B:Proc ; C:ProcPat | D:ProcPat ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isParPat(C))
  rule #sub( A:Proc | B:Proc ; C:Proc    | D:Proc    ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:Proc    | D:ProcPat ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:ProcPat | D:Proc    ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isParPat(C))
  rule #sub( A:Proc | B:Proc ; C:ProcPat | D:ProcPat ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
       requires notBool (isPar(A) orBool isParPat(C))

// TODO: other productions

//----------------
//--- Patterns ---
//----------------
// Fundamental cases -- WildCard
  rule #sub( _:Proc    ; _:Proc    ; \_        ) => \_
  rule #sub( _:Proc    ; _:ProcPat ; \_        ) => \_
  rule #sub( _:Name    ; _:Name    ; \_        ) => \_
  rule #sub( _:Name    ; _:NamePat ; \_        ) => \_
  rule #sub( _:ProcPat ;    \_     ; A:ProcPat ) => A
  rule #sub( _:ProcPat ;    \_     ; A:Proc    ) => A
  rule #sub( _:Proc    ;    \_     ; A:ProcPat ) => A
  rule #sub( _:Proc    ;    \_     ; A:Proc    ) => A
  rule #sub( _:NamePat ;    \_     ; A:ProcPat ) => A
  rule #sub( _:NamePat ;    \_     ; A:Proc    ) => A
  rule #sub( _:Name    ;    \_     ; A:ProcPat ) => A
  rule #sub( _:Name    ;    \_     ; A:Proc    ) => A
  rule #sub( _:ProcPat ;    \_     ; A:NamePat ) => A
  rule #sub( _:ProcPat ;    \_     ; A:Name    ) => A
  rule #sub( _:Proc    ;    \_     ; A:NamePat ) => A
  rule #sub( _:Proc    ;    \_     ; A:Name    ) => A
  rule #sub( _:NamePat ;    \_     ; A:NamePat ) => A
  rule #sub( _:NamePat ;    \_     ; A:Name    ) => A
  rule #sub( _:Name    ;    \_     ; A:NamePat ) => A
  rule #sub( _:Name    ;    \_     ; A:Name    ) => A
/*
// Pattern Variable
  rule #sub( A:Name    ; B:PatVar ; B        ) => A
  rule #sub( _:Name    ; B:PatVar ; C:PatVar ) => B requires B =/=K C
  rule #sub( A:NamePat ; B:PatVar ; B        ) => A
  rule #sub( _:NamePat ; B:PatVar ; C:PatVar ) => B requires B =/=K C
  rule #sub( A:Proc    ; B:PatVar ; B        ) => A
  rule #sub( _:Proc    ; B:PatVar ; C:PatVar ) => B requires B =/=K C
  rule #sub( A:ProcPat ; B:PatVar ; B        ) => A
  rule #sub( _:ProcPat ; B:PatVar ; C:PatVar ) => B requires B =/=K C
*/
  // TODO: sub for Uri for #match

// Recusive cases -- destructuring substitution Proc or Name
  // sub Proc for Proc in @ProcPat
  rule #sub(  A:Proc ;  B:Proc ; @C:ProcPat ) => @#sub(A;B;C) // TODO: delete

  // sub Proc for Proc in EvalPat
  rule #sub(  A:Proc ;  B:Proc ; *C:NamePat ) => *#sub(A;B;C) // TODO: delete

  // sub Eval for Eval in ProcPat
  rule #sub( *A:Name ; *B:Name ;  C:ProcPat ) =>  #sub(A;B;C) // TODO: delete

  // sub Proc for Proc in SendPat -- sub in channel and continuation
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name    !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! ( D:ProcPats ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name    !! ( D:ProcPats ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

// sub Proc for SimplePat
  // this is only called after successful #match
  rule #sub( _:Proc ; _:SimplePat     ; A:Proc ) => A
  rule #sub( _:Name ; _:SimpleNamePat ; A:Proc ) => A

// SimplePat -- not changed by substitution
  rule #sub( _:Name    ; _:Name    ; A:SimplePat ) => A
  rule #sub( _:Name    ; _:NamePat ; A:SimplePat ) => A
  rule #sub( _:NamePat ; _:NamePat ; A:SimplePat ) => A
  rule #sub( _:Proc    ; _:Proc    ; A:SimplePat ) => A
  rule #sub( _:Proc    ; _:ProcPat ; A:SimplePat ) => A
  rule #sub( _:ProcPat ; _:ProcPat ; A:SimplePat ) => A

// sub into PatExp
  // PatNeg
  rule #sub( A:Name    ; B:Name    ; ~ C:Proc    ) => ~ #sub(A;B;C)
  rule #sub( A:Name    ; B:NamePat ; ~ C:Proc    ) => ~ #sub(A;B;C)
  rule #sub( A:NamePat ; B:NamePat ; ~ C:Proc    ) => ~ #sub(A;B;C)
  rule #sub( A:Name    ; B:Name    ; ~ C:ProcPat ) => ~ #sub(A;B;C)
  rule #sub( A:Name    ; B:NamePat ; ~ C:ProcPat ) => ~ #sub(A;B;C)
  rule #sub( A:NamePat ; B:NamePat ; ~ C:ProcPat ) => ~ #sub(A;B;C)
  rule #sub( A:Proc    ; B:Proc    ; ~ C:Proc    ) => ~ #sub(A;B;C)
  rule #sub( A:Proc    ; B:ProcPat ; ~ C:Proc    ) => ~ #sub(A;B;C)
  rule #sub( A:ProcPat ; B:ProcPat ; ~ C:Proc    ) => ~ #sub(A;B;C)
  rule #sub( A:Proc    ; B:Proc    ; ~ C:ProcPat ) => ~ #sub(A;B;C)
  rule #sub( A:Proc    ; B:ProcPat ; ~ C:ProcPat ) => ~ #sub(A;B;C)
  rule #sub( A:ProcPat ; B:ProcPat ; ~ C:ProcPat ) => ~ #sub(A;B;C)
  // PatAnd
  rule #sub( A:Name    ; B:Name    ; C:Proc    /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Name    ; B:NamePat ; C:Proc    /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:NamePat ; B:NamePat ; C:Proc    /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Name    ; B:Name    ; C:Proc    /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Name    ; B:NamePat ; C:Proc    /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:NamePat ; B:NamePat ; C:Proc    /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Name    ; B:Name    ; C:ProcPat /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Name    ; B:NamePat ; C:ProcPat /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:NamePat ; B:NamePat ; C:ProcPat /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Name    ; B:Name    ; C:ProcPat /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Name    ; B:NamePat ; C:ProcPat /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:NamePat ; B:NamePat ; C:ProcPat /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Proc    ; B:Proc    ; C:Proc    /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Proc    ; B:ProcPat ; C:Proc    /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:ProcPat ; B:ProcPat ; C:Proc    /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Proc    ; B:Proc    ; C:Proc    /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Proc    ; B:ProcPat ; C:Proc    /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:ProcPat ; B:ProcPat ; C:Proc    /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Proc    ; B:Proc    ; C:ProcPat /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Proc    ; B:ProcPat ; C:ProcPat /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:ProcPat ; B:ProcPat ; C:ProcPat /\ D:Proc    ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Proc    ; B:Proc    ; C:ProcPat /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:Proc    ; B:ProcPat ; C:ProcPat /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  rule #sub( A:ProcPat ; B:ProcPat ; C:ProcPat /\ D:ProcPat ) => #sub(A;B;C) /\ #sub(A;B;D)
  // PatOr
  rule #sub( A:Name    ; B:Name    ; C:Proc    \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Name    ; B:NamePat ; C:Proc    \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:NamePat ; B:NamePat ; C:Proc    \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Name    ; B:Name    ; C:Proc    \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Name    ; B:NamePat ; C:Proc    \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:NamePat ; B:NamePat ; C:Proc    \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Name    ; B:Name    ; C:ProcPat \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Name    ; B:NamePat ; C:ProcPat \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:NamePat ; B:NamePat ; C:ProcPat \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Name    ; B:Name    ; C:ProcPat \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Name    ; B:NamePat ; C:ProcPat \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:NamePat ; B:NamePat ; C:ProcPat \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Proc    ; B:Proc    ; C:Proc    \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Proc    ; B:ProcPat ; C:Proc    \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:ProcPat ; B:ProcPat ; C:Proc    \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Proc    ; B:Proc    ; C:Proc    \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Proc    ; B:ProcPat ; C:Proc    \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:ProcPat ; B:ProcPat ; C:Proc    \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Proc    ; B:Proc    ; C:ProcPat \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Proc    ; B:ProcPat ; C:ProcPat \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:ProcPat ; B:ProcPat ; C:ProcPat \/ D:Proc    ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Proc    ; B:Proc    ; C:ProcPat \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:Proc    ; B:ProcPat ; C:ProcPat \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)
  rule #sub( A:ProcPat ; B:ProcPat ; C:ProcPat \/ D:ProcPat ) => #sub(A;B;C) \/ #sub(A;B;D)

// sub Name for NamePat
  rule #sub(  A:Var  ; @B:ProcPat ; C:Name    ) => #sub(*A;B;C) requires notBool isWildCard(B)
  rule #sub( @A:Proc ; @B:ProcPat ; C:Name    ) => #sub( A;B;C) requires notBool isWildCard(B)
  rule #sub(  A:Var  ; @B:ProcPat ; C:NamePat ) => #sub(*A;B;C) requires notBool isWildCard(B)
  rule #sub( @A:Proc ; @B:ProcPat ; C:NamePat ) => #sub( A;B;C) requires notBool isWildCard(B)
  rule #sub(  A:Var  ; @B:ProcPat ; C:Proc    ) => #sub(*A;B;C) requires notBool isWildCard(B)
  rule #sub( @A:Proc ; @B:ProcPat ; C:Proc    ) => #sub( A;B;C) requires notBool isWildCard(B)
  rule #sub(  A:Var  ; @B:ProcPat ; C:ProcPat ) => #sub(*A;B;C)
       requires notBool (isWildCard(B) orBool isSimplePat(C) orBool isPatExp(C))
  rule #sub( @A:Proc ; @B:ProcPat ; C:ProcPat ) => #sub( A;B;C)
       requires notBool (isWildCard(B) orBool isSimplePat(C) orBool isPatExp(C))

// sub Proc for PatExp in Proc
  // these substitutions are only accessed after a successful #match
  // so the substituting Proc must be of the correct type
  rule #sub( _:Proc ; ~ _:Proc    ; C:Name    ) => C
  rule #sub( _:Proc ; ~ _:ProcPat ; C:Name    ) => C
  rule #sub( _:Proc ; ~ _:Proc    ; C:NamePat ) => C
  rule #sub( _:Proc ; ~ _:ProcPat ; C:NamePat ) => C
  rule #sub( _:Proc ; ~ _:Proc    ; C:Proc    ) => C
  rule #sub( _:Proc ; ~ _:ProcPat ; C:Proc    ) => C
  rule #sub( _:Proc ; ~ _:Proc    ; C:ProcPat ) => C
  rule #sub( _:Proc ; ~ _:ProcPat ; C:ProcPat ) => C
  rule #sub( A:Proc ;      B:Proc /\ _:SimplePat ; C:Name    ) => #sub(A;B;C)
  rule #sub( A:Proc ;   B:ProcPat /\ _:SimplePat ; C:Name    ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat /\ B:Proc      ; C:Name    ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat /\ B:ProcPat   ; C:Name    ) => #sub(A;B;C)
  rule #sub( A:Proc ;      B:Proc /\ _:SimplePat ; C:NamePat ) => #sub(A;B;C)
  rule #sub( A:Proc ;   B:ProcPat /\ _:SimplePat ; C:NamePat ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat /\ B:Proc      ; C:NamePat ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat /\ B:ProcPat   ; C:NamePat ) => #sub(A;B;C)
  rule #sub( A:Proc ;      B:Proc /\ _:SimplePat ; C:Proc    ) => #sub(A;B;C)
  rule #sub( A:Proc ;   B:ProcPat /\ _:SimplePat ; C:Proc    ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat /\ B:Proc      ; C:Proc    ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat /\ B:ProcPat   ; C:Proc    ) => #sub(A;B;C)
  rule #sub( A:Proc ;      B:Proc /\ _:SimplePat ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( A:Proc ;   B:ProcPat /\ _:SimplePat ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat /\ B:Proc      ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat /\ B:ProcPat   ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( A:Proc ;      B:Proc \/ _:SimplePat ; C:Name    ) => #sub(A;B;C)
  rule #sub( A:Proc ;   B:ProcPat \/ _:SimplePat ; C:Name    ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat \/ B:Proc      ; C:Name    ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat \/ B:ProcPat   ; C:Name    ) => #sub(A;B;C)
  rule #sub( A:Proc ;      B:Proc \/ _:SimplePat ; C:NamePat ) => #sub(A;B;C)
  rule #sub( A:Proc ;   B:ProcPat \/ _:SimplePat ; C:NamePat ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat \/ B:Proc      ; C:NamePat ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat \/ B:ProcPat   ; C:NamePat ) => #sub(A;B;C)
  rule #sub( A:Proc ;      B:Proc \/ _:SimplePat ; C:Proc    ) => #sub(A;B;C)
  rule #sub( A:Proc ;   B:ProcPat \/ _:SimplePat ; C:Proc    ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat \/ B:Proc      ; C:Proc    ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat \/ B:ProcPat   ; C:Proc    ) => #sub(A;B;C)
  rule #sub( A:Proc ;      B:Proc \/ _:SimplePat ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( A:Proc ;   B:ProcPat \/ _:SimplePat ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat \/ B:Proc      ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( A:Proc ; _:SimplePat \/ B:ProcPat   ; C:ProcPat ) => #sub(A;B;C)

// Collection substitutions -- assumed normalized and lengths match
  // sub RhoList for RhoList/ListPat
  rule #sub( [ A:Procs ] ; [ B:ProcPats ] ; C:Name    ) => #sub(A;B;C)
  rule #sub( [ A:Procs ] ; [ B:ProcPats ] ; C:NamePat ) => #sub(A;B;C)
  rule #sub( [ A:Procs ] ; [ B:ProcPats ] ; C:Proc    ) => #sub(A;B;C)
  rule #sub( [ A:Procs ] ; [ B:ProcPats ] ; C:ProcPat ) => #sub(A;B;C)
    // list remainder patterns
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc                 ... E:ProcVar ] ; F:Name    ) => #sub([B];E;#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat              ... E:ProcVar ] ; F:Name    ) => #sub([B];E;#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc    , D:Procs    ... E:ProcVar ] ; F:Name    ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc    , D:ProcPats ... E:ProcVar ] ; F:Name    ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:Procs    ... E:ProcVar ] ; F:Name    ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:ProcPats ... E:ProcVar ] ; F:Name    ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc                 ... E:ProcVar ] ; F:NamePat ) => #sub([B];E;#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat              ... E:ProcVar ] ; F:NamePat ) => #sub([B];E;#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc    , D:Procs    ... E:ProcVar ] ; F:NamePat ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc    , D:ProcPats ... E:ProcVar ] ; F:NamePat ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:Procs    ... E:ProcVar ] ; F:NamePat ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:ProcPats ... E:ProcVar ] ; F:NamePat ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc                 ... E:ProcVar ] ; F:Proc    ) => #sub([B];E;#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat              ... E:ProcVar ] ; F:Proc    ) => #sub([B];E;#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc    , D:Procs    ... E:ProcVar ] ; F:Proc    ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc    , D:ProcPats ... E:ProcVar ] ; F:Proc    ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:Procs    ... E:ProcVar ] ; F:Proc    ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:ProcPats ... E:ProcVar ] ; F:Proc    ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc                 ... E:ProcVar ] ; F:ProcPat ) => #sub([B];E;#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat              ... E:ProcVar ] ; F:ProcPat ) => #sub([B];E;#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc    , D:Procs    ... E:ProcVar ] ; F:ProcPat ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:Proc    , D:ProcPats ... E:ProcVar ] ; F:ProcPat ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:Procs    ... E:ProcVar ] ; F:ProcPat ) => #sub([B];[D...E];#sub(A;C;F))
  rule #sub( [ A:Proc , B:Procs ] ; [ C:ProcPat , D:ProcPats ... E:ProcVar ] ; F:ProcPat ) => #sub([B];[D...E];#sub(A;C;F))
  // sub RhoMap for RhoMap/MapPat
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPairs } ; C:Name    ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPats  } ; C:Name    ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPairs } ; C:NamePat ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPats  } ; C:NamePat ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPairs } ; C:Proc    ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPats  } ; C:Proc    ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPairs } ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPats  } ; C:ProcPat ) => #sub(A;B;C)
    // KVPair/KVPat
  rule #sub( A:Proc : B:Proc ; C:Proc    : D:Proc    ; E:Name    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc    : D:ProcPat ; E:Name    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:ProcPat : D:Proc    ; E:Name    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:ProcPat : D:ProcPat ; E:Name    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc    : D:Proc    ; E:NamePat ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc    : D:ProcPat ; E:NamePat ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:ProcPat : D:Proc    ; E:NamePat ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:ProcPat : D:ProcPat ; E:NamePat ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc    : D:Proc    ; E:Proc    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc    : D:ProcPat ; E:Proc    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:ProcPat : D:Proc    ; E:Proc    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:ProcPat : D:ProcPat ; E:Proc    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc    : D:Proc    ; E:ProcPat ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc    : D:ProcPat ; E:ProcPat ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:ProcPat : D:Proc    ; E:ProcPat ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:ProcPat : D:ProcPat ; E:ProcPat ) => #sub(A,B;C,D;E)
    // KVPairs/KVPats
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPats  ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPairs ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPats  ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPats  ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPairs ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPats  ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPats  ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPairs ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPats  ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPats  ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPairs ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPat  , D:RhoKVPats  ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))
    // map remainder patterns
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair                ... E:ProcVar } ; F:Name    ) => #sub({B};E;#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat                 ... E:ProcVar } ; F:Name    ) => #sub({B};E;#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs ... E:ProcVar } ; F:Name    ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPats  ... E:ProcVar } ; F:Name    ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPairs ... E:ProcVar } ; F:Name    ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPats  ... E:ProcVar } ; F:Name    ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair                ... E:ProcVar } ; F:NamePat ) => #sub({B};E;#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat                 ... E:ProcVar } ; F:NamePat ) => #sub({B};E;#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs ... E:ProcVar } ; F:NamePat ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPats  ... E:ProcVar } ; F:NamePat ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPairs ... E:ProcVar } ; F:NamePat ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPats  ... E:ProcVar } ; F:NamePat ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair                ... E:ProcVar } ; F:Proc    ) => #sub({B};E;#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat                 ... E:ProcVar } ; F:Proc    ) => #sub({B};E;#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs ... E:ProcVar } ; F:Proc    ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPats  ... E:ProcVar } ; F:Proc    ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPairs ... E:ProcVar } ; F:Proc    ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPats  ... E:ProcVar } ; F:Proc    ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair                ... E:ProcVar } ; F:ProcPat ) => #sub({B};E;#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat                 ... E:ProcVar } ; F:ProcPat ) => #sub({B};E;#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPairs ... E:ProcVar } ; F:ProcPat ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPair , D:RhoKVPats  ... E:ProcVar } ; F:ProcPat ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPairs ... E:ProcVar } ; F:ProcPat ) => #sub({B};{D...E};#sub(A;C;F))
  rule #sub( { A:RhoKVPair , B:RhoKVPairs } ; { C:RhoKVPat  , D:RhoKVPats  ... E:ProcVar } ; F:ProcPat ) => #sub({B};{D...E};#sub(A;C;F))
  // sub RhoSet for RhoSet/SetPat
  rule #sub( Set( A:Procs ) ; Set( B:Procs    ) ; C:Name    ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:ProcPats ) ; C:Name    ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:Procs    ) ; C:NamePat ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:ProcPats ) ; C:NamePat ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:Procs    ) ; C:Proc    ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:ProcPats ) ; C:Proc    ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:Procs    ) ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:ProcPats ) ; C:ProcPat ) => #sub(A;B;C)
    // set remainder patterns
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc                 ... E:ProcVar ) ; F:Name    ) => #sub(Set(B);E;#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat              ... E:ProcVar ) ; F:Name    ) => #sub(Set(B);E;#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:Procs    ... E:ProcVar ) ; F:Name    ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:ProcPats ... E:ProcVar ) ; F:Name    ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:Procs    ... E:ProcVar ) ; F:Name    ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:ProcPats ... E:ProcVar ) ; F:Name    ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc                 ... E:ProcVar ) ; F:NamePat ) => #sub(Set(B);E;#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat              ... E:ProcVar ) ; F:NamePat ) => #sub(Set(B);E;#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:Procs    ... E:ProcVar ) ; F:NamePat ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:ProcPats ... E:ProcVar ) ; F:NamePat ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:Procs    ... E:ProcVar ) ; F:NamePat ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:ProcPats ... E:ProcVar ) ; F:NamePat ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc                 ... E:ProcVar ) ; F:Proc    ) => #sub(Set(B);E;#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat              ... E:ProcVar ) ; F:Proc    ) => #sub(Set(B);E;#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:Procs    ... E:ProcVar ) ; F:Proc    ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:ProcPats ... E:ProcVar ) ; F:Proc    ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:Procs    ... E:ProcVar ) ; F:Proc    ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:ProcPats ... E:ProcVar ) ; F:Proc    ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc                 ... E:ProcVar ) ; F:ProcPat ) => #sub(Set(B);E;#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat              ... E:ProcVar ) ; F:ProcPat ) => #sub(Set(B);E;#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:Procs    ... E:ProcVar ) ; F:ProcPat ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:Proc    , D:ProcPats ... E:ProcVar ) ; F:ProcPat ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:Procs    ... E:ProcVar ) ; F:ProcPat ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  rule #sub( Set( A:Proc , B:Procs ) ; Set( C:ProcPat , D:ProcPats ... E:ProcVar ) ; F:ProcPat ) => #sub(Set(B);Set(D...E);#sub(A;C;F))
  // sub RhoTuple for RhoTuple/TuplePat
  rule #sub( ( A:Procs ,) ; ( B:Procs    ,) ; C:Name    ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:ProcPats ,) ; C:Name    ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:Procs    ,) ; C:NamePat ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:ProcPats ,) ; C:NamePat ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:Procs    ,) ; C:Proc    ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:ProcPats ,) ; C:Proc    ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:Procs    ,) ; C:ProcPat ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:ProcPats ,) ; C:ProcPat ) => #sub(A;B;C)

//-------------------------
//--- Map substitutions ---
//-------------------------
  // Empty map => no sub
  rule #sub(  .Map ; A:Names      ) => A [structural]
  rule #sub(  .Map ; A:NamePats   ) => A [structural]
  rule #sub(  .Map ; A:Procs      ) => A [structural]
  rule #sub(  .Map ; A:ProcPats   ) => A [structural]
  rule #sub(  .Map ; A:RhoKVPairs ) => A [structural]
  rule #sub(  .Map ; A:RhoKVPats  ) => A [structural]
  rule #sub(  .Map ; A:Branches   ) => A [structural]
  rule #sub(  .Map ; A:BranchPats ) => A [structural]
  rule #sub(  .Map ; A:MatchCases ) => A [structural]
  rule #sub(  .Map ; A:MCasePats  ) => A [structural]
  rule #sub(  .Map ; A:InterpMaps ) => A [structural]

  // if no variables are map keys, then no substitution happens
  rule #sub( A:Map ; B:Name       ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:NamePat    ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:Proc       ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:ProcPat    ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:RhoKVPair  ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:RhoKVPat   ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:Branch     ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:BranchPat  ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:MatchCase  ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:MCasePat   ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]
  rule #sub( A:Map ; B:InterpMaps ) => B requires intersectSet(#FV(B),keys(A)) ==K .Set [structural]

  // if variables appear as map keys, substitute value for key
    // Name[Pat]s
  rule #sub( A:Name |-> B:Name C:Map ; D:Names    ) => #sub(C;#sub(B;A;D))
  rule #sub( A:Name |-> B:Name C:Map ; D:NamePats ) => #sub(C;#sub(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:Names    ) => #sub(C;#sub(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:NamePats ) => #sub(C;#sub(B;A;D))
    // Proc[Pat]s
  rule #sub( A:Name |-> B:Name C:Map ; D:Procs    ) => #sub(C;#sub(B;A;D))
  rule #sub( A:Name |-> B:Name C:Map ; D:ProcPats ) => #sub(C;#sub(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:Procs    ) => #sub(C;#sub(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:ProcPats ) => #sub(C;#sub(B;A;D))
    // KVPairs/Pats
  rule #sub( A:Name |-> B:Name C:Map ; D:RhoKVPairs ) => #sub(C;#subKV(B;A;D))
  rule #sub( A:Name |-> B:Name C:Map ; D:RhoKVPats  ) => #sub(C;#subKV(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:RhoKVPairs ) => #sub(C;#subKV(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:RhoKVPats  ) => #sub(C;#subKV(B;A;D))
    // Branches/Pats
  rule #sub( A:Name |-> B:Name C:Map ; D:Branches   ) => #sub(C;#subBranch(B;A;D))
  rule #sub( A:Name |-> B:Name C:Map ; D:BranchPats ) => #sub(C;#subBranch(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:Branches   ) => #sub(C;#subBranch(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:BranchPats ) => #sub(C;#subBranch(B;A;D))
    // MatchCases/Pats
  rule #sub( A:Name |-> B:Name C:Map ; D:MatchCases ) => #sub(C;#subMatch(B;A;D))
  rule #sub( A:Name |-> B:Name C:Map ; D:MCasePats  ) => #sub(C;#subMatch(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:MatchCases ) => #sub(C;#subMatch(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:MCasePats  ) => #sub(C;#subMatch(B;A;D))
    // InterpMaps
  rule #sub( A:Name |-> B:Name C:Map ; D:InterpMaps ) => #sub(C;#sub(B;A;D))
  rule #sub( A:Proc |-> B:Proc C:Map ; D:InterpMaps ) => #sub(C;#sub(B;A;D))

// Several substitution targets
  rule #sub( A:Map ; B:Name    , C:Names    ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:Name    , C:NamePats ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:NamePat , C:Names    ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:NamePat , C:NamePats ) => #sub(A;B) , #sub(A;C)

  rule #sub( A:Map ; B:Proc    , C:Procs    ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:Proc    , C:ProcPats ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:ProcPat , C:Procs    ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:ProcPat , C:ProcPats ) => #sub(A;B) , #sub(A;C)

  rule #sub( A:Map ; B:RhoKVPair , C:RhoKVPairs ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:RhoKVPair , C:RhoKVPats  ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:RhoKVPat  , C:RhoKVPairs ) => #sub(A;B) , #sub(A;C)
  rule #sub( A:Map ; B:RhoKVPat  , C:RhoKVPats  ) => #sub(A;B) , #sub(A;C)

  rule #sub( A:Map ; B:Branch    C:Branches   ) => #sub(A;B) #sub(A;C)
  rule #sub( A:Map ; B:Branch    C:BranchPats ) => #sub(A;B) #sub(A;C)
  rule #sub( A:Map ; B:BranchPat C:Branches   ) => #sub(A;B) #sub(A;C)
  rule #sub( A:Map ; B:BranchPat C:BranchPats ) => #sub(A;B) #sub(A;C)

  rule #sub( A:Map ; B:MatchCase C:MatchCases ) => #sub(A;B) #sub(A;C)
  rule #sub( A:Map ; B:MatchCase C:MCasePats  ) => #sub(A;B) #sub(A;C)
  rule #sub( A:Map ; B:MCasePat  C:MatchCases ) => #sub(A;B) #sub(A;C)
  rule #sub( A:Map ; B:MCasePat  C:MCasePats  ) => #sub(A;B) #sub(A;C)

//-----------------
//--- #subGuard ---
//-----------------
// length(P) == length(N)
  rule #subGuard( A:Proc  ; B:Name     ; C:BExp ) => #sub(@A;B;C)
  rule #subGuard( A:Proc  ; B:NamePat  ; C:BExp ) => #sub(@A;B;C)
  rule #subGuard( A:Procs ; B:Names    ; C:BExp ) => #sub(#quotes(A);B;C)
  rule #subGuard( A:Procs ; B:NamePats ; C:BExp ) => #sub(#quotes(A);B;C)

//------------------------
//--- Simultaneous sub ---
//------------------------
// substitution variables
  rule #mapVarSub( A:NamePats ) => #mapVarSub(A;0)
  rule #mapVarSub( A:ProcPats ) => #mapVarSub(A;0)
  rule #mapVarSub( A:Var                  ; I:Int ) => A |-> nvar(I)
  rule #mapVarSub( A:Var     , B:NamePats ; I:Int ) => A |-> nvar(I) #mapVarSub(B;I +Int 1)
  rule #mapVarSub( A:ProcVar              ; I:Int ) => A |-> pvar(I)
  rule #mapVarSub( A:ProcVar , B:ProcPats ; I:Int ) => A |-> pvar(I) #mapVarSub(B;I +Int 1)
// NamePats/ProcPats to substitute in
  rule #mapVarIn( A:NamePats ) => #mapVarIn(A;0)
  rule #mapVarIn( A:ProcPats ) => #mapVarIn(A;0)
  rule #mapVarIn( A:NamePat              ; I:Int ) => nvar(I) |-> A
  rule #mapVarIn( A:NamePat , B:NamePats ; I:Int ) => nvar(I) |-> A #mapVarIn(B;I +Int 1)
  rule #mapVarIn( A:ProcPat              ; I:Int ) => pvar(I) |-> A
  rule #mapVarIn( A:ProcPat , B:ProcPats ; I:Int ) => pvar(I) |-> A #mapVarIn(B;I +Int 1)

//-------------------
//--- #subcontext ---
//-------------------
// Fundamental substitution contexts
  // AExp
  rule #subcontext(  A:Proc ;  \B:Var ; C:AExp ) => (B in #FPV(C)) impliesBool isAExp(A)
  rule #subcontext( @A:Proc ; @\B:Var ; C:AExp ) => #subcontext(A;\B;C)
  rule #subcontext( @A:Proc ;   B:Var ; C:AExp ) => (B in #FNV(C)) impliesBool isAExp(A)
  // BExp
  rule #subcontext( A:Proc  ;  \B:Var ; C:BExp ) => (B in #FPV(C)) impliesBool isBExp(A)
  rule #subcontext( @A:Proc ; @\B:Var ; C:BExp ) => #subcontext(A;\B;C)
  rule #subcontext( @A:Proc ;   B:Var ; C:BExp ) => (B in #FNV(C)) impliesBool isBExp(A)
  // ListExp
  rule #subcontext( A:Proc  ;  \B:Var ; C:ListExp ) => (B in #FPV(C)) impliesBool isListExp(A)
  rule #subcontext( @A:Proc ; @\B:Var ; C:ListExp ) => #subcontext(A;\B;C)
  rule #subcontext( @A:Proc ;   B:Var ; C:ListExp ) => (B in #FNV(C)) impliesBool isListExp(A)
  // StringExp
  rule #subcontext( A:Proc  ; \B:Var ; C:StringExp ) => (B in #FPV(C)) impliesBool isStringExp(A)
  rule #subcontext( @A:Proc ; B:Var  ; C:StringExp ) => (B in #FNV(C)) impliesBool isStringExp(A)

//----------------
//--- #sub2map ---
//----------------
// mapping from a given substitution: #sub(A;B;C) == #sub(#sub2map(A;B);C)

// Fundamental substitution mappings
  rule #sub2map( A:Proc ;  \B:Var ) => \B |->  A
  rule #sub2map( A:Proc ;  *B:Var ) =>  B |-> @A
  rule #sub2map( A:Name ; @\B:Var ) => \B |-> *A
  rule #sub2map( A:Name ;   B:Var ) =>  B |->  A

  rule #sub2map( _:ProcPat ; \_ ) => .Map
  rule #sub2map( _:Proc    ; \_ ) => .Map
  rule #sub2map( _:NamePat ; \_ ) => .Map
  rule #sub2map( _:Name    ; \_ ) => .Map

// Send & SendPat
  // Consumable
  rule #sub2map( A:NamePat !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  (            ) ; C:NamePat !  (            ) ) => #sub2map(A;C)
  rule #sub2map( A:Name    !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:ProcPats ) ; C:Name    !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  (            ) ; C:NamePat !  (            ) ) => #sub2map(A;C)
  rule #sub2map( A:Name    !  (            ) ; C:Name    !  (            ) ) => #sub2map(A;C)
  // Unconsumable
  rule #sub2map( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! (            ) ; C:NamePat !! (            ) ) => #sub2map(A;C)
  rule #sub2map( A:Name    !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:ProcPats ) ; C:Name    !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! (            ) ; C:NamePat !! (            ) ) => #sub2map(A;C)
  rule #sub2map( A:Name    !! (            ) ; C:Name    !! (            ) ) => #sub2map(A;C)

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
