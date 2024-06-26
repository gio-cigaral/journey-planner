type autocomplete = 
  | Origin
  | Destination
  | None

module State = {
  type t = {
    displayPlan: bool,
    origin: string,
    originPosition: option<Common.GeocodeResponse.feature>,
    originAutocomplete: option<array<Common.GeocodeResponse.feature>>,
    destination: string,
    destinationPosition: option<Common.GeocodeResponse.feature>,
    destinationAutocomplete: option<array<Common.GeocodeResponse.feature>>,
  }
}

module Action = {
  type t =
    | SetOrigin(string)
    | SetOriginPosition(Common.GeocodeResponse.feature)
    | SetOriginAutocomplete(array<Common.GeocodeResponse.feature>)
    | SetDestination(string)
    | SetDestinationPosition(Common.GeocodeResponse.feature)
    | SetDestinationAutocomplete(array<Common.GeocodeResponse.feature>)
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
  | Action.SetOrigin(origin) => {
      ...state,
      origin: origin
    }
  | Action.SetOriginPosition(originPosition) => {
      ...state,
      originPosition: Some(originPosition)
    }
  | Action.SetOriginAutocomplete(autocomplete) => {
      ...state,
      originAutocomplete: Some(autocomplete)
    }
  | Action.SetDestination(destination) => {
      ...state,
      destination: destination
    }
  | Action.SetDestinationPosition(destinationPosition) => {
      ...state,
      destinationPosition: Some(destinationPosition)
    }
  | Action.SetDestinationAutocomplete(autocomplete) => {
      ...state,
      destinationAutocomplete: Some(autocomplete)
    }
  }
}

let initialState: State.t = {
  displayPlan: false,
  origin: "",
  originPosition: None,
  originAutocomplete: None,
  destination: "",
  destinationPosition: None,
  destinationAutocomplete: None
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
