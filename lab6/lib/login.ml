open! Base

let login_page _req =
  let open Dream_html in
  let open Dream_html.Hx in
  let open HTML in
  Layout.layout
    ~children:
      (div
         [ class_
             "flex min-h-screen flex-col items-center justify-center px-4 py-12 sm:px-6 \
              lg:px-8"
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
                     [ txt "Log in for SIMAInsurance" ]
                 ]
             ; form
                 [ class_ "space-y-6"
                 ; post "/login"
                 ; Hx.target "#error"
                 ; swap "innerHTML"
                 ]
                 [ div
                     []
                     [ label
                         [ class_
                             "text-sm font-medium leading-none \
                              peer-disabled:cursor-not-allowed peer-disabled:opacity-70 \
                              sr-only"
                         ; for_ "email"
                         ]
                         [ txt "Email address" ]
                     ; input
                         [ class_
                             "h-10 bg-background text-sm ring-offset-background \
                              file:border-0 file:bg-transparent file:text-sm \
                              file:font-medium placeholder:text-muted-foreground \
                              focus-visible:outline-none focus-visible:ring-2 \
                              focus-visible:ring-ring focus-visible:ring-offset-2 \
                              disabled:cursor-not-allowed disabled:opacity-50 relative \
                              block w-full appearance-none rounded-md border \
                              border-gray-300 px-3 py-2 text-gray-900 \
                              placeholder-gray-500 focus:z-10 focus:border-gray-900 \
                              focus:outline-none focus:ring-gray-900 \
                              dark:border-gray-700 dark:bg-gray-950 dark:text-gray-50 \
                              dark:placeholder-gray-500 dark:focus:border-gray-700 \
                              dark:focus:ring-gray-700"
                         ; id "email"
                         ; autocomplete `email
                         ; required
                         ; placeholder "Email address"
                         ; type_ "email"
                         ; name "email"
                         ]
                     ]
                 ; div
                     []
                     [ label
                         [ class_
                             "text-sm font-medium leading-none \
                              peer-disabled:cursor-not-allowed peer-disabled:opacity-70 \
                              sr-only"
                         ; for_ "password"
                         ]
                         [ txt "Password" ]
                     ; input
                         [ class_
                             "h-10 bg-background text-sm ring-offset-background \
                              file:border-0 file:bg-transparent file:text-sm \
                              file:font-medium placeholder:text-muted-foreground \
                              focus-visible:outline-none focus-visible:ring-2 \
                              focus-visible:ring-ring focus-visible:ring-offset-2 \
                              disabled:cursor-not-allowed disabled:opacity-50 relative \
                              block w-full appearance-none rounded-md border \
                              border-gray-300 px-3 py-2 text-gray-900 \
                              placeholder-gray-500 focus:z-10 focus:border-gray-900 \
                              focus:outline-none focus:ring-gray-900 \
                              dark:border-gray-700 dark:bg-gray-950 dark:text-gray-50 \
                              dark:placeholder-gray-500 dark:focus:border-gray-700 \
                              dark:focus:ring-gray-700"
                         ; id "password"
                         ; autocomplete `current_password
                         ; required
                         ; placeholder "Password"
                         ; type_ "password"
                         ; name "password"
                         ]
                     ]
                 ; div
                     []
                     [ button
                         [ class_
                             "items-center whitespace-nowrap ring-offset-background \
                              transition-colors focus-visible:outline-none \
                              focus-visible:ring-2 focus-visible:ring-ring \
                              focus-visible:ring-offset-2 disabled:pointer-events-none \
                              disabled:opacity-50 h-10 relative flex w-full \
                              justify-center rounded-md bg-gray-900 py-2 px-4 text-sm \
                              font-medium text-white shadow-sm hover:bg-gray-900/90 \
                              focus:outline-none focus:ring-2 focus:ring-gray-900 \
                              focus:ring-offset-2 dark:bg-gray-50 dark:text-gray-900 \
                              dark:hover:bg-gray-50/90 dark:focus:ring-gray-300"
                         ; type_ "submit"
                         ]
                         [ txt "Log in" ]
                     ]
                 ; span [ class_ "text-red-500 pt-4"; id "error" ] []
                 ]
             ]
         ])
;;

let exists_user email password =
  let open Lwt.Syntax in
  let open Caqti_request.Infix in
  let query =
    (Caqti_type.(tup2 string string) ->? Caqti_type.int)
      "select id from user where email = $1 and password = $2"
  in
  fun (module Db : Caqti_lwt.CONNECTION) ->
    let* unit_or_error = Db.find_opt query (email, password) in
    Caqti_lwt.or_fail unit_or_error
;;

let login_post req =
  let open Lwt.Syntax in
  let* form = Dream.form ~csrf:false req in
  match form with
  | `Ok [ ("email", email); ("password", password) ] ->
    let* user = exists_user email password |> Dream.sql req in
    (match user with
     | Some _ ->
       Dream.empty
         `OK
         ~headers:
           [ "Set-Cookie", Stdlib.Printf.sprintf "authorized=%s; Path=/; HttpOnly" email
           ; "HX-Redirect", "/policy"
           ]
     | None -> Dream.html "Email or password does not match")
  | _ -> Dream.html "Something went wrong"
;;
