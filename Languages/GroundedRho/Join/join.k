
require "../grho.k"
require "substitution.k"

module JOIN-SYNTAX
  import GRHO
  import SUBSTITUTION
endmodule

module JOIN
  import JOIN-SYNTAX

  rule
  <receives>
    ...
   (<rec>
      <rchan> X:Name , Y:Name </rchan>
      <bvars> A:Name , B:Name </bvars>
      <bnum>  M:Int  , N:Int   </bnum>
      <rper>  0                </rper>
      <cont>  P:Proc           </cont>
    </rec> => .Bag)
    ...
  </receives>
  <sends>
    ...
   (<send>
      <schan> X  </schan>
      <msg> Q:Proc </msg>
      <tuple> M  </tuple>
      <sper>  0   </sper>
    </send> => .Bag)
   (<send>
	    <schan> Y  </schan>
	    <msg> R:Proc </msg>
	    <tuple> N  </tuple>
   	  <sper>  0   </sper>
    </send> => .Bag)
    ...
  </sends>
  (.Bag => <thread> <k> P[ @Q / A ][ @R / B ] </k> </thread>)

// Hard-coded join of 3 binds, each listening for a 1-tuple
  rule
  <receives>
    ...
   (<rec>
      <rchan> X:Name , Y:Name , Z:Name </rchan>
      <bvars> A:Name , B:Name , C:Name </bvars>
      <bnum>  L:Int  , M:Int  , N:Int   </bnum>
      <rper>  0                         </rper>
      <cont>  P:Proc                    </cont>
    </rec> => .Bag)
    ...
  </receives>
  <sends>
    ...
   (<send>
      <schan> X  </schan>
      <msg> Q:Proc </msg>
      <tuple> L  </tuple>
      <sper>  0   </sper>
    </send> => .Bag)
   (<send>
	    <schan> Y  </schan>
	    <msg> R:Proc </msg>
	    <tuple> M  </tuple>
   	  <sper>  0   </sper>
    </send> => .Bag)
   (<send>
	    <schan> Z  </schan>
	    <msg> S:Proc </msg>
	    <tuple> N  </tuple>
   	  <sper>  0   </sper>
    </send> => .Bag)
    ...
  </sends>
  <reaction>
    <who>   .K => P           </who>
    <what>  .K => Q , R , S  </what>
    <where> .K => A , B , C </where>
  </reaction>

endmodule