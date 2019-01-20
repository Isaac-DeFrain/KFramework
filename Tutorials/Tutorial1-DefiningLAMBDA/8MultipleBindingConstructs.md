# [Tutorial 1 - Lesson 8](https://www.youtube.com/watch?v=Ox4uXDpcY64)
## Multiple Binding Constructs

### To learn:
* How multiple binding constructs can coexist
* What the `mu` binder does

In this lesson, we learn how multiple language constructs that bind variables can coexist. We will also learn about or recall another famous binder besides `lambda`, namely `mu`, which can be used to elegantly define all kinds of interesting fixed-point constructs.


### Coexistence of Multiple Binding Constructs
The `mu` binder has the same syntax as lambda, except that it replaces `lambda` with `mu`.

Since `mu` is a binder, in order for substitution to know how to deal with *variable capture* in the presence of `mu`, we have to tell it that `mu` is a binding construct, as we did with `lambda`.  We take advantage of being there and also add `mu` its desired LaTeX attribute `[latex(\mu{#1}.{#2})]`.

The intuition for
```
	mu X . E
```

is that it reduces to `E`, but with each free occurrence of `X` in `E` behaving like a pointer that points back to `mu X . E`.

With that in mind, let us postpone the definition of `mu` and instead redefine `letrec F X = E in E'` as a derived construct, assuming `mu` available.  The idea is to simply regard `F` as a fixed-point of the function
```
	lambda X . E
```

that is, to first calculate
```
	mu F . lambda X . E
```

and then to evaluate `E'` where `F` is bound to this fixed-point:
```
	let F = mu F . lambda X . E in E'
```

The rule is as follows:
```
	rule letrec F:Id X:Id = E in E' => let F = mu F . lambda X . E in E'   [macro]
```

This new definition of `letrec` may still look a bit tricky, particularly because `F` is bound twice, but it is much simpler and cleaner than our previous definition.  Moreover, now it is done in a type-safe manner (this aspect goes beyond our objective in this tutorial).


### `mu` Semantics
Let us now define the semantic rule of `mu`.

The semantics of `mu` is actually disarmingly simple.  We just have to substitute `mu X . E` for each free occurrence of `X` in `E`:
```
	rule mu X . E => E[(mu X . E) / X]
```

Kompile `lambda.k` and execute some recursive programs.  They should now be several times faster.  Write a few more recursive programs, e.g. calculating the Ackermann function, calculating the number of moves needed to solve the Hanoi tower problem, etc.

We have defined our first programming language in K, which allows us to write interesting functional programs.  In the next, lesson we will learn how to fully document our language definition, in order to disseminate it, ship it to colleagues or friends, publish it, teach it, and so on.

