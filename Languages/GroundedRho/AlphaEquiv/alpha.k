// Alpha Equivalence for Grounded Rho Calculus

require "../grho.k"

module ALPHA-SYNTAX
  import GRHO-SYNTAX
  
  syntax   ProcOrName ::= Proc | Name
  
  syntax         Proc ::= "#bound(" Int ";" Proc ")"   [function]

  syntax         Name ::= "#bound(" Int ";" Name ")"   [function]

  syntax    BoundName ::= "bound(" Int ")"
  
  syntax     FreeName ::= "free("  Int ")"
  
  syntax         Name ::= BoundName | FreeName
  
  syntax         Bool ::= Proc "#alpha" Proc
  
  syntax       String ::= "toString(" Proc ")"

endmodule

module ALPHA
  import ALPHA-SYNTAX

  configuration
  <T color="purple">
    <k> #bound( 0 ; $PGM:Proc ) </k>
  </T>

  syntax KResult ::= Proc | Name
  
  rule #bound( _:Int ; G:Ground ) => G
  rule #bound( _:Int ; Nil ) => Nil

  rule #bound( I:Int ; P:Proc | Q:Proc ) => #bound( I ; P ) | #bound( I ; Q )

  rule #bound( I:Int ; for( Y:NameVar <- X:Name ){ P:Proc } ) => for( bound(I) <- X ){ #bound( I +Int 1 ; P[ bound(I) / Y] ) }

  rule #bound( I:Int ; X:Name ! ( P:Proc ) ) => X ! ( #bound( I ; P ) )
  
  rule #bound( I:Int ; * X:Name ) => * #bound( I ; X )
  
  rule #bound( _:Int ; N:FreeName  ) => N
  rule #bound( _:Int ; N:BoundName ) => N
  rule #bound( I:Int ; X:NameVar   ) => free(I)
  rule #bound( I:Int ; @ P:Proc ) => @ #bound( I ; P )
  
  rule #bound( 0 ; P:Proc #alpha Q:Proc ) => toString( #bound(0;P) ) ==String toString( #bound(0;Q) )

endmodule