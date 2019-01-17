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
We will extend the EXP language.


### Extending EXP with Functional Features
To make EXP more expressive, we add `lambda` and `mu` abstractions to it.
```
	1  require "../exp.k"
	2  require "modules/substitution.k"
	3
	4  module EXP-LAMBDA-SYNTAX
	5    imports EXP-SYNTAX
	6
	7    syntax     Val ::= Int
	8		      | "lambda" Id "." Exp  [binder]     //lambda abstraction
	9    syntax     Exp ::= Val
	10		      | Exp Exp  	  [seqstrict]     //application
	11		      | "mu" Id "." Exp	     [binder]     //mu abstraction
	12 endmodule
	13
	14 module EXP-LAMBDA
	15   imports EXP + EXP-LAMBDA-SYNTAX
	16   imports SUBSTITUTION
	17
	18   syntax KResult ::= Val
	19
	20   rule (lambda X:Id . E:Exp) V:Val => E[V / X]         //beta-reduction
	21
	22   rule             mu X:Id . E:Exp => E[mu X . E / X]  //mu-unrolling
	23 endmodule
```

#### Splitting Definitions Among Files
Larger K definitions are usually spread out among multiple files, each potentially containing multiple modules. As a file-equivalent of the `imports` command on modules, a file can be included into another file using the `require` directive. `require` will first look up the path in the current directory; if not found, it will then look it up in the `include` directory from the K distribution. The tree of `require` dependencies is followed recursively.


#### Binders and Substitution
Both `lambda` and `mu` are binders, binding their first argument in the second argument. We use the builtin substitution operator to give semantics to these constructs. To guarantee that the substitutions work correctly (i.e. avoid variable capture), these constructs are marked with the [binder] annotation (lines 8 and 11). Currently, the `binder` annotation can only be applied to a two-argument production, of which the first must be an identifier.

The SUBSTITUTION module is completely defined in the K tool, leveraging the binder predicate, and using the AST-view of the user-defined syntax to define a generic, capture-avoiding substitution operator. It exports a construct '`syntax K ::= K[K / K]`', which substitutes the second argument for the third in the first.

To guarantee a *call-by-value* evaluation strategy, the application operator is declared `seqstrict` (line 10). Moreover, since all rules that don't explicitly mention a cell are assumed to be at the top of the computation cell, the evaluation strategy is also *outermost* (line 20). A special category `Val` is introduced to allow matching on both integers and lambda abstractions (lines 7-8) and computation results are extended to include all the values (line 18). Constraining rules not mentioning a cell to only happen at the top of the computation cell also helps avoid non-termination for the `mu`-unrolling rule (line 22), by only unrolling `mu` in an evaluation position.

K does not commit to substitution-based definitions only. Environment-based definitions are quite natural, too. The environment is typically just another cell in the configuration which holds a map.


#### Desugaring Syntax
We show how one might desugar syntax in the K tool by adding two popular functional constructs to our language: `let` and `letrec`.
```
	syntax Exp ::= "let" Id "=" Exp "in" Exp
		     | "letrec" Id Id "=" Exp "in" Exp
```

Instead of directly giving them semantics, we use `macro` capabilities to desugar them into `lambda` and `mu` abstractions:
```
	rule         (let X:Id = E1:Exp in E2:Exp) => (lambda X . E2) E1                    [macro]
	rule (letrec F:Id X:Id = E1:Exp in E2:Exp) => (let F = mu F . lambda X . E1 in E2)  [macro]
```

The `let` operator desugars into an application of a `lambda`-abstraction, while `letrec` desugars into the `let` construct binding a `mu`-abstraction. Since they won't be part of the AST when giving the semantics, their corresponding productions don't need to annotated as binders.

These macros are to be applied on programs at parse time; therefore both the syntax declaration and the macros themselves belong in the EXP-LAMBDA-SYNTAX module.


### Imperative Features
We add some imperative features to the EXP language.


#### Statements
To begin, we add a new syntactic category `Stmt` (for statements) and change the semicolon to be a statement terminator instead of an expression separator.
```
	syntax Stmt ::= Exp ";"    [strict]
		      | Stmt Stmt
```

As we do not want statements to evaluate to values, we will not use strictness constraints to give statements their semantics. Instead, we give semantics for the expression statement and sequential composition with the following two rules:
```
	rule V:Val ; => .		      //expression statement
	rule St1:Stmt St2:Stmt => St1 ~> St2  //sequential composition
```

The first rule discards the value for the expression statement; the second sequences statements as computations.

Again, we add syntax productions to EXP-SYNTAX and K rules to EXP.


#### Syntactic Lists
K provides built-in support for generic syntactic lists: `List{Nonterminal,terminal}` stands for `terminal`-separated lists of zero or more `Nonterminal` elements. To instantiate and use the K built-in lists, we must alias each instance with a (typically fresh) non-terminal in our syntax. As an exmple, we add variable declarations to our EXP language. The first production below defines the `Ids` alias for the comma-separated lists of identifiers, while the second uses it to introduce variable declarations:
```
	syntax Ids ::= List{Id, ","}
	syntax Stmt ::= "var" Ids ";"
```

Thus, both '`var x, y, z ;`' and '`var ;`' are bot valid declarations.

For semantic purposes, these lists are currently interpreted as cons-lists (i.e. lists constructed with a head element followed by a tail list). Therefore, when giving semantics to constructs with list parameters, we often distinguish between two cases: when the list is empty and when the list has at least one element. TO give semantics to `var`, we add two new cells to the configuration: `env`, to hold mappings from variables to locations, and `store`, to hold mappings from locations to values. The semantics of variable declarations are captures in the following rules:
```
	rule var .Ids ; => .  [structural]

	rule <k> var (X:Id, X1:Ids => X1) ; ...</k>
	     <env> Rho:Map => Rho[!N:Int / X] </env>
	     <store>... . => !N |-> 0 ...</store>
```

The first rule simply dissolves the `var` declaration if it's followed by an empty variable list (indicated by `.Ids`). The second rule recursively declares the first variable in the list by adding a mapping from a *fresh* location `!N` to `0` in the `store` cell, and updating the mapping of the name of the variable in the `env` cell to point to that location. We prefer to make the second rule structural, thinking of dissolving the residual empty `var` declaration as a structural cleanup rather than as a computational step.


## Concurrency and Nondeterminism
We can define nondeterministic features both related to concurrency and to the under-specification (e.g. order of evaluation). Also, we discuss methods to control the state explosion due to nondeterminism.

### Configuration Abstraction
We would like to extend EXP with concurrency features. The addition of the `env` cell in the presence of concurrency requires further adjustments to the configuration. First, there needs to be an `env` cell for each computation cell, to avoid one computation shadowing the variables of another one. Moreover, each environment should be tied to its computation, to avoid using another thread's environment. This can be acheived by adding another cell, `thread`, on top of the `k` and `env` cells, using the `multiplicity` XML attribute to indicate that the `thread` cell can occur multiple times. The `multiplicity` attribute can be used to specify how many copies of a cell are allowed: either 0 or 1 (`"?"`) (??), 0 or more (`"*"`), or one or more (`"+"`) (doesn't seem to work for me). Upon this transformation, the configuration changes as follows:
```
	configuration
	<thread multiplicity="*">
	  <k> $PGM:K </k>
	  <env> .Map </env>
	</thread>
	<store> .Map </store>
	<streams>
	  <in stream="stdin">   .List </in>
	  <out stream="stdout"> .List </out>
	</streams>
```

A possible syntax and semantics for thread spawning is:
```
	syntax Stmt ::= "spawn" "{" Stmt "}"

	rule <k> spawn { St:Stmt } => . ...</k> <env> Rho:Map </env>
	     (.Bag => <thread>... <k> St </k> <env> Rho </env> ...</thread>)
```

Changes to the configuration are quite frequent in practice, typically needed in order to accomodate new langauge features. K's configuration abstraction process allows users to not have to modify their rules when making structural changes to the language configuration. This feature is crucial for modularity, beacause it offers the possibility to write definitions in a way that may not require revisits to existing rules when the configuration is changed. Indeed, only the `spawn` rule needs to modified, despite the addition of a new `thread` cell. Instead, this cell is automatically inferred (added to the K tool at compile time) from the definition of the configuration above. For our rule for `var` given above, it means that the `k` and `env` cells will be considered as being part of the same `thread` cell. The K tool can infer this context in instances when there is only one correct way to complete the configuration used in rules in order to match the declared configuration. For further explanation, see [K Overview and SIMPLE Case Study](http://fsl.cs.illinois.edu/index.php/K_Overview_and_SIMPLE_Case_Study) and [An Overview of the K Semantic Framework](http://fsl.cs.illinois.edu/index.php/An_Overview_of_the_K_Semantic_Framework).

Multiplicity information is important in the configuration abstraction process, as it tells the K tool how to complete rules like that for a `rendezvous` construct:
```
	syntax Exp ::= "rendezvous" Exp  [strict]

	rule <k> rendezvous I:Int => I ...</k> <k> rendezvous I:Int => I ...</k>
```

As the `k` cell does not have the `multiplicity` set to `"*"` and `thread` does, the tool can infer that each of the two computations resides in its own thread.

Continuing to add imperative features to our language, we can take the above information and add rules for reading and setting a variable in memory:
```
	//reading a variable from memory		//setting a variable in memory

	syntax Exp ::= Id				syntax Exp ::= Id "=" Exp  [strict(2)]

	rule <k> X:Id => I ...</k>			rule <k> X:Id = I:Int => I ...</k>
	     <env>... X |-> L:Int ...</env>		     <env>... X |-> L:Int ...</env>
	     <store>... L |-> I:Int ...</store>		     <store>... L |-> (_ => I) ...</store>
```

Note how these rules avoid mentioning any `thread` cells.

One limitation of the current implementation is that is does not allow multiple cells with the same name to appear in the initial configuration (??).

### Advanced Strictness and Evaluation Strategies



### Controlling Nondeterminism
There are two main sources of nondeterminism in programming languages: concurrency and order of evaluation. We discuss how the K tool can be used to explore both kinds of nondeterministic behavior.

#### Transitions
At the theoretical level, K rules are partitioned into *structural* and *computational* rules. Intuitively, structural rules rearrange the configuration so that computational rules can apply. Structural rules therefore do not count as computational steps. A canonical example of structural rules are the rules generated for strictness constraints. A K semantics can be thought of as a generator of *transition systems* or *Kripke structures*, one for each program. Only the computational rules create *steps*, or *transitions*, in the corresponding transition systems or Kripke structures.

Although desirable from a theoretical point of view, allowing all computaional rules to generate transitions may yield a tremendous number of interleavings in practice. Most of these interleavings can be behaviorally equivalent. E.g. the fact that a thread computes `2+5 => 7` is likely irrelevant for other threads, so one may not want to consider it as an observable transition in the space of interleavings. Since th K tool cannot know (without help) which transitions need to be explored and which do not, the user must say so explicitly, allowing one to declare rules bearing certain attributes as "transitions". The rules bearing attributes tagged as transitions are the only ones considered as transitions when exploring a program's transition system.

E.g. we would like to explore the nondeterminism generated by the semantics of `print` for the EXP program `p5.exp` containing the program
```
	spawn (print 1);
	spawn (print 2);
	print 3
```

To do that, we can annotate the `print` rule with the tag `print)` (to be able to refer to it), and recompile with `kompile exp.k --transition "print"`. (This feature requires the OCAML backend.)

Now to search the transition system generated by `p5.exp` for `print` nondeterminism and display the observed behaviors, we use the `--search` option of the `krun` tool on `p5.exp`, i.e. we run the command `krun --search p5.exp`. The following table is generated:
```
	Solution 1:	Solution 2:	Solution 3:	Solution 4:	Solution 5:	Solution 6:
	<T>		<T>		<T>		<T>		<T>		<T>
	  <k>		  <k>		  <k>		  <k>		  <k>		  <k>
	    1		    1 		    1		    1		    1		    1
	  </k>		  </k>		  </k>		  </k>		  </k>		  </k>
	  <k>		  <k>		  <k>		  <k>		  <k>		  <k>
	  2		    2		    2		    2		    2		    2
	  </k>		  </k>		  </k>		  </k>		  </k>		  </k>
	  <k>		  <k>		  <k>		  <k>		  <k>		  <k>
	    3		    3		    3		    3		    3		    3
	  </k>		  </k>		  </k>		  </k>		  </k>		  </k>
 	  <streams>	  <streams>	  <streams>	  <streams>	  <streams>	  <streams>
	    <in>	    <in>	    <in>	    <in>	    <in>	    <in>
	      .		      .		      .		      .		      .		      .
	    </in>	    </in>	    </in>	    </in>	    </in>	    </in>
	    <out>	    <out>	    <out>	    <out>	    <out>	    <out> 
	      "132"	      "123"	      "312"	      "321"	      "231"	      "213"
	    </out>	    </out>	    </out>	    </out>	    </out>	    </out>
	  </streams>	  </streams>	  </streams>	  </streams>	  </streams>	  </streams>
	</T>		</T>		</T>		</T>		</T>		</T>
```

#### Nondeterministic Strictness
Although good in theory, the unrestricted use of heating/cooling rules may create an immense, often infeasibly large space of possibilities to analyze. Therefore, for performance reasons, *the K tool chooses an arbitrary, but fixed, default order to evaluate the arguments of a strict language construct*. Specifically, similarly to refocusing semantics, see [Refocusing In Reduction Semantics](http://citeseerx.ist.psu.edu/viewdoc/download;jsessionid=CEB6BCED93C9B347F696B30E6DB76D19?doi=10.1.1.59.7008&rep=rep1&type=pdf), once a path to a redex is chosen, no other path is chosen until all redexes on that path are evaluated. This has the side effect of potentially losing behaviors due to missed interleavings.

To restore these missing interleavings, the K tool offers a `superheat`/`supercool`ing process. These allow the user to customize the level of strictness-based nondeterminism available. These processes bear no theoretical significance, in that they do not affect the semantics of the language in any way. However, they have practical relevance, specific to our implementation of the K tool. More precisely, **productions** whose attributes are specified as `superheat` during compilation are used to tell the K tool that we want to exhaustively explore all the nondeterministic evaluation choices for the strictness of the corresponding language construct. Similarly, whenever a **rule** is tagged and the language definition is kompiled with the `--supercool` option, the K tool will reset the current context, restarting the search for a redex. During this step, the rules defining the descent towards the next redex get a chance to pick another evaluation order.

This way, we can think of `superheat`ing/`supercool`ing as marking fragments of computation in which exhaustive analysis of the evaluation order is performed. Used carefully, this mechanism allows us to explore more nondeterministic behaviors of a program, with minimal loss of efficiency.

E.g. we will name the addition operator in EXP:
```
	syntax Exp ::= Exp "+" Exp  [plus, strict]
```

After recompiling the K definition with `kompile --superheat "plus"`, we can run the program `p3.exp`
```
	print(1) + print(2) + print(3)
```

using the `--search` option of `krun`, i.e. doing `krun pathTo/p3.exp --search`. The tool finds four solutions, differeing only in the contents of their `out` cell, containing the strings `"123"`, `"213"`, `"312"`, and `"321"`. The reason there are only four outputs instead of six is that in the absence of any `supercool` rule, `superheat` only offers nondeterministic choice. That is, once an argument of a construct is chosen to be evaluated, it is evaluated completely. In order to observe full nondeterminism, the rules whose behavior we consider observable, e.g. the output rule, 
```
	rule <k> print I:Int => I ...</k>
	     <out>... . => ListItem(I) </out>  [output]
```

must be specified as supercooling. Then after recompiling using `kompile --superheat "plus" --supercool "output"`, `krun --search` will exhibit all six expected behaviors of `p3.exp`, containing in the `out` cell the additional strings `"132"` and `"231"`.

It is worth noting that the use of these compilation options is sound with respect to the the semantics of the definition in the sense that they allow the K tool to partially explore the transition system defined by the semantics.


## Literate Programming
































