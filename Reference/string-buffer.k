
module STRING-BUFFER-IN-K [symbolic]
  imports BASIC-K
  imports STRING

  syntax StringBuffer ::= ".StringBuffer"                 [function, functional]
  syntax StringBuffer ::= StringBuffer "+String" String   [function, functional, left, avoid]
  syntax StringBuffer ::= String
  syntax String ::= StringBuffer2String ( StringBuffer )  [function, functional]

  rule {SB:String}:>StringBuffer +String S:String => SB +String S
  rule .StringBuffer => ""
  rule StringBuffer2String(S:String) => S
endmodule

module STRING-BUFFER-HOOKED [concrete]
  imports BASIC-K
  imports STRING

  syntax StringBuffer                                     [hook(BUFFER.StringBuffer)]
  syntax StringBuffer ::= ".StringBuffer"                 [function, functional, hook(BUFFER.empty), impure]
  syntax StringBuffer ::= StringBuffer "+String" String   [function, functional, left, hook(BUFFER.concat), avoid]
  syntax String ::= StringBuffer2String ( StringBuffer )  [function, functional, hook(BUFFER.toString)]
endmodule

module STRING-BUFFER
  imports STRING-BUFFER-HOOKED
  imports STRING-BUFFER-IN-K
endmodule

