# Substitution for Grho

`sub.k` defines the substitution function `#sub` which is polymorphic for processes. This function is only ever applied after the `#match` predicate so we assume the inputs match.

To distinguish between name and process variables (written in `GRHO` as `x` and `\x`, resp.) in the substitution function, I found that it was best to write my own. This substitution function is much more general than the builtin substitution in K, is optimized for use with Grho, and mirrors the substitutions given by RNode.

See `/tests` for examples.
