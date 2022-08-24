@react.component
let make = () => {
  let (state, dispatch) = React.useContext(DirectionsMenuContext.context)
  let (_, dataDispatch) = React.useContext(DataContext.context)

  let originCallback = (a: Common.GeocodeResponse.t) => dispatch(SetOriginPosition(a.features[0]))
  let destinationCallback = (a: Common.GeocodeResponse.t) => dispatch(SetDestinationPosition(a.features[0]))
  let coordinatesErrorHandler = a => Js.log(a)
  let getCoordinates = (~parameters, ~callback) => Data.getCoordinates(~parameters, ~callback, ~errorHandler=coordinatesErrorHandler)

  let callbackPlan = a => dataDispatch(DataContext.Action.SetPlan([a]))
  let planErrorHandler = a => Js.log(a)
  let getPlanData = (~parameters) => Data.getPlan(~parameters, ~callback=callbackPlan, ~errorHandler=planErrorHandler)

  // * Geocode upon submit - auto accept closest possible match
  let handleSubmit = (evt: ReactEvent.Mouse.t) => {
    switch state.origin {
    | "" => ()
    | _ => {
        let originParameters = APIFunctions.getCoordinatesParameters(~location=state.origin)
        getCoordinates(~parameters=originParameters, ~callback=originCallback)
      }
    }

    switch state.destination {
    | "" => ()
    | _ => {
        let destinationParameters = APIFunctions.getCoordinatesParameters(~location=state.destination)
        getCoordinates(~parameters=destinationParameters, ~callback=destinationCallback)
      }
    }
  }

  React.useEffect2(() => {
    switch (state.originPosition, state.destinationPosition) {
    | (Some(origin), Some(destination)) => {
        let planParameters = 
          APIFunctions.getPlanParameters(
            ~origin=origin.center,
            ~destination=destination.center,
            ~time=Util.getCurrentTime(),
            ~date=Util.getCurrentDate()
          )        
        getPlanData(~parameters=planParameters)
      }
    | _ => ()
    }

    None
  }, (state.originPosition, state.destinationPosition))

  <div id="directions-container" className="h-full w-full p-5">
    <form className="flex flex-col justify-evenly h-4/5 bg-radiola-light-grey">
      <div id="origin-input-bar" className="relative w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="From"
          value={state.origin}
          onChange={(evt) => 
            dispatch(SetOrigin((evt->ReactEvent.Form.target)["value"]))
          }
        />
        // TODO: autocomplete div
        // <div id="autocomplete-items" className="absolute z-50 top-full left-0 right-0 border-2 border-b-0 border-t-0 border-gray-300">
        //   <div id="item" className="p-3 cursor-pointer bg-red-500 border-b-2 border-black"> </div>
        // </div>
      </div>

      <div id="destination-input-bar" className="w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="To"
          value={state.destination}
          onChange={(evt) =>
            dispatch(SetDestination((evt->ReactEvent.Form.target)["value"]))
          }
        />
      </div>

      <hr />

      <div id="submit-button" className="w-full h-12 border-2 border-gray-300 rounded-full">
        <button type_="button" className="w-full h-full" onClick={handleSubmit}>
          {React.string("Plan my journey")}
        </button>
      </div>
    </form>
  </div>
}
