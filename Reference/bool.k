
module BOOL-SYNTAX
  syntax Bool [hook(BOOL.Bool)]
  syntax Bool ::= "true"  [token]
  syntax Bool ::= "false" [token]
endmodule

module BOOL
  imports BASIC-K
  imports BOOL-SYNTAX
  syntax Bool ::= "notBool" Bool          [function, functional, klabel(notBool_), symbol, smtlib(not), boolOperation, latex(\neg_{\scriptstyle\it Bool}{#1}), hook(BOOL.not)]
                > Bool "andBool" Bool     [function, functional, klabel(_andBool_), symbol, left, smtlib(and), boolOperation, latex({#1}\wedge_{\scriptstyle\it Bool}{#2}), hook(BOOL.and)]
                | Bool "andThenBool" Bool [function, functional, left, smtlib(and), boolOperation, hook(BOOL.andThen)]
                | Bool "xorBool" Bool     [function, functional, left, smtlib(xor), boolOperation, hook(BOOL.xor)]
                | Bool "orBool" Bool      [function, functional, left, smtlib(or), boolOperation, latex({#1}\vee_{\scriptstyle\it Bool}{#2}), hook(BOOL.or)]
                | Bool "orElseBool" Bool  [function, functional, left, smtlib(or), boolOperation, hook(BOOL.orElse)]
                | Bool "impliesBool" Bool [function, functional, left, smtlib(=>), boolOperation, hook(BOOL.implies)]
                > left:
                  Bool "==Bool" Bool      [function, functional, left, smtlib(=), hook(BOOL.eq)]
                | Bool "=/=Bool" Bool     [function, functional, left, smtlib(distinct), hook(BOOL.ne)]

  rule notBool true => false
  rule notBool false => true

  rule true andBool B:Bool => B:Bool
  rule B:Bool andBool true => B:Bool
  rule false andBool _:Bool => false
  rule _:Bool andBool false => false

  rule true andThenBool K::Bool => K
  rule K::Bool andThenBool true => K
  rule false andThenBool _ => false
  rule _ andThenBool false => false

  rule false xorBool B:Bool => B:Bool
  rule B:Bool xorBool false => B:Bool
  rule B:Bool xorBool B:Bool => false
  rule B1:Bool xorBool B2:Bool => notBool (B1 ==Bool B2)

  rule true orBool _:Bool => true
  rule _:Bool orBool true => true
  rule false orBool B:Bool => B
  rule B:Bool orBool false => B

  rule true orElseBool _ => true
  rule _ orElseBool true => true
  rule false orElseBool K::Bool => K
  rule K::Bool orElseBool false => K

  rule true impliesBool B:Bool => B
  rule false impliesBool _:Bool => true
  rule _:Bool impliesBool true => true
  rule B:Bool impliesBool false => notBool B

  rule B1:Bool =/=Bool B2:Bool => notBool (B1 ==Bool B2)

endmodule

