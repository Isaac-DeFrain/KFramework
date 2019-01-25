
// NOTE: DO NOT DIRECTLY IMPORT *-STREAM MODULES
// These stream modules will be automatically instantiated and implicitly imported
// into the main module when `stream` attributes appear in configuration cells.
// Only `Stream` productions and `[stream]` rules will be imported.
// The cell name will be replaced with the one of the main configuration.

module STDIN-STREAM
  imports K-IO

  syntax Stream ::= #istream(Int)
  syntax Stream ::= #parseInput(String, String)

  configuration <stdin> ListItem(#buffer($STDIN:String)) ListItem($IO:String) ListItem(#istream(#stdin)) </stdin>

  // read one character at a time until we read whitespace
  rule [stdinGetc]:
       <stdin>
       ListItem(#parseInput(_:String, Delimiters:String))
       ListItem(#buffer(S:String => S +String chrChar(#getc(N))))
       ListItem("on")
       ListItem(#istream(N:Int))
       </stdin>
    requires findChar(S, Delimiters, 0) ==Int -1 // [stdin]
       [stream]

  // when we reach whitespace, if it parses create a ListItem
  rule [stdinParseString]:
       <stdin>
       (ListItem(#parseInput("String", Delimiters:String)) => ListItem(S))
       ListItem(#buffer(S:String => ""))
       _:List
       </stdin>
    requires findChar(S, Delimiters, 0) =/=Int -1 // [stdin]
       [stream]

  // a hack: handle the case when we read integers without the help of the IO server
  rule [stdinParseInt]:
       <stdin>
       (ListItem(#parseInput("Int", Delimiters:String))
       => ListItem(String2Int(substrString(S, 0, findChar(S, Delimiters, 0)))))
       ListItem(#buffer(S:String => substrString(S,findChar(S, Delimiters, 0) +Int 1, lengthString(S))))
       _:List
       </stdin>
    requires findChar(S, Delimiters, 0) =/=Int -1
       andBool lengthString(S) >Int 1 // [stdin]
       [stream]

  rule [stdinParseArbitrarySort]:
       <stdin>
       (ListItem(#parseInput(Sort:String, Delimiters:String))
       => ListItem(#parse(substrString(S, 0, findChar(S, Delimiters, 0)), Sort)))
       ListItem(#buffer(S:String => substrString(S,findChar(S, Delimiters, 0) +Int 1, lengthString(S))))
       _:List
       </stdin>
    requires findChar(S, Delimiters, 0) =/=Int -1
       andBool Sort =/=String "String"
       andBool Sort =/=String "Int"
       andBool lengthString(S) >Int 1 // [stdin]
       [stream]

  rule [stdinTrim]:
       <stdin>
       ListItem(#parseInput(Sort:String, Delimiters:String))
       ListItem(#buffer(S:String => substrString(S, 1, lengthString(S))))
       _:List
       </stdin>
    requires findChar(S, Delimiters, 0) =/=Int -1
       andBool Sort =/=String "String"
       andBool lengthString(S) <=Int 1 // [stdin]
       [stream]

  // NOTE: This unblocking rule will be instantiated and inserted carefully
  // when necessary according to user-defined rules, since otherwise it will
  // lead to a diverging (i.e., non-terminating) transition system definition.
  // Currently, it supports only a simple pattern matching on the top of the
  // input stream cell, e.g.,
  //   rule <k> read() => V ... </k> <in> ListItem(V:Int) => .List ...  </in>
  // Non-supported rules that refer to the input stream cell in a sophisticated
  // way will get stuck in concrete execution mode with real IO enabled (i.e.,
  // under `--io on` option), while they will still work in symbolic execution
  // mode or concrete execution mode with real IO disabled (i.e., under `--io
  // off`, `--search`, or `--debug` options).
  //
  // TODO: More patterns need to be supported as well. In that case, we need to
  // have a way to specify such patterns.
  rule [stdinUnblock]:
       <stdin>
         (.List => ListItem(#parseInput(?Sort:String, ?Delimiters:String)))
         ListItem(#buffer(_:String))
         ...
       </stdin>
       [unblock]

  /*
  syntax Stream ::= "#noIO"

  rule ListItem(#buffer(_))
       (ListItem(#noIO) ListItem(#istream(_:Int)) => .List) [stdin]
  */

endmodule

module STDOUT-STREAM
  imports K-IO

  syntax Stream ::= #ostream(Int)

  configuration <stdout> ListItem(#ostream(#stdout)) ListItem($IO:String) ListItem(#buffer("")) </stdout>
//configuration <stderr> ListItem(#ostream(#stderr)) ListItem($IO:String) ListItem(#buffer("")) </stderr>

  rule [stdoutBufferFloat]:
       <stdout>
       ListItem(#ostream(_))
       ListItem(_)
       ListItem(#buffer(Buffer:String => Buffer +String Float2String(F)))
       (ListItem(F:Float) => .List)
       _:List
       </stdout>
       // [stdout, stderr]
       [stream]
  rule [stdoutBufferInt]:
       <stdout>
       ListItem(#ostream(_))
       ListItem(_)
       ListItem(#buffer(Buffer:String => Buffer +String Int2String(I)))
       (ListItem(I:Int) => .List)
       _:List
       </stdout>
       // [stdout, stderr]
       [stream]
  rule [stdoutBufferString]:
       <stdout>
       ListItem(#ostream(_))
       ListItem(_)
       ListItem(#buffer(Buffer:String => Buffer +String S))
       (ListItem(S:String) => .List)
       _:List
       </stdout>
       // [stdout, stderr]
       [stream]

  // Send first char from the buffer to the server
  rule [stdoutWrite]:
       <stdout>
       ListItem(#ostream({(.K => #write(N, S)) ~> N:Int}:>Int))
       ListItem("on")
       ListItem(#buffer(S:String => ""))
       _:List
       </stdout>
    requires S =/=String "" // [stdout, stderr]
       [stream]

  /*
  syntax Stream ::= "#noIO"

  rule ListItem(#buffer(Buffer:String => Buffer +String Float2String(F)))
       (ListItem(F:Float) => .List)
       _:List [stdout, stderr]
  rule ListItem(#buffer(Buffer:String => Buffer +String Int2String(I)))
       (ListItem(I:Int) => .List)
       _:List [stdout, stderr]
  rule ListItem(#buffer(Buffer:String => Buffer +String S))
       (ListItem(S:String) => .List)
       _:List [stdout, stderr]

  rule (ListItem(#ostream(_:Int)) ListItem(#noIO) => .List)
       ListItem(#buffer(_))
       _:List [stdout, stderr]
  */

endmodule

