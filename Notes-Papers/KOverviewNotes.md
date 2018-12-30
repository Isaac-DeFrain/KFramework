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

#### Configuration of SIMPLE
SIMPLE has functions with abrupt termination, exceptions, dynamic threads with lock synchronization and memory sharing, and input/output. The initial configuration of SIMPLE:
```
	<T>
	  <threads>
	    <thread multiplicity="*">
	      <k>
		$PGM:K
	      </k>
	      <control>
		<fstack>
		  .List
		</fstack>
		<xstack>
		  .List
		</xstack>
	      </control>
	      <env>
		.Map
	      </env>
	      <holds>
		.Map
	      </holds>
	      <id>
		0
	      </id>
	    </thread>
	  </threads>
	  <genv>
	    .Map
	  </genv>
	  <store>
	    .Map
	  </store>
	  <busy>
	    .Set
	  </busy>
	  <terminated>
	    .Set
	  </terminated>
	  <in>
	    .List
	  </in>
	  <out>
	    .List
	  </out>
	  <nextLoc>
	    0
	  </nextLoc>
	</T>
```

consists of a top level cell, `T`, holding a `threads` cell, a global environment map cell `genv` mapping the global variables and function names to their locations, a shared store map cell `store` mapping each location to some value, a set cell `terminated` holding the unique identifiers of the threads which have terminated (needed for `join`), `input` and `output` list cells, and a `nextLoc` cell holding a natural number undicating the next available location in memory. In SIMPLE, we prefer to explicitly manage memory. The location counter in `nextLoc` models an actual physical location in the store. The `threads` cell contains one `thread` cell for each existing thread in the program (signified by `multiplicity="*"`, meaning that at any given moment there could be zero or more `thread` cells). Each `thread` cell contains a computation cell `k`, a `control` cell holding the various control structures needed to jump to certain points of interest in the program execution, a local environment cell `env` mapping the thread local variables to locations in the store, and finally a `hold` map cell indicating what locks have been acquired by the thread and not released so far and how many times each lock has been acquired without being released (SIMPLE's locks are re-entrant). The `control` cell contains only two subcells, a function stack `fstack` and an exception stack `xstack` which are both lists. More control structures can be added to the `control` cell if the language is extended with more control-changing constructs. Notice that all cells except the `k` cell are initialized, in that they contain a ground term of their coreesponding sort. The `k` cell is initialized with the (KAST of the) program to be executed.

K's configuration declaration does several things at the same time:
1. It defines an algebraic signature for configurations;
2. It says how to initialize the configuration;
3. It gives a basis for concretizing semantic rewrite rules, which for modularity, can be given more abstractly.

K uses XML to delimit cells (shown above) and allows for users to further initialize the configuration with custom `$PGM`-like placeholders, and even allows for connecting certain cells to standard I/O in order to obtain realistic interpreters when executing K definitions.

### K Rules
The configuration is initialized by placing the target program at it's specified position and initializing all other cells with their declared contents. The K rewrite rules giving the language semantics (nondeterministically and concurrently) match and apply, potentially generating any possible behavior of the target program. There are two types of rules in K, *structural* and *computational*. Intuitively, structural rules decompose and eventually push the tasks to the top (or to the left) of the computation. Semantic rules then say how to process the atomic tasks. I.e. the structural rules do not count as observable steps, while the computational rules do. We discuss the formal semantic difference between the two in the next section. Unless explicitly tagged `[structural]`, K rules are assumed to be computational.

#### Structural Rules
An important category of structural rules is *heatin/cooling* rules (terminology inspired from the chemical abstract machine). Heating/cooling rules have the role of re-arranging the computation according to the desired evaluation strategies. The result of this structural process is that, unlike in reduction semantics with evalutaion contexts, rewriting in K nedds *not* be context-sensitive. E.g. consider the addition operation in SIMPLE, which is intended to be nondeterministic. We add two pairs of reversible structural rules for it, namely
```
	rule E1 + E2 => E1 ~> [] + E2  [structural] //heating
	rule E1 ~> [] + E2 => E1 + E2  [structural] //cooling

	rule E1 + E2 => E2 ~> E1 + []  [structural] //heating
	rule E2 ~> E1 + [] => E1 + E2  [structural] //cooling
```

The first and third ("heating") rules say that at any moment we can "heat" an addition by pulling any of its two arguments and scheduling it for reduction, thus *splitting* syntax into an *evaluation context* (the tail of the resulting sequence of computational tasks) and a *redex* (the head of the sequence). The second and fourth ("cooling") rules say that at any moment we can "cool" the addition by plugging its heated argument back into its context. This way, we can nondeterministically explore all possible orders in which the two arguments of a sum can be reduced (all their evaluation interleavings).

To simplify the application of heating/cooling rules, in K we simply use a syntactic annotation:
```
	syntax Exp := Exp "+" Exp  [strict]
```

The "strict" annotation, or attribute, associated to a syntactic construct states that it is intended to be (nondeterministically) strict in its arguments, and is equivalent to giving the four rules above. We can constrain strictness only to specified by appending a space-separated list in parentheses, e.g. a construct which is to be strict only in its first and third arguments, would be annotated with "strict(1 3)". To evaluate the arguments of a construct in a specified order, say from left to right, we use the `[seqstrict]` annotation. The translation of "sequentially strict" rules into structural heatin/cooling rules is as follows:
```
	rule E1 + V2 => E1 ~> [] + V2  [structural] //heating
	rule E1 ~> [] + V2 => E1 + V2  [structural] //cooling

	rule V1 + E2 => E2 ~> V1 + []  [structural] //heating
	rule E2 ~> V1 + [] => V1 + E2  [structural] //cooling
```

where `V1` is the evaluation of `E1` and `V2` of `E2`.

The heating/cooling rules are not immediately executable, as they can lead to non-termination. The same way the theory of term rewriting allows for rewriting *modulo* axioms like commutativity (and associativity, idempotency, etc.) and rewrite engines provide decision procedures to implement it, in the theory of K, we assume that rewriting with computational rules occurs modulo the structural rules and implementations of K provide heuristics or procedures to deal with structural rules. If one is willing to trade (some) nondeterminism for performance, then one can break the circularity of heating/cooling rules like above by adding side-conditions saying that the heated expression is always a non-value (e.g. `E1` in the rule) and that the cooled expression is always a value (e.g. `E1` in the second rule).

More generally, we can specify any evaluation context in terms of heating/cooling structural rules, by simply pulling the "hole" from the context and scheduling it in front of the context. E.g. consider the following K evaluation context in the definition of SIMPLE stating that in order to calculate the "lvalue" of an array element we need to evaluate the index of that element (here `A` ranges over array expressions):
```
	context lvalue(A([]))
```

This context can be represented by the following two structural rules:
```
	rule lvalue(A(E)) => E ~> lvalue(A([]))  [structural]
	rule E ~> lvalue(A([])) => lvalue(A(E))  [structural]
```

In reduction semantics, the evaluation context above would be specified using a syntactic declaration of the form `Cxt ::= lvalue(A(Cxt))`. K allows users to specify evaluation contexts using a notation like `lvalue(A[]))` above, in addition to more particular attributes. Such declarations of evaluation contexts are then automatically translated into heating/cooling rules like above.

The heating/cooling rules are not restricted to only defining evaluation strategies by means of conventional evaluation contexts. E.g. the K tool allows users to specify "contexts" like the following:
```
	context I * [] when I =/=Int 0

	context [] . M when [] =/=K super

	context ++ ([] => lvalue([]))
```

The first context states that the second argument of a multiplication operation is evaulated only if the value of the first argument is different from zero (since one may want to give a shortcircuited semantics to multiplication and reduce the amount of unnecessary nondeterminism). The second states that the object in a member access expression is evalutaed whever it is different `super` (since `super` member accesses are resolved statically). The third context declaration makes use of K's in-place rewriting notation. It basically says that when the argument of the increment construct is evaluated, it should be wrapped with the `lvalue` construct. The role of the wrapper is for the special treatment of the expression being evaluated.

The heating rules corresponding to these contexts are, respectively:
```
	rule I * E => E ~> I * []         [structural]

	rule E . M => E ~> [] . M         [structural]

	rule ++ E  => lvalue(E) ~> ++ []  [structural]
```

The corresponding cooling rules reverse the heating rules. Note that the cooling rule for the third context expects the wrapper to still be wrapping the expression, and it removes it upon plugging the expession back. Thus, this wrapper should only have contextual meaning, used for altering the semantics, but being preserved by it. In some sense, these wrappers are actually providing locally typed evaluation contexts.

Not all structural rules are heating/cooling rules. Sometimes we want to desugar some language constructs into others or into built-in K constructs and we do not want such steps to be observable. E.g. one may want to desugar a "for" loop into a "while" loop or eliminate the sequential composition construct, replacing it with the K built-in `~>` construct. A language designer may not want such structural rules to be reversible. In fact, making all structural rules reversible may yield unwanted nondeterminism in the language.

#### Computational Rules
Many K rules, particularly those which are computational, involve more than one cell. E.g. the variable lookup rule of SIMPLE grabs the program variable to lookup from the `k` cell, then grabs its location from the `env` cell, then accesses the value at that location in the `store` cell, and finally rewrites the program variable to that value. Thus, a significant amount of configuration structure needs to be specified in the rule for variable lookup and in the end only a little bit of that structure is changed. Conventional rewrite rules of the form `left => right` have two drawbacks, one practical and one theoretical. Practically, one has to mention the entire configuration context in *both* `left` and `right`, which is tedious, error-prone, and non-modular. Theoretically, such rules enforce an interleaving semantics for concurrency where one may want a true concurrency semantics; e.g. two threads reading the same location in the store would have to interleave, simply because the left-hand-sides of the corresponding variable lookup rule instances overlap. K addresses these problems by introducing an *in-place* style for writing rewrite rules and a semantics for it which is not based on translation to conventional rules.

The K rule for variable lookup in SIMPLE:
```
	rule <threads>... <thread> <k> X => V ...</k> <env>... X |-> L ...</env> ...</thread> ...</threads>
	     <store>... L |-> V ...</store>
```

This translates to the conventional rewrite rule:
```
	rule threads(thread(k(X ~> K) env(X |-> L, Env) Thread) Threads) store(L |-> V, Store)
	  => threads(thread(k(V ~> K) env(X |-> L, Env) Thread) Threads) store(L |-> V, Store)
```

where `K`, `Env`, `Thread`, `Threads`, and `Store` are cell frame variables corresponding to the "tears".














