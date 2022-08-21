// TODO: move MenuBar "content" type logic here
type selection = 
  | Tracker
  | Directions
  | Routes
  | Empty

module Action = {
  type t = 
    | SetSelection(string)
    | SetStops(array<Common.Stop.t>)
    | SetPlan(array<Common.TripPlannerResponse.t>)  // TODO: change to option<> once connected to search bars
    | SetActiveItinerary(int)
    | SetViewState(Mapbox.ViewState.t)
}

module State = {
  type t = {
    selection: selection,
    stops: option<array<Common.Stop.t>>,
    plan: array<Common.TripPlannerResponse.t>,  // TODO: change to option<> once connected to search bars
    itinerary: option<array<Common.Itinerary.t>>,
    activeItinerary: int,
    viewState: Mapbox.ViewState.t
  }
}

let initialState: State.t = {
  selection: Empty,
  stops: None,
  plan: [], // TODO: change to option<> once connected to search bars
  itinerary: None,
  activeItinerary: 0,
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
