@react.component
let make = () => {
  let originBarRef = React.useRef(Js.Nullable.null)
  let destinationBarRef = React.useRef(Js.Nullable.null)
  let (state, dispatch) = React.useContext(DirectionsMenuContext.context)
  let (dataState, dataDispatch) = React.useContext(DataContext.context)

  // * ------- COMPONENT FOCUS LISTENERS ------- 
  let originHandleInsideClick = (_: ReactEvent.Mouse.t) => {
    Js.log("inside - origin bar")
    dataDispatch(DataContext.Action.SetFocus(DataContext.Focus.DirectionsMenu("origin")))
  }

  let destinationHandleInsideClieck = (_: ReactEvent.Mouse.t) => {
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

  // * Add search bar components to global focus listener
  React.useEffect0(() => {
    dataDispatch(DataContext.Action.AddFocusListener(originListener))
    dataDispatch(DataContext.Action.AddFocusListener(destinationListener))

    let cleanup = () => {
      dataDispatch(DataContext.Action.RemoveFocusListener(originListener))
      dataDispatch(DataContext.Action.RemoveFocusListener(destinationListener))
    }

    Some(cleanup)
  })

  // * ------- COORDINATES API CALL  ------- 
  let originCallback = (a: Common.GeocodeResponse.t) => dispatch(SetOriginPosition(a.features[0]))
  let destinationCallback = (a: Common.GeocodeResponse.t) => dispatch(SetDestinationPosition(a.features[0]))
  let coordinatesErrorHandler = a => Js.log(a)
  let getCoordinates = (~parameters, ~callback) => Data.getCoordinates(~parameters, ~callback, ~errorHandler=coordinatesErrorHandler)

  // * ------- PLAN API CALL  ------- 
  let callbackPlan = a => {
    Js.log("plan found")
    Js.log(a)
    dataDispatch(DataContext.Action.SetPlan([a]))
  }
  let planErrorHandler = a => Js.log(a)
  let getPlanData = (~parameters) => Data.getPlan(~parameters, ~callback=callbackPlan, ~errorHandler=planErrorHandler)

  // * Geocode upon submit - auto accept closest possible match
  let handleSubmit = (_: ReactEvent.Mouse.t) => {
    switch (state.origin, state.originPosition) {
    | ("", _) => ()
    | (_, Some(_)) => ()
    | (_, None) => {
        let originParameters = APIFunctions.getCoordinatesParameters(~location=state.origin)
        getCoordinates(~parameters=originParameters, ~callback=originCallback)
      }
    }

    switch (state.destination, state.destinationPosition) {
    | ("", _) => ()
    | (_, Some(_)) => ()
    | (_, None) => {
        let destinationParameters = APIFunctions.getCoordinatesParameters(~location=state.destination)
        getCoordinates(~parameters=destinationParameters, ~callback=destinationCallback)
      }
    }

    // Search for itineraries based on origin and destination positions
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
  }

  // * ------- HANDLE ORIGIN AUTOCOMPLETE ------- 
  
  let handleOriginChange = (evt: ReactEvent.Form.t) => {
    let search = (evt->ReactEvent.Form.target)["value"]
    let parameters = APIFunctions.getCoordinatesParameters(~location=search)
    let callback = (a: Common.GeocodeResponse.t) => dispatch(DirectionsMenuContext.Action.SetOriginAutocomplete(a.features))

    dispatch(SetOrigin(search))
    getCoordinates(~parameters, ~callback)
  }

  let handleOriginChosenSuggestion = (item: Common.GeocodeResponse.feature) => {
    Js.log("chosen origin - ")
    Js.log(item)
    dispatch(DirectionsMenuContext.Action.SetOrigin(item.placeName))
    dispatch(DirectionsMenuContext.Action.SetOriginPosition(item))
  }

  let originAutocompleteElements = 
    switch state.originAutocomplete {
    | Some(autocomplete) => {
        autocomplete
        ->Belt.Array.mapWithIndex((index, item) => {
          <div 
            key={"origin-suggestion-" ++ Belt.Int.toString(index)} 
            className="pl-3 pr-3 pt-1 pb-1 h-8 cursor-pointer bg-gray-100 border-b-2 border-gray-300 truncate hover:bg-gray-300"
            onClick={(_) => handleOriginChosenSuggestion(item)}
          >
            {React.string(item.placeName)}
          </div>
        })
      }
    | None => [React.null]
    }

  let activeOriginAutocomplete = 
    switch dataState.focus {
    | DirectionsMenu(bar) => {
        switch bar {
        | "origin" => "block"
        | _ => "hidden border-0"
        }
      }
    | _ => "hidden border-0"
    }

  // * ------- HANDLE DESTINATION AUTOCOMPLETE ------- 

  let handleDestinationChange = (evt: ReactEvent.Form.t) => {
    let search = (evt->ReactEvent.Form.target)["value"]
    let parameters = APIFunctions.getCoordinatesParameters(~location=search)
    let callback = (a: Common.GeocodeResponse.t) => dispatch(DirectionsMenuContext.Action.SetDestinationAutocomplete(a.features))

    dispatch(SetDestination(search))
    getCoordinates(~parameters, ~callback)
  }

  let handleDestinationChosenSuggestion = (item: Common.GeocodeResponse.feature) => {
    Js.log("chosen destination - ")
    Js.log(item)
    dispatch(DirectionsMenuContext.Action.SetDestination(item.placeName))
    dispatch(DirectionsMenuContext.Action.SetDestinationPosition(item))
  }

  let destinationAutocompleteElements = 
    switch state.destinationAutocomplete {
    | Some(autocomplete) => {
        autocomplete
        ->Belt.Array.mapWithIndex((index, item) => {
          <div 
            key={"destination-suggestion-" ++ Belt.Int.toString(index)} 
            className="pl-3 pr-3 pt-1 pb-1 h-8 cursor-pointer bg-gray-100 border-b-2 border-gray-300 truncate hover:bg-gray-300"
            onClick={(_) => handleDestinationChosenSuggestion(item)}
          >
            {React.string(item.placeName)}
          </div>
        })
      }
    | None => [React.null]
    }

  let activeDestinationAutocomplete = 
    switch dataState.focus {
    | DirectionsMenu(bar) => {
        switch bar {
        | "destination" => "block"
        | _ => "hidden border-0"
        }
      }
    | _ => "hidden border-0"
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
          onChange={handleOriginChange}
        />

        <div id="origin-autocomplete-items" className=`${activeOriginAutocomplete} absolute z-40 top-full left-0 right-0 border-2 border-b-0 border-gray-300`>
          {
            React.array(originAutocompleteElements)
          }
        </div>
      </div>

      <div id="destination-input-bar" className="relative w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          ref={ReactDOM.Ref.domRef(destinationBarRef)}
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="To"
          value={state.destination}
          onChange={handleDestinationChange}
        />

        <div id="destination-autocomplete-items" className=`${activeDestinationAutocomplete} absolute z-40 top-full left-0 right-0 border-2 border-b-0 border-gray-300`>
          {
            React.array(destinationAutocompleteElements)
          }
        </div>
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
