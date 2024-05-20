open Lwt.Syntax
open Base

module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

let policy_list =
  let query =
    let open Caqti_request.Infix in
    (T.unit ->* T.(tup3 int string int)) "select id, type, base_price from policy;"
  in
  fun (module Db : DB) ->
    let* comments_or_error = Db.collect_list query () in
    Caqti_lwt.or_fail comments_or_error
;;

let policy_page req =
  let open Dream_html in
  let open HTML in
  let* policy_list = Dream.sql req policy_list in
  Lwt.wrap (fun () ->
    Layout.layout
      ~children:
        (body
           []
           [ h1 [] [ txt "SIMASoftware" ]
           ; h2 [] [ txt "" ]
           ; div []
             @@ List.map policy_list ~f:(fun (policy_id, policy_type, base_price) ->
               div
                 [ id "%d" policy_id ]
                 [ txt "Type: %s, Price: %d" policy_type base_price ])
           ]))
;;
