// Alpha Equivalence for Grounded Rho Calculus

require "../grho.k"

module ALPHA-SYNTAX
  import GRHO-SYNTAX
  
  syntax         Proc ::= "#bound(" Int ";" Proc ")"   [function, klabel(boundP)]

  syntax         Name ::= "#bound(" Int ";" Name ")"   [function, klabel(boundN)]

  syntax    BoundName ::= "bound(" Int ")"
  
  syntax     FreeName ::= "free("  Int ")"
  
  syntax         Name ::= BoundName | FreeName
  
  syntax         Bool ::= Proc "#alpha" Proc           [function, klabel(alpha)]

// Syntax priorities impose rule priorities
  syntax priorities boundN boundP > alpha

endmodule

module ALPHA
  import ALPHA-SYNTAX

  configuration
  <T color="purple">
    <k> #bound( 0 ; $PGM:Proc ) </k>
  </T>

  syntax KResult ::= Proc | Name | Bool
  
  rule #bound( I:Int ; new N:Name           in { P:Proc } ) => #bound( I +Int 1 ; P[ bound(I) / N ] )
  rule #bound( I:Int ; new M:Name , N:Name  in { P:Proc } ) => #bound( I +Int 1 ; new N in { P[ bound(I) / M ] } )
  rule #bound( I:Int ; new M:Name , N:Names in { P:Proc } ) => #bound( I +Int 1 ; new N in { P[ bound(I) / M ] } )
  
  rule #bound( _:Int ; G:Ground ) => G
  rule #bound( _:Int ; Nil ) => Nil

  rule #bound( I:Int ; P:Proc | Q:Proc ) => #bound( I ; P ) | #bound( I ; Q )

  rule #bound( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ) => for( bound(I) <- #bound(I;X) ){ #bound( I +Int 1 ; P[ bound(I) / Y] ) }
  
  // TODO: more tests for substitution in P
  rule #bound( I:Int ; for( Y:Chan <- X:Name ){ P:Proc } ) => for( #bound(I;Y) <- #bound(I;X) ){ #bound( I +Int 1 ; P ) }
  rule #bound( I:Int ; for(        <- X:Name ){ P:Proc } ) => for(             <- #bound(I;X) ){ #bound( I +Int 1 ; P ) }

  rule #bound( I:Int ; X:Name ! ( P:Proc ) ) => #bound(I;X) ! ( #bound( I ; P ) )
  
  rule #bound( I:Int ; * X:Name ) => * #bound( I ; X )

  rule #bound( _:Int ; N:BoundName   ) => N
  rule #bound( I:Int ; _:Unforgeable ) => bound(I)
  rule #bound( I:Int ; X:NameVar     ) => free(I)
  
// Quoting increases count
  rule #bound( I:Int ; @ P:Proc      ) => @ #bound( I +Int 1 ; P )
  
// Alpha Equivalence Predicate
  rule #bound( 0 ; P:Proc #alpha Q:Proc ) => #bound(0;P) ==K #bound(0;Q)

endmodule