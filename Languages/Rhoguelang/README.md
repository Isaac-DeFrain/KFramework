# Rhoguelang: Rho-calculus to Rholang in K

Rho-calc with added:
* Processes
  * Ground terms / basic data structures
    - [x] `Nil`
    - [x] Bool
    - [x] Int
    - [x] String
    - [x] Unforgeable integer for `new`: `"unforgeable(" Int ")"`
    - [x] `Uri ::= "uri(" String ")"`
  - [x] Bundle
  - [ ] List: `RhoList ::= "[" Procs "]"`
  * Map
    - [ ] `Mapping ::= Proc ":" Proc`
    - [ ] `Map ::= "{" List{Mapping, ","} "}"`
  * Method
  - [ ] `Procs ::= Proc | Proc "," Procs`
  - [x] Set: `Set ::= "Set" "(" List{Proc, ","} ")"`
  - [ ] Tuple: `RhoTuple ::= "(" Proc ",)" | "(" Proc "," Procs ")"`
* Operations
  * Conditional
    - [ ] `If (x) {P}` (if `x` is `true`, then the first element of the `k` cell rewrites to `P`; otherwise it dissolves)
    - [ ] `If (x) {P} else {Q}` (if `x` is `true`, then the first element of the `k` cell rewrites to `P`; otherwise it rewrites to `Q`)
  * Bool
    - [ ] not: `notbool`
    - [ ] and: `andbool`
    - [ ] or:  `orbool`
  - [ ] Bundle: read and/or write
  * Arithmetic
    - [ ] Int: `+Int`, `-Int`, `*Int`, `/Int`
    - [ ] Float: `+Float`, `-Float`, `*Float`, `/Float`
  * List
    - [ ] nth element in list: `List.nth(Int): list*int -> proc`
  * Map
    - [ ]
  * Method
    - [ ]
  - [ ] Mod arithmetic
  * Set
    - [ ] union: `"Set1".union("Set2"): set*set -> set`
    - [ ] delete: `"Set".delete("Element"): set -> set`
    - [ ] contains: `"Set".contains("Element"): set*proc -> bool`
    - [ ] size: `size("Set"): set -> int`
  * String
    - [ ] concatenation: `++`
    - [ ] interpolation: `%%`
    - [ ] slice: `"string".slice(m,n)`
    - [ ] hexToBytes: `"hexString".hexToBytes`
  * Tuple
    - [ ] `tuple.nth(m)`
  - [ ] Uri?
* Operators: syntax -> semantics
  - [x] Par
  - [x] Quote
  - [x] Receive
  - [x] Send
  - [x] Persistent receive/send
  - [x] Contract (syntactic sugar: persistent receive)
  - [ ] Bundle
  - [ ] Join (many binds)
  - [ ] Peek ("comm without consumption")
  - [ ] `new` (unforgeable names)
  - [ ] Logical connectives
* Reductions
  - [x] Comms (linear and persistent)
  - [ ] Strict functions
  - [ ] Pattern matching
- [x] Process variables
- [ ] Type system
  - [ ] tagged function types

Difference between Rholang and Rho calculus:
* In Rho calculus: `for (@Nil <- x){ P }` is executed for any name which is substituted for any name sent on `x`, which is then substituted for `@Nil` in the continuation `P`.
* In Rholang: `for (@Nil <- x){ P }` only executes when `@Nil` is sent on `x`.

Here's a diagram of the configuration:
![Rhoguelang configuration](RhoguelangConfiguration.png)
