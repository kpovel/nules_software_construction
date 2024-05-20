open! Base
open Lwt.Syntax

module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

let user_by_email email =
  let query =
    let open Caqti_request.Infix in
    (T.string ->* T.int) "select id from user where email = $1;"
  in
  fun (module Db : DB) ->
    let* users = Db.collect_list query email in
    Caqti_lwt.or_fail users
;;

let authorized req =
  match Dream.cookie req "authorized" ~decrypt:false with
  | Some email ->
    let* users = user_by_email email |> Dream.sql req in
    List.length users <> 0 |> Lwt.return
  | None ->
    Dream.log "No 'authorized' cookie found.";
    Lwt.return false
;;
