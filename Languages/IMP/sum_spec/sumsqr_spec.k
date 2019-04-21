require "../imp.k"

module SUMSQR_SPEC
  import IMP

// Invariant spec <=> (co)inductive hypothesis
// each step of the while loop unrolling has this state transition, i.e. satisfies the property:
  rule
      <k> while (M) { Z = Z + M * M ; M = M - 1 ; } => .K ...</k>
      <state>
        M |-> (N:Int => 0)
        Z |-> (S:Int => S +Int N *Int (N +Int 1) *Int ( 2 *Int N +Int 1) /Int 6)
      </state>
      requires N >=Int  0

// Main spec
/* pre-state and post-state: if we initiate computation with an empty state map and the variables 
   M, Z with intial values N and 0, respectively, then the computation terminates with the state map 
     M |-> 0
     Z |-> (2*N+1)*(N+1)*N/6  (the expected sum of squares formula)
*/
  rule
      <k> int M , Z ; M = N:Int ; while (M) { Z = Z + M * M ; M = M - 1 ; } => .K </k>
      <state> .Map => 
        M |-> 0
        Z |-> (( 2 *Int N +Int 1 ) *Int (N +Int 1) *Int N /Int 6)
      </state>
      requires N >=Int 0

endmodule

/*
Output: #True
*/