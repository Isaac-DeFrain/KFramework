// Concurrent EXP Language

require "domains.k"

module EXP-SYNTAX
  import DOMAINS

// Arithmetic syntax
  syntax Exp ::= Int
               | "(" Exp ")"            [bracket]
               | Exp "+" Exp          [seqstrict]
               | Exp "*" Exp          [seqstrict]
               | Exp "/" Exp          [seqstrict]
               | Exp "?" Exp ":" Exp  [strict(1)]
               | Exp ";" Exp          [seqstrict]

// I/O syntax
  syntax Exp ::= "read"
               | "print" "(" Exp ")"     [strict]

// Concurrency features
  syntax Exp ::= "spawn" Exp
               | "rendezvous" Exp        [strict]

endmodule

module EXP
  import EXP-SYNTAX

  syntax KResult ::= Int

  configuration
  <T>
    <threads>
      <thread multiplicity="*">
        <k> $PGM:K </k>
      </thread>
    </threads>
    <feed> .List </feed>
    <disp> .List </disp>
  </T>

// Arithmetic semantics
  rule I1:Int + I2:Int => I1 +Int I2
  rule I1:Int * I2:Int => I1 *Int I2
  rule I1:Int / I2:Int => I1 /Int I2 requires I2 =/=Int 0

  rule 0 ? _ : E:Exp => E
  rule I:Int ? E:Exp : _ => E
  rule _:Int ; I2:Int => I2 

// I/O semantics
  rule <k> read => I ...</k>
       <feed> ListItem(I:Int) => . ...</feed>

  rule <k> print(I:Int) => . ...</k>
       <disp>... . => ListItem(I) </disp>

// Concurrency semantics
  rule <k> spawn E:Exp => . ...</k>
   (.Bag => <thread> <k> E </k> </thread>)

  rule <k> rendezvous I:Int => I ...</k>
       <k> rendezvous I     => I ...</k>

endmodule
