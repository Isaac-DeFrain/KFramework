
module STRATEGY
    imports BUILTIN-ID-TOKENS

    syntax #RuleTag ::= #LowerId                           [token]
                      | #UpperId                           [token]

    syntax Strategy ::= #STUCK() [symbol]

    syntax Strategy ::= "^" #RuleTag                      [klabel(#applyRule), symbol]

    syntax Strategy ::= "~" #RuleTag                    [klabel(#appliedRule), symbol]

    configuration <s> $STRATEGY:K  </s>
endmodule

module DEFAULT-STRATEGY-CONCRETE [concrete]
    imports syntax STRATEGY
    rule ~ regular => ^ regular [anywhere]
endmodule

module DEFAULT-STRATEGY-SYMBOLIC [symbolic]
    imports syntax STRATEGY
    rule <s> ~ regular => ^ regular ... </s>
endmodule

module DEFAULT-STRATEGY
    imports syntax STRATEGY
    imports DEFAULT-STRATEGY-CONCRETE
    imports DEFAULT-STRATEGY-SYMBOLIC

    rule initSCell(_) => <s> ^ regular </s>
endmodule

module BASIC-STRATEGY
    imports STRATEGY
    imports BOOL
    imports CONFIGURATION-PRIMITIVES

    syntax Strategy ::= Bool

    syntax Hole ::= "#SHOLE" | "#FROZEN" "(" K ")"

    syntax Strategy ::= Hole

    syntax Strategy ::= "if" Strategy "then" Strategy "else" Strategy
                        > Strategy "*"
                        > Strategy ";" Strategy                             [right]
                        > Strategy "||" Strategy                            [right]


    rule <s> S:Strategy* => if S then S* else true ...</s>

    rule <s> A:Strategy || B:Strategy => A ~> #FROZEN(THIS_CONFIGURATION:K) ~> #SHOLE || B ...</s> when notBool(isBool(A))
    rule <s> A:Bool ~> #SHOLE || B:Strategy => A || B ...</s>
    rule <s> false || B:Strategy => B ...</s>
    rule <s> true || B:Strategy => true ...</s>

    rule <s> if true then B:Strategy else C:Strategy => B ...</s>
    rule <s> if false then B:Strategy else C:Strategy => C ...</s>

    rule <s> if A:Strategy then B:Strategy else C:Strategy => (A ~> #FROZEN(THIS_CONFIGURATION:K) ~> if #SHOLE then B else C) ...</s> when notBool(isBool(A))
    rule <s> A:Bool ~> if #SHOLE then B:Strategy else C:Strategy => if A then B else C ...</s>

    rule <s> false ~> #FROZEN(CONFIGURATION:K) => #RESTORE_CONFIGURATION(CONFIGURATION) ~> false  ...</s>

    rule <s> true ~> #FROZEN(CONFIGURATION:K) => true ...</s>

//    rule <s> #STUCK ~> #applyRule(_) => false ...</s>
    rule <s> #appliedRule(_) => true ...</s>

    rule <s> A:Strategy ; B:Strategy => A ~> #SHOLE ; B ...</s> when notBool(isBool(A))

    rule <s> A:Bool ~> #SHOLE ; B:Strategy => A ; B ...</s>

    rule <s> true ; B:Strategy => B ...</s>

    rule <s> false ; B:Strategy => false ...</s>

// the second rule is stupid -- just made to sidestep what is likely a KSEQ normalization bug
    rule <s> #STUCK() ~> #applyRule(_) => false ...</s>
    rule <s> #STUCK() ~> false => false ...</s>

endmodule
