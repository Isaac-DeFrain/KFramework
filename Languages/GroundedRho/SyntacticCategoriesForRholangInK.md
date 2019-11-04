# Syntactic Categories for Rholang in K

## Names
```
       Name ::= Var           // Name variable
              > Quote         // Quoted process
              > VarDec        // Variable declaration -- Var or Var(Uri)
              > TypedName     // Typed name variable

  // Meta-level names
       Name ::= EmptyName
        Var ::= BoundName
  BoundName ::= "n(" Int ")"
              | "n(" Int "," Int ")"
```

## Name Patterns
```
    NamePat ::= WildCard      // WildCard
              > PatVar        // Pattern variable
              | QuotePat      // Quoted process pattern
              | SimpleNamePat // Simple name pattern
```

## Processes
```
       Proc ::= New           // New name declarations
              > Ground        // Ground terms - Bool, Int, Nil, String, Uri
              | Collection    // Data structures - RhoList, RhoMap, RhoSet, RhoTuple
              | ProcVar       // Process variable
              > TypedProc     // Typed process variable
              > VarRef        // Variable references - name/process variable shadowing
              > Eval          // Evaluation/Dequote name
              > MethodProc    // Method
              > Exp           // Arithmetic, Boolean, RhoList, & String expressions
              > Matching      // Match & Select
              > Receive       // Receive/Consume
              | Contract      // Contract
              | Invocation    // Contract invocation
              | Send          // Send/Produce
              > Conditional   // If...then(...else)
              > Bundle        // Bundled processes
              > Par           // Parallel composition of processes

  // Meta-level processes
       Proc ::= EmptyProc
       PVar ::= BoundProc
  BoundProc ::= "x(" Int ")"
              | "x(" Int "," Int ")"
```

## Process Patterns
```
    ProcPat ::= Proc          // Concrete process
              > WildCard      // WildCard
              > PatExp        // Pattern expression
              > NewPat        // New pattern
              | CollectionPat // Collection pattern
              | SimplePat     // Simple process pattern
              > EvalPat       // Evaluation pattern
              > MethodPat     // Method pattern
              > ExpPat        // Arithmetic, Boolean, RhoList, & String pattern
              > MatchingPat   // Match & Select pattern
              > RecPat        // Receive pattern
              | ContractPat   // Contract pattern
              | InvocationPat // Contract invocation pattern
              | SendPat       // Send pattern
              > CondPat       // If...then(...else) pattern
              > ParPat        // Par pattern
```
