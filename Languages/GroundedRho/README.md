# Grounded Rho Calculus

This is the implementation of the rho calculus with `Bool`, `Int`, `String`, and variables (striving to be full Rholang) in the K framework. The state of a program (or more generally, a term) is modeled by the configuration and evolves according to the rewrite rules defined in the `GRHO` module in the K definition. The syntax is defined in the `GRHO-SYNTAX` module in the same definition.

The configuration contains cells for:
* Concurrent activity threads and environments: `<threads/>`
* The multiset of sends and receives: `<tuplespace/>`
* Reductions of comm events involving several messages: `<reaction/>`
* Mapping locations to values: `<store/>`
* Fresh locations: `<nextLoc/>`

I am currently reading through the Scala source code and implementing the formal semantics for Rholang in K in the file `grho.k`. You can find test programs in the "tests" folder to get an idea as to how program execution works.
