// RhoSON -- Rholang Structural Object Notation

// Can be fairly easily adapted to contain ordered & unordered structures

require "../../grho.k"
require "../../AuxFun/auxfun.k"

module RHOSON-SYNTAX
  import GRHO-SYNTAX

// Kind Map
  syntax          KindMap ::= "{" String ":" Name "}" // NameVar
                            | "{" String ":" Name "," String ":" Names "}" // Bind
                            | "{" String ":" Name "," String ":" Proc  "}" // Send
  syntax           RhoMap ::= KindMap

// Kind function
  syntax          RhoMap ::= "#kind("      Name   ")"         [function]
                           | "#kind("      Names  ")"         [function]
                           | "#kind("      Proc   ")"         [function]
                           | "#kind("      Procs  ")"         [function]
                           | "#kind("      Bind   ")"         [function]

  syntax       RhoKVPair ::= "#kindBind("  Lbind  ")"         [function]
                           | "#kindBind("  Pbind  ")"         [function]
                           | "#kindBind("  Rbind  ")"         [function]
                           | "#kindOrder(" Lbind  ";" Int ")" [function]
                           | "#kindOrder(" Pbind  ";" Int ")" [function]
                           | "#kindOrder(" Rbind  ";" Int ")" [function]
                           | "#kindOrder(" Name   ";" Int ")" [function]
                           | "#kindOrder(" Proc   ";" Int ")" [function]

  syntax      RhoKVPairs ::= "#kind("  RhoKVPair  ")"         [function]
                           | "#kind("  RhoKVPairs ")"         [function]
                           | "#kindBind("  Lbinds ")"         [function]
                           | "#kindBind("  Pbinds ")"         [function]
                           | "#kindBind("  Rbinds ")"         [function]
                           | "#kindOrder(" Lbinds ";" Int ")" [function]
                           | "#kindOrder(" Pbinds ";" Int ")" [function]
                           | "#kindOrder(" Rbinds ";" Int ")" [function]
                           | "#kindOrder(" Names  ";" Int ")" [function]
                           | "#kindOrder(" Procs  ";" Int ")" [function]

endmodule

module RHOSON
  import RHOSON-SYNTAX
  import AUXFUN

//-------------
//--- #kind ---
//-------------
// Maps Proc to RhoMap

// Ground
  rule #kind( A:Bool   ) => { "bool"   : A   }
  rule #kind( A:Int    ) => { "int"    : A   }
  rule #kind( A:String ) => { "string" : A   }
  rule #kind( Nil      ) => { "nil"    : Nil }
  rule #kind( unforgeable( I:Int ) ) => { "unforgeable" : I }
//  rule #kind( `A:NativeChan` ) ) => { "uri" : A }

// Variables
  rule #kind( X:NameVar ) => { "namevar" : X }
  rule #kind( X:ProcVar ) => { "procvar" : X }

  rule #kind( EmptyN ) => { "empty" : "name" }
  rule #kind( EmptyP ) => { "empty" : "proc" }

// Receive
  // unguarded
  rule #kind( for( A:Lbind  ){ P:Proc } ) => { "receive" : { "single" : { #kindBind(A) } , "cont" : P } }
  rule #kind( for( A:Pbind  ){ P:Proc } ) => { "receive" : { "single" : { #kindBind(A) } , "cont" : P } }
  rule #kind( for( A:Rbind  ){ P:Proc } ) => { "receive" : { "single" : { #kindBind(A) } , "cont" : P } }
  rule #kind( for( A:Lbinds ){ P:Proc } ) => { "receive" : { "multi"  : { #kindBind(A) } , "cont" : P } }
  rule #kind( for( A:Pbinds ){ P:Proc } ) => { "receive" : { "multi"  : { #kindBind(A) } , "cont" : P } }
  rule #kind( for( A:Rbinds ){ P:Proc } ) => { "receive" : { "multi"  : { #kindBind(A) } , "cont" : P } }
  // guarded
  rule #kind( for( A:Lbind  if G:BExp ){ P:Proc } ) => { "receive" : { "multi" : { "guarded" : { #kindBind(A) } , "guard" : #kind(G) } , "cont" : P } }
  rule #kind( for( A:Lbinds if G:BExp ){ P:Proc } ) => { "receive" : { "multi" : { "guarded" : { #kindBind(A) } , "guard" : #kind(G) } , "cont" : P } }
  rule #kind( for( A:Pbind  if G:BExp ){ P:Proc } ) => { "receive" : { "multi" : { "guarded" : { #kindBind(A) } , "guard" : #kind(G) } , "cont" : P } }
  rule #kind( for( A:Pbinds if G:BExp ){ P:Proc } ) => { "receive" : { "multi" : { "guarded" : { #kindBind(A) } , "guard" : #kind(G) } , "cont" : P } }
  rule #kind( for( A:Rbind  if G:BExp ){ P:Proc } ) => { "receive" : { "multi" : { "guarded" : { #kindBind(A) } , "guard" : #kind(G) } , "cont" : P } }
  rule #kind( for( A:Rbinds if G:BExp ){ P:Proc } ) => { "receive" : { "multi" : { "guarded" : { #kindBind(A) } , "guard" : #kind(G) } , "cont" : P } }

  // Bind
  rule #kindBind( A:Lbind ) => "linear" : #kind(A)
  rule #kindBind( A:Pbind ) => "peek"   : #kind(A)
  rule #kindBind( A:Rbind ) => "repeat" : #kind(A)
  rule #kindBind( A:Lbind ; B:Lbind  ) => #kindOrder(A;0) , #kindOrder(B;1)
  rule #kindBind( A:Lbind ; B:Lbinds ) => #kindOrder(A;0) , #kindOrder(B;1)
  rule #kindBind( A:Pbind ; B:Pbind  ) => #kindOrder(A;0) , #kindOrder(B;1)
  rule #kindBind( A:Pbind ; B:Pbinds ) => #kindOrder(A;0) , #kindOrder(B;1)
  rule #kindBind( A:Rbind ; B:Rbind  ) => #kindOrder(A;0) , #kindOrder(B;1)
  rule #kindBind( A:Rbind ; B:Rbinds ) => #kindOrder(A;0) , #kindOrder(B;1)

  rule #kindOrder( A:Lbind ; I ) => I : #kind(A)
  rule #kindOrder( A:Pbind ; I ) => I : #kind(A)
  rule #kindOrder( A:Rbind ; I ) => I : #kind(A)

  rule #kindOrder( A:Lbind ; B:Lbind  ; I ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  rule #kindOrder( A:Lbind ; B:Lbinds ; I ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  rule #kindOrder( A:Pbind ; B:Pbind  ; I ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  rule #kindOrder( A:Pbind ; B:Pbinds ; I ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  rule #kindOrder( A:Rbind ; B:Rbind  ; I ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  rule #kindOrder( A:Rbind ; B:Rbinds ; I ) => I : #kind(A) , #kindOrder(B;I +Int 1)

  rule #kind( A:Lbind ) => { "chan" : #kind(#chan(A)) , "listen" : #kind(#bvar(A)) }
  rule #kind( A:Pbind ) => { "chan" : #kind(#chan(A)) , "listen" : #kind(#bvar(A)) }
  rule #kind( A:Rbind ) => { "chan" : #kind(#chan(A)) , "listen" : #kind(#bvar(A)) }

// Send
  rule #kind( A:Name !  ( B:Procs ) ) => { "send" : { "linear"  : { "chan" : #kind(A) , "msg" : #kind(B)      } } }
  rule #kind( A:Name !  ( B:Proc  ) ) => { "send" : { "linear"  : { "chan" : #kind(A) , "msg" : #kind(B)      } } }
  rule #kind( A:Name !  (         ) ) => { "send" : { "linear"  : { "chan" : #kind(A) , "msg" : #kind(EmptyP) } } }
  rule #kind( A:Name !! ( B:Procs ) ) => { "send" : { "persist" : { "chan" : #kind(A) , "msg" : #kind(B)      } } }
  rule #kind( A:Name !! ( B:Proc  ) ) => { "send" : { "persist" : { "chan" : #kind(A) , "msg" : #kind(B)      } } }
  rule #kind( A:Name !! (         ) ) => { "send" : { "persist" : { "chan" : #kind(A) , "msg" : #kind(EmptyP) } } }

// Par
  rule #kind( A:Par ) => { "par" : { #kind(#par2procs(A)) } }

// Collection
  // RhoList
  rule #kind( [ P:Procs ] ) => { "list" : #kind(P) }
  rule #kind( [ P:Proc  ] ) => { "list" : #kind(P) }
  rule #kind( [ ] ) => { "list" : "empty" }

  // RhoMap
  rule #kind( { R:RhoKVPairs } ) => { "map" : { #kind(R) } }
  rule #kind( { R:RhoKVPair  } ) => { "map" : { #kind(R) } }
  rule #kind( {  } ) => { "map" : "empty" }
    // KVPairs -- Order???
  rule #kind( A:Proc : B:Proc ) => "key" : #kind(A) , "value" : #kind(B)
  rule #kind( A:RhoKVPair , B:RhoKVPair  ) => #appendKV(#kind(A);#kind(B))
  rule #kind( A:RhoKVPair , B:RhoKVPairs ) => #appendKV(#kind(A);#kind(B))

  // RhoSet
  rule #kind( Set( P:Procs ) ) => { "set" : #kind(P) }
  rule #kind( Set( P:Proc  ) ) => { "set" : #kind(P) }
  rule #kind( Set( ) ) => { "set" : "empty" }

  // RhoTuple
  rule #kind( tuple( P:Procs ) ) => { "tuple" : #kind(P) }
  rule #kind(      ( P:Proc ,) ) => { "tuple" : #kind(P) }

// Procs
  rule #kind( A:Procs ) => { #kindOrder(A;0) }
  rule #kindOrder( A:Proc ; I:Int ) => I : #kind(A)
  rule #kindOrder( A:Proc , B:Proc  ; I:Int ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  rule #kindOrder( A:Proc , B:Procs ; I:Int ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  //  #kindUnord

// Names
  // Quote
  rule #kind( @P:Proc ) => { "quote" : #kind(P) }

  rule #kind( A:Names ) => { #kindOrder(A;0) }
  rule #kindOrder( A:Name ; I:Int ) => I : #kind(A)
  rule #kindOrder( A:Name , B:Name  ; I:Int ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  rule #kindOrder( A:Name , B:Names ; I:Int ) => I : #kind(A) , #kindOrder(B;I +Int 1)
  //  #kindUnord

endmodule