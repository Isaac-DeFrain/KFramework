// The #isIn predicate - checks for type inclusion

require "../StructuralType/stype.k"

module IS-IN-SYNTAX
import STYPE

// The function #isIn is the inclusion predicate
syntax Bool ::= Type "#isIn"      Type  [function, strict]

// Auxiliaries
syntax Bool ::= Type "#isIn-leaf" Type  [function, strict]
syntax Bool ::= Type "#isIn-pat"  Type  [function, strict]

endmodule

module IS-IN
import IS-IN-SYNTAX
/*
// Semantics for the #isIn predicate
rule [ StringPCS:String ;; PCSType1:Type ;; PCSType2:Type ] #isIn
     [ StringPTN:String ;; PTNType1:Type ;; PTNType2:Type ]
     =>
     #if toString([ StringPCS:String ;; PCSType1:Type ;; PCSType2:Type ]) ==String
         toString([ StringPTN:String ;; PTNType1:Type ;; PTNType2:Type ])
     #then
       true
     #else
       #if StringPCS ==String StringPTN
       #then
         // #if LEAF
         // Leaves are: #truncate, NameVar, Nil, ProcVar, bool, int, string, uri, unforgeable
         // RECURSION
         // #then TRUE
         // #else FALSE
         #if
           {PCSType1 #isIn PTNType1} and {PCSType2 #isIn PTNType2}
         #then
           true
         #else
           false
         #fi
       #else
         #if StringPTN ==String "procvar"
          #then
            // #if WILDCARD #then OK
            // #else ...
            #if #isProc [ StringPCS:String ;; PCSType1:Type ;; PCSType2:Type ]
            #then true
          #else
            #if StringPTN ==String "namevar"
            #then
              // #if WILDCARD #then OK
              // #else ...
              #if #isName [ StringPCS:String ;; PCSType1:Type ;; PCSType2:Type ]
              #then true
            #else
              #if // ANY PATTERN TYPE
              #then
                // match to the simple type
              #else
                false
              #fi
            #fi
          #fi
       #fi
     #fi
*/
endmodule
