@react.component
let make = () => {
  let (dataState, dataDispatch) = React.useContext(DataContext.context)

  // * START TESTING CODE
  let errorHandle = a => Js.log(a)
  let callback = a => Js.log("Retrieved Stops Data")
  let getStopData = () => Data.getStops(~callback, ~errorHandle)

  let callbackPlan = a => {
    Js.log("Retrieved Plan Data")
    Js.log(a)
    dataDispatch(DataContext.Action.SetPlan([a]))
  }
  // let callbackPlan = a => Js.log(a)
  let getPlanData = () => Data.getPlan(~callback=callbackPlan, ~errorHandle)

  // Testing PolyLineCodec bindings: "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
  Js.log(PolylineCodec.decode(~encodedPath="_p~iF~ps|U_ulLnnqC_mqNvxq`@", ~precision=5, ()))

  React.useEffect0(() => {
    getPlanData()
    getStopData()
    None
  })
  // * END TESTING CODE

  <div className="flex flex-col justify-between h-screen">
    <div className="z-10 lg:max-w-xl">
      <SearchBar />
    </div>

    <div className="z-0 h-full w-full absolute">
      <Map.Context>
        <Map images=[{name: "map-pin", url: "/img/person.png"}]>
          // TODO: Create Route element
          {
            switch dataState.itinerary {
            | Some(itinerary) => <Itinerary itinerary=itinerary[dataState.route]> </Itinerary>
            | None => <div> </div>
            }
          }
        </Map>
      </Map.Context>
    </div>

    <div className="z-10 lg:max-w-xl">
      <MenuBar />
    </div>
  </div>
}
