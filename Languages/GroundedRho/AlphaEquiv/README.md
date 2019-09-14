# DeBruijn Indices and Alpha Equivalence for Grho

`alpha.k` defines a function `#deBruijn` which assigns De Bruijn indices to process and name variables.

## How Constructs Are Indexed
Indexing is performed via two main functions:
1. `#deBruijn` takes an `Int` parameter and a `NamePat`, `ProcPat`, or subexpression (`RhoKVPats`, `ProcPats`, `BranchPats`, `MCasePats`, etc.) and returns properly parameterized calls to itself and `#mapify` on the subexpressions of the original input expression and indexes the name variables declared in a top-level new declaration.
2. `#mapify` takes an `Int` parameter and `NamePat`, `ProcPat`, or subexpression and returns a map of all the free variables in the expression to their indexed counterparts. This map is used to substitute indexed variables for their unindexed occurrence.

### Receives

### Sends

### Parallel Compositions
The processes `P`,`Q` running in parallel in `P | Q` are passed the same indexing environment.

TO BE CONTINUED
