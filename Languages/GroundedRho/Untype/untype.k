// Structural type system for RHO-CALCULUS
// Type = Structural binary tree

require "domains.k"
require "kast.k"
require "substitution.k"
require "../StructuralTypes/stype.k"

module UNTYPE-SYNTAX
  import DOMAINS
  import KAST
  import KSEQ-SYMBOLIC
  import SUBSTITUTION
  import STYPE-SYNTAX

  syntax IntermediateType ::= "#untype(" Type ")"                                                  [function]
                            | "untype[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]

  syntax  OrPatOrLeafType ::= "untype[" OrPat       "]"                              // untype[OrPat] < OrPatOrLeafType
                            | "untype[" Leaf        "]"                              //  untype[Leaf] < OrPatOrLeafType

//  Initial type
  syntax      InitialType ::= "untype[" BindOrPat   "]"                              //   untype[BindOrPat] < InitialType
                            | "untype[" BindNamePat "]"                              // untype[BindNamePat] < InitialType

//  Terminal type
  syntax     TerminalType ::= "untype[" String ";;" TerminalType     ";;" TerminalType     "]"

  syntax         LeafType ::= "untype[" String ";;" Leaf             ";;" Leaf             "]"

endmodule


module UNTYPE
  import UNTYPE-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> #untype( $PGM:Type ) </k>
    </T>

  syntax KResult ::= InitialType

  rule #untype( type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] ) => untype[ S:String ;; #untype(A) ;; #untype(B) ]  [strict(2,3)]

/*
2 kinds of rewrites:
1. type[ S1:String ;; S2:String ;; L:Leaf ] => I:InitialType               i.e. type[ "leaf" ;; _:String ;; L:Leaf ] => type[L] (special treatment for "Nil" and "#truncate")
2. type[  S:String ;; I1:InitialType ;; I2:InitialType ] => I3:InitialType i.e. type[ "par"  ;; type[ P:ProcPat ] ;; type[ Q:ProcPat ] ] => type[  ]
*/
// Leaves
// 1. type[ "leaf":String ;; _:String ;; L:Leaf ] => type[ L ]:InitialType
/*
      "leaf"
       /  \  => I
      S2   L
*/
  rule #untype( type[ "leaf" ;; S:String   ;; L:Leaf ] ) => untype[ L         ] requires S =/=String "nil" andBool S =/=String "truncate" [anywhere]
  rule #untype( type[ "leaf" ;; "nil"      ;; "Nil"  ] ) => untype[ Nil       ] [anywhere]
  rule #untype( type[ "leaf" ;; "truncate" ;;   _    ] ) => untype[ #truncate ] [anywhere]

  rule untype[ "simpletype" ;; untype[ toString( ST:OrPat ) ] ;; untype[#truncate] ] => untype[ ST ] [anywhere]

/* 2. type[  S:String ;; I1:InitialType ;; I2:InitialType ] => I3:InitialType   [anywhere]
          S
        /  \   => I3
      I1    I2
*/
  rule untype[ "quote"   ;; untype[P:Proc    ] ;; untype[#truncate ] ] => untype[ @ P ] [anywhere]
  rule untype[ "quote"   ;; untype[P:ProcPat ] ;; untype[#truncate ] ] => untype[ @ P ] [anywhere]

  rule untype[ "eval"    ;; untype[N:Name    ] ;; untype[#truncate ] ] => untype[ * N ] [anywhere]
  rule untype[ "eval"    ;; untype[N:NamePat ] ;; untype[#truncate ] ] => untype[ * N ] [anywhere]

  rule untype[ "send"    ;; untype[N:Name    ] ;; untype[P:Proc    ] ] => untype[ N ! ( P ) ] [anywhere]
  rule untype[ "send"    ;; untype[N:Name    ] ;; untype[P:ProcPat ] ] => untype[ N ! ( P ) ] [anywhere]
  rule untype[ "send"    ;; untype[N:NamePat ] ;; untype[P:Proc    ] ] => untype[ N ! ( P ) ] [anywhere]
  rule untype[ "send"    ;; untype[N:NamePat ] ;; untype[P:ProcPat ] ] => untype[ N ! ( P ) ] [anywhere]

  rule untype[ "bind"    ;; untype[B:NamePat ] ;; untype[N:Name    ] ] => untype[ B <- N ] [anywhere]
  rule untype[ "bind"    ;; untype[B:NamePat ] ;; untype[N:NamePat ] ] => untype[ B <- N ] [anywhere]

  rule untype[ "receive" ;; untype[B:Bind    ] ;; untype[P:Proc    ] ] => untype[ for( B ){ P } ] [anywhere]
  rule untype[ "receive" ;; untype[B:Bind    ] ;; untype[P:ProcPat ] ] => untype[ for( B ){ P } ] [anywhere]
  rule untype[ "receive" ;; untype[B:BindPat ] ;; untype[P:Proc    ] ] => untype[ for( B ){ P } ] [anywhere]
  rule untype[ "receive" ;; untype[B:BindPat ] ;; untype[P:ProcPat ] ] => untype[ for( B ){ P } ] [anywhere]

  rule untype[ "par"     ;; untype[P:Proc    ] ;; untype[Q:Proc    ] ] => untype[ P | Q ] [anywhere]
  rule untype[ "par"     ;; untype[P:Proc    ] ;; untype[Q:ProcPat ] ] => untype[ P | Q ] [anywhere]
  rule untype[ "par"     ;; untype[P:ProcPat ] ;; untype[Q:Proc    ] ] => untype[ P | Q ] [anywhere]
  rule untype[ "par"     ;; untype[P:ProcPat ] ;; untype[Q:ProcPat ] ] => untype[ P | Q ] [anywhere]

endmodule
