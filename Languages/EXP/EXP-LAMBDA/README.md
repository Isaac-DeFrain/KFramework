# EXP-LAMBDA language
Described in the [K Primer](http://fsl.cs.illinois.edu/FSL/papers/2013/k-primer-2013-v32/k-primer-2013-v32-public.pdf)

EXP language with functional features

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

* Functional features
```
  syntax Val ::= Int
               | "lambda" Id "." Exp      [binder]

  syntax Exp ::= Val
               | Exp Exp
               | "mu" Id "." Exp          [binder]
               | "let" Id "=" Exp "in" Exp
               | "letrec" Id Id "in" Exp "in" Exp
```

* Concurrency features
```
  syntax Exp ::= "spawn" Exp
               | "rendezvous" Exp         [strict]
```

### Semantics module
* Results
```
  KResult ::= Val
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

* Functional semantics
```
  rule (lambda X:Id . E:Exp) V:Val => E[V / X]
  rule mu X:Id . E:Exp => E[mu X . E / X]
```

  We also `"require substitution.k"` and need to `import SUBSTITUTION`.

  Desugar `let` and `letrec` directly into `lambda` and `mu`
  ```
  rule let X:Id = E1:Exp in E2:Exp => (lambda X . E2) E1  [macro]
  rule letrec F:Id X:Id = E1:Exp in E2:Exp                [macro]
    => let F = mu F . lambda X . E1 in E2
  ```

* Concurrency semantics
```
  rule <k> spawn E => 0 ...</k>
    ( . => <k> E </k>)

  rule <k> rendezvous I:Int => I ...</k>
       <k> rendezvous I     => I ...</k>
```
