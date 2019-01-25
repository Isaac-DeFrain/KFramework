
module BYTES-HOOKED [concrete]
  syntax Bytes [hook(BYTES.Bytes)]

  syntax      Bytes ::= ".Bytes"                                  [function, functional, hook(BYTES.empty), impure]
  syntax Endianness ::= "LE"                                      [klabel(littleEndianBytes), symbol]
                      | "BE"                                      [klabel(bigEndianBytes), symbol]
  syntax Signedness ::= "Signed"                                  [klabel(signedBytes), symbol]
                      | "Unsigned"                                [klabel(unsignedBytes), symbol]
  syntax        Int ::= Bytes2Int(Bytes, Endianness, Signedness)  [function, functional, hook(BYTES.bytes2int)]
  syntax      Bytes ::= Int2Bytes(Int, Int, Endianness)           [function, functional, hook(BYTES.int2bytes)]
                      | Int2Bytes(Int, Endianness, Signedness)    [function, functional, klabel(Int2BytesNoLen)]
  syntax     String ::= Bytes2String(Bytes)                       [function, functional, hook(BYTES.bytes2string)]
  syntax      Bytes ::= String2Bytes(String)                      [function, functional, hook(BYTES.string2bytes)]

  syntax      Bytes ::= substrBytes(Bytes, Int, Int)              [function, hook(BYTES.substr)]
  syntax      Bytes ::= replaceAtBytes(Bytes, Int, Bytes)         [function, hook(BYTES.replaceAt)]
  syntax      Bytes ::= padRightBytes(Bytes, Int, Int)            [function, hook(BYTES.padRight)]
                      | padLeftBytes(Bytes, Int, Int)             [function, hook(BYTES.padLeft)]
  syntax      Bytes ::= reverseBytes(Bytes)                       [function, functional, hook(BYTES.reverse)]

  syntax        Int ::= lengthBytes(Bytes)                        [function, functional, hook(BYTES.length), smtlib(lengthBytes)]

  syntax      Bytes ::= Bytes "+Bytes" Bytes                      [function, functional, hook(BYTES.concat), right]
endmodule

module BYTES-IN-K [symbolic]
  import INT
  import K-EQUAL
  import STRING
  import STRING-BUFFER

  syntax      Bytes ::= "nilBytes"
                      | Int ":" Bytes
  syntax Endianness ::= "LE"          [klabel(littleEndianBytes), symbol]
                      | "BE"          [klabel(bigEndianBytes), symbol]
  syntax Signedness ::= "Signed"      [klabel(signedBytes), symbol]
                      | "Unsigned"    [klabel(unsignedBytes), symbol]

  syntax Bytes ::= ".Bytes"           [function, functional]
  rule .Bytes => nilBytes

  syntax Int ::= Bytes2Int(Bytes, Endianness, Signedness)  [function, functional]
  rule Bytes2Int(nilBytes, _, _) => 0
  rule Bytes2Int(B : nilBytes, BE, Unsigned) => B
  rule Bytes2Int(B0 : B1 : BS, BE, Unsigned) => Bytes2Int(((B0 <<Int 8) |Int B1) : BS, BE, Unsigned)
  rule Bytes2Int(B0 : BS, BE, Signed) => signExtendBitRangeInt(Bytes2Int(B0 : BS, BE, Unsigned), 0, lengthBytes(B0 : BS) <<Int 3)
  rule Bytes2Int(B0 : BS, LE, S) => Bytes2Int(reverseBytes(B0 : BS), BE, S)

  syntax Bytes ::= Int2Bytes(Int, Bytes)                   [function, klabel(Int2BytesAux)]
  syntax Bytes ::= Int2Bytes(Int, Int, Endianness)         [function, functional]
                 | Int2Bytes(Int, Endianness, Signedness)  [function, functional, klabel(Int2BytesNoLen)]
  rule Int2Bytes(LEN, I, BE) => padLeftBytes(Int2Bytes(bitRangeInt(I, 0, LEN <<Int 3), nilBytes), LEN, #if I <Int 0 #then 255 #else 0 #fi)
  rule Int2Bytes(LEN, I, LE) => reverseBytes(Int2Bytes(LEN, I, BE))
  rule Int2Bytes(0, BS) => BS
  rule Int2Bytes(I, BS) => Int2Bytes(I >>Int 8, I &Int 255 : BS) requires I =/=Int 0

  syntax String ::= Bytes2String(Bytes, StringBuffer) [function, klabel(Bytes2StringAux)]
  syntax String ::= Bytes2String(Bytes) [function, functional]
  rule Bytes2String(BS) => Bytes2String(BS, .StringBuffer)
  rule Bytes2String(nilBytes, BUFFER) => StringBuffer2String(BUFFER)
  rule Bytes2String(B : BS, BUFFER) => Bytes2String(BS, BUFFER +String chrChar(B))

  syntax Bytes ::= String2Bytes(String) [function, functional]
  rule String2Bytes(S) => ordChar(substrString(S, 0, 1)) : String2Bytes(substrString(S, 1, lengthString(S))) requires lengthString(S) >=Int 1
  rule String2Bytes("") => nilBytes

  syntax Bytes ::= substrBytes(Bytes, Int, Int) [function]
  rule substrBytes(BS, 0, 0) => nilBytes
  rule substrBytes(B : BS, N, M) => substrBytes(BS, N -Int 1, M -Int 1) requires N >Int 0
  rule substrBytes(B : BS, 0, M) => B : substrBytes(BS, 0, M -Int 1) requires M >Int 0

  syntax Bytes ::= replaceAtBytes(Bytes, Int, Bytes) [function]
  rule replaceAtBytes(BS, _, nilBytes) => BS
  rule replaceAtBytes(B : BS, N, BS') => B : replaceAtBytes(BS, N -Int 1, BS') requires N >Int 0
  rule replaceAtBytes(_ : BS, 0, B : BS') => B : replaceAtBytes(BS, 0, BS')

  syntax Bytes ::= padRightBytes(Bytes, Int, Int) [function]
                 | padLeftBytes(Bytes, Int, Int) [function]
  rule padRightBytes(BS, LEN, VAL) => reverseBytes(padLeftBytes(reverseBytes(BS), LEN, VAL))
  rule padLeftBytes(BS, LEN, VAL) => BS requires lengthBytes(BS) >=Int LEN
  rule padLeftBytes(BS, LEN, VAL) => padLeftBytes(VAL : BS, LEN, VAL) requires lengthBytes(BS) <Int LEN

  syntax Bytes ::= reverseBytes(Bytes) [function, functional]
  syntax Bytes ::= reverseBytes(Bytes, Bytes) [function, klabel(reverseBytesAux)]
  rule reverseBytes(BS) => reverseBytes(BS, nilBytes)
  rule reverseBytes(nilBytes, BS) => BS
  rule reverseBytes(B : BS, BS') => reverseBytes(BS, B : BS')

  syntax Int ::= lengthBytes(Bytes) [function, functional, smtlib(lengthBytes)]
  syntax Int ::= lengthBytes(Bytes, Int) [function, klabel(lengthBytesAux), smtlib(lengthBytesAux)]
  rule lengthBytes(BS) => lengthBytes(BS, 0)
  rule lengthBytes(nilBytes, SIZE) => SIZE
  rule lengthBytes(B : BS, SIZE) => lengthBytes(BS, SIZE +Int 1)

  syntax Bytes ::= Bytes "+Bytes" Bytes [function, functional, right]
  rule nilBytes +Bytes B2 => B2
  rule (B : BS) +Bytes B2 => B : (BS +Bytes B2)
endmodule

module BYTES
  import BYTES-HOOKED
  import BYTES-IN-K
  import INT

  rule Int2Bytes(I, E, Unsigned) => Int2Bytes((log2Int(I) +Int 8) /Int 8, I, E)
    requires I >Int 0
  rule Int2Bytes(0, _::Endianness, _) => .Bytes
  rule Int2Bytes(I, E, Signed) => Int2Bytes((log2Int(I) +Int 9) /Int 8, I, E)
    requires I >Int 0
  rule Int2Bytes(I, E, Signed) => Int2Bytes((log2Int(~Int I) +Int 9) /Int 8, I, E)
    requires I <Int -1
  rule Int2Bytes(-1, E, Signed) => Int2Bytes(1, -1, E)
endmodule


