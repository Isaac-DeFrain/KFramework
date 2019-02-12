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

  syntax      Red ::= "#red("   ProcOrPat ")"    [function]

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
  rule #unpar(   Nil        ) => .List
  rule #unpar( B:Bool       ) => ListItem(B)
  rule #unpar( I:Int        ) => ListItem(I)
  rule #unpar( S:String     ) => ListItem(S)

  rule #unpar( R:Receive    ) => ListItem(R)
  rule #unpar( R:ReceivePat ) => ListItem(R)

  rule #unpar( S:Send       ) => ListItem(S)
  rule #unpar( S:SendPat    ) => ListItem(S)

  rule #unpar( R:Reify      ) => ListItem(R)
  rule #unpar( R:ReifyPat   ) => ListItem(R)

  rule #unpar( S:SimpleType ) => ListItem(S)
  rule #unpar( V:ProcVar    ) => ListItem(V)

// Recursive calls
  rule #unpar( P:Proc    | Q:Proc    ) => #unpar(P) #unpar(Q)  [strict]
  rule #unpar( P:ProcPat | Q:Proc    ) => #unpar(P) #unpar(Q)  [strict]
  rule #unpar( P:Proc    | Q:ProcPat ) => #unpar(P) #unpar(Q)  [strict]
  rule #unpar( P:ProcPat | Q:ProcPat ) => #unpar(P) #unpar(Q)  [strict]

//  rule Red(  )

endmodule
