@react.component
let make = () => {
  let (dataState, dataDispatch) = React.useContext(DataContext.context)

  // let onClick = (_, selection: DataContext.Selection.t) => {
  //   dataDispatch(DataContext.Action.SetSelection(selection))
  //   ()
  // }

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

  let activeTabIcon: (~tab: DataContext.Selection.t) => string =
    (~tab: DataContext.Selection.t) => {
      if (tab === dataState.selection) {
        "text-radiola-light-grey"
      } else {
        "text-radiola-light-grey/25"
      }
    }

  let activeTabHighlight: (~tab: DataContext.Selection.t) => string = 
    (~tab: DataContext.Selection.t) => {
      if (tab === dataState.selection) {
        "block"
      } else {
        "hidden"
      }
    }
  
  // TODO: adjust "footer" element height for large screens - starting height too low?
  <div id="footer" className=`${activeFooter} lg:ml-7 lg:mr-7 lg:h-96 shadow-md`>
    <ul id="nav-bar" className="flex flex-row justify-evenly w-full h-14 overflow-hidden rounded-t-xl bg-radiola-blue">
      // TODO: only show label for large screens
      <li className="relative flex flex-col justify-center flex-1 text-center cursor-pointer group" onClick={(_) => dataDispatch(DataContext.Action.SetSelection(DataContext.Selection.Tracker))}>
        <i className=`fe fe-radio ${activeTabIcon(~tab=DataContext.Selection.Tracker)} z-10 group-hover:text-radiola-light-grey text-[2.75rem]` />
        <div className=`${activeTabHighlight(~tab=DataContext.Selection.Tracker)} z-0 group-hover:block absolute bottom-0 left-0 h-3 w-full bg-gradient-to-t from-radiola-red to-radiola-blue`></div>
        // <div className="text-radiola-light-grey/25 text-xs">{React.string("TRACKER")}</div>
      </li>

      <li className="relative flex flex-col justify-center flex-1 text-center cursor-pointer group" onClick={(_) => dataDispatch(DataContext.Action.SetSelection(DataContext.Selection.Directions))}>
        <i className=`fe fe-map-pin ${activeTabIcon(~tab=DataContext.Selection.Directions)} z-10 group-hover:text-radiola-light-grey text-[2.5rem]` />
        <div className=`${activeTabHighlight(~tab=DataContext.Selection.Directions)} z-0 group-hover:block absolute bottom-0 left-0 h-3 w-full bg-gradient-to-t from-radiola-red to-radiola-blue`></div>
        // <div className="text-radiola-light-grey/25">{React.string("DIRECTIONS")}</div>
      </li>

      <li className="relative flex flex-col justify-center flex-1 text-center cursor-pointer group" onClick={(_) => dataDispatch(DataContext.Action.SetSelection(DataContext.Selection.Routes))}>
        <i className=`fe fe-bookmark ${activeTabIcon(~tab=DataContext.Selection.Routes)} z-10 group-hover:text-radiola-light-grey text-[2.75rem]` />
        <div className=`${activeTabHighlight(~tab=DataContext.Selection.Routes)} z-0 group-hover:block absolute bottom-0 left-0 h-3 w-full bg-gradient-to-t from-radiola-red to-radiola-blue`></div>
        // <div className="text-radiola-light-grey/25">{React.string("ROUTES")}</div>
      </li>
    </ul>

    <DirectionsMenuContext>
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
    </DirectionsMenuContext>
  </div>
}
