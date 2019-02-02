# K Framework Cheat Sheet

This is very much a work in progress!

Just do yourself a favor and put the K binary files in your PATH, by
1. Adding `export PATH=$PATH:pathto/nightly/k/bin`

## Compile K Definition
In a terminal, either go to the directory containing the language definition or add a `pathTo/` (whatever the path to the definition or program happens to be) in front every appearance of `lang.k` or `pgm.lang`.

### Backend options
* OCAML is default

* Java: `kompile lang.k --backend java`

* LLVM: `kompile lang.k --backend llvm`

* KORE: `kompile lang.k --backend kore`

* Haskell: `kompile lang.k --backend haskell`

## Included in K (VIS: "Very important syntax/semantics")

### Array
```
  syntax Array                                         [hook(ARRAY.Array), unit(arrayCtor), element(_[_<-_])]

  syntax KItem ::= Array "[" Int "]"                   [function, hook(ARRAY.lookup)]
                 | Array "[" Int "<-" KItem   "]"      [function, hook(ARRAY.update), klabel(_[_<-_]), symbol]
                 | Array "[" Int "<-" "undef" "]"      [function, hook(ARRAY.remove)]
                 | updateArray(Array, Int, List)       [function, hook(ARRAY.updateAll)]

  // Sets a range of indices (given by an index into the array
  // and the number of indices to set) to the same value
  syntax Array ::= fillArray(Array, Int, Int, KItem)   [function, hook(ARRAY.fill)]

  syntax  Bool ::= Int "in_keys" "(" Array ")"         [function, functional, hook(ARRAY.in_keys)]

  syntax Array ::= makeEmptyArray(Int)                 [function, hook(ARRAY.makeEmpty), impure]
                 | arrayCtor(String, Int)              [function, hook(ARRAY.ctor), symbol]
                 | makeArray(Int, KItem)               [function, hook(ARRAY.make), impure, klabel(makeArrayOcaml)]

  syntax Array ::= makeArray(Int, KItem)               [function, hook(ARRAY.make)]
                 | arr(List, Int, KItem)

    rule makeArray(I::Int, D::KItem) => arr(.List, I, D)

    rule arr(L::List, _, D::KItem) [ IDX::Int ]
         => #if IDX >=Int size(L) #then D #else L[IDX] #fi

  syntax List ::= ensureOffsetList(List, Int, KItem)   [function]

    rule ensureOffsetList(L::List, IDX::Int, D::KItem)
         => #if IDX >=Int size(L) #then updateList(makeList(IDX +Int 1, D), 0, L) #else L #fi

    rule arr(L::List, I::Int, D::KItem) [ IDX::Int <- VAL::KItem ]
         => arr(ensureOffsetList(L, IDX, D) [ IDX <- VAL ], I, D)

    rule arr(L::List, I::Int, D::KItem) [ IDX::Int <- undef ]
         => arr(L, I, D) [ IDX <- D ]

    rule updateArray(arr(L::List, I::Int, D::KItem), IDX::Int, L2::List)
         => arr(updateList(ensureOffsetList(L, IDX +Int size(L2) -Int 1, D), IDX, L2), I, D)

    rule fillArray(arr(L::List, I::Int, D::KItem), IDX::Int, LEN::Int, VAL::KItem)
         => arr(fillList(ensureOffsetList(L, IDX +Int LEN -Int 1, D), IDX, LEN, VAL), I, D)

    rule IDX::Int in_keys(arr(_, I::Int, _)) => IDX >=Int 0 andBool IDX <Int I
```

### Bool
```
  syntax   Bool ::=          "notBool" Bool   [function, functional, boolOperation]
                  > Bool     "andBool" Bool   [function, functional, boolOperation]
                  | Bool "andThenBool" Bool   [function, functional, left, boolOperation]
                  | Bool     "xorBool" Bool   [function, functional, left, boolOperation]
                  | Bool      "orBool" Bool   [function, functional, left, boolOperation]
                  | Bool  "orElseBool" Bool   [function, functional, left, boolOperation]
                  | Bool "impliesBool" Bool   [function, functional, left, boolOperation]
                  > left:
                    Bool      "==Bool" Bool   [function, functional, left]
                  | Bool     "=/=Bool" Bool   [function, functional, left]
```

### Collection
```
  syntax   List ::= Set2List(Set)             [function]
  syntax    Set ::= List2Set(List)            [function, functional]
```

### Integer
```
  syntax   Bool ::= Int      "<=Int" Int      [function, functional, left]
                  | Int       "<Int" Int      [function, functional, left]
                  | Int      ">=Int" Int      [function, functional, left]
                  | Int       ">Int" Int      [function, functional, left]
                  | Int      "==Int" Int      [function, functional, left]
                  | Int     "=/=Int" Int      [function, functional, left]
                  | Int "dividesInt" Int      [function]
                  | freshInt(Int)             [freshGenerator, function, functional]
                  | randInt(Int)              [function]

    rule I1:Int ==Int I2:Int => I1 ==K I2
    rule I1:Int =/=Int I2:Int => notBool (I1 ==Int I2)
    rule (I1:Int dividesInt I2:Int) => (I2 %Int I1) ==Int 0
    rule freshInt(I:Int) => I

  syntax    Int ::= "~Int" Int                                                  [function, functional]
                  > left:
                    Int   "^Int" Int                                            [function, left]
                  | Int  "^%Int" Int Int                                        [function, left]
                  > left:
                    Int   "*Int" Int                                            [function, functional, left]
                  | Int   "/Int" Int                                            [function, left]
                  | Int   "%Int" Int                                            [function, left]
                  | Int "divInt" Int                                            [function, left]
                  | Int "modInt" Int                                            [function, left]
                  > left:
                    Int   "+Int" Int                                            [function, functional, left]
                  | Int   "-Int" Int                                            [function, functional, left]
                  > left:
                    Int  ">>Int" Int                                            [function, left]
                  | Int  "<<Int" Int                                            [function, left]
                  > left:
                    Int   "&Int" Int                                            [function, functional, left]
                  > left:
                    Int "xorInt" Int                                            [function, functional, left]
                  > left:
                    Int   "|Int" Int                                            [function, functional, left]

  syntax    Int ::= minInt  ( Int , Int )                                       [function, functional]
                  | maxInt  ( Int , Int )                                       [function, functional]
                  | absInt  ( Int )                                             [function, functional]
                  | log2Int ( Int )                                             [function]
                  | bitRangeInt           ( Int, indexInt:Int, lengthInt:Int )  [function]
                  | signExtendBitRangeInt ( Int, indexInt:Int, lengthInt:Int )  [function]

    rule bitRangeInt(I, IDX, LEN) => (I >>Int IDX) modInt (1 <<Int LEN)

    rule signExtendBitRangeInt(I, IDX, LEN)
         => (bitRangeInt(I, IDX, LEN) +Int (1 <<Int (LEN -Int 1))) modInt (1 <<Int LEN) -Int (1 <<Int (LEN -Int 1))

    rule I1:Int divInt I2:Int => (I1 -Int (I1 modInt I2)) /Int I2  requires I2 =/=Int 0

    rule I1:Int modInt I2:Int
         => ((I1 %Int absInt(I2)) +Int absInt(I2)) %Int absInt(I2)  requires I2 =/=Int 0    [concrete]

    rule minInt(I1:Int, I2:Int) => I1 requires I1 <=Int I2
    rule minInt(I1:Int, I2:Int) => I2 requires I1 >=Int I2

  syntax      K ::= srandInt ( Int )                       [function]
```

### K
```
  syntax   Bool ::= left: K "==K" K                        [function, functional, smtlib(=), hook(KEQUAL.eq), klabel(_==K_), symbol, latex({#1}\mathrel{=_K}{#2}), equalEqualK]
                  | K "=/=K" K                             [function, functional, smtlib(distinct), hook(KEQUAL.ne), klabel(_=/=K_), symbol, latex({#1}\mathrel{\neq_K}{#2}), notEqualEqualK]

  syntax priorities equalEqualK notEqualEqualK > boolOperation mlOp

    rule K1:K =/=K K2:K => notBool (K1 ==K K2)
    rule K1:Bool ==Bool K2:Bool => K1 ==K K2

  syntax      K ::= "#if" Bool "#then" K "#else" K "#fi"   [function, functional, smtlib(ite), hook(KEQUAL.ite), poly(0, 2, 3)]

    rule #if C:Bool #then B1 #else _ #fi => B1 requires C
    rule #if C:Bool #then _ #else B2 #fi => B2 requires notBool C

  syntax      K ::= "#configuration"                       [function, impure hook(KREFLECTION.configuration)]
  syntax  KItem ::=  #fresh(String)                        [function, hook(KREFLECTION.fresh), impure]
                  | getKLabel(K)                           [function, hook(KREFLECTION.getKLabel)]

  syntax String ::= #getenv(String)                        [function, impure, hook(KREFLECTION.getenv)]
                  | #sort(K)                               [function, hook(KREFLECTION.sort)]

  // Return empty string if the term has no klabel
  syntax String ::= #getKLabelString(K)                    [function, hook(KREFLECTION.getKLabel)]

  // Return true if no variable nor unresolved function appears in any subterm
  syntax   Bool ::= #isConcrete(K)                         [function, hook(KREFLECTION.isConcrete)]
                  | #isVariable(K)                         [function, hook(KREFLECTION.isVariable)]

  // Used to parse semantic rules
  syntax non-assoc #KRewrite
  syntax      K ::= K "=>" K                               [klabel(#KRewrite), symbol, poly(0, 1, 2)]

  syntax      K ::= K "#as" K                              [klabel(#KAs), symbol, poly(0, 1, 2)]

  // Functions that preserve sorts and can therefore have inner rewrites
  syntax      K ::= "#fun" "(" K ")" "(" K ")"             [klabel(#fun2), symbol, poly(0, 1, 2), prefer]

  // Functions that do not preserve sort and therefore cannot have inner rewrites
  syntax      K ::= "#fun" "(" K "=>" K ")" "(" K ")"      [klabel(#fun3), symbol, poly(0, 2; 1, 3)]
```

### List
```
  // Concatenation of two Lists. This is similar to the append "@" operation in many functional programming languages.
  syntax   List ::= List List                              [left, function, functional, hook(LIST.concat), klabel(_List_), symbol, smtlib(smt_seq_concat), assoc, unit(.List), element(ListItem), format(%1%n%2)]

  // Empty List
  syntax   List ::= ".List"                                [function, functional, hook(LIST.unit), klabel(.List), symbol, smtlib(smt_seq_nil), latex(\dotCt{List})]

  // Singleton List
  syntax   List ::= ListItem(KItem)                        [function, functional, hook(LIST.element), klabel(ListItem), symbol, smtlib(smt_seq_elem)]

  // Get an element form the List by index. Positive indices mean from the beginning (0 is the first element), and negative indices mean from the end (-1 is the last element).
  syntax  KItem ::= List "[" Int "]"                       [function, hook(LIST.get), klabel(List:get), symbol]

  syntax   List ::= List "[" Int "<-" KItem "]"            [function, hook(LIST.update), klabel(List:set)]

  syntax   List ::= makeList(Int, KItem)                   [function, hook(LIST.make)]

  syntax   List ::= updateList(List, Int, List)            [function, hook(LIST.updateAll)]

  syntax   List ::= fillList(List, Int, Int, KItem)        [function, hook(LIST.fill)]

  // Remove elements from the beginning and the end of the List
  syntax   List ::= range(List, Int, Int)                  [function, hook(LIST.range), klabel(List:range), symbol]

  // Check element membership in the given list
  syntax   Bool ::= KItem "in" List                        [function, functional, hook(LIST.in), klabel(_inList_)]

  // Get the list length
  syntax    Int ::= size(List)                             [function, functional, hook(LIST.size), klabel (sizeList), smtlib(smt_seq_len)]
```

### Map
```
  // The Map represents a generalized associative array. Each key can be paired with an arbitrary value, and can be used to reference its associated value. Multiple bindings for the same key are not allowed.

  syntax priorities _|->_ > _Map_ .Map
  syntax non-assoc _|->_

  // Map consisting of key/value pairs of two Maps (the keys of the two Maps are assumed disjoint)
  syntax   Map ::= Map Map                              [left, function, hook(MAP.concat), klabel(_Map_), symbol, assoc, comm, unit(.Map), element(_|->_), index(0), format(%1%n%2)]

  // Construct an empty Map
  syntax   Map ::= ".Map"                               [function, functional, hook(MAP.unit), klabel(.Map), symbol, latex(\dotCt{Map})]

  // Singleton Map (a Map with only one key/value pair). The key is on the left and the value is on the right.
  syntax   Map ::= KItem "|->" KItem                    [function, functional, hook(MAP.element), klabel(_|->_), symbol, latex({#1}\mapsto{#2})]

  // Retrieve the value associated with the given key
  syntax KItem ::= Map "[" KItem "]"                    [function, hook(MAP.lookup), klabel(Map:lookup), symbol]

  syntax KItem ::= Map "[" KItem "]" "orDefault" KItem  [function, functional, hook(MAP.lookupOrDefault), klabel(Map:lookupOrDefault)]

  // Update a Map at the level of individual keys and values
  syntax   Map ::= Map "[" KItem "<-" KItem   "]"       [function, functional, hook(MAP.update), prefer]

  // Remove key/value pair associated with the key from map
  syntax   Map ::= Map "[" KItem "<-" "undef" "]"       [function, functional, hook(MAP.remove), klabel(_[_<-undef]), symbol]

  // Get the difference of two maps interpreted as sets of entries ($M_1 \setminus M2$)
  syntax   Map ::= Map "-Map" Map                       [function, functional, hook(MAP.difference), latex({#1}-_{\it Map}{#2})]

  // Update the first map by adding all key/value pairs in the second map. If a key in the first map exists also in the second map, its associated value will be overwritten by the value from the second map.
  syntax   Map ::= updateMap(Map, Map)                  [function, functional, hook(MAP.updateAll)]

  // Update the Map by removing all key/value pairs with the key in the Set
  syntax   Map ::= removeAll(Map, Set)                  [function, functional, hook(MAP.removeAll)]

  // List of all keys in the Map:
  syntax  List ::= "keys_list" "(" Map ")"              [function, hook(MAP.keys_list)]

  // Set of all keys in the Map
  syntax   Set ::= keys(Map)                            [function, functional, hook(MAP.keys)]

  // Check if a KItem is in keys(Map)
  syntax  Bool ::= KItem "in_keys" "(" Map ")"          [function, functional, hook(MAP.in_keys)]

  // List consisting of all values in the Map
  syntax  List ::= values(Map)                          [function, hook(MAP.values)]

  // Map size (number of key/value pairs)
  syntax   Int ::= size(Map)                            [function, functional, hook(MAP.size), klabel(sizeMap)]

  // Check map inclusion
  syntax  Bool ::= Map "<=Map" Map                      [function, functional, hook(MAP.inclusion)]

  // Arbitrarily choose a key of the Map
  syntax KItem ::= choice(Map)                          [function, hook(MAP.choice), klabel(Map:choice)]
```

### Set
```
  // The Set represents a mathematical set (a collection of unique items).

  // Construct a new Set as the union of two different sets ($A \cup B$)
  syntax   Set ::= Set Set                              [left, function, functional, hook(SET.concat), klabel(_Set_), symbol, assoc, comm, unit(.Set), idem, element(SetItem), format(%1%n%2)]

  // Construct an empty Set
  syntax   Set ::= ".Set"                               [function, functional, hook(SET.unit), klabel(.Set), symbol, latex(\dotCt{Set})]

  // Construct a singleton Set (e.g. $\{ a \}$). To add an element $a$ to a set $A$, construct the union of the singleton set $\{ a \}$ and $A$ (i.e. $\{ a \} \cup A$).
  syntax   Set ::= SetItem ( KItem )                    [function, functional, hook(SET.element), klabel(SetItem), symbol]

  // Get the intersection of two sets (i.e. $A \cap B$)
  syntax   Set ::= intersectSet ( Set , Set )           [function, functional, hook(SET.intersection)]

  // Get the difference of two sets (i.e. $A \setminus B$)
  syntax   Set ::= Set  "-Set" Set                      [function, functional, hook(SET.difference), latex({#1}-_{\it Set}{#2}), klabel(Set:difference), symbol]

  // Check element membership in a set (i.e. $a \in A$)
  syntax  Bool ::= KItem  "in" Set                      [function, functional, hook(SET.in), klabel(Set:in), symbol]

  // Check set inclusion (i.e. $A \subseteq B$)
  syntax  Bool ::= Set "<=Set" Set                      [function, functional, hook(SET.inclusion)]

  // Get the cardinality of a set (i.e. $|A|$)
  syntax   Int ::= size ( Set )                         [function, functional, hook(SET.size)]

  // Arbitrarily choose an element of a Set
  syntax KItem ::= choice ( Set )                       [function, hook(SET.choice), klabel(Set:choice)]
```

### String
```
  syntax   Bool ::= String  ==String String                       [function, functional, left]
                  | String =/=String String                       [function, functional, left]
                  | String   <String String                       [function, functional]
                  | String  <=String String                       [function, functional]
                  | String   >String String                       [function, functional]
                  | String  >=String String                       [function, functional]

    rule S1:String  ==String S2:String => S1 ==K S2
    rule S1:String =/=String S2:String => notBool (S1 ==String S2)
    rule S1:String  <=String S2:String => notBool (S2 <String S1)
    rule S1:String   >String S2:String => S2 <String S1
    rule S1:String  >=String S2:String => notBool (S1 <String S2)

  syntax  Float ::= String2Float ( String )                       [function]

  syntax    Int ::= lengthString ( String )                       [function, functional]
                  | findString ( String , String , Int )          [function]
                  | rfindString ( String , String , Int )         [function]
                  | findChar ( String , String , Int )            [function]
                  | rfindChar ( String , String , Int )           [function]
                  | ordChar ( String )                            [function]
                  | String2Int ( String )                         [function]
                  | String2Base ( String , Int )                  [function]
                  | countAllOccurrences ( String , String )       [function, functional]

  syntax String ::= String +String String                         [function, functional, left]
                  | Base2String ( Int , Int )                     [function]
                  | chrChar ( Int )                               [function]
                  | substrString ( String , Int , Int )           [function, functional]
                  | Float2String ( Float )                        [function, functional]
                  | Int2String ( Int )                            [function, functional]
                  | Float2String ( Float , String )               [function]
                  | replaceAll ( String , String , String )       [function, functional]
                  | replace ( String , String , String , Int )    [function]
                  | replaceFirst ( String , String , String )     [function, functional]
                  | categoryChar ( String )                       [function]
                  | directionalityChar ( String )                 [function]
                  | "newUUID"                                     [function, impure]
```

### Substitution
```
  // used for user-defined substitution only
  syntax KVariable

  syntax K ::= K "[" K "/" K "]"  [function, hook(SUBSTITUTION.substOne), impure, poly(0, 1)]
  syntax K ::= K "[" Map "]"      [function, hook(SUBSTITUTION.substMany), impure, poly(0, 1)]
```

--------------------------------------------------------------------------------------------

When defining K rules, we can give a variable it's sort in order for the K tool to perform a runtime sort check. E.g. the rule
```
	rule (lambda X:Id . E:Exp) V:Val => E[V / X]
```
instructs the K tool to check that `X` is an `Id`, `E` is an `Exp`, and `V` is a `Val` at runtime.

## Declaring fresh variables
To declare a fresh integer, for example, it looks like you can use either `!I:Int` or `?I:Int`.


## Construct Attributes

#### Function
Not sure what the `[function]` attribute does exactly.

#### Functional
Not sure what the `[functional]` attribute does exactly.

#### Left/Right
The attribute `[left]` (`[right]`) makes a language construct left (right)-associative.

#### K labels
Constructs can be given a *K label*. Using the attribute `[klabel(labelName)]` is syntactic sugar for replacing the node names in the KAST. Using `KLabels` is also a way to use overloaded sorts, e.g.
```
  syntax Names ::= List{Id, ","}  [klabel(NameVars)]

  syntax Procs ::= List{Id, ","}  [klabel(ProcVars)]
```

The K tool is now able to distinguish between a list of `Id`s as a list of name variables or process variables.

#### Poly
Not sure what the `[poly]` attribute does exactly.

#### Pure vs. Impure
Not sure what the `[impure]` attribute does exactly.

## Rule Attributes
#### Anywhere
If we have a rule which we want to apply outside of the `k` cell, in fact we want it to apply anywhere, then we can use the `[anywhere]` attribute. E.g.
```
  rule P:Proc | Nil => P  [anywhere]
```
Now this rule applies in all cells. This is used as opposed to a `context`.

#### Macro
The `[macro]` attribute is reserved for syntactic sugar. Macros desugar statically.

### Nondeterminism
Two sources of nondeterminism in programs: concurrency and evaluation strategies.

#### Concurrency
* Search the transition system generated by a program for all possible behaviors of a rule tagged `[rTag]`
1. First kompile the definition using the `--transition` option, i.e.
```
  kompile lang.k --transition "rTag"
```

2. Then krun the program using one of the `--search`, `--search-all`, or `--search-final` option, i.e.
```
  krun pgm.lang --search        krun pgm.lang --search-all        krun pgm.lang --search-final
```

#### Strictness: Evaluation Strategies
Strict, seqstrict

#### Superheating/Supercooling: Tags
Constructors and rules can be given a *tag*. For the strictly-evaluated constructor with , the tags allow the K tool to search for nondeterminism caused by evaluation order using the option `--superheat "cTag"`. For the rule with tag `[rTag]`, you can search for nondeterministic behavior caused by this rule using the option `--supercool "rTag"`.

In both cases, the tag syntax is the same:
```
  syntax Sort ::= ...     [cTag, strict]

  rule Left => Right              [rTag]
```

E.g.
```
  syntax Exp ::= Exp "+" Exp       [plus, strict]

  rule <k> print I:Int => I ...</k>
       <out>... . => ListItem(I) </out>  [output]
```

--------------
  From the Reference manual
----------------------------------------------------------------------------------------------------------

### `krun [options] <file>`
Programs in K are executed by means of invocation of the `krun` tool. In its simplest possible form, `krun` is executed with only a single command-line argument: the name of the program to be run. However, `krun` also provides a number of command line options designed to allow more complicated behaviors and ways to specify what to execute. These options can be viewed by executing the command `krun -h`; details are provided below.

##### Specifying the definition to execute with: `--k-definition`, `--compiled-def`
In order for `krun` to be able to execute anything, it needs to be able to decide where to look for information about the K semantics it is executing under. By default, if no options are specified, it looks in the current working directory for a directory with the suffix "-kompiled". If it finds exactly one of these, it assumes that this contains the compiled semantics you wish to use to execute. If instead it finds no such directories, or more than one such directory, it will throw an error.

However, sometimes it is desirable to be able to compile more than one semantics into the same directory, or to be able to execute a semantics with `krun` from outside the directory the semantics resides in. This is where the `--k-definition` and `--compiled-def` directories come into play. The simplest way to specify this information is with the `--compiled-def` flag, which takes a single argument representing the path to the compiled K definition's directory. If this directory exists, it assumes it contains the semantics you wish to execute with, and proceeds accordingly.

The `--k-definition` flag behaves similarly. However, instead of accepting the path to the compiled K definition, it instead accepts as an argument the path to the main file of extension .k in your semantics (that is to say, the one you executed `kompile` on). It then attempts to infer the location of the compiled K definition from this path. Needless to say, if you executed `kompile` with the `--output` flag, it will not succeed, and will throw an error message instead. In this case, simply use the `--compiled-def` flag instead to specify the path you passed to `kompile --output`.

##### Specifying the program to execute under the semantics: `-c`, `--pgm`, `--term`
In order for a program to be executed by `krun`, it needs to know how to obtain the term representing the configuration it is supposed to rewrite. By default, this is obtained by means of the configuration declaration in your definition's semantics, and the abstraction of configuration variables.  By specifying one or more configuration variables, you are able to tell `krun` to plug values of your choosing into the initial configuration.

As a convention, the most common of these is the configuration variable `$PGM`. `$PGM` is special because we assume that it is the name of the program or main piece of syntax you wish to execute in your semantics. As such, it has several special mechanisms in place to allow you to specify a value for it. The simplest of these is to specify the name of a file containing your program (or a different value to be parsed if you have specified an external parser) on the command line as an argument. If you do this, `krun` will automatically invoke the parser and return a parsed value to be put into the `$PGM` configuration variable.

You can also specify a value to be parsed for the `$PGM` variable with the `--pgm` flag. This is just syntactic sugar: the command `krun --pgm foo` and the command `krun foo` are semantically equivalent.

Finally, you may specify the value for the `$PGM` variable the same way values are specified for all other configuration variables. Since you can specify an arbitrarily large number of configuration variables in your initial configuration, it isn't feasible to specify all of them as arguments on the command line unless they are referenced by name. This is the purpose of the `krun -c` flag. This flag takes two arguments: the name of the configuration variable to be specified, and the value it should contain. For example, to tell `krun` that the program to be executed should be the lambda calculus identity function, we would construct the command `krun -cPGM="lambda x . x"`. This pattern can also be used to specify any other configuration variable by its name and the value you wish it to have.

It's worth noting however that all of these approaches operate under the assumption that you wish to make use of the configuration variable abstraction when constructing a term for \krun to rewrite. However, sometimes, for example when restarting a previously saved computation, it is desirable to specify the entire term to be rewritten manually. This is where the option `--term` comes in. By specifying a value to the
`--term` option, the configuration declaration in the semantics is bypassed entirely, and `krun` assumes that the entirety of the term to be rewritten consists of whatever it parses from the value of the option.

##### Searching the state space of programs: `--bound`, `--depth`, `--graph`, `--pattern`, `--search`
So far we have been operating on the assumption that all you want to do with your semantics is execute it. However, the ultimate purpose of the K tool is to provide a mechanism for specifying formal semantics of programming languages so that you can do more complicated types of formal analyses of programs. As such, the `krun` tool provides a number of options designed to assist in the analysis of programs that you execute. The simplest of these tools is the search of the state space of programs.

In order to make use of the search functionality that `krun` provides, it is first necessary to tune your semantics for nondeterminism by appropriately specifying values for the `--transition` and `--super-strict` flags to `kompile`. For information on how to do this, please refer to section on nondeterminism.

Once this is done, the simplest possible entry point into the mechanisms `krun` provides for searching the state space of programs is the `--search` flag. By specifying this flag, instead of executing only a single run of the program, it instead attempts to find all possible final states of that program. That is to say, it will return a list of all the configurations your program is capable of terminating in.

Unfortunately, for large programs with significant amounts of nondeterminism, this may be something which takes too much time. Additionally, you may desire to write programs which do not terminate, or which otherwise are not feasible to allow for exploration of the entire state space of the program to termination. This is why we provide tools for specifying bounds on the exploration of the state space.

The first of these is the `--bound` flag. This takes an integer argument specifying the maximum number of solutions you are looking for. Once it has found at least as many solutions as you asked for as a bound, the search will terminate at that point without looking for further solutions.

The second is the `--depth` flag. `krun` operates by performing a *breadth-first* search of the state space of the program. As such, one possible way to limit the resources required to complete an exploration is to put a maximum limit on the depth of the search. If a depth of N is specified, `krun` will terminate the search as soon as all states that are at most N states away from the initial configuration have been explored.

By default, the `--search` command only returns final states: that is to say, states in which no further rewriting is possible. However, if I wish to explore only a finite depth of the program, this is likely to be undesirable behavior. If I specified a depth of 3, and there were no programs which terminated within three steps, by default the search would return no results. In order to prevent this, `krun` makes use of a number of options it provides to decide which types of states are considered solutions in order to set some intelligent defaults.

By default, the `--search` command returns only *final states*, unless a depth parameter is provided, in which case it *returns all states beginning with the initial state and ending with those states at the maximum depth bound away*. If however you wish to specify both a depth parameter and expect the search to only return final states, this is also possible by replacing the flag `--search` with the flag `--search-final`. You may also retrieve all states even without specifying a depth bound if you use the flag `--search-all`. Finally, the flags `--search-one-step` and `--search-one-or-more-steps` round out the selection by allowing you to select only configurations one step away from the initial state, or to select only configurations at least one step away from the initial state, respectively.

Sometimes, however, the mechanisms described so far do not provide what you require in order to be able to select only the states you wish to select. For this purpose, `krun` allows you to specify search patterns with the `--pattern` flag. By specifying a K rule without any rewrites in it (i.e. a pattern plus an optional side condition and optional attributes), you can perform matching and check side conditions on the results of the search, and discard all the solutions which do not meet your search criteria. If the search pattern contains variables, the search will return a substitution, telling you the values of each of those variables in the solution you requested. You can also tell `krun` that you don't want to see the value of a particular variable by using an anonymous variable (i.e. `_`) instead of a named variable in your search pattern.

It is worth noting that the `--pattern` flag is also able to be used on normal executions. The effect this has is to execute the program until it has reached its final configuration, and then perform a search on the resulting configuration. Therefore, you will either get a single solution containing the substitution through which the configuration resulting from execution matches the specified pattern, or else you will get no solutions, indicating that the configuration resulting from execution does not match the specified pattern. This may be useful in cases where you want to perform pattern matching on the result of executing a program, for example if you wish to write a test case which asserts that all programs executed through your semantics terminate with an empty k cell.

Finally, you may wish to visualize the search graph created by your search command. For this purpose we provide the `--graph` flag to `krun`. The `--graph` flag tells `krun` to *output the search graph as a set of nodes connected by edges corresponding to transition rules in your semantics*. By specifying this flag, you will receive a textual representation of this graph for your examination. You will also be given the option to load this graph into the `krun` debugger in order to view it in more detail by examining specific vertices and edges within the graph.  Future versions of the tool also plan to allow you to export your graph to an xml format to be loaded by third-party tools, or saved to a file and reloaded by the debugger at a later time.

##### Debugging programs: `--debug`
Frequently, one of the applications of a programming language that you desire is the ability to observe how a program executes as it is executing. For this purpose, `krun` provides a built-in set of debugging facilities.  By executing a program in `krun` with the `--debug` flag, you tell `krun` to create an instance of the debugger to use to manually explore the state space of the program.

When you first execute a program in the debugger, it begins by automatically executing until the first transition point in the semantics. For this reason, it is necessary to first tune your semantics for nondeterminism before using the debugger. For information on this process, please refer to the section on nondeterminism.

Once you have reached the first transition point in the semantics, the debugger halts for user input. At this point, you can specify a number of different commands to the debugger. To refer back to this list of commands while debugging, type the `help` command. Similarly, to exit the debugger at any time, type the `abort` command.

The remaining commands serve the purpose of allowing you to manually explore the state space of your program, and to construct a search graph of these states. Essentially, you may select any state in your program and tell `krun` to execute from that state for some specific amount of time. When the debugger returns control to you, it will have added the states it passed through while performing your command to the search graph, and you will be able to view them.

For this purpose, `krun` provides four basic commands to control your interaction with the search graph. First of these is the `show-search-graph` command. This command prints a summary of the entire search graph as it has been constructed so far. Each state in the graph is given a unique number, and each edge provides whatever basic information the debugger has been able to learn about that edge (i.e. its label or its tags).

Before you can execute from a particular state, you must first select it with the `select` command. By passing this command a state number, you tell the debugger that future commands to further explore the state space of the program should begin in that state. This is not necessary if your desire is to begin executing in the state you had just created. However, if you have immediately previously executed a command which generated more than one leaf state, or if you wish to execute from a different state than the leaf state you have just created, you need to first use this command to select the state in question.

Finally, `krun` allows you to request additional information concerning states or edges in the graph. By using the `show-node` command, you may tell the debugger to display the entire configuration for a particular state number. You may also use the `show-edge` command to tell the debugger to display all the information it has on a particular edge. Sometimes this is only the contents of the configurations at the two endpoints of the edge. Other times this also includes additional information like the label of the rule, or the entire rule itself.

The remaining commands in the debugger serve the purpose of allowing you to manually create new nodes in the search graph by executing some number of steps. The simplest of these commands is the `resume` command. By specifying this command, `krun` proceeds to execute from the current state until the program terminates. This will not provide you with any information concerning the edges you pass through along the way, but it will construct every single unique state between the state you began in and the termination of the program. It also automatically selects the final state it returns.

If instead you wish to only proceed for some finite number of steps, you may use the `step` command. This command behaves identically to the `resume` command except that in addition to terminating if the program
reaches a final state, it also terminates after executing a fixed number of steps. By default this is only a single step, but you may pass as an argument a different number of steps for a bound as well. This command also automatically selects the last state stepped through.

Finally, sometimes you may wish to examine the nondeterminism of a program, or to gain further information about the edges of a particular segment of execution. For this purpose we provide the `step-all` command. By default, this command constructs all possible states exactly one step away from the state you had previously selected to begin in. However, you may also increase the depth of this command by passing it an argument of a number of steps.

The `step-all` command also serves to fill in any additional information about the edges in the search graph it creates. Due to a current limitation of the tool, edges created by means of superheating will only provide you with the knowledge that they are superheated edges. However, a future version of the tool will also provide you with the syntax production in your semantics which was superheated. You may also even currently obtain the entire rule corresponding to a `--transition` rule.

It is also planned in future versions of the tool to provide a graphical API to the debugger to allow you to visualize the search graph in two dimensions, and to allow you to save the search graph to an xml format to be loaded by the debugger later, or to be used by third-party tools. Finally, it is also planned to allow execution via the `step` and `resume` commands to be terminated partway through by sending the SIGINT signal to the debugger.

##### Debugging programs graphically: `--debug-gui`
The graphical debugger comes as an extension of the textual one, allowing the user to visualize the search graph information in a two dimensional manner. In order to access the graphical debugger you have to execute a program in `krun` with the `--debug-gui` flag.

Example: `krun program.ext --debug-gui`

This type of execution instantiates a new window containing:
1. *Graph panel*: a panel for graph visualization
2. *Configuration panel*: a panel for displaying the configuration
3. *Command area*: a command area with buttons
4. *Menu*: a menu for save, load or export operations

1. Graph panel
The "Graph panel" represents the location which will hold the current search graph of the program. Results of future exploration operations will be visible in this area. As in general, the graph is comprised of vertices and edges.

* Vertex
A vertex represents a certain state of the program. A vertex has a "Config id" label, where the id is specific for each state individually. Vertices can be selected. Selection is performed by left clicking the vertex. The label of the vertex is highlighted with a red color so that the user can be constantly aware of the current selection.

Also available is the selection of multiple vertices. This can be accomplished in two ways:
  1. by holding the "Shift" key while left-clicking on the vertices of choice
  2. by holding the left-click and moving the cursor to cover the entire area where the vertices to be selected are placed

The results of selection are further discussed in the "Configuration panel" and "Command area" sections.

One final action that can be performed is centering the selected vertex inside the graph layout. To accomplish this, you have to hold the "Ctrl" key while selecting a vertex. This will generate a transition which will position the vertex in the middle of the graph panel area.

* Edge
Edges connect the vertices, retaining information about the transition applied and offering a hierarchical manner of data interpretation. Single selection is possible even upon edges. Left-clicking an edge will open a new frame, further details about this frame being found in the "Difference between states panel" section.

The execution of the graphical debugger is identical with that of the textual debugger, in what regards the processes that are conducted in the background. An automatic execution until the first transition point in the semantics is launched. Once this state is reached, the debugger halts for user input. In consequence, the graph panel initially contains two vertices. The uppermost one is equivalent to the original state of the program, whilst the other one is obtained after the previously mentioned automatic execution. Additions to the graph will be dictated by the users exploration actions.

Taking into account the size of the graph that can become considerably large, ZOOM-IN and ZOOM-OUT capabilities are enabled. To zoom in or out, the user must position his cursor inside the reserved area of the graph panel and utilize the scroll of the mouse to zoom in or out. This way the graph can be manipulated and better controlled.

To a degree, the graph panel can be interpreted as the visual correspondent of the `show-search-graph` command from the textual debugger. The common element is represented by the fact that the purpose of both concepts at hand is to display the entire search graph that has been constructed so far. The difference surfaces from the manner of presentation, as well as from the scope of visibility of the graph. In the case of the graphical debugger, the graph is always visible and is automatically modified according to the users actions.

2. Configuration panel
The "Configuration panel" provides more specific information about a certain state. As mentioned in the "Graph panel" section, the graph contains all the currently constructed states, represented as vertices with labels. Apart from these labels, states have associated different configurations, which are key points of interest in investigating the behaviour of a program. To display a configuration of choice just select the corresponding vertex from the graph panel.

After selection, the configuration panel will be updated with the proper configuration of that state outputted in an xml format. The option of having multiple configurations opened for view without updating the current panel is available. When a user selects multiple vertices, each vertex configuration will be display in a tabbed panel in the area reserved for visualizing cell states. To avoid confusion, only one configuration is shown at a time, but the process of interchanging the viewed configuration is as simple as clicking the tabbed panel associated with the wanted vertex. To close a tabbed panel simply deselect the correspondent vertex.

On account of the xml format, the printed cells of the configuration can be further processed. A cell can be collapsed by pressing the "-" symbol which accompanies the start tag of the cell. By doing so, the entire content of that cell will be replaced with a closed tag. To expand a collapsed cell click the "+" symbol which appears in front of it. The configuration panel acts like a global handler for all the existing states. What that means is that all the expand and collapse actions performed in a configuration are memorized and applied to a distinct configuration when a different state is chosen from the graph. For example, if a user collapses the k cell of a configuration, this cell will appear collapsed no matter the vertex selected from the graph panel.

Initially all cells are expanded. By adding the ability of manipulating the content of the configuration, the user is able to obtain a better view of the information that is essential for his process of evaluating the program's behaviour.

3. Command area
The "Command area" reveals the actions available for user execution in the form of accessible buttons. These are in order:

  * `#Step`
  * `#Step-all`
  * `#Collapse`
  * `#Expand`
  * `#Compare`
  * `#Help`
  * `#Exit`

The first two buttons of the list are equivalent to the commands with the same name from the textual debugger.

The other four buttons are specific to the graphical debugger and its manner of data representation.

In addition, this area contains an input box where the user can enter the number of steps that need to be passed to the debuggers background processes and executed.

* Step
The "Step" button performs an action which behaves identically to the `step` command from the textual debugger.

  1. Select from the graph panel the vertex which holds the state from which to begin the execution.
  2. Write the number of steps to be executed in the input box of the command area.
  3. Press the "Step button".

The command is executed and the resulting states of this action are automatically added to the already constructed search graph. Once the graph is updated with the new components, it is immediately redrawn to display the current information inside the graph panel.

As a final phase of the "Step" command, the last state added in the graph is by default selected for the user.

Another feature of the "Step" command is that it can be applied to a group of vertices from the graph, not just one. The stages to be followed for this type of action are identical to those previously described for the "Step" command, with the exception that a multiple selection should be done upon the graph panel. The number of given steps will be executed for each and every vertex of the selection and all of the resulting states and corresponding edges will be inserted in the graph panel. All final states for every initially chosen vertex will be selected automatically.

The graph has unique components. No vertex containing a state can appear more than once inside the graph.

* Step_all
The "Step-all" button is the correspondent of the `step-all` command from the textual debugger.
  1. Select wanted vertex or group of vertices.
  2. Give number of steps to be executed (default 1) in the input box.
  3. Press "Step-all" button.

> Result: All successors in the entered number of transitions are computed and the newly created vertices and edges are properly placed inside the graph panel.

* Collapse
The "Collapse" button offers data manipulation support. Because the search graph can become difficult to handle due to dimension concerns, the user is given the ability to reduce the number of visible graph components.
  1. Select vertices that should be collapsed.
  2. Press "Collapse" button.

> Result:  The selected group of vertices are mashed up into one graph component.

The changes are observable in the graph panel. The new component which accommodates a number of basic vertices has distinct properties. The shape of this component is dictated by the number of vertices it holds. This translates to a new triangle shaped component being added if 3 vertices were collapsed, or a square shaped in the case of 4 vertices and so on. The label for this component lists the configuration ids for the vertices which were compressed.

The button can be used only in certain conditions and if those requirements are not fulfilled it becomes disabled. The condition for enabling this button is to select at least 2 vertices from the graph. Another important aspect is that collapsing extends not only to basic vertices. Any combination of more than two graph elements (normal vertices, collapsed components) can be the subject of collapsing.

* Expand
The "Expand" button represents the complementary action of the "Collapse" button. Information prioritizing can be modified and a collapsed vertex should have the option of being brought back to a detailed view.
  1. Select the compressed component that should be expanded.
  2. Press "Expand" button.

> Result:  The graph is redrawn and the elements which formed the collapsed component are once again available in the displayed search graph.

The enabling of this button is conditioned by selecting a composed graph element.

* Compare
The "Compare" button has the purpose of easing the workload to which the user has to be submitted to in order to perceive the differences between configurations.
  1. Select 2 basic vertices.
  2. Press the "Compare" button.

> Result: A new window appears displaying the "Difference between states panel".

* Exit
The "Exit" button represent the manner in which the user can stop the execution of the graphical debugger. Clicking this button will close the window associated to the debugging session.

  * Difference between states panel
  The "Difference between states panel" contains two configurations, displayed next to each other, one on the left half of the panel and the other on the right half.

  The differences between the two configurations are highlighted for the user with a yellow color. This way the user can easily remark what has changed and what remains common for the two selected elements.

* Menu
  * Save: The "Save configuration" option enables the user to retain an exact state of a vertex(vertices) in a file(files). It could be the case that a certain configuration can be of great interest or that the execution is halted and we want to restart the process of debugging from where we left if off.

    To save a configuration just select a vertex(or vertices) from the Graph Panel, press File and then Save Configuration. Then choose the location where the file which stores the configuration should be saved.

    Shortkey: Ctrl+S.


  * Load: Press File -> Load Configuration to load a specific file of your choice.

    Shortkey: Ctrl+L.

  * Export: Graph representations can be exported in a .png format by clicking File -> Export png.

    Shortkey: Ctrl+P.

##### LTL Model Checking: `--ltlmc`
###### External parsers: `--parser`, `--cfg-parser`
Up to this point we have been operating under the assumption that your desire is only to use the default parsing options for parsing terms provided as inputs to `krun`. However, sometimes you will find that it is simply not possible to parse a particular language using the K framework. Because of this limitation, it is intended that you be able to specify external parsers for your language which can be used instead of the default parser in order to parse programs and terms in such languages.  Because of this, `krun` provides several options designed to allow you to choose how you wish to parse terms that are inputs to `krun`, as well as also providing a number of intelligent defaults.

The simplest form of parsing occurs when you specify a file as an argument on the command line. By default, this parses the contents of that file using the `kast` command with no options. For example, if I write the command `krun foo`, it will in term execute the command `kast foo` which will assume that foo is a file on the file system containing a program written in the syntax of the language. For details concerning how `kast` operates, refer to the `kast` section.

In order to specify an external parser for this purpose, the `--parser` flag is used. By specifying a shell command as argument to this flag, that shell command gets executed with a single argument: the value of the argument to `krun`. Normally this is the path to a file containing code to be parsed. However, this is not necessarily a guarantee. For example, the command `krun --parser "kast -e" "foo"` will execute the command `kast -e foo` which will in turn assume that "foo" is a valid program in the language of the semantics you have defined (as opposed to the name of a file containing such a program).

However, unfortunately, sometimes the name of the file (or the term itself) is not sufficient information in order to be able to successfully parse a value. In order to remedy this, and instead of requiring that external parsers be able to parse flags on the command line, `krun` also sets a number of environment variables in the environment of the process created for the external parser. These environment variables provide additional information in order to allow the external parser to make additional decisions concerning how to parse something, or not, as it chooses. Currently `krun` sets three of these.

1. KRUN\_COMPILED\_DEF
Contains the absolute path to the compiled definition directory on the file system, in case the external parser wishes to use this. This is especially useful if your external parser is a variant of `kast`.

2. KRUN\_SORT
Contains a sort name designed to provide the external parser information about the context in which the term is being parsed. As an example of how this is used, if you specify a model-checking formula using the
`--ltlmc` flag, it is parsed using your external parser with the sort information of ``LtlFormula''.

3. KRUN\_IS\_NOT\_FILE
Tells the external parser that because of the particular type of value being parsed, by default it is being passed as an argument on the command line instead of as a name to a file containing data to be parsed. For example, configuration variables, when parsed by an external parser, set this value. Note that this does not necessarily mean that the value actually being passed doesn't consist of a filename. A parser may behave however you wish it to, and as long as it receives an input it can understand, this is acceptable behavior. The flag merely indicates that unless you specify an external parser, the value provided is being assumed to be data to be parsed rather than a filename. This allows the same parser to be used both with a filename and with data to be parsed, without needing to specify separate parser commands for each.

It is worth noting the `--parser` flag, while used for programs, model-checking formulas, `--term` values, and runtime parsing of `#String` constants, is not used to specify parsers for configuration variables. This is because a limitation of the Apache CLI framework used to parse command line arguments makes it impossible to determine where within a command line string an argument (i.e. not an option) is specified. However, since it is possible to obtain this information for options, it is used in the design of how you specify external parsers for configuration variables.

The `--cfg-parser` flag behaves similarly to the `--parser` flag in that it takes a string to be used as the command for parsing configuration variables. However, since it is possible to specify multiple configuration variables, it is desirable to allow these configuration variables to be parsed each with different parsers. Therefore, when determining which parser to use to parse a particular configuration variable, the parser chosen is the one specified by the rightmost `--cfg-parser` flag which is to the left of the `-c` flag in question. Additionally, by default, since most configuration parameters contain things like Lists and Maps and other pieces of syntax not provided by the default `kast` parser, the default parser for configuration variables is `kast -groundParser -e`. Refer to the `kast` section for details on how this command behaves.

Because `krun` parses a number of different types of inputs, each of which consisting of a different sort of data, it is reasonable to expect that it will use a number of different types of behavior when deciding which parser to use to parse that data. For reference, therefore, the following table contains all the information concerning how each type of data parsed by `krun` is parsed by default, and how it can be customized.

---------------------------------------------------------------------------------------------------------------------
Type of data parsed & Default parser & Parser flag & KRUN\_SORT & KRUN\_IS\_NOT\_FILE
---------------------------------------------------------------------------------------------------------------------
| `--pgm` and command line arguments | `kast` | `--parser` |  |  |
---------------------------------------------------------------------------------------------------------------------
| `--term` | `kast -groundParser` | `--parser` |  |  |
---------------------------------------------------------------------------------------------------------------------
| -c` | `kast -groundParser -e` | `--cfg-parser` |  | `true` |
---------------------------------------------------------------------------------------------------------------------
| `--pattern` | `kast -ruleParser -e`  |  |  |  |
---------------------------------------------------------------------------------------------------------------------
| `--ltlmc` | `kast` | `--parser` | `LtlFormula` | `true` if the argument provided is not a file, `false` otherwise |
---------------------------------------------------------------------------------------------------------------------
| `#parse(Term, Sort)` | `kast` | `--parser` | `Sort` | `true` |
---------------------------------------------------------------------------------------------------------------------

##### \krun execution backends: `--backend`
By default, once an initial configuration has been computed by `krun`, the actual executing of the rewriting-based semantics is performed by ocaml. It used to be maude, however, for certain purposes, maude is less than ideal. For example, maude's implementation of Sets, Bags, and Maps is based on associative-commutative matching, which, while incredibly powerful and capable of supporting very complex operations on these data types, is highly inefficient. Additionally, certain applications of the k-framework are highly string-intensive, such as performing program verification which requires the construction of SMT-LIB 2 strings. Unfortunately maude's string implementation has no support for buffered construction of strings, and so the construction of large strings in maude is highly inefficient. These two examples are simply two of a number of reasons why it is not always the case that Maude provides the optimal solution for executing programs in `krun`.

For this purpose, we provide the ability to utilize other execution backends, as they become implemented by the framework. In order to specify these backends, it is necessary to pass to `krun` the `--backend` flag. This flag takes a string representing the name of a `krun` execution backend, and then, once it is time to begin rewriting, passes off the task of executing the program to this backend. The currently supported backends are: ocaml, haskell, java, kore, llvm.

##### Output formats: `--output-mode`, `--output`, `--color`, `--statistics`, `--trace`, `--profile`
`krun` supports a number of distinct modes for specifying output. The most obvious of these pieces of functionality is the `--output-mode` flag. This flag supports four different values. Simplest of these is *none*, which tells `krun` to display no output except that which was printed to the console or to files by I/O in the program execution. The second, *pretty*, is also the default, and tells `krun` to pretty-print the output it receives from its backend. For normal execution, this means that it re-concretizes the syntax that was flattened by `kompile`, and displays it to the user. For search, this means that we display the list of search results (or the list of substitutions) which has also been re-concretized. For model-checking, this means either displaying the fixed constant `true` to represent a model-checking which has succeeded, or displaying a graph consisting of the re-concretized states composing the LTL counterexample returned by a model-checking which has failed.

The third value is *raw*. A raw output simply takes the output printed by the ocaml backend and provides it unchanged to the user. Finally, the fourth value, *binary*, saves the resulting configuration of an execution to a binary format that can be used later to resume computation. Output mode binary is currently not supported by search or model-checking, but future versions of the tool will save these results to a format which can be loaded by the debugger.

By default (except in the case of output mode binary, which always saves to a file), the output is printed to stdout. However, sometimes it is desirable to separate the output provided by krun from the output provided to stdout by I/O in your program. In order to do this, we have provided the flag `--output`. This flag accepts as a single parameter the path to a file, which it writes the output to.

Finally, there are several other miscellaneous options which have an effect on how the output of `krun` is printed. For example, the `--color` flag tells `krun` to pretty-print cells in the color specified in the configuration. Since this is also the default, primarily you will be using its inverse flag, `--no-color`, which is useful if you wish to pipe the output printed to stdout to a file. Since colors are printed using 8-color ANSI terminal color codes, if you specify the `--output` flag, the default becomes `--no-color`. If for some reason you wish to preserve these color codes in the output file, you may still specify the `--color` flag manually.

Also present is the flag `--statistics`, which parses statistics returned by ocaml about the execution of a program and prints them to the user. Due to limitations of the tool, currently this is only supported for program execution, but it is planned to also support search and model-checking in a future release.

Finally, there are two other pieces of functionality that `krun` exposes for output via the raw output mode only. These correspond to access to ocaml's internal tracer and profiler, respectively. By specifying `--trace`, you tell `krun` to tell ocaml to output the entire trace of all rewriting done to the file it internally writes its output to, which is displayed to the user via output mode raw. A note of warning here: because it is I/O intensive and ocaml otherwise performs a very high number of rewrites per second, the trace feature is incredibly slow, and should be used with caution.

Additionally, by specifying the flag `--profile`, you tell `krun` to tell ocaml to construct profiling information on all the rules executed by the semantics. This is useful if you wish to examine whether there are any rules which are matching or applying too often. It's worth noting here however, that since the primary speed bottleneck in maude is associative-commutative matching, it is not always the case that decreasing the number of times a rule rewrites will have an appreciable effect on performance, even if that rule executes millions of times. In the absence of AC matching, maude rewrites several million rules per second. AC matching, however, is over 100 times slower.

##### Basic Data Types
* Strings

A String in K corresponds to an indexable, searchable array of Unicode code points, as represented by literals enclosed in double quotes. For example, `""` is the empty string, and `"string"` is a string of length 6. While most ASCII characters can be encoded simply by typing them, non-ASCII characters in K definitions, as well as some ASCII characters, require escape sequences to encode themselves in strings. K provides, in addition to the standard escape sequences `\t`, `\n`, `\r`, `\\`, and `\"`, three mechanisms for escaping characters. The first, `\x`, takes exactly two hexadecimal digits as argument, and encodes the Latin-1 Unicode code point corresponding to that number. The second, `\u`, takes exactly four hexadecimal digits as argument, and encodes a Unicode character in the Basic Multilingual Plane.

For portability reasons, a String in K is a sequence of code points, not a sequence of code units. Therefore, the escape sequences in the range `\ud800` to `\udfff`, corresponding to UTF-16 surrogate pairs, are not allowed in String literals. If you believe that this impairs your ability to write the semantics you desire in the K framework, please let us know. We are willing to re-evaluate this decision. However, you might simply consider disallowing such strings in your semantics, as they do not correspond to any well-encoded Unicode String, and the Unicode standard forbids their use outside of UTF-16 surrogate pairs. Alternatively, you may choose to represent strings as an array of bytes or an array of integers in your semantics, and implement encoding and decoding yourself.

The third and final escape sequence K provides is `\U`, which takes eight hexadecimal digits encoding any Unicode code point, from `\U00000000` all the way up to `\U0010ffff`.

The K framework defines the following operations on Strings:
```
  syntax String ::= String "+String" String

  syntax   Bool ::= String "==String" String
                  | String "=/=String" String
                  | String "<String" String
                  | String ">String" String
                  | String "<=String" String
                  | String ">=String" String

  syntax    Int ::= lengthString(String)
                  | ordChar(String)
                  | String2Int(String)
                  | findString(String, String, Int)
                  | rfindString(String, String, Int)

  syntax String ::= chrChar(Int)
                  | substrString(String, Int, Int)
                  | Int2String(Int)
                  | categoryChar(String)
                  | directionalityChar(String)
```

The `+String` operation performs String *concatenation*. The `==String` operation performs String *equality*, the `=/=String` *inequality*, and the remaining four comparisons perform lexicographic ordering on Strings. The `lengthString` operation returns the number of code points in the String. `ordChar` and `chrChar` convert between single unicode characters and their numeric code points. Again, as before, unicode code points in the surrogate range cannot be encoded in Strings in K.

`substrString` takes a string, an inclusive begin offset, and an exclusive end offset, and returns the characters between that range. `findString` takes two strings and an inclusive offset, and returns the index of the first occurrence of the second string in the first string which follows the provided offset. `rfindString` performs the same task but searches from right to left.

`String2Int` converts a String into an integer by means of parsing it. A String that can be converted to an integer is either a sequence of characters with the "Nd" general category, optionally preceded by a sign, or else a single character with a Numeric Value unicode property which corresponds to an integer.  `Int2String` converts back from an integer to a string by means of the ASCII digit characters.

Finally, several methods exist to support reflection into the Unicode character database. `categoryChar` returns the two-letter string code corresponding to the general category of the character provided as argument, and `directionalityChar` provides the string code of the bidirectionality category of the character.











* Details of `krun --h`

Options:
  * `--argv`
	Additional argument to pass to interpreter binary
	(Default: `<empty string>`)
  * `--bound`
	The number of desired solutions for search.
  * `--color`
	Use colors in output (Default: on)
  * `--config-parser, -p`
	Command used to parse configuration variables. Default is "kast --parser ground -e". See description of --parser. For example, -pPGM="kast" specifies that the configuration variable $PGM should be parsed with the command "kast".
  * `--config-parserkey=value`
	(Default: {})
  * `--config-var, -c`
	Specify values for variables in the configuration.
  * `--config-varkey=value`
	(Default: {})
  * `--debug`
	Print debugging output messages
	(Default: false)
  * `--depth`
	The maximum number of computational steps to execute or search the definition for.
  * `--directory, -d`
	Path to the directory in which the kompiled K definition resides. The default is the unique, only directory with the suffix '-kompiled' in the current directory. A definition may also be specified with the 'KRUN_COMPILED_DEF' environment variable, in which case it is used if the option is not specified on the command line.
  * `--dry-run`
	Compile program into KORE format but do not run. Only used in Haskell backend
	(Default: false)
  * `--graph`
	Displays the search graph generated by the last search.
	(Default: false)
  * `--haskell-backend-command`
	Command to run the Haskell backend execution engine
	(Default: kore-exec)
  * `--haskell-backend-home`
	Directory where the Haskell backend source installation resides
  * `--interpret`
	Use even more minimal interpreter pipeline for faster performance
	(Default: false)
  * `--io`
	Use real IO when running the definition. Defaults to true.
  * `--mini-krun`
	Use minimalist krun pipeline for faster performance.
	(Default: false)
  * `--native-compiler`
	Command to use to perform native linking.
  * `--ocaml-compile`
	Compile program to run into OCAML binary
	(Default: false)
  * `--output, -o`
	How to display krun results. `<mode>` is either [pretty|program|kast|binary|json|none]
	(Default: PRETTY)
  * `--output-file`
	Store output in the file instead of displaying it.
  * `--output-flatten`
	(Assoc) KLabels to flatten into one list
	(Default: [])
  * `--output-omit`
	KLabels to omit from the output
	(Default: [])
  * `--output-tokast`
	KLabels to output as KAST tokens
	(Default: [])
  * `--output-tokenize`
	KLabels to tokenize underneath (reducing output size)
	(Default: [])
  * `--parser`
	Command used to parse programs. Default is "kast"
  * `--pattern`
	Specify a term and/or side condition that the result of execution or search must match in order to succeed. Return the resulting matches as a list of substitutions. In conjunction with it you can specify other 2 options that are optional: bound (the number of desired solutions) and depth (the maximum depth of the search).
  * `--search`
	In conjunction with it you can specify 3 options that are optional: pattern (the pattern used for search), bound (the number of desired solutions) and depth (the maximum depth of the search)
	(Default: false)
  * `--search-all`
	Same as --search but return all matching states, even if --	depth is not provided
	(Default: false)
  * `--search-final`
	Same as `--search` but only return final states, even if `--depth` is provided
	(Default: false)
  * `--search-one-or-more-steps`
	Same as `--search-all` but exclude initial state, even if it matches
	(Default: false)
  * `--search-one-step`
	Same as `--search` but search only one transition step.
	(Default: false)
  * `--term`
	Input argument will be parsed with the specified parser and used as the sole input to krun
	(Default: false)

#### `kompile`
* `kompile [options] <file>`
* Options:
  * `--backend`
	Choose a backend. <backend> is one of [ocaml|java|llvm|kore|haskell]. Each creates the kompiled K definition
	(Default: ocaml)
  * `--check-races`
	Checks for races among regular rules
	(Default: false)
  * `--coverage`
	Generate coverage data when executing semantics
	(Default: false)
  * `--debug`
	Print debugging output messages
	(Default: false)
  * `--directory, -d`
	Path to the directory in which the output resides. An output can be either a kompiled K definition or a document which depends on the type of backend. The default is the directory containing the main definition file.
  * `--gen-ml-only`
	Do not compile definition; only generate .ml files
	(Default: false)
  * `--hook-namespaces`
	<string> is a whitespace-separated list of namespaces to include in the hooks defined in the definition
	(Default: [])
  * `--main-module`
	Specify main module in which a program starts to execute. This information is used by 'krun'. The default is the 	name of the given K definition file without the extension (.k).
  * `--no-expand-macros`
	Do not expand macros on initial configurations at runtime. Will likely cause incorrect behavior if any macros are used in this term
	(Default: false)
  * `--no-link-prelude`
	Do not link interpreter binaries against constants.cmx and prelude.cmx. Do not use this if you don't know what you're doing
	(Default: false)
  * `--no-prelude`
	Do not implicitly require prelude.k
	(Default: false)
  * `--non-strict`
	Do not add runtime sort checks for every variable's inferred sort
	(Default: false)
  * `--ocaml-dump-exit-code`
	Exit code which should trigger a dump of the configuration when using
  * `--ocaml-compile`
  * `--ocaml-serialize-config`
	<string> is a whitespace-separated list of configuration variables to precompute the value of
	(Default: [])
  * `--opaque-klabels`
	Declare all the klabels declared by the following secondary definition.
  * `--packages`
	<string> is a whitespace-separated list of ocamlfind packages to be included in the compilation of the definition
	(Default: [])
  * `--reverse-rules`
	Reverse the order of rules as much as possible in order to find most nondeterminism without searching
	(Default: false)
  * `--syntax-module`
	Specify main module for syntax. This information is used by 'krun'
	(Default: <main-module>-SYNTAX)
  * `--transition`
	<string> is a whitespace-separated list of tags designating rules to become transitions
	(Default: [transition])
  * `-I`
	Add a directory to the search path for requires statements.
	(Default: [])
  * `-O2`
	Optimize in ways that improve performance, but intere with debugging and increase compilation time and code size slightly.
	(Default: false)
  * `-O3`
	Optimize aggressively in ways that significantly improve performance, but also increase compilation time and code size.
	(Default: false)
  * `-Og`
	Optimize as much as possible without interfering with debugging experience
	(Default: false)
  * `-ccopt`
	Add a command line option to the compiler invocation for the llvm backend
	(Default: [])

#### `kast`
* `kast [options] <file>`
* Options:
  * `--debug`
	Print debugging output messages
	(Default: false)
  * `--directory, -d`
	Path to the directory in which the kompiled K definition resides. The default is the unique, only directory with the suffix '-kompiled' in the current directory. A definition may also be specified with the `KRUN_COMPILED_DEF` environment variable, in which case it is used if the option is not specified on the command line.
  * `--expand-macros`
	Also expand macros in the parsed string.
	(Default: false)
  * `--expression, -e`
	An expression to parse passed on the command line. It is an error to provide both this option and a file to parse.
  * `--help, -h`
	Print this help message
	(Default: false)
  * `--help-experimental, -X`
	Print help on non-standard options.
	(Default: false)
  * `--kore`
	Output KORE-syntax instead of KAST-syntax.
	(Default: false)
  * `--module, -m`
	Parse text in the specified module. Defaults to the syntax module of the definition.
  * `--sort, -s`
	The start sort for the default parser. The default is the sort of $PGM from the configuration. A sort may also be specified with the 'KRUN_SORT' environment variable, in which case it is used if the option is not specified on the command line.

#### `kdoc`
* `kdoc [options] <file>`
* Options:
  * `--debug`
	Print debugging output messages
	(Default: false)
  * `--directory, -d`
	Path to the directory in which the output resides. An output can be either a kompiled K definition or a document which depends on the type of backend. The default is the directory containing the main definition file.
  * `--format`
  	Choose a format. <format> is one of [pdf|latex|html|unparse|doc|unflatten]. Each generates a document from the given K definition
	(Default: pdf)
  * `--help, -h`
	Print this help message
	(Default: false)
