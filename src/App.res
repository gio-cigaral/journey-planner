@react.component
let make = () => {
  let appRef = React.useRef(Js.Nullable.null)
  let (dataState, dataDispatch) = React.useContext(DataContext.context)

  // let errorHandler = a => Js.log(a)
  // let callback = a => dataDispatch(DataContext.Action.SetStops(a))
  // let getStopData = () => Data.getStops(~callback, ~errorHandler)

  // React.useEffect0(() => {
  //   // TODO: process stops
  //   getStopData()
  //   None
  // })

  React.useEffect2(() => {
    let handleClick = (evt) => {
      Js.log("outside click handler")
      let targetDom = ReactEvent.Mouse.target(evt)
      let targetListener: array<DataContext.FocusListener.t> = Belt.Array.keepMap(dataState.focusListeners, (listener) => {
        switch listener.ref.current->Js.Nullable.toOption {
        | Some(dom) => {
            if (ReactDOM.domElementToObj(dom) == targetDom) {
              Some(listener)
            } else {
              None
            }
          }
        | None => None
        }
      })

      if (Belt.Array.length(targetListener) == 0) {
        dataDispatch(DataContext.Action.SetFocus(DataContext.Focus.Empty))
      } else {
        targetListener[0].handleInsideClick(evt)
      }
    }

    Util.addDocumentEventListener("click", handleClick)

    let cleanup = () => {
      Util.removeDocumentEventListener("click", handleClick)
    }

    Some(cleanup)
  }, (appRef, dataState.focusListeners))

  <div ref={ReactDOM.Ref.domRef(appRef)} className="flex flex-col justify-between h-screen">
    <div className="z-10 lg:max-w-sm">
      <SearchBarContext>
        <SearchBar />
      </SearchBarContext>
    </div>

    <div className="z-0 h-full w-full absolute">
      <Map.Context>
        <Map images=[{name: "map-pin", url: "/img/person.png"}]>
          {
            switch dataState.stops {
            | Some(stops) => 
                <Stop stops=stops />
            | None => React.null
            }
          }
          {
            switch dataState.itinerary {
            | Some(itinerary) => <Itinerary itinerary=itinerary[dataState.activeItinerary] />
            | None => React.null
            }
          }
        </Map>
      </Map.Context>
    </div>

    <div className="z-10 lg:max-w-sm">
      <MenuBar />
    </div>
  </div>
}
