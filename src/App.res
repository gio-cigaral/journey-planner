@react.component
let make = () => {
  <div className="flex flex-col justify-between h-screen">
    <div id="search-container" className="flex m-5 relative lg:max-w-xl border-2 border-black">
      <div id="search-bar" className="m-5 bg-blue-200 w-full h-10 flex">
        // ? would it be possible to reuse the searchbar component from Dynamis?
      </div>
      <img className="absolute top-0 left-0" src="/img/DYNAMIS_ColourSignet.svg" alt="Radiola Dynamis Icon" />
    </div>

    <div id="bottom-nav-bar" className="flex flex-row justify-evenly lg:ml-5 lg:max-w-xl rounded-t-xl bg-blue-900 h-20 lg:h-96">
      <div id="icon-1" className="hover:border-2">
        <img src="/img/DYNAMIS_ColourSignet.svg" alt="placeholder" />
      </div>
      <div id="icon-2" className="hover:border-2">
        <img src="/img/DYNAMIS_ColourSignet.svg" alt="placeholder" />
      </div>
      <div id="icon-3" className="hover:border-2">
        <img  src="/img/DYNAMIS_ColourSignet.svg" alt="placeholder" />
      </div>
    </div>
  </div>
}

// example component
/**
  <div className="max-w-xl mx-auto bg-white rounded-xl shadow-md overflow-hidden md:max-w-2xl">
    <div className="md:flex">
      <div className="md:shrink-0">
        <img className="h-48 w-full object-cover md:h-full md:w-48" src="/img/DYNAMIS_ColourSignet.svg" alt="Man looking at item at a store" />
      </div>
      <div className="p-8">
        <div className="uppercase tracking-wide text-sm text-indigo-500 font-semibold">{React.string("Case study")}</div>
        <a href="#" className="block mt-1 text-lg leading-tight font-medium text-black hover:underline">{React.string("Finding customers for your new business")}</a>
        <p className="mt-2 text-slate-500">{React.string("Getting a new business off the ground is a lot of hard work. Here are five ideas you can use to find your first customers.")}</p>
      </div>
    </div>
  </div>
*/
