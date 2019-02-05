// RHO CALCULUS with additional Ground terms

require "domains.k"
require "kast.k"
require "substitution.k"

module NAMEVAR-SYNTAX
import DOMAINS
import KAST
import KSEQ-SYMBOLIC
import SET
import SUBSTITUTION

//************************************
//*** Grounded Rho-Calculus Syntax ***
//************************************

syntax              Var ::= Id                                                     // Id < Var, General Variables

//-------------
//--- NAMES ---
//-------------

// Channels
syntax             Name ::= "{" Name "}"                                [bracket]  // {_}: Name ---> Name
                          | "@" Proc                                     [strict]  // @: Proc -----> Name

// Name Variables
syntax          NameVar ::= Var                                 [klabel(namevar)]  // Var < NameVar
// Name Patterns
syntax          NamePat ::= "{" NamePat "}"                             [bracket]  //   {_}: NamePat ---> NamePat
                          | NameVar                                                //           NameVar < NamePat
                          | "@" ProcPat                                            //   @: ProcPat -----> NamePat

syntax        NameOrPat ::= "{" NameOrPat "}"                                      // {_}: NameOrPat ---> NameOrPat
                          | Name                                                   //              Name < NameOrPat
                          | NamePat                                                //           NamePat < NameOrPat

//-----------------
//--- PROCESSES ---
//-----------------

// Process Variables
syntax          ProcVar ::= Var                                 [klabel(procvar)]  // Var < ProcVar

// Processes
syntax             Proc ::= "{" Proc "}"                                [bracket]  // {_}: Proc -> Proc
                          | "Nil"                                                  //        Nil < Proc
                          | Ground                                                 //     Ground < Proc
                          | Receive                                                //    Receive < Proc
                          | Send                                                   //       Send < Proc
                          | Reify                                                  //      Reify < Proc
                          | Exp
                          > Par                                                    //        Par < Proc

// Par
syntax              Par ::= Proc "|" Proc                              [left,par]  // _|_: Proc x Proc ----------------> Par

// Receive
syntax          Receive ::= "for" "(" Bind ")" "{" Proc    "}"   [binder,receive]  // for(_){_}: Bind x Proc ------> Receive
                                                                                                                              // requires ProcPat[N / BindNamePat] to be concrete when N:Name
syntax             Bind ::= BindNamePat "<-" Name                          [bind]  // _<-_: NamePat x Name -----------> Bind  // e.g. for( y <- @Nil ){ y!("hi") } is a Proc because
                                                                                                                              // BindNamePat = y and ProcPat = y!("hi") thus
syntax      BindNamePat ::= NamePat                                                // NamePat < BindNamePat                   // {y!("hi")}[N / y] = N!("hi") is a concrete process

// Send
syntax             Send ::= Name "!" "(" Proc ")"                [strict(2),send]  // _!(_): Name x Proc -------------> Send

// Reify
syntax            Reify ::= "*" Name                                      [reify]  // *: Name -----------------------> Reify

// Ground terms
syntax           Ground ::= Bool                                                   //   Bool < Ground
                          | Int                                                    //    Int < Ground
                          | String                                                 // String < Ground

//syntax      KVariable ::= Proc | ProcPat

//syntax        Pattern ::= ProcPat

//------------------------
//--- Process Patterns ---
//------------------------

// Par Pattern
syntax           ParPat ::= Proc    "|" ProcPat                            [left]  //    _|_: Proc x ProcPat ---------> ParPat
                          | ProcPat "|" Proc                               [left]  // _|_: ProcPat x Proc ------------> ParPat
                          | ProcPat "|" ProcPat                            [left]  // _|_: ProcPat x ProcPat ---------> ParPat

syntax         ParOrPat ::= Par                                                    //     Par < ParOrPat
                          | ParPat                                                 //  ParPat < ParOrPat

// Receive Pattern
syntax       ReceivePat ::= "for" "(" Bind    ")" "{" ProcPat "}"        [binder]  // for(_){_}: Bind x ProcPat -----> ProcPat  // requires ProcPat[Name / BindNamePat] to be a process pattern?
                          | "for" "(" BindPat ")" "{" ProcPat "}"        [binder]  // for(_){_}: Bind x ProcPat -----> ProcPat

syntax     ReceiveOrPat ::= Receive                                                //    Receive < ReciveOrPat
                          | ReceivePat                                             // ReceivePat < ReciveOrPat

syntax          BindPat ::= BindNamePat "<-" NamePat                               // _<-_: BindNamePat x NamePat ---> BindPat

syntax        BindOrPat ::= Bind                                                   //    Bind < BindOrPat
                          | BindPat                                                // BindPat < BindOrPat

// Send Pattern
syntax          SendPat ::= Name    "!" "(" ProcPat ")"                            //    _!(_): Name x ProcPat ------> SendPat
                          | NamePat "!" "(" ProcPat ")"                            // _!(_): NamePat x ProcPat ------> SendPat
                          | NamePat "!" "(" Proc    ")"                            // _!(_): NamePat x Proc ---------> SendPat

syntax        SendOrPat ::= Send                                                   //    Send < SendOrPat
                          | SendPat                                                // SendPat < SendOrPat

// Reify Pattern
syntax         ReifyPat ::= "*" NamePat                                            // *: NamePat -------------------> ReifyPat

syntax       ReifyOrPat ::= Reify                                                  //    Reify < ReifyOrPat
                          | ReifyPat                                               // ReifyPat < ReifyOrPat

// Process Pattern
syntax          ProcPat ::= "{" ProcPat "}"                                        // {_}: ProcPat ------------------> ProcPat
//                        | SimpleType                                             //  SimplType < ProcPat
                          | ProcVar                                                //    ProcVar < ProcPat
                          | ReceivePat                                             // ReceivePat < ProcPat
                          | SendPat                                                //    SendPat < ProcPat
                          | ReifyPat                                               //   ReifyPat < ProcPat
                          > ParPat                                                 //     ParPat < ProcPat

syntax        ProcOrPat ::= "{" ProcOrPat "}"                                      //       {_}: ProcOrPat --------> ProcOrPat
                          | Proc                                                   //     Proc < ProcOrPat
                          | ProcPat                                                //  ProcPat < ProcOrPat

syntax            OrPat ::= NameOrPat
                          | ProcOrPat

// Sets
syntax       Set ::= "FN(" OrPat ")"                    [function]  // free names
                   | "FV(" OrPat ")"                    [function]  // free variables
                   | "BN(" OrPat ")"                    [function]  // bound names
                   | "BV(" OrPat ")"                    [function]  // bound variables
                   | "RN(" OrPat ")"                    [function]  // receive names
                   | "RC(" OrPat ")"                    [function]  // receive channels
                   | "RV(" OrPat ")"                    [function]  // receive variables
                   | "SN(" OrPat ")"                    [function]  // send names
                   | "SC(" OrPat ")"                    [function]  // send channels
                   | "SV(" OrPat ")"                    [function]  // send variables
                   |  "N(" OrPat ")"                    [function]  // names
                   |  "V(" OrPat ")"                    [function]  // variables
                   | "CH(" OrPat ")"                    [function]  // channels
                   | "PP(" OrPat ")"                    [function]  // process patterns
                   | "NP(" OrPat ")"                    [function]  // name patterns
                   |   "(" Set   ")"                     [bracket]

//syntax     Int ::= "howMany" "(" Set ")"                    [strict]

// GROUND TERMS
syntax    Ground ::= Int | Bool | String | Set                          //Int, Bool, and String ground terms

// Expressions - resolve to ground term
syntax       Exp ::= AExp | BExp

//syntax     Int ::= "sizeSet" "(" Set ")"              [function]

// Arithmetic
syntax      AExp ::= Int
                   | "(" AExp ")"                       [bracket]
                   | ReifyPat                                      //for interesting message passing: x(y){ *y + 5 }
                   | String
                   | Set
                   | AExp "+" AExp                       [strict]
                   | AExp "-" AExp                       [strict]
                   | AExp "*" AExp                       [strict]

// Boolean
syntax      BExp ::= Bool
                   | "(" BExp ")"                       [bracket]
                   | Reify
                   | ReifyPat
                   | String
                   | Set
                   | AExp "<=" AExp                   [seqstrict]
                   | AExp "==" AExp                      [strict]
                   | "not" BExp                          [strict]
                   | BExp "&&" BExp                   [strict(1)]
                   | BExp "==" BExp                      [strict]

// For sets...
syntax     KItem ::= OrPat

endmodule


module NAMEVAR
import NAMEVAR-SYNTAX
import SUBSTITUTION

  configuration
    <T>
      <k> $PGM:OrPat </k>
    </T>

syntax KResult ::= Ground | Reify | Set

// Arithmetic
rule I1:Int  + I2:Int => I1  +Int I2  [anywhere]
rule I1:Int  - I2:Int => I1  -Int I2  [anywhere]
rule I1:Int  * I2:Int => I1  *Int I2  [anywhere]
rule I1:Int <= I2:Int => I1 <=Int I2  [anywhere]
rule I1:Int == I2:Int => I1 ==Int I2  [anywhere]

// Boolean
rule      not B:Bool    => notBool B  [anywhere]
rule true  && B:Bool    => B          [anywhere]
rule false && _         => false      [anywhere]
rule B1:Bool == B2:Bool => B1 ==Bool B2  [anywhere]

// Set
rule S1:Set +  S2:Set  => S1 S2  [anywhere]
rule S1:Set -  S2:Set  => S1 -Set S2  [anywhere]
rule S1:Set *  S2:Set  => intersectSet(S1,S2)  [anywhere,strict]
rule S1:Set <= S2:Set  => S1 <=Set S2  [anywhere]
rule S1:Set == S2:Set  => (S1 <=Set S2) && (S2 <=Set S1)  [anywhere]
//rule howMany ( S:Set ) => size(S)

// String
rule S1:String  + S2:String => S1  +String S2  [anywhere]
rule S1:String == S2:String => S1 ==String S2  [anywhere]

// Name set
rule N(   Nil     ) => .Set  [anywhere]
rule N( _:Bool    ) => .Set  [anywhere]
rule N( _:Int     ) => .Set  [anywhere]
rule N( _:String  ) => .Set  [anywhere]
rule N( N:Name    ) => SetItem(N)  [anywhere]
rule N( N:NamePat ) => SetItem(N)  [anywhere]

rule N( for( Y:NamePat <- X:Name    ) { P:Proc    } )  => SetItem(X) N(P)  [anywhere]
rule N( for( Y:NamePat <- X:Name    ) { P:ProcPat } )  => SetItem(X) N(P)  [anywhere]
rule N( for( Y:NamePat <- X:NamePat ) { P:ProcPat } )  => SetItem(X) N(P)  [anywhere]

rule N( X:Name    ! ( P:Proc    ) ) => SetItem(X) N(P)  [anywhere]
rule N( X:NamePat ! ( P:Proc    ) ) => SetItem(X) N(P)  [anywhere]
rule N( X:Name    ! ( P:ProcPat ) ) => SetItem(X) N(P)  [anywhere]
rule N( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) N(P)  [anywhere]

rule N( P:Proc    | Q:Proc    ) => N(P) N(Q)  [anywhere]
rule N( P:ProcPat | Q:Proc    ) => N(P) N(Q)  [anywhere]
rule N( P:Proc    | Q:ProcPat ) => N(P) N(Q)  [anywhere]
rule N( P:ProcPat | Q:ProcPat ) => N(P) N(Q)  [anywhere]

rule N( * X:Name    ) => SetItem(X)  [anywhere]
rule N( * X:NamePat ) => SetItem(X)  [anywhere]

rule N( A1:AExp  + A2:AExp ) => N(A1) N(A2)  [anywhere]
rule N( A1:AExp  - A2:AExp ) => N(A1) N(A2)  [anywhere]
rule N( A1:AExp  * A2:AExp ) => N(A1) N(A2)  [anywhere]

rule N( not B:BExp )         => N(B)  [anywhere]
rule N( B1:BExp && B2:BExp ) => N(B1) N(B2)  [anywhere]

// Free Name set
rule FN(   Nil    ) => .Set  [anywhere]
rule FN( _:Bool   ) => .Set  [anywhere]
rule FN( _:Int    ) => .Set  [anywhere]
rule FN( _:String ) => .Set  [anywhere]

rule FN( _:Name    ) => .Set  [anywhere]
rule FN( N:NamePat ) => SetItem(N)  [anywhere]

rule FN( for( Y:NamePat <- X:Name    ) { P:Proc    } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )  [anywhere]
rule FN( for( Y:NamePat <- X:Name    ) { P:ProcPat } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )  [anywhere]
rule FN( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => SetItem(X) ( FN(P) -Set SetItem(Y) )  [anywhere]

rule FN( X:Name    ! ( P:Proc    ) ) => SetItem(X) FN(P)  [anywhere]
rule FN( X:NamePat ! ( P:Proc    ) ) => SetItem(X) FN(P)  [anywhere]
rule FN( X:Name    ! ( P:ProcPat ) ) => SetItem(X) FN(P)  [anywhere]
rule FN( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) FN(P)  [anywhere]

rule FN( P:Proc    | Q:Proc    ) => FN(P) FN(Q)  [anywhere]
rule FN( P:ProcPat | Q:Proc    ) => FN(P) FN(Q)  [anywhere]
rule FN( P:Proc    | Q:ProcPat ) => FN(P) FN(Q)  [anywhere]
rule FN( P:ProcPat | Q:ProcPat ) => FN(P) FN(Q)  [anywhere]

rule FN( * X:Name    ) => SetItem(X)  [anywhere]
rule FN( * X:NamePat ) => SetItem(X)  [anywhere]

rule FN( A1:AExp +  A2:AExp ) => FN(A1) FN(A2)  [anywhere]
rule FN( A1:AExp -  A2:AExp ) => FN(A1) FN(A2)  [anywhere]
rule FN( A1:AExp *  A2:AExp ) => FN(A1) FN(A2)  [anywhere]
rule FN( A1:AExp <= A2:AExp ) => FN(A1) FN(A2)  [anywhere]

rule FN( not B:BExp )         => FN(B)  [anywhere]
rule FN( B1:BExp && B2:BExp ) => FN(B1) FN(B2)  [anywhere]

// Bound Name set
rule BN( P:Proc    ) => N(P) -Set FN(P)  [anywhere]
rule BN( P:ProcPat ) => N(P) -Set FN(P)  [anywhere]

// Variable set
rule V( _:Proc    ) => .Set  [anywhere]

rule V( _:Name    ) => .Set  [anywhere]
rule V( N:NamePat ) => SetItem(N)  [anywhere]

rule V( for( Y:NamePat <- X:Name    ) { P:ProcPat } ) => V(P) -Set SetItem(Y)  [anywhere]
rule V( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => SetItem(X) ( V(P) -Set SetItem(Y) )  [anywhere]

rule V( X:NamePat ! ( P:Proc    ) ) => SetItem(X)  [anywhere]
rule V( X:Name    ! ( P:ProcPat ) ) => V(P)  [anywhere]
rule V( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) V(P)  [anywhere]

rule V( P:ProcPat | Q:Proc    ) => V(P)  [anywhere]
rule V( P:Proc    | Q:ProcPat ) => V(Q)  [anywhere]
rule V( P:ProcPat | Q:ProcPat ) => V(P) V(Q)  [anywhere]

rule V( * X:NamePat ) => SetItem(X)  [anywhere]

rule V( A1:AExp  + A2:AExp ) => V(A1) V(A2)  [anywhere]
rule V( A1:AExp  - A2:AExp ) => V(A1) V(A2)  [anywhere]
rule V( A1:AExp  * A2:AExp ) => V(A1) V(A2)  [anywhere]

rule V( not B:BExp ) => V(B)  [anywhere]
rule V( B1:BExp && B2:BExp ) => V(B1) V(B2)  [anywhere]

// Bound Variable set
rule BV( _:Proc    ) => .Set  [anywhere]
rule BV( P:ProcPat ) => intersectSet( BN(P) , V(P) )  [anywhere]

// Free Variable set
rule FV( _:Proc    ) => .Set  [anywhere]
rule FV( P:ProcPat ) => intersectSet( FN(P) , V(P) )  [anywhere]

// Channel set
rule CH(   Nil    ) => .Set  [anywhere]
rule CH( _:Bool   ) => .Set  [anywhere]
rule CH( _:Int    ) => .Set  [anywhere]
rule CH( _:String ) => .Set  [anywhere]

rule CH( for( Y:NamePat <- X:Name    ) { P:Proc    } ) => SetItem(X) ( CH(P) -Set SetItem(Y) )  [anywhere]
rule CH( for( Y:NamePat <- X:Name    ) { P:ProcPat } ) => SetItem(X) ( CH(P) -Set SetItem(Y) )  [anywhere]
rule CH( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => ( CH(P) -Set SetItem(Y) )  [anywhere]

rule CH( X:Name    ! ( P:Proc    ) ) => SetItem(X) CH(P)  [anywhere]
rule CH( X:NamePat ! ( P:Proc    ) ) => CH(P)  [anywhere]
rule CH( X:Name    ! ( P:ProcPat ) ) => SetItem(X) CH(P)  [anywhere]
rule CH( X:NamePat ! ( P:ProcPat ) ) => CH(P)  [anywhere]

rule CH( P:Proc    | Q:Proc    ) => CH(P) CH(Q)  [anywhere]
rule CH( P:ProcPat | Q:Proc    ) => CH(P) CH(Q)  [anywhere]
rule CH( P:Proc    | Q:ProcPat ) => CH(P) CH(Q)  [anywhere]
rule CH( P:ProcPat | Q:ProcPat ) => CH(P) CH(Q)  [anywhere]

rule CH( * X:Name    ) => SetItem(X)  [anywhere]
rule CH( * _:NamePat ) => .Set  [anywhere]

rule CH( A1:AExp  + A2:AExp ) => CH(A1) CH(A2)  [anywhere]
rule CH( A1:AExp  - A2:AExp ) => CH(A1) CH(A2)  [anywhere]
rule CH( A1:AExp  * A2:AExp ) => CH(A1) CH(A2)  [anywhere]

rule CH( not B:BExp ) => CH(B)  [anywhere]
rule CH( B1:BExp && B2:BExp ) => CH(B1) CH(B2)  [anywhere]

// Receive Name set
rule RN(   Nil    ) => .Set  [anywhere]
rule RN( _:Bool   ) => .Set  [anywhere]
rule RN( _:Int    ) => .Set  [anywhere]
rule RN( _:String ) => .Set  [anywhere]

rule RN( for( Y:NamePat <- X:Name    ) { P:Proc    } )  => SetItem(X) ( RN(P) -Set SetItem(Y) )  [anywhere]
rule RN( for( Y:NamePat <- X:Name    ) { P:ProcPat } )  => SetItem(X) ( RN(P) -Set SetItem(Y) )  [anywhere]
rule RN( for( Y:NamePat <- X:NamePat ) { P:ProcPat } )  => SetItem(X) ( RN(P) -Set SetItem(Y) )  [anywhere]

rule RN( _:Name    ! ( P:Proc    ) ) => RN(P)  [anywhere]
rule RN( _:NamePat ! ( P:Proc    ) ) => RN(P)  [anywhere]
rule RN( _:Name    ! ( P:ProcPat ) ) => RN(P)  [anywhere]
rule RN( _:NamePat ! ( P:ProcPat ) ) => RN(P)  [anywhere]

rule RN( P:Proc    | Q:Proc    ) => RN(P) RN(Q)  [anywhere]
rule RN( P:ProcPat | Q:Proc    ) => RN(P) RN(Q)  [anywhere]
rule RN( P:Proc    | Q:ProcPat ) => RN(P) RN(Q)  [anywhere]
rule RN( P:ProcPat | Q:ProcPat ) => RN(P) RN(Q)  [anywhere]

rule RN( * _:Name    ) => .Set  [anywhere]
rule RN( * _:NamePat ) => .Set  [anywhere]

rule RN( A1:AExp  + A2:AExp ) => RN(A1) RN(A2)  [anywhere]
rule RN( A1:AExp  - A2:AExp ) => RN(A1) RN(A2)  [anywhere]
rule RN( A1:AExp  * A2:AExp ) => RN(A1) RN(A2)  [anywhere]

rule RN( not B:BExp ) => RN(B)  [anywhere]
rule RN( B1:BExp && B2:BExp ) => RN(B1) RN(B2)  [anywhere]

// Receive Variable set
rule RV( _:Proc ) => .Set  [anywhere]

rule RV( for( Y:NamePat <- _:Name    ) { P:ProcPat } ) => RV(P) -Set SetItem( Y )  [anywhere]
rule RV( for( Y:NamePat <- X:NamePat ) { P:ProcPat } ) => SetItem(X) ( RV(P)-Set SetItem(Y) )  [anywhere]

rule RV( _:NamePat ! ( _:Proc    ) ) => .Set  [anywhere]
rule RV( _:Name    ! ( P:ProcPat ) ) => RV(P)  [anywhere]
rule RV( _:NamePat ! ( P:ProcPat ) ) => RV(P)  [anywhere]

rule RV( P:ProcPat | _:Proc    ) => RV(P)  [anywhere]
rule RV( _:Proc    | P:ProcPat ) => RV(P)  [anywhere]
rule RV( P:ProcPat | Q:ProcPat ) => RV(P) RV(Q)  [anywhere]

rule RV( * _:NamePat  ) => .Set  [anywhere]

rule RV( A1:AExp  + A2:AExp ) => RV(A1) RV(A2)  [anywhere]
rule RV( A1:AExp  - A2:AExp ) => RV(A1) RV(A2)  [anywhere]
rule RV( A1:AExp  * A2:AExp ) => RV(A1) RV(A2)  [anywhere]

rule RV( not B:BExp ) => RV(B)  [anywhere]
rule RV( B1:BExp && B2:BExp ) => RV(B1) RV(B2)  [anywhere]

// Send Name set
rule SN(   Nil    ) => .Set  [anywhere]
rule SN( _:Bool   ) => .Set  [anywhere]
rule SN( _:Int    ) => .Set  [anywhere]
rule SN( _:String ) => .Set  [anywhere]

rule SN( for( Y:NamePat <- _:Name    ) { P:Proc    }  ) => SN(P) -Set SetItem(Y)  [anywhere]
rule SN( for( Y:NamePat <- _:Name    ) { P:ProcPat }  ) => SN(P) -Set SetItem(Y)  [anywhere]
rule SN( for( Y:NamePat <- _:NamePat ) { P:ProcPat }  ) => SN(P) -Set SetItem(Y)  [anywhere]

rule SN( X:Name    ! ( P:Proc    ) ) => SetItem(X) SN(P)  [anywhere]
rule SN( X:NamePat ! ( P:Proc    ) ) => SetItem(X) SN(P)  [anywhere]
rule SN( X:Name    ! ( P:ProcPat ) ) => SetItem(X) SN(P)  [anywhere]
rule SN( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) SN(P)  [anywhere]

rule SN( P:Proc    | Q:Proc    ) => SN(P) SN(Q)  [anywhere]
rule SN( P:ProcPat | Q:Proc    ) => SN(P) SN(Q)  [anywhere]
rule SN( P:Proc    | Q:ProcPat ) => SN(P) SN(Q)  [anywhere]
rule SN( P:ProcPat | Q:ProcPat ) => SN(P) SN(Q)  [anywhere]

rule SN( * _:Name    ) => .Set  [anywhere]
rule SN( * _:NamePat ) => .Set  [anywhere]

rule SN( A1:AExp  + A2:AExp ) => SN(A1) SN(A2)  [anywhere]
rule SN( A1:AExp  - A2:AExp ) => SN(A1) SN(A2)  [anywhere]
rule SN( A1:AExp  * A2:AExp ) => SN(A1) SN(A2)  [anywhere]

rule SN( not B:BExp ) => SN(B)  [anywhere]
rule SN( B1:BExp && B2:BExp ) => SN(B1) SN(B2)  [anywhere]

// Send Variable set
rule SV( _:Proc ) => .Set  [anywhere]

rule SV( for( _:NamePat <- _:Name    ) { P:ProcPat } )  => SV(P)  [anywhere]
rule SV( for( _:NamePat <- _:NamePat ) { P:ProcPat } )  => SV(P)  [anywhere]

rule SV( X:NamePat ! ( _:Proc    ) ) => SetItem(X)  [anywhere]
rule SV( _:Name    ! ( P:ProcPat ) ) => SV(P)  [anywhere]
rule SV( X:NamePat ! ( P:ProcPat ) ) => SetItem(X) SV(P)  [anywhere]

rule SV( P:ProcPat | _:Proc    ) => SV(P)  [anywhere]
rule SV( _:Proc    | P:ProcPat ) => SV(P)  [anywhere]
rule SV( P:ProcPat | Q:ProcPat ) => SV(P) SV(Q)  [anywhere]

rule SV( * _:NamePat ) => .Set  [anywhere]

rule SV( A1:AExp  - A2:AExp ) => SV(A1) SV(A2)  [anywhere]
rule SV( A1:AExp  + A2:AExp ) => SV(A1) SV(A2)  [anywhere]
rule SV( A1:AExp  * A2:AExp ) => SV(A1) SV(A2)  [anywhere]

rule SV( not B:BExp ) => SV(B)  [anywhere]
rule SV( B1:BExp && B2:BExp ) => SV(B1) SV(B2)  [anywhere]

// Receive Channel set
rule RC( P:Proc    ) => intersectSet( RN(P) , CH(P) )  [anywhere]
rule RC( P:ProcPat ) => intersectSet( RN(P) , CH(P) )  [anywhere]

// Send Channel set
rule SC( P:Proc    ) => intersectSet( SN(P) , CH(P) )  [anywhere]
rule SC( P:ProcPat ) => intersectSet( SN(P) , CH(P) )  [anywhere]

endmodule
