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

  syntax IntermediateType ::= "#untype(" Type ")"   [function]
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

  syntax KResult ::= OrPatOrLeafType

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

  rule untype[ "simpletype" ;; #untype( type[ toString( ST:OrPat ) ] ) ;; #untype( type[#truncate] ) ] => untype[ ST ] [anywhere]
/*
2. type[  _:String ;; ( type[ _:String ;; _:String ;; L:Leaf ] => type[ L:Leaf ] ) ;; _:InitialType ]
           S
         /    \
    "leaf"     I1
    / \ => I2
 S2  L1

rule type[ _:String ;; ( type[ "leaf"       ;; S:String   ;; L:Leaf ] => type[ L   ] ) ;; _:IntermediateType ]  requires S =/=String "nil" [anywhere]
rule type[ _:String ;; ( type[ "leaf"       ;; "nil"      ;; "Nil"  ] => type[ Nil ] ) ;; _:IntermediateType ] [anywhere]
rule type[ _:String ;; ( type[ "simpletype" ;; type[ toString( ST:OrPat ) ] ;; _ ] => type[ ST ] ) ;; _:InitialType ] [anywhere]

rule type[ _:String ;; ( type[ "send" ;; type[ N:Name    ] ;; type[ P:Proc    ] ] => type[ N ! ( P ) ] ) ;; _:IntermediateType ] [anywhere]
rule type[ _:String ;; ( type[ "send" ;; type[ N:NamePat ] ;; type[ P:Proc    ] ] => type[ N ! ( P ) ] ) ;; _:IntermediateType ] [anywhere]
rule type[ _:String ;; ( type[ "send" ;; type[ N:Name    ] ;; type[ P:ProcPat ] ] => type[ N ! ( P ) ] ) ;; _:IntermediateType ] [anywhere]
rule type[ _:String ;; ( type[ "send" ;; type[ N:NamePat ] ;; type[ P:ProcPat ] ] => type[ N ! ( P ) ] ) ;; _:IntermediateType ] [anywhere]

3. type[  _:String ;; I1:InitialType  ;; ( type[ _:String ;; _:String ;; L:Leaf ] => type[ L ] ) ]
         S
        /  \
      I1   "leaf"
            / \ => I2
          S2  L1

rule type[ _:String ;; _:IntermediateType ;; ( type[ "leaf"       ;; S:String                     ;; L:Leaf ] => type[ L         ] ) ]  requires S =/=String "nil" andBool S =/=String "truncate" [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "leaf"       ;; "nil"                        ;; "Nil"  ] => type[ Nil       ] ) ] [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "leaf"       ;; "truncate"                   ;; _      ] => type[ #truncate ] ) ] [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "simpletype" ;; type[ toString( ST:OrPat ) ] ;; _      ] => type[ ST        ] ) ] [anywhere]
*/
/* 4. type[  S:String ;; I1:InitialType ;; I2:InitialType ] => I3:InitialType   [anywhere]
          S
        /  \   => I3
      I1    I2
*/
  rule untype[ "quote"   ;; type[P:Proc    ] ;; type[#truncate ] ] => untype[ @ P ] [anywhere]
  rule untype[ "quote"   ;; type[P:ProcPat ] ;; type[#truncate ] ] => untype[ @ P ] [anywhere]

  rule untype[ "reify"   ;; type[N:Name    ] ;; type[#truncate ] ] => type[ * N ] [anywhere]
  rule untype[ "reify"   ;; type[N:NamePat ] ;; type[#truncate ] ] => type[ * N ] [anywhere]

  rule untype[ "send"    ;; type[N:Name    ] ;; type[P:Proc    ] ] => type[ N ! ( P ) ] [anywhere]
  rule untype[ "send"    ;; type[N:Name    ] ;; type[P:ProcPat ] ] => type[ N ! ( P ) ] [anywhere]
  rule untype[ "send"    ;; type[N:NamePat ] ;; type[P:Proc    ] ] => type[ N ! ( P ) ] [anywhere]
  rule untype[ "send"    ;; type[N:NamePat ] ;; type[P:ProcPat ] ] => type[ N ! ( P ) ] [anywhere]

  rule type[ "bind"    ;; untype[B:NamePat ] ;; untype[N:Name    ] ] => untype[ B <- N ] [anywhere]
  rule type[ "bind"    ;; untype[B:NamePat ] ;; untype[N:NamePat ] ] => untype[ B <- N ] [anywhere]

  rule type[ "receive" ;; untype[B:Bind    ] ;; untype[P:Proc    ] ] => untype[ for( B ){ P } ] [anywhere]
  rule type[ "receive" ;; untype[B:Bind    ] ;; untype[P:ProcPat ] ] => untype[ for( B ){ P } ] [anywhere]
  rule type[ "receive" ;; untype[B:BindPat ] ;; untype[P:Proc    ] ] => untype[ for( B ){ P } ] [anywhere]
  rule type[ "receive" ;; untype[B:BindPat ] ;; untype[P:ProcPat ] ] => untype[ for( B ){ P } ] [anywhere]

  rule type[ "par"     ;; type[P:Proc    ] ;; type[Q:Proc    ] ] => type[ P | Q ] [anywhere]
  rule type[ "par"     ;; type[P:Proc    ] ;; type[Q:ProcPat ] ] => type[ P | Q ] [anywhere]
  rule type[ "par"     ;; type[P:ProcPat ] ;; type[Q:Proc    ] ] => type[ P | Q ] [anywhere]
  rule type[ "par"     ;; type[P:ProcPat ] ;; type[Q:ProcPat ] ] => type[ P | Q ] [anywhere]

endmodule
