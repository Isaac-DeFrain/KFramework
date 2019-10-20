// RhoSON -- Rholang Structural Object (Type) Notation

// Can be fairly easily adapted to contain ordered & unordered structures
/*
TODO:
 - add remaining features
*/

require "../grho.k"
require "../AuxFun/auxfun.k"

module RHOSON-SYNTAX
  import GRHO-SYNTAX

// Kind Map
  syntax          KindMap ::= "{" String ":" NamePat "}" // Name variable
                            | "{" String ":" NamePat "," String ":" NamePats "}" // Bind
                            | "{" String ":" NamePat "," String ":" ProcPats "}" // Send
  syntax           MapPat ::= KindMap

// Kind function
  syntax          MapPat ::= "#kind(" NamePat   ")" [function]
                           | "#kind(" NamePats  ")" [function]
                           | "#kind(" ProcPat   ")" [function]
                           | "#kind(" ProcPats  ")" [function]
                           | "#kind(" BindPat   ")" [function]
                           | "#kind(" MCasePat  ")" [function]
                           | "#kind(" BranchPat ")" [function]
                           | "#kind(" LetBind   ")" [function]

  syntax        RhoKVPat ::= "#kindBind("  LbindPat  ")"          [function]
                           | "#kindBind("  PbindPat  ")"          [function]
                           | "#kindBind("  RbindPat  ")"          [function]
                           | "#kindOrder(" LbindPat  ";;" Int ")" [function]
                           | "#kindOrder(" PbindPat  ";;" Int ")" [function]
                           | "#kindOrder(" RbindPat  ";;" Int ")" [function]
                           | "#kindOrder(" MCasePat  ";;" Int ")" [function]
                           | "#kindOrder(" BranchPat ";;" Int ")" [function]
                           | "#kindOrder(" NamePat   ";"  Int ")" [function]
                           | "#kindOrder(" ProcPat   ";"  Int ")" [function]
  // LetExp
  syntax        RhoKVPat ::= "#kindBind("  SeqLetBinds ")"      [function]
                           | "#kindBind("  SimLetBinds ")"      [function]
                           | "#kindOrder(" LetBind ";;" Int ")" [function]

// Subexpressions
  syntax       RhoKVPats ::= "#kind("      RhoKVPat   ")"          [function]
                           | "#kind("      RhoKVPats  ")"          [function]
                           | "#kindBind("  LbindPats  ")"          [function]
                           | "#kindBind("  PbindPats  ")"          [function]
                           | "#kindBind("  RbindPats  ")"          [function]
                           | "#kindOrder(" LbindPats  ";;" Int ")" [function]
                           | "#kindOrder(" PbindPats  ";;" Int ")" [function]
                           | "#kindOrder(" RbindPats  ";;" Int ")" [function]
                           | "#kindOrder(" MCasePats  ";;" Int ")" [function]
                           | "#kindOrder(" BranchPats ";;" Int ")" [function]
                           | "#kindOrder(" NamePats   ";"  Int ")" [function]
                           | "#kindOrder(" ProcPats   ";"  Int ")" [function]

  syntax       RhoKVPats ::= "#kindBind("  SeqSimLetBinds ")"          [function]
                           | "#kindOrder(" SeqLetBinds    ";;" Int ")" [function]
                           | "#kindOrder(" SimLetBinds    ";;" Int ")" [function]
                           | "#kindOrder(" SeqSimLetBinds ";;" Int ")" [function]

endmodule

module RHOSON
  import RHOSON-SYNTAX
  import AUXFUN

  syntax KResult ::= MapPat | SimplePat | SimpleNamePat

//-------------
//--- #kind ---
//-------------
// Maps NamePat/ProcPat to MapPat

// Ground
  rule #kind( _:Bool   ) => { "simple" : Bool   }
  rule #kind( _:Int    ) => { "simple" : Int    }
  rule #kind( _:String ) => { "simple" : String }
  rule #kind(   Nil    ) => { "unit"   : Nil    }
  rule #kind( _:Unforgeable ) => { "simple" : Unforgeable }
  rule #kind( _:Uri    ) => { "simple" : Uri    }

// Variables
  rule #kind( A:Var     ) => { "var" : NameVar }
  rule #kind( A:ProcVar ) => { "var" : ProcVar }
//  rule #kind( A:Var ( B:Uri ) ) => { "var" : NameVar , "uri" : ??? }

// Receive
  // unguarded
  rule #kind( for( A:LbindPat  ){ B:ProcPat } ) => { "receive" : { "linear" : { #kindBind(A) } , "cont" : #kind(B) } }
  rule #kind( for( A:PbindPat  ){ B:ProcPat } ) => { "receive" : { "peek"   : { #kindBind(A) } , "cont" : #kind(B) } }
  rule #kind( for( A:RbindPat  ){ B:ProcPat } ) => { "receive" : { "repeat" : { #kindBind(A) } , "cont" : #kind(B) } }
  rule #kind( for( A:LbindPats ){ B:ProcPat } ) => { "receive" : { "linear" : { #kindBind(A) } , "cont" : #kind(B) } }
  rule #kind( for( A:PbindPats ){ B:ProcPat } ) => { "receive" : { "peek"   : { #kindBind(A) } , "cont" : #kind(B) } }
  rule #kind( for( A:RbindPats ){ B:ProcPat } ) => { "receive" : { "repeat" : { #kindBind(A) } , "cont" : #kind(B) } }
  // guarded
  rule #kind( for( A:LbindPat  if G:BExp ){ B:ProcPat } )
    => { "receive" : { "linear" : { #append( #kindBind(A) ; "guard" : #kind(G)) } , "cont" : #kind(B) } }
  rule #kind( for( A:LbindPats if G:BExp ){ B:ProcPat } )
    => { "receive" : { "linear" : { #append( #kindBind(A) ; "guard" : #kind(G)) } , "cont" : #kind(B) } }
  rule #kind( for( A:PbindPat  if G:BExp ){ B:ProcPat } )
    => { "receive" : { "peek"   : { #append( #kindBind(A) ; "guard" : #kind(G)) } , "cont" : #kind(B) } }
  rule #kind( for( A:PbindPats if G:BExp ){ B:ProcPat } )
    => { "receive" : { "peek"   : { #append( #kindBind(A) ; "guard" : #kind(G)) } , "cont" : #kind(B) } }
  rule #kind( for( A:RbindPat  if G:BExp ){ B:ProcPat } )
    => { "receive" : { "repeat" : { #append( #kindBind(A) ; "guard" : #kind(G)) } , "cont" : #kind(B) } }
  rule #kind( for( A:RbindPats if G:BExp ){ B:ProcPat } )
    => { "receive" : { "repeat" : { #append( #kindBind(A) ; "guard" : #kind(G)) } , "cont" : #kind(B) } }

  // Bind
  rule #kindBind( A:LbindPat ) => 0 : #kind(A)
  rule #kindBind( A:PbindPat ) => 0 : #kind(A)
  rule #kindBind( A:RbindPat ) => 0 : #kind(A)
  rule #kindBind( A:LbindPat & B:LbindPat  ) => #kindOrder(A;;0) , #kindOrder(B;;1)
  rule #kindBind( A:LbindPat & B:LbindPats ) => #kindOrder(A;;0) , #kindOrder(B;;1)
  rule #kindBind( A:PbindPat & B:PbindPat  ) => #kindOrder(A;;0) , #kindOrder(B;;1)
  rule #kindBind( A:PbindPat & B:PbindPats ) => #kindOrder(A;;0) , #kindOrder(B;;1)
  rule #kindBind( A:RbindPat & B:RbindPat  ) => #kindOrder(A;;0) , #kindOrder(B;;1)
  rule #kindBind( A:RbindPat & B:RbindPats ) => #kindOrder(A;;0) , #kindOrder(B;;1)
  // single Bind
  rule #kindOrder( A:LbindPat ;; I:Int ) => I : #kind(A)
  rule #kindOrder( A:PbindPat ;; I:Int ) => I : #kind(A)
  rule #kindOrder( A:RbindPat ;; I:Int ) => I : #kind(A)
  // multiple Binds
  rule #kindOrder( A:LbindPat & B:LbindPat  ;; I:Int ) => I : #kind(A) , #kindOrder(B;;I +Int 1)
  rule #kindOrder( A:LbindPat & B:LbindPats ;; I:Int ) => I : #kind(A) , #kindOrder(B;;I +Int 1)
  rule #kindOrder( A:PbindPat & B:PbindPat  ;; I:Int ) => I : #kind(A) , #kindOrder(B;;I +Int 1)
  rule #kindOrder( A:PbindPat & B:PbindPats ;; I:Int ) => I : #kind(A) , #kindOrder(B;;I +Int 1)
  rule #kindOrder( A:RbindPat & B:RbindPat  ;; I:Int ) => I : #kind(A) , #kindOrder(B;;I +Int 1)
  rule #kindOrder( A:RbindPat & B:RbindPats ;; I:Int ) => I : #kind(A) , #kindOrder(B;;I +Int 1)

  rule #kind( A:LbindPat ) => { "chan" : #kind(#chan(A)) , "listen" : #kind(#bvar(A)) }
  rule #kind( A:PbindPat ) => { "chan" : #kind(#chan(A)) , "listen" : #kind(#bvar(A)) }
  rule #kind( A:RbindPat ) => { "chan" : #kind(#chan(A)) , "listen" : #kind(#bvar(A)) }

// Send
  rule #kind( A:NamePat !  ( B:ProcPats ) ) => { "send" : { "linear" : { "chan" : #kind(A) , "msg" : #kind(B) } } }
  rule #kind( A:NamePat !  (            ) ) => { "send" : { "linear" : { "chan" : #kind(A) , "msg" : Empty    } } }
  rule #kind( A:NamePat !! ( B:ProcPats ) ) => { "send" : { "repeat" : { "chan" : #kind(A) , "msg" : #kind(B) } } }
  rule #kind( A:NamePat !! (            ) ) => { "send" : { "repeat" : { "chan" : #kind(A) , "msg" : Empty    } } }

// Par
  rule #kind( A:ParPat ) => { "par" : { #kind(#par2pats(A)) } }

// Eval
  rule #kind( *A:NamePat ) => { "eval" : #kind(A) }

// New
  rule #kind( new A:VarDecs in { B:ProcPat } ) => { "new" : { "declared" : #kind(A) , "body" : #kind(B) } }

// Match
  rule #kind( match A:ProcPat { B:MCasePats } ) => { "match" : { "process" : #kind(A) , "cases" : { #kindOrder(B;;0) } } }
  // MatchCases
  rule #kind( { A:ProcPat } |=> B:ProcPat ) => { "pattern" : #kind(A) , "body" : #kind(B) }
  rule #kindOrder( A:MCasePat             ;; I:Int ) => I : #kind(A)
  rule #kindOrder( A:MCasePat B:MCasePats ;; I:Int ) => I : #kind(A) , #kindOrder(B;;I +Int 1)

// Select
  rule #kind( select { A:BranchPats } ) => { "select" : { "branches" : { #kindOrder(A;;0) } } }
  // Branches
  rule #kind( { A:LbindPat  } |=> B:ProcPat ) => { "bind"  : { #kindBind(A) } , "body" : #kind(B) }
  rule #kind( { A:LbindPats } |=> B:ProcPat ) => { "binds" : { #kindBind(A) } , "body" : #kind(B) }
  rule #kind( { A:LbindPat  if G:BExp } |=> B:ProcPat ) => { "bind"  : { #kindBind(A) , "guard" : #kind(G) } , "body" : #kind(B) }
  rule #kind( { A:LbindPats if G:BExp } |=> B:ProcPat ) => { "binds" : { #append( #kindBind(A) ; "guard" : #kind(G)) } , "body" : #kind(B) }
  rule #kindOrder( A:BranchPat ;; I:Int ) => I : #kind(A)
  rule #kindOrder( A:BranchPat B:BranchPats ;; I:Int ) => I : #kind(A) , #kindOrder(B;;I +Int 1)

// Let
  rule #kind( let A:LetBind        in { B:Proc } ) => { "let"       : { "bind"  :       #kind(A)   , "body" : #kind(B) } }
  rule #kind( let A:SeqLetBinds    in { B:Proc } ) => { "seqlet"    : { "binds" : { #kindBind(A) } , "body" : #kind(B) } }
  rule #kind( let A:SimLetBinds    in { B:Proc } ) => { "simlet"    : { "binds" : { #kindBind(A) } , "body" : #kind(B) } } requires notBool     isLetBind(A)
  rule #kind( let A:SeqSimLetBinds in { B:Proc } ) => { "seqsimlet" : { "binds" : { #kindBind(A) } , "body" : #kind(B) } } requires notBool isSeqLetBinds(A)
  // LetBinds
  rule #kind( _:ProcVar <- B:Proc ) => { "var" : ProcVar , "def" : #kind(B) }

  rule #kindBind( A:LetBind ) => "basic" : #kind(A)
  rule #kindBind( A:LetBind ; B:LetBind     ) => "seq" : { #kindOrder(A;;0) , #kindOrder(B;;1) }
  rule #kindBind( A:LetBind ; B:SeqLetBinds ) => "seq" : { #kindOrder(A;;0) , #kindOrder(B;;1) }
  rule #kindBind( A:LetBind & B:SimLetBinds ) => "sim" : { #kindOrder(A;;0) , #kindOrder(B;;1) }
  rule #kindBind( A:SeqLetBinds > B:SimLetBinds    ) => #append(#kindBind(A);#kindBind(B))
  rule #kindBind( A:SimLetBinds > B:SeqLetBinds    ) => #append(#kindBind(A);#kindBind(B))
  rule #kindBind( A:SimLetBinds > B:SimLetBinds    ) => #append(#kindBind(A);#kindBind(B))
  rule #kindBind( A:SeqLetBinds > B:SeqSimLetBinds ) => #append(#kindBind(A);#kindBind(B))
  rule #kindBind( A:SimLetBinds > B:SeqSimLetBinds ) => #append(#kindBind(A);#kindBind(B))

  rule #kindOrder( A:LetBind ;; I:Int ) =>  I : #kind(A)
  rule #kindOrder( A:LetBind ; B:LetBind     ;; I:Int ) =>  I : #kind(A) , (I +Int 1) : #kind(B)
  rule #kindOrder( A:LetBind ; B:SeqLetBinds ;; I:Int ) =>  I : #kind(A) , #kindOrder(B;;I +Int 1)
  rule #kindOrder( A:LetBind & B:SimLetBinds ;; I:Int ) =>  I : #kind(A) , #kindOrder(B;;I +Int 1)

// VarRef
  rule #kind( A:NameRef ) => { "varref" : NameVar }
  rule #kind( A:ProcRef ) => { "varref" : ProcVar }

// Conditional
  rule #kind( if ( A:BExp ) B:ProcPat ) => { "conditional" : { "if" : #kind(A) , "then" : #kind(B) } }
  rule #kind( if ( A:BExp ) B:ProcPat else C:ProcPat ) => { "conditional" : { "if" : #kind(A) , "then" : #kind(B) , "else" : #kind(C) } }

// Contract
  rule #kind( contract A:NamePat ( B:NamePats ) = { C:ProcPat } ) => { "contract" : { "name" : #kind(A) , "args" : { #kindOrder(B;0) } , "body" : #kind(C) } }
  rule #kind( contract A:NamePat (            ) = { C:ProcPat } ) => { "contract" : { "name" : #kind(A) , "args" : Empty               , "body" : #kind(C) } }

// Invocation
  rule #kind( A:NamePat ( B:NamePats ) ) => { "invocation" : { "name" : #kind(A) , "params" : { #kindOrder(B;0) } } }
  rule #kind( A:NamePat (            ) ) => { "invocation" : { "name" : #kind(A) , "params" : Empty               } }

// Collection
  // RhoList
  rule #kind( [ A:ProcPats ] ) => { "list" : #kind(A) }
  rule #kind( [ ] ) => { "list" : Empty }

  // RhoMap
  rule #kind( { A:RhoKVPats } ) => { "map" : { #kind(A) } }
  rule #kind( {  } ) => { "map" : Empty }
    // KVPairs -- Order???
  rule #kind( A:ProcPat  : B:ProcPat   ) => "key" : #kind(A) , "value" : #kind(B)
  rule #kind( A:RhoKVPat , B:RhoKVPats ) => #append(#kind(A);#kind(B))

  // RhoSet
  rule #kind( Set( A:ProcPats ) ) => { "set" : #kind(A) }
  rule #kind( Set( ) ) => { "set" : Empty }

  // RhoTuple
  rule #kind( ( A:ProcPats ,) ) => { "tuple" : #kind(A) }

// Exp
  // AExp -- TODO: precedence
  rule #kind( - A:AExp ) => { "neg" : #kind(A) }
  rule #kind( A:AExp % B:AExp ) => { "%" : { #kindOrder(A,B;0) } }
  rule #kind( A:AExp * B:AExp ) => { "*" : { #kindOrder(A,B;0) } }
  rule #kind( A:AExp / B:AExp ) => { "/" : { #kindOrder(A,B;0) } }
  rule #kind( A:AExp + B:AExp ) => { "+" : { #kindOrder(A,B;0) } }
  rule #kind( A:AExp - B:AExp ) => { "-" : { #kindOrder(A,B;0) } }

  // BExp
  rule #kind( A:AExp <= B:AExp ) => { "<=" : { #kindOrder(A,B;0) } }
  rule #kind( A:AExp <  B:AExp ) => { "<"  : { #kindOrder(A,B;0) } }
  rule #kind( A:AExp >= B:AExp ) => { ">=" : { #kindOrder(A,B;0) } }
  rule #kind( A:AExp >  B:AExp ) => { ">"  : { #kindOrder(A,B;0) } }
  rule #kind( not A:BExp ) => { "not" : #kind(A) }
  rule #kind( A:BExp and B:BExp ) => { "and" : { #kindOrder(A,B;0) } }
  rule #kind( A:BExp or  B:BExp ) => { "or"  : { #kindOrder(A,B;0) } }
  rule #kind( A:Name ==  B:Name ) => { "name==" : { #kindOrder(A,B;0) } }
  rule #kind( A:Name !=  B:Name ) => { "name!=" : { #kindOrder(A,B;0) } }
  rule #kind( A:Proc ==  B:Proc ) => { "proc==" : { #kindOrder(A,B;0) } }
  rule #kind( A:Proc !=  B:Proc ) => { "proc!=" : { #kindOrder(A,B;0) } }
  rule #kind( A:ProcPat matches B:ProcPat ) => { "matches" : { #kindOrder(A,B;0) } }

  // ListExp


  // SrtingExp

// Method

// SimplePat
  rule #kind( A:SimplePat     ) => { "pattern" : A }
  rule #kind( A:SimpleNamePat ) => { "pattern" : A }

// ProcPats
  rule #kind( A:ProcPats ) => { #kindOrder(A;0) } requires notBool isProcPat(A)
  rule #kindOrder( A:ProcPat ; I:Int ) => I : #kind(A)
  rule #kindOrder( A:ProcPat , B:ProcPats ; I:Int ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  //  #kindUnord

// NamePats
  // Quote
  rule #kind( @A:ProcPat ) => { "quote" : #kind(A) }

  rule #kind( A:NamePats ) => { #kindOrder(A;0) } requires notBool isNamePat(A)
  rule #kindOrder( A:NamePat ; I:Int ) => I : #kind(A)
  rule #kindOrder( A:NamePat , B:NamePats ; I:Int ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  //  #kindUnord

// PatExp
  rule #kind( ~ A:ProcPat ) => { "negation" : #kind(A) }
  rule #kind( A:ProcPat \/ B:ProcPat ) => { "disjunction" : { #kindOrder(A,B;0) } }
  rule #kind( A:ProcPat /\ B:ProcPat ) => { "conjunction" : { #kindOrder(A,B;0) } }

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
