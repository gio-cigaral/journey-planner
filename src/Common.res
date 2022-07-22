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

// * ref http://dev.opentripplanner.org/apidoc/2.0.0/json_TripPlannerResponse.html
module TripPlannerResponse = {
  type place = {
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

  type encodedPolylineBean = {
    points: option<string>,
    length: int
  }

  // type walkStep = {

  // }

  // TODO: Implement steps: ApiWalkStep
  // http://dev.opentripplanner.org/apidoc/2.0.0/json_ApiWalkStep.html
  type leg = {
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
    from: option<place>,
    to: option<place>,
    intermediateStops: option<place>,
    legGeometry: option<encodedPolylineBean>,
    // steps: option<array<walkStep>>,
    routeShortName: option<string>,
    routeLongName: option<string>,
    duration: float
  }

  type itinerary = {
    duration: option<int>,
    startTime: option<int>,
    endTime: option<int>,
    walkTime: int,
    transitTime: int,
    waitingTime: int,
    walkDistance: option<float>,
    transfers: option<int>,
    legs: option<array<leg>>
  }

  type plan = {
    date: int,
    from: place,
    to: place,
    itineraries: array<itinerary>
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