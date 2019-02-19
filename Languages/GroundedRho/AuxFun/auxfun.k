// #lengths of RhoTuple/Names/Procs/Binds
// #chans of Binds
// #bvars of Binds
// for GRHO configuration

requires "../grho.k"

module AUXFUN-SYNTAX
  import GRHO-SYNTAX

  syntax   Int ::= "#length" RhoTuple        [function]
                 | "#length" Name            [function]
                 | "#length" Names           [function]
                 | "#length"  "(" Bind  ")"  [function]

  syntax Procs ::= "#lengths" "(" Binds ")"  [function]

  syntax  Name ::= "#chan"  "(" Bind  ")"    [function]
                 | "#bvar"  "(" Bind  ")"    [function]

  syntax Names ::= "#chans" "(" Binds ")"    [function]
                 | "#bvars" "(" Binds ")"    [function]

endmodule

module AUXFUN
  import AUXFUN-SYNTAX

  syntax KResult ::= Int | Procs | Name

// Tuple Length
  rule #length ( _:Proc ) => 1
  rule #length ( _:Proc , _:Proc  ) => 2
  rule #length ( _:Proc , P:Procs ) => 1 +Int #length ( P )         [strict]

// Name List Length
  rule #length _:Name => 1
  rule #length _:Name , _:Name  => 2
  rule #length _:Name , N:Names => 1 +Int #length N                 [strict]

// Bind Length
  rule #length ( _:Name  <- _:Name ) => 1
  rule #length ( N:Names <- _:Name ) => #length N                   [strict]
  rule #length ( _:Name  <= _:Name ) => 1
  rule #length ( N:Names <= _:Name ) => #length N                   [strict]

// Binds Lengths
  rule #lengths ( B:Lbind ; C:Lbind  ) => #length(B) , #length(C)   [strict]
  rule #lengths ( B:Lbind ; C:Lbinds ) => #length(B) , #lengths(C)  [strict]
  rule #lengths ( B:Rbind ; C:Rbind  ) => #length(B) , #length(C)   [strict]
  rule #lengths ( B:Rbind ; C:Rbinds ) => #length(B) , #lengths(C)  [strict]

// Bind Channel
  rule #chan ( _:Name  <- N:Name ) => N
  rule #chan ( _:Names <- N:Name ) => N
  rule #chan ( _:Name  <= N:Name ) => N
  rule #chan ( _:Names <= N:Name ) => N

// Binds Channels
  rule #chans ( B:Lbind ; C:Lbind  ) => #chan(B) , #chan(C)         [strict]
  rule #chans ( B:Lbind ; C:Lbinds ) => #chan(B) , #chans(C)        [strict]
  rule #chans ( B:Rbind ; C:Rbind  ) => #chan(B) , #chan(C)         [strict]
  rule #chans ( B:Rbind ; C:Rbinds ) => #chan(B) , #chans(C)        [strict]

// Bind Variables
  rule #bvar ( N:Name  <- _:Name ) => { N }
  rule #bvar ( N:Names <- _:Name ) => { N }
  rule #bvar ( N:Name  <= _:Name ) => { N }
  rule #bvar ( N:Names <= _:Name ) => { N }

// Binds Variables
  rule #bvars ( B:Lbind ; C:Lbind  ) => #bvar(B) , #bvar(C)         [strict]
  rule #bvars ( B:Lbind ; C:Lbinds ) => #bvar(B) , #bvars(C)        [strict]
  rule #bvars ( B:Rbind ; C:Rbind  ) => #bvar(B) , #bvar(C)         [strict]
  rule #bvars ( B:Rbind ; C:Rbinds ) => #bvar(B) , #bvars(C)        [strict]

endmodule
