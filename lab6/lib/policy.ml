open Lwt
open Lwt.Syntax
open! Base

module type DB = Caqti_lwt.CONNECTION

module T = Caqti_type

let policy_list =
  let query =
    let open Caqti_request.Infix in
    (T.unit ->* T.(tup2 string int)) "select type, base_price from policy;"
  in
  fun (module Db : DB) ->
    let* comments_or_error = Db.collect_list query () in
    Caqti_lwt.or_fail comments_or_error
;;

let user_age ~email =
  let query =
    let open Caqti_request.Infix in
    (T.string ->! T.int) "select age from user where email = $1;"
  in
  fun (module Db : DB) ->
    let* age = Db.find query email in
    Caqti_lwt.or_fail age
;;

let calculate_insurence_price ~customer_age policyl =
  let old_customer = customer_age > 60 in
  match old_customer with
  | true -> List.map ~f:(fun (policy_type, price) -> policy_type, price * 2) policyl
  | false -> policyl
;;

let policy_page req =
  let* authorized = Auth.authorized req in
  match authorized with
  | false -> Dream.empty `Found ~headers:[ "Location", "/" ]
  | true ->
    let user_email =
      match Dream.cookie req "authorized" ~decrypt:false with
      | Some email -> email
      | None -> raise (Failure "token should exists")
    in
    let* customer_age = user_age ~email:user_email |> Dream.sql req in
    let* policy_list = Dream.sql req policy_list in
    let policy_list = calculate_insurence_price ~customer_age policy_list in
    let open Dream_html in
    let open HTML in
    Lwt.wrap (fun () ->
      Layout.layout
        ~children:
          (div
             [ class_
                 "flex min-h-screen flex-col items-center justify-center bg-gray-50 px-4 \
                  py-12 dark:bg-gray-900 sm:px-6 lg:px-8"
             ]
             [ div
                 [ class_ "w-full max-w-md space-y-8" ]
                 [ div
                     []
                     [ h2
                         [ class_
                             "mt-6 text-center text-3xl font-bold tracking-tight \
                              text-gray-900 dark:text-gray-50"
                         ]
                         [ txt "Explore Our Insurance Policies" ]
                     ; p
                         [ class_
                             "mt-2 text-center text-sm text-gray-600 dark:text-gray-400"
                         ]
                         [ txt "Find the right coverage for your needs." ]
                     ]
                 ; div [ class_ "grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3" ]
                   @@ List.map policy_list ~f:(fun (policy_type, price) ->
                     div
                       [ class_ "rounded-lg border bg-card text-card-foreground shadow-sm"
                       ]
                       [ div
                           [ class_ "p-6 space-y-4" ]
                           [ div
                               [ class_ "text-center" ]
                               [ h3
                                   [ class_ "text-lg font-semibold" ]
                                   [ txt "%s" policy_type ]
                               ; p
                                   [ class_ "text-gray-500 dark:text-gray-400" ]
                                   [ txt "$%i/month" price ]
                               ]
                           ; button
                               [ class_
                                   "inline-flex items-center justify-center \
                                    whitespace-nowrap rounded-md text-sm font-medium \
                                    ring-offset-background transition-colors \
                                    focus-visible:outline-none focus-visible:ring-2 \
                                    focus-visible:ring-ring focus-visible:ring-offset-2 \
                                    disabled:pointer-events-none disabled:opacity-50 \
                                    bg-primary text-primary-foreground \
                                    hover:bg-primary/90 h-10 px-4 py-2 w-full"
                               ]
                               [ txt "Get a Quote" ]
                           ]
                       ])
                 ]
             ]))
    >>= Dream_html.respond
;;
