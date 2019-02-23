// Red-Black Rho Calculus

module RBRHO-SYNTAX

  syntax   ProcR ::= "NilR"
                   | ProcB
                   | "for" "(" NameR "<-" NameR ")" "{" ProcR "}"
                   | NameR "!" "(" ProcR ")"
                   | ProcR "|" ProcR
                   | "*" NameR

  syntax   NameR ::= "@" ProcR

  syntax   ProcB ::= "NilB"
                   | ProcR
                   | "for" "(" NameB "<-" NameB ")" "{" ProcB "}"
                   | NameB "!" "(" ProcB ")"
                   | ProcB "|" ProcB
                   | "*" NameB

  syntax   NameB ::= "@" ProcB

endmodule

module RBRHO
  import RBRHO-SYNTAX

endmodule

/*
$ kompile rbrho.k --backend java --debug
org.kframework.CircularityException: ProcB < ProcR < ProcB
	at org.kframework.POSet.constructAndThrowCycleException(POSet.scala:49)
	at org.kframework.POSet.$anonfun$constructAndThrowCycleException$2(POSet.scala:51)
	at org.kframework.POSet.$anonfun$constructAndThrowCycleException$2$adapted(POSet.scala:51)
	at scala.collection.immutable.HashSet$HashSet1.foreach(HashSet.scala:320)
	at org.kframework.POSet.constructAndThrowCycleException(POSet.scala:51)
	at org.kframework.POSet.$anonfun$transitiveClosure$1(POSet.scala:32)
	at scala.collection.TraversableLike.$anonfun$map$1(TraversableLike.scala:234)
	at scala.collection.immutable.Map$Map2.foreach(Map.scala:146)
	at scala.collection.TraversableLike.map(TraversableLike.scala:234)
	at scala.collection.TraversableLike.map$(TraversableLike.scala:227)
	at scala.collection.AbstractTraversable.map(Traversable.scala:104)
	at org.kframework.POSet.transitiveClosure(POSet.scala:28)
	at org.kframework.POSet.<init>(POSet.scala:57)
	at org.kframework.POSet$.apply(POSet.scala:148)
	at org.kframework.definition.Sorting.computeSubsortPOSet(outer.scala:64)
	at org.kframework.definition.Sorting.computeSubsortPOSet$(outer.scala:59)
	at org.kframework.definition.Module.computeSubsortPOSet(outer.scala:89)
	at org.kframework.definition.Module.subsorts$lzycompute(outer.scala:247)
	at org.kframework.definition.Module.subsorts(outer.scala:247)
	at org.kframework.compile.checks.CheckSortTopUniqueness.check(CheckSortTopUniqueness.java:54)
	at org.kframework.compile.checks.CheckSortTopUniqueness.check(CheckSortTopUniqueness.java:49)
	at org.kframework.compile.checks.CheckSortTopUniqueness.check(CheckSortTopUniqueness.java:38)
	at java.base/java.util.Iterator.forEachRemaining(Iterator.java:133)
	at scala.collection.convert.Wrappers$IteratorWrapper.forEachRemaining(Wrappers.scala:26)
	at java.base/java.util.Spliterators$IteratorSpliterator.forEachRemaining(Spliterators.java:1801)
	at java.base/java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:658)
	at org.kframework.kompile.Kompile.lambda$checkDefinition$12(Kompile.java:220)
	at java.base/java.util.Iterator.forEachRemaining(Iterator.java:133)
	at scala.collection.convert.Wrappers$IteratorWrapper.forEachRemaining(Wrappers.scala:26)
	at java.base/java.util.Spliterators$IteratorSpliterator.forEachRemaining(Spliterators.java:1801)
	at java.base/java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:658)
	at org.kframework.kompile.Kompile.checkDefinition(Kompile.java:220)
	at org.kframework.kompile.Kompile.run(Kompile.java:111)
	at org.kframework.kompile.KompileFrontEnd.run(KompileFrontEnd.java:70)
	at org.kframework.main.FrontEnd.main(FrontEnd.java:52)
	at org.kframework.main.Main.runApplication(Main.java:118)
	at org.kframework.main.Main.runApplication(Main.java:107)
	at org.kframework.main.Main.main(Main.java:53)
org.kframework.CircularityException: ProcB < ProcR < ProcB
	at org.kframework.POSet.constructAndThrowCycleException(POSet.scala:49)
	at org.kframework.POSet.$anonfun$constructAndThrowCycleException$2(POSet.scala:51)
	at org.kframework.POSet.$anonfun$constructAndThrowCycleException$2$adapted(POSet.scala:51)
	at scala.collection.immutable.HashSet$HashSet1.foreach(HashSet.scala:320)
	at org.kframework.POSet.constructAndThrowCycleException(POSet.scala:51)
	at org.kframework.POSet.$anonfun$transitiveClosure$1(POSet.scala:32)
	at scala.collection.TraversableLike.$anonfun$map$1(TraversableLike.scala:234)
	at scala.collection.immutable.Map$Map2.foreach(Map.scala:146)
	at scala.collection.TraversableLike.map(TraversableLike.scala:234)
	at scala.collection.TraversableLike.map$(TraversableLike.scala:227)
	at scala.collection.AbstractTraversable.map(Traversable.scala:104)
	at org.kframework.POSet.transitiveClosure(POSet.scala:28)
	at org.kframework.POSet.<init>(POSet.scala:57)
	at org.kframework.POSet$.apply(POSet.scala:148)
	at org.kframework.definition.Sorting.computeSubsortPOSet(outer.scala:64)
	at org.kframework.definition.Sorting.computeSubsortPOSet$(outer.scala:59)
	at org.kframework.definition.Module.computeSubsortPOSet(outer.scala:89)
	at org.kframework.definition.Module.subsorts$lzycompute(outer.scala:247)
	at org.kframework.definition.Module.subsorts(outer.scala:247)
	at org.kframework.compile.checks.CheckSortTopUniqueness.check(CheckSortTopUniqueness.java:54)
	at org.kframework.compile.checks.CheckSortTopUniqueness.check(CheckSortTopUniqueness.java:49)
	at org.kframework.compile.checks.CheckSortTopUniqueness.check(CheckSortTopUniqueness.java:38)
	at java.base/java.util.Iterator.forEachRemaining(Iterator.java:133)
	at scala.collection.convert.Wrappers$IteratorWrapper.forEachRemaining(Wrappers.scala:26)
	at java.base/java.util.Spliterators$IteratorSpliterator.forEachRemaining(Spliterators.java:1801)
	at java.base/java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:658)
	at org.kframework.kompile.Kompile.lambda$checkDefinition$12(Kompile.java:220)
	at java.base/java.util.Iterator.forEachRemaining(Iterator.java:133)
	at scala.collection.convert.Wrappers$IteratorWrapper.forEachRemaining(Wrappers.scala:26)
	at java.base/java.util.Spliterators$IteratorSpliterator.forEachRemaining(Spliterators.java:1801)
	at java.base/java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:658)
	at org.kframework.kompile.Kompile.checkDefinition(Kompile.java:220)
	at org.kframework.kompile.Kompile.run(Kompile.java:111)
	at org.kframework.kompile.KompileFrontEnd.run(KompileFrontEnd.java:70)
	at org.kframework.main.FrontEnd.main(FrontEnd.java:52)
	at org.kframework.main.Main.runApplication(Main.java:118)
	at org.kframework.main.Main.runApplication(Main.java:107)
	at org.kframework.main.Main.main(Main.java:53)
[Error] Internal: Uncaught exception thrown of type CircularityException.
Please rerun your program with the --debug flag to generate a stack trace, and
file a bug report at https://github.com/kframework/k/issues (ProcB < ProcR <
ProcB)
*/