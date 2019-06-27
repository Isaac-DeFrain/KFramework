// Substitution for Rholang
/*
TODO:
 - add remaining features - Methods, Bundles, Match
 - more testing
 - sub for Uri for #match
*/
/*
  This substitution function is needed to make distinct the notions of name variables and process variables.
  The builtin substitution does not make this distinction.
  E.g. we want the substitution (x!(\x))[@Nil / x] to result in @Nil!(\x) since we only substitute for x:NameVar, NOT \x:ProcVar
    the definitions of NameVar ::= Var and ProcVar ::= "\\" Var don't allow for this with the the builtin substitution
*/

require "domains.k"
require "../AuxFun/auxfun.k"
require "../Names_Variables/namevar.k"
require "../grho.k"

module SUB-SYNTAX
  import GRHO-SYNTAX
  import DOMAINS

// Proc/ProcPat subs into Proc
  syntax       Proc ::= "#sub(" Proc     ";" Proc     ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Proc     ";" ProcPat  ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" ProcPat  ";" Proc     ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" ProcPat  ";" ProcPat  ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Procs    ";" Procs    ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Procs    ";" ProcPats ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" ProcPats ";" Procs    ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" ProcPats ";" ProcPats ";" Proc ")" [function, poly(0,3)]

// Name/NamePat subs into Proc
  syntax       Proc ::= "#sub(" Name     ";" Name     ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Name     ";" NamePat  ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" NamePat  ";" Name     ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" NamePat  ";" NamePat  ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Names    ";" Names    ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" Names    ";" NamePats ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" NamePats ";" Names    ";" Proc ")" [function, poly(0,3)]
                      | "#sub(" NamePats ";" NamePats ";" Proc ")" [function, poly(0,3)]

// Proc/ProcPat subs into Procs
  syntax      Procs ::= "#sub(" Proc     ";" Proc     ";" Procs ")" [function]
                      | "#sub(" Proc     ";" ProcPat  ";" Procs ")" [function]
                      | "#sub(" ProcPat  ";" Proc     ";" Procs ")" [function]
                      | "#sub(" ProcPat  ";" ProcPat  ";" Procs ")" [function]
                      | "#sub(" Procs    ";" Procs    ";" Procs ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" Procs ")" [function]
                      | "#sub(" ProcPats ";" Procs    ";" Procs ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" Procs ")" [function]

// Name/NamePat subs into Procs
  syntax      Procs ::= "#sub(" Name     ";" Name     ";" Procs ")" [function]
                      | "#sub(" Name     ";" NamePat  ";" Procs ")" [function]
                      | "#sub(" NamePat  ";" Name     ";" Procs ")" [function]
                      | "#sub(" NamePat  ";" NamePat  ";" Procs ")" [function]
                      | "#sub(" Names    ";" Names    ";" Procs ")" [function]
                      | "#sub(" Names    ";" NamePats ";" Procs ")" [function]
                      | "#sub(" NamePats ";" Names    ";" Procs ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" Procs ")" [function]

// Receive subs
  // if substitutions are not included in listens -- #subRec
  syntax       Proc ::= "#subRec(" Proc     ";" Proc     ";" Proc ")" [function]
                      | "#subRec(" Proc     ";" ProcPat  ";" Proc ")" [function]
                      | "#subRec(" ProcPat  ";" ProcPat  ";" Proc ")" [function]
                      | "#subRec(" Procs    ";" Procs    ";" Proc ")" [function]
                      | "#subRec(" Procs    ";" ProcPats ";" Proc ")" [function]
                      | "#subRec(" ProcPats ";" ProcPats ";" Proc ")" [function]
                      | "#subRec(" Name     ";" Name     ";" Proc ")" [function]
                      | "#subRec(" Name     ";" NamePat  ";" Proc ")" [function]
                      | "#subRec(" NamePat  ";" NamePat  ";" Proc ")" [function]
                      | "#subRec(" Names    ";" Names    ";" Proc ")" [function]
                      | "#subRec(" Names    ";" NamePats ";" Proc ")" [function]
                      | "#subRec(" NamePats ";" NamePats ";" Proc ")" [function]

  // if substitutions are included in listens -- #subChan
  syntax       Proc ::= "#subChan(" Proc     ";" Proc     ";" Proc ")" [function]
                      | "#subChan(" Proc     ";" ProcPat  ";" Proc ")" [function]
                      | "#subChan(" ProcPat  ";" ProcPat  ";" Proc ")" [function]
                      | "#subChan(" Procs    ";" Procs    ";" Proc ")" [function]
                      | "#subChan(" Procs    ";" ProcPats ";" Proc ")" [function]
                      | "#subChan(" ProcPats ";" ProcPats ";" Proc ")" [function]
                      | "#subChan(" Name     ";" Name     ";" Proc ")" [function]
                      | "#subChan(" Name     ";" NamePat  ";" Proc ")" [function]
                      | "#subChan(" NamePat  ";" NamePat  ";" Proc ")" [function]
                      | "#subChan(" Names    ";" Names    ";" Proc ")" [function]
                      | "#subChan(" Names    ";" NamePats ";" Proc ")" [function]
                      | "#subChan(" NamePats ";" NamePats ";" Proc ")" [function]

// Binds -- TODO: guarded
  syntax      Lbind ::= "#subBind(" Proc     ";" Proc     ";;" Lbind  ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" Lbind  ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" Lbind  ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" Lbind  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Lbind  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Lbind  ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" Lbind  ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" Lbind  ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" Lbind  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Lbind  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Lbind  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Lbind  ")" [function]
  syntax     Lbinds ::= "#subBind(" Proc     ";" Proc     ";;" Lbinds ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" Lbinds ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" Lbinds ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" Lbinds ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Lbinds ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Lbinds ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" Lbinds ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" Lbinds ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" Lbinds ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Lbinds ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Lbinds ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Lbinds ")" [function]
  syntax      Pbind ::= "#subBind(" Proc     ";" Proc     ";;" Pbind  ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" Pbind  ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" Pbind  ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" Pbind  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Pbind  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Pbind  ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" Pbind  ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" Pbind  ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" Pbind  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Pbind  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Pbind  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Pbind  ")" [function]
  syntax     Pbinds ::= "#subBind(" Proc     ";" Proc     ";;" Pbinds ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" Pbinds ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" Pbinds ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" Pbinds ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Pbinds ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Pbinds ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" Pbinds ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" Pbinds ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" Pbinds ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Pbinds ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Pbinds ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Pbinds ")" [function]
  syntax      Rbind ::= "#subBind(" Proc     ";" Proc     ";;" Rbind  ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" Rbind  ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" Rbind  ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" Rbind  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Rbind  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Rbind  ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" Rbind  ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" Rbind  ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" Rbind  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Rbind  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Rbind  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Rbind  ")" [function]
  syntax     Rbinds ::= "#subBind(" Proc     ";" Proc     ";;" Rbinds ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" Rbinds ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" Rbinds ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" Rbinds ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" Rbinds ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" Rbinds ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" Rbinds ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" Rbinds ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" Rbinds ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" Rbinds ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" Rbinds ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" Rbinds ")" [function]

  // New substitution
  syntax        New ::= "#subNew(" Proc     ";" Proc     ";" New ")" [function]
                      | "#subNew(" Proc     ";" ProcPat  ";" New ")" [function]
                      | "#subNew(" ProcPat  ";" ProcPat  ";" New ")" [function]
                      | "#subNew(" Procs    ";" Procs    ";" New ")" [function]
                      | "#subNew(" Procs    ";" ProcPats ";" New ")" [function]
                      | "#subNew(" ProcPats ";" ProcPats ";" New ")" [function]
                      | "#subNew(" Name     ";" Name     ";" New ")" [function]
                      | "#subNew(" Name     ";" NamePat  ";" New ")" [function]
                      | "#subNew(" NamePat  ";" NamePat  ";" New ")" [function]
                      | "#subNew(" Names    ";" Names    ";" New ")" [function]
                      | "#subNew(" Names    ";" NamePats ";" New ")" [function]
                      | "#subNew(" NamePats ";" NamePats ";" New ")" [function]

  // Match substitution
  syntax      Match ::= "#subMatch(" Proc     ";" Proc     ";" Match ")" [function]
                      | "#subMatch(" Proc     ";" ProcPat  ";" Match ")" [function]
                      | "#subMatch(" ProcPat  ";" ProcPat  ";" Match ")" [function]
                      | "#subMatch(" Procs    ";" Procs    ";" Match ")" [function]
                      | "#subMatch(" Procs    ";" ProcPats ";" Match ")" [function]
                      | "#subMatch(" ProcPats ";" ProcPats ";" Match ")" [function]
                      | "#subMatch(" Name     ";" Name     ";" Match ")" [function]
                      | "#subMatch(" Name     ";" NamePat  ";" Match ")" [function]
                      | "#subMatch(" NamePat  ";" NamePat  ";" Match ")" [function]
                      | "#subMatch(" Names    ";" Names    ";" Match ")" [function]
                      | "#subMatch(" Names    ";" NamePats ";" Match ")" [function]
                      | "#subMatch(" NamePats ";" NamePats ";" Match ")" [function]

// RhoMap
  syntax  RhoKVPair ::= "#subKV(" Proc     ";" Proc     ";" RhoKVPair  ")" [function]
                      | "#subKV(" Proc     ";" ProcPat  ";" RhoKVPair  ")" [function]
                      | "#subKV(" ProcPat  ";" ProcPat  ";" RhoKVPair  ")" [function]
                      | "#subKV(" Procs    ";" Procs    ";" RhoKVPair  ")" [function]
                      | "#subKV(" Procs    ";" ProcPats ";" RhoKVPair  ")" [function]
                      | "#subKV(" ProcPats ";" ProcPats ";" RhoKVPair  ")" [function]
                      | "#subKV(" Name     ";" Name     ";" RhoKVPair  ")" [function]
                      | "#subKV(" Name     ";" NamePat  ";" RhoKVPair  ")" [function]
                      | "#subKV(" NamePat  ";" NamePat  ";" RhoKVPair  ")" [function]
                      | "#subKV(" Names    ";" Names    ";" RhoKVPair  ")" [function]
                      | "#subKV(" Names    ";" NamePats ";" RhoKVPair  ")" [function]
                      | "#subKV(" NamePats ";" NamePats ";" RhoKVPair  ")" [function]
  syntax RhoKVPairs ::= "#subKV(" Proc     ";" Proc     ";" RhoKVPairs ")" [function]
                      | "#subKV(" Proc     ";" ProcPat  ";" RhoKVPairs ")" [function]
                      | "#subKV(" ProcPat  ";" ProcPat  ";" RhoKVPairs ")" [function]
                      | "#subKV(" Procs    ";" Procs    ";" RhoKVPairs ")" [function]
                      | "#subKV(" Procs    ";" ProcPats ";" RhoKVPairs ")" [function]
                      | "#subKV(" ProcPats ";" ProcPats ";" RhoKVPairs ")" [function]
                      | "#subKV(" Name     ";" Name     ";" RhoKVPairs ")" [function]
                      | "#subKV(" Name     ";" NamePat  ";" RhoKVPairs ")" [function]
                      | "#subKV(" NamePat  ";" NamePat  ";" RhoKVPairs ")" [function]
                      | "#subKV(" Names    ";" Names    ";" RhoKVPairs ")" [function]
                      | "#subKV(" Names    ";" NamePats ";" RhoKVPairs ")" [function]
                      | "#subKV(" NamePats ";" NamePats ";" RhoKVPairs ")" [function]

// String expressions
  syntax  ConcatExp ::= "#subConcat(" Proc     ";" Proc     ";" ConcatExp  ")" [function]
                      | "#subConcat(" Proc     ";" ProcPat  ";" ConcatExp  ")" [function]
                      | "#subConcat(" ProcPat  ";" ProcPat  ";" ConcatExp  ")" [function]
                      | "#subConcat(" Procs    ";" Procs    ";" ConcatExp  ")" [function]
                      | "#subConcat(" Procs    ";" ProcPats ";" ConcatExp  ")" [function]
                      | "#subConcat(" ProcPats ";" ProcPats ";" ConcatExp  ")" [function]
                      | "#subConcat(" Name     ";" Name     ";" ConcatExp  ")" [function]
                      | "#subConcat(" Name     ";" NamePat  ";" ConcatExp  ")" [function]
                      | "#subConcat(" NamePat  ";" NamePat  ";" ConcatExp  ")" [function]
                      | "#subConcat(" Names    ";" Names    ";" ConcatExp  ")" [function]
                      | "#subConcat(" Names    ";" NamePats ";" ConcatExp  ")" [function]
                      | "#subConcat(" NamePats ";" NamePats ";" ConcatExp  ")" [function]
  syntax InterpMaps ::= "#subInterp(" Proc     ";" Proc     ";" InterpMaps ")" [function]
                      | "#subInterp(" Proc     ";" ProcPat  ";" InterpMaps ")" [function]
                      | "#subInterp(" ProcPat  ";" ProcPat  ";" InterpMaps ")" [function]
                      | "#subInterp(" Procs    ";" Procs    ";" InterpMaps ")" [function]
                      | "#subInterp(" Procs    ";" ProcPats ";" InterpMaps ")" [function]
                      | "#subInterp(" ProcPats ";" ProcPats ";" InterpMaps ")" [function]
                      | "#subInterp(" Name     ";" Name     ";" InterpMaps ")" [function]
                      | "#subInterp(" Name     ";" NamePat  ";" InterpMaps ")" [function]
                      | "#subInterp(" NamePat  ";" NamePat  ";" InterpMaps ")" [function]
                      | "#subInterp(" Names    ";" Names    ";" InterpMaps ")" [function]
                      | "#subInterp(" Names    ";" NamePats ";" InterpMaps ")" [function]
                      | "#subInterp(" NamePats ";" NamePats ";" InterpMaps ")" [function]

// Name substitution
  syntax       Name ::= "#sub(" Proc     ";" Proc     ";" Name ")" [function]
                      | "#sub(" Proc     ";" ProcPat  ";" Name ")" [function]
                      | "#sub(" ProcPat  ";" Proc     ";" Name ")" [function]
                      | "#sub(" ProcPat  ";" ProcPat  ";" Name ")" [function]
                      | "#sub(" Procs    ";" Procs    ";" Name ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" Name ")" [function]
                      | "#sub(" ProcPats ";" Procs    ";" Name ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" Name ")" [function]
                      | "#sub(" Name     ";" Name     ";" Name ")" [function]
                      | "#sub(" Name     ";" NamePat  ";" Name ")" [function]
                      | "#sub(" NamePat  ";" Name     ";" Name ")" [function]
                      | "#sub(" NamePat  ";" NamePat  ";" Name ")" [function]
                      | "#sub(" Names    ";" Names    ";" Name ")" [function]
                      | "#sub(" Names    ";" NamePats ";" Name ")" [function]
                      | "#sub(" NamePats ";" Names    ";" Name ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" Name ")" [function]

  syntax      Names ::= "#sub(" Proc     ";" Proc     ";" Names ")" [function]
                      | "#sub(" Proc     ";" ProcPat  ";" Names ")" [function]
                      | "#sub(" ProcPat  ";" Proc     ";" Names ")" [function]
                      | "#sub(" ProcPat  ";" ProcPat  ";" Names ")" [function]
                      | "#sub(" Procs    ";" Procs    ";" Names ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" Names ")" [function]
                      | "#sub(" ProcPats ";" Procs    ";" Names ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" Names ")" [function]
                      | "#sub(" Name     ";" Name     ";" Names ")" [function]
                      | "#sub(" Name     ";" NamePat  ";" Names ")" [function]
                      | "#sub(" NamePat  ";" Name     ";" Names ")" [function]
                      | "#sub(" NamePat  ";" NamePat  ";" Names ")" [function]
                      | "#sub(" Names    ";" Names    ";" Names ")" [function]
                      | "#sub(" Names    ";" NamePats ";" Names ")" [function]
                      | "#sub(" NamePats ";" Names    ";" Names ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" Names ")" [function]

// Process Pattern substitution
  syntax    ProcPat ::= "#sub(" Proc     ";" Proc     ";" ProcPat ")" [function]
                      | "#sub(" Proc     ";" ProcPat  ";" ProcPat ")" [function]
                      | "#sub(" ProcPat  ";" ProcPat  ";" ProcPat ")" [function]
                      | "#sub(" Procs    ";" Procs    ";" ProcPat ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" ProcPat ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" ProcPat ")" [function]
                      | "#sub(" Name     ";" Name     ";" ProcPat ")" [function]
                      | "#sub(" Name     ";" NamePat  ";" ProcPat ")" [function]
                      | "#sub(" NamePat  ";" NamePat  ";" ProcPat ")" [function]
                      | "#sub(" Names    ";" Names    ";" ProcPat ")" [function]
                      | "#sub(" Names    ";" NamePats ";" ProcPat ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" ProcPat ")" [function]

  // Receive pattern
  syntax    ProcPat ::=  "#subRec(" Proc     ";" Proc     ";" ProcPat ")" [function]
                      |  "#subRec(" Proc     ";" ProcPat  ";" ProcPat ")" [function]
                      |  "#subRec(" ProcPat  ";" ProcPat  ";" ProcPat ")" [function]
                      |  "#subRec(" Procs    ";" Procs    ";" ProcPat ")" [function]
                      |  "#subRec(" Procs    ";" ProcPats ";" ProcPat ")" [function]
                      |  "#subRec(" ProcPats ";" ProcPats ";" ProcPat ")" [function]
                      |  "#subRec(" Name     ";" Name     ";" ProcPat ")" [function]
                      |  "#subRec(" Name     ";" NamePat  ";" ProcPat ")" [function]
                      |  "#subRec(" NamePat  ";" NamePat  ";" ProcPat ")" [function]
                      |  "#subRec(" Names    ";" Names    ";" ProcPat ")" [function]
                      |  "#subRec(" Names    ";" NamePats ";" ProcPat ")" [function]
                      |  "#subRec(" NamePats ";" NamePats ";" ProcPat ")" [function]
                      | "#subChan(" Proc     ";" Proc     ";" ProcPat ")" [function]
                      | "#subChan(" Proc     ";" ProcPat  ";" ProcPat ")" [function]
                      | "#subChan(" ProcPat  ";" ProcPat  ";" ProcPat ")" [function]
                      | "#subChan(" Procs    ";" Procs    ";" ProcPat ")" [function]
                      | "#subChan(" Procs    ";" ProcPats ";" ProcPat ")" [function]
                      | "#subChan(" ProcPats ";" ProcPats ";" ProcPat ")" [function]
                      | "#subChan(" Name     ";" Name     ";" ProcPat ")" [function]
                      | "#subChan(" Name     ";" NamePat  ";" ProcPat ")" [function]
                      | "#subChan(" NamePat  ";" NamePat  ";" ProcPat ")" [function]
                      | "#subChan(" Names    ";" Names    ";" ProcPat ")" [function]
                      | "#subChan(" Names    ";" NamePats ";" ProcPat ")" [function]
                      | "#subChan(" NamePats ";" NamePats ";" ProcPat ")" [function]

  syntax   LbindPat ::= "#subBind(" Proc     ";" Proc     ";;" LbindPat  ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" LbindPat  ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" LbindPat  ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" LbindPat  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" LbindPat  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" LbindPat  ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" LbindPat  ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" LbindPat  ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" LbindPat  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" LbindPat  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" LbindPat  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" LbindPat  ")" [function]
  syntax  LbindPats ::= "#subBind(" Proc     ";" Proc     ";;" LbindPats ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" LbindPats ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" LbindPats ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" LbindPats ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" LbindPats ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" LbindPats ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" LbindPats ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" LbindPats ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" LbindPats ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" LbindPats ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" LbindPats ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" LbindPats ")" [function]
  syntax   PbindPat ::= "#subBind(" Proc     ";" Proc     ";;" PbindPat  ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" PbindPat  ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" PbindPat  ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" PbindPat  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" PbindPat  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" PbindPat  ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" PbindPat  ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" PbindPat  ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" PbindPat  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" PbindPat  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" PbindPat  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" PbindPat  ")" [function]
  syntax  PbindPats ::= "#subBind(" Proc     ";" Proc     ";;" PbindPats ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" PbindPats ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" PbindPats ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" PbindPats ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" PbindPats ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" PbindPats ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" PbindPats ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" PbindPats ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" PbindPats ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" PbindPats ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" PbindPats ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" PbindPats ")" [function]
  syntax   RbindPat ::= "#subBind(" Proc     ";" Proc     ";;" RbindPat  ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" RbindPat  ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" RbindPat  ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" RbindPat  ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" RbindPat  ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" RbindPat  ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" RbindPat  ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" RbindPat  ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" RbindPat  ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" RbindPat  ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" RbindPat  ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" RbindPat  ")" [function]
  syntax  RbindPats ::= "#subBind(" Proc     ";" Proc     ";;" RbindPats ")" [function]
                      | "#subBind(" Proc     ";" ProcPat  ";;" RbindPats ")" [function]
                      | "#subBind(" ProcPat  ";" ProcPat  ";;" RbindPats ")" [function]
                      | "#subBind(" Procs    ";" Procs    ";;" RbindPats ")" [function]
                      | "#subBind(" Procs    ";" ProcPats ";;" RbindPats ")" [function]
                      | "#subBind(" ProcPats ";" ProcPats ";;" RbindPats ")" [function]
                      | "#subBind(" Name     ";" Name     ";;" RbindPats ")" [function]
                      | "#subBind(" Name     ";" NamePat  ";;" RbindPats ")" [function]
                      | "#subBind(" NamePat  ";" NamePat  ";;" RbindPats ")" [function]
                      | "#subBind(" Names    ";" Names    ";;" RbindPats ")" [function]
                      | "#subBind(" Names    ";" NamePats ";;" RbindPats ")" [function]
                      | "#subBind(" NamePats ";" NamePats ";;" RbindPats ")" [function]

  // New pattern
  syntax     NewPat ::= "#subNew(" Proc     ";" Proc     ";" NewPat ")" [function]
                      | "#subNew(" Proc     ";" ProcPat  ";" NewPat ")" [function]
                      | "#subNew(" ProcPat  ";" ProcPat  ";" NewPat ")" [function]
                      | "#subNew(" Procs    ";" Procs    ";" NewPat ")" [function]
                      | "#subNew(" Procs    ";" ProcPats ";" NewPat ")" [function]
                      | "#subNew(" ProcPats ";" ProcPats ";" NewPat ")" [function]
                      | "#subNew(" Name     ";" Name     ";" NewPat ")" [function]
                      | "#subNew(" Name     ";" NamePat  ";" NewPat ")" [function]
                      | "#subNew(" NamePat  ";" NamePat  ";" NewPat ")" [function]
                      | "#subNew(" Names    ";" Names    ";" NewPat ")" [function]
                      | "#subNew(" Names    ";" NamePats ";" NewPat ")" [function]
                      | "#subNew(" NamePats ";" NamePats ";" NewPat ")" [function]

  // Match pattern
  syntax   MatchPat ::= "#subMatch(" Proc     ";" Proc     ";" MatchPat ")" [function]
                      | "#subMatch(" Proc     ";" ProcPat  ";" MatchPat ")" [function]
                      | "#subMatch(" ProcPat  ";" ProcPat  ";" MatchPat ")" [function]
                      | "#subMatch(" Procs    ";" Procs    ";" MatchPat ")" [function]
                      | "#subMatch(" Procs    ";" ProcPats ";" MatchPat ")" [function]
                      | "#subMatch(" ProcPats ";" ProcPats ";" MatchPat ")" [function]
                      | "#subMatch(" Name     ";" Name     ";" MatchPat ")" [function]
                      | "#subMatch(" Name     ";" NamePat  ";" MatchPat ")" [function]
                      | "#subMatch(" NamePat  ";" NamePat  ";" MatchPat ")" [function]
                      | "#subMatch(" Names    ";" Names    ";" MatchPat ")" [function]
                      | "#subMatch(" Names    ";" NamePats ";" MatchPat ")" [function]
                      | "#subMatch(" NamePats ";" NamePats ";" MatchPat ")" [function]

  syntax   ProcPats ::= "#sub(" Proc     ";" Proc     ";" ProcPats ")" [function]
                      | "#sub(" Proc     ";" ProcPat  ";" ProcPats ")" [function]
                      | "#sub(" ProcPat  ";" ProcPat  ";" ProcPats ")" [function]
                      | "#sub(" Procs    ";" Procs    ";" ProcPats ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" ProcPats ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" ProcPats ")" [function]
                      | "#sub(" Name     ";" Name     ";" ProcPats ")" [function]
                      | "#sub(" Name     ";" NamePat  ";" ProcPats ")" [function]
                      | "#sub(" NamePat  ";" NamePat  ";" ProcPats ")" [function]
                      | "#sub(" Names    ";" Names    ";" ProcPats ")" [function]
                      | "#sub(" Names    ";" NamePats ";" ProcPats ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" ProcPats ")" [function]

// Name Pattern substitution
  syntax    NamePat ::= "#sub(" Proc     ";" Proc     ";" NamePat  ")" [function]
                      | "#sub(" Proc     ";" ProcPat  ";" NamePat  ")" [function]
                      | "#sub(" ProcPat  ";" ProcPat  ";" NamePat  ")" [function]
                      | "#sub(" Procs    ";" Procs    ";" NamePat  ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" NamePat  ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" NamePat  ")" [function]
                      | "#sub(" Name     ";" Name     ";" NamePat  ")" [function]
                      | "#sub(" Name     ";" NamePat  ";" NamePat  ")" [function]
                      | "#sub(" NamePat  ";" NamePat  ";" NamePat  ")" [function]
                      | "#sub(" Names    ";" Names    ";" NamePat  ")" [function]
                      | "#sub(" Names    ";" NamePats ";" NamePat  ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" NamePat  ")" [function]

  syntax   NamePats ::= "#sub(" Proc     ";" Proc     ";" NamePats ")" [function]
                      | "#sub(" Proc     ";" ProcPat  ";" NamePats ")" [function]
                      | "#sub(" ProcPat  ";" ProcPat  ";" NamePats ")" [function]
                      | "#sub(" Procs    ";" Procs    ";" NamePats ")" [function]
                      | "#sub(" Procs    ";" ProcPats ";" NamePats ")" [function]
                      | "#sub(" ProcPats ";" ProcPats ";" NamePats ")" [function]
                      | "#sub(" Name     ";" Name     ";" NamePats ")" [function]
                      | "#sub(" Name     ";" NamePat  ";" NamePats ")" [function]
                      | "#sub(" NamePat  ";" NamePat  ";" NamePats ")" [function]
                      | "#sub(" Names    ";" Names    ";" NamePats ")" [function]
                      | "#sub(" Names    ";" NamePats ";" NamePats ")" [function]
                      | "#sub(" NamePats ";" NamePats ";" NamePats ")" [function]

// Map substitutions
  syntax       Name ::= "#sub(" Map ";" Name  ")" [function]
  syntax      Names ::= "#sub(" Map ";" Names ")" [function]
  syntax       Proc ::= "#sub(" Map ";" Proc  ")" [function, poly(0,2)]
  syntax      Procs ::= "#sub(" Map ";" Procs ")" [function]

  syntax    NamePat ::= "#sub(" Map ";" NamePat  ")" [function]
  syntax   NamePats ::= "#sub(" Map ";" NamePats ")" [function]
  syntax    ProcPat ::= "#sub(" Map ";" ProcPat  ")" [function]
  syntax   ProcPats ::= "#sub(" Map ";" ProcPats ")" [function]

  syntax        Map ::= "#sub2map(" Proc     ";" Proc     ")" [function]
                      | "#sub2map(" Proc     ";" ProcPat  ")" [function]
                      | "#sub2map(" ProcPat  ";" ProcPat  ")" [function]
                      | "#sub2map(" Procs    ";" Procs    ")" [function]
                      | "#sub2map(" Procs    ";" ProcPats ")" [function]
                      | "#sub2map(" ProcPats ";" ProcPats ")" [function]
                      | "#sub2map(" Name     ";" Name     ")" [function]
                      | "#sub2map(" Name     ";" NamePat  ")" [function]
                      | "#sub2map(" NamePat  ";" NamePat  ")" [function]
                      | "#sub2map(" Names    ";" Names    ")" [function]
                      | "#sub2map(" Names    ";" NamePats ")" [function]
                      | "#sub2map(" NamePats ";" NamePats ")" [function]

// Input guard satisfaction predicate for comm in Grho
  syntax       Bool ::= "#subGuard(" Proc  ";" Name     ";" BExp ")" [function]
                      | "#subGuard(" Proc  ";" NamePat  ";" BExp ")" [function]
  syntax       Bool ::= "#subGuard(" Procs ";" Names    ";" BExp ")" [function]
                      | "#subGuard(" Procs ";" NamePats ";" BExp ")" [function]

endmodule

module SUB
  import SUB-SYNTAX
  import AUXFUN
  import NAMEVAR

  syntax KResult ::= Proc | Procs | Bind | Binds | New | Match | ConcatExp | InterpMaps | RhoKVPair | RhoKVPairs
                   | ProcPat | ProcPats | BindPat | BindPats | NewPat | MatchPat
                   | Name | Name | NamePat | NamePats

// BoundName/Proc subs for ALPHA
  // requirements of #sub function on BoundNames/Procs for finishing De Bruijn index substitutions
  rule #sub( A:Name ; B:Name ;  C:BoundName ) =>  C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ;  C:BoundName ) =>  C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:Name ; B:Name ; *C:BoundName ) => *C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ; *C:BoundName ) => *C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:BoundName ; _:BoundName ;  _:BoundName ) =>  A
  rule #sub( A:BoundName ; _:BoundName ; *_:BoundName ) => *A
  rule #sub( A:BoundName ; _:BoundName ;  _:NameVar   ) =>  A
  rule #sub( A:BoundName ; _:BoundName ; *_:NameVar   ) => *A
  // no sub BoundName for BoundName in ProcVar
  rule #sub( _:BoundName ; _:BoundName ;  C:ProcVar   ) =>  C
  rule #sub( _:BoundName ; _:BoundName ; @C:ProcVar   ) => @C
  // no sub BoundName for BoundName in BoundProc
  rule #sub( _:BoundName ; _:BoundName ;  C:BoundProc ) =>  C
  rule #sub( _:BoundName ; _:BoundName ; @C:BoundProc ) => @C

  rule #sub( A:Name ; B:Name ;  C:BoundProc ) =>  C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ;  C:BoundProc ) =>  C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:Name ; B:Name ; @C:BoundProc ) => @C requires notBool (isBoundName(A) andBool isBoundName(B))
  rule #sub( A:Proc ; B:Proc ; @C:BoundProc ) => @C requires notBool (isBoundProc(A) andBool isBoundProc(B))
  rule #sub( A:BoundProc ; _:BoundProc ;  _:BoundProc ) =>  A
  rule #sub( A:BoundProc ; _:BoundProc ; @_:BoundProc ) => @A
  rule #sub( A:BoundProc ; _:BoundProc ;  _:ProcVar   ) =>  A
  rule #sub( A:BoundProc ; _:BoundProc ; @_:ProcVar   ) => @A
  // no sub BoundProc for BoundProc in NameVar
  rule #sub( _:BoundProc ; _:BoundProc ;  C:NameVar   ) =>  C
  rule #sub( _:BoundProc ; _:BoundProc ; *C:NameVar   ) => *C
  // no sub BoundProc for BoundProc in BoundName
  rule #sub( _:BoundProc ; _:BoundProc ;  C:BoundName ) =>  C
  rule #sub( _:BoundProc ; _:BoundProc ; *C:BoundName ) => *C

// For #mapSub -- de Bruijn indexing for Receive 
  rule #sub( _:Name ; @sub ; N:Name ) => N
  rule #sub( _:Name ; @sub ; P:Proc ) => P
  rule #sub( _:Proc ;  sub ; N:Name ) => N
  rule #sub( _:Proc ;  sub ; P:Proc ) => P
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

//------------------------------------------------
//--- Substitute Proc for Proc in Proc or Name ---
//------------------------------------------------
// Trivial cases
  rule #sub( A:Proc ; A ; N:Name ) => N
  rule #sub( A:Proc ; A ; P:Proc ) => P
  rule #sub( _:Proc ; _:Proc ; G:Ground ) => G

// Fundamental cases -- variables
  // sub Proc for ProcVar in ProcVar or NameVar
  rule #sub( A:Proc ; B:ProcVar ; C:ProcVar ) => A requires B ==K C
  rule #sub( A:Proc ; B:ProcVar ; C:ProcVar ) => C requires B =/=K C
  rule #sub( _:Proc ; _:ProcVar ; A:NameVar ) => A

  // sub Proc for *NameVar in NameVar or ProcVar
  rule #sub( A:Proc ; *B:NameVar ; C:NameVar ) => @A requires B ==K C
  rule #sub( A:Proc ; *B:NameVar ; C:NameVar ) =>  C requires B =/=K C
  rule #sub( _:Proc ; *_:NameVar ; A:ProcVar ) =>  A

  // TODO: sub for Uri for #match

// Recusive cases -- destructuring substitution Proc or Name
  // sub Proc for Proc in @Proc
  rule #sub( A:Proc ; B:Proc ; @C:Proc ) => @ #sub(A;B;C)

  // sub Proc for Proc in *Name
  rule #sub( A:Proc ; B:Proc ; *C:Name ) => * #sub(A;B;C)

  // sub *Name for *Name in Proc
  rule #sub( *A:Name ; *B:Name ; C:Proc ) => #sub(A;B;C)

  // sub Proc for Proc in Send -- sub in channel and continuation
  rule #sub( A:Proc ; B:Proc ; C:Name !  (         ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Proc  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! (         ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Proc  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Proc for Proc in Receive -- only substitute free variables in channel and continuation
    // if substitution variables are all listening variables and not receive variables, then no substitution occurs
  rule #sub( _:Proc ;  B:Proc    ; Rec:Receive ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
    // if substitution variables are distinct from free variables in Rec, then no substitution occurs
  rule #sub( _:Proc ;  B:Proc    ; Rec:Receive ) => Rec requires intersectSet(#FV(B),#FV(Rec)) <=Set .Set
    // substituting for a ProcVar -- if ProcVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Proc ;  B:ProcVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
    // substituting for *NameVar -- if NameVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Proc ; *B:NameVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(@A;B;Rec) #else #subRec(@A;B;Rec) #fi

    // if substitution variable is a listening variable, then it is only substituted in the channel (not in the guard or continuation)
  rule #subChan( A:Proc ; B:ProcVar ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ Cont }
    // guarded
  rule #subChan( A:Proc ; B:ProcVar ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)   if #sub(A;B;G)){ Cont }
  rule #subChan( A:Proc ; B:ProcVar ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs)  if #sub(A;B;G)){ Cont }

    // if NameVar to be substituted not a listening variable, then it is substituted in the channel and continuation (and guard)
  rule #subRec( A:Proc ; B:ProcVar ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ #sub(A;B;Cont) }
      // guarded
  rule #subRec( A:Proc ; B:ProcVar ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Proc ; B:ProcVar ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }

  // Binds -- TODO: add patterns
    // Linear
  rule #subBind( A:Proc ; B:Proc ;;            <- X:Name  ) =>   <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Name     <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names    <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePat  <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePats <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind ; D:Lbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Lbind ; D:Lbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
    // Repeated
  rule #subBind( A:Proc ; B:Proc ;;            <= X:Name  ) =>   <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Name     <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names    <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePat  <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePats <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind ; D:Rbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Rbind ; D:Rbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
    // Peek
  rule #subBind( A:Proc ; B:Proc ;;            <<- X:Name  ) =>   <<- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Name     <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:Names    <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePat  <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; Y:NamePats <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind ; D:Pbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Proc ; B:Proc ;; C:Pbind ; D:Pbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)

// MRec
  rule #subRec( A:Proc ; B:ProcVar ; for( C:Lbinds ){ P:Proc } ) => for( #subBind(A;B;;C) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:ProcVar ; for( C:Pbinds ){ P:Proc } ) => for( #subBind(A;B;;C) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:ProcVar ; for( C:Rbinds ){ P:Proc } ) => for( #subBind(A;B;;C) ){ #sub(A;B;P) }

  rule #subRec( A:Proc ; B:ProcVar ; for( C:Lbinds if G:BExp ){ P:Proc } ) => for( #subBind(A;B;;C) if #sub(A;B;G) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:ProcVar ; for( C:Pbinds if G:BExp ){ P:Proc } ) => for( #subBind(A;B;;C) if #sub(A;B;G) ){ #sub(A;B;P) }
  rule #subRec( A:Proc ; B:ProcVar ; for( C:Rbinds if G:BExp ){ P:Proc } ) => for( #subBind(A;B;;C) if #sub(A;B;G) ){ #sub(A;B;P) }


// sub Proc for Proc in Par -- apply after normalization
  rule #sub( A:Proc ; B:Proc ; C:Proc | D:Proc ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isPar(A)

// sub Proc for Proc in Collections
  // RhoList
  rule #sub( _:Proc ; _:Proc ; [ ] ) => [ ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc  ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc , D:Proc  ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]
  rule #sub( A:Proc ; B:Proc ; [ C:Proc , D:Procs ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]

  // RhoMap
  rule #sub( _:Proc ; _:Proc ; { } ) => { }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair  } ) => { #subKV(A;B;C) }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair , D:RhoKVPair  } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
  rule #sub( A:Proc ; B:Proc ; { C:RhoKVPair , D:RhoKVPairs } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
    // RhoKVPairs
  rule #subKV( A:Proc ; B:Proc ; C:Proc : D:Proc ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Proc ; B:Proc ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)

  // RhoSet
  rule #sub( _:Proc ; _:Proc ; Set( ) ) => Set( )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc  ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc , D:Proc  ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; Set( C:Proc , D:Procs ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )

  // RhoTuple
  rule #sub( A:Proc ; B:Proc ; ( C:Proc  ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Proc ; B:Proc ; ( C:Procs ,) ) => ( #sub(A;B;C) ,)

// sub Proc for Proc in New
  rule #sub( A:Proc ; B:ProcVar ; P:New ) => #if (@B #in (#dec(P))) #then P #else #subNew(A;B;P) #fi

  rule #subNew( A:Proc ; B:Proc ; new C:Name  in { D:Proc } ) => new C in { #sub(A;B;D) }
  rule #subNew( A:Proc ; B:Proc ; new C:Names in { D:Proc } ) => new C in { #sub(A;B;D) }

// Arithmetic Exps
  rule #sub( A:Proc ; B:Proc ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Proc ; B:Proc ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
// String expressions
  rule #sub( A:Proc ; B:Proc ; C:StringOrVar D:ConcatExp ) => #sub(A;B;C) #subConcat(A;B;D)
  rule #subConcat( A:Proc ; B:Proc ; ++ C:StringOrVar ) => ++ #sub(A;B;C)
  rule #subConcat( A:Proc ; B:Proc ; ++ C:StringOrVar D:ConcatExp ) => ++ #sub(A;B;C) #subConcat(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:StringOrVar %% D:InterpMaps ) => #sub(A;B;C) %% #subInterp(A;B;D)
  rule #subInterp( A:Proc ; B:Proc ; C:RhoMap ) => #sub(A;B;C)
  rule #subInterp( A:Proc ; B:Proc ; C:RhoMap %% D:InterpMaps ) => #sub(A;B;C) %% #subInterp(A;B;D)

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
  rule #sub( A:Proc ; B:Proc ; C:Name , D:Name  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Name , D:Names ) => #sub(A;B;C) , #sub(A;B;D)
// sub Proc for Proc in Procs
  rule #sub( A:Proc ; B:Proc ; C:Proc , D:Proc  ) => #sub(A;B;C) , #sub(A;B;D)
  rule #sub( A:Proc ; B:Proc ; C:Proc , D:Procs ) => #sub(A;B;C) , #sub(A;B;D)

// Several Procs substitutions
  // sub Procs for Procs in Name -- applies after #match predicate so lengths are assumed equal
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; N:Name ) => #sub(B;D;#sub(A;C;N))
  // sub Procs for Procs in Proc
  rule #sub( A:Proc , B:Proc  ; C:Proc , D:Proc  ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Proc , B:Procs ; C:Proc , D:Procs ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  // sub Procs for Procs in Names
  rule #sub( A:Procs ; B:Procs ; M:Name , N:Name  ) => #append(#sub(A;B;M);#sub(A;B;N))
  rule #sub( A:Procs ; B:Procs ; M:Name , N:Names ) => #append(#sub(A;B;M);#sub(A;B;N))
// sub Procs for Procs in Procs
  rule #sub( A:Procs ; B:Procs ; P:Proc , Q:Proc  ) => #append(#sub(A;B;P);#sub(A;B;Q))
  rule #sub( A:Procs ; B:Procs ; P:Proc , Q:Procs ) => #append(#sub(A;B;P);#sub(A;B;Q))

// sub Proc for Proc in Map
  rule #sub( _:Proc ; _:Proc ; .Map ) => .Map
  rule #sub( A:Proc ; B:Proc ; C:Proc |-> D:Proc E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)
  rule #sub( A:Proc ; B:Proc ; C:Name |-> D:Name E:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;E)

//-----------------------
//--- Deeper Patterns ---
//-----------------------
// sub Send for Send in Proc - sub channel for channel and message(s) for message(s)
  rule #sub( A:Name !  (         ) ; B:Name !  (         ) ; P:Proc ) => #sub(A;B;P)
  rule #sub( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name !! (         ) ; B:Name !! (         ) ; P:Proc ) => #sub(A;B;P)
  rule #sub( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ; P:Proc ) => #sub(B;D;#sub(A;C;P))
// sub Send for Send in Name - sub channel for channel and message(s) for message(s)
  rule #sub( A:Name !  (         ) ; B:Name !  (         ) ; N:Name ) => #sub(A;B;N)
  rule #sub( A:Name !  ( B:Proc  ) ; C:Name !  ( D:Proc  ) ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name !  ( B:Procs ) ; C:Name !  ( D:Procs ) ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name !! (         ) ; B:Name !! (         ) ; N:Name ) => #sub(A;B;N)
  rule #sub( A:Name !! ( B:Proc  ) ; C:Name !! ( D:Proc  ) ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name !! ( B:Procs ) ; C:Name !! ( D:Procs ) ; N:Name ) => #sub(B;D;#sub(A;C;N))

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
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; N:Name ) => #sub(B;D;#sub(A;C;N)) requires notBool (isPar(A) orBool isPar(C))
  rule #sub( A:Proc | B:Proc ; C:Proc | D:Proc ; P:Proc ) => #sub(B;D;#sub(A;C;P)) requires notBool (isPar(A) orBool isPar(C))

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
  // sub Name for NameVar in NameVar or ProcVar
  rule #sub( A:Name ; B:NameVar ; C:NameVar ) => A requires B ==K C
  rule #sub( A:Name ; B:NameVar ; C:NameVar ) => C requires B =/=K C
  rule #sub( _:Name ; _:NameVar ; A:ProcVar ) => A

  // sub Name for @ProcVar in NameVar
  rule #sub( A:Name ; @B:ProcVar ; C:ProcVar ) => *A requires B ==K C
  rule #sub( A:Name ; @B:ProcVar ; C:ProcVar ) =>  C requires B =/=K C
  rule #sub( _:Name ; @_:ProcVar ; A:NameVar ) =>  A

// Recursive cases
  // sub Name for Name in @Proc
  rule #sub( A:Name ; B:Name ; @C:Proc ) => @ #sub(A;B;C)

  // sub Name for Name in *Name
  rule #sub( A:Name ; B:Name ; *C:Name ) => * #sub(A;B;C)

  rule #sub( A:NameVar ; @B:Proc ; C:Proc ) => #sub(*A;B;C)

  // sub @Proc for @Proc in Name & Proc - drop quotes
  rule #sub( @A:Proc ; @B:Proc ; C:Name ) => #sub(A;B;C)
  rule #sub( @A:Proc ; @B:Proc ; C:Proc ) => #sub(A;B;C)

  // sub Name for Name in Receive -- only substitute free variables in channel and continuation
    // if substitution variables are all listening variables and not receive variables, then no substitution occurs
  rule #sub( _:Name ;  B:Name    ; Rec:Receive ) => Rec requires #FV(B) <=Set (#LV(Rec) -Set #RV(Rec))
    // if substitution variables are distinct from free variables in Rec, then no substitution occurs
  rule #sub( _:Name ;  B:Name    ; Rec:Receive ) => Rec requires intersectSet(#FV(B),#FV(Rec)) <=Set .Set
    // substituting for a ProcVar -- if ProcVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Name ;  B:NameVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(A;B;Rec) #else #subRec(A;B;Rec) #fi
    // substituting for *NameVar -- if NameVar is a listening variable, substitute only in the channel, else substitute in both the channel and continuation
  rule #sub( A:Name ; @B:ProcVar ; Rec:Receive ) => #if (B in #LV(Rec)) #then #subChan(*A;B;Rec) #else #subRec(*A;B;Rec) #fi

    // if substitution variable is a listening variable, then it is only substituted in the channel (not in the guard or continuation)
  rule #subChan( A:Name ; B:NameVar ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ Cont }
    // guarded
  rule #subChan( A:Name ; B:NameVar ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  if #sub(A;B;G)){ Cont }
  rule #subChan( A:Name ; B:NameVar ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) if #sub(A;B;G)){ Cont }

    // if NameVar to be substituted not a listening variable, then it is substituted in the channel and continuation (and guard)
  rule #subRec( A:Name ; B:NameVar ; for( LB:Lbind   ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( LBs:Lbinds ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( PB:Pbind   ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( PBs:Pbinds ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( RB:Rbind   ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( RBs:Rbinds ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) ){ #sub(A;B;Cont) }
      // guarded
  rule #subRec( A:Name ; B:NameVar ; for( LB:Lbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( LBs:Lbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;LBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( PB:Pbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( PBs:Pbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;PBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( RB:Rbind   if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RB)  if #sub(A;B;G) ){ #sub(A;B;Cont) }
  rule #subRec( A:Name ; B:NameVar ; for( RBs:Rbinds if G:BExp ){ Cont:Proc } ) => for( #subBind(A;B;;RBs) if #sub(A;B;G) ){ #sub(A;B;Cont) }

  // Binds
    // Linear
  rule #subBind( A:Name ; B:Name ;;            <- X:Name  ) =>   <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Name     <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names    <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePat  <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePats <- X:Name  ) => Y <- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Lbind ; D:Lbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Lbind ; D:Lbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
    // Repeated
  rule #subBind( A:Name ; B:Name ;;            <= X:Name  ) =>   <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Name     <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names    <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePat  <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePats <= X:Name  ) => Y <= #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Rbind ; D:Rbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Rbind ; D:Rbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
    // Peek
  rule #subBind( A:Name ; B:Name ;;            <<- X:Name  ) =>   <<- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Name     <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:Names    <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePat  <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; Y:NamePats <<- X:Name  ) => Y <<- #sub(A;B;X)
  rule #subBind( A:Name ; B:Name ;; C:Pbind ; D:Pbind  ) => #subBind(A;B;;C) ; #subBind(A;B;;D)
  rule #subBind( A:Name ; B:Name ;; C:Pbind ; D:Pbinds ) => #subBind(A;B;;C) ; #subBind(A;B;;D)

  // sub Name for Name in Send
  rule #sub( A:Name ; B:Name ; C:Name !  (         ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Name ; B:Name ; C:Name !  ( D:Proc  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; C:Name !  ( D:Procs ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; C:Name !! (         ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Name ; B:Name ; C:Name !! ( D:Proc  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; C:Name !! ( D:Procs ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

  // sub Name for Name in Par
  rule #sub( A:Name ; B:Name ; C:Proc | D:Proc ) => #sub(A;B;C) | #sub(A;B;D) requires notBool isPar(A)

  // sub Name for Name in Collections
    // RhoList
  rule #sub( _:Name ; _:Name ; [ ] ) => [ ]
  rule #sub( A:Name ; B:Name ; [ C:Proc ] ) => [ #sub(A;B;C) ]
  rule #sub( A:Name ; B:Name ; [ C:Proc , D:Proc  ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]
  rule #sub( A:Name ; B:Name ; [ C:Proc , D:Procs ] ) => [ #sub(A;B;C) , #sub(A;B;D) ]

    // RhoMap
  rule #sub( _:Name ; _:Name ; { } ) => { }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair } ) => { #subKV(A;B;C) }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair , D:RhoKVPair  } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
  rule #sub( A:Name ; B:Name ; { C:RhoKVPair , D:RhoKVPairs } ) => { #subKV(A;B;C) , #subKV(A;B;D) }
      // RhoKVPairs
  rule #subKV( A:Name ; B:Name ; C:Proc : D:Proc ) => #sub(A;B;C) : #sub(A;B;D)
  rule #subKV( A:Name ; B:Name ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)
  rule #subKV( A:Name ; B:Name ; C:RhoKVPair , D:RhoKVPair ) => #subKV(A;B;C) , #subKV(A;B;D)

    // RhoSet
  rule #sub( _:Name ; _:Name ; Set( ) ) => Set( )
  rule #sub( A:Name ; B:Name ; Set( C:Proc ) ) => Set( #sub(A;B;C) )
  rule #sub( A:Name ; B:Name ; Set( C:Proc , D:Proc  ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )
  rule #sub( A:Name ; B:Name ; Set( C:Proc , D:Procs ) ) => Set( #sub(A;B;C) , #sub(A;B;D) )

    // RhoTuple
  rule #sub( A:Name ; B:Name ; ( C:Proc  ,) ) => ( #sub(A;B;C) ,)
  rule #sub( A:Name ; B:Name ; ( C:Procs ,) ) => ( #sub(A;B;C) ,)

  // sub Name for Name in New -- if substitution variable is bound, no substitution occurs, else substitute in Proc
  rule #sub( A:Name ; B:NameVar ; P:New ) => #if (B #in (#dec(P))) #then P #else #subNew(A;B;P) #fi

  rule #subNew( A:Name ; B:Name ; new C:Name  in { D:Proc } ) => new C in { #sub(A;B;D) }
  rule #subNew( A:Name ; B:Name ; new C:Names in { D:Proc } ) => new C in { #sub(A;B;D) }

// Arithmetic Exps
  rule #sub( A:Name ; B:Name ; - C:AExp ) => - #sub(A;B;C)
  rule #sub( A:Name ; B:Name ; C:AExp *  D:AExp ) => #sub(A;B;C) *  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp /  D:AExp ) => #sub(A;B;C) /  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp +  D:AExp ) => #sub(A;B;C) +  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp -  D:AExp ) => #sub(A;B;C) -  #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:AExp %  D:AExp ) => #sub(A;B;C) %  #sub(A;B;D)
// String expressions
  rule #sub( A:Name ; B:Name ; C:StringOrVar D:ConcatExp ) => #sub(A;B;C) #subConcat(A;B;D)
  rule #subConcat( A:Name ; B:Name ; ++ C:StringOrVar ) => ++ #sub(A;B;C)
  rule #subConcat( A:Name ; B:Name ; ++ C:StringOrVar D:ConcatExp ) => ++ #sub(A;B;C) #subConcat(A;B;D)

  rule #sub( A:Name ; B:Name ; C:StringOrVar %% D:RhoMap ) => #sub(A;B;C) %% #sub(A;B;D)
  rule #sub( A:Name ; B:Name ; C:StringOrVar %% D:RhoMap %% E:InterpMaps ) => #sub(A;B;C) %% #subInterp(A;B;D %% E)
  rule #subInterp( A:Name ; B:Name ; C:RhoMap ) => #sub(A;B;C)
  rule #subInterp( A:Name ; B:Name ; C:RhoMap %% D:InterpMaps ) => #sub(A;B;C) %% #subInterp(A;B;D)

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

// sub Names for Names in Name
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; N:Name ) => #sub(B;D;#sub(A;C;N))
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; N:Name ) => #sub(B;D;#sub(A;C;N))
// sub Names for Names in Proc
  rule #sub( A:Name , B:Name  ; C:Name , D:Name  ; P:Proc ) => #sub(B;D;#sub(A;C;P))
  rule #sub( A:Name , B:Names ; C:Name , D:Names ; P:Proc ) => #sub(B;D;#sub(A;C;P))
// sub Name for Name in Names
  rule #sub( A:Name ; B:Name ; C:Name , D:Name  ) => #append(#sub(A;B;C);#sub(A;B;D))
  rule #sub( A:Name ; B:Name ; C:Name , D:Names ) => #append(#sub(A;B;C);#sub(A;B;D))
// sub Name for Name in Procs
  rule #sub( A:Name ; B:Name ; C:Proc , D:Proc  ) => #append(#sub(A;B;C);#sub(A;B;D))
  rule #sub( A:Name ; B:Name ; C:Proc , D:Procs ) => #append(#sub(A;B;C);#sub(A;B;D))
// sub Names for Names in Names
  rule #sub( A:Names ; B:Names ; M:Name , N:Name  ) => #append(#sub(A;B;M);#sub(A;B;N))
  rule #sub( A:Names ; B:Names ; M:Name , N:Names ) => #append(#sub(A;B;M);#sub(A;B;N))
// sub Names for Names in Procs
  rule #sub( A:Names ; B:Names ; P:Proc , Q:Proc  ) => #append(#sub(A;B;P);#sub(A;B;Q))
  rule #sub( A:Names ; B:Names ; P:Proc , Q:Procs ) => #append(#sub(A;B;P);#sub(A;B;Q))

// sub Name for Name in Map
  rule #sub( _:Name ; _:Name ; .Map ) => .Map
  rule #sub( A:Name ; B:Name ; C:Proc |-> D:Proc M:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;M)
  rule #sub( A:Name ; B:Name ; C:Name |-> D:Name M:Map ) => #sub(A;B;C) |-> #sub(A;B;D) #sub(A;B;M)

//-------------------------
//--- Map substitutions ---
//-------------------------
  // if no variables are map keys, then no substitution happens
  rule #sub( M:Map ; N:Name    ) => N requires intersectSet(#FV(N),keys(M)) ==K .Set
//  rule #sub( M:Map ; N:NamePat ) => N requires intersectSet(#FV(N),keys(M)) ==K .Set
  rule #sub( M:Map ; A:Name    , B:Name     ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:NamePat , B:Name     ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:Name    , B:NamePat  ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:NamePat , B:NamePat  ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
  rule #sub( M:Map ; A:Name    , B:Names    ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:NamePat , B:Names    ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:Name    , B:NamePats ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:NamePat , B:NamePats ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
  // if variables appear as map keys, substitute value for key
  rule #sub( Key:Name |-> Val:Name M:Map ; N:Name     ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Name |-> Val:Name M:Map ; N:Names    ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Name |-> Val:Name M:Map ; N:NamePat  ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Name |-> Val:Name M:Map ; N:NamePats ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:Name     ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:Names    ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:NamePat  ) => #sub(M;#sub(Val;Key;N))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; N:NamePats ) => #sub(M;#sub(Val;Key;N))

  // if no variables are map keys, then no substitution happens
  rule #sub( M:Map ; P:Proc    ) => P requires intersectSet(#FV(P),keys(M)) ==K .Set
//  rule #sub( M:Map ; P:ProcPat ) => P requires intersectSet(#FV(N),keys(M)) ==K .Set
  rule #sub( M:Map ; A:Proc    , B:Proc     ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:ProcPat , B:Proc     ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:Proc    , B:ProcPat  ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:ProcPat , B:ProcPat  ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
  rule #sub( M:Map ; A:Proc    , B:Procs    ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:ProcPat , B:Procs    ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:Proc    , B:ProcPats ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
//  rule #sub( M:Map ; A:ProcPat , B:ProcPats ) => A , #sub(M;B) requires intersectSet(#FV(A),keys(M)) ==K .Set
  // if variables appear as map keys, substitute value for key
  rule #sub( Key:Name |-> Val:Name M:Map ; P:Proc     ) => #sub(M;#sub(Val;Key;P)) //
  rule #sub( Key:Name |-> Val:Name M:Map ; P:Procs    ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Name |-> Val:Name M:Map ; P:ProcPat  ) => #sub(M;#sub(Val;Key;P)) //
  rule #sub( Key:Name |-> Val:Name M:Map ; P:ProcPats ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:Proc     ) => #sub(M;#sub(Val;Key;P)) //
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:Procs    ) => #sub(M;#sub(Val;Key;P))
  rule #sub( Key:Proc |-> Val:Proc M:Map ; P:ProcPat  ) => #sub(M;#sub(Val;Key;P)) //
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
  rule #sub( _:ProcPat ; \_     ; A:ProcPat ) => A
  rule #sub( _:ProcPat ; \_     ; A:Proc    ) => A
  rule #sub( _:Proc    ; \_     ; A:ProcPat ) => A
  rule #sub( _:Proc    ; \_     ; A:Proc    ) => A
  rule #sub( _:NamePat ; \_     ; A:ProcPat ) => A
  rule #sub( _:NamePat ; \_     ; A:Proc    ) => A
  rule #sub( _:Name    ; \_     ; A:ProcPat ) => A
  rule #sub( _:Name    ; \_     ; A:Proc    ) => A
  rule #sub( _:ProcPat ; \_     ; A:NamePat ) => A
  rule #sub( _:ProcPat ; \_     ; A:Name    ) => A
  rule #sub( _:Proc    ; \_     ; A:NamePat ) => A
  rule #sub( _:Proc    ; \_     ; A:Name    ) => A
  rule #sub( _:NamePat ; \_     ; A:NamePat ) => A
  rule #sub( _:NamePat ; \_     ; A:Name    ) => A
  rule #sub( _:Name    ; \_     ; A:NamePat ) => A
  rule #sub( _:Name    ; \_     ; A:Name    ) => A

  // TODO: sub for Uri for #match

// Recusive cases -- destructuring substitution Proc or Name
  // sub Proc for Proc in @Proc
  rule #sub( A:Proc ; B:Proc ; @C:ProcPat ) => @ #sub(A;B;C)

  // sub Proc for Proc in EvalPat
  rule #sub( A:Proc ; B:Proc ; *C:NamePat ) => * #sub(A;B;C)

  // sub Eval for Eval in ProcPat
  rule #sub( *A:Name ; *B:Name ; C:ProcPat ) => #sub(A;B;C)

  // sub Proc for Proc in SendPat -- sub in channel and continuation
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  (            ) ) => #sub(A;B;C) !  (             )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  ( D:Proc     ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  ( D:Procs    ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  ( D:ProcPat  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name    !  ( D:ProcPat  ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name    !  ( D:ProcPats ) ) => #sub(A;B;C) !  ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! (            ) ) => #sub(A;B;C) !! (             )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! ( D:Proc     ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! ( D:Procs    ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! ( D:ProcPat  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:NamePat !! ( D:ProcPats ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name    !! ( D:ProcPat  ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )
  rule #sub( A:Proc ; B:Proc ; C:Name    !! ( D:ProcPats ) ) => #sub(A;B;C) !! ( #sub(A;B;D) )

// sub Proc for SimplePat
  rule #sub( A:Proc ; Bool        ; C:Proc ) => #if        isBool(A) #then C #else .K #fi
  rule #sub( A:Proc ; Int         ; C:Proc ) => #if         isInt(A) #then C #else .K #fi
  rule #sub( A:Proc ; String      ; C:Proc ) => #if      isString(A) #then C #else .K #fi
  rule #sub( A:Proc ; List        ; C:Proc ) => #if     isRhoList(A) #then C #else .K #fi
  rule #sub( A:Proc ; Map         ; C:Proc ) => #if      isRhoMap(A) #then C #else .K #fi
  rule #sub( A:Proc ; Set         ; C:Proc ) => #if      isRhoSet(A) #then C #else .K #fi
  rule #sub( A:Proc ; Tuple       ; C:Proc ) => #if    isRhoTuple(A) #then C #else .K #fi
  rule #sub( A:Proc ; Unforgeable ; C:Proc ) => #if isUnforgeable(A) #then C #else .K #fi
  rule #sub( A:Proc ; Uri         ; C:Proc ) => #if         isUri(A) #then C #else .K #fi

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
  rule #sub(  A:NameVar ; @B:ProcPat ; C:Name    ) => #sub(*A;B;C) requires notBool  isWildCard(B)
  rule #sub( @A:Proc    ; @B:ProcPat ; C:Name    ) => #sub( A;B;C) requires notBool  isWildCard(B)
  rule #sub(  A:NameVar ; @B:ProcPat ; C:NamePat ) => #sub(*A;B;C) requires notBool  isWildCard(B)
  rule #sub( @A:Proc    ; @B:ProcPat ; C:NamePat ) => #sub( A;B;C) requires notBool  isWildCard(B)
  rule #sub(  A:NameVar ; @B:ProcPat ; C:Proc    ) => #sub(*A;B;C) requires notBool  isWildCard(B)
  rule #sub( @A:Proc    ; @B:ProcPat ; C:Proc    ) => #sub( A;B;C) requires notBool  isWildCard(B)
  rule #sub(  A:NameVar ; @B:ProcPat ; C:ProcPat ) => #sub(*A;B;C)
       requires notBool (isWildCard(B) orBool isSimplePat(C) orBool isPatExp(C))
  rule #sub( @A:Proc    ; @B:ProcPat ; C:ProcPat ) => #sub( A;B;C)
       requires notBool (isWildCard(B) orBool isSimplePat(C) orBool isPatExp(C))

// sub Proc for ProcPat in Proc
//  rule #sub( _:Proc ; ~ _:Proc    ; C:Proc ) => C
  rule #sub( A:Proc ;       B:Proc /\ Bool         ; C:Proc ) => #if        isBool(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Bool         ; C:Proc ) => #if        isBool(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Int          ; C:Proc ) => #if         isInt(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Int          ; C:Proc ) => #if         isInt(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ String       ; C:Proc ) => #if      isString(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ String       ; C:Proc ) => #if      isString(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ List         ; C:Proc ) => #if     isRhoList(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ List         ; C:Proc ) => #if     isRhoList(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Map          ; C:Proc ) => #if      isRhoMap(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Map          ; C:Proc ) => #if      isRhoMap(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Set          ; C:Proc ) => #if      isRhoSet(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Set          ; C:Proc ) => #if      isRhoSet(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Tuple        ; C:Proc ) => #if    isRhoTuple(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;    B:ProcPat /\ Tuple        ; C:Proc ) => #if    isRhoTuple(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Unforgeable  ; C:Proc ) => #if isUnforgeable(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       B:Proc /\ Uri          ; C:Proc ) => #if         isUri(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;       B:Proc /\ ConcreteProc ; C:Proc ) => #if #match(A;ConcreteProc) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;         Bool /\ B:Proc       ; C:Proc ) => #if        isBool(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;         Bool /\ B:ProcPat    ; C:Proc ) => #if        isBool(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;          Int /\ B:Proc       ; C:Proc ) => #if         isInt(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;          Int /\ B:ProcPat    ; C:Proc ) => #if         isInt(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;       String /\ B:Proc       ; C:Proc ) => #if      isString(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;       String /\ B:ProcPat    ; C:Proc ) => #if      isString(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;         List /\ B:Proc       ; C:Proc ) => #if     isRhoList(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;         List /\ B:ProcPat    ; C:Proc ) => #if     isRhoList(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;          Map /\ B:Proc       ; C:Proc ) => #if      isRhoMap(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;          Map /\ B:ProcPat    ; C:Proc ) => #if      isRhoMap(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;          Set /\ B:Proc       ; C:Proc ) => #if      isRhoSet(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;          Set /\ B:ProcPat    ; C:Proc ) => #if      isRhoSet(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;        Tuple /\ B:Proc       ; C:Proc ) => #if    isRhoTuple(A) #then #sub(A;B;C) #else C #fi
  rule #sub( A:Proc ;        Tuple /\ B:ProcPat    ; C:Proc ) => #if    isRhoTuple(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;  Unforgeable /\ B:Proc       ; C:Proc ) => #if isUnforgeable(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ;          Uri /\ B:Proc       ; C:Proc ) => #if         isUri(A) #then #sub(A;B;C) #else C #fi
//  rule #sub( A:Proc ; ConcreteProc /\ B:Proc       ; C:Proc ) => #if #match(A;ConcreteProc) #then #sub(A;B;C) #else C #fi

// sub Procs for ProcPats
//  rule #sub( A:Proc , B:Proc  ; C:ProcPat , D:Proc     ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc , B:Proc  ; C:Proc    , D:ProcPat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc , B:Proc  ; C:ProcPat , D:ProcPat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc , B:Procs ; C:ProcPat , D:Procs    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc , B:Procs ; C:Proc    , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc , B:Procs ; C:ProcPat , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc , B:Proc  ; C:ProcPat , D:Proc     ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc , B:Proc  ; C:Proc    , D:ProcPat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc , B:Proc  ; C:ProcPat , D:ProcPat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc , B:Procs ; C:ProcPat , D:Procs    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc , B:Procs ; C:Proc    , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc , B:Procs ; C:ProcPat , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))

// sub Procs for ProcPats
//  rule #sub( A:ProcPat , B:Proc     ; C:ProcPat , D:Proc     ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc    , B:ProcPat  ; C:ProcPat , D:Proc     ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPat  ; C:ProcPat , D:Proc     ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:Proc     ; C:Proc    , D:ProcPat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc    , B:ProcPat  ; C:Proc    , D:ProcPat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPat  ; C:Proc    , D:ProcPat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:Proc     ; C:ProcPat , D:ProcPat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc    , B:ProcPat  ; C:ProcPat , D:ProcPat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPat  ; C:ProcPat , D:ProcPat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:Procs    ; C:ProcPat , D:Procs    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc    , B:ProcPats ; C:ProcPat , D:Procs    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:Procs    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:Procs    ; C:Proc    , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:ProcPats ; C:Proc    , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPats ; C:Proc    , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:Procs    ; C:ProcPat , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:ProcPats ; C:ProcPat , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:Proc     ; C:ProcPat , D:Proc     ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc    , B:ProcPat  ; C:ProcPat , D:Proc     ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPat  ; C:ProcPat , D:Proc     ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:Proc     ; C:Proc    , D:ProcPat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc    , B:ProcPat  ; C:Proc    , D:ProcPat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPat  ; C:Proc    , D:ProcPat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:Proc     ; C:ProcPat , D:ProcPat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc    , B:ProcPat  ; C:ProcPat , D:ProcPat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPat  ; C:ProcPat , D:ProcPat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:Procs    ; C:ProcPat , D:Procs    ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Proc    , B:ProcPats ; C:ProcPat , D:Procs    ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:Procs    ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:Procs    ; C:Proc    , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:ProcPats ; C:Proc    , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:ProcPat , B:ProcPats ; C:Proc    , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:Procs    ; C:ProcPat , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Proc    , B:ProcPats ; C:ProcPat , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:ProcPat , B:ProcPats ; C:ProcPat , D:ProcPats ; E:Name ) => #sub(B;D;#sub(A;C;E))

// sub Names for NamePats
//  rule #sub( A:Name , B:Name  ; C:NamePat , D:Name     ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Name , B:Name  ; C:Name    , D:NamePat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Name , B:Name  ; C:NamePat , D:NamePat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:NamePat , D:Names    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:Name    , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:Names    ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Name , B:Name  ; C:NamePat , D:Name     ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Name , B:Name  ; C:Name    , D:NamePat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
//  rule #sub( A:Name , B:Name  ; C:NamePat , D:NamePat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:Names    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:Name    , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name , B:Names ; C:NamePat , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
// TODO: finish

// sub Names for NamePats
  rule #sub( A:NamePat , B:Name     ; C:NamePat , D:Name     ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePat  ; C:NamePat , D:Name     ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePat  ; C:NamePat , D:Name     ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Name     ; C:Name    , D:NamePat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePat  ; C:Name    , D:NamePat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePat  ; C:Name    , D:NamePat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Name     ; C:NamePat , D:NamePat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePat  ; C:NamePat , D:NamePat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePat  ; C:NamePat , D:NamePat  ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Names    ; C:NamePat , D:Names    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:NamePat , D:Names    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:NamePat , D:Names    ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Names    ; C:Name    , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:Name    , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:Name    , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Names    ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ; E:Proc ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Name     ; C:NamePat , D:Name     ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePat  ; C:NamePat , D:Name     ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePat  ; C:NamePat , D:Name     ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Name     ; C:Name    , D:NamePat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePat  ; C:Name    , D:NamePat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePat  ; C:Name    , D:NamePat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Name     ; C:NamePat , D:NamePat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePat  ; C:NamePat , D:NamePat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePat  ; C:NamePat , D:NamePat  ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Names    ; C:NamePat , D:Names    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:NamePat , D:Names    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:NamePat , D:Names    ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Names    ; C:Name    , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:Name    , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:Name    , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:Names    ; C:NamePat , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:Name    , B:NamePats ; C:NamePat , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))
  rule #sub( A:NamePat , B:NamePats ; C:NamePat , D:NamePats ; E:Name ) => #sub(B;D;#sub(A;C;E))


//----------------
//--- #sub2map ---
//----------------
// mapping from a given substitution: #sub(A;B;C) = #sub(#sub2map(A;B);C)

// Fundamental substitution mappings
  rule #sub2map( A:Proc ;  B:ProcVar ) => B |->  A
  rule #sub2map( A:Proc ; *B:NameVar ) => B |-> @A
  rule #sub2map( A:Name ; @B:ProcVar ) => B |-> *A
  rule #sub2map( A:Name ;  B:NameVar ) => B |->  A

  rule #sub2map( _:ProcPat ; \_ ) => .Map
  rule #sub2map( _:Proc    ; \_ ) => .Map
  rule #sub2map( _:NamePat ; \_ ) => .Map
  rule #sub2map( _:Name    ; \_ ) => .Map

// Send & SendPat
  // Consumable
  rule #sub2map( A:NamePat !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  ( B:ProcPat  ) ; C:NamePat !  ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  ( B:Proc     ) ; C:NamePat !  ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  ( B:Proc     ) ; C:NamePat !  ( D:Proc     ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !  (            ) ; C:NamePat !  (            ) ) => #sub2map(A;C)
  rule #sub2map( A:Name    !  ( B:ProcPats ) ; C:NamePat !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:ProcPats ) ; C:Name    !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:ProcPat  ) ; C:NamePat !  ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:ProcPat  ) ; C:Name    !  ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Procs    ) ; C:NamePat !  ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Procs    ) ; C:Name    !  ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Proc     ) ; C:NamePat !  ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Proc     ) ; C:NamePat !  ( D:Proc     ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Proc     ) ; C:Name    !  ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  ( B:Proc     ) ; C:Name    !  ( D:Proc     ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !  (            ) ; C:NamePat !  (            ) ) => #sub2map(A;C)
  rule #sub2map( A:Name    !  (            ) ; C:Name    !  (            ) ) => #sub2map(A;C)
  // Unconsumable
  rule #sub2map( A:NamePat !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! ( B:ProcPat  ) ; C:NamePat !! ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! ( B:Proc     ) ; C:NamePat !! ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! ( B:Proc     ) ; C:NamePat !! ( D:Proc     ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:NamePat !! (            ) ; C:NamePat !! (            ) ) => #sub2map(A;C)
  rule #sub2map( A:Name    !! ( B:ProcPats ) ; C:NamePat !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:ProcPats ) ; C:Name    !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:ProcPat  ) ; C:NamePat !! ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:ProcPat  ) ; C:Name    !! ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Procs    ) ; C:NamePat !! ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:ProcPats ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Procs    ) ; C:Name    !! ( D:Procs    ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Proc     ) ; C:NamePat !! ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Proc     ) ; C:NamePat !! ( D:Proc     ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Proc     ) ; C:Name    !! ( D:ProcPat  ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! ( B:Proc     ) ; C:Name    !! ( D:Proc     ) ) => updateMap( #sub2map(A;C) , #sub2map(B;D) )
  rule #sub2map( A:Name    !! (            ) ; C:NamePat !! (            ) ) => #sub2map(A;C)
  rule #sub2map( A:Name    !! (            ) ; C:Name    !! (            ) ) => #sub2map(A;C)


  rule   @ * N:Name => N  [anywhere, structural]
  rule   * @ P:Proc => P  [anywhere, structural]

endmodule