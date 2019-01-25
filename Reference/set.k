// Dependencies?

module SET
  imports INT-SYNTAX
  imports BASIC-K

  syntax Set [hook(SET.Set)]

  /*@ \section{Description} The Set represents a mathematical set (a collection
   of unique items). */

  /*@ Construct a new Set as the union of two different sets ($A \cup B$) */
  syntax Set ::= Set Set                  [left, function, functional, hook(SET.concat), klabel(_Set_), symbol, assoc, comm, unit(.Set), idem, element(SetItem), format(%1%n%2)]
  /*@ Construct an empty Set */
  syntax Set ::= ".Set"                   [function, functional, hook(SET.unit), klabel(.Set), symbol, latex(\dotCt{Set})]
               //| "."
  /*@ Construct a singleton Set (a Set with only one element $\{ a \}$). To add
   an element $a$ to a set $A$, construct the union of the singleton set
   $\{ a \}$ and $A$ ($\{ a \} \cup A$). */
  syntax Set ::= SetItem(KItem)               [function, functional, hook(SET.element), klabel(SetItem), symbol]

  /*@ Get the intersection of two sets ($A \cap B$) */
  syntax Set ::= intersectSet(Set, Set)   [function, functional, hook(SET.intersection)]

  /*@ Get the difference of two sets ($A \setminus B$)*/
  syntax Set ::= Set "-Set" Set           [function, functional, hook(SET.difference), latex({#1}-_{\it Set}{#2}), klabel(Set:difference), symbol]

  /*@ Check element membership in a set ($a \in A$) */
  syntax Bool ::= KItem "in" Set              [function, functional, hook(SET.in), klabel(Set:in), symbol]

  /*@ Check set inclusion ($A \subseteq B$) */
  syntax Bool ::= Set "<=Set" Set         [function, functional, hook(SET.inclusion)]

  /*@ Get the cardinality of a set ($|A|$) */
  syntax Int ::= size(Set)                [function, functional, hook(SET.size)]

  /*@ Get an arbitrarily chosen element of the Set */
  syntax KItem ::= choice(Set)                [function, hook(SET.choice), klabel(Set:choice)]

  /* set difference axioms */
  // TODO(AndreiS): remove this if not used
  //rule S1:Set -Set (SetItem(K:K) S2:Set) => S1 -Set S2
  //requires notBool(K in S1)
  //rule S:Set -Set .Set => S
endmodule

