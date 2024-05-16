open Base

let assertm condition message =
  if not condition then failwith ("Assertion failed: " ^ message)
;;

class _customer name policy =
  object
    val name : string = name
    val mutable policy : string option = policy

    method take_out_policy selected_policy =
      assertm
        (List.mem
           [ "Auto"; "Property"; "Travel"; "Health"; "Business" ]
           selected_policy
           ~equal:(fun x y -> String.equal x y))
        (Stdlib.Printf.sprintf "Selected policy not available %s" selected_policy);
      policy <- Some selected_policy;
      ()

    method report_incident () = ()
  end

let email_max_length = 320

let _send_mail email _message =
  assertm (String.length email > email_max_length) "Maximum email length reached";
  ()
;;

let () = ()
