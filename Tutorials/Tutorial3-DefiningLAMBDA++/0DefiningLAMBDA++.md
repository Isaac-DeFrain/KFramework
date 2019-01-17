# Tutorial 3: Defining LAMBDA++

In this tutorial, we will learn how to define language constructs which abruptly change the execution control flow, and how to define language semantics following an environment/store style.  Specifically, we will learn the following:

* How to define constructs like `callcc`, which allow you to take snapshots of program executions and to go *back in time* at any moment
* How to define languages in an environment/store style
* Some basic notions about the use of closures and closure-like semantic structures to save and restore execution environments
* Some basic intuitions about reusing existing semantics in new languages, as well as some of the pitfalls in doing so.
