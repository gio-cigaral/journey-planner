// OTP API requests
let getBackendData = (url) => {
  let headers = Fetch.HeadersInit.make({"Content-Type": "application/json"})
  Fetch.fetchWithInit("http://localhost:8080" ++ url, Fetch.RequestInit.make(~method_=Get, ~headers, ()))
}

let getStops = (parameters) => getBackendData("/otp/routers/default/index/stops" ++ parameters)

// let getPlan = (parameters) => getBackendData("/otp/routers/default/plan?fromPlace=-37.68714862992901%2C176.16710186004642&toPlace=-37.68222404664231%2C176.1323404312134&time=2%3A56pm&date=07-20-2022&mode=TRANSIT%2CWALK&maxWalkDistance=4828.032&arriveBy=false&wheelchair=false&showIntermediateStops=true&debugItineraryFilter=false&locale=en" ++ parameters)
// let getPlan = (parameters) => getBackendData("/otp/routers/default/plan?fromPlace=-37.68664345065945%2C176.16807818412784&toPlace=-37.682100927871026%2C176.1324155330658&time=2%3A56pm&date=07-20-2022&mode=TRANSIT%2CWALK&maxWalkDistance=4828.032&arriveBy=false&wheelchair=false&showIntermediateStops=true&debugItineraryFilter=false&locale=en" ++ parameters)
let getPlan = (parameters) => getBackendData("/otp/routers/default/plan?fromPlace=-37.68664345065945%2C176.16807818412784&toPlace=-37.682100927871026%2C176.1324155330658&time=14%3A56&date=07-20-2022&mode=TRANSIT%2CWALK&maxWalkDistance=4828.032&arriveBy=false&wheelchair=false&showIntermediateStops=true&debugItineraryFilter=false&locale=en" ++ parameters)

// Mapbox API requests
let getMapboxData = (url) => {
  let headers = Fetch.HeadersInit.make({"Content-Type": "application/json"})
  Fetch.fetchWithInit("https://api.mapbox.com" ++ url, Fetch.RequestInit.make(~method_=Get, ~headers, ()))
}

let getCoordinates = (parameters) => getMapboxData("/geocoding/v5/mapbox.places/" ++ parameters)
