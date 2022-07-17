@react.component
let make = () => {
  let errorHandle = a => Js.log(a)
  let callback = a => Js.log("Retrieved stops")
  let getStopData = () => Data.getStops(~callback, ~errorHandle)

  React.useEffect0(() => {
    getStopData()
    None
  })

  <div className="flex flex-col justify-between h-screen">
    <div className="z-10">
      <SearchBar />
    </div>

    <div className="z-0 h-full w-full absolute">
      <Map.Context>
        <Map images=[{name: "map-pin", url: "/img/person.png"}]>
          <div> </div>
        </Map>
      </Map.Context>
    </div>

    <div className="z-10">
      <MenuBar />
    </div>
  </div>
}
