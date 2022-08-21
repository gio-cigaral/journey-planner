module Stop = {
  let decode = (json): Common.Stop.t => {
    open Json.Decode
    {
      id: json |> field("id", Json.Decode.string),
      code: json |> optional(field("code", Json.Decode.string)),
      name: json |> field("name", Json.Decode.string),
      lat: json |> field("lat", Json.Decode.float),
      lon: json |> field("lon", Json.Decode.float)
    }
  }
}

// TODO: consider renaming
module Plan = {
  let placeInfo = (json): Common.Place.t => {
    open Json.Decode
    {
      name: json |> field("name", Json.Decode.string),
      lat: json |> field("lat", Json.Decode.float),
      lon: json |> field("lon", Json.Decode.float),
      stopId: json |> optional(field("stopId", Json.Decode.string)),
      stopCode: json |> optional(field("stopCode", Json.Decode.string)),
      departure: json |> optional(field("departure", Json.Decode.int)),
      arrival: json |> optional(field("arrival", Json.Decode.int)),
      stopIndex: json |> optional(field("stopIndex", Json.Decode.int)),
      stopSequence: json |> optional(field("stopSequence", Json.Decode.int))
    }
  }

  let encodedPolylineBeanInfo = (json): Common.EncodedPolylineBean.t => {
    open Json.Decode
    {
      points: json |> optional(field("points", Json.Decode.string)),
      length: json |> field("length", Json.Decode.int)
    }
  }

  let legInfo = (json): Common.Leg.t => {
    open Json.Decode
    {
      startTime: json |> optional(field("startTime", Json.Decode.int)),
      endTime: json |> optional(field("endTime", Json.Decode.int)),
      distance: json |> optional(field("distance", Json.Decode.float)),
      mode: json |> optional(field("mode", Json.Decode.string)),
      transitLeg: json |> optional(field("transitLeg", Json.Decode.bool)),
      route: json |> optional(field("route", Json.Decode.string)),
      agencyName: json |> optional(field("agencyName", Json.Decode.string)),
      agencyUrl: json |> optional(field("agencyUrl", Json.Decode.string)),
      routeColor: json |> optional(field("routeColor", Json.Decode.string)),
      routeType: json |> optional(field("routeType", Json.Decode.int)),
      routeTextColor: json |> optional(field("routeTextColor", Json.Decode.string)),
      headsign: json |> optional(field("headsign", Json.Decode.string)),
      routeId: json |> optional(field("routeId", Json.Decode.string)),
      agencyId: json |> optional(field("agencyId", Json.Decode.string)),
      serviceDate: json |> optional(field("serviceDate", Json.Decode.string)),
      from: json |> optional(field("from", placeInfo)),
      to: json |> optional(field("to", placeInfo)),
      intermediateStops: json |> optional(field("intermediateStops", placeInfo)),
      legGeometry: json |> optional(field("legGeometry", encodedPolylineBeanInfo)),
      // steps: json |> optional(field("steps", Json.Decode.array(walkStepInfo))),
      routeShortName: json |> optional(field("routeShortName", Json.Decode.string)),
      routeLongName: json |> optional(field("routeLongName", Json.Decode.string)),
      duration: json |> field("duration", Json.Decode.float)
    }
  }

  let itineraryInfo = (json): Common.Itinerary.t => {
    open Json.Decode
    {
      duration: json |> optional(field("duration", Json.Decode.int)),
      startTime: json |> optional(field("startTime", Json.Decode.int)),
      endTime: json |> optional(field("endTime", Json.Decode.int)),
      walkTime: json |> field("walkTime", Json.Decode.int),
      transitTime: json |> field("transitTime", Json.Decode.int),
      waitingTime: json |> field("waitingTime", Json.Decode.int),
      walkDistance: json |> optional(field("walkDistance", Json.Decode.float)),
      transfers: json |> optional(field("transfers", Json.Decode.int)),
      legs: json |> optional(field("legs", Json.Decode.array(legInfo)))
    }
  }

  let planInfo = (json): Common.TripPlannerResponse.plan => {
    open Json.Decode
    {
      date: json |> field("date", Json.Decode.int),
      from: json |> field("from", placeInfo),
      to: json |> field("to", placeInfo),
      itineraries: json |> field("itineraries", Json.Decode.array(itineraryInfo))
    }
  }

  // ? there might be an error with the array decoder for "missing"
  let errorInfo = (json): Common.TripPlannerResponse.error => {
    open Json.Decode
    {
      id: json |> field("id", Json.Decode.int),
      msg: json |> optional(field("msg", Json.Decode.string)),
      message: json |> optional(field("message", Json.Decode.string)),
      missing: json |> optional(field("missing", Json.Decode.array(Json.Decode.string)))
    }
  }

  let decode = (json): Common.TripPlannerResponse.t => {
    open Json.Decode
    {
      plan: json |> field("plan", planInfo),
      previousPageCursor: json |> optional(field("previousPageCursor", Json.Decode.string)),
      nextPageCursor: json |> optional(field("nextPageCursor", Json.Decode.string)),
      error: json |> optional(field("error", errorInfo))
    }
  }
}

module Geocode = {
  let featureInfo = (json): Common.GeocodeResponse.feature => {
    open Json.Decode
    {
      id: json |> field("id", Json.Decode.string),
      relevance: json |> field("relevance", Json.Decode.float),
      placeName: json |> field("place_name", Json.Decode.string),
      center: json |> field("center", Json.Decode.array(Json.Decode.float))
    }
  }

  let decode = (json): Common.GeocodeResponse.t => {
    open Json.Decode
    {
      features: json |> field("features", Json.Decode.array(featureInfo))
    }
  }
} 

let toStops = Json.Decode.array(Stop.decode)
let toPlan = Plan.decode
let toGeocode = Geocode.decode
