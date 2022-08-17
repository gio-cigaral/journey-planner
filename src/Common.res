// * ref http://dev.opentripplanner.org/apidoc/2.0.0/json_ApiStopShort.html
module Stop = {
  type t = {
    id: string,
    code: option<string>,
    name: string,
    lat: float,
    lon: float
  }
}

module Place = {
  type t = {
    name: string,
    lat: float,
    lon: float,
    stopId: option<string>,
    stopCode: option<string>,
    departure: option<int>,
    arrival: option<int>,
    stopIndex: option<int>,
    stopSequence: option<int>
  }
}

module EncodedPolylineBean = {
  type t = {
    points: option<string>,
    length: int
  }
}

// module WalkStep = {
//   type t = {

//   }
// }

module Leg = {
  // TODO: Implement steps: ApiWalkStep
  // http://dev.opentripplanner.org/apidoc/2.0.0/json_ApiWalkStep.html
  type t = {
    startTime: option<int>,
    endTime: option<int>,
    distance: option<float>,
    mode: option<string>,
    transitLeg: option<bool>,
    route: option<string>,
    agencyName: option<string>,
    agencyUrl: option<string>,
    routeColor: option<string>,
    routeType: option<int>,
    routeTextColor: option<string>,
    headsign: option<string>,
    routeId: option<string>,
    agencyId: option<string>,
    serviceDate: option<string>,
    from: option<Place.t>,
    to: option<Place.t>,
    intermediateStops: option<Place.t>,
    legGeometry: option<EncodedPolylineBean.t>,
    // steps: option<array<walkStep>>,
    routeShortName: option<string>,
    routeLongName: option<string>,
    duration: float
  }

}

module Itinerary = {
  type t = {
    duration: option<int>,
    startTime: option<int>,
    endTime: option<int>,
    walkTime: int,
    transitTime: int,
    waitingTime: int,
    walkDistance: option<float>,
    transfers: option<int>,
    legs: option<array<Leg.t>>
  }
}

// * ref http://dev.opentripplanner.org/apidoc/2.0.0/json_TripPlannerResponse.html
module TripPlannerResponse = {
  type plan = {
    date: int,
    from: Place.t,
    to: Place.t,
    itineraries: array<Itinerary.t>
  }

  // ? Possibly change 'message' type into custom type to allow for pattern matching
  // ? see http://dev.opentripplanner.org/apidoc/2.0.0/json_Message.html
  type error = {
    id: int,
    msg: option<string>,
    message: option<string>,
    missing: option<array<string>>
  }

  
  type t = {
    plan: plan,
    previousPageCursor: string,
    nextPageCursor: string,
    error: option<error>
  }
}