@deriving(abstract)
type routeLine = {
  id: int,
  shape: array<Mapbox.position>,
  color: string
}

// Display a single itinerary on map
@react.component
let make = (
  ~itinerary: Common.Itinerary.t
) => {
  let (dataState, _) = React.useContext(DataContext.context)
  let (_, mapDispatch) = React.useContext(Map.Context.context)
  let (lines, setLines) = React.useState(_ => [])

  // React.useEffect0(() => {
  //   Map.Context.Action.AddInteractiveLayerId("tripStops")->mapDispatch
  //   None
  // })

  // convert coordinate array to Mapbox.position
  let convertCoordinate = (~coord: array<float>) => {
    let pos: Mapbox.position = {
      lat: coord[0],
      lon: coord[1]
    }
    pos
  }

  let getItineraryShapes = () => {    
    let encodedPath = 
      switch itinerary.legs {
      | Some(leg) => {
        Belt.Array.map(leg, (l) => {
          switch l.legGeometry {
          | Some(lg) => {
            switch lg.points {
            | Some(p) => p
            | _ => ""
            }
          
          }
          | _ => ""
          }
        }) 
      }
      | _ => [""]
      }

    let decodedPath = Belt.Array.map(encodedPath, (path) => {
      PolylineCodec.decode(~encodedPath=path, ~precision=5, ())
    })

    let mapboxCoordinates = Belt.Array.mapWithIndex(decodedPath, (index, path) => {
      let shape = Belt.Array.map(path, (coord) => {
        convertCoordinate(~coord)
      })
      
      let color = 
        switch itinerary.legs {
        | Some(leg) => { 
          switch leg[index].routeColor {
          | Some(color) => "#" ++ color
          | _ => "black"
          }
        }
        | _ => "black"
        }

      routeLine(~id=index, ~shape, ~color)
    })

    setLines(_ => mapboxCoordinates)
  }

  React.useEffect1(() => {
    getItineraryShapes()
    None
  }, [itinerary])

  let lineFeatures = 
    lines
    ->Belt.Array.mapWithIndex((index, line) => {
      Mapbox.Feature.makeLine(
        ~geometry=Mapbox.Geometry.LineString.make(~positions=shapeGet(line)),
        ~properties=Mapbox.Feature.properties(~feature=`itinerary-${Belt.Int.toString(index)}`, ()),
      )
    })

  // ? May need to modify <id> and <filter> tags to also specify which Itinerary the line belongs to
  // ? e.g. `itineraryLine${Belt.Int.toString(dataState.route)}-${Belt.Int.toString(index)}`
  let lineElements = 
    lines
    ->Belt.Array.mapWithIndex((index, line) => {
      <Mapbox.Layer.Line
        id=`itineraryLine-${Belt.Int.toString(index)}`
        paint={Mapbox.Layer.Line.paint(~lineWidth=5, ~lineOpacity=0.7, ~lineColor=colorGet(line), ())}
        filter=Any([Mapbox.Any("=="), Any(["get", "feature"]), Any(`itinerary-${Belt.Int.toString(index)}`)])
      />
    })

  <Mapbox.Source.GeoJSON
    id="selectedItinerary"
    data={Mapbox.FeatureCollection.make(~features=lineFeatures)}
  >
    {
      React.array(lineElements)
    }
  </Mapbox.Source.GeoJSON>
}