# Rhoguelang: Rho-calculus to Rholang in K

Rho-calc with added:
* Ground terms / basic data structures
  - [x] Bool
  - [x] Int
  - [x] String
- [x] `Nil`
- [x] Bundle: `Bundle { Proc }`
- [x] List: `[ Procs ]`
- [x] Map: `{ Proc : Proc, ... }`
- [x] Set: `{ Procs }`
- [x] Tuple: `( Proc ,) | ( Proc , Procs )`
- [x] Uri: `"uri(" String ")"`
* Operations - syntax
  - Conditional
    - [ ] `If (x) {P}` (if `x` is `true`, then the first element of the `k` cell rewrites to `P`; otherwise it dissolves)
    - [ ] `If (x) {P} else {Q}` (if `x` is `true`, then the first element of the `k` cell rewrites to `P`; otherwise it rewrites to `Q`)
  - [ ] Bool: `notbool`, `andbool`, `orbool`
  - [ ] Bundle: read and/or write
  - [ ] Int arithmetic: `+Int`, `-Int`, `*Int`, `/Int`
  * List
    - [ ] concatenation: `++`
    - [ ] slice from *m* to *n*: `"list".slice(m,n)`
  * Map
    - [ ]
  - [ ] Mod arithmetic: `%%`
  * Set
    - [ ] union: `"set1".union("set2")`
    - [ ] contains predicate: `"set".contains("element")`
    - [ ] delete: `"set".delete("element")`
  - [ ] String
  - [ ] Tuple
  - [ ] Uri?
* Operations - semantics
  - [x] Par
  - [x] Quote
  - [x] Receive
  - [x] Send
  - [x] Persistent receive/send
  - [x] Contract (syntactic sugar: persistent receive)
  - [ ] Bundle
  - [ ] Join
  - [ ] Peek ("comm without consumption")
  - [ ] `new` (unforgeable names)
  - [ ] Logical connectives for patterns
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
