require "../imp.k"

module SUM_SPEC
  import IMP

  rule   // invariant spec
      <k> while (n) { s = s + n ; n = n - 1 ; } => .K ...</k>
      <state>
        n |-> (N:Int => 0)
        s |-> (S:Int => S +Int N *Int (N +Int 1) /Int 2)
      </state>
      requires N >=Int  0

  rule   // main spec
      <k> int n , s ; n = N:Int ;  while (n) { s = s + n ; n = n - 1 ; }  => .K </k>
      <state> .Map => 
        n |-> 0
        s |-> ((N +Int 1) *Int N /Int 2)
      </state>
      requires N >=Int 0

endmodule