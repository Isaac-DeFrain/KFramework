// Synchronous Pi-calculus

require "substitution.k"

module PI-SYNTAX
import ID
import SUBSTITUTION

  syntax     Name ::= Id

  syntax     Proc ::= NormProc                                           //normal processes
                    | Proc "|" Proc                  	[par,left]       //parallel composition
                    | "!" Proc                         	[rep]            //replication
                    | "(" "nu" Name ")" Proc           	[new,binder]     //new
	            | "(" Proc ")"                     	[bracket]
		    | "{" Proc "}"			[bracket]

  syntax NormProc ::= Name "?" "(" Name ")" "." Proc  	[rec,binder(2)]  //receive
                    | Name "!" "(" Name ")" "." Proc	[send]           //send
                    | "Nil"				                 //stopped process
		    | NormProc "+" NormProc		[or,left]        //sum of normal processes

//syntax priority Replication New Receive Send > Or > Par                //need more tests

  syntax KVariable ::= Name

endmodule

module PI
import PI-SYNTAX

  configuration
<T color="green">
  <par color="yellow">
    <thread color="magenta" multiplicity="*">
      <k color="purple">
        $PGM:Proc
      </k>
      <env color="cyan">
        <local color="blue" multiplicity="*"> . </local>
      </env>
      <sum color="orange">
        <summand color="red" multiplicity="*"> . </summand>
      </sum>
    </thread>
  </par>
</T>

// REPLICATION SEMANTICS
//rule <thread> <k> ( ! P1:Proc ) | P2:Proc => P1 | P2 ...</k> ...</thread>
//     (.Bag => <thread> <k> ! P1 </k> ...</thread>)  [structural]

// STRUCTURAL EQUIVALENCES

// (P/\equiv, |, 0) is a symmetric monoid
//  P | 0      \equiv P
// (P | Q) | R \equiv P | (Q | R)

// Par of Procs creates a thread for each Proc
  rule <thread> <k> P:Proc | Q:Proc => P ...</k> ...</thread>
       (.Bag => <thread> <k> Q </k> ...</thread>)  [structural]

// Dissolve Nil k cell
//rule <thread> <k> Nil </k> ...</thread> => .Bag  [structural]

// (N/\equiv, +, 0) is a symmetric monoid

// NormProcs in k cells are dissolved and added to sum cell
  rule <thread>... <k> N:NormProc => . ...</k>
       <sum>... .Bag => <summand> N </summand> ...</sum> ...</thread>  [structural]

// Sum of NormProcs creates a summand cell for each NormProc
  rule <summand> N:NormProc + M:NormProc => N </summand>
       (.Bag => <summand> M </summand>) [structural]

// Dissolve Nil summand cell
//rule <sum>... <summand> Nil </summand> => .Bag ...</sum>  [structural]

// Dissolve empty threads
  rule <thread>... <k> . </k> <sum> .Bag </sum> ...</thread> => .Bag  [structural]

// (nu x) 0 \equiv 0
// (nu x)(nu y)P \equiv (nu y)(nu x)P

// Dissolve nu Nil summand
  rule <sum>... <summand> ( nu X:Name ) Nil </summand> => .Bag ...</sum>  [structural]

// Nu binding
  rule <k> ( nu X ) P => P </k>
       <env>... (.Bag => <local> X </local>) ...</env> [structural]

// Commutativity of nu

// !(!P) \equiv !P ???
// !(Nil | Nil) \equiv !Nil ???

// Repeated replication
  rule <k> ! (! P:Proc) => ! P ...</k>  [structural]

// Replication of par
  rule <k> ! ( P1:Proc | P2:Proc ) => (! P1) | (! P2) ...</k>  [structural]

// Nil replication
//rule <k> ! Nil => Nil ...</k>  [structural]

// COMM EVENT

  rule <thread>
         <k> (. => P1[Z / Y]) ...</k>
         (<sum>
           ...
           <summand> X:Name ? ( Y:Name ) . P1:Proc </summand>
	   ...
         </sum> => <sum> .Bag </sum>)
         ...
       </thread>
       <thread>
         <k> (. => P2) ...</k>
         (<sum>
           ...
	   <summand> X:Name ! ( Z:Name ) . P2:Proc </summand>
	   ...
         </sum> => <sum> .Bag </sum>)
         ...
       </thread>
       [comm]

endmodule
