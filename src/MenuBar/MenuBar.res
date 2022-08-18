@react.component
let make = () => {
  let (dataState, dataDispatch) = React.useContext(DataContext.context)

  // Styling for mobile
  let activeFooter = 
    switch dataState.selection {
    | Empty => "h-14"
    | _ => "h-96"
    }

  // Styling for mobile
  let activeContent = 
    switch dataState.selection {
    | Empty => "hidden"
    | _ => "block h-[20.5rem]"
    }
  
  // TODO: adjust "footer" element height for large screens - starting height too low?
  <div id="footer" className=`${activeFooter} lg:ml-7 lg:mr-7 lg:h-96 shadow-md`>
    <ul id="nav-bar" className="flex flex-row justify-evenly w-full h-14 overflow-hidden rounded-t-xl bg-radiola-blue">
      // TODO: replace current "active" tab highglighting
      // TODO: only show label for large screens
      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400" onClick={(_) => dataDispatch(DataContext.Action.SetSelection("tracker"))}>
        <i className="fe fe-radio text-radiola-light-grey/25 text-[2.75rem]" />
        // <div className="text-radiola-light-grey/25 text-xs">{React.string("TRACKER")}</div>
      </li>

      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400" onClick={(_) => dataDispatch(DataContext.Action.SetSelection("directions"))}>
        <i className="fe fe-map-pin text-radiola-light-grey/25 text-[2.5rem]" />
        // <div className="text-radiola-light-grey/25">{React.string("DIRECTIONS")}</div>
      </li>

      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400" onClick={(_) => dataDispatch(DataContext.Action.SetSelection("routes"))}>
        <i className="fe fe-bookmark text-radiola-light-grey/25 text-[2.75rem]" />
        // <div className="text-radiola-light-grey/25">{React.string("ROUTES")}</div>
      </li>
    </ul>

    <div id="content" className=`${activeContent} bg-radiola-light-grey lg:block lg:h-[20.5rem]`>
      // TODO: create react element for each content type
      {
        switch dataState.selection {
        | Tracker => React.null
        | Directions => <DirectionsMenu />
        | Routes => React.null
        | Empty => React.null
        }
      }
    </div>
  </div>
}