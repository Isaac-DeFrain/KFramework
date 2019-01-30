// RHO CALCULUS with additional Ground terms

require "domains.k"
require "substitution.k"

module NAMEVAR-SYNTAX
import DOMAINS
import SET
import SUBSTITUTION


//-------------
//--- NAMES ---
//-------------

// Variables
syntax       Var ::= Id

// Quoted Process
syntax     Quote ::= "@" Proc                            [strict]  // Quote: Proc -> Name

// Names
syntax      Name ::= Var                                           // Var: Id     -> Name (Name variable)
                   | Quote
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
syntax       Set ::= "FN(" Proc ")"                    [function]  // free names
                   | "FV(" Proc ")"                    [function]  // free variables
                   | "BN(" Proc ")"                    [function]  // bound names
                   | "BV(" Proc ")"                    [function]  // bound variables
                   | "RN(" Proc ")"                    [function]  // receive names
                   | "RC(" Proc ")"                    [function]  // receive channels
                   | "RV(" Proc ")"                    [function]  // receive variables
                   | "SN(" Proc ")"                    [function]  // send names
                   | "SC(" Proc ")"                    [function]  // send channels
                   | "SV(" Proc ")"                    [function]  // send variables
                   |  "N(" Proc ")"                    [function]  // names
                   |  "V(" Proc ")"                    [function]  // variables
                   |  "Q(" Proc ")"                    [function]  // quoted
                   | "CH(" Proc ")"                    [function]  // channels
                   | "PP(" Proc ")"                    [function]  // process patterns
                   | "NP(" Proc ")"                    [function]  // name patterns
                   |   "(" Set  ")"                     [bracket]

//syntax       Int ::= "howMany" "(" Set ")"             [strict]

// GROUND TERMS
syntax    Ground ::= Int | Bool | String | Set                     //Int, Bool, and String ground terms

// Expressions - resolve to ground term
syntax       Exp ::= AExp | BExp

//syntax       Int ::= "sizeSet" "(" Set ")"           [function]

// Arithmetic
syntax      AExp ::= Int
                   | "(" AExp ")"                       [bracket]
                   | Reify                                         //for interesting message passing: x(y){ *y + 5 }
                   | String
                   | Set
                   | AExp "+" AExp                       [strict]
                   | AExp "-" AExp                       [strict]
                   | AExp "*" AExp                       [strict]

// Boolean
syntax      BExp ::= Bool
                   | "(" BExp ")"                       [bracket]
                   | Reify
                   | String
                   | Set
                   | AExp "<=" AExp                   [seqstrict]
                   | AExp "==" AExp                      [strict]
                   | "not" BExp                          [strict]
                   | BExp "&&" BExp                   [strict(1)]
                   | BExp "==" BExp                      [strict]

// For sets...
syntax     KItem ::= Name | Var | Proc

endmodule


module NAMEVAR
import NAMEVAR-SYNTAX
import SUBSTITUTION

  configuration
    <T>
      <k> $PGM:Ground </k>
    </T>

syntax KResult ::= Ground | Reify

// Arithmetic
rule I1:Int  + I2:Int => I1  +Int I2
rule I1:Int  - I2:Int => I1  -Int I2
rule I1:Int  * I2:Int => I1  *Int I2
rule I1:Int <= I2:Int => I1 <=Int I2
rule I1:Int == I2:Int => I1 ==Int I2

// Boolean
rule not B:Bool         => notBool B
rule true && B:Bool     => B
rule false && _         => false
rule B1:Bool == B2:Bool => B1 ==Bool B2

// Set
rule S1:Set +  S2:Set  => S1 S2
rule S1:Set -  S2:Set  => S1 -Set S2
rule S1:Set *  S2:Set  => intersectSet(S1,S2)
rule S1:Set <= S2:Set  => S1 <=Set S2
rule S1:Set == S2:Set  => (S1 <=Set S2) && (S2 <=Set S1)
//rule howMany ( S:Set ) => size(S)

// String
rule S1:String  + S2:String => S1  +String S2
rule S1:String == S2:String => S1 ==String S2

// Name set
rule N(   Nil    ) => .Set
rule N( _:Bool   ) => .Set
rule N( _:Int    ) => .Set
rule N( _:String ) => .Set

rule N( X:Name ( Y:Name )  { P:Proc } )  => SetItem(X) SetItem(Y) N(P)

rule N( X:Name ! ( P:Proc ) )            => SetItem(X) N(P)

rule N( P:Proc | Q:Proc )                => N(P) N(Q)

rule N( * X:Name )                       => SetItem(X)

rule N( A1:AExp  + A2:AExp )             => N(A1) N(A2)
rule N( A1:AExp  - A2:AExp )             => N(A1) N(A2)
rule N( A1:AExp  * A2:AExp )             => N(A1) N(A2)

rule N( not B:BExp )                     => N(B)
rule N( B1:BExp && B2:BExp )             => N(B1) N(B2)

// Free Name set
rule FN(   Nil    ) => .Set
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

// Bound Name set
rule BN( P:Proc ) => N(P) -Set FN(P)

// Variable set
rule V(   Nil    ) => .Set
rule V( _:Bool   ) => .Set
rule V( _:Int    ) => .Set
rule V( _:String ) => .Set

rule V( X:Var   ( Y:Var   )  { P:Proc } )  => SetItem(X) SetItem(Y) V(P)
rule V( X:Var   ( _:Quote )  { P:Proc } )  => SetItem(X) V(P)
rule V( _:Quote ( Y:Var   )  { P:Proc } )  => SetItem(Y) V(P)
rule V( _:Quote ( _:Quote )  { P:Proc } )  => V(P)

rule V( X:Var   ! ( P:Proc ) )             => SetItem(X) V(P)
rule V( _:Quote ! ( P:Proc ) )             => V(P)

rule V( P:Proc | Q:Proc )                  => V(P) V(Q)

rule V( * X:Var   )                        => SetItem(X)
rule V( * _:Quote )                        => .Set

rule V( A1:AExp  + A2:AExp )               => V(A1) V(A2)
rule V( A1:AExp  - A2:AExp )               => V(A1) V(A2)
rule V( A1:AExp  * A2:AExp )               => V(A1) V(A2)

rule V( not B:BExp )                       => V(B)
rule V( B1:BExp && B2:BExp )               => V(B1) V(B2)

// Bound Variable set
rule BV( P:Proc ) => intersectSet( BN(P) , V(P) )

// Free Variable set
rule FV( P:Proc ) => intersectSet( FN(P) , V(P) )

// Quoted set
rule Q( P:Proc )  => N(P) -Set V(P)

// Channel set
rule CH(   Nil    ) => .Set
rule CH( _:Bool   ) => .Set
rule CH( _:Int    ) => .Set
rule CH( _:String ) => .Set

rule CH( X:Quote ( _:Name )  { P:Proc } )  => SetItem(X) CH(P)
rule CH( _:Var   ( _:Name )  { P:Proc } )  => CH(P)

rule CH( X:Quote ! ( P:Proc ) )            => SetItem(X) CH(P)
rule CH( _:Var   ! ( P:Proc ) )            => CH(P)

rule CH( P:Proc | Q:Proc )                 => CH(P) CH(Q)

rule CH( * X:Quote )                       => SetItem(X)
rule CH( * _:Var   )                       => .Set

rule CH( A1:AExp  + A2:AExp )              => CH(A1) CH(A2)
rule CH( A1:AExp  - A2:AExp )              => CH(A1) CH(A2)
rule CH( A1:AExp  * A2:AExp )              => CH(A1) CH(A2)

rule CH( not B:BExp )                      => CH(B)
rule CH( B1:BExp && B2:BExp )              => CH(B1) CH(B2)

// Process Pattern set
rule PP(   Nil    ) => .Set
rule PP( _:Bool   ) => .Set
rule PP( _:Int    ) => .Set
rule PP( _:String ) => .Set

rule PP( _:Name ( @P:Proc )  { Q:Proc } )  => SetItem(P) PP(Q)
rule PP( _:Name (  _:Var  )  { Q:Proc } )  => PP(Q)

rule PP( _:Name ! ( Q:Proc ) )             => PP(Q)

rule PP( P:Proc | Q:Proc )                 => PP(P) PP(Q)

rule PP( * @P:Proc )                       => SetItem(P)
rule PP( * _:Var   )                       => .Set

rule PP( A1:AExp  + A2:AExp )              => PP(A1) PP(A2)
rule PP( A1:AExp  - A2:AExp )              => PP(A1) PP(A2)
rule PP( A1:AExp  * A2:AExp )              => PP(A1) PP(A2)

rule PP( not B:BExp )                      => PP(B)
rule PP( B1:BExp && B2:BExp )              => PP(B1) PP(B2)

// Name Pattern set - will need to change when other patterns are introduced
rule NP( P:Proc ) => V(P)

// Receive Name set
rule RN(   Nil    ) => .Set
rule RN( _:Bool   ) => .Set
rule RN( _:Int    ) => .Set
rule RN( _:String ) => .Set

rule RN( X:Name ( _:Name )  { P:Proc } )  => SetItem(X) RN(P)

rule RN( _:Name ! ( P:Proc ) )            => RN(P)

rule RN( P:Proc | Q:Proc )                => RN(P) RN(Q)

rule RN( * @P:Proc )                      => RN(P)
rule RN( * _:Var   )                      => .Set

rule RN( A1:AExp  + A2:AExp )             => RN(A1) RN(A2)
rule RN( A1:AExp  - A2:AExp )             => RN(A1) RN(A2)
rule RN( A1:AExp  * A2:AExp )             => RN(A1) RN(A2)

rule RN( not B:BExp )                     => RN(B)
rule RN( B1:BExp && B2:BExp )             => RN(B1) RN(B2)

// Receive Variable set
rule RV(   Nil    ) => .Set
rule RV( _:Bool   ) => .Set
rule RV( _:Int    ) => .Set
rule RV( _:String ) => .Set

rule RV( X:Var   ( _:Name )  { P:Proc } )   => SetItem(X) RV(P)
rule RV( _:Quote ( _:Name )  { P:Proc } )   => RV(P)

rule RV( _:Name ! ( P:Proc ) )              => RV(P)

rule RV( P:Proc | Q:Proc )                  => RV(P) RV(Q)

rule RV( * @P:Proc )                        => RV(P)
rule RV( * _:Var   )                        => .Set

rule RV( A1:AExp  + A2:AExp )               => RV(A1) RV(A2)
rule RV( A1:AExp  - A2:AExp )               => RV(A1) RV(A2)
rule RV( A1:AExp  * A2:AExp )               => RV(A1) RV(A2)

rule RV( not B:BExp )                       => RV(B)
rule RV( B1:BExp && B2:BExp )               => RV(B1) RV(B2)

// Send Name set
rule SN(   Nil    ) => .Set
rule SN( _:Bool   ) => .Set
rule SN( _:Int    ) => .Set
rule SN( _:String ) => .Set

rule SN( _:Name ( _:Name )  { P:Proc } )  => SN(P)

rule SN( X:Name ! ( P:Proc ) )            => SetItem(X) SN(P)

rule SN( P:Proc | Q:Proc )                => SN(P) SN(Q)

rule SN( * @P:Proc )                      => SN(P)
rule SN( * _:Var   )                      => .Set

rule SN( A1:AExp  + A2:AExp )             => SN(A1) SN(A2)
rule SN( A1:AExp  - A2:AExp )             => SN(A1) SN(A2)
rule SN( A1:AExp  * A2:AExp )             => SN(A1) SN(A2)

rule SN( not B:BExp )                     => SN(B)
rule SN( B1:BExp && B2:BExp )             => SN(B1) SN(B2)

// Send Variable set
rule SV(   Nil    ) => .Set
rule SV( _:Bool   ) => .Set
rule SV( _:Int    ) => .Set
rule SV( _:String ) => .Set

rule SV( _:Name ( _:Name )  { P:Proc } )  => SV(P)

rule SV( X:Var   ! ( P:Proc ) )           => SetItem(X) SV(P)
rule SV( _:Quote  ! ( P:Proc ) )          => SV(P)

rule SV( P:Proc | Q:Proc )                => SV(P) SV(Q)

rule SV( * @P:Proc )                      => SV(P)
rule SV( * _:Var   )                      => .Set

rule SV( A1:AExp  + A2:AExp )             => SV(A1) SV(A2)
rule SV( A1:AExp  - A2:AExp )             => SV(A1) SV(A2)
rule SV( A1:AExp  * A2:AExp )             => SV(A1) SV(A2)

rule SV( not B:BExp )                     => SV(B)
rule SV( B1:BExp && B2:BExp )             => SV(B1) SV(B2)

// Receive Channel set
rule RC( P:Proc ) => intersectSet( RN(P) , CH(P) )

// Send Channel set
rule SC( P:Proc ) => intersectSet( SN(P) , CH(P) )

endmodule
