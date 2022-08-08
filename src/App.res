@react.component
let make = () => {
  let errorHandle = a => Js.log(a)
  let callback = a => Js.log("Retrieved Data")
  let getStopData = () => Data.getStops(~callback, ~errorHandle)

  // TODO: save itinerary obj
  let (itinerary, setItinerary) = React.useState(_ => "")

  let callbackPlan = a => setItinerary(a)
  let getPlanData = () => Data.getPlan(~callback=callbackPlan, ~errorHandle)

  // Testing PolyLineCodec bindings: "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
  Js.log(PolylineCodec.decode(~encodedPath="", ~precision=5, ()))

  React.useEffect0(() => {
    getPlanData()
    getStopData()
    None
  })

  <div className="flex flex-col justify-between h-screen">
    <div className="z-10 lg:max-w-xl">
      <SearchBar />
    </div>

    <div className="z-0 h-full w-full absolute">
      <Map.Context>
        <Map images=[{name: "map-pin", url: "/img/person.png"}]>
          // TODO: Create Route element
          <div> </div>
        </Map>
      </Map.Context>
    </div>

    <div className="z-10 lg:max-w-xl">
      <MenuBar />
    </div>
  </div>
}
