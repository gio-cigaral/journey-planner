let getBackendData = (url) => {
  let headers = Fetch.HeadersInit.make({"Content-Type": "application/json"})
  Fetch.fetchWithInit("http://localhost:8080" ++ url, Fetch.RequestInit.make(~method_=Get, ~headers, ()))
}

let getStops = (parameters) => getBackendData("/otp/routers/default/index/stops" ++ parameters)
