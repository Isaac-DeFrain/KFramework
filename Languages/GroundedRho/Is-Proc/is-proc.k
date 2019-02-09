
require "../Names_Variables/namevar.k"

module IS-PROC-SYNTAX
  import NAMEVAR
// the #isProc predicate
// currently checks to see if a ProcOrPat corresponds to a process
// will ultimately check to see if the type corresponds to a process, i.e. only has one inhabitant.

// Why is the type needed here instead of using the process/pattern directly?

  syntax BExp ::= "#isProc" ProcOrPat     [function]
         //    | "#isProc" Type       [function]

endmodule

module IS-PROC
  import IS-PROC-SYNTAX
  import SET
  import BOOL

  configuration
  <T>
    <k> #isProc $PGM:ProcOrPat </k>
  </T>

  syntax KResult ::= Bool

  rule #isProc P:Proc    => V( P ) <=Set .Set [strict]
  rule #isProc P:ProcPat => V( P ) <=Set .Set [strict]

// Semantics
// StrProc =/=String "quote" and not a pattern

endmodule
