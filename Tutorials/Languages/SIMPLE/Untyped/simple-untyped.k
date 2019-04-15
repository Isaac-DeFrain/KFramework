// Copyright (c) 2014-2018 K Team. All Rights Reserved.
/*!
\title{SIMPLE --- Untyped}
\author{Grigore Ro\c{s}u and Traian Florin \c{S}erb\u{a}nu\c{t}\u{a}
        (\texttt{\{grosu,tserban2\}@illinois.edu})}
\organization{University of Illinois at Urbana-Champaign}
*/
module SIMPLE-UNTYPED-SYNTAX
  imports DOMAINS-SYNTAX

// Identifiers
  syntax Id ::= "main"                   [token]

// Declarations
  syntax Decl ::= "var" Exps ";"
                | "function" Id "(" Ids ")" Block

// Expressions
  syntax Exp ::= Int | Bool | String | Id
               | "(" Exp ")"             [bracket]
               | "++" Exp
               > Exp "[" Exps "]"        [strict]
               > Exp "(" Exps ")"        [strict]
               | "-" Exp                 [strict]
               | "sizeOf" "(" Exp ")"    [strict]
               | "read" "(" ")"
               > left:
                 Exp "*" Exp             [strict, left]
               | Exp "/" Exp             [strict, left]
               | Exp "%" Exp             [strict, left]
               > left:
                 Exp "+" Exp             [strict, left]
               | Exp "-" Exp             [strict, left]
               > non-assoc:
                 Exp "<" Exp             [strict, non-assoc]
               | Exp "<=" Exp            [strict, non-assoc]
               | Exp ">" Exp             [strict, non-assoc]
               | Exp ">=" Exp            [strict, non-assoc]
               | Exp "==" Exp            [strict, non-assoc]
               | Exp "!=" Exp            [strict, non-assoc]
               > "!" Exp                 [strict]
               > left:
                 Exp "&&" Exp            [strict(1), left]
               | Exp "||" Exp            [strict(1), left]
               > "spawn" Block
               > Exp "=" Exp             [strict(2), right]

  syntax Ids  ::= List{Id,","}
  syntax Exps ::= List{Exp,","}          [strict]
  syntax Exps ::= Ids
  syntax Val
  syntax Vals ::= List{Val,","}
  syntax Bottom
  syntax Bottoms ::= List{Bottom,","}
  syntax Ids ::= Bottoms

// Statements
  syntax Block ::= "{" "}"
                | "{" Stmts "}"

  syntax Stmt ::= Decl | Block
                | Exp ";"                               [strict]
                | "if" "(" Exp ")" Block "else" Block   [avoid, strict(1)]
                | "if" "(" Exp ")" Block
                | "while" "(" Exp ")" Block
                | "for" "(" Stmts Exp ";" Exp ")" Block
                | "return" Exp ";"                      [strict]
                | "return" ";"
                | "print" "(" Exps ")" ";"              [strict]
                | "try" Block "catch" "(" Id ")" Block
                | "throw" Exp ";"                       [strict]
                | "join" Exp ";"                        [strict]
                | "acquire" Exp ";"                     [strict]
                | "release" Exp ";"                     [strict]
                | "rendezvous" Exp ";"                  [strict]

  syntax Stmts ::= Stmt
                 | Stmts Stmts    [right]

// Desugared Syntax
  rule if (E) S => if (E) S else {}                                 [macro]
  rule for(Start Cond; Step) {S} => {Start while (Cond) {S Step;}}  [macro]
  rule for(Start Cond; Step) {} => {Start while (Cond) {Step;}}     [macro]
  rule var E1:Exp, E2:Exp, Es:Exps; => var E1; var E2, Es;          [macro]
  rule var X:Id = E; => var X; X = E;                               [macro]

endmodule

module SIMPLE-UNTYPED
  imports SIMPLE-UNTYPED-SYNTAX
  imports DOMAINS

// Basic Semantic Infrastructure

// Values
  syntax Val ::= Int | Bool | String
               | array(Int,Int)
               | lambda(Ids,Stmt)
  syntax Exp ::= Val
  syntax Exps ::= Vals
  syntax Vals ::= Bottoms
  syntax KResult ::= Val | Vals

//---------------------
//--- Configuration ---
//---------------------
  syntax ControlCell
  syntax ControlCellFragment

  configuration <T color="red">
                  <threads color="orange">
                    <thread multiplicity="*" color="yellow">
                      <k color="green"> $PGM:Stmts ~> execute </k>
                      <control color="cyan">
                        <fstack color="blue"> .List </fstack>
                        <xstack color="purple"> .List </xstack>
                      </control>
                      <env color="violet"> .Map </env>
                      <holds color="black"> .Map </holds>
                      <id color="pink"> 0 </id>
                    </thread>
                  </threads>
                  <genv color="pink"> .Map </genv>
                  <store color="white"> .Map </store>
                  <busy color="cyan"> .Set </busy>
                  <terminated color="red"> .Set </terminated>
                  <input color="magenta" stream="stdin"> .List </input>
                  <output color="brown" stream="stdout"> .List </output>
                  <nextLoc color="gray"> 0 </nextLoc>
                </T>

//---------------------------------------
//--- Declarations and Initialization ---
//---------------------------------------

// Variable Declaration
  syntax KItem ::= "undefined"  [latex(\bot)]

  rule <k> var X:Id; => . ...</k>
       <env> Env => Env[X <- L] </env>
       <store>... .Map => L |-> undefined ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

// Array Declaration
  context var _:Id[HOLE];

  rule <k> var X:Id[N:Int]; => . ...</k>
       <env> Env => Env[X <- L] </env>
       <store>... .Map => L |-> array(L +Int 1, N) (L +Int 1) ... (L +Int N) |-> undefined ...</store>
       <nextLoc> L => L +Int 1 +Int N </nextLoc>
    requires N >=Int 0

  syntax Id ::= "$1" | "$2"
  rule var X:Id[N1:Int, N2:Int, Vs:Vals];
    => var X[N1];
       {
         for(var $1 = 0; $1 <= N1 - 1; ++$1) {
           var $2[N2, Vs];
           X[$1] = $2;
         }
       }
    [structural]

// Function declaration
  rule <k> function F(Xs) S => . ...</k>
       <env> Env => Env[F <- L] </env>
       <store>... .Map => L |-> lambda(Xs, S) ...</store>
       <nextLoc> L => L +Int 1 </nextLoc>

// Initialization
  syntax KItem ::= "execute"
  rule <k> execute => main(.Exps); </k>
       <env> Env </env>
       <genv> .Map => Env </genv>                              [structural]

//-------------------
//--- Expressions ---
//-------------------

// Variable lookup
  rule <k> X:Id => V ...</k>
       <env>... X |-> L ...</env>
       <store>... L |-> V:Val ...</store>                      [lookup]

// Variable/Array increment
  context ++(HOLE => lvalue(HOLE))
  rule <k> ++loc(L) => I +Int 1 ...</k>
       <store>... L |-> (I => I +Int 1) ...</store>            [increment]

// Arithmetic operators
  rule I1 + I2 => I1 +Int I2
  rule Str1 + Str2 => Str1 +String Str2
  rule I1 - I2 => I1 -Int I2
  rule I1 * I2 => I1 *Int I2
  rule I1 / I2 => I1 /Int I2 requires I2 =/=K 0
  rule I1 % I2 => I1 %Int I2 requires I2 =/=K 0
  rule - I => 0 -Int I
  rule I1 < I2 => I1 <Int I2
  rule I1 <= I2 => I1 <=Int I2
  rule I1 > I2 => I1 >Int I2
  rule I1 >= I2 => I1 >=Int I2

  rule V1:Val == V2:Val => V1 ==K  V2  // ==K is syntactic comparison
  rule V1:Val != V2:Val => V1 =/=K V2

// Boolean
  rule ! T => notBool(T)
  rule true  && E => E
  rule false && _ => false
  rule true  || _ => true
  rule false || E => E

// Array lookup
  rule V:Val[N1:Int, N2:Int, Vs:Vals] => V[N1][N2, Vs]         [structural, anywhere]

  rule array(L,_)[N:Int] => lookup(L +Int N)                   [structural, anywhere]

// Size of an array
  rule sizeOf(array(_,N)) => N

// Function calls
  syntax KItem ::= (Map,K,ControlCellFragment)

  rule <k> lambda(Xs,S)(Vs:Vals) ~> K => mkDecls(Xs,Vs) S return; </k>
       <control>
         <fstack> .List => ListItem((Env,K,C)) ...</fstack>
         C
       </control>
       <env> Env => GEnv </env>
       <genv> GEnv </genv>

  rule <k> return(V:Val); ~> _ => V ~> K </k>
       <control>
         <fstack> ListItem((Env,K,C)) => .List ...</fstack>
         (_ => C)
       </control>
       <env> _ => Env </env>

  syntax Val ::= "nothing"
  rule return; => return nothing;                              [macro]

// Read
  rule <k> read() => I ...</k>
       <input> ListItem(I:Int) => .List ...</input>            [read]

// Assignment
  context (HOLE => lvalue(HOLE)) = _

  rule <k> loc(L) = V:Val => V ...</k>
       <store>... L |-> (_ => V) ...</store>                   [assignment]

//------------------
//--- Statements ---
//------------------

// Blocks
  rule {} => .                                                 [structural]
  rule <k> { S } => S ~> setEnv(Env) ...</k> <env> Env </env>  [structural]

// Sequential composition
  rule S1:Stmts S2:Stmts => S1 ~> S2                           [structural]

// Expression statements
  rule _:Val; => .

// Conditional
  rule if ( true) S else _ => S
  rule if (false) _ else S => S

// While loop
  rule while (E) S => if (E) {S while(E)S}                     [structural]

// Print
  rule <k> print(V:Val, Es => Es); ...</k>
       <output>... .List => ListItem(V) </output>              [print]

  rule print(.Vals); => .                                      [structural]

// Exceptions
  syntax KItem ::= (Id,Stmts,K,Map,ControlCellFragment)

  syntax KItem ::= "popx"

  rule <k> (try S1 catch(X) {S2} => S1 ~> popx) ~> K </k>
       <control>
         <xstack> .List => ListItem((X, S2, K, Env, C)) ...</xstack>
         C
       </control>
       <env> Env </env>

  rule <k> popx => . ...</k>
       <xstack> ListItem(_) => .List ...</xstack>

  rule <k> throw V:Val; ~> _ => { var X = V; S2 } ~> K </k>
       <control>
         <xstack> ListItem((X, S2, K, Env, C)) => .List ...</xstack>
         (_ => C)
       </control>
       <env> _ => Env </env>

//---------------
//--- Threads ---
//---------------

// Thread creation
  rule <thread>...
         <k> spawn S => !T:Int ...</k>
         <env> Env </env>
       ...</thread>
       (.Bag => <thread>...
               <k> S </k>
               <env> Env </env>
               <id> !T </id>
             ...</thread>)

// Thread termination
  rule (<thread>... <k> . </k> <holds> H </holds> <id> T </id> ...</thread> => .Bag)
       <busy> Busy => Busy -Set keys(H) </busy>
       <terminated>... .Set => SetItem(T) ...</terminated>

// Thread joining
  rule <k> join T:Int; => . ...</k>
       <terminated>... SetItem(T) ...</terminated>

// Acquire lock
  rule <k> acquire V:Val; => . ...</k>
       <holds>... .Map => V |-> 0 ...</holds>
       <busy> Busy (.Set => SetItem(V)) </busy>
    requires (notBool(V in Busy))                              [acquire]

  rule <k> acquire V; => . ...</k>
       <holds>... V:Val |-> (N => N +Int 1) ...</holds>

// Release lock
  rule <k> release V:Val; => . ...</k>
       <holds>... V |-> (N => N -Int 1) ...</holds>
    requires N >Int 0

  rule <k> release V; => . ...</k> <holds>... V:Val |-> 0 => .Map ...</holds>
       <busy>... SetItem(V) => .Set ...</busy>

// Rendezvous synchronization
  rule <k> rendezvous V:Val; => . ...</k>
       <k> rendezvous V; => . ...</k>                          [rendezvous]

//---------------------------------------------
//--- Auxiliary declarations and operations ---
//---------------------------------------------

// Making declarations
  syntax Stmts ::= mkDecls(Ids,Vals)  [function]
  rule mkDecls((X:Id, Xs:Ids), (V:Val, Vs:Vals)) => var X=V; mkDecls(Xs,Vs)
  rule mkDecls(.Ids,.Vals) => {}

// Location lookup
  syntax Exp ::= lookup(Int)
  rule <k> lookup(L) => V ...</k>
       <store>... L |-> V:Val ...</store>                      [lookup]

// Environment recovery
  syntax KItem ::= setEnv(Map)
  rule <k> setEnv(Env) => . ...</k> <env> _ => Env </env>      [structural]
  rule (setEnv(_) => .) ~> setEnv(_)                           [structural]

// lvalue and loc
  syntax Exp ::= lvalue(K)
  syntax Val ::= loc(Int)

  // Local variable
  rule <k> lvalue(X:Id => loc(L)) ...</k>
       <env>... X |-> L:Int ...</env>                          [structural]

  // Array element
  context lvalue(_:Exp[HOLE:Exps])
  context lvalue(HOLE:Exp[_:Exps])
  rule lvalue(lookup(L:Int) => loc(L))                         [structural]

// Initializing multiple locations
  syntax Map ::= Int "..." Int "|->" K  [function, latex({#1}\ldots{#2}\mapsto{#3})]
  rule N...M |-> _ => .Map  requires N >Int M
  rule N...M |-> K => N |-> K (N +Int 1)...M |-> K  requires N <=Int M

endmodule
