# Substitution for Grho

To distinguish between name and process variables (written in Grho as `x` and `\x`, resp.) in the substitution function, I found that it was best to write my own. This substitution function is much more general than the builtin substitution in K, is optimized for use with Grho, and mirrors the substitutions given by RNode. 