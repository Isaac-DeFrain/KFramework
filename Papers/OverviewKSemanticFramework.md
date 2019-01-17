# Overview of K Semantic Framework Notes

## Abstract
K is an executable semantic framework in which programming languages, calculi, as well as type systems or formal analysis tools can be defined, making use of *configurations*, *computations*, and *rules*. Configurations organize the system/program state into units called *cells*, which are labeled and can be nested. Cpomputations carry "computational meaning" as special nested list structures sequentializing computational tasks, such as fragments of programs; in particular, computations extend the original language or calculus syntax. K (rewrite) rules generalize conventional rewrite rules by making explicit which parts of the term they read, write, or do not care about. This distinction makes K a suitable framework for defining truly concurrent languages or calculi, even in the presence of sharing. Since computations can be handled like any other terms in a rewriting environment, i.e. they can be matched, moved from one place to another in the original term, modified, or even deleted. K is particularly suitable for defining control-intensive language features such as abrupt termination, exceptions, or call/cc.

We give an overview of the K framework: what it is, how it can be used, and where it has been used already. We also discuss the K definition of CHALLENGE, a programming language that aims to challenge and expose the limitations of existing semantic frameworks.


## Introduction
"Gentle" introduction to K, a rewriting-based semantic definitional framework. K was introduced by Gigore Rosu in the lecture notes of a programming langauge design course at the University of Illinois Urbana-Champaign in Fall 2003, as a means to define executable concurrent languages in rewriting logic using [Maude](http://maude.cs.illinois.edu/w/index.php/The_Maude_System). A more formal description of K can be found in [Programming Languages: A Rewriting Approach](http://fsl.cs.illinois.edu/pub/pl.pdf).


## K Overview by Example
Programming languages, calculi, as well as type systems or formal analyzers can be defined in K by making use of special, potentially nested *(K) cell* structures, and *(K) rewrite rules*. There are two types of K rules: *computational rules*, which count as computational steps, and *structural rules*, which do not count as computational steps. K rules are *unconditional* (they may have ordinary side conditions, though, as rule schemata), and they are *context-insensitive*, so K rules apply concurrently as soon as they match, without any contextual delay or restrictions.

### K Semantics of IMP
K makes intensive use of the context-free grammar (CFG) notation for syntax and for configurations, extended with specialized "algebraic" notation for lists, sets, multisets (bags), and maps. For any sort `S`, the sort `List[*, S, I]` (or `Bag[*, S, I]` or `Set[*, S, I]`) defines the `*`-separated lists (or bags or sets) of elements of sort `S`, with identity `I`. If unspecified, by default `*` is `_, _` for lists and `_ _` for bags and sets, and `I` is `.`. `List[S]` defines the comma-separated lists of type `S`, expressed with the lower-level CFG productions
```
	List[S] ::= . | S(,S)*
```

Similarly
```
	Map[*, S1 |-> S2, I]
```

contains a set of mappings `source |-> target`, with `source` of sort `S1` and `target` of sort `S2`, separated by `*` and with identity `I`; by default, `*` is `_ _` and `I` is `.`.

Like in the CHAM, program or system configurations in K are organized as potentially nested structures of *cells*.

The K configuration of IMP can be defined as:
```
	Config(IMP) == <<K>_k <Map[Id |-> Int]>_state>_T
```

i.e. IMP configurations consist of a top cell `<>_T` containing two other cells inside: a cell `<>_k` which holds a term of sort `K` (terms of sort `K` are called *computations* and extend the original language syntax as explained below) and a cell `<>_state` which holds a map from variables to integers. E.g. "`<<x = 1; y = x + 1;>_k <.>_state>_T`" is a configuration holding program "`x = 1; y = x + 1;`" and empty state, and "`<<x = 1; y = x + 1;>_k <x |-> 0, y |-> 1>_state>_T`" is a configuration holding the same program and a state mapping `x` to `0` and `y` to `1`.

K provides special notational support for *computational structures*, or simply *computations*. Computations have the sort `K`, which is builtin in the K framework. Computaions extend the original language/calulus/system syntax with special `~>`-separated lists. Like in reduction semantics with evaluation contexts, K allows one to define evaluation contexts over the language syntax. However, unlike reduction semantics, parsing does not play any crucial role in K, because K replaces the hard-to-implement split/plug operations of evaluation contexts by plain, context-insensitive rewriting. Therefore, instead of defining evaluation contexts using context-free grammars and relying on splitting syntactic terms (via parsing) into the evaluation contexts and redexes, in K we define define evaluation contexts using special rewrite rules. E.g. the evaluation contexts of sum, comparison, and conditional in IMP can be defined as follows, by means of *structural rules* (the sum `+` is nondeterministic, i.e. the evaluation procedure for its arguments is not fixed and the comparison `<=` is sequential):
```
	             a1 + a2  <=>  a1 ~> [] + a2
	             a1 + a2  <=>  a2 ~> a1 + []
	            a1 <= a2  <=>  a1 ~> [] <= a2
	            i1 <= a2  <=>  a2 ~> i1 <= []
	if b then s1 else s2  <=>  b ~> if [] then s1 else s2
```

The symbol `<=>` stands for two structural rules, one left-to-right and another right-to-left.

The right-hand sides of the structural rules above contain, besides the task sequentialization operator `~>`, `freezer` operators containing `[]` in their names. The first rule above says that in any expression of the form `a1 + a2`, `a1` can be scheduled for processing while `a2` is being held for future processing. Since the rules above are bi-directional, they can be used at will to structurally rearrange the computations for processing. Thus, when iteratively applied left-to-right they fulfill the role of *splitting* syntax into an evaluation context (the tail of the resulting sequence of computational tasks) and a redex (the head of the resulting sequence), and when applied right-to-left they fulfill the role of plugging syntax into context. Such structural rules are known as *heating*/*cooling rules* in K. `a1 + a2` is "heated" into `a1 ~> [] + a2`, while `a1 ~> [] + a2` is "cooled" into `a1 + a2`.














