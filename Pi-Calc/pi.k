require "substitution.k"

module PI-SYNTAX
  imports ID
  imports SUBSTITUTION

  syntax Name ::= Id

  syntax Proc ::= NormProc
                | Proc "|" Proc                  	[klabel(Par), left]
                | "!" Proc                          	[klabel(Replication)]
                | "(" "nu" Name ")" Proc            	[klabel(New)]
	        | "(" Proc ")"                      	[bracket]
		| "{" Proc "}"				[bracket]

  syntax NormProc ::= Name "?" "(" Name ")" "." Proc  	[binder(2), klabel(Receive)]
                    | Name "!" "(" Name ")" "." Proc	[klabel(Send)]
                    | "Nil"				//stopped process
		    | NormProc "+" NormProc		[klabel(Or), left]

  syntax priority Replication New Receive Send > Or > Par

  syntax KVariable ::= Name

endmodule

module PI
  imports PI-SYNTAX

  configuration <T>
                  <par>
		    <proc multiplicity="*">
		      <k>
		        $PGM:Proc
		      </k>
		      <bounds>
		    	<bound multiplicity="*"> . </bound>
		      </bounds>
		      <sum>
		        <summand multiplicity="*"> . </summand>
		      </sum>
		    </proc>
		  </par>
                </T>


  // REPLICATION SEMANTICS

  rule <proc>... <k> ! P:Proc => P ...</k> ...</proc>
       (.Bag => <proc>... <k> P </k> ...</proc>) [structural]

  // STRUCTURAL EQUIVALENCES

  // (P/\equiv, |, 0) is a symmetric monoid
  // P | 0 \equiv P
  // (P | Q) | R \equiv P | (Q | R)

  rule <proc>... <k> P:Proc | Q:Proc => P </k> ...</proc>
       (.Bag => <proc>... <k> Q </k> ...</proc>) [structural]

  rule <proc>... <k> Nil </k> ...</proc> => .Bag [structural]

  // (N/\equiv, +, 0) is a symmetric monoid

  rule <proc>... <k> N:NormProc => . </k>
       <sum> .Bag => <summand> N </summand> </sum> ...</proc> [structural]

  rule <summand> N:NormProc + M:NormProc => N </summand>
       (.Bag => <summand> M </summand>) [structural]

  rule <sum>... <summand> Nil </summand> => .Bag ...</sum> [structural]

  rule <proc>... <k> . </k> <sum> .Bag </sum> ...</proc> => .Bag [structural]

  // (nu x) 0 \equiv 0
  // (nu x)(nu y)P \equiv (nu y)(nu x)P
    //no environment/store needed to generate fresh names?
  
  rule <k> ( nu X:Name ) P:Proc => P ...</k>
       <bounds>... (.Bag => <bound> X </bound>) ...</bounds> [structural]

  // !(!P) \equiv !P
  // !(Nil | Nil) \equiv !Nil
    //needs to be finished

  // COMM EVENT

  rule <proc>
         ...
         <k> (. => P[Z / Y]) ...</k>
         (<sum>
           ...
           <summand> X:Name ? ( Y:Name ) . P:Proc </summand>
	   ...
         </sum> => <sum> .Bag </sum>)
         ...
       </proc>
       <proc>
         ...
         <k> (. => Q) ...</k>
         (<sum>
           ...
	   <summand> X:Name ! ( Z:Name ) . Q:Proc </summand>
	   ...
         </sum> => <sum> .Bag </sum>)
         ...
       </proc>

endmodule
