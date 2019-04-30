// De Bruijn Index & Alpha Equivalence for Grounded Rho Calculus

/*
TODO:
 - how to handle several name listens & joins?
 - more tests for substitutions in continuations for listens on chan
*/

require "../../grho.k"

module ALPHA-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX
  
  syntax       DBProc ::= "#deBruijn(" Int ";" NameVar  ";" Proc  ")"
                        | "#deBruijn(" Int ";" NameVars ";" Proc ")"
  
  syntax         Proc ::= "#deBruijn(" Int ";" Proc ")"
                        | "new" NameVar  "in" "{" DBProc "}"
                        | "new" NameVars "in" "{" DBProc "}"
                        | Proc "#alpha" Proc

  syntax         Name ::= "#deBruijn(" Int ";" Name ")"
  syntax      NameVar ::= BoundName
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
    <mem> .Map </mem>
  </T>

  syntax KResult ::= Proc | Name | Bool

// New Name Declarations - update mem map
  rule <k> #deBruijn( I:Int ; new M:NameVar in { P:Proc } )
    => new bound(I) in { #deBruijn( I +Int 1 ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>

  rule <k> #deBruijn( I:Int ; new nv(M:NameVar , N:NameVar)  in { P:Proc } )
    => new bound(I) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>

  rule <k> #deBruijn( I:Int ; new nv(M:NameVar , N:NameVars) in { P:Proc } )
    => new bound(I) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
  
  rule <k> new A:NameVar in { #deBruijn( I:Int ; M:NameVar ; P:Proc ) } 
    => new A , bound(I) in { #deBruijn( I +Int 1 ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires notBool (M in keys(Mem))
  rule <k> new A:NameVar in { #deBruijn( I:Int ; M:NameVar ; P:Proc ) } 
    => new A , bound(I) in { #deBruijn( I +Int 1 ; P[ bound(I) / Mem[M] ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires M in keys(Mem)

  rule <k> new A:NameVar in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVar)  ; P:Proc ) } 
    => new A , bound(I) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires notBool (M in keys(Mem))
  rule <k> new A:NameVar in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVar)  ; P:Proc ) } 
    => new A , bound(I) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / Mem[M] ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires M in keys(Mem)

  rule <k> new A:NameVar in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVars) ; P:Proc ) } 
    => new A , bound(I) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires notBool (M in keys(Mem))
  rule <k> new A:NameVar in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVars) ; P:Proc ) } 
    => new A , bound(I) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / Mem[M] ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires M in keys(Mem)  

  rule <k> new A:NameVars in { #deBruijn( I:Int ; M:NameVar ; P:Proc ) } 
    => new #appendv(A ; bound(I)) in { #deBruijn( I +Int 1 ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires notBool (M in keys(Mem))
  rule <k> new A:NameVars in { #deBruijn( I:Int ; M:NameVar ; P:Proc) } 
    => new #appendv(A ; bound(I)) in { #deBruijn( I +Int 1 ; P[ bound(I) / Mem[M] ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires M in keys(Mem)

  rule <k> new A:NameVars in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVar)  ; P:Proc ) } 
    => new #appendv(A ; bound(I)) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires notBool (M in keys(Mem))
  rule <k> new A:NameVars in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVar)  ; P:Proc ) } 
    => new #appendv(A ; bound(I)) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / Mem[M] ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires M in keys(Mem)

  rule <k> new A:NameVars in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVars) ; P:Proc ) } 
    => new #appendv(A ; bound(I)) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / M ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires notBool (M in keys(Mem))
  rule <k> new A:NameVars in { #deBruijn( I:Int ; nv(M:NameVar , N:NameVars) ; P:Proc ) } 
    => new #appendv(A ; bound(I)) in { #deBruijn( I +Int 1 ; N ; P[ bound(I) / Mem[M] ] ) } ...</k>
       <mem> Mem => updateMap( Mem , M |-> bound(I) ) </mem>
       requires M in keys(Mem)

// Ground Terms
  rule #deBruijn( _:Int ; G:Ground ) => G
  rule #deBruijn( _:Int ; Nil ) => Nil

// Parallel Composition
  rule #deBruijn( I:Int ; P:Proc | Q:Proc ) => #deBruijn(I;P) | #deBruijn(I;Q)

// Receives
  // variables become bound with the appropriate index
  // previously bound variables do not influence listening variables
  rule <k> #deBruijn( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ) 
    => for( bound(I) <- #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P[ bound(I) / Y] ) } ...</k>
       <mem> Mem => updateMap( Mem , Y |-> bound(I) ) </mem>
  rule #deBruijn( I:Int ; for(   <- X:Name ){ P:Proc } ) => for(   <- #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }

  rule <k> #deBruijn( I:Int ; for( Y:NameVar <= X:Name ){ P:Proc } ) 
    => for( bound(I) <= #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P[ bound(I) / Y] ) } ...</k>
       <mem> Mem => updateMap( Mem , Y |-> bound(I) ) </mem>
  rule #deBruijn( I:Int ; for(   <= X:Name ){ P:Proc } ) => for(   <= #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }

  rule <k> #deBruijn( I:Int ; for( Y:NameVar <! X:Name ){ P:Proc } ) 
    => for( bound(I) <! #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P[ bound(I) / Y] ) } ...</k>
       <mem> Mem => updateMap( Mem , Y |-> bound(I) ) </mem>
  rule #deBruijn( I:Int ; for(   <! X:Name ){ P:Proc } ) => for(   <! #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }
  
  // TODO: more tests for substitution in P
  rule #deBruijn( I:Int ; for( Y:Quote <- X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <- #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }
  rule #deBruijn( I:Int ; for( Y:Quote <= X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <= #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }
  rule #deBruijn( I:Int ; for( Y:Quote <! X:Name ){ P:Proc } ) => for( #deBruijn(I;Y) <! #deBruijn(I;X) ){ #deBruijn( I +Int 1 ; P ) }

// Sends
// index and map constant on name and proc
  rule #deBruijn( I:Int ; X:Name !  ( P:Proc ) ) => #deBruijn(I;X) !  ( #deBruijn(I;P) )
  rule #deBruijn( I:Int ; X:Name !! ( P:Proc ) ) => #deBruijn(I;X) !! ( #deBruijn(I;P) )

// Evals
// index is constant
  rule #deBruijn( I:Int ; * X:Name ) => * #deBruijn(I;X)

// Names
  // Bound names do not change // TODO: what should happen with the memory here?
  rule #deBruijn( _:Int ; N:BoundName ) => N

  // Free variables are distinguised from bound ones - should only pertain to fragments of programs...
  // TODO: relation to mem map
  rule #deBruijn( I:Int ; N:NameVar ) => free(I)

  // Quotes
  // index increases - this is not the desired semantics...
  rule #deBruijn( I:Int ; @ P:Proc ) => @ #deBruijn(I;P)

// Several Names
  // want to do something like #deBruijn(I;Y,Z) => #deBruijn(I;Y) , #deBruijn(I;Z) for several names
  // these name lists will only appear in listens, but can't make the appropriate substitutions in the continuation...
  
// Alpha Equivalence Predicate
  // checks synactic equality of De Bruijn index substituted terms
  syntax Bool ::= Proc "<=>" Proc [strict(1,2)]
  rule P:Proc <=> Q:Proc => P ==K Q
  rule #deBruijn( I:Int ; P:Proc #alpha Q:Proc) => #deBruijn(I;P) <=> #deBruijn(I;Q)

endmodule