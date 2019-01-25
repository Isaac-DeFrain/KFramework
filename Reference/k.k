
module K-EQUAL
  imports BOOL
  imports BASIC-K

  syntax Bool ::= left:
                    K "==K" K           [function, functional, smtlib(=), hook(KEQUAL.eq), klabel(_==K_), symbol, latex({#1}\mathrel{=_K}{#2}), equalEqualK]
                | K "=/=K" K          [function, functional, smtlib(distinct), hook(KEQUAL.ne), klabel(_=/=K_), symbol, latex({#1}\mathrel{\neq_K}{#2}), notEqualEqualK]

  syntax priorities equalEqualK notEqualEqualK > boolOperation mlOp
  rule K1:K =/=K K2:K => notBool (K1 ==K K2)

  rule K1:Bool ==Bool K2:Bool => K1 ==K K2

  syntax K ::= "#if" Bool "#then" K "#else" K "#fi"   [function, functional, smtlib(ite), hook(KEQUAL.ite), poly(0, 2, 3)]

  rule #if C:Bool #then B1 #else _ #fi => B1 requires C
  rule #if C:Bool #then _ #else B2 #fi => B2 requires notBool C

endmodule

module K-REFLECTION
  imports BASIC-K
  imports STRING
  imports K-REFLECTION-SYMBOLIC

  syntax K ::= "#configuration" [function, impure, hook(KREFLECTION.configuration)]
  syntax String ::= #sort(K) [function, hook(KREFLECTION.sort)]
  syntax KItem ::= #fresh(String)   [function, hook(KREFLECTION.fresh), impure]
  syntax KItem ::= getKLabel(K)  [function, hook(KREFLECTION.getKLabel)]

  syntax String ::= #getenv(String) [function, impure, hook(KREFLECTION.getenv)]

  // meaningful only for the purposes of compilation to a binary, otherwise
  // undefined
  syntax List ::= #argv() [function, hook(KREFLECTION.argv)]

endmodule

module K-REFLECTION-SYMBOLIC [symbolic]
  imports BASIC-K
  imports STRING

  // return empty string if the term has no klabel
  syntax String ::= #getKLabelString(K) [function, hook(KREFLECTION.getKLabelString)]

  // return true if no variable nor unresolved function appears in any subterm
  syntax Bool ::= #isConcrete(K) [function, hook(KREFLECTION.isConcrete)]
  syntax Bool ::= #isVariable(K) [function, hook(KREFLECTION.isVariable)]
endmodule

module K-IO
  imports LIST
  imports STRING

  syntax IOError ::= "#EOF" | "#noparse" | #unknownIOError(Int)
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

  syntax Int ::= "#open" "(" String ")" [function]
               | "#open" "(" String "," String ")" [function, hook(IO.open), impure]
               | "#tell" "(" Int ")" [function, hook(IO.tell), impure]
               | "#getc" "(" Int ")"             [function, hook(IO.getc), impure]
  syntax String ::= "#read" "(" Int "," Int ")"    [function, hook(IO.read), impure]

  syntax K ::= "#close" "(" Int ")" [function, hook(IO.close), impure]
             | "#seek" "(" Int "," Int ")" [function, hook(IO.seek), impure]
             | "#seekEnd" "(" Int "," Int ")" [function, hook(IO.seekEnd), impure]
             | "#putc" "(" Int "," Int ")"      [function, hook(IO.putc), impure]
             | "#write" "(" Int "," String ")" [function, hook(IO.write), impure]
             | "#lock" "(" Int "," Int ")" [function, hook(IO.lock), impure]
             | "#unlock" "(" Int "," Int ")" [function, hook(IO.unlock), impure]

  syntax KItem ::= "#stat" "(" String ")" [function, hook(IO.stat), impure]
                 | "#lstat" "(" String ")" [function, hook(IO.lstat), impure]
                 | "#opendir" "(" String ")" [function, hook(IO.opendir), impure]

  syntax KItem ::= #parse ( String , String ) [function, hook(IO.parse), impure]
  syntax KItem ::= #parseInModule(String, // input
                                  String, // start symbol
                                  String) // module name
                                  [function, hook(IO.parseInModule), impure]

  rule #open(S:String) => #open(S:String, "r+")

  syntax Int ::= "#stdin"   [function, functional]
                | "#stdout" [function, functional]
                | "#stderr" [function, functional]

  rule #stdin => 0
  rule #stdout => 1
  rule #stderr => 2

  syntax Stream ::= #buffer(K)

// ------------------------------
// System

  syntax KItem ::= #system ( String ) [function, hook(IO.system), impure]
                 | "#systemResult" "(" Int /* exit code */ "," String /* stdout */ "," String /* stderr */ ")"

  syntax K ::= #logToFile(String, String) [function, functional, hook(IO.log), impure, returnsUnit]

endmodule

