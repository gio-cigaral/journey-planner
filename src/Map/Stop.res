@react.component
let make = (
  ~stops: array<Common.Stop.t>
) => {
  let (_, mapDispatch) = React.useContext(Map.Context.context)

  // convert coordinate array to Mapbox.position
  let convertCoordinate = (~lat: float, ~lon: float) => {
    let pos: Mapbox.position = {
      lat: lat,
      lon: lon
    }
    pos
  }

  React.useEffect0(() => {
    "stop-circle"
    -> Map__Context.Action.AddInteractiveLayerId
    -> mapDispatch

    let cleanup = () => {
      "stop-circle"
      -> Map__Context.Action.RemoveInteractiveLayerId
      -> mapDispatch
    }

    Some(cleanup)
  })

  // Center map over stop
  // React.useEffect2(() => {
  //   switch mapState.ref {
  //   | Some(map) => Map.flyTo(map, stop.lon, stop.lat, 20)
  //   | None => ()
  //   }
  //   None
  // }, (mapState.ref, stop))

  // ? May need to change feature from being specific (i.e. `stop-${stop.id}`) to be more generic and represent feature type (e.g. 'stop')
  let features = 
    stops
    ->Belt.Array.map((stop) => {
      Mapbox.Feature.make(
        ~geometry=Mapbox.Geometry.Point.make(~position=convertCoordinate(~lat=stop.lat, ~lon=stop.lon)),
        ~properties=Mapbox.Feature.properties(~id=stop.id, ~feature=`stop-${stop.id}`, ()),
      )
    })

  let stopElements = 
    stops
    ->Belt.Array.map((stop) => {
      <Mapbox.Layer.Circle
        id="stop-circle"  // * Display one stop
        // id=`stop-circle-${stop.id}`  // * Display all stops (NOTE: this leads to an issue with onClick as it needs to match ID added above to ID here)
        paint={Mapbox.Layer.Circle.paint(
          ~circleRadius=Any([Mapbox.Any("interpolate"), Any(["linear"]), Any(["zoom"]), Any(10), Any(1), Any(13), Any(5), Any(20), Any(15)]),
          ~circleColor=Any("#FFFFFF"),
          ~circleStrokeColor="#002F5D",
          ~circleStrokeWidth=2,
          ()
        )}
        filter=Any([Mapbox.Any("=="), Any(["get", "feature"]), Any(`stop-${stop.id}`)])
      />
    })

  <Mapbox.Source.GeoJSON
    id="stops"
    data={Mapbox.FeatureCollection.make(~features)}
  >
    {
      React.array(stopElements)
    }
  </Mapbox.Source.GeoJSON>
}
