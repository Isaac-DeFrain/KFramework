
module ID-SYNTAX
  import INT-SYNTAX
  import STRING-SYNTAX

  syntax     Id                         [token]
  syntax String ::= Id2String (Id)      [function, functional, hook(STRING.token2string)]
  syntax     Id ::= String2Id (String)  [function, functional, hook(STRING.string2token)]
  syntax     Id ::= freshId(Int)        [freshGenerator, function, functional]
endmodule

module ID-SYMBOLIC [symbolic, kast]
  import ID-SYNTAX

  syntax KItem  ::= "#parseToken"  "(" String "," String ")"          [function, hook(STRING.parseToken)]
  rule String2Id(S:String) => {#parseToken("Id", S)}:>Id

endmodule

module ID-PROGRAM-PARSING
  import BUILTIN-ID-TOKENS

  syntax     Id ::= r"(?<![A-Za-z0-9\\_])[A-Za-z\\_][A-Za-z0-9\\_]*"  [prec(1), notInRules, token, autoReject]
                  | #LowerId                                          [notInRules, token, autoReject]
                  | #UpperId                                          [notInRules, token, autoReject]
endmodule

module ID
  import ID-SYNTAX
  import ID-SYMBOLIC
  import STRING

  rule freshId(I:Int) => String2Id("_" +String Int2String(I))

endmodule
