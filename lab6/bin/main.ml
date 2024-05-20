open! Base
open Lab6

let () =
  Dream.run ~port:42069
  @@ Dream.sql_pool "sqlite3:db/dev.db"
  @@ Dream.router
       [ Dream.get "/" (fun req -> Dream_html.respond (Index.index_page req))
       ; Dream.get "/login" (fun req -> Dream_html.respond (Login.login_page req))
       ; Dream.post "/login" (fun req -> Login.login_post req)
       ; Dream.get "/signup" (fun req -> Dream_html.respond (Signup.signup_page req))
       ; Dream.post "/signup" (fun req -> Signup.signup_post req)
       ; Dream.get "/policy" (fun req -> Policy.policy_page req)
       ]
;;
