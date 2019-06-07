
require "../Names_Variables/namevar.k"

module IS-PROC-SYNTAX
  import DOMAINS
  import NAMEVAR-SYNTAX
// the #Proc? predicate checks to see if input corresponds to a process
// the #Pat? predicate checks to see if input corresponds to a process with free variables

  syntax Bool ::= "#Proc?(" K ")"
                | "#Pat?("  K ")"

endmodule

module IS-PROC
  import IS-PROC-SYNTAX
  import NAMEVAR

  configuration
  <T>
    <k> $PGM:K </k>
  </T>

  syntax KResult ::= Bool | Set

  rule #Proc?( P:Proc ) => FV( P ) <=Set .Set
  rule #Pat?(  P:Proc ) => notBool( FV( P ) <=Set .Set )

endmodule
