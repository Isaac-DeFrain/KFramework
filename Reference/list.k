// Dependencies?

module LIST
  imports INT-SYNTAX
  imports BASIC-K

  syntax List [hook(LIST.List)]

  /*@ \section{Description} \K lists are ordered collections that may contain
   duplicate elements. These behave more like lists in functional programming
   languages than arrays in imperative programming languages; there's no
   numerical indexing, but instead specific elements are refered to using the
   Mylist,Mylist construct in combination with the MyListItem construct. It's
   worth noting that \K lists aren't exactly like lists in functional languages;
   they're associative, which means that it's easy to access elements at both
   ends of the lists and concatenate them. For example, L:Mylist,E accesses
   element E at the end of a list. */

  //TODO(AndreiS): move the paragraph below
  /*@ \section{User-Defined Lists} It is very common in \K to define a shorthand
   for lists of user-defined sorts. \K 's builtin way of doing this is to use
   List\{KItem,"Separator"\}, where "Separator" is any valid character or
   sequence of characters used to separate distinct elements.
   For example, after defining \\
   syntax KItem ::= Elt\\
   a user could then define
   syntax Elts ::= List\{Elt,","\} \\
   which would be a comma-separated list whose elements are all of sort Elt. A
   user could just as well define \\
   syntax Elts ::= List\{Elt,"and"\} \\
   which would be a list containing elements of sort Elt that are separated with
   the word "and". If only one argument is given, the separator is asumed to be
   commas. So, \\
   syntax Elts = List\{Elt\} \\
   would define a comma-separated list containing elements of sort Elt.
  */

  /*@ Construct a new List as the concatenation of two Lists. This is similar to
   the append "@" operation in many functional programming languages. */
  syntax List ::= List List               [left, function, functional, hook(LIST.concat), klabel(_List_), symbol, smtlib(smt_seq_concat), assoc, unit(.List), element(ListItem), format(%1%n%2)]
  /*@ Construct an empty List: */
  syntax List ::= ".List"                 [function, functional, hook(LIST.unit), klabel(.List), symbol, smtlib(smt_seq_nil), latex(\dotCt{List})]
                //| "."
  /*@ Construct a singleton List (a list with only  one element) */
  syntax List ::= ListItem(KItem)             [function, functional, hook(LIST.element), klabel(ListItem), symbol, smtlib(smt_seq_elem)]

  /*@ Get an element form the List by index. Positive indices mean from the
   beginning (0 is the first element), and negative indices mean from the end
   (-1 is the last element). */
  syntax KItem ::= List "[" Int "]"           [function, hook(LIST.get), klabel(List:get), symbol]

  syntax List ::= List "[" Int "<-" KItem "]" [function, hook(LIST.update), klabel(List:set)]

  syntax List ::= makeList(Int, KItem) [function, hook(LIST.make)]

  syntax List ::= updateList(List, Int, List) [function, hook(LIST.updateAll)]

  syntax List ::= fillList(List, Int, Int, KItem) [function, hook(LIST.fill)]

  /*@ Remove elements from the beginning and the end of the List. */
  syntax List ::= range(List, Int, Int)   [function, hook(LIST.range), klabel(List:range), symbol]

  /*@ Check element membership in the given list */
  syntax Bool ::= KItem "in" List             [function, functional, hook(LIST.in), klabel(_inList_)]

  /*@ Get the list length */
  syntax Int ::= size(List)               [function, functional, hook(LIST.size), klabel (sizeList), smtlib(smt_seq_len)]
endmodule

