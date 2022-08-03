// Display a given itinerary on map
@react.component
let make = (
  ~itinerary: Common.TripPlannerResponse.itinerary
) => {
  // let (dataState, _) = React.useContext(DataContext.context)
  let (_, mapDispatch) = React.useContext(Map.Context.context)
  let (shapes, setShapes) = React.useState(_ => [])

  let getItineraryShapes = () => {
    // TODO: decode all leg geometries
    // TODO: [1]
    // Note: legs, legGeometry, points are all optional fields
    // ? how to access an optional property?
    // itinerary.legs[x].legGeometry.points

    // * To test just try to draw only the first leg
    // let path = itinerary.legs[0].legGeometry.points

    let encodedPath = 
      switch itinerary.legs {
      | Some(l) => {
        switch l[0].legGeometry {
        | Some(lg) => {
          switch lg.points {
          | Some(p) => p
          | _ => ""
          }
        }
        | _ => ""
        } 
      }
      | _ => ""
      }

    let decodedPath = PolylineCodec.decode(~encodedPath, ~precision=5, ())

    // Convert decoded path (array of coordinates) to type: Mapbox.position
    decodedPath
    ->Belt.Array.map(coord => {
      convertCoordinate(~coord)
    })

    setShapes(_ => decodedPath)
  }

  // attempt at converting coordinate array to Mapbox.position
  // let convertCoordinate = (~coord: array<float>) => {
  //   let test: Mapbox.position = {
  //     lat: coord[0],
  //     lon: coord[1]
  //   }
  // }

  React.useEffect1(() => {
    getItineraryShapes()
    None
  }, [itinerary])

  let lineFeatures = 
    shapes
    ->Belt.Array.map(shape => {
      Mapbox.Feature.makeLine(
        ~geometry=Mapbox.Geometry.LineString.make(~positions=shape), // TODO: [1] convert return type of 'decode' to Mapbox.position
        ~properties=Mapbox.Feature.properties(~feature="itinerary", ()),
      )
    })

  <Mapbox.Source.GeoJSON
    id="selectedItinerary"
    data={Mapbox.FeatureCollection.make(~features=lineFeatures)}
  >
    <Mapbox.Layer.Line
      id="itineraryLine"
      paint={Mapbox.Layer.Line.paint(~lineWidth=5, ~lineOpacity=0.7, ())}
      filter=Any([Mapbox.Any("=="), Any(["get", "feature"]), Any("itinerary")])
    />
  </Mapbox.Source.GeoJSON>
}