# Match Predicate -- Structural type inclusion

`match.k` defines a predicate `#match` for pattern-matching, i.e. `#match( A:Proc ; B:Proc )` is true if `A` and `B` match and false otherwise.

See `/tests` for examples.

## Matching

### Receives
Matching receives is a complicated matter. At the surface, it's not completely clear what this means as the relationships between variable bindings from specific channels must somehow also be present in the to-be-matched receive. The complexity of this situation increases significantly when receives with multiple bindings are considered. E.g. `example 1`

As far as terminology is concerned, we will refer to the components of the matching predicate as follows:
```rholang
    #match( A:Receive ; B:Receive )
```
We will call `A` the *candidate receive* and `B` the *to-be-matched receive*. The notation denotes that we will check whether the candidate receive matches the to-be-matched receive. This predicate returns `true` if they match and `false` otherwise.

Thankfully, some of the receive matching requirements are relatively straightforward. We claim that these requirements are straightforward:
for a receive A to match a receive B,
* the type of binding(s) must be the same in both receives; i.e. linear, peek, or repeated;
* the number of listens must be the same in both receives;
* for one bind to match another: the channels must match, the number of listening names must be equal, and the listening names must match pairwise; and
* the continuations must behave in a matching manner, upon substitution of their respective listening variables (more on this below).

However, there are more subtle conditions that must also be satisfied for a satisfactory notion of receive matching. These arise in the context of receives with multiple listens/bindings:
* any channel equality relations present in the to-be-matched receive must also be reflected in the candidate receive (see example 2);
* to ensure matching behavior of the continuations, after all binds have been matched, we substitute the listening variables from the binds in the candidate receive for the listening variables of the corresponding binds of the to-be-matched receive into the continuation of the to-be-matched receive and check that this is matched by the continuation of the candidate receive (see example 3); and
* as long as there exists one favorable matching configuration, the match is successful (see example 4).

Example 2:
```rholang
    #match( for( a <= @0 & b <= @1 ){ ... } ; for( y <= x & z <= x ) { ... } ) => false
```
Since the candidate channels are distinct and the to-be-matched channels are the same, these both should evaluate to `false`.

Example 3:
On the other hand,
```rholang
    #match( for( a <= @0 & b <= @1 ){ a!(*b) } ; for( y <= w & z <= x ) { y!(*z) } ) => true
```
should evaluate to `true` since the binds and continuations match (see below).

Shifting focus to the continuations,
```rholang
    #match( for( a <= @0 & b <= @1 ){ a!(*b) } ; for( y <= w & z <= x ) { y!(*z) } ) => true
```
we can expect one of two outcomes from matching binds:
1. Binds match like `#match( a <= @0 ; y <= w ) => true` and `#match( b <= @1 ; z <= x ) => true`, resulting in the following check for the continuations (we substitute `a` for `y` and `b` for `z` in the to-be-matched receive's continuation in this case):
```rholang
    #match( a!(*b) ; a!(*b) ) => true
```
2. Binds match like `#match( a <= @0 ; z <= x ) => true` and `#match( b <= @1 ; y <= w ) => true`, resulting in the following check for the continuations (we substitute `a` for `z` and `b` for `y` in the to-be-matched receive's continuation in this case):
```rholang
    #match( a!(*b) ; b!(*a) ) => true
```
Currently this returns `true`, but should not in this case as we have not preserved the relationships of the listening variables in the continuation. E.g. if we consider having the sends `@0!(1)` and `@1!("a")` in the tuplespace, then the substitution in case 1 leads to both continuations being `@1!("a")`, but in case 2, the continuations are `@1!("a")` and `@"a"!(1)`, respectively.

In the case of `Proc` continuations we should look for structural equivalence of these continuations. In the case of `ProcPat` we need something strictly between structural equivalence and type inclusion...
