// The #isIn predicate - checks for type inclusion

// Patterns detected by appearance of "pat" as substring of the first or second type argument!!!
// Concrete processes may only have "pat" appear as a substring in the third type argument!!!

require "stype.k"

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
rule [      StrProc:String ;;      ProcType1:Type ;;      ProcType2:Type ] #isIn
     [ StrProcOrPat:String ;; ProcOrPatType1:Type ;; ProcOrPatType2:Type ]
     =>
     #if toString([      StrProc:String ;;      ProcType1:Type ;;      ProcType2:Type ]) ==String
         toString([ StrProcOrPat:String ;; ProcOrPatType1:Type ;; ProcOrPatType2:Type ])
     #then
       true                                                                                            // ProcOrPat == Proc
     #else
       #if StrProc ==String StrProcOrPat
       #then
         // Leaves are: truncate, procvar, namevar, nil, bool, int, string
         // RECURSION
         // #if ProcType1 ==String "truncate"
         // #then true(?) ...continue...
         // #else #if ...procvar...continue...
         #if
           {PCSType1 #isIn PTNType1} and {PCSType2 #isIn PTNType2}
         #then
           true
         #else
           false
         #fi
       #else
         #if StrProcOrPat ==String "procvar"       (don't understand this yet)
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
