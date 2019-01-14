# K Framework Cheat Sheet

Just do yourself a favor and put the K binary files in your PATH, by
1. Adding `export PATH=$PATH:pathto/nightly/k/bin`

## Compile K Definition
In a terminal, either go to the directory containing the language definition or add a `pathTo/` (whatever the path to the definition or program happens to be) in front every appearance of `lang.k` or `pgm.lang`.

### Backend options
* OCAML is default
* Java
```
	kompile lang.k --backend java
```
* LLVM
```
	kompile lang.k --backend llvm
```
* KORE
```
	kompile lang.k --backend kore
```
* Haskell
```
	kompile lang.k --backend haskell
```

#### Change default backend (??)

## Attributes
### K labels
Constructs can be given a *K label*. Using the attribute `[klabel(labelName)]` is syntactic sugar for replacing the node names in the KAST.

### Re: Nondeterminism
#### Concurrency
* Search the transition system generated by a program for all possible behaviors of a rule tagged `[rTag]`
1. First kompile the definition using the `--transition` option, i.e.
```
	kompile lang.k --transition "rTag"
```

2. Then krun the program using one of the `--search`, `--search-all`, or `--search-final` option, i.e.
```
	krun pgm.lang --search	       krun pgm.lang --search-all	  krun pgm.lang --search-final
```

#### Strictness: Evaluation Strategies


### Superheating/Supercooling: Tags
Constructors and rules can be given a *tag*. For the strictly-evaluated constructor with , the tags allow the K tool to search for nondeterminism caused by evaluation order using the option `--superheat "cTag"`. For the rule with tag `[rTag]`, you can search for nondeterministic behavior caused by this rule using the option `--supercool "rTag"`.

In both cases, the tag syntax is the same:
```
				syntax Sort ::= ...  [cTag, strict]

				rule ... => ...              [rTag]
```

E.g.
```
				syntax Exp ::= Exp "+" Exp       [plus, strict]

				rule <k> print I:Int => I ...</k>
	     			 <out>... . => ListItem(I) </out>  [output]
```

----------------------------------------------------------------------
Output from `--help`
----------------------------------------------------------------------

#### krun [options] <file>
* Options:
--argv
Additional argument to pass to interpreter binary
Default: <empty string>
--bound
The number of desired solutions for search.
--color
Use colors in output. Default is on.
--config-parser, -p
Command used to parse configuration variables. Default is "kast --parser ground -e". See description of --parser. For example, -pPGM="kast" specifies that the configuration variable $PGM should be parsed with the command "kast".
Syntax: --config-parserkey=value
Default: {}
--config-var, -c
Specify values for variables in the configuration.
Syntax: --config-varkey=value
Default: {}
--debug
Print debugging output messages
Default: false
--depth
The maximum number of computational steps to execute or search the
definition for.
--directory, -d
Path to the directory in which the kompiled K definition resides. The
default is the unique, only directory with the suffix '-kompiled' in the current directory. A definition may also be specified with the 'KRUN_COMPILED_DEF' environment variable, in which case it is used if the option is not specified on the command line.
--dry-run
Compile program into KORE format but do not run. Only used in Haskell
backend.
Default: false
--graph
Displays the search graph generated by the last search.
Default: false
--haskell-backend-command
Command to run the Haskell backend execution engine.
Default: kore-exec
--haskell-backend-home
Directory where the Haskell backend source installation resides.
--help, -h
Print this help message
Default: false
--help-experimental, -X
Print help on non-standard options.
Default: false
--interpret
Use even more minimal interpreter pipeline for faster performance.
Default: false
--io
Use real IO when running the definition. Defaults to true.
--mini-krun
Use minimalist krun pipeline for faster performance.
Default: false
--native-compiler
Command to use to perform native linking.
--ocaml-compile
Compile program to run into OCAML binary.
Default: false
--output, -o
How to display krun results. <mode> is either
[pretty|program|kast|binary|json|none].
Default: PRETTY
--output-file
Store output in the file instead of displaying it.
--output-flatten
(Assoc) KLabels to flatten into one list.
Default: []
--output-omit
KLabels to omit from the output.
Default: []
--output-tokast
KLabels to output as KAST tokens.
Default: []
--output-tokenize
KLabels to tokenize underneath (reducing output size).
Default: []
--parser
Command used to parse programs. Default is "kast"
--pattern
Specify a term and/or side condition that the result of execution or
search must match in order to succeed. Return the resulting matches as a list of substitutions. In conjunction with it you can specify other 2
options that are optional: bound (the number of desired solutions) and
depth (the maximum depth of the search).
--search
In conjunction with it you can specify 3 options that are optional:
pattern (the pattern used for search), bound (the number of desired
solutions) and depth (the maximum depth of the search).
Default: false
--search-all
Same as --search but return all matching states, even if --depth is not provided.
Default: false
--search-final
Same as --search but only return final states, even if --depth is
provided.
Default: false
--search-one-or-more-steps
Same as --search-all but exclude initial state, even if it matches.
Default: false
--search-one-step
Same as --search but search only one transition step.
Default: false
--term
Input argument will be parsed with the specified parser and used as the sole input to krun.
Default: false
--verbose, -v
Print verbose output messages
Default: false
--version
Print version information
Default: false
--warnings, -w
Warning level. Values: [all|normal|none]
Default: NORMAL
--warnings-to-errors, -w2e
Convert warnings to errors.
Default: false

#### kompile [options] <file>
* Options:
--backend
Choose a backend. <backend> is one of [ocaml|java|llvm|kore|haskell].
Each creates the kompiled K definition.
Default: ocaml
--check-races
Checks for races among regular rules.
Default: false
--coverage
Generate coverage data when executing semantics.
Default: false
--debug
Print debugging output messages
Default: false
--directory, -d
Path to the directory in which the output resides. An output can be
either a kompiled K definition or a document which depends on the type of backend. The default is the directory containing the main definition
file.
--gen-ml-only
Do not compile definition; only generate .ml files.
Default: false
--help, -h
Print this help message
Default: false
--help-experimental, -X
Print help on non-standard options.
Default: false
--hook-namespaces
<string> is a whitespace-separated list of namespaces to include in the hooks defined in the definition
Default: []
--main-module
Specify main module in which a program starts to execute. This
information is used by 'krun'. The default is the name of the given K
definition file without the extension (.k).
--no-expand-macros
Do not expand macros on initial configurations at runtime. Will likely
cause incorrect behavior if any macros are used in this term.
Default: false
--no-link-prelude
Do not link interpreter binaries against constants.cmx and prelude.cmx. Do not use this if you don't know what you're doing.
Default: false
--no-prelude
Do not implicitly require prelude.k.
Default: false
--non-strict
Do not add runtime sort checks for every variable's inferred sort.
Default: false
--ocaml-dump-exit-code
Exit code which should trigger a dump of the configuration when using
--ocaml-compile.
--ocaml-serialize-config
<string> is a whitespace-separated list of configuration variables to
precompute the value of
Default: []
--opaque-klabels
Declare all the klabels declared by the following secondary definition.
--packages
<string> is a whitespace-separated list of ocamlfind packages to be
included in the compilation of the definition
Default: []
--reverse-rules
Reverse the order of rules as much as possible in order to find most
nondeterminism without searching.
Default: false
--syntax-module
Specify main module for syntax. This information is used by 'krun'.
(Default: <main-module>-SYNTAX).
--transition
<string> is a whitespace-separated list of tags designating rules to
become transitions.
Default: [transition]
--verbose, -v
Print verbose output messages
Default: false
--version
Print version information
Default: false
--warnings, -w
Warning level. Values: [all|normal|none]
Default: NORMAL
--warnings-to-errors, -w2e
Convert warnings to errors.
Default: false
-I
Add a directory to the search path for requires statements.
Default: []
-O2
Optimize in ways that improve performance, but intere with debugging and increase compilation time and code size slightly.
Default: false
-O3
Optimize aggressively in ways that significantly improve performance, but also increase compilation time and code size.
Default: false
-Og
Optimize as much as possible without interfering with debugging
experience.
Default: false
-ccopt
Add a command line option to the compiler invocation for the llvm
backend.
Default: []

#### kast [options] <file>
* Options:
--debug
Print debugging output messages
Default: false
--directory, -d
Path to the directory in which the kompiled K definition resides. The
default is the unique, only directory with the suffix '-kompiled' in the
current directory. A definition may also be specified with the
'KRUN_COMPILED_DEF' environment variable, in which case it is used if the
option is not specified on the command line.
--expand-macros
Also expand macros in the parsed string.
Default: false
--expression, -e
An expression to parse passed on the command line. It is an error to
provide both this option and a file to parse.
--help, -h
Print this help message
Default: false
--help-experimental, -X
Print help on non-standard options.
Default: false
--kore
Output KORE-syntax instead of KAST-syntax.
Default: false
--module, -m
Parse text in the specified module. Defaults to the syntax module of the definition.
--sort, -s
The start sort for the default parser. The default is the sort of $PGM
from the configuration. A sort may also be specified with the 'KRUN_SORT' environment variable, in which case it is used if the option is not specified on the command line.
--verbose, -v
Print verbose output messages
Default: false
--version
Print version information
Default: false
--warnings, -w
Warning level. Values: [all|normal|none]
Default: NORMAL
--warnings-to-errors, -w2e
Convert warnings to errors.
Default: false