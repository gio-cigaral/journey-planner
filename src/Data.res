let genericDataRetrieval = (~parameters="", ~callback, ~errorHandler, ~apiFunction, ~decoder, ()) => {
  open Js.Promise
  apiFunction(parameters)
  |> then_(Fetch.Response.json)
  |> then_(json => decoder(json)->resolve)
  |> then_(data => callback(data) |> resolve)
  |> catch(_err => {
    errorHandler(_err)
    resolve()
  })
  |> ignore
}

exception MyException(string)

let multiDataRetrieval = (~parameterList=[], ~callback, ~errorHandler, ~apiFunction, ~decoder, ()) => {
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
    errorHandler(_err)
    Js.Promise.resolve()
  })
  |> ignore
}

let getStops = (~parameters, ~callback, ~errorHandler) =>
  genericDataRetrieval(
    ~parameters,
    ~apiFunction=APIFunctions.getStops,
    ~decoder=Decode.toStops,
    ~callback,
    ~errorHandler, ()
  )

let getPlan = (~parameters, ~callback, ~errorHandler) =>
  genericDataRetrieval(
    ~parameters,
    ~apiFunction=APIFunctions.getPlan,
    ~decoder=Decode.toPlan,
    ~callback,
    ~errorHandler, ()
  )

let getCoordinates = (~parameters, ~callback, ~errorHandler) =>
  genericDataRetrieval(
    ~parameters,
    ~apiFunction=APIFunctions.getCoordinates,
    ~decoder=Decode.toGeocode,
    ~callback,
    ~errorHandler, ()
  )
