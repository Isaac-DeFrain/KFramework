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

syntax               Type ::= "#untype(" Type ")"                                                   [function]

endmodule


module UNTYPE
import UNTYPE-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

syntax KResult ::= OrPatOrLeafType

rule #untype( T:Type ) => T   [strict]

/*
4 kinds of rewrites (2 pairs of symmetric rules):
1. type[ S1:String ;; S2:String ;; L:Leaf ] => I:InitialType                    i.e. type[ S1:String ;; S2:String ;; L:Leaf ] => I:InitialType (special treatment for "Nil")
2. type[  S:String ;; ( T1:TerminalType => I:InitialType ) ;; T2:TerminalType ] i.e. type[  S:String ;; ( type[ S1:String ;; S2:String ;; L:Leaf ] => type[L] ) ;; T2:TerminalType ]
3. type[  S:String ;; I1:InitialType ;; ( T:TerminalType => I2:InitialType ) ]  i.e. type[  S:String ;; I1:InitialType ;; ( type[ S1:String ;; S2:String ;; L:Leaf ] => type[L] ) ]
4. type[  S:String ;; I1:InitialType ;; I2:InitialType ] => I3:InitialType      i.e.
*/
// Leaves
// 1. type[ _:String ;; _:String ;; L:Leaf ] => type[ L/Nil ]
rule type[ _:String ;; _:String   ;; L:Leaf ] => type[ L         ]  [anywhere]
rule type[ "leaf"   ;; "nil"      ;; "Nil"  ] => type[ Nil       ]  [anywhere]
rule type[ "leaf"   ;; "truncate" ;;   _    ] => type[ #truncate ]  [anywhere]

rule type[ "simpletype" ;; type[ toString( ST:OrPat ) ] ;; _ ] => type[ ST ]  [anywhere]

/* 2. type[  _:String ;; ( type[ _:String ;; _:String ;; L:Leaf ] => type[ L:Leaf ] ) ;; _:IntermediateType ]
           S
        /     \
      S1        I1
     / \ => I2
   S2  L1
*/
rule type[ _:String ;; ( type[ _:String     ;; _:String                     ;; L:Leaf ] => type[ L         ] ) ;; _:IntermediateType ]  [anywhere]
rule type[ _:String ;; ( type[ "leaf"       ;; "nil"                        ;; "Nil"  ] => type[ Nil       ] ) ;; _:IntermediateType ]  [anywhere]
rule type[ _:String ;; ( type[ "leaf"       ;; "truncate"                   ;; _      ] => type[ #truncate ] ) ;; _:IntermediateType ]  [anywhere]
rule type[ _:String ;; ( type[ "simpletype" ;; type[ toString( ST:OrPat ) ] ;; _      ] => type[ ST        ] ) ;; _:IntermediateType ]  [anywhere]

/* 3. type[  S:String ;; I1:InitialType  ;; ( type[ S1:String ;; S2:String ;; L:Leaf ] => type[ L ] ) ]
         S
        /  \
     In1    S1
            / \ => I2
          S2  L1
*/
rule type[ _:String ;; _:IntermediateType ;; ( type[ _:String     ;; _:String                     ;; L:Leaf ] => type[ L         ] ) ]  [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "leaf"       ;; "nil"                        ;; "Nil"  ] => type[ Nil       ] ) ]  [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "leaf"       ;; "truncate"                   ;; _      ] => type[ #truncate ] ) ]  [anywhere]
rule type[ _:String ;; _:IntermediateType ;; ( type[ "simpletype" ;; type[ toString( ST:OrPat ) ] ;; _      ] => type[ ST        ] ) ]  [anywhere]

// 4. type[  S:String ;; I1:InitialType ;; I2:InitialType ] => I3:InitialType   [anywhere]
/*        S
        /  \   => I3
      I1    I2
*/
rule type[ "quote"   ;; type[P:Proc   ]  ;; _:IntermediateType ] => type[ @ P ]  [anywhere]
rule type[ "quote"   ;; type[P:ProcPat]  ;; _:IntermediateType ] => type[ @ P ]  [anywhere]

rule type[ "reify"   ;; type[N:Name   ]  ;; _:IntermediateType ] => type[ * N ]  [anywhere]
rule type[ "reify"   ;; type[N:NamePat]  ;; _:IntermediateType ] => type[ * N ]  [anywhere]

rule type[ "send"    ;; type[N:Name        ] ;; type[P:Proc   ] ] => type[ N ! ( P ) ]  [anywhere]
rule type[ "send"    ;; type[N:Name        ] ;; type[P:ProcPat] ] => type[ N ! ( P ) ]  [anywhere]
rule type[ "send"    ;; type[N:NamePat     ] ;; type[P:Proc   ] ] => type[ N ! ( P ) ]  [anywhere]
rule type[ "send"    ;; type[N:NamePat     ] ;; type[P:ProcPat] ] => type[ N ! ( P ) ]  [anywhere]
rule type[ "send"    ;; type[N:Name        ] ;; type[ Nil     ] ] => type[ N ! (Nil) ]  [anywhere]
rule type[ "send"    ;; type[N:NamePat     ] ;; type[ Nil     ] ] => type[ N ! (Nil) ]  [anywhere]

rule type[ "bind"    ;; type[B:BindNamePat ] ;; type[N:Name   ] ] => type[ B <- N ]  [anywhere]
rule type[ "bind"    ;; type[B:BindNamePat ] ;; type[N:NamePat] ] => type[ B <- N ]  [anywhere]

rule type[ "receive" ;; type[R:Bind        ] ;; type[P:Proc   ] ] => type[ for( R ){ P } ]  [anywhere]
rule type[ "receive" ;; type[R:Bind        ] ;; type[P:ProcPat] ] => type[ for( R ){ P } ]  [anywhere]
rule type[ "receive" ;; type[R:BindPat     ] ;; type[P:ProcPat] ] => type[ for( R ){ P } ]  [anywhere]

rule type[ "par"     ;; type[P:Proc        ] ;; type[Q:Proc   ] ] => type[ P | Q ]  [anywhere]
rule type[ "par"     ;; type[P:Proc        ] ;; type[Q:ProcPat] ] => type[ P | Q ]  [anywhere]
rule type[ "par"     ;; type[P:ProcPat     ] ;; type[Q:Proc   ] ] => type[ P | Q ]  [anywhere]
rule type[ "par"     ;; type[P:ProcPat     ] ;; type[Q:ProcPat] ] => type[ P | Q ]  [anywhere]

endmodule
