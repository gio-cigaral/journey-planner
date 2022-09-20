open DataContext

let reducer = (state: State.t, action) => {
  switch action {
  | Action.SetSelection(selection) => 
  Js.log(selection)
  {
    ...state,
    selection: selection
  }
  | Action.SetFocus(focus) => {
    ...state,
    focus: focus
  }
  | Action.AddFocusListener(listener) => {
    ...state,
    focusListeners: Belt.Array.concat(state.focusListeners, [listener])
  }
  | Action.RemoveFocusListener(listener) => {
    ...state,
    focusListeners: Belt.Array.keep(state.focusListeners, x => x.id != listener.id)
  }
  | Action.SetSearchLocation(searchLocation) => {
    ...state,
    searchLocation: Some(searchLocation)
  }
  | Action.SetStops(stops) => {
    ...state,
    stops: Some(stops)
  }
  // | Action.SetCloseStops(closeStops) => {
  //   ...state,
  //   closeStops: Some(closeStops)
  // }
  | Action.SetPlan(plan) => {
    ...state,
    // plan: Some(plan),
    plan: plan,
    itinerary: 
      switch plan {
      | Some(p) => Some(p.plan.itineraries)
      | None => None
      }
  }
  | Action.SetActiveItinerary(activeItinerary) => {
    ...state,
    activeItinerary: activeItinerary
  }
  | Action.SetViewState(viewState) => {
    ...state,
    viewState: viewState
  }
  }
}

@react.component
let make = (~children) => {
  let (state, dispatch) = React.useReducer(reducer, initialState)

  <Provider value=(state, dispatch)>
    children
  </Provider>
}
