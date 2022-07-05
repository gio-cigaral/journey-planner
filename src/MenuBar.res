@react.component
let make = () => {
  // TODO: adjust "footer" element height for large screens - starting height too low?
  <div id="footer" className="lg:ml-7 lg:max-w-xl h-14 lg:h-96 shadow-md">
    <ul id="nav-bar" className="flex flex-row justify-evenly w-full h-full lg:h-14 overflow-hidden rounded-t-xl bg-radiola-blue">
      // TODO: replace current "active" tab highglighting
      // TODO: only show label for large screens
      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400">
        <i className="fe fe-radio text-radiola-light-grey/25 text-[2.75rem]" />
        // <div className="text-radiola-light-grey/25 text-xs">{React.string("TRACKER")}</div>
      </li>

      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400">
        <i className="fe fe-map-pin text-radiola-light-grey/25 text-[2.5rem]" />
        // <div className="text-radiola-light-grey/25">{React.string("DIRECTIONS")}</div>
      </li>

      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400">
        <i className="fe fe-bookmark text-radiola-light-grey/25 text-[2.75rem]" />
        // <div className="text-radiola-light-grey/25">{React.string("ROUTES")}</div>
      </li>
    </ul>

    <div id="content" className="hidden lg:block lg:h-[20.5rem] lg:bg-radiola-light-grey ">
    
    </div>
  </div>
}