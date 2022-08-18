@react.component
let make = () => {
  // let (state, dispatch) = React.useReducer(reducer, initialState)
  let (state, dispatch) = React.useContext(DirectionsMenuContext.context)
  let (_, dataDispatch) = React.useContext(DataContext.context)

  // * TESTING
  // triton%20hearing%20tauranga.json?  -> ${Js.Global.encodeURI(state.origin)}?
  // country=nz
  // &proximity=ip
  // &types=place%2Cpostcode%2Caddress%2Cpoi
  // &access_token=pk.eyJ1IjoicmFkaW9sYSIsImEiOiJjbDVnN3VmZ3kxaW5xM2JtdHVhbzgzcW9qIn0.zeCuHBB9ObU6Rdyr6_Z5Vg  -> &access_token=${Map.mapboxAccessToken}
  let search = `${state.origin}.json?country=nz&proximity=ip&types=place,postcode,address,poi&access_token=${Map.mapboxAccessToken}`
  let parameters = Js.Global.encodeURI(search)
  let errorHandler = a => Js.log(a)
  let callback = a => Js.log(a)
  let test = () => Data.getCoordinates(~parameters, ~callback, ~errorHandler)

  let handleClick = (evt: ReactEvent.Mouse.t) => {
    Js.log(state.origin)
    Js.log(state.destination)

    // * TESTING
    Js.log("hello")
    let h = test()
    h()
    ()
  }

  <div id="directions-container" className="h-full w-full p-5">
    <form className="flex flex-col justify-evenly h-4/5 bg-radiola-light-grey">
      <div id="origin-input-bar" className="w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="From"
          value={state.origin}
          onChange={(evt) => 
            dispatch(SetOrigin((evt->ReactEvent.Form.target)["value"]))
          }
        />
      </div>

      <div id="destination-input-bar" className="w-full h-12 border-2 border-gray-300 rounded-lg">
        <input 
          type_="text"
          className="w-full h-full pl-12 pr-12 bg-inherit" 
          placeholder="To"
          value={state.destination}
          onChange={(evt) =>
            dispatch(SetDestination((evt->ReactEvent.Form.target)["value"]))
          }
        />
      </div>

      <hr />

      <div id="submit-button" className="w-full h-12 border-2 border-gray-300 rounded-full">
        <button type_="button" className="w-full h-full" onClick={handleClick}>
          {React.string("Plan my journey")}
        </button>
      </div>
    </form>
  </div>
}