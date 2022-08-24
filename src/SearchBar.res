module State = {
  type t = {
    search: string,
    position: option<Common.GeocodeResponse.feature>
  }
}

module Action = {
  type t =
    | SetSearch(string)
    | SetPosition(Common.GeocodeResponse.feature)
}

let initialState: State.t = {
  search: "",
  position: None
}

let reducer = (state: State.t, action) => {
  switch action {
  | Action.SetSearch(search) => {
      ...state,
      search: search
    }
  | Action.SetPosition(position) => 
    Js.log("setting search position")
    Js.log(position.placeName)
    {
      ...state,
      position: Some(position)
    }
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)
  let (_, dataDispatch) = React.useContext(DataContext.context)

  let searchCallback = (a: Common.GeocodeResponse.t) => dispatch(SetPosition(a.features[0]))
  let searchErrorHandler = a => Js.log(a)
  let getCoordinates = (~parameters, ~callback) => Data.getCoordinates(~parameters, ~callback, ~errorHandler=searchErrorHandler)

  let handleSubmit = (_: ReactEvent.Mouse.t) => {
    Js.log("submit search")
    switch state.search {
    | "" => ()
    | _ => {
        let parameters = APIFunctions.getCoordinatesParameters(~location=state.search)
        getCoordinates(~parameters, ~callback=searchCallback)
      }
    }
  }

  React.useEffect1(() => {
    switch state.position {
    | Some(position) => {
        Js.log("HELLO - " ++ position.placeName)
        dataDispatch(DataContext.Action.SetSearch(position))
      }
    | _ => ()
    }
    None
  }, [state.position])

  // TODO: remove "active" styling for text input box
  <div id="search-container" className="flex m-2 relative">
    <form className="flex flex-row m-5 w-full h-14 rounded-lg bg-radiola-light-grey shadow-md">
      <div id="search-bar" className="w-full">
        <input 
          type_="text"
          className="w-full h-full pl-12 bg-inherit" 
          placeholder="Enter stop ID or address"
          value={state.search}
          onChange={(evt) => 
            dispatch(SetSearch((evt->ReactEvent.Form.target)["value"]))
          }
        />
      </div>

      <div 
        id="search-submit" 
        className="flex flex-col justify-center w-12 text-center text-black/75 cursor-pointer"
        onClick={handleSubmit}
      >
        <i className="fe fe-search text-3xl" />
      </div>
    </form>

    <div id="icon-container" className="absolute top-0 bottom-0 mt-auto mb-auto h-16">
      <img className="w-auto h-full" src="/img/DYNAMIS_ColourSignet.svg" alt="Radiola Dynamis Icon" />
    </div>
  </div>
}
