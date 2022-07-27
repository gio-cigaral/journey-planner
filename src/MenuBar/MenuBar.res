type content = 
  | Tracker
  | Directions
  | Routes
  | None

// Content to display in menu card
type state = {display : content}

// TODO: add functionality to minimize the menu card - by clicking on the background (i.e. any element except the SearchBar or MenuBar)
// * difficult to do since the listener would have to be on a parent element while the work needs to be completed in this one
// ? possible solution is to have the card minimize when the 'focus' is off the entire MenuBar 
// ? - problem with this is it will minimize for the SearchBar as well
// * might need to be handled by a parent (App?) state 
// * - handle by parent context (see "showMenu"? in white-label DropMenu.res) - how will this element know when the context has changed?
// * LoginForm.res onChange?
let reducer = (state, action) => {
  switch action {
  | Tracker => 
    Js.log("displaying tracker")
    {display: Tracker}
  | Directions => 
    Js.log("displaying directions")
    {display: Directions}
  | Routes => 
    Js.log("displaying routes")
    {display: Routes}
  | None => 
    Js.log("displaying NONE")
    {display: None}
  }
}

@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(reducer, {display: None})

  let activeFooter = 
    switch state.display {
    | None => "h-14"
    | _ => "h-96"
    }

  let activeContent = 
    switch state.display {
    | None => "hidden"
    | _ => "block h-[20.5rem]"
    }
  
  // TODO: adjust "footer" element height for large screens - starting height too low?
  <div id="footer" className=`${activeFooter} lg:ml-7 lg:max-w-xl lg:h-96 shadow-md`>
    <ul id="nav-bar" className="flex flex-row justify-evenly w-full h-14 overflow-hidden rounded-t-xl bg-radiola-blue">
      // TODO: replace current "active" tab highglighting
      // TODO: only show label for large screens
      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400" onClick={(_) => dispatch(Tracker)}>
        <i className="fe fe-radio text-radiola-light-grey/25 text-[2.75rem]" />
        // <div className="text-radiola-light-grey/25 text-xs">{React.string("TRACKER")}</div>
      </li>

      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400" onClick={(_) => dispatch(Directions)}>
        <i className="fe fe-map-pin text-radiola-light-grey/25 text-[2.5rem]" />
        // <div className="text-radiola-light-grey/25">{React.string("DIRECTIONS")}</div>
      </li>

      <li className="flex flex-col justify-center flex-1 text-center hover:bg-blue-400" onClick={(_) => dispatch(Routes)}>
        <i className="fe fe-bookmark text-radiola-light-grey/25 text-[2.75rem]" />
        // <div className="text-radiola-light-grey/25">{React.string("ROUTES")}</div>
      </li>
    </ul>

    <div id="content" className=`${activeContent} bg-radiola-light-grey lg:block lg:h-[20.5rem]`>
      // TODO: create modules for each content type
      {
        switch state.display {
        | Tracker => React.null
        | Directions => <DirectionsMenu />
        | Routes => React.null
        | None => React.null
        }
      }
    </div>
  </div>
}