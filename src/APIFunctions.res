let getBackendData = (url) => {
  let headers = Fetch.HeadersInit.make({"Content-Type": "application/json"})
  Fetch.fetchWithInit("http://localhost:8080" ++ url, Fetch.RequestInit.make(~method_=Get, ~headers, ()))
}

let getStops = (parameters) => getBackendData("/otp/routers/default/index/stops" ++ parameters)

let getPlan = (parameters) => getBackendData("/otp/routers/default/plan?fromPlace=-37.68714862992901%2C176.16710186004642&toPlace=-37.68222404664231%2C176.1323404312134&time=2%3A56pm&date=07-20-2022&mode=TRANSIT%2CWALK&maxWalkDistance=4828.032&arriveBy=false&wheelchair=false&showIntermediateStops=true&debugItineraryFilter=false&locale=en" ++ parameters)