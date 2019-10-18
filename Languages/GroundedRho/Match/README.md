# Match Predicate -- Structural type inclusion

`match.k` defines a predicate `#match` for pattern-matching, i.e. `#match( A:Proc ; B:Proc )` is true if `A` matches `B` and false otherwise; that is to say that the structural type of `A` is included in the structural type of `B`.

See [/tests](https://github.com/Isaac-DeFrain/KFramework/tree/master/Languages/GroundedRho/Match/tests) for examples.

## Matching

### Receives
Matching receives is a complicated matter. At the surface, it's not completely clear what this means as the relationships between variable bindings from specific channels must somehow also be present in the to-be-matched receive. The complexity of this situation increases significantly when receives with multiple bindings are considered. E.g. `example 1`

As far as terminology is concerned, we will refer to the components of the matching predicate as follows:
```rholang
    #match( A:Receive ; B:Receive )
```
We will call `A` the *candidate receive* and `B` the *to-be-matched receive*. The notation and terminology allude to the fact that this predicate will check whether the candidate receive matches the to-be-matched receive.

Thankfully, some of the receive matching requirements are relatively straightforward. We claim that these requirements are straightforward:
for a receive A to match a receive B,
1. the type of binding(s) must be the same in both receives; i.e. linear, peek, or repeated;
2. the number of listens must be the same in both receives;
3. for each bind to match another:
  * they must be of the same type (already covered by 1.);
  * their channels must match, specifically the candidate bind's channel must match the to-be-matched bind's channel;
  * the number of listening names must be equal (i.e. messages of the same arity are accepted);
  * the listening name(s) must match pairwise, specifically the candidate bind's listening name(s) must match the the to-be-matched bind's listening name(s); and
4. the continuations must match, upon substitution of their respective listening variables (more on this below).

Conditions 1-3 are really about bind matching. A good way to think about this is that a bind `A` matches a bind `B` of the same type iff all messages accepted by `A` are also accepted by `B`; of course, `B` could accept other messages too, but it must accept those accepted by `A`. This means that any channel on which `A` accepts messages, `B` must also accept messages on this channel.

However, there are more subtle conditions that must also be satisfied for a *satisfactory* notion of receive matching. These arise in the context of receives with multiple listens/bindings:
5. any channel equality relations present in the to-be-matched receive must also be present in the candidate receive (see example 1);
6. to ensure matching of the continuations, after all binds have been matched, we substitute the listening variables from the binds in the candidate receive for the listening variables of the corresponding binds of the to-be-matched receive into the continuation of the to-be-matched receive and check that this is matched by the continuation of the candidate receive (see example 2); and
7. as long as there exists one favorable matching configuration, the match is successful (see example 3). However, since there may in general be several matching configurations, all of which are "correct", the specific arrangement should be a choice of the implementer and the resulting substitution from such an arrangement a source of nondeterminism.

Example 1:
```rholang
    #match( for( a <= @0 & b <= @1 ){ ... } ; for( y <= x & z <= x ) { ... } ) => false
```
Since the candidate channels are distinct and the to-be-matched channels are the same, this match should not be satisfied.

In general this principle should be followed, however Coop Rholang returns an error when we use the same variable name in more than one listen in a receive, i.e. like `x` in `for( y <= x & z <= x ) { ... }`

Example 2:
```rholang
    #match( for( a <= @0 & @Nil <= @1 ){ a!(*b) } ; for( y <= w & @Nil <= x ) { y!(*z) } ) => true
```
Here there is no relation between the to-be-matched receive's channels, so we do not need to check any channel relations in the candidate receive. This should evaluate to `true` since the binds and continuations match in the given order (see below).

Example 3:
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

As far as continuations are concerned, we should require a stricter version of `#match` which check equality of indices for indexed variables, but otherwise behaves like `#match`.
