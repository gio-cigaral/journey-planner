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
  | Action.SetPosition(position) => {
      ...state,
      position: Some(position)
    }
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  // TODO: remove "active" styling for text input box
  <div id="search-container" className="flex m-2 relative">
    <form className="flex m-5 w-full h-14 rounded-lg bg-radiola-light-grey shadow-md">
      <div id="search-bar" className="w-full">
        <input 
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="Enter stop ID or address"
          value={state.search}
          onChange={(evt) => 
            dispatch(SetSearch((evt->ReactEvent.Form.target)["value"]))
          }
        />
      </div>

      <div id="search-submit">
        // <i className="" />
      </div>
    </form>

    <div id="icon-container" className="absolute top-0 bottom-0 mt-auto mb-auto h-16">
      <img className="w-auto h-full" src="/img/DYNAMIS_ColourSignet.svg" alt="Radiola Dynamis Icon" />
    </div>
  </div>
}
