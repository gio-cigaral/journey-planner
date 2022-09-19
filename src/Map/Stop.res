@react.component
let make = (
  ~stopsData: array<Common.Stop.t>
) => {
  let (dataState, _) = React.useContext(DataContext.context)
  let (mapState, mapDispatch) = React.useContext(Map.Context.context)
  let (stops, setStops) = React.useState(_ => stopsData)

  // convert coordinate array to Mapbox.position
  let convertCoordinate = (~lat: float, ~lon: float) => {
    let pos: Mapbox.position = {
      lat: lat,
      lon: lon
    }
    pos
  }

  React.useEffect0(() => {
    "closeStops"
    -> Map.Context.Action.AddInteractiveLayerId
    -> mapDispatch

    let cleanup = () => {
      "closeStops"
      -> Map.Context.Action.RemoveInteractiveLayerId
      -> mapDispatch
    }

    Some(cleanup)
  })

  React.useEffect3(() => {
    let latitude = Mapbox.ViewState.latitudeGet(mapState.debouncedViewState)
    let longitude = Mapbox.ViewState.longitudeGet(mapState.debouncedViewState)
    switch (latitude, longitude, dataState.stops) {
    | (Some(lat), Some(lon), Some(stops)) => {
        let latOffset = 0.05
        let lonOffset = 0.05

        let closeStops = 
          stops
          ->Belt.Array.keepMap(stop => {
            if (
              stop.lat < lat +. latOffset &&
              stop.lat > lat -. latOffset &&
              stop.lon < lon +. lonOffset &&
              stop.lon > lon -. lonOffset
            ) {
              Some(stop)
            } else {
              None
            }
          })

        setStops(_ => closeStops)
      }
    | _ => ()
    }

    None
  }, (mapState.debouncedViewState, mapState.loaded, stopsData))

  let features = 
    stops
    ->Belt.Array.map((stop) => {
      Mapbox.Feature.make(
        ~geometry=Mapbox.Geometry.Point.make(~position=convertCoordinate(~lat=stop.lat, ~lon=stop.lon)),
        ~properties=Mapbox.Feature.properties(~id=stop.id, ~feature=`closeStop`, ()),
      )
    })

  <Mapbox.Source.GeoJSON
    id="stops"
    data={Mapbox.FeatureCollection.make(~features)}
  >
    <Mapbox.Layer.Circle
      id="closeStops"
      paint={Mapbox.Layer.Circle.paint(
        ~circleRadius=Any([Mapbox.Any("interpolate"), Any(["linear"]), Any(["zoom"]), Any(10), Any(1), Any(13), Any(5), Any(20), Any(15)]),
        ~circleColor=Any("#FFFFFF"),
        ~circleStrokeColor="#002F5D",
        ~circleStrokeWidth=2,
        ()
      )}
    />
  </Mapbox.Source.GeoJSON>
}
