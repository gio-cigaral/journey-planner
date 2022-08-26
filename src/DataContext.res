type selection = 
  | Tracker
  | Directions
  | Routes
  | Empty

module Focus = {
  type t =
    | Search
    | Map
    | Empty
}

module Action = {
  type t = 
    | SetSelection(string)
    | SetFocus(Focus.t)
    | SetSearchLocation(Common.GeocodeResponse.feature)
    | SetStops(array<Common.Stop.t>)
    | SetPlan(array<Common.TripPlannerResponse.t>)  // TODO: change to option<> once connected to search bars
    | SetActiveItinerary(int)
    | SetViewState(Mapbox.ViewState.t)
}

module State = {
  type t = {
    selection: selection,
    focus: Focus.t,
    searchLocation: option<Common.GeocodeResponse.feature>,
    stops: option<array<Common.Stop.t>>,
    plan: array<Common.TripPlannerResponse.t>,  // TODO: change to option<> once connected to search bars
    itinerary: option<array<Common.Itinerary.t>>,
    activeItinerary: int,
    viewState: Mapbox.ViewState.t
  }
}

let initialState: State.t = {
  selection: Empty,
  focus: Empty,
  searchLocation: None,
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
