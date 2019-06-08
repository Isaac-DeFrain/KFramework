require "../grho.k"

module GRHO_SPEC
  import GRHO
  
// must use #UpperIds for #KVariables

  rule   // invariant spec
      <k> while (M) { Z = Z + M ; M = M - 1 ; } => .K ...</k>
      <state>
        M |-> (N:Int => 0)
        Z |-> (S:Int => S +Int N *Int (N +Int 1) /Int 2)
      </state>
      requires N >=Int  0

  rule   // main spec
      <k> int M , Z ; M = N:Int ; while (M) { Z = Z + M ; M = M - 1 ; } => .K </k>
      <state> .Map => 
        M |-> 0
        Z |-> ((N +Int 1) *Int N /Int 2)
      </state>
      requires N >=Int 0

endmodule