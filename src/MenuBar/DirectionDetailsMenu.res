@react.component
let make = (
  ~planData: Common.TripPlannerResponse.t
) => {
  let (dataState, dataDispatch) = React.useContext(DataContext.context)
  let (directionState, _) = React.useContext(DirectionMenuContext.context)

  let (_, setPlan) = React.useState(_ => planData)
  let (itineraries, setItineraries) = React.useState(_ => planData.plan.itineraries)
  let (activeItinerary, setActiveItinerary) = React.useState(_ => planData.plan.itineraries[dataState.activeItinerary])

  React.useEffect1(() => {
    setPlan(_ => planData)
    setItineraries(_ => planData.plan.itineraries)
    setActiveItinerary(_ => planData.plan.itineraries[dataState.activeItinerary])

    None
  }, [planData])

  React.useEffect1(() => {
    setActiveItinerary(_ => itineraries[dataState.activeItinerary])

    None
  }, [dataState.activeItinerary])

  let itinerarySwitchButtons = 
    itineraries
    ->Belt.Array.mapWithIndex((index, _) => {
      <li
        key=`itinerary-button-${Belt.Int.toString(index)}`
        className="flex flex-col grow justify-center h-full text-center text-radiola-light-grey cursor-pointer hover:bg-gray-600"
        onClick={_ => dataDispatch(DataContext.Action.SetActiveItinerary(index))}
      >
        {React.string(Belt.Int.toString(index))}
      </li>
    })
  
  <div>
    <ul id="details-header" className="flex flex-row justify-evenly w-full h-7 overflow-hidden bg-gray-300">
      <div className="w-1/4">
        <li 
          className="flex flex-col justify-center h-full text-center text-radiola-light-grey cursor-pointer hover:bg-gray-600"
          onClick={_ => {
            dataDispatch(DataContext.Action.SetPlan(None))
            dataDispatch(DataContext.Action.SetSelection(Directions(Input)))
          }}
        >
          <i className="fe fe-arrow-left" />
        </li>
      </div>

      <div className="w-3/4 flex flex-row justify-evenly">
        {
          React.array(itinerarySwitchButtons)
        }
      </div>
    </ul>

    <div id="details-content">
      {React.string("From: " ++ directionState.origin)}
      <br />
      {React.string("To: " ++ directionState.destination)}
      <br />
      {React.string("Leave: " ++ switch activeItinerary.startTime {
        | Some(time) => Js.Date.toUTCString(Js.Date.fromFloat(Belt.Int.toFloat(time)))
        | None => "00:00"
      })}
      <br />
      {React.string("Arrive: " ++ switch activeItinerary.endTime {
        | Some(time) => Js.Date.toUTCString(Js.Date.fromFloat(Belt.Int.toFloat(time)))
        | None => "00:00"
      })}
    </div>
  </div>
}
