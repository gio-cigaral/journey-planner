module Action = {
  type t =
    | SetViewState(Mapbox.ViewState.t)
    | SetMapRef(option<React.ref<Js.Nullable.t<Dom.element>>>)
    | SetLoaded(bool)
    | SetDebouncedViewState(Mapbox.ViewState.t)
    | AddInteractiveLayerId(string)
    | RemoveInteractiveLayerId(string)
}

module State = {
  type t = {
    viewState: Mapbox.ViewState.t,
    ref: option<React.ref<Js.Nullable.t<Dom.element>>>,
    loaded: bool,
    debouncedViewState: Mapbox.ViewState.t,
    interactiveLayerIds: array<string>
  }
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

// Set initial view state of Map to center over Tauranga
let initialViewState: Mapbox.ViewState.t = 
  Mapbox.ViewState.make(
    ~latitude=-37.68708, 
    ~longitude=176.16702, 
    ~zoom=0, 
    ~bearing=0.0, 
    ~pitch=0.0, 
    ()
  )

let initialState: State.t = {
  viewState: initialViewState, //Mapbox.ViewState.make()
  ref: None,
  loaded: false,
  debouncedViewState: Mapbox.ViewState.make(),
  interactiveLayerIds: []
}

let context: React.Context.t<(State.t, Action.t => unit)> = React.createContext((
  initialState,
  _ => (),
))

let reducer = (state: State.t, action) => {
  switch action {
  | Action.SetViewState(viewState) => {
      ...state,
      viewState: viewState
    }
  | Action.SetMapRef(mapRef) => {
      ...state,
      ref: mapRef
    }
  | Action.SetLoaded(loaded) => {
      ...state,
      loaded: loaded
    }
  | Action.SetDebouncedViewState(debouncedViewState) => {
      ...state,
      debouncedViewState: debouncedViewState
    }
  | Action.AddInteractiveLayerId(interactiveLayerId) => 
    Js.log("adding ID: " ++ interactiveLayerId)
    {
      ...state,
      interactiveLayerIds: Belt.Array.concat(state.interactiveLayerIds, [interactiveLayerId])
    }
  | Action.RemoveInteractiveLayerId(interactiveLayerId) => 
    Js.log("removing ID: " ++ interactiveLayerId)
    {
      ...state,
      interactiveLayerIds: Belt.Array.keep(state.interactiveLayerIds, id => id != interactiveLayerId)
    }
  }
}

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  <Provider value={(state, dispatch)} context> 
    children 
  </Provider>
}
