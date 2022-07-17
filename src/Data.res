let genericDataRetrieval = (~parameters="", ~callback, ~errorHandle, ~apiFunction, ~decoder, ()) => {
  open Js.Promise
  apiFunction(parameters)
  |> then_(Fetch.Response.json)
  |> then_(json => decoder(json)->resolve)
  |> then_(data => callback(data) |> resolve)
  |> catch(_err => {
    errorHandle(_err)
    resolve()
  })
  |> ignore
}

exception MyException(string)

let multiDataRetrieval = (~parameterList=[], ~callback, ~errorHandle, ~apiFunction, ~decoder, ()) => {
  parameterList
  -> Belt.Array.map(parameters => {
    apiFunction(parameters)
    |> Js.Promise.then_(Fetch.Response.json)
    |> Js.Promise.then_(json => decoder(json)->Ok->Js.Promise.resolve)
    |> Js.Promise.catch(_err => {
      Error("Failed")->Js.Promise.resolve
    })
  })
  -> Js.Promise.all
  |> Js.Promise.then_(results => callback(results) |> Js.Promise.resolve)
  |> Js.Promise.catch(_err => {
    errorHandle(_err)
    Js.Promise.resolve()
  })
  |> ignore
}

let getStops = (~callback, ~errorHandle) =>
  genericDataRetrieval(
    ~apiFunction=APIFunctions.getStops,
    ~decoder=Decode.toStops,
    ~callback,
    ~errorHandle, ()
  )
