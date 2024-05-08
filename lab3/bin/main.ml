open Base

type _policy =
  | Auto
  | Property
  | Travel
  | Health
  | Business

type incident = < name : string ; policy : _policy >

class person name phone =
  object
    val name : string = name
    val phone : string = phone
    method name = name
    method phone = phone
  end

class ['a] _manager name phone =
  object
    inherit person name phone
    method contact_client () = ()
    method register_insured_event (_event : incident) = ()
  end

class ['a] _customer (person : person) policy =
  object
    val person = person
    val mutable policy : _policy option = policy

    method take_out_policy selected_policy =
      policy <- Some selected_policy;
      ()

    method report_incident () = ()
  end

let () =
  Stdlib.Printf.printf "Програмне забезпечення інформаційної системи страхової компанії"
;;
