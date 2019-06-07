// Namespace Logic

require "../grho.k"

module FORM-SYNTAX
  import GRHO

  syntax  PForm ::= "{" PForm "}"                     [bracket]  // 
                  > "True"                                       // verity
                  | "Zero"                                       // nullity
                  | "not" PForm                                  // negation
                  | PForm "&" PForm                      [left]  // conjunction
                  | PForm "|" PForm                      [left]  // separation
                  | "*" NForm                                    // descent
                  | QForm "!" "(" PForm ")"                      // elevation
                  | "(" QForm "?" NForm ")" PForm                // activity
                  | "rec" Prop "." PForm                         // greatest fixed point
                  | "All" Name ":" PForm "." PForm               // quantification

  syntax  QForm ::= "@" PForm                                    // indication
                  | NForm                                        // ...

  syntax  NForm ::= "@" Proc                                     // nomination
                  | Name                                         // ...

  syntax   Prop ::= Id                           [klabel(prop)]  // propositional variables

// Needs a notion of valuation to instantiate each propositional variable with a true/false value

endmodule

module FORM
  import FORM-SYNTAX

  configuration
  <T color="teal">
    <k color="purple"> $PGM:PForm </k>
  </T>

endmodule

/*
Kompile error:
$ kompile form.k --backend java --debug
java.util.NoSuchElementException: No value present
	at java.base/java.util.Optional.get(Optional.java:148)
	at org.kframework.compile.AddParentCells.lambda$concretizeCell$10(AddParentCells.java:279)
	at java.base/java.util.stream.Collectors.lambda$groupingBy$53(Collectors.java:1127)
	at java.base/java.util.stream.ReduceOps$3ReducingSink.accept(ReduceOps.java:169)
	at java.base/java.util.ArrayList$ArrayListSpliterator.forEachRemaining(ArrayList.java:1492)
	at java.base/java.util.stream.AbstractPipeline.copyInto(AbstractPipeline.java:484)
	at java.base/java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:474)
	at java.base/java.util.stream.ReduceOps$ReduceOp.evaluateSequential(ReduceOps.java:913)
	at java.base/java.util.stream.AbstractPipeline.evaluate(AbstractPipeline.java:234)
	at java.base/java.util.stream.ReferencePipeline.collect(ReferencePipeline.java:578)
	at org.kframework.compile.AddParentCells.concretizeCell(AddParentCells.java:279)
	at org.kframework.compile.AddParentCells.concretize(AddParentCells.java:296)
	at org.kframework.compile.AddParentCells.concretize(AddParentCells.java:302)
	at org.kframework.compile.AddParentCells.concretize(AddParentCells.java:314)
	at org.kframework.compile.ConcretizeCells.concretize(ConcretizeCells.java:71)
	at org.kframework.definition.ModuleTransformer$.$anonfun$fromSentenceTransformer$1(transformers.scala:16)
	at org.kframework.definition.ModuleTransformer$.$anonfun$fromSentenceTransformer$3(transformers.scala:22)
	at scala.collection.TraversableLike.$anonfun$map$1(TraversableLike.scala:234)
	at scala.collection.mutable.HashSet.foreach(HashSet.scala:78)
	at scala.collection.TraversableLike.map(TraversableLike.scala:234)
	at scala.collection.TraversableLike.map$(TraversableLike.scala:227)
	at scala.collection.mutable.AbstractSet.scala$collection$SetLike$$super$map(Set.scala:46)
	at scala.collection.SetLike.map(SetLike.scala:101)
	at scala.collection.SetLike.map$(SetLike.scala:101)
	at scala.collection.mutable.AbstractSet.map(Set.scala:46)
	at org.kframework.definition.ModuleTransformer$.$anonfun$fromSentenceTransformer$2(transformers.scala:20)
	at org.kframework.definition.ModuleTransformer.$anonfun$apply$1(transformers.scala:73)
	at scala.collection.concurrent.TrieMap.getOrElseUpdate(TrieMap.scala:903)
	at org.kframework.definition.ModuleTransformer.apply(transformers.scala:70)
	at org.kframework.definition.ModuleTransformer.apply(transformers.scala:66)
	at org.kframework.definition.DefinitionTransformer.apply(transformers.scala:109)
	at org.kframework.compile.ConcretizeCells.transformDefinition(ConcretizeCells.java:44)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at org.kframework.kompile.Kompile.lambda$defaultSteps$9(Kompile.java:183)
	at org.kframework.backend.java.symbolic.JavaBackend.lambda$steps$2(JavaBackend.java:104)
	at org.kframework.kompile.Kompile.run(Kompile.java:113)
	at org.kframework.kompile.KompileFrontEnd.run(KompileFrontEnd.java:70)
	at org.kframework.main.FrontEnd.main(FrontEnd.java:52)
	at org.kframework.main.Main.runApplication(Main.java:118)
	at org.kframework.main.Main.runApplication(Main.java:107)
	at org.kframework.main.Main.main(Main.java:53)
java.util.NoSuchElementException: No value present
	at java.base/java.util.Optional.get(Optional.java:148)
	at org.kframework.compile.AddParentCells.lambda$concretizeCell$10(AddParentCells.java:279)
	at java.base/java.util.stream.Collectors.lambda$groupingBy$53(Collectors.java:1127)
	at java.base/java.util.stream.ReduceOps$3ReducingSink.accept(ReduceOps.java:169)
	at java.base/java.util.ArrayList$ArrayListSpliterator.forEachRemaining(ArrayList.java:1492)
	at java.base/java.util.stream.AbstractPipeline.copyInto(AbstractPipeline.java:484)
	at java.base/java.util.stream.AbstractPipeline.wrapAndCopyInto(AbstractPipeline.java:474)
	at java.base/java.util.stream.ReduceOps$ReduceOp.evaluateSequential(ReduceOps.java:913)
	at java.base/java.util.stream.AbstractPipeline.evaluate(AbstractPipeline.java:234)
	at java.base/java.util.stream.ReferencePipeline.collect(ReferencePipeline.java:578)
	at org.kframework.compile.AddParentCells.concretizeCell(AddParentCells.java:279)
	at org.kframework.compile.AddParentCells.concretize(AddParentCells.java:296)
	at org.kframework.compile.AddParentCells.concretize(AddParentCells.java:302)
	at org.kframework.compile.AddParentCells.concretize(AddParentCells.java:314)
	at org.kframework.compile.ConcretizeCells.concretize(ConcretizeCells.java:71)
	at org.kframework.definition.ModuleTransformer$.$anonfun$fromSentenceTransformer$1(transformers.scala:16)
	at org.kframework.definition.ModuleTransformer$.$anonfun$fromSentenceTransformer$3(transformers.scala:22)
	at scala.collection.TraversableLike.$anonfun$map$1(TraversableLike.scala:234)
	at scala.collection.mutable.HashSet.foreach(HashSet.scala:78)
	at scala.collection.TraversableLike.map(TraversableLike.scala:234)
	at scala.collection.TraversableLike.map$(TraversableLike.scala:227)
	at scala.collection.mutable.AbstractSet.scala$collection$SetLike$$super$map(Set.scala:46)
	at scala.collection.SetLike.map(SetLike.scala:101)
	at scala.collection.SetLike.map$(SetLike.scala:101)
	at scala.collection.mutable.AbstractSet.map(Set.scala:46)
	at org.kframework.definition.ModuleTransformer$.$anonfun$fromSentenceTransformer$2(transformers.scala:20)
	at org.kframework.definition.ModuleTransformer.$anonfun$apply$1(transformers.scala:73)
	at scala.collection.concurrent.TrieMap.getOrElseUpdate(TrieMap.scala:903)
	at org.kframework.definition.ModuleTransformer.apply(transformers.scala:70)
	at org.kframework.definition.ModuleTransformer.apply(transformers.scala:66)
	at org.kframework.definition.DefinitionTransformer.apply(transformers.scala:109)
	at org.kframework.compile.ConcretizeCells.transformDefinition(ConcretizeCells.java:44)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at scala.Function1.$anonfun$andThen$1(Function1.scala:52)
	at org.kframework.kompile.Kompile.lambda$defaultSteps$9(Kompile.java:183)
	at org.kframework.backend.java.symbolic.JavaBackend.lambda$steps$2(JavaBackend.java:104)
	at org.kframework.kompile.Kompile.run(Kompile.java:113)
	at org.kframework.kompile.KompileFrontEnd.run(KompileFrontEnd.java:70)
	at org.kframework.main.FrontEnd.main(FrontEnd.java:52)
	at org.kframework.main.Main.runApplication(Main.java:118)
	at org.kframework.main.Main.runApplication(Main.java:107)
	at org.kframework.main.Main.main(Main.java:53)
[Error] Internal: Uncaught exception thrown of type NoSuchElementException.
Please rerun your program with the --debug flag to generate a stack trace, and
file a bug report at https://github.com/kframework/k/issues (No value present)
*/