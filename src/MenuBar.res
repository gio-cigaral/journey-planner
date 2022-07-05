@react.component
let make = () => {
  // TODO: adjust "footer" element height for large screens
  <div id="footer" className="lg:ml-7 lg:max-w-xl rounded-t-xl bg-radiola-blue h-14 lg:h-96">
    <ul id="nav-bar" className="flex flex-row justify-evenly w-full h-full overflow-hidden">
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
  </div>
}