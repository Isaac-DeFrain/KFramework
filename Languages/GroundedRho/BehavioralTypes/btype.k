// Structural type system for RHO-CALCULUS
// Type = Structural binary tree

require "domains.k"
require "kast.k"
require "substitution.k"
require "../StructuralTypes/stype.k"

module BTYPE-SYNTAX
  import DOMAINS
  import KAST
  import KSEQ-SYMBOLIC
  import SUBSTITUTION
  import STYPE-SYNTAX

  syntax     Bool ::= ProcOrPat "->" ProcOrPat

  syntax     List ::= "#unpar(" ProcOrPat ")"    [function]

  syntax      Set ::= "#red("   ProcOrPat ")"    [function]

  syntax    KItem ::= Proc
                    | ProcPat

endmodule

module BTYPE
  import BTYPE-SYNTAX
  import SET
  import LIST

  configuration
    <T color="teal">
      <k color="purple"> #unpar( $PGM:ProcOrPat ) </k>
    </T>

  syntax KResult ::= Set | List

//--------------------------------
//--- Behavioral Type function ---
//--------------------------------

  rule #unpar( { P:ProcOrPat } ) => #unpar(P)  [strict]

// Base cases - no par
  rule #unpar(   Nil    ) => .List
  rule #unpar( B:Bool   ) => ListItem(B)
  rule #unpar( I:Int    ) => ListItem(I)
  rule #unpar( S:String ) => ListItem(S)

  rule #unpar( for( Y:BindNamePat <- X:Name    ){ P:Proc    } ) => ListItem( for( Y <- X ){P} )
  rule #unpar( for( Y:BindNamePat <- X:NamePat ){ P:Proc    } ) => ListItem( for( Y <- X ){P} )
  rule #unpar( for( Y:BindNamePat <- X:Name    ){ P:ProcPat } ) => ListItem( for( Y <- X ){P} )
  rule #unpar( for( Y:BindNamePat <- X:NamePat ){ P:ProcPat } ) => ListItem( for( Y <- X ){P} )

  rule #unpar( X:Name    ! ( P:Proc    ) ) => ListItem( X!(P) )
  rule #unpar( X:NamePat ! ( P:Proc    ) ) => ListItem( X!(P) )
  rule #unpar( X:Name    ! ( P:ProcPat ) ) => ListItem( X!(P) )
  rule #unpar( X:NamePat ! ( P:ProcPat ) ) => ListItem( X!(P) )

  rule #unpar( * X:Name    ) => ListItem( * X )
  rule #unpar( * X:NamePat ) => ListItem( * X )

  rule #unpar( S:SimpleType ) => ListItem(S)
  rule #unpar( V:ProcVar    ) => ListItem(V)

// Recursive calls
  rule #unpar(   Nil    | Q:Proc    ) => #unpar(Q)
  rule #unpar(   Nil    | Q:ProcPat ) => #unpar(Q)
  rule #unpar( B:Bool   | Q:Proc    ) => ListItem(B) #unpar(Q)
  rule #unpar( B:Bool   | Q:ProcPat ) => ListItem(B) #unpar(Q)
  rule #unpar( I:Int    | Q:Proc    ) => ListItem(I) #unpar(Q)
  rule #unpar( I:Int    | Q:ProcPat ) => ListItem(I) #unpar(Q)
  rule #unpar( S:String | Q:Proc    ) => ListItem(S) #unpar(Q)
  rule #unpar( S:String | Q:ProcPat ) => ListItem(S) #unpar(Q)

  rule #unpar( for( Y:BindNamePat <- X:Name    ){ P:Proc    }    | Q:Proc    ) => ListItem( for( Y <- X ){P} ) #unpar(Q)
  rule #unpar( for( Y:BindNamePat <- X:Name    ){ P:ProcPat }    | Q:Proc    ) => ListItem( for( Y <- X ){P} ) #unpar(Q)
  rule #unpar( for( Y:BindNamePat <- X:NamePat ){ P:Proc    }    | Q:Proc    ) => ListItem( for( Y <- X ){P} ) #unpar(Q)
  rule #unpar( for( Y:BindNamePat <- X:NamePat ){ P:ProcPat }    | Q:Proc    ) => ListItem( for( Y <- X ){P} ) #unpar(Q)
  rule #unpar( for( Y:BindNamePat <- X:Name    ){ P:Proc    }    | Q:ProcPat ) => ListItem( for( Y <- X ){P} ) #unpar(Q)
  rule #unpar( for( Y:BindNamePat <- X:Name    ){ P:ProcPat }    | Q:ProcPat ) => ListItem( for( Y <- X ){P} ) #unpar(Q)
  rule #unpar( for( Y:BindNamePat <- X:NamePat ){ P:Proc    }    | Q:ProcPat ) => ListItem( for( Y <- X ){P} ) #unpar(Q)
  rule #unpar( for( Y:BindNamePat <- X:NamePat ){ P:ProcPat }    | Q:ProcPat ) => ListItem( for( Y <- X ){P} ) #unpar(Q)

  rule #unpar( X:Name    ! ( P:Proc    ) | Q:Proc    ) => ListItem( X!(P) ) #unpar(Q)
  rule #unpar( X:NamePat ! ( P:Proc    ) | Q:Proc    ) => ListItem( X!(P) ) #unpar(Q)
  rule #unpar( X:Name    ! ( P:ProcPat ) | Q:Proc    ) => ListItem( X!(P) ) #unpar(Q)
  rule #unpar( X:NamePat ! ( P:ProcPat ) | Q:Proc    ) => ListItem( X!(P) ) #unpar(Q)
  rule #unpar( X:Name    ! ( P:Proc    ) | Q:ProcPat ) => ListItem( X!(P) ) #unpar(Q)
  rule #unpar( X:NamePat ! ( P:Proc    ) | Q:ProcPat ) => ListItem( X!(P) ) #unpar(Q)
  rule #unpar( X:Name    ! ( P:ProcPat ) | Q:ProcPat ) => ListItem( X!(P) ) #unpar(Q)
  rule #unpar( X:NamePat ! ( P:ProcPat ) | Q:ProcPat ) => ListItem( X!(P) ) #unpar(Q)

  rule #unpar( * X:Name     | Q:Proc    ) => ListItem( * X ) #unpar(Q)
  rule #unpar( * X:NamePat  | Q:Proc    ) => ListItem( * X ) #unpar(Q)
  rule #unpar( * X:Name     | Q:ProcPat ) => ListItem( * X ) #unpar(Q)
  rule #unpar( * X:NamePat  | Q:ProcPat ) => ListItem( * X ) #unpar(Q)

  rule #unpar( S:SimpleType | Q:Proc    ) => ListItem(S) #unpar(Q)
  rule #unpar( S:SimpleType | Q:ProcPat ) => ListItem(S) #unpar(Q)
  rule #unpar( V:ProcVar    | Q:Proc    ) => ListItem(V) #unpar(Q)
  rule #unpar( V:ProcVar    | Q:ProcPat ) => ListItem(V) #unpar(Q)


//  rule Red(  )

endmodule
