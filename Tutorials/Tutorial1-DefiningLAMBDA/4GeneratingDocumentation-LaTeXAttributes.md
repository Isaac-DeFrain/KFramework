# [Tutorial 1 - Lesson 4](https://www.youtube.com/watch?v=ULXA4e_6-DY)
## Generating Documentation; Latex Attributes

### To learn:
* How to generate documentation
* How to define LaTeX attributes

In this lesson, we learn how to generate formatted documentation from K language definitions.  We also learn how to use LaTeX attributes to control the formatting of language constructs, particularly of ones which have a mathematical flavor which we want to display accordingly.


### Generating Documentation
To generate PDF documentation, all we have to do is to call the `kdoc` command in the folder where the kompiled definition lives.  This command generates a `lambda.pdf` file, which contains the formatted K definition.

Open this file using your favorite PDF reader.  The syntactic details are not shown in the generated PDF, because we typically want to focus on semantics at this stage.  The main notational difference between the original `.k` and the generated PDF is how rules are displayed.  In the PDF, the rule `left => right` is replaced by its representation in K (see papers on K), which is harder to write in ASCII.  Specifically, `left` is underlined and `right` is written under the line.  The metaphor here is that the underlined terms change, as indicated under the lines.  In K, rules can have a more general form than shown in `lambda.k`, where several subterms in a term can rewrite concurrently and
atomically.  The K rules will be explained in their full generality in the IMP and IMP++ tutorials.


### LaTeX Attributes
To enhance readability, we may want to replace the keyword `lambda` by the mathematical lambda symbol in the generated documentation.  We can control the way we display language constructs in the generated documentation by associating them LaTeX attributes.

This is actually quite easy.  All we have to do is to associate a `latex` attribute to the production defining the construct in question, following the LaTeX syntax for defining new commands (or macros).

In our case, we associate the attribute `latex(\lambda{#1}.{#2})` to the production declaring the lambda abstraction (recall that in LaTeX, `#n` refers to the n-th argument of the defined new command).

Let us now kompile the new `lambda.k` using the option `--pdf`, and note how the `latex` attribute is being used in the produced output.

Note that it is also possible to generate HTML documentation.  See `kdoc --help` for the exact command line options.

We will later see, in Lesson 9, that we can add arbitrarily complex LaTeX comments and headers to our language definitions, which give us maximum flexibility in formatting our language definitions.

Now we have a simple programming language, with a nice documentation.  However, it is not easy to write interesting programs in this language.  Almost all programming languages build upon existing datatypes and libraries.  The K tool provides a few of these (and you can add more).

In the next lesson, we show how we can add builtin integers and Booleans to LAMBDA, so we can start to evaluate meaningful expressions.


### Additional Notes
The `--pdf` and `--html` options have changed, so the video is currently obsolete.  See `kompile --help` for the new syntax.

