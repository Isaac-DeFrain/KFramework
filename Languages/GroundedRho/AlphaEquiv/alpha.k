// De Bruijn Index & Alpha Equivalence for Grounded Rho Calculus

/*
TODO:
 - new declarations of several names should not be nested
 - how to handle several name listens & joins?
*/

require "../grho.k"

module ALPHA-SYNTAX
  import GRHO-SYNTAX
  
  syntax         Proc ::= "#deBruijn(" Int ";" Proc  ")"  [function, klabel(deBruijnP)]
	    | Proc "#alpha" Proc              [klabel(alpha)]

  syntax         Name ::= "#deBruijn(" Int ";" Name  ")"  [function, klabel(deBruijnN)]
//                      | "#deBruijn(" Int "," Int ";" Name ")"  [function, klabel(deBruijnN)]
  
//syntax        Names ::= "#deBruijn(" Int ";" Names ")"  [function, klabel(deBruijnNs)]
//                      | "#deBruijn(" Int "," Int ";" Names ")"  [function, klabel(deBruijnNs)]

  syntax    BoundName ::= "bound(" Int ")"
//                      | "bound(" Int "," Int ")"          // for several name listens
//	    | "bound(" Int "," Int "," Int ")"  // for several listen joins
  
  syntax     FreeName ::= "free("  Int ")"  // this is only used for analyzing fragments of programs
  
  syntax         Name ::= BoundName | FreeName

// Syntax priorities impose rule priorities
  syntax priorities deBruijnN deBruijnP > alpha

endmodule

module ALPHA
  import ALPHA-SYNTAX

  configuration
  <T color="purple">
    <k> #deBruijn( 0 ; $PGM:Proc ) </k>
  </T>

  syntax KResult ::= Proc | Name | Bool

// Declarations of several new names implemented as nested declarations
// this makes it so that new x,y in { P } is alpha equivalent with new x in { new y in { P } }
  rule #deBruijn( I:Int ; new N:Name           in { P:Proc } ) => new bound(I) in { #deBruijn( I +Int 1 ; P[ bound(I) / N ] ) }
  rule #deBruijn( I:Int ; new M:Name , N:Name  in { P:Proc } ) => new bound(I) in { #deBruijn( I +Int 1 ; new N in { P[ bound(I) / M ] } ) }
  rule #deBruijn( I:Int ; new M:Name , N:Names in { P:Proc } ) => new bound(I) in { #deBruijn( I +Int 1 ; new N in { P[ bound(I) / M ] } ) }

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
  rule #deBruijn( I:Int ; for( Y:Chan <- X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <- #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }
  rule #deBruijn( I:Int ; for( Y:Chan <= X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <= #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }
  rule #deBruijn( I:Int ; for( Y:Chan <! X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <! #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }

// Sends
// index constant on name and proc
  rule #deBruijn( I:Int ; X:Name !  ( P:Proc ) ) => #deBruijn(I;X) ! ( #deBruijn( I ; P ) )
  rule #deBruijn( I:Int ; X:Name !! ( P:Proc ) ) => #deBruijn(I;X) ! ( #deBruijn( I ; P ) )

// Evals
// index is constant
  rule #deBruijn( I:Int ; * X:Name ) => * #deBruijn( I ; X )

// Names
  // Bound names do not change
  rule #deBruijn( _:Int ; N:BoundName ) => N

  // Free variables are distinguised from bound ones - only pertains to fragments of programs
  rule #deBruijn( I:Int ; _:NameVar   ) => free(I)

  // Quotes
  // index increases - is this what we want?
  // TODO: more tests
  rule #deBruijn( I:Int ; @ P:Proc ) => @ #deBruijn( I +Int 1 ; P )

// Several Names
  // want to do something like #deBruijn(I;Y,Z) => #deBruijn(I;Y) , #deBruijn(I;Z) for several names
  // these name lists will only appear in listens, but can't make the appropriate substitutions in the continuation...
  
// Alpha Equivalence Predicate
  // checks synactic equality of De Bruijn index substituted terms
  rule #deBruijn( 0 ; P:Proc #alpha Q:Proc ) => #deBruijn(0;P) ==K #deBruijn(0;Q)

endmodule