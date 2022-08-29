@react.component
let make = () => {
  let originBarRef = React.useRef(Js.Nullable.null)
  let destinationBarRef = React.useRef(Js.Nullable.null)
  let (state, dispatch) = React.useContext(DirectionsMenuContext.context)
  let (_, dataDispatch) = React.useContext(DataContext.context)

  let originCallback = (a: Common.GeocodeResponse.t) => dispatch(SetOriginPosition(a.features[0]))
  let destinationCallback = (a: Common.GeocodeResponse.t) => dispatch(SetDestinationPosition(a.features[0]))
  let coordinatesErrorHandler = a => Js.log(a)
  let getCoordinates = (~parameters, ~callback) => Data.getCoordinates(~parameters, ~callback, ~errorHandler=coordinatesErrorHandler)

  let callbackPlan = a => dataDispatch(DataContext.Action.SetPlan([a]))
  let planErrorHandler = a => Js.log(a)
  let getPlanData = (~parameters) => Data.getPlan(~parameters, ~callback=callbackPlan, ~errorHandler=planErrorHandler)

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

  let originHandleInsideClick = (evt: ReactEvent.Mouse.t) => {
    Js.log("inside - origin bar")
    dataDispatch(DataContext.Action.SetFocus(DataContext.Focus.DirectionsMenu("origin")))
  }

  let destinationHandleInsideClieck = (evt: ReactEvent.Mouse.t) => {
    Js.log("inside - destination bar")
    dataDispatch(DataContext.Action.SetFocus(DataContext.Focus.DirectionsMenu("destination")))
  }

  let originListener = DataContext.FocusListener.make(
    ~id="origin-input-bar",
    ~ref=originBarRef,
    ~handleInsideClick=originHandleInsideClick
  )

  let destinationListener = DataContext.FocusListener.make(
    ~id="destination-input-bar",
    ~ref=destinationBarRef,
    ~handleInsideClick=destinationHandleInsideClieck
  )

  React.useEffect0(() => {
    dataDispatch(DataContext.Action.AddFocusListener(originListener))
    dataDispatch(DataContext.Action.AddFocusListener(destinationListener))

    let cleanup = () => {
      dataDispatch(DataContext.Action.RemoveFocusListener(originListener))
      dataDispatch(DataContext.Action.RemoveFocusListener(destinationListener))
    }

    Some(cleanup)
  })

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

  <div id="directions-container" className="h-full w-full p-5">
    <form className="flex flex-col justify-evenly h-4/5 bg-radiola-light-grey">
      <div id="origin-input-bar" className="relative w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          ref={ReactDOM.Ref.domRef(originBarRef)}
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="From"
          value={state.origin}
          onChange={(evt) => 
            dispatch(SetOrigin((evt->ReactEvent.Form.target)["value"]))
          }
        />
        <div id="autocomplete-items" className=`block h-6 absolute z-40 top-full left-0 right-0 border-2 border-b-0 border-gray-300`>
        // {
        //   React.array(autocompleteElements)
        // }

        <div 
          // key={"search-suggestion-" ++ Belt.Int.toString(index)} 
          className="p-3 cursor-pointer bg-radiola-light-grey border-b-2 border-gray-300 truncate hover:bg-gray-300"
          // onClick={(_) => handleChosenSuggestion(item)}
        >
          {React.string("Tauranga Hospital, Tauranga, Bay of Plenty")}
        </div>
      </div>
      </div>

      

      <div id="destination-input-bar" className="w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          ref={ReactDOM.Ref.domRef(destinationBarRef)}
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
