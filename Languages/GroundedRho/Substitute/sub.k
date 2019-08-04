// Rholang Substitution
/*
TODO:
 - add remaining features - Methods, Bundles, Match
 - more testing
 - sub for Uri for #match
 - prove #sub(_;_;_) is safe substitution
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
  syntax       Proc ::= "#sub(" Procs    ";" Procs    ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Procs    ";" ProcPats ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" ProcPats ";" ProcPats ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Names    ";" Names    ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Names    ";" NamePats ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" NamePats ";" NamePats ";" Proc ")" [function, poly(0,3)]

  syntax      Procs ::= "#sub(" Procs    ";" Procs    ";" Procs ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" Procs ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" Procs ")" [function]
                      | "#sub(" Names    ";" Names    ";" Procs ")" [function]
                      | "#sub(" Names    ";" NamePats ";" Procs ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" Procs ")" [function]

// Receive subs
  // if substitutions are not included in listens -- #subRec
  syntax       Proc ::= "#subRec(" Procs    ";" Procs    ";" Proc ")" [function]
                      | "#subRec(" Procs    ";" ProcPats ";" Proc ")" [function]
                      | "#subRec(" ProcPats ";" ProcPats ";" Proc ")" [function]
                      | "#subRec(" Names    ";" Names    ";" Proc ")" [function]
                      | "#subRec(" Names    ";" NamePats ";" Proc ")" [function]
                      | "#subRec(" NamePats ";" NamePats ";" Proc ")" [function]

  // if substitutions are included in listens -- #subChan
  syntax       Proc ::= "#subChan(" Procs    ";" Procs    ";" Proc ")" [function]
                      | "#subChan(" Procs    ";" ProcPats ";" Proc ")" [function]
                      | "#subChan(" ProcPats ";" ProcPats ";" Proc ")" [function]
                      | "#subChan(" Names    ";" Names    ";" Proc ")" [function]
                      | "#subChan(" Names    ";" NamePats ";" Proc ")" [function]
                      | "#subChan(" NamePats ";" NamePats ";" Proc ")" [function]

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

  syntax       Proc ::= "#subNew(" Int ";" Set ";" Proc ")" [function]

  // Match substitution -- TODO
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

// Select sub -- TODO
  syntax     Branch ::= "#subBranch(" Proc     ";" Proc     ";" Branch   ")" [function]
                      | "#subBranch(" Procs    ";" ProcPats ";" Branch   ")" [function]
                      | "#subBranch(" ProcPats ";" ProcPats ";" Branch   ")" [function]
                      | "#subBranch(" Names    ";" Names    ";" Branch   ")" [function]
                      | "#subBranch(" Names    ";" NamePats ";" Branch   ")" [function]
                      | "#subBranch(" NamePats ";" NamePats ";" Branch   ")" [function]
  syntax   Branches ::= "#subBranch(" Proc     ";" Proc     ";" Branches ")" [function]
                      | "#subBranch(" Procs    ";" ProcPats ";" Branches ")" [function]
                      | "#subBranch(" ProcPats ";" ProcPats ";" Branches ")" [function]
                      | "#subBranch(" Names    ";" Names    ";" Branches ")" [function]
                      | "#subBranch(" Names    ";" NamePats ";" Branches ")" [function]
                      | "#subBranch(" NamePats ";" NamePats ";" Branches ")" [function]

// RhoMap
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
  syntax       Name ::= "#sub(" Procs    ";" Procs    ";" Name ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" Name ")" [function]
                      | "#sub(" ProcPats ";" Procs    ";" Name ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" Name ")" [function]
                      | "#sub(" Names    ";" Names    ";" Name ")" [function]
                      | "#sub(" Names    ";" NamePats ";" Name ")" [function]
                      | "#sub(" NamePats ";" Names    ";" Name ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" Name ")" [function]

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

  syntax    ProcPat ::= "#subNew(" Int ";" Set ";" ProcPat ")" [function]

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
                      | "#sub(" Map      ";" NamePat  ")"              [function]

  syntax   NamePats ::= "#sub(" Procs    ";" Procs    ";" NamePats ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" NamePats ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" NamePats ")" [function]
                      | "#sub(" Names    ";" Names    ";" NamePats ")" [function]
                      | "#sub(" Names    ";" NamePats ";" NamePats ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" NamePats ")" [function]
                      | "#sub(" Map ";" NamePats ")" [function]

  syntax        Map ::= "#sub(" Names ";" Names ";" Map ")" [function]
                      | "#sub(" Procs ";" Procs ";" Map ")" [function]

// Map substitutions
  syntax       Name ::= "#sub(" Map ";" Name  ")" [function]
  syntax      Names ::= "#sub(" Map ";" Names ")" [function]
  syntax       Proc ::= "#sub(" Map ";" Proc  ")" [function, poly(0,2)]
  syntax      Procs ::= "#sub(" Map ";" Procs ")" [function]

  syntax    NamePat ::= "#sub(" Map ";" NamePat  ")" [function]
  syntax   NamePats ::= "#sub(" Map ";" NamePats ")" [function]
  syntax    ProcPat ::= "#sub(" Map ";" ProcPat  ")" [function]
  syntax   ProcPats ::= "#sub(" Map ";" ProcPats ")" [function]

  syntax        Map ::= "#sub2map(" Procs    ";" Procs    ")" [function]
                      | "#sub2map(" Procs    ";" ProcPats ")" [function]
                      | "#sub2map(" ProcPats ";" ProcPats ")" [function]
                      | "#sub2map(" Names    ";" Names    ")" [function]
                      | "#sub2map(" Names    ";" NamePats ")" [function]
                      | "#sub2map(" NamePats ";" NamePats ")" [function]

// Input guard satisfaction predicate for comm in Grho
  syntax       Bool ::= "#subGuard(" Procs ";" Names    ";" BExp ")" [function]
                      | "#subGuard(" Procs ";" NamePats ";" BExp ")" [function]

// Substitution context checking
  syntax       Bool ::= "#subcontext(" Proc    ";" Proc ";" Proc    ")" [function]
                      | "#subcontext(" Proc    ";" Proc ";" ProcPat ")" [function]
                      | "#subcontext(" ProcPat ";" Proc ";" Proc    ")" [function]
                      | "#subcontext(" ProcPat ";" Proc ";" ProcPat ")" [function]
                      | "#subcontext(" Name    ";" Name ";" Proc    ")" [function]
                      | "#subcontext(" Name    ";" Name ";" ProcPat ")" [function]
                      | "#subcontext(" NamePat ";" Name ";" Proc    ")" [function]
                      | "#subcontext(" NamePat ";" Name ";" ProcPat ")" [function]

  syntax      KItem ::= Proc | Name

endmodule

module SUB
  import SUB-SYNTAX
  import AUXFUN
  import NAMEVAR

  syntax KResult ::= Proc | Procs | Bind | Binds | New | Match | InterpMaps | RhoKVPair | RhoKVPairs
                   | ProcPat | ProcPats | BindPat | BindPats | NewPat | MatchPat
                   | MatchCase | MatchCases | Branch | Branches
                   | Name | Names | NamePat | NamePats

// BoundName/Proc subs for ALPHA
  // requirements of #sub function on BoundNames/Procs for finishing De Bruijn index substitutions
  rule #sub( A:Name ; B:Name ;  C:BoundName ) =>  C
       requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ;  C:BoundName ) =>  C
       requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:Name ; B:Name ; *C:BoundName ) => *C
       requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ; *C:BoundName ) => *C
       requires notBool (isBoundProc(A) andBool isBoundProc(B))
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

  rule #sub( A:Name ; B:Name ;  C:BoundProc ) =>  C
       requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ;  C:BoundProc ) =>  C
       requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:Name ; B:Name ; @C:BoundProc ) => @C
       requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ; @C:BoundProc ) => @C
       requires notBool (isBoundProc(A) andBool isBoundProc(B))
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

// For #mapSub -- de Bruijn indexing for Receive
  rule #sub( _:Name ; @sub ; N:Name    ) => N
  rule #sub( _:Name ; @sub ; P:Proc    ) => P
  rule #sub( _:Proc ;  sub ; N:Name    ) => N
  rule #sub( _:Proc ;  sub ; P:Proc    ) => P
  rule #sub( _:Name ; @sub ; N:NamePat ) => N
  rule #sub( _:Name ; @sub ; P:ProcPat ) => P
  rule #sub( _:Proc ;  sub ; N:NamePat ) => N
  rule #sub( _:Proc ;  sub ; P:ProcPat ) => P

  rule #sub( _:Name    ; _:Name    ; sub ) => sub
  rule #sub( _:Name    ; _:NamePat ; sub ) => sub
  rule #sub( _:NamePat ; _:NamePat ; sub ) => sub
  rule #sub( _:Proc    ; _:Proc    ; sub ) => sub
  rule #sub( _:Proc    ; _:ProcPat ; sub ) => sub
  rule #sub( _:ProcPat ; _:ProcPat ; sub ) => sub

  rule #sub( @EmptyP ; EmptyN ; A:Proc ) => A

//--------------------------------
//--- Substitute Proc for Proc ---
//--------------------------------
// Trivial cases
  rule #sub( A:Proc ; A ; N:Name ) => N
  rule #sub( A:Proc ; A ; P:Proc ) => P
  rule #sub( _:Proc ; _:Proc ; G:Ground ) => G

// Fundamental cases -- variables
  // sub Proc for ProcVar in ProcVar or Var
  rule #sub( A:Proc ; \B:Var   ; \B     ) =>  A
  rule #sub( _:Proc ; \B:Var   ; \C:Var ) => \C requires B =/=K C
  rule #sub( _:Proc ; \(_:Var) ;  A:Var ) =>  A
  // Typed
  rule #sub( A:Proc ; \B:Var ; \B     :: D:ProcPat ) =>  A // requires #match(A;D)???
  rule #sub( A:Proc ; \B:Var ; \C:Var :: D:ProcPat ) => \C :: #sub(A;\B;D) requires B =/=K C
  rule #sub( A:Proc ; \B:Var ;  C:Var :: D:NamePat ) =>  C :: #sub(A;\B;D)

  // sub Proc for *Var in Var or ProcVar
  rule #sub( A:Proc ; *B:Var ;  B     ) => @A
  rule #sub( A:Proc ; *B:Var ;  C:Var ) =>  C requires B =/=K C
  rule #sub( _:Proc ; *_:Var ; \A:Var ) => \A
  // Typed
  rule #sub( A:Proc ; *B:Var ;  B     :: D:NamePat ) => @A // requires #match(A;D)???
  rule #sub( A:Proc ; *B:Var ;  C:Var :: D:NamePat ) =>  C :: #sub(A;*B;D) requires B =/=K C
  rule #sub( A:Proc ; *B:Var ; \C:Var :: D:ProcPat ) => \C :: #sub(A;*B;D)

  // TODO: sub for Uri for #match

// Recusive cases -- destructuring substitution Proc or Name
  // sub Proc for Proc in @Proc
  rule #sub( A:Proc ; B:Proc ; @C:Proc ) => @#sub(A;B;C)

  // sub Proc for Proc in *Name
  rule #sub( A:Proc ; B:Proc ; *C:Name ) => *#sub(A;B;C)

  // sub *Name for *Name in Proc
  rule #sub( *A:Name ; *B:Name ; C:Proc ) => #sub(A;B;C) requires notBool isVar(B)

  // sub Proc for Proc in Send -- sub in channel and continuation
  rule #sub( A:Proc ; B:Proc ; C:Name !  (         ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! (         ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Proc for Proc in Receive -- only substitute free variables in channel and continuation
    // if substitution variables are all listening variables and not receive variables, then no substitution occurs
  rule #sub( _:Proc ;  B:Proc ; Rec:Receive ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
    // if substitution variables are distinct from free variables in Rec, then no substitution occurs
  rule #sub( _:Proc ;  B:Proc ; Rec:Receive ) => Rec requires intersectSet(#FV(B),#FV(Rec)) ==K .Set
    // substituting for a ProcVar -- if ProcVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Proc ; \B:Var ; Rec:Receive ) => #if (\B in #LV(Rec)) #then #subChan(A;\B;Rec) #else #subRec(A;\B;Rec) #fi
    // substituting for *Var -- if Var is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Proc ; *B:Var ; Rec:Receive ) => #if (B  in #LV(Rec)) #then #subChan(@A;B;Rec) #else #subRec(@A;B;Rec) #fi

    // if substitution variable is a listening variable, then it is only substituted in the channel (not in the guard or continuation)
  rule #subChan( A:Proc ; \B:Var ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;\B;;LB)  ){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;\B;;LBs) ){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;\B;;PB)  ){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;\B;;PBs) ){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;\B;;RB)  ){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;\B;;RBs) ){ Cont }
    // guarded
  rule #subChan( A:Proc ; \B:Var ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;LB)   if #sub(A;\B;G)){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;LBs)  if #sub(A;\B;G)){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;PB)   if #sub(A;\B;G)){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;PBs)  if #sub(A;\B;G)){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;RB)   if #sub(A;\B;G)){ Cont }
  rule #subChan( A:Proc ; \B:Var ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;RBs)  if #sub(A;\B;G)){ Cont }

    // if Var to be substituted not a listening variable, then it is substituted in the channel and continuation (and guard)
  rule #subRec( A:Proc ; \B:Var ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;\B;;LB)  ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;\B;;LBs) ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;\B;;PB)  ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;\B;;PBs) ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;\B;;RB)  ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;\B;;RBs) ){ #sub(A;\B;Cont) }
      // guarded
  rule #subRec( A:Proc ; \B:Var ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;LB)  if #sub(A;\B;G) ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;LBs) if #sub(A;\B;G) ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;PB)  if #sub(A;\B;G) ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;PBs) if #sub(A;\B;G) ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;RB)  if #sub(A;\B;G) ){ #sub(A;\B;Cont) }
  rule #subRec( A:Proc ; \B:Var ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;\B;;RBs) if #sub(A;\B;G) ){ #sub(A;\B;Cont) }

  // Binds
    // Linear
  rule #subBind( A:Proc ; B:Proc ;;            <- X:Name  ) =>   <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names    <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePats <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind & D:Lbind  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind & D:Lbinds ) => #subBind(A;B;;C) & #subBind(A;B;;D)
    // Peek
  rule #subBind( A:Proc ; B:Proc ;;            <<- X:Name  ) =>   <<- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names    <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePats <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind & D:Pbind  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind & D:Pbinds ) => #subBind(A;B;;C) & #subBind(A;B;;D)
    // Repeated
  rule #subBind( A:Proc ; B:Proc ;;            <= X:Name  ) =>   <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names    <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePats <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind & D:Rbind  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind & D:Rbinds ) => #subBind(A;B;;C) & #subBind(A;B;;D)

// MRec
  rule #subRec( A:Proc ; \B:Var ; for( C:Lbinds ){ P:Proc } ) => for( #subBind(A;\B;;C) ){ #sub(A;\B;P) }
  rule #subRec( A:Proc ; \B:Var ; for( C:Pbinds ){ P:Proc } ) => for( #subBind(A;\B;;C) ){ #sub(A;\B;P) }
  rule #subRec( A:Proc ; \B:Var ; for( C:Rbinds ){ P:Proc } ) => for( #subBind(A;\B;;C) ){ #sub(A;\B;P) }

  rule #subRec( A:Proc ; \B:Var ; for( C:Lbinds if G:BExp ){ P:Proc } ) => for( #subBind(A;\B;;C) if #sub(A;\B;G) ){ #sub(A;\B;P) }
  rule #subRec( A:Proc ; \B:Var ; for( C:Pbinds if G:BExp ){ P:Proc } ) => for( #subBind(A;\B;;C) if #sub(A;\B;G) ){ #sub(A;\B;P) }
  rule #subRec( A:Proc ; \B:Var ; for( C:Rbinds if G:BExp ){ P:Proc } ) => for( #subBind(A;\B;;C) if #sub(A;\B;G) ){ #sub(A;\B;P) }


// sub Proc for Proc in Par -- apply after normalization
  rule #sub( A:Proc ; B:Proc ; C:Proc    | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isPar(A)
  rule #sub( A:Proc ; B:Proc ; C:Proc    | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isPar(A)
  rule #sub( A:Proc ; B:Proc ; C:ProcPat | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isParPat(A)
  rule #sub( A:Proc ; B:Proc ; C:ProcPat | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isParPat(A)

// sub Proc for Proc in Match -- TODO
  rule #sub( A:Proc ; B:Proc ; match { C:Proc } { D:MatchCases } ) => match {#sub(A;B;C)} {#subMatch(A;B;D)}
  // MatchCases
  rule #subMatch( A:Proc ; B:Proc ; { C:Proc    } |=> D:Proc ) => {#sub(A;B;C)} |=> #sub(A;B;D)
  rule #subMatch( A:Proc ; B:Proc ; { C:ProcPat } |=> D:Proc ) => {#sub(A;B;C)} |=> #sub(A;B;D)
  rule #subMatch( A:Proc ; B:Proc ; C:MatchCase D:MatchCases ) => #subMatch(A;B;C) #subMatch(A;B;D)

// sub Proc for Proc in Select -- TODO
  rule #sub( A:Proc ; B:Proc ; select { C:Branches } ) => select { #subBranch(A;B;C) }
  // Branches
//  rule #subBranch( A:Proc ; B:Proc ; { C:Lbind  } |=> D:Proc ) => { #subBind(A;B;;C) } |=> ???
//  rule #subBranch( A:Proc ; B:Proc ; { C:Lbinds } |=> D:Proc ) => { #subBind(A;B;;C) } |=> ???
//  rule #subBranch( A:Proc ; B:Proc ; C:Branch D:Branches ) => #subBranch(A;B;C) #subBranch(A;B;D)

// sub Proc for Proc in Collections -- TODO: patterns
  // RhoList
  rule #sub( _:Proc ; _:Proc ; [ ] ) => [ ]
  rule #sub( A:Proc ; B:Proc ; [ C:Procs    ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Proc ; B:Proc ; [ C:ProcPats ] ) => [ #sub(A;B;C) ]

  // RhoMap
  rule #sub( _:Proc ; _:Proc ; { } ) => { }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPairs } ) => { #subKV(A;B;C) }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPats  } ) => { #subKV(A;B;C) }
    // RhoKVPairs/Pats
  rule #subKV( A:Proc ; B:Proc ; C:Proc    : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:Proc    : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:ProcPat : D:Proc    ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:ProcPat : D:ProcPat ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPair , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPair , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPat  , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPat  , D:RhoKVPats  ) => #subKV(A;B;C) , #subKV(A;B;D)

  // RhoSet
  rule #sub( _:Proc ; _:Proc ; Set( ) ) => Set( )
  rule #sub( A:Proc ; B:Proc ; Set( C:Procs    ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Proc ; B:Proc ; Set( C:ProcPats ) ) => Set( #sub(A;B;C) )

  // RhoTuple
  rule #sub( A:Proc ; B:Proc ; ( C:Procs    ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Proc ; B:Proc ; ( C:ProcPats ,) ) => ( #sub(A;B;C) ,)

// sub Proc for Proc in New
  rule    #sub( A:Proc ; \B:Var  ; P:New ) => #subNew(A;\B;P)
  rule #subNew( A:Proc ;  B:Proc ; new C:VarDecs in { D:Proc } ) => new C in { #sub(A;B;D) }

  rule #subNew( I:Int ; .Set ; P:Proc    ) => P
  rule #subNew( I:Int ; .Set ; P:ProcPat ) => P
  rule #subNew( I:Int ;  SetItem( A:Var ) S:Set ; P:Proc    )
    => #subNew(I +Int 1;S;#sub(@unforgeable(I);A;P))
  rule #subNew( I:Int ;  SetItem( A:Var ) S:Set ; P:ProcPat )
    => #subNew(I +Int 1;S;#sub(@unforgeable(I);A;P))

// Arithmetic Exps
  rule #sub( A:Proc ; B:Proc ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
// List & String expressions
//  rule #sub( A:Proc ; B:Proc ; C:StringOrVar D:ConcatExp ) => #sub(A;B;C) #subConcat(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:ListOrVar   ++ D:ListOrVar   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:ListOrVar   ++ D:ConcatList  ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:StringOrVar ++ D:StringOrVar ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:StringOrVar ++ D:ConcatStr   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:StringOrVar %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:RhoMap      %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)

// Boolean Exps
  rule #sub( A:Proc ; B:Proc ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc    matches D:Proc    ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc    matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:ProcPat matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)

// sub Proc for Proc in Names
  rule #sub( A:Proc ; B:Proc ; C:Name    , D:Names    ) => #sub(A;B;C) , #sub(A;B;D)
// sub Proc for Proc in NamePats
  rule #sub( A:Proc ; B:Proc ; C:Name    , D:NamePats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:NamePat , D:Names    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:NamePat , D:NamePats ) => #sub(A;B;C) , #sub(A;B;D)
// sub Proc for Proc in Procs
  rule #sub( A:Proc ; B:Proc ; C:Proc    , D:Procs    ) => #sub(A;B;C) , #sub(A;B;D)
// sub Proc for Proc in ProcPats
  rule #sub( A:Proc ; B:Proc ; C:Proc    , D:ProcPats ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:ProcPat , D:Procs    ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:ProcPat , D:ProcPats ) => #sub(A;B;C) , #sub(A;B;D)

// Several Procs substitutions -- only applies after #match predicate so lengths are assumed equal
  // sub Procs for Procs in Name
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; N:Name    ) => #sub(B;D;#sub(A;C;N))
  // sub Procs for Procs in NamePat
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; N:NamePat ) => #sub(B;D;#sub(A;C;N))
  // sub Procs for Procs in Proc
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:Proc    ) => #sub(B;D;#sub(A;C;P))
  // sub Procs for Procs in ProcPat
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:ProcPat ) => #sub(B;D;#sub(A;C;P))
  // sub Procs for Procs in Names
  rule #sub( A:Procs ; B:Procs ; M:Name , N:Names ) => #append(#sub(A;B;M);#sub(A;B;N))
  // sub Procs for Procs in NamePats
  rule #sub( A:Procs ; B:Procs ; M:Name    , N:NamePats ) => #append(#sub(A;B;M);#sub(A;B;N))
  rule #sub( A:Procs ; B:Procs ; M:NamePat , N:Names    ) => #append(#sub(A;B;M);#sub(A;B;N))
  rule #sub( A:Procs ; B:Procs ; M:NamePat , N:NamePats ) => #append(#sub(A;B;M);#sub(A;B;N))
// sub Procs for Procs in Procs
  rule #sub( A:Procs ; B:Procs ; P:Proc , Q:Procs ) => #append(#sub(A;B;P);#sub(A;B;Q))
// sub Procs for Procs in ProcPats
  rule #sub( A:Procs ; B:Procs ; P:Proc    , Q:ProcPats ) => #append(#sub(A;B;P);#sub(A;B;Q))
  rule #sub( A:Procs ; B:Procs ; P:ProcPat , Q:Procs    ) => #append(#sub(A;B;P);#sub(A;B;Q))
  rule #sub( A:Procs ; B:Procs ; P:ProcPat , Q:ProcPats ) => #append(#sub(A;B;P);#sub(A;B;Q))

// sub Proc for Proc in Map
  rule #sub( _:Proc ; _:Proc ; .Map ) => .Map
  rule #sub( A:Proc ; B:Proc ; C:Proc |-> D:Proc E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Proc ; B:Proc ; C:Name |-> D:Name E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)

//-----------------------
//--- Deeper Patterns ---
//-----------------------
// sub Send for Send[Pat] in Proc - sub channel for channel and message(s) for message(s)
  rule #sub( A:Name    !  (            ) ; B:Name    !  (            ) ; E:Proc ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:Procs    ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:Name    !  ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:NamePat !  (            ) ; E:Proc ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  (            ) ; B:NamePat !  (            ) ; E:Proc ) => #sub(A;B;E)
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:Name    !! (            ) ; E:Proc ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:Procs    ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:Name    !! ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:NamePat !! (            ) ; E:Proc ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! (            ) ; B:NamePat !! (            ) ; E:Proc ) => #sub(A;B;E)
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:Proc ) => #sub(B;D;#sub(A;C;E))

// sub Send for Send[Pat] in Name - sub channel for channel and message(s) for message(s)
  rule #sub( A:Name    !  (            ) ; B:Name    !  (            ) ; E:Name ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:Procs    ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:Name    !  ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  (            ) ; B:NamePat !  (            ) ; E:Name ) => #sub(A;B;E)
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  (            ) ; B:NamePat !  (            ) ; E:Name ) => #sub(A;B;E)
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:Name    !! (            ) ; E:Name ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:Procs    ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:Name    !! ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! (            ) ; B:NamePat !! (            ) ; E:Name ) => #sub(A;B;E)
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! (            ) ; B:NamePat !! (            ) ; E:Name ) => #sub(A;B;E)
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ; E:Name ) => #sub(B;D;#sub(A;C;E))

// TODO: more testing!!!
// sub Receive for Receive in Proc or Name
  // single
    // unguarded -- channel free variables substituted into Proc first, then continuation free variables substituted into that
  rule #sub( for( A:Lbind ){ C:Proc } ; for( B:Lbind ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Pbind ){ C:Proc } ; for( B:Pbind ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Rbind ){ C:Proc } ; for( B:Rbind ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Lbind ){ C:Proc } ; for( B:Lbind ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
  rule #sub( for( A:Pbind ){ C:Proc } ; for( B:Pbind ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
  rule #sub( for( A:Rbind ){ C:Proc } ; for( B:Rbind ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
    // guarded

  // multi
    // unguarded
  rule #sub( for( A:Lbinds ){ C:Proc } ; for( B:Lbinds ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Pbinds ){ C:Proc } ; for( B:Pbinds ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Rbinds ){ C:Proc } ; for( B:Rbinds ){ D:Proc } ; N:Name )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);N))
  rule #sub( for( A:Lbinds ){ C:Proc } ; for( B:Lbinds ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
  rule #sub( for( A:Pbinds ){ C:Proc } ; for( B:Pbinds ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
  rule #sub( for( A:Rbinds ){ C:Proc } ; for( B:Rbinds ){ D:Proc } ; P:Proc )
    => #sub(#sub(#mapSub(#LV(A));C);#sub(#mapSub(#LV(B));D);#sub(#chan(A);#chan(B);P))
    // guarded -- sub guard free variables after channels and before continuations

// sub Par for Par in Name or Proc -- applied after normalization
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; N:Name ) => #sub(B;D;#sub(A;C;N))
       requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; P:Proc ) => #sub(B;D;#sub(A;C;P))
       requires notBool (isPar(A) orBool isPar(C))

// TODO: other productions


//------------------------------------------------
//--- Substitute Name for Name in Name or Proc ---
//------------------------------------------------
// Trivial cases
  rule #sub( A:Name ; A ; N:Name ) => N
  rule #sub( A:Name ; A ; P:Proc ) => P
  rule #sub( _:Name ; _:Name    ; G:Ground ) => G
  rule #sub( _:Name ; _:NamePat ; G:Ground ) => G

// sub Name for Name[Pat] in SimplePat
  rule #sub( _:Name ; _:Name    ; A:SimplePat ) => A
  rule #sub( _:Name ; _:NamePat ; A:SimplePat ) => A

// Fundamental cases
  // sub Name for Var in Var or ProcVar
  rule #sub( A:Name ; B:Var ;  B     ) =>  A
  rule #sub( A:Name ; B:Var ;  C:Var ) =>  C requires B =/=K C
  rule #sub( _:Name ; _:Var ; \A:Var ) => \A
  // Typed
  rule #sub( A:Name ; B:Var ;  B     :: D:NamePat ) =>  A // requires #match(A;D)???
  rule #sub( A:Name ; B:Var ;  C:Var :: D:NamePat ) =>  C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; B:Var ; \C:Var :: D:ProcPat ) => \C :: #sub(A;B;D)

  // sub Name for @ProcVar in Var
  rule #sub( A:Name ; @\B:Var   ; \B     ) => *A
  rule #sub( A:Name ; @\B:Var   ; \C:Var ) => \C requires B =/=K C
  rule #sub( _:Name ; @\(_:Var) ;  A:Var ) =>  A
  // Typed
  rule #sub( A:Name ; @\B:Var ; \B     :: D:ProcPat ) => *A // requires #match(A;D)???
  rule #sub( A:Name ; @\B:Var ; \C:Var :: D:ProcPat ) => \C :: #sub(A;B;D) requires B =/=K C
  rule #sub( A:Name ; @\B:Var ;  C:Var :: D:NamePat ) =>  C :: #sub(A;B;D)

// Recursive cases
  // sub Name for Name in @Proc
  rule #sub( A:Name ; B:Name ; @C:Proc ) => @ #sub(A;B;C)

  // sub Name for Name in *Name
  rule #sub( A:Name ;  B:Name ; *C:Name ) => * #sub(A;B;C)
  rule #sub( A:Var  ; @B:Proc ;  C:Proc ) => #sub(*A;B;C)

  // sub @Proc for @Proc in Name & Proc - drop quotes
  rule #sub( @A:Proc ; @B:Proc ; C:Name ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:Proc ; C:Proc ) => #sub(A;B;C)

  // sub Name for Name in Receive -- only substitute free variables in channel and continuation
    // if substitution variables are all listening variables and not receive variables, then no substitution occurs
  rule #sub( _:Name ;  B:Name ; Rec:Receive ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
    // if substitution variables are distinct from free variables in Rec, then no substitution occurs
  rule #sub( _:Name ;  B:Name ; Rec:Receive ) => Rec requires intersectSet(#FV(B),#FV(Rec)) ==K .Set
    // substituting for a ProcVar -- if ProcVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Name ;   B:Var ; Rec:Receive ) => #if (B  in #LV(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
    // substituting for *Var -- if Var is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Name ; @\B:Var ; Rec:Receive ) => #if (\B in #LV(Rec)) #then #subChan(*A;\B;Rec) #else #subRec(*A;\B;Rec) #fi

    // if substitution variable is a listening variable, then it is only substituted in the channel (not in the guard or continuation)
  rule #subChan( A:Name ; B:Var ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ Cont }
  rule #subChan( A:Name ; B:Var ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ Cont }
  rule #subChan( A:Name ; B:Var ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ Cont }
  rule #subChan( A:Name ; B:Var ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ Cont }
  rule #subChan( A:Name ; B:Var ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ Cont }
  rule #subChan( A:Name ; B:Var ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ Cont }
    // guarded
  rule #subChan( A:Name ; B:Var ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:Var ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:Var ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:Var ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:Var ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:Var ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) if #sub(A;B;G)){ Cont }

    // if Var to be substituted not a listening variable, then it is substituted in the channel and continuation (and guard)
  rule #subRec( A:Name ; B:Var ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ #sub(A;B;Cont) }
      // guarded
  rule #subRec( A:Name ; B:Var ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:Var ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }

  // Binds
    // Linear
  rule #subBind( A:Name ; B:Name ;;            <-  X:Name  ) =>   <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names    <-  X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePats <-  X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Lbind & D:Lbind  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Lbind & D:Lbinds ) => #subBind(A;B;;C) & #subBind(A;B;;D)
    // Repeated
  rule #subBind( A:Name ; B:Name ;;            <=  X:Name  ) =>   <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names    <=  X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePats <=  X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Rbind & D:Rbind  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Rbind & D:Rbinds ) => #subBind(A;B;;C) & #subBind(A;B;;D)
    // Peek
  rule #subBind( A:Name ; B:Name ;;            <<- X:Name  ) =>   <<- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names    <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePats <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Pbind & D:Pbind  ) => #subBind(A;B;;C) & #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Pbind & D:Pbinds ) => #subBind(A;B;;C) & #subBind(A;B;;D)

  // sub Name for Name in Send
  rule #sub( A:Name ; B:Name ; C:Name !  (         ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Name ; B:Name ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; C:Name !! (         ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Name ; B:Name ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Name for Name in Par
  rule #sub( A:Name ; B:Name ; C:Proc    | D:Proc ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isPar(A)
  rule #sub( A:Name ; B:Name ; C:Proc    | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isPar(A)
  rule #sub( A:Name ; B:Name ; C:ProcPat | D:Proc    ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isParPat(A)
  rule #sub( A:Name ; B:Name ; C:ProcPat | D:ProcPat ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isParPat(A)

  // sub Name for Name in Collections
    // RhoList
  rule #sub( _:Name ; _:Name ; [ ] ) => [ ]
  rule #sub( A:Name ; B:Name ; [ C:Procs ] ) => [ #sub(A;B;C) ]

    // RhoMap
  rule #sub( _:Name ; _:Name ; { } ) => { }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPairs } ) => { #subKV(A;B;C) }
      // RhoKVPairs
  rule #subKV( A:Name ; B:Name ; C:Proc : D:Proc ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:Name ; C:RhoKVPair , D:RhoKVPairs ) => #subKV(A;B;C) , #subKV(A;B;D)

    // RhoSet
  rule #sub( _:Name ; _:Name ; Set( ) ) => Set( )
  rule #sub( A:Name ; B:Name ; Set( C:Procs ) ) => Set( #sub(A;B;C) )

    // RhoTuple
  rule #sub( A:Name ; B:Name ; ( C:Procs ,) ) => ( #sub(A;B;C) ,)

  // sub Name for Name in New -- if substitution variable is bound, no substitution occurs, else substitute in Proc
  rule #sub( A:Name ; B:Var ; P:New ) => #if (B in #DV(P)) #then P #else #subNew(A;B;P) #fi
  rule #subNew( A:Name ; B:Name ; new C:VarDecs in { D:Proc } ) => new C in { #sub(A;B;D) }

// Arithmetic Exps
  rule #sub( A:Name ; B:Name ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Name ; B:Name ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
// String expressions
//  rule #sub( A:Name ; B:Name ; C:StringOrVar D:ConcatExp ) => #sub(A;B;C) #subConcat(A;B;D)
  rule #sub( A:Name ; B:Name ; C:ListOrVar   ++ D:ListOrVar   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:ListOrVar   ++ D:ConcatList  ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:StringOrVar ++ D:StringOrVar ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:StringOrVar ++ D:ConcatStr   ) => #sub(A;B;C) ++ #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:StringOrVar %% D:RhoMap      ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:StringOrVar %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:RhoMap      %% D:InterpMaps  ) => #sub(A;B;C) %% #sub(A;B;D)

// Boolean Exps
  rule #sub( A:Name ; B:Name ; not C:BExp ) => not #sub(A;B;C)
  rule #sub( A:Name ; B:Name ; C:BExp and D:BExp ) => #sub(A;B;C) and #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:BExp or  D:BExp ) => #sub(A;B;C) or  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp <=  D:AExp ) => #sub(A;B;C) <=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp <   D:AExp ) => #sub(A;B;C) <   #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp >=  D:AExp ) => #sub(A;B;C) >=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp >   D:AExp ) => #sub(A;B;C) >   #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Name ==  D:Name ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Name !=  D:Name ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc ==  D:Proc ) => #sub(A;B;C) ==  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc !=  D:Proc ) => #sub(A;B;C) !=  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc    matches D:Proc    ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:Proc    matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:ProcPat matches D:ProcPat ) => #sub(A;B;C) matches #sub(A;B;D)

// NPatExp -- TODO: complete
// sub Name for NPatAnd in Proc
//  rule #sub( _:Name ; ~ _:Proc    ; C:Proc ) => C
//  rule #sub( @A:Proc ; B:Name /\ @C:SimplePat ; D:Proc ) => #sub(A;*B/\C;D)

// Condtionals
  rule #sub( A:Name ; B:Name ; if (C:BExp) D:Proc   ) => if (#sub(A;B;C)) #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:IfThen else D:Proc ) => #sub(A;B;C) else #sub(A;B;D)

// sub Names for Names in Names
  rule #sub( A:Names ; B:Names ; C:Name , D:Names ) => #append(#sub(A;B;C);#sub(A;B;D))
// sub Names for Names in Procs
  rule #sub( A:Names ; B:Names ; C:Proc , D:Procs ) => #append(#sub(A;B;C);#sub(A;B;D))

// sub Name for Name in Map
  rule #sub( _:Name ; _:Name ; .Map ) => .Map
  rule #sub( A:Name ; B:Name ; C:Proc |-> D:Proc M:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;M)
  rule #sub( A:Name ; B:Name ; C:Name |-> D:Name M:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;M)

//-------------------------
//--- Map substitutions ---
//-------------------------
  rule #sub( .Map ; A:Names    ) => A
  rule #sub( .Map ; A:NamePats ) => A
  rule #sub( .Map ; A:Procs    ) => A
  rule #sub( .Map ; A:ProcPats ) => A
  // if no variables are map keys, then no substitution happens
//  rule #sub( M:Map ; N:Name    ) => N requires intersectSet(#FV(N),keys(M)) ==K .Set
//  rule #sub( M:Map ; N:NamePat ) => N requires intersectSet(#FV(N),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:Name    , B:Names    ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:NamePat , B:Names    ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:Name    , B:NamePats ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:NamePat , B:NamePats ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
  // if variables appear as map keys, substitute value for key
  rule #sub( Key:Name |-> Val:Name M:Map ; N:Names    ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Name |-> Val:Name M:Map ; N:NamePats ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:Names    ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:NamePats ) => #sub(M;#sub(Val;Key;N))

  // if no variables are map keys, then no substitution happens
//  rule #sub( M:Map ; P:Proc    ) => P requires intersectSet(#FV(P),keys(M)) ==K .Set
//  rule #sub( M:Map ; P:ProcPat ) => P requires intersectSet(#FV(N),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:Proc    , B:Procs    ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:ProcPat , B:Procs    ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:Proc    , B:ProcPats ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:ProcPat , B:ProcPats ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
  // if variables appear as map keys, substitute value for key
  rule #sub( Key:Name |-> Val:Name M:Map ; P:Procs    ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Name |-> Val:Name M:Map ; P:ProcPats ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:Procs    ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:ProcPats ) => #sub(M;#sub(Val;Key;P))

//-----------------
//--- #subGuard ---
//-----------------
// length(P) == length(N)
  rule #subGuard( P:Proc  ; N:Name     ; B:BExp ) => #sub(@P;N;B) //
  rule #subGuard( P:Proc  ; N:NamePat  ; B:BExp ) => #sub(@P;N;B) //
  rule #subGuard( P:Procs ; N:Names    ; B:BExp ) => #sub(#quotes(P);N;B)
  rule #subGuard( P:Procs ; N:NamePats ; B:BExp ) => #sub(#quotes(P);N;B)

//----------------
//--- Patterns ---
//----------------
// Trivial cases
  rule #sub( A:Proc ; A ; N:NamePat ) => N
  rule #sub( A:Proc ; A ; P:ProcPat ) => P

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

  // TODO: sub for Uri for #match

// Recusive cases -- destructuring substitution Proc or Name
  // sub Proc for Proc in @Proc
  rule #sub(  A:Proc ;  B:Proc ; @C:ProcPat ) => @#sub(A;B;C)

  // sub Proc for Proc in EvalPat
  rule #sub(  A:Proc ;  B:Proc ; *C:NamePat ) => *#sub(A;B;C)

  // sub Eval for Eval in ProcPat
  rule #sub( *A:Name ; *B:Name ;  C:ProcPat ) =>  #sub(A;B;C)

  // sub Proc for Proc in SendPat -- sub in channel and continuation
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name    !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! ( D:ProcPats ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name    !! ( D:ProcPats ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

// sub Proc for SimplePat -- TODO: add remaining SimplePats & SimpleNamePats
  rule #sub( A:Proc ; Bool        ; C:Proc ) => #if        isBool(A) #then C #else .K #fi
  rule #sub( A:Proc ; Int         ; C:Proc ) => #if         isInt(A) #then C #else .K #fi
  rule #sub( A:Proc ; String      ; C:Proc ) => #if      isString(A) #then C #else .K #fi
  rule #sub( A:Proc ; List        ; C:Proc ) => #if     isRhoList(A) #then C #else .K #fi
  rule #sub( A:Proc ; Map         ; C:Proc ) => #if      isRhoMap(A) #then C #else .K #fi
  rule #sub( A:Proc ; Set         ; C:Proc ) => #if      isRhoSet(A) #then C #else .K #fi
  rule #sub( A:Proc ; Tuple       ; C:Proc ) => #if    isRhoTuple(A) #then C #else .K #fi
  rule #sub( A:Proc ; Unforgeable ; C:Proc ) => #if isUnforgeable(A) #then C #else .K #fi
  rule #sub( A:Proc ; Uri         ; C:Proc ) => #if         isUri(A) #then C #else .K #fi
  rule #sub( A:Proc ; Proc        ; C:Proc ) => #if        isProc(A) #then C #else .K #fi
  rule #sub( A:Proc ; Ground      ; C:Proc ) => #if      isGround(A) #then C #else .K #fi
  rule #sub( A:Proc ; Par         ; C:Proc ) => #if         isPar(A) #then C #else .K #fi
  rule #sub( A:Proc ; Send        ; C:Proc ) => #if        isSend(A) #then C #else .K #fi
  rule #sub( A:Proc ; Receive     ; C:Proc ) => #if     isReceive(A) #then C #else .K #fi
  rule #sub( A:Proc ; ProcVar     ; C:Proc ) => #if     isProcVar(A) #then C #else .K #fi
  rule #sub( A:Proc ; Contract    ; C:Proc ) => #if    isContract(A) #then C #else .K #fi
  rule #sub( A:Proc ; Method      ; C:Proc ) => #if      isMethod(A) #then C #else .K #fi

// SimplePat -- sub invariant
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

// sub Proc for ProcPat in Proc
//  rule #sub( _:Proc ; ~ _:Proc    ; C:Proc ) => C
  rule #sub( A:Proc ;       B:Proc /\ Bool         ; C:Proc )
    => #if isBExp(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Bool         ; C:Proc )
    => #if isBExp(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Int          ; C:Proc )
    => #if isAExp(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Int          ; C:Proc )
    => #if isAExp(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ String       ; C:Proc )
    => #if isStringExp(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ String       ; C:Proc )
    => #if isStringExp(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ List         ; C:Proc )
    => #if   isListExp(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ List         ; C:Proc )
    => #if   isListExp(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Map          ; C:Proc )
    => #if isRhoMap(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Map          ; C:Proc )
    => #if isRhoMap(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Set          ; C:Proc )
    => #if isRhoSet(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Set          ; C:Proc )
    => #if isRhoSet(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Tuple        ; C:Proc )
    => #if isRhoTuple(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Tuple        ; C:Proc )
    => #if isRhoTuple(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Unforgeable  ; C:Proc )
    => #if isUnforgeable(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Unforgeable  ; C:Proc )
    => #if isUnforgeable(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Uri          ; C:Proc )
    => #if isUri(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Uri          ; C:Proc )
    => #if isUri(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;       B:Proc /\ ClosedProc   ; C:Proc ) => #if #match(A;ClosedProc) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;         Bool /\ B:Proc       ; C:Proc ) => #if        isBool(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;         Bool /\ B:ProcPat    ; C:Proc )
    => #if isBExp(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;          Int /\ B:Proc       ; C:Proc ) => #if         isInt(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;          Int /\ B:ProcPat    ; C:Proc )
    => #if isAExp(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;       String /\ B:Proc       ; C:Proc ) => #if      isString(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       String /\ B:ProcPat    ; C:Proc )
    => #if isStringExp(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;         List /\ B:Proc       ; C:Proc ) => #if     isRhoList(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;         List /\ B:ProcPat    ; C:Proc )
    => #if isListExp(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;          Map /\ B:Proc       ; C:Proc ) => #if      isRhoMap(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;          Map /\ B:ProcPat    ; C:Proc )
    => #if isRhoMap(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;          Set /\ B:Proc       ; C:Proc ) => #if      isRhoSet(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;          Set /\ B:ProcPat    ; C:Proc )
    => #if isRhoSet(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;        Tuple /\ B:Proc       ; C:Proc ) => #if    isRhoTuple(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;        Tuple /\ B:ProcPat    ; C:Proc )
    => #if isRhoTuple(A) orBool isBoundProc(A) orBool isEval(A)
       #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;  Unforgeable /\ B:Proc       ; C:Proc ) => #if isUnforgeable(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;          Uri /\ B:Proc       ; C:Proc ) => #if         isUri(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;   ClosedProc /\ B:Proc       ; C:Proc ) => #if #match(A;ClosedProc) #then #sub(A;B;C) #else C #fi

// sub RhoList for RhoList
  rule #sub( [ A:Procs ] ; [ B:Procs ] ; C:Name    ) => #sub(A;B;C)
  rule #sub( [ A:Procs ] ; [ B:Procs ] ; C:NamePat ) => #sub(A;B;C)
  rule #sub( [ A:Procs ] ; [ B:Procs ] ; C:Proc    ) => #sub(A;B;C)
  rule #sub( [ A:Procs ] ; [ B:Procs ] ; C:ProcPat ) => #sub(A;B;C)

// sub RhoMap for RhoMap
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPairs } ; C:Name    ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPairs } ; C:NamePat ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPairs } ; C:Proc    ) => #sub(A;B;C)
  rule #sub( { A:RhoKVPairs } ; { B:RhoKVPairs } ; C:ProcPat ) => #sub(A;B;C)

  rule #sub( A:Proc : B:Proc ; C:Proc : D:Proc ; E:Name    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc : D:Proc ; E:NamePat ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc : D:Proc ; E:Proc    ) => #sub(A,B;C,D;E)
  rule #sub( A:Proc : B:Proc ; C:Proc : D:Proc ; E:ProcPat ) => #sub(A,B;C,D;E)
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs ; E:Name    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs ; E:NamePat ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs ; E:Proc    ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:RhoKVPair , B:RhoKVPairs ; C:RhoKVPair , D:RhoKVPairs ; E:ProcPat ) => #sub(B;D;#sub(A;C;E))

// sub RhoSet for RhoSet
  rule #sub( Set( A:Procs ) ; Set( B:Procs ) ; C:Name    ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:Procs ) ; C:NamePat ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:Procs ) ; C:Proc    ) => #sub(A;B;C)
  rule #sub( Set( A:Procs ) ; Set( B:Procs ) ; C:ProcPat ) => #sub(A;B;C)

// sub RhoTuple for RhoTuple
  rule #sub( ( A:Procs ,) ; ( B:Procs ,) ; C:Name    ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:Procs ,) ; C:NamePat ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:Procs ,) ; C:Proc    ) => #sub(A;B;C)
  rule #sub( ( A:Procs ,) ; ( B:Procs ,) ; C:ProcPat ) => #sub(A;B;C)

// sub Proc[Pat]s for ProcPats
  rule #sub( A:Proc    , B:Procs    ; C:ProcPat , D:Procs    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:Procs    ; C:Proc    , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:Procs    ; C:ProcPat , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:Procs    ; C:ProcPat , D:Procs    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:Procs    ; C:Proc    , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:Procs    ; C:ProcPat , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:Procs    ; C:ProcPat , D:Procs    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:ProcPats ; C:Proc    , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:Procs    ; C:ProcPat , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:ProcPats ; C:ProcPat , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:Procs    ; C:ProcPat , D:Procs    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:ProcPats ; C:Proc    , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:Procs    ; C:ProcPat , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:ProcPats ; C:ProcPat , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))

// sub Name[Pat]s for Name[Pat]s
  rule #sub( A:Name    , B:Names    ; C:Name    , D:Names    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:Name    , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:NamePat , D:Names    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:Name    , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:Name    , D:Names    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:Name    , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:NamePat , D:Names    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:NamePat , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:Name    , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:NamePat , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))

//-------------------
//--- #subcontext ---
//-------------------
// Funcdamental substitution contexts
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

  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule
