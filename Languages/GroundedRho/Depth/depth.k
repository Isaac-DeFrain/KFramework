// Depth Function

requires "domains.k"
requires "kast.k"
requires "substitution.k"
requires "../StructuralTypes/stype.k"

module DEPTH-SYNTAX
  import DOMAINS
  import INT
  import KAST
  import KSEQ-SYMBOLIC
  import SUBSTITUTION
  import STYPE-SYNTAX

  //----------------------
  //--- Depth Function ---
  //----------------------
  syntax           Int ::= "#dep" "(" Type ")"   [function,klabel(dep)]

  syntax      LeafType ::= "type[" String ";;" Leaf ";;" Leaf "]"    // type[ String ;; Leaf ;; Leaf ] < LeafType and we know that type[ String ;; Leaf ;; Leaf ] < TerminalType

  syntax  TerminalType ::= LeafType                                  // for consistency, we make LeafType < TerminalType
  // strict

endmodule

module DEPTH
  import DEPTH-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Type </k>
    </T>

  syntax KResult ::= Int

// Leaves are the base case
  rule _:LeafType => 1

// The depth of a non-leaf terminaltype is computed recursively
  rule type[ _:String ;; A:TerminalType ;; B:TerminalType ] => 1 +Int maxInt ( #dep(A) , #dep(B) )

  rule #dep( _:LeafType ) => 1
  rule #dep( type[ _:String ;; A:TerminalType ;; B:TerminalType ] ) => 1 +Int maxInt( #dep(A) , #dep(B) )  [strict]

endmodule
