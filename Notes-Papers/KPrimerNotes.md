# K Primer

## K Definition

### Modules
*Modules* group language features (syntax, evaluation strategies, configuration, and execution rules). A module is defined by the syntax:

```
	module <Name>
	  ...
	endmodule
```
where `<Name>` is a name identifying the module (customary to use only caps and hyphens).

* A K definition is required to have at least one main module; good practice: isolate syntax from semantics.

A module must be imported within another module before referring to (parts of) them. E.g. `EXP` imports the module `EXP-SYNTAX`:

```
	module EXP-SYNTAX
	  ...
	endmodule

	module EXP
	  imports EXP-SYNTAX
	  ...
	endmodule
```

### Compiling Definitions
* K definitions are usually stored in files with extension "`.k`". Suppose a file `exp.k` containing modules `EXP-SYNTAX` and `EXP`. To compile this definition (and check validity), execute the following command:

```
	$ kompile exp
```

Upon successful completion, `kompile` prints nothing. For `kompile` options, type `kompile --help`.

### Comments
The K tool allows:

* C-like comments, introduced by ``//`` for single-line comments and ``/*...*/`` for multi-line comments.
* LaTeX-comments, introduced by ``//@`` and ``/*@``, can be used to push ready-to-publish definitions.


## Language Syntax
* Syntax in K is often called "the syntax of the semantics" to highlight the fact that its role is to serve as a convenient notation when writing the semantics.

External parsers can be used by typing the `-parser` option of `krun`.

### User-Defined Syntax
* Syntax is defined using a variant of BNF notation, with *terminals* enclosed in quotes and *non-terminals* starting with capital letters. E.g. the syntax declaration:

```
	syntax Exp ::= Int
		    | Exp "+" Exp		[seqstrict] //addition
		    | Exp "*" Exp		[seqstrict] //multiplication
		    | Exp "/" Exp		[seqstrict] //division
		    | "read"			[seqstrict] //read Int from console
		    | "print" "(" Exp ")"	[seqstrict] //write evaluation result to console
		    | "(" Exp ")"		[bracket]   //bracket has no semantic meaning and does not generate an additional node in the AST
```
defines a syntactic category `Exp`, containing the built-in integers and three basic arithmetic operations on expressions, as well as I/O operations.

* `seqstrict` and `strict` are attributes carrying semantic information, being used to define the *evaluation strategy* of the corresponding construct.

Declaring addition `seqstrict` means that the arguments of "`+`" will be evaluated from left to right before evaluating the addition itself.

* Other attributes are used to help the parser with operation precedence and grouping, or to instruct the PDF generator how to display the various constructs.

### Built-Ins
* Predefined semantic categories: computations, lists, sets, bags, maps

* Built-in syntactic categories/datatypes: Booleans (`Bool`), unbounded integers (`Int`), floats (`Float`), strings (`String`), identifiers (`Id`) (all come with semantic operations)

* `include/builtin` directory in the distribution

Built-in semantic operations are postfixed with the name of the corresponding syntactic category. E.g.
```
	5 +Int 7  //integer addition
	5 <=Int 7 //integer less-than-equal-to (produces true : Bool)
```

### Parsing Programs
* Test syntax definitions by parsing programs written using the syntax.

Consider the `EXP` program `2avg.exp`:
```
	print((read + read)/2)
```
printing the average of two numbers read from the console.

After using `kompile` to compile the definition, the `kast` command can be used to test that the program parses and to see its K *abstract syntax tree*. (By default, `kast` requires being run from the directory containing the K definition file and the compiled definition. Use the `--help` option to see more details about `kast`.) Moreover, all tokens not declared in the user syntax are assumed to be identifiers.

* The K AST is a tree with K labels as nodes, either associated to syntactic productions (e.g. ``_+_``) or injections of the predefined datatypes' constants as tokens.


## Language Semantics
* Three parts of specifying semantics within the K tool:
  1. Evaluation strategies (to (re)arrange computations)
  2. Structure of configuration (to hold program states)
  3. K rules (describing the configuration transitions)

### Evaluation Strategies: Strictness
* Evaluation strategies serve as a link between syntax and semantics, by specifying how the arguments of a language construct should be evaluated. E.g.
```
	syntax Exp ::= Exp "+" Exp		[seqstrict] //each arg evaluated before "+"

	syntax Exp ::= Exp "?" Exp ":" Exp	[strict(1)] //conditional (only need to evaluate the first arg)

	syntax Exp ::= Exp ";" Exp		[seqstrict] //sequential composition
```

* Two evaluation strategies:
(Each optionally takes a space-separated list of numbers as arguments, denoting the positions on which the construct is strict.)
  * `seqstrict`: ensures that the arguments are evaluated in order from left to right. E.g. the `[seqstrict]` annotation for the ``+`` construct says we want to evaluate all arguments of the ``+`` operator from *left to right* before giving its semantics.
  * `strict`: would also specify that both subexpressions must be evaluated, but does not constrain the evaluation strategy, i.e. the order of argument evaluation.

* The K tool distinguishes a category of terms, `KResult`, which is used to determine which terms are values, or *results*, i.e. no evaluation is required for these terms.

E.g. the following `syntax` declaration specifies the integers as values/results in the `EXP` language
```
	syntax KResult ::= Int
```

* `KResult` declarations are typically put in the main module, as it semantically defines terms as values.

### Computations
*Computation structures*, or simply *computations*, extend the abstract syntax of a language with a list structure using the separator `~>` (read "followed by" or "and then").

* K provides a distinguished sort, `K`, for computations. The `KResult` sort is a subsort of `K`.

* The intuition of computation structures of the form `t1 ~> t2 ~> ... ~> tn` is that the listed tasks are to be processed in order, `t1` followed by `t2` followed by ... followed by `tn`.

* The rules generated from strictness annotations are the main users of the sequencing constructor; they "heat" the computation by sequencing the evaluation of the arguments before the evaluation of the construct itself, and then "cool" it back once a value is obtained.

E.g. the heating rule for the conditional construct would look something like:
```
	E1:Exp ? E2:Exp : E3:Exp => E1 ~> [] ? E2 : E3
```

with the side condition where `E1` is *not* a result. The cooling rule would be the opposite:
```
	E1:Exp ~> [] ? E2:Exp : E3:Exp => E1 ? E2 : E3
```

with the side condition where `E1` is a result.

### Configurations, Initial Configuration
In K, the state of a running program/system is represented by a *configuration*. Configurations are structured as nested, labeled cells containing various computation based data structures. (Written using XML-like notation, with the label of the cell as the tag name and the contents between opening and closing tags.)

E.g. the configuration of `EXP` is:
```
	configuration
	  <k> $PGM:K </k>
	  <streams>
	    <in stream="stdin"> .List </in>
	    <out stream="stdout"> .List </out>
	  </streams>
```

the above describes both the initial configuration and the general structure of a configuration for `EXP` and should be included in the `EXP` module (usually in the first few lines).

* The configuration declaration is introduced by the `configuration` keyword, and consists of a cell labeled `k`, meant to hold the running program, and a `streams` cell holding the `in` and `out` cells, which hold an executing program's input/output streams (abstracted as lists).

* The `in` and `out` cells contain the XML attribute `stream` which enhances the interpreter generated from the definition with interactive I/O.

* Variables in the initial configuration, e.g. ``$PGM:K``, are place-holders, meant to be initialized at the beginning of program execution.

* Allowed cell contents: computations and lists/bags/sets/maps of computations with their sorts being `List`, `Bag`, `Set`, and `Map`, respectively. Elements of these structures are obtained by injecting computations (of sort K) into these sorts through the constructors `ListItem`, `BagItem`, `SetItem`, and `|->`, respectively.

* Since the K sort encompasses all built-in datatypes and user-defined syntax, this allows for items like `ListItem(I:Int)`, `SetItem(42)`, and `x |-> 42` to be written.

* The unit of these sorts is denoted by `.`, which for disambiguation purposes can be suffixed by the sort name, e.g. `.List` inside the `in` cell in the configuration.

* The configuration declaration serves as the backbone for the process of *configuration abstraction* which allows users to only mention relevant cells in each semantic rule, while the rest of the configuration is inferred automatically.

### Rules
K rules describe how a running configuration evolves by advancing the computation and potentially altering the state/environment.

* Semantic rules are introduced using the keyword `rule`

* Rules describe how terms/subterms in the configuration change, similar to a rewrite rule: any term matching the left-hand side of a rule can be replaced by the right-hand side.

* For basic operations which do not require matching multiple parts of the configuration, a K rule might look like a rewrite rule, with just one rewrite symbol at the top of the rule.

E.g. the semantics of addition and multiplication in `EXP` are completed by:
```
	rule I1:Int + I2:Int => I1 +Int I2
	rule I1:Int * I2:Int => I1 *Int I2
```

As strictness is assumed to take care of the evaluation strategy, K rules are written under the assumption that the strict positions have already been evaluated.

* K rules can have *side conditions* which are introduced by the `requires` keyword, and are expected to be Boolean predicates. The following rule:
```
	rule I1:Int / I2:Int => I1 /Int I2 requires I2 =/=Int 0
```

specifies that division should only be attempted when the denominator is non-zero.

* Variables are initial-cap letters or words followed by numbers or primes, e.g. `Foo2` or `X'`. Variables can be sorted by `X:Sort`, i.e. `X` is a variable of sort `Sort`. Variables must be typed at least once per rule.

* Anonymous variables are represented by `_`, which allow omitting the name of a variable when it is not used elsewhere in a rule.

E.g. the rules for evaluating the conditional expression:
```
	rule 0 ? _ : E:Exp => E
	rule I:Int ? E:Exp : _ => E requires I =/=Int 0
```

* In K, rewriting is extended by *local rewriting*. By pushing the rewrite actions inside their contexts, K rules can omit parts of a term that would otherwise be duplicated on both sides of the rule. This is done by allowing multiple occurrences of the rewrite symbol `=>`, linking the parts of the matching contexts which are changed by the rule and their their corresponding replacements.

E.g. the two rules for performing I/O:
```
	rule <k> print(I:Int) => I ...</k>		rule <k> read => I:Int ...</k>
	     <out> ... .List => ListItem(I) </out>	     <in> ListItem(I) => .List ...</in>
```

  * The `print` rule performs two changes in the configuration: (1) the `print` expression is replaced by its integer argument; (2) a list item containing that integer replaces the empty list in the output cell (i.e. it is added to that list).
  * The `read` rule similarly replaces one element in the input cell by the empty list (i.e. deletes it from that list) and uses its value as a replacement for `read` in the computation cell.

* Parts of the configuration can be omitted and inferred by the K tool (*configuration abstraction*)

* K also allows omission of non-essential cell contents at either end (writing `...` instead)

Full semantics for the `print` and `read` rules:
  * **print**: if `print I` (where `I` is an integer) is found at the beginning of the computation cell, then it is replaced by `I` and `I` is added at the end of the output list
  * **read**: if `read` is found at the beginning of the computation cell, then the first element in the input list is removed and its value is used as a replacement for `read`

Note that the rules corresponding to strictness annotations are used both to ensure that a `print` or `read` expression would eventually reach the top of the computation if it is in an evaluation position, and also that once they are evaluated, their values are plugged back into their corresponding context.

The above techniques make K rules simple and modular.


### Executing Programs with `krun`
Once the K definition of a language is written in the K tool and it is compiled successfully, the `krun` command can be used to execute/interpret programs written in the defined language.

* The `krun` tool starts executing the program in the initial configuration with the variable `$PGM` replaced by the K AST of the input program. The rules are then allowed to apply to the configuration, and the final configuration is obtained when no more rules apply.

* The `read` and `print` instructions affect the `in` and `out` cells. Since these cells are annotated with the `stream` attribute, the `krun` tool requests input from the standard input stream whenever a rule needs an item from the `in` cell to match, and would flush whatever is entered in the `out` to the standard output stream.

```
	$ cat p1.exp		$cat 2avg.exp			$ cat p2.exp
	(3 * (4 + 6)) / 2	print((read + read) / 2)	print(100 / read)

	$ krun p1.exp		$ krun 2avg.exp			$ echo "0" | krun p2.exp

	<k>			5				<k>
	  15			7				  100 / 0 ~> print []
	</k>			6				</k>
	<streams>		<k>				<streams>
	  <in>			  6				  <in>
	    .			</k>				    .
	  </in>			<streams>			  </in>
	  <out>			  <in>				  <out>
	    .			    .				    .
	  </out>		  </in>				  </out>
	</streams>		  <out>				</streams>
				    .
				  </out>
				</streams>
```

The execution of `p2.exp` shows two things: that it is possible to pipe input to the program, and how a stuck final configuration looks. Since the rule for division is guarded by the condition that the divisor is not zero, no rule can advance the computation after `read` was replaced by 0. This explains why `100 / 0` remains at the top of the computation.


## More Advanced K Definitional Features






























