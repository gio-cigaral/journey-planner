module Selection = {
  type t = 
    | Tracker
    | Directions
    | Routes
    | Empty
}

module Focus = {
  type t =
    | Search
    | MenuBar
    | DirectionsMenu(string)
    | Map
    | Empty
}

module FocusListener = {
  type t = {
    id: string,
    ref: React.ref<Js.Nullable.t<Dom.element>>,
    handleInsideClick: (ReactEvent.Mouse.t => unit)
  }

  @obj
  external make: (
    ~id: string,
    ~ref: React.ref<Js.Nullable.t<Dom.element>>,
    ~handleInsideClick: (ReactEvent.Mouse.t => unit)
  ) => t = ""
}

module SearchLocation = {
  type t = {
    name: string,
    position: Common.GeocodeResponse.feature
  }

  @obj
  external make: (
    ~name: string,
    ~position: Common.GeocodeResponse.feature
  ) => t = ""
}

module Action = {
  type t = 
    | SetSelection(Selection.t)
    | SetFocus(Focus.t)
    | AddFocusListener(FocusListener.t)
    | RemoveFocusListener(FocusListener.t)
    | SetSearchLocation(SearchLocation.t)
    | SetStops(array<Common.Stop.t>)
    | SetPlan(array<Common.TripPlannerResponse.t>)  // TODO: change to option<> once connected to search bars
    | SetActiveItinerary(int)
    | SetViewState(Mapbox.ViewState.t)
}

module State = {
  type t = {
    selection: Selection.t,
    focus: Focus.t,
    focusListeners: array<FocusListener.t>,  // TODO: double check array is the appropriate collection type here (i.e. is it mutable?)
    searchLocation: option<SearchLocation.t>,
    stops: option<array<Common.Stop.t>>,
    plan: array<Common.TripPlannerResponse.t>,  // TODO: change to option<> once connected to search bars
    itinerary: option<array<Common.Itinerary.t>>,
    activeItinerary: int,
    viewState: Mapbox.ViewState.t
  }
}

let initialState: State.t = {
  selection: Directions,
  focus: Empty,
  focusListeners: [],
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
