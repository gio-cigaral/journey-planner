// TODO: move MenuBar "content" type logic here
type selection = 
  | Tracker
  | Directions
  | Routes
  | None

module Action = {
  type t = 
    | SetSelection(selection)
    | SetPlan(array<Common.TripPlannerResponse.t>)
    | SetRoute(int)
    | SetViewState(Mapbox.ViewState.t)
}

module State = {
  type t = {
    selection: selection,
    plan: array<Common.TripPlannerResponse.t>,
    itinerary: option<array<Common.Itinerary.t>>,
    route: int,
    viewState: Mapbox.ViewState.t
  }
}

let initialState: State.t = {
  selection: None,
  plan: [],
  itinerary: None,
  route: 1,
  viewState: Mapbox.ViewState.make()
}

let context: React.Context.t<(State.t, Action.t => unit)> = React.createContext((
  initialState,
  _ => (),
))

module Provider = {
  let makeProps = (~value, ~children, ()) => {"value": value, "children": children}
  let make = React.Context.provider(context)
}
