# [Tutorial 3 - Lesson 3](https://www.youtube.com/watch?v=tW4KRdgBIGo)
## Reusing Existing Semantics

### To learn:
* How to reuse existing semantics

In this lesson we will learn that, in some cases, we can reuse existing semantics of language features without having to make any change!


### Reusing Semantics
Although the definitional style of the basic LAMBDA language changed quite radically in our previous lesson, compared to its original definition in Tutorial 1, we fortunately can reuse a large portion of the previous definition.  For example, let us just cut-and-paste the rest of the definition from Tutorial 1 - Lesson 7.  See `lambda.k`.

Let us `kompile` and `krun` all the remaining programs from Tutorial 1.  Everything should work fine, although the store contains lots of garbage.  *Garbage collection* is an interesting topic, but we do not do it here.  Nevertheless, much of this garbage is caused by the intricate use of the fixed-point combinator to define recursion.  In a future lesson in this tutorial, we will see that a different, environment-based definition of fixed-points will allocate much less memory.

One interesting question at this stage is: how do we know when we can reuse an existing semantics of a language feature?  Well, I'm afraid the answer is: we don't.  In the next lesson, we will learn how reuse can fail for quite subtle reasons, which are impossible to detect statically (and some non-experts may fail to even detect them at all).


### Additional Notes
* Cut-and-paste is a poor-man's approach to reuse.

A better way to reuse, which requires a bit of planning ahead, is to put each feature in its own module.  Then you can simply include the modules containing the features you want to reuse.  Our point in this lesson was that such reuse is possible, not to teach the best way to do it in practice.  However, good methodologies on how to use a technology are equally important.

* Do we need an `env`/`store` split?  Couldn't we just work with a `state`?

In our language so far, since we never change the value of a variable, it happens to be OK to only keep a state.  That is, to collapse `env`/`store` into `state`, then embed the state in closures and restore the state instead of the environment.  However, this simplistic approach breaks as soon as we add references to our language, because functions can then modify the environment in which they were declared, so we would have to carry over those changes when returning from function invocations, which would be quite difficult.

