let layout ~children =
  let open Dream_html in
  let open Dream_html.Hx in
  let open HTML in
  html
    [ lang "en" ]
    [ head
        []
        [ title [] "SIMAInsurance"
        ; meta [ charset "UTF-8" ]
        ; meta [ name "viewport"; content "width=device-width, initial-scale=1.0" ]
        ; script [ src "https://unpkg.com/htmx.org@1.9.12" ] ""
        ; script
            [ src
                "https://cdn.tailwindcss.com?plugins=forms,typography,aspect-ratio,container-queries"
            ]
            ""
        ]
    ; body
        [ class_
            "h-screen bg-gray-50 dark:bg-gray-900 flex flex-col items-center \
             justify-center"
        ; boost true
        ]
        [ children ]
    ]
;;
