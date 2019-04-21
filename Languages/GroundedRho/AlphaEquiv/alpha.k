// De Bruijn Index & Alpha Equivalence for Grounded Rho Calculus

/*
TODO:
 - add environment, store, and nextLoc cells
   - maybe memory of variables seen is all that's needed
 - how to handle several name listens & joins?
 - more tests for substitutions in continuations for listens on chan
*/

require "../grho.k"

module ALPHA-SYNTAX
  import GRHO-SYNTAX
  
  syntax       DBProc ::= "#deBruijn(" Name  ";" Proc ")" [function]
                        | "#deBruijn(" Names ";" Proc ")" [function]
  
  syntax         Proc ::= "#deBruijn(" Proc ")"            [function]
                        | "new" Name  "in" "{" DBProc "}"  [function]
                        | "new" Names "in" "{" DBProc "}"  [function]
                        | Proc "#alpha" Proc

  syntax         Name ::= "#deBruijn(" Name ")"            [function]
                        | BoundName
                        | FreeName
//                      | "#deBruijn(" Int "," Int ";" Name ")"  [function, klabel(deBruijnN)]

//syntax        Names ::= "#deBruijn(" Int ";" Names ")"  [function, klabel(deBruijnNs)]
//                      | "#deBruijn(" Int "," Int ";" Names ")"  [function, klabel(deBruijnNs)]

  syntax    BoundName ::= "bound(" Int ")"
                        | "bound(" Int "," Int ")"          // for several name listens?
                        | "bound(" Int "," Int "," Int ")"  // for several listen joins?
  
  syntax     FreeName ::= "free("  Int ")"  // this is only used for analyzing fragments of programs

endmodule

module ALPHA
  import ALPHA-SYNTAX
  import AUXFUN

  configuration
  <T color="purple">
    <threads color="blue">
      <thread color="cyan" multiplicity="*">
        <k> #deBruijn( $PGM:Proc ) ~> sub </k>
        <env> .Map  </env>
        <index> 0 </index>
        <count> 0 </count>
      </thread>
    </threads>
    <store color="pink"> .Map  </store>
    <nextLoc color="gray"> 0 </nextLoc>
  </T>

  syntax KResult ::= Proc | Name | Bool

  syntax   KItem ::= "sub"

// New Name Declarations
  rule <k> #deBruijn( new M:NameVar in { P:Proc } ) => new M in { #deBruijn( P ) } ~> setEnv(Env) ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>
  
  rule <k> #deBruijn( new M:NameVar , N:NameVar in { P:Proc } ) => new M in { #deBruijn( N ; P ) } ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>
       
  rule <k> #deBruijn( new M:NameVar , N:Names in { P:Proc } ) => new M in { #deBruijn( N ; P ) } ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

  rule <k> new A:Name in { #deBruijn( M:Name ; P:Proc ) } => new A , M in { #deBruijn( P ) } ~> setEnv(Env) ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

  rule <k> new A:Name in { #deBruijn( M:Name , N:Name ; P:Proc ) } => new A , M in { #deBruijn( N ; P ) } ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

  rule <k> new A:Name in { #deBruijn( M:Name , N:Names ; P:Proc ) } => new A , M in { #deBruijn( N ; P ) } ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

  rule <k> new A:Names in { #deBruijn( M:Name ; P:Proc ) } => new #append(A ; M) in { #deBruijn( P ) } ~> setEnv(Env) ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

  rule <k> new A:Names in { #deBruijn( M:Name , N:Name ; P:Proc ) } => new #append(A ; M) in { #deBruijn( N ; P ) } ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

  rule <k> new A:Names in { #deBruijn( M:Name , N:Names ; P:Proc ) } => new #append(A ; M) in { #deBruijn( N ; P ) } ...</k>
       <env> Env => updateMap(Env, M |-> L) </env>
       <index> I </index>
       <count> C => C +Int 1 </count>
       <store>... .Map => L |-> bound(I,C) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

// Ground Terms
// index is constant and no storage allocation
  rule #deBruijn( G:Ground ) => G
  rule #deBruijn( Nil ) => Nil

// Parallel Composition
  rule #deBruijn( P:Proc | Q:Proc ) => #deBruijn( P ) | #deBruijn( Q )

// Sends
// index constant on name and proc
  rule #deBruijn( X:Name !  ( P:Proc ) ) => #deBruijn( X ) !  ( #deBruijn( P ) )
  rule #deBruijn( X:Name !! ( P:Proc ) ) => #deBruijn( X ) !! ( #deBruijn( P ) )

// Evals
// index is constant
  rule #deBruijn( * X:Name ) => * #deBruijn( X )

// Names
  // Bound names do not change
  rule #deBruijn( N:BoundName ) => N

/*
// Receives
  // variables become bound with the appropriate index
  rule #deBruijn( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ) => for( bound(I) <- #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P[ bound(I) / Y] ) }
  rule #deBruijn( I:Int ; for(           <- X:Name ){ P:Proc } ) => for(          <- #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }

  rule #deBruijn( I:Int ; for( Y:NameVar <= X:Name ){ P:Proc } ) => for( bound(I) <= #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P[ bound(I) / Y] ) }
  rule #deBruijn( I:Int ; for(           <= X:Name ){ P:Proc } ) => for(          <= #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }

  rule #deBruijn( I:Int ; for( Y:NameVar <! X:Name ){ P:Proc } ) => for( bound(I) <! #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P[ bound(I) / Y] ) }
  rule #deBruijn( I:Int ; for(           <! X:Name ){ P:Proc } ) => for(          <! #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }
  
  // TODO: more tests for substitution in P
  rule #deBruijn( I:Int ; for( Y:Quote <- X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <- #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }
  rule #deBruijn( I:Int ; for( Y:Quote <= X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <= #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }
  rule #deBruijn( I:Int ; for( Y:Quote <! X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <! #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }

  // Free variables are distinguised from bound ones - only pertains to fragments of programs
  rule #deBruijn( I:Int ; _:NameVar ) => free(I)

  // Quotes
  // index increases - is this what we want?
  // TODO: more tests
  rule #deBruijn( I:Int ; @ P:Proc ) => @ #deBruijn( I +Int 1 ; P )
*/

// Resetting the environment
  syntax KItem ::= setEnv(Map)
  rule <k> setEnv(Env) => . ...</k> <env> _ => Env </env>  [structural]
  
  // if there are multiple sequential Env resets
  rule (setEnv(_) => .) ~> setEnv(_)  [structural]

// Several Names
  // want to do something like #deBruijn(I;Y,Z) => #deBruijn(I;Y) , #deBruijn(I;Z) for several names
  // these name lists will only appear in listens, but can't make the appropriate substitutions in the continuation...
  
// Alpha Equivalence Predicate
  // checks synactic equality of De Bruijn index substituted terms
//  rule #deBruijn( I:Int ; P:Proc #alpha Q:Proc ) => #deBruijn( I ; P ) ==K #deBruijn( I ; Q )

// This rule says that if #deBruijn( 0 ; $PGM ) evaluates to a Bool (i.e. if we evaluate the #alpha predicate), then forget about the post substitution.
// That's not quite what I want... maybe alpha equivalence needs to be moved to a completely different module?
//  rule <k> _:Bool ~> (sub => .) </k>

endmodule