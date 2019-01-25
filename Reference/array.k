// Copyright (c) 2015-2018 K Team. All Rights Reserved.
require "kast.k"

module DOMAINS-SYNTAX
  imports ID
  imports UNSIGNED-INT-SYNTAX
  imports BOOL-SYNTAX
  imports STRING-SYNTAX
endmodule

module DOMAINS
  imports DOMAINS-SYNTAX
  imports INT
  imports BOOL
  imports STRING
  imports BASIC-K
  imports LIST
  imports K-IO
  imports MAP
  imports SET
  imports K-REFLECTION
endmodule

module ARRAY-SYNTAX
  imports LIST

  syntax Array [hook(ARRAY.Array), unit(arrayCtor), element(_[_<-_])]

  syntax KItem ::= Array "[" Int "]" [function, hook(ARRAY.lookup)]
  syntax Array ::= Array "[" Int "<-" KItem "]" [function, hook(ARRAY.update), klabel(_[_<-_]), symbol]
  syntax Array ::= Array "[" Int "<-" "undef" "]" [function, hook(ARRAY.remove)]
  syntax Array ::= updateArray(Array, Int, List) [function, hook(ARRAY.updateAll)]
  /*@ Sets a range of indices (given by an index into the array and the number
   of indices to set) to the same value. */
  syntax Array ::= fillArray(Array, Int, Int, KItem) [function, hook(ARRAY.fill)]

  syntax Bool ::= Int "in_keys" "(" Array ")" [function, functional, hook(ARRAY.in_keys)]
endmodule

module ARRAY-CONCRETE [concrete, kast]
  imports ARRAY-SYNTAX
  imports LIST
  imports STRING-SYNTAX

  syntax Array ::= makeEmptyArray(Int) [function, hook(ARRAY.makeEmpty), impure]
                 | arrayCtor(String, Int) [function, hook(ARRAY.ctor), symbol]
                 | makeArray(Int, KItem) [function, hook(ARRAY.make), impure, klabel(makeArrayOcaml)]
endmodule

module ARRAY-SYMBOLIC [symbolic]
  imports ARRAY-IN-K
endmodule

module ARRAY-KORE [kore]
  imports ARRAY-IN-K
endmodule

module ARRAY-IN-K
  imports ARRAY-SYNTAX
  imports LIST
  imports K-EQUAL
  imports INT

  syntax Array ::= makeArray(Int, KItem) [function, hook(ARRAY.make)]

  syntax Array ::= arr(List, Int, KItem)

  rule makeArray(I::Int, D::KItem) => arr(.List, I, D)

  rule arr(L::List, _, D::KItem) [ IDX::Int ] => #if IDX >=Int size(L) #then D #else L[IDX] #fi

  syntax List ::= ensureOffsetList(List, Int, KItem) [function]
  rule ensureOffsetList(L::List, IDX::Int, D::KItem) => #if IDX >=Int size(L) #then updateList(makeList(IDX +Int 1, D), 0, L) #else L #fi

  rule arr(L::List, I::Int, D::KItem) [ IDX::Int <- VAL::KItem ] => arr(ensureOffsetList(L, IDX, D) [ IDX <- VAL ], I, D)

  rule arr(L::List, I::Int, D::KItem) [ IDX::Int <- undef ] => arr(L, I, D) [ IDX <- D ]

  rule updateArray(arr(L::List, I::Int, D::KItem), IDX::Int, L2::List) => arr(updateList(ensureOffsetList(L, IDX +Int size(L2) -Int 1, D), IDX, L2), I, D)

  rule fillArray(arr(L::List, I::Int, D::KItem), IDX::Int, LEN::Int, VAL::KItem) => arr(fillList(ensureOffsetList(L, IDX +Int LEN -Int 1, D), IDX, LEN, VAL), I, D)

  rule IDX::Int in_keys(arr(_, I::Int, _)) => IDX >=Int 0 andBool IDX <Int I
endmodule

module ARRAY
  imports ARRAY-CONCRETE
  imports ARRAY-SYMBOLIC
  imports ARRAY-KORE
endmodule

