@react.component
let make = () => {
  <div className="flex flex-col justify-between h-screen">
    <SearchBar />

    <Map images=[{name: "map-pin", url: "/img/person.png"}]>
      <div> </div>
    </Map>

    <MenuBar />
  </div>
}
