// Length of tuple/name list/int list for GRHO configuration

requires "../grho.k"

module TUPLEN-SYNTAX
  import GRHO-SYNTAX

  syntax   Int ::= "#length" RhoTuple       [function]
                 | "#length" Name           [function]
                 | "#length" Names          [function]
                 | "#length" "(" Bind  ")"  [function]

  syntax Procs ::= "#length" "(" Binds ")"  [function]

endmodule

module TUPLEN
  import TUPLEN-SYNTAX

  syntax KResult ::= Int

// Tuples
  rule #length ( _:Proc ) => 1
  rule #length ( _:Proc , _:Proc  ) => 2
  rule #length ( _:Proc , P:Procs ) => 1 +Int #length ( P )  [strict]

// Names
  rule #length _:Name => 1
  rule #length _:Name , _:Name  => 2
  rule #length _:Name , N:Names => 1 +Int #length N  [strict]

// Bind
  rule #length ( _:Name  <- _:Name ) => 1
  rule #length ( N:Names <- _:Name ) => #length N
  rule #length ( _:Name  <= _:Name ) => 1
  rule #length ( N:Names <= _:Name ) => #length N  [strict]

// Binds
  rule #length ( B:Lbind ; C:Lbind  ) => #length(B) , #length(C)  [strict]
  rule #length ( B:Lbind ; C:Lbinds ) => #length(B) , #length(C)  [strict]
  rule #length ( B:Rbind ; C:Rbind  ) => #length(B) , #length(C)  [strict]
  rule #length ( B:Rbind ; C:Rbinds ) => #length(B) , #length(C)  [strict]

endmodule
