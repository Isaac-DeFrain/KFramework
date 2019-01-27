
module STRING-SYNTAX
  // Double Quoted Strings are of the form:
  // DoubleQuote StringChar* DoubleQuote
  // StringChar ::= ~[\"\n\r\\] // anything except for Newline, DoubleQuote and Backslash
  //              | [\\][nrtf\"\\] // Backslash followed by either 'nrtf', DoubleQuote or Backslash
  //              | [\\][x] 2*Hex // "\xFF"       Backslash 'x' followed by two   hexadecimal characters
  //              | [\\][u] 4*Hex // "\uFFFF"     Backslash 'u' followed by four  hexadecimal characters
  //              | [\\][U] 8*Hex // "\UFFffFFff" Backslash 'U' followed by eight hexadecimal characters
  //                              // the code must not be in the range [0xdfff, 0xd800] or exceed 0x10ffff
  syntax String [hook(STRING.String)]
  syntax String ::= r"[\\\"](([^\\\"\\n\\r\\\\])|([\\\\][nrtf\\\"\\\\])|([\\\\][x][0-9a-fA-F]{2})|([\\\\][u][0-9a-fA-F]{4})|([\\\\][U][0-9a-fA-F]{8}))*[\\\"]"      [token]
endmodule

module STRING
  imports STRING-SYNTAX
  imports INT
  imports FLOAT-SYNTAX
  imports K-EQUAL

  syntax String ::= String "+String" String    [function, functional, left, latex({#1}+_{\scriptstyle\it String}{#2}), hook(STRING.concat)]

  syntax Bool ::= String "==String" String [function, functional, left, hook(STRING.eq)]

  syntax Int ::= lengthString ( String ) [function, functional, hook(STRING.length)]
  syntax String ::= chrChar ( Int )      [function, hook(STRING.chr)]
  syntax Int ::= ordChar ( String )      [function, hook(STRING.ord)]

  syntax String ::= substrString ( String , Int , Int ) [function, functional, hook(STRING.substr)]
  syntax Int ::= findString ( String , String , Int )   [function, hook(STRING.find)]
  syntax Int ::= rfindString ( String , String , Int )  [function, hook(STRING.rfind)]
  syntax Int ::= findChar ( String , String , Int )     [function, hook(STRING.findChar)]
  syntax Int ::= rfindChar ( String , String , Int )    [function, hook(STRING.rfindChar)]

  syntax String ::= Float2String ( Float )              [function, functional, hook(STRING.float2string)]
  syntax String ::= Float2String ( Float , String )     [function, klabel(FloatFormat), hook(STRING.floatFormat)]
  syntax Float  ::= String2Float ( String )             [function, hook(STRING.string2float)]
  syntax Int    ::= String2Int   ( String )             [function, hook(STRING.string2int)]
  syntax String ::= Int2String   ( Int )                [function, functional, hook(STRING.int2string)]
  syntax String ::= Base2String  ( Int , Int )          [function, hook(STRING.base2string)]
  syntax Int    ::= String2Base  ( String , Int )       [function, hook(STRING.string2base)]


  syntax String ::= "replaceAll" "(" String "," String "," String ")"      [function, functional, hook(STRING.replaceAll)]
  syntax String ::= "replace" "(" String "," String "," String "," Int ")" [function, hook(STRING.replace)]
  syntax String ::= "replaceFirst" "(" String "," String "," String ")"    [function, functional, hook(STRING.replaceFirst)]
  syntax Int ::= "countAllOccurrences" "(" String "," String ")"            [function, functional, hook(STRING.countAllOccurrences)]

  syntax Bool ::= String "=/=String" String      [function, functional, left, hook(STRING.ne)]
  rule S1:String =/=String S2:String => notBool (S1 ==String S2)
  rule S1:String ==String S2:String => S1 ==K S2

  syntax Bool ::= String  "<String" String              [function, functional, hook(STRING.lt)]
                | String "<=String" String              [function, functional, hook(STRING.le)]
                | String  ">String" String              [function, functional, hook(STRING.gt)]
                | String ">=String" String              [function, functional, hook(STRING.ge)]

  syntax String ::= categoryChar(String)                [function, hook(STRING.category)]
                  | directionalityChar(String)          [function, hook(STRING.directionality)]

  syntax String ::= "newUUID" [function, hook(STRING.uuid), impure]

  rule S1:String <=String S2:String => notBool (S2 <String S1)
  rule S1:String >String S2:String => S2 <String S1
  rule S1:String >=String S2:String => notBool (S1 <String S2)

  rule findChar(S1:String, S2:String, I:Int) => #if findString(S1, substrString(S2, 0, 1), I) ==Int -1 #then findChar(S1, substrString(S2, 1, lengthString(S2)), I) #else #if findChar(S1, substrString(S2, 1, lengthString(S2)), I) ==Int -1 #then findString(S1, substrString(S2, 0, 1), I) #else minInt(findString(S1, substrString(S2, 0, 1), I), findChar(S1, substrString(S2, 1, lengthString(S2)), I)) #fi #fi requires S2 =/=String ""
  rule findChar(_, "", _) => -1
  rule rfindChar(S1:String, S2:String, I:Int) => maxInt(rfindString(S1, substrString(S2, 0, 1), I), rfindChar(S1, substrString(S2, 1, lengthString(S2)), I)) requires S2 =/=String ""
  rule rfindChar(_, "", _) => -1

  rule countAllOccurrences(Source:String, ToCount:String) => 0
            requires findString(Source, ToCount, 0) <Int 0
  rule countAllOccurrences(Source:String, ToCount:String) => 1 +Int countAllOccurrences(substrString(Source, findString(Source, ToCount, 0) +Int lengthString(ToCount), lengthString(Source)), ToCount)
            requires findString(Source, ToCount, 0) >=Int 0

  rule replaceFirst(Source:String, ToReplace:String, Replacement:String) => substrString(Source, 0, findString(Source, ToReplace, 0))
                +String Replacement +String substrString(Source, findString(Source, ToReplace, 0) +Int lengthString(ToReplace), lengthString(Source))
                requires findString(Source, ToReplace, 0) >=Int 0
  rule replaceFirst(Source:String, ToReplace:String, _:String) => Source
        requires findString(Source, ToReplace, 0) <Int 0


  rule replace(Source:String, ToReplace:String, Replacement:String, Count:Int) =>
       substrString(Source, 0, findString(Source, ToReplace, 0)) +String Replacement +String
       replace(substrString(Source, findString(Source, ToReplace, 0) +Int lengthString(ToReplace), lengthString(Source)), ToReplace, Replacement, Count -Int 1)
        requires Count >Int 0
  rule replace(Source:String, _, _, 0) => Source
  rule replaceAll(Source:String, ToReplace:String, Replacement:String) => replace(Source, ToReplace, Replacement, countAllOccurrences(Source, ToReplace))

endmodule

