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
    let stopLayerIds = 
      stops
      ->Belt.Array.map((stop) => {
        `stop-circle-${stop.id}`
      })

    stopLayerIds
    ->Belt.Array.forEach((id) => {
      id
      -> Map__Context.Action.AddInteractiveLayerId
      -> mapDispatch
    })

    let cleanup = () => {
      stopLayerIds
      ->Belt.Array.forEach((id) => {
        id
        -> Map__Context.Action.RemoveInteractiveLayerId
        -> mapDispatch
      })
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

  // ? May need to change feature from being specific (i.e. `stop-${stop.id}`) to be more generic and represent feature type (e.g. 'stop')
  let features = 
    stops
    ->Belt.Array.map((stop) => {
      Mapbox.Feature.make(
        ~geometry=Mapbox.Geometry.Point.make(~position=convertCoordinate(~lat=stop.lat, ~lon=stop.lon)),
        ~properties=Mapbox.Feature.properties(~id=stop.id, ~feature=`stop-circle-${stop.id}`, ()),
      )
    })

  let stopElements = 
    stops
    ->Belt.Array.map((stop) => {
      <Mapbox.Layer.Circle
        // id="stop-circle"  // * Display one stop
        id=`stop-circle-${stop.id}`  // * Display all stops 
        key=`stop-circle-${stop.id}`
        // ! (NOTE: this leads to an issue with Map.onClick as it needs to match InteractiveLayerID ("stop-circle") to the ID here ("stop-circle-${stop.id}"))
        // ? unique IDs are required to generate multiple elements 
        paint={Mapbox.Layer.Circle.paint(
          ~circleRadius=Any([Mapbox.Any("interpolate"), Any(["linear"]), Any(["zoom"]), Any(10), Any(1), Any(13), Any(5), Any(20), Any(15)]),
          ~circleColor=Any("#FFFFFF"),
          ~circleStrokeColor="#002F5D",
          ~circleStrokeWidth=2,
          ()
        )}
        filter=Any([Mapbox.Any("=="), Any(["get", "feature"]), Any(`stop-circle-${stop.id}`)])
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
