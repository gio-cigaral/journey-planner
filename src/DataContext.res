module Selection = {
  type directionsSubMenu =
    | Input
    | Details

  type t = 
    | Tracker
    | Directions(directionsSubMenu)
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
    // | SetCloseStops(array<Common.Stop.t>)
    | SetPlan(option<Common.TripPlannerResponse.t>)
    | SetActiveItinerary(int)
    | SetViewState(Mapbox.ViewState.t)
}

module State = {
  type t = {
    selection: Selection.t,
    focus: Focus.t,
    focusListeners: array<FocusListener.t>,
    searchLocation: option<SearchLocation.t>,
    stops: option<array<Common.Stop.t>>,
    // closeStops: option<array<Common.Stop.t>>,
    plan: option<Common.TripPlannerResponse.t>,
    itinerary: option<array<Common.Itinerary.t>>,
    activeItinerary: int,
    viewState: Mapbox.ViewState.t
  }
}

let initialState: State.t = {
  selection: Directions(Input),
  focus: Empty,
  focusListeners: [],
  searchLocation: None,
  stops: None,
  // closeStops: None,
  plan: None,
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
