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

syntax               Type ::= "#untype(" Type ")"   [function]

endmodule


module UNTYPE
import UNTYPE-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

syntax KResult ::= OrPatOrLeafType

rule #untype( T:Type ) => T  [strict]

/*
2 kinds of rewrites (2 pairs of symmetric rules):
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
rule type[ "leaf" ;; S:String   ;; L:Leaf ] => type[ L         ]  requires S =/=String "nil" andBool S =/=String "truncate" [anywhere]
rule type[ "leaf" ;; "nil"      ;; "Nil"  ] => type[ Nil       ] [anywhere]
rule type[ "leaf" ;; "truncate" ;;   _    ] => type[ #truncate ] [anywhere]

rule type[ "simpletype" ;; type[ toString( ST:OrPat ) ] ;; _ ] => type[ ST ] [anywhere]

/* 2. type[  _:String ;; ( type[ _:String ;; _:String ;; L:Leaf ] => type[ L:Leaf ] ) ;; _:InitialType ]
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
/* 3. type[  _:String ;; I1:InitialType  ;; ( type[ _:String ;; _:String ;; L:Leaf ] => type[ L ] ) ]
         S
        /  \
      I1   "leaf"
            / \ => I2
          S2  L1

rule type[ _:String ;; _:IntermediateType ;; ( type[ "leaf"       ;; S:String                     ;; L:Leaf ] => type[ L         ] ) ]  requires S =/=String "nil" andBool S =/=String "truncate" [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "leaf"       ;; "nil"                        ;; "Nil"  ] => type[ Nil       ] ) ] [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "leaf"       ;; "truncate"                   ;; _      ] => type[ #truncate ] ) ] [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "simpletype" ;; type[ toString( ST:OrPat ) ] ;; _      ] => type[ ST        ] ) ] [anywhere]

/* 4. type[  S:String ;; I1:InitialType ;; I2:InitialType ] => I3:InitialType   [anywhere]
          S
        /  \   => I3
      I1    I2
*/
rule type[ "quote"   ;; type[P:Proc    ]  ;; _:InitialType  ] => type[ @ P ] [anywhere]
rule type[ "quote"   ;; type[P:ProcPat ]  ;; _:InitialType  ] => type[ @ P ] [anywhere]

rule type[ "reify"   ;; type[N:Name    ]  ;; type[ #truncate ] ] => type[ * N ] [anywhere]
rule type[ "reify"   ;; type[N:NamePat ]  ;; type[ #truncate ]  ] => type[ * N ] [anywhere]

rule type[ "send"    ;; type[N:Name    ] ;; type[P:Proc    ] ] => type[ N ! ( P ) ] [anywhere]
rule type[ "send"    ;; type[N:Name    ] ;; type[P:ProcPat ] ] => type[ N ! ( P ) ] [anywhere]
rule type[ "send"    ;; type[N:NamePat ] ;; type[P:Proc    ] ] => type[ N ! ( P ) ] [anywhere]
rule type[ "send"    ;; type[N:NamePat ] ;; type[  Nil     ] ] => type[ N ! (Nil) ] [anywhere]
rule type[ "send"    ;; type[N:NamePat ] ;; type[P:ProcPat ] ] => type[ N ! ( P ) ] [anywhere]

rule type[ "bind"    ;; type[B:BindNamePat ] ;; type[N:Name    ] ] => type[ B <- N ] [anywhere]
rule type[ "bind"    ;; type[B:BindNamePat ] ;; type[N:NamePat ] ] => type[ B <- N ] [anywhere]

rule type[ "receive" ;; type[R:Bind    ] ;; type[P:Proc    ] ] => type[ for( R ){ P } ] [anywhere]
rule type[ "receive" ;; type[R:Bind    ] ;; type[P:ProcPat ] ] => type[ for( R ){ P } ] [anywhere]
rule type[ "receive" ;; type[R:BindPat ] ;; type[P:ProcPat ] ] => type[ for( R ){ P } ] [anywhere]

rule type[ "par"     ;; type[P:Proc    ] ;; type[Q:Proc    ] ] => type[ P | Q ] [anywhere]
rule type[ "par"     ;; type[P:Proc    ] ;; type[Q:ProcPat ] ] => type[ P | Q ] [anywhere]
rule type[ "par"     ;; type[P:ProcPat ] ;; type[Q:Proc    ] ] => type[ P | Q ] [anywhere]
rule type[ "par"     ;; type[P:ProcPat ] ;; type[Q:ProcPat ] ] => type[ P | Q ] [anywhere]

endmodule
