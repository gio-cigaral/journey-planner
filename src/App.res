@react.component
let make = () => {
  let (dataState, dataDispatch) = React.useContext(DataContext.context)

  let errorHandler = a => Js.log(a)
  let callback = a => dataDispatch(DataContext.Action.SetStops(a))
  let getStopData = () => Data.getStops(~callback, ~errorHandler)

  let callbackPlan = a => dataDispatch(DataContext.Action.SetPlan([a]))
  let getPlanData = () => Data.getPlan(~callback=callbackPlan, ~errorHandler)

  React.useEffect0(() => {
    getPlanData()
    getStopData()
    None
  })

  <div className="flex flex-col justify-between h-screen">
    <div className="z-10 xl:max-w-lg lg:max-w-sm">
      <SearchBar />
    </div>

    <div className="z-0 h-full w-full absolute">
      <Map.Context>
        <Map images=[{name: "map-pin", url: "/img/person.png"}]>
          {
            switch dataState.stops {
            | Some(stops) => 
                <Stop stops=stops />
            | None => React.null
            }
          }
          {
            switch dataState.itinerary {
            | Some(itinerary) => <Itinerary itinerary=itinerary[dataState.route] />
            | None => React.null
            }
          }
        </Map>
      </Map.Context>
    </div>

    <div className="z-10 xl:max-w-lg lg:max-w-sm">
      <MenuBar />
    </div>
  </div>
}
