// Structural type system for RHO-CALCULUS
// Type = Structural binary tree

require "domains.k"
require "kast.k"
require "substitution.k"
require "../StructuralTypes/stype.k"

module T2OP-SYNTAX
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
                          | "type[" String ";;" String           ";;" IntermediateType "]"    [strict(3)]
                          | TerminalType
                          | InitialType

//  Terminal type
syntax     TerminalType ::= "type[" String ";;" String           ";;" OrPat            "]"
                          | "type[" String ";;" String           ";;" TerminalType     "]"
                          | "type[" String ";;" TerminalType     ";;" TerminalType     "]"

//-- toString --
syntax           String ::= "toString(" OrPat ")"
*/
syntax               Type ::= "#untype(" Type ")"                                                      [function]
                            | "t2ut("    Type ")"                                                        [strict]
                            | InitialUnType
                            | IntermediateUnType
                            | TerminalUnType

syntax              OrPat ::= "Untype2OrPat(" TerminalUnType ")"                                         [strict]

syntax      InitialUnType ::= "untype[" String ";;" Leaf               ";;" Leaf               "]"
                            | "untype[" String ";;" TerminalUnType     ";;" TerminalUnType     "]"
                            | TerminalType

syntax IntermediateUnType ::= "untype[" String ";;" IntermediateUnType ";;" IntermediateUnType "]"  [strict(2,3)]
                            | TerminalUnType
                            | InitialUnType
                            | IntermediatType

syntax     TerminalUnType ::= "untype[" OrPat       "]"
                            | "untype[" BindOrPat   "]"
                            | "untype[" BindNamePat "]"
                            | InitialType

endmodule


module T2OP
import T2OP-SYNTAX
import STYPE

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

syntax KResult ::= OrPat | TerminalType | TerminalUnType

rule t2ut( type[ S:String ;; T:IntermediateType ;; U:IntermediateType ] ) => untype[ S ;; T ;; U ]
rule t2ut( type[ S:String ;; T:String           ;; U:IntermediateType ] ) => untype[ S ;; T ;; U ]
rule t2ut( type[ S:String ;; T:String           ;; P:OrPat            ] ) => untype[ S ;; T ;; P ]
rule t2ut( type[ S:String ;; T:String           ;; U:TerminalType     ] ) => untype[ S ;; T ;; U ]
rule t2ut( type[ S:String ;; T:TerminalType     ;; U:TerminalType     ] ) => untype[ S ;; T ;; U ]

rule #untype( T:Type ) => T                       [strict]
//rule Type2OrPat( untype( type[ P:OrPat ] ) ) => P

// Leaves
rule untype[ "leaf"    ;; "bool"    ;; B:Bool     ] => untype[ B ]
rule untype[ "leaf"    ;; "int"     ;; I:Int      ] => untype[ I ]
rule untype[ "leaf"    ;; "string"  ;; S:String   ] => untype[ S ]

rule untype[ "leaf"    ;; "nil"     ;; "Nil"      ] => type[ Nil ]

rule untype[ "leaf"    ;; "procvar" ;; PV:ProcVar ] => untype[ PV ]
rule untype[ "leaf"    ;; "namevar" ;; NV:NameVar ] => untype[ NV ]

rule untype[ "simple"  ;; "procpat" ;; toString( ST:OrPat ) ] => untype[ ST ]

rule untype[ "quote"   ;; "name"    ;; untype[P:Proc   ] ] => untype[ @ P ]
rule untype[ "quote"   ;; "procpat" ;; untype[P:ProcPat] ] => untype[ @ P ]

rule untype[ "reify"   ;; "name"    ;; untype[N:Name   ] ] => untype[ * N ]
rule untype[ "reify"   ;; "namepat" ;; untype[N:NamePat] ] => untype[ * N ]

rule untype[ "send"    ;; untype[N:Name        ] ;; untype[P:Proc   ] ] => untype[ N ! ( P ) ]
rule untype[ "send"    ;; untype[N:Name        ] ;; untype[P:ProcPat] ] => untype[ N ! ( P ) ]
rule untype[ "send"    ;; untype[N:NamePat     ] ;; untype[P:Proc   ] ] => untype[ N ! ( P ) ]
rule untype[ "send"    ;; untype[N:NamePat     ] ;; untype[P:ProcPat] ] => untype[ N ! ( P ) ]

rule untype[ "bind"    ;; untype[B:BindNamePat ] ;; untype[N:Name   ] ] => untype[ B <- N ]
rule untype[ "bind"    ;; untype[B:BindNamePat ] ;; untype[N:NamePat] ] => untype[ B <- N ]

rule untype[ "receive" ;; untype[R:Bind        ] ;; untype[P:Proc   ] ] => untype[ for( R ){ P } ]
rule untype[ "receive" ;; untype[R:Bind        ] ;; untype[P:ProcPat] ] => untype[ for( R ){ P } ]
rule untype[ "receive" ;; untype[R:BindPat     ] ;; untype[P:ProcPat] ] => untype[ for( R ){ P } ]

rule untype[ "par"     ;; untype[P:Proc        ] ;; untype[Q:Proc   ] ] => untype[ P | Q ]
rule untype[ "par"     ;; untype[P:Proc        ] ;; untype[Q:ProcPat] ] => untype[ P | Q ]
rule untype[ "par"     ;; untype[P:ProcPat     ] ;; untype[Q:Proc   ] ] => untype[ P | Q ]
rule untype[ "par"     ;; untype[P:ProcPat     ] ;; untype[Q:ProcPat] ] => untype[ P | Q ]

endmodule
