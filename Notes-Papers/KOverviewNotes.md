# K Overview Notes


## Overview of the K Framework
Overview of K focusing on its capabilities and objectives.

K is a programming language definitional framework based on context insensitive term rewriting. K builds upon the following three main ideas:

1. Flatten syntax into special *computational structures*, or simply *computations*, which include abstract syntax and are reminiscent of refocusing in reduction semantics with evaluation contexts, continuations, and computations in monads.

2. Represent the state, or *configuration*, of an executing program as a potentially nested structure of labeled *cells*. K rewrite rules then iteratively transform such configurations, starting with a configuration holding the original program and ending with a configuration holding the result.

3. Give semantics to language constructs using the K *rewrite rules*, typically a small number of independent rules for each language construct. The precise semantics of K is given in terms of graph rewriting intuitions, in order to yield truly concurrent language semantics. K rules are split into two groups: *structural* and *computational*. The role of structural rules is only to rearrange the configuration so that computational rules can match and apply.














