// De Bruijn Index & Alpha Equivalence for Grounded Rho Calculus

/*
TODO:
 - add memory for new declarations: <mem> M:NameVar |-> bound(I) </mem>
 - how to handle several name listens & joins?
 - more tests for substitutions in continuations for listens on chan
*/

require "../../grho.k"

module ALPHA-SYNTAX
  import GRHO-SYNTAX
  
  syntax       DBProc ::= "#deBruijn(" Int ";" Name  ";" Proc ")" [function]
                        | "#deBruijn(" Int ";" Names ";" Proc ")" [function]
  
  syntax         Proc ::= "#deBruijn(" Int ";" Proc   ")"  [function]
                        | "new" Name  "in" "{" DBProc "}"  [function]
                        | "new" Names "in" "{" DBProc "}"  [function]
                        | Proc "#alpha" Proc

  syntax         Name ::= "#deBruijn(" Int ";" Name  ")"   [function]
                        | BoundName
                        | FreeName
//                      | "#deBruijn(" Int "," Int ";" Name ")"  [function, klabel(deBruijnN)]

//syntax        Names ::= "#deBruijn(" Int ";" Names ")"  [function, klabel(deBruijnNs)]
//                      | "#deBruijn(" Int "," Int ";" Names ")"  [function, klabel(deBruijnNs)]

  syntax    BoundName ::= "bound(" Int ")"
//                      | "bound(" Int "," Int ")"          // for several name listens
//                      | "bound(" Int "," Int "," Int ")"  // for several listen joins
  
  syntax     FreeName ::= "free("  Int ")"  // this is only used for analyzing fragments of programs

endmodule

module ALPHA
  import ALPHA-SYNTAX
  import AUXFUN

  configuration
  <T color="purple">
    <k> #deBruijn( 0 ; $PGM:Proc ) </k>
  </T>

  syntax KResult ::= Proc | Name | Bool

// New Name Declarations
  rule #deBruijn( I:Int ; new N:NameVar           in { P:Proc } ) => new bound(I) in { #deBruijn( I +Int 1 ; P[ bound(I) / N ] ) }
  rule #deBruijn( I:Int ; new M:NameVar , N:Name  in { P:Proc } ) => new bound(I) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / M ] ) }
  rule #deBruijn( I:Int ; new M:NameVar , N:Names in { P:Proc } ) => new bound(I) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / M ] ) }
  
  rule new A:Name in { #deBruijn( I:Int ; M:Name ; P:Proc ) } => new A , bound(I) in { #deBruijn( I +Int 1 ; P[ bound(I) / M ] ) }
  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Name  ; P:Proc ) } => new A , bound(I) in { #deBruijn( I +Int 1 ; N ; { P[ bound(I) / M ] } ) }
  rule new A:Name in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ) } => new A , bound(I) in { #deBruijn( I +Int 1 ; N ; { P[ bound(I) / M ] } ) }
  
  rule new A:Names in { #deBruijn( I:Int ; M:Name ; P:Proc ) } => new #append(A ; bound(I)) in { #deBruijn( I +Int 1 ; P[ bound(I) / M ] ) }
  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Name  ; P:Proc ) } => new #append(A ; bound(I)) in { #deBruijn( I +Int 1 ; N ; { P[ bound(I) / M ] } ) }
  rule new A:Names in { #deBruijn( I:Int ; M:Name , N:Names ; P:Proc ) } => new #append(A ; bound(I)) in { #deBruijn( I +Int 1 ; N ; { P[ bound(I) / M ] } ) }

// Ground Terms
  rule #deBruijn( _:Int ; G:Ground ) => G
  rule #deBruijn( _:Int ; Nil ) => Nil

// Parallel Composition
  rule #deBruijn( I:Int ; P:Proc | Q:Proc ) => #deBruijn( I ; P ) | #deBruijn( I ; Q )

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

// Sends
// index constant on name and proc
  rule #deBruijn( I:Int ; X:Name !  ( P:Proc ) ) => #deBruijn(I;X) !  ( #deBruijn( I ; P ) )
  rule #deBruijn( I:Int ; X:Name !! ( P:Proc ) ) => #deBruijn(I;X) !! ( #deBruijn( I ; P ) )

// Evals
// index is constant
  rule #deBruijn( I:Int ; * X:Name ) => * #deBruijn( I ; X )

// Names
  // Bound names do not change
  rule #deBruijn( _:Int ; N:BoundName ) => N

  // Free variables are distinguised from bound ones - should only pertain to fragments of programs...
  rule #deBruijn( I:Int ; _:NameVar ) => free(I)

  // Quotes
  // index increases - this is not the desired semantics...
  rule #deBruijn( I:Int ; @ P:Proc ) => @ #deBruijn( I +Int 1 ; P )

// Several Names
  // want to do something like #deBruijn(I;Y,Z) => #deBruijn(I;Y) , #deBruijn(I;Z) for several names
  // these name lists will only appear in listens, but can't make the appropriate substitutions in the continuation...
  
// Alpha Equivalence Predicate
  // checks synactic equality of De Bruijn index substituted terms
  rule #deBruijn( 0 ; P:Proc #alpha Q:Proc ) => #deBruijn(0;P) ==K #deBruijn(0;Q)

endmodule