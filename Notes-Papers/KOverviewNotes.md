# K Overview and SIMPLE Case Study Notes


## Overview of the K Framework
Overview of K focusing on its capabilities and objectives.

K is a programming language definitional framework based on context insensitive term rewriting. K builds upon the following three main ideas:

1. Flatten syntax into special *computational structures*, or simply *computations*, which include abstract syntax and are reminiscent of refocusing in reduction semantics with evaluation contexts, continuations, and computations in monads.

2. Represent the state, or *configuration*, of an executing program as a potentially nested structure of labeled *cells*. K rewrite rules then iteratively transform such configurations, starting with a configuration holding the original program and ending with a configuration holding the result.

3. Give semantics to language constructs using the K *rewrite rules*, typically a small number of independent rules for each language construct. The precise semantics of K is given in terms of graph rewriting intuitions, in order to yield truly concurrent language semantics. K rules are split into two groups: *structural* and *computational*. The role of structural rules is only to rearrange the configuration so that computational rules can match and apply.

K additionally brings a series of semantic innovations and notations, e.g. K rules are regarded as *transactions*, stating what is only read, what is both read and written, and what is irrelevant. This allows for true concurrency, even in the presence of sharing. Also, a *configuration abstraction* mechanism allows definitions to be both compact and modular.

### Case Study: the SIMPLE Language
SIMPLE is intended to be a pedagogical and research language that captures the essence of the imperative programming paradigm. A `.simple` program consists of a set of global variable  declarations and function definitions. Like in C, functions cannot be nested and each program must have one function called `main`, which is invoked when the program is executed. SIMPLE also includes the following features in addition to the conventional imperative expression and statement constructs:

* *Multidimensional arrays and array references*. An array evaluates to an array reference, which is a special value holding a location (where the elements of the array start) together with the size of the array; the elements of the array can be array references themselves. Array references are *ordinary values*, i.e. they can be assigned to variables and passed/received by functions.

* *Functions and function values*. Functions can have zero or more parameters and can return abruptly using a `return` statement. SIMPLE follows a call-by-value parameter passing style, with static scoping. Function names evaluate to *function abstractions*, which are also ordinary values.

* *Blocks with locals*. SIMPLE variables can be declared anywhere, their scope being from their declaration place until the end of the enclosing block.

* *Input/Output*. The expression `read()` evaluates to the next value in the input buffer, and the statement `print(e)` evaluates `e` and outputs its value to the output buffer. Input/Output buffers are lists of values.

* *Exceptions*. SIMPLE has parametric exceptions (the value thrown as an exception can be caught and bound).

* *Concurrency via dynamic thread creation/termination and synchronization*. One can spawn a thread to execute any statement. The spawned thread shares its environment at creation with its parent. Threads can be synchronized via a join command which blocks the current thread until the joined thread completes, via re-entrant locks which can be acquired and released, and rendezvous commands.

### K Syntax
The K syntax of languages, calculi, or systems, as well as the additional syntax needed for the semantics of these, is defined using *context-free grammars* (CFG), or equivalently, algebraic signatures written using the *mixfix* notation. We use `List{Nonterminal,terminal}` to refer to the nonterminal corresponding to `terminal`-separated lists of `Nonterminal` elements; e.g. `List{Exp,@}` refers to `@`-separated lists of expressions. As a special case, `List{Nonterminal}` stands for comma-separated lists of nonterminals. In K, "`.`", read "nothing" and possibly tagged with its type, is uniformly used as the unit of all structures mentioned above. If a different unit is preferred, it can be specified as an additional argument to `List`, e.g. `List{Exp,@,nil}`.

Syntax definition and parsing 













