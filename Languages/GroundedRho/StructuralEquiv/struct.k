// Structural & Name Equivalence for Grounded Rho Calculus

require "../grho.k"

module STRUCT-SYNTAX
  import DOMAINS
  import GRHO-SYNTAX
  
  syntax   Bool ::= "#structEq("  Proc ";" Proc ")" [function]
                  | "#nameEq("    Name ";" Name ")" [function]
  syntax    Int ::= "#parCount("  Proc ";" Proc ")" [function]
  syntax   Proc ::= "#parRemove(" Proc ";" Proc ")" [function]
  syntax    Set ::= "#setify(" Proc ")"             [function]

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
  rule #parCount( A:Proc ; B:Proc | C:Proc ) => #if A ==K C #then 1 +Int #parCount(A;B) #else #parCount(A;B) #fi
       requires notBool isPar(C)

// removes a nonPar Proc from a Par and preserves order
// first arg intended to be nonPar, second arg is intended to be Par (enforced by #setify)
  // single Proc Par i.e. a nonPar Proc
  rule #parRemove( A:Proc ; B:Proc ) => #if A ==K B #then Nil #else B #fi requires notBool isPar(B)
  // multiple Proc Par
  rule #parRemove( A:Proc ; B:Proc | C:Proc ) => #if A ==K C #then #parRemove(A;B) #else #parRemove(A;B) | C #fi
       requires notBool isPar(C)

// computes par set of a Proc
  // par set of a nonPar Proc contains only one appearance of that Proc
  rule #setify( A:Proc ) => SetItem(A,1) requires notBool isPar(A)
  rule #setify( A:Proc | B:Proc ) 
    => #if B ==K Nil
       #then #setify(A) // Nil is the unit of | -- forget about it!
       #else
         #if #parCount(B;A) >Int 0
         // remove Nil introduced by #parRemove
         #then SetItem(B, 1 +Int #parCount(B;A)) (#setify(#parRemove(B;A)) -Set SetItem(Nil,1))
         #else SetItem(B,1) (#setify(A) -Set SetItem(Nil,1)) 
         #fi 
       #fi requires notBool isPar(B)

// checks par set equlaity of deBruijnified Procs
  rule #structEq( P:Proc ; Q:Proc ) => #setify(#deBruijn(0;P;.Map)) <=Set #setify(#deBruijn(0;Q;.Map))
                                       andBool #setify(#deBruijn(0;Q;.Map)) <=Set #setify(#deBruijn(0;P;.Map))

  rule #nameEq( @P:Proc ; @Q:Proc ) => #structEq(P;Q)
  rule #nameEq( A:Name ; B:Name ) => A ==K B requires notBool isQuote(A)

// For #setify testing
  // configuration inherited from ALPHA (initializes execution with #deBruijn(0;$PGM:Proc;.Map))
  rule #deBruijn(0;S:Set;.Map) => S

endmodule