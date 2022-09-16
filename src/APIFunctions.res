// * ------- OTP API REQUESTS ------- 
let getBackendData = (url) => {
  let headers = Fetch.HeadersInit.make({"Content-Type": "application/json"})
  Fetch.fetchWithInit("http://localhost:8080" ++ url, Fetch.RequestInit.make(~method_=Get, ~headers, ()))
}

let getStopsParameters = (~lat: float, ~lon: float, ~radius: float) => {
  let lat = `lat=${Belt.Float.toString(lat)}`
  let lon = `&lon=${Belt.Float.toString(lon)}`
  let radius = `&radius=${Belt.Float.toString(radius)}`

  let request = lat ++ lon ++ radius
  Js.Global.encodeURI(request)
}
let getStops = (parameters) => getBackendData("/otp/routers/default/index/stops?" ++ parameters)

let getPlanParameters = (~origin: array<float>, ~destination: array<float>, ~time: string, ~date: string) => {
  let from = `fromPlace=${Belt.Float.toString(origin[1])},${Belt.Float.toString(origin[0])}`
  let to = `&toPlace=${Belt.Float.toString(destination[1])},${Belt.Float.toString(destination[0])}`
  let time = `&time=${time}`
  let date = `&date=${date}`
  let otherParams = "&mode=TRANSIT,WALK&maxWalkDistance=4828.032&arriveBy=false&wheelchair=false&showIntermediateStops=true&debugItineraryFilter=false&locale=en"
  
  let request = from ++ to ++ time ++ date ++ otherParams
  Js.Global.encodeURI(request)
}
let getPlan = (parameters) => getBackendData("/otp/routers/default/plan?" ++ parameters)

// * ------- MAPBOX API REQUESTS ------- 
let mapboxAccessToken = "pk.eyJ1IjoicmFkaW9sYSIsImEiOiJjbDVnN3VmZ3kxaW5xM2JtdHVhbzgzcW9qIn0.zeCuHBB9ObU6Rdyr6_Z5Vg"

let getMapboxData = (url) => {
  let headers = Fetch.HeadersInit.make({"Content-Type": "application/json"})
  Fetch.fetchWithInit("https://api.mapbox.com" ++ url, Fetch.RequestInit.make(~method_=Get, ~headers, ()))
}

let getCoordinatesParameters = (~location: string) => {
  let search = `${location}.json?country=nz&proximity=ip&types=place,postcode,address,poi&access_token=${mapboxAccessToken}`
  Js.Global.encodeURI(search)
}
let getCoordinates = (parameters) => getMapboxData("/geocoding/v5/mapbox.places/" ++ parameters)
