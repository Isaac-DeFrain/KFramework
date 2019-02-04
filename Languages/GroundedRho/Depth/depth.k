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
  syntax           Int ::= "#depth" "(" Type ")"   [function,klabel(depth)]

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
  rule #depth( _:LeafType ) => 1

// The depth of a non-leaf terminaltype is computed recursively
  rule type[ _:String ;; A:TerminalType ;; B:TerminalType ] => 1 +Int maxInt ( #depth(A) , #depth(B) )
  rule #depth( type[ _:String ;; A:TerminalType ;; B:TerminalType ] ) => 1 +Int maxInt( #depth(A) , #depth(B) )  [strict]

endmodule
