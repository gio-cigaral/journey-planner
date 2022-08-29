module State = {
  type t = {
    search: string,
    autocomplete: option<array<Common.GeocodeResponse.feature>>,
    position: option<Common.GeocodeResponse.feature>
  }
}

module Action = {
  type t =
    | SetSearch(string)
    | SetAutocomplete(array<Common.GeocodeResponse.feature>)
    | SetPosition(Common.GeocodeResponse.feature)
}

module Provider = {
  @react.component
  let make = (
    ~value,
    ~context,
    ~children
  ) => {
    React.createElement(React.Context.provider(context), {"value": value, "children": children})
  }
}

let reducer = (state: State.t, action) => {
  switch action {
  | Action.SetSearch(search) => {
      ...state,
      search: search
    }
  | Action.SetAutocomplete(autocomplete) => {
      ...state,
      autocomplete: Some(autocomplete)
    }
  | Action.SetPosition(position) => {
      ...state,
      position: Some(position)
    }
  }
}

let initialState: State.t = {
  search: "",
  autocomplete: None,
  position: None
}

let context: React.Context.t<(State.t, Action.t => unit)> = React.createContext((
  initialState,
  _ => (),
))

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  <Provider value={(state, dispatch)} context> 
    children 
  </Provider>
}
