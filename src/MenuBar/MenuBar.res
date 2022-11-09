@react.component
let make = () => {
  let (dataState, dataDispatch) = React.useContext(DataContext.context)

  let onClickTab = (selection: DataContext.Selection.t) => {
    dataDispatch(DataContext.Action.SetSelection(selection))
  }

  let onClickDirections = () => {
    switch dataState.plan {
    | Some(_) => onClickTab(Directions(Details))
    | None => onClickTab(Directions(Input))
    }
  }

  // Styling for mobile
  let activeFooter = 
    switch dataState.selection {
    | Empty => "h-14"
    | Directions(subMenu) => {
        switch subMenu {
        | Details => "h-[40rem] lg:h-[75vh]"
        | _ => "h-96"
        }
      }
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
      switch dataState.selection {
      | Tracker => {
          switch tab {
          | Tracker => "text-custom-light-grey"
          | _ => "text-custom-light-grey/25"
          }
        }
      | Directions(_) => {
          switch tab {
          | Directions(_) => "text-custom-light-grey"
          | _ => "text-custom-light-grey/25"
          }
        }
      | Routes => {
          switch tab {
          | Routes => "text-custom-light-grey"
          | _ => "text-custom-light-grey/25"
          }
        }
      | _ => "text-custom-light-grey/25"
      }
    }

  let activeTabHighlight: (~tab: DataContext.Selection.t) => string = 
    (~tab: DataContext.Selection.t) => {
      switch dataState.selection {
      | Tracker => {
          switch tab {
          | Tracker => "block"
          | _ => "hidden"
          }
        }
      | Directions(_) => {
          switch tab {
          | Directions(_) => "block"
          | _ => "hidden"
          }
        }
      | Routes => {
          switch tab {
          | Routes => "block"
          | _ => "hidden"
          }
        }
      | _ => "hidden"
      }
    }
  
  // TODO: adjust "footer" element height for large screens - starting height too low?
  <div id="footer" className=`flex flex-col ${activeFooter} lg:ml-7 lg:mr-7 shadow-md`>
    <ul id="nav-bar" className="flex flex-row justify-evenly grow-0 w-full h-14 overflow-hidden rounded-t-xl bg-custom-blue">
      // TODO: only show label for large screens
      <li className="relative flex flex-col justify-center flex-1 text-center cursor-pointer group" onClick={(_) => onClickTab(Tracker)}>
        <i className=`fe fe-radio ${activeTabIcon(~tab=Tracker)} z-10 group-hover:text-custom-light-grey text-[2.75rem]` />
        <div className=`${activeTabHighlight(~tab=Tracker)} z-0 group-hover:block absolute bottom-0 left-0 h-3 w-full bg-gradient-to-t from-custom-red to-custom-blue`></div>
        // <div className="text-custom-light-grey/25 text-xs">{React.string("TRACKER")}</div>
      </li>

      <li className="relative flex flex-col justify-center flex-1 text-center cursor-pointer group" onClick={(_) => onClickDirections()}>
        <i className=`fe fe-map-pin ${activeTabIcon(~tab=Directions(Input))} z-10 group-hover:text-custom-light-grey text-[2.5rem]` />
        <div className=`${activeTabHighlight(~tab=Directions(Input))} z-0 group-hover:block absolute bottom-0 left-0 h-3 w-full bg-gradient-to-t from-custom-red to-custom-blue`></div>
        // <div className="text-custom-light-grey/25">{React.string("DIRECTIONS")}</div>
      </li>

      <li className="relative flex flex-col justify-center flex-1 text-center cursor-pointer group" onClick={(_) => onClickTab(Routes)}>
        <i className=`fe fe-bookmark ${activeTabIcon(~tab=Routes)} z-10 group-hover:text-custom-light-grey text-[2.75rem]` />
        <div className=`${activeTabHighlight(~tab=Routes)} z-0 group-hover:block absolute bottom-0 left-0 h-3 w-full bg-gradient-to-t from-custom-red to-custom-blue`></div>
        // <div className="text-custom-light-grey/25">{React.string("ROUTES")}</div>
      </li>
    </ul>

    <DirectionMenuContext>
      // TODO: problem with 'grow' overflowing the page
      <div id="content" className=`${activeContent} lg:block lg:h-[20.5rem] grow bg-custom-light-grey`>
        // TODO: create react element for each content type
        {
          switch dataState.selection {
          | Tracker => React.null
          | Directions(subMenu) => {
              switch subMenu {
              | Input => <DirectionInputMenu />
              | Details => {
                  switch dataState.plan {
                  | Some(plan) => <DirectionDetailsMenu planData={plan} />
                  | None => {
                      dataDispatch(DataContext.Action.SetSelection(Directions(Input)))
                      <DirectionInputMenu />
                    }
                  }
                }
              }
            } 
          | Routes => React.null
          | Empty => React.null
          }
        }
      </div>
    </DirectionMenuContext>
  </div>
}
