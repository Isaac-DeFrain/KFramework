# Rhoguelang: Rho-calculus to Rholang in K

Rho-calc with added:
- [ ] Ground terms / basic data structures
  - [x] `Nil`
  - [x] Bool
  - [x] Int
  - [x] String
  - [x] Bundle
  - [ ] List
  - [ ] Map
  - [ ] Set
  - [ ] Tuple
  - [ ] Uri
- [ ] Operations
  - [ ] Conditional
    - [ ] `If (x) {P}`
    - [ ] `If (x) {P} else {Q}`
  - [ ] Int arithmetic (modular)
  - [ ] Boolean
  - [ ] String
  - [ ] List
- [ ] Operators
  - [x] Par
  - [x] Quote
  - [x] Receive
  - [x] Send
  - [x] Persistent receive/send
  - [x] Contract (syntactic sugar: persistent receive)
  - [ ] Join (list substitution)
  - [ ] Peek
  - [ ] `new` (unforgeable names)
  - [ ] Logical connectives
- [ ] Reductions
  - [x] Comms (linear and persistent)
  - [ ] Strict functions
  - [ ] Pattern matching
- [x] Process variables
- [ ] Type system
  - [ ] tagged function types

Here's a diagram of the configuration:
![Rhoguelang configuration](RhoguelangConfiguration.png)
