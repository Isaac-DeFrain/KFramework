


syntax          Proc ::= "Nil"
                       | Name "(" NamePat ")" "{" Proc "}"            [binder(2)]
                       | Name "[" Proc "]"
                       | "*" Name
                       > Proc "|" Proc

syntax          Name ::= "@" Proc

syntax       NameVar ::= Id

syntax       NamePat ::= Name
                       | NameVar

syntax       Context ::= ProcContext
                       | NameContext

syntax          Hold ::= "[]"

syntax   ProcContext ::= Hold
                       | Name "(" NamePat ")" "{" Hold "}"
                       | Name "[" Hold "]"
                       | "@" Hold
                       > Hold "|" Proc
                       | Proc "|" Hold
                       | Hold "|" Hold

syntax   NameContext ::= "*" Hold
                       | Hold "(" NamePat ")" "{" Proc "}"
                       | Name "(" Hold    ")" "{" Proc "}"
                       | Hold "(" Hold    ")" "{" Proc "}"
                       | Hold "[" Proc "]"
