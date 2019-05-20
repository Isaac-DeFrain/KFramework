// Structural & Name Equivalence for Grounded Rho Calculus

require "../grho.k"
require "../AlphaEquiv/alpha.k"

module STRUCT-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX
  
  syntax   Bool ::= "#structEq("  Proc  ";" Proc  ")" [function]
                  | "#nameEq("    Name  ";" Name  ")" [function]
//                  | "#nameEq("    Names ";" Names ")" [function]
  syntax    Int ::= "#parCount("  Proc  ";" Proc  ")" [function]
  syntax   Proc ::= "#parRemove(" Proc  ";" Proc  ")" [function]
  syntax    Set ::= "#setify("    Proc  ")"           [function]

endmodule

module STRUCT
  import STRUCT-SYNTAX
  import ALPHA

  syntax KResult ::= Proc | Name | Bool

// counts number of appearances of a nonPar Proc in a Par
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #parCount( A:Proc ; B:Proc ) => #if A ==K B #then 1 #else 0 #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #parCount( A:Proc ; B:Proc | C:Proc ) => #if A ==K B #then 1 +Int #parCount(A;C) #else #parCount(A;C) #fi
       requires notBool isPar(B)

// removes a nonPar Proc from a Par and preserves order
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #parRemove( A:Proc ; B:Proc ) => #if A ==K B #then Nil #else B #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #parRemove( A:Proc ; B:Proc | C:Proc ) => #if A ==K B #then #parRemove(A;C) #else B | #parRemove(A;C) #fi
       requires notBool isPar(B)

// computes par set of a Proc
  // par set of a nonPar Proc contains only one appearance of that Proc
  rule #setify( A:Proc ) => SetItem(A,1) requires notBool isPar(A)
  rule #setify( A:Proc | B:Proc ) 
    => #if A ==K Nil
       #then #setify(B) // Nil is the unit of | -- forget about it!
       #else
         #if #parCount(A;B) >Int 0
         // remove Nil introduced by #parRemove
         #then SetItem(A, 1 +Int #parCount(A;B)) (#setify(#parRemove(A;B)) -Set SetItem(Nil,1))
         #else SetItem(A,1) (#setify(B) -Set SetItem(Nil,1)) 
         #fi 
       #fi requires notBool isPar(A)

// checks par set equlaity of deBruijnified Procs
  rule #structEq( P:Proc ; Q:Proc ) => #setify(#deBruijn(0;P;.Map)) <=Set #setify(#deBruijn(0;Q;.Map))
                                       andBool #setify(#deBruijn(0;Q;.Map)) <=Set #setify(#deBruijn(0;P;.Map))

  // mainly for NameVars
  rule #nameEq( A:Name ; B:Name ) => A ==K B requires notBool isQuote(A)
  rule #nameEq( A:Name ; A ) => true
  rule #nameEq( @P:Proc ; @Q:Proc ) => #structEq(P;Q) [owise]
  // several Names
//  rule #nameEq( A:Name , B:Name ; C:Name , D:Name  ) => #nameEq(A;C) andBool #nameEq(B;D)
//  rule #nameEq( A:Name , B:Name ; C:Name , D:Names ) => #nameEq(A;C) andBool #nameEq(B;D)

endmodule