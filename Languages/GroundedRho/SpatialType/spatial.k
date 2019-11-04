// Spatial type function for Rholang

require "../grho.k"

module SPATIAL-SYNTAX
  import GRHO-SYNTAX

// Spatial type function
  syntax     NamePat ::= "#spatialType(" NamePat  ")" [function]
  syntax    NamePats ::= "#spatialType(" NamePats ")" [function]

  syntax     ProcPat ::= "#spatialType(" ProcPat  ")" [function]
  syntax    ProcPats ::= "#spatialType(" ProcPats ")" [function]

  // RhoKVPairs
  syntax    RhoKVPat ::= "#spatialType(" RhoKVPat  ")" [function]
  syntax   RhoKVPats ::= "#spatialType(" RhoKVPats ")" [function]

  // syntax       KItem ::= IndexedSet | IndexedProcs | ProcPat

endmodule

module SPATIAL
  import SPATIAL-SYNTAX

  syntax KResult ::= NamePat | NamePats | ProcPat | ProcPats

// Names
  rule #spatialType( @A:ProcPat ) => @#spatialType(A)

// TODO: variables(?)

  // Multi
  rule #spatialType( A:NamePat , B:NamePats ) => #spatialType(A) , #spatialType(B)

// Procs
  // Simple types
  rule #spatialType(   Nil         ) => Unit
  rule #spatialType( _:Bool        ) => Bool
  rule #spatialType( _:Int         ) => Int
  rule #spatialType( _:String      ) => String
  rule #spatialType( _:Unforgeable ) => Unforgeable
  rule #spatialType( _:Uri         ) => Uri

  // Eval
  rule #spatialType( *A:NamePat ) => *#spatialType(A)

  // Send
  rule #spatialType( A:NamePat !  ( )            ) => #spatialType(A) !  ( )
  rule #spatialType( A:NamePat !  ( B:ProcPats ) ) => #spatialType(A) !  ( #spatialType(B) )
  rule #spatialType( A:NamePat !! ( )            ) => #spatialType(A) !! ( )
  rule #spatialType( A:NamePat !! ( B:ProcPats ) ) => #spatialType(A) !! ( #spatialType(B) )

  // Receive
  // rule #spatialType( for( ??? ){ ... } ) => ???

  // Contract
  rule #spatialType( contract A:NamePat ( ) = { C:ProcPat } ) => contract #spatialType(A) ( ) = { #spatialType(C) }
  rule #spatialType( contract A:NamePat ( B:NamePats ) = { C:ProcPat } )
    => contract #spatialType(A) ( #spatialType(B) ) = { #spatialType(C) }

  // Invocation
  rule #spatialType( A:NamePat ( )            ) => #spatialType(A) ( )
  rule #spatialType( A:NamePat ( B:NamePats ) ) => #spatialType(A) ( #spatialType(B) )

  // Par
  rule #spatialType( A:ProcPat | B:ProcPat ) => #spatialType(A) | #spatialType(B)
       requires notBool isParPat(A)

  // TODO: Match, Select

  // Collection
    // RhoList
  rule #spatialType( [ ] ) => EmptyListPat
  rule #spatialType( [ A:ProcPats ] ) => [ #spatialType(A) ]

    // RhoMap
  rule #spatialType( { } ) => EmptyMapPat
  rule #spatialType( { A:RhoKVPats } ) => { #spatialType(A) }
    // RhoKVPairs
  rule #spatialType( A:ProcPat  : B:ProcPat   ) => #spatialType(A) : #spatialType(B)
  rule #spatialType( A:RhoKVPat , B:RhoKVPats ) => #spatialType(A) , #spatialType(B)

    // RhoSet
  rule #spatialType( Set( ) ) => EmptySetPat
  rule #spatialType( Set( A:ProcPats ) ) => Set( #spatialType(A) )

    // RhoTuple
  rule #spatialType( ( A:ProcPats ,) ) => ( #spatialType(A) ,)

  // VarRef
  // rule #spatialType( = *A:NamePat ) => =*#spatialType(A)
  // rule #spatialType( =  A:ProcPat ) => = #spatialType(A) requires notBool isEvalPat(A)

  // Conditional
  rule #spatialType( if ( A:BExp ) B:ProcPat ) => if ( A ) #spatialType(B)
  rule #spatialType( if ( A:BExp ) B:ProcPat else C:ProcPat ) => if ( A ) #spatialType(B) else #spatialType(C)

  // Method
  rule #spatialType( A:ProcPat . B:Method ( )            ) => #spatialType(A).B( )
  rule #spatialType( A:ProcPat . B:Method ( C:ProcPats ) ) => #spatialType(A).B( #spatialType(C) )

  // Bundle
  rule #spatialType( bundle+{ A:ProcPat } ) => bundle+{ #spatialType(A) }
  rule #spatialType( bundle-{ A:ProcPat } ) => bundle-{ #spatialType(A) }
  rule #spatialType( bundle0{ A:ProcPat } ) => bundle0{ #spatialType(A) }
  rule #spatialType(  bundle{ A:ProcPat } ) =>  bundle{ #spatialType(A) }

  // TODO: New(?), Exp(?), LetExp(?)

  // Multi
  rule #spatialType( A:ProcPat , B:ProcPats ) => #spatialType(A) , #spatialType(B)

//------------------
//--- Structural ---
//------------------
// Nil = unit of |
  rule Nil       | A:ProcPat => A [anywhere, structural]
  rule A:ProcPat | Nil       => A [anywhere, structural]
// @* = Id_NamePat & *@ = Id_ProcPat
  rule @ * A:NamePat => A [anywhere, structural]
  rule * @ A:ProcPat => A [anywhere, structural]
// ~~ = Id_ProcPat
  rule ~ ~ A:ProcPat => A [anywhere, structural]

endmodule
