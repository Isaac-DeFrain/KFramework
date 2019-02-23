// Enumeration of Rho Calculus Names & Processes

require "../rho.k"

module ENUM-SYNTAX
  import RHO-SYNTAX

  syntax     Int ::= "N(" Name ")"  [function]
                   | "N(" Proc ")"  [function]

endmodule

module ENUM
  import ENUM-SYNTAX

  configuration
  <k> N( $PGM:Proc ) </k>

  syntax KResult ::= Int 

  rule N( Nil ) => 1
  rule N( @ P:Proc ) => 2 ^Int N(P)
  rule N( X:Name ( Y:Name) { P:Proc } ) => 3 ^Int N(X) ^Int N(Y) ^Int N(P)
  rule N( X:Name ! ( P:Proc ) ) => 5 ^Int N(X) ^Int N(P)
  rule N( P:Proc | Q:Proc ) => N(P) *Int N(Q)
  rule N( * @ P ) => N(P)

endmodule