open Stdweb
open Helix

let options =
  let open Js.Encoder in
  obj
    [
      ("title", string "Helix - uPlot");
      ("width", int 600);
      ("height", int 400);
      ("scales", obj [ ("x", obj [ ("time", bool false) ]) ]);
      ( "series",
        array js
          [|
            obj [];
            obj [ ("label", string "One"); ("stroke", string "red") ];
            obj
              [
                ("label", string "Two");
                ("stroke", string "blue");
                ("show", bool false);
              ];
          |] );
    ]

let data1 =
  [|
    [| 1.; 2.; 3.; 4.; 5.; 6.; 7. |];
    [| 40.; 43.; 60.; 65.; 71.; 73.; 80. |];
    [| 18.; 24.; 37.; 55.; 55.; 60.; 63. |];
  |]

let data2 =
  [|
    [| 1.; 2.; 3.; 4.; 5.; 6.; 7. |];
    [| 10.; 23.; 10.; 95.; 71.; 93.; 20. |];
    [| 38.; 84.; 77.; 15.; 35.; 10.; 43. |];
  |]

let main () =
  let flag = Signal.make true in
  let uplot = ref None in
  let mount_uplot el = uplot := Some (Uplot.make ~options ~data:data1 el) in
  let adjust_data flag =
    match !uplot with
    | None -> Console.log "uplot not loaded"
    | Some uplot -> Uplot.set_data uplot (if flag then data1 else data2)
  in
  Signal.sub adjust_data flag;
  let open Html in
  div []
    [
      button
        [ on_click (fun _ -> Signal.update not flag) ]
        [ text "Toggle data" ];
      div [ Attr.on_mount mount_uplot ] [];
    ]

let () =
  match Dom.Document.get_element_by_id "root" with
  | Some root -> Helix.render root (main ())
  | None -> failwith "no #root found"
