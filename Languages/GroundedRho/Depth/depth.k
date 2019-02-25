// Depth Function

requires "domains.k"
requires "../StructuralTypes/stype.k"

module DEPTH-SYNTAX
  import DOMAINS
  import INT
  import STYPE-SYNTAX

  //----------------------
  //--- Depth Function ---
  //----------------------
  syntax           Int ::= "#depth("  Type ")"   [function]  // nesting depth
                         | "#qdepth(" Type ")"   [function]  // quote depth

endmodule

module DEPTH
  import DEPTH-SYNTAX

  configuration
    <T color="teal">
      <k color="purple"> $PGM:Int </k>
    </T>

  syntax KResult ::= Int

// Leaves are the base case
  rule #depth( _:LeafType ) => 1

// The depth of a non-leaf terminaltype is computed recursively
  rule #depth( type[ _:String ;; A:TerminalType ;; B:TerminalType ] ) => 1 +Int maxInt( #depth(A) , #depth(B) )

// Quote Qepth
  rule #qdepth( _:LeafType ) => 0

  rule #qdepth( type[ "quote" ;; A:TerminalType ;; B:TerminalType ] ) => 1 +Int maxInt( #qdepth(A) , #qdepth(B) )

  rule #qdepth( type[ S:String ;; A:TerminalType ;; B:TerminalType ] ) => maxInt( #qdepth(A) , #qdepth(B) ) requires S =/=String "quote"

endmodule
