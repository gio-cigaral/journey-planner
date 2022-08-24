open DataContext

let reducer = (state: State.t, action) => {
  switch action {
  | Action.SetSelection(selection) => {
    ...state,
    selection: {
      switch selection {
      | "tracker" => 
        Js.log("displaying tracker")
        Tracker
      | "directions" => 
        Js.log("displaying directions")
        Directions
      | "routes" => 
        Js.log("displaying routes")
        Routes
      | _ => 
        Js.log("displaying empty")
        Empty
      }
    }
  }
  | Action.SetSearch(search) => {
    ...state,
    search: Some(search)
  }
  | Action.SetStops(stops) => {
    ...state,
    stops: Some(stops)
  }
  | Action.SetPlan(plan) => {
    ...state,
    plan: plan,
    itinerary: Some(plan[0].plan.itineraries)
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
