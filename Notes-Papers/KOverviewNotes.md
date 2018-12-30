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
The K syntax of languages, calculi, or systems, as well as the additional syntax needed for the semantics of these, is defined using *context-free grammars* (CFG), or equivalently, algebraic signatures written using the *mixfix* notation. We use `List{Nonterminal,terminal}` to refer to the nonterminal corresponding to `terminal`-separated lists of `Nonterminal` elements; e.g. `List{Exp,@}` refers to `@`-separated lists of expressions. As a special case, `List{Nonterminal}` stands for comma-separated lists of nonterminals. In K, `.`, read "nothing" and possibly tagged with its type, is uniformly used as the unit of all structures mentioned above. If a different unit is preferred, it can be specified as an additional argument to `List`, e.g. `List{Exp,@,nil}`.

At its core, K is not concerned with concrete syntax at all. The syntax of K currently consists of one syntactic category `K` for *computational structures* (*computations*), i.e. structures which have the capability to compute when put in the right context, together with another syntactic category, `KLabel`, for AST labels:
```
	     K ::= KLabel ( List{K} ) | List{K,~>}			  (generic)
	KLabel ::= 0 | 1 | ... | while(_)_ | {_} | ...		(language-specific)
```

A programming language, calculus, or system syntax, including constants as primitive values, is eventually regarded as a set of K labels by simply associating a unique K label to each production and discarding all the concrete syntactic categories. This way, any program or fragment of a program can be regarded (for semantic reasons) as a K *abstract syntax tree* (KAST) whose nodes are K labels and whoes leaves are `.`. By default, we use the mixfix notational philosophy when choosing label names. E.g. the fragment of SIMPLE program:
```
	while(x > 0) {x = x - 1;}
```

can be regarded as the KAST
```
	while(_)_(_>_(x(.), 0(.)), {_}(_=_(x(.), _-_(x(.), 1(.)))))
```

Theoretically, the KAST notation allows one to give language-independent and thus modular semantics to constructs that require one to visit the entire language syntax, such as substitution or code generation, by simply giving their semantics in terms of KASTs and not worrying about the concrete language syntax. Practically, it gives a means to separate syntactic and semantic concerns, leaving the translation from concrete syntax to KAST to tools.

In addition to capturing language/calculus/system syntax as KAST structures as explained, the `K` syntactic category also provides a *task sequentialization* list construct, writtenn `~>` and read "followed by" or "and then". Idea being that if `t1`, ..., `tN` are computations, then `t1 ~> ... ~> tN` can be thought of as the computation consisting of `t1` followed by ... followed by `tN`.

E.g. if `s1, s2 \in K` are KASTs corresponding to two statements in SIMPLE, then the semantics of sequential composition reduces `s1 s2` to `s1 ~> s2`, which will be further processed by using other rules: first `s1` will be fully evaluated, then `s2`. E.g. if `e1, e2 \in K` are KASTs corresponding to two expressions in SIMPLE, then the rewrite rules defining the evaluation strategy of addition will allow the expression `e1 + e2` to nondeterministically rewrite to either `e1 ~> [] + e2` or `e2 ~> e1 + []`, where `_+[]` and `[]+_` are two new K labels specifically added for this prupose.

### K Configurations
A programming language semantics is typically driven by the syntax, but it often needs additional semantic data in order to properly capture the desired semantics of each langauge consturct. Such data may include a program environment mapping program variables to memory locations, a store mapping memory locations to values, one or more stacks for functions and exceptions, a multi-set (or bag) of threads, a set of held locks associated to each thread, etc. To distinguish the various semantic components from each other, in K we "wrap" them within suggestively named *cells* when we structure them together in a configuration. These cells are nothing but constructors taking the desired structure and yieding a configuration item. E.g. the `<store>` cell can be defined as an operation
```
	store : Map -> CfgItem
```

where `Map` is the sort of maps from say natural numbers to integers. Cells can be nested.

K assumes such configurations are defined upfront, before the semantic rules are given, since thte structure of program configurations is an important aspect that gives K its modularity.
















