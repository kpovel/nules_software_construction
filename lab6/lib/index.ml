let index_page _req =
  let open Dream_html in
  let open HTML in
  Layout.layout
    ~children:
      (main
         []
         [ div
             [ class_ "space-y-4 text-center" ]
             [ h1
                 [ class_
                     "text-5xl font-bold tracking-tight text-gray-900 dark:text-gray-50"
                 ]
                 [ txt "SIMAInsurance" ]
             ; p
                 [ class_ "max-w-md text-lg text-gray-500 dark:text-gray-400" ]
                 [ txt
                     "Providing comprehensive auto, home, and life insurance coverage to \
                      protect what matters most."
                 ]
             ; div
                 [ class_ "flex flex-col gap-2 sm:flex-row justify-center " ]
                 [ a
                     [ href "/signup"
                     ; class_
                         "inline-flex h-10 items-center justify-center rounded-md \
                          bg-gray-900 px-8 text-sm font-medium text-gray-50 shadow \
                          transition-colors hover:bg-gray-900/90 \
                          focus-visible:outline-none focus-visible:ring-1 \
                          focus-visible:ring-gray-950 disabled:pointer-events-none \
                          disabled:opacity-50 dark:bg-gray-50 dark:text-gray-900 \
                          dark:hover:bg-gray-50/90 dark:focus-visible:ring-gray-300"
                     ]
                     [ txt "Sign up" ]
                 ; a
                     [ href "/login"
                     ; class_
                         "inline-flex h-10 items-center justify-center rounded-md border \
                          border-gray-200 border-gray-200 bg-white px-8 text-sm \
                          font-medium shadow-sm transition-colors hover:bg-gray-100 \
                          hover:text-gray-900 focus-visible:outline-none \
                          focus-visible:ring-1 focus-visible:ring-gray-950 \
                          disabled:pointer-events-none disabled:opacity-50 \
                          dark:border-gray-800 dark:border-gray-800 dark:bg-gray-950 \
                          dark:hover:bg-gray-800 dark:hover:text-gray-50 \
                          dark:focus-visible:ring-gray-300"
                     ]
                     [ txt "Log in" ]
                 ]
             ]
         ])
;;
