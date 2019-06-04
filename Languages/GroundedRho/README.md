# Grounded Rho Calculus

This is the implementation of the Rho Calculus with `Bool`, `Int`, `String`, and variables (well on its way to be full Rholang) in K framework. The state of a program (or more generally, a term) is modeled by the configuration and evolves according to the rewrite rules defined in `grho.k`. The syntax is defined in the `GRHO-SYNTAX` module in the same definition.

The configuration contains cells for:
* Concurrent computational tasks: `<activity/>`
* The multiset of sends: `<sends/>`
* The multiset of receives:`<receives/>`
* Fresh locations for name declarations: `<nextLoc/>`

You can find test programs in `/tests` to get an idea as to how program execution works.
