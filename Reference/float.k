
module FLOAT-SYNTAX
  syntax Float [hook(FLOAT.Float)]
  syntax Float ::= r"([\\+-]?[0-9]+(\\.[0-9]*)?|\\.[0-9]+)([eE][\\+-]?([0-9]+(\\.[0-9]*)?|\\.[0-9]d+))?([fFdD]|([pP][0-9]+[xX][0-9]+))?" [token, prec(1)]
  syntax Float ::= r"[\\+-]?Infinity([fFdD]|([pP][0-9]+[xX][0-9]+))?" [token]
  syntax Float ::= r"NaN([fFdD]|([pP][0-9]+[xX][0-9]+))?" [token]
endmodule

module FLOAT
  imports FLOAT-SYNTAX
  imports BOOL
  imports INT-SYNTAX

  syntax Int ::= precisionFloat(Float) [function, functional, hook(FLOAT.precision)]
               | exponentFloat(Float) [function, functional, hook(FLOAT.exponent)]
               | exponentBitsFloat(Float) [function, functional, hook(FLOAT.exponentBits)]

  syntax Bool ::= signFloat(Float)      [function, functional, hook(FLOAT.sign)]
                | isNaN(Float)          [function, functional, smtlib((not (== #1 #1))), hook(FLOAT.isNaN)]
                | isInfinite(Float)     [function, functional]
  syntax MInt ::= significandFloat(Float) [function, hook(FLOAT.significand)]

  syntax Float ::= "--Float" Float             [function, functional, smtlib(-), hook(FLOAT.neg)]
                 > Float "^Float" Float        [function, left, latex({#1}^{#2}), hook(FLOAT.pow)]
                 > left:
                   Float "*Float" Float        [function, left, smtlib((* roundNearestTiesToEven #1 #2)), latex({#1}\mathrel{\ast_{\scriptstyle\it Float}}{#2}), hook(FLOAT.mul)]
                 | Float "/Float" Float        [function, left, smtlib((/ roundNearestTiesToEven #1 #2)), latex({#1}\mathrel{\div_{\scriptstyle\it Float}}{#2}), hook(FLOAT.div)]
                 | Float "%Float" Float        [function, left, smtlib((remainder roundNearestTiesToEven #1 #2)), latex({#1}\mathrel{\%_{\scriptstyle\it Float}}{#2}), hook(FLOAT.rem)]
                 > left:
                   Float "+Float" Float        [function, left, smtlib((+ roundNearestTiesToEven #1 #2)), latex({#1}\mathrel{+_{\scriptstyle\it Float}}{#2}), hook(FLOAT.add)]
                 | Float "-Float" Float        [function, left, smtlib((- roundNearestTiesToEven #1 #2)), latex({#1}\mathrel{-_{\scriptstyle\it Float}}{#2}), hook(FLOAT.sub)]

  syntax Float ::= rootFloat(Float, Int)        [function, hook(FLOAT.root)]
                 | absFloat(Float)              [function, functional, smtlib(abs), hook(FLOAT.abs)]
                 | roundFloat(Float, Int, Int)  [function, hook(FLOAT.round)]
                 | floorFloat(Float)            [function, functional, hook(FLOAT.floor)]
                 | ceilFloat(Float)             [function, functional, hook(FLOAT.ceil)]
                 | expFloat(Float)              [function, functional, hook(FLOAT.exp)]
                 | logFloat(Float)              [function, hook(FLOAT.log)]
                 | sinFloat(Float)              [function, functional, hook(FLOAT.sin)]
                 | cosFloat(Float)              [function, functional, hook(FLOAT.cos)]
                 | tanFloat(Float)              [function, hook(FLOAT.tan)]
                 | asinFloat(Float)             [function, hook(FLOAT.asin)]
                 | acosFloat(Float)             [function, hook(FLOAT.acos)]
                 | atanFloat(Float)             [function, functional, hook(FLOAT.atan)]
                 | atan2Float(Float, Float)     [function, hook(FLOAT.atan2)]
                 | maxFloat(Float, Float)       [function, smtlib(max), hook(FLOAT.max)]
                 | minFloat(Float, Float)       [function, smtlib(min), hook(FLOAT.min)]
                 | sqrtFloat(Float)             [function]
                 | maxValueFloat(Int, Int)      [function, hook(FLOAT.maxValue)]
                 | minValueFloat(Int, Int)      [function, hook(FLOAT.minValue)]

  syntax Bool ::= Float "<=Float" Float       [function, left, smtlib(<=), latex({#1}\mathrel{\leq_{\scriptstyle\it Float}}{#2}), hook(FLOAT.le)]
                | Float "<Float" Float        [function, left, smtlib(<), latex({#1}\mathrel{<_{\scriptstyle\it Float}}{#2}), hook(FLOAT.lt)]
                | Float ">=Float" Float       [function, left, smtlib(>=), latex({#1}\mathrel{\geq_{\scriptstyle\it Float}}{#2}), hook(FLOAT.ge)]
                | Float ">Float" Float        [function, left, smtlib(>), latex({#1}\mathrel{>_{\scriptstyle\it Float}}{#2}), hook(FLOAT.gt)]
                | Float "==Float" Float       [function, left, smtlib(==), latex({#1}\mathrel{==_{\scriptstyle\it Float}}{#2}), hook(FLOAT.eq), klabel(_==Float_)]
                | Float "=/=Float" Float      [function, left, smtlib((not (== #1 #2))), latex({#1}\mathrel{\neq_{\scriptstyle\it Float}}{#2})]


  rule F1:Float =/=Float F2:Float => notBool (F1 ==Float F2)

  syntax Float ::= Int2Float(Int, Int, Int)    [function, latex({\\it{}Int2Float}), hook(FLOAT.int2float)]
  syntax Int ::= Float2Int(Float)    [function, functional, latex({\\it{}Float2Int}), hook(FLOAT.float2int)]

  rule sqrtFloat(F:Float) => rootFloat(F, 2)

  rule isInfinite(F:Float) => F >Float maxValueFloat(precisionFloat(F), exponentBitsFloat(F)) orBool F <Float --Float maxValueFloat(precisionFloat(F), exponentBitsFloat(F))

endmodule

