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
                              | "type[" String ;; Type ;; Type "]"

endmodule


module UNTYPE
  import UNTYPE-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> #untype( $PGM:Type ) </k>
    </T>

  syntax KResult ::= OrPatOrLeafType

  rule #untype( type[ S:String ;; A:IntermediateType ;; B:IntermediateType ] ) => type[ S:String ;; #untype(A) ;; #untype(B) ]  [strict(2,3)]

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
  rule #untype( type[ "leaf" ;; S:String   ;; L:Leaf ] ) => type[ L         ]  requires S =/=String "nil" andBool S =/=String "truncate" [anywhere]
  rule #untype( type[ "leaf" ;; "nil"      ;; "Nil"  ] ) => type[ Nil       ] [anywhere]
  rule #untype( type[ "leaf" ;; "truncate" ;;   _    ] ) => type[ #truncate ] [anywhere]

  rule #untype( type[ "simpletype" ;; type[ toString( ST:OrPat ) ] ;; _ ] ) => type[ ST ] [anywhere]
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
  rule #untype( type[ "quote"   ;; type[P:Proc    ]  ;; _:InitialType  ] ) => type[ @ P ] [anywhere]
  rule #untype( type[ "quote"   ;; type[P:ProcPat ]  ;; _:InitialType  ] ) => type[ @ P ] [anywhere]

  rule #untype( type[ "reify"   ;; type[N:Name    ]  ;; type[ #truncate ] ] ) => type[ * N ] [anywhere]
  rule #untype( type[ "reify"   ;; type[N:NamePat ]  ;; type[ #truncate ] ] ) => type[ * N ] [anywhere]

  rule #untype( type[ "send"    ;; type[N:Name    ] ;; type[P:Proc    ] ] ) => type[ N ! ( P ) ] [anywhere]
  rule #untype( type[ "send"    ;; type[N:Name    ] ;; type[P:ProcPat ] ] ) => type[ N ! ( P ) ] [anywhere]
  rule #untype( type[ "send"    ;; type[N:NamePat ] ;; type[  Nil     ] ] ) => type[ N ! (Nil) ] [anywhere]  // shouldn't be needed
  rule #untype( type[ "send"    ;; type[N:NamePat ] ;; type[P:Proc    ] ] ) => type[ N ! ( P ) ] [anywhere]
  rule #untype( type[ "send"    ;; type[N:NamePat ] ;; type[P:ProcPat ] ] ) => type[ N ! ( P ) ] [anywhere]

  rule #untype( type[ "bind"    ;; type[B:BindNamePat ] ;; type[N:Name    ] ] ) => type[ B <- N ] [anywhere]
  rule #untype( type[ "bind"    ;; type[B:BindNamePat ] ;; type[N:NamePat ] ] ) => type[ B <- N ] [anywhere]

  rule #untype( type[ "receive" ;; type[B:Bind    ] ;; type[P:Proc    ] ] ) => type[ for( B ){ P } ] [anywhere]
  rule #untype( type[ "receive" ;; type[B:Bind    ] ;; type[P:ProcPat ] ] ) => type[ for( B ){ P } ] [anywhere]
  rule #untype( type[ "receive" ;; type[B:BindPat ] ;; type[P:ProcPat ] ] ) => type[ for( B ){ P } ] [anywhere]

  rule #untype( type[ "par"     ;; type[P:Proc    ] ;; type[Q:Proc    ] ] ) => type[ P | Q ] [anywhere]
  rule #untype( type[ "par"     ;; type[P:Proc    ] ;; type[Q:ProcPat ] ] ) => type[ P | Q ] [anywhere]
  rule #untype( type[ "par"     ;; type[P:ProcPat ] ;; type[Q:Proc    ] ] ) => type[ P | Q ] [anywhere]
  rule #untype( type[ "par"     ;; type[P:ProcPat ] ;; type[Q:ProcPat ] ] ) => type[ P | Q ] [anywhere]

endmodule
