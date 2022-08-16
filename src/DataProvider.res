open DataContext

let reducer = (state: State.t, action) => {
  switch action {
  | Action.SetSelection(selection) => {
    ...state,
    selection: selection
  }
  | Action.SetPlan(plan) => {
    ...state,
    plan: plan,
    itinerary: Some(plan[0].plan.itineraries)
  }
  | Action.SetRoute(route) => {
    ...state,
    route: route
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
