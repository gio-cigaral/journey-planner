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

  let activeItineraryButton = (~index) => {
    if (index === dataState.activeItinerary) {
      "bg-gray-600"
    } else {
      "bg-gray-300"
    }
  }

  let itinerarySwitchButtons = 
    itineraries
    ->Belt.Array.mapWithIndex((index, _) => {
      <li
        key=`itinerary-button-${Belt.Int.toString(index)}`
        className=`flex flex-col grow justify-center h-full text-center text-radiola-light-grey cursor-pointer ${activeItineraryButton(~index)} hover:bg-gray-600`
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

    <div id="details-content" className="p-4">
      <div className="truncate pb-2">
        <b>{React.string("From: ")}</b>
        {React.string(directionState.origin)}
      </div>

      <div className="truncate pb-2">
        <b>{React.string("To: ")}</b>
        {React.string(directionState.destination)}
      </div>

      <div className="flex flex-row justify-around pb-2">
        <div>
          <b>{React.string("Leave: ")}</b>
          {
            React.string(switch activeItinerary.startTime {
              | Some(time) => Util.getReadableTime(~time=Belt.Int.toFloat(time))
              | None => "N/A"
              })
          }
        </div>

        <div>
          <b>{React.string("Arrive: ")}</b>
          {
            React.string(switch activeItinerary.endTime {
              | Some(time) => Util.getReadableTime(~time=Belt.Int.toFloat(time))
              | None => "N/A"
              })
          }
        </div>
      </div>

      <hr />

      
    </div>
  </div>
}
