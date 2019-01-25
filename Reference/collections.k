// Dependencies?

module COLLECTIONS
  imports LIST
  imports SET
  imports MAP

  syntax List ::= Set2List(Set) [function, hook(SET.set2list)]
  syntax Set ::= List2Set(List) [function, functional, hook(SET.list2set)]

endmodule

