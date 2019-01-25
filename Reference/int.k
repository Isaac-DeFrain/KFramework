// Dependencies?

module UNSIGNED-INT-SYNTAX
  syntax Int [hook(INT.Int)]
  syntax Int ::= r"[0-9]+" [prefer, token, prec(2)]
endmodule

module INT-SYNTAX
  imports UNSIGNED-INT-SYNTAX
  syntax Int ::= r"[\\+-]?[0-9]+" [prefer, token, prec(2)]
endmodule

module INT
  imports INT-SYNTAX
  imports BOOL
  imports K-EQUAL

  syntax Int ::= "~Int" Int                     [function, functional, latex(\mathop{\sim_{\scriptstyle\it Int}}{#1}), hook(INT.not)]
               > left:
                 Int "^Int" Int                 [function, left, smtlib(^), latex({#1}\mathrel{{\char`\^}_{\!\scriptstyle\it Int}}{#2}), hook(INT.pow)]
               | Int "^%Int" Int Int            [function, left, smtlib((mod (^ #1 #2) #3)), hook(INT.powmod)]
               > left:
                 Int "*Int" Int                 [function, functional, left, smtlib(*), latex({#1}\mathrel{\ast_{\scriptstyle\it Int}}{#2}), hook(INT.mul)]
               /* FIXME: translate /Int and %Int into smtlib */
               /* /Int and %Int implement t-division */
               | Int "/Int" Int                 [function, left, smtlib(div), latex({#1}\mathrel{\div_{\scriptstyle\it Int}}{#2}), hook(INT.tdiv)]
               | Int "%Int" Int                 [function, left, smtlib(mod), latex({#1}\mathrel{\%_{\scriptstyle\it Int}}{#2}), hook(INT.tmod)]
               /* divInt and modInt implement e-division */
               | Int "divInt" Int               [function, left, smtlib(div), hook(INT.ediv)]
               | Int "modInt" Int               [function, left, smtlib(mod), hook(INT.emod)]
               > left:
                 Int "+Int" Int                 [function, functional, left, smtlib(+), latex({#1}\mathrel{+_{\scriptstyle\it Int}}{#2}), hook(INT.add), klabel(_+Int_), symbol]
               | Int "-Int" Int                 [function, functional, left, smtlib(-), latex({#1}\mathrel{-_{\scriptstyle\it Int}}{#2}), hook(INT.sub)]
               > left:
                 Int ">>Int" Int                [function, left, latex({#1}\mathrel{\gg_{\scriptstyle\it Int}}{#2}), hook(INT.shr)]
               | Int "<<Int" Int                [function, left, latex({#1}\mathrel{\ll_{\scriptstyle\it Int}}{#2}), hook(INT.shl)]
               > left:
                 Int "&Int" Int                 [function, functional, left, latex({#1}\mathrel{\&_{\scriptstyle\it Int}}{#2}), hook(INT.and)]
               > left:
                 Int "xorInt" Int               [function, functional, left, latex({#1}\mathrel{\oplus_{\scriptstyle\it Int}}{#2}), hook(INT.xor)]
               > left:
                 Int "|Int" Int                 [function, functional, left, latex({#1}\mathrel{|_{\scriptstyle\it Int}}{#2}), hook(INT.or)]
  syntax Int ::= "minInt" "(" Int "," Int ")"   [function, functional, smtlib(int_min), hook(INT.min)]
               | "maxInt" "(" Int "," Int ")"   [function, functional, smtlib(int_max), hook(INT.max)]
               | absInt ( Int )                 [function, functional, smtlib(int_abs), hook(INT.abs)]
               | log2Int ( Int )                [function, hook(INT.log2)]

  syntax Int ::= bitRangeInt           ( Int, indexInt: Int, lengthInt: Int ) [function, hook(INT.bitRange)]
  syntax Int ::= signExtendBitRangeInt ( Int, indexInt: Int, lengthInt: Int ) [function, hook(INT.signExtendBitRange)]

  rule bitRangeInt(I, IDX, LEN) => (I >>Int IDX) modInt (1 <<Int LEN)

  rule signExtendBitRangeInt(I, IDX, LEN) => (bitRangeInt(I, IDX, LEN) +Int (1 <<Int (LEN -Int 1))) modInt (1 <<Int LEN) -Int (1 <<Int (LEN -Int 1))

  rule I1:Int divInt I2:Int => (I1 -Int (I1 modInt I2)) /Int I2
  requires I2 =/=Int 0
  rule
    I1:Int modInt I2:Int
  =>
    ((I1 %Int absInt(I2)) +Int absInt(I2)) %Int absInt(I2)
  requires I2 =/=Int 0    [concrete]

  rule minInt(I1:Int, I2:Int) => I1 requires I1 <=Int I2
  rule minInt(I1:Int, I2:Int) => I2 requires I1 >=Int I2

  syntax Bool ::= Int "<=Int" Int         [function, functional, left, smtlib(<=), latex({#1}\mathrel{\leq_{\scriptstyle\it Int}}{#2}), hook(INT.le)]
                | Int "<Int" Int          [function, functional, left, smtlib(<), latex({#1}\mathrel{<_{\scriptstyle\it Int}}{#2}), hook(INT.lt)]
                | Int ">=Int" Int         [function, functional, left, smtlib(>=), latex({#1}\mathrel{\geq_{\scriptstyle\it Int}}{#2}), hook(INT.ge)]
                | Int ">Int" Int          [function, functional, left, smtlib(>), latex({#1}\mathrel{>_{\scriptstyle\it Int}}{#2}), hook(INT.gt)]
                | Int "==Int" Int         [function, functional, left, smtlib(=), latex({#1}\mathrel{{=}{=}_{\scriptstyle\it Int}}{#2}), hook(INT.eq), klabel(_==Int_)]
                | Int "=/=Int" Int        [function, functional, left, smtlib(distinct), latex({#1}\mathrel{{=}{/}{=}_{\scriptstyle\it Int}}{#2}), hook(INT.ne)]
                | Int "dividesInt" Int    [function]

  rule I1:Int ==Int I2:Int => I1 ==K I2
  rule I1:Int =/=Int I2:Int => notBool (I1 ==Int I2)
  rule (I1:Int dividesInt I2:Int) => (I2 %Int I1) ==Int 0

  syntax Int ::= freshInt(Int)    [freshGenerator, function, functional]
  rule freshInt(I:Int) => I

  syntax Int ::= randInt(Int) [function, hook(INT.rand)]
  syntax K ::= srandInt(Int) [function, hook(INT.srand)]
endmodule

