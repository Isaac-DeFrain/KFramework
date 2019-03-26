open Prelude
open Constants
open Constants.K
module Def = struct
let freshFunction (sort: string) (config: k) (counter: Z.t) : k = interned_bottom
let evalisBool (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBool and sort = 
SortBool in match c with 
| [Bool _] -> [Bool true]
(*{| rule ``isBool(#KToken(#token("Bool","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBool, var__0) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBool(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_andBool_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_andBool_ and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_and c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_andBool_`(#token("false","Bool"),_4)=>#token("false","Bool")`` requires isBool(_4) ensures #token("true","Bool") [UNIQUE_ID(e6ebe927ba416a1602679eb0166f22d394adf70452e0505c00f11c036a896253) contentStartColumn(8) contentStartLine(304) org.kframework.attributes.Location(Location(304,8,304,37)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_4_2) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andBool_`(_1,#token("false","Bool"))=>#token("false","Bool")`` requires isBool(_1) ensures #token("true","Bool") [UNIQUE_ID(1a7512841ede635d09556466797d23f3f3cec57fe0fb6a68ce0c3a1cccb0b68f) contentStartColumn(8) contentStartLine(305) org.kframework.attributes.Location(Location(305,8,305,37)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_1_3) :: []),((Bool false) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andBool_`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(cd0a9b340fae24c9a05126d8df860cb7145fc64875711e36efaa694085559dc0) contentStartColumn(8) contentStartLine(302) org.kframework.attributes.Location(Location(302,8,302,37)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varB_4) :: [])) when true && (true) -> (varB_4 :: [])
(*{| rule `` `_andBool_`(B,#token("true","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(b598bf51d1c959b7112e06b7f85a391ee5a18108acd52bb65ea27ef0381ed0e0) contentStartColumn(8) contentStartLine(303) org.kframework.attributes.Location(Location(303,8,303,37)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_5) :: []),((Bool true) :: [])) when true && (true) -> (varB_5 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalnotBool_ (c: k) (config: k) (guard: int) : k = let lbl = 
LblnotBool_ and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_not c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `notBool_`(#token("true","Bool"))=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(de18dba5cb1b6e56941a63279edb1d16da29d7a997a3e82cbc2b81b066eadf47) contentStartColumn(8) contentStartLine(299) org.kframework.attributes.Location(Location(299,8,299,29)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: [])) -> ((Bool false) :: [])
(*{| rule `` `notBool_`(#token("false","Bool"))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(dbe4d83961158619e994f90623f08be11020d80c56685ef1ec2dd2b15760c474) contentStartColumn(8) contentStartLine(300) org.kframework.attributes.Location(Location(300,8,300,29)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: [])) -> ((Bool true) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalnot__GRHO'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lblnot__GRHO'Hyph'SYNTAX in match c with 
(*{| rule `` `not__GRHO-SYNTAX`(B)=>`notBool_`(B)`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(7d77b6b4fde65384252542451e83a83ccc82c876f0b8b64aada15ebea7bd7c8b) anywhere() contentStartColumn(8) contentStartLine(83) org.kframework.attributes.Location(Location(83,8,83,31)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_6) :: [])) when true && (true) -> ([Bool ((not ((isTrue [varB_6]))))])
| k0 -> [KApply1(lbl, k0)]
let eval_and__GRHO'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_and__GRHO'Hyph'SYNTAX in match c with 
(*{| rule `` `_and__GRHO-SYNTAX`(#token("false","Bool"),_164)=>#token("false","Bool")`` requires isBool(_164) ensures #token("true","Bool") [UNIQUE_ID(ecc5445264161bd4cfe6a36dea10360988d58bfdff24ea7d0a15fbb949d25284) anywhere() contentStartColumn(8) contentStartLine(85) org.kframework.attributes.Location(Location(85,8,85,33)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_164_7) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_and__GRHO-SYNTAX`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(9f355e2594f250c66716f1ecc0fa570f1b13246a437a8ad88f6056b1825766fa) anywhere() contentStartColumn(8) contentStartLine(84) org.kframework.attributes.Location(Location(84,8,84,29)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varB_8) :: [])) when true && (true) -> (varB_8 :: [])
| k0,k1 -> [KApply2(lbl, k0, k1)]
let evalisInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisInt and sort = 
SortBool in match c with 
| [Int _] -> [Bool true]
(*{| rule ``isInt(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__9) :: [])) -> ((Bool true) :: [])
(*{| rule ``isInt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_10)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT_Eqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_le c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX in match c with 
(*{| rule `` `_<=__GRHO-SYNTAX`(I1,I2)=>`_<=Int__INT`(I1,I2)`` requires `_andBool_`(isInt(I2),isInt(I1)) ensures #token("true","Bool") [UNIQUE_ID(27c50c405ae27aa0f614b712d478f8feec4e07d86da285312c0b18012fcc1ae6) anywhere() contentStartColumn(8) contentStartLine(82) org.kframework.attributes.Location(Location(82,8,82,39)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_11) :: []),((Int _ as varI2_12) :: [])) when ((true) && (true)) && (true) -> ((eval_'_LT_Eqls'Int__INT((varI1_11 :: []),(varI2_12 :: [])) config (-1)))
| k0,k1 -> [KApply2(lbl, k0, k1)]
let eval_'Star'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Star'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_mul c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Star'__GRHO'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Star'__GRHO'Hyph'SYNTAX in match c with 
(*{| rule `` `_*__GRHO-SYNTAX`(I1,I2)=>`_*Int__INT`(I1,I2)`` requires `_andBool_`(isInt(I2),isInt(I1)) ensures #token("true","Bool") [UNIQUE_ID(749dc8187da0d5f7015ce08589569fd068d614805168bf5dbd4ecd3c326c3edd) anywhere() contentStartColumn(8) contentStartLine(79) org.kframework.attributes.Location(Location(79,8,79,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_13) :: []),((Int _ as varI2_14) :: [])) when ((true) && (true)) && (true) -> ((eval_'Star'Int__INT((varI1_13 :: []),(varI2_14 :: [])) config (-1)))
| k0,k1 -> [KApply2(lbl, k0, k1)]
let eval_'Plus'Int_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Plus'Int_ and sort = 
SortInt in match c with 
| _ -> try INT.hook_add c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Plus'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Plus'String__STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Hyph'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hyph'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_sub c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Hyph'__GRHO'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hyph'__GRHO'Hyph'SYNTAX in match c with 
(*{| rule `` `_-__GRHO-SYNTAX`(I1,I2)=>`_-Int__INT`(I1,I2)`` requires `_andBool_`(isInt(I2),isInt(I1)) ensures #token("true","Bool") [UNIQUE_ID(c23e57693e0b68b11038f204681e99656e7f1e4c42b1e2ee170f338edd3b6bd0) anywhere() contentStartColumn(8) contentStartLine(78) org.kframework.attributes.Location(Location(78,8,78,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_15) :: []),((Int _ as varI2_16) :: [])) when ((true) && (true)) && (true) -> ((eval_'Hyph'Int__INT((varI1_15 :: []),(varI2_16 :: [])) config (-1)))
| k0,k1 -> [KApply2(lbl, k0, k1)]
let rec evalisProcs (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProcs and sort = 
SortBool in match c with 
(*{| rule ``isProcs(#KToken(#token("Procs","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProcs, var__17) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcs(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProcs(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_18 :: []),(varK1_19 :: [])) :: [])) when (((isTrue (evalisProc((varK0_18 :: [])) config (-1)))) && ((isTrue (evalisProcs((varK1_19 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcs(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_20 :: []),(varK1_21 :: [])) :: [])) when (((isTrue (evalisProc((varK0_20 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_21 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcs(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_22)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisRhoKVPairs (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRhoKVPairs and sort = 
SortBool in match c with 
(*{| rule ``isRhoKVPairs(`_:__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Coln'__GRHO'Hyph'SYNTAX,(varK0_23 :: []),(varK1_24 :: [])) :: [])) when (((isTrue (evalisProc((varK0_23 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_24 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRhoKVPairs(`_:_,__GRHO-SYNTAX`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isProc(K0),isProc(K1)),isRhoKVPairs(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl_'Coln'_'Comm'__GRHO'Hyph'SYNTAX,(varK0_25 :: []),(varK1_26 :: []),(varK2_27 :: [])) :: [])) when (((((isTrue (evalisProc((varK0_25 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_26 :: [])) config (-1)))))) && ((isTrue (evalisRhoKVPairs((varK2_27 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRhoKVPairs(#KToken(#token("RhoKVPairs","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoKVPairs, var__28) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRhoKVPairs(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_29)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisProcList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProcList and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
| [Int _] -> [Bool true]
(*{| rule ``isProcList(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__30) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("BExp","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBExp, var__31) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("MultiRec","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMultiRec, var__32) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`not__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isBExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblnot__GRHO'Hyph'SYNTAX,(varK0_33 :: [])) :: [])) when (isTrue (evalisBExp((varK0_33 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`Set(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblSet'LPar'_'RPar'_GRHO'Hyph'SYNTAX,(varK0_34 :: [])) :: [])) when (isTrue (evalisProcList((varK0_34 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isRhoTuple(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Bang'__GRHO'Hyph'SYNTAX,(varK0_35 :: []),(varK1_36 :: [])) :: [])) when (((isTrue (evalisName((varK0_35 :: [])) config (-1)))) && ((isTrue (evalisRhoTuple((varK1_36 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`*__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Star'__GRHO'Hyph'SYNTAX,(varK0_37 :: [])) :: [])) when (isTrue (evalisName((varK0_37 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("UnconsumableSend","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUnconsumableSend, var__38) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("RhoMap","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoMap, var__39) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Receive","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReceive, var__40) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_or__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBExp(K0),isBExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_or__GRHO'Hyph'SYNTAX,(varK0_41 :: []),(varK1_42 :: [])) :: [])) when (((isTrue (evalisBExp((varK0_41 :: [])) config (-1)))) && ((isTrue (evalisBExp((varK1_42 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("AExp","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortAExp, var__43) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("RhoList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoList, var__44) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`Nil_GRHO-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblNil_GRHO'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("RhoSet","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoSet, var__45) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Bundle","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBundle, var__46) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_;_;;__GRHO-SYNTAX`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isInt(K1)),isInt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varK0_47 :: []),((Int _ as varK1_48) :: []),((Int _ as varK2_49) :: [])) :: [])) when (((((isTrue (evalisName((varK0_47 :: [])) config (-1)))) && (true))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("BindOcc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBindOcc, var__50) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Bool","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBool, var__51) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isRhoKVPairs(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_52 :: [])) :: [])) when (isTrue (evalisRhoKVPairs((varK0_52 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Eval","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEval, var__53) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_!!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isRhoTuple(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'BangBang'__GRHO'Hyph'SYNTAX,(varK0_54 :: []),(varK1_55 :: [])) :: [])) when (((isTrue (evalisName((varK0_54 :: [])) config (-1)))) && ((isTrue (evalisRhoTuple((varK1_55 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_56 :: [])) :: [])) when (isTrue (evalisProc((varK0_56 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Uri","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUri, var__57) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Collection","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortCollection, var__58) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Par","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPar, var__59) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_|__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Pipe'__GRHO'Hyph'SYNTAX,(varK0_60 :: []),(varK1_61 :: [])) :: [])) when (((isTrue (evalisProc((varK0_60 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_61 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Send","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSend, var__62) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`{[_;_]}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(varK0_63 :: []),((Int _ as varK1_64) :: [])) :: [])) when (((isTrue (evalisProc((varK0_63 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`bundle{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_65 :: [])) :: [])) when (isTrue (evalisProc((varK0_65 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_and__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBExp(K0),isBExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_and__GRHO'Hyph'SYNTAX,(varK0_66 :: []),(varK1_67 :: [])) :: [])) when (((isTrue (evalisBExp((varK0_66 :: [])) config (-1)))) && ((isTrue (evalisBExp((varK1_67 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`bundle-{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'HyphLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_68 :: [])) :: [])) when (isTrue (evalisProc((varK0_68 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_*__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Star'__GRHO'Hyph'SYNTAX,(varK0_69 :: []),(varK1_70 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_69 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_70 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`(_;_)_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varK0_71 :: []),((Int _ as varK1_72) :: [])) :: [])) when (((isTrue (evalisName((varK0_71 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Ground","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortGround, var__73) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBinds(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_74 :: [])) :: [])) when (isTrue (evalisBinds((varK0_74 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("New","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNew, var__75) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__76) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProcs(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_77 :: []),(varK1_78 :: [])) :: [])) when (((isTrue (evalisProc((varK0_77 :: [])) config (-1)))) && ((isTrue (evalisProcs((varK1_78 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("ChanLen","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortChanLen, var__79) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_-__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Hyph'__GRHO'Hyph'SYNTAX,(varK0_80 :: []),(varK1_81 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_80 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_81 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`uri(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isString(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbluri'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((String _ as varK0_82) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("ProcList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProcList, var__83) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`bundle0{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle0'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_84 :: [])) :: [])) when (isTrue (evalisProc((varK0_84 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_+__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Plus'__GRHO'Hyph'SYNTAX,(varK0_85 :: []),(varK1_86 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_85 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_86 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(tuple(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbltuple,(varK0_87 :: [])) :: [])) when (isTrue (evalisProcList((varK0_87 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_88 :: [])) :: [])) when (isTrue (evalisName((varK0_88 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`[_]_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LSqB'_'RSqB'_GRHO'Hyph'SYNTAX,(varK0_89 :: [])) :: [])) when (isTrue (evalisProcList((varK0_89 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isAExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_90 :: [])) :: [])) when (isTrue (evalisAExp((varK0_90 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isBExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_91 :: [])) :: [])) when (isTrue (evalisBExp((varK0_91 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("SingleRec","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSingleRec, var__92) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`bundle+{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'PlusLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_93 :: [])) :: [])) when (isTrue (evalisProc((varK0_93 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_;_;;__GRHO-SYNTAX`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isNameList(K1)),isInt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varK0_94 :: []),(varK1_95 :: []),((Int _ as varK2_96) :: [])) :: [])) when (((((isTrue (evalisName((varK0_94 :: [])) config (-1)))) && ((isTrue (evalisNameList((varK1_95 :: [])) config (-1)))))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`for(_){_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBinds(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_97 :: []),(varK1_98 :: [])) :: [])) when (((isTrue (evalisBinds((varK0_97 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_98 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("ConsumableSend","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortConsumableSend, var__99) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("JoinList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortJoinList, var__100) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBind(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_101 :: [])) :: [])) when (isTrue (evalisBind((varK0_101 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("RhoTuple","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoTuple, var__102) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Proc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProc, var__103) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(#KToken(#token("Procs","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProcs, var__104) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_<=__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varK0_105 :: []),(varK1_106 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_105 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_106 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_107 :: []),(varK1_108 :: [])) :: [])) when (((isTrue (evalisProc((varK0_107 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_108 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`new_in{_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblnew_in'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_109 :: []),(varK1_110 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_109 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_110 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(`for(_){_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBind(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_111 :: []),(varK1_112 :: [])) :: [])) when (((isTrue (evalisBind((varK0_111 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_112 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProcList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_113)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisRhoTuple (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRhoTuple and sort = 
SortBool in match c with 
(*{| rule ``isRhoTuple(tuple(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbltuple,(varK0_114 :: [])) :: [])) when (isTrue (evalisProcList((varK0_114 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRhoTuple(#KToken(#token("RhoTuple","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoTuple, var__115) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRhoTuple(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_116)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisString (c: k) (config: k) (guard: int) : k = let lbl = 
LblisString and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
(*{| rule ``isString(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_117 :: [])) :: [])) when (isTrue (evalisName((varK0_117 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isString(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBinds(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_118 :: [])) :: [])) when (isTrue (evalisBinds((varK0_118 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isString(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_119 :: [])) :: [])) when (isTrue (evalisProc((varK0_119 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isString(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__120) :: [])) -> ((Bool true) :: [])
(*{| rule ``isString(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBind(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_121 :: [])) :: [])) when (isTrue (evalisBind((varK0_121 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isString(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_122)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and eval_'Plus'__GRHO'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Plus'__GRHO'Hyph'SYNTAX in match c with 
(*{| rule `` `_+__GRHO-SYNTAX`(S1,S2)=>`_+String__STRING`(S1,S2)`` requires `_andBool_`(isString(S1),isString(S2)) ensures #token("true","Bool") [UNIQUE_ID(3883054df2ccebc277d8787ce5d1712518821ad1b6a989432bbedfff4e979822) anywhere() contentStartColumn(8) contentStartLine(88) org.kframework.attributes.Location(Location(88,8,88,46)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_123) :: []),((String _ as varS2_124) :: [])) when ((true) && (true)) && (true) -> ((eval_'Plus'String__STRING((varS1_123 :: []),(varS2_124 :: [])) config (-1)))
(*{| rule `` `_+__GRHO-SYNTAX`(I1,I2)=>`_+Int_`(I1,I2)`` requires `_andBool_`(isInt(I2),isInt(I1)) ensures #token("true","Bool") [UNIQUE_ID(0e66f3db788d485e4b5c27e6d1f30adb74ecdc4de44b2b5aaa3f6c69ff7b5240) anywhere() contentStartColumn(8) contentStartLine(77) org.kframework.attributes.Location(Location(77,8,77,37)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_125) :: []),((Int _ as varI2_126) :: [])) when ((true) && (true)) && (true) -> ((eval_'Plus'Int_((varI1_125 :: []),(varI2_126 :: [])) config (-1)))
| k0,k1 -> [KApply2(lbl, k0, k1)]
and evalisAExp (c: k) (config: k) (guard: int) : k = let lbl = 
LblisAExp and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
| [Int _] -> [Bool true]
(*{| rule ``isAExp(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isAExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_127 :: [])) :: [])) when (isTrue (evalisAExp((varK0_127 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_128 :: [])) :: [])) when (isTrue (evalisProc((varK0_128 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBind(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_129 :: [])) :: [])) when (isTrue (evalisBind((varK0_129 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(#KToken(#token("Eval","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEval, var__130) :: [])) -> ((Bool true) :: [])
(*{| rule ``isAExp(`_*__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Star'__GRHO'Hyph'SYNTAX,(varK0_131 :: []),(varK1_132 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_131 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_132 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(`*__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Star'__GRHO'Hyph'SYNTAX,(varK0_133 :: [])) :: [])) when (isTrue (evalisName((varK0_133 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_134 :: [])) :: [])) when (isTrue (evalisName((varK0_134 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBinds(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_135 :: [])) :: [])) when (isTrue (evalisBinds((varK0_135 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(#KToken(#token("AExp","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortAExp, var__136) :: [])) -> ((Bool true) :: [])
(*{| rule ``isAExp(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__137) :: [])) -> ((Bool true) :: [])
(*{| rule ``isAExp(`_+__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Plus'__GRHO'Hyph'SYNTAX,(varK0_138 :: []),(varK1_139 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_138 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_139 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(`_-__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Hyph'__GRHO'Hyph'SYNTAX,(varK0_140 :: []),(varK1_141 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_140 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_141 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isAExp(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__142) :: [])) -> ((Bool true) :: [])
(*{| rule ``isAExp(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_143)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisBind (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBind and sort = 
SortBool in match c with 
(*{| rule ``isBind(#KToken(#token("Lbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbind, var__144) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBind(`_<-__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varK0_145 :: []),(varK1_146 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_145 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_146 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBind(#KToken(#token("Pbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbind, var__147) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBind(`_<!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varK0_148 :: []),(varK1_149 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_148 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_149 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBind(#KToken(#token("Rbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbind, var__150) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBind(`_<=__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varK0_151 :: []),(varK1_152 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_151 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_152 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBind(#KToken(#token("Bind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBind, var__153) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBind(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_154)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisRbinds (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRbinds and sort = 
SortBool in match c with 
(*{| rule ``isRbinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isRbind(K0),isRbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_155 :: []),(varK1_156 :: [])) :: [])) when (((isTrue (evalisRbind((varK0_155 :: [])) config (-1)))) && ((isTrue (evalisRbinds((varK1_156 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRbinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isRbind(K0),isRbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_157 :: []),(varK1_158 :: [])) :: [])) when (((isTrue (evalisRbind((varK0_157 :: [])) config (-1)))) && ((isTrue (evalisRbind((varK1_158 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRbinds(#KToken(#token("Rbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbinds, var__159) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRbinds(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_160)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisRbind (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRbind and sort = 
SortBool in match c with 
(*{| rule ``isRbind(`_<=__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varK0_161 :: []),(varK1_162 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_161 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_162 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRbind(#KToken(#token("Rbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbind, var__163) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRbind(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_164)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisLbinds (c: k) (config: k) (guard: int) : k = let lbl = 
LblisLbinds and sort = 
SortBool in match c with 
(*{| rule ``isLbinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLbind(K0),isLbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_165 :: []),(varK1_166 :: [])) :: [])) when (((isTrue (evalisLbind((varK0_165 :: [])) config (-1)))) && ((isTrue (evalisLbind((varK1_166 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isLbinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLbind(K0),isLbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_167 :: []),(varK1_168 :: [])) :: [])) when (((isTrue (evalisLbind((varK0_167 :: [])) config (-1)))) && ((isTrue (evalisLbinds((varK1_168 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isLbinds(#KToken(#token("Lbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbinds, var__169) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLbinds(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_170)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisLbind (c: k) (config: k) (guard: int) : k = let lbl = 
LblisLbind and sort = 
SortBool in match c with 
(*{| rule ``isLbind(#KToken(#token("Lbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbind, var__171) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLbind(`_<-__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varK0_172 :: []),(varK1_173 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_172 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_173 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isLbind(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_174)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisPbinds (c: k) (config: k) (guard: int) : k = let lbl = 
LblisPbinds and sort = 
SortBool in match c with 
(*{| rule ``isPbinds(#KToken(#token("Pbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbinds, var__175) :: [])) -> ((Bool true) :: [])
(*{| rule ``isPbinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isPbind(K0),isPbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_176 :: []),(varK1_177 :: [])) :: [])) when (((isTrue (evalisPbind((varK0_176 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varK1_177 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isPbinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isPbind(K0),isPbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_178 :: []),(varK1_179 :: [])) :: [])) when (((isTrue (evalisPbind((varK0_178 :: [])) config (-1)))) && ((isTrue (evalisPbind((varK1_179 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isPbinds(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_180)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisNames (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNames and sort = 
SortBool in match c with 
(*{| rule ``isNames(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_181 :: []),(varK1_182 :: [])) :: [])) when (((isTrue (evalisName((varK0_181 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_182 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNames(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isNames(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_183 :: []),(varK1_184 :: [])) :: [])) when (((isTrue (evalisName((varK0_183 :: [])) config (-1)))) && ((isTrue (evalisNames((varK1_184 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNames(#KToken(#token("Names","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNames, var__185) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNames(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_186)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisNameList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNameList and sort = 
SortBool in match c with 
(*{| rule ``isNameList(#KToken(#token("Name","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortName, var__187) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNameList(`@__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_AT_'__GRHO'Hyph'SYNTAX,(varK0_188 :: [])) :: [])) when (isTrue (evalisProc((varK0_188 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNameList(`unforgeable(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblunforgeable'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((Int _ as varK0_189) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isNameList(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isNames(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_190 :: []),(varK1_191 :: [])) :: [])) when (((isTrue (evalisName((varK0_190 :: [])) config (-1)))) && ((isTrue (evalisNames((varK1_191 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNameList(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_192 :: []),(varK1_193 :: [])) :: [])) when (((isTrue (evalisName((varK0_192 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_193 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNameList(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__194) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNameList(#KToken(#token("NameList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNameList, var__195) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNameList(#KToken(#token("Names","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNames, var__196) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNameList(#KToken(#token("NameVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNameVar, var__197) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNameList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_198)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisPbind (c: k) (config: k) (guard: int) : k = let lbl = 
LblisPbind and sort = 
SortBool in match c with 
(*{| rule ``isPbind(#KToken(#token("Pbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbind, var__199) :: [])) -> ((Bool true) :: [])
(*{| rule ``isPbind(`_<!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varK0_200 :: []),(varK1_201 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_200 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_201 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isPbind(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_202)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisBinds (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBinds and sort = 
SortBool in match c with 
(*{| rule ``isBinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isPbind(K0),isPbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_203 :: []),(varK1_204 :: [])) :: [])) when (((isTrue (evalisPbind((varK0_203 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varK1_204 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLbind(K0),isLbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_205 :: []),(varK1_206 :: [])) :: [])) when (((isTrue (evalisLbind((varK0_205 :: [])) config (-1)))) && ((isTrue (evalisLbind((varK1_206 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBinds(#KToken(#token("Pbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbinds, var__207) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isPbind(K0),isPbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_208 :: []),(varK1_209 :: [])) :: [])) when (((isTrue (evalisPbind((varK0_208 :: [])) config (-1)))) && ((isTrue (evalisPbind((varK1_209 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLbind(K0),isLbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_210 :: []),(varK1_211 :: [])) :: [])) when (((isTrue (evalisLbind((varK0_210 :: [])) config (-1)))) && ((isTrue (evalisLbinds((varK1_211 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isRbind(K0),isRbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_212 :: []),(varK1_213 :: [])) :: [])) when (((isTrue (evalisRbind((varK0_212 :: [])) config (-1)))) && ((isTrue (evalisRbinds((varK1_213 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBinds(#KToken(#token("Binds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBinds, var__214) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBinds(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isRbind(K0),isRbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_215 :: []),(varK1_216 :: [])) :: [])) when (((isTrue (evalisRbind((varK0_215 :: [])) config (-1)))) && ((isTrue (evalisRbind((varK1_216 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBinds(#KToken(#token("Lbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbinds, var__217) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBinds(#KToken(#token("Rbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbinds, var__218) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBinds(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_219)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisBExp (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBExp and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
(*{| rule ``isBExp(#KToken(#token("BExp","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBExp, var__220) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBExp(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isBExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_221 :: [])) :: [])) when (isTrue (evalisBExp((varK0_221 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(`_and__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBExp(K0),isBExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_and__GRHO'Hyph'SYNTAX,(varK0_222 :: []),(varK1_223 :: [])) :: [])) when (((isTrue (evalisBExp((varK0_222 :: [])) config (-1)))) && ((isTrue (evalisBExp((varK1_223 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_224 :: [])) :: [])) when (isTrue (evalisProc((varK0_224 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBinds(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_225 :: [])) :: [])) when (isTrue (evalisBinds((varK0_225 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBind(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_226 :: [])) :: [])) when (isTrue (evalisBind((varK0_226 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(#KToken(#token("Eval","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEval, var__227) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBExp(`_or__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBExp(K0),isBExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_or__GRHO'Hyph'SYNTAX,(varK0_228 :: []),(varK1_229 :: [])) :: [])) when (((isTrue (evalisBExp((varK0_228 :: [])) config (-1)))) && ((isTrue (evalisBExp((varK1_229 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(`_<=__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varK0_230 :: []),(varK1_231 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_230 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_231 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_232 :: [])) :: [])) when (isTrue (evalisName((varK0_232 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__233) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBExp(`not__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isBExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblnot__GRHO'Hyph'SYNTAX,(varK0_234 :: [])) :: [])) when (isTrue (evalisBExp((varK0_234 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(#KToken(#token("Bool","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBool, var__235) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBExp(`*__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Star'__GRHO'Hyph'SYNTAX,(varK0_236 :: [])) :: [])) when (isTrue (evalisName((varK0_236 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBExp(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_237)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and evalisProc (c: k) (config: k) (guard: int) : k = let lbl = 
LblisProc and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
| [Int _] -> [Bool true]
(*{| rule ``isProc(#KToken(#token("Collection","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortCollection, var__238) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("MultiRec","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMultiRec, var__239) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`bundle0{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle0'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_240 :: [])) :: [])) when (isTrue (evalisProc((varK0_240 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Bundle","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBundle, var__241) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`bundle-{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'HyphLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_242 :: [])) :: [])) when (isTrue (evalisProc((varK0_242 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__243) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`not__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isBExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblnot__GRHO'Hyph'SYNTAX,(varK0_244 :: [])) :: [])) when (isTrue (evalisBExp((varK0_244 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isRhoTuple(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Bang'__GRHO'Hyph'SYNTAX,(varK0_245 :: []),(varK1_246 :: [])) :: [])) when (((isTrue (evalisName((varK0_245 :: [])) config (-1)))) && ((isTrue (evalisRhoTuple((varK1_246 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isRhoKVPairs(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_247 :: [])) :: [])) when (isTrue (evalisRhoKVPairs((varK0_247 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`bundle+{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'PlusLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_248 :: [])) :: [])) when (isTrue (evalisProc((varK0_248 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("RhoSet","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoSet, var__249) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("RhoTuple","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoTuple, var__250) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Bool","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBool, var__251) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Uri","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUri, var__252) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`for(_){_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBinds(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_253 :: []),(varK1_254 :: [])) :: [])) when (((isTrue (evalisBinds((varK0_253 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_254 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Eval","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEval, var__255) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_256 :: [])) :: [])) when (isTrue (evalisProc((varK0_256 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Receive","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReceive, var__257) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Par","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPar, var__258) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`_;_;;__GRHO-SYNTAX`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isInt(K1)),isInt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varK0_259 :: []),((Int _ as varK1_260) :: []),((Int _ as varK2_261) :: [])) :: [])) when (((((isTrue (evalisName((varK0_259 :: [])) config (-1)))) && (true))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_*__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Star'__GRHO'Hyph'SYNTAX,(varK0_262 :: []),(varK1_263 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_262 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_263 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("ConsumableSend","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortConsumableSend, var__264) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`[_]_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LSqB'_'RSqB'_GRHO'Hyph'SYNTAX,(varK0_265 :: [])) :: [])) when (isTrue (evalisProcList((varK0_265 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_-__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Hyph'__GRHO'Hyph'SYNTAX,(varK0_266 :: []),(varK1_267 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_266 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_267 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("RhoList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoList, var__268) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("ChanLen","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortChanLen, var__269) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Ground","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortGround, var__270) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("UnconsumableSend","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUnconsumableSend, var__271) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`uri(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isString(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbluri'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((String _ as varK0_272) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`for(_){_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBind(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_273 :: []),(varK1_274 :: [])) :: [])) when (((isTrue (evalisBind((varK0_273 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_274 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_|__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Pipe'__GRHO'Hyph'SYNTAX,(varK0_275 :: []),(varK1_276 :: [])) :: [])) when (((isTrue (evalisProc((varK0_275 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_276 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("BExp","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBExp, var__277) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBind(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_278 :: [])) :: [])) when (isTrue (evalisBind((varK0_278 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`*__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Star'__GRHO'Hyph'SYNTAX,(varK0_279 :: [])) :: [])) when (isTrue (evalisName((varK0_279 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`new_in{_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblnew_in'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_280 :: []),(varK1_281 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_280 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_281 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_282 :: [])) :: [])) when (isTrue (evalisName((varK0_282 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("SingleRec","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSingleRec, var__283) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Proc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortProc, var__284) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("JoinList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortJoinList, var__285) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("New","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNew, var__286) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isAExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_287 :: [])) :: [])) when (isTrue (evalisAExp((varK0_287 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_!!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isRhoTuple(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'BangBang'__GRHO'Hyph'SYNTAX,(varK0_288 :: []),(varK1_289 :: [])) :: [])) when (((isTrue (evalisName((varK0_288 :: [])) config (-1)))) && ((isTrue (evalisRhoTuple((varK1_289 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_<=__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varK0_290 :: []),(varK1_291 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_290 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_291 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(tuple(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbltuple,(varK0_292 :: [])) :: [])) when (isTrue (evalisProcList((varK0_292 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`bundle{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_293 :: [])) :: [])) when (isTrue (evalisProc((varK0_293 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_or__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBExp(K0),isBExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_or__GRHO'Hyph'SYNTAX,(varK0_294 :: []),(varK1_295 :: [])) :: [])) when (((isTrue (evalisBExp((varK0_294 :: [])) config (-1)))) && ((isTrue (evalisBExp((varK1_295 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("AExp","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortAExp, var__296) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`_;_;;__GRHO-SYNTAX`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isNameList(K1)),isInt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varK0_297 :: []),(varK1_298 :: []),((Int _ as varK2_299) :: [])) :: [])) when (((((isTrue (evalisName((varK0_297 :: [])) config (-1)))) && ((isTrue (evalisNameList((varK1_298 :: [])) config (-1)))))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_and__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBExp(K0),isBExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_and__GRHO'Hyph'SYNTAX,(varK0_300 :: []),(varK1_301 :: [])) :: [])) when (((isTrue (evalisBExp((varK0_300 :: [])) config (-1)))) && ((isTrue (evalisBExp((varK1_301 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBinds(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_302 :: [])) :: [])) when (isTrue (evalisBinds((varK0_302 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`Nil_GRHO-SYNTAX`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblNil_GRHO'Hyph'SYNTAX) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isBExp(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_303 :: [])) :: [])) when (isTrue (evalisBExp((varK0_303 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`(_;_)_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varK0_304 :: []),((Int _ as varK1_305) :: [])) :: [])) when (((isTrue (evalisName((varK0_304 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(`_+__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isAExp(K0),isAExp(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Plus'__GRHO'Hyph'SYNTAX,(varK0_306 :: []),(varK1_307 :: [])) :: [])) when (((isTrue (evalisAExp((varK0_306 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_307 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("RhoMap","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoMap, var__308) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`Set(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblSet'LPar'_'RPar'_GRHO'Hyph'SYNTAX,(varK0_309 :: [])) :: [])) when (isTrue (evalisProcList((varK0_309 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__310) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(`{[_;_]}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(varK0_311 :: []),((Int _ as varK1_312) :: [])) :: [])) when (((isTrue (evalisProc((varK0_311 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("BindOcc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBindOcc, var__313) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(#KToken(#token("Send","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSend, var__314) :: [])) -> ((Bool true) :: [])
(*{| rule ``isProc(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_315)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and eval'Star'__GRHO'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Star'__GRHO'Hyph'SYNTAX in match c with 
(*{| rule `` `*__GRHO-SYNTAX`(`@__GRHO-SYNTAX`(P))=>P`` requires isProc(P) ensures #token("true","Bool") [UNIQUE_ID(4e83d4228a2d5a03193db03387d4c0f9ecf78ec0feae17d11a88eb195543b47a) anywhere() contentStartColumn(10) contentStartLine(1621) org.kframework.attributes.Location(Location(1621,10,1621,25)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| ((KApply1(Lbl'_AT_'__GRHO'Hyph'SYNTAX,(varP_316 :: [])) :: [])) when (isTrue (evalisProc((varP_316 :: [])) config (-1))) && (true) -> (varP_316 :: [])
| k0 -> [KApply1(lbl, k0)]
and eval'_AT_'__GRHO'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'_AT_'__GRHO'Hyph'SYNTAX in match c with 
(*{| rule `` `@__GRHO-SYNTAX`(`*__GRHO-SYNTAX`(N))=>N`` requires isName(N) ensures #token("true","Bool") [UNIQUE_ID(6e6f724e94ec0b6a9b0bdee3aef4f48f6931d5433dae2aa8b22bf35c1dd0d714) anywhere() contentStartColumn(10) contentStartLine(1618) org.kframework.attributes.Location(Location(1618,10,1618,25)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| ((KApply1(Lbl'Star'__GRHO'Hyph'SYNTAX,(varN_317 :: [])) :: [])) when (isTrue (evalisName((varN_317 :: [])) config (-1))) && (true) -> (varN_317 :: [])
| k0 -> [KApply1(lbl, k0)]
and evalisName (c: k) (config: k) (guard: int) : k = let lbl = 
LblisName and sort = 
SortBool in match c with 
(*{| rule ``isName(`@__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_AT_'__GRHO'Hyph'SYNTAX,(varK0_318 :: [])) :: [])) when (isTrue (evalisProc((varK0_318 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isName(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__319) :: [])) -> ((Bool true) :: [])
(*{| rule ``isName(#KToken(#token("NameVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNameVar, var__320) :: [])) -> ((Bool true) :: [])
(*{| rule ``isName(`unforgeable(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblunforgeable'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((Int _ as varK0_321) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isName(#KToken(#token("Name","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortName, var__322) :: [])) -> ((Bool true) :: [])
(*{| rule ``isName(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_323)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortInt in match c with 
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>#token("2","Int")`` requires `_andBool_`(isLbind(B),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(2d69b0496a74df5b6ce1436a5e499d7f038f717be710c437cefd9aac491488a6) contentStartColumn(8) contentStartLine(198) org.kframework.attributes.Location(Location(198,8,198,43)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_324 :: []),(varC_325 :: [])) :: [])) when (((isTrue (evalisLbind((varB_324 :: [])) config (-1)))) && ((isTrue (evalisLbind((varC_325 :: [])) config (-1))))) && (true) -> ((Lazy.force int2) :: [])
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(_43,N))=>`_+Int_`(#token("1","Int"),`#length(_)_AUXFUN-SYNTAX`(N))`` requires `_andBool_`(isName(_43),isNames(N)) ensures #token("true","Bool") [UNIQUE_ID(08e2949015a6d85ec65be010ae0a4f6448ff47992c172f0f3f23af2287b0dd37) contentStartColumn(8) contentStartLine(194) org.kframework.attributes.Location(Location(194,8,194,58)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(var_43_326 :: []),(varN_327 :: [])) :: [])) when (((isTrue (evalisName((var_43_326 :: [])) config (-1)))) && ((isTrue (evalisNames((varN_327 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varN_327 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_+Int_`(#token("1","Int"),`#length(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isPbind(B),isPbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(4ee77b85c886ab1d45259cd600b8bee115467c361110019514bb0223517ff168) contentStartColumn(8) contentStartLine(205) org.kframework.attributes.Location(Location(205,8,205,60)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_328 :: []),(varC_329 :: [])) :: [])) when (((isTrue (evalisPbind((varB_328 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varC_329 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_329 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>#token("2","Int")`` requires `_andBool_`(isRbind(C),isRbind(B)) ensures #token("true","Bool") [UNIQUE_ID(06016612d41367d3096924b9106ea2c2eeef72b1391b9ebede29ca657e2837ec) contentStartColumn(8) contentStartLine(201) org.kframework.attributes.Location(Location(201,8,201,43)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_330 :: []),(varC_331 :: [])) :: [])) when (((isTrue (evalisRbind((varC_331 :: [])) config (-1)))) && ((isTrue (evalisRbind((varB_330 :: [])) config (-1))))) && (true) -> ((Lazy.force int2) :: [])
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>#token("2","Int")`` requires `_andBool_`(isPbind(C),isPbind(B)) ensures #token("true","Bool") [UNIQUE_ID(6b830e33ab70c249caea2aa702665dfa1ba280e35693b47f3a9e3cd61bc37791) contentStartColumn(8) contentStartLine(204) org.kframework.attributes.Location(Location(204,8,204,43)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_332 :: []),(varC_333 :: [])) :: [])) when (((isTrue (evalisPbind((varC_333 :: [])) config (-1)))) && ((isTrue (evalisPbind((varB_332 :: [])) config (-1))))) && (true) -> ((Lazy.force int2) :: [])
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(_25,_26))=>#token("2","Int")`` requires `_andBool_`(isName(_26),isName(_25)) ensures #token("true","Bool") [UNIQUE_ID(4b1ef826dbbb4a6044f0357a4c15bc38dc89f115a2b3392ae244773e25752bfa) contentStartColumn(8) contentStartLine(193) org.kframework.attributes.Location(Location(193,8,193,41)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(var_25_334 :: []),(var_26_335 :: [])) :: [])) when (((isTrue (evalisName((var_26_335 :: [])) config (-1)))) && ((isTrue (evalisName((var_25_334 :: [])) config (-1))))) && (true) -> ((Lazy.force int2) :: [])
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_+Int_`(#token("1","Int"),`#length(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isLbinds(C),isLbind(B)) ensures #token("true","Bool") [UNIQUE_ID(4d537869814547490bea98b338b043cdbba091f97df19f7aba1d4ca11b32fe3b) contentStartColumn(8) contentStartLine(199) org.kframework.attributes.Location(Location(199,8,199,60)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_336 :: []),(varC_337 :: [])) :: [])) when (((isTrue (evalisLbinds((varC_337 :: [])) config (-1)))) && ((isTrue (evalisLbind((varB_336 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_337 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_+Int_`(#token("1","Int"),`#length(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isRbind(B),isRbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(f4151ebe1a69c5144c0a355c7820c20c23c8353a8c723708990e4105e329e8bf) contentStartColumn(8) contentStartLine(202) org.kframework.attributes.Location(Location(202,8,202,60)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_338 :: []),(varC_339 :: [])) :: [])) when (((isTrue (evalisRbind((varB_338 :: [])) config (-1)))) && ((isTrue (evalisRbinds((varC_339 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_339 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#length(_)_AUXFUN-SYNTAX`(_76)=>#token("1","Int")`` requires isName(_76) ensures #token("true","Bool") [UNIQUE_ID(81345c2577438fa6b21fc0bd5130c9994f25cd826538839e19141dcb3c75b06e) contentStartColumn(8) contentStartLine(192) org.kframework.attributes.Location(Location(192,8,192,41)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((var_76_340 :: [])) when (isTrue (evalisName((var_76_340 :: [])) config (-1))) && (true) -> ((Lazy.force int1) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortInt in match c with 
(*{| rule `` `#bnum(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(_29,_30))=>#token("1","Int")`` requires `_andBool_`(isName(_29),isName(_30)) ensures #token("true","Bool") [UNIQUE_ID(2f3ecbd822a43c165a55d47c6a2ab233f1b10a1c0453e8588b4b356209f7ba9e) contentStartColumn(8) contentStartLine(247) org.kframework.attributes.Location(Location(247,8,247,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(var_29_341 :: []),(var_30_342 :: [])) :: [])) when (((isTrue (evalisName((var_29_341 :: [])) config (-1)))) && ((isTrue (evalisName((var_30_342 :: [])) config (-1))))) && (true) -> ((Lazy.force int1) :: [])
(*{| rule `` `#bnum(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(_52,_53))=>#token("1","Int")`` requires `_andBool_`(isName(_52),isName(_53)) ensures #token("true","Bool") [UNIQUE_ID(c7726a9d81d1e65c28b7fcbec3efcb9e53f0e2c8c767efdd1b88104836edba59) contentStartColumn(8) contentStartLine(251) org.kframework.attributes.Location(Location(251,8,251,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(var_52_343 :: []),(var_53_344 :: [])) :: [])) when (((isTrue (evalisName((var_52_343 :: [])) config (-1)))) && ((isTrue (evalisName((var_53_344 :: [])) config (-1))))) && (true) -> ((Lazy.force int1) :: [])
(*{| rule `` `#bnum(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(N,_77))=>`#length(_)_AUXFUN-SYNTAX`(N)`` requires `_andBool_`(isName(_77),isNames(N)) ensures #token("true","Bool") [UNIQUE_ID(72b6283d5c6a36969291fbffe37208d1fc402999ac6e78f9fb154465bb8d2188) contentStartColumn(8) contentStartLine(252) org.kframework.attributes.Location(Location(252,8,252,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varN_345 :: []),(var_77_346 :: [])) :: [])) when (((isTrue (evalisName((var_77_346 :: [])) config (-1)))) && ((isTrue (evalisNames((varN_345 :: [])) config (-1))))) && (true) -> ((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varN_345 :: [])) config (-1)))
(*{| rule `` `#bnum(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,_32))=>`#length(_)_AUXFUN-SYNTAX`(B)`` requires `_andBool_`(isProc(_32),isBinds(B)) ensures #token("true","Bool") [UNIQUE_ID(23d42d8b48e7ba2572f8ebafc088fce9305bd2e3735d239a1d946cd3bde28b7f) contentStartColumn(8) contentStartLine(115) org.kframework.attributes.Location(Location(115,8,115,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varB_347 :: []),(var_32_348 :: [])) :: [])) when (((isTrue (evalisProc((var_32_348 :: [])) config (-1)))) && ((isTrue (evalisBinds((varB_347 :: [])) config (-1))))) && (true) -> ((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_347 :: [])) config (-1)))
(*{| rule `` `#bnum(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(N,_39))=>`#length(_)_AUXFUN-SYNTAX`(N)`` requires `_andBool_`(isName(_39),isNames(N)) ensures #token("true","Bool") [UNIQUE_ID(9cd8711433b85d45230386ce47b1b302d855cf77075e61f49947be9c4baa92b0) contentStartColumn(8) contentStartLine(248) org.kframework.attributes.Location(Location(248,8,248,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varN_349 :: []),(var_39_350 :: [])) :: [])) when (((isTrue (evalisName((var_39_350 :: [])) config (-1)))) && ((isTrue (evalisNames((varN_349 :: [])) config (-1))))) && (true) -> ((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varN_349 :: [])) config (-1)))
(*{| rule `` `#bnum(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,_84))=>`#bnum(_)_AUXFUN-SYNTAX`(B)`` requires `_andBool_`(isProc(_84),isBind(B)) ensures #token("true","Bool") [UNIQUE_ID(d7279f4a98b425313a99780bc288453ec71e37c782554b7047112379b5fd958a) contentStartColumn(8) contentStartLine(114) org.kframework.attributes.Location(Location(114,8,114,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varB_351 :: []),(var_84_352 :: [])) :: [])) when (((isTrue (evalisProc((var_84_352 :: [])) config (-1)))) && ((isTrue (evalisBind((varB_351 :: [])) config (-1))))) && (true) -> ((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_351 :: [])) config (-1)))
(*{| rule `` `#bnum(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(_65,_66))=>#token("1","Int")`` requires `_andBool_`(isName(_66),isName(_65)) ensures #token("true","Bool") [UNIQUE_ID(a2ce1dfe4dd418c75425aff79b4239eb59a6852187730e64af11fd066c04d985) contentStartColumn(8) contentStartLine(249) org.kframework.attributes.Location(Location(249,8,249,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(var_65_353 :: []),(var_66_354 :: [])) :: [])) when (((isTrue (evalisName((var_66_354 :: [])) config (-1)))) && ((isTrue (evalisName((var_65_353 :: [])) config (-1))))) && (true) -> ((Lazy.force int1) :: [])
(*{| rule `` `#bnum(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(N,_21))=>`#length(_)_AUXFUN-SYNTAX`(N)`` requires `_andBool_`(isName(_21),isNames(N)) ensures #token("true","Bool") [UNIQUE_ID(532097a252016c39603eef0e64fb1aeae83dbbfe3fc895efa444f80b3a9b28dc) contentStartColumn(8) contentStartLine(250) org.kframework.attributes.Location(Location(250,8,250,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varN_355 :: []),(var_21_356 :: [])) :: [])) when (((isTrue (evalisName((var_21_356 :: [])) config (-1)))) && ((isTrue (evalisNames((varN_355 :: [])) config (-1))))) && (true) -> ((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varN_355 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'argv (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'argv and sort = 
SortList in match c with 
| _ -> try KREFLECTION.hook_argv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'argv : k Lazy.t = lazy (eval'Hash'argv () interned_bottom (-1))
let evalisK (c: k) (config: k) (guard: int) : k = let lbl = 
LblisK and sort = 
SortBool in match c with 
| [_] -> [Bool true] | _ -> [Bool false]
| [List (s,_,_)] when (s = SortList) -> [Bool true]
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
| _ -> [Bool true]
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
| [Int _] -> [Bool true]
| [Float _] -> [Bool true]
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKCell and sort = 
SortBool in match c with 
(*{| rule ``isKCell(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_357)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKCell(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__358) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_359)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisThreadCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadCell and sort = 
SortBool in match c with 
(*{| rule ``isThreadCell(`<thread>`(K0))=>#token("true","Bool")`` requires isKCell(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'thread'_GT_',(varK0_360 :: [])) :: [])) when (isTrue (evalisKCell((varK0_360 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadCell(#KToken(#token("ThreadCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCell, var__361) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_362)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisPbindList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisPbindList and sort = 
SortBool in match c with 
(*{| rule ``isPbindList(#KToken(#token("Pbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbind, var__363) :: [])) -> ((Bool true) :: [])
(*{| rule ``isPbindList(#KToken(#token("PbindList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbindList, var__364) :: [])) -> ((Bool true) :: [])
(*{| rule ``isPbindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isPbind(K0),isPbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_365 :: []),(varK1_366 :: [])) :: [])) when (((isTrue (evalisPbind((varK0_365 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varK1_366 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isPbindList(`_<!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varK0_367 :: []),(varK1_368 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_367 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_368 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isPbindList(#KToken(#token("Pbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbinds, var__369) :: [])) -> ((Bool true) :: [])
(*{| rule ``isPbindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isPbind(K0),isPbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_370 :: []),(varK1_371 :: [])) :: [])) when (((isTrue (evalisPbind((varK0_370 :: [])) config (-1)))) && ((isTrue (evalisPbind((varK1_371 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isPbindList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_372)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalMap'Coln'lookup (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'lookup and sort = 
SortKItem in match c with 
| _ -> try MAP.hook_lookup c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisChanList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisChanList and sort = 
SortBool in match c with 
(*{| rule ``isChanList(#KToken(#token("ChanList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortChanList, var__373) :: [])) -> ((Bool true) :: [])
(*{| rule ``isChanList(`(_;_)_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isNameList(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varK0_374 :: []),(varK1_375 :: [])) :: [])) when (((isTrue (evalisName((varK0_374 :: [])) config (-1)))) && ((isTrue (evalisNameList((varK1_375 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isChanList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_376)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'stderr_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stderr_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stderr_K-IO`(.KList)=>#token("2","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(11ef087f50cc8e9fe0fe6a8b028370816f2f2a3573af358ab6ca98318723d0e5) contentStartColumn(8) contentStartLine(910) org.kframework.attributes.Location(Location(910,8,910,20)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| () -> ((Lazy.force int2) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stderr_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stderr_K'Hyph'IO () interned_bottom (-1))
let eval'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_seek c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisIdNum (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIdNum and sort = 
SortBool in match c with 
(*{| rule ``isIdNum(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isInt(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,((Int _ as varK0_377) :: []),((Int _ as varK1_378) :: [])) :: [])) when ((true) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isIdNum(#KToken(#token("IdNum","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIdNum, var__379) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIdNum(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_380)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisWhoCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWhoCell and sort = 
SortBool in match c with 
(*{| rule ``isWhoCell(#KToken(#token("WhoCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhoCell, var__381) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhoCell(`<who>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'who'_GT_',(varK0_382)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isWhoCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_383)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsEqls'K_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'K_ and sort = 
SortBool in match c with 
| _ -> try KEQUAL.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsEqls'Bool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'Bool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==Bool__BOOL`(K1,K2)=>`_==K_`(K1,K2)`` requires `_andBool_`(isBool(K1),isBool(K2)) ensures #token("true","Bool") [UNIQUE_ID(a17699668426366833f88851c95d611be854ecef7a676d2061669bf689f05fd1) contentStartColumn(8) contentStartLine(765) org.kframework.attributes.Location(Location(765,8,765,43)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK1_384) :: []),((Bool _ as varK2_385) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varK1_384 :: []),(varK2_385 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Perc'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Perc'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_tmod c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalabsInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblabsInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_abs c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsEqls'Int_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'Int_ and sort = 
SortBool in match c with 
| _ -> try INT.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==Int_`(I1,I2)=>`_==K_`(I1,I2)`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(e92e4aa4a18bee70f2627cdafb8687e2dfcc0dd6a7f8cbb8d1bd17d751c2da2a) contentStartColumn(8) contentStartLine(407) org.kframework.attributes.Location(Location(407,8,407,40)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_386) :: []),((Int _ as varI2_387) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varI1_386 :: []),(varI2_387 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsSlshEqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=Int__INT`(I1,I2)=>`notBool_`(`_==Int_`(I1,I2))`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(59ca895589d5fc7fa573380dac68ddd6602f6fa8b2761530a861aa894455f27e) contentStartColumn(8) contentStartLine(408) org.kframework.attributes.Location(Location(408,8,408,53)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_388) :: []),((Int _ as varI2_389) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Int_((varI1_388 :: []),(varI2_389 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_modInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_modInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_emod c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_modInt__INT`(I1,I2)=>`_%Int__INT`(`_+Int_`(`_%Int__INT`(I1,absInt(I2)),absInt(I2)),absInt(I2))`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_=/=Int__INT`(I2,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(fb4bf5b2f12862af75611e525d51d7e1966bcc322ee8456d2ed1cdaadf02f6f5) concrete() contentStartColumn(5) contentStartLine(391) org.kframework.attributes.Location(Location(391,5,394,23)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_390) :: []),((Int _ as varI2_391) :: [])) when ((((true) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varI2_391 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Perc'Int__INT(((eval_'Plus'Int_(((eval_'Perc'Int__INT((varI1_390 :: []),((evalabsInt((varI2_391 :: [])) config (-1)))) config (-1))),((evalabsInt((varI2_391 :: [])) config (-1)))) config (-1))),((evalabsInt((varI2_391 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_GT__GT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT__GT_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_shr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_LT__LT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT__LT_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_shl c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalbitRangeInt (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblbitRangeInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_bitRange c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``bitRangeInt(I,IDX,LEN)=>`_modInt__INT`(`_>>Int__INT`(I,IDX),`_<<Int__INT`(#token("1","Int"),LEN))`` requires `_andBool_`(`_andBool_`(isInt(I),isInt(LEN)),isInt(IDX)) ensures #token("true","Bool") [UNIQUE_ID(08ec18eb216a86553c22eacaaf8b628b19097a5f4dbbbbb68a5daa77c9337449) contentStartColumn(8) contentStartLine(384) org.kframework.attributes.Location(Location(384,8,384,70)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_392) :: []),((Int _ as varIDX_393) :: []),((Int _ as varLEN_394) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((eval_modInt__INT(((eval_'_GT__GT_'Int__INT((varI_392 :: []),(varIDX_393 :: [])) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),(varLEN_394 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalsignExtendBitRangeInt (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblsignExtendBitRangeInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_signExtendBitRange c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``signExtendBitRangeInt(I,IDX,LEN)=>`_-Int__INT`(`_modInt__INT`(`_+Int_`(bitRangeInt(I,IDX,LEN),`_<<Int__INT`(#token("1","Int"),`_-Int__INT`(LEN,#token("1","Int")))),`_<<Int__INT`(#token("1","Int"),LEN)),`_<<Int__INT`(#token("1","Int"),`_-Int__INT`(LEN,#token("1","Int"))))`` requires `_andBool_`(`_andBool_`(isInt(I),isInt(LEN)),isInt(IDX)) ensures #token("true","Bool") [UNIQUE_ID(b413c3f4500443aec69bee9b10feb030330d60bd136c698a9947546393728a00) contentStartColumn(8) contentStartLine(386) org.kframework.attributes.Location(Location(386,8,386,149)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_395) :: []),((Int _ as varIDX_396) :: []),((Int _ as varLEN_397) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((eval_'Hyph'Int__INT(((eval_modInt__INT(((eval_'Plus'Int_(((evalbitRangeInt((varI_395 :: []),(varIDX_396 :: []),(varLEN_397 :: [])) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),((eval_'Hyph'Int__INT((varLEN_397 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),(varLEN_397 :: [])) config (-1)))) config (-1))),((eval_'_LT__LT_'Int__INT(((Lazy.force int1) :: []),((eval_'Hyph'Int__INT((varLEN_397 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalisSet (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSet and sort = 
SortBool in match c with 
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
(*{| rule ``isSet(#KToken(#token("Set","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSet, var__398) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSet(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_399)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'getenv (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'getenv and sort = 
SortString in match c with 
| _ -> try KREFLECTION.hook_getenv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSchanCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSchanCell and sort = 
SortBool in match c with 
(*{| rule ``isSchanCell(#KToken(#token("SchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSchanCell, var__400) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSchanCell(`<schan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'schan'_GT_',(varK0_401)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSchanCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_402)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisMsgCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMsgCell and sort = 
SortBool in match c with 
(*{| rule ``isMsgCell(`<msg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msg'_GT_',(varK0_403)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMsgCell(#KToken(#token("MsgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsgCell, var__404) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsgCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_405)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTupleCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTupleCell and sort = 
SortBool in match c with 
(*{| rule ``isTupleCell(`<tuple>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'tuple'_GT_',(varK0_406)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isTupleCell(#KToken(#token("TupleCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTupleCell, var__407) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTupleCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_408)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStypeCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStypeCell and sort = 
SortBool in match c with 
(*{| rule ``isStypeCell(`<stype>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'stype'_GT_',(varK0_409)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStypeCell(#KToken(#token("StypeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStypeCell, var__410) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStypeCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_411)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSidCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSidCell and sort = 
SortBool in match c with 
(*{| rule ``isSidCell(#KToken(#token("SidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSidCell, var__412) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSidCell(`<sid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sid'_GT_',(varK0_413)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSidCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_414)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisMlidCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMlidCell and sort = 
SortBool in match c with 
(*{| rule ``isMlidCell(#KToken(#token("MlidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMlidCell, var__415) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMlidCell(`<mlid>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varK0_416) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMlidCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_417)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendCellBag and sort = 
SortBool in match c with 
(*{| rule ``isSendCellBag(`<send>`(K0,K1,K2,K3,K4,K5))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isSchanCell(K0),isMsgCell(K1)),isTupleCell(K2)),isStypeCell(K3)),isSidCell(K4)),isMlidCell(K5)) ensures #token("true","Bool") []|}*)
| ((KApply6(Lbl'_LT_'send'_GT_',(varK0_418 :: []),(varK1_419 :: []),(varK2_420 :: []),(varK3_421 :: []),(varK4_422 :: []),(varK5_423 :: [])) :: [])) when (((((((((((isTrue (evalisSchanCell((varK0_418 :: [])) config (-1)))) && ((isTrue (evalisMsgCell((varK1_419 :: [])) config (-1)))))) && ((isTrue (evalisTupleCell((varK2_420 :: [])) config (-1)))))) && ((isTrue (evalisStypeCell((varK3_421 :: [])) config (-1)))))) && ((isTrue (evalisSidCell((varK4_422 :: [])) config (-1)))))) && ((isTrue (evalisMlidCell((varK5_423 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendCellBag(#KToken(#token("SendCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCell, var__424) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendCellBag(#KToken(#token("SendCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCellBag, var__425) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_426)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendsCell and sort = 
SortBool in match c with 
(*{| rule ``isSendsCell(`<sends>`(K0))=>#token("true","Bool")`` requires isSendCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sends'_GT_',(varK0_427 :: [])) :: [])) when (isTrue (evalisSendCellBag((varK0_427 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendsCell(#KToken(#token("SendsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCell, var__428) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_429)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIdCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIdCell and sort = 
SortBool in match c with 
(*{| rule ``isIdCell(#KToken(#token("IdCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIdCell, var__430) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIdCell(`<id>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'id'_GT_',(varK0_431)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isIdCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_432)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisLengthCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisLengthCell and sort = 
SortBool in match c with 
(*{| rule ``isLengthCell(#KToken(#token("LengthCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLengthCell, var__433) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLengthCell(`<length>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'length'_GT_',(varK0_434)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isLengthCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_435)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisContCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisContCell and sort = 
SortBool in match c with 
(*{| rule ``isContCell(`<cont>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'cont'_GT_',(varK0_436)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isContCell(#KToken(#token("ContCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortContCell, var__437) :: [])) -> ((Bool true) :: [])
(*{| rule ``isContCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_438)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStateCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStateCell and sort = 
SortBool in match c with 
(*{| rule ``isStateCell(#KToken(#token("StateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCell, var__439) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStateCell(`<state>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'state'_GT_',(varK0_440)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStateCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_441)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisMatchCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMatchCell and sort = 
SortBool in match c with 
(*{| rule ``isMatchCell(#KToken(#token("MatchCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMatchCell, var__442) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMatchCell(`<match>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'match'_GT_',(varK0_443)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMatchCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_444)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTypeCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTypeCell and sort = 
SortBool in match c with 
(*{| rule ``isTypeCell(#KToken(#token("TypeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTypeCell, var__445) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTypeCell(`<type>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'type'_GT_',(varK0_446)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isTypeCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_447)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisNomoCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNomoCell and sort = 
SortBool in match c with 
(*{| rule ``isNomoCell(#KToken(#token("NomoCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNomoCell, var__448) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNomoCell(`<nomo>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as varK0_449) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isNomoCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_450)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisChanCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisChanCell and sort = 
SortBool in match c with 
(*{| rule ``isChanCell(#KToken(#token("ChanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortChanCell, var__451) :: [])) -> ((Bool true) :: [])
(*{| rule ``isChanCell(`<chan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'chan'_GT_',(varK0_452)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isChanCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_453)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisVarsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisVarsCell and sort = 
SortBool in match c with 
(*{| rule ``isVarsCell(`<vars>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'vars'_GT_',(varK0_454)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isVarsCell(#KToken(#token("VarsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortVarsCell, var__455) :: [])) -> ((Bool true) :: [])
(*{| rule ``isVarsCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_456)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisNumCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNumCell and sort = 
SortBool in match c with 
(*{| rule ``isNumCell(`<num>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'num'_GT_',(varK0_457)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isNumCell(#KToken(#token("NumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNumCell, var__458) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNumCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_459)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisLidCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisLidCell and sort = 
SortBool in match c with 
(*{| rule ``isLidCell(`<lid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'lid'_GT_',(varK0_460)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isLidCell(#KToken(#token("LidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLidCell, var__461) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLidCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_462)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisMsidCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMsidCell and sort = 
SortBool in match c with 
(*{| rule ``isMsidCell(`<msid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msid'_GT_',(varK0_463)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMsidCell(#KToken(#token("MsidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsidCell, var__464) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsidCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_465)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisListenCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisListenCellBag and sort = 
SortBool in match c with 
(*{| rule ``isListenCellBag(#KToken(#token("ListenCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListenCellBag, var__466) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListenCellBag(#KToken(#token("ListenCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListenCell, var__467) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListenCellBag(`<listen>`(K0,K1,K2,K3,K4))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isChanCell(K0),isVarsCell(K1)),isNumCell(K2)),isLidCell(K3)),isMsidCell(K4)) ensures #token("true","Bool") []|}*)
| ((KApply5(Lbl'_LT_'listen'_GT_',(varK0_468 :: []),(varK1_469 :: []),(varK2_470 :: []),(varK3_471 :: []),(varK4_472 :: [])) :: [])) when (((((((((isTrue (evalisChanCell((varK0_468 :: [])) config (-1)))) && ((isTrue (evalisVarsCell((varK1_469 :: [])) config (-1)))))) && ((isTrue (evalisNumCell((varK2_470 :: [])) config (-1)))))) && ((isTrue (evalisLidCell((varK3_471 :: [])) config (-1)))))) && ((isTrue (evalisMsidCell((varK4_472 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isListenCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_473)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisListensCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisListensCell and sort = 
SortBool in match c with 
(*{| rule ``isListensCell(#KToken(#token("ListensCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListensCell, var__474) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListensCell(`<listens>`(K0))=>#token("true","Bool")`` requires isListenCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'listens'_GT_',(varK0_475 :: [])) :: [])) when (isTrue (evalisListenCellBag((varK0_475 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isListensCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_476)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRecCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecCellBag and sort = 
SortBool in match c with 
(*{| rule ``isRecCellBag(`<rec>`(K0,K1,K2,K3,K4,K5,K6,K7))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isIdCell(K0),isLengthCell(K1)),isContCell(K2)),isStateCell(K3)),isMatchCell(K4)),isTypeCell(K5)),isNomoCell(K6)),isListensCell(K7)) ensures #token("true","Bool") []|}*)
| ((KApply8(Lbl'_LT_'rec'_GT_',(varK0_477 :: []),(varK1_478 :: []),(varK2_479 :: []),(varK3_480 :: []),(varK4_481 :: []),(varK5_482 :: []),(varK6_483 :: []),(varK7_484 :: [])) :: [])) when (((((((((((((((isTrue (evalisIdCell((varK0_477 :: [])) config (-1)))) && ((isTrue (evalisLengthCell((varK1_478 :: [])) config (-1)))))) && ((isTrue (evalisContCell((varK2_479 :: [])) config (-1)))))) && ((isTrue (evalisStateCell((varK3_480 :: [])) config (-1)))))) && ((isTrue (evalisMatchCell((varK4_481 :: [])) config (-1)))))) && ((isTrue (evalisTypeCell((varK5_482 :: [])) config (-1)))))) && ((isTrue (evalisNomoCell((varK6_483 :: [])) config (-1)))))) && ((isTrue (evalisListensCell((varK7_484 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecCellBag(#KToken(#token("RecCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCellBag, var__485) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecCellBag(#KToken(#token("RecCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCell, var__486) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_487)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisReceivesCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReceivesCell and sort = 
SortBool in match c with 
(*{| rule ``isReceivesCell(`<receives>`(K0))=>#token("true","Bool")`` requires isRecCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'receives'_GT_',(varK0_488 :: [])) :: [])) when (isTrue (evalisRecCellBag((varK0_488 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isReceivesCell(#KToken(#token("ReceivesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReceivesCell, var__489) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReceivesCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_490)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTuplespaceCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTuplespaceCell and sort = 
SortBool in match c with 
(*{| rule ``isTuplespaceCell(`<tuplespace>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSendsCell(K0),isReceivesCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'tuplespace'_GT_',(varK0_491 :: []),(varK1_492 :: [])) :: [])) when (((isTrue (evalisSendsCell((varK0_491 :: [])) config (-1)))) && ((isTrue (evalisReceivesCell((varK1_492 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCell(#KToken(#token("TuplespaceCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCell, var__493) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_494)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalintersectSet (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblintersectSet and sort = 
SortSet in match c with 
| _ -> try SET.hook_intersection c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitMsgCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitMsgCell and sort = 
SortMsgCell in match c with 
(*{| rule ``initMsgCell(.KList)=>`<msg>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(1b2eec790506b4e2b5dc92efe6a0fd6aa6ec03227fcef86f1d415c06b10a6181) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'msg'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitMsgCell : k Lazy.t = lazy (evalinitMsgCell () interned_bottom (-1))
let eval_in_keys'LPar'_'RPar'_MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_in_keys'LPar'_'RPar'_MAP and sort = 
SortBool in match c with 
| _ -> try MAP.hook_in_keys c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'bind'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'bind'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortBind in match c with 
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_21))=>`_<-__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(A),isNames(B)),`_==Int_`(_21,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(2c48a58e39492e2894e6140c8d4f0f2e059cfa9191c80c337f7412b752e501be) contentStartColumn(8) contentStartLine(153) org.kframework.attributes.Location(Location(153,8,153,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_495 :: []),(varB_496 :: []),((Int _ as var_21_497) :: [])) :: [])) when (((((isTrue (evalisName((varA_495 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_496 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_21_497 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varB_496 :: []),(varA_495 :: [])) :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_2))=>`_<!__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(A),isNames(B)),`_==Int_`(_2,#token("2","Int"))) ensures #token("true","Bool") [UNIQUE_ID(b4ad0fa8b0d7cd7747bafccd41b79e4dca9494a50e89e798fc08e56508f64b50) contentStartColumn(8) contentStartLine(157) org.kframework.attributes.Location(Location(157,8,157,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_498 :: []),(varB_499 :: []),((Int _ as var_2_500) :: [])) :: [])) when (((((isTrue (evalisName((varA_498 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_499 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_2_500 :: []),((Lazy.force int2) :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varB_499 :: []),(varA_498 :: [])) :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_47))=>`_<=__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),`_==Int_`(_47,#token("1","Int"))) ensures #token("true","Bool") [UNIQUE_ID(8ee964f2b9dbe218f948c1f5930fca2589bf9851bfd3d27002c41b8c07318462) contentStartColumn(8) contentStartLine(154) org.kframework.attributes.Location(Location(154,8,154,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_501 :: []),(varB_502 :: []),((Int _ as var_47_503) :: [])) :: [])) when (((((isTrue (evalisName((varB_502 :: [])) config (-1)))) && ((isTrue (evalisName((varA_501 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_47_503 :: []),((Lazy.force int1) :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX((varB_502 :: []),(varA_501 :: [])) config (-1)))
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,_27))=>B`` requires `_andBool_`(isProc(_27),isBinds(B)) ensures #token("true","Bool") [UNIQUE_ID(1bf0554c51562758abea985a98ffa454141e27a60019a568141ef9b8ee84f32c) contentStartColumn(8) contentStartLine(103) org.kframework.attributes.Location(Location(103,8,103,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varB_504 :: []),(var_27_505 :: [])) :: [])) when (((isTrue (evalisProc((var_27_505 :: [])) config (-1)))) && ((isTrue (evalisBinds((varB_504 :: [])) config (-1))))) && (true) -> (varB_504 :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_5))=>`_<=__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(A),isNames(B)),`_==Int_`(_5,#token("1","Int"))) ensures #token("true","Bool") [UNIQUE_ID(4760c8323c694905aa56f11e4d61c16d6f4250de6b7d3ca4b896bc18134dbdc4) contentStartColumn(8) contentStartLine(155) org.kframework.attributes.Location(Location(155,8,155,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_506 :: []),(varB_507 :: []),((Int _ as var_5_508) :: [])) :: [])) when (((((isTrue (evalisName((varA_506 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_507 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_5_508 :: []),((Lazy.force int1) :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX((varB_507 :: []),(varA_506 :: [])) config (-1)))
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_6))=>`_<-__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),`_==Int_`(_6,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(bc7d474ac1ffcecf0d6546a31c936a5e06f40b35b3ab826f2113dbb5ba262dbb) contentStartColumn(8) contentStartLine(152) org.kframework.attributes.Location(Location(152,8,152,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_509 :: []),(varB_510 :: []),((Int _ as var_6_511) :: [])) :: [])) when (((((isTrue (evalisName((varB_510 :: [])) config (-1)))) && ((isTrue (evalisName((varA_509 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_6_511 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varB_510 :: []),(varA_509 :: [])) :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_65))=>`_<-__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),`_==Int_`(_65,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(bc7d474ac1ffcecf0d6546a31c936a5e06f40b35b3ab826f2113dbb5ba262dbb) contentStartColumn(8) contentStartLine(152) org.kframework.attributes.Location(Location(152,8,152,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_512 :: []),(varB_513 :: []),((Int _ as var_65_514) :: [])) :: [])) when (((((isTrue (evalisName((varB_513 :: [])) config (-1)))) && ((isTrue (evalisName((varA_512 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_65_514 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varB_513 :: []),(varA_512 :: [])) :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_1))=>`_<-__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(A),isNames(B)),`_==Int_`(_1,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(2c48a58e39492e2894e6140c8d4f0f2e059cfa9191c80c337f7412b752e501be) contentStartColumn(8) contentStartLine(153) org.kframework.attributes.Location(Location(153,8,153,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_515 :: []),(varB_516 :: []),((Int _ as var_1_517) :: [])) :: [])) when (((((isTrue (evalisName((varA_515 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_516 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_1_517 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varB_516 :: []),(varA_515 :: [])) :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_60))=>`_<=__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(A),isNames(B)),`_==Int_`(_60,#token("1","Int"))) ensures #token("true","Bool") [UNIQUE_ID(4760c8323c694905aa56f11e4d61c16d6f4250de6b7d3ca4b896bc18134dbdc4) contentStartColumn(8) contentStartLine(155) org.kframework.attributes.Location(Location(155,8,155,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_518 :: []),(varB_519 :: []),((Int _ as var_60_520) :: [])) :: [])) when (((((isTrue (evalisName((varA_518 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_519 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_60_520 :: []),((Lazy.force int1) :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX((varB_519 :: []),(varA_518 :: [])) config (-1)))
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_3))=>`_<!__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),`_==Int_`(_3,#token("2","Int"))) ensures #token("true","Bool") [UNIQUE_ID(e25d298d6e16a47056dc8d16e1f502118548f99812a80151ffbf46b6fdb2dff5) contentStartColumn(8) contentStartLine(156) org.kframework.attributes.Location(Location(156,8,156,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_521 :: []),(varB_522 :: []),((Int _ as var_3_523) :: [])) :: [])) when (((((isTrue (evalisName((varB_522 :: [])) config (-1)))) && ((isTrue (evalisName((varA_521 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_3_523 :: []),((Lazy.force int2) :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varB_522 :: []),(varA_521 :: [])) :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_4))=>`_<=__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),`_==Int_`(_4,#token("1","Int"))) ensures #token("true","Bool") [UNIQUE_ID(8ee964f2b9dbe218f948c1f5930fca2589bf9851bfd3d27002c41b8c07318462) contentStartColumn(8) contentStartLine(154) org.kframework.attributes.Location(Location(154,8,154,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_524 :: []),(varB_525 :: []),((Int _ as var_4_526) :: [])) :: [])) when (((((isTrue (evalisName((varB_525 :: [])) config (-1)))) && ((isTrue (evalisName((varA_524 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_4_526 :: []),((Lazy.force int1) :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX((varB_525 :: []),(varA_524 :: [])) config (-1)))
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_22))=>`_<!__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(A),isNames(B)),`_==Int_`(_22,#token("2","Int"))) ensures #token("true","Bool") [UNIQUE_ID(b4ad0fa8b0d7cd7747bafccd41b79e4dca9494a50e89e798fc08e56508f64b50) contentStartColumn(8) contentStartLine(157) org.kframework.attributes.Location(Location(157,8,157,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_527 :: []),(varB_528 :: []),((Int _ as var_22_529) :: [])) :: [])) when (((((isTrue (evalisName((varA_527 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_528 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_22_529 :: []),((Lazy.force int2) :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varB_528 :: []),(varA_527 :: [])) :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,_28))=>B`` requires `_andBool_`(isBind(B),isProc(_28)) ensures #token("true","Bool") [UNIQUE_ID(020fc3b95a7da603ff351eeb1eecaaaf214c3a11f755e27fe4e89df1e73d8983) contentStartColumn(8) contentStartLine(102) org.kframework.attributes.Location(Location(102,8,102,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varB_530 :: []),(var_28_531 :: [])) :: [])) when (((isTrue (evalisBind((varB_530 :: [])) config (-1)))) && ((isTrue (evalisProc((var_28_531 :: [])) config (-1))))) && (true) -> (varB_530 :: [])
(*{| rule `` `#bind(_)_AUXFUN-SYNTAX`(`_;_;;__GRHO-SYNTAX`(A,B,_23))=>`_<!__GRHO-SYNTAX`(B,A)`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),`_==Int_`(_23,#token("2","Int"))) ensures #token("true","Bool") [UNIQUE_ID(e25d298d6e16a47056dc8d16e1f502118548f99812a80151ffbf46b6fdb2dff5) contentStartColumn(8) contentStartLine(156) org.kframework.attributes.Location(Location(156,8,156,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varA_532 :: []),(varB_533 :: []),((Int _ as var_23_534) :: [])) :: [])) when (((((isTrue (evalisName((varB_533 :: [])) config (-1)))) && ((isTrue (evalisName((varA_532 :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_23_534 :: []),((Lazy.force int2) :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varB_533 :: []),(varA_532 :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisThreadCellBag (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadCellBag and sort = 
SortBool in match c with 
(*{| rule ``isThreadCellBag(#KToken(#token("ThreadCellBag","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCellBag, var__535) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadCellBag(#KToken(#token("ThreadCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCell, var__536) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadCellBag(`<thread>`(K0))=>#token("true","Bool")`` requires isKCell(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'thread'_GT_',(varK0_537 :: [])) :: [])) when (isTrue (evalisKCell((varK0_537 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadCellBag(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_538)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL and sort = 
SortK in match c with 
| _ -> try KEQUAL.hook_ite c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `#if_#then_#else_#fi_K-EQUAL`(C,_10,B2)=>B2`` requires `_andBool_`(isBool(C),`notBool_`(C)) ensures #token("true","Bool") [UNIQUE_ID(d46b5ae094d17de19ef9725da497c32e21813c6e4b5a0d6a2c4b03bd55bb312c) contentStartColumn(8) contentStartLine(770) org.kframework.attributes.Location(Location(770,8,770,64)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Bool _ as varC_539) :: []),(var_10_540),(varB2_541)) when ((true) && ((not ((isTrue [varC_539]))))) && (true) -> (varB2_541)
(*{| rule `` `#if_#then_#else_#fi_K-EQUAL`(C,B1,_11)=>B1`` requires `_andBool_`(isBool(C),C) ensures #token("true","Bool") [UNIQUE_ID(0883a4d4051090478d6b8a7ac8d4e0e15e7708308fa24e63137b9ac7e87383aa) contentStartColumn(8) contentStartLine(769) org.kframework.attributes.Location(Location(769,8,769,56)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Bool _ as varC_542) :: []),(varB1_543),(var_11_544)) when ((true) && ((isTrue [varC_542]))) && (true) -> (varB1_543)
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalfindString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfindString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_find c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalsubstrString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblsubstrString and sort = 
SortString in match c with 
| _ -> try STRING.hook_substr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evallengthString (c: k) (config: k) (guard: int) : k = let lbl = 
LbllengthString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_length c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_Eqls'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_Eqls'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_ge c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalminInt'LPar'_'Comm'_'RPar'_INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblminInt'LPar'_'Comm'_'RPar'_INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_min c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `minInt(_,_)_INT`(I1,I2)=>I2`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_>=Int__INT`(I1,I2)) ensures #token("true","Bool") [UNIQUE_ID(f93c59dd0bdb46ab467898db4ad231d94d30e5b88427054becac14f3969eff8e) contentStartColumn(8) contentStartLine(397) org.kframework.attributes.Location(Location(397,8,397,57)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_545) :: []),((Int _ as varI2_546) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT((varI1_545 :: []),(varI2_546 :: [])) config (-1))))) && (true) -> (varI2_546 :: [])
(*{| rule `` `minInt(_,_)_INT`(I1,I2)=>I1`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_<=Int__INT`(I1,I2)) ensures #token("true","Bool") [UNIQUE_ID(c3daf36ef673ae6ce68430bc5170ec91b3d397f5f3e34aee375a841739bcfc9b) contentStartColumn(8) contentStartLine(396) org.kframework.attributes.Location(Location(396,8,396,57)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_547) :: []),((Int _ as varI2_548) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_LT_Eqls'Int__INT((varI1_547 :: []),(varI2_548 :: [])) config (-1))))) && (true) -> (varI1_547 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsEqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsEqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_eq c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_==String__STRING`(S1,S2)=>`_==K_`(S1,S2)`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(daddd877c886e178648c9a2a7a5b307a0f59225ac211c099829b467bb5ebf98d) contentStartColumn(8) contentStartLine(537) org.kframework.attributes.Location(Location(537,8,537,49)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_549) :: []),((String _ as varS2_550) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'K_((varS1_549 :: []),(varS2_550 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'EqlsSlshEqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=String__STRING`(S1,S2)=>`notBool_`(`_==String__STRING`(S1,S2))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2a5c8974455ca9cde473273aeca1a4fa8072aa68d104bc94daa71ee7bf52c8a4) contentStartColumn(8) contentStartLine(536) org.kframework.attributes.Location(Location(536,8,536,65)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_551) :: []),((String _ as varS2_552) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'String__STRING((varS1_551 :: []),(varS2_552 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalfindChar (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfindChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_findChar c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``findChar(S1,S2,I)=>`#if_#then_#else_#fi_K-EQUAL`(`_==Int_`(findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),#token("-1","Int")),findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I),`#if_#then_#else_#fi_K-EQUAL`(`_==Int_`(findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I),#token("-1","Int")),findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),`minInt(_,_)_INT`(findString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),findChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I))))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isString(S2)),isString(S1)),`_=/=String__STRING`(S2,#token("\"\"","String"))) ensures #token("true","Bool") [UNIQUE_ID(5a89a8f3b78438530e84da3913f33203b224f3c348d32f09785edd80c9cfe137) contentStartColumn(8) contentStartLine(553) org.kframework.attributes.Location(Location(553,8,553,431)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varS1_553) :: []),((String _ as varS2_554) :: []),((Int _ as varI_555) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'String__STRING((varS2_554 :: []),((String "") :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsEqls'Int_(((evalfindString((varS1_553 :: []),((evalsubstrString((varS2_554 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_555 :: [])) config (-1))),((Lazy.force int'Hyph'1) :: [])) config (-1)))) then (((evalfindChar((varS1_553 :: []),((evalsubstrString((varS2_554 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_554 :: [])) config (-1)))) config (-1))),(varI_555 :: [])) config (-1)))) else (((if ((isTrue (eval_'EqlsEqls'Int_(((evalfindChar((varS1_553 :: []),((evalsubstrString((varS2_554 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_554 :: [])) config (-1)))) config (-1))),(varI_555 :: [])) config (-1))),((Lazy.force int'Hyph'1) :: [])) config (-1)))) then (((evalfindString((varS1_553 :: []),((evalsubstrString((varS2_554 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_555 :: [])) config (-1)))) else (((evalminInt'LPar'_'Comm'_'RPar'_INT(((evalfindString((varS1_553 :: []),((evalsubstrString((varS2_554 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_555 :: [])) config (-1))),((evalfindChar((varS1_553 :: []),((evalsubstrString((varS2_554 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_554 :: [])) config (-1)))) config (-1))),(varI_555 :: [])) config (-1)))) config (-1)))))))))
(*{| rule ``findChar(_14,#token("\"\"","String"),_15)=>#token("-1","Int")`` requires `_andBool_`(isInt(_15),isString(_14)) ensures #token("true","Bool") [UNIQUE_ID(3c92cdc7bbe8b210d199a92b38a24538ca780f801572b653c3cb72d6d89a2adf) contentStartColumn(8) contentStartLine(554) org.kframework.attributes.Location(Location(554,8,554,32)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as var_14_556) :: []),((String "") :: []),((Int _ as var_15_557) :: [])) when ((true) && (true)) && (true) -> ((Lazy.force int'Hyph'1) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_'_LT_Eqls'Set__SET (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Set__SET and sort = 
SortBool in match c with 
| _ -> try SET.hook_inclusion c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_Set_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_Set_ and sort = 
SortSet in match c with 
| _ -> try SET.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalSetItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblSetItem and sort = 
SortSet in match c with 
| _ -> try SET.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortName in match c with 
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(_64,N))=>N`` requires `_andBool_`(isName(_64),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(54d1966ab514638f69499ee0e5287f5d7af7234948bae4fae44d7ea598442684) contentStartColumn(8) contentStartLine(230) org.kframework.attributes.Location(Location(230,8,230,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(var_64_558 :: []),(varN_559 :: [])) :: [])) when (((isTrue (evalisName((var_64_558 :: [])) config (-1)))) && ((isTrue (evalisName((varN_559 :: [])) config (-1))))) && (true) -> (varN_559 :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_!__GRHO-SYNTAX`(N,tuple(_67)))=>N`` requires `_andBool_`(isProcList(_67),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(a38a3503611abc43d89225d89288923a1143413f5a88deef8b99a40ac28dc394) contentStartColumn(8) contentStartLine(90) org.kframework.attributes.Location(Location(90,8,90,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Bang'__GRHO'Hyph'SYNTAX,(varN_560 :: []),(KApply1(Lbltuple,(var_67_561 :: [])) :: [])) :: [])) when (((isTrue (evalisProcList((var_67_561 :: [])) config (-1)))) && ((isTrue (evalisName((varN_560 :: [])) config (-1))))) && (true) -> (varN_560 :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(B),`#chan(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isPbind(B),isPbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(a2ae9dc1925d1d9d32a3540eda6f648ff708bffbe6506beee88d2f57c3425f84) contentStartColumn(8) contentStartLine(241) org.kframework.attributes.Location(Location(241,8,241,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_562 :: []),(varC_563 :: [])) :: [])) when (((isTrue (evalisPbind((varB_562 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varC_563 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_562 :: [])) config (-1))),((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_563 :: [])) config (-1)))) :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(_38,N))=>N`` requires `_andBool_`(isName(_38),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(c23c191547419ae382b0e12e3ed4335e4d4cd5e4b03e298db27f5cf478bdb1e3) contentStartColumn(8) contentStartLine(224) org.kframework.attributes.Location(Location(224,8,224,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(var_38_564 :: []),(varN_565 :: [])) :: [])) when (((isTrue (evalisName((var_38_564 :: [])) config (-1)))) && ((isTrue (evalisName((varN_565 :: [])) config (-1))))) && (true) -> (varN_565 :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(B),`#chan(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isRbind(C),isRbind(B)) ensures #token("true","Bool") [UNIQUE_ID(3ccb844d6456cee0c68ec5484fc9d44d8369984b05754cc04896b65d0e9d0955) contentStartColumn(8) contentStartLine(237) org.kframework.attributes.Location(Location(237,8,237,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_566 :: []),(varC_567 :: [])) :: [])) when (((isTrue (evalisRbind((varC_567 :: [])) config (-1)))) && ((isTrue (evalisRbind((varB_566 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_566 :: [])) config (-1))),((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_567 :: [])) config (-1)))) :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(B),`#chan(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isLbind(B),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(3ddb204610dccb78f597099d36789758ecfc8c2d6f0ed080c723491e8db1ab68) contentStartColumn(8) contentStartLine(234) org.kframework.attributes.Location(Location(234,8,234,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_568 :: []),(varC_569 :: [])) :: [])) when (((isTrue (evalisLbind((varB_568 :: [])) config (-1)))) && ((isTrue (evalisLbind((varC_569 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_568 :: [])) config (-1))),((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_569 :: [])) config (-1)))) :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(_34,N))=>N`` requires `_andBool_`(isNames(_34),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(5b6580353400c0dad04aac970f4a2ef7c24981b08461d5fd6e987ff3aa330e2c) contentStartColumn(8) contentStartLine(231) org.kframework.attributes.Location(Location(231,8,231,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(var_34_570 :: []),(varN_571 :: [])) :: [])) when (((isTrue (evalisNames((var_34_570 :: [])) config (-1)))) && ((isTrue (evalisName((varN_571 :: [])) config (-1))))) && (true) -> (varN_571 :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(_31,N))=>N`` requires `_andBool_`(isName(_31),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(d454f26bc46b4941d010f6018a75ee65f41f57d7b7c6de43abf4d1681ca7f97e) contentStartColumn(8) contentStartLine(227) org.kframework.attributes.Location(Location(227,8,227,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(var_31_572 :: []),(varN_573 :: [])) :: [])) when (((isTrue (evalisName((var_31_572 :: [])) config (-1)))) && ((isTrue (evalisName((varN_573 :: [])) config (-1))))) && (true) -> (varN_573 :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,_19))=>`#chan(_)_AUXFUN-SYNTAX`(B)`` requires `_andBool_`(isProc(_19),isBind(B)) ensures #token("true","Bool") [UNIQUE_ID(1440d70b7b70c316e5178a065b68987cc8f7edcb5c1051f5a6e020a22ca8b70e) contentStartColumn(8) contentStartLine(108) org.kframework.attributes.Location(Location(108,8,108,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varB_574 :: []),(var_19_575 :: [])) :: [])) when (((isTrue (evalisProc((var_19_575 :: [])) config (-1)))) && ((isTrue (evalisBind((varB_574 :: [])) config (-1))))) && (true) -> ((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_574 :: [])) config (-1)))
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(_40,N))=>N`` requires `_andBool_`(isName(N),isNames(_40)) ensures #token("true","Bool") [UNIQUE_ID(56b3f1674b1675b273ecb14c92965b73fbba4a16eac0385d885e4b077e0cdca8) contentStartColumn(8) contentStartLine(228) org.kframework.attributes.Location(Location(228,8,228,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(var_40_576 :: []),(varN_577 :: [])) :: [])) when (((isTrue (evalisName((varN_577 :: [])) config (-1)))) && ((isTrue (evalisNames((var_40_576 :: [])) config (-1))))) && (true) -> (varN_577 :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(B),`#chan(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isRbind(B),isRbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(957c6432ddc6eefac37692fe8aa8c6feee601dd3c9d39672dbc6b7ee891ff1b3) contentStartColumn(8) contentStartLine(238) org.kframework.attributes.Location(Location(238,8,238,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_578 :: []),(varC_579 :: [])) :: [])) when (((isTrue (evalisRbind((varB_578 :: [])) config (-1)))) && ((isTrue (evalisRbinds((varC_579 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_578 :: [])) config (-1))),((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_579 :: [])) config (-1)))) :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(_20,N))=>N`` requires `_andBool_`(isNames(_20),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(09422a458d5ec34d0cc2efe08e66160adcf3ce857cee47a13b329368ccf4fdb2) contentStartColumn(8) contentStartLine(225) org.kframework.attributes.Location(Location(225,8,225,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(var_20_580 :: []),(varN_581 :: [])) :: [])) when (((isTrue (evalisNames((var_20_580 :: [])) config (-1)))) && ((isTrue (evalisName((varN_581 :: [])) config (-1))))) && (true) -> (varN_581 :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,_22))=>`#chan(_)_AUXFUN-SYNTAX`(B)`` requires `_andBool_`(isProc(_22),isBinds(B)) ensures #token("true","Bool") [UNIQUE_ID(1cc571fba54183a0f88128e15e0fed04bec921d42d161c95433805ed352b0fbd) contentStartColumn(8) contentStartLine(109) org.kframework.attributes.Location(Location(109,8,109,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varB_582 :: []),(var_22_583 :: [])) :: [])) when (((isTrue (evalisProc((var_22_583 :: [])) config (-1)))) && ((isTrue (evalisBinds((varB_582 :: [])) config (-1))))) && (true) -> ((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_582 :: [])) config (-1)))
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(B),`#chan(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isLbinds(C),isLbind(B)) ensures #token("true","Bool") [UNIQUE_ID(a18c193080476f73cc881b640b86cf8dc563fa21f84d87c35035e05104cc5b4a) contentStartColumn(8) contentStartLine(235) org.kframework.attributes.Location(Location(235,8,235,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_584 :: []),(varC_585 :: [])) :: [])) when (((isTrue (evalisLbinds((varC_585 :: [])) config (-1)))) && ((isTrue (evalisLbind((varB_584 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_584 :: [])) config (-1))),((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_585 :: [])) config (-1)))) :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_!!__GRHO-SYNTAX`(N,tuple(_80)))=>N`` requires `_andBool_`(isProcList(_80),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(0ef6bda9a25ba7029ea9ba09057205023715b43c28c9ed037a4ad67e4fb4e477) contentStartColumn(8) contentStartLine(91) org.kframework.attributes.Location(Location(91,8,91,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'BangBang'__GRHO'Hyph'SYNTAX,(varN_586 :: []),(KApply1(Lbltuple,(var_80_587 :: [])) :: [])) :: [])) when (((isTrue (evalisProcList((var_80_587 :: [])) config (-1)))) && ((isTrue (evalisName((varN_586 :: [])) config (-1))))) && (true) -> (varN_586 :: [])
(*{| rule `` `#chan(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(B),`#chan(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isPbind(C),isPbind(B)) ensures #token("true","Bool") [UNIQUE_ID(abbca6a0f75c6dc637c37ce83f8c9c2747cbd6b1d9ef058da54ffefe1ac9e233) contentStartColumn(8) contentStartLine(240) org.kframework.attributes.Location(Location(240,8,240,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_588 :: []),(varC_589 :: [])) :: [])) when (((isTrue (evalisPbind((varC_589 :: [])) config (-1)))) && ((isTrue (evalisPbind((varB_588 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_588 :: [])) config (-1))),((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_589 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortName in match c with 
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bvar(_)_AUXFUN-SYNTAX`(B),`#bvar(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isLbinds(C),isLbind(B)) ensures #token("true","Bool") [UNIQUE_ID(9ec7d5e24ff3670d9651884d31787076597d50b4c94cf15a474b3fce16d8ee99) contentStartColumn(8) contentStartLine(266) org.kframework.attributes.Location(Location(266,8,266,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_590 :: []),(varC_591 :: [])) :: [])) when (((isTrue (evalisLbinds((varC_591 :: [])) config (-1)))) && ((isTrue (evalisLbind((varB_590 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_590 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_591 :: [])) config (-1)))) :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(N,_63))=>N`` requires `_andBool_`(isName(_63),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(9f5ae4573f17a389daced2e112a0945da59409d6a86c7e68a5a56d280f110c24) contentStartColumn(8) contentStartLine(262) org.kframework.attributes.Location(Location(262,8,262,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varN_592 :: []),(var_63_593 :: [])) :: [])) when (((isTrue (evalisName((var_63_593 :: [])) config (-1)))) && ((isTrue (evalisName((varN_592 :: [])) config (-1))))) && (true) -> (varN_592 :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bvar(_)_AUXFUN-SYNTAX`(B),`#bvar(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isRbind(C),isRbind(B)) ensures #token("true","Bool") [UNIQUE_ID(cbee4fe69239fdcca37affd4d5d6a7dfa251ae2e574c7b071db620fd94f2cdf1) contentStartColumn(8) contentStartLine(268) org.kframework.attributes.Location(Location(268,8,268,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_594 :: []),(varC_595 :: [])) :: [])) when (((isTrue (evalisRbind((varC_595 :: [])) config (-1)))) && ((isTrue (evalisRbind((varB_594 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_594 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_595 :: [])) config (-1)))) :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bvar(_)_AUXFUN-SYNTAX`(B),`#bvar(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isLbind(B),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(4e185aaeb9eccd638d9cd8f24681ca3cfae3031ad2c2fda67b0a5dde972eb95a) contentStartColumn(8) contentStartLine(265) org.kframework.attributes.Location(Location(265,8,265,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_596 :: []),(varC_597 :: [])) :: [])) when (((isTrue (evalisLbind((varB_596 :: [])) config (-1)))) && ((isTrue (evalisLbind((varC_597 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_596 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_597 :: [])) config (-1)))) :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(N,_24))=>N`` requires `_andBool_`(isName(_24),isNames(N)) ensures #token("true","Bool") [UNIQUE_ID(c01d0cb4a49e326d6ced289ba7876387b070fbfd14e5039700c52bc26a3c9891) contentStartColumn(8) contentStartLine(261) org.kframework.attributes.Location(Location(261,8,261,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varN_598 :: []),(var_24_599 :: [])) :: [])) when (((isTrue (evalisName((var_24_599 :: [])) config (-1)))) && ((isTrue (evalisNames((varN_598 :: [])) config (-1))))) && (true) -> (varN_598 :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(N,_49))=>N`` requires `_andBool_`(isName(_49),isNames(N)) ensures #token("true","Bool") [UNIQUE_ID(c151e225dc82406ed16217447ee6df04249ced606f27e6a01f7b7dc91bd10dae) contentStartColumn(8) contentStartLine(259) org.kframework.attributes.Location(Location(259,8,259,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varN_600 :: []),(var_49_601 :: [])) :: [])) when (((isTrue (evalisName((var_49_601 :: [])) config (-1)))) && ((isTrue (evalisNames((varN_600 :: [])) config (-1))))) && (true) -> (varN_600 :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,_82))=>`#bvar(_)_AUXFUN-SYNTAX`(B)`` requires `_andBool_`(isProc(_82),isBinds(B)) ensures #token("true","Bool") [UNIQUE_ID(a329883ff6c2be918997e27dc3c44f1a0833673670d379cd10290d11457def89) contentStartColumn(8) contentStartLine(106) org.kframework.attributes.Location(Location(106,8,106,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varB_602 :: []),(var_82_603 :: [])) :: [])) when (((isTrue (evalisProc((var_82_603 :: [])) config (-1)))) && ((isTrue (evalisBinds((varB_602 :: [])) config (-1))))) && (true) -> ((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_602 :: [])) config (-1)))
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(N,_87))=>N`` requires `_andBool_`(isName(_87),isNames(N)) ensures #token("true","Bool") [UNIQUE_ID(d176276acaa21624858914cad6e52921d1833423b186cd4ba9c4fbffa7b20bca) contentStartColumn(8) contentStartLine(263) org.kframework.attributes.Location(Location(263,8,263,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varN_604 :: []),(var_87_605 :: [])) :: [])) when (((isTrue (evalisName((var_87_605 :: [])) config (-1)))) && ((isTrue (evalisNames((varN_604 :: [])) config (-1))))) && (true) -> (varN_604 :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bvar(_)_AUXFUN-SYNTAX`(B),`#bvar(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isPbind(C),isPbind(B)) ensures #token("true","Bool") [UNIQUE_ID(4d56e6ef42674c26c00d31438dc642ed34ae3a26fc98d66019c96dfe9dc0e20d) contentStartColumn(8) contentStartLine(271) org.kframework.attributes.Location(Location(271,8,271,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_606 :: []),(varC_607 :: [])) :: [])) when (((isTrue (evalisPbind((varC_607 :: [])) config (-1)))) && ((isTrue (evalisPbind((varB_606 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_606 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_607 :: [])) config (-1)))) :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(N,_75))=>N`` requires `_andBool_`(isName(_75),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(e7a23968e5f75c12113bfc989fe83bd4a950d8e9b3c2b8b6ca1cf0c6da429df1) contentStartColumn(8) contentStartLine(258) org.kframework.attributes.Location(Location(258,8,258,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varN_608 :: []),(var_75_609 :: [])) :: [])) when (((isTrue (evalisName((var_75_609 :: [])) config (-1)))) && ((isTrue (evalisName((varN_608 :: [])) config (-1))))) && (true) -> (varN_608 :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bvar(_)_AUXFUN-SYNTAX`(B),`#bvar(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isPbind(B),isPbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(af93c164bfd87391a9b5f5c4d5dc2dffef6442bbf3c2434edadd2362c28aba8d) contentStartColumn(8) contentStartLine(272) org.kframework.attributes.Location(Location(272,8,272,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_610 :: []),(varC_611 :: [])) :: [])) when (((isTrue (evalisPbind((varB_610 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varC_611 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_610 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_611 :: [])) config (-1)))) :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(N,_23))=>N`` requires `_andBool_`(isName(_23),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(a35a4fe9a3949d4734f85b5472f81160ca6cb88cb42a3826b1d4675b7cb30037) contentStartColumn(8) contentStartLine(260) org.kframework.attributes.Location(Location(260,8,260,40)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varN_612 :: []),(var_23_613 :: [])) :: [])) when (((isTrue (evalisName((var_23_613 :: [])) config (-1)))) && ((isTrue (evalisName((varN_612 :: [])) config (-1))))) && (true) -> (varN_612 :: [])
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,_72))=>`#bvar(_)_AUXFUN-SYNTAX`(B)`` requires `_andBool_`(isProc(_72),isBind(B)) ensures #token("true","Bool") [UNIQUE_ID(1a45a99013f738e6d2ef6fd2aad62c37c31e8a9fa9e53f8a53d4b7ccf8cd9c65) contentStartColumn(8) contentStartLine(105) org.kframework.attributes.Location(Location(105,8,105,57)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varB_614 :: []),(var_72_615 :: [])) :: [])) when (((isTrue (evalisProc((var_72_615 :: [])) config (-1)))) && ((isTrue (evalisBind((varB_614 :: [])) config (-1))))) && (true) -> ((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_614 :: [])) config (-1)))
(*{| rule `` `#bvar(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bvar(_)_AUXFUN-SYNTAX`(B),`#bvar(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isRbind(B),isRbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(878609af9f4e55148b981af2a9a13ad40eb8b6cc455ca1f0958e4a511c7e5c96) contentStartColumn(8) contentStartLine(269) org.kframework.attributes.Location(Location(269,8,269,59)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_616 :: []),(varC_617 :: [])) :: [])) when (((isTrue (evalisRbind((varB_616 :: [])) config (-1)))) && ((isTrue (evalisRbinds((varC_617 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_616 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_617 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalSet'Coln'difference (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'difference and sort = 
SortSet in match c with 
| _ -> try SET.hook_difference c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalSet'Coln'in (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'in and sort = 
SortBool in match c with 
| _ -> try SET.hook_in c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortSet in match c with 
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(A,B))=>`SetItem`(`(_;_)_GRHO-SYNTAX`(B,`#length(_)_AUXFUN-SYNTAX`(A)))`` requires `_andBool_`(isName(B),isNames(A)) ensures #token("true","Bool") [UNIQUE_ID(ed2d5eac9604f41e9c1f6b3a14c249d793b0c7f0c27a1e288db8b0988cce8f28) contentStartColumn(8) contentStartLine(284) org.kframework.attributes.Location(Location(284,8,284,69)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varA_618 :: []),(varB_619 :: [])) :: [])) when (((isTrue (evalisName((varB_619 :: [])) config (-1)))) && ((isTrue (evalisNames((varA_618 :: [])) config (-1))))) && (true) -> ((evalSetItem((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varB_619 :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_618 :: [])) config (-1)))) :: [])) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(A,B))=>`SetItem`(`(_;_)_GRHO-SYNTAX`(B,`#length(_)_AUXFUN-SYNTAX`(A)))`` requires `_andBool_`(isName(B),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(b93916f48c8326564d34194565225719598a33f844a7f7248ec6ddd568ba5d28) contentStartColumn(8) contentStartLine(278) org.kframework.attributes.Location(Location(278,8,278,69)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varA_620 :: []),(varB_621 :: [])) :: [])) when (((isTrue (evalisName((varB_621 :: [])) config (-1)))) && ((isTrue (evalisName((varA_620 :: [])) config (-1))))) && (true) -> ((evalSetItem((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varB_621 :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_620 :: [])) config (-1)))) :: [])) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`_Set_`(`#chanlen(_)_AUXFUN-SYNTAX`(A),`#chanlen(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isLbind(B),isLbind(A)) ensures #token("true","Bool") [UNIQUE_ID(30a85e75e74090f9af3e971191f7923260106852dd4dda24fcc1925c0b1f8235) contentStartColumn(8) contentStartLine(280) org.kframework.attributes.Location(Location(280,8,280,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_622 :: []),(varB_623 :: [])) :: [])) when (((isTrue (evalisLbind((varB_623 :: [])) config (-1)))) && ((isTrue (evalisLbind((varA_622 :: [])) config (-1))))) && (true) -> ((eval_Set_(((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_622 :: [])) config (-1))),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_623 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`_Set_`(`#chanlen(_)_AUXFUN-SYNTAX`(A),`#chanlen(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isPbind(A),isPbinds(B)) ensures #token("true","Bool") [UNIQUE_ID(0c3fd30fcde6e8355c15a11da44792e6fbb5c9c8984dd578f2b852f1ccd4f4d5) contentStartColumn(8) contentStartLine(291) org.kframework.attributes.Location(Location(291,8,291,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_624 :: []),(varB_625 :: [])) :: [])) when (((isTrue (evalisPbind((varA_624 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varB_625 :: [])) config (-1))))) && (true) -> ((eval_Set_(((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_624 :: [])) config (-1))),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_625 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(A,B))=>`SetItem`(`(_;_)_GRHO-SYNTAX`(B,`#length(_)_AUXFUN-SYNTAX`(A)))`` requires `_andBool_`(isName(B),isNames(A)) ensures #token("true","Bool") [UNIQUE_ID(2b70871196e288d5aaed9786f12c1bfdde296fd6b9a2e0bb25a9f2346a8c30c9) contentStartColumn(8) contentStartLine(289) org.kframework.attributes.Location(Location(289,8,289,69)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varA_626 :: []),(varB_627 :: [])) :: [])) when (((isTrue (evalisName((varB_627 :: [])) config (-1)))) && ((isTrue (evalisNames((varA_626 :: [])) config (-1))))) && (true) -> ((evalSetItem((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varB_627 :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_626 :: [])) config (-1)))) :: [])) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(A,B))=>`SetItem`(`(_;_)_GRHO-SYNTAX`(B,`#length(_)_AUXFUN-SYNTAX`(A)))`` requires `_andBool_`(isName(B),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(ec7533c6c9657d3265310a39d78b2cad83246c6fad02efd83beee7606627a394) contentStartColumn(8) contentStartLine(288) org.kframework.attributes.Location(Location(288,8,288,69)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varA_628 :: []),(varB_629 :: [])) :: [])) when (((isTrue (evalisName((varB_629 :: [])) config (-1)))) && ((isTrue (evalisName((varA_628 :: [])) config (-1))))) && (true) -> ((evalSetItem((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varB_629 :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_628 :: [])) config (-1)))) :: [])) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`_Set_`(`#chanlen(_)_AUXFUN-SYNTAX`(A),`#chanlen(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isRbind(B),isRbind(A)) ensures #token("true","Bool") [UNIQUE_ID(50a7c374c6ea72a4569c65c50b99fbe55d14e7dfbbdbdfeb142a5afc670c3ca6) contentStartColumn(8) contentStartLine(285) org.kframework.attributes.Location(Location(285,8,285,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_630 :: []),(varB_631 :: [])) :: [])) when (((isTrue (evalisRbind((varB_631 :: [])) config (-1)))) && ((isTrue (evalisRbind((varA_630 :: [])) config (-1))))) && (true) -> ((eval_Set_(((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_630 :: [])) config (-1))),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_631 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`_Set_`(`#chanlen(_)_AUXFUN-SYNTAX`(A),`#chanlen(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isRbinds(B),isRbind(A)) ensures #token("true","Bool") [UNIQUE_ID(6fb49673e93571785606b10c989aa48101cb5e40784364eaaa5d3e0359a66a3b) contentStartColumn(8) contentStartLine(286) org.kframework.attributes.Location(Location(286,8,286,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_632 :: []),(varB_633 :: [])) :: [])) when (((isTrue (evalisRbinds((varB_633 :: [])) config (-1)))) && ((isTrue (evalisRbind((varA_632 :: [])) config (-1))))) && (true) -> ((eval_Set_(((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_632 :: [])) config (-1))),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_633 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`_Set_`(`#chanlen(_)_AUXFUN-SYNTAX`(A),`#chanlen(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isPbind(A),isPbind(B)) ensures #token("true","Bool") [UNIQUE_ID(8d426eef4bbd6a201634952e25258ca907655023d8a62150690b71cc6bf11bcd) contentStartColumn(8) contentStartLine(290) org.kframework.attributes.Location(Location(290,8,290,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_634 :: []),(varB_635 :: [])) :: [])) when (((isTrue (evalisPbind((varA_634 :: [])) config (-1)))) && ((isTrue (evalisPbind((varB_635 :: [])) config (-1))))) && (true) -> ((eval_Set_(((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_634 :: [])) config (-1))),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_635 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`_Set_`(`#chanlen(_)_AUXFUN-SYNTAX`(A),`#chanlen(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isLbind(A),isLbinds(B)) ensures #token("true","Bool") [UNIQUE_ID(4c8dc3b27a5dd14e6d39048c6d187041bbfc544ac95c218ff5eeebfe45db52bd) contentStartColumn(8) contentStartLine(281) org.kframework.attributes.Location(Location(281,8,281,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_636 :: []),(varB_637 :: [])) :: [])) when (((isTrue (evalisLbind((varA_636 :: [])) config (-1)))) && ((isTrue (evalisLbinds((varB_637 :: [])) config (-1))))) && (true) -> ((eval_Set_(((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_636 :: [])) config (-1))),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_637 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(A,B))=>`SetItem`(`(_;_)_GRHO-SYNTAX`(B,`#length(_)_AUXFUN-SYNTAX`(A)))`` requires `_andBool_`(isName(B),isNames(A)) ensures #token("true","Bool") [UNIQUE_ID(9f4de37f0e2adc50377c7ccec3a0467dc01286a53e78504eb027757d3eef7bcc) contentStartColumn(8) contentStartLine(279) org.kframework.attributes.Location(Location(279,8,279,69)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varA_638 :: []),(varB_639 :: [])) :: [])) when (((isTrue (evalisName((varB_639 :: [])) config (-1)))) && ((isTrue (evalisNames((varA_638 :: [])) config (-1))))) && (true) -> ((evalSetItem((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varB_639 :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_638 :: [])) config (-1)))) :: [])) config (-1)))
(*{| rule `` `#chanlen(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(A,B))=>`SetItem`(`(_;_)_GRHO-SYNTAX`(B,`#length(_)_AUXFUN-SYNTAX`(A)))`` requires `_andBool_`(isName(B),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(fa8bc9bd054bd42dcf0f482164e14067461326a3e43ca072102d6884d59a587b) contentStartColumn(8) contentStartLine(283) org.kframework.attributes.Location(Location(283,8,283,69)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varA_640 :: []),(varB_641 :: [])) :: [])) when (((isTrue (evalisName((varB_641 :: [])) config (-1)))) && ((isTrue (evalisName((varA_640 :: [])) config (-1))))) && (true) -> ((evalSetItem((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varB_641 :: []),((eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_640 :: [])) config (-1)))) :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_orBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_orBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_or c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_orBool__BOOL`(#token("false","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(ababa6e5e3735076933657815e24f99518fe532715ea97eae22ead8e30097b53) contentStartColumn(8) contentStartLine(319) org.kframework.attributes.Location(Location(319,8,319,32)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varB_642) :: [])) when true && (true) -> (varB_642 :: [])
(*{| rule `` `_orBool__BOOL`(B,#token("false","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(630487d34ae5fc313a9b8cae2ad45b7b80671058bca3c97a7864774c5a431711) contentStartColumn(8) contentStartLine(320) org.kframework.attributes.Location(Location(320,8,320,32)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_643) :: []),((Bool false) :: [])) when true && (true) -> (varB_643 :: [])
(*{| rule `` `_orBool__BOOL`(#token("true","Bool"),_8)=>#token("true","Bool")`` requires isBool(_8) ensures #token("true","Bool") [UNIQUE_ID(166d732e9fd6609a71feb6d62f8a420d291ac81be018b646ee1177935b008f01) contentStartColumn(8) contentStartLine(317) org.kframework.attributes.Location(Location(317,8,317,34)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as var_8_644) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orBool__BOOL`(_6,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_6) ensures #token("true","Bool") [UNIQUE_ID(497077a299480dbc06eccb33cd98338014bd125c4c601cb88a765dbcb334b14b) contentStartColumn(8) contentStartLine(318) org.kframework.attributes.Location(Location(318,8,318,34)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_6_645) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Stop'Set (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'Set and sort = 
SortSet in match c with 
| _ -> try SET.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'Set : k Lazy.t = lazy (eval'Stop'Set () interned_bottom (-1))
let rec eval_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortBool in match c with 
(*{| rule `` `_#ine(_)_AUXFUN-SYNTAX`(A,B)=>`_<=Set__SET`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isBinds(A),isBinds(B)) ensures #token("true","Bool") [UNIQUE_ID(378d9f3803bbedb2acadf8098d9391ff8030252f4574c22ecefe27b7335231b3) contentStartColumn(8) contentStartLine(181) org.kframework.attributes.Location(Location(181,8,181,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_646 :: []),(varB_647 :: [])) when (((isTrue (evalisBinds((varA_646 :: [])) config (-1)))) && ((isTrue (evalisBinds((varB_647 :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_646 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_647 :: [])) config (-1)))) config (-1)))
(*{| rule `` `_#ine(_)_AUXFUN-SYNTAX`(A,B)=>`_<=Set__SET`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isBind(A),isBind(B)) ensures #token("true","Bool") [UNIQUE_ID(dd5623c40f9cdce4d8e73944a81a0fafe9c7d4a1fb49556e2595675224b22e93) contentStartColumn(8) contentStartLine(179) org.kframework.attributes.Location(Location(179,8,179,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_648 :: []),(varB_649 :: [])) when (((isTrue (evalisBind((varA_648 :: [])) config (-1)))) && ((isTrue (evalisBind((varB_649 :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_648 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_649 :: [])) config (-1)))) config (-1)))
(*{| rule `` `_#ine(_)_AUXFUN-SYNTAX`(A,B)=>`_<=Set__SET`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isBind(A),isBinds(B)) ensures #token("true","Bool") [UNIQUE_ID(35d1a42cb02aecfde794a95db066bd4c53471f2739c1a6362a816c823a184425) contentStartColumn(8) contentStartLine(180) org.kframework.attributes.Location(Location(180,8,180,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_650 :: []),(varB_651 :: [])) when (((isTrue (evalisBind((varA_650 :: [])) config (-1)))) && ((isTrue (evalisBinds((varB_651 :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_650 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_651 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
and eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortSet in match c with 
(*{| rule `` `#bindocc(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_=/=Int__INT`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B),#token("0","Int")),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B)))),`Set:difference`(`#bindocc(_)_AUXFUN-SYNTAX`(B),`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B))))),`_Set_`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isPbind(A),isPbinds(B)) ensures #token("true","Bool") [UNIQUE_ID(6293b04b981fa45bace9ef83acefe70d283567a88902a9ce8b75b7db7c7ff2b0) contentStartColumn(8) contentStartLine(375) org.kframework.attributes.Location(Location(375,8,379,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_652 :: []),(varB_653 :: [])) :: [])) when (((isTrue (evalisPbind((varA_652 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varB_653 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsSlshEqls'Int__INT(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1)))) :: []),(varB_653 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1))),((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1)))) :: []),(varB_653 :: [])) config (-1)))) config (-1)))) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_653 :: [])) config (-1))),((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1)))) :: []),(varB_653 :: [])) config (-1)))) :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_652 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_653 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocc(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_<=Set__SET`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),#token("2","Int"))),`Set:difference`(`#bindocc(_)_AUXFUN-SYNTAX`(B),`#bindocc(_)_AUXFUN-SYNTAX`(A))),`_Set_`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isRbind(B),isRbind(A)) ensures #token("true","Bool") [UNIQUE_ID(be2b82cef3a12dfd87c537192f67668b1f6744c82e57979c0100f4cd26ffc5a0) contentStartColumn(8) contentStartLine(358) org.kframework.attributes.Location(Location(358,8,362,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_654 :: []),(varB_655 :: [])) :: [])) when (((isTrue (evalisRbind((varB_655 :: [])) config (-1)))) && ((isTrue (evalisRbind((varA_654 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_654 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_655 :: [])) config (-1)))) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_654 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_654 :: [])) config (-1))),((Lazy.force int2) :: [])) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_655 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_654 :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_654 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_655 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocc(_)_AUXFUN-SYNTAX`(A)=>`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),#token("1","Int")))`` requires isBind(A) ensures #token("true","Bool") [UNIQUE_ID(324237a76e93acdcce4e84ae814fae265f93d8bd3edcbf6262db18c2cf1f49ce) contentStartColumn(8) contentStartLine(343) org.kframework.attributes.Location(Location(343,8,343,66)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_656 :: [])) when (isTrue (evalisBind((varA_656 :: [])) config (-1))) && (true) -> ((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_656 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_656 :: [])) config (-1))),((Lazy.force int1) :: [])) :: [])) config (-1)))
(*{| rule `` `#bindocc(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_=/=Int__INT`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B),#token("0","Int")),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B)))),`Set:difference`(`#bindocc(_)_AUXFUN-SYNTAX`(B),`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B))))),`_Set_`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isRbinds(B),isRbind(A)) ensures #token("true","Bool") [UNIQUE_ID(0d07a430a3748d477f931fb143e972caac7b2c28f19b65b3858e9043e0371f55) contentStartColumn(8) contentStartLine(363) org.kframework.attributes.Location(Location(363,8,367,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_657 :: []),(varB_658 :: [])) :: [])) when (((isTrue (evalisRbinds((varB_658 :: [])) config (-1)))) && ((isTrue (evalisRbind((varA_657 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsSlshEqls'Int__INT(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1)))) :: []),(varB_658 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1))),((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1)))) :: []),(varB_658 :: [])) config (-1)))) config (-1)))) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_658 :: [])) config (-1))),((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1)))) :: []),(varB_658 :: [])) config (-1)))) :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_657 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_658 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocc(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_<=Set__SET`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),#token("2","Int"))),`Set:difference`(`#bindocc(_)_AUXFUN-SYNTAX`(B),`#bindocc(_)_AUXFUN-SYNTAX`(A))),`_Set_`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isLbind(B),isLbind(A)) ensures #token("true","Bool") [UNIQUE_ID(e356320c1b0556d7ee9063838f5f738d1dddd66f92a786f3291c12232e7fc47d) contentStartColumn(8) contentStartLine(346) org.kframework.attributes.Location(Location(346,8,350,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_659 :: []),(varB_660 :: [])) :: [])) when (((isTrue (evalisLbind((varB_660 :: [])) config (-1)))) && ((isTrue (evalisLbind((varA_659 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_659 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_660 :: [])) config (-1)))) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_659 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_659 :: [])) config (-1))),((Lazy.force int2) :: [])) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_660 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_659 :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_659 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_660 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocc(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_<=Set__SET`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),#token("2","Int"))),`Set:difference`(`#bindocc(_)_AUXFUN-SYNTAX`(B),`#bindocc(_)_AUXFUN-SYNTAX`(A))),`_Set_`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isPbind(A),isPbind(B)) ensures #token("true","Bool") [UNIQUE_ID(a25dc88edadecd6aa1f8083d68474d1fbb7e9e2b31d516ed06cc093be2975e19) contentStartColumn(8) contentStartLine(370) org.kframework.attributes.Location(Location(370,8,374,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_661 :: []),(varB_662 :: [])) :: [])) when (((isTrue (evalisPbind((varA_661 :: [])) config (-1)))) && ((isTrue (evalisPbind((varB_662 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_661 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_662 :: [])) config (-1)))) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_661 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_661 :: [])) config (-1))),((Lazy.force int2) :: [])) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_662 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_661 :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_661 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_662 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocc(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_=/=Int__INT`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B),#token("0","Int")),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B)))),`Set:difference`(`#bindocc(_)_AUXFUN-SYNTAX`(B),`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bnum(_)_AUXFUN-SYNTAX`(A)),B))))),`_Set_`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isLbind(A),isLbinds(B)) ensures #token("true","Bool") [UNIQUE_ID(b657c4aa975262e2787a115d6716b41d39be4276663458079f4d3ebf9fdfc758) contentStartColumn(8) contentStartLine(351) org.kframework.attributes.Location(Location(351,8,355,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_663 :: []),(varB_664 :: [])) :: [])) when (((isTrue (evalisLbind((varA_663 :: [])) config (-1)))) && ((isTrue (evalisLbinds((varB_664 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsSlshEqls'Int__INT(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1)))) :: []),(varB_664 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1))),((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1)))) :: []),(varB_664 :: [])) config (-1)))) config (-1)))) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_664 :: [])) config (-1))),((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1)))) :: []),(varB_664 :: [])) config (-1)))) :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_663 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_664 :: [])) config (-1)))) config (-1))))))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
and eval_'Hash'in'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hash'in'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortBool in match c with 
(*{| rule `` `_#in(_)_AUXFUN-SYNTAX`(A,`_,__GRHO-SYNTAX`(B,C))=>`_orBool__BOOL`(`_==String__STRING`(`toString(_)_AUXFUN-SYNTAX`(A),`toString(_)_AUXFUN-SYNTAX`(B)),`_#in(_)_AUXFUN-SYNTAX`(A,C))`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),isNames(C)) ensures #token("true","Bool") [UNIQUE_ID(994ceaa6192fa3da3ab177fcc0022d2872365b56db76b5619c4573f5a4229e35) contentStartColumn(8) contentStartLine(170) org.kframework.attributes.Location(Location(170,8,170,92)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_665 :: []),(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varB_666 :: []),(varC_667 :: [])) :: [])) when (((((isTrue (evalisName((varB_666 :: [])) config (-1)))) && ((isTrue (evalisName((varA_665 :: [])) config (-1)))))) && ((isTrue (evalisNames((varC_667 :: [])) config (-1))))) && (true) -> ([Bool ((((isTrue (eval_'EqlsEqls'String__STRING((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varA_665 :: [])) :: []),(KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varB_666 :: [])) :: [])) config (-1)))) || ((isTrue (eval_'Hash'in'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_665 :: []),(varC_667 :: [])) config (-1))))))])
(*{| rule `` `_#in(_)_AUXFUN-SYNTAX`(A,B)=>`_<=Set__SET`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isBind(A),isBind(B)) ensures #token("true","Bool") [UNIQUE_ID(6699bcf415f0024a4303c65666857f9d95c84321437c910793fc57cbc413bedc) contentStartColumn(8) contentStartLine(174) org.kframework.attributes.Location(Location(174,8,174,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_668 :: []),(varB_669 :: [])) when (((isTrue (evalisBind((varA_668 :: [])) config (-1)))) && ((isTrue (evalisBind((varB_669 :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_668 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_669 :: [])) config (-1)))) config (-1)))
(*{| rule `` `_#in(_)_AUXFUN-SYNTAX`(A,B)=>`_<=Set__SET`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isBinds(A),isBinds(B)) ensures #token("true","Bool") [UNIQUE_ID(3aa16ab51d41759d2804c20e1dc3e4776292067a5db8905a872fba866c5811c5) contentStartColumn(8) contentStartLine(176) org.kframework.attributes.Location(Location(176,8,176,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_670 :: []),(varB_671 :: [])) when (((isTrue (evalisBinds((varA_670 :: [])) config (-1)))) && ((isTrue (evalisBinds((varB_671 :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_670 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_671 :: [])) config (-1)))) config (-1)))
(*{| rule `` `_#in(_)_AUXFUN-SYNTAX`(A,`_,__GRHO-SYNTAX`(B,C))=>`_orBool__BOOL`(`_==String__STRING`(`toString(_)_AUXFUN-SYNTAX`(A),`toString(_)_AUXFUN-SYNTAX`(B)),`_==String__STRING`(`toString(_)_AUXFUN-SYNTAX`(A),`toString(_)_AUXFUN-SYNTAX`(C)))`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),isName(C)) ensures #token("true","Bool") [UNIQUE_ID(51076a6470b8ee45a5ab4ff4d38d36ca487a9da770fb64a4d045f8fa0afa62c2) contentStartColumn(8) contentStartLine(169) org.kframework.attributes.Location(Location(169,8,169,115)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_672 :: []),(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varB_673 :: []),(varC_674 :: [])) :: [])) when (((((isTrue (evalisName((varB_673 :: [])) config (-1)))) && ((isTrue (evalisName((varA_672 :: [])) config (-1)))))) && ((isTrue (evalisName((varC_674 :: [])) config (-1))))) && (true) -> ([Bool ((((isTrue (eval_'EqlsEqls'String__STRING((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varA_672 :: [])) :: []),(KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varB_673 :: [])) :: [])) config (-1)))) || ((isTrue (eval_'EqlsEqls'String__STRING((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varA_672 :: [])) :: []),(KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varC_674 :: [])) :: [])) config (-1))))))])
(*{| rule `` `_#in(_)_AUXFUN-SYNTAX`(A,B)=>`_==String__STRING`(`toString(_)_AUXFUN-SYNTAX`(A),`toString(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isName(B),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(f03f3a62ce044d09d0b08d25de7581059018b8539821c79400b10667c9740f0b) contentStartColumn(8) contentStartLine(168) org.kframework.attributes.Location(Location(168,8,168,75)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_675 :: []),(varB_676 :: [])) when (((isTrue (evalisName((varB_676 :: [])) config (-1)))) && ((isTrue (evalisName((varA_675 :: [])) config (-1))))) && (true) -> ((eval_'EqlsEqls'String__STRING((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varA_675 :: [])) :: []),(KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varB_676 :: [])) :: [])) config (-1)))
(*{| rule `` `_#in(_)_AUXFUN-SYNTAX`(A,B)=>`_<=Set__SET`(`#bindocc(_)_AUXFUN-SYNTAX`(A),`#bindocc(_)_AUXFUN-SYNTAX`(B))`` requires `_andBool_`(isBind(A),isBinds(B)) ensures #token("true","Bool") [UNIQUE_ID(5b85ab0e018b1745521fa19b684d199d3f0d413e15c3096a93a008537ca2b7c2) contentStartColumn(8) contentStartLine(175) org.kframework.attributes.Location(Location(175,8,175,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_677 :: []),(varB_678 :: [])) when (((isTrue (evalisBind((varA_677 :: [])) config (-1)))) && ((isTrue (evalisBinds((varB_678 :: [])) config (-1))))) && (true) -> ((eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_677 :: [])) config (-1))),((eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_678 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
and eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortInt in match c with 
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),`_;__GRHO-SYNTAX`(B,C))=>`#if_#then_#else_#fi_K-EQUAL`(`Set:in`(`(_;_)_GRHO-SYNTAX`(A,I),`#chanlen(_)_AUXFUN-SYNTAX`(B)),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C)),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isPbind(C)),isName(A)),isPbind(B)) ensures #token("true","Bool") [UNIQUE_ID(400d2aa39dfd31cbfe2300820cf9afb4eaf607aa40e475a0f668e1f3e82802aa) contentStartColumn(8) contentStartLine(306) org.kframework.attributes.Location(Location(306,8,306,148)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_679 :: []),((Int _ as varI_680) :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_681 :: []),(varC_682 :: [])) :: [])) when ((((((true) && ((isTrue (evalisPbind((varC_682 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_679 :: [])) config (-1)))))) && ((isTrue (evalisPbind((varB_681 :: [])) config (-1))))) && (true) -> ((if ((isTrue (evalSet'Coln'in((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_679 :: []),(varI_680 :: [])) :: []),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_681 :: [])) config (-1)))) config (-1)))) then (((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_679 :: []),(varI_680 :: [])) :: []),(varC_682 :: [])) config (-1)))) config (-1)))) else (((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_679 :: []),(varI_680 :: [])) :: []),(varC_682 :: [])) config (-1))))))
| ((var_0_683 :: []),(var_1_684)) when guard < 1(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(N,_0)=>`#if_#then_#else_#fi_K-EQUAL`(`_#in(_)_AUXFUN-SYNTAX`(N,M),`_+Int_`(I,`#chanmany(_:_)_AUXFUN-SYNTAX`(N,S)),`#chanmany(_:_)_AUXFUN-SYNTAX`(N,S))`` requires `_andBool_`(`_andBool_`(#setChoice(`_;_;;__GRHO-SYNTAX`(M,_44,I),_0),#match(S,`Set:difference`(_0,`SetItem`(`_;_;;__GRHO-SYNTAX`(M,_44,I))))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isSet(S)),isName(M)),isInt(_44)),isName(N))) ensures #token("true","Bool") [UNIQUE_ID(e1b130143f17aa3811db9bc556aa858fdcd3e691a6b28bf3315777ad986508e0) contentStartColumn(8) contentStartLine(336) org.kframework.attributes.Location(Location(336,8,336,140)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (match (var_1_684) with 
| [Set (_,_,collection)] -> let choice = (KSet.fold (fun e result -> if result == interned_bottom then (match e with | (KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(var_2_685 :: []),((Int _ as var_5_686) :: []),((Int _ as var_3_687) :: [])) :: []) as e0 -> (let e = ((evalSet'Coln'difference((var_1_684),((evalSetItem(e0) config (-1)))) config (-1))) in match e with 
| [Bottom] -> interned_bottom
| ((Set (SortSet,_,_) as var_4_688) :: []) when ((((true) && (true))) && (((((((((true) && (true))) && ((isTrue (evalisName((var_2_685 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisName((var_0_683 :: [])) config (-1))))))) && (true) -> ((if ((isTrue (eval_'Hash'in'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_683 :: []),(var_2_685 :: [])) config (-1)))) then (((eval_'Plus'Int_((var_3_687 :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_683 :: []),(var_4_688 :: [])) config (-1)))) config (-1)))) else (((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_683 :: []),(var_4_688 :: [])) config (-1))))))| _ -> interned_bottom)| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX c config 1) else choice| _ -> (eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX c config 1))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),`_;__GRHO-SYNTAX`(B,C))=>`#if_#then_#else_#fi_K-EQUAL`(`Set:in`(`(_;_)_GRHO-SYNTAX`(A,I),`#chanlen(_)_AUXFUN-SYNTAX`(B)),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C)),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isName(A)),isPbind(B)),isPbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(861aed9d3f13b0960ae3131c143628900df9d7a7d8dc36a7d0d262c3239a3260) contentStartColumn(8) contentStartLine(307) org.kframework.attributes.Location(Location(307,8,307,148)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_689 :: []),((Int _ as varI_690) :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_691 :: []),(varC_692 :: [])) :: [])) when ((((((true) && ((isTrue (evalisName((varA_689 :: [])) config (-1)))))) && ((isTrue (evalisPbind((varB_691 :: [])) config (-1)))))) && ((isTrue (evalisPbinds((varC_692 :: [])) config (-1))))) && (true) -> ((if ((isTrue (evalSet'Coln'in((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_689 :: []),(varI_690 :: [])) :: []),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_691 :: [])) config (-1)))) config (-1)))) then (((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_689 :: []),(varI_690 :: [])) :: []),(varC_692 :: [])) config (-1)))) config (-1)))) else (((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_689 :: []),(varI_690 :: [])) :: []),(varC_692 :: [])) config (-1))))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C)=>`#if_#then_#else_#fi_K-EQUAL`(`_#ine(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(B,A),C),#token("1","Int"),#token("0","Int"))`` requires `_andBool_`(`_andBool_`(isName(A),isNames(B)),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(56cefdedcb33ff2819d07c2f4aed8d117a5fb53297b6bdab785ed82e2ef178b0) contentStartColumn(8) contentStartLine(311) org.kframework.attributes.Location(Location(311,8,311,94)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_693 :: []),(varB_694 :: [])) :: []),(varC_695 :: [])) when (((((isTrue (evalisName((varA_693 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_694 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varC_695 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varB_694 :: []),(varA_693 :: [])) :: []),(varC_695 :: [])) config (-1)))) then (((Lazy.force int1) :: [])) else (((Lazy.force int0) :: []))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C)=>`#if_#then_#else_#fi_K-EQUAL`(`_#ine(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(B,A),C),#token("1","Int"),#token("0","Int"))`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(9da3023cdd2df2e26f4d48095d2816cebd7cbb37d6ed3602dce2a2a40c7ba218) contentStartColumn(8) contentStartLine(310) org.kframework.attributes.Location(Location(310,8,310,94)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_696 :: []),(varB_697 :: [])) :: []),(varC_698 :: [])) when (((((isTrue (evalisName((varB_697 :: [])) config (-1)))) && ((isTrue (evalisName((varA_696 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varC_698 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varB_697 :: []),(varA_696 :: [])) :: []),(varC_698 :: [])) config (-1)))) then (((Lazy.force int1) :: [])) else (((Lazy.force int0) :: []))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isLbinds(D),isName(A)),isNames(B)),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(84e6e7cac5be54f1b89813846174e6558d103244c35df75db2313592ffd26aed) contentStartColumn(8) contentStartLine(320) org.kframework.attributes.Location(Location(320,8,320,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_699 :: []),(varB_700 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_701 :: []),(varD_702 :: [])) :: [])) when (((((((isTrue (evalisLbinds((varD_702 :: [])) config (-1)))) && ((isTrue (evalisName((varA_699 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_700 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varC_701 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_699 :: []),(varB_700 :: [])) :: []),(varC_701 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_699 :: []),(varB_700 :: [])) :: []),(varD_702 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isName(B),isName(A)),isLbind(C)),isLbind(D)) ensures #token("true","Bool") [UNIQUE_ID(d006611ec3205e4d08987526b038e729812957b536a3e8923f62e4155ef1cfd6) contentStartColumn(8) contentStartLine(317) org.kframework.attributes.Location(Location(317,8,317,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_703 :: []),(varB_704 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_705 :: []),(varD_706 :: [])) :: [])) when (((((((isTrue (evalisName((varB_704 :: [])) config (-1)))) && ((isTrue (evalisName((varA_703 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varC_705 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varD_706 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_703 :: []),(varB_704 :: [])) :: []),(varC_705 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_703 :: []),(varB_704 :: [])) :: []),(varD_706 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),`_;__GRHO-SYNTAX`(B,C))=>`#if_#then_#else_#fi_K-EQUAL`(`Set:in`(`(_;_)_GRHO-SYNTAX`(A,I),`#chanlen(_)_AUXFUN-SYNTAX`(B)),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C)),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isRbind(C)),isName(A)),isRbind(B)) ensures #token("true","Bool") [UNIQUE_ID(dc5d0505d36e48c95b69af8e0aa39ccf848ab35e5253f1279e4b9c436d7c2db9) contentStartColumn(8) contentStartLine(303) org.kframework.attributes.Location(Location(303,8,303,148)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_707 :: []),((Int _ as varI_708) :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_709 :: []),(varC_710 :: [])) :: [])) when ((((((true) && ((isTrue (evalisRbind((varC_710 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_707 :: [])) config (-1)))))) && ((isTrue (evalisRbind((varB_709 :: [])) config (-1))))) && (true) -> ((if ((isTrue (evalSet'Coln'in((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_707 :: []),(varI_708 :: [])) :: []),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_709 :: [])) config (-1)))) config (-1)))) then (((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_707 :: []),(varI_708 :: [])) :: []),(varC_710 :: [])) config (-1)))) config (-1)))) else (((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_707 :: []),(varI_708 :: [])) :: []),(varC_710 :: [])) config (-1))))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isRbind(C),isName(B)),isName(A)),isRbinds(D)) ensures #token("true","Bool") [UNIQUE_ID(3897a541266284c3c874b79a206bbb3606db7e69b816e397220852adc0b813f5) contentStartColumn(8) contentStartLine(324) org.kframework.attributes.Location(Location(324,8,324,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_711 :: []),(varB_712 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_713 :: []),(varD_714 :: [])) :: [])) when (((((((isTrue (evalisRbind((varC_713 :: [])) config (-1)))) && ((isTrue (evalisName((varB_712 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_711 :: [])) config (-1)))))) && ((isTrue (evalisRbinds((varD_714 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_711 :: []),(varB_712 :: [])) :: []),(varC_713 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_711 :: []),(varB_712 :: [])) :: []),(varD_714 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),B)=>`#if_#then_#else_#fi_K-EQUAL`(`Set:in`(`(_;_)_GRHO-SYNTAX`(A,I),`#chanlen(_)_AUXFUN-SYNTAX`(B)),#token("1","Int"),#token("0","Int"))`` requires `_andBool_`(`_andBool_`(isInt(I),isName(A)),isBind(B)) ensures #token("true","Bool") [UNIQUE_ID(7b83e17413fd5caf44320eb3cce9d353e8fdf0098b98bddc44760bdff36ed349) contentStartColumn(8) contentStartLine(299) org.kframework.attributes.Location(Location(299,8,299,148)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_715 :: []),((Int _ as varI_716) :: [])) :: []),(varB_717 :: [])) when ((((true) && ((isTrue (evalisName((varA_715 :: [])) config (-1)))))) && ((isTrue (evalisBind((varB_717 :: [])) config (-1))))) && (true) -> ((if ((isTrue (evalSet'Coln'in((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_715 :: []),(varI_716 :: [])) :: []),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_717 :: [])) config (-1)))) config (-1)))) then (((Lazy.force int1) :: [])) else (((Lazy.force int0) :: []))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isName(B),isPbind(C)),isPbinds(D)),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(a20c1f74ce7611b1b6b50c9fffd96f30653f36f20f45a1e3bcb19547d8e308d7) contentStartColumn(8) contentStartLine(329) org.kframework.attributes.Location(Location(329,8,329,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_718 :: []),(varB_719 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_720 :: []),(varD_721 :: [])) :: [])) when (((((((isTrue (evalisName((varB_719 :: [])) config (-1)))) && ((isTrue (evalisPbind((varC_720 :: [])) config (-1)))))) && ((isTrue (evalisPbinds((varD_721 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_718 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_718 :: []),(varB_719 :: [])) :: []),(varC_720 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_718 :: []),(varB_719 :: [])) :: []),(varD_721 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C)=>`#if_#then_#else_#fi_K-EQUAL`(`_#ine(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(B,A),C),#token("1","Int"),#token("0","Int"))`` requires `_andBool_`(`_andBool_`(isPbind(C),isName(A)),isNames(B)) ensures #token("true","Bool") [UNIQUE_ID(8f6780be8fef3a29dcf7a8f93b99593d73d564bfbd7be91635d9afc5e11922b6) contentStartColumn(8) contentStartLine(315) org.kframework.attributes.Location(Location(315,8,315,94)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_722 :: []),(varB_723 :: [])) :: []),(varC_724 :: [])) when (((((isTrue (evalisPbind((varC_724 :: [])) config (-1)))) && ((isTrue (evalisName((varA_722 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_723 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varB_723 :: []),(varA_722 :: [])) :: []),(varC_724 :: [])) config (-1)))) then (((Lazy.force int1) :: [])) else (((Lazy.force int0) :: []))))
| ((var_0_725 :: []),(var_1_726)) when guard < 12(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(N,_0)=>`#if_#then_#else_#fi_K-EQUAL`(`_#in(_)_AUXFUN-SYNTAX`(N,M),I,#token("0","Int"))`` requires `_andBool_`(`_andBool_`(#setChoice(`_;_;;__GRHO-SYNTAX`(M,_81,I),_0),`_==K_`(`.Set`(.KList),`Set:difference`(_0,`SetItem`(`_;_;;__GRHO-SYNTAX`(M,_81,I))))),`_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isInt(_81)),isName(M)),isName(N))) ensures #token("true","Bool") [UNIQUE_ID(8607dceed2a9604b6f55440b8a6d2ba2369356e345ea8308e82db91a3d2cf6b6) contentStartColumn(8) contentStartLine(335) org.kframework.attributes.Location(Location(335,8,335,107)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (match (var_1_726) with 
| [Set (_,_,collection)] -> let choice = (KSet.fold (fun e result -> if result == interned_bottom then (match e with | (KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(var_2_727 :: []),((Int _ as var_4_728) :: []),((Int _ as var_3_729) :: [])) :: []) as e1 when ((((true) && ((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),((evalSet'Coln'difference((var_1_726),((evalSetItem(e1) config (-1)))) config (-1)))) config (-1)))))) && (((((((true) && (true))) && ((isTrue (evalisName((var_2_727 :: [])) config (-1)))))) && ((isTrue (evalisName((var_0_725 :: [])) config (-1))))))) && (true) -> ((if ((isTrue (eval_'Hash'in'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_725 :: []),(var_2_727 :: [])) config (-1)))) then ((var_3_729 :: [])) else (((Lazy.force int0) :: []))))| _ -> interned_bottom) else result) collection interned_bottom) in if choice == interned_bottom then (eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX c config 12) else choice| _ -> (eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX c config 12))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(N,_0)=>#token("0","Int")`` requires `_andBool_`(`_==K_`(`.Set`(.KList),_0),isName(N)) ensures #token("true","Bool") [UNIQUE_ID(b7c10228532f8a1ed96919cce4bc60aa60203c5e5de59e1e1536712c38927f2b) contentStartColumn(8) contentStartLine(334) org.kframework.attributes.Location(Location(334,8,334,39)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varN_730 :: []),(var_0_731)) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_731)) config (-1)))) && ((isTrue (evalisName((varN_730 :: [])) config (-1))))) && (true) -> ((Lazy.force int0) :: [])
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),`_;__GRHO-SYNTAX`(B,C))=>`#if_#then_#else_#fi_K-EQUAL`(`Set:in`(`(_;_)_GRHO-SYNTAX`(A,I),`#chanlen(_)_AUXFUN-SYNTAX`(B)),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C)),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isLbinds(C)),isName(A)),isLbind(B)) ensures #token("true","Bool") [UNIQUE_ID(a271faf4c35a01d8d7e0118aed93a420d59a25b436e5620060798de3f2eeff71) contentStartColumn(8) contentStartLine(301) org.kframework.attributes.Location(Location(301,8,301,148)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_732 :: []),((Int _ as varI_733) :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_734 :: []),(varC_735 :: [])) :: [])) when ((((((true) && ((isTrue (evalisLbinds((varC_735 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_732 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varB_734 :: [])) config (-1))))) && (true) -> ((if ((isTrue (evalSet'Coln'in((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_732 :: []),(varI_733 :: [])) :: []),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_734 :: [])) config (-1)))) config (-1)))) then (((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_732 :: []),(varI_733 :: [])) :: []),(varC_735 :: [])) config (-1)))) config (-1)))) else (((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_732 :: []),(varI_733 :: [])) :: []),(varC_735 :: [])) config (-1))))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isRbind(C),isName(A)),isNames(B)),isRbinds(D)) ensures #token("true","Bool") [UNIQUE_ID(7bf9ba96864093d3cd2fa826a477586f8132bc9e67c5a9d09e7dd0cf7f977df6) contentStartColumn(8) contentStartLine(325) org.kframework.attributes.Location(Location(325,8,325,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_736 :: []),(varB_737 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_738 :: []),(varD_739 :: [])) :: [])) when (((((((isTrue (evalisRbind((varC_738 :: [])) config (-1)))) && ((isTrue (evalisName((varA_736 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_737 :: [])) config (-1)))))) && ((isTrue (evalisRbinds((varD_739 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_736 :: []),(varB_737 :: [])) :: []),(varC_738 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_736 :: []),(varB_737 :: [])) :: []),(varD_739 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isName(B),isLbinds(D)),isName(A)),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(901f688af72a1f4c2903217480fda8af25b3669de93e65a744403a2bffd21b9f) contentStartColumn(8) contentStartLine(319) org.kframework.attributes.Location(Location(319,8,319,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_740 :: []),(varB_741 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_742 :: []),(varD_743 :: [])) :: [])) when (((((((isTrue (evalisName((varB_741 :: [])) config (-1)))) && ((isTrue (evalisLbinds((varD_743 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_740 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varC_742 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_740 :: []),(varB_741 :: [])) :: []),(varC_742 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_740 :: []),(varB_741 :: [])) :: []),(varD_743 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C)=>`#if_#then_#else_#fi_K-EQUAL`(`_#ine(_)_AUXFUN-SYNTAX`(`_<=__GRHO-SYNTAX`(B,A),C),#token("1","Int"),#token("0","Int"))`` requires `_andBool_`(`_andBool_`(isRbind(C),isName(B)),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(73724fa2c3043194304a55f4089e82fe3175c881c508c2421a05a33b2a28c2b2) contentStartColumn(8) contentStartLine(312) org.kframework.attributes.Location(Location(312,8,312,94)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_744 :: []),(varB_745 :: [])) :: []),(varC_746 :: [])) when (((((isTrue (evalisRbind((varC_746 :: [])) config (-1)))) && ((isTrue (evalisName((varB_745 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_744 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX(((eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX((varB_745 :: []),(varA_744 :: [])) config (-1))),(varC_746 :: [])) config (-1)))) then (((Lazy.force int1) :: [])) else (((Lazy.force int0) :: []))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isPbind(C),isName(A)),isNames(B)),isPbind(D)) ensures #token("true","Bool") [UNIQUE_ID(9b8cbfd0a627163e9fa569ee74c5800392dc8c566ad527e001fa8bdb0479a15d) contentStartColumn(8) contentStartLine(328) org.kframework.attributes.Location(Location(328,8,328,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_747 :: []),(varB_748 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_749 :: []),(varD_750 :: [])) :: [])) when (((((((isTrue (evalisPbind((varC_749 :: [])) config (-1)))) && ((isTrue (evalisName((varA_747 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_748 :: [])) config (-1)))))) && ((isTrue (evalisPbind((varD_750 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_747 :: []),(varB_748 :: [])) :: []),(varC_749 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_747 :: []),(varB_748 :: [])) :: []),(varD_750 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C)=>`#if_#then_#else_#fi_K-EQUAL`(`_#ine(_)_AUXFUN-SYNTAX`(`_<-__GRHO-SYNTAX`(B,A),C),#token("1","Int"),#token("0","Int"))`` requires `_andBool_`(`_andBool_`(isRbind(C),isName(A)),isNames(B)) ensures #token("true","Bool") [UNIQUE_ID(5e149555802cc12b30c57caec19fe3242d9e8363390aacf8523ef38c1964943e) contentStartColumn(8) contentStartLine(313) org.kframework.attributes.Location(Location(313,8,313,94)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_751 :: []),(varB_752 :: [])) :: []),(varC_753 :: [])) when (((((isTrue (evalisRbind((varC_753 :: [])) config (-1)))) && ((isTrue (evalisName((varA_751 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_752 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varB_752 :: []),(varA_751 :: [])) :: []),(varC_753 :: [])) config (-1)))) then (((Lazy.force int1) :: [])) else (((Lazy.force int0) :: []))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),`_;__GRHO-SYNTAX`(B,C))=>`#if_#then_#else_#fi_K-EQUAL`(`Set:in`(`(_;_)_GRHO-SYNTAX`(A,I),`#chanlen(_)_AUXFUN-SYNTAX`(B)),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C)),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isName(A)),isRbind(B)),isRbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(c0773e7afdfac21275950b398e98f52193324b3621d7aa4cc34e2d6dc13e1814) contentStartColumn(8) contentStartLine(304) org.kframework.attributes.Location(Location(304,8,304,148)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_754 :: []),((Int _ as varI_755) :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_756 :: []),(varC_757 :: [])) :: [])) when ((((((true) && ((isTrue (evalisName((varA_754 :: [])) config (-1)))))) && ((isTrue (evalisRbind((varB_756 :: [])) config (-1)))))) && ((isTrue (evalisRbinds((varC_757 :: [])) config (-1))))) && (true) -> ((if ((isTrue (evalSet'Coln'in((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_754 :: []),(varI_755 :: [])) :: []),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_756 :: [])) config (-1)))) config (-1)))) then (((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_754 :: []),(varI_755 :: [])) :: []),(varC_757 :: [])) config (-1)))) config (-1)))) else (((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_754 :: []),(varI_755 :: [])) :: []),(varC_757 :: [])) config (-1))))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C)=>`#if_#then_#else_#fi_K-EQUAL`(`_#ine(_)_AUXFUN-SYNTAX`(`_<!__GRHO-SYNTAX`(B,A),C),#token("1","Int"),#token("0","Int"))`` requires `_andBool_`(`_andBool_`(isName(B),isPbind(C)),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(77d50c8dc872e0f508d279fc815928f3c9302e78f8f0dac47c5f24fbe41e4839) contentStartColumn(8) contentStartLine(314) org.kframework.attributes.Location(Location(314,8,314,94)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_758 :: []),(varB_759 :: [])) :: []),(varC_760 :: [])) when (((((isTrue (evalisName((varB_759 :: [])) config (-1)))) && ((isTrue (evalisPbind((varC_760 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_758 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varB_759 :: []),(varA_758 :: [])) :: []),(varC_760 :: [])) config (-1)))) then (((Lazy.force int1) :: [])) else (((Lazy.force int0) :: []))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),`_;__GRHO-SYNTAX`(B,C))=>`#if_#then_#else_#fi_K-EQUAL`(`Set:in`(`(_;_)_GRHO-SYNTAX`(A,I),`#chanlen(_)_AUXFUN-SYNTAX`(B)),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C)),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,I),C))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isName(A)),isLbind(B)),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(52207ddd10017f673f4abe8205fde3b1698b6ea6883bf8cdd5c087fed2b13e13) contentStartColumn(8) contentStartLine(300) org.kframework.attributes.Location(Location(300,8,300,148)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_761 :: []),((Int _ as varI_762) :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_763 :: []),(varC_764 :: [])) :: [])) when ((((((true) && ((isTrue (evalisName((varA_761 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varB_763 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varC_764 :: [])) config (-1))))) && (true) -> ((if ((isTrue (evalSet'Coln'in((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_761 :: []),(varI_762 :: [])) :: []),((eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_763 :: [])) config (-1)))) config (-1)))) then (((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_761 :: []),(varI_762 :: [])) :: []),(varC_764 :: [])) config (-1)))) config (-1)))) else (((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_761 :: []),(varI_762 :: [])) :: []),(varC_764 :: [])) config (-1))))))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isRbind(C),isRbind(D)),isName(A)),isNames(B)) ensures #token("true","Bool") [UNIQUE_ID(271f2d90da45d42b580f4e79c2d503aea5d0ff6eedda077f71d7016bb4db460d) contentStartColumn(8) contentStartLine(323) org.kframework.attributes.Location(Location(323,8,323,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_765 :: []),(varB_766 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_767 :: []),(varD_768 :: [])) :: [])) when (((((((isTrue (evalisRbind((varC_767 :: [])) config (-1)))) && ((isTrue (evalisRbind((varD_768 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_765 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_766 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_765 :: []),(varB_766 :: [])) :: []),(varC_767 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_765 :: []),(varB_766 :: [])) :: []),(varD_768 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isRbind(C),isRbind(D)),isName(B)),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(83981eb2e30673fc6070f829669abd3f9dc0a9e95e691903c97c6ddd1de48ee0) contentStartColumn(8) contentStartLine(322) org.kframework.attributes.Location(Location(322,8,322,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_769 :: []),(varB_770 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_771 :: []),(varD_772 :: [])) :: [])) when (((((((isTrue (evalisRbind((varC_771 :: [])) config (-1)))) && ((isTrue (evalisRbind((varD_772 :: [])) config (-1)))))) && ((isTrue (evalisName((varB_770 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_769 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_769 :: []),(varB_770 :: [])) :: []),(varC_771 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_769 :: []),(varB_770 :: [])) :: []),(varD_772 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isName(A),isNames(B)),isLbind(C)),isLbind(D)) ensures #token("true","Bool") [UNIQUE_ID(cd0a68dce18c1bbc9a19cc23c0dff283629a32cbe7e47e0f8f239640962190dc) contentStartColumn(8) contentStartLine(318) org.kframework.attributes.Location(Location(318,8,318,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_773 :: []),(varB_774 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_775 :: []),(varD_776 :: [])) :: [])) when (((((((isTrue (evalisName((varA_773 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_774 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varC_775 :: [])) config (-1)))))) && ((isTrue (evalisLbind((varD_776 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_773 :: []),(varB_774 :: [])) :: []),(varC_775 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_773 :: []),(varB_774 :: [])) :: []),(varD_776 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isName(B),isPbind(C)),isName(A)),isPbind(D)) ensures #token("true","Bool") [UNIQUE_ID(4048f7be0496272aa1daf68e598ec8280cfaea96ae140fe602e30762798be04a) contentStartColumn(8) contentStartLine(327) org.kframework.attributes.Location(Location(327,8,327,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_777 :: []),(varB_778 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_779 :: []),(varD_780 :: [])) :: [])) when (((((((isTrue (evalisName((varB_778 :: [])) config (-1)))) && ((isTrue (evalisPbind((varC_779 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_777 :: [])) config (-1)))))) && ((isTrue (evalisPbind((varD_780 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_777 :: []),(varB_778 :: [])) :: []),(varC_779 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_777 :: []),(varB_778 :: [])) :: []),(varD_780 :: [])) config (-1)))) config (-1)))
(*{| rule `` `#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),`_;__GRHO-SYNTAX`(C,D))=>`_+Int_`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),C),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(A,B),D))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isPbind(C),isPbinds(D)),isName(A)),isNames(B)) ensures #token("true","Bool") [UNIQUE_ID(9e1efdcb93fe97904977550139710051557bc4ac274c2c71d8727b81ad439c88) contentStartColumn(8) contentStartLine(330) org.kframework.attributes.Location(Location(330,8,330,108)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_781 :: []),(varB_782 :: [])) :: []),(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varC_783 :: []),(varD_784 :: [])) :: [])) when (((((((isTrue (evalisPbind((varC_783 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varD_784 :: [])) config (-1)))))) && ((isTrue (evalisName((varA_781 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_782 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_781 :: []),(varB_782 :: [])) :: []),(varC_783 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varA_781 :: []),(varB_782 :: [])) :: []),(varD_784 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
and eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortSet in match c with 
(*{| rule `` `#bindocce(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_<=Set__SET`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),#token("2","Int"))),`Set:difference`(`#bindocce(_)_AUXFUN-SYNTAX`(B),`#bindocce(_)_AUXFUN-SYNTAX`(A))),`_Set_`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isRbind(B),isRbind(A)) ensures #token("true","Bool") [UNIQUE_ID(9b108d5a739ed29a5e2fc218096ed0a7aefaaf7869709cbd2080cf809ec7f04c) contentStartColumn(8) contentStartLine(400) org.kframework.attributes.Location(Location(400,8,404,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_785 :: []),(varB_786 :: [])) :: [])) when (((isTrue (evalisRbind((varB_786 :: [])) config (-1)))) && ((isTrue (evalisRbind((varA_785 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_785 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_786 :: [])) config (-1)))) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_785 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_785 :: [])) config (-1))),((Lazy.force int2) :: [])) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_786 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_785 :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_785 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_786 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocce(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_<=Set__SET`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),#token("2","Int"))),`Set:difference`(`#bindocce(_)_AUXFUN-SYNTAX`(B),`#bindocce(_)_AUXFUN-SYNTAX`(A))),`_Set_`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isPbind(A),isPbind(B)) ensures #token("true","Bool") [UNIQUE_ID(0aee5d42197802969541bfee852f15275eb82b7e7477bbab09194b640f1f74c7) contentStartColumn(8) contentStartLine(412) org.kframework.attributes.Location(Location(412,8,416,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_787 :: []),(varB_788 :: [])) :: [])) when (((isTrue (evalisPbind((varA_787 :: [])) config (-1)))) && ((isTrue (evalisPbind((varB_788 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_787 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_788 :: [])) config (-1)))) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_787 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_787 :: [])) config (-1))),((Lazy.force int2) :: [])) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_788 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_787 :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_787 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_788 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocce(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_<=Set__SET`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),#token("2","Int"))),`Set:difference`(`#bindocce(_)_AUXFUN-SYNTAX`(B),`#bindocce(_)_AUXFUN-SYNTAX`(A))),`_Set_`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isLbind(B),isLbind(A)) ensures #token("true","Bool") [UNIQUE_ID(a660449b0947329af8e0c8db57a7034c36a33c85073a1ab1ff2fe9a8754e5da8) contentStartColumn(8) contentStartLine(388) org.kframework.attributes.Location(Location(388,8,392,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_789 :: []),(varB_790 :: [])) :: [])) when (((isTrue (evalisLbind((varB_790 :: [])) config (-1)))) && ((isTrue (evalisLbind((varA_789 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'_LT_Eqls'Set__SET(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_789 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_790 :: [])) config (-1)))) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_789 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_789 :: [])) config (-1))),((Lazy.force int2) :: [])) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_790 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_789 :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_789 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_790 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocce(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_=/=Int__INT`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B),#token("0","Int")),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B)))),`Set:difference`(`#bindocce(_)_AUXFUN-SYNTAX`(B),`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B))))),`_Set_`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isRbinds(B),isRbind(A)) ensures #token("true","Bool") [UNIQUE_ID(adfa59d5ceee1f485fdc8e0da2cbd8983ad21fe4a84c4510567da8e6ed0adac3) contentStartColumn(8) contentStartLine(405) org.kframework.attributes.Location(Location(405,8,409,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_791 :: []),(varB_792 :: [])) :: [])) when (((isTrue (evalisRbinds((varB_792 :: [])) config (-1)))) && ((isTrue (evalisRbind((varA_791 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsSlshEqls'Int__INT(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1)))) :: []),(varB_792 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1))),((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1)))) :: []),(varB_792 :: [])) config (-1)))) config (-1)))) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_792 :: [])) config (-1))),((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1)))) :: []),(varB_792 :: [])) config (-1)))) :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_791 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_792 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocce(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_=/=Int__INT`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B),#token("0","Int")),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B)))),`Set:difference`(`#bindocce(_)_AUXFUN-SYNTAX`(B),`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B))))),`_Set_`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isLbind(A),isLbinds(B)) ensures #token("true","Bool") [UNIQUE_ID(3980d424d4faf464f2e325cd4e1f0eac9298601c0b1e80978c58f5ccbacd53a5) contentStartColumn(8) contentStartLine(393) org.kframework.attributes.Location(Location(393,8,397,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_793 :: []),(varB_794 :: [])) :: [])) when (((isTrue (evalisLbind((varA_793 :: [])) config (-1)))) && ((isTrue (evalisLbinds((varB_794 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsSlshEqls'Int__INT(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1)))) :: []),(varB_794 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1))),((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1)))) :: []),(varB_794 :: [])) config (-1)))) config (-1)))) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_794 :: [])) config (-1))),((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1)))) :: []),(varB_794 :: [])) config (-1)))) :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_793 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_794 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocce(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(A,B))=>`#if_#then_#else_#fi_K-EQUAL`(`_=/=Int__INT`(`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B),#token("0","Int")),`_Set_`(`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),`_+Int_`(#token("1","Int"),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B)))),`Set:difference`(`#bindocce(_)_AUXFUN-SYNTAX`(B),`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),`#chanmany(_:_)_AUXFUN-SYNTAX`(`(_;_)_GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A)),B))))),`_Set_`(`#bindocce(_)_AUXFUN-SYNTAX`(A),`#bindocce(_)_AUXFUN-SYNTAX`(B)))`` requires `_andBool_`(isRbinds(B),isRbind(A)) ensures #token("true","Bool") [UNIQUE_ID(adfa59d5ceee1f485fdc8e0da2cbd8983ad21fe4a84c4510567da8e6ed0adac3) contentStartColumn(8) contentStartLine(417) org.kframework.attributes.Location(Location(417,8,421,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varA_795 :: []),(varB_796 :: [])) :: [])) when (((isTrue (evalisRbinds((varB_796 :: [])) config (-1)))) && ((isTrue (evalisRbind((varA_795 :: [])) config (-1))))) && (true) -> ((if ((isTrue (eval_'EqlsSlshEqls'Int__INT(((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1)))) :: []),(varB_796 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))) then (((eval_Set_(((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1))),((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1)))) :: []),(varB_796 :: [])) config (-1)))) config (-1)))) :: [])) config (-1))),((evalSet'Coln'difference(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_796 :: [])) config (-1))),((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1))),((eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1)))) :: []),(varB_796 :: [])) config (-1)))) :: [])) config (-1)))) config (-1)))) config (-1)))) else (((eval_Set_(((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_795 :: [])) config (-1))),((eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_796 :: [])) config (-1)))) config (-1))))))
(*{| rule `` `#bindocce(_)_AUXFUN-SYNTAX`(A)=>`SetItem`(`_;_;;__GRHO-SYNTAX`(`#chan(_)_AUXFUN-SYNTAX`(A),`#bvar(_)_AUXFUN-SYNTAX`(A),#token("1","Int")))`` requires isBind(A) ensures #token("true","Bool") [UNIQUE_ID(2a6987d33257299a9819f7d4d9906d2af82cc5b62d557f784e86c585eae7f5d6) contentStartColumn(8) contentStartLine(385) org.kframework.attributes.Location(Location(385,8,385,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_797 :: [])) when (isTrue (evalisBind((varA_797 :: [])) config (-1))) && (true) -> ((evalSetItem((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_797 :: [])) config (-1))),((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varA_797 :: [])) config (-1))),((Lazy.force int1) :: [])) :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisWhoCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWhoCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isWhoCellOpt(#KToken(#token("WhoCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhoCell, var__798) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhoCellOpt(#KToken(#token("WhoCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhoCellOpt, var__799) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhoCellOpt(noWhoCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoWhoCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhoCellOpt(`<who>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'who'_GT_',(varK0_800)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isWhoCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_801)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisNew (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNew and sort = 
SortBool in match c with 
(*{| rule ``isNew(#KToken(#token("New","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNew, var__802) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNew(`new_in{_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblnew_in'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_803 :: []),(varK1_804 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_803 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_804 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isNew(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_805)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalString2Int (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Int and sort = 
SortInt in match c with 
| _ -> try STRING.hook_string2int c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitWhereCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitWhereCell and sort = 
SortWhereCell in match c with 
(*{| rule ``initWhereCell(.KList)=>`<where>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(9d79468f8aecb58e0375a706cc9361c9bef0b90aee3868f4d15cf7f2afcb7ad4) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'where'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitWhereCell : k Lazy.t = lazy (evalinitWhereCell () interned_bottom (-1))
let evalproject'Coln'Proc (c: k) (config: k) (guard: int) : k = let lbl = 
Lblproject'Coln'Proc and sort = 
SortProc in match c with 
(*{| rule `` `project:Proc`(K)=>K`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(cb126cf017df4e6349622538a0090ca4f49fe00ccf73259bbd5ec5a3e59e3beb) projection()]|}*)
| ((varK_806 :: [])) -> (varK_806 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitKCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitKCell and sort = 
SortKCell in match c with 
(*{| rule ``initKCell(Init)=>`<k>`(`project:Proc`(`Map:lookup`(Init,#token("$PGM","KConfigVar"))))`` requires isProc(`project:Proc`(`Map:lookup`(Init,#token("$PGM","KConfigVar")))) ensures #token("true","Bool") [UNIQUE_ID(d3d92662c16a4dde1625ade96c567eef65d6dc0ed7c3f0ee2b3d4001d0c3f393) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_807) :: [])) when (isTrue (evalisProc(((evalproject'Coln'Proc(((evalMap'Coln'lookup((varInit_807 :: []),(KToken (SortKConfigVar, "$PGM") :: [])) config (-1)))) config (-1)))) config (-1))) && (true) -> (KApply1(Lbl'_LT_'k'_GT_',((evalproject'Coln'Proc(((evalMap'Coln'lookup((varInit_807 :: []),(KToken (SortKConfigVar, "$PGM") :: [])) config (-1)))) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitThreadCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitThreadCell and sort = 
SortThreadCell in match c with 
(*{| rule ``initThreadCell(Init)=>`<thread>`(initKCell(Init))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(0eb9a346d4152f513a1782dc6b34441979e54d9311b37b51fa40edf829c8b39e) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_808) :: [])) -> (KApply1(Lbl'_LT_'thread'_GT_',((evalinitKCell((varInit_808 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSingleRec (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSingleRec and sort = 
SortBool in match c with 
(*{| rule ``isSingleRec(#KToken(#token("SingleRec","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSingleRec, var__809) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSingleRec(`for(_){_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBind(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_810 :: []),(varK1_811 :: [])) :: [])) when (((isTrue (evalisBind((varK0_810 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_811 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSingleRec(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_812)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIOError (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIOError and sort = 
SortBool in match c with 
(*{| rule ``isIOError(`#ECONNREFUSED_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNREFUSED_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPIPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPIPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ETOOMANYREFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ETOOMANYREFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETUNREACH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETUNREACH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EBUSY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EBUSY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EHOSTDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EHOSTDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTEMPTY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTEMPTY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EFBIG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EFBIG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#E2BIG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'E2BIG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOLCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOLCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EROFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EROFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EISCONN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EISCONN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESRCH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESRCH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINPROGRESS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINPROGRESS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ERANGE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ERANGE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(#KToken(#token("IOError","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIOError, var__813) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOBUFS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOBUFS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOSPC_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOSPC_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EADDRINUSE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EADDRINUSE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EAFNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EAFNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDOM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDOM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EIO_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EIO_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOPNOTSUPP_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOPNOTSUPP_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENAMETOOLONG_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENAMETOOLONG_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPERM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPERM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPROTONOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPROTONOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMLINK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMLINK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOENT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOENT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOMEM_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOMEM_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECONNRESET_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNRESET_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EWOULDBLOCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EWOULDBLOCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOEXEC_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOEXEC_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECONNABORTED_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECONNABORTED_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOSYS_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOSYS_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EHOSTUNREACH_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EHOSTUNREACH_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EEXIST_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EEXIST_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(#unknownIOError(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'unknownIOError,((Int _ as varK0_814) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDESTADDRREQ_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDESTADDRREQ_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EBADF_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EBADF_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EXDEV_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EXDEV_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTCONN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTCONN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENFILE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENFILE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENODEV_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENODEV_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENXIO_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENXIO_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETRESET_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETRESET_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPFNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPFNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EISDIR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EISDIR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ETIMEDOUT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ETIMEDOUT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINVAL_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINVAL_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EAGAIN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EAGAIN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESPIPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESPIPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMFILE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMFILE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EFAULT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EFAULT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENETDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENETDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOVERFLOW_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOVERFLOW_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EACCES_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EACCES_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EOF_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EOF_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EDEADLK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EDEADLK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTSOCK_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTSOCK_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ECHILD_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ECHILD_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EPROTOTYPE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EPROTOTYPE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOPROTOOPT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOPROTOOPT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EINTR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EINTR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ELOOP_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ELOOP_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESHUTDOWN_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESHUTDOWN_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EMSGSIZE_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EMSGSIZE_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTDIR_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTDIR_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EALREADY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EALREADY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ENOTTY_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ENOTTY_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#ESOCKTNOSUPPORT_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'ESOCKTNOSUPPORT_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#EADDRNOTAVAIL_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'EADDRNOTAVAIL_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(`#noparse_K-IO`(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(Lbl'Hash'noparse_K'Hyph'IO) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIOError(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_815)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisThreadsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadsCell and sort = 
SortBool in match c with 
(*{| rule ``isThreadsCell(`<threads>`(K0))=>#token("true","Bool")`` requires isThreadCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'threads'_GT_',(varK0_816 :: [])) :: [])) when (isTrue (evalisThreadCellBag((varK0_816 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadsCell(#KToken(#token("ThreadsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadsCell, var__817) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadsCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_818)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTupleCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTupleCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isTupleCellOpt(`<tuple>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'tuple'_GT_',(varK0_819)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isTupleCellOpt(#KToken(#token("TupleCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTupleCell, var__820) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTupleCellOpt(noTupleCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoTupleCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTupleCellOpt(#KToken(#token("TupleCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTupleCellOpt, var__821) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTupleCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_822)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'parse (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'parse and sort = 
SortKItem in match c with 
| _ -> try IO.hook_parse c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisEval (c: k) (config: k) (guard: int) : k = let lbl = 
LblisEval and sort = 
SortBool in match c with 
(*{| rule ``isEval(#KToken(#token("Eval","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEval, var__823) :: [])) -> ((Bool true) :: [])
(*{| rule ``isEval(`*__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Star'__GRHO'Hyph'SYNTAX,(varK0_824 :: [])) :: [])) when (isTrue (evalisName((varK0_824 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isEval(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_825)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisWhatCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWhatCell and sort = 
SortBool in match c with 
(*{| rule ``isWhatCell(#KToken(#token("WhatCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhatCell, var__826) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhatCell(`<what>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'what'_GT_',(varK0_827)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isWhatCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_828)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRhoList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRhoList and sort = 
SortBool in match c with 
(*{| rule ``isRhoList(#KToken(#token("RhoList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoList, var__829) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRhoList(`[_]_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LSqB'_'RSqB'_GRHO'Hyph'SYNTAX,(varK0_830 :: [])) :: [])) when (isTrue (evalisProcList((varK0_830 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRhoList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_831)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisChanCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisChanCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isChanCellOpt(#KToken(#token("ChanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortChanCell, var__832) :: [])) -> ((Bool true) :: [])
(*{| rule ``isChanCellOpt(#KToken(#token("ChanCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortChanCellOpt, var__833) :: [])) -> ((Bool true) :: [])
(*{| rule ``isChanCellOpt(`<chan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'chan'_GT_',(varK0_834)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isChanCellOpt(noChanCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoChanCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isChanCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_835)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisVarsCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisVarsCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isVarsCellOpt(#KToken(#token("VarsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortVarsCell, var__836) :: [])) -> ((Bool true) :: [])
(*{| rule ``isVarsCellOpt(#KToken(#token("VarsCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortVarsCellOpt, var__837) :: [])) -> ((Bool true) :: [])
(*{| rule ``isVarsCellOpt(noVarsCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoVarsCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isVarsCellOpt(`<vars>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'vars'_GT_',(varK0_838)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isVarsCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_839)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisNumCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNumCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isNumCellOpt(#KToken(#token("NumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNumCell, var__840) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNumCellOpt(#KToken(#token("NumCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNumCellOpt, var__841) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNumCellOpt(noNumCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoNumCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNumCellOpt(`<num>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'num'_GT_',(varK0_842)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isNumCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_843)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisLidCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisLidCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isLidCellOpt(noLidCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoLidCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLidCellOpt(#KToken(#token("LidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLidCell, var__844) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLidCellOpt(#KToken(#token("LidCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLidCellOpt, var__845) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLidCellOpt(`<lid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'lid'_GT_',(varK0_846)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isLidCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_847)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisMsidCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMsidCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isMsidCellOpt(#KToken(#token("MsidCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsidCellOpt, var__848) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsidCellOpt(`<msid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msid'_GT_',(varK0_849)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMsidCellOpt(noMsidCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoMsidCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsidCellOpt(#KToken(#token("MsidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsidCell, var__850) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsidCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_851)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisListenCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisListenCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isListenCellFragment(`<listen>-fragment`(K0,K1,K2,K3,K4))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isChanCellOpt(K0),isVarsCellOpt(K1)),isNumCellOpt(K2)),isLidCellOpt(K3)),isMsidCellOpt(K4)) ensures #token("true","Bool") []|}*)
| ((KApply5(Lbl'_LT_'listen'_GT_Hyph'fragment,(varK0_852 :: []),(varK1_853 :: []),(varK2_854 :: []),(varK3_855 :: []),(varK4_856 :: [])) :: [])) when (((((((((isTrue (evalisChanCellOpt((varK0_852 :: [])) config (-1)))) && ((isTrue (evalisVarsCellOpt((varK1_853 :: [])) config (-1)))))) && ((isTrue (evalisNumCellOpt((varK2_854 :: [])) config (-1)))))) && ((isTrue (evalisLidCellOpt((varK3_855 :: [])) config (-1)))))) && ((isTrue (evalisMsidCellOpt((varK4_856 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isListenCellFragment(#KToken(#token("ListenCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListenCellFragment, var__857) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListenCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_858)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalmakeList (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblmakeList and sort = 
SortList in match c with 
| _ -> try LIST.hook_make c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'LSqB'_'_LT_Hyph'undef'RSqB' (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'_LT_Hyph'undef'RSqB' and sort = 
SortMap in match c with 
| _ -> try MAP.hook_remove c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'unlock'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'unlock'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_unlock c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_andThenBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_andThenBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_andThen c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_andThenBool__BOOL`(K,#token("true","Bool"))=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(1aad8125a2ba7fcbd3c40ac487b7dc776993e9d167ac20f0210e14213abec45f) contentStartColumn(8) contentStartLine(308) org.kframework.attributes.Location(Location(308,8,308,37)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK_859) :: []),((Bool true) :: [])) when true && (true) -> (varK_859 :: [])
(*{| rule `` `_andThenBool__BOOL`(#token("false","Bool"),_3)=>#token("false","Bool")`` requires isBool(_3) ensures #token("true","Bool") [UNIQUE_ID(34b51d1bff350ce2cd8b17b3af8effdfcf390962b57189087f3cc3b6bbe59cbc) contentStartColumn(8) contentStartLine(309) org.kframework.attributes.Location(Location(309,8,309,36)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_3_860) :: [])) when true && (true) -> ((Bool false) :: [])
(*{| rule `` `_andThenBool__BOOL`(#token("true","Bool"),K)=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(b058439c1adf0de5fb7afd07d638d2cda247a4344cbdc14812da46c5db5499df) contentStartColumn(8) contentStartLine(307) org.kframework.attributes.Location(Location(307,8,307,37)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varK_861) :: [])) when true && (true) -> (varK_861 :: [])
(*{| rule `` `_andThenBool__BOOL`(_7,#token("false","Bool"))=>#token("false","Bool")`` requires isBool(_7) ensures #token("true","Bool") [UNIQUE_ID(d0a6502b90e84545c10a45f7199b2a6d77f52d0841c63dcc792b60073f300e07) contentStartColumn(8) contentStartLine(310) org.kframework.attributes.Location(Location(310,8,310,36)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_7_862) :: []),((Bool false) :: [])) when true && (true) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'parseInModule (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'parseInModule and sort = 
SortKItem in match c with 
| _ -> try IO.hook_parseInModule c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Hash'system (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'system and sort = 
SortKItem in match c with 
| _ -> try IO.hook_system c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitRidCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitRidCell and sort = 
SortRidCell in match c with 
(*{| rule ``initRidCell(.KList)=>`<rid>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(3561d3b88a67e9bd037c0dc9b68fea8312337f821012b100a286bfcf95278318) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'rid'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitRidCell : k Lazy.t = lazy (evalinitRidCell () interned_bottom (-1))
let evalisList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisList and sort = 
SortBool in match c with 
| [List (s,_,_)] when (s = SortList) -> [Bool true]
(*{| rule ``isList(#KToken(#token("List","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortList, var__863) :: [])) -> ((Bool true) :: [])
(*{| rule ``isList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_864)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendsCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendsCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isSendsCellOpt(`<sends>`(K0))=>#token("true","Bool")`` requires isSendCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sends'_GT_',(varK0_865 :: [])) :: [])) when (isTrue (evalisSendCellBag((varK0_865 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendsCellOpt(noSendsCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoSendsCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCellOpt(#KToken(#token("SendsCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCellOpt, var__866) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCellOpt(#KToken(#token("SendsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCell, var__867) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_868)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisReceivesCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReceivesCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isReceivesCellOpt(#KToken(#token("ReceivesCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReceivesCellOpt, var__869) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReceivesCellOpt(`<receives>`(K0))=>#token("true","Bool")`` requires isRecCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'receives'_GT_',(varK0_870 :: [])) :: [])) when (isTrue (evalisRecCellBag((varK0_870 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isReceivesCellOpt(noReceivesCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoReceivesCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReceivesCellOpt(#KToken(#token("ReceivesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReceivesCell, var__871) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReceivesCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_872)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTuplespaceCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTuplespaceCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isTuplespaceCellFragment(#KToken(#token("TuplespaceCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCellFragment, var__873) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellFragment(`<tuplespace>-fragment`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSendsCellOpt(K0),isReceivesCellOpt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'tuplespace'_GT_Hyph'fragment,(varK0_874 :: []),(varK1_875 :: [])) :: [])) when (((isTrue (evalisSendsCellOpt((varK0_874 :: [])) config (-1)))) && ((isTrue (evalisReceivesCellOpt((varK1_875 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_876)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_gt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k * k) (config: k) (guard: int) : k = let lbl = 
Lblreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replace c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replace(_,_,_,_)_STRING`(Source,_12,_13,_27)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(_13)),isString(_12)),`_==Int_`(_27,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(ba5c0b944155cbe05f7bf6c179a2ed1e9baea983ec5099e8449b31926e9b3069) contentStartColumn(8) contentStartLine(574) org.kframework.attributes.Location(Location(574,8,574,49)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varSource_877) :: []),((String _ as var_12_878) :: []),((String _ as var_13_879) :: []),((Int _ as var_27_880) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsEqls'Int_((var_27_880 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_877 :: [])
(*{| rule `` `replace(_,_,_,_)_STRING`(Source,_12,_13,_0)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(_13)),isString(_12)),`_==Int_`(_0,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(ba5c0b944155cbe05f7bf6c179a2ed1e9baea983ec5099e8449b31926e9b3069) contentStartColumn(8) contentStartLine(574) org.kframework.attributes.Location(Location(574,8,574,49)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varSource_881) :: []),((String _ as var_12_882) :: []),((String _ as var_13_883) :: []),((Int _ as var_0_884) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsEqls'Int_((var_0_884 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_881 :: [])
(*{| rule `` `replace(_,_,_,_)_STRING`(Source,ToReplace,Replacement,Count)=>`_+String__STRING`(`_+String__STRING`(substrString(Source,#token("0","Int"),findString(Source,ToReplace,#token("0","Int"))),Replacement),`replace(_,_,_,_)_STRING`(substrString(Source,`_+Int_`(findString(Source,ToReplace,#token("0","Int")),lengthString(ToReplace)),lengthString(Source)),ToReplace,Replacement,`_-Int__INT`(Count,#token("1","Int"))))`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isString(Replacement),isString(Source)),isInt(Count)),isString(ToReplace)),`_>Int__INT`(Count,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(00a2618b5ebbb57a911b7f2ad35458f6b3e1d5cb14ef1e49468e9833e93e48c0) contentStartColumn(8) contentStartLine(570) org.kframework.attributes.Location(Location(570,8,573,30)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_885) :: []),((String _ as varToReplace_886) :: []),((String _ as varReplacement_887) :: []),((Int _ as varCount_888) :: [])) when ((((((((true) && (true))) && (true))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varCount_888 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'String__STRING(((eval_'Plus'String__STRING(((evalsubstrString((varSource_885 :: []),((Lazy.force int0) :: []),((evalfindString((varSource_885 :: []),(varToReplace_886 :: []),((Lazy.force int0) :: [])) config (-1)))) config (-1))),(varReplacement_887 :: [])) config (-1))),((evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING(((evalsubstrString((varSource_885 :: []),((eval_'Plus'Int_(((evalfindString((varSource_885 :: []),(varToReplace_886 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToReplace_886 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_885 :: [])) config (-1)))) config (-1))),(varToReplace_886 :: []),(varReplacement_887 :: []),((eval_'Hyph'Int__INT((varCount_888 :: []),((Lazy.force int1) :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize4 c)))])
let eval_'_LT_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_'Int__INT and sort = 
SortBool in match c with 
| _ -> try INT.hook_lt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING and sort = 
SortInt in match c with 
| _ -> try STRING.hook_countAllOccurrences c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `countAllOccurrences(_,_)_STRING`(Source,ToCount)=>#token("0","Int")`` requires `_andBool_`(`_andBool_`(isString(ToCount),isString(Source)),`_<Int__INT`(findString(Source,ToCount,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(cb338e251d0b5234f4abbf9c60008d68dc9dd3a8b1a5a410ed51f56d43a7b5af) contentStartColumn(8) contentStartLine(558) org.kframework.attributes.Location(Location(558,8,559,59)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_889) :: []),((String _ as varToCount_890) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_LT_'Int__INT(((evalfindString((varSource_889 :: []),(varToCount_890 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((Lazy.force int0) :: [])
(*{| rule `` `countAllOccurrences(_,_)_STRING`(Source,ToCount)=>`_+Int_`(#token("1","Int"),`countAllOccurrences(_,_)_STRING`(substrString(Source,`_+Int_`(findString(Source,ToCount,#token("0","Int")),lengthString(ToCount)),lengthString(Source)),ToCount))`` requires `_andBool_`(`_andBool_`(isString(ToCount),isString(Source)),`_>=Int__INT`(findString(Source,ToCount,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(9834f2e2641cb2ecf28969acaab73619cb181f1a69c9cfef5102f907edaeb71e) contentStartColumn(8) contentStartLine(560) org.kframework.attributes.Location(Location(560,8,561,60)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_891) :: []),((String _ as varToCount_892) :: [])) when ((((true) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT(((evalfindString((varSource_891 :: []),(varToCount_892 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((Lazy.force int1) :: []),((evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING(((evalsubstrString((varSource_891 :: []),((eval_'Plus'Int_(((evalfindString((varSource_891 :: []),(varToCount_892 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToCount_892 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_891 :: [])) config (-1)))) config (-1))),(varToCount_892 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replaceAll c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replaceAll(_,_,_)_STRING`(Source,ToReplace,Replacement)=>`replace(_,_,_,_)_STRING`(Source,ToReplace,Replacement,`countAllOccurrences(_,_)_STRING`(Source,ToReplace))`` requires `_andBool_`(`_andBool_`(isString(Replacement),isString(Source)),isString(ToReplace)) ensures #token("true","Bool") [UNIQUE_ID(3358d86b83068ab68fc4f0ed02513db149426f011866db38ff0a5015e8fee30d) contentStartColumn(8) contentStartLine(575) org.kframework.attributes.Location(Location(575,8,575,154)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varSource_893) :: []),((String _ as varToReplace_894) :: []),((String _ as varReplacement_895) :: [])) when ((((true) && (true))) && (true)) && (true) -> ((evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING((varSource_893 :: []),(varToReplace_894 :: []),(varReplacement_895 :: []),((evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING((varSource_893 :: []),(varToReplace_894 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalisBindList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBindList and sort = 
SortBool in match c with 
(*{| rule ``isBindList(#KToken(#token("Bind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBind, var__896) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(#KToken(#token("Pbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbind, var__897) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(#KToken(#token("Lbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbinds, var__898) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(#KToken(#token("Rbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbind, var__899) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_<-__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varK0_900 :: []),(varK1_901 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_900 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_901 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(#KToken(#token("Lbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbind, var__902) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLbind(K0),isLbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_903 :: []),(varK1_904 :: [])) :: [])) when (((isTrue (evalisLbind((varK0_903 :: [])) config (-1)))) && ((isTrue (evalisLbind((varK1_904 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isRbind(K0),isRbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_905 :: []),(varK1_906 :: [])) :: [])) when (((isTrue (evalisRbind((varK0_905 :: [])) config (-1)))) && ((isTrue (evalisRbinds((varK1_906 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(#KToken(#token("BindList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBindList, var__907) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(#KToken(#token("Binds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBinds, var__908) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(#KToken(#token("Pbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPbinds, var__909) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_<!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Bang'__GRHO'Hyph'SYNTAX,(varK0_910 :: []),(varK1_911 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_910 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_911 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isPbind(K0),isPbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_912 :: []),(varK1_913 :: [])) :: [])) when (((isTrue (evalisPbind((varK0_912 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varK1_913 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_<=__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varK0_914 :: []),(varK1_915 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_914 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_915 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLbind(K0),isLbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_916 :: []),(varK1_917 :: [])) :: [])) when (((isTrue (evalisLbind((varK0_916 :: [])) config (-1)))) && ((isTrue (evalisLbinds((varK1_917 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(#KToken(#token("Rbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbinds, var__918) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isPbind(K0),isPbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_919 :: []),(varK1_920 :: [])) :: [])) when (((isTrue (evalisPbind((varK0_919 :: [])) config (-1)))) && ((isTrue (evalisPbind((varK1_920 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isRbind(K0),isRbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_921 :: []),(varK1_922 :: [])) :: [])) when (((isTrue (evalisRbind((varK0_921 :: [])) config (-1)))) && ((isTrue (evalisRbind((varK1_922 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_923)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisForgCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisForgCell and sort = 
SortBool in match c with 
(*{| rule ``isForgCell(#KToken(#token("ForgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortForgCell, var__924) :: [])) -> ((Bool true) :: [])
(*{| rule ``isForgCell(`<forg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'forg'_GT_',(varK0_925)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isForgCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_926)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitChanCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitChanCell and sort = 
SortChanCell in match c with 
(*{| rule ``initChanCell(.KList)=>`<chan>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(c68af9f4d7642ce4cb4bb81f55398ceae39be4279cea0e104ffb02c541a3c9e0) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'chan'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitChanCell : k Lazy.t = lazy (evalinitChanCell () interned_bottom (-1))
let eval_'Xor_'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Xor_'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_pow c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitRnumCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitRnumCell and sort = 
SortRnumCell in match c with 
(*{| rule ``initRnumCell(.KList)=>`<rnum>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(1373c23a332f6ff01e9f5d5f47b67100e8f6c5c70d0b29613ba65f7ec1cbff45) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'rnum'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitRnumCell : k Lazy.t = lazy (evalinitRnumCell () interned_bottom (-1))
let evalisRidCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRidCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isRidCellOpt(#KToken(#token("RidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRidCell, var__927) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRidCellOpt(#KToken(#token("RidCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRidCellOpt, var__928) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRidCellOpt(noRidCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoRidCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRidCellOpt(`<rid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rid'_GT_',(varK0_929)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isRidCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_930)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisReceivesCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReceivesCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isReceivesCellFragment(`<receives>-fragment`(K0))=>#token("true","Bool")`` requires isRecCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'receives'_GT_Hyph'fragment,(varK0_931 :: [])) :: [])) when (isTrue (evalisRecCellBag((varK0_931 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isReceivesCellFragment(#KToken(#token("ReceivesCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReceivesCellFragment, var__932) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReceivesCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_933)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT_'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_lt c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'_GT_'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_gt c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_>String__STRING`(S1,S2)=>`_<String__STRING`(S2,S1)`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(85f6517ce0e2b7074d495585267afa5b0502e09d5bf63c57fb6c6d77174aa16a) contentStartColumn(8) contentStartLine(550) org.kframework.attributes.Location(Location(550,8,550,52)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_934) :: []),((String _ as varS2_935) :: [])) when ((true) && (true)) && (true) -> ((eval_'_LT_'String__STRING((varS2_935 :: []),(varS1_934 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisSidCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSidCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isSidCellOpt(#KToken(#token("SidCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSidCellOpt, var__936) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSidCellOpt(noSidCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoSidCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSidCellOpt(#KToken(#token("SidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSidCell, var__937) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSidCellOpt(`<sid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sid'_GT_',(varK0_938)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSidCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_939)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendsCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendsCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isSendsCellFragment(#KToken(#token("SendsCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCellFragment, var__940) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendsCellFragment(`<sends>-fragment`(K0))=>#token("true","Bool")`` requires isSendCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sends'_GT_Hyph'fragment,(varK0_941 :: [])) :: [])) when (isTrue (evalisSendCellBag((varK0_941 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendsCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_942)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitLengthCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitLengthCell and sort = 
SortLengthCell in match c with 
(*{| rule ``initLengthCell(.KList)=>`<length>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(22ff624848a1198a86ab7cff587d15ef7385c904e420c851bf40c470a686e552) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'length'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitLengthCell : k Lazy.t = lazy (evalinitLengthCell () interned_bottom (-1))
let evalisKConfigVar (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKConfigVar and sort = 
SortBool in match c with 
(*{| rule ``isKConfigVar(#KToken(#token("KConfigVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKConfigVar, var__943) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKConfigVar(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_944)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRnumCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRnumCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isRnumCellOpt(noRnumCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoRnumCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRnumCellOpt(#KToken(#token("RnumCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRnumCellOpt, var__945) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRnumCellOpt(#KToken(#token("RnumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRnumCell, var__946) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRnumCellOpt(`<rnum>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rnum'_GT_',(varK0_947)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isRnumCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_948)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRhoMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRhoMap and sort = 
SortBool in match c with 
(*{| rule ``isRhoMap(#KToken(#token("RhoMap","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoMap, var__949) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRhoMap(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isRhoKVPairs(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_950 :: [])) :: [])) when (isTrue (evalisRhoKVPairs((varK0_950 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRhoMap(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_951)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSend (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSend and sort = 
SortBool in match c with 
(*{| rule ``isSend(#KToken(#token("UnconsumableSend","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUnconsumableSend, var__952) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSend(`_!!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isRhoTuple(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'BangBang'__GRHO'Hyph'SYNTAX,(varK0_953 :: []),(varK1_954 :: [])) :: [])) when (((isTrue (evalisName((varK0_953 :: [])) config (-1)))) && ((isTrue (evalisRhoTuple((varK1_954 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSend(`_!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isRhoTuple(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Bang'__GRHO'Hyph'SYNTAX,(varK0_955 :: []),(varK1_956 :: [])) :: [])) when (((isTrue (evalisName((varK0_955 :: [])) config (-1)))) && ((isTrue (evalisRhoTuple((varK1_956 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSend(#KToken(#token("ConsumableSend","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortConsumableSend, var__957) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSend(#KToken(#token("Send","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSend, var__958) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSend(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_959)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKResult (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKResult and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
| [Int _] -> [Bool true]
(*{| rule ``isKResult(`*__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Star'__GRHO'Hyph'SYNTAX,(varK0_960 :: [])) :: [])) when (isTrue (evalisName((varK0_960 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__961) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("KResult","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKResult, var__962) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("Uri","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUri, var__963) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("Name","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortName, var__964) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__965) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("NameVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNameVar, var__966) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_967 :: [])) :: [])) when (isTrue (evalisName((varK0_967 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_968 :: [])) :: [])) when (isTrue (evalisProc((varK0_968 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("Ground","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortGround, var__969) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("Eval","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortEval, var__970) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(`unforgeable(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblunforgeable'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((Int _ as varK0_971) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(`@__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_AT_'__GRHO'Hyph'SYNTAX,(varK0_972 :: [])) :: [])) when (isTrue (evalisProc((varK0_972 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBinds(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_973 :: [])) :: [])) when (isTrue (evalisBinds((varK0_973 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(`uri(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isString(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbluri'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((String _ as varK0_974) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__975) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBind(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_976 :: [])) :: [])) when (isTrue (evalisBind((varK0_976 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKResult(#KToken(#token("Bool","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBool, var__977) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKResult(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_978)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisWhereCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWhereCell and sort = 
SortBool in match c with 
(*{| rule ``isWhereCell(#KToken(#token("WhereCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhereCell, var__979) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhereCell(`<where>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'where'_GT_',(varK0_980)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isWhereCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_981)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRidCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRidCell and sort = 
SortBool in match c with 
(*{| rule ``isRidCell(`<rid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rid'_GT_',(varK0_982)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isRidCell(#KToken(#token("RidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRidCell, var__983) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRidCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_984)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRnumCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRnumCell and sort = 
SortBool in match c with 
(*{| rule ``isRnumCell(`<rnum>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rnum'_GT_',(varK0_985)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isRnumCell(#KToken(#token("RnumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRnumCell, var__986) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRnumCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_987)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisReactCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReactCell and sort = 
SortBool in match c with 
(*{| rule ``isReactCell(#KToken(#token("ReactCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactCell, var__988) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactCell(`<react>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'react'_GT_',(varK0_989)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isReactCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_990)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisReactionCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReactionCell and sort = 
SortBool in match c with 
(*{| rule ``isReactionCell(#KToken(#token("ReactionCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactionCell, var__991) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactionCell(`<reaction>`(K0,K1,K2,K3,K4,K5,K6))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isWhoCell(K0),isWhatCell(K1)),isWhereCell(K2)),isRidCell(K3)),isRnumCell(K4)),isReactCell(K5)),isForgCell(K6)) ensures #token("true","Bool") []|}*)
| ((KApply7(Lbl'_LT_'reaction'_GT_',(varK0_992 :: []),(varK1_993 :: []),(varK2_994 :: []),(varK3_995 :: []),(varK4_996 :: []),(varK5_997 :: []),(varK6_998 :: [])) :: [])) when (((((((((((((isTrue (evalisWhoCell((varK0_992 :: [])) config (-1)))) && ((isTrue (evalisWhatCell((varK1_993 :: [])) config (-1)))))) && ((isTrue (evalisWhereCell((varK2_994 :: [])) config (-1)))))) && ((isTrue (evalisRidCell((varK3_995 :: [])) config (-1)))))) && ((isTrue (evalisRnumCell((varK4_996 :: [])) config (-1)))))) && ((isTrue (evalisReactCell((varK5_997 :: [])) config (-1)))))) && ((isTrue (evalisForgCell((varK6_998 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isReactionCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_999)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisCell and sort = 
SortBool in match c with 
(*{| rule ``isCell(#KToken(#token("SidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSidCell, var__1000) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<msg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msg'_GT_',(varK0_1001)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("MlidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMlidCell, var__1002) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<threads>`(K0))=>#token("true","Bool")`` requires isThreadCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'threads'_GT_',(varK0_1003 :: [])) :: [])) when (isTrue (evalisThreadCellBag((varK0_1003 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("Cell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortCell, var__1004) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCell, var__1005) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("RecCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCell, var__1006) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<where>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'where'_GT_',(varK0_1007)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ChanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortChanCell, var__1008) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<rec>`(K0,K1,K2,K3,K4,K5,K6,K7))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isIdCell(K0),isLengthCell(K1)),isContCell(K2)),isStateCell(K3)),isMatchCell(K4)),isTypeCell(K5)),isNomoCell(K6)),isListensCell(K7)) ensures #token("true","Bool") []|}*)
| ((KApply8(Lbl'_LT_'rec'_GT_',(varK0_1009 :: []),(varK1_1010 :: []),(varK2_1011 :: []),(varK3_1012 :: []),(varK4_1013 :: []),(varK5_1014 :: []),(varK6_1015 :: []),(varK7_1016 :: [])) :: [])) when (((((((((((((((isTrue (evalisIdCell((varK0_1009 :: [])) config (-1)))) && ((isTrue (evalisLengthCell((varK1_1010 :: [])) config (-1)))))) && ((isTrue (evalisContCell((varK2_1011 :: [])) config (-1)))))) && ((isTrue (evalisStateCell((varK3_1012 :: [])) config (-1)))))) && ((isTrue (evalisMatchCell((varK4_1013 :: [])) config (-1)))))) && ((isTrue (evalisTypeCell((varK5_1014 :: [])) config (-1)))))) && ((isTrue (evalisNomoCell((varK6_1015 :: [])) config (-1)))))) && ((isTrue (evalisListensCell((varK7_1016 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("RnumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRnumCell, var__1017) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<send>`(K0,K1,K2,K3,K4,K5))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isSchanCell(K0),isMsgCell(K1)),isTupleCell(K2)),isStypeCell(K3)),isSidCell(K4)),isMlidCell(K5)) ensures #token("true","Bool") []|}*)
| ((KApply6(Lbl'_LT_'send'_GT_',(varK0_1018 :: []),(varK1_1019 :: []),(varK2_1020 :: []),(varK3_1021 :: []),(varK4_1022 :: []),(varK5_1023 :: [])) :: [])) when (((((((((((isTrue (evalisSchanCell((varK0_1018 :: [])) config (-1)))) && ((isTrue (evalisMsgCell((varK1_1019 :: [])) config (-1)))))) && ((isTrue (evalisTupleCell((varK2_1020 :: [])) config (-1)))))) && ((isTrue (evalisStypeCell((varK3_1021 :: [])) config (-1)))))) && ((isTrue (evalisSidCell((varK4_1022 :: [])) config (-1)))))) && ((isTrue (evalisMlidCell((varK5_1023 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_1024)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__1025) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<state>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'state'_GT_',(varK0_1026)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("VarsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortVarsCell, var__1027) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("WhoCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhoCell, var__1028) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<stype>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'stype'_GT_',(varK0_1029)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<rid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rid'_GT_',(varK0_1030)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<mlid>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varK0_1031) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<vars>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'vars'_GT_',(varK0_1032)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<sends>`(K0))=>#token("true","Bool")`` requires isSendCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sends'_GT_',(varK0_1033 :: [])) :: [])) when (isTrue (evalisSendCellBag((varK0_1033 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("WhereCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhereCell, var__1034) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ReceivesCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReceivesCell, var__1035) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<match>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'match'_GT_',(varK0_1036)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ContCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortContCell, var__1037) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ReactCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactCell, var__1038) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("MatchCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMatchCell, var__1039) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<length>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'length'_GT_',(varK0_1040)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<what>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'what'_GT_',(varK0_1041)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<thread>`(K0))=>#token("true","Bool")`` requires isKCell(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'thread'_GT_',(varK0_1042 :: [])) :: [])) when (isTrue (evalisKCell((varK0_1042 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<listen>`(K0,K1,K2,K3,K4))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isChanCell(K0),isVarsCell(K1)),isNumCell(K2)),isLidCell(K3)),isMsidCell(K4)) ensures #token("true","Bool") []|}*)
| ((KApply5(Lbl'_LT_'listen'_GT_',(varK0_1043 :: []),(varK1_1044 :: []),(varK2_1045 :: []),(varK3_1046 :: []),(varK4_1047 :: [])) :: [])) when (((((((((isTrue (evalisChanCell((varK0_1043 :: [])) config (-1)))) && ((isTrue (evalisVarsCell((varK1_1044 :: [])) config (-1)))))) && ((isTrue (evalisNumCell((varK2_1045 :: [])) config (-1)))))) && ((isTrue (evalisLidCell((varK3_1046 :: [])) config (-1)))))) && ((isTrue (evalisMsidCell((varK4_1047 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ReactionCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactionCell, var__1048) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<listens>`(K0))=>#token("true","Bool")`` requires isListenCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'listens'_GT_',(varK0_1049 :: [])) :: [])) when (isTrue (evalisListenCellBag((varK0_1049 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<lid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'lid'_GT_',(varK0_1050)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("SendsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendsCell, var__1051) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TypeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTypeCell, var__1052) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("LidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLidCell, var__1053) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("WhatCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhatCell, var__1054) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ListensCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListensCell, var__1055) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<receives>`(K0))=>#token("true","Bool")`` requires isRecCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'receives'_GT_',(varK0_1056 :: [])) :: [])) when (isTrue (evalisRecCellBag((varK0_1056 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<id>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'id'_GT_',(varK0_1057)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<num>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'num'_GT_',(varK0_1058)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<msid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msid'_GT_',(varK0_1059)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<rnum>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'rnum'_GT_',(varK0_1060)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<forg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'forg'_GT_',(varK0_1061)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("StypeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStypeCell, var__1062) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<tuplespace>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSendsCell(K0),isReceivesCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'tuplespace'_GT_',(varK0_1063 :: []),(varK1_1064 :: [])) :: [])) when (((isTrue (evalisSendsCell((varK0_1063 :: [])) config (-1)))) && ((isTrue (evalisReceivesCell((varK1_1064 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ThreadCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCell, var__1065) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ThreadsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadsCell, var__1066) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("RidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRidCell, var__1067) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("StateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCell, var__1068) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<chan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'chan'_GT_',(varK0_1069)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("NumCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNumCell, var__1070) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<react>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'react'_GT_',(varK0_1071)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<cont>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'cont'_GT_',(varK0_1072)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<who>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'who'_GT_',(varK0_1073)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("MsgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsgCell, var__1074) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("MsidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsidCell, var__1075) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<T>`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isThreadsCell(K0),isTuplespaceCell(K1)),isReactionCell(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'T'_GT_',(varK0_1076 :: []),(varK1_1077 :: []),(varK2_1078 :: [])) :: [])) when (((((isTrue (evalisThreadsCell((varK0_1076 :: [])) config (-1)))) && ((isTrue (evalisTuplespaceCell((varK1_1077 :: [])) config (-1)))))) && ((isTrue (evalisReactionCell((varK2_1078 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ListenCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListenCell, var__1079) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<type>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'type'_GT_',(varK0_1080)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("SchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSchanCell, var__1081) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TuplespaceCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCell, var__1082) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<nomo>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as varK0_1083) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("ForgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortForgCell, var__1084) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<reaction>`(K0,K1,K2,K3,K4,K5,K6))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isWhoCell(K0),isWhatCell(K1)),isWhereCell(K2)),isRidCell(K3)),isRnumCell(K4)),isReactCell(K5)),isForgCell(K6)) ensures #token("true","Bool") []|}*)
| ((KApply7(Lbl'_LT_'reaction'_GT_',(varK0_1085 :: []),(varK1_1086 :: []),(varK2_1087 :: []),(varK3_1088 :: []),(varK4_1089 :: []),(varK5_1090 :: []),(varK6_1091 :: [])) :: [])) when (((((((((((((isTrue (evalisWhoCell((varK0_1085 :: [])) config (-1)))) && ((isTrue (evalisWhatCell((varK1_1086 :: [])) config (-1)))))) && ((isTrue (evalisWhereCell((varK2_1087 :: [])) config (-1)))))) && ((isTrue (evalisRidCell((varK3_1088 :: [])) config (-1)))))) && ((isTrue (evalisRnumCell((varK4_1089 :: [])) config (-1)))))) && ((isTrue (evalisReactCell((varK5_1090 :: [])) config (-1)))))) && ((isTrue (evalisForgCell((varK6_1091 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("SendCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCell, var__1092) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("NomoCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNomoCell, var__1093) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("LengthCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLengthCell, var__1094) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("TupleCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTupleCell, var__1095) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<sid>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'sid'_GT_',(varK0_1096)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(#KToken(#token("IdCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIdCell, var__1097) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCell(`<tuple>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'tuple'_GT_',(varK0_1098)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(`<schan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'schan'_GT_',(varK0_1099)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1100)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalvalues (c: k) (config: k) (guard: int) : k = let lbl = 
Lblvalues and sort = 
SortList in match c with 
| _ -> try MAP.hook_values c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitStypeCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitStypeCell and sort = 
SortStypeCell in match c with 
(*{| rule ``initStypeCell(.KList)=>`<stype>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(0ec7daaece8180c493380d1fa5fb7866004daa74ec28b795f6ba9818ee8f30b8) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'stype'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitStypeCell : k Lazy.t = lazy (evalinitStypeCell () interned_bottom (-1))
let evalList'Coln'get (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'get and sort = 
SortKItem in match c with 
| _ -> try LIST.hook_get c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'lstat'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'lstat'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_lstat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalSendCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblSendCellBagItem and sort = 
SortSendCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isKCellOpt(#KToken(#token("KCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCellOpt, var__1101) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(#KToken(#token("KCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKCell, var__1102) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(`<k>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'k'_GT_',(varK0_1103)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(noKCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoKCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1104)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisThreadCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isThreadCellFragment(`<thread>-fragment`(K0))=>#token("true","Bool")`` requires isKCellOpt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'thread'_GT_Hyph'fragment,(varK0_1105 :: [])) :: [])) when (isTrue (evalisKCellOpt((varK0_1105 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadCellFragment(#KToken(#token("ThreadCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadCellFragment, var__1106) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1107)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStateCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStateCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isStateCellOpt(#KToken(#token("StateCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCellOpt, var__1108) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStateCellOpt(noStateCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoStateCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStateCellOpt(#KToken(#token("StateCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStateCell, var__1109) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStateCellOpt(`<state>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'state'_GT_',(varK0_1110)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStateCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1111)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitLidCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitLidCell and sort = 
SortLidCell in match c with 
(*{| rule ``initLidCell(.KList)=>`<lid>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(027232db5b8e794168adf6cbc2122616382ff20217a4619c645d0641d8598bc0) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'lid'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitLidCell : k Lazy.t = lazy (evalinitLidCell () interned_bottom (-1))
let evalisListensCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisListensCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isListensCellOpt(`<listens>`(K0))=>#token("true","Bool")`` requires isListenCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'listens'_GT_',(varK0_1112 :: [])) :: [])) when (isTrue (evalisListenCellBag((varK0_1112 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isListensCellOpt(#KToken(#token("ListensCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListensCellOpt, var__1113) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListensCellOpt(#KToken(#token("ListensCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListensCell, var__1114) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListensCellOpt(noListensCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoListensCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListensCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1115)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTuplespaceCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTuplespaceCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isTuplespaceCellOpt(#KToken(#token("TuplespaceCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCellOpt, var__1116) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellOpt(#KToken(#token("TuplespaceCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTuplespaceCell, var__1117) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellOpt(`<tuplespace>`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isSendsCell(K0),isReceivesCell(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'_LT_'tuplespace'_GT_',(varK0_1118 :: []),(varK1_1119 :: [])) :: [])) when (((isTrue (evalisSendsCell((varK0_1118 :: [])) config (-1)))) && ((isTrue (evalisReceivesCell((varK1_1119 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellOpt(noTuplespaceCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoTuplespaceCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTuplespaceCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1120)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'List (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'List and sort = 
SortList in match c with 
| _ -> try LIST.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'List : k Lazy.t = lazy (eval'Stop'List () interned_bottom (-1))
let evalisSendCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendCell and sort = 
SortBool in match c with 
(*{| rule ``isSendCell(`<send>`(K0,K1,K2,K3,K4,K5))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isSchanCell(K0),isMsgCell(K1)),isTupleCell(K2)),isStypeCell(K3)),isSidCell(K4)),isMlidCell(K5)) ensures #token("true","Bool") []|}*)
| ((KApply6(Lbl'_LT_'send'_GT_',(varK0_1121 :: []),(varK1_1122 :: []),(varK2_1123 :: []),(varK3_1124 :: []),(varK4_1125 :: []),(varK5_1126 :: [])) :: [])) when (((((((((((isTrue (evalisSchanCell((varK0_1121 :: [])) config (-1)))) && ((isTrue (evalisMsgCell((varK1_1122 :: [])) config (-1)))))) && ((isTrue (evalisTupleCell((varK2_1123 :: [])) config (-1)))))) && ((isTrue (evalisStypeCell((varK3_1124 :: [])) config (-1)))))) && ((isTrue (evalisSidCell((varK4_1125 :: [])) config (-1)))))) && ((isTrue (evalisMlidCell((varK5_1126 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendCell(#KToken(#token("SendCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCell, var__1127) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1128)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalrandInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblrandInt and sort = 
SortInt in match c with 
| _ -> try INT.hook_rand c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'configuration_K'Hyph'REFLECTION (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'configuration_K'Hyph'REFLECTION and sort = 
SortK in match c with 
| _ -> try KREFLECTION.hook_configuration c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let evalisFloat (c: k) (config: k) (guard: int) : k = let lbl = 
LblisFloat and sort = 
SortBool in match c with 
| [Float _] -> [Bool true]
(*{| rule ``isFloat(#KToken(#token("Float","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortFloat, var__1129) :: [])) -> ((Bool true) :: [])
(*{| rule ``isFloat(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1130)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'close'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'close'LPar'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_close c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalkeys_list'LPar'_'RPar'_MAP (c: k) (config: k) (guard: int) : k = let lbl = 
Lblkeys_list'LPar'_'RPar'_MAP and sort = 
SortList in match c with 
| _ -> try MAP.hook_keys_list c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitTypeCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitTypeCell and sort = 
SortTypeCell in match c with 
(*{| rule ``initTypeCell(.KList)=>`<type>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(246b6711c40b97cdb86b003308da8dcbc073a0d97bde535f2d583b6d7022a453) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'type'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitTypeCell : k Lazy.t = lazy (evalinitTypeCell () interned_bottom (-1))
let evalString2Id (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Id and sort = 
SortId in match c with 
| _ -> try STRING.hook_string2token c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalInt2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblInt2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_int2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalfreshId (c: k) (config: k) (guard: int) : k = let lbl = 
LblfreshId and sort = 
SortId in match c with 
(*{| rule ``freshId(I)=>`String2Id`(`_+String__STRING`(#token("\"_\"","String"),`Int2String`(I)))`` requires isInt(I) ensures #token("true","Bool") [UNIQUE_ID(cb89ef33f1b27d7db53de8a3c240cc3b944a9a0a9559c32b1b97c7bfec87bfa2) contentStartColumn(8) contentStartLine(745) org.kframework.attributes.Location(Location(745,8,745,62)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_1131) :: [])) when true && (true) -> ((evalString2Id(((eval_'Plus'String__STRING(((String "_") :: []),((evalInt2String((varI_1131 :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalchrChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblchrChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_chr c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSchanCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSchanCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isSchanCellOpt(#KToken(#token("SchanCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSchanCell, var__1132) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSchanCellOpt(noSchanCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoSchanCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSchanCellOpt(`<schan>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'schan'_GT_',(varK0_1133)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isSchanCellOpt(#KToken(#token("SchanCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSchanCellOpt, var__1134) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSchanCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1135)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_orElseBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_orElseBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_orElse c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_orElseBool__BOOL`(#token("false","Bool"),K)=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(efdd958595a7fecb549f4368ba6097862b61abc903a6d33684803a3a0043bda8) contentStartColumn(8) contentStartLine(324) org.kframework.attributes.Location(Location(324,8,324,37)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varK_1136) :: [])) when true && (true) -> (varK_1136 :: [])
(*{| rule `` `_orElseBool__BOOL`(_5,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_5) ensures #token("true","Bool") [UNIQUE_ID(2882f8b0a388fe37313c6b828cb9039a9838984f56e50b5095476c319b3dfbd8) contentStartColumn(8) contentStartLine(323) org.kframework.attributes.Location(Location(323,8,323,33)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_5_1137) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orElseBool__BOOL`(#token("true","Bool"),_9)=>#token("true","Bool")`` requires isBool(_9) ensures #token("true","Bool") [UNIQUE_ID(6ea998be2fb9b60b7964c4b4939293b6fecb47f52a53031c6227218949cf22f0) contentStartColumn(8) contentStartLine(322) org.kframework.attributes.Location(Location(322,8,322,33)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as var_9_1138) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_orElseBool__BOOL`(K,#token("false","Bool"))=>K`` requires isBool(K) ensures #token("true","Bool") [UNIQUE_ID(8c7774b237a73a62ffd53be8d97ac73eb2f040dcf41983ea18840919b416d291) contentStartColumn(8) contentStartLine(325) org.kframework.attributes.Location(Location(325,8,325,37)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varK_1139) :: []),((Bool false) :: [])) when true && (true) -> (varK_1139 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Slsh'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Slsh'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_tdiv c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_divInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_divInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_ediv c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_divInt__INT`(I1,I2)=>`_/Int__INT`(`_-Int__INT`(I1,`_modInt__INT`(I1,I2)),I2)`` requires `_andBool_`(`_andBool_`(isInt(I1),isInt(I2)),`_=/=Int__INT`(I2,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(b7fc8e019ea9840ee8c5e9232d39d7944e010f117308f672e92891325002610e) contentStartColumn(8) contentStartLine(388) org.kframework.attributes.Location(Location(388,8,389,23)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((Int _ as varI1_1140) :: []),((Int _ as varI2_1141) :: [])) when ((((true) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varI2_1141 :: []),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Slsh'Int__INT(((eval_'Hyph'Int__INT((varI1_1140 :: []),((eval_modInt__INT((varI1_1140 :: []),(varI2_1141 :: [])) config (-1)))) config (-1))),(varI2_1141 :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisWhereCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWhereCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isWhereCellOpt(#KToken(#token("WhereCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhereCellOpt, var__1142) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhereCellOpt(`<where>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'where'_GT_',(varK0_1143)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isWhereCellOpt(#KToken(#token("WhereCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhereCell, var__1144) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhereCellOpt(noWhereCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoWhereCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhereCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1145)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_ThreadCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_ThreadCellBag_ and sort = 
SortThreadCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalList'Coln'range (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'range and sort = 
SortList in match c with 
| _ -> try LIST.hook_range c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalinitTupleCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitTupleCell and sort = 
SortTupleCell in match c with 
(*{| rule ``initTupleCell(.KList)=>`<tuple>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(8d61c5db487e428ef5c79957248c12546318f5c9822c1d70bcde924ff1734b53) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'tuple'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitTupleCell : k Lazy.t = lazy (evalinitTupleCell () interned_bottom (-1))
let evalisMsgCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMsgCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isMsgCellOpt(#KToken(#token("MsgCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsgCellOpt, var__1146) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsgCellOpt(`<msg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'msg'_GT_',(varK0_1147)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMsgCellOpt(noMsgCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoMsgCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsgCellOpt(#KToken(#token("MsgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMsgCell, var__1148) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMsgCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1149)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStypeCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStypeCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isStypeCellOpt(`<stype>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'stype'_GT_',(varK0_1150)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStypeCellOpt(#KToken(#token("StypeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStypeCell, var__1151) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStypeCellOpt(noStypeCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoStypeCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStypeCellOpt(#KToken(#token("StypeCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStypeCellOpt, var__1152) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStypeCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1153)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisMlidCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMlidCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isMlidCellOpt(#KToken(#token("MlidCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMlidCellOpt, var__1154) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMlidCellOpt(`<mlid>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varK0_1155) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMlidCellOpt(#KToken(#token("MlidCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMlidCell, var__1156) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMlidCellOpt(noMlidCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoMlidCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMlidCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1157)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisSendCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisSendCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isSendCellFragment(`<send>-fragment`(K0,K1,K2,K3,K4,K5))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isSchanCellOpt(K0),isMsgCellOpt(K1)),isTupleCellOpt(K2)),isStypeCellOpt(K3)),isSidCellOpt(K4)),isMlidCellOpt(K5)) ensures #token("true","Bool") []|}*)
| ((KApply6(Lbl'_LT_'send'_GT_Hyph'fragment,(varK0_1158 :: []),(varK1_1159 :: []),(varK2_1160 :: []),(varK3_1161 :: []),(varK4_1162 :: []),(varK5_1163 :: [])) :: [])) when (((((((((((isTrue (evalisSchanCellOpt((varK0_1158 :: [])) config (-1)))) && ((isTrue (evalisMsgCellOpt((varK1_1159 :: [])) config (-1)))))) && ((isTrue (evalisTupleCellOpt((varK2_1160 :: [])) config (-1)))))) && ((isTrue (evalisStypeCellOpt((varK3_1161 :: [])) config (-1)))))) && ((isTrue (evalisSidCellOpt((varK4_1162 :: [])) config (-1)))))) && ((isTrue (evalisMlidCellOpt((varK5_1163 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isSendCellFragment(#KToken(#token("SendCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSendCellFragment, var__1164) :: [])) -> ((Bool true) :: [])
(*{| rule ``isSendCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1165)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisReactionCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReactionCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isReactionCellOpt(noReactionCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoReactionCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactionCellOpt(#KToken(#token("ReactionCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactionCellOpt, var__1166) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactionCellOpt(#KToken(#token("ReactionCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactionCell, var__1167) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactionCellOpt(`<reaction>`(K0,K1,K2,K3,K4,K5,K6))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isWhoCell(K0),isWhatCell(K1)),isWhereCell(K2)),isRidCell(K3)),isRnumCell(K4)),isReactCell(K5)),isForgCell(K6)) ensures #token("true","Bool") []|}*)
| ((KApply7(Lbl'_LT_'reaction'_GT_',(varK0_1168 :: []),(varK1_1169 :: []),(varK2_1170 :: []),(varK3_1171 :: []),(varK4_1172 :: []),(varK5_1173 :: []),(varK6_1174 :: [])) :: [])) when (((((((((((((isTrue (evalisWhoCell((varK0_1168 :: [])) config (-1)))) && ((isTrue (evalisWhatCell((varK1_1169 :: [])) config (-1)))))) && ((isTrue (evalisWhereCell((varK2_1170 :: [])) config (-1)))))) && ((isTrue (evalisRidCell((varK3_1171 :: [])) config (-1)))))) && ((isTrue (evalisRnumCell((varK4_1172 :: [])) config (-1)))))) && ((isTrue (evalisReactCell((varK5_1173 :: [])) config (-1)))))) && ((isTrue (evalisForgCell((varK6_1174 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isReactionCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1175)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalupdateMap (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblupdateMap and sort = 
SortMap in match c with 
| _ -> try MAP.hook_updateAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisJoinList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisJoinList and sort = 
SortBool in match c with 
(*{| rule ``isJoinList(`{[_;_]}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(varK0_1176 :: []),((Int _ as varK1_1177) :: [])) :: [])) when (((isTrue (evalisProc((varK0_1176 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isJoinList(#KToken(#token("JoinList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortJoinList, var__1178) :: [])) -> ((Bool true) :: [])
(*{| rule ``isJoinList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1179)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'stype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortInt in match c with 
(*{| rule `` `#stype(_)_AUXFUN-SYNTAX`(`_!__GRHO-SYNTAX`(_85,tuple(_86)))=>#token("0","Int")`` requires `_andBool_`(isName(_85),isProcList(_86)) ensures #token("true","Bool") [UNIQUE_ID(1e7940d1be27e084a9270773c6b3a74f51d651153e2f4f492368944a9b4571fe) contentStartColumn(8) contentStartLine(98) org.kframework.attributes.Location(Location(98,8,98,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Bang'__GRHO'Hyph'SYNTAX,(var_85_1180 :: []),(KApply1(Lbltuple,(var_86_1181 :: [])) :: [])) :: [])) when (((isTrue (evalisName((var_85_1180 :: [])) config (-1)))) && ((isTrue (evalisProcList((var_86_1181 :: [])) config (-1))))) && (true) -> ((Lazy.force int0) :: [])
(*{| rule `` `#stype(_)_AUXFUN-SYNTAX`(`_!!__GRHO-SYNTAX`(_57,tuple(_58)))=>#token("1","Int")`` requires `_andBool_`(isProcList(_58),isName(_57)) ensures #token("true","Bool") [UNIQUE_ID(8d41cfddd70f4f5cee54292db6cb90b463dbdb90928e5f4ba9b2bbd6333e64d6) contentStartColumn(8) contentStartLine(99) org.kframework.attributes.Location(Location(99,8,99,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'BangBang'__GRHO'Hyph'SYNTAX,(var_57_1182 :: []),(KApply1(Lbltuple,(var_58_1183 :: [])) :: [])) :: [])) when (((isTrue (evalisProcList((var_58_1183 :: [])) config (-1)))) && ((isTrue (evalisName((var_57_1182 :: [])) config (-1))))) && (true) -> ((Lazy.force int1) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'EqlsSlshEqls'K_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'K_ and sort = 
SortBool in match c with 
| _ -> try KEQUAL.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=K_`(K1,K2)=>`notBool_`(`_==K_`(K1,K2))`` requires `_andBool_`(isK(K1),isK(K2)) ensures #token("true","Bool") [UNIQUE_ID(0221882a8af3c088550dce160a5b2e48351ef2431aad518a72f3d65258a4066d) contentStartColumn(8) contentStartLine(763) org.kframework.attributes.Location(Location(763,8,763,45)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varK1_1184),(varK2_1185)) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'K_((varK1_1184),(varK2_1185)) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'lock'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'lock'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_lock c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalfillList (c: k * k * k * k) (config: k) (guard: int) : k = let lbl = 
LblfillList and sort = 
SortList in match c with 
| _ -> try LIST.hook_fill c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize4 c)))])
let evalinitForgCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitForgCell and sort = 
SortForgCell in match c with 
(*{| rule ``initForgCell(.KList)=>`<forg>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(100c71f920415851d5cfbb82b246eeb3ee658548bd06e063210cb356c015a816) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'forg'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitForgCell : k Lazy.t = lazy (evalinitForgCell () interned_bottom (-1))
let evalisRecCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecCell and sort = 
SortBool in match c with 
(*{| rule ``isRecCell(`<rec>`(K0,K1,K2,K3,K4,K5,K6,K7))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isIdCell(K0),isLengthCell(K1)),isContCell(K2)),isStateCell(K3)),isMatchCell(K4)),isTypeCell(K5)),isNomoCell(K6)),isListensCell(K7)) ensures #token("true","Bool") []|}*)
| ((KApply8(Lbl'_LT_'rec'_GT_',(varK0_1186 :: []),(varK1_1187 :: []),(varK2_1188 :: []),(varK3_1189 :: []),(varK4_1190 :: []),(varK5_1191 :: []),(varK6_1192 :: []),(varK7_1193 :: [])) :: [])) when (((((((((((((((isTrue (evalisIdCell((varK0_1186 :: [])) config (-1)))) && ((isTrue (evalisLengthCell((varK1_1187 :: [])) config (-1)))))) && ((isTrue (evalisContCell((varK2_1188 :: [])) config (-1)))))) && ((isTrue (evalisStateCell((varK3_1189 :: [])) config (-1)))))) && ((isTrue (evalisMatchCell((varK4_1190 :: [])) config (-1)))))) && ((isTrue (evalisTypeCell((varK5_1191 :: [])) config (-1)))))) && ((isTrue (evalisNomoCell((varK6_1192 :: [])) config (-1)))))) && ((isTrue (evalisListensCell((varK7_1193 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecCell(#KToken(#token("RecCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCell, var__1194) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1195)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_List_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_List_ and sort = 
SortList in match c with 
| _ -> try LIST.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisMultiRec (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMultiRec and sort = 
SortBool in match c with 
(*{| rule ``isMultiRec(`for(_){_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBinds(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_1196 :: []),(varK1_1197 :: [])) :: [])) when (((isTrue (evalisBinds((varK0_1196 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_1197 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isMultiRec(#KToken(#token("MultiRec","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMultiRec, var__1198) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMultiRec(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1199)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_open c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'PipeHyph_GT_'_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'PipeHyph_GT_'_ and sort = 
SortMap in match c with 
| _ -> try MAP.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_xorBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_xorBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_xor c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_xorBool__BOOL`(B,B)=>#token("false","Bool")`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(70684b52edf7d3194cd01f6e5714b364631e8d96267df666bb689e5380e13cc4) contentStartColumn(8) contentStartLine(314) org.kframework.attributes.Location(Location(314,8,314,38)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_1200) :: []),((Bool _ as varB_1201) :: [])) when true && (((compare_kitem varB_1200 varB_1201) = 0) && true) -> ((Bool false) :: [])
(*{| rule `` `_xorBool__BOOL`(B,#token("false","Bool"))=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(2eae84ae7b21312fecde18860149de73365b819e65aada5f952fc5b9101ae014) contentStartColumn(8) contentStartLine(313) org.kframework.attributes.Location(Location(313,8,313,38)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_1202) :: []),((Bool false) :: [])) when true && (true) -> (varB_1202 :: [])
(*{| rule `` `_xorBool__BOOL`(#token("false","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(0b888132027262073a3306d90f4a55b0a4ea27984cd77fccd8bf29cd48efb665) contentStartColumn(8) contentStartLine(312) org.kframework.attributes.Location(Location(312,8,312,38)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as varB_1203) :: [])) when true && (true) -> (varB_1203 :: [])
(*{| rule `` `_xorBool__BOOL`(B1,B2)=>`notBool_`(`_==Bool__BOOL`(B1,B2))`` requires `_andBool_`(isBool(B2),isBool(B1)) ensures #token("true","Bool") [UNIQUE_ID(1c34683a46438798498c925345e696fc017c0665504d0877c44e540d820b1ec7) contentStartColumn(8) contentStartLine(315) org.kframework.attributes.Location(Location(315,8,315,57)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB1_1204) :: []),((Bool _ as varB2_1205) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Bool__BOOL((varB1_1204 :: []),(varB2_1205 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisMatchCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMatchCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isMatchCellOpt(noMatchCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoMatchCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMatchCellOpt(#KToken(#token("MatchCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMatchCellOpt, var__1206) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMatchCellOpt(#KToken(#token("MatchCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMatchCell, var__1207) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMatchCellOpt(`<match>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'match'_GT_',(varK0_1208)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isMatchCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1209)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'Hyph'Map__MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hyph'Map__MAP and sort = 
SortMap in match c with 
| _ -> try MAP.hook_difference c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisRhoSet (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRhoSet and sort = 
SortBool in match c with 
(*{| rule ``isRhoSet(`Set(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblSet'LPar'_'RPar'_GRHO'Hyph'SYNTAX,(varK0_1210 :: [])) :: [])) when (isTrue (evalisProcList((varK0_1210 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRhoSet(#KToken(#token("RhoSet","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoSet, var__1211) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRhoSet(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1212)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitReactCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitReactCell and sort = 
SortReactCell in match c with 
(*{| rule ``initReactCell(.KList)=>`<react>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(4cbc8d1a55cf7251268c51aa72b1f39f04f89470730c039918710f059cec9562) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'react'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitReactCell : k Lazy.t = lazy (evalinitReactCell () interned_bottom (-1))
let eval'Stop'RecCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'RecCellBag and sort = 
SortRecCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'RecCellBag : k Lazy.t = lazy (eval'Stop'RecCellBag () interned_bottom (-1))
let eval'Hash'sort (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'sort and sort = 
SortString in match c with 
| _ -> try KREFLECTION.hook_sort c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'open'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'open'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#open(_)_K-IO`(S)=>`#open(_,_)_K-IO`(S,#token("\"r+\"","String"))`` requires isString(S) ensures #token("true","Bool") [UNIQUE_ID(ed7ee74167faa7f8e3a152e9e495d112a67407097a0bb306ac17e2ce4bebf100) contentStartColumn(8) contentStartLine(902) org.kframework.attributes.Location(Location(902,8,902,48)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS_1213) :: [])) when true && (true) -> ((eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO((varS_1213 :: []),((String "r+") :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_ListenCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_ListenCellBag_ and sort = 
SortListenCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'LSqB'_'RSqB'_SUBSTITUTION (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'RSqB'_SUBSTITUTION and sort = 
SortK in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisPar (c: k) (config: k) (guard: int) : k = let lbl = 
LblisPar and sort = 
SortBool in match c with 
(*{| rule ``isPar(`_|__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isProc(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Pipe'__GRHO'Hyph'SYNTAX,(varK0_1214 :: []),(varK1_1215 :: [])) :: [])) when (((isTrue (evalisProc((varK0_1214 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_1215 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isPar(#KToken(#token("Par","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortPar, var__1216) :: [])) -> ((Bool true) :: [])
(*{| rule ``isPar(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1217)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_replaceFirst c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `replaceFirst(_,_,_)_STRING`(Source,ToReplace,_18)=>Source`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Source),isString(_18)),isString(ToReplace)),`_<Int__INT`(findString(Source,ToReplace,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(4320c56cb2a4f4c70e2500eb8f33dab497a5bb09aa847e4e0c0ae496ab671040) contentStartColumn(8) contentStartLine(566) org.kframework.attributes.Location(Location(566,8,567,57)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_1218) :: []),((String _ as varToReplace_1219) :: []),((String _ as var_18_1220) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'_LT_'Int__INT(((evalfindString((varSource_1218 :: []),(varToReplace_1219 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> (varSource_1218 :: [])
(*{| rule `` `replaceFirst(_,_,_)_STRING`(Source,ToReplace,Replacement)=>`_+String__STRING`(`_+String__STRING`(substrString(Source,#token("0","Int"),findString(Source,ToReplace,#token("0","Int"))),Replacement),substrString(Source,`_+Int_`(findString(Source,ToReplace,#token("0","Int")),lengthString(ToReplace)),lengthString(Source)))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isString(Replacement),isString(Source)),isString(ToReplace)),`_>=Int__INT`(findString(Source,ToReplace,#token("0","Int")),#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(4941a93fc06d65bd530ddbfcaabb498d40e247effd559cda2d85e65d73692b70) contentStartColumn(8) contentStartLine(563) org.kframework.attributes.Location(Location(563,8,565,66)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varSource_1221) :: []),((String _ as varToReplace_1222) :: []),((String _ as varReplacement_1223) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'_GT_Eqls'Int__INT(((evalfindString((varSource_1221 :: []),(varToReplace_1222 :: []),((Lazy.force int0) :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1))))) && (true) -> ((eval_'Plus'String__STRING(((eval_'Plus'String__STRING(((evalsubstrString((varSource_1221 :: []),((Lazy.force int0) :: []),((evalfindString((varSource_1221 :: []),(varToReplace_1222 :: []),((Lazy.force int0) :: [])) config (-1)))) config (-1))),(varReplacement_1223 :: [])) config (-1))),((evalsubstrString((varSource_1221 :: []),((eval_'Plus'Int_(((evalfindString((varSource_1221 :: []),(varToReplace_1222 :: []),((Lazy.force int0) :: [])) config (-1))),((evallengthString((varToReplace_1222 :: [])) config (-1)))) config (-1))),((evallengthString((varSource_1221 :: [])) config (-1)))) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Stop'ListenCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'ListenCellBag and sort = 
SortListenCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'ListenCellBag : k Lazy.t = lazy (eval'Stop'ListenCellBag () interned_bottom (-1))
let evalinitListensCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitListensCell and sort = 
SortListensCell in match c with 
(*{| rule ``initListensCell(.KList)=>`<listens>`(`.ListenCellBag`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(6fe80efb98d17155cb555122007cad00ea5535b1bf9379dc9cb19ecab463a37a) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'listens'_GT_',((Lazy.force const'Stop'ListenCellBag))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitListensCell : k Lazy.t = lazy (evalinitListensCell () interned_bottom (-1))
let eval'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_putc c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisThreadsCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadsCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isThreadsCellOpt(#KToken(#token("ThreadsCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadsCell, var__1224) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadsCellOpt(`<threads>`(K0))=>#token("true","Bool")`` requires isThreadCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'threads'_GT_',(varK0_1225 :: [])) :: [])) when (isTrue (evalisThreadCellBag((varK0_1225 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadsCellOpt(#KToken(#token("ThreadsCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadsCellOpt, var__1226) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadsCellOpt(noThreadsCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoThreadsCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadsCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1227)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'Map (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'Map and sort = 
SortMap in match c with 
| _ -> try MAP.hook_unit c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'Map : k Lazy.t = lazy (eval'Stop'Map () interned_bottom (-1))
let eval'Hash'logToFile (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'logToFile and sort = 
SortK in match c with 
| _ -> try IO.hook_log c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortString in match c with 
| _ -> try IO.hook_read c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitMlidCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitMlidCell and sort = 
SortMlidCell in match c with 
(*{| rule ``initMlidCell(.KList)=>`<mlid>`(`.Set`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(b71f8ccd8548db06f350987725c46f54ab9554e1bebf3a97809b6b4a5fbd975c) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'mlid'_GT_',((Lazy.force const'Stop'Set))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitMlidCell : k Lazy.t = lazy (evalinitMlidCell () interned_bottom (-1))
let evalisNameVar (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNameVar and sort = 
SortBool in match c with 
(*{| rule ``isNameVar(#KToken(#token("NameVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNameVar, var__1228) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNameVar(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__1229) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNameVar(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1230)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalId2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblId2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_token2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitVarsCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitVarsCell and sort = 
SortVarsCell in match c with 
(*{| rule ``initVarsCell(.KList)=>`<vars>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(7da20d6e2dfb5893d5d24c5fac7c8599d0c4372876401bb4288333f4befacd4e) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'vars'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitVarsCell : k Lazy.t = lazy (evalinitVarsCell () interned_bottom (-1))
let evalinitNumCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitNumCell and sort = 
SortNumCell in match c with 
(*{| rule ``initNumCell(.KList)=>`<num>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(90b10c05f39c477f284fb64c1365868c2a912155b2815ff31f26968ea8b679e7) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'num'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitNumCell : k Lazy.t = lazy (evalinitNumCell () interned_bottom (-1))
let evalinitMsidCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitMsidCell and sort = 
SortMsidCell in match c with 
(*{| rule ``initMsidCell(.KList)=>`<msid>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(7dcdf93442757952d0990877a7342f07717318dd6adf129668abdfdb69dc3302) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'msid'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitMsidCell : k Lazy.t = lazy (evalinitMsidCell () interned_bottom (-1))
let evalinitListenCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitListenCell and sort = 
SortListenCell in match c with 
(*{| rule ``initListenCell(.KList)=>`<listen>`(initChanCell(.KList),initVarsCell(.KList),initNumCell(.KList),initLidCell(.KList),initMsidCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(4142cc9100da2f47f8f1b114f8ead145c21e0fb115d5336bf0dbc77b224d03a5) initializer()]|}*)
| () -> (KApply5(Lbl'_LT_'listen'_GT_',((Lazy.force constinitChanCell)),((Lazy.force constinitVarsCell)),((Lazy.force constinitNumCell)),((Lazy.force constinitLidCell)),((Lazy.force constinitMsidCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitListenCell : k Lazy.t = lazy (evalinitListenCell () interned_bottom (-1))
let evalisContCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisContCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isContCellOpt(noContCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoContCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isContCellOpt(#KToken(#token("ContCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortContCellOpt, var__1231) :: [])) -> ((Bool true) :: [])
(*{| rule ``isContCellOpt(#KToken(#token("ContCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortContCell, var__1232) :: [])) -> ((Bool true) :: [])
(*{| rule ``isContCellOpt(`<cont>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'cont'_GT_',(varK0_1233)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isContCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1234)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalfreshInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblfreshInt and sort = 
SortInt in match c with 
(*{| rule ``freshInt(I)=>I`` requires isInt(I) ensures #token("true","Bool") [UNIQUE_ID(d7221da1fa6b633137e79279efd265a289ea7e8496612615f43546422d446bc4) contentStartColumn(8) contentStartLine(412) org.kframework.attributes.Location(Location(412,8,412,28)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI_1235) :: [])) when true && (true) -> (varI_1235 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let freshFunction (sort: string) (config: k) (counter: Z.t) : k = match sort with 
| "Id" -> (evalfreshId ([Int counter]) config (-1))
| "Int" -> (evalfreshInt ([Int counter]) config (-1))
| _ -> invalid_arg ("Cannot find fresh function for sort " ^ sort)let eval'Hash'fresh (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'fresh and sort = 
SortKItem in match c with 
| _ -> try KREFLECTION.hook_fresh c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalMap'Coln'choice (c: k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'choice and sort = 
SortKItem in match c with 
| _ -> try MAP.hook_choice c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_impliesBool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_impliesBool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_implies c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_impliesBool__BOOL`(_2,#token("true","Bool"))=>#token("true","Bool")`` requires isBool(_2) ensures #token("true","Bool") [UNIQUE_ID(7fdeea13463fa86d05e4d5bfb9e9c627b90ab57930f712fef1bfc08543a87d74) contentStartColumn(8) contentStartLine(329) org.kframework.attributes.Location(Location(329,8,329,39)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as var_2_1236) :: []),((Bool true) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_impliesBool__BOOL`(#token("true","Bool"),B)=>B`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(278435b95efb1a1ce04f6d701b12e6438c3cf3aee8019b41ea93b05755d379d7) contentStartColumn(8) contentStartLine(327) org.kframework.attributes.Location(Location(327,8,327,36)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool true) :: []),((Bool _ as varB_1237) :: [])) when true && (true) -> (varB_1237 :: [])
(*{| rule `` `_impliesBool__BOOL`(#token("false","Bool"),_0)=>#token("true","Bool")`` requires isBool(_0) ensures #token("true","Bool") [UNIQUE_ID(3497d026ef9468fdac7e6b5de6841fad0118b17ca073ba25af4c5d8573a167b2) contentStartColumn(8) contentStartLine(328) org.kframework.attributes.Location(Location(328,8,328,40)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool false) :: []),((Bool _ as var_0_1238) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule `` `_impliesBool__BOOL`(B,#token("false","Bool"))=>`notBool_`(B)`` requires isBool(B) ensures #token("true","Bool") [UNIQUE_ID(0129e06009c7500aefab482e1bc8e348010c6bd01acd15725172192c05a70831) contentStartColumn(8) contentStartLine(330) org.kframework.attributes.Location(Location(330,8,330,45)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB_1239) :: []),((Bool false) :: [])) when true && (true) -> ([Bool ((not ((isTrue [varB_1239]))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'getc'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'getc'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_getc c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'chanlist'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'chanlist'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortSet in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalmaxInt'LPar'_'Comm'_'RPar'_INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblmaxInt'LPar'_'Comm'_'RPar'_INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_max c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitReceivesCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitReceivesCell and sort = 
SortReceivesCell in match c with 
(*{| rule ``initReceivesCell(.KList)=>`<receives>`(`.RecCellBag`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(150c32e3a295e9b3882bd410d58f765b4c0832b7277e7d5a933d0fafea18226d) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'receives'_GT_',((Lazy.force const'Stop'RecCellBag))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitReceivesCell : k Lazy.t = lazy (evalinitReceivesCell () interned_bottom (-1))
let evalisListenCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisListenCell and sort = 
SortBool in match c with 
(*{| rule ``isListenCell(#KToken(#token("ListenCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListenCell, var__1240) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListenCell(`<listen>`(K0,K1,K2,K3,K4))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isChanCell(K0),isVarsCell(K1)),isNumCell(K2)),isLidCell(K3)),isMsidCell(K4)) ensures #token("true","Bool") []|}*)
| ((KApply5(Lbl'_LT_'listen'_GT_',(varK0_1241 :: []),(varK1_1242 :: []),(varK2_1243 :: []),(varK3_1244 :: []),(varK4_1245 :: [])) :: [])) when (((((((((isTrue (evalisChanCell((varK0_1241 :: [])) config (-1)))) && ((isTrue (evalisVarsCell((varK1_1242 :: [])) config (-1)))))) && ((isTrue (evalisNumCell((varK2_1243 :: [])) config (-1)))))) && ((isTrue (evalisLidCell((varK3_1244 :: [])) config (-1)))))) && ((isTrue (evalisMsidCell((varK4_1245 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isListenCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1246)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Tild'Int__INT (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Tild'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_not c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT_Eqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_le c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_<=String__STRING`(S1,S2)=>`notBool_`(`_<String__STRING`(S2,S1))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2c1110a97c0d904a19992e4eac695692515cb703f5d689aaa6945290a696d662) contentStartColumn(8) contentStartLine(549) org.kframework.attributes.Location(Location(549,8,549,63)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_1247) :: []),((String _ as varS2_1248) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'_LT_'String__STRING((varS2_1248 :: []),(varS1_1247 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalordChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblordChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_ord c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitIdCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitIdCell and sort = 
SortIdCell in match c with 
(*{| rule ``initIdCell(.KList)=>`<id>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(c80a2693757dd33297ed22a12529422737ac2723cd9eba64f1f7ce4f8d4949ff) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'id'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitIdCell : k Lazy.t = lazy (evalinitIdCell () interned_bottom (-1))
let evalrfindString (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblrfindString and sort = 
SortInt in match c with 
| _ -> try STRING.hook_rfind c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let rec evalrfindChar (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblrfindChar and sort = 
SortInt in match c with 
| _ -> try STRING.hook_rfindChar c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule ``rfindChar(_16,#token("\"\"","String"),_17)=>#token("-1","Int")`` requires `_andBool_`(isInt(_17),isString(_16)) ensures #token("true","Bool") [UNIQUE_ID(04cb290eea9d7c93a48f761cab20217a689222a306098df1120917b013944330) contentStartColumn(8) contentStartLine(556) org.kframework.attributes.Location(Location(556,8,556,33)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as var_16_1249) :: []),((String "") :: []),((Int _ as var_17_1250) :: [])) when ((true) && (true)) && (true) -> ((Lazy.force int'Hyph'1) :: [])
(*{| rule ``rfindChar(S1,S2,I)=>`maxInt(_,_)_INT`(rfindString(S1,substrString(S2,#token("0","Int"),#token("1","Int")),I),rfindChar(S1,substrString(S2,#token("1","Int"),lengthString(S2)),I))`` requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(I),isString(S2)),isString(S1)),`_=/=String__STRING`(S2,#token("\"\"","String"))) ensures #token("true","Bool") [UNIQUE_ID(dea96adb63c0d77626a51f08fb7a6daf76e3a7b8d0205f5285542c1160f2ddeb) contentStartColumn(8) contentStartLine(555) org.kframework.attributes.Location(Location(555,8,555,182)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (((String _ as varS1_1251) :: []),((String _ as varS2_1252) :: []),((Int _ as varI_1253) :: [])) when ((((((true) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'String__STRING((varS2_1252 :: []),((String "") :: [])) config (-1))))) && (true) -> ((evalmaxInt'LPar'_'Comm'_'RPar'_INT(((evalrfindString((varS1_1251 :: []),((evalsubstrString((varS2_1252 :: []),((Lazy.force int0) :: []),((Lazy.force int1) :: [])) config (-1))),(varI_1253 :: [])) config (-1))),((evalrfindChar((varS1_1251 :: []),((evalsubstrString((varS2_1252 :: []),((Lazy.force int1) :: []),((evallengthString((varS2_1252 :: [])) config (-1)))) config (-1))),(varI_1253 :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalListenCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblListenCellBagItem and sort = 
SortListenCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_Map_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_Map_ and sort = 
SortMap in match c with 
| _ -> try MAP.hook_concat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisWhatCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisWhatCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isWhatCellOpt(noWhatCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoWhatCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhatCellOpt(#KToken(#token("WhatCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhatCellOpt, var__1254) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhatCellOpt(#KToken(#token("WhatCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortWhatCell, var__1255) :: [])) -> ((Bool true) :: [])
(*{| rule ``isWhatCellOpt(`<what>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'what'_GT_',(varK0_1256)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isWhatCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1257)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisReactCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReactCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isReactCellOpt(#KToken(#token("ReactCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactCell, var__1258) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactCellOpt(#KToken(#token("ReactCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactCellOpt, var__1259) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactCellOpt(`<react>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'react'_GT_',(varK0_1260)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isReactCellOpt(noReactCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoReactCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1261)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisForgCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisForgCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isForgCellOpt(`<forg>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'forg'_GT_',(varK0_1262)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isForgCellOpt(noForgCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoForgCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isForgCellOpt(#KToken(#token("ForgCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortForgCellOpt, var__1263) :: [])) -> ((Bool true) :: [])
(*{| rule ``isForgCellOpt(#KToken(#token("ForgCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortForgCell, var__1264) :: [])) -> ((Bool true) :: [])
(*{| rule ``isForgCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1265)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisReactionCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReactionCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isReactionCellFragment(`<reaction>-fragment`(K0,K1,K2,K3,K4,K5,K6))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isWhoCellOpt(K0),isWhatCellOpt(K1)),isWhereCellOpt(K2)),isRidCellOpt(K3)),isRnumCellOpt(K4)),isReactCellOpt(K5)),isForgCellOpt(K6)) ensures #token("true","Bool") []|}*)
| ((KApply7(Lbl'_LT_'reaction'_GT_Hyph'fragment,(varK0_1266 :: []),(varK1_1267 :: []),(varK2_1268 :: []),(varK3_1269 :: []),(varK4_1270 :: []),(varK5_1271 :: []),(varK6_1272 :: [])) :: [])) when (((((((((((((isTrue (evalisWhoCellOpt((varK0_1266 :: [])) config (-1)))) && ((isTrue (evalisWhatCellOpt((varK1_1267 :: [])) config (-1)))))) && ((isTrue (evalisWhereCellOpt((varK2_1268 :: [])) config (-1)))))) && ((isTrue (evalisRidCellOpt((varK3_1269 :: [])) config (-1)))))) && ((isTrue (evalisRnumCellOpt((varK4_1270 :: [])) config (-1)))))) && ((isTrue (evalisReactCellOpt((varK5_1271 :: [])) config (-1)))))) && ((isTrue (evalisForgCellOpt((varK6_1272 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isReactionCellFragment(#KToken(#token("ReactionCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReactionCellFragment, var__1273) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReactionCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1274)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitSchanCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSchanCell and sort = 
SortSchanCell in match c with 
(*{| rule ``initSchanCell(.KList)=>`<schan>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(fb3f04378e2de704012940ecf0be5d176bf31eff6f4ae8799fe8998e5c601d32) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'schan'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSchanCell : k Lazy.t = lazy (evalinitSchanCell () interned_bottom (-1))
let rec eval'Hash'lengths'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'lengths'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortProcs in match c with 
(*{| rule `` `#lengths(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bnum(_)_AUXFUN-SYNTAX`(B),`#bnum(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isRbind(C),isRbind(B)) ensures #token("true","Bool") [UNIQUE_ID(6f404fff6e63663af391417199642d1db5093f80fdc0fdd60c3a1163dfd2bdbe) contentStartColumn(8) contentStartLine(214) org.kframework.attributes.Location(Location(214,8,214,63)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_1275 :: []),(varC_1276 :: [])) :: [])) when (((isTrue (evalisRbind((varC_1276 :: [])) config (-1)))) && ((isTrue (evalisRbind((varB_1275 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1275 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_1276 :: [])) config (-1)))) :: [])
(*{| rule `` `#lengths(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bnum(_)_AUXFUN-SYNTAX`(B),`#bnum(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isPbind(C),isPbind(B)) ensures #token("true","Bool") [UNIQUE_ID(0117a712e60527d1dac2332ca2a6419ae9b8ea1a8ea6cccf44884bba831fcb71) contentStartColumn(8) contentStartLine(217) org.kframework.attributes.Location(Location(217,8,217,63)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_1277 :: []),(varC_1278 :: [])) :: [])) when (((isTrue (evalisPbind((varC_1278 :: [])) config (-1)))) && ((isTrue (evalisPbind((varB_1277 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1277 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_1278 :: [])) config (-1)))) :: [])
(*{| rule `` `#lengths(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bnum(_)_AUXFUN-SYNTAX`(B),`#lengths(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isPbind(B),isPbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(ac42ccec29a9a177721c4fabd8c19397524d00cb91ea7aaa1ac3793f7ba56e1d) contentStartColumn(8) contentStartLine(218) org.kframework.attributes.Location(Location(218,8,218,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_1279 :: []),(varC_1280 :: [])) :: [])) when (((isTrue (evalisPbind((varB_1279 :: [])) config (-1)))) && ((isTrue (evalisPbinds((varC_1280 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1279 :: [])) config (-1))),((eval'Hash'lengths'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_1280 :: [])) config (-1)))) :: [])
(*{| rule `` `#lengths(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bnum(_)_AUXFUN-SYNTAX`(B),`#lengths(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isLbinds(C),isLbind(B)) ensures #token("true","Bool") [UNIQUE_ID(95e44d9c2bfc30ef1add7a3b5717257be83194a5c34f8dabcece2246468218cd) contentStartColumn(8) contentStartLine(212) org.kframework.attributes.Location(Location(212,8,212,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_1281 :: []),(varC_1282 :: [])) :: [])) when (((isTrue (evalisLbinds((varC_1282 :: [])) config (-1)))) && ((isTrue (evalisLbind((varB_1281 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1281 :: [])) config (-1))),((eval'Hash'lengths'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_1282 :: [])) config (-1)))) :: [])
(*{| rule `` `#lengths(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bnum(_)_AUXFUN-SYNTAX`(B),`#lengths(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isRbind(B),isRbinds(C)) ensures #token("true","Bool") [UNIQUE_ID(87ad524092dcf3501894082bf8cf6b3180d6cf78fad675840ada80495d681c62) contentStartColumn(8) contentStartLine(215) org.kframework.attributes.Location(Location(215,8,215,65)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_1283 :: []),(varC_1284 :: [])) :: [])) when (((isTrue (evalisRbind((varB_1283 :: [])) config (-1)))) && ((isTrue (evalisRbinds((varC_1284 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1283 :: [])) config (-1))),((eval'Hash'lengths'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_1284 :: [])) config (-1)))) :: [])
(*{| rule `` `#lengths(_)_AUXFUN-SYNTAX`(`_;__GRHO-SYNTAX`(B,C))=>`_,__GRHO-SYNTAX`(`#bnum(_)_AUXFUN-SYNTAX`(B),`#bnum(_)_AUXFUN-SYNTAX`(C))`` requires `_andBool_`(isLbind(B),isLbind(C)) ensures #token("true","Bool") [UNIQUE_ID(15a043262ffb2f47edaaf3eeb6667dac71a4c03e8a5f30af752c00046a1f0da5) contentStartColumn(8) contentStartLine(211) org.kframework.attributes.Location(Location(211,8,211,63)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varB_1285 :: []),(varC_1286 :: [])) :: [])) when (((isTrue (evalisLbind((varB_1285 :: [])) config (-1)))) && ((isTrue (evalisLbind((varC_1286 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1285 :: [])) config (-1))),((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((varC_1286 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evaldirectionalityChar (c: k) (config: k) (guard: int) : k = let lbl = 
LbldirectionalityChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_directionality c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalFloat2String (c: k) (config: k) (guard: int) : k = let lbl = 
LblFloat2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_float2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'opendir'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'opendir'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_opendir c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortNames in match c with 
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(A,B)=>`_,__GRHO-SYNTAX`(A,B)`` requires `_andBool_`(isName(A),isNames(B)) ensures #token("true","Bool") [UNIQUE_ID(dcbf29257690184c45636a522e642cdd2c968d7f19fbe671356554e29367fe23) contentStartColumn(8) contentStartLine(137) org.kframework.attributes.Location(Location(137,8,137,53)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_1287 :: []),(varB_1288 :: [])) when (((isTrue (evalisName((varA_1287 :: [])) config (-1)))) && ((isTrue (evalisNames((varB_1288 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1287 :: []),(varB_1288 :: [])) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(A,B),C)=>`_,__GRHO-SYNTAX`(A,`#append(_;_)_AUXFUN-SYNTAX`(B,C))`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),isName(C)) ensures #token("true","Bool") [UNIQUE_ID(8591ef781e6ec6fbcee913778ba88e340c8e2ed9468a4d3091250c1d3c17a1a5) contentStartColumn(8) contentStartLine(135) org.kframework.attributes.Location(Location(135,8,135,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1289 :: []),(varB_1290 :: [])) :: []),(varC_1291 :: [])) when (((((isTrue (evalisName((varB_1290 :: [])) config (-1)))) && ((isTrue (evalisName((varA_1289 :: [])) config (-1)))))) && ((isTrue (evalisName((varC_1291 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1289 :: []),((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1290 :: []),(varC_1291 :: [])) config (-1)))) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(A,B)=>`_,__GRHO-SYNTAX`(A,B)`` requires `_andBool_`(isProc(A),isProcs(B)) ensures #token("true","Bool") [UNIQUE_ID(923ca1444cffd0c6f3d0fe75826e1cccacd54c2672ff3178c6f2516e6af328a7) contentStartColumn(8) contentStartLine(144) org.kframework.attributes.Location(Location(144,8,144,53)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_1292 :: []),(varB_1293 :: [])) when (((isTrue (evalisProc((varA_1292 :: [])) config (-1)))) && ((isTrue (evalisProcs((varB_1293 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1292 :: []),(varB_1293 :: [])) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(A,B),C)=>`_,__GRHO-SYNTAX`(A,`#append(_;_)_AUXFUN-SYNTAX`(B,C))`` requires `_andBool_`(`_andBool_`(isName(B),isName(A)),isNames(C)) ensures #token("true","Bool") [UNIQUE_ID(79b69255c4fbc89c1424dc75b53bda7b91e33c39bdca03df7fe9a20bb4bf682f) contentStartColumn(8) contentStartLine(138) org.kframework.attributes.Location(Location(138,8,138,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1294 :: []),(varB_1295 :: [])) :: []),(varC_1296 :: [])) when (((((isTrue (evalisName((varB_1295 :: [])) config (-1)))) && ((isTrue (evalisName((varA_1294 :: [])) config (-1)))))) && ((isTrue (evalisNames((varC_1296 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1294 :: []),((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1295 :: []),(varC_1296 :: [])) config (-1)))) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(A,B)=>`_,__GRHO-SYNTAX`(A,B)`` requires `_andBool_`(isProc(B),isProc(A)) ensures #token("true","Bool") [UNIQUE_ID(cf81930c7913a8b9a8e5c8d02b664024988bb37fe507a40141c6003dec2ed33a) contentStartColumn(8) contentStartLine(141) org.kframework.attributes.Location(Location(141,8,141,53)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_1297 :: []),(varB_1298 :: [])) when (((isTrue (evalisProc((varB_1298 :: [])) config (-1)))) && ((isTrue (evalisProc((varA_1297 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1297 :: []),(varB_1298 :: [])) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(A,B),C)=>`_,__GRHO-SYNTAX`(A,`#append(_;_)_AUXFUN-SYNTAX`(B,C))`` requires `_andBool_`(`_andBool_`(isProc(A),isProcs(B)),isProcs(C)) ensures #token("true","Bool") [UNIQUE_ID(81de67ef2aa6419730117e5a8ea87e1461a9da0424bd77fa125b9c7b9d2b7f90) contentStartColumn(8) contentStartLine(146) org.kframework.attributes.Location(Location(146,8,146,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1299 :: []),(varB_1300 :: [])) :: []),(varC_1301 :: [])) when (((((isTrue (evalisProc((varA_1299 :: [])) config (-1)))) && ((isTrue (evalisProcs((varB_1300 :: [])) config (-1)))))) && ((isTrue (evalisProcs((varC_1301 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1299 :: []),((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1300 :: []),(varC_1301 :: [])) config (-1)))) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(A,B),C)=>`_,__GRHO-SYNTAX`(A,`#append(_;_)_AUXFUN-SYNTAX`(B,C))`` requires `_andBool_`(`_andBool_`(isProc(B),isProc(A)),isProcs(C)) ensures #token("true","Bool") [UNIQUE_ID(be8589a617d597fe4eb011ff5492dc44c578ad46394190ca4629fd1f00984e7c) contentStartColumn(8) contentStartLine(145) org.kframework.attributes.Location(Location(145,8,145,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1302 :: []),(varB_1303 :: [])) :: []),(varC_1304 :: [])) when (((((isTrue (evalisProc((varB_1303 :: [])) config (-1)))) && ((isTrue (evalisProc((varA_1302 :: [])) config (-1)))))) && ((isTrue (evalisProcs((varC_1304 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1302 :: []),((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1303 :: []),(varC_1304 :: [])) config (-1)))) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(A,B),C)=>`_,__GRHO-SYNTAX`(A,`#append(_;_)_AUXFUN-SYNTAX`(B,C))`` requires `_andBool_`(`_andBool_`(isName(A),isNames(C)),isNames(B)) ensures #token("true","Bool") [UNIQUE_ID(3967c71539bef96f9372a9d55e0625bb47f9a9cdb3e795a4db12bc2078eeefb2) contentStartColumn(8) contentStartLine(139) org.kframework.attributes.Location(Location(139,8,139,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1305 :: []),(varB_1306 :: [])) :: []),(varC_1307 :: [])) when (((((isTrue (evalisName((varA_1305 :: [])) config (-1)))) && ((isTrue (evalisNames((varC_1307 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_1306 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1305 :: []),((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1306 :: []),(varC_1307 :: [])) config (-1)))) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(A,B),C)=>`_,__GRHO-SYNTAX`(A,`#append(_;_)_AUXFUN-SYNTAX`(B,C))`` requires `_andBool_`(`_andBool_`(isProc(B),isProc(A)),isProc(C)) ensures #token("true","Bool") [UNIQUE_ID(ec8ac6a92c301eaeb4969a4d08b941c2317ce0aadb198ca4ccb7468dffc4a473) contentStartColumn(8) contentStartLine(142) org.kframework.attributes.Location(Location(142,8,142,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1308 :: []),(varB_1309 :: [])) :: []),(varC_1310 :: [])) when (((((isTrue (evalisProc((varB_1309 :: [])) config (-1)))) && ((isTrue (evalisProc((varA_1308 :: [])) config (-1)))))) && ((isTrue (evalisProc((varC_1310 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1308 :: []),((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1309 :: []),(varC_1310 :: [])) config (-1)))) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(A,B),C)=>`_,__GRHO-SYNTAX`(A,`#append(_;_)_AUXFUN-SYNTAX`(B,C))`` requires `_andBool_`(`_andBool_`(isProc(A),isProc(C)),isProcs(B)) ensures #token("true","Bool") [UNIQUE_ID(21291f3732bcdefd8e5836c852bcbd4b010fcdd3ffc2760ff378de85059294aa) contentStartColumn(8) contentStartLine(143) org.kframework.attributes.Location(Location(143,8,143,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1311 :: []),(varB_1312 :: [])) :: []),(varC_1313 :: [])) when (((((isTrue (evalisProc((varA_1311 :: [])) config (-1)))) && ((isTrue (evalisProc((varC_1313 :: [])) config (-1)))))) && ((isTrue (evalisProcs((varB_1312 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1311 :: []),((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1312 :: []),(varC_1313 :: [])) config (-1)))) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(`_,__GRHO-SYNTAX`(A,B),C)=>`_,__GRHO-SYNTAX`(A,`#append(_;_)_AUXFUN-SYNTAX`(B,C))`` requires `_andBool_`(`_andBool_`(isName(A),isName(C)),isNames(B)) ensures #token("true","Bool") [UNIQUE_ID(a184e30fe77e66ba8d40e4b490876881f1299aa0984cfdc2152ced56fd56fae6) contentStartColumn(8) contentStartLine(136) org.kframework.attributes.Location(Location(136,8,136,64)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1314 :: []),(varB_1315 :: [])) :: []),(varC_1316 :: [])) when (((((isTrue (evalisName((varA_1314 :: [])) config (-1)))) && ((isTrue (evalisName((varC_1316 :: [])) config (-1)))))) && ((isTrue (evalisNames((varB_1315 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1314 :: []),((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varB_1315 :: []),(varC_1316 :: [])) config (-1)))) :: [])
(*{| rule `` `#append(_;_)_AUXFUN-SYNTAX`(A,B)=>`_,__GRHO-SYNTAX`(A,B)`` requires `_andBool_`(isName(B),isName(A)) ensures #token("true","Bool") [UNIQUE_ID(d36c6b56a3b5f73b7193ed4fe015c70f254385778aabeed0b9123341a8171373) contentStartColumn(8) contentStartLine(134) org.kframework.attributes.Location(Location(134,8,134,53)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((varA_1317 :: []),(varB_1318 :: [])) when (((isTrue (evalisName((varB_1318 :: [])) config (-1)))) && ((isTrue (evalisName((varA_1317 :: [])) config (-1))))) && (true) -> (KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varA_1317 :: []),(varB_1318 :: [])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalRecCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblRecCellBagItem and sort = 
SortRecCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitWhoCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitWhoCell and sort = 
SortWhoCell in match c with 
(*{| rule ``initWhoCell(.KList)=>`<who>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(27075b3416a2183f7985567f9555c947e8b1c871c87ae0171444a9788b8a09a6) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'who'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitWhoCell : k Lazy.t = lazy (evalinitWhoCell () interned_bottom (-1))
let evalsizeList (c: k) (config: k) (guard: int) : k = let lbl = 
LblsizeList and sort = 
SortInt in match c with 
| _ -> try LIST.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisChanLen (c: k) (config: k) (guard: int) : k = let lbl = 
LblisChanLen and sort = 
SortBool in match c with 
(*{| rule ``isChanLen(#KToken(#token("ChanLen","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortChanLen, var__1319) :: [])) -> ((Bool true) :: [])
(*{| rule ``isChanLen(`(_;_)_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isInt(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl'LPar'_'SCln'_'RPar'_GRHO'Hyph'SYNTAX,(varK0_1320 :: []),((Int _ as varK1_1321) :: [])) :: [])) when (((isTrue (evalisName((varK0_1320 :: [])) config (-1)))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isChanLen(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1322)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'SendCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'SendCellBag and sort = 
SortSendCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'SendCellBag : k Lazy.t = lazy (eval'Stop'SendCellBag () interned_bottom (-1))
let evalinitSendsCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSendsCell and sort = 
SortSendsCell in match c with 
(*{| rule ``initSendsCell(.KList)=>`<sends>`(`.SendCellBag`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(f560092ab59f628f9463eec0f65b1c172f37d9c5d7064c88449f2427728dd6e1) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'sends'_GT_',((Lazy.force const'Stop'SendCellBag))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSendsCell : k Lazy.t = lazy (evalinitSendsCell () interned_bottom (-1))
let evalinitTuplespaceCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitTuplespaceCell and sort = 
SortTuplespaceCell in match c with 
(*{| rule ``initTuplespaceCell(.KList)=>`<tuplespace>`(initSendsCell(.KList),initReceivesCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(05239e74b0145c7d40ebf34a01e3a581ae158c91e93a0c3916f201b75669aff4) initializer()]|}*)
| () -> (KApply2(Lbl'_LT_'tuplespace'_GT_',((Lazy.force constinitSendsCell)),((Lazy.force constinitReceivesCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitTuplespaceCell : k Lazy.t = lazy (evalinitTuplespaceCell () interned_bottom (-1))
let eval_'EqlsSlshEqls'Bool__BOOL (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'EqlsSlshEqls'Bool__BOOL and sort = 
SortBool in match c with 
| _ -> try BOOL.hook_ne c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_=/=Bool__BOOL`(B1,B2)=>`notBool_`(`_==Bool__BOOL`(B1,B2))`` requires `_andBool_`(isBool(B2),isBool(B1)) ensures #token("true","Bool") [UNIQUE_ID(229c060a3ad56352e70dadb0089a132434aa77f4aaf4ef46e44d820031a08b83) contentStartColumn(8) contentStartLine(332) org.kframework.attributes.Location(Location(332,8,332,57)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Bool _ as varB1_1323) :: []),((Bool _ as varB2_1324) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'EqlsEqls'Bool__BOOL((varB1_1323 :: []),(varB2_1324 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisCollection (c: k) (config: k) (guard: int) : k = let lbl = 
LblisCollection and sort = 
SortBool in match c with 
(*{| rule ``isCollection(#KToken(#token("RhoList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoList, var__1325) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCollection(`Set(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LblSet'LPar'_'RPar'_GRHO'Hyph'SYNTAX,(varK0_1326 :: [])) :: [])) when (isTrue (evalisProcList((varK0_1326 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCollection(`{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isRhoKVPairs(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_1327 :: [])) :: [])) when (isTrue (evalisRhoKVPairs((varK0_1327 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCollection(`[_]_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'LSqB'_'RSqB'_GRHO'Hyph'SYNTAX,(varK0_1328 :: [])) :: [])) when (isTrue (evalisProcList((varK0_1328 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCollection(#KToken(#token("RhoMap","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoMap, var__1329) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCollection(#KToken(#token("RhoTuple","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoTuple, var__1330) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCollection(#KToken(#token("Collection","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortCollection, var__1331) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCollection(#KToken(#token("RhoSet","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRhoSet, var__1332) :: [])) -> ((Bool true) :: [])
(*{| rule ``isCollection(tuple(K0))=>#token("true","Bool")`` requires isProcList(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbltuple,(varK0_1333 :: [])) :: [])) when (isTrue (evalisProcList((varK0_1333 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isCollection(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1334)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalremoveAll (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblremoveAll and sort = 
SortMap in match c with 
| _ -> try MAP.hook_removeAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisTCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTCell and sort = 
SortBool in match c with 
(*{| rule ``isTCell(#KToken(#token("TCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCell, var__1335) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTCell(`<T>`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isThreadsCell(K0),isTuplespaceCell(K1)),isReactionCell(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'T'_GT_',(varK0_1336 :: []),(varK1_1337 :: []),(varK2_1338 :: [])) :: [])) when (((((isTrue (evalisThreadsCell((varK0_1336 :: [])) config (-1)))) && ((isTrue (evalisTuplespaceCell((varK1_1337 :: [])) config (-1)))))) && ((isTrue (evalisReactionCell((varK2_1338 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTCell(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1339)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION and sort = 
SortK in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Hash'msg'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'msg'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortProc in match c with 
(*{| rule `` `#msg(_)_AUXFUN-SYNTAX`(`_!__GRHO-SYNTAX`(_56,tuple(P)))=>P`` requires `_andBool_`(isProcs(P),isName(_56)) ensures #token("true","Bool") [UNIQUE_ID(5177441937574123148a3e9b97d8abd7b55fa9faadc787b5a2bbf22eaa54e48c) contentStartColumn(8) contentStartLine(94) org.kframework.attributes.Location(Location(94,8,94,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Bang'__GRHO'Hyph'SYNTAX,(var_56_1340 :: []),(KApply1(Lbltuple,(varP_1341 :: [])) :: [])) :: [])) when (((isTrue (evalisProcs((varP_1341 :: [])) config (-1)))) && ((isTrue (evalisName((var_56_1340 :: [])) config (-1))))) && (true) -> (varP_1341 :: [])
(*{| rule `` `#msg(_)_AUXFUN-SYNTAX`(`_!!__GRHO-SYNTAX`(_35,tuple(P)))=>P`` requires `_andBool_`(isProc(P),isName(_35)) ensures #token("true","Bool") [UNIQUE_ID(4b860af213cf67b0636065decbd56cb656ccf50888bfe764f8957bc95945e5c8) contentStartColumn(8) contentStartLine(95) org.kframework.attributes.Location(Location(95,8,95,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'BangBang'__GRHO'Hyph'SYNTAX,(var_35_1342 :: []),(KApply1(Lbltuple,(varP_1343 :: [])) :: [])) :: [])) when (((isTrue (evalisProc((varP_1343 :: [])) config (-1)))) && ((isTrue (evalisName((var_35_1342 :: [])) config (-1))))) && (true) -> (varP_1343 :: [])
(*{| rule `` `#msg(_)_AUXFUN-SYNTAX`(`_!!__GRHO-SYNTAX`(_60,tuple(P)))=>P`` requires `_andBool_`(isProcs(P),isName(_60)) ensures #token("true","Bool") [UNIQUE_ID(81756fd06e0449dea31514e7634fa30de4b490964be3fd69b9b723d6c450cdf9) contentStartColumn(8) contentStartLine(96) org.kframework.attributes.Location(Location(96,8,96,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'BangBang'__GRHO'Hyph'SYNTAX,(var_60_1344 :: []),(KApply1(Lbltuple,(varP_1345 :: [])) :: [])) :: [])) when (((isTrue (evalisProcs((varP_1345 :: [])) config (-1)))) && ((isTrue (evalisName((var_60_1344 :: [])) config (-1))))) && (true) -> (varP_1345 :: [])
(*{| rule `` `#msg(_)_AUXFUN-SYNTAX`(`_!__GRHO-SYNTAX`(_47,tuple(P)))=>P`` requires `_andBool_`(isName(_47),isProc(P)) ensures #token("true","Bool") [UNIQUE_ID(79cba3edbfe5bc07b2c8bea16a6e8174c3fc4504034beef954a897de08613ff5) contentStartColumn(8) contentStartLine(93) org.kframework.attributes.Location(Location(93,8,93,48)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lbl_'Bang'__GRHO'Hyph'SYNTAX,(var_47_1346 :: []),(KApply1(Lbltuple,(varP_1347 :: [])) :: [])) :: [])) when (((isTrue (evalisName((var_47_1346 :: [])) config (-1)))) && ((isTrue (evalisProc((varP_1347 :: [])) config (-1))))) && (true) -> (varP_1347 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisThreadsCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisThreadsCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isThreadsCellFragment(`<threads>-fragment`(K0))=>#token("true","Bool")`` requires isThreadCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'threads'_GT_Hyph'fragment,(varK0_1348 :: [])) :: [])) when (isTrue (evalisThreadCellBag((varK0_1348 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isThreadsCellFragment(#KToken(#token("ThreadsCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortThreadsCellFragment, var__1349) :: [])) -> ((Bool true) :: [])
(*{| rule ``isThreadsCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1350)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisLengthCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisLengthCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isLengthCellOpt(#KToken(#token("LengthCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLengthCell, var__1351) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLengthCellOpt(noLengthCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoLengthCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLengthCellOpt(`<length>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'length'_GT_',(varK0_1352)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isLengthCellOpt(#KToken(#token("LengthCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLengthCellOpt, var__1353) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLengthCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1354)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRbindList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRbindList and sort = 
SortBool in match c with 
(*{| rule ``isRbindList(#KToken(#token("Rbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbinds, var__1355) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRbindList(#KToken(#token("RbindList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbindList, var__1356) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRbindList(`_<=__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varK0_1357 :: []),(varK1_1358 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_1357 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_1358 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRbindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isRbind(K0),isRbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_1359 :: []),(varK1_1360 :: [])) :: [])) when (((isTrue (evalisRbind((varK0_1359 :: [])) config (-1)))) && ((isTrue (evalisRbinds((varK1_1360 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRbindList(#KToken(#token("Rbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRbind, var__1361) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRbindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isRbind(K0),isRbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_1362 :: []),(varK1_1363 :: [])) :: [])) when (((isTrue (evalisRbind((varK0_1362 :: [])) config (-1)))) && ((isTrue (evalisRbind((varK1_1363 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRbindList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1364)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisConsumableSend (c: k) (config: k) (guard: int) : k = let lbl = 
LblisConsumableSend and sort = 
SortBool in match c with 
(*{| rule ``isConsumableSend(`_!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isRhoTuple(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Bang'__GRHO'Hyph'SYNTAX,(varK0_1365 :: []),(varK1_1366 :: [])) :: [])) when (((isTrue (evalisName((varK0_1365 :: [])) config (-1)))) && ((isTrue (evalisRhoTuple((varK1_1366 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isConsumableSend(#KToken(#token("ConsumableSend","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortConsumableSend, var__1367) :: [])) -> ((Bool true) :: [])
(*{| rule ``isConsumableSend(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1368)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitNomoCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitNomoCell and sort = 
SortNomoCell in match c with 
(*{| rule ``initNomoCell(.KList)=>`<nomo>`(`.Set`(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(d7cece9bce9f6936a3054783177952b21b8ab81806141ebf055d23ef1d658e2e) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'nomo'_GT_',((Lazy.force const'Stop'Set))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitNomoCell : k Lazy.t = lazy (evalinitNomoCell () interned_bottom (-1))
let evalisReceive (c: k) (config: k) (guard: int) : k = let lbl = 
LblisReceive and sort = 
SortBool in match c with 
(*{| rule ``isReceive(`for(_){_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBind(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_1369 :: []),(varK1_1370 :: [])) :: [])) when (((isTrue (evalisBind((varK0_1369 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_1370 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isReceive(#KToken(#token("MultiRec","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMultiRec, var__1371) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReceive(`for(_){_}_GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isBinds(K0),isProc(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_1372 :: []),(varK1_1373 :: [])) :: [])) when (((isTrue (evalisBinds((varK0_1372 :: [])) config (-1)))) && ((isTrue (evalisProc((varK1_1373 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isReceive(#KToken(#token("Receive","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortReceive, var__1374) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReceive(#KToken(#token("SingleRec","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortSingleRec, var__1375) :: [])) -> ((Bool true) :: [])
(*{| rule ``isReceive(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1376)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitThreadsCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitThreadsCell and sort = 
SortThreadsCell in match c with 
(*{| rule ``initThreadsCell(Init)=>`<threads>`(initThreadCell(Init))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(c857246a71e85381e300bd128131054d722cceffa25640ca9988bcb420c1a2ce) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_1377) :: [])) -> (KApply1(Lbl'_LT_'threads'_GT_',((evalinitThreadCell((varInit_1377 :: [])) config (-1)))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitWhatCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitWhatCell and sort = 
SortWhatCell in match c with 
(*{| rule ``initWhatCell(.KList)=>`<what>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(24ebfa02c620d7f9f22bc2856fa13c01f61b4ebee0771696d14c3f5bd45e98d3) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'what'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitWhatCell : k Lazy.t = lazy (evalinitWhatCell () interned_bottom (-1))
let evalinitReactionCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitReactionCell and sort = 
SortReactionCell in match c with 
(*{| rule ``initReactionCell(.KList)=>`<reaction>`(initWhoCell(.KList),initWhatCell(.KList),initWhereCell(.KList),initRidCell(.KList),initRnumCell(.KList),initReactCell(.KList),initForgCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(d2b28db5d977ec137327aba853b4c3cc18a753901cb15af2a3cfdb5a62e6a2a0) initializer()]|}*)
| () -> (KApply7(Lbl'_LT_'reaction'_GT_',((Lazy.force constinitWhoCell)),((Lazy.force constinitWhatCell)),((Lazy.force constinitWhereCell)),((Lazy.force constinitRidCell)),((Lazy.force constinitRnumCell)),((Lazy.force constinitReactCell)),((Lazy.force constinitForgCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitReactionCell : k Lazy.t = lazy (evalinitReactionCell () interned_bottom (-1))
let evalinitTCell (c: k) (config: k) (guard: int) : k = let lbl = 
LblinitTCell and sort = 
SortTCell in match c with 
(*{| rule ``initTCell(Init)=>`<T>`(initThreadsCell(Init),initTuplespaceCell(.KList),initReactionCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(8045a11b2f3c653dba53e856cd5f57257095621b1bd94b9aec57ca0bf5a1c0a4) initializer()]|}*)
| (((Map (SortMap,_,_) as varInit_1378) :: [])) -> (KApply3(Lbl'_LT_'T'_GT_',((evalinitThreadsCell((varInit_1378 :: [])) config (-1))),((Lazy.force constinitTuplespaceCell)),((Lazy.force constinitReactionCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalFloatFormat (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblFloatFormat and sort = 
SortString in match c with 
| _ -> try STRING.hook_floatFormat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Xor_Perc'Int___INT (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Xor_Perc'Int___INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_powmod c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval_RecCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_RecCellBag_ and sort = 
SortRecCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval_'Pipe'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Pipe'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_or c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisKVariable (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKVariable and sort = 
SortBool in match c with 
| [Int _] -> [Bool true]
(*{| rule ``isKVariable(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_1379 :: []),(varK1_1380 :: [])) :: [])) when (((isTrue (evalisName((varK0_1379 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_1380 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKVariable(`unforgeable(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isInt(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblunforgeable'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((Int _ as varK0_1381) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("KVariable","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortKVariable, var__1382) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__1383) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(`@__GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_AT_'__GRHO'Hyph'SYNTAX,(varK0_1384 :: [])) :: [])) when (isTrue (evalisProc((varK0_1384 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("Name","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortName, var__1385) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__1386) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(`_,__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isNames(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varK0_1387 :: []),(varK1_1388 :: [])) :: [])) when (((isTrue (evalisName((varK0_1387 :: [])) config (-1)))) && ((isTrue (evalisNames((varK1_1388 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("Names","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNames, var__1389) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(#KToken(#token("NameVar","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNameVar, var__1390) :: [])) -> ((Bool true) :: [])
(*{| rule ``isKVariable(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1391)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_dividesInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_dividesInt__INT and sort = 
SortBool in match c with 
(*{| rule `` `_dividesInt__INT`(I1,I2)=>`_==Int_`(`_%Int__INT`(I2,I1),#token("0","Int"))`` requires `_andBool_`(isInt(I1),isInt(I2)) ensures #token("true","Bool") [UNIQUE_ID(81f77f3fbad78d0c735f87bfe9eff8339b46a8ead5ca820f8d69aafef7cb551d) contentStartColumn(8) contentStartLine(409) org.kframework.attributes.Location(Location(409,8,409,58)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varI1_1392) :: []),((Int _ as varI2_1393) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'Int_(((eval_'Perc'Int__INT((varI2_1393 :: []),(varI1_1392 :: [])) config (-1))),((Lazy.force int0) :: [])) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'stat'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stat'LPar'_'RPar'_K'Hyph'IO and sort = 
SortKItem in match c with 
| _ -> try IO.hook_stat c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalupdateList (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblupdateList and sort = 
SortList in match c with 
| _ -> try LIST.hook_updateAll c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalinitContCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitContCell and sort = 
SortContCell in match c with 
(*{| rule ``initContCell(.KList)=>`<cont>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(9ae3f63ba6a8508ad4e1712e7170da45c90d694ae480d00f73186c6370430ef6) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'cont'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitContCell : k Lazy.t = lazy (evalinitContCell () interned_bottom (-1))
let evalSet'Coln'choice (c: k) (config: k) (guard: int) : k = let lbl = 
LblSet'Coln'choice and sort = 
SortKItem in match c with 
| _ -> try SET.hook_choice c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisListensCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisListensCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isListensCellFragment(#KToken(#token("ListensCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortListensCellFragment, var__1394) :: [])) -> ((Bool true) :: [])
(*{| rule ``isListensCellFragment(`<listens>-fragment`(K0))=>#token("true","Bool")`` requires isListenCellBag(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'listens'_GT_Hyph'fragment,(varK0_1395 :: [])) :: [])) when (isTrue (evalisListenCellBag((varK0_1395 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isListensCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1396)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalcategoryChar (c: k) (config: k) (guard: int) : k = let lbl = 
LblcategoryChar and sort = 
SortString in match c with 
| _ -> try STRING.hook_category c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisBundle (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBundle and sort = 
SortBool in match c with 
(*{| rule ``isBundle(#KToken(#token("Bundle","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBundle, var__1397) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBundle(`bundle{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_1398 :: [])) :: [])) when (isTrue (evalisProc((varK0_1398 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBundle(`bundle+{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'PlusLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_1399 :: [])) :: [])) when (isTrue (evalisProc((varK0_1399 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBundle(`bundle-{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle'HyphLBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_1400 :: [])) :: [])) when (isTrue (evalisProc((varK0_1400 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBundle(`bundle0{_}_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lblbundle0'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(varK0_1401 :: [])) :: [])) when (isTrue (evalisProc((varK0_1401 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isBundle(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1402)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitSidCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSidCell and sort = 
SortSidCell in match c with 
(*{| rule ``initSidCell(.KList)=>`<sid>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(da4091ea598c96af275519610b67f61bc14699950879053cd050392857d5a7c1) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'sid'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSidCell : k Lazy.t = lazy (evalinitSidCell () interned_bottom (-1))
let eval'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_write c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisLbindList (c: k) (config: k) (guard: int) : k = let lbl = 
LblisLbindList and sort = 
SortBool in match c with 
(*{| rule ``isLbindList(#KToken(#token("Lbinds","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbinds, var__1403) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLbindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLbind(K0),isLbinds(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_1404 :: []),(varK1_1405 :: [])) :: [])) when (((isTrue (evalisLbind((varK0_1404 :: [])) config (-1)))) && ((isTrue (evalisLbinds((varK1_1405 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isLbindList(`_<-__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isNameList(K0),isName(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'_LT_Hyph'__GRHO'Hyph'SYNTAX,(varK0_1406 :: []),(varK1_1407 :: [])) :: [])) when (((isTrue (evalisNameList((varK0_1406 :: [])) config (-1)))) && ((isTrue (evalisName((varK1_1407 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isLbindList(`_;__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isLbind(K0),isLbind(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(varK0_1408 :: []),(varK1_1409 :: [])) :: [])) when (((isTrue (evalisLbind((varK0_1408 :: [])) config (-1)))) && ((isTrue (evalisLbind((varK1_1409 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isLbindList(#KToken(#token("LbindList","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbindList, var__1410) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLbindList(#KToken(#token("Lbind","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortLbind, var__1411) :: [])) -> ((Bool true) :: [])
(*{| rule ``isLbindList(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1412)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisUnconsumableSend (c: k) (config: k) (guard: int) : k = let lbl = 
LblisUnconsumableSend and sort = 
SortBool in match c with 
(*{| rule ``isUnconsumableSend(`_!!__GRHO-SYNTAX`(K0,K1))=>#token("true","Bool")`` requires `_andBool_`(isName(K0),isRhoTuple(K1)) ensures #token("true","Bool") []|}*)
| ((KApply2(Lbl_'BangBang'__GRHO'Hyph'SYNTAX,(varK0_1413 :: []),(varK1_1414 :: [])) :: [])) when (((isTrue (evalisName((varK0_1413 :: [])) config (-1)))) && ((isTrue (evalisRhoTuple((varK1_1414 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isUnconsumableSend(#KToken(#token("UnconsumableSend","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUnconsumableSend, var__1415) :: [])) -> ((Bool true) :: [])
(*{| rule ``isUnconsumableSend(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1416)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisIdCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisIdCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isIdCellOpt(noIdCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoIdCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIdCellOpt(#KToken(#token("IdCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIdCell, var__1417) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIdCellOpt(`<id>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'id'_GT_',(varK0_1418)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isIdCellOpt(#KToken(#token("IdCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortIdCellOpt, var__1419) :: [])) -> ((Bool true) :: [])
(*{| rule ``isIdCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1420)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisTypeCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTypeCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isTypeCellOpt(#KToken(#token("TypeCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTypeCell, var__1421) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTypeCellOpt(#KToken(#token("TypeCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTypeCellOpt, var__1422) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTypeCellOpt(noTypeCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoTypeCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTypeCellOpt(`<type>`(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'type'_GT_',(varK0_1423)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isTypeCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1424)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisNomoCellOpt (c: k) (config: k) (guard: int) : k = let lbl = 
LblisNomoCellOpt and sort = 
SortBool in match c with 
(*{| rule ``isNomoCellOpt(`<nomo>`(K0))=>#token("true","Bool")`` requires isSet(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as varK0_1425) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isNomoCellOpt(noNomoCell(.KList))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KApply0(LblnoNomoCell) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNomoCellOpt(#KToken(#token("NomoCell","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNomoCell, var__1426) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNomoCellOpt(#KToken(#token("NomoCellOpt","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortNomoCellOpt, var__1427) :: [])) -> ((Bool true) :: [])
(*{| rule ``isNomoCellOpt(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1428)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisRecCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisRecCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isRecCellFragment(`<rec>-fragment`(K0,K1,K2,K3,K4,K5,K6,K7))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isIdCellOpt(K0),isLengthCellOpt(K1)),isContCellOpt(K2)),isStateCellOpt(K3)),isMatchCellOpt(K4)),isTypeCellOpt(K5)),isNomoCellOpt(K6)),isListensCellOpt(K7)) ensures #token("true","Bool") []|}*)
| ((KApply8(Lbl'_LT_'rec'_GT_Hyph'fragment,(varK0_1429 :: []),(varK1_1430 :: []),(varK2_1431 :: []),(varK3_1432 :: []),(varK4_1433 :: []),(varK5_1434 :: []),(varK6_1435 :: []),(varK7_1436 :: [])) :: [])) when (((((((((((((((isTrue (evalisIdCellOpt((varK0_1429 :: [])) config (-1)))) && ((isTrue (evalisLengthCellOpt((varK1_1430 :: [])) config (-1)))))) && ((isTrue (evalisContCellOpt((varK2_1431 :: [])) config (-1)))))) && ((isTrue (evalisStateCellOpt((varK3_1432 :: [])) config (-1)))))) && ((isTrue (evalisMatchCellOpt((varK4_1433 :: [])) config (-1)))))) && ((isTrue (evalisTypeCellOpt((varK5_1434 :: [])) config (-1)))))) && ((isTrue (evalisNomoCellOpt((varK6_1435 :: [])) config (-1)))))) && ((isTrue (evalisListensCellOpt((varK7_1436 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isRecCellFragment(#KToken(#token("RecCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortRecCellFragment, var__1437) :: [])) -> ((Bool true) :: [])
(*{| rule ``isRecCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1438)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_xorInt__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_xorInt__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_xor c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalMap'Coln'lookupOrDefault (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblMap'Coln'lookupOrDefault and sort = 
SortKItem in match c with 
| _ -> try MAP.hook_lookupOrDefault c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalString2Float (c: k) (config: k) (guard: int) : k = let lbl = 
LblString2Float and sort = 
SortFloat in match c with 
| _ -> try STRING.hook_string2float c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitStateCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitStateCell and sort = 
SortStateCell in match c with 
(*{| rule ``initStateCell(.KList)=>`<state>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(4c7198eb5b4e40d7b39330c673b5fea4d9a049a47bd28262fd8dd547a72c7f15) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'state'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitStateCell : k Lazy.t = lazy (evalinitStateCell () interned_bottom (-1))
let eval'Hash'stdout_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stdout_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stdout_K-IO`(.KList)=>#token("1","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(fd57288699ac44a10b4d3e3c65ee3ad16f98646109e64ed7a5ac726279e39ae9) contentStartColumn(8) contentStartLine(909) org.kframework.attributes.Location(Location(909,8,909,20)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| () -> ((Lazy.force int1) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stdout_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stdout_K'Hyph'IO () interned_bottom (-1))
let evalinitMatchCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitMatchCell and sort = 
SortMatchCell in match c with 
(*{| rule ``initMatchCell(.KList)=>`<match>`(.K)`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(1f99b6963e9d9361aaee83bc8b61bd8165c961c7425b9acc16c57286a090a876) initializer()]|}*)
| () -> (KApply1(Lbl'_LT_'match'_GT_',([])) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitMatchCell : k Lazy.t = lazy (evalinitMatchCell () interned_bottom (-1))
let eval_'And'Int__INT (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'And'Int__INT and sort = 
SortInt in match c with 
| _ -> try INT.hook_and c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let eval'Hash'rtype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'rtype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortInt in match c with 
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(_59)=>#token("0","Int")`` requires isLbind(_59) ensures #token("true","Bool") [UNIQUE_ID(75217263cc5bb0c0fe2934f7ef70c7aa8ec1601068738ca5e747e2814fba65a8) contentStartColumn(8) contentStartLine(124) org.kframework.attributes.Location(Location(124,8,124,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((var_59_1439 :: [])) when (isTrue (evalisLbind((var_59_1439 :: [])) config (-1))) && (true) -> ((Lazy.force int0) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(_83)=>#token("2","Int")`` requires isPbind(_83) ensures #token("true","Bool") [UNIQUE_ID(b51d0d7bb52ce39f0785fc3ccfe46cc4f8abd8b52031c3872edf5ade0308a397) contentStartColumn(8) contentStartLine(128) org.kframework.attributes.Location(Location(128,8,128,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((var_83_1440 :: [])) when (isTrue (evalisPbind((var_83_1440 :: [])) config (-1))) && (true) -> ((Lazy.force int2) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(_79)=>#token("1","Int")`` requires isRbind(_79) ensures #token("true","Bool") [UNIQUE_ID(aec987d84afffc750171574efa289fcd6f4e33106306187e99c7542d511d6e37) contentStartColumn(8) contentStartLine(126) org.kframework.attributes.Location(Location(126,8,126,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((var_79_1441 :: [])) when (isTrue (evalisRbind((var_79_1441 :: [])) config (-1))) && (true) -> ((Lazy.force int1) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(_45,_46))=>#token("2","Int")`` requires `_andBool_`(isProc(_46),isPbind(_45)) ensures #token("true","Bool") [UNIQUE_ID(0bb37e330ad9bcbb60830997bf848a8a3d178fc13baf51680b119c624b35898d) contentStartColumn(8) contentStartLine(121) org.kframework.attributes.Location(Location(121,8,121,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_45_1442 :: []),(var_46_1443 :: [])) :: [])) when (((isTrue (evalisProc((var_46_1443 :: [])) config (-1)))) && ((isTrue (evalisPbind((var_45_1442 :: [])) config (-1))))) && (true) -> ((Lazy.force int2) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(_55)=>#token("2","Int")`` requires isPbinds(_55) ensures #token("true","Bool") [UNIQUE_ID(d2bdd9cd351922329398145771f3484dc93ee93c841a42d9bed6825a70e07d2e) contentStartColumn(8) contentStartLine(129) org.kframework.attributes.Location(Location(129,8,129,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((var_55_1444 :: [])) when (isTrue (evalisPbinds((var_55_1444 :: [])) config (-1))) && (true) -> ((Lazy.force int2) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(_36,_37))=>#token("1","Int")`` requires `_andBool_`(isRbinds(_36),isProc(_37)) ensures #token("true","Bool") [UNIQUE_ID(2beb5311a8c890a50261709f65c46453bf0d7714994151432e921de8cac470e1) contentStartColumn(8) contentStartLine(120) org.kframework.attributes.Location(Location(120,8,120,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_36_1445 :: []),(var_37_1446 :: [])) :: [])) when (((isTrue (evalisRbinds((var_36_1445 :: [])) config (-1)))) && ((isTrue (evalisProc((var_37_1446 :: [])) config (-1))))) && (true) -> ((Lazy.force int1) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(_73,_74))=>#token("0","Int")`` requires `_andBool_`(isProc(_74),isLbind(_73)) ensures #token("true","Bool") [UNIQUE_ID(847a560b8db4b1d3d5192bbe5eaf2398975e718b7d809a5b49e1f96f9d419f3a) contentStartColumn(8) contentStartLine(117) org.kframework.attributes.Location(Location(117,8,117,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_73_1447 :: []),(var_74_1448 :: [])) :: [])) when (((isTrue (evalisProc((var_74_1448 :: [])) config (-1)))) && ((isTrue (evalisLbind((var_73_1447 :: [])) config (-1))))) && (true) -> ((Lazy.force int0) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(_54)=>#token("1","Int")`` requires isRbinds(_54) ensures #token("true","Bool") [UNIQUE_ID(38591d1aee0c67f62eae02c9fd5639c53a71b576a03641eec82b11c148784bda) contentStartColumn(8) contentStartLine(127) org.kframework.attributes.Location(Location(127,8,127,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((var_54_1449 :: [])) when (isTrue (evalisRbinds((var_54_1449 :: [])) config (-1))) && (true) -> ((Lazy.force int1) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(_61,_62))=>#token("0","Int")`` requires `_andBool_`(isProc(_62),isLbinds(_61)) ensures #token("true","Bool") [UNIQUE_ID(8a8e829b1b0657411303cb06d488f1708b0fefa4be72ce888e5429f1290a5377) contentStartColumn(8) contentStartLine(118) org.kframework.attributes.Location(Location(118,8,118,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_61_1450 :: []),(var_62_1451 :: [])) :: [])) when (((isTrue (evalisProc((var_62_1451 :: [])) config (-1)))) && ((isTrue (evalisLbinds((var_61_1450 :: [])) config (-1))))) && (true) -> ((Lazy.force int0) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(_41,_42))=>#token("1","Int")`` requires `_andBool_`(isRbind(_41),isProc(_42)) ensures #token("true","Bool") [UNIQUE_ID(c9fb85ea38fcde72a569ef139f8ea4d0570df2a2062957578a7ffc6bf8677c4c) contentStartColumn(8) contentStartLine(119) org.kframework.attributes.Location(Location(119,8,119,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_41_1452 :: []),(var_42_1453 :: [])) :: [])) when (((isTrue (evalisRbind((var_41_1452 :: [])) config (-1)))) && ((isTrue (evalisProc((var_42_1453 :: [])) config (-1))))) && (true) -> ((Lazy.force int1) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(_48)=>#token("0","Int")`` requires isLbinds(_48) ensures #token("true","Bool") [UNIQUE_ID(856d2822e64aa9371cf60f2da76059b59ede1802d0815b051926b1f979211ece) contentStartColumn(8) contentStartLine(125) org.kframework.attributes.Location(Location(125,8,125,32)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((var_48_1454 :: [])) when (isTrue (evalisLbinds((var_48_1454 :: [])) config (-1))) && (true) -> ((Lazy.force int0) :: [])
(*{| rule `` `#rtype(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(_70,_71))=>#token("2","Int")`` requires `_andBool_`(isPbinds(_70),isProc(_71)) ensures #token("true","Bool") [UNIQUE_ID(faeceffee69de054ca570ca9a4beecf45e1e77991dfe806e720eba28e33e986b) contentStartColumn(8) contentStartLine(122) org.kframework.attributes.Location(Location(122,8,122,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_70_1455 :: []),(var_71_1456 :: [])) :: [])) when (((isTrue (evalisPbinds((var_70_1455 :: [])) config (-1)))) && ((isTrue (evalisProc((var_71_1456 :: [])) config (-1))))) && (true) -> ((Lazy.force int2) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evallog2Int (c: k) (config: k) (guard: int) : k = let lbl = 
Lbllog2Int and sort = 
SortInt in match c with 
| _ -> try INT.hook_log2 c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'stdin_K'Hyph'IO (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'stdin_K'Hyph'IO and sort = 
SortInt in match c with 
(*{| rule `` `#stdin_K-IO`(.KList)=>#token("0","Int")`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(595a161d3d44d3c588fcd417f7279ef70547c573e159ef5bfc70692b22149da9) contentStartColumn(8) contentStartLine(908) org.kframework.attributes.Location(Location(908,8,908,19)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| () -> ((Lazy.force int0) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Hash'stdin_K'Hyph'IO : k Lazy.t = lazy (eval'Hash'stdin_K'Hyph'IO () interned_bottom (-1))
let evalBase2String (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblBase2String and sort = 
SortString in match c with 
| _ -> try STRING.hook_base2string c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalListItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblListItem and sort = 
SortList in match c with 
| _ -> try LIST.hook_element c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisStream (c: k) (config: k) (guard: int) : k = let lbl = 
LblisStream and sort = 
SortBool in match c with 
(*{| rule ``isStream(#buffer(K0))=>#token("true","Bool")`` requires isK(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbl'Hash'buffer,(varK0_1457)) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isStream(#KToken(#token("Stream","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortStream, var__1458) :: [])) -> ((Bool true) :: [])
(*{| rule ``isStream(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1459)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_GT_Eqls'String__STRING (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_GT_Eqls'String__STRING and sort = 
SortBool in match c with 
| _ -> try STRING.hook_ge c lbl sort config freshFunction
with Not_implemented -> match c with 
(*{| rule `` `_>=String__STRING`(S1,S2)=>`notBool_`(`_<String__STRING`(S1,S2))`` requires `_andBool_`(isString(S2),isString(S1)) ensures #token("true","Bool") [UNIQUE_ID(2e24bd4be2ac7aa21b58ac7fe4e1e4e70e5e69437dff6c98e3ff986df28f5b21) contentStartColumn(8) contentStartLine(551) org.kframework.attributes.Location(Location(551,8,551,63)) org.kframework.attributes.Source(Source(/usr/lib/kframework/include/builtin/domains.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((String _ as varS1_1460) :: []),((String _ as varS2_1461) :: [])) when ((true) && (true)) && (true) -> ([Bool ((not ((isTrue (eval_'_LT_'String__STRING((varS1_1460 :: []),(varS2_1461 :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisBindOcc (c: k) (config: k) (guard: int) : k = let lbl = 
LblisBindOcc and sort = 
SortBool in match c with 
(*{| rule ``isBindOcc(#KToken(#token("BindOcc","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBindOcc, var__1462) :: [])) -> ((Bool true) :: [])
(*{| rule ``isBindOcc(`_;_;;__GRHO-SYNTAX`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isInt(K1)),isInt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varK0_1463 :: []),((Int _ as varK1_1464) :: []),((Int _ as varK2_1465) :: [])) :: [])) when (((((isTrue (evalisName((varK0_1463 :: [])) config (-1)))) && (true))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindOcc(`_;_;;__GRHO-SYNTAX`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isName(K0),isNameList(K1)),isInt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl_'SCln'_'SClnSCln'__GRHO'Hyph'SYNTAX,(varK0_1466 :: []),(varK1_1467 :: []),((Int _ as varK2_1468) :: [])) :: [])) when (((((isTrue (evalisName((varK0_1466 :: [])) config (-1)))) && ((isTrue (evalisNameList((varK1_1467 :: [])) config (-1)))))) && (true)) && (true) -> ((Bool true) :: [])
(*{| rule ``isBindOcc(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1469)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'_LT_Eqls'Map__MAP (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'_LT_Eqls'Map__MAP and sort = 
SortBool in match c with 
| _ -> try MAP.hook_inclusion c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalnewUUID_STRING (c: unit) (config: k) (guard: int) : k = let lbl = 
LblnewUUID_STRING and sort = 
SortString in match c with 
| _ -> try STRING.hook_uuid c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let evalsizeMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblsizeMap and sort = 
SortInt in match c with 
| _ -> try MAP.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisId (c: k) (config: k) (guard: int) : k = let lbl = 
LblisId and sort = 
SortBool in match c with 
(*{| rule ``isId(#KToken(#token("Id","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortId, var__1470) :: [])) -> ((Bool true) :: [])
(*{| rule ``isId(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1471)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_SendCellBag_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_SendCellBag_ and sort = 
SortSendCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalsize (c: k) (config: k) (guard: int) : k = let lbl = 
Lblsize and sort = 
SortInt in match c with 
| _ -> try SET.hook_size c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_inList_ (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_inList_ and sort = 
SortBool in match c with 
| _ -> try LIST.hook_in c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisMap (c: k) (config: k) (guard: int) : k = let lbl = 
LblisMap and sort = 
SortBool in match c with 
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
(*{| rule ``isMap(#KToken(#token("Map","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortMap, var__1472) :: [])) -> ((Bool true) :: [])
(*{| rule ``isMap(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1473)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalsrandInt (c: k) (config: k) (guard: int) : k = let lbl = 
LblsrandInt and sort = 
SortK in match c with 
| _ -> try INT.hook_srand c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisKItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblisKItem and sort = 
SortBool in match c with 
| [_] -> [Bool true] | _ -> [Bool false]
| [List (s,_,_)] when (s = SortList) -> [Bool true]
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
| [Map (s,_,_)] when (s = SortMap) -> [Bool true]
| [Int _] -> [Bool true]
| [Float _] -> [Bool true]
| [Set (s,_,_)] when (s = SortSet) -> [Bool true]
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let rec eval'Hash'length__AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'length__AUXFUN'Hyph'SYNTAX and sort = 
SortInt in match c with 
(*{| rule `` `#length__AUXFUN-SYNTAX`(tuple(_33))=>#token("1","Int")`` requires isProc(_33) ensures #token("true","Bool") [UNIQUE_ID(7f6f5c0cf741393996495556910561abed593e22c49c390cc561227431fbee63) contentStartColumn(8) contentStartLine(187) org.kframework.attributes.Location(Location(187,8,187,41)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply1(Lbltuple,(var_33_1474 :: [])) :: [])) when (isTrue (evalisProc((var_33_1474 :: [])) config (-1))) && (true) -> ((Lazy.force int1) :: [])
(*{| rule `` `#length__AUXFUN-SYNTAX`(tuple(`_,__GRHO-SYNTAX`(_68,_69)))=>#token("2","Int")`` requires `_andBool_`(isProc(_68),isProc(_69)) ensures #token("true","Bool") [UNIQUE_ID(cba94e8b47174b8a807be5658f4dd3622227a0b1a851a3ce80da5c7ee90f9124) contentStartColumn(8) contentStartLine(188) org.kframework.attributes.Location(Location(188,8,188,41)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply1(Lbltuple,(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(var_68_1475 :: []),(var_69_1476 :: [])) :: [])) :: [])) when (((isTrue (evalisProc((var_68_1475 :: [])) config (-1)))) && ((isTrue (evalisProc((var_69_1476 :: [])) config (-1))))) && (true) -> ((Lazy.force int2) :: [])
(*{| rule `` `#length__AUXFUN-SYNTAX`(tuple(`_,__GRHO-SYNTAX`(_50,P)))=>`_+Int_`(#token("1","Int"),`#length__AUXFUN-SYNTAX`(tuple(P)))`` requires `_andBool_`(isProcs(P),isProc(_50)) ensures #token("true","Bool") [UNIQUE_ID(525844773a900ba76b1d3d2d11c438a71ca01f48f567a244e8962d0df013a596) contentStartColumn(8) contentStartLine(189) org.kframework.attributes.Location(Location(189,8,189,58)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply1(Lbltuple,(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(var_50_1477 :: []),(varP_1478 :: [])) :: [])) :: [])) when (((isTrue (evalisProcs((varP_1478 :: [])) config (-1)))) && ((isTrue (evalisProc((var_50_1477 :: [])) config (-1))))) && (true) -> ((eval_'Plus'Int_(((Lazy.force int1) :: []),((eval'Hash'length__AUXFUN'Hyph'SYNTAX((KApply1(Lbltuple,(varP_1478 :: [])) :: [])) config (-1)))) config (-1)))
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalisUri (c: k) (config: k) (guard: int) : k = let lbl = 
LblisUri and sort = 
SortBool in match c with 
(*{| rule ``isUri(#KToken(#token("Uri","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUri, var__1479) :: [])) -> ((Bool true) :: [])
(*{| rule ``isUri(`uri(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isString(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbluri'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((String _ as varK0_1480) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isUri(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1481)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalList'Coln'set (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
LblList'Coln'set and sort = 
SortList in match c with 
| _ -> try LIST.hook_update c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let evalString2Base (c: k * k) (config: k) (guard: int) : k = let lbl = 
LblString2Base and sort = 
SortInt in match c with 
| _ -> try STRING.hook_string2base c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalisTCellFragment (c: k) (config: k) (guard: int) : k = let lbl = 
LblisTCellFragment and sort = 
SortBool in match c with 
(*{| rule ``isTCellFragment(#KToken(#token("TCellFragment","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortTCellFragment, var__1482) :: [])) -> ((Bool true) :: [])
(*{| rule ``isTCellFragment(`<T>-fragment`(K0,K1,K2))=>#token("true","Bool")`` requires `_andBool_`(`_andBool_`(isThreadsCellOpt(K0),isTuplespaceCellOpt(K1)),isReactionCellOpt(K2)) ensures #token("true","Bool") []|}*)
| ((KApply3(Lbl'_LT_'T'_GT_Hyph'fragment,(varK0_1483 :: []),(varK1_1484 :: []),(varK2_1485 :: [])) :: [])) when (((((isTrue (evalisThreadsCellOpt((varK0_1483 :: [])) config (-1)))) && ((isTrue (evalisTuplespaceCellOpt((varK1_1484 :: [])) config (-1)))))) && ((isTrue (evalisReactionCellOpt((varK2_1485 :: [])) config (-1))))) && (true) -> ((Bool true) :: [])
(*{| rule ``isTCellFragment(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1486)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP (c: k * k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'LSqB'_'_LT_Hyph'_'RSqB'_MAP and sort = 
SortMap in match c with 
| _ -> try MAP.hook_update c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize3 c)))])
let eval'Hash'tell'LPar'_'RPar'_K'Hyph'IO (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'tell'LPar'_'RPar'_K'Hyph'IO and sort = 
SortInt in match c with 
| _ -> try IO.hook_tell c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalkeys (c: k) (config: k) (guard: int) : k = let lbl = 
Lblkeys and sort = 
SortSet in match c with 
| _ -> try MAP.hook_keys c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalinitRecCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitRecCell and sort = 
SortRecCell in match c with 
(*{| rule ``initRecCell(.KList)=>`<rec>`(initIdCell(.KList),initLengthCell(.KList),initContCell(.KList),initStateCell(.KList),initMatchCell(.KList),initTypeCell(.KList),initNomoCell(.KList),initListensCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(3caa91037f4b4b7f74fc246fe7352eddb3b177930ac8dfdc68cb85f7e327bcfc) initializer()]|}*)
| () -> (KApply8(Lbl'_LT_'rec'_GT_',((Lazy.force constinitIdCell)),((Lazy.force constinitLengthCell)),((Lazy.force constinitContCell)),((Lazy.force constinitStateCell)),((Lazy.force constinitMatchCell)),((Lazy.force constinitTypeCell)),((Lazy.force constinitNomoCell)),((Lazy.force constinitListensCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitRecCell : k Lazy.t = lazy (evalinitRecCell () interned_bottom (-1))
let evalisGround (c: k) (config: k) (guard: int) : k = let lbl = 
LblisGround and sort = 
SortBool in match c with 
| [String _] -> [Bool true]
| [Bool _] -> [Bool true]
| [Int _] -> [Bool true]
(*{| rule ``isGround(#KToken(#token("String","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortString, var__1487) :: [])) -> ((Bool true) :: [])
(*{| rule ``isGround(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isName(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_1488 :: [])) :: [])) when (isTrue (evalisName((varK0_1488 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isGround(`uri(_)_GRHO-SYNTAX`(K0))=>#token("true","Bool")`` requires isString(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(Lbluri'LPar'_'RPar'_GRHO'Hyph'SYNTAX,((String _ as varK0_1489) :: [])) :: [])) when true && (true) -> ((Bool true) :: [])
(*{| rule ``isGround(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBinds(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_1490 :: [])) :: [])) when (isTrue (evalisBinds((varK0_1490 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isGround(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isBind(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_1491 :: [])) :: [])) when (isTrue (evalisBind((varK0_1491 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isGround(#KToken(#token("Ground","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortGround, var__1492) :: [])) -> ((Bool true) :: [])
(*{| rule ``isGround(#KToken(#token("Int","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortInt, var__1493) :: [])) -> ((Bool true) :: [])
(*{| rule ``isGround(#KToken(#token("Bool","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortBool, var__1494) :: [])) -> ((Bool true) :: [])
(*{| rule ``isGround(`toString(_)_AUXFUN-SYNTAX`(K0))=>#token("true","Bool")`` requires isProc(K0) ensures #token("true","Bool") []|}*)
| ((KApply1(LbltoString'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX,(varK0_1495 :: [])) :: [])) when (isTrue (evalisProc((varK0_1495 :: [])) config (-1))) && (true) -> ((Bool true) :: [])
(*{| rule ``isGround(#KToken(#token("Uri","KString"),_))=>#token("true","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") []|}*)
| ((KToken (SortUri, var__1496) :: [])) -> ((Bool true) :: [])
(*{| rule ``isGround(K)=>#token("false","Bool")`` requires #token("true","Bool") ensures #token("true","Bool") [owise()]|}*)
| ((varK_1497)) -> ((Bool false) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Stop'ThreadCellBag (c: unit) (config: k) (guard: int) : k = let lbl = 
Lbl'Stop'ThreadCellBag and sort = 
SortThreadCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let const'Stop'ThreadCellBag : k Lazy.t = lazy (eval'Stop'ThreadCellBag () interned_bottom (-1))
let evalgetKLabel (c: k) (config: k) (guard: int) : k = let lbl = 
LblgetKLabel and sort = 
SortKItem in match c with 
| _ -> try KREFLECTION.hook_getKLabel c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let evalThreadCellBagItem (c: k) (config: k) (guard: int) : k = let lbl = 
LblThreadCellBagItem and sort = 
SortThreadCellBag in match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'cont'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (c: k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'cont'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX and sort = 
SortProc in match c with 
(*{| rule `` `#cont(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(_78,P))=>P`` requires `_andBool_`(isProc(P),isBinds(_78)) ensures #token("true","Bool") [UNIQUE_ID(f8512de328b9ed18c8eeb6499ffe4271c0179e583e604df7a7640f492df42f0c) contentStartColumn(8) contentStartLine(112) org.kframework.attributes.Location(Location(112,8,112,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_78_1498 :: []),(varP_1499 :: [])) :: [])) when (((isTrue (evalisProc((varP_1499 :: [])) config (-1)))) && ((isTrue (evalisBinds((var_78_1498 :: [])) config (-1))))) && (true) -> (varP_1499 :: [])
(*{| rule `` `#cont(_)_AUXFUN-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(_51,P))=>P`` requires `_andBool_`(isBind(_51),isProc(P)) ensures #token("true","Bool") [UNIQUE_ID(69ad7423aeb5794ff064523cbd189e4ed81ce9e90a709426fe0b9d963cefff74) contentStartColumn(8) contentStartLine(111) org.kframework.attributes.Location(Location(111,8,111,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| ((KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_51_1500 :: []),(varP_1501 :: [])) :: [])) when (((isTrue (evalisBind((var_51_1500 :: [])) config (-1)))) && ((isTrue (evalisProc((varP_1501 :: [])) config (-1))))) && (true) -> (varP_1501 :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize1 c)))])
let eval'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO and sort = 
SortK in match c with 
| _ -> try IO.hook_seekEnd c lbl sort config freshFunction
with Not_implemented -> match c with 
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let rec eval_'Hash'in__AUXFUN'Hyph'SYNTAX (c: k * k) (config: k) (guard: int) : k = let lbl = 
Lbl_'Hash'in__AUXFUN'Hyph'SYNTAX and sort = 
SortBool in match c with 
(*{| rule `` `_#in__AUXFUN-SYNTAX`(A,tuple(`_,__GRHO-SYNTAX`(B,C)))=>`_orBool__BOOL`(`_==Int_`(A,B),`_==Int_`(A,C))`` requires `_andBool_`(`_andBool_`(isInt(B),isInt(A)),isInt(C)) ensures #token("true","Bool") [UNIQUE_ID(26dc6151a346e0c662c35304a47d6d81e9563cfd16a84b443ced585fc3ead050) contentStartColumn(8) contentStartLine(164) org.kframework.attributes.Location(Location(164,8,164,67)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varA_1502) :: []),(KApply1(Lbltuple,(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((Int _ as varB_1503) :: []),((Int _ as varC_1504) :: [])) :: [])) :: [])) when ((((true) && (true))) && (true)) && (true) -> ([Bool ((((isTrue (eval_'EqlsEqls'Int_((varA_1502 :: []),(varB_1503 :: [])) config (-1)))) || ((isTrue (eval_'EqlsEqls'Int_((varA_1502 :: []),(varC_1504 :: [])) config (-1))))))])
(*{| rule `` `_#in__AUXFUN-SYNTAX`(A,tuple(B))=>`_==Int_`(A,B)`` requires `_andBool_`(isInt(B),isInt(A)) ensures #token("true","Bool") [UNIQUE_ID(1b64061ab611cdbd677204a96783c3e9ff2d99751eed7eab15596769815d1c84) contentStartColumn(8) contentStartLine(163) org.kframework.attributes.Location(Location(163,8,163,50)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varA_1505) :: []),(KApply1(Lbltuple,((Int _ as varB_1506) :: [])) :: [])) when ((true) && (true)) && (true) -> ((eval_'EqlsEqls'Int_((varA_1505 :: []),(varB_1506 :: [])) config (-1)))
(*{| rule `` `_#in__AUXFUN-SYNTAX`(A,tuple(`_,__GRHO-SYNTAX`(B,C)))=>`_orBool__BOOL`(`_==Int_`(A,B),`_#in__AUXFUN-SYNTAX`(A,tuple(C)))`` requires `_andBool_`(`_andBool_`(isInt(B),isInt(A)),isProcs(C)) ensures #token("true","Bool") [UNIQUE_ID(d01a99ab077fc9f1a4a6852ebecac68f8aa712c17b4f45970657026e22c7edd7) contentStartColumn(8) contentStartLine(165) org.kframework.attributes.Location(Location(165,8,165,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/AuxFun/auxfun.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (((Int _ as varA_1507) :: []),(KApply1(Lbltuple,(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,((Int _ as varB_1508) :: []),(varC_1509 :: [])) :: [])) :: [])) when ((((true) && (true))) && ((isTrue (evalisProcs((varC_1509 :: [])) config (-1))))) && (true) -> ([Bool ((((isTrue (eval_'EqlsEqls'Int_((varA_1507 :: []),(varB_1508 :: [])) config (-1)))) || ((isTrue (eval_'Hash'in__AUXFUN'Hyph'SYNTAX((varA_1507 :: []),(KApply1(Lbltuple,(varC_1509 :: [])) :: [])) config (-1))))))])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize2 c)))])
let evalinitSendCell (c: unit) (config: k) (guard: int) : k = let lbl = 
LblinitSendCell and sort = 
SortSendCell in match c with 
(*{| rule ``initSendCell(.KList)=>`<send>`(initSchanCell(.KList),initMsgCell(.KList),initTupleCell(.KList),initStypeCell(.KList),initSidCell(.KList),initMlidCell(.KList))`` requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(0f157d0b3558ae132dce818a01731d7eb241afb31f7cd79a4216bd037e2b3f75) initializer()]|}*)
| () -> (KApply6(Lbl'_LT_'send'_GT_',((Lazy.force constinitSchanCell)),((Lazy.force constinitMsgCell)),((Lazy.force constinitTupleCell)),((Lazy.force constinitStypeCell)),((Lazy.force constinitSidCell)),((Lazy.force constinitMlidCell))) :: [])
| _ -> raise (Stuck [denormalize (KApply(lbl, (denormalize0 c)))])
let constinitSendCell : k Lazy.t = lazy (evalinitSendCell () interned_bottom (-1))
let eval (c: normal_kitem) (config: k) : k = match c with KApply(lbl, kl) -> (match lbl with 
|Lbl'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lbl'Hash'argv -> eval'Hash'argv (normalize0 kl) config (-1)
|LblisThreadCell -> evalisThreadCell (normalize1 kl) config (-1)
|LblisPbindList -> evalisPbindList (normalize1 kl) config (-1)
|LblnotBool_ -> evalnotBool_ (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'Int__INT -> eval_'_LT_Eqls'Int__INT (normalize2 kl) config (-1)
|LblMap'Coln'lookup -> evalMap'Coln'lookup (normalize2 kl) config (-1)
|LblisChanList -> evalisChanList (normalize1 kl) config (-1)
|Lbl'Hash'stderr_K'Hyph'IO -> eval'Hash'stderr_K'Hyph'IO (normalize0 kl) config (-1)
|Lbl'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'seek'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblisIdNum -> evalisIdNum (normalize1 kl) config (-1)
|LblisWhoCell -> evalisWhoCell (normalize1 kl) config (-1)
|Lbl_'EqlsEqls'Bool__BOOL -> eval_'EqlsEqls'Bool__BOOL (normalize2 kl) config (-1)
|LblsignExtendBitRangeInt -> evalsignExtendBitRangeInt (normalize3 kl) config (-1)
|LblisSet -> evalisSet (normalize1 kl) config (-1)
|Lbl'Hash'getenv -> eval'Hash'getenv (normalize1 kl) config (-1)
|LblisTuplespaceCell -> evalisTuplespaceCell (normalize1 kl) config (-1)
|LblisBinds -> evalisBinds (normalize1 kl) config (-1)
|LblintersectSet -> evalintersectSet (normalize2 kl) config (-1)
|LblinitMsgCell -> evalinitMsgCell (normalize0 kl) config (-1)
|Lbl_in_keys'LPar'_'RPar'_MAP -> eval_in_keys'LPar'_'RPar'_MAP (normalize2 kl) config (-1)
|Lbl'Hash'bind'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'bind'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LblisThreadCellBag -> evalisThreadCellBag (normalize1 kl) config (-1)
|LblfindChar -> evalfindChar (normalize3 kl) config (-1)
|Lbl'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'bindocce'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LblSet'Coln'in -> evalSet'Coln'in (normalize2 kl) config (-1)
|LblisWhoCellOpt -> evalisWhoCellOpt (normalize1 kl) config (-1)
|LblisK -> evalisK (normalize1 kl) config (-1)
|LblisNew -> evalisNew (normalize1 kl) config (-1)
|LblisReceivesCell -> evalisReceivesCell (normalize1 kl) config (-1)
|LblString2Int -> evalString2Int (normalize1 kl) config (-1)
|LblinitWhereCell -> evalinitWhereCell (normalize0 kl) config (-1)
|LblisStypeCell -> evalisStypeCell (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'Set__SET -> eval_'_LT_Eqls'Set__SET (normalize2 kl) config (-1)
|Lbl_'Hash'in'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval_'Hash'in'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize2 kl) config (-1)
|LblinitThreadCell -> evalinitThreadCell (normalize1 kl) config (-1)
|LblisSingleRec -> evalisSingleRec (normalize1 kl) config (-1)
|LblisIOError -> evalisIOError (normalize1 kl) config (-1)
|LblisThreadsCell -> evalisThreadsCell (normalize1 kl) config (-1)
|LblisTupleCellOpt -> evalisTupleCellOpt (normalize1 kl) config (-1)
|Lbl'Hash'parse -> eval'Hash'parse (normalize2 kl) config (-1)
|LblisEval -> evalisEval (normalize1 kl) config (-1)
|LblisWhatCell -> evalisWhatCell (normalize1 kl) config (-1)
|LblisRhoList -> evalisRhoList (normalize1 kl) config (-1)
|LblisListenCellFragment -> evalisListenCellFragment (normalize1 kl) config (-1)
|LblmakeList -> evalmakeList (normalize2 kl) config (-1)
|Lbl_'LSqB'_'_LT_Hyph'undef'RSqB' -> eval_'LSqB'_'_LT_Hyph'undef'RSqB' (normalize2 kl) config (-1)
|Lbl'Hash'unlock'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'unlock'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl_'EqlsEqls'Int_ -> eval_'EqlsEqls'Int_ (normalize2 kl) config (-1)
|Lbl_andThenBool__BOOL -> eval_andThenBool__BOOL (normalize2 kl) config (-1)
|LblisPbinds -> evalisPbinds (normalize1 kl) config (-1)
|Lbl'Hash'parseInModule -> eval'Hash'parseInModule (normalize3 kl) config (-1)
|LblisProcs -> evalisProcs (normalize1 kl) config (-1)
|LblisAExp -> evalisAExp (normalize1 kl) config (-1)
|LblisTypeCell -> evalisTypeCell (normalize1 kl) config (-1)
|Lbl'Hash'system -> eval'Hash'system (normalize1 kl) config (-1)
|LblisLbinds -> evalisLbinds (normalize1 kl) config (-1)
|LblisLengthCell -> evalisLengthCell (normalize1 kl) config (-1)
|LblinitRidCell -> evalinitRidCell (normalize0 kl) config (-1)
|LblisString -> evalisString (normalize1 kl) config (-1)
|LblisLbind -> evalisLbind (normalize1 kl) config (-1)
|Lbl_'Perc'Int__INT -> eval_'Perc'Int__INT (normalize2 kl) config (-1)
|Lbl_'_GT__GT_'Int__INT -> eval_'_GT__GT_'Int__INT (normalize2 kl) config (-1)
|LblisList -> evalisList (normalize1 kl) config (-1)
|LblisTuplespaceCellFragment -> evalisTuplespaceCellFragment (normalize1 kl) config (-1)
|LblreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING -> evalreplaceAll'LPar'_'Comm'_'Comm'_'RPar'_STRING (normalize3 kl) config (-1)
|LblisBindList -> evalisBindList (normalize1 kl) config (-1)
|LblisForgCell -> evalisForgCell (normalize1 kl) config (-1)
|LblinitChanCell -> evalinitChanCell (normalize0 kl) config (-1)
|LblisProcList -> evalisProcList (normalize1 kl) config (-1)
|LblfindString -> evalfindString (normalize3 kl) config (-1)
|Lbl_'Xor_'Int__INT -> eval_'Xor_'Int__INT (normalize2 kl) config (-1)
|LblinitRnumCell -> evalinitRnumCell (normalize0 kl) config (-1)
|LblisRidCellOpt -> evalisRidCellOpt (normalize1 kl) config (-1)
|LblisReceivesCellFragment -> evalisReceivesCellFragment (normalize1 kl) config (-1)
|LblabsInt -> evalabsInt (normalize1 kl) config (-1)
|Lbl_'_GT_'String__STRING -> eval_'_GT_'String__STRING (normalize2 kl) config (-1)
|LblisSidCellOpt -> evalisSidCellOpt (normalize1 kl) config (-1)
|LblisSendsCellFragment -> evalisSendsCellFragment (normalize1 kl) config (-1)
|LblinitLengthCell -> evalinitLengthCell (normalize0 kl) config (-1)
|Lbl_'EqlsEqls'String__STRING -> eval_'EqlsEqls'String__STRING (normalize2 kl) config (-1)
|LblisKConfigVar -> evalisKConfigVar (normalize1 kl) config (-1)
|LblisRnumCellOpt -> evalisRnumCellOpt (normalize1 kl) config (-1)
|LblisRhoMap -> evalisRhoMap (normalize1 kl) config (-1)
|LblisSend -> evalisSend (normalize1 kl) config (-1)
|LblisKResult -> evalisKResult (normalize1 kl) config (-1)
|LblisCell -> evalisCell (normalize1 kl) config (-1)
|LblisPbind -> evalisPbind (normalize1 kl) config (-1)
|Lblvalues -> evalvalues (normalize1 kl) config (-1)
|LblinitStypeCell -> evalinitStypeCell (normalize0 kl) config (-1)
|LblList'Coln'get -> evalList'Coln'get (normalize2 kl) config (-1)
|Lbl'Hash'lstat'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'lstat'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|LblSendCellBagItem -> evalSendCellBagItem (normalize1 kl) config (-1)
|LblisThreadCellFragment -> evalisThreadCellFragment (normalize1 kl) config (-1)
|LblisStateCellOpt -> evalisStateCellOpt (normalize1 kl) config (-1)
|LblSetItem -> evalSetItem (normalize1 kl) config (-1)
|LblisNameList -> evalisNameList (normalize1 kl) config (-1)
|LblisRhoKVPairs -> evalisRhoKVPairs (normalize1 kl) config (-1)
|LblinitLidCell -> evalinitLidCell (normalize0 kl) config (-1)
|LblisListensCellOpt -> evalisListensCellOpt (normalize1 kl) config (-1)
|LblisMsidCellOpt -> evalisMsidCellOpt (normalize1 kl) config (-1)
|LblisTuplespaceCellOpt -> evalisTuplespaceCellOpt (normalize1 kl) config (-1)
|Lbl_'_LT_'Int__INT -> eval_'_LT_'Int__INT (normalize2 kl) config (-1)
|Lbl'Stop'List -> eval'Stop'List (normalize0 kl) config (-1)
|LblisSendCell -> evalisSendCell (normalize1 kl) config (-1)
|LblisSendsCellOpt -> evalisSendsCellOpt (normalize1 kl) config (-1)
|LblrandInt -> evalrandInt (normalize1 kl) config (-1)
|Lbl'Hash'configuration_K'Hyph'REFLECTION -> eval'Hash'configuration_K'Hyph'REFLECTION (normalize0 kl) config (-1)
|LblisSendsCell -> evalisSendsCell (normalize1 kl) config (-1)
|LblisFloat -> evalisFloat (normalize1 kl) config (-1)
|Lbl'Hash'close'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'close'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lblkeys_list'LPar'_'RPar'_MAP -> evalkeys_list'LPar'_'RPar'_MAP (normalize1 kl) config (-1)
|LblisContCell -> evalisContCell (normalize1 kl) config (-1)
|LblinitTypeCell -> evalinitTypeCell (normalize0 kl) config (-1)
|LblfreshId -> evalfreshId (normalize1 kl) config (-1)
|LblchrChar -> evalchrChar (normalize1 kl) config (-1)
|LblisSchanCellOpt -> evalisSchanCellOpt (normalize1 kl) config (-1)
|Lbl_orElseBool__BOOL -> eval_orElseBool__BOOL (normalize2 kl) config (-1)
|Lbl_divInt__INT -> eval_divInt__INT (normalize2 kl) config (-1)
|LblisWhereCellOpt -> evalisWhereCellOpt (normalize1 kl) config (-1)
|Lbl_ThreadCellBag_ -> eval_ThreadCellBag_ (normalize2 kl) config (-1)
|LblList'Coln'range -> evalList'Coln'range (normalize3 kl) config (-1)
|LblinitTupleCell -> evalinitTupleCell (normalize0 kl) config (-1)
|LblisProc -> evalisProc (normalize1 kl) config (-1)
|LblisListensCell -> evalisListensCell (normalize1 kl) config (-1)
|Lbl_'Plus'Int_ -> eval_'Plus'Int_ (normalize2 kl) config (-1)
|LblisKCell -> evalisKCell (normalize1 kl) config (-1)
|LblisReactionCell -> evalisReactionCell (normalize1 kl) config (-1)
|Lbl_orBool__BOOL -> eval_orBool__BOOL (normalize2 kl) config (-1)
|Lbl_'_GT_Eqls'Int__INT -> eval_'_GT_Eqls'Int__INT (normalize2 kl) config (-1)
|LblisSendCellFragment -> evalisSendCellFragment (normalize1 kl) config (-1)
|LblisReactionCellOpt -> evalisReactionCellOpt (normalize1 kl) config (-1)
|LblupdateMap -> evalupdateMap (normalize2 kl) config (-1)
|LblisNomoCell -> evalisNomoCell (normalize1 kl) config (-1)
|LblisJoinList -> evalisJoinList (normalize1 kl) config (-1)
|LblInt2String -> evalInt2String (normalize1 kl) config (-1)
|Lbl'Hash'stype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'stype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'K_ -> eval_'EqlsSlshEqls'K_ (normalize2 kl) config (-1)
|Lbl'Hash'lock'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'lock'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblisNumCell -> evalisNumCell (normalize1 kl) config (-1)
|LblcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING -> evalcountAllOccurrences'LPar'_'Comm'_'RPar'_STRING (normalize2 kl) config (-1)
|Lbl_'_GT_'Int__INT -> eval_'_GT_'Int__INT (normalize2 kl) config (-1)
|LblfillList -> evalfillList (normalize4 kl) config (-1)
|LblinitForgCell -> evalinitForgCell (normalize0 kl) config (-1)
|LblbitRangeInt -> evalbitRangeInt (normalize3 kl) config (-1)
|LblisRecCell -> evalisRecCell (normalize1 kl) config (-1)
|Lbl_'_LT_'String__STRING -> eval_'_LT_'String__STRING (normalize2 kl) config (-1)
|Lbl_List_ -> eval_List_ (normalize2 kl) config (-1)
|LblisMultiRec -> evalisMultiRec (normalize1 kl) config (-1)
|Lbl'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'open'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl_'PipeHyph_GT_'_ -> eval_'PipeHyph_GT_'_ (normalize2 kl) config (-1)
|Lbl_xorBool__BOOL -> eval_xorBool__BOOL (normalize2 kl) config (-1)
|LblisMatchCellOpt -> evalisMatchCellOpt (normalize1 kl) config (-1)
|Lbl_'Hyph'Map__MAP -> eval_'Hyph'Map__MAP (normalize2 kl) config (-1)
|Lbl'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'length'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LblisRhoSet -> evalisRhoSet (normalize1 kl) config (-1)
|LblinitReactCell -> evalinitReactCell (normalize0 kl) config (-1)
|Lbl'Stop'RecCellBag -> eval'Stop'RecCellBag (normalize0 kl) config (-1)
|LblisReceivesCellOpt -> evalisReceivesCellOpt (normalize1 kl) config (-1)
|LblisListenCellBag -> evalisListenCellBag (normalize1 kl) config (-1)
|Lbl_'EqlsEqls'K_ -> eval_'EqlsEqls'K_ (normalize2 kl) config (-1)
|Lbl'Hash'sort -> eval'Hash'sort (normalize1 kl) config (-1)
|Lbl'Hash'open'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'open'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl_ListenCellBag_ -> eval_ListenCellBag_ (normalize2 kl) config (-1)
|Lbl_'LSqB'_'RSqB'_SUBSTITUTION -> eval_'LSqB'_'RSqB'_SUBSTITUTION (normalize2 kl) config (-1)
|LblisPar -> evalisPar (normalize1 kl) config (-1)
|LblreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING -> evalreplaceFirst'LPar'_'Comm'_'Comm'_'RPar'_STRING (normalize3 kl) config (-1)
|LblinitListensCell -> evalinitListensCell (normalize0 kl) config (-1)
|Lbl'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'putc'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblisThreadsCellOpt -> evalisThreadsCellOpt (normalize1 kl) config (-1)
|LblisChanCell -> evalisChanCell (normalize1 kl) config (-1)
|LblisRnumCell -> evalisRnumCell (normalize1 kl) config (-1)
|LblisVarsCell -> evalisVarsCell (normalize1 kl) config (-1)
|Lbl'Stop'Map -> eval'Stop'Map (normalize0 kl) config (-1)
|Lbl'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'chanmany'LPar'_'Coln'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize2 kl) config (-1)
|Lbl'Hash'logToFile -> eval'Hash'logToFile (normalize2 kl) config (-1)
|Lbl_'EqlsSlshEqls'String__STRING -> eval_'EqlsSlshEqls'String__STRING (normalize2 kl) config (-1)
|Lbl'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'read'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblinitMlidCell -> evalinitMlidCell (normalize0 kl) config (-1)
|LblisNameVar -> evalisNameVar (normalize1 kl) config (-1)
|LblisSendCellBag -> evalisSendCellBag (normalize1 kl) config (-1)
|LblId2String -> evalId2String (normalize1 kl) config (-1)
|LblisInt -> evalisInt (normalize1 kl) config (-1)
|LblinitListenCell -> evalinitListenCell (normalize0 kl) config (-1)
|LblisContCellOpt -> evalisContCellOpt (normalize1 kl) config (-1)
|LblisLidCellOpt -> evalisLidCellOpt (normalize1 kl) config (-1)
|Lbl'Hash'fresh -> eval'Hash'fresh (normalize1 kl) config (-1)
|LblMap'Coln'choice -> evalMap'Coln'choice (normalize1 kl) config (-1)
|Lbl_impliesBool__BOOL -> eval_impliesBool__BOOL (normalize2 kl) config (-1)
|Lbl'Hash'getc'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'getc'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl_Set_ -> eval_Set_ (normalize2 kl) config (-1)
|Lbl'Hash'chanlist'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'chanlist'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lbl_'Star'Int__INT -> eval_'Star'Int__INT (normalize2 kl) config (-1)
|LblmaxInt'LPar'_'Comm'_'RPar'_INT -> evalmaxInt'LPar'_'Comm'_'RPar'_INT (normalize2 kl) config (-1)
|LblisRidCell -> evalisRidCell (normalize1 kl) config (-1)
|LblinitReceivesCell -> evalinitReceivesCell (normalize0 kl) config (-1)
|LblisListenCell -> evalisListenCell (normalize1 kl) config (-1)
|LblisBool -> evalisBool (normalize1 kl) config (-1)
|Lbl'Tild'Int__INT -> eval'Tild'Int__INT (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'String__STRING -> eval_'_LT_Eqls'String__STRING (normalize2 kl) config (-1)
|LblordChar -> evalordChar (normalize1 kl) config (-1)
|LblinitIdCell -> evalinitIdCell (normalize0 kl) config (-1)
|LblisRbinds -> evalisRbinds (normalize1 kl) config (-1)
|LblrfindChar -> evalrfindChar (normalize3 kl) config (-1)
|Lbl_modInt__INT -> eval_modInt__INT (normalize2 kl) config (-1)
|LblListenCellBagItem -> evalListenCellBagItem (normalize1 kl) config (-1)
|LblisNames -> evalisNames (normalize1 kl) config (-1)
|LblisMlidCellOpt -> evalisMlidCellOpt (normalize1 kl) config (-1)
|Lbl'Stop'ListenCellBag -> eval'Stop'ListenCellBag (normalize0 kl) config (-1)
|Lbl_Map_ -> eval_Map_ (normalize2 kl) config (-1)
|Lbl_'Hyph'Int__INT -> eval_'Hyph'Int__INT (normalize2 kl) config (-1)
|LblisReactionCellFragment -> evalisReactionCellFragment (normalize1 kl) config (-1)
|LblinitSchanCell -> evalinitSchanCell (normalize0 kl) config (-1)
|Lbl'Hash'lengths'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'lengths'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LbldirectionalityChar -> evaldirectionalityChar (normalize1 kl) config (-1)
|LblFloat2String -> evalFloat2String (normalize1 kl) config (-1)
|LblisIdCell -> evalisIdCell (normalize1 kl) config (-1)
|Lbl'Hash'opendir'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'opendir'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lbl'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize2 kl) config (-1)
|LblinitKCell -> evalinitKCell (normalize1 kl) config (-1)
|LblRecCellBagItem -> evalRecCellBagItem (normalize1 kl) config (-1)
|LblinitWhoCell -> evalinitWhoCell (normalize0 kl) config (-1)
|LblisBExp -> evalisBExp (normalize1 kl) config (-1)
|LblsizeList -> evalsizeList (normalize1 kl) config (-1)
|LblisChanLen -> evalisChanLen (normalize1 kl) config (-1)
|Lbl'Stop'Set -> eval'Stop'Set (normalize0 kl) config (-1)
|LblinitTuplespaceCell -> evalinitTuplespaceCell (normalize0 kl) config (-1)
|LblString2Id -> evalString2Id (normalize1 kl) config (-1)
|LblisStateCell -> evalisStateCell (normalize1 kl) config (-1)
|Lbl_'EqlsSlshEqls'Bool__BOOL -> eval_'EqlsSlshEqls'Bool__BOOL (normalize2 kl) config (-1)
|LblisCollection -> evalisCollection (normalize1 kl) config (-1)
|LblisSidCell -> evalisSidCell (normalize1 kl) config (-1)
|LblremoveAll -> evalremoveAll (normalize2 kl) config (-1)
|LblisTCell -> evalisTCell (normalize1 kl) config (-1)
|Lbl_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION -> eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION (normalize3 kl) config (-1)
|Lbl'Hash'msg'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'msg'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lbl_andBool_ -> eval_andBool_ (normalize2 kl) config (-1)
|Lbl_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval_'Hash'ine'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize2 kl) config (-1)
|LblisThreadsCellFragment -> evalisThreadsCellFragment (normalize1 kl) config (-1)
|LblisLengthCellOpt -> evalisLengthCellOpt (normalize1 kl) config (-1)
|LblisRbindList -> evalisRbindList (normalize1 kl) config (-1)
|LblisConsumableSend -> evalisConsumableSend (normalize1 kl) config (-1)
|LbllengthString -> evallengthString (normalize1 kl) config (-1)
|LblinitNomoCell -> evalinitNomoCell (normalize0 kl) config (-1)
|LblisReceive -> evalisReceive (normalize1 kl) config (-1)
|LblinitTCell -> evalinitTCell (normalize1 kl) config (-1)
|Lbl'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LblFloatFormat -> evalFloatFormat (normalize2 kl) config (-1)
|LblisMsidCell -> evalisMsidCell (normalize1 kl) config (-1)
|LblisRhoTuple -> evalisRhoTuple (normalize1 kl) config (-1)
|Lbl_'Plus'String__STRING -> eval_'Plus'String__STRING (normalize2 kl) config (-1)
|Lbl_'Xor_Perc'Int___INT -> eval_'Xor_Perc'Int___INT (normalize3 kl) config (-1)
|Lbl_RecCellBag_ -> eval_RecCellBag_ (normalize2 kl) config (-1)
|Lbl_'Pipe'Int__INT -> eval_'Pipe'Int__INT (normalize2 kl) config (-1)
|LblisMsgCellOpt -> evalisMsgCellOpt (normalize1 kl) config (-1)
|LblisKVariable -> evalisKVariable (normalize1 kl) config (-1)
|Lbl_dividesInt__INT -> eval_dividesInt__INT (normalize2 kl) config (-1)
|LblrfindString -> evalrfindString (normalize3 kl) config (-1)
|LblisChanCellOpt -> evalisChanCellOpt (normalize1 kl) config (-1)
|Lbl'Hash'stat'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'stat'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|LblisLidCell -> evalisLidCell (normalize1 kl) config (-1)
|LblupdateList -> evalupdateList (normalize3 kl) config (-1)
|LblisMsgCell -> evalisMsgCell (normalize1 kl) config (-1)
|Lbl'Stop'SendCellBag -> eval'Stop'SendCellBag (normalize0 kl) config (-1)
|LblinitContCell -> evalinitContCell (normalize0 kl) config (-1)
|LblisWhatCellOpt -> evalisWhatCellOpt (normalize1 kl) config (-1)
|LblSet'Coln'choice -> evalSet'Coln'choice (normalize1 kl) config (-1)
|LblisMatchCell -> evalisMatchCell (normalize1 kl) config (-1)
|LblisListensCellFragment -> evalisListensCellFragment (normalize1 kl) config (-1)
|LblcategoryChar -> evalcategoryChar (normalize1 kl) config (-1)
|LblisName -> evalisName (normalize1 kl) config (-1)
|LblSet'Coln'difference -> evalSet'Coln'difference (normalize2 kl) config (-1)
|LblinitNumCell -> evalinitNumCell (normalize0 kl) config (-1)
|LblfreshInt -> evalfreshInt (normalize1 kl) config (-1)
|LblisBundle -> evalisBundle (normalize1 kl) config (-1)
|LblisKCellOpt -> evalisKCellOpt (normalize1 kl) config (-1)
|LblinitSidCell -> evalinitSidCell (normalize0 kl) config (-1)
|Lbl'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'write'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|LblisForgCellOpt -> evalisForgCellOpt (normalize1 kl) config (-1)
|LblisLbindList -> evalisLbindList (normalize1 kl) config (-1)
|LblisUnconsumableSend -> evalisUnconsumableSend (normalize1 kl) config (-1)
|LblisRecCellFragment -> evalisRecCellFragment (normalize1 kl) config (-1)
|LblisIdCellOpt -> evalisIdCellOpt (normalize1 kl) config (-1)
|LblisSchanCell -> evalisSchanCell (normalize1 kl) config (-1)
|Lbl_xorInt__INT -> eval_xorInt__INT (normalize2 kl) config (-1)
|LblMap'Coln'lookupOrDefault -> evalMap'Coln'lookupOrDefault (normalize3 kl) config (-1)
|LblString2Float -> evalString2Float (normalize1 kl) config (-1)
|LblinitVarsCell -> evalinitVarsCell (normalize0 kl) config (-1)
|Lbl'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL -> eval'Hash'if_'Hash'then_'Hash'else_'Hash'fi_K'Hyph'EQUAL (normalize3 kl) config (-1)
|LblisNumCellOpt -> evalisNumCellOpt (normalize1 kl) config (-1)
|LblinitStateCell -> evalinitStateCell (normalize0 kl) config (-1)
|Lbl'Hash'stdout_K'Hyph'IO -> eval'Hash'stdout_K'Hyph'IO (normalize0 kl) config (-1)
|LblinitMatchCell -> evalinitMatchCell (normalize0 kl) config (-1)
|Lbl_'And'Int__INT -> eval_'And'Int__INT (normalize2 kl) config (-1)
|LblisMlidCell -> evalisMlidCell (normalize1 kl) config (-1)
|Lbl'Hash'rtype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'rtype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LblinitWhatCell -> evalinitWhatCell (normalize0 kl) config (-1)
|Lbl_'EqlsSlshEqls'Int__INT -> eval_'EqlsSlshEqls'Int__INT (normalize2 kl) config (-1)
|Lbl_'_LT__LT_'Int__INT -> eval_'_LT__LT_'Int__INT (normalize2 kl) config (-1)
|Lbllog2Int -> evallog2Int (normalize1 kl) config (-1)
|Lbl'Hash'stdin_K'Hyph'IO -> eval'Hash'stdin_K'Hyph'IO (normalize0 kl) config (-1)
|Lbl'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'chanlen'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LblBase2String -> evalBase2String (normalize2 kl) config (-1)
|LblListItem -> evalListItem (normalize1 kl) config (-1)
|LblisStream -> evalisStream (normalize1 kl) config (-1)
|Lbl_'_GT_Eqls'String__STRING -> eval_'_GT_Eqls'String__STRING (normalize2 kl) config (-1)
|LblisBindOcc -> evalisBindOcc (normalize1 kl) config (-1)
|Lbl_'_LT_Eqls'Map__MAP -> eval_'_LT_Eqls'Map__MAP (normalize2 kl) config (-1)
|LblnewUUID_STRING -> evalnewUUID_STRING (normalize0 kl) config (-1)
|LblsizeMap -> evalsizeMap (normalize1 kl) config (-1)
|LblisWhereCell -> evalisWhereCell (normalize1 kl) config (-1)
|LblisId -> evalisId (normalize1 kl) config (-1)
|LblinitThreadsCell -> evalinitThreadsCell (normalize1 kl) config (-1)
|LblsubstrString -> evalsubstrString (normalize3 kl) config (-1)
|Lbl_SendCellBag_ -> eval_SendCellBag_ (normalize2 kl) config (-1)
|LblisTypeCellOpt -> evalisTypeCellOpt (normalize1 kl) config (-1)
|Lblsize -> evalsize (normalize1 kl) config (-1)
|Lbl'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'bindocc'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lblproject'Coln'Proc -> evalproject'Coln'Proc (normalize1 kl) config (-1)
|LblisBind -> evalisBind (normalize1 kl) config (-1)
|LblisReactCellOpt -> evalisReactCellOpt (normalize1 kl) config (-1)
|Lbl_inList_ -> eval_inList_ (normalize2 kl) config (-1)
|LblisVarsCellOpt -> evalisVarsCellOpt (normalize1 kl) config (-1)
|LblminInt'LPar'_'Comm'_'RPar'_INT -> evalminInt'LPar'_'Comm'_'RPar'_INT (normalize2 kl) config (-1)
|LblinitReactionCell -> evalinitReactionCell (normalize0 kl) config (-1)
|LblisMap -> evalisMap (normalize1 kl) config (-1)
|LblsrandInt -> evalsrandInt (normalize1 kl) config (-1)
|LblisTupleCell -> evalisTupleCell (normalize1 kl) config (-1)
|LblisKItem -> evalisKItem (normalize1 kl) config (-1)
|Lbl'Hash'length__AUXFUN'Hyph'SYNTAX -> eval'Hash'length__AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LblisReactCell -> evalisReactCell (normalize1 kl) config (-1)
|LblinitMsidCell -> evalinitMsidCell (normalize0 kl) config (-1)
|LblisRecCellBag -> evalisRecCellBag (normalize1 kl) config (-1)
|LblisUri -> evalisUri (normalize1 kl) config (-1)
|LblList'Coln'set -> evalList'Coln'set (normalize3 kl) config (-1)
|LblString2Base -> evalString2Base (normalize2 kl) config (-1)
|LblisStypeCellOpt -> evalisStypeCellOpt (normalize1 kl) config (-1)
|LblisNomoCellOpt -> evalisNomoCellOpt (normalize1 kl) config (-1)
|LblisTCellFragment -> evalisTCellFragment (normalize1 kl) config (-1)
|Lblreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING -> evalreplace'LPar'_'Comm'_'Comm'_'Comm'_'RPar'_STRING (normalize4 kl) config (-1)
|Lbl_'Slsh'Int__INT -> eval_'Slsh'Int__INT (normalize2 kl) config (-1)
|LblisRbind -> evalisRbind (normalize1 kl) config (-1)
|Lbl_'LSqB'_'_LT_Hyph'_'RSqB'_MAP -> eval_'LSqB'_'_LT_Hyph'_'RSqB'_MAP (normalize3 kl) config (-1)
|Lbl'Hash'tell'LPar'_'RPar'_K'Hyph'IO -> eval'Hash'tell'LPar'_'RPar'_K'Hyph'IO (normalize1 kl) config (-1)
|Lblkeys -> evalkeys (normalize1 kl) config (-1)
|LblinitRecCell -> evalinitRecCell (normalize0 kl) config (-1)
|LblinitSendsCell -> evalinitSendsCell (normalize0 kl) config (-1)
|LblisGround -> evalisGround (normalize1 kl) config (-1)
|Lbl'Stop'ThreadCellBag -> eval'Stop'ThreadCellBag (normalize0 kl) config (-1)
|LblgetKLabel -> evalgetKLabel (normalize1 kl) config (-1)
|LblThreadCellBagItem -> evalThreadCellBagItem (normalize1 kl) config (-1)
|Lbl'Hash'cont'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'cont'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lbl'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO -> eval'Hash'seekEnd'LPar'_'Comm'_'RPar'_K'Hyph'IO (normalize2 kl) config (-1)
|Lbl_'Hash'in__AUXFUN'Hyph'SYNTAX -> eval_'Hash'in__AUXFUN'Hyph'SYNTAX (normalize2 kl) config (-1)
|Lbl'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX -> eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX (normalize1 kl) config (-1)
|LblinitSendCell -> evalinitSendCell (normalize0 kl) config (-1)
|Lbl_'Plus'__GRHO'Hyph'SYNTAX -> eval_'Plus'__GRHO'Hyph'SYNTAX (normalize2 kl) config (-1)
|Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX -> eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX (normalize2 kl) config (-1)
|Lbl_'Star'__GRHO'Hyph'SYNTAX -> eval_'Star'__GRHO'Hyph'SYNTAX (normalize2 kl) config (-1)
|Lblnot__GRHO'Hyph'SYNTAX -> evalnot__GRHO'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lbl_'Hyph'__GRHO'Hyph'SYNTAX -> eval_'Hyph'__GRHO'Hyph'SYNTAX (normalize2 kl) config (-1)
|Lbl'_AT_'__GRHO'Hyph'SYNTAX -> eval'_AT_'__GRHO'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lbl'Star'__GRHO'Hyph'SYNTAX -> eval'Star'__GRHO'Hyph'SYNTAX (normalize1 kl) config (-1)
|Lbl_and__GRHO'Hyph'SYNTAX -> eval_and__GRHO'Hyph'SYNTAX (normalize2 kl) config (-1)
| _ -> [denormalize c])
| _ -> [denormalize c]
let rec get_next_op_from_exp(c: kitem) : (k -> k * (step_function)) = step
and step (c:k) : k * step_function =
 try let config = c in match c with 
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`` `<thread>`(`<k>`(.K))=>`.ThreadCellBag`(.KList)``,DotVar1)),_0,_1) requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(8236ddfc6eb920764c04e2eff79e625d2e55f8c2f8d792e8b54a894d952518f4) contentStartColumn(8) contentStartLine(1612) org.kframework.attributes.Location(Location(1612,8,1612,47)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',([])) :: [])) :: []),(varDotVar1_1510 :: [])) config (-1)) :: [])) :: []),(var_0_1511),(var_1_1512)) :: []) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_(((Lazy.force const'Stop'ThreadCellBag)),(varDotVar1_1510 :: [])) config (-1)))) :: []),(var_0_1511),(var_1_1512)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_|__GRHO-SYNTAX`(P,`Nil_GRHO-SYNTAX`(.KList))=>P``~>DotVar3)),DotVar1)),_0,_1) requires isProc(P) ensures #token("true","Bool") [UNIQUE_ID(e390077f99cce6c65e7b2a791c3442a3a8d8aec95063966e1ea01cf93f457935) contentStartColumn(8) contentStartLine(1609) org.kframework.attributes.Location(Location(1609,8,1609,28)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Pipe'__GRHO'Hyph'SYNTAX,(varP_1513 :: []),(KApply0(LblNil_GRHO'Hyph'SYNTAX) :: [])) :: varDotVar3_1514)) :: [])) :: []),(varDotVar1_1515 :: [])) config (-1)) :: [])) :: []),(var_0_1516),(var_1_1517)) :: []) when (isTrue (evalisProc((varP_1513 :: [])) config (-1))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_1513 :: varDotVar3_1514)) :: [])) :: []),(varDotVar1_1515 :: [])) config (-1)))) :: []),(var_0_1516),(var_1_1517)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_|__GRHO-SYNTAX`(`Nil_GRHO-SYNTAX`(.KList),P)=>P``~>DotVar3)),DotVar1)),_0,_1) requires isProc(P) ensures #token("true","Bool") [UNIQUE_ID(b8205f2febbf01bd88cf55a3d80fe81a0c315b3c2ea7adb4bb63b1a7cead6290) contentStartColumn(11) contentStartLine(1608) org.kframework.attributes.Location(Location(1608,11,1608,28)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Pipe'__GRHO'Hyph'SYNTAX,(KApply0(LblNil_GRHO'Hyph'SYNTAX) :: []),(varP_1518 :: [])) :: varDotVar3_1519)) :: [])) :: []),(varDotVar1_1520 :: [])) config (-1)) :: [])) :: []),(var_0_1521),(var_1_1522)) :: []) when (isTrue (evalisProc((varP_1518 :: [])) config (-1))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_1518 :: varDotVar3_1519)) :: [])) :: []),(varDotVar1_1520 :: [])) config (-1)))) :: []),(var_0_1521),(var_1_1522)) :: [])), (StepFunc step))
(*{| rule `<T>`(_7,`<tuplespace>`(DotVar1,`<receives>`(`_RecCellBag_`(`<rec>`(_0,_1,_2,_3,_4,_5,_6,`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(#token("\"\"","String")),`<vars>`(#token("\"\"","String")),`<num>`(#token("\"\"","String")),`<lid>`(#token("\"\"","String")),`<msid>`(#token("\"\"","String")))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar2))),_8) requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(01cfe85d93b2e91bba600f2fd058554e01b885b5d114489338145d10a6912d43) contentStartColumn(5) contentStartLine(1597) org.kframework.attributes.Location(Location(1597,5,1605,15)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(var_7_1523),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_1524),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(var_0_1525),(var_1_1526),(var_2_1527),(var_3_1528),(var_4_1529),(var_5_1530),(var_6_1531),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(varDotVar4_1532 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar2_1533 :: [])) config (-1)) :: [])) :: [])) :: []),(var_8_1534)) :: []) -> (((KApply3(Lbl'_LT_'T'_GT_',(var_7_1523),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_1524),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(var_0_1525),(var_1_1526),(var_2_1527),(var_3_1528),(var_4_1529),(var_5_1530),(var_6_1531),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1532 :: [])) config (-1)))) :: [])) :: []),(varDotVar2_1533 :: [])) config (-1)))) :: [])) :: []),(var_8_1534)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`` `<thread>`(`<k>`(`Nil_GRHO-SYNTAX`(.KList)))=>`.ThreadCellBag`(.KList)``,DotVar1)),_0,_1) requires #token("true","Bool") ensures #token("true","Bool") [UNIQUE_ID(5c1c20d2c0b640a497dafef7e0f92bdfb5a0f86b1cc1709668d8ff02ecd1fb7a) contentStartColumn(8) contentStartLine(1613) org.kframework.attributes.Location(Location(1613,8,1613,47)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K) structural()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply0(LblNil_GRHO'Hyph'SYNTAX) :: [])) :: [])) :: []),(varDotVar1_1535 :: [])) config (-1)) :: [])) :: []),(var_0_1536),(var_1_1537)) :: []) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_(((Lazy.force const'Stop'ThreadCellBag)),(varDotVar1_1535 :: [])) config (-1)))) :: []),(var_0_1536),(var_1_1537)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_70),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_71),`<nomo>`(_183),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`#append(_;_)_AUXFUN-SYNTAX`(Q,R)``),`<where>`(``Z=>`#append(_;_)_AUXFUN-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``U=>`_+Int_`(U,#token("1","Int"))``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isInt(J)),isSet(_183)),isInt(L)),isProcs(R)),isName(X)),isInt(V)),isInt(I)),isNames(Y)),isSet(S)),isNames(Z)),isProc(P)),isInt(N)),isInt(U)),`_>Int__INT`(L,U))),`_andBool_`(`_==Int_`(_71,#token("0","Int")),`_==Int_`(_70,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(58a9c2007c853e7392eb58312943b54f2ebc9350e8eed3a93f4d84bd05928fb6) collect() contentStartColumn(5) contentStartLine(1064) org.kframework.attributes.Location(Location(1064,5,1101,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1538),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1539 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1540 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_1541) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_70_1542) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1543) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1544) :: [])) :: [])) :: []),(varDotVar2_1545 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1546) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1547) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1548 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1549) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_71_1550) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_183_1551) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1552 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1553 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_1554) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1555) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1556) :: [])) :: [])) :: []),(varDotVar4_1557 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1558 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1559 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1560 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1561 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1562) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varU_1563) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1564)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1564)) config (-1)))) && ((((((((((((((((((((((((((((((isTrue (evalisProcs((varQ_1540 :: [])) config (-1)))) && (true))) && (true))) && (true))) && ((isTrue (evalisProcs((varR_1560 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_1552 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisNames((varY_1553 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisNames((varZ_1561 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_1548 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_1547 :: []),(varU_1563 :: [])) config (-1)))))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_71_1550 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_70_1542 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem varI_1556 varI_1543) = 0) && ((compare_kitem varL_1547 varL_1549) = 0) && ((compare_kitem varJ_1546 varJ_1562) = 0) && ((compare_kitem varN_1554 varN_1541) = 0) && ((compare_kitem varX_1552 varX_1539) = 0) && ((compare_kitem varP_1548 varP_1559) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1538),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_1545 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1546 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1547 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1548 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1547 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_71_1550 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_183_1551 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1557 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1558 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1548 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varQ_1540 :: []),(varR_1560 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'where'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varY_1553 :: []),(varZ_1561 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1546 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((eval_'Plus'Int_((varU_1563 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_1544 :: []),((evalSetItem((varV_1555 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<receives>`(`_RecCellBag_`(`` `<rec>`(`<id>`(J),`<length>`(L),`<cont>`(_89),`<state>`(#token("\"collection\"","String")),`<match>`(_90),`<type>`(T),`<nomo>`(_91),`<listens>`(_92))=>`.RecCellBag`(.KList)``,DotVar2))),`<reaction>`(`<who>`(_93),`<what>`(_94),`<where>`(_95),`<rid>`(J),`<rnum>`(L),`<react>`(``#token("\"forget\"","String")=>#token("\"react\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(T),isInt(J)),isInt(L)),isSet(_91)),`_andBool_`(#token("true","Bool"),isListenCellBag(_92))),`_=/=Int__INT`(T,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(04cd910f0c96013e6f7307ae34455f46ad696f321ec53a66932aa26608abc769) comm() contentStartColumn(4) contentStartLine(562) org.kframework.attributes.Location(Location(562,4,581,24)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1565),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_1566),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1567) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1568) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_89_1569)) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_90_1570)) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as varT_1571) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_91_1572) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_92_1573 :: [])) :: [])) :: []),(varDotVar2_1574 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_93_1575)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_94_1576)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_95_1577)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1578) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varL_1579) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1580)) :: [])) :: [])) :: []) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1580)) config (-1)))) && (((((((((((true) && (true))) && (true))) && (true))) && (((true) && ((isTrue (evalisListenCellBag((var_92_1573 :: [])) config (-1)))))))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varT_1571 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varL_1568 varL_1579) = 0) && ((compare_kitem varJ_1567 varJ_1578) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1565),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_1566),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_(((Lazy.force const'Stop'RecCellBag)),(varDotVar2_1574 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_93_1575)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_94_1576)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_95_1577)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1567 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(varL_1568 :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "react") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1580)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_106),`<stype>`(_107),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_108),`<nomo>`(_194),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_109),`<lid>`(V),`<msid>`(``I=>#token("\"\"","String")``)),DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`_,__GRHO-SYNTAX`(Q,R)``),`<where>`(``Z=>`_,__GRHO-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``U=>`_+Int_`(U,#token("1","Int"))``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isSet(_194)),isProc(Q)),isInt(J)),isInt(L)),isProcs(R)),isName(X)),isInt(V)),isInt(I)),isSet(S)),isNames(Z)),isProc(P)),isInt(U)),`_>Int__INT`(L,U))),`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_108,#token("1","Int")),`_==Int_`(_107,#token("0","Int"))),`_==Int_`(_109,#token("1","Int"))),`_==Int_`(_106,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(0647b0dbaa10f865ea7260edf519eb10226ca803ed6e6569ef16da5d1254807f) collect() contentStartColumn(5) contentStartLine(1187) org.kframework.attributes.Location(Location(1187,5,1224,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1581),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1582 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1583 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_106_1584) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_107_1585) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1586) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1587) :: [])) :: [])) :: []),(varDotVar2_1588 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1589) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1590) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1591 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1592) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_108_1593) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_194_1594) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1595 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1596 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_109_1597) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1598) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1599) :: [])) :: [])) :: []),(varDotVar4_1600 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1601 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1602 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1603 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1604 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1605) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varU_1606) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1607)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1607)) config (-1)))) && ((((((((((((((((((((((((((((isTrue (evalisName((varY_1596 :: [])) config (-1)))) && (true))) && ((isTrue (evalisProc((varQ_1583 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProcs((varR_1603 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_1595 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisNames((varZ_1604 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_1602 :: [])) config (-1)))))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_1590 :: []),(varU_1606 :: [])) config (-1)))))))) && ((((((((isTrue (eval_'EqlsEqls'Int_((var_108_1593 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_107_1585 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_109_1597 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_106_1584 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_1586 varI_1599) = 0) && ((compare_kitem varL_1590 varL_1592) = 0) && ((compare_kitem varJ_1605 varJ_1589) = 0) && ((compare_kitem varX_1595 varX_1582) = 0) && ((compare_kitem varP_1602 varP_1591) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1581),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_1588 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1605 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1590 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1602 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1590 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_108_1593 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_194_1594 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1595 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1596 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',(var_109_1597 :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(varV_1598 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(varDotVar4_1600 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1601 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1602 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_1583 :: []),(varR_1603 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_1596 :: []),(varZ_1604 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1605 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((eval_'Plus'Int_((varU_1606 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_1587 :: []),((evalSetItem((varV_1598 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(_0,_1,`<reaction>`(`<who>`(``P=>`_[_/_]_SUBSTITUTION`(P,`@__GRHO-SYNTAX`(Q),Y)``),`<what>`(`` `_,__GRHO-SYNTAX`(Q,R)=>R``),`<where>`(`` `_,__GRHO-SYNTAX`(Y,Z)=>Z``),`<rid>`(_108),`<rnum>`(_109),`<react>`(#token("\"react\"","String")),`<forg>`(_2))) requires `_andBool_`(`_==K_`(`.Set`(.KList),_2),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isName(Z)),isProc(R)),isProc(P))) ensures #token("true","Bool") [UNIQUE_ID(6e3f33f7eb820903dc29d5a421cb670a9e0ba4d421b46eef5d789f433fc3757e) comm() contentStartColumn(5) contentStartLine(418) org.kframework.attributes.Location(Location(418,5,426,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(var_0_1608),(var_1_1609),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1610 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_1611 :: []),(varR_1612 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_1613 :: []),(varZ_1614 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(var_108_1615)) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_109_1616)) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "react") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_2_1617)) :: [])) :: [])) :: []) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_2_1617)) config (-1)))) && ((((((((((isTrue (evalisName((varY_1613 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_1611 :: [])) config (-1)))))) && ((isTrue (evalisName((varZ_1614 :: [])) config (-1)))))) && ((isTrue (evalisProc((varR_1612 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_1610 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(var_0_1608),(var_1_1609),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',((eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION((varP_1610 :: []),((eval'_AT_'__GRHO'Hyph'SYNTAX((varQ_1611 :: [])) config (-1))),(varY_1613 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1612 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1614 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(var_108_1615)) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_109_1616)) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "react") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_2_1617)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_30),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_31),`<nomo>`(_166),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``#token("\"\"","String")=>Q``),`<where>`(``#token("\"\"","String")=>Y``),`<rid>`(J),`<rnum>`(``_32=>#token("1","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isInt(J)),isSet(_166)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isNames(Y)),isSet(S)),isProc(P)),isInt(N))),`_andBool_`(`_andBool_`(`_==Int_`(_32,#token("0","Int")),`_==Int_`(_30,#token("0","Int"))),`_==Int_`(_31,#token("2","Int")))) ensures #token("true","Bool") [UNIQUE_ID(557ab08dd5affac5bf902602cb31c10bcbdd4e437d864b0d255e1d44dde7b1ed) contentStartColumn(5) contentStartLine(817) initialize() org.kframework.attributes.Location(Location(817,5,853,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1618),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1619 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1620 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_1621) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_30_1622) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1623) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1624) :: [])) :: [])) :: []),(varDotVar2_1625 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1626) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1627) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1628 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1629) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_31_1630) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_166_1631) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1632 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1633 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_1634) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1635) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1636) :: [])) :: [])) :: []),(varDotVar4_1637 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1638 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1639 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1640) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_32_1641) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1642)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1642)) config (-1)))) && ((((((((((((((((((((((isTrue (evalisProcs((varQ_1620 :: [])) config (-1)))) && (true))) && (true))) && (true))) && ((isTrue (evalisName((varX_1619 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisNames((varY_1633 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_1628 :: [])) config (-1)))))) && (true))))) && ((((((isTrue (eval_'EqlsEqls'Int_((var_32_1641 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_30_1622 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_31_1630 :: []),((Lazy.force int2) :: [])) config (-1))))))) && (((compare_kitem varI_1623 varI_1636) = 0) && ((compare_kitem varL_1627 varL_1629) = 0) && ((compare_kitem varJ_1626 varJ_1640) = 0) && ((compare_kitem varN_1634 varN_1621) = 0) && ((compare_kitem varX_1619 varX_1632) = 0) && ((compare_kitem varP_1628 varP_1639) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1618),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1619 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1620 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(varN_1634 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_30_1622 :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_1623 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_1624 :: []),((evalSetItem((varV_1635 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_1625 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1626 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1627 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1628 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1627 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_31_1630 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_166_1631 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1637 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1638 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1628 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_1620 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_1633 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1626 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1642)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_93),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_94),`<nomo>`(_162),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`#append(_;_)_AUXFUN-SYNTAX`(Q,R)``),`<where>`(``Z=>`#append(_;_)_AUXFUN-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``_95=>#token("2","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isName(Z)),isInt(J)),isInt(L)),isSet(_162)),isName(X)),isInt(V)),isInt(I)),isProc(R)),isNames(Y)),isSet(S)),isProc(P)),isInt(N))),`_andBool_`(`_andBool_`(`_==Int_`(_95,#token("1","Int")),`_==Int_`(_93,#token("0","Int"))),`_==Int_`(_94,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(e50d9057c8797c22677f2cf14d8046f6d89bc83e0f8ad3681717c24d5c69cdc5) collect() contentStartColumn(5) contentStartLine(983) org.kframework.attributes.Location(Location(983,5,1019,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1643),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1644 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1645 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_1646) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_93_1647) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1648) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1649) :: [])) :: [])) :: []),(varDotVar2_1650 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1651) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1652) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1653 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1654) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_94_1655) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_162_1656) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1657 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1658 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_1659) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1660) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1661) :: [])) :: [])) :: []),(varDotVar4_1662 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1663 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1664 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1665 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1666 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1667) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_95_1668) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1669)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1669)) config (-1)))) && ((((((((((((((((((((((((((isTrue (evalisProcs((varQ_1645 :: [])) config (-1)))) && ((isTrue (evalisName((varZ_1666 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisName((varX_1644 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varR_1665 :: [])) config (-1)))))) && ((isTrue (evalisNames((varY_1658 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_1653 :: [])) config (-1)))))) && (true))))) && ((((((isTrue (eval_'EqlsEqls'Int_((var_95_1668 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_93_1647 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_94_1655 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem varI_1648 varI_1661) = 0) && ((compare_kitem varL_1652 varL_1654) = 0) && ((compare_kitem varJ_1667 varJ_1651) = 0) && ((compare_kitem varN_1646 varN_1659) = 0) && ((compare_kitem varX_1644 varX_1657) = 0) && ((compare_kitem varP_1653 varP_1664) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1643),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_1650 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1667 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1652 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1653 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1652 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_94_1655 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_162_1656 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1662 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1663 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1653 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varQ_1645 :: []),(varR_1665 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'where'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varY_1658 :: []),(varZ_1666 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1667 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int2) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_1649 :: []),((evalSetItem((varV_1660 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_-__GRHO-SYNTAX`(K0,HOLE)=>HOLE~>`#freezer_-__GRHO-SYNTAX0_`(K0)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(K0),isAExp(HOLE)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(2b12170752d85580f253d4b17447d6c0a5df2f5d3a1040d37f23df8c76c576ea) heat() org.kframework.attributes.Location(Location(153,24,153,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(100445376) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Hyph'__GRHO'Hyph'SYNTAX,(varK0_1670 :: []),(varHOLE_1671 :: [])) :: varDotVar3_1672)) :: [])) :: []),(varDotVar1_1673 :: [])) config (-1)) :: [])) :: []),(var_0_1674),(var_1_1675)) :: []) when (((((isTrue (evalisAExp((varK0_1670 :: [])) config (-1)))) && ((isTrue (evalisAExp((varHOLE_1671 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_1671 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1671 :: KApply1(Lbl'Hash'freezer_'Hyph'__GRHO'Hyph'SYNTAX0_,(varK0_1670 :: [])) :: varDotVar3_1672)) :: [])) :: []),(varDotVar1_1673 :: [])) config (-1)))) :: []),(var_0_1674),(var_1_1675)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(``#token("\"matched\"","String")=>#token("\"collection\"","String")``),`<match>`(L),`<type>`(_136),`<nomo>`(_137),`<listens>`(_138)),DotVar2))),`<reaction>`(`<who>`(``.K=>P``),`<what>`(``.K=>#token("\"\"","String")``),`<where>`(``.K=>#token("\"\"","String")``),`<rid>`(``.K=>J``),`<rnum>`(``.K=>#token("0","Int")``),`<react>`(``.K=>#token("\"collect\"","String")``),`<forg>`(``.K=>`.Set`(.KList)``))) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isSet(_137),isInt(J)),isInt(L)),isProc(P)),`_andBool_`(#token("true","Bool"),isListenCellBag(_138))) ensures #token("true","Bool") [UNIQUE_ID(694bf24e78a40c0ad4ea910e97014b4c439ebddc6c9131368dfd689ecc4f263a) contentStartColumn(5) contentStartLine(540) org.kframework.attributes.Location(Location(540,5,558,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K) promote()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1676),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_1677),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1678) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1679) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1680 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "matched") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1681) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_136_1682)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_137_1683) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_138_1684 :: [])) :: [])) :: []),(varDotVar2_1685 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',([])) :: []),(KApply1(Lbl'_LT_'what'_GT_',([])) :: []),(KApply1(Lbl'_LT_'where'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',([])) :: []),(KApply1(Lbl'_LT_'react'_GT_',([])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',([])) :: [])) :: [])) :: []) when ((((((((true) && (true))) && (true))) && ((isTrue (evalisProc((varP_1680 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisListenCellBag((var_138_1684 :: [])) config (-1))))))) && (((compare_kitem varL_1679 varL_1681) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1676),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_1677),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1678 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1679 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1680 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1679 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_136_1682)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_137_1683 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_138_1684 :: [])) :: [])) :: []),(varDotVar2_1685 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1680 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1678 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int0) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((Lazy.force const'Stop'Set))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(_96),`<state>`(#token("\"collection\"","String")),`<match>`(_97),`<type>`(_98),`<nomo>`(_99),`<listens>`(_100)),DotVar2))),`<reaction>`(`<who>`(_101),`<what>`(_102),`<where>`(_103),`<rid>`(J),`<rnum>`(R),`<react>`(``#token("\"forget\"","String")=>#token("\"collect\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(J),isInt(L)),isSet(_99)),`_andBool_`(#token("true","Bool"),isListenCellBag(_100))),isInt(R)),`_>Int__INT`(L,R))) ensures #token("true","Bool") [UNIQUE_ID(dffbae5b2a0bb5697c8a684c288863b533a48f1c0bdaa44fa34bf3c25d81301e) contentStartColumn(5) contentStartLine(445) org.kframework.attributes.Location(Location(445,5,464,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1686),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_1687),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1688) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1689) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_96_1690)) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_97_1691)) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_98_1692)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_99_1693) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_100_1694 :: [])) :: [])) :: []),(varDotVar2_1695 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_101_1696)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_102_1697)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_103_1698)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1699) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varR_1700) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1701)) :: [])) :: [])) :: []) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1701)) config (-1)))) && (((((((((((true) && (true))) && (true))) && (((true) && ((isTrue (evalisListenCellBag((var_100_1694 :: [])) config (-1)))))))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_1689 :: []),(varR_1700 :: [])) config (-1))))))) && (((compare_kitem varJ_1688 varJ_1699) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1686),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_1687),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1688 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1689 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_96_1690)) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_97_1691)) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_98_1692)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_99_1693 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_100_1694 :: [])) :: [])) :: []),(varDotVar2_1695 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_101_1696)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_102_1697)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_103_1698)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1688 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(varR_1700 :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1701)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`_ThreadCellBag_`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_|__GRHO-SYNTAX`(P,Q)=>.K``~>DotVar2)),`` `.ThreadCellBag`(.KList)=>`<thread>`(`<k>`(P))``),`` `.ThreadCellBag`(.KList)=>`<thread>`(`<k>`(Q))``),DotVar1)),_0,_1) requires `_andBool_`(isProc(Q),isProc(P)) ensures #token("true","Bool") [UNIQUE_ID(4bb9331438cd4e35dbe100feb999c880f9012544d466296d39fad4d461b539e5) contentStartColumn(8) contentStartLine(96) load() org.kframework.attributes.Location(Location(96,8,98,47)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_(((eval_ThreadCellBag_(((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Pipe'__GRHO'Hyph'SYNTAX,(varP_1702 :: []),(varQ_1703 :: [])) :: varDotVar2_1704)) :: [])) :: []),((Lazy.force const'Stop'ThreadCellBag) :: [])) config (-1)) :: []),((Lazy.force const'Stop'ThreadCellBag) :: [])) config (-1)) :: []),(varDotVar1_1705 :: [])) config (-1)) :: [])) :: []),(var_0_1706),(var_1_1707)) :: []) when (((isTrue (evalisProc((varQ_1703 :: [])) config (-1)))) && ((isTrue (evalisProc((varP_1702 :: [])) config (-1))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_(((eval_ThreadCellBag_(((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varDotVar2_1704)) :: [])) :: []),(KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varP_1702 :: [])) :: [])) :: [])) config (-1))),(KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varQ_1703 :: [])) :: [])) :: [])) config (-1))),(varDotVar1_1705 :: [])) config (-1)))) :: []),(var_0_1706),(var_1_1707)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_66),`<stype>`(_67),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_68),`<nomo>`(_195),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_69),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`_,__GRHO-SYNTAX`(Q,R)``),`<where>`(``Z=>`_,__GRHO-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``U=>`_+Int_`(U,#token("1","Int"))``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isInt(J)),isInt(L)),isSet(_195)),isProcs(R)),isName(X)),isInt(V)),isInt(I)),isSet(S)),isNames(Z)),isProc(P)),isInt(U)),`_>Int__INT`(L,U))),`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_69,#token("1","Int")),`_==Int_`(_67,#token("0","Int"))),`_==Int_`(_68,#token("0","Int"))),`_==Int_`(_66,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(7033978027e050a9893a90bfba1f0b24d745e32277488e5d6f838b49b16ca94a) collect() contentStartColumn(5) contentStartLine(1023) org.kframework.attributes.Location(Location(1023,5,1060,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1708),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1709 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1710 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_66_1711) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_67_1712) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1713) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1714) :: [])) :: [])) :: []),(varDotVar2_1715 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1716) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1717) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1718 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1719) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_68_1720) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_195_1721) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1722 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1723 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_69_1724) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1725) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1726) :: [])) :: [])) :: []),(varDotVar4_1727 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1728 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1729 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1730 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1731 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1732) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varU_1733) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1734)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1734)) config (-1)))) && ((((((((((((((((((((((((((((isTrue (evalisName((varY_1723 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_1710 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisProcs((varR_1730 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_1709 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisNames((varZ_1731 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_1718 :: [])) config (-1)))))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_1719 :: []),(varU_1733 :: [])) config (-1)))))))) && ((((((((isTrue (eval_'EqlsEqls'Int_((var_69_1724 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_67_1712 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_68_1720 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_66_1711 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_1726 varI_1713) = 0) && ((compare_kitem varL_1719 varL_1717) = 0) && ((compare_kitem varJ_1716 varJ_1732) = 0) && ((compare_kitem varX_1709 varX_1722) = 0) && ((compare_kitem varP_1718 varP_1729) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1708),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_1715 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1716 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1719 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1718 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1719 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_68_1720 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_195_1721 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1727 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1728 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1718 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_1710 :: []),(varR_1730 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_1723 :: []),(varZ_1731 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1716 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((eval_'Plus'Int_((varU_1733 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_1714 :: []),((evalSetItem((varV_1725 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_+__GRHO-SYNTAX`(HOLE,K1)=>HOLE~>`#freezer_+__GRHO-SYNTAX1_`(K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(HOLE),isAExp(K1)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(c3f851feb77afcc5cb7e06ddcf83b7a96a6b3f75fac13f8415061f7d5168c109) heat() org.kframework.attributes.Location(Location(152,24,152,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(480402503) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Plus'__GRHO'Hyph'SYNTAX,(varHOLE_1735 :: []),(varK1_1736 :: [])) :: varDotVar3_1737)) :: [])) :: []),(varDotVar1_1738 :: [])) config (-1)) :: [])) :: []),(var_0_1739),(var_1_1740)) :: []) when (((((isTrue (evalisAExp((varHOLE_1735 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_1736 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_1735 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1735 :: KApply1(Lbl'Hash'freezer_'Plus'__GRHO'Hyph'SYNTAX1_,(varK1_1736 :: [])) :: varDotVar3_1737)) :: [])) :: []),(varDotVar1_1738 :: [])) config (-1)))) :: []),(var_0_1739),(var_1_1740)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_and__GRHO-SYNTAX1_`(K1)=>`_and__GRHO-SYNTAX`(HOLE,K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isBExp(K1),isBExp(HOLE)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(74661d223dde3690c98b08695754cfe53d7f4a5cd30db4f8daa5317a62f36621) cool() org.kframework.attributes.Location(Location(162,24,162,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(493944943) strict(1)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1741 :: KApply1(Lbl'Hash'freezer_and__GRHO'Hyph'SYNTAX1_,(varK1_1742 :: [])) :: varDotVar3_1743)) :: [])) :: []),(varDotVar1_1744 :: [])) config (-1)) :: [])) :: []),(var_0_1745),(var_1_1746)) :: []) when (((((isTrue (evalisBExp((varK1_1742 :: [])) config (-1)))) && ((isTrue (evalisBExp((varHOLE_1741 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_1741 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_and__GRHO'Hyph'SYNTAX((varHOLE_1741 :: []),(varK1_1742 :: [])) config (-1)) @ varDotVar3_1743)) :: [])) :: []),(varDotVar1_1744 :: [])) config (-1)))) :: []),(var_0_1745),(var_1_1746)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_90),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_91),`<nomo>`(_196),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(``I=>#token("\"\"","String")``)),DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``#token("\"\"","String")=>Q``),`<where>`(``#token("\"\"","String")=>Y``),`<rid>`(J),`<rnum>`(``_92=>#token("1","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isSet(_196)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isNames(Y)),isSet(S)),isProc(P)),isInt(N))),`_andBool_`(`_andBool_`(`_==Int_`(_90,#token("0","Int")),`_==Int_`(_92,#token("0","Int"))),`_==Int_`(_91,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(8d42af781fa92a22c2b7204128fde2fe766ad51f5df8c6258742583972cd3123) contentStartColumn(5) contentStartLine(735) initialize() org.kframework.attributes.Location(Location(735,5,771,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1747),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1748 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1749 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_1750) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_90_1751) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1752) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1753) :: [])) :: [])) :: []),(varDotVar2_1754 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1755) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1756) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1757 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1758) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_91_1759) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_196_1760) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1761 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1762 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_1763) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1764) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1765) :: [])) :: [])) :: []),(varDotVar4_1766 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1767 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1768 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1769) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_92_1770) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1771)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1771)) config (-1)))) && ((((((((((((((((((((((isTrue (evalisProcs((varQ_1749 :: [])) config (-1)))) && (true))) && (true))) && (true))) && ((isTrue (evalisName((varX_1761 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisNames((varY_1762 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_1757 :: [])) config (-1)))))) && (true))))) && ((((((isTrue (eval_'EqlsEqls'Int_((var_90_1751 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_92_1770 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_91_1759 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_1765 varI_1752) = 0) && ((compare_kitem varL_1756 varL_1758) = 0) && ((compare_kitem varJ_1769 varJ_1755) = 0) && ((compare_kitem varN_1763 varN_1750) = 0) && ((compare_kitem varX_1761 varX_1748) = 0) && ((compare_kitem varP_1757 varP_1768) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1747),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_1754 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1769 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1756 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1757 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1756 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_91_1759 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_196_1760 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1761 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1762 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',(varN_1763 :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(varV_1764 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(varDotVar4_1766 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1767 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1757 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_1749 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_1762 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1769 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_1753 :: []),((evalSetItem((varV_1764 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_110),`<stype>`(_105),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_111),`<nomo>`(_104),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_112),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`_,__GRHO-SYNTAX`(Q,R)``),`<where>`(``Z=>`_,__GRHO-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``_113=>#token("2","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isName(Z)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isProc(R)),isSet(S)),isProc(P)),isSet(_104))),`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_111,#token("2","Int")),`_==Int_`(_110,#token("1","Int"))),`_==Int_`(_112,#token("1","Int"))),`_==Int_`(_113,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(9b9d7181999399217f083c4bb686dbda671c59d31b31c24409a2ff8ecda71194) collect() contentStartColumn(5) contentStartLine(1271) org.kframework.attributes.Location(Location(1271,5,1307,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1772),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1773 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1774 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_110_1775) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_105_1776)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1777) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1778) :: [])) :: [])) :: []),(varDotVar2_1779 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1780) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1781) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1782 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1783) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_111_1784) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_104_1785) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1786 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1787 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_112_1788) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1789) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1790) :: [])) :: [])) :: []),(varDotVar4_1791 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1792 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1793 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1794 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1795 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1796) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_113_1797) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1798)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1798)) config (-1)))) && ((((((((((((((((((((((((isTrue (evalisName((varY_1787 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_1774 :: [])) config (-1)))))) && ((isTrue (evalisName((varZ_1795 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_1786 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varR_1794 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_1782 :: [])) config (-1)))))) && (true))))) && ((((((((isTrue (eval_'EqlsEqls'Int_((var_111_1784 :: []),((Lazy.force int2) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_110_1775 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_112_1788 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_113_1797 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_1777 varI_1790) = 0) && ((compare_kitem varL_1781 varL_1783) = 0) && ((compare_kitem varJ_1780 varJ_1796) = 0) && ((compare_kitem varX_1786 varX_1773) = 0) && ((compare_kitem varP_1782 varP_1793) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1772),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1786 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1774 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(var_110_1775 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_105_1776)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_1777 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_1778 :: []),((evalSetItem((varV_1789 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_1779 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1780 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1781 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1782 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1781 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_111_1784 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_104_1785 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1791 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1792 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1782 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_1774 :: []),(varR_1794 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_1787 :: []),(varZ_1795 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1780 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int2) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1798)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_or__GRHO-SYNTAX1_`(K1)=>`_or__GRHO-SYNTAX`(HOLE,K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isBExp(K1),isBExp(HOLE)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(134453ee02ea34488a15d3bc672c1d229ee1916c5717ad7079cd5849268ade2c) cool() org.kframework.attributes.Location(Location(163,24,163,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1533547487) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1799 :: KApply1(Lbl'Hash'freezer_or__GRHO'Hyph'SYNTAX1_,(varK1_1800 :: [])) :: varDotVar3_1801)) :: [])) :: []),(varDotVar1_1802 :: [])) config (-1)) :: [])) :: []),(var_0_1803),(var_1_1804)) :: []) when (((((isTrue (evalisBExp((varK1_1800 :: [])) config (-1)))) && ((isTrue (evalisBExp((varHOLE_1799 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_1799 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_or__GRHO'Hyph'SYNTAX,(varHOLE_1799 :: []),(varK1_1800 :: [])) :: varDotVar3_1801)) :: [])) :: []),(varDotVar1_1802 :: [])) config (-1)))) :: []),(var_0_1803),(var_1_1804)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_*__GRHO-SYNTAX`(K0,HOLE)=>HOLE~>`#freezer_*__GRHO-SYNTAX0_`(K0)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(K0),isAExp(HOLE)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(a2824b079b25b57666d6f775330cba7b4a5ff8adcee4f6764e8d0d20651025c0) heat() org.kframework.attributes.Location(Location(151,24,151,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1774690057) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Star'__GRHO'Hyph'SYNTAX,(varK0_1805 :: []),(varHOLE_1806 :: [])) :: varDotVar3_1807)) :: [])) :: []),(varDotVar1_1808 :: [])) config (-1)) :: [])) :: []),(var_0_1809),(var_1_1810)) :: []) when (((((isTrue (evalisAExp((varK0_1805 :: [])) config (-1)))) && ((isTrue (evalisAExp((varHOLE_1806 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_1806 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1806 :: KApply1(Lbl'Hash'freezer_'Star'__GRHO'Hyph'SYNTAX0_,(varK0_1805 :: [])) :: varDotVar3_1807)) :: [])) :: []),(varDotVar1_1808 :: [])) config (-1)))) :: []),(var_0_1809),(var_1_1810)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_-__GRHO-SYNTAX0_`(K0)=>`_-__GRHO-SYNTAX`(K0,HOLE)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(K0),isAExp(HOLE)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(e30c13fc7117a2998dee3fe6d01807e7817a09268c0cfa1bd8e0acc897fb47b8) cool() org.kframework.attributes.Location(Location(153,24,153,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(100445376) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1811 :: KApply1(Lbl'Hash'freezer_'Hyph'__GRHO'Hyph'SYNTAX0_,(varK0_1812 :: [])) :: varDotVar3_1813)) :: [])) :: []),(varDotVar1_1814 :: [])) config (-1)) :: [])) :: []),(var_0_1815),(var_1_1816)) :: []) when (((((isTrue (evalisAExp((varK0_1812 :: [])) config (-1)))) && ((isTrue (evalisAExp((varHOLE_1811 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_1811 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'Hyph'__GRHO'Hyph'SYNTAX((varK0_1812 :: []),(varHOLE_1811 :: [])) config (-1)) @ varDotVar3_1813)) :: [])) :: []),(varDotVar1_1814 :: [])) config (-1)))) :: []),(var_0_1815),(var_1_1816)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_or__GRHO-SYNTAX0_`(K0)=>`_or__GRHO-SYNTAX`(K0,HOLE)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isBExp(HOLE),isBExp(K0)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(c4e0b38b02624b76a5715762bdd8254f15de19f3e233273d7b017a68ec6a3a8e) cool() org.kframework.attributes.Location(Location(163,24,163,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1533547487) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1817 :: KApply1(Lbl'Hash'freezer_or__GRHO'Hyph'SYNTAX0_,(varK0_1818 :: [])) :: varDotVar3_1819)) :: [])) :: []),(varDotVar1_1820 :: [])) config (-1)) :: [])) :: []),(var_0_1821),(var_1_1822)) :: []) when (((((isTrue (evalisBExp((varHOLE_1817 :: [])) config (-1)))) && ((isTrue (evalisBExp((varK0_1818 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_1817 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_or__GRHO'Hyph'SYNTAX,(varK0_1818 :: []),(varHOLE_1817 :: [])) :: varDotVar3_1819)) :: [])) :: []),(varDotVar1_1820 :: [])) config (-1)))) :: []),(var_0_1821),(var_1_1822)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_<=__GRHO-SYNTAX`(HOLE,K1)=>HOLE~>`#freezer_<=__GRHO-SYNTAX1_`(K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(HOLE),isAExp(K1)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(1c7af175a58e8833c11c565fb5882ab65d1afa762ae083a7344de2b100423a03) heat() org.kframework.attributes.Location(Location(160,24,160,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1650955365) seqstrict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varHOLE_1823 :: []),(varK1_1824 :: [])) :: varDotVar3_1825)) :: [])) :: []),(varDotVar1_1826 :: [])) config (-1)) :: [])) :: []),(var_0_1827),(var_1_1828)) :: []) when (((((isTrue (evalisAExp((varHOLE_1823 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_1824 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_1823 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1823 :: KApply1(Lbl'Hash'freezer_'_LT_Eqls'__GRHO'Hyph'SYNTAX1_,(varK1_1824 :: [])) :: varDotVar3_1825)) :: [])) :: []),(varDotVar1_1826 :: [])) config (-1)))) :: []),(var_0_1827),(var_1_1828)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_156),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_54),`<nomo>`(_155),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`#append(_;_)_AUXFUN-SYNTAX`(Q,R)``),`<where>`(``Z=>`#append(_;_)_AUXFUN-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``U=>`_+Int_`(U,#token("1","Int"))``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isInt(J)),isInt(L)),isProcs(R)),isName(X)),isInt(V)),isInt(I)),isSet(_155)),isNames(Y)),isSet(S)),isNames(Z)),isProc(P)),isInt(N)),isInt(U)),`_>Int__INT`(L,U))),`_==Int_`(_54,#token("2","Int"))) ensures #token("true","Bool") [UNIQUE_ID(6c7a60ca01efe9ff2facbd279dc587e310a5d0666e4b43a5d6862fc6be483e71) collect() contentStartColumn(5) contentStartLine(1392) org.kframework.attributes.Location(Location(1392,5,1429,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1829),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1830 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1831 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_1832) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_156_1833)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1834) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1835) :: [])) :: [])) :: []),(varDotVar2_1836 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1837) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1838) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1839 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1840) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_54_1841) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_155_1842) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1843 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1844 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_1845) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1846) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1847) :: [])) :: [])) :: []),(varDotVar4_1848 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1849 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1850 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1851 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1852 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1853) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varU_1854) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1855)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1855)) config (-1)))) && ((((((((((((((((((((((((((((((isTrue (evalisProcs((varQ_1831 :: [])) config (-1)))) && (true))) && (true))) && ((isTrue (evalisProcs((varR_1851 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_1830 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisNames((varY_1844 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisNames((varZ_1852 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_1850 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_1840 :: []),(varU_1854 :: [])) config (-1)))))))) && ((isTrue (eval_'EqlsEqls'Int_((var_54_1841 :: []),((Lazy.force int2) :: [])) config (-1))))) && (((compare_kitem varI_1847 varI_1834) = 0) && ((compare_kitem varL_1840 varL_1838) = 0) && ((compare_kitem varJ_1853 varJ_1837) = 0) && ((compare_kitem varN_1832 varN_1845) = 0) && ((compare_kitem varX_1830 varX_1843) = 0) && ((compare_kitem varP_1850 varP_1839) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1829),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1830 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1831 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(varN_1832 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_156_1833)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_1847 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_1835 :: []),((evalSetItem((varV_1846 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_1836 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1853 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1840 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1850 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1840 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_54_1841 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_155_1842 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1848 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1849 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1850 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varQ_1831 :: []),(varR_1851 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'where'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varY_1844 :: []),(varZ_1852 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1853 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((eval_'Plus'Int_((varU_1854 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1855)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_+__GRHO-SYNTAX0_`(K0)=>`_+__GRHO-SYNTAX`(K0,HOLE)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(K0),isAExp(HOLE)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(0ffaed27a17ac01c4555082b189e45c821232a5ed504e509b510d4f8640d909f) cool() org.kframework.attributes.Location(Location(152,24,152,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(480402503) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1856 :: KApply1(Lbl'Hash'freezer_'Plus'__GRHO'Hyph'SYNTAX0_,(varK0_1857 :: [])) :: varDotVar3_1858)) :: [])) :: []),(varDotVar1_1859 :: [])) config (-1)) :: [])) :: []),(var_0_1860),(var_1_1861)) :: []) when (((((isTrue (evalisAExp((varK0_1857 :: [])) config (-1)))) && ((isTrue (evalisAExp((varHOLE_1856 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_1856 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'Plus'__GRHO'Hyph'SYNTAX((varK0_1857 :: []),(varHOLE_1856 :: [])) config (-1)) @ varDotVar3_1858)) :: [])) :: []),(varDotVar1_1859 :: [])) config (-1)))) :: []),(var_0_1860),(var_1_1861)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_49),`<stype>`(_50),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_51),`<nomo>`(_186),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_52),`<lid>`(V),`<msid>`(``I=>#token("\"\"","String")``)),DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``#token("\"\"","String")=>Q``),`<where>`(``#token("\"\"","String")=>Y``),`<rid>`(J),`<rnum>`(``_53=>#token("1","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isSet(S)),isSet(_186)),isProc(P))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_50,#token("0","Int")),`_==Int_`(_53,#token("0","Int"))),`_==Int_`(_49,#token("1","Int"))),`_==Int_`(_51,#token("1","Int"))),`_==Int_`(_52,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(837420b3660ef8d9cdca47da40d565071699d1460719a5fa974f7aee4b8bd648) contentStartColumn(5) contentStartLine(695) initialize() org.kframework.attributes.Location(Location(695,5,731,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1862),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1863 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1864 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_49_1865) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_50_1866) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1867) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1868) :: [])) :: [])) :: []),(varDotVar2_1869 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1870) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1871) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1872 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1873) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_51_1874) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_186_1875) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1876 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1877 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_52_1878) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1879) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1880) :: [])) :: [])) :: []),(varDotVar4_1881 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1882 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1883 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1884) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_53_1885) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1886)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1886)) config (-1)))) && ((((((((((((((((((((isTrue (evalisName((varY_1877 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_1864 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_1863 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && (true))) && ((isTrue (evalisProc((varP_1872 :: [])) config (-1)))))))) && ((((((((((isTrue (eval_'EqlsEqls'Int_((var_50_1866 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_53_1885 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_49_1865 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_51_1874 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_52_1878 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_1867 varI_1880) = 0) && ((compare_kitem varL_1873 varL_1871) = 0) && ((compare_kitem varJ_1870 varJ_1884) = 0) && ((compare_kitem varX_1863 varX_1876) = 0) && ((compare_kitem varP_1872 varP_1883) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1862),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_1869 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1870 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1873 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1872 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1873 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_51_1874 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_186_1875 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1863 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1877 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',(var_52_1878 :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(varV_1879 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(varDotVar4_1881 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1882 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1872 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_1864 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_1877 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1870 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_1868 :: []),((evalSetItem((varV_1879 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezernot__GRHO-SYNTAX0_`(.KList)=>`not__GRHO-SYNTAX`(HOLE)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(isBExp(HOLE),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(6ce8917b7a25d337b90653e8bbf572727359a00b94377fae7fa859a604713124) cool() org.kframework.attributes.Location(Location(161,24,161,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1788380050) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1887 :: KApply0(Lbl'Hash'freezernot__GRHO'Hyph'SYNTAX0_) :: varDotVar3_1888)) :: [])) :: []),(varDotVar1_1889 :: [])) config (-1)) :: [])) :: []),(var_0_1890),(var_1_1891)) :: []) when (((isTrue (evalisBExp((varHOLE_1887 :: [])) config (-1)))) && (((true) && ((isTrue (evalisKResult((varHOLE_1887 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((evalnot__GRHO'Hyph'SYNTAX((varHOLE_1887 :: [])) config (-1)) @ varDotVar3_1888)) :: [])) :: []),(varDotVar1_1889 :: [])) config (-1)))) :: []),(var_0_1890),(var_1_1891)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_and__GRHO-SYNTAX`(HOLE,K1)=>HOLE~>`#freezer_and__GRHO-SYNTAX1_`(K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isBExp(K1),isBExp(HOLE)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(4c94ea2a729ed2f9fab13e5b3ade9149012dd2e4d545c8c769ff17468d00c4cb) heat() org.kframework.attributes.Location(Location(162,24,162,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(493944943) strict(1)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_and__GRHO'Hyph'SYNTAX,(varHOLE_1892 :: []),(varK1_1893 :: [])) :: varDotVar3_1894)) :: [])) :: []),(varDotVar1_1895 :: [])) config (-1)) :: [])) :: []),(var_0_1896),(var_1_1897)) :: []) when (((((isTrue (evalisBExp((varK1_1893 :: [])) config (-1)))) && ((isTrue (evalisBExp((varHOLE_1892 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_1892 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1892 :: KApply1(Lbl'Hash'freezer_and__GRHO'Hyph'SYNTAX1_,(varK1_1893 :: [])) :: varDotVar3_1894)) :: [])) :: []),(varDotVar1_1895 :: [])) config (-1)))) :: []),(var_0_1896),(var_1_1897)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_76),`<stype>`(_77),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_78),`<nomo>`(_147),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_79),`<lid>`(V),`<msid>`(``I=>#token("\"\"","String")``)),DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`_,__GRHO-SYNTAX`(Q,R)``),`<where>`(``Z=>`_,__GRHO-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``_80=>#token("2","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isName(Z)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isProc(R)),isSet(S)),isProc(P)),isSet(_147))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_79,#token("1","Int")),`_==Int_`(_76,#token("1","Int"))),`_==Int_`(_78,#token("1","Int"))),`_==Int_`(_77,#token("0","Int"))),`_==Int_`(_80,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(39a59ef942374212cb203be2d94e091e061255f6e325ea43aa159b99a461edf9) collect() contentStartColumn(5) contentStartLine(1107) org.kframework.attributes.Location(Location(1107,5,1143,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1898),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1899 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1900 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_76_1901) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_77_1902) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1903) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1904) :: [])) :: [])) :: []),(varDotVar2_1905 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1906) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1907) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1908 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1909) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_78_1910) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_147_1911) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1912 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1913 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_79_1914) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1915) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1916) :: [])) :: [])) :: []),(varDotVar4_1917 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1918 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1919 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1920 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1921 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1922) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_80_1923) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1924)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1924)) config (-1)))) && ((((((((((((((((((((((((isTrue (evalisName((varY_1913 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_1900 :: [])) config (-1)))))) && ((isTrue (evalisName((varZ_1921 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_1912 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varR_1920 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_1908 :: [])) config (-1)))))) && (true))))) && ((((((((((isTrue (eval_'EqlsEqls'Int_((var_79_1914 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_76_1901 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_78_1910 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_77_1902 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_80_1923 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_1916 varI_1903) = 0) && ((compare_kitem varL_1907 varL_1909) = 0) && ((compare_kitem varJ_1922 varJ_1906) = 0) && ((compare_kitem varX_1912 varX_1899) = 0) && ((compare_kitem varP_1908 varP_1919) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1898),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_1905 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1922 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1907 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1908 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1907 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_78_1910 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_147_1911 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1912 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1913 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',(var_79_1914 :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(varV_1915 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(varDotVar4_1917 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1918 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1908 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_1900 :: []),(varR_1920 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_1913 :: []),(varZ_1921 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1922 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int2) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_1904 :: []),((evalSetItem((varV_1915 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_+__GRHO-SYNTAX`(K0,HOLE)=>HOLE~>`#freezer_+__GRHO-SYNTAX0_`(K0)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(K0),isAExp(HOLE)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(4330d63ce2970479e2d5c3251a144dab2f6cff2684e5e8c7666a6627d8078dc7) heat() org.kframework.attributes.Location(Location(152,24,152,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(480402503) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Plus'__GRHO'Hyph'SYNTAX,(varK0_1925 :: []),(varHOLE_1926 :: [])) :: varDotVar3_1927)) :: [])) :: []),(varDotVar1_1928 :: [])) config (-1)) :: [])) :: []),(var_0_1929),(var_1_1930)) :: []) when (((((isTrue (evalisAExp((varK0_1925 :: [])) config (-1)))) && ((isTrue (evalisAExp((varHOLE_1926 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_1926 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1926 :: KApply1(Lbl'Hash'freezer_'Plus'__GRHO'Hyph'SYNTAX0_,(varK0_1925 :: [])) :: varDotVar3_1927)) :: [])) :: []),(varDotVar1_1928 :: [])) config (-1)))) :: []),(var_0_1929),(var_1_1930)) :: [])), (StepFunc step))
(*{| rule `<T>`(_0,_1,`<reaction>`(`<who>`(``P=>`_[_/_]_SUBSTITUTION`(P,`@__GRHO-SYNTAX`(Q),Y)``),`<what>`(`` `_,__GRHO-SYNTAX`(Q,R)=>R``),`<where>`(`` `_,__GRHO-SYNTAX`(Y,Z)=>Z``),`<rid>`(_158),`<rnum>`(_159),`<react>`(#token("\"react\"","String")),`<forg>`(_2))) requires `_andBool_`(`_==K_`(`.Set`(.KList),_2),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isProcs(R)),isNames(Z)),isProc(P))) ensures #token("true","Bool") [UNIQUE_ID(ea05211bbb3957916dceea749e298b61759b1a0a56cbf13812533b5803dc4a0c) comm() contentStartColumn(5) contentStartLine(407) org.kframework.attributes.Location(Location(407,5,415,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(var_0_1931),(var_1_1932),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1933 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_1934 :: []),(varR_1935 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_1936 :: []),(varZ_1937 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(var_158_1938)) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_159_1939)) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "react") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_2_1940)) :: [])) :: [])) :: []) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_2_1940)) config (-1)))) && ((((((((((isTrue (evalisName((varY_1936 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_1934 :: [])) config (-1)))))) && ((isTrue (evalisProcs((varR_1935 :: [])) config (-1)))))) && ((isTrue (evalisNames((varZ_1937 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_1933 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(var_0_1931),(var_1_1932),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',((eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION((varP_1933 :: []),((eval'_AT_'__GRHO'Hyph'SYNTAX((varQ_1934 :: [])) config (-1))),(varY_1936 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_1935 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_1937 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(var_158_1938)) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_159_1939)) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "react") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_2_1940)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_35),`<stype>`(_36),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_37),`<nomo>`(_174),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_38),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``#token("\"\"","String")=>Q``),`<where>`(``#token("\"\"","String")=>Y``),`<rid>`(J),`<rnum>`(``_39=>#token("1","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isSet(_174)),isProc(Q)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isSet(S)),isProc(P))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_35,#token("1","Int")),`_==Int_`(_39,#token("0","Int"))),`_==Int_`(_38,#token("1","Int"))),`_==Int_`(_36,#token("1","Int"))),`_==Int_`(_37,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(11dcaa611a6b043dab9e0b8abbc68300383c7f19db1a7fe99544c461e863ebb3) contentStartColumn(5) contentStartLine(858) initialize() org.kframework.attributes.Location(Location(858,5,894,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1941),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1942 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1943 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_35_1944) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_36_1945) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1946) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1947) :: [])) :: [])) :: []),(varDotVar2_1948 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1949) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1950) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1951 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1952) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_37_1953) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_174_1954) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1955 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1956 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_38_1957) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1958) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1959) :: [])) :: [])) :: []),(varDotVar4_1960 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1961 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1962 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1963) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_39_1964) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1965)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1965)) config (-1)))) && ((((((((((((((((((((isTrue (evalisName((varY_1956 :: [])) config (-1)))) && (true))) && ((isTrue (evalisProc((varQ_1943 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_1955 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisProc((varP_1951 :: [])) config (-1)))))))) && ((((((((((isTrue (eval_'EqlsEqls'Int_((var_35_1944 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_39_1964 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_38_1957 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_36_1945 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_37_1953 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem varI_1946 varI_1959) = 0) && ((compare_kitem varL_1950 varL_1952) = 0) && ((compare_kitem varJ_1949 varJ_1963) = 0) && ((compare_kitem varX_1955 varX_1942) = 0) && ((compare_kitem varP_1951 varP_1962) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1941),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1955 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1943 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(var_35_1944 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_36_1945 :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_1946 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_1947 :: []),((evalSetItem((varV_1958 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_1948 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1949 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1950 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1951 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1950 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_37_1953 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_174_1954 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1960 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1961 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1951 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_1943 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_1956 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1949 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1965)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_7),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_8),`<nomo>`(_154),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``#token("\"\"","String")=>Q``),`<where>`(``#token("\"\"","String")=>Y``),`<rid>`(J),`<rnum>`(``_9=>#token("1","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isNames(Y)),isSet(S)),isProc(P)),isInt(N)),isSet(_154))),`_andBool_`(`_andBool_`(`_==Int_`(_9,#token("0","Int")),`_==Int_`(_8,#token("0","Int"))),`_==Int_`(_7,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(f0164be6ba25f3f165886d779da43efa51ad114f1bf410b4797cb9d4c6333831) contentStartColumn(5) contentStartLine(654) initialize() org.kframework.attributes.Location(Location(654,5,690,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1966),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_1967 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_1968 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_1969) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_7_1970) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_1971) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_1972) :: [])) :: [])) :: []),(varDotVar2_1973 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_1974) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_1975) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1976 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_1977) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_8_1978) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_154_1979) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_1980 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_1981 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_1982) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_1983) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_1984) :: [])) :: [])) :: []),(varDotVar4_1985 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_1986 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1987 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_1988) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_9_1989) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_1990)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_1990)) config (-1)))) && ((((((((((((((((((((((isTrue (evalisProcs((varQ_1968 :: [])) config (-1)))) && (true))) && (true))) && ((isTrue (evalisName((varX_1967 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisNames((varY_1981 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_1976 :: [])) config (-1)))))) && (true))) && (true))))) && ((((((isTrue (eval_'EqlsEqls'Int_((var_9_1989 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_8_1978 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_7_1970 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem varI_1971 varI_1984) = 0) && ((compare_kitem varL_1975 varL_1977) = 0) && ((compare_kitem varJ_1988 varJ_1974) = 0) && ((compare_kitem varN_1969 varN_1982) = 0) && ((compare_kitem varX_1967 varX_1980) = 0) && ((compare_kitem varP_1976 varP_1987) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_1966),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_1973 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_1988 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_1975 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_1976 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_1975 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_8_1978 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_154_1979 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_1985 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_1986 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_1976 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_1968 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_1981 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_1988 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_1972 :: []),((evalSetItem((varV_1983 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_or__GRHO-SYNTAX`(HOLE,K1)=>HOLE~>`#freezer_or__GRHO-SYNTAX1_`(K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isBExp(K1),isBExp(HOLE)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(1dca09b9593d425f50f3f89a9b8bbbed462a0fdff47153fba7c14ece3fe23f2a) heat() org.kframework.attributes.Location(Location(163,24,163,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1533547487) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_or__GRHO'Hyph'SYNTAX,(varHOLE_1991 :: []),(varK1_1992 :: [])) :: varDotVar3_1993)) :: [])) :: []),(varDotVar1_1994 :: [])) config (-1)) :: [])) :: []),(var_0_1995),(var_1_1996)) :: []) when (((((isTrue (evalisBExp((varK1_1992 :: [])) config (-1)))) && ((isTrue (evalisBExp((varHOLE_1991 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_1991 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1991 :: KApply1(Lbl'Hash'freezer_or__GRHO'Hyph'SYNTAX1_,(varK1_1992 :: [])) :: varDotVar3_1993)) :: [])) :: []),(varDotVar1_1994 :: [])) config (-1)))) :: []),(var_0_1995),(var_1_1996)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_<=__GRHO-SYNTAX0_`(K0)=>`_<=__GRHO-SYNTAX`(K0,HOLE)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(K0),isAExp(HOLE)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(96528607178696630574011e2c427c18535696cb5742975728797e9fa41b7c75) cool() org.kframework.attributes.Location(Location(160,24,160,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1650955365) seqstrict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_1997 :: KApply1(Lbl'Hash'freezer_'_LT_Eqls'__GRHO'Hyph'SYNTAX0_,(varK0_1998 :: [])) :: varDotVar3_1999)) :: [])) :: []),(varDotVar1_2000 :: [])) config (-1)) :: [])) :: []),(var_0_2001),(var_1_2002)) :: []) when (((((isTrue (evalisAExp((varK0_1998 :: [])) config (-1)))) && ((isTrue (evalisAExp((varHOLE_1997 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_1997 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX((varK0_1998 :: []),(varHOLE_1997 :: [])) config (-1)) @ varDotVar3_1999)) :: [])) :: []),(varDotVar1_2000 :: [])) config (-1)))) :: []),(var_0_2001),(var_1_2002)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_101),`<stype>`(_102),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_103),`<nomo>`(_157),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_104),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`_,__GRHO-SYNTAX`(Q,R)``),`<where>`(``Z=>`_,__GRHO-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``_105=>#token("2","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isName(Z)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isProc(R)),isSet(S)),isProc(P)),isSet(_157))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_103,#token("0","Int")),`_==Int_`(_101,#token("1","Int"))),`_==Int_`(_105,#token("1","Int"))),`_==Int_`(_104,#token("1","Int"))),`_==Int_`(_102,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(6e6b509d8244992bd0554a1a9ce470eaf3bae1b785f0c0f6d7ac3a30a7e8f8e9) collect() contentStartColumn(5) contentStartLine(1435) org.kframework.attributes.Location(Location(1435,5,1471,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2003),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2004 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2005 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_101_2006) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_102_2007) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2008) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2009) :: [])) :: [])) :: []),(varDotVar2_2010 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2011) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2012) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2013 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2014) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_103_2015) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_157_2016) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2017 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2018 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_104_2019) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2020) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2021) :: [])) :: [])) :: []),(varDotVar4_2022 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2023 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2024 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2025 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2026 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2027) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_105_2028) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2029)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2029)) config (-1)))) && ((((((((((((((((((((((((isTrue (evalisName((varY_2018 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_2005 :: [])) config (-1)))))) && ((isTrue (evalisName((varZ_2026 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_2004 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varR_2025 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_2013 :: [])) config (-1)))))) && (true))))) && ((((((((((isTrue (eval_'EqlsEqls'Int_((var_103_2015 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_101_2006 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_105_2028 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_104_2019 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_102_2007 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_2008 varI_2021) = 0) && ((compare_kitem varL_2014 varL_2012) = 0) && ((compare_kitem varJ_2011 varJ_2027) = 0) && ((compare_kitem varX_2004 varX_2017) = 0) && ((compare_kitem varP_2013 varP_2024) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2003),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2004 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2005 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(var_101_2006 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_102_2007 :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_2008 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_2009 :: []),((evalSetItem((varV_2020 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_2010 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2011 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2014 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2013 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2014 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_103_2015 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_157_2016 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2022 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2023 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2013 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_2005 :: []),(varR_2025 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_2018 :: []),(varZ_2026 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2011 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int2) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2029)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_140),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_15),`<nomo>`(_139),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`#append(_;_)_AUXFUN-SYNTAX`(Q,R)``),`<where>`(``Z=>`#append(_;_)_AUXFUN-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``_16=>#token("2","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isName(Z)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isProc(R)),isNames(Y)),isSet(S)),isProc(P)),isInt(N)),isSet(_139))),`_andBool_`(`_==Int_`(_16,#token("1","Int")),`_==Int_`(_15,#token("2","Int")))) ensures #token("true","Bool") [UNIQUE_ID(1696815d9d1db63879c03adb1d3af420742643c2c98c7cafddec2c47173b6db4) collect() contentStartColumn(5) contentStartLine(1311) org.kframework.attributes.Location(Location(1311,5,1347,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2030),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2031 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2032 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_2033) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_140_2034)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2035) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2036) :: [])) :: [])) :: []),(varDotVar2_2037 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2038) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2039) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2040 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2041) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_15_2042) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_139_2043) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2044 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2045 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_2046) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2047) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2048) :: [])) :: [])) :: []),(varDotVar4_2049 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2050 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2051 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2052 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2053 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2054) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_16_2055) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2056)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2056)) config (-1)))) && ((((((((((((((((((((((((((isTrue (evalisProcs((varQ_2032 :: [])) config (-1)))) && ((isTrue (evalisName((varZ_2053 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_2044 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varR_2052 :: [])) config (-1)))))) && ((isTrue (evalisNames((varY_2045 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_2040 :: [])) config (-1)))))) && (true))) && (true))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_16_2055 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_15_2042 :: []),((Lazy.force int2) :: [])) config (-1))))))) && (((compare_kitem varI_2048 varI_2035) = 0) && ((compare_kitem varL_2039 varL_2041) = 0) && ((compare_kitem varJ_2054 varJ_2038) = 0) && ((compare_kitem varN_2033 varN_2046) = 0) && ((compare_kitem varX_2044 varX_2031) = 0) && ((compare_kitem varP_2040 varP_2051) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2030),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2044 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2032 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(varN_2033 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_140_2034)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_2048 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_2036 :: []),((evalSetItem((varV_2047 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_2037 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2054 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2039 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2040 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2039 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_15_2042 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_139_2043 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2049 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2050 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2040 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varQ_2032 :: []),(varR_2052 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'where'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varY_2045 :: []),(varZ_2053 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2054 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int2) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2056)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_+__GRHO-SYNTAX1_`(K1)=>`_+__GRHO-SYNTAX`(HOLE,K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(HOLE),isAExp(K1)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(919554c935d93534c8e4ffb85a8c349248cfac3d13b280d000a3bd4a50b62a16) cool() org.kframework.attributes.Location(Location(152,24,152,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(480402503) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2057 :: KApply1(Lbl'Hash'freezer_'Plus'__GRHO'Hyph'SYNTAX1_,(varK1_2058 :: [])) :: varDotVar3_2059)) :: [])) :: []),(varDotVar1_2060 :: [])) config (-1)) :: [])) :: []),(var_0_2061),(var_1_2062)) :: []) when (((((isTrue (evalisAExp((varHOLE_2057 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_2058 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_2057 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'Plus'__GRHO'Hyph'SYNTAX((varHOLE_2057 :: []),(varK1_2058 :: [])) config (-1)) @ varDotVar3_2059)) :: [])) :: []),(varDotVar1_2060 :: [])) config (-1)))) :: []),(var_0_2061),(var_1_2062)) :: [])), (StepFunc step))
(*{| rule `<T>`(_0,`<tuplespace>`(DotVar1,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(``#token("\"\"","String")=>#token("\"matched\"","String")``),`<match>`(L),`<type>`(_187),`<nomo>`(_188),`<listens>`(_189)),DotVar2))),_1) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#token("true","Bool"),isListenCellBag(_189)),isInt(J)),isInt(L)),isProc(P)),isSet(_188)) ensures #token("true","Bool") [UNIQUE_ID(a898f923bfdefadfdfc6553349d6639146661881564137c7ad76ddff0cfb45fd) contentStartColumn(5) contentStartLine(503) matched() org.kframework.attributes.Location(Location(503,5,512,11)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(var_0_2063),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_2064),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2065) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2066) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2067 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2068) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_187_2069)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_188_2070) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_189_2071 :: [])) :: [])) :: []),(varDotVar2_2072 :: [])) config (-1)) :: [])) :: [])) :: []),(var_1_2073)) :: []) when ((((((((((true) && ((isTrue (evalisListenCellBag((var_189_2071 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varP_2067 :: [])) config (-1)))))) && (true)) && (((compare_kitem varL_2068 varL_2066) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(var_0_2063),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_2064),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2065 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2068 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2067 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "matched") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2068 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_187_2069)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_188_2070 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_189_2071 :: [])) :: [])) :: []),(varDotVar2_2072 :: [])) config (-1)))) :: [])) :: []),(var_1_2073)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_*__GRHO-SYNTAX`(HOLE,K1)=>HOLE~>`#freezer_*__GRHO-SYNTAX1_`(K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(HOLE),isAExp(K1)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(1b2b4a7e8efe6b6e00d3c14d0bd5886e69ee56b012c3651cb59322710ee2978c) heat() org.kframework.attributes.Location(Location(151,24,151,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1774690057) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Star'__GRHO'Hyph'SYNTAX,(varHOLE_2074 :: []),(varK1_2075 :: [])) :: varDotVar3_2076)) :: [])) :: []),(varDotVar1_2077 :: [])) config (-1)) :: [])) :: []),(var_0_2078),(var_1_2079)) :: []) when (((((isTrue (evalisAExp((varHOLE_2074 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_2075 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_2074 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2074 :: KApply1(Lbl'Hash'freezer_'Star'__GRHO'Hyph'SYNTAX1_,(varK1_2075 :: [])) :: varDotVar3_2076)) :: [])) :: []),(varDotVar1_2077 :: [])) config (-1)))) :: []),(var_0_2078),(var_1_2079)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_*__GRHO-SYNTAX0_`(K0)=>`_*__GRHO-SYNTAX`(K0,HOLE)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(K0),isAExp(HOLE)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(dab7993bcdbda5851c0945892bd518735b19ac7a0c61c5bdb4feeb54141e2c09) cool() org.kframework.attributes.Location(Location(151,24,151,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1774690057) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2080 :: KApply1(Lbl'Hash'freezer_'Star'__GRHO'Hyph'SYNTAX0_,(varK0_2081 :: [])) :: varDotVar3_2082)) :: [])) :: []),(varDotVar1_2083 :: [])) config (-1)) :: [])) :: []),(var_0_2084),(var_1_2085)) :: []) when (((((isTrue (evalisAExp((varK0_2081 :: [])) config (-1)))) && ((isTrue (evalisAExp((varHOLE_2080 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_2080 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'Star'__GRHO'Hyph'SYNTAX((varK0_2081 :: []),(varHOLE_2080 :: [])) config (-1)) @ varDotVar3_2082)) :: [])) :: []),(varDotVar1_2083 :: [])) config (-1)))) :: []),(var_0_2084),(var_1_2085)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(``#token("\"matched\"","String")=>#token("\"\"","String")``),`<match>`(M),`<type>`(_125),`<nomo>`(_126),`<listens>`(_127)),DotVar2))),`<reaction>`(`<who>`(_128),`<what>`(_129),`<where>`(_130),`<rid>`(R),`<rnum>`(_131),`<react>`(_132),`<forg>`(_133))) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(#token("true","Bool"),isListenCellBag(_127)),isInt(J)),isInt(L)),isSet(_126)),isProc(P)),isInt(R)),isInt(M)),`_=/=Int__INT`(J,R)) ensures #token("true","Bool") [UNIQUE_ID(2284213fe7b571c585b2bd87be9d371a24d51dae8cbce2f9a4fb24d915f37760) contentStartColumn(5) contentStartLine(516) demote() org.kframework.attributes.Location(Location(516,5,535,24)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2086),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_2087),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2088) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2089) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2090 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "matched") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varM_2091) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_125_2092)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_126_2093) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_127_2094 :: [])) :: [])) :: []),(varDotVar2_2095 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_128_2096)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_129_2097)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_130_2098)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varR_2099) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_131_2100)) :: []),(KApply1(Lbl'_LT_'react'_GT_',(var_132_2101)) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_133_2102)) :: [])) :: [])) :: []) when ((((((((((((((((true) && ((isTrue (evalisListenCellBag((var_127_2094 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisProc((varP_2090 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (eval_'EqlsSlshEqls'Int__INT((varJ_2088 :: []),(varR_2099 :: [])) config (-1))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2086),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_2087),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2088 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2089 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2090 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varM_2091 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_125_2092)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_126_2093 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_127_2094 :: [])) :: [])) :: []),(varDotVar2_2095 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_128_2096)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_129_2097)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_130_2098)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varR_2099 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_131_2100)) :: []),(KApply1(Lbl'_LT_'react'_GT_',(var_132_2101)) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_133_2102)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_<=__GRHO-SYNTAX1_`(K1)=>`_<=__GRHO-SYNTAX`(HOLE,K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(HOLE),isAExp(K1)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(18e9cc99789579deef276a21a427d5a2dab7301cdadcb10c9773530bf2e6cc39) cool() org.kframework.attributes.Location(Location(160,24,160,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1650955365) seqstrict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2103 :: KApply1(Lbl'Hash'freezer_'_LT_Eqls'__GRHO'Hyph'SYNTAX1_,(varK1_2104 :: [])) :: varDotVar3_2105)) :: [])) :: []),(varDotVar1_2106 :: [])) config (-1)) :: [])) :: []),(var_0_2107),(var_1_2108)) :: []) when (((((isTrue (evalisAExp((varHOLE_2103 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_2104 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_2103 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'_LT_Eqls'__GRHO'Hyph'SYNTAX((varHOLE_2103 :: []),(varK1_2104 :: [])) config (-1)) @ varDotVar3_2105)) :: [])) :: []),(varDotVar1_2106 :: [])) config (-1)))) :: []),(var_0_2107),(var_1_2108)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_98),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_99),`<nomo>`(_165),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``#token("\"\"","String")=>Q``),`<where>`(``#token("\"\"","String")=>Y``),`<rid>`(J),`<rnum>`(``_100=>#token("1","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isSet(_165)),isNames(Y)),isSet(S)),isProc(P)),isInt(N))),`_andBool_`(`_andBool_`(`_==Int_`(_100,#token("0","Int")),`_==Int_`(_99,#token("0","Int"))),`_==Int_`(_98,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(05c87012b1bc441743e611fd15da684a23f0b81e1177d9492a05461ebbe58dd1) contentStartColumn(5) contentStartLine(898) initialize() org.kframework.attributes.Location(Location(898,5,934,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2109),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2110 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2111 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_2112) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_98_2113) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2114) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2115) :: [])) :: [])) :: []),(varDotVar2_2116 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2117) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2118) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2119 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2120) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_99_2121) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_165_2122) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2123 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2124 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_2125) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2126) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2127) :: [])) :: [])) :: []),(varDotVar4_2128 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2129 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2130 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2131) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_100_2132) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2133)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2133)) config (-1)))) && ((((((((((((((((((((((isTrue (evalisProcs((varQ_2111 :: [])) config (-1)))) && (true))) && (true))) && ((isTrue (evalisName((varX_2110 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisNames((varY_2124 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_2119 :: [])) config (-1)))))) && (true))))) && ((((((isTrue (eval_'EqlsEqls'Int_((var_100_2132 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_99_2121 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_98_2113 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_2114 varI_2127) = 0) && ((compare_kitem varL_2120 varL_2118) = 0) && ((compare_kitem varJ_2117 varJ_2131) = 0) && ((compare_kitem varN_2125 varN_2112) = 0) && ((compare_kitem varX_2110 varX_2123) = 0) && ((compare_kitem varP_2119 varP_2130) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2109),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2110 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2111 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(varN_2125 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_98_2113 :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_2114 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_2115 :: []),((evalSetItem((varV_2126 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_2116 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2117 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2120 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2119 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2120 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_99_2121 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_165_2122 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2128 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2129 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2119 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_2111 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_2124 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2117 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2133)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_28),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_29),`<nomo>`(_153),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(``I=>#token("\"\"","String")``)),DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`#append(_;_)_AUXFUN-SYNTAX`(Q,R)``),`<where>`(``Z=>`#append(_;_)_AUXFUN-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``U=>`_+Int_`(U,#token("1","Int"))``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isInt(J)),isInt(L)),isProcs(R)),isName(X)),isInt(V)),isInt(I)),isNames(Y)),isSet(S)),isNames(Z)),isSet(_153)),isProc(P)),isInt(N)),isInt(U)),`_>Int__INT`(L,U))),`_andBool_`(`_==Int_`(_28,#token("0","Int")),`_==Int_`(_29,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(8039fb9065775a1fc4e61fc3705fb5fbb67648c0c8b6b877d574dc5227be8fdf) collect() contentStartColumn(5) contentStartLine(1228) org.kframework.attributes.Location(Location(1228,5,1265,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2134),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2135 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2136 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_2137) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_28_2138) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2139) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2140) :: [])) :: [])) :: []),(varDotVar2_2141 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2142) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2143) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2144 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2145) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_29_2146) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_153_2147) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2148 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2149 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_2150) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2151) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2152) :: [])) :: [])) :: []),(varDotVar4_2153 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2154 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2155 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2156 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2157 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2158) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varU_2159) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2160)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2160)) config (-1)))) && ((((((((((((((((((((((((((((((isTrue (evalisProcs((varQ_2136 :: [])) config (-1)))) && (true))) && (true))) && ((isTrue (evalisProcs((varR_2156 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_2148 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisNames((varY_2149 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisNames((varZ_2157 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_2144 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_2145 :: []),(varU_2159 :: [])) config (-1)))))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_28_2138 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_29_2146 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_2139 varI_2152) = 0) && ((compare_kitem varL_2145 varL_2143) = 0) && ((compare_kitem varJ_2142 varJ_2158) = 0) && ((compare_kitem varN_2137 varN_2150) = 0) && ((compare_kitem varX_2148 varX_2135) = 0) && ((compare_kitem varP_2144 varP_2155) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2134),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_2141 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2142 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2145 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2144 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2145 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_29_2146 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_153_2147 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2148 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2149 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',(varN_2137 :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(varV_2151 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(varDotVar4_2153 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2154 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2144 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varQ_2136 :: []),(varR_2156 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'where'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varY_2149 :: []),(varZ_2157 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2142 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((eval_'Plus'Int_((varU_2159 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_2140 :: []),((evalSetItem((varV_2151 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(_168),`<state>`(``#token("\"collection\"","String")=>#token("\"\"","String")``),`<match>`(``L=>#token("0","Int")``),`<type>`(_81),`<nomo>`(``_169=>`.Set`(.KList)``),`<listens>`(_170)),DotVar2))),`<reaction>`(`<who>`(_171),`<what>`(_172),`<where>`(_173),`<rid>`(J),`<rnum>`(L),`<react>`(``#token("\"forget\"","String")=>#token("\"react\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(isSet(_169),`_andBool_`(#token("true","Bool"),isListenCellBag(_170))),isInt(J)),isInt(L))),`_==Int_`(_81,#token("1","Int"))) ensures #token("true","Bool") [UNIQUE_ID(d818fa4c533a733153fd6b85d6c7460e53d0b33598175eb989ad488fa96b050b) comm() contentStartColumn(5) contentStartLine(584) org.kframework.attributes.Location(Location(584,5,602,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2161),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_2162),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2163) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2164) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_168_2165)) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2166) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_81_2167) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_169_2168) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_170_2169 :: [])) :: [])) :: []),(varDotVar2_2170 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_171_2171)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_172_2172)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_173_2173)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2174) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varL_2175) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2176)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2176)) config (-1)))) && (((((((true) && (((true) && ((isTrue (evalisListenCellBag((var_170_2169 :: [])) config (-1)))))))) && (true))) && (true))))) && ((isTrue (eval_'EqlsEqls'Int_((var_81_2167 :: []),((Lazy.force int1) :: [])) config (-1))))) && (((compare_kitem varL_2164 varL_2175) = 0) && ((compare_kitem varL_2175 varL_2166) = 0) && ((compare_kitem varJ_2163 varJ_2174) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2161),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_2162),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2163 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2164 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_168_2165)) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Lazy.force int0) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_81_2167 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Lazy.force const'Stop'Set))) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(var_170_2169 :: [])) :: [])) :: []),(varDotVar2_2170 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_171_2171)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_172_2172)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_173_2173)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2163 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(varL_2164 :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "react") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2176)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_40),`<stype>`(_41),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_42),`<nomo>`(_184),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_43),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``#token("\"\"","String")=>Q``),`<where>`(``#token("\"\"","String")=>Y``),`<rid>`(J),`<rnum>`(``_44=>#token("1","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isSet(_184),isName(Y)),isProc(Q)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isSet(S)),isProc(P))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_42,#token("0","Int")),`_==Int_`(_43,#token("1","Int"))),`_==Int_`(_40,#token("1","Int"))),`_==Int_`(_41,#token("0","Int"))),`_==Int_`(_44,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(63f21250780c5a1ca9a320f12a8fb00a9c1e0b9d584609485297dae63adeb8de) contentStartColumn(5) contentStartLine(614) initialize() org.kframework.attributes.Location(Location(614,5,650,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2177),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2178 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2179 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_40_2180) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_41_2181) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2182) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2183) :: [])) :: [])) :: []),(varDotVar2_2184 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2185) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2186) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2187 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2188) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_42_2189) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_184_2190) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2191 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2192 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_43_2193) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2194) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2195) :: [])) :: [])) :: []),(varDotVar4_2196 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2197 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2198 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2199) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_44_2200) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2201)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2201)) config (-1)))) && (((((((((((((((((((true) && ((isTrue (evalisName((varY_2192 :: [])) config (-1)))))) && ((isTrue (evalisProc((varQ_2179 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_2191 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisProc((varP_2187 :: [])) config (-1)))))))) && ((((((((((isTrue (eval_'EqlsEqls'Int_((var_42_2189 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_43_2193 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_40_2180 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_41_2181 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_44_2200 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem varI_2182 varI_2195) = 0) && ((compare_kitem varL_2186 varL_2188) = 0) && ((compare_kitem varJ_2185 varJ_2199) = 0) && ((compare_kitem varX_2191 varX_2178) = 0) && ((compare_kitem varP_2187 varP_2198) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2177),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_2184 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2185 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2186 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2187 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2186 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_42_2189 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_184_2190 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2196 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2197 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2187 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_2179 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_2192 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2185 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_2183 :: []),((evalSetItem((varV_2194 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_72),`<stype>`(_73),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_74),`<nomo>`(_163),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_75),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`_,__GRHO-SYNTAX`(Q,R)``),`<where>`(``Z=>`_,__GRHO-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``U=>`_+Int_`(U,#token("1","Int"))``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isSet(_163),isName(Y)),isProc(Q)),isInt(J)),isInt(L)),isProcs(R)),isName(X)),isInt(V)),isInt(I)),isSet(S)),isNames(Z)),isProc(P)),isInt(U)),`_>Int__INT`(L,U))),`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_74,#token("0","Int")),`_==Int_`(_73,#token("1","Int"))),`_==Int_`(_72,#token("1","Int"))),`_==Int_`(_75,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(84f8121ce14c46706f64aa1a9d084156f6dfd23a6dfbb51ca961eeb34bf5d0b3) collect() contentStartColumn(5) contentStartLine(1515) org.kframework.attributes.Location(Location(1515,5,1552,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2202),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2203 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2204 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_72_2205) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_73_2206) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2207) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2208) :: [])) :: [])) :: []),(varDotVar2_2209 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2210) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2211) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2212 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2213) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_74_2214) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_163_2215) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2216 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2217 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_75_2218) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2219) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2220) :: [])) :: [])) :: []),(varDotVar4_2221 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2222 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2223 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2224 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2225 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2226) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varU_2227) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2228)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2228)) config (-1)))) && (((((((((((((((((((((((((((true) && ((isTrue (evalisName((varY_2217 :: [])) config (-1)))))) && ((isTrue (evalisProc((varQ_2204 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProcs((varR_2224 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_2203 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisNames((varZ_2225 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_2212 :: [])) config (-1)))))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_2211 :: []),(varU_2227 :: [])) config (-1)))))))) && ((((((((isTrue (eval_'EqlsEqls'Int_((var_74_2214 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_73_2206 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_72_2205 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_75_2218 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_2220 varI_2207) = 0) && ((compare_kitem varL_2211 varL_2213) = 0) && ((compare_kitem varJ_2226 varJ_2210) = 0) && ((compare_kitem varX_2203 varX_2216) = 0) && ((compare_kitem varP_2212 varP_2223) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2202),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2203 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2204 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(var_72_2205 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_73_2206 :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_2220 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_2208 :: []),((evalSetItem((varV_2219 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_2209 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2226 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2211 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2212 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2211 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_74_2214 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_163_2215 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2221 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2222 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2212 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_2204 :: []),(varR_2224 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_2217 :: []),(varZ_2225 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2226 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((eval_'Plus'Int_((varU_2227 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2228)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_or__GRHO-SYNTAX`(K0,HOLE)=>HOLE~>`#freezer_or__GRHO-SYNTAX0_`(K0)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isBExp(HOLE),isBExp(K0)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(45763a525dce2d9538e3f514630fbd571c2e704ab83197c80489b3434adbf6c5) heat() org.kframework.attributes.Location(Location(163,24,163,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1533547487) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_or__GRHO'Hyph'SYNTAX,(varK0_2229 :: []),(varHOLE_2230 :: [])) :: varDotVar3_2231)) :: [])) :: []),(varDotVar1_2232 :: [])) config (-1)) :: [])) :: []),(var_0_2233),(var_1_2234)) :: []) when (((((isTrue (evalisBExp((varHOLE_2230 :: [])) config (-1)))) && ((isTrue (evalisBExp((varK0_2229 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_2230 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2230 :: KApply1(Lbl'Hash'freezer_or__GRHO'Hyph'SYNTAX0_,(varK0_2229 :: [])) :: varDotVar3_2231)) :: [])) :: []),(varDotVar1_2232 :: [])) config (-1)))) :: []),(var_0_2233),(var_1_2234)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_57),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_58),`<nomo>`(_88),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`#append(_;_)_AUXFUN-SYNTAX`(Q,R)``),`<where>`(``Z=>`#append(_;_)_AUXFUN-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``_59=>#token("2","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isName(Z)),isSet(_88)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isProc(R)),isNames(Y)),isSet(S)),isProc(P)),isInt(N))),`_andBool_`(`_andBool_`(`_==Int_`(_57,#token("1","Int")),`_==Int_`(_59,#token("1","Int"))),`_==Int_`(_58,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(64b7bd25e7ab7ae2feeb8438af075751e42b7f78dcb669b9fb07f1d6fba2baf6) collect() contentStartColumn(5) contentStartLine(1475) org.kframework.attributes.Location(Location(1475,5,1511,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2235),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2236 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2237 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_2238) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_57_2239) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2240) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2241) :: [])) :: [])) :: []),(varDotVar2_2242 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2243) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2244) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2245 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2246) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_58_2247) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_88_2248) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2249 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2250 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_2251) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2252) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2253) :: [])) :: [])) :: []),(varDotVar4_2254 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2255 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2256 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2257 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2258 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2259) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_59_2260) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2261)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2261)) config (-1)))) && ((((((((((((((((((((((((((isTrue (evalisProcs((varQ_2237 :: [])) config (-1)))) && ((isTrue (evalisName((varZ_2258 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisName((varX_2236 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varR_2257 :: [])) config (-1)))))) && ((isTrue (evalisNames((varY_2250 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_2245 :: [])) config (-1)))))) && (true))))) && ((((((isTrue (eval_'EqlsEqls'Int_((var_57_2239 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_59_2260 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_58_2247 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem varI_2253 varI_2240) = 0) && ((compare_kitem varL_2244 varL_2246) = 0) && ((compare_kitem varJ_2259 varJ_2243) = 0) && ((compare_kitem varN_2238 varN_2251) = 0) && ((compare_kitem varX_2236 varX_2249) = 0) && ((compare_kitem varP_2245 varP_2256) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2235),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2236 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2237 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(varN_2238 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_57_2239 :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_2253 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_2241 :: []),((evalSetItem((varV_2252 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_2242 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2259 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2244 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2245 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2244 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_58_2247 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_88_2248 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2254 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2255 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2245 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varQ_2237 :: []),(varR_2257 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'where'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varY_2250 :: []),(varZ_2258 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2259 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int2) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2261)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_-__GRHO-SYNTAX1_`(K1)=>`_-__GRHO-SYNTAX`(HOLE,K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(HOLE),isAExp(K1)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(add36f094821bf6f4d2fc29f99ec6ec6679d4c49c81e6892e6c9e9f06ee86a21) cool() org.kframework.attributes.Location(Location(153,24,153,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(100445376) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2262 :: KApply1(Lbl'Hash'freezer_'Hyph'__GRHO'Hyph'SYNTAX1_,(varK1_2263 :: [])) :: varDotVar3_2264)) :: [])) :: []),(varDotVar1_2265 :: [])) config (-1)) :: [])) :: []),(var_0_2266),(var_1_2267)) :: []) when (((((isTrue (evalisAExp((varHOLE_2262 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_2263 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_2262 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'Hyph'__GRHO'Hyph'SYNTAX((varHOLE_2262 :: []),(varK1_2263 :: [])) config (-1)) @ varDotVar3_2264)) :: [])) :: []),(varDotVar1_2265 :: [])) config (-1)))) :: []),(var_0_2266),(var_1_2267)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_55),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_56),`<nomo>`(_146),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`#append(_;_)_AUXFUN-SYNTAX`(Q,R)``),`<where>`(``Z=>`#append(_;_)_AUXFUN-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``U=>`_+Int_`(U,#token("1","Int"))``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isSet(_146)),isInt(J)),isInt(L)),isProcs(R)),isName(X)),isInt(V)),isInt(I)),isNames(Y)),isSet(S)),isNames(Z)),isProc(P)),isInt(N)),isInt(U)),`_>Int__INT`(L,U))),`_andBool_`(`_==Int_`(_56,#token("0","Int")),`_==Int_`(_55,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(38d9e94296d652439deced9b0466e643ae601f39daa59b39662dd6ebd44d9e8a) collect() contentStartColumn(5) contentStartLine(1556) org.kframework.attributes.Location(Location(1556,5,1593,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2268),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2269 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2270 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_2271) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_55_2272) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2273) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2274) :: [])) :: [])) :: []),(varDotVar2_2275 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2276) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2277) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2278 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2279) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_56_2280) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_146_2281) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2282 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2283 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_2284) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2285) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2286) :: [])) :: [])) :: []),(varDotVar4_2287 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2288 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2289 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2290 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2291 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2292) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varU_2293) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2294)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2294)) config (-1)))) && ((((((((((((((((((((((((((((((isTrue (evalisProcs((varQ_2270 :: [])) config (-1)))) && (true))) && (true))) && (true))) && ((isTrue (evalisProcs((varR_2290 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_2282 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisNames((varY_2283 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisNames((varZ_2291 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_2278 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_2277 :: []),(varU_2293 :: [])) config (-1)))))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_56_2280 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_55_2272 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_2286 varI_2273) = 0) && ((compare_kitem varL_2277 varL_2279) = 0) && ((compare_kitem varJ_2292 varJ_2276) = 0) && ((compare_kitem varN_2271 varN_2284) = 0) && ((compare_kitem varX_2282 varX_2269) = 0) && ((compare_kitem varP_2278 varP_2289) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2268),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2282 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2270 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(varN_2271 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_55_2272 :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_2286 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_2274 :: []),((evalSetItem((varV_2285 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_2275 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2292 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2277 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2278 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2277 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_56_2280 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_146_2281 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2287 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2288 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2278 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varQ_2270 :: []),(varR_2290 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'where'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varY_2283 :: []),(varZ_2291 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2292 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((eval_'Plus'Int_((varU_2293 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2294)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`` `.ThreadCellBag`(.KList)=>`<thread>`(`<k>`(`_[_/_]_SUBSTITUTION`(P,`@__GRHO-SYNTAX`(Q),Y)))``,DotVar1)),DotVar0,`<reaction>`(`<who>`(``P=>.K``),`<what>`(``Q=>.K``),`<where>`(``Y=>.K``),`<rid>`(``I=>.K``),`<rnum>`(``_185=>.K``),`<react>`(``#token("\"react\"","String")=>.K``),`<forg>`(``_0=>.K``))) requires `_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isInt(I)),isProc(P))) ensures #token("true","Bool") [UNIQUE_ID(d6c5706391852d8377e536736703e3e1842b5283594e65308e84be89af55e856) comm() contentStartColumn(5) contentStartLine(429) org.kframework.attributes.Location(Location(429,5,440,15)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_(((Lazy.force const'Stop'ThreadCellBag) :: []),(varDotVar1_2295 :: [])) config (-1)) :: [])) :: []),(varDotVar0_2296),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2297 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_2298 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_2299 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varI_2300) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_185_2301)) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "react") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2302)) :: [])) :: [])) :: []) when (((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2302)) config (-1)))) && ((((((((isTrue (evalisName((varY_2299 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_2298 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_2297 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION((varP_2297 :: []),((eval'_AT_'__GRHO'Hyph'SYNTAX((varQ_2298 :: [])) config (-1))),(varY_2299 :: [])) config (-1)))) :: [])) :: []),(varDotVar1_2295 :: [])) config (-1)))) :: []),(varDotVar0_2296),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',([])) :: []),(KApply1(Lbl'_LT_'what'_GT_',([])) :: []),(KApply1(Lbl'_LT_'where'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',([])) :: []),(KApply1(Lbl'_LT_'react'_GT_',([])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',([])) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_10),`<stype>`(_11),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_12),`<nomo>`(_167),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_13),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`_,__GRHO-SYNTAX`(Q,R)``),`<where>`(``Z=>`_,__GRHO-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``_14=>#token("2","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isName(Z)),isInt(J)),isSet(_167)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isProc(R)),isSet(S)),isProc(P))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_11,#token("0","Int")),`_==Int_`(_14,#token("1","Int"))),`_==Int_`(_13,#token("1","Int"))),`_==Int_`(_10,#token("1","Int"))),`_==Int_`(_12,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(53060b3dd24f2b967de8e3d86213079126a52797542d35c8320e9b21871cb420) collect() contentStartColumn(5) contentStartLine(943) org.kframework.attributes.Location(Location(943,5,979,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2303),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2304 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2305 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_10_2306) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_11_2307) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2308) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2309) :: [])) :: [])) :: []),(varDotVar2_2310 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2311) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2312) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2313 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2314) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_12_2315) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_167_2316) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2317 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2318 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_13_2319) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2320) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2321) :: [])) :: [])) :: []),(varDotVar4_2322 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2323 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2324 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2325 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2326 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2327) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_14_2328) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2329)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2329)) config (-1)))) && ((((((((((((((((((((((((isTrue (evalisName((varY_2318 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_2305 :: [])) config (-1)))))) && ((isTrue (evalisName((varZ_2326 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisName((varX_2317 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varR_2325 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((varP_2313 :: [])) config (-1)))))))) && ((((((((((isTrue (eval_'EqlsEqls'Int_((var_11_2307 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_14_2328 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_13_2319 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_10_2306 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_12_2315 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem varI_2308 varI_2321) = 0) && ((compare_kitem varL_2314 varL_2312) = 0) && ((compare_kitem varJ_2311 varJ_2327) = 0) && ((compare_kitem varX_2317 varX_2304) = 0) && ((compare_kitem varP_2313 varP_2324) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2303),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_2310 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2311 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2314 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2313 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2314 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_12_2315 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_167_2316 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2322 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2323 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2313 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_2305 :: []),(varR_2325 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_2318 :: []),(varZ_2326 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2311 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int2) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_2309 :: []),((evalSetItem((varV_2320 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``HOLE~>`#freezer_*__GRHO-SYNTAX1_`(K1)=>`_*__GRHO-SYNTAX`(HOLE,K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(HOLE),isAExp(K1)),`_andBool_`(#token("true","Bool"),isKResult(HOLE))) ensures #token("true","Bool") [UNIQUE_ID(d50c7236f4c8313752c600c4c158b4eb1f15659779aeb3ce10f89963070ed71e) cool() org.kframework.attributes.Location(Location(151,24,151,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1774690057) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2330 :: KApply1(Lbl'Hash'freezer_'Star'__GRHO'Hyph'SYNTAX1_,(varK1_2331 :: [])) :: varDotVar3_2332)) :: [])) :: []),(varDotVar1_2333 :: [])) config (-1)) :: [])) :: []),(var_0_2334),(var_1_2335)) :: []) when (((((isTrue (evalisAExp((varHOLE_2330 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_2331 :: [])) config (-1)))))) && (((true) && ((isTrue (evalisKResult((varHOLE_2330 :: [])) config (-1))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'Star'__GRHO'Hyph'SYNTAX((varHOLE_2330 :: []),(varK1_2331 :: [])) config (-1)) @ varDotVar3_2332)) :: [])) :: []),(varDotVar1_2333 :: [])) config (-1)))) :: []),(var_0_2334),(var_1_2335)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_85),`<stype>`(_86),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_87),`<nomo>`(_150),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_88),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``#token("\"\"","String")=>Q``),`<where>`(``#token("\"\"","String")=>Y``),`<rid>`(J),`<rnum>`(``_89=>#token("1","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isSet(_150)),isProc(Q)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isSet(S)),isProc(P))),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_==Int_`(_86,#token("0","Int")),`_==Int_`(_85,#token("1","Int"))),`_==Int_`(_89,#token("0","Int"))),`_==Int_`(_88,#token("1","Int"))),`_==Int_`(_87,#token("2","Int")))) ensures #token("true","Bool") [UNIQUE_ID(f96c50435704ec2b246550ca443d7553ca41a116e0d41e9c8fc9a41a374da55e) contentStartColumn(5) contentStartLine(777) initialize() org.kframework.attributes.Location(Location(777,5,813,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2336),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2337 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2338 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_85_2339) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_86_2340) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2341) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2342) :: [])) :: [])) :: []),(varDotVar2_2343 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2344) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2345) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2346 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2347) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_87_2348) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_150_2349) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2350 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2351 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_88_2352) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2353) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2354) :: [])) :: [])) :: []),(varDotVar4_2355 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2356 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2357 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2358) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_89_2359) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2360)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2360)) config (-1)))) && ((((((((((((((((((((isTrue (evalisName((varY_2351 :: [])) config (-1)))) && (true))) && ((isTrue (evalisProc((varQ_2338 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_2350 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisProc((varP_2346 :: [])) config (-1)))))))) && ((((((((((isTrue (eval_'EqlsEqls'Int_((var_86_2340 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_85_2339 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_89_2359 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_88_2352 :: []),((Lazy.force int1) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_87_2348 :: []),((Lazy.force int2) :: [])) config (-1))))))) && (((compare_kitem varI_2341 varI_2354) = 0) && ((compare_kitem varL_2347 varL_2345) = 0) && ((compare_kitem varJ_2358 varJ_2344) = 0) && ((compare_kitem varX_2350 varX_2337) = 0) && ((compare_kitem varP_2346 varP_2357) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2336),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2350 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2338 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(var_85_2339 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_86_2340 :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_2341 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_2342 :: []),((evalSetItem((varV_2353 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_2343 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2358 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2347 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2346 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2347 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_87_2348 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_150_2349 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2355 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2356 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2346 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varQ_2338 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varY_2351 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2358 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2360)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(N),`<stype>`(_82),`<sid>`(I),`<mlid>`(S))=>`.SendCellBag`(.KList)``,DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_83),`<nomo>`(_124),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(N),`<lid>`(V),`<msid>`(``I=>#token("\"\"","String")``)),DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`#append(_;_)_AUXFUN-SYNTAX`(Q,R)``),`<where>`(``Z=>`#append(_;_)_AUXFUN-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``_84=>#token("2","Int")``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(``_0=>`Set:difference`(S,`SetItem`(V))``))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProcs(Q),isName(Z)),isInt(J)),isInt(L)),isName(X)),isInt(V)),isInt(I)),isProc(R)),isNames(Y)),isSet(S)),isSet(_124)),isProc(P)),isInt(N))),`_andBool_`(`_andBool_`(`_==Int_`(_83,#token("1","Int")),`_==Int_`(_82,#token("0","Int"))),`_==Int_`(_84,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(69264738e524408df0475218c06c83c6172153f33081f0c13d27ec38579e2f2b) collect() contentStartColumn(5) contentStartLine(1147) org.kframework.attributes.Location(Location(1147,5,1183,16)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2361),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2362 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2363 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as varN_2364) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((Int _ as var_82_2365) :: [])) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2366) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2367) :: [])) :: [])) :: []),(varDotVar2_2368 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2369) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2370) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2371 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2372) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_83_2373) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_124_2374) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2375 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2376 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as varN_2377) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2378) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2379) :: [])) :: [])) :: []),(varDotVar4_2380 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2381 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2382 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2383 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2384 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2385) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as var_84_2386) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2387)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2387)) config (-1)))) && ((((((((((((((((((((((((((isTrue (evalisProcs((varQ_2363 :: [])) config (-1)))) && ((isTrue (evalisName((varZ_2384 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((varX_2375 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varR_2383 :: [])) config (-1)))))) && ((isTrue (evalisNames((varY_2376 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((varP_2371 :: [])) config (-1)))))) && (true))))) && ((((((isTrue (eval_'EqlsEqls'Int_((var_83_2373 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_82_2365 :: []),((Lazy.force int0) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_84_2386 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_2366 varI_2379) = 0) && ((compare_kitem varL_2372 varL_2370) = 0) && ((compare_kitem varJ_2369 varJ_2385) = 0) && ((compare_kitem varN_2364 varN_2377) = 0) && ((compare_kitem varX_2375 varX_2362) = 0) && ((compare_kitem varP_2371 varP_2382) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2361),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag)),(varDotVar2_2368 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2369 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2372 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2371 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2372 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_83_2373 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_124_2374 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2375 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2376 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',(varN_2364 :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(varV_2378 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(varDotVar4_2380 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2381 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2371 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varQ_2363 :: []),(varR_2383 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'where'_GT_',((eval'Hash'append'LPar'_'SCln'_'RPar'_AUXFUN'Hyph'SYNTAX((varY_2376 :: []),(varZ_2384 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2369 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Lazy.force int2) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_2367 :: []),((evalSetItem((varV_2378 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(Q),`<tuple>`(_24),`<stype>`(_107),`<sid>`(I),`<mlid>`(``S=>`Set:difference`(S,`SetItem`(V))``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(J),`<length>`(L),`<cont>`(P),`<state>`(#token("\"collection\"","String")),`<match>`(L),`<type>`(_25),`<nomo>`(_106),`<listens>`(`_ListenCellBag_`(`` `<listen>`(`<chan>`(X),`<vars>`(Y),`<num>`(_26),`<lid>`(V),`<msid>`(I))=>`.ListenCellBag`(.KList)``,DotVar4))),DotVar3))),`<reaction>`(`<who>`(P),`<what>`(``R=>`_,__GRHO-SYNTAX`(Q,R)``),`<where>`(``Z=>`_,__GRHO-SYNTAX`(Y,Z)``),`<rid>`(J),`<rnum>`(``U=>`_+Int_`(U,#token("1","Int"))``),`<react>`(``#token("\"collect\"","String")=>#token("\"forget\"","String")``),`<forg>`(_0))) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(Y),isProc(Q)),isInt(J)),isSet(_106)),isInt(L)),isProcs(R)),isName(X)),isInt(V)),isInt(I)),isSet(S)),isNames(Z)),isProc(P)),isInt(U)),`_>Int__INT`(L,U))),`_andBool_`(`_andBool_`(`_==Int_`(_24,#token("1","Int")),`_==Int_`(_25,#token("2","Int"))),`_==Int_`(_26,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(d78abf77a801fd8b514be9970ed63627dd5988fe2ffd4ed6c1c0bfd02b464dd9) collect() contentStartColumn(5) contentStartLine(1351) org.kframework.attributes.Location(Location(1351,5,1388,22)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2388),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2389 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2390 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_24_2391) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_107_2392)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as varI_2393) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Set (SortSet,_,_) as varS_2394) :: [])) :: [])) :: []),(varDotVar2_2395 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as varJ_2396) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as varL_2397) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2398 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varL_2399) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_25_2400) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_106_2401) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(varX_2402 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(varY_2403 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_26_2404) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varV_2405) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2406) :: [])) :: [])) :: []),(varDotVar4_2407 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar3_2408 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2409 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(varR_2410 :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(varZ_2411 :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',((Int _ as varJ_2412) :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((Int _ as varU_2413) :: [])) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "collect") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2414)) :: [])) :: [])) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_0_2414)) config (-1)))) && ((((((((((((((((((((((((((((isTrue (evalisName((varY_2403 :: [])) config (-1)))) && ((isTrue (evalisProc((varQ_2390 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisProcs((varR_2410 :: [])) config (-1)))))) && ((isTrue (evalisName((varX_2389 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisNames((varZ_2411 :: [])) config (-1)))))) && ((isTrue (evalisProc((varP_2409 :: [])) config (-1)))))) && (true))) && ((isTrue (eval_'_GT_'Int__INT((varL_2399 :: []),(varU_2413 :: [])) config (-1)))))))) && ((((((isTrue (eval_'EqlsEqls'Int_((var_24_2391 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_25_2400 :: []),((Lazy.force int2) :: [])) config (-1)))))) && ((isTrue (eval_'EqlsEqls'Int_((var_26_2404 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem varI_2406 varI_2393) = 0) && ((compare_kitem varL_2399 varL_2397) = 0) && ((compare_kitem varJ_2396 varJ_2412) = 0) && ((compare_kitem varX_2389 varX_2402) = 0) && ((compare_kitem varP_2409 varP_2398) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2388),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(varX_2389 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(varQ_2390 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(var_24_2391 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_107_2392)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(varI_2406 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((evalSet'Coln'difference((varS_2394 :: []),((evalSetItem((varV_2405 :: [])) config (-1)))) config (-1)))) :: [])) :: []),(varDotVar2_2395 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(varJ_2396 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(varL_2399 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(varP_2409 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "collection") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(varL_2399 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_25_2400 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_106_2401 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag)),(varDotVar4_2407 :: [])) config (-1)))) :: [])) :: []),(varDotVar3_2408 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(varP_2409 :: [])) :: []),(KApply1(Lbl'_LT_'what'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varQ_2390 :: []),(varR_2410 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'where'_GT_',(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(varY_2403 :: []),(varZ_2411 :: [])) :: [])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(varJ_2396 :: [])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',((eval_'Plus'Int_((varU_2413 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',(var_0_2414)) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `not__GRHO-SYNTAX`(HOLE)=>HOLE~>`#freezernot__GRHO-SYNTAX0_`(.KList)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(isBExp(HOLE),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(b4ac536ffa126220fbb02f35006066ff4814dc710cd51422c94cafbe34a0714e) heat() org.kframework.attributes.Location(Location(161,24,161,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1788380050) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply1(Lblnot__GRHO'Hyph'SYNTAX,(varHOLE_2415 :: [])) :: varDotVar3_2416)) :: [])) :: []),(varDotVar1_2417 :: [])) config (-1)) :: [])) :: []),(var_0_2418),(var_1_2419)) :: []) when (((isTrue (evalisBExp((varHOLE_2415 :: [])) config (-1)))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_2415 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2415 :: const'Hash'freezernot__GRHO'Hyph'SYNTAX0_ :: varDotVar3_2416)) :: [])) :: []),(varDotVar1_2417 :: [])) config (-1)))) :: []),(var_0_2418),(var_1_2419)) :: [])), (StepFunc step))
(*{| rule `<T>`(DotVar0,`<tuplespace>`(DotVar1,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(_115),`<length>`(_116),`<cont>`(_117),`<state>`(_118),`<match>`(``M=>`_-Int__INT`(M,#token("1","Int"))``),`<type>`(_119),`<nomo>`(_120),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(_121),`<vars>`(_122),`<num>`(_123),`<lid>`(J),`<msid>`(``I=>#token("\"\"","String")``)),DotVar3))),DotVar2))),`<reaction>`(`<who>`(_110),`<what>`(_111),`<where>`(_112),`<rid>`(_113),`<rnum>`(_114),`<react>`(#token("\"forget\"","String")),`<forg>`(``S=>`Set:difference`(S,`SetItem`(J))``))) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isSet(_120),isInt(J)),isInt(I)),isSet(S)),isInt(M)),`Set:in`(J,S)) ensures #token("true","Bool") [UNIQUE_ID(f463d11fc8a9dbaa19623a027de127aa9f69432857832f61e9e952390ca2f11d) contentStartColumn(5) contentStartLine(468) forget() org.kframework.attributes.Location(Location(468,5,497,20)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2420),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_2421),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_115_2422)) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_116_2423)) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_117_2424)) :: []),(KApply1(Lbl'_LT_'state'_GT_',(var_118_2425)) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as varM_2426) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_119_2427)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_120_2428) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(var_121_2429)) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(var_122_2430)) :: []),(KApply1(Lbl'_LT_'num'_GT_',(var_123_2431)) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as varJ_2432) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((Int _ as varI_2433) :: [])) :: [])) :: []),(varDotVar3_2434 :: [])) config (-1)) :: [])) :: [])) :: []),(varDotVar2_2435 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_110_2436)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_111_2437)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_112_2438)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(var_113_2439)) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_114_2440)) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((Set (SortSet,_,_) as varS_2441) :: [])) :: [])) :: [])) :: []) when ((((((((((true) && (true))) && (true))) && (true))) && (true))) && ((isTrue (evalSet'Coln'in((varJ_2432 :: []),(varS_2441 :: [])) config (-1))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(varDotVar0_2420),(KApply2(Lbl'_LT_'tuplespace'_GT_',(varDotVar1_2421),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_115_2422)) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_116_2423)) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_117_2424)) :: []),(KApply1(Lbl'_LT_'state'_GT_',(var_118_2425)) :: []),(KApply1(Lbl'_LT_'match'_GT_',((eval_'Hyph'Int__INT((varM_2426 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_119_2427)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_120_2428 :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(var_121_2429)) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(var_122_2430)) :: []),(KApply1(Lbl'_LT_'num'_GT_',(var_123_2431)) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(varJ_2432 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(varDotVar3_2434 :: [])) config (-1)))) :: [])) :: []),(varDotVar2_2435 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',(var_110_2436)) :: []),(KApply1(Lbl'_LT_'what'_GT_',(var_111_2437)) :: []),(KApply1(Lbl'_LT_'where'_GT_',(var_112_2438)) :: []),(KApply1(Lbl'_LT_'rid'_GT_',(var_113_2439)) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',(var_114_2440)) :: []),(KApply1(Lbl'_LT_'react'_GT_',((String "forget") :: [])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',((evalSet'Coln'difference((varS_2441 :: []),((evalSetItem((varJ_2432 :: [])) config (-1)))) config (-1)))) :: [])) :: [])) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_<=__GRHO-SYNTAX`(K0,HOLE)=>HOLE~>`#freezer_<=__GRHO-SYNTAX0_`(K0)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(K0),isAExp(HOLE)),`_andBool_`(isKResult(K0),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(77d0c61a9669e03679f52ecd831e909fabcca103c9d0122ca872782e19980dc6) heat() org.kframework.attributes.Location(Location(160,24,160,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(1650955365) seqstrict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'_LT_Eqls'__GRHO'Hyph'SYNTAX,(varK0_2442 :: []),(varHOLE_2443 :: [])) :: varDotVar3_2444)) :: [])) :: []),(varDotVar1_2445 :: [])) config (-1)) :: [])) :: []),(var_0_2446),(var_1_2447)) :: []) when (((((isTrue (evalisAExp((varK0_2442 :: [])) config (-1)))) && ((isTrue (evalisAExp((varHOLE_2443 :: [])) config (-1)))))) && ((((isTrue (evalisKResult((varK0_2442 :: [])) config (-1)))) && ((not ((isTrue (evalisKResult((varHOLE_2443 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2443 :: KApply1(Lbl'Hash'freezer_'_LT_Eqls'__GRHO'Hyph'SYNTAX0_,(varK0_2442 :: [])) :: varDotVar3_2444)) :: [])) :: []),(varDotVar1_2445 :: [])) config (-1)))) :: []),(var_0_2446),(var_1_2447)) :: [])), (StepFunc step))
(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `_-__GRHO-SYNTAX`(HOLE,K1)=>HOLE~>`#freezer_-__GRHO-SYNTAX1_`(K1)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(isAExp(HOLE),isAExp(K1)),`_andBool_`(#token("true","Bool"),`notBool_`(isKResult(HOLE)))) ensures #token("true","Bool") [UNIQUE_ID(9a7262ba2246a9cea193e86a8048fa267dd307750c020d191a502fd99d89141c) heat() org.kframework.attributes.Location(Location(153,24,153,68)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/grho.k)) productionID(100445376) strict()]|}*)
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl_'Hyph'__GRHO'Hyph'SYNTAX,(varHOLE_2448 :: []),(varK1_2449 :: [])) :: varDotVar3_2450)) :: [])) :: []),(varDotVar1_2451 :: [])) config (-1)) :: [])) :: []),(var_0_2452),(var_1_2453)) :: []) when (((((isTrue (evalisAExp((varHOLE_2448 :: [])) config (-1)))) && ((isTrue (evalisAExp((varK1_2449 :: [])) config (-1)))))) && (((true) && ((not ((isTrue (evalisKResult((varHOLE_2448 :: [])) config (-1))))))))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(varHOLE_2448 :: KApply1(Lbl'Hash'freezer_'Hyph'__GRHO'Hyph'SYNTAX1_,(varK1_2449 :: [])) :: varDotVar3_2450)) :: [])) :: []),(varDotVar1_2451 :: [])) config (-1)))) :: []),(var_0_2452),(var_1_2453)) :: [])), (StepFunc step))
| _ -> lookups_step c c (-1)
with Sys.Break -> raise (Stuck c)
and lookups_step (c: k) (config: k) (guard: int) : k * step_function = match c with 
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(var_0_2454 :: []),(var_1_2455 :: [])) :: []),(var_2_2456 :: [])) :: []),((Int _ as var_3_2457) :: [])) :: var_4_2458)) :: [])) :: []),(var_5_2459 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2460),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as var_3_2461) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_7_2462) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2463 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_9_2464) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_10_2465) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2466)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag) :: []),(var_12_2467 :: [])) config (-1)) :: [])) :: [])) :: []),(var_13_2468 :: [])) config (-1)) :: [])) :: [])) :: []),(var_14_2469)) :: []) when guard < 64(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(`_;__GRHO-SYNTAX`(A,B),P),I)=>`{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,P),I)``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(I),`<length>`(_151),`<cont>`(_152),`<state>`(#token("\"load\"","String")),`<match>`(_17),`<type>`(_18),`<nomo>`(_0),`<listens>`(`_ListenCellBag_`(`` `.ListenCellBag`(.KList)=>`<listen>`(`<chan>`(`#chan(_)_AUXFUN-SYNTAX`(A)),`<vars>`(`#bvar(_)_AUXFUN-SYNTAX`(A)),`<num>`(`#bnum(_)_AUXFUN-SYNTAX`(A)),`<lid>`(!J),`<msid>`(#token("\"\"","String")))``,DotVar7))),DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProc(_152),isLbind(A)),isInt(!J)),isInt(I)),isLbind(B)),isProc(P)),isInt(_151)),#match(!J,#fresh(#token("\"Int\"","String"))))),`_andBool_`(`_==Int_`(_17,#token("0","Int")),`_==Int_`(_18,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(1d28da2168ca57e3dde79fe402f24ad87350fb0dcab2285bfaeb3e0e17a81290) contentStartColumn(8) contentStartLine(188) load() org.kframework.attributes.Location(Location(188,8,206,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 64)
| ((Int _ as var_15_2470) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_11_2466)) config (-1)))) && ((((((((((((((((isTrue (evalisProc((var_8_2463 :: [])) config (-1)))) && ((isTrue (evalisLbind((var_0_2454 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisLbind((var_1_2455 :: [])) config (-1)))))) && ((isTrue (evalisProc((var_2_2456 :: [])) config (-1)))))) && (true))) && (true))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_9_2464 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_10_2465 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem var_3_2461 var_3_2457) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_1_2455 :: []),(var_2_2456 :: [])) :: []),(var_3_2461 :: [])) :: var_4_2458)) :: [])) :: []),(var_5_2459 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2460),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_3_2461 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_7_2462 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2463 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_9_2464 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_10_2465 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2466)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2454 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2454 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'num'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2454 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_15_2470 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_12_2467 :: [])) config (-1)))) :: [])) :: []),(var_13_2468 :: [])) config (-1)))) :: [])) :: []),(var_14_2469)) :: [])), (StepFunc step))| _ -> (lookups_step c config 64))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(var_0_2471 :: []),(var_1_2472 :: [])) :: []),(var_2_2473 :: [])) :: []),((Int _ as var_3_2474) :: [])) :: var_4_2475)) :: [])) :: []),(var_5_2476 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2477),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as var_3_2478) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_7_2479) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2480 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_9_2481) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_10_2482) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2483)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag) :: []),(var_12_2484 :: [])) config (-1)) :: [])) :: [])) :: []),(var_13_2485 :: [])) config (-1)) :: [])) :: [])) :: []),(var_14_2486)) :: []) when guard < 65(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(`_;__GRHO-SYNTAX`(A,B),P),I)=>`{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,P),I)``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(I),`<length>`(_148),`<cont>`(_149),`<state>`(#token("\"load\"","String")),`<match>`(_33),`<type>`(_34),`<nomo>`(_0),`<listens>`(`_ListenCellBag_`(`` `.ListenCellBag`(.KList)=>`<listen>`(`<chan>`(`#chan(_)_AUXFUN-SYNTAX`(A)),`<vars>`(`#bvar(_)_AUXFUN-SYNTAX`(A)),`<num>`(`#bnum(_)_AUXFUN-SYNTAX`(A)),`<lid>`(!J),`<msid>`(#token("\"\"","String")))``,DotVar7))),DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isPbind(A),isPbinds(B)),isInt(!J)),isInt(I)),isProc(P)),isInt(_148)),isProc(_149)),#match(!J,#fresh(#token("\"Int\"","String"))))),`_andBool_`(`_==Int_`(_34,#token("2","Int")),`_==Int_`(_33,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(fd5836bab13fce456e034c95c9c8b2ae7735c68a3409cc5b4dcb6ea3ae307c76) contentStartColumn(8) contentStartLine(295) load() org.kframework.attributes.Location(Location(295,8,313,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 65)
| ((Int _ as var_15_2487) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_11_2483)) config (-1)))) && ((((((((((((((((isTrue (evalisPbind((var_0_2471 :: [])) config (-1)))) && ((isTrue (evalisPbinds((var_1_2472 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((var_2_2473 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((var_8_2480 :: [])) config (-1)))))) && (true))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_10_2482 :: []),((Lazy.force int2) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_9_2481 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem var_3_2474 var_3_2478) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_1_2472 :: []),(var_2_2473 :: [])) :: []),(var_3_2474 :: [])) :: var_4_2475)) :: [])) :: []),(var_5_2476 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2477),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_3_2474 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_7_2479 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2480 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_9_2481 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_10_2482 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2483)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2471 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2471 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'num'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2471 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_15_2487 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_12_2484 :: [])) config (-1)))) :: [])) :: []),(var_13_2485 :: [])) config (-1)))) :: [])) :: []),(var_14_2486)) :: [])), (StepFunc step))| _ -> (lookups_step c config 65))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(var_0_2488 :: []),(var_1_2489 :: [])) :: []),(var_2_2490 :: [])) :: []),((Int _ as var_3_2491) :: [])) :: var_4_2492)) :: [])) :: []),(var_5_2493 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2494),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as var_3_2495) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_7_2496) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2497 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_9_2498) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_10_2499) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2500)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag) :: []),(var_12_2501 :: [])) config (-1)) :: [])) :: [])) :: []),(var_13_2502 :: [])) config (-1)) :: [])) :: [])) :: []),(var_14_2503)) :: []) when guard < 66(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(`_;__GRHO-SYNTAX`(A,B),P),I)=>`{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,P),I)``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(I),`<length>`(_192),`<cont>`(_193),`<state>`(#token("\"load\"","String")),`<match>`(_96),`<type>`(_97),`<nomo>`(_0),`<listens>`(`_ListenCellBag_`(`` `.ListenCellBag`(.KList)=>`<listen>`(`<chan>`(`#chan(_)_AUXFUN-SYNTAX`(A)),`<vars>`(`#bvar(_)_AUXFUN-SYNTAX`(A)),`<num>`(`#bnum(_)_AUXFUN-SYNTAX`(A)),`<lid>`(!J),`<msid>`(#token("\"\"","String")))``,DotVar7))),DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isRbind(A),isInt(!J)),isInt(I)),isProc(_193)),isInt(_192)),isRbinds(B)),isProc(P)),#match(!J,#fresh(#token("\"Int\"","String"))))),`_andBool_`(`_==Int_`(_97,#token("1","Int")),`_==Int_`(_96,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(db2c0f63ab5b2beb8963378e98ee6173e3942884ff53e630f2a8e9761aaf50ca) contentStartColumn(8) contentStartLine(252) load() org.kframework.attributes.Location(Location(252,8,270,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 66)
| ((Int _ as var_15_2504) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_11_2500)) config (-1)))) && ((((((((((((((((isTrue (evalisRbind((var_0_2488 :: [])) config (-1)))) && (true))) && (true))) && ((isTrue (evalisProc((var_8_2497 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisRbinds((var_1_2489 :: [])) config (-1)))))) && ((isTrue (evalisProc((var_2_2490 :: [])) config (-1)))))) && (true))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_10_2499 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_9_2498 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem var_3_2491 var_3_2495) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_1_2489 :: []),(var_2_2490 :: [])) :: []),(var_3_2491 :: [])) :: var_4_2492)) :: [])) :: []),(var_5_2493 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2494),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_3_2491 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_7_2496 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2497 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_9_2498 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_10_2499 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2500)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2488 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2488 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'num'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2488 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_15_2504 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_12_2501 :: [])) config (-1)))) :: [])) :: []),(var_13_2502 :: [])) config (-1)))) :: [])) :: []),(var_14_2503)) :: [])), (StepFunc step))| _ -> (lookups_step c config 66))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(var_0_2505 :: []),(var_1_2506 :: [])) :: []),(var_2_2507 :: [])) :: []),((Int _ as var_3_2508) :: [])) :: var_4_2509)) :: [])) :: []),(var_5_2510 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2511),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as var_3_2512) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_7_2513) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2514 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_9_2515) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_10_2516) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2517)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag) :: []),(var_12_2518 :: [])) config (-1)) :: [])) :: [])) :: []),(var_13_2519 :: [])) config (-1)) :: [])) :: [])) :: []),(var_14_2520)) :: []) when guard < 67(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(`_;__GRHO-SYNTAX`(A,B),P),I)=>`{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,P),I)``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(I),`<length>`(_134),`<cont>`(_135),`<state>`(#token("\"load\"","String")),`<match>`(_61),`<type>`(_62),`<nomo>`(_0),`<listens>`(`_ListenCellBag_`(`` `.ListenCellBag`(.KList)=>`<listen>`(`<chan>`(`#chan(_)_AUXFUN-SYNTAX`(A)),`<vars>`(`#bvar(_)_AUXFUN-SYNTAX`(A)),`<num>`(`#bnum(_)_AUXFUN-SYNTAX`(A)),`<lid>`(!J),`<msid>`(#token("\"\"","String")))``,DotVar7))),DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProc(_135),isInt(_134)),isRbind(A)),isInt(!J)),isInt(I)),isRbind(B)),isProc(P)),#match(!J,#fresh(#token("\"Int\"","String"))))),`_andBool_`(`_==Int_`(_62,#token("1","Int")),`_==Int_`(_61,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(9dd4418d4e26f7f5dce02acf32ab0e02e743e9ea068f93f2f9094ce16e30ea7c) contentStartColumn(8) contentStartLine(231) load() org.kframework.attributes.Location(Location(231,8,249,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 67)
| ((Int _ as var_15_2521) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_11_2517)) config (-1)))) && ((((((((((((((((isTrue (evalisProc((var_8_2514 :: [])) config (-1)))) && (true))) && ((isTrue (evalisRbind((var_0_2505 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisRbind((var_1_2506 :: [])) config (-1)))))) && ((isTrue (evalisProc((var_2_2507 :: [])) config (-1)))))) && (true))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_10_2516 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_9_2515 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem var_3_2508 var_3_2512) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_1_2506 :: []),(var_2_2507 :: [])) :: []),(var_3_2508 :: [])) :: var_4_2509)) :: [])) :: []),(var_5_2510 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2511),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_3_2508 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_7_2513 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2514 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_9_2515 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_10_2516 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2517)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2505 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2505 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'num'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2505 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_15_2521 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_12_2518 :: [])) config (-1)))) :: [])) :: []),(var_13_2519 :: [])) config (-1)))) :: [])) :: []),(var_14_2520)) :: [])), (StepFunc step))| _ -> (lookups_step c config 67))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(var_0_2522 :: []),(var_1_2523 :: [])) :: []),(var_2_2524 :: [])) :: []),((Int _ as var_3_2525) :: [])) :: var_4_2526)) :: [])) :: []),(var_5_2527 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2528),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as var_3_2529) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_7_2530) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2531 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_9_2532) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_10_2533) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2534)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag) :: []),(var_12_2535 :: [])) config (-1)) :: [])) :: [])) :: []),(var_13_2536 :: [])) config (-1)) :: [])) :: [])) :: []),(var_14_2537)) :: []) when guard < 68(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(`_;__GRHO-SYNTAX`(A,B),P),I)=>`{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,P),I)``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(I),`<length>`(_160),`<cont>`(_161),`<state>`(#token("\"load\"","String")),`<match>`(_63),`<type>`(_64),`<nomo>`(_0),`<listens>`(`_ListenCellBag_`(`` `.ListenCellBag`(.KList)=>`<listen>`(`<chan>`(`#chan(_)_AUXFUN-SYNTAX`(A)),`<vars>`(`#bvar(_)_AUXFUN-SYNTAX`(A)),`<num>`(`#bnum(_)_AUXFUN-SYNTAX`(A)),`<lid>`(!J),`<msid>`(#token("\"\"","String")))``,DotVar7))),DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isPbind(A),isPbind(B)),isInt(_160)),isInt(!J)),isInt(I)),isProc(_161)),isProc(P)),#match(!J,#fresh(#token("\"Int\"","String"))))),`_andBool_`(`_==Int_`(_64,#token("2","Int")),`_==Int_`(_63,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(2c7613c445631592b001937d654335a77956f345647c0deb4e96ace3b80a704a) contentStartColumn(8) contentStartLine(274) load() org.kframework.attributes.Location(Location(274,8,292,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 68)
| ((Int _ as var_15_2538) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_11_2534)) config (-1)))) && ((((((((((((((((isTrue (evalisPbind((var_0_2522 :: [])) config (-1)))) && ((isTrue (evalisPbind((var_1_2523 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisProc((var_8_2531 :: [])) config (-1)))))) && ((isTrue (evalisProc((var_2_2524 :: [])) config (-1)))))) && (true))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_10_2533 :: []),((Lazy.force int2) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_9_2532 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem var_3_2525 var_3_2529) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_1_2523 :: []),(var_2_2524 :: [])) :: []),(var_3_2525 :: [])) :: var_4_2526)) :: [])) :: []),(var_5_2527 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2528),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_3_2525 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_7_2530 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2531 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_9_2532 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_10_2533 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2534)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2522 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2522 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'num'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2522 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_15_2538 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_12_2535 :: [])) config (-1)))) :: [])) :: []),(var_13_2536 :: [])) config (-1)))) :: [])) :: []),(var_14_2537)) :: [])), (StepFunc step))| _ -> (lookups_step c config 68))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(KApply2(Lbl_'SCln'__GRHO'Hyph'SYNTAX,(var_0_2539 :: []),(var_1_2540 :: [])) :: []),(var_2_2541 :: [])) :: []),((Int _ as var_3_2542) :: [])) :: var_4_2543)) :: [])) :: []),(var_5_2544 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2545),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as var_3_2546) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_7_2547) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2548 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_9_2549) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((Int _ as var_10_2550) :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2551)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag) :: []),(var_12_2552 :: [])) config (-1)) :: [])) :: [])) :: []),(var_13_2553 :: [])) config (-1)) :: [])) :: [])) :: []),(var_14_2554)) :: []) when guard < 69(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(`_;__GRHO-SYNTAX`(A,B),P),I)=>`{[_;_]}_GRHO-SYNTAX`(`for(_){_}_GRHO-SYNTAX`(B,P),I)``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(I),`<length>`(_190),`<cont>`(_191),`<state>`(#token("\"load\"","String")),`<match>`(_45),`<type>`(_46),`<nomo>`(_0),`<listens>`(`_ListenCellBag_`(`` `.ListenCellBag`(.KList)=>`<listen>`(`<chan>`(`#chan(_)_AUXFUN-SYNTAX`(A)),`<vars>`(`#bvar(_)_AUXFUN-SYNTAX`(A)),`<num>`(`#bnum(_)_AUXFUN-SYNTAX`(A)),`<lid>`(!J),`<msid>`(#token("\"\"","String")))``,DotVar7))),DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isLbind(A),isProc(_191)),isLbinds(B)),isInt(!J)),isInt(I)),isInt(_190)),isProc(P)),#match(!J,#fresh(#token("\"Int\"","String"))))),`_andBool_`(`_==Int_`(_46,#token("0","Int")),`_==Int_`(_45,#token("0","Int")))) ensures #token("true","Bool") [UNIQUE_ID(54f8f283c1dc9513992c263ef151303128a530c87131338d4c72689b34fb8297) contentStartColumn(8) contentStartLine(209) load() org.kframework.attributes.Location(Location(209,8,227,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 69)
| ((Int _ as var_15_2555) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_11_2551)) config (-1)))) && ((((((((((((((((isTrue (evalisLbind((var_0_2539 :: [])) config (-1)))) && ((isTrue (evalisProc((var_8_2548 :: [])) config (-1)))))) && ((isTrue (evalisLbinds((var_1_2540 :: [])) config (-1)))))) && (true))) && (true))) && (true))) && ((isTrue (evalisProc((var_2_2541 :: [])) config (-1)))))) && (true))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_10_2550 :: []),((Lazy.force int0) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_9_2549 :: []),((Lazy.force int0) :: [])) config (-1))))))) && (((compare_kitem var_3_2542 var_3_2546) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(KApply2(Lblfor'LPar'_'RParLBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_1_2540 :: []),(var_2_2541 :: [])) :: []),(var_3_2542 :: [])) :: var_4_2543)) :: [])) :: []),(var_5_2544 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_6_2545),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_3_2542 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_7_2547 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_8_2548 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_9_2549 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_10_2550 :: [])) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_11_2551)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2539 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2539 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'num'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2539 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_15_2555 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_12_2552 :: [])) config (-1)))) :: [])) :: []),(var_13_2553 :: [])) config (-1)))) :: [])) :: []),(var_14_2554)) :: [])), (StepFunc step))| _ -> (lookups_step c config 69))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(var_0_2556 :: []),((Int _ as var_1_2557) :: [])) :: var_2_2558)) :: [])) :: []),(var_3_2559 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_4_2560),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',((Int _ as var_1_2561) :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_5_2562) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_6_2563 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_7_2564) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_8_2565)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_9_2566)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_(((Lazy.force const'Stop'ListenCellBag) :: []),(var_10_2567 :: [])) config (-1)) :: [])) :: [])) :: []),(var_11_2568 :: [])) config (-1)) :: [])) :: [])) :: []),(var_12_2569)) :: []) when guard < 70(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `{[_;_]}_GRHO-SYNTAX`(R,I)=>.K``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`<rec>`(`<id>`(I),`<length>`(_175),`<cont>`(_176),`<state>`(``#token("\"load\"","String")=>#token("\"\"","String")``),`<match>`(_48),`<type>`(_177),`<nomo>`(_0),`<listens>`(`_ListenCellBag_`(`` `.ListenCellBag`(.KList)=>`<listen>`(`<chan>`(`#chan(_)_AUXFUN-SYNTAX`(R)),`<vars>`(`#bvar(_)_AUXFUN-SYNTAX`(R)),`<num>`(`#bnum(_)_AUXFUN-SYNTAX`(R)),`<lid>`(!J),`<msid>`(#token("\"\"","String")))``,DotVar7))),DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(`_==K_`(`.Set`(.KList),_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(!J),isInt(I)),isProc(_176)),isInt(_175)),isSingleRec(R)),#match(!J,#fresh(#token("\"Int\"","String"))))),`_==Int_`(_48,#token("0","Int"))) ensures #token("true","Bool") [UNIQUE_ID(78470d7378057d85d76acbaf6350322f37cfaaf7b30cee117bc7f8dd9ef7716f) contentStartColumn(8) contentStartLine(165) load() org.kframework.attributes.Location(Location(165,8,183,14)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 70)
| ((Int _ as var_13_2570) :: []) when (((((isTrue (eval_'EqlsEqls'K_(((Lazy.force const'Stop'Set)),(var_9_2566)) config (-1)))) && (((((((((((true) && (true))) && ((isTrue (evalisProc((var_6_2563 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisSingleRec((var_0_2556 :: [])) config (-1)))))) && (true))))) && ((isTrue (eval_'EqlsEqls'Int_((var_7_2564 :: []),((Lazy.force int0) :: [])) config (-1))))) && (((compare_kitem var_1_2561 var_1_2557) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(var_2_2558)) :: [])) :: []),(var_3_2559 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_4_2560),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_1_2561 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',(var_5_2562 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_6_2563 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',(var_7_2564 :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_8_2565)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',(var_9_2566)) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2556 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2556 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'num'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2556 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_13_2570 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_10_2567 :: [])) config (-1)))) :: [])) :: []),(var_11_2568 :: [])) config (-1)))) :: [])) :: []),(var_12_2569)) :: [])), (StepFunc step))| _ -> (lookups_step c config 70))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lblnew_in'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_0_2571 :: []),(var_1_2572 :: [])) :: var_2_2573)) :: [])) :: []),(var_3_2574 :: [])) config (-1)) :: [])) :: []),(var_4_2575),(var_5_2576)) :: []) when guard < 71(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `new_in{_}_GRHO-SYNTAX`(N,P)=>`_[_/_]_SUBSTITUTION`(P,`unforgeable(_)_GRHO-SYNTAX`(!I),N)``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(`_andBool_`(isName(N),isProc(P)),isInt(!I)),#match(!I,#fresh(#token("\"Int\"","String")))) ensures #token("true","Bool") [UNIQUE_ID(30726f680e7d8db61fc8a1d4809325b39a7ed50c00b2c87c5e682336488fc36f) contentStartColumn(8) contentStartLine(91) org.kframework.attributes.Location(Location(91,8,91,62)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 71)
| ((Int _ as var_6_2577) :: []) when (((((((isTrue (evalisName((var_0_2571 :: [])) config (-1)))) && ((isTrue (evalisProc((var_1_2572 :: [])) config (-1)))))) && (true))) && (true)) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',((eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION((var_1_2572 :: []),(KApply1(Lblunforgeable'LPar'_'RPar'_GRHO'Hyph'SYNTAX,(var_6_2577 :: [])) :: []),(var_0_2571 :: [])) config (-1)) @ var_2_2573)) :: [])) :: []),(var_3_2574 :: [])) config (-1)))) :: []),(var_4_2575),(var_5_2576)) :: [])), (StepFunc step))| _ -> (lookups_step c config 71))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lblnew_in'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(var_0_2578 :: []),(var_1_2579 :: [])) :: []),(var_2_2580 :: [])) :: var_3_2581)) :: [])) :: []),(var_4_2582 :: [])) config (-1)) :: [])) :: []),(var_5_2583),(var_6_2584)) :: []) when guard < 72(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `new_in{_}_GRHO-SYNTAX`(`_,__GRHO-SYNTAX`(M,N),P)=>`new_in{_}_GRHO-SYNTAX`(N,`_[_/_]_SUBSTITUTION`(P,`unforgeable(_)_GRHO-SYNTAX`(!I),M))``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(M),isNames(N)),isProc(P)),isInt(!I)),#match(!I,#fresh(#token("\"Int\"","String")))) ensures #token("true","Bool") [UNIQUE_ID(27d6bf504ea434a66022cd2f252885e7c42bd3d7b60517b46a2edb6d3d86ed15) contentStartColumn(8) contentStartLine(93) org.kframework.attributes.Location(Location(93,8,93,85)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 72)
| ((Int _ as var_7_2585) :: []) when (((((((((isTrue (evalisName((var_0_2578 :: [])) config (-1)))) && ((isTrue (evalisNames((var_1_2579 :: [])) config (-1)))))) && ((isTrue (evalisProc((var_2_2580 :: [])) config (-1)))))) && (true))) && (true)) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lblnew_in'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_1_2579 :: []),((eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION((var_2_2580 :: []),(KApply1(Lblunforgeable'LPar'_'RPar'_GRHO'Hyph'SYNTAX,(var_7_2585 :: [])) :: []),(var_0_2578 :: [])) config (-1)))) :: var_3_2581)) :: [])) :: []),(var_4_2582 :: [])) config (-1)))) :: []),(var_5_2583),(var_6_2584)) :: [])), (StepFunc step))| _ -> (lookups_step c config 72))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lblnew_in'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(KApply2(Lbl_'Comm'__GRHO'Hyph'SYNTAX,(var_0_2586 :: []),(var_1_2587 :: [])) :: []),(var_2_2588 :: [])) :: var_3_2589)) :: [])) :: []),(var_4_2590 :: [])) config (-1)) :: [])) :: []),(var_5_2591),(var_6_2592)) :: []) when guard < 73(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(`` `new_in{_}_GRHO-SYNTAX`(`_,__GRHO-SYNTAX`(M,N),P)=>`new_in{_}_GRHO-SYNTAX`(N,`_[_/_]_SUBSTITUTION`(P,`unforgeable(_)_GRHO-SYNTAX`(!I),M))``~>DotVar3)),DotVar1)),_0,_1) requires `_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isName(M),isName(N)),isProc(P)),isInt(!I)),#match(!I,#fresh(#token("\"Int\"","String")))) ensures #token("true","Bool") [UNIQUE_ID(6fca8ae240b5b6514f49fe69237875428a5801e58d6102663384051e7796e64d) contentStartColumn(8) contentStartLine(92) org.kframework.attributes.Location(Location(92,8,92,85)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 73)
| ((Int _ as var_7_2593) :: []) when (((((((((isTrue (evalisName((var_0_2586 :: [])) config (-1)))) && ((isTrue (evalisName((var_1_2587 :: [])) config (-1)))))) && ((isTrue (evalisProc((var_2_2588 :: [])) config (-1)))))) && (true))) && (true)) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lblnew_in'LBra'_'RBra'_GRHO'Hyph'SYNTAX,(var_1_2587 :: []),((eval_'LSqB'_'Slsh'_'RSqB'_SUBSTITUTION((var_2_2588 :: []),(KApply1(Lblunforgeable'LPar'_'RPar'_GRHO'Hyph'SYNTAX,(var_7_2593 :: [])) :: []),(var_0_2586 :: [])) config (-1)))) :: var_3_2589)) :: [])) :: []),(var_4_2590 :: [])) config (-1)))) :: []),(var_5_2591),(var_6_2592)) :: [])), (StepFunc step))| _ -> (lookups_step c config 73))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(var_0_2594 :: var_1_2595)) :: [])) :: []),(var_2_2596 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_3_2597),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_(((Lazy.force const'Stop'RecCellBag) :: []),(var_4_2598 :: [])) config (-1)) :: [])) :: [])) :: []),(var_5_2599)) :: []) when guard < 74(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``R=>.K``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`` `.RecCellBag`(.KList)=>`<rec>`(`<id>`(!I),`<length>`(#token("1","Int")),`<cont>`(`#cont(_)_AUXFUN-SYNTAX`(R)),`<state>`(#token("\"\"","String")),`<match>`(#token("0","Int")),`<type>`(`#rtype(_)_AUXFUN-SYNTAX`(R)),`<nomo>`(`.Set`(.KList)),`<listens>`(`<listen>`(`<chan>`(`#chan(_)_AUXFUN-SYNTAX`(R)),`<vars>`(`#bvar(_)_AUXFUN-SYNTAX`(R)),`<num>`(`#bnum(_)_AUXFUN-SYNTAX`(R)),`<lid>`(!J),`<msid>`(#token("\"\"","String")))))``,DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(`_andBool_`(isInt(!J),isInt(!I)),isSingleRec(R)),`_andBool_`(#match(!J,#fresh(#token("\"Int\"","String"))),#match(!I,#fresh(#token("\"Int\"","String"))))) ensures #token("true","Bool") [UNIQUE_ID(04c8aeef5f15469e7a457ee7ef98a6f7192b28a74c94c54c8eda8725c28403c9) contentStartColumn(8) contentStartLine(118) load() org.kframework.attributes.Location(Location(118,8,136,24)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 74)
| ((Int _ as var_7_2600) :: []) -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 74)
| ((Int _ as var_6_2601) :: []) when ((((((true) && (true))) && ((isTrue (evalisSingleRec((var_0_2594 :: [])) config (-1)))))) && (((true) && (true)))) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(var_1_2595)) :: [])) :: []),(var_2_2596 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_3_2597),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_6_2601 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((Lazy.force int1) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',((eval'Hash'cont'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2594 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Lazy.force int0) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((eval'Hash'rtype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2594 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Lazy.force const'Stop'Set))) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2594 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((eval'Hash'bvar'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2594 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'num'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2594 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_7_2600 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: [])) :: [])) :: []),(var_4_2598 :: [])) config (-1)))) :: [])) :: []),(var_5_2599)) :: [])), (StepFunc step))| _ -> (lookups_step c config 74))| _ -> (lookups_step c config 74))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(var_0_2602 :: var_1_2603)) :: [])) :: []),(var_2_2604 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_3_2605),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_(((Lazy.force const'Stop'RecCellBag) :: []),(var_4_2606 :: [])) config (-1)) :: [])) :: [])) :: []),(var_5_2607)) :: []) when guard < 75(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``R=>`{[_;_]}_GRHO-SYNTAX`(R,!I)``~>DotVar3)),DotVar1)),`<tuplespace>`(DotVar4,`<receives>`(`_RecCellBag_`(`` `.RecCellBag`(.KList)=>`<rec>`(`<id>`(!I),`<length>`(`#bnum(_)_AUXFUN-SYNTAX`(R)),`<cont>`(`#cont(_)_AUXFUN-SYNTAX`(R)),`<state>`(#token("\"load\"","String")),`<match>`(#token("0","Int")),`<type>`(`#rtype(_)_AUXFUN-SYNTAX`(R)),`<nomo>`(`.Set`(.KList)),`<listens>`(`<listen>`(`<chan>`(#token("\"\"","String")),`<vars>`(#token("\"\"","String")),`<num>`(#token("\"\"","String")),`<lid>`(#token("\"\"","String")),`<msid>`(#token("\"\"","String")))))``,DotVar5))),DotVar0) requires `_andBool_`(`_andBool_`(isMultiRec(R),isInt(!I)),#match(!I,#fresh(#token("\"Int\"","String")))) ensures #token("true","Bool") [UNIQUE_ID(3c942f7a60da2430e3d03c47e7afed550269b2f4da9f071fedfebb70ab000787) contentStartColumn(8) contentStartLine(143) load() org.kframework.attributes.Location(Location(143,8,161,24)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 75)
| ((Int _ as var_6_2608) :: []) when (((((isTrue (evalisMultiRec((var_0_2602 :: [])) config (-1)))) && (true))) && (true)) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(KApply2(Lbl'LBraLSqB'_'SCln'_'RSqBRBra'_GRHO'Hyph'SYNTAX,(var_0_2602 :: []),(var_6_2608 :: [])) :: var_1_2603)) :: [])) :: []),(var_2_2604 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(var_3_2605),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(KApply1(Lbl'_LT_'id'_GT_',(var_6_2608 :: [])) :: []),(KApply1(Lbl'_LT_'length'_GT_',((eval'Hash'bnum'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2602 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'cont'_GT_',((eval'Hash'cont'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2602 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "load") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Lazy.force int0) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',((eval'Hash'rtype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2602 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Lazy.force const'Stop'Set))) :: []),(KApply1(Lbl'_LT_'listens'_GT_',(KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: [])) :: [])) :: []),(var_4_2606 :: [])) config (-1)))) :: [])) :: []),(var_5_2607)) :: [])), (StepFunc step))| _ -> (lookups_step c config 75))
| (KApply3(Lbl'_LT_'T'_GT_',(var_0_2609),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(var_1_2610 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(var_2_2611 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_3_2612) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_4_2613)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as var_5_2614) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',(var_6_2615)) :: [])) :: []),(var_7_2616 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(var_8_2617),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_9_2618) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_10_2619 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_11_2620) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_12_2621)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_13_2622) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(var_1_2623 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(var_14_2624 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_3_2625) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as var_15_2626) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_16_2627 :: [])) config (-1)) :: [])) :: [])) :: []),(var_17_2628 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',([])) :: []),(KApply1(Lbl'_LT_'what'_GT_',([])) :: []),(KApply1(Lbl'_LT_'where'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',([])) :: []),(KApply1(Lbl'_LT_'react'_GT_',([])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',([])) :: [])) :: [])) :: []) when guard < 76(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(_144),`<tuple>`(N),`<stype>`(_145),`<sid>`(I),`<mlid>`(``_0=>`_Set_`(`SetItem`(J),DotVar3)``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(DotVar5,`<length>`(L),`<cont>`(_141),`<state>`(#token("\"\"","String")),`<match>`(``M=>`_+Int_`(M,#token("1","Int"))``),`<type>`(_142),`<nomo>`(``S=>`_Set_`(S,`SetItem`(I))``),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(X),`<vars>`(_143),`<num>`(N),`<lid>`(J),`<msid>`(``#token("\"\"","String")=>I``)),DotVar6))),DotVar4))),`<reaction>`(`<who>`(.K),`<what>`(.K),`<where>`(.K),`<rid>`(.K),`<rnum>`(.K),`<react>`(.K),`<forg>`(.K))) requires `_andBool_`(#match(DotVar3,_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isInt(J),isInt(L)),isName(X)),isInt(I)),isSet(S)),isProc(_141)),isInt(N)),isInt(M)),isProcs(_144)),isNames(_143)),`_andBool_`(`notBool_`(`Set:in`(I,S)),`_>Int__INT`(L,M)))) ensures #token("true","Bool") [UNIQUE_ID(6d6c0afd433d908e985d862fa16318992882f4436c561c3f832f991a42279c88) contentStartColumn(5) contentStartLine(365) match() org.kframework.attributes.Location(Location(365,5,399,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
 -> (let e = (var_6_2615) in match e with 
| [Bottom] -> (lookups_step c config 76)
| ((Set (SortSet,_,_) as var_18_2629) :: []) when ((true) && (((((((((((((((((((((true) && (true))) && ((isTrue (evalisName((var_1_2610 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProc((var_10_2619 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisProcs((var_2_2611 :: [])) config (-1)))))) && ((isTrue (evalisNames((var_14_2624 :: [])) config (-1)))))) && ((((not ((isTrue (evalSet'Coln'in((var_5_2614 :: []),(var_13_2622 :: [])) config (-1)))))) && ((isTrue (eval_'_GT_'Int__INT((var_9_2618 :: []),(var_11_2620 :: [])) config (-1))))))))) && (((compare_kitem var_3_2625 var_3_2612) = 0) && ((compare_kitem var_1_2610 var_1_2623) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(var_0_2609),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(var_1_2610 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(var_2_2611 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(var_3_2625 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_4_2613)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(var_5_2614 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((eval_Set_(((evalSetItem((var_15_2626 :: [])) config (-1))),(var_18_2629 :: [])) config (-1)))) :: [])) :: []),(var_7_2616 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(var_8_2617),(KApply1(Lbl'_LT_'length'_GT_',(var_9_2618 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_10_2619 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((eval_'Plus'Int_((var_11_2620 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_12_2621)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((eval_Set_((var_13_2622 :: []),((evalSetItem((var_5_2614 :: [])) config (-1)))) config (-1)))) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(var_1_2610 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(var_14_2624 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',(var_3_2625 :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_15_2626 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',(var_5_2614 :: [])) :: [])) :: []),(var_16_2627 :: [])) config (-1)))) :: [])) :: []),(var_17_2628 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',([])) :: []),(KApply1(Lbl'_LT_'what'_GT_',([])) :: []),(KApply1(Lbl'_LT_'where'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',([])) :: []),(KApply1(Lbl'_LT_'react'_GT_',([])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',([])) :: [])) :: [])) :: [])), (StepFunc step))| _ -> (lookups_step c config 76))
| (KApply3(Lbl'_LT_'T'_GT_',(var_0_2630),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(var_1_2631 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(var_2_2632 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((Int _ as var_3_2633) :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_4_2634)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',((Int _ as var_5_2635) :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',(var_6_2636)) :: [])) :: []),(var_7_2637 :: [])) config (-1)) :: [])) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(var_8_2638),(KApply1(Lbl'_LT_'length'_GT_',((Int _ as var_9_2639) :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_10_2640 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((Int _ as var_11_2641) :: [])) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_12_2642)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((Set (SortSet,_,_) as var_13_2643) :: [])) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(var_1_2644 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(var_14_2645 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',((Int _ as var_15_2646) :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',((Int _ as var_16_2647) :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',((String "") :: [])) :: [])) :: []),(var_17_2648 :: [])) config (-1)) :: [])) :: [])) :: []),(var_18_2649 :: [])) config (-1)) :: [])) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',([])) :: []),(KApply1(Lbl'_LT_'what'_GT_',([])) :: []),(KApply1(Lbl'_LT_'where'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',([])) :: []),(KApply1(Lbl'_LT_'react'_GT_',([])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',([])) :: [])) :: [])) :: []) when guard < 77(*{| rule `<T>`(DotVar0,`<tuplespace>`(`<sends>`(`_SendCellBag_`(`<send>`(`<schan>`(X),`<msg>`(_181),`<tuple>`(_19),`<stype>`(_182),`<sid>`(I),`<mlid>`(``_0=>`_Set_`(`SetItem`(J),DotVar3)``)),DotVar2)),`<receives>`(`_RecCellBag_`(`<rec>`(DotVar5,`<length>`(L),`<cont>`(_178),`<state>`(#token("\"\"","String")),`<match>`(``M=>`_+Int_`(M,#token("1","Int"))``),`<type>`(_179),`<nomo>`(``S=>`_Set_`(S,`SetItem`(I))``),`<listens>`(`_ListenCellBag_`(`<listen>`(`<chan>`(X),`<vars>`(_180),`<num>`(_20),`<lid>`(J),`<msid>`(``#token("\"\"","String")=>I``)),DotVar6))),DotVar4))),`<reaction>`(`<who>`(.K),`<what>`(.K),`<where>`(.K),`<rid>`(.K),`<rnum>`(.K),`<react>`(.K),`<forg>`(.K))) requires `_andBool_`(`_andBool_`(#match(DotVar3,_0),`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(`_andBool_`(isProc(_181),isName(_180)),isInt(J)),isInt(L)),isName(X)),isInt(I)),isProc(_178)),isSet(S)),isInt(M)),`_andBool_`(`notBool_`(`Set:in`(I,S)),`_>Int__INT`(L,M)))),`_andBool_`(`_==Int_`(_20,#token("1","Int")),`_==Int_`(_19,#token("1","Int")))) ensures #token("true","Bool") [UNIQUE_ID(3b20d3c88b3b7b1650559ce09ae64059651cae7ca6e37cd470d4c0e56b4df3fd) contentStartColumn(5) contentStartLine(327) match() org.kframework.attributes.Location(Location(327,5,361,49)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K "requires" K)]|}*)
 -> (let e = (var_6_2636) in match e with 
| [Bottom] -> (lookups_step c config 77)
| ((Set (SortSet,_,_) as var_19_2650) :: []) when ((((true) && ((((((((((((((((((((isTrue (evalisProc((var_2_2632 :: [])) config (-1)))) && ((isTrue (evalisName((var_14_2645 :: [])) config (-1)))))) && (true))) && (true))) && ((isTrue (evalisName((var_1_2631 :: [])) config (-1)))))) && (true))) && ((isTrue (evalisProc((var_10_2640 :: [])) config (-1)))))) && (true))) && (true))) && ((((not ((isTrue (evalSet'Coln'in((var_5_2635 :: []),(var_13_2643 :: [])) config (-1)))))) && ((isTrue (eval_'_GT_'Int__INT((var_9_2639 :: []),(var_11_2641 :: [])) config (-1)))))))))) && ((((isTrue (eval_'EqlsEqls'Int_((var_15_2646 :: []),((Lazy.force int1) :: [])) config (-1)))) && ((isTrue (eval_'EqlsEqls'Int_((var_3_2633 :: []),((Lazy.force int1) :: [])) config (-1))))))) && (((compare_kitem var_1_2631 var_1_2644) = 0) && true) -> (((KApply3(Lbl'_LT_'T'_GT_',(var_0_2630),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',(var_1_2631 :: [])) :: []),(KApply1(Lbl'_LT_'msg'_GT_',(var_2_2632 :: [])) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',(var_3_2633 :: [])) :: []),(KApply1(Lbl'_LT_'stype'_GT_',(var_4_2634)) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(var_5_2635 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((eval_Set_(((evalSetItem((var_16_2647 :: [])) config (-1))),(var_19_2650 :: [])) config (-1)))) :: [])) :: []),(var_7_2637 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'receives'_GT_',((eval_RecCellBag_((KApply8(Lbl'_LT_'rec'_GT_',(var_8_2638),(KApply1(Lbl'_LT_'length'_GT_',(var_9_2639 :: [])) :: []),(KApply1(Lbl'_LT_'cont'_GT_',(var_10_2640 :: [])) :: []),(KApply1(Lbl'_LT_'state'_GT_',((String "") :: [])) :: []),(KApply1(Lbl'_LT_'match'_GT_',((eval_'Plus'Int_((var_11_2641 :: []),((Lazy.force int1) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'type'_GT_',(var_12_2642)) :: []),(KApply1(Lbl'_LT_'nomo'_GT_',((eval_Set_((var_13_2643 :: []),((evalSetItem((var_5_2635 :: [])) config (-1)))) config (-1)))) :: []),(KApply1(Lbl'_LT_'listens'_GT_',((eval_ListenCellBag_((KApply5(Lbl'_LT_'listen'_GT_',(KApply1(Lbl'_LT_'chan'_GT_',(var_1_2631 :: [])) :: []),(KApply1(Lbl'_LT_'vars'_GT_',(var_14_2645 :: [])) :: []),(KApply1(Lbl'_LT_'num'_GT_',(var_15_2646 :: [])) :: []),(KApply1(Lbl'_LT_'lid'_GT_',(var_16_2647 :: [])) :: []),(KApply1(Lbl'_LT_'msid'_GT_',(var_5_2635 :: [])) :: [])) :: []),(var_17_2648 :: [])) config (-1)))) :: [])) :: []),(var_18_2649 :: [])) config (-1)))) :: [])) :: []),(KApply7(Lbl'_LT_'reaction'_GT_',(KApply1(Lbl'_LT_'who'_GT_',([])) :: []),(KApply1(Lbl'_LT_'what'_GT_',([])) :: []),(KApply1(Lbl'_LT_'where'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rid'_GT_',([])) :: []),(KApply1(Lbl'_LT_'rnum'_GT_',([])) :: []),(KApply1(Lbl'_LT_'react'_GT_',([])) :: []),(KApply1(Lbl'_LT_'forg'_GT_',([])) :: [])) :: [])) :: [])), (StepFunc step))| _ -> (lookups_step c config 77))
| (KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(var_0_2651 :: var_1_2652)) :: [])) :: []),(var_2_2653 :: [])) config (-1)) :: [])) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_(((Lazy.force const'Stop'SendCellBag) :: []),(var_3_2654 :: [])) config (-1)) :: [])) :: []),(var_4_2655)) :: []),(var_5_2656)) :: []) when guard < 78(*{| rule `<T>`(`<threads>`(`_ThreadCellBag_`(`<thread>`(`<k>`(``S=>.K``~>DotVar3)),DotVar1)),`<tuplespace>`(`<sends>`(`_SendCellBag_`(`` `.SendCellBag`(.KList)=>`<send>`(`<schan>`(`#chan(_)_AUXFUN-SYNTAX`(S)),`<msg>`(`#msg(_)_AUXFUN-SYNTAX`(S)),`<tuple>`(`#length__AUXFUN-SYNTAX`(tuple(`#msg(_)_AUXFUN-SYNTAX`(S)))),`<stype>`(`#stype(_)_AUXFUN-SYNTAX`(S)),`<sid>`(!I),`<mlid>`(`.Set`(.KList)))``,DotVar5)),DotVar4),DotVar0) requires `_andBool_`(`_andBool_`(isInt(!I),isSend(S)),#match(!I,#fresh(#token("\"Int\"","String")))) ensures #token("true","Bool") [UNIQUE_ID(ba6bf346eaf1e88de70820ec0269a6f99488bd7ae5be1ace41744b2a09211808) contentStartColumn(8) contentStartLine(103) load() org.kframework.attributes.Location(Location(103,8,111,25)) org.kframework.attributes.Source(Source(/home/isaac/Documents/KFramework/Git/Languages/GroundedRho/Join/./join.k)) org.kframework.definition.Production(syntax RuleContent ::= K)]|}*)
 -> (let e = ((eval'Hash'fresh(((String "Int") :: [])) config (-1))) in match e with 
| [Bottom] -> (lookups_step c config 78)
| ((Int _ as var_6_2657) :: []) when ((((true) && ((isTrue (evalisSend((var_0_2651 :: [])) config (-1)))))) && (true)) && (true) -> (((KApply3(Lbl'_LT_'T'_GT_',(KApply1(Lbl'_LT_'threads'_GT_',((eval_ThreadCellBag_((KApply1(Lbl'_LT_'thread'_GT_',(KApply1(Lbl'_LT_'k'_GT_',(var_1_2652)) :: [])) :: []),(var_2_2653 :: [])) config (-1)))) :: []),(KApply2(Lbl'_LT_'tuplespace'_GT_',(KApply1(Lbl'_LT_'sends'_GT_',((eval_SendCellBag_((KApply6(Lbl'_LT_'send'_GT_',(KApply1(Lbl'_LT_'schan'_GT_',((eval'Hash'chan'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2651 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'msg'_GT_',((eval'Hash'msg'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2651 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'tuple'_GT_',((eval'Hash'length__AUXFUN'Hyph'SYNTAX((KApply1(Lbltuple,((eval'Hash'msg'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2651 :: [])) config (-1)))) :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'stype'_GT_',((eval'Hash'stype'LPar'_'RPar'_AUXFUN'Hyph'SYNTAX((var_0_2651 :: [])) config (-1)))) :: []),(KApply1(Lbl'_LT_'sid'_GT_',(var_6_2657 :: [])) :: []),(KApply1(Lbl'_LT_'mlid'_GT_',((Lazy.force const'Stop'Set))) :: [])) :: []),(var_3_2654 :: [])) config (-1)))) :: []),(var_4_2655)) :: []),(var_5_2656)) :: [])), (StepFunc step))| _ -> (lookups_step c config 78))
| _ -> raise (Stuck c)
let make_stuck (config: k) : k = config
let make_unstuck (config: k) : k = config
let get_thread_set (config: k) : k = [Map(SortMap,Lbl_Map_,KMap.empty)]
let set_thread_set (config: k) (set: k) : k = config
end
let () = Plugin.the_definition := Some (module Def)
