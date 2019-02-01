
// Module defining only the sorts K and KString, useful for modularity
//-----------
module SORT-K
//-----------

  syntax K                           [hook(K.K)]

endmodule

//------------
module BASIC-K
//------------

import SORT-K

  syntax KItem                   [hook(K.KItem)]
  syntax KConfigVar                      [token]
  syntax               K ::= KItem

endmodule

//------------
module KSTRING
//------------

  syntax         KString ::= r"[\\\"](([^\\\"\\n\\r\\\\])|([\\\\][nrtf\\\"\\\\])|([\\\\][x][0-9a-fA-F]{2})|([\\\\][u][0-9a-fA-F]{4})|([\\\\][U][0-9a-fA-F]{8}))*[\\\"]"   [token]
                             // optionally qualified strings, like in Scala "abc", i"abc", r"a*bc", etc.

endmodule

//----------------------
module BUILTIN-ID-TOKENS
//----------------------

  syntax        #LowerId ::= r"[a-z][a-zA-Z0-9]*"                   [prec(2), token]
  syntax        #UpperId ::= r"[A-Z][a-zA-Z0-9]*"                   [prec(2), token]

endmodule

//---------------
module SORT-KBOTT
//---------------

import SORT-K

  syntax KBott

endmodule

//---------
module KAST
//---------

import BASIC-K
import SORT-KBOTT
import KSTRING
import BUILTIN-ID-TOKENS

  syntax           KBott ::= "#token" "(" KString "," KString ")"   [klabel(#KToken), symbol]
                           | "#klabel" "(" KLabel ")"               [klabel(#WrappedKLabel), symbol]
                           | KLabel "(" KList ")"                   [klabel(#KApply), symbol]

  syntax           KItem ::= KBott

  syntax          KLabel ::= r"`(\\\\`|\\\\\\\\|[^`\\\\\\n\\r])+`"  [token]
                           | #LowerId                               [token, autoReject]
                           | r"(?<![a-zA-Z0-9])[#a-z][a-zA-Z0-9]*"  [token, autoReject, prec(1)]
                           // something that doesn't collide with meta-variables

  syntax           KList ::= K
                           | ".KList"                               [klabel(#EmptyKList), symbol]
                           | ".::KList"                             [klabel(#EmptyKList), symbol]
                           | KList "," KList                        [klabel(#KList), left, assoc, unit(#EmptyKList), symbol, prefer]

endmodule


// To be used when parsing/pretty-printing ground configurations
//---------
module KSEQ
//---------

import KAST
import K-TOP-SORT

  syntax left #KSequence

  syntax           KBott ::= ".K"                                   [klabel(#EmptyK), symbol, unparseAvoid]
//                         | "."                                    [klabel(#EmptyK), symbol]
                           | ".::K"                                 [klabel(#EmptyK), symbol, unparseAvoid]

  syntax               K ::= K "~>" K                               [klabel(#KSequence), left, assoc, unit(#EmptyK), symbol]
                           | "(" K ")"                              [bracket, poly(0, 1)]

endmodule


// To be used when parsing/pretty-printing symbolic configurations
//------------------
module KSEQ-SYMBOLIC
//------------------

import KSEQ

  syntax      #KVariable ::= r"(?<![A-Za-z0-9_\\$!\\?])(\\!|\\?)?([A-Z][A-Za-z0-9'_]*|_)"   [token, prec(1), autoReject]
                           | #UpperId                                                       [token, autoReject]

  syntax      KConfigVar ::= r"(?<![A-Za-z0-9_\\$!\\?])(\\$)([A-Z][A-Za-z0-9'_]*)"          [token, autoReject]

  syntax           KBott ::= #KVariable
                           | KConfigVar

  syntax          KLabel ::= #KVariable

  syntax        #Pattern ::= "#True"                                [klabel(#True), symbol]
                           | "#False"                               [klabel(#False), symbol]
                           | K
                           | "(" #Pattern ")"                       [bracket]
                           | "#Not"  "(" #Pattern ")"               [klabel(#Not), symbol, mlOp]
                           | "#Ceil" "(" #Pattern ")"               [klabel(#Ceil), symbol, mlOp]
                           > #Pattern  "#Equals" #Pattern           [klabel(#Equals), symbol, mlOp, format(%i%1%d%n%2%n%i%3%d)]
                           > #Pattern     "#And" #Pattern           [klabel(#And), symbol, assoc, comm, unit(#True), mlOp, format(%i%1%d%n%2%n%i%3%d)]
                           > #Pattern      "#Or" #Pattern           [klabel(#Or), symbol, assoc, comm, unit(#False), mlOp, format(%i%1%d%n%2%n%i%3%d)]
                           > #Pattern "#Implies" #Pattern           [klabel(#Implies), symbol, mlOp, format(%i%1%d%n%2%n%i%3%d)]
                           > "#Exists" #KVariable "." #Pattern      [klabel(#Exists), symbol, mlOp]
                           | "#Forall" #KVariable "." #Pattern      [klabel(#Forall), symbol, mlOp]

endmodule

//-----------
module KCELLS
//-----------

import KAST

  syntax Cell

  syntax              Bag ::= Bag Bag  [left, assoc, klabel(#cells), symbol, unit(#cells)]
                           | ".Bag"                                 [klabel(#cells), symbol]
                           | ".::Bag" [klabel(#cells), symbol]
                           | Cell
                           | KBott
                           | "(" Bag ")" [bracket]

  syntax               K ::= Bag

endmodule

//---------------
module RULE-CELLS
//---------------

import KCELLS
import RULE-LISTS

  // if this module is imported, the parser automatically
  // generates, for all productions that have the attribute 'cell' or 'maincell',
  // a production like below:
  //syntax Cell ::= "<top>" #OptionalDots K #OptionalDots "</top>" [klabel(<top>)]

  syntax   #OptionalDots ::= "..." [klabel(#dots), symbol]
                           | ""    [klabel(#noDots), symbol]
endmodule

//-----------------
module CONFIG-CELLS
//-----------------

import KCELLS
import RULE-LISTS

  syntax       #CellName ::= r"[a-zA-Z][a-zA-Z0-9\\-]*"      [token, prec(1)]
                           | #LowerId                        [token]
                           | #UpperId                        [token]

  syntax            Cell ::= "<" #CellName #CellProperties ">" K "</" #CellName ">" [klabel(#configCell), symbol]
  syntax            Cell ::= "<" #CellName "/>" [klabel(#externalCell), symbol]

  syntax #CellProperties ::= #CellProperty #CellProperties   [klabel(#cellPropertyList), symbol]
                           | ""                              [klabel(#cellPropertyListTerminator), symbol]

  syntax   #CellProperty ::= #CellName "=" KString           [klabel(#cellProperty), symbol]

endmodule


module REQUIRES-ENSURES
import BASIC-K

  syntax     RuleContent ::= K                               [klabel("#ruleNoConditions"), symbol]
                           | K "requires" K                  [klabel("#ruleRequires"), symbol]
                           | K "when" K                      [klabel("#ruleRequires"), symbol]
                           | K "ensures"  K                  [klabel("#ruleEnsures"), symbol]
                           | K "requires" K "ensures" K      [klabel("#ruleRequiresEnsures"), symbol]
                           | K "when" K "ensures" K          [klabel("#ruleRequiresEnsures"), symbol]

endmodule

//---------------
module K-TOP-SORT
//---------------

import SORT-KBOTT

  syntax           KItem ::= KBott [poly(1)]

endmodule

//------------------
module K-BOTTOM-SORT
//------------------

import SORT-KBOTT

  syntax           KItem ::= KBott [poly(0)]

endmodule

//-------------------
module K-SORT-LATTICE
//-------------------

import K-TOP-SORT
import K-BOTTOM-SORT

endmodule

//---------------
module AUTO-CASTS
//---------------

  // if this module is imported, the parser automatically
  // generates, for all sorts, productions of the form:
  //                Sort ::= Sort "::Sort"
  //                       | Sort  ":Sort"
  //                       | K    ":>Sort"
  //
  //               KBott ::= Sort "<:Sort"
  //
  // this is part of the mechanism that allows concrete user syntax in K

endmodule

//----------------
module AUTO-FOLLOW
//----------------

  // if this module is imported, the parser automatically
  // generates a follow restriction for every terminal which is a prefix
  // of another terminal. This is useful to prevent ambiguities such as:
  // syntax K ::= "a"
  // syntax K ::= "b"
  // syntax K ::= "ab"
  // syntax K ::= K K
  // #parse("ab", "K")
  // In the above example, the terminal "a" is not allowed to be followed by a "b"
  // because it would turn the terminal into the terminal "ab".

endmodule

//------------------
module PROGRAM-LISTS
//------------------

import SORT-K

  // if this module is imported, the parser automatically
  // replaces the default productions for lists:
  // Es ::= E "," Es [userList("*"), klabel('_,_)]
  //      | ".Es"    [userList("*"), klabel('.Es)]
  // into a series of productions more suitable for programs:
  // Es#Terminator ::= ""      [klabel('.Es)]
  // Ne#Es ::= E "," Ne#Es     [klabel('_,_)]
  //         | E Es#Terminator [klabel('_,_)]
  // Es ::= Ne#Es
  //      | Es#Terminator      // if the list is *

endmodule

//---------------
module RULE-LISTS
//---------------

  // if this module is imported, the parser automatically
  // adds the subsort production to the parsing module only:
  // Es ::= E        [userList("*")]

endmodule

//-------------------
module DEFAULT-LAYOUT
//-------------------

    syntax       #Layout ::= r"(\\/\\*([^\\*]|(\\*+([^\\*\\/])))*\\*+\\/)"
                           | r"(\\/\\/[^\\n\\r]*)"
                           | r"([\\ \\n\\r\\t])"

endmodule

//--------------------------
module DEFAULT-CONFIGURATION
//--------------------------

import BASIC-K

  configuration <k> $PGM:K </k>

endmodule

//-----------------------
module RECORD-PRODUCTIONS
//-----------------------

  // if this module is imported, prefix productions of the form
  // syntax Sort ::= name(Args)
  // will be able to be parsed with don't-care variables according
  // to their nonterminal's names

endmodule

// To be used to parse semantic rules
//------
module K
//------

import KSEQ-SYMBOLIC
import REQUIRES-ENSURES
import RECORD-PRODUCTIONS
import K-SORT-LATTICE
import AUTO-CASTS
import AUTO-FOLLOW

  syntax non-assoc #KRewrite
  syntax               K ::= K  "=>" K                              [klabel(#KRewrite), symbol, poly(0, 1, 2)]
                           | K "#as" K                              [klabel(#KAs), symbol, poly(0, 1, 2)]

  // functions that preserve sorts and can therefore have inner rewrites
  syntax               K ::= "#fun" "(" K ")" "(" K ")"             [klabel(#fun2), symbol, poly(0, 1, 2), prefer]

  // functions that do not preserve sort and therefore cannot have inner rewrites
  syntax               K ::= "#fun" "(" K "=>" K ")" "(" K ")"      [klabel(#fun3), symbol, poly(0, 2; 1, 3)]

endmodule

// To be used to parse terms in full K
//-----------
module K-TERM
//-----------

import KSEQ-SYMBOLIC
import RECORD-PRODUCTIONS
import K-SORT-LATTICE
import AUTO-CASTS
import AUTO-FOLLOW

endmodule

//------------
module K-EQUAL
//------------

import BOOL
import BASIC-K

  syntax            Bool ::= left:  K  "==K" K                      [function, functional, smtlib(=), hook(KEQUAL.eq), klabel(_==K_), symbol, latex({#1}\mathrel{=_K}{#2}), equalEqualK]
                           |        K "=/=K" K                      [function, functional, smtlib(distinct), hook(KEQUAL.ne), klabel(_=/=K_), symbol, latex({#1}\mathrel{\neq_K}{#2}), notEqualEqualK]

  syntax priorities equalEqualK notEqualEqualK > boolOperation mlOp

  rule K1:K =/=K K2:K => notBool (K1 ==K K2)
  rule K1:Bool ==Bool K2:Bool => K1 ==K K2

  syntax               K ::= "#if" Bool "#then" K "#else" K "#fi"   [function, functional, smtlib(ite), hook(KEQUAL.ite), poly(0, 2, 3)]

  rule #if C:Bool #then B1 #else _ #fi => B1 requires C
  rule #if C:Bool #then _ #else B2 #fi => B2 requires notBool C

endmodule

//-----------------
module K-REFLECTION
//-----------------

import BASIC-K
import STRING
import K-REFLECTION-SYMBOLIC

  syntax               K ::= "#configuration"                       [function, impure, hook(KREFLECTION.configuration)]

  syntax           KItem ::= #fresh(String)                         [function, hook(KREFLECTION.fresh), impure]
                           | getKLabel(K)                           [function, hook(KREFLECTION.getKLabel)]

  syntax          String ::= #sort(K)                               [function, hook(KREFLECTION.sort)]
                           | #getenv(String)                        [function, impure, hook(KREFLECTION.getenv)]

  // meaningful only for the purposes of compilation to a binary, otherwise
  // undefined
  syntax            List ::= #argv()                                [function, hook(KREFLECTION.argv)]

endmodule

//-------------------------------------
module K-REFLECTION-SYMBOLIC [symbolic]
//-------------------------------------

import BASIC-K
import STRING

  // return empty string if the term has no klabel
  syntax         String ::= #getKLabelString(K)                     [function, hook(KREFLECTION.getKLabelString)]

  // return true if no variable nor unresolved function appears in any subterm
  syntax           Bool ::= #isConcrete(K)                          [function, hook(KREFLECTION.isConcrete)]
                          | #isVariable(K)                          [function, hook(KREFLECTION.isVariable)]
endmodule

//---------
module K-IO
//---------

import LIST
import STRING

  syntax        IOError ::= "#EOF" | "#noparse" | #unknownIOError(Int)
                          | "#E2BIG"
                          | "#EACCES"
                          | "#EAGAIN"
                          | "#EBADF"
                          | "#EBUSY"
                          | "#ECHILD"
                          | "#EDEADLK"
                          | "#EDOM"
                          | "#EEXIST"
                          | "#EFAULT"
                          | "#EFBIG"
                          | "#EINTR"
                          | "#EINVAL"
                          | "#EIO"
                          | "#EISDIR"
                          | "#EMFILE"
                          | "#EMLINK"
                          | "#ENAMETOOLONG"
                          | "#ENFILE"
                          | "#ENODEV"
                          | "#ENOENT"
                          | "#ENOEXEC"
                          | "#ENOLCK"
                          | "#ENOMEM"
                          | "#ENOSPC"
                          | "#ENOSYS"
                          | "#ENOTDIR"
                          | "#ENOTEMPTY"
                          | "#ENOTTY"
                          | "#ENXIO"
                          | "#EPERM"
                          | "#EPIPE"
                          | "#ERANGE"
                          | "#EROFS"
                          | "#ESPIPE"
                          | "#ESRCH"
                          | "#EXDEV"
                          | "#EWOULDBLOCK"
                          | "#EINPROGRESS"
                          | "#EALREADY"
                          | "#ENOTSOCK"
                          | "#EDESTADDRREQ"
                          | "#EMSGSIZE"
                          | "#EPROTOTYPE"
                          | "#ENOPROTOOPT"
                          | "#EPROTONOSUPPORT"
                          | "#ESOCKTNOSUPPORT"
                          | "#EOPNOTSUPP"
                          | "#EPFNOSUPPORT"
                          | "#EAFNOSUPPORT"
                          | "#EADDRINUSE"
                          | "#EADDRNOTAVAIL"
                          | "#ENETDOWN"
                          | "#ENETUNREACH"
                          | "#ENETRESET"
                          | "#ECONNABORTED"
                          | "#ECONNRESET"
                          | "#ENOBUFS"
                          | "#EISCONN"
                          | "#ENOTCONN"
                          | "#ESHUTDOWN"
                          | "#ETOOMANYREFS"
                          | "#ETIMEDOUT"
                          | "#ECONNREFUSED"
                          | "#EHOSTDOWN"
                          | "#EHOSTUNREACH"
                          | "#ELOOP"
                          | "#EOVERFLOW"

  syntax            Int ::= "#open" "(" String ")"                  [function]
                          | "#open" "(" String "," String ")"       [function, hook(IO.open), impure]
                          | "#tell" "(" Int ")"                     [function, hook(IO.tell), impure]
                          | "#getc" "(" Int ")"                     [function, hook(IO.getc), impure]

  syntax         String ::= "#read" "(" Int "," Int ")"             [function, hook(IO.read), impure]

  syntax              K ::= "#close"   "(" Int ")"                  [function, hook(IO.close), impure]
                          | "#seek"    "(" Int "," Int ")"          [function, hook(IO.seek), impure]
                          | "#seekEnd" "(" Int "," Int ")"          [function, hook(IO.seekEnd), impure]
                          | "#putc"    "(" Int "," Int ")"          [function, hook(IO.putc), impure]
                          | "#write"   "(" Int "," String ")"       [function, hook(IO.write), impure]
                          | "#lock"    "(" Int "," Int ")"          [function, hook(IO.lock), impure]
                          | "#unlock"  "(" Int "," Int ")"          [function, hook(IO.unlock), impure]

  syntax          KItem ::= "#stat"    "(" String ")"               [function, hook(IO.stat), impure]
                          | "#lstat"   "(" String ")"               [function, hook(IO.lstat), impure]
                          | "#opendir" "(" String ")"               [function, hook(IO.opendir), impure]
                          | #parse ( String , String )              [function, hook(IO.parse), impure]
                          | #parseInModule(String, // input
                                           String, // start symbol
                                           String) // module name
                                                                    [function, hook(IO.parseInModule), impure]

    rule #open(S:String) => #open(S:String, "r+")

  syntax            Int ::= "#stdin"                                [function, functional]
                          | "#stdout"                               [function, functional]
                          | "#stderr"                               [function, functional]

    rule #stdin  => 0
    rule #stdout => 1
    rule #stderr => 2

  syntax         Stream ::= #buffer(K)

//--------------
//--- System ---
//--------------
  syntax          KItem ::= #system ( String )                      [function, hook(IO.system), impure]
                          | "#systemResult" "(" Int /* exit code */ "," String /* stdout */ "," String /* stderr */ ")"

  syntax              K ::= #logToFile(String, String)              [function, functional, hook(IO.log), impure, returnsUnit]

endmodule

