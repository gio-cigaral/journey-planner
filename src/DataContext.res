// TODO: move MenuBar "content" type logic here
type selection = 
  | Tracker
  | Directions
  | Routes
  | None

module Action = {
  type t = 
    | SetSelection(selection)
    | SetStops(array<Common.Stop.t>)
    | SetPlan(array<Common.TripPlannerResponse.t>)  // TODO: change to option<> once connected to search bars
    | SetRoute(int)
    | SetViewState(Mapbox.ViewState.t)
}

module State = {
  type t = {
    selection: selection,
    stops: option<array<Common.Stop.t>>,
    plan: array<Common.TripPlannerResponse.t>,  // TODO: change to option<> once connected to search bars
    itinerary: option<array<Common.Itinerary.t>>,
    route: int,
    viewState: Mapbox.ViewState.t
  }
}

let initialState: State.t = {
  selection: None,
  stops: None,
  plan: [], // TODO: change to option<> once connected to search bars
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
