// Red-Black-Green Rho Calculus

  syntax   ProcA ::= "NilA"
                   | ProcB
                   | ProcC
                   | "for" "(" NameA "<-" NameA ")" "{" ProcA "}"
                   | NameA "!" "(" ProcA ")"
                   | ProcA "|" ProcA
                   | "*" NameA

  syntax   NameA ::= "@" ProcA

  syntax   ProcB ::= "NilB"
                   | ProcA
                   | ProcC
                   | "for" "(" NameB "<-" NameB ")" "{" ProcB "}"
                   | NameB "!" "(" ProcB ")"
                   | ProcB "|" ProcB
                   | "*" NameB

  syntax   NameB ::= "@" ProcB

  syntax   ProcC ::= "NilC"
                   | ProcA
                   | ProcB
                   | "for" "(" NameC "<-" NameC ")" "{" ProcC "}"
                   | NameC "!" "(" ProcC ")"
                   | ProcC "|" ProcC
                   | "*" NameC

  syntax   NameC ::= "@" ProcC