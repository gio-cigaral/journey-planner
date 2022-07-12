module Action = {
  type t =
    | SetViewState(Mapbox.ViewState.t)
    | SetMapRef(option<React.ref<Js.Nullable.t<Dom.element>>>)
    | SetLoaded(bool)
    | SetDebouncedViewState(Mapbox.ViewState.t)
}

module State = {
  type t = {
    viewState: Mapbox.ViewState.t,
    ref: option<React.ref<Js.Nullable.t<Dom.element>>>,
    loaded: bool,
    debouncedViewState: Mapbox.ViewState.t
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

let initialState: State.t = {
  viewState: Mapbox.ViewState.make(),
  ref: None,
  loaded: false,
  debouncedViewState: Mapbox.ViewState.make()
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
  }
}

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  <Provider value={(state, dispatch)} context> 
    children 
  </Provider>
}
