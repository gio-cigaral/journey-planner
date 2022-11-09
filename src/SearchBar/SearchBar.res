@react.component
let make = () => {
  let searchBarInputRef = React.useRef(Js.Nullable.null)
  let (state, dispatch) = React.useContext(SearchBarContext.context)
  let (dataState, dataDispatch) = React.useContext(DataContext.context)

  let handleInsideClick = (_: ReactEvent.Mouse.t) => {
    Js.log("inside - search bar")
    dataDispatch(DataContext.Action.SetFocus(DataContext.Focus.Search))
  }

  let listener = DataContext.FocusListener.make(
    ~id="search-bar",
    ~ref=searchBarInputRef,
    ~handleInsideClick
  )

  React.useEffect0(() => {
    dataDispatch(DataContext.Action.AddFocusListener(listener))

    let cleanup = () => {
      dataDispatch(DataContext.Action.RemoveFocusListener(listener))
    }

    Some(cleanup)
  })

  let searchErrorHandler = a => Js.log(a)
  let getCoordinates = (~parameters, ~callback) => Data.getCoordinates(~parameters, ~callback, ~errorHandler=searchErrorHandler)

  // Update DataContext state with found/chosen location
  let handleSubmit = (_: ReactEvent.Mouse.t) => {
    Js.log("submit search")
    
    let parameters = APIFunctions.getCoordinatesParameters(~location=state.search)
    let searchCallback = (a: Common.GeocodeResponse.t) => {
      dispatch(SearchBarContext.Action.SetPosition(a.features[0]))
      dataDispatch(DataContext.Action.SetSearchLocation(DataContext.SearchLocation.make(~name=state.search, ~position=a.features[0])))
    }

    switch state.position {
    | Some(position) => {
        Js.log("inside position")
        // TODO: run "dataDispatch(DataContext.Action.SetSearchLocation(a.features[0]))" once position is found
        switch dataState.searchLocation {
        | Some(searchLocation) => {
            Js.log(`${searchLocation.name} : ${state.search}`)
            if (searchLocation.name != state.search) {
              getCoordinates(~parameters, ~callback=searchCallback)
            }
          }
        | None => dataDispatch(DataContext.Action.SetSearchLocation(DataContext.SearchLocation.make(~name=state.search, ~position)))
        }
      }
    | _ => {
        // Default - auto-accept first suggestion returned by geocoding API
        Js.log("checking state.search")
        switch state.search {
        | "" => ()
        | _ => {
            Js.log("running search")
            getCoordinates(~parameters, ~callback=searchCallback)
          }
        }
      }
    }
  }

  let handleChange = (evt: ReactEvent.Form.t) => {
    let search = (evt->ReactEvent.Form.target)["value"]
    let parameters = APIFunctions.getCoordinatesParameters(~location=search)
    let autocompleteCallback = (a: Common.GeocodeResponse.t) => dispatch(SearchBarContext.Action.SetAutocomplete(a.features))

    dispatch(SearchBarContext.Action.SetSearch(search))
    getCoordinates(~parameters, ~callback=autocompleteCallback)
  }

  let handleChosenSuggestion = (item: Common.GeocodeResponse.feature) => {
    dispatch(SearchBarContext.Action.SetSearch(item.placeName))
    dispatch(SearchBarContext.Action.SetPosition(item))
  }

  let autocompleteElements = 
    switch state.autocomplete {
    | Some(autocomplete) => {
        autocomplete
        ->Belt.Array.mapWithIndex((index, item) => {
          <div 
            key={"search-suggestion-" ++ Belt.Int.toString(index)} 
            className="p-3 cursor-pointer bg-custom-light-grey border-b-2 border-gray-300 truncate hover:bg-gray-300"
            onClick={(_) => handleChosenSuggestion(item)}
          >
            {React.string(item.placeName)}
          </div>
        })
      }
    | None => [React.null]
    }

  let activeAutocomplete = 
    switch dataState.focus {
    | Search => "block"
    | _ => "hidden border-0"
    }

  // TODO: remove "active" styling for text input box
  <div id="search-container" className="flex m-2 relative">
    <form className="relative flex flex-row m-5 w-full h-14 rounded-lg bg-custom-light-grey shadow-md" onSubmit={(evt) => ReactEvent.Form.preventDefault(evt)}>
      <div id="search-bar" className="w-full">
        <input 
          ref={ReactDOM.Ref.domRef(searchBarInputRef)}
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="Enter stop ID or address"
          value={state.search}
          onChange={handleChange}
        />
      </div>

      <div 
        id="search-submit" 
        className="absolute z-40 top-0 bottom-0 flex flex-col justify-center right-0 w-12 text-center text-black/75 cursor-pointer"
        onClick={handleSubmit}
      >
        <i className="fe fe-search text-3xl" />
      </div>

      <div id="autocomplete-items" className=`${activeAutocomplete} absolute z-40 top-full left-0 right-0 border-2 border-b-0 border-gray-300`>
        {
          React.array(autocompleteElements)
        }
      </div>
    </form>

    <div id="icon-container" className="absolute z-50 top-0 bottom-0 mt-auto mb-auto h-16" onClick={(_) => Util.emptyFocus(dataDispatch)}>
      <img className="w-auto h-full" src="" alt="" />
    </div>
  </div>
}
