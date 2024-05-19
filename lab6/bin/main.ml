open Lwt
open Lwt.Syntax
open Base

module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

let layout ~children =
  let open Dream_html in
  let open HTML in
  html
    [ lang "en" ]
    [ head
        []
        [ title [] "SIMASoftware"
        ; meta [ charset "UTF-8" ]
        ; meta [ name "viewport"; content "width=device-width, initial-scale=1.0" ]
        ; script [ src "https://unpkg.com/htmx.org@1.9.12" ] ""
        ; script
            [ src
                "https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,container-queries"
            ]
            ""
        ]
    ; children
    ]
;;

let policy_list =
  let query =
    let open Caqti_request.Infix in
    (T.unit ->* T.(tup3 int string int)) "select id, type, base_price from policy;"
  in
  fun (module Db : DB) ->
    let* comments_or_error = Db.collect_list query () in
    Caqti_lwt.or_fail comments_or_error
;;

let policy_template req =
  let open Dream_html in
  let open HTML in
  let* policy_list = Dream.sql req policy_list in
  Lwt.wrap (fun () ->
    layout
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

let () =
  Dream.run ~port:42069
  @@ Dream.logger
  @@ Dream.sql_pool "sqlite3:db/dev.db"
  @@ Dream.router
       [ Dream.get "/policy" (fun req -> policy_template req >>= Dream_html.respond) ]
;;
