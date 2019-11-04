# Sends, Receives, Comm Events & Tuplespace

## Sends & Tuplespace
Each send adds a `SendMultiSetElem` to the `<sends/>` cell.
```
  <k> A:Send => . ...</k>
  <sends> S:Set => addNameSpace(sendSet(A);S) </sends>
  SendMultiSetElem ::= Name ";" TypeSendElem    // channel ; TypeSendElem
      TypeSendElem ::= NamePats ";" EnumSendSet // msg spatial type ; EnumSendSet
       EnumSendSet ::= Int ";" Names ";" Int    // quantity ; msg(s) ; send type
```
  where
  `sendSet(A) => SetItem(chan(A);SetItem(quotes(spatialType(msg(A)));SetItem(1;quotes(msg(A));stype(A))))`

For eaxmple,
```
   <k> @0!!(1,"a",[3,4],Set( )) => . ...</k>
   <sends>
     S => addNameSpace(SetItem(@0;SetItem(@Int,@String,@[Int,Int];SetItem(1;1,"a",[3,4],Set( );1)));S)
   </sends>
```

## Receives & Tuplespace
Each receive adds a `RecMultiSetElem` to the `<receives/>` cell.
```
   <k> A:Receive => . ...</k>
   <receives> S:Set => addRec(recSet(A);S) </receives>
    RecMultiSetElem ::= Int ";" BindMultiSet ";" Proc ";" BExp ";" Int // quantity ; BindMultiSet ; continuation ; guard ; rec type
   BindMultiSetElem ::= Int ";" Name ";" NamePats                      // quantity ; channel ; listening patterns
```
  where `recSet(A) => SetItem(1;enumBindSet(A);cont(A);guard(A);rtype(A))`

// Add example

## Comm Events & Tuplespace
Each element in the receive/sums multiset will be checked against the entire send multiset.
```
  (.Bag => <task> <k> updateTupleSpace(S;SetItem(Ni;Ci;Di;Ei;Ji)) </task>)
  <sends> S:Set => .Set </sends>
  <receives> SetItem(Ni;Ci;Di;Ei;Ji) R:Set => minusRec(SetItem(1;Ci;Di;Ei;Ji);R) </sends>
  requires comm(S;SetItem(1;Ci;Di;Ei;Ji))
```
  where `updateTupleSpace(A;B) => [remainingSendSet(A;B);sub(subList(A;B);Di)]`
  and `comm(A;B)` checks that all binds are matched (and guard is satisfied).
  Also, `updateTupleSpace` adjusts the send multiset and executes the substituted continuation.
```
  <k> [ A:Set ; B:Proc ] => B ...</k>
  <sends> .Set => A </sends>
```

  Need to compute:
  remainingSendSet: sendMultiSet x enumBindSet --> Set
  subList: sendMultiSet x enumBindSet --> list of substitutions to make in continuation
  minusRec: recMultiSetElem x recMultiSet --> recMultiSet
