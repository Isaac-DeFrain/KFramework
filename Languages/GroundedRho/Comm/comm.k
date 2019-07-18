// Comm predicate

require "../grho.k"
require "../AuxFun/auxfun.k"
require "../Configuration/config.k"
require "../Match/match.k"
require "../StructuralEquiv/struct.k"

module COMM-SYNTAX
  import GRHO-SYNTAX
  import CONFIG

// how to make Bag or SendCellBag the first arg???
  syntax    Bool ::= "#matchComm(" Cell ";" Receive ")" [function]

endmodule

module COMM
  import COMM-SYNTAX
  import AUXFUN
  import MATCH
  import STRUCT

  syntax KResult ::= Bool

  rule (<rec>  R:LinearSRec </rec> => .Bag)
       (<send> S:ConSend   </send> => .Bag)
       (.Bag => <task> <k> #sub(#quotes(#msg(S));#bvar(R);#cont(R)) </k> </task>)
        requires #matchComm(S;;#gbind(R)) [comm]
  rule (<rec>  R:SRec       </rec> => .Bag)
        <send> S:UnconSend </send>
       (.Bag => <task> <k> #sub(#quotes(#msg(S));#bvar(R);#cont(R)) </k> </task>)
        requires #matchComm(S;;#gbind(R)) andBool notBool isRepeatSRec(R) [comm]

  rule (<rec>  R:PeekSRec </rec> => .Bag)
        <send> S:ConSend </send>
       (.Bag => <task> <k> #sub(#quotes(#msg(S));#bvar(R);#cont(R)) </k> </task>)
        requires #matchComm(S;;#gbind(R)) [comm]

  rule  <rec>  R:RepeatSRec </rec>
       (<send> S:ConSend   </send> => .Bag)
       (.Bag => <task> <k> #sub(#quotes(#msg(S));#bvar(R);#cont(R)) </k> </task>)
        requires #matchComm(S;;#gbind(R)) [comm]
//  rule  <rec>  R:RepeatSRec </rec>
//        <send> S:UnconSend </send>
//        requires #matchComm(S;;#gbind(R))

//  rule #matchComm( <sends> T </sends> ; _:Receive ) => false
//       requires isSendCellBag(T) andBool T ==K .SendCellBag
//  rule #matchComm( <sends> <send> S:Send </send> </sends> ; R:Receive )
//    => #matchComm(S;;#gbind(R)) [comm]
//  rule #matchComm( <sends> <send> S:Send </send> T </sends> ; R:SRec )
//    => #matchComm(S;;#gbind(R)) andBool
//       #matchComm(<sends> T </sends>;R) requires isSendCellBag(T)
//       andBool notBool T =/=K .SendCellBag [comm]


endmodule
