// Dependencies?

module MAP
  imports LIST
  imports SET

  syntax Map [hook(MAP.Map)]

  /*@\section{Description} The Map represents a generalized associative array.
   Each key can be paired with an arbitrary value, and can be used to reference
   its associated value. Multiple bindings for the same key are not allowed. */

  /*@ Construct a new Map consisting of key/value pairs of two Maps (the keys of
   the two Maps are assumed disjoint) */
  syntax Map ::= Map Map                        [left, function, hook(MAP.concat), klabel(_Map_), symbol, assoc, comm, unit(.Map), element(_|->_), index(0), format(%1%n%2)]
  /*@  Construct an empty Map */
  syntax Map ::= ".Map"                         [function, functional, hook(MAP.unit), klabel(.Map), symbol, latex(\dotCt{Map})]
               // breaks klabel uniqueness
               //| "."                            [function, hook(MAP.unit)]
  /*@ Construct a singleton Map (a Map with only one key/value pair). The key
   is on the left and the value is on the right */
  syntax Map ::= KItem "|->" KItem                      [function, functional, hook(MAP.element), klabel(_|->_), symbol, latex({#1}\mapsto{#2})]

  syntax priorities _|->_ > _Map_ .Map
  syntax non-assoc _|->_

  /*@ Retrieve the value associated with the given key */
  syntax KItem ::= Map "[" KItem "]"                    [function, hook(MAP.lookup), klabel(Map:lookup), symbol]

  syntax KItem ::= Map "[" KItem "]" "orDefault" KItem      [function, functional, hook(MAP.lookupOrDefault), klabel(Map:lookupOrDefault)]

  /*@ Update a Map in form of  of keys and values: */
  syntax Map ::= Map "[" KItem "<-" KItem "]"           [function, functional, hook(MAP.update), prefer]

  /*@ Remove key/value pair associated with the key from map? */
  syntax Map ::= Map "[" KItem "<-" "undef" "]"     [function, functional, hook(MAP.remove), klabel(_[_<-undef]), symbol]

  /*@ Get the difference of two maps interpreted as sets of entries
   ($M_1 \setminus M2$) */
  syntax Map ::= Map "-Map" Map                 [function, functional, hook(MAP.difference), latex({#1}-_{\it Map}{#2})]

  /*@ Update the first map by adding all key/value pairs in the second map. If a
   key in the first map exists also in the second map, its associated value will
   be overwritten by the value from the second map. */
  syntax Map ::= updateMap(Map, Map)            [function, functional, hook(MAP.updateAll)]

  /*@ Update the Map by removing all key/value pairs with the key in the Set. */
  syntax Map ::= removeAll(Map, Set)            [function, functional, hook(MAP.removeAll)]

  /*@ Get a Set consisting of all keys in the Map:*/
  syntax Set ::= keys(Map)                      [function, functional, hook(MAP.keys)]
  syntax List ::= "keys_list" "(" Map ")"       [function, hook(MAP.keys_list)]

  syntax Bool ::= KItem "in_keys" "(" Map ")"       [function, functional, hook(MAP.in_keys)]

  /*@ Get a List consisting of all values in the Map: */
  syntax List ::= values(Map)                   [function, hook(MAP.values)]

  /*@ Get the Map size (number of key/value pairs) */
  syntax Int ::= size(Map)                      [function, functional, hook(MAP.size), klabel(sizeMap)]

  /*@ Check map inclusion */
  syntax Bool ::= Map "<=Map" Map               [function, functional, hook(MAP.inclusion)]

  /*@ Get an arbitrarily chosen key of the Map  */
  syntax KItem ::= choice(Map)                      [function, hook(MAP.choice), klabel(Map:choice)]
endmodule

