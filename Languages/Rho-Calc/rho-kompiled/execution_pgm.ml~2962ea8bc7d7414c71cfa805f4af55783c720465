
open Prelude
open Constants
open Constants.K
open Run
let () = Sys.catch_break true
let () = Gc.set { (Gc.get()) with Gc.minor_heap_size = 33554432 }let () = CONFIG.set_sys_argv ()
external load_kore_term : unit -> string = "load_kore_term"
external load_marshal_term : unit -> string = "load_marshal_term"
let unserializedKMap = match Lexer.parse_k_binary_string (load_kore_term ()) with
  [Map(SortMap, Lbl_Map_, m)] -> m
| _ -> failwith "kore_term is not of sort Map"
let serialized = (Marshal.from_string (load_marshal_term ()) 0 : Prelude.k)
let serializedKMap = match serialized with
  [Map(SortMap, Lbl_Map_, m)] -> m
| _ -> failwith "marshal_term is not of sort Map"
let completeMap = let conflict key val1 _ = Some val1 in
    [(Map (SortMap, Lbl_Map_, KMap.union conflict unserializedKMap serializedKMap))]
let input = (let module Def = (val Plugin.get ()) in Def.eval (KApply(LblinitTCell, [completeMap])) interned_bottom)
let try_match (c: k) (config: k) (guard: int) : k Subst.t = Subst.singleton "_" [Int Z.zero]
let _ = try let res, _ = run_no_thread_opt(input) (!CONFIG.depth) in let subst = try_match res res (-1) in
let code = get_exit_code subst in
exit code
with Stuck(res) -> (prerr_endline "Execution failed (configuration dumped)";
let out = open_out !CONFIG.output_file in output_string out (print_k res);
exit 139)
