# Rhoguelang: Rho-calculus to Rholang in K

Rho-calc with added:
* Ground terms / basic data structures
  - [x] Bool
  - [x] Int
  - [x] String
- [x] `Nil`
- [x] Bundle: `Bundle { Proc }` and `Bundle ::= `
- [x] List: `[ Procs ]`
- [x] Map: `{ Proc : Proc, ... }`
- [x] Set: `{ Procs }`
- [x] Tuple: `( Proc ,) | ( Proc , Procs )`
- [x] Uri: `uri( String )`
* Operations - syntax
  - Conditional
    - [x] `If (x) {P}` (if `x` is `true`, then the first element of the `k` cell rewrites to `P`; otherwise it dissolves)
    - [x] `If (x) {P} else {Q}` (if `x` is `true`, then the first element of the `k` cell rewrites to `P`; otherwise it rewrites to `Q`)
  - [x] Bool: `notbool`, `andbool`, `orbool`
  - [x] Int arithmetic: `+Int`, `-Int`, `*Int`, `/Int`
  - [x] Remainder: `%`
  * Methods
    * List
      - [x] append: `List.append(List): list*list -> list`
      - [x] *m* th element: `List.nth(m): list*int -> proc`
      - [x] length: `List.length(): list -> int`
      - [x] slice from *m* to *n*: `List.slice(m,n): list*int*int -> list`
    * Map
      - [x] union: `Map.union(Map): map*map -> map`
      - [x] delete: `Map.delete(Key): map*key -> map`
      - [x] contains predicate: `Map.contains(Key): map*key -> bool`
      - [x] get value: `Map.get(Key): map*key -> value`
      - [x] get or else: `Map.getOrElse(Key, Proc): map*key*proc -> map \/ proc`
      - [x] set value: `Map.set(Key, Value): map*key*value -> map`
      - [x] get keys: `Map.keys(): map -> set`
      - [x] size: `Map.size(): map -> int`
    * Set
      - [x] union: `Set.union(Set): set*set -> set`
      - [x] contains predicate: `Set.contains(Element): set*proc -> bool`
      - [x] delete: `Set.delete(Element): set*proc -> set`
      - [x] size: `Set.size(Set): set -> int`
   * String
      - [x] concatenation: `String ++ String: string*string -> string`
      - [x] interpolation: `"${Key}String" %% {Map}: string*map -> string`
      - [x] length: `String.length:`
      - [x] slice from *m* to *n*: `String.slice(m,n): string*int*int -> string`
      - [x] interpret hex string: `HexString.hexToBytes(): hexstring -> string`
    * Tuple
      - [x] *m* th element: `Tuple.nth(m): tuple*int -> proc`
    - [x] All data structures have `toByteArray()`
* Operations - semantics
  - [x] Par
  - [x] Quote
  - [x] Receive
  - [x] Send
  - [x] Persistent receive/send
  - [x] Contract (syntactic sugar: persistent receive)
  - [ ] Bundle: read and/or write (I/O?)
  - [x] Join
  - [x] Peek ("comm without consumption")
  - [x] `new` (unforgeable names)
  - [ ] Logical connectives for patterns
  - [x] Comms (linear and persistent)
  - [ ] Strict functions
  - [ ] Pattern matching
- [x] Process variables
- [x] Name variables
* Type system
  - [ ] Structural type system
  - [ ] Behavioral type system
  - [ ] Tagged function types

Difference between Rholang and Rho calculus:
* In Rho calculus: `for (@Nil <- x){ P }` is executed for any name which is substituted for any name sent on `x`, which is then substituted for `@Nil` in the continuation `P`.
* In Rholang: `for (@Nil <- x){ P }` only executes when `@Nil` is sent on `x`.

Here's a diagram of the configuration:
![Rhoguelang configuration](RhoguelangConfiguration.png)
