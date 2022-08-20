@react.component
let make = () => {
  // let (state, dispatch) = React.useReducer(reducer, initialState)
  let (state, dispatch) = React.useContext(DirectionsMenuContext.context)
  let (_, dataDispatch) = React.useContext(DataContext.context)

  let getParameters = (~location: string) => {
    let search = `${location}.json?country=nz&proximity=ip&types=place,postcode,address,poi&access_token=${Map.mapboxAccessToken}`
    Js.Global.encodeURI(search)
  }

  // * Geocode upon submit - auto accept closest possible match
  let originCallback = (a: Common.GeocodeResponse.t) => dispatch(SetOriginPosition(a.features[0]))
  let destinationCallback = (a: Common.GeocodeResponse.t) => dispatch(SetDestinationPosition(a.features[0]))

  let errorHandler = a => Js.log(a)

  let getCoordinates = (~parameters, ~callback) => Data.getCoordinates(~parameters, ~callback, ~errorHandler)

  let callbackPlan = a => dataDispatch(DataContext.Action.SetPlan([a]))
  let getPlanData = () => Data.getPlan(~callback=callbackPlan, ~errorHandler)

  let handleClick = (evt: ReactEvent.Mouse.t) => {
    Js.log(state.origin)
    Js.log(state.destination)

    getCoordinates(~parameters=getParameters(~location=state.origin), ~callback=originCallback)
    getCoordinates(~parameters=getParameters(~location=state.destination), ~callback=destinationCallback)
  }

  React.useEffect2(() => {
    if (Js.Option.isSome(state.originPosition) && Js.Option.isSome(state.destinationPosition)) {
      Js.log("test")
      getPlanData()
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
        <button type_="button" className="w-full h-full" onClick={handleClick}>
          {React.string("Plan my journey")}
        </button>
      </div>
    </form>
  </div>
}