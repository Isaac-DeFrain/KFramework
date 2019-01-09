# Overview of K Semantic Framework Notes

## Abstract
K is an executable semantic framework in which programming languages, calculi, as well as type systems or formal analysis tools can be defined, making use of *configurations*, *computations*, and *rules*. Configurations organize the system/program state into units called *cells*, which are labeled and can be nested. Cpomputations carry "computational meaning" as special nested list structures sequentializing computational tasks, such as fragments of programs; in particular, computations extend the original language or calculus syntax. K (rewrite) rules generalize conventional rewrite rules by making explicit which parts of the term they read, write, or do not care about. This distinction makes K a suitable framework for defining truly concurrent languages or calculi, even in the presence of sharing. Since computations can be handled like any other terms in a rewriting environment, i.e. they can be matched, moved from one place to another in the original term, modified, or even deleted. K is particularly suitable for defining control-intensive language features such as abrupt termination, exceptions, or call/cc.

We give an overview of the K framework: what it is, how it can be used, and where it has been used already. We also discuss the K definition of CHALLENGE, a programming language that aims to challenge and expose the limitations of existing semantic frameworks.


## Introduction
"Gentle" introduction to K, a rewriting-based semantic definitional framework. K was introduced by Gigore Rosu in the lecture notes of a programming langauge course at the University of Illinois Urbana-Champaign in Fall 2003, as a means to define executable concurrent languages in rewriting logic using [Maude](http://maude.cs.illinois.edu/w/index.php/The_Maude_System). 












