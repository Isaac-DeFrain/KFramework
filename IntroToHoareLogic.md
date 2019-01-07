# Introduction to Hoare Logic

## Hoare Triple
The central feature of Hoare logic is the **Hoare triple**. A triple describes how the execution of a piece of code changes the state of the computation. A Hoare triple is of the form
```
	{P} C {Q}
```

where `P` and `Q` are *assertions* and `C` is a *command*. `P` is called the *precondition* and `Q` is called the *postcondition*: when the precondition is met, executing the command establishes the postcondition. Assertions are formulae is predicate logic.

Hoare logic provides *axioms* and *inference rules* for all the constructs of a simple imperative programming language. Additionally, there are rules for *concurrency*, *procedures*, *jumps*, and *pointers*.

## Partial and Total Correctness
Standard Hoare logic can only prove *partial correctness*, while termination must be proved separately. Thus the intuitive reading of a Hoare triple `{P} C {Q}` is:
```
	Whenever P holds of the state before execution of C, then Q will hold afterwards, or C does not terminate.
```

In the latter case, there is no "after", so `Q` can be any statement. Indeed, one can choose `Q` to be false to express that `C` does not terminate.

## Rules
* Empty statement axiom schema

The *empty statement* rule asserts that the `skip` statement does not change the state of the program, thus whatever holds true before `skip` also holds true afterwards.
```
	_ => {P} skip {P}
```

* Assignment axiom schema

The *assignment axiom* states that, after the assignment, any predicate that was previously true for the right-hand side of the assignment now holds for the variable. Formally, let `P` be an assertion in which the variable `x` is *free*. Then:
```
	_ => {P[E/x]} x:= E {P}
```

where `P[E/x]` denotes the assertion `P` in which each *free occurrence* of `x` has been replaced by the expression `E`.

The assignment scheme means that the truth of `P[E/x]` is equivalent to the after-assignment truth of `P`.

E.g. valid triples:
  * `{ x+1 = 42 } y:= x+1 { y = 42 }`
  * `{ x+5 <= N } x:= x+5 { x <= N }`

All preconditions that are not modified by the expression can be carried over to the postcondition. E.g. `{ x+1 = 42 } y:= x+1 { y = 42 and x+1 = 42}`

The assignment axiom scheme is equivalent to saying that to find the precondition, first take the postcondition and replace all occurrences of the left-hand side of the assignment with the right-hand side of the assignment. The converse is false in general, i.e. `{ P } x := E { P[E/x] }` is not necessarily true. E.g. the converse leads to nonsense like `{ x = 5 } x := 3 { 3 = 5 }`.

While a given postcondition `P` uniquely determines the precondition `P[E/x]`, the converse is not true. E.g. both `{ 0 < y*y /\ y*y < 9 } x := y*y { 0 < x /\ x < 9 }` and `{ 0 < y*y /\ y*y < 9 } x := y*y { 0 < x /\ y*y < 9 }` are valid instances of the assignment axiom scheme.

The assignment axiom proposed by Hoare **does not apply** when more than one name may refer to the same stored value. E.g. `{ y = 3 } x := 2 { y = 3 }` is wrong if `x` and `y` refer to the same variable (*aliasing*).


* Rule of composition

Hoare's rule of composition applies to sequentially executed programs `S` and `T`, where `S` executes prior to `T`, written `S ; T` (`Q` is called the *midcondition*):
```
	{P} S {Q} , {Q} T {R} => {P} S ; T {R}
```

E.g. consider the following instances of the assignment axiom: `{x+1 = 42} y := x+1 {y = 42}` and `{y = 42} z := y {z = 42}`. By the rule of composition, one concludes `{x+1 = 42} y := x+1 ; z := y {z = 42}`.


* Conditional rule

The conditional rule states that a postcondition `Q` common to both the `then` and `else` parts is also a postcondition of the whole `if...endif` statement.
```
	{B /\ P} S {Q} , {~B /\ P} T {Q} => {P} if B then S else T endif {Q}
```

* Consequence rule

This rule allows one to strengthen the precondition and/or to weaken the postcondition.
```
	P1 -> P2 , {P2} S {Q2} , Q2 -> Q1 => {P1} S {Q1}
```

* While rule
```
	{P /\ B} S {P} => {P} while B do S done {~B /\ P}
```

Here `P` is the *loop invariant*, which is to be preserved by the loop body `S`. After the loop is finished, this invariant `P` still holds, and moreover `~B` must have caused the loop to end. As in the conditional rule, `B` must not have side effects.

E.g. a proof of `{x <= 10} while x < 10 do x := x+1 done {x = 10}` (where `{x = 10}` is `{~(x < 10) /\ x <= 10}` simplified) by the while rule requires a proof of `{x < 10} x := x+1 {x <= 10}` (where `{x < 10}` is `{x <= 10 /\ x < 10}` simplified), which is obtained by the assignment rule. Finally, the postcondition `{~(x < 10) /\ x <= 10}` can be simplified to `{x = 10}`.

The while rule can be used to formally verify the following program to compute the exact square root `x` of an arbitrary number `a` - even if `x` is an integer variable and `a` is not a square number: 
```
	{true} while x*x =/= a do skip done {x*x = a /\ true}
```

After applying the while rule with `P` being `true`, it remains to prove `{true /\ x*x =/= a} skip {true}`, which follows from the empty statement axiom and consequence rule.

In fact, this program is *partially* correct because it is not guaranteed to terminate.

