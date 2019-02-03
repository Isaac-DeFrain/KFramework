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
/*
syntax             Type ::= "#type(" Type ")"                          [function]  // #type( t:Type ) => t
                          | InitialType                                            //      InitialType < Type
                          | IntermediateType                                       // IntermediateType < Type
                          | TerminalType                                           //     TerminalType < Type
                          | String                                                 //           String < Type (for String input/output)


// Simple Types - types of ground terms
syntax       SimpleType ::= "Bool"                                                 //   Bool < SimpleType
                          | "Int"                                                  //    Int < SimpleType
                          | "String"                                               // String < SimpleType

// Recursive syntax for the type rewrites
//  Initial type
syntax      InitialType ::= "type[" OrPat       "]"
                          | "type[" BindOrPat   "]"
                          | "type[" BindNamePat "]"

//  Intermediate type
syntax IntermediateType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                          | "type[" String ";;" String           ";;" IntermediateType "]"  [strict(2,3)]
                          | TerminalType
                          | InitialType

//  Terminal type
syntax     TerminalType ::= "type[" String ";;" String           ";;" Leaf             "]"
                          | "type[" String ";;" TerminalType     ";;" TerminalType     "]"

syntax             Leaf ::= Ground
                          | NameVar
                          | ProcVar
*/

syntax               Type ::= "#untype(" Type ")"                                                    [function]

syntax IntermediateUnType ::= "type[" String ";;" IntermediateType ";;" IntermediateType "]"  [strict(2,3)]
                            | "type[" String ";;" String           ";;" IntermediateType "]"    [strict(3)]
                            | TerminalType
                            | InitialType

endmodule


module UNTYPE
import UNTYPE-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

syntax KResult ::= OrPat | InitialType

rule #untype( T:Type ) => T                       [strict]

/*
type[ S1 ;;  S2        ;;  L         ] => I
type[  S ;; (T1 => I ) ;;  T2        ]
type[  S ;;  T1        ;; (T2 => I ) ]
type[  S ;; (T => I1 ) ;;  I2        ]
type[  S ;;  I1        ;; (T => I2 ) ]
type[  S ;;  I1        ;;  I2        ] => I3

6 kinds of rewrites:
1. type[ S1:String ;; S2:String ;; L:Leaf ] => InitialType                      i.e. type[ S1:String ;; S2:String ;; L:Leaf ] => I:InitialType (special treatment for "Nil")
2. type[  S:String ;; ( T1:TerminalType => I:InitialType ) ;; T2:TerminalType ] i.e. type[  S:String ;; ( type[ S1:String ;; S2:String ;; L:Leaf ] => type[L] ) ;; T2:TerminalType ]
3. type[  S:String ;; I1:InitialType ;; ( T:TerminalType => I2:InitialType ) ]  i.e. type[  S:String ;; I1:InitialType ;; ( type[ S1:String ;; S2:String ;; L:Leaf ] => type[L] ) ]
4. type[  S:String ;; I1:InitialType ;; I2:InitialType ] => InitialType         i.e.
*/

// Leaves
// 1. type[ S1:String ;; S2:String ;; L:Leaf ] => InitialType
rule type[ "leaf"        ;; "bool"    ;; B:Bool                  ] => type[ B ]
rule type[ "leaf"        ;; "int"     ;; I:Int                   ] => type[ I ]
rule type[ "leaf"        ;; "string"  ;; S:String                ] => type[ S ]

rule type[ "leaf"        ;; "nil"     ;; "Nil"                   ] => type[ Nil ]

rule type[ "leaf"        ;; "procvar" ;; PV:ProcVar              ] => type[ PV ]
rule type[ "leaf"        ;; "namevar" ;; NV:NameVar              ] => type[ NV ]

rule type[ "simpletype"  ;; "procpat" ;; toString( ST:OrPat )    ] => type[ ST ]

// 2. type[  S:String ;; ( type[ S1 ;; S2 ;; L1 ] => type[ L1 ] ) ;; type[ S3 ;; S4 ;; L2 ] ]
rule type[ "quote"       ;; "name"    ;; type[ B:Bool        ] ] ] => type[ @ B ]
rule type[ "quote"       ;; "name"    ;; type[ I:Int         ] ] ] => type[ @ I ]
rule type[ "quote"       ;; "name"    ;; type[ S:String      ] ] ] => type[ @ S ]

rule type[ "quote"       ;; "name"    ;; type[ Nil           ] ] ] => type[ @ Nil ]

rule type[ "quote"       ;; "procpat" ;; type[ PV:ProcVar    ] ] ] => type[ @ PV ]
rule type[ "quote"       ;; "procoat" ;; type[ ST:SimpleType ] ] ] => type[ @ ST ]

// 3. type[  S:String ;; T1:TerminalType ;; ( T2:TerminalType => I:InitialType ) ]

// 4. type[  S:String ;; ( T:TerminalType => I1:InitialType ) ;; I2:InitialType  ]

// 5. type[  S:String ;; I1:InitialType  ;; ( T:TerminalType => I2:InitialType ) ]

// 6. type[  S:String ;; I1:InitialType  ;; I2:InitialType ] => InitialType
rule type[ "quote"   ;; "name"    ;; type[P:Proc   ] ] => type[ @ P ]
rule type[ "quote"   ;; "procpat" ;; type[P:ProcPat] ] => type[ @ P ]

rule type[ "reify"   ;; "name"    ;; type[N:Name   ] ] => type[ * N ]
rule type[ "reify"   ;; "namepat" ;; type[N:NamePat] ] => type[ * N ]

rule type[ "send"    ;; type[N:Name        ] ;; type[P:Proc   ] ] => type[ N ! ( P ) ]
rule type[ "send"    ;; type[N:Name        ] ;; type[P:ProcPat] ] => type[ N ! ( P ) ]
rule type[ "send"    ;; type[N:NamePat     ] ;; type[P:Proc   ] ] => type[ N ! ( P ) ]
rule type[ "send"    ;; type[N:NamePat     ] ;; type[P:ProcPat] ] => type[ N ! ( P ) ]

rule type[ "bind"    ;; type[B:BindNamePat ] ;; type[N:Name   ] ] => type[ B <- N ]
rule type[ "bind"    ;; type[B:BindNamePat ] ;; type[N:NamePat] ] => type[ B <- N ]

rule type[ "receive" ;; type[R:Bind        ] ;; type[P:Proc   ] ] => type[ for( R ){ P } ]
rule type[ "receive" ;; type[R:Bind        ] ;; type[P:ProcPat] ] => type[ for( R ){ P } ]
rule type[ "receive" ;; type[R:BindPat     ] ;; type[P:ProcPat] ] => type[ for( R ){ P } ]

rule type[ "par"     ;; type[P:Proc        ] ;; type[Q:Proc   ] ] => type[ P | Q ]
rule type[ "par"     ;; type[P:Proc        ] ;; type[Q:ProcPat] ] => type[ P | Q ]
rule type[ "par"     ;; type[P:ProcPat     ] ;; type[Q:Proc   ] ] => type[ P | Q ]
rule type[ "par"     ;; type[P:ProcPat     ] ;; type[Q:ProcPat] ] => type[ P | Q ]

endmodule
