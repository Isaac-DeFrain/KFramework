// RHO CALCULUS STATIC TYPE SYSTEM
// Input: rho calc process
// Output: top-level constructor

module RHOTYPE-SYNTAX
import ID
import DOMAINS


// NAMES
syntax Var  ::= Id
syntax Name ::= "@" Proc                         [strict]       // Quote: Proc -> Name
              | Var                                             // Id: -> Name (only for convenience)

// PROCESSES
syntax Proc ::= "Nil"                                           // Stop: -> Proc
              | Name "(" Name ")"  "{" Proc "}"  [strict]       // Rec: Name*Name*Proc -> Proc
              | Name "!" "(" Proc ")"            [strict]       // Send: Name*Proc -> Proc
              | "*" Name                         [strict]       // Reify: Name -> Proc
              > Proc "|" Proc                    [left,strict]  // Par: Proc*Proc -> Proc
                
// BRACKETS
syntax Name ::= "{" Name "}"                     [bracket]
              | "(" Name ")"                     [bracket]

syntax Proc ::= "{" Proc "}"                     [bracket]
              | "(" Proc ")"                     [bracket]

syntax KVariable ::= Name

endmodule

module RHOTYPE
import RHOTYPE-SYNTAX

configuration
  <T>
    <k> $PGM:Proc </k>
  </T>

syntax KResult ::= PType

// TYPES
syntax Proc ::= PType
syntax PType ::= "receive" | "send" | "par" | "reify" | "nil"

syntax Name ::= NType
syntax NType ::= "quote" | "variable"

rule @ _:Proc => quote
rule _:Var => variable

// PAR TYPING
rule _:Proc | _:Proc => par

// SEND TYPING
rule _:Name ! ( _:Proc ) => send

// RECEIVE TYPING
rule _:Name ( _:Name ) { _:Proc } => receive

// REIFY TYPING
rule * _:Name => reify

// NIL TYPING
rule Nil => nil

endmodule
