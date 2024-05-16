type policy =
  | Auto
  | Property
  | Travel
  | Health
  | Business

type user =
  { name : string
  ; email : string
  ; age : int
  }

let base_insurence_price = 500

let calculate_insurence_price customer policy =
  let old_customer = customer.age > 60 in
  let base_price =
    if old_customer then base_insurence_price * 2 else base_insurence_price
  in
  match policy with
  | Auto -> base_price * 2
  | Property -> base_price * 3
  | Travel -> base_price * 3
  | Health -> base_price * 2
  | Business -> base_price * 5
;;

let db_write_insurance customer policy price = ()

let register_insurance_policies customer policy =
  let insurence_price = calculate_insurence_price customer policy in
  db_write_insurance customer policy insurence_price;
  ()
;;

let page () =
  let open Dream_html in
  let open HTML in
  html
    [ lang "en" ]
    [ head [] [ title [] "SIMASoftware" ]
    ; body
        []
        [ h1 [] [ txt "SIMASoftware" ]
        ; p [] [ txt "Is cool!" ]
        ; form
            [ method_ `POST; action "/feedback" ]
            [ label [ for_ "what-you-think" ] [ txt "Tell us what you think!" ]
            ; input [ name "what-you-think"; id "what-you-think" ]
            ; button [ type_ "submit" ] [ txt "Send" ]
            ]
        ]
    ]
;;

let () =
  Dream.run ~port:42069
  @@ Dream.logger
  @@ Dream.router
       [ Dream.get "/" (fun _ -> Dream_html.respond (page ()))
       ; Dream.get "/echo/foo" (fun _ -> Dream.html "foo route")
       ; Dream.get "/echo/:caml" (fun request -> Dream.html (Dream.param request "caml"))
       ]
;;
