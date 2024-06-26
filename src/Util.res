let getReadableTime = (~time: float) => {
  // * Get Time (HH-mm[am/pm])
  let date = Js.Date.fromFloat(time)

  let hours24 = Belt.Float.toInt(Js.Date.getHours(date))
  let hours12 = Belt.Int.toString(mod(hours24, 12))
  let period = hours24 > 12 ? "pm" : "am"

  let minutes = Js.Date.getMinutes(date)
  let minutesFormat = minutes < 10.0 ? "0" ++ Belt.Float.toString(minutes) : Belt.Float.toString(minutes)

  hours12 ++ ":" ++ minutesFormat ++ period
}

let getCurrentTime = () => {
  getReadableTime(~time=Js.Date.now())
}

let getCurrentDate = () => {
  // * Get Date (MM-DD-YYYY)
  let date = Js.Date.fromFloat(Js.Date.now())
  let re = %re("/\//g")
  Js.String.replaceByRe(re, "-", Js.Date.toLocaleDateString(date))
}

let mToKm = (~distance: float) => {
  distance /. 1000.0
}

let sToMin = (~time: float) => {
  time /. 60.0
}

// React
let emptyFocus = (dispatch) => {
  Js.log("focus - empty")
  dispatch(DataContext.Action.SetFocus(DataContext.Focus.Empty))
}

let getInnerWidth: unit => int = %raw(`() => window.innerWidth`)

@scope("document") @val
external addDocumentEventListener: (string, ReactEvent.Mouse.t => unit) => unit = "addEventListener"

@scope("document") @val
external removeDocumentEventListener: (string, ReactEvent.Mouse.t => unit) => unit = "removeEventListener"
