// RHO CALCULUS with additional Ground terms

require "domains.k"
require "substitution.k"

module FREENAME-SYNTAX
import DOMAINS
import SET
import SUBSTITUTION


//-------------
//--- NAMES ---
//-------------
syntax       Var ::= Id

syntax      Name ::= Var                                           // Var: Id     -> Name (Name variable)
                   | "@" Proc                            [strict]  // Quote: Proc -> Name
                   | "{" Name "}"                       [bracket]

//-----------------
//--- PROCESSES ---
//-----------------
syntax      Proc ::= "{" Proc "}"                       [bracket]
                   | "Nil"                                         // Stop: -> Proc
                   | Ground                                        // Bool, Int, String
                   | Exp                                           // Bool, Int, String expressions
                   | Receive                                       // Receive
                   | Send                                          // Send
                   | Reify                                         // Reify/evaluate
                   > Par                                           // Par

syntax       Par ::= Proc "|" Proc                         [left]  // Par: Proc*Proc -> Proc

syntax   Receive ::= Name "(" Name ")"  "{" Proc "}"  [binder(2)]  // Rec: Name*Name*Proc -> Proc

syntax      Send ::= Name "!" "(" Proc ")"            [strict(2)]  // Send: Name*Proc -> Proc

syntax     Reify ::= "*" Name

// Sets
syntax       Set ::= "FN" "(" Proc ")"                 [function]
                   | "(" Set ")"                        [bracket]

// GROUND TERMS
syntax    Ground ::= Int | Bool | String                           //Int, Bool, and String ground terms

// Expressions - resolve to ground term
syntax       Exp ::= AExp | BExp

// Arithmetic
syntax      AExp ::= Int
                   | "(" AExp ")"  [bracket]
                   | Reify                    //for interesting message passing: x(y){ *y + 5 }
                   | String                   // S1 + S2 => S1 +String S2
                   | Set
                   | AExp "+" AExp  [strict]
                   | AExp "-" AExp  [strict]
                   | AExp "*" AExp  [strict]

// Boolean
syntax      BExp ::= Bool
                   | "(" BExp ")"      [bracket]
                   | Reify
                   | String
                   | Set
                   | AExp "<=" AExp  [seqstrict]
                   | "not" BExp         [strict]
                   | BExp "&&" BExp  [strict(1)]

// Alpha Equivalence
syntax      Bool ::= Set "==" Set      [strict]

// Structural Equivalence
syntax      Bool ::= Proc "equiv" Proc   [left]

//syntax KVariable ::= Name
syntax     KItem ::= Name

endmodule


module FREENAME
import FREENAME-SYNTAX
import SUBSTITUTION

  configuration
    <T>
      <k> $PGM:Set </k>
    </T>

syntax KResult ::= Ground | Reify | Set

// Free name equality
rule S1:Set == S2:Set => (S1 <=Set S2) && (S2 <=Set S1)

// Arithmetic
rule I1:Int + I2:Int => I1 +Int I2
rule I1:Int - I2:Int => I1 -Int I2
rule I1:Int * I2:Int => I1 *Int I2

// Boolean
rule I1:Int <= I2:Int => I1 <=Int I2
rule not B:Bool => notBool B
rule true && B:Bool => B
rule false && _ => false

// Set
rule S1:Set +  S2:Set => S1 S2
rule S1:Set -  S2:Set => S1 -Set S2
rule S1:Set *  S2:Set => intersectSet(S1,S2)
rule S1:Set <= S2:Set => S1 <=Set S2

// String
rule S1:String + S2:String => S1 +String S2

// Free & Bound Names
rule FN( Nil )      => .Set
rule FN( _:Bool   ) => .Set
rule FN( _:Int    ) => .Set
rule FN( _:String ) => .Set

rule FN( X:Name ( Y:Name )  { P:Proc } ) => SetItem(X) (FN(P) -Set SetItem(Y))

rule FN( X:Name ! ( P:Proc ) )           => FN(P) SetItem(X)

rule FN( P:Proc | Q:Proc )               => FN(P) FN(Q)

rule FN( * X:Name )                      => SetItem(X)

rule FN( A1:AExp +  A2:AExp )            => FN(A1) FN(A2)
rule FN( A1:AExp -  A2:AExp )            => FN(A1) FN(A2)
rule FN( A1:AExp *  A2:AExp )            => FN(A1) FN(A2)
rule FN( A1:AExp <= A2:AExp )            => FN(A1) FN(A2)

rule FN( not B:BExp )                    => FN(B)
rule FN( B1:BExp && B2:BExp )            => FN(B1) FN(B2)

endmodule
