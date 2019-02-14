// RHO CALCULUS with Bool, Int, String ground terms and free name function
// No patterns, only name variables

require "domains.k"
require "substitution.k"

module GRHO-SYNTAX
  import DOMAINS
  import SET
  import SUBSTITUTION


//-------------
//--- NAMES ---
//-------------
  syntax       Var ::= Id                                            //    Id < Var

  syntax   NameVar ::= Var                                           //   Var < NameVar

  syntax      Name ::= Quote                                         // Quote < Name
                     | "{" Name "}"                       [bracket]  //    {_}: Name -----> Name
                     | NameVar

  syntax     Quote ::= "@" Proc                                      //      @: Proc ----> Quote

//-----------------
//--- PROCESSES ---
//-----------------
  syntax      Proc ::= "{" Proc "}"                       [bracket]  // {_}: Proc --------> Proc
                     | "Nil"                                         // Nil: -------------> Proc
                     | Collection                                    // Collection of processes
                     | Ground                                        // Bool, Int, String < Proc
                     | AExp                                          // Arithmetic expressions: AExp < Proc
                     | BExp                                          //    Boolean expressions: BExp < Proc
                     | Reify                                         //   Reify < Proc
                     | Receive                                       // Receive < Proc
                     | Send                                          //    Send < Proc
                     > Par                                           //     Par < Proc

  syntax       Par ::= Proc "|" Proc                         [left]  //     _|_: Proc x Proc --------------> Par

  syntax   Receive ::= Name "(" Name ")"  "{" Proc "}"  [binder(2)]  // _(_){_}: Name x Name x Proc ---> Receive

  syntax      Send ::= Name "!" "(" Proc ")"                         // _!(_): Name x Proc -------------> Send
                     | Name "!" RhoTuple                             //   _!_: Name x RhoTuple ---------> Send

  syntax     Reify ::= "*" Name

  syntax       Set ::= "FN(" Proc ")"                    [function]  // FN: Proc ------------> Set

// Sets
  syntax      Proc ::= Set                                           // Set < Proc
                     | "(" Set ")"                        [bracket]  // (_): Set ------------> Set

  syntax     Procs ::= Proc "," Proc                       [strict]  // _,_: Proc x Proc ----> Procs
                     | Proc "," Procs                      [strict]  // _,_: Proc x Procs ---> Procs

// Collection
  syntax
        Collection ::= RhoList
                     | RhoMap
                     | RhoSet
                     | RhoTuple

  syntax   RhoList ::= "[" Proc  "]"                       [strict]
                     | "[" Procs "]"                       [strict]

  syntax    RhoMap ::= "{" RhoKVPairs "}"

  syntax
        RhoKVPairs ::= Proc ":" Proc
                     | Proc ":" Proc "," RhoKVPairs

  syntax    RhoSet ::= "Set" "(" Proc  ")"                 [strict]
                     | "Set" "(" Procs ")"                 [strict]

  syntax  RhoTuple ::= "(" Proc ",)"                                  // 1-tuple
                     | "(" Procs ")"                                  // n-tuple, n > 2

// GROUND TERMS
  syntax    Ground ::= Int | Bool | String                           //Int, Bool, String < Ground

// Arithmetic
  syntax      AExp ::= "(" AExp ")"                                  //     (_): AExp ------> AExp
                     | Int                                           //    Int < AExp
                     | Reify                                         //  Reify < AExp , for interesting message passing: x(y){ *y + 5 }
                     | String                                        // String < AExp (S1 + S2 => S1 +String S2)
                     > AExp "*" AExp                       [strict]  // _*_: AExp x AExp ---> AExp
                     > AExp "+" AExp                       [strict]  // _+_: AExp x AExp ---> AExp

// Boolean
  syntax      BExp ::= Bool                                          //   Bool < BExp
                     | "(" BExp ")"                                  //  (_): BExp ----------> BExp
                     | Reify                                         //  Reify < BExp
                     | String                                        // String < BExp
                     | AExp  "<=" AExp                  [seqstrict]  // _<=_: AExp x AExp ---> BExp
                     | "not" BExp                          [strict]  // not_: BExp ----------> BExp
                     > BExp "and" BExp                  [strict(1)]  //  and: BExp ----------> BExp
                     > BExp  "or" BExp                     [strict]  //   or: BExp ----------> BExp

// Structural & Name Equivalences
  syntax      Bool ::= Proc "equiv"  Proc
                     | Name "equivN" Name

  syntax KVariable ::= Name

  syntax     KItem ::= Name | Proc

endmodule


module GRHO
  import GRHO-SYNTAX
  import SUBSTITUTION

  configuration
    <T color="purple">
      <threadpool color="red">
        <thread multiplicity="*">                             //collection of threads
          <k> $PGM:Proc </k>                                  //programs and computations are process-based
        </thread>                                             //
      </threadpool>                                           //tuplespace stores sends and receives
      <tuplespace color="blue">                               //
        <sends color="teal">                                  //**sends**
          <send color="cyan" multiplicity="*">                //
            <schan> .K </schan>                               //sending channel (many messages on same channel)
            <msg>   .K   </msg>                               //message
            <tuple> .K </tuple>                               //true = tuple / false = proc
          </send>                                             //
        </sends>                                              //
        <receives color="green">                              //**receives**
          <rec color="yellow" multiplicity="*">               //
            <rchan> .K </rchan>                               //receiving channel (many messages on same channel)
            <bvar>  .K  </bvar>                               //binding varible in continuation
            <cont>  .K  </cont>                               //continuation
          </rec>
        </receives>
      </tuplespace>
    </T>

  syntax KResult ::= Ground | Reify | Set

// Arithmetic
  rule I1:Int + I2:Int => I1 +Int I2    [anywhere]
  rule I1:Int * I2:Int => I1 *Int I2    [anywhere]

// Boolean
  rule I1:Int <= I2:Int => I1 <=Int I2  [anywhere]
  rule not B:Bool => notBool B          [anywhere]
  rule true and B:Bool => B             [anywhere]
  rule false and _ => false             [anywhere]

// Set
//rule S1:Set + S2:Set => S1 S2
//rule S1:Set - S2:Set => S1 -Set S2

// String
  rule S1:String + S2:String => S1 +String S2  [anywhere]

// PAR OPERATOR SEMANTICS
  rule <thread> <k> P:Proc | Q:Proc => . ...</k> </thread>
       (.Bag => <thread> <k> P </k> </thread>)
       (.Bag => <thread> <k> Q </k> </thread>)                  //[structural]

// SEND OPERATOR SEMANTICS
  rule <k> X:Name ! ( P:Proc ) => . ...</k>                     //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>
                  <schan>   X   </schan>                        //sending channel X
                  <msg>     P     </msg>                        //message sent P
                  <tuple> false </tuple>                        //process
                </send>)                                        //[structural]

  rule <k> X:Name ! T:RhoTuple => . ...</k>                     //dissolve send in <threadpool/> and spawn <send/>
       (.Bag => <send>
                  <schan>  X   </schan>                         //sending channel X
                  <msg>    T     </msg>                         //message sent T
                  <tuple> true </tuple>                         //tuple
                </send>)                                        //[structural]

// RECEIVE OPERATOR SEMANTICS
  rule <k>  X:Name ( Y:Name ) { P:Proc } => . ...</k>           //dissolve Rec in <threadpool/> and spawn <rec/>
       (.Bag => <rec>
                  <rchan> X </rchan>                            //receiving channel X
                  <bvar>  Y  </bvar>                            //variable Y binding in continuation P
                  <cont>  P  </cont>                            //continuation P
                </rec>)                                         //[structural]

// REDUCTION RULES

// COMM EVENT
// Comm: x!(Q) | x(y){P} => P[@Q / y]
// Process messages
  rule                                                          //dissolve send and receive on "same" channel
  (<rec>                                                        //dissolve receive:
     <rchan> X:Name </rchan>                                    // channel X
     <bvar>  Y:Name  </bvar>                                    // binding variable Y
     <cont>  P:Proc  </cont>                                    // continuation P
   </rec> => .Bag)
  (<send>                                                       //dissolve send:
     <schan> X     </schan>                                     // channel X
     <msg>   Q:Proc  </msg>                                     // message Q
     <tuple> false </tuple>                                     // process
   </send> => .Bag)
  (.Bag => <thread> <k> P[@ Q / Y] </k> </thread>)              //spawn single <thread/> holding sub P[Z / Y]
  [comm]                                                        //tagged "comm" for tracking nondeterminism

// Tuple messages
// requires binding variable Y to be a tuple of the same length as T
// substitution is done by mapping the coordinates
  rule                                                          //dissolve send and receive on "same" channel
  (<rec>                                                        //dissolve receive:
     <rchan> X:Name </rchan>                                    // channel X
     <bvar>  Y:Name  </bvar>                                    // binding variable Y
     <cont>  P:Proc  </cont>                                    // continuation P
   </rec> => .Bag)
  (<send>                                                       //dissolve send:
     <schan> X         </schan>                                 // channel X
     <msg>   T:RhoTuple  </msg>                                 // message Q
     <tuple> true      </tuple>                                 // process
   </send> => .Bag)
// need to create the map {T_i : Y_i} for substitution
  (.Bag => <thread> <k> P[@ T / Y] </k> </thread>)              //spawn single <thread/> holding sub P[Z / Y]
  [comm]                                                        //tagged "comm" for tracking nondeterminism

// STRUCTURAL EQUIVALENCE
//  P | 0      \equiv P
//  P | Q      \equiv Q | P
// (P | Q) | R \equiv P | (Q | R)

// Eliminate unnecessary Nils
  rule    Nil | P:Proc => P                   //  [anywhere]
  rule P:Proc | Nil    => P                   //  [anywhere]

// Dissolve computationally meaningless threads
  rule <thread> <k> .K  </k> </thread> => .Bag  [structural]  //empty threads
  rule <thread> <k> Nil </k> </thread> => .Bag  [structural]  //Nil threads

// NAME EQUIVALENCE
// @{*x} \equiv_N x
// P \equiv Q \implies @P \equiv_N @Q (side condition)

  rule   @ * N:Name => N                          [anywhere]

// INVERSES
  rule   * @ P:Proc => P                          [anywhere]

// PAR: P|Q -> P'|Q when P -> P'

// EQUIV: P -> Q when P \equiv P', P' -> Q', and Q' \equiv Q

// SYNTACTIC SUBSTITUTION

// Free & Bound Names
  rule FN(   Nil    ) => .Set
  rule FN( _:Bool   ) => .Set
  rule FN( _:Int    ) => .Set
  rule FN( _:String ) => .Set

  rule FN( X:Name ( Y:Name )  { P:Proc } ) => SetItem(X) (FN(P) -Set SetItem(Y))

  rule FN( X:Name ! ( P:Proc ) )  => SetItem(X) FN(P)

  rule FN( P:Proc | Q:Proc )      => FN(P) FN(Q)

  rule FN( * X:Name )             => SetItem(X)

endmodule
