// RHO CALCULUS STATIC TYPE SYSTEM

module RHOTYPE-SYNTAX
import ID
import DOMAINS


// NAMES
syntax Name ::= "@" Proc                         [strict]       // Quote: Proc -> Name
              | Id                                              // Id: -> Name (only for convenience)

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
syntax Proc ::= PType
syntax PType ::= "receive" | "send" | "par" | "reify" | "proc"

syntax NType ::= "name"
syntax Name ::= NType


rule _:Name => name
rule _:Proc => proc

// PAR TYPING
rule proc | proc => par

// SEND TYPING
rule name ! ( proc ) => send

// RECEIVE TYPING
rule name ( name ) { proc } => receive

// REIFY TYPING
rule * name => reify

endmodule
