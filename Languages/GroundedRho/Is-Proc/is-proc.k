require "stype.k"

module IS-PROC-SYNTAX
import TYPE
// the #isProc predicate
// Checks to see if the type corresponds to a process, i.e. only has one inhabitant.

syntax Bool ::= "#isProc" Type  [function]

endmodule

module IS-PROC
import IS-PROC-SYNTAX

// Semantics
// StrProc =/=String "quote" and not a pattern

endmodule
