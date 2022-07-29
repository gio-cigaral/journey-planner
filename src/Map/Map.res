module Context = Map__Context

let mapboxAccessToken = "pk.eyJ1IjoicmFkaW9sYSIsImEiOiJjbDVnN3VmZ3kxaW5xM2JtdHVhbzgzcW9qIn0.zeCuHBB9ObU6Rdyr6_Z5Vg"
let mapStyle = "mapbox://styles/mapbox/streets-v9?optimize=true"

type image = {
  name: string,
  url: string
}

let loadImages = (map: React.ref<Js.Nullable.t<Dom.element>>, images: array<image>) => {
  switch map.current->Js.Nullable.toOption {
  | Some(x) => 
    images
    -> Belt.Array.forEach(image => {
      Mapbox.Map.loadImage(
        x,
        image.url,
        image.name,
        {() => Js.log("map-pin loaded")},
        {() => Js.log("error")}
      )
    })
  | None => ()
  }
}

@react.component
let make = (~images: array<image>, ~children) => {
  let ref = React.useRef(Js.Nullable.null)
  let (state, dispatch) = React.useContext(Context.context)
  // ? why is the dispatch function for the DataContext an underscore?
  // let (data, _) = React.useContext(DataContext.context)

  // Update Map ref
  // ? what is a ref, what is it used for, and why would it change?
  React.useEffect0(() => {
    Some(ref)
    -> Context.Action.SetMapRef
    -> dispatch

    let cleanup = () => {
      None
      -> Context.Action.SetMapRef
      -> dispatch
    }

    Some(cleanup)
  })

  // ? what is the DebouncedViewState for?
  // React.useEffect1(() => {
  //   data.viewState
  //   -> Context.Action.SetViewState
  //   -> dispatch

  //   data.viewState
  //   -> Context.Action.SetDebouncedViewState
  //   -> dispatch

  //   None
  // }, [data.viewState])

  let onMove = (evt) => {
    evt
    -> Mapbox.ViewStateChangeEvent.getViewState
    -> Context.Action.SetViewState
    -> dispatch
  }

  // let onMoveEnd = (evt) => {
  //   evt
  //   -> Mapbox.ViewStateChangeEvent.getViewState
  //   -> Context.Action.SetDebouncedViewState
  //   -> dispatch
  // }

  <Mapbox.Spread props=state.viewState>
    <Mapbox.Map
      ref={ReactDOM.Ref.domRef(ref)}
      onMove
      // onMoveEnd
      onLoad={_ => {
        loadImages(ref, images)
        dispatch(Context.Action.SetLoaded(true))
      }}
      reuseMaps=true
      mapboxAccessToken
      mapStyle
      minPitch=0.0
      maxPitch=0.0
      minZoom=10
      maxZoom=24>
      <Mapbox.NavigationControl position=#bottomright />
      <Mapbox.GeolocateControl
        position=#bottomright
        trackUserLocation=true
        showUserHeading=true
        positionOptions={Mapbox.GeolocateControl.Options.make(
          ~timeout=10,
          ~enableHighAccuracy=true,
          (),
        )}
      />
        children
    </Mapbox.Map>
  </Mapbox.Spread>
}