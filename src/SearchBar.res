@react.component
let make = () => {
  // TODO: remove "active" styling for text input box
  <div id="search-container" className="flex m-2 relative">
    <form className="flex m-5 w-full h-14 rounded-lg bg-radiola-light-grey shadow-md">
      <div id="search-bar" className="w-full">
        <input 
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="Enter stop ID or address"
        />
      </div>
    </form>
    <div id="icon-container" className="absolute top-0 bottom-0 mt-auto mb-auto h-16">
      <img className="w-auto h-full" src="/img/DYNAMIS_ColourSignet.svg" alt="Radiola Dynamis Icon" />
    </div>
  </div>
}
