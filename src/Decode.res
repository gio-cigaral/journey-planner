module Stop = {
  let decode = (json): Common.Stop.t => {
    open Json.Decode
    {
      id: json |> field("id", Json.Decode.string),
      code: json |> optional(field("code", Json.Decode.string)),
      name: json |> field("name", Json.Decode.string),
      lat: json |> field("lat", Json.Decode.float),
      lon: json |> field("lon", Json.Decode.float),
    }
  }
}

let toStops = Json.Decode.array(Stop.decode)