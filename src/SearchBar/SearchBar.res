@react.component
let make = () => {
  let (state, dispatch) = React.useContext(SearchBarContext.context)
  let (_, dataDispatch) = React.useContext(DataContext.context)

  let searchCallback = (a: Common.GeocodeResponse.t) => dispatch(SearchBarContext.Action.SetPosition(a.features[0]))
  let searchErrorHandler = a => Js.log(a)
  let getCoordinates = (~parameters, ~callback) => Data.getCoordinates(~parameters, ~callback, ~errorHandler=searchErrorHandler)

  let handleSubmit = (_: ReactEvent.Mouse.t) => {
    Js.log("submit search")
    switch state.search {
    | "" => ()
    | _ => {
        let parameters = APIFunctions.getCoordinatesParameters(~location=state.search)
        getCoordinates(~parameters, ~callback=searchCallback)
      }
    }
  }

  let handleChange = (evt: ReactEvent.Form.t) => {
    let search = (evt->ReactEvent.Form.target)["value"]
    dispatch(SearchBarContext.Action.SetSearch(search))

    let parameters = APIFunctions.getCoordinatesParameters(~location=search)
    let autocompleteCallback = (a: Common.GeocodeResponse.t) => dispatch(SearchBarContext.Action.SetAutocomplete(a.features))
    getCoordinates(~parameters, ~callback=autocompleteCallback)
  }

  React.useEffect1(() => {
    switch state.position {
    | Some(position) => {
        dataDispatch(DataContext.Action.SetSearchLocation(position))
      }
    | _ => ()
    }
    None
  }, [state.position])

  // TODO: remove "active" styling for text input box
  <div id="search-container" className="flex m-2 relative">
    // TODO: override or disable default "onSubmit" function 
    <form className="relative flex flex-row m-5 w-full h-14 rounded-lg bg-radiola-light-grey shadow-md">
      <div id="search-bar" className="w-full">
        <input 
          type_="text"
          className="w-full h-full pl-12 bg-inherit" 
          placeholder="Enter stop ID or address"
          value={state.search}
          onChange={handleChange}
        />
      </div>

      <div 
        id="search-submit" 
        className="flex flex-col justify-center w-12 text-center text-black/75 cursor-pointer"
        onClick={handleSubmit}
      >
        <i className="fe fe-search text-3xl" />
      </div>

      // TODO: autocomplete div
      {
        switch state.autocomplete {
        | Some(autocomplete) =>
            if (Belt.Array.length(autocomplete) > 0) {
              <div id="autocomplete-items" className="absolute z-50 top-full left-0 right-0 border-2 border-b-0 border-t-0 border-gray-300">
                <div className="p-3 cursor-pointer bg-red-500 border-b-2 border-black"> </div>
              </div>
            } else {
              React.null
            }
        | None => React.null
        }
      }
    </form>

    <div id="icon-container" className="absolute top-0 bottom-0 mt-auto mb-auto h-16">
      <img className="w-auto h-full" src="/img/DYNAMIS_ColourSignet.svg" alt="Radiola Dynamis Icon" />
    </div>
  </div>
}
