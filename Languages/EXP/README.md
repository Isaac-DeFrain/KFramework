# EXP language
Described in the [K Primer](http://fsl.cs.illinois.edu/FSL/papers/2013/k-primer-2013-v32/k-primer-2013-v32-public.pdf)

## The Definition
* The `Exp` syntactic category: contains the built-in integers and three basic arithmetic operations on expressions, as well as I/O operations.

### Syntax Module
* Arithmetic syntax
```
  syntax Exp ::= Int
               | "(" Exp ")"             [bracket]
               | Exp "+" Exp           [seqstrict]
               | Exp "*" Exp           [seqstrict]
               | Exp "/" Exp           [seqstrict]
               | Exp "?" Exp ":" Exp   [strict(1)]
               | Exp ";" Exp           [seqstrict]
```

* I/O syntax
```
  syntax Exp ::= "read"
               | "print" "(" Exp ")"      [strict]
```

* Concurrency features
```
  syntax Exp ::= "spawn" Exp
               | "rendezvous" Exp         [strict]
```

### Semantics module
* Results
```
  KResult ::= Int
```
Strict functions evaluate arguments to `Int`

* Configuration
```
  configuration
    <k> $PGM:K </k>
    <streams>
      <in stream="stdin">   .List  </in>
      <out stream="stdout"> .List </out>
    </streams>
```

* Arithmetic semantics
```
  rule I1:Int + I2:Int => I1 +Int I2
  rule I1:Int * I2:Int => I1 *Int I2
  rule I1:Int / I2:Int => I1 /Int I2 requires I2 =/=Int 0

  rule 0 ? _ : E:Exp => E
  rule I:Int ? E:Exp : _ => E requires I =/=Int 0
  rule _:Int ; I2:Int => I2
```

* I/O semantics
```
  rule <k> read => I ...</k>
       <in> ListItem(I:Int) => . ...</in>

  rule <k> print(I:Int) => . ...</k>
       <out>... . => ListItem(I) </out>
```

* Concurrency semantics
```
  rule <k> spawn E => 0 ...</k>
    (.Bag => <thread> <k> E </k> </thread>)

  rule <k> rendezvous I:Int => I ...</k>
       <k> rendezvous I     => I ...</k>
```
