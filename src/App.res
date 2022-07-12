@react.component
let make = () => {
  <div className="flex flex-col justify-between h-screen">
    <div className="z-10">
      <SearchBar />
    </div>

    <div className="z-0 h-full w-full absolute">
      <Map images=[{name: "map-pin", url: "/img/person.png"}]>
        <div> </div>
      </Map>
    </div>

    <div className="z-10">
      <MenuBar />
    </div>
  </div>
}
