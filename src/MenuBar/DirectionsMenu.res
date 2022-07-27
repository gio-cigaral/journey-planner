@react.component
let make = () => {
  // <p>{React.string("Directions Menu")}</p>
  <div id="directions-container" className="h-full w-full p-5">
    <form className="flex flex-col justify-evenly h-4/5 bg-radiola-light-grey lg:max-w-xl">
      <div id="search-bar" className="w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit placeholder:italic" 
          placeholder="Enter origin"
        />
      </div>

      <div id="search-bar" className="w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit placeholder:italic" 
          placeholder="Enter destination"
        />
      </div>
    </form>
  </div>
}