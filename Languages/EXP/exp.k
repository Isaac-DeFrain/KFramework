// Concurrent EXP Language

require "domains.k"

module EXP-SYNTAX
  import DOMAINS

// Arithmetic syntax
  syntax  Exp ::= Int | Id | String
                | "(" Exp ")"            [bracket]
                | Exp "+" Exp          [seqstrict]
                | Exp "*" Exp          [seqstrict]
                | Exp "/" Exp          [seqstrict]
                > Exp "?" Exp ":" Exp  [strict(1)]
                | Exp ";" Exp          [seqstrict]

// I/O syntax
  syntax  Exp ::= "read" "(" ")"
                | "print" "(" Exp ")"    [strict]

// Concurrency features
  syntax  Exp ::= "spawn" Exp
                | "rendezvous" Exp        [strict]

  syntax Exps ::= List{Exp,","}           [strict]
  
  syntax  Ids ::= List{Id,","}            [strict]

endmodule

module EXP
  import EXP-SYNTAX

  syntax KResult ::= Printable

  configuration
  <T color="purple">
    <threads>
      <thread multiplicity="*">
        <k> $PGM:K </k>
      </thread>
    </threads>
    <input stream="stdin"> .List </input>
    <output stream="stdout"> .List </output>
  </T>

// Arithmetic semantics
  rule I1:Int + I2:Int => I1 +Int I2
  rule I1:Int * I2:Int => I1 *Int I2
  rule I1:Int / I2:Int => I1 /Int I2 requires I2 =/=Int 0
  
  rule S1:String + S2:String => S1 +String S2

// Conditionals
  rule 0 ? _ : E:Exp => E
  rule I:Int ? E:Exp : _ => E requires I =/=Int 0
  
// Sequential composition
  rule _:Int ; I:Int => I
  rule E1:Exp ; E2:Exp => E1 ~> E2  [structural, owise]

// I/O semantics
// read() only reads integer values, it gets stuck 
// if the first value in the <in/> cell is not an integer!
  rule <k> read() => I ...</k>
       <input> ListItem(I:Int) => .List ...</input>

  syntax Printable ::= Int | String
  syntax Exp ::= Printable
  rule <k> print(P:Printable) ...</k>
       <output>... .List => ListItem(P) </output>

// Concurrency semantics
  // Spawn thread
  rule <k> spawn E:Exp => . ...</k>
   (.Bag => <thread> <k> E </k> </thread>)

  // Synchronization
  rule <k> rendezvous I:Int => I ...</k>
       <k> rendezvous I     => I ...</k>

endmodule
