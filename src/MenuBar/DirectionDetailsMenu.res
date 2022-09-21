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

  let legElements = 
    switch activeItinerary.legs {
    | Some(legs) => {
        legs
        ->Belt.Array.mapWithIndex((index, leg) => {
          let mode = 
            switch leg.mode {
            | Some(mode) => mode
            | None => ""
            }
          let distance = 
            switch leg.distance {
            | Some(distance) => Js.Float.toFixedWithPrecision(Util.mToKm(~distance), ~digits=2)
            | None => ""
            }
          let duration = Js.Float.toFixedWithPrecision(Util.sToMin(~time=leg.duration), ~digits=1)

          // TODO
          let walkSteps = 
            switch leg.steps {
            | Some(steps) => [React.null]
            | None => [React.null]
            }

          <div key=`leg-${Belt.Int.toString(index)}`>
            <b>{React.string(mode ++ " ")}</b>
            {React.string(distance ++ " km, " ++ duration ++ " mins")}
          </div>
        })
      }
    | None => [React.null]
    }
  
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

      <hr className="pb-2" />

      <div className="pb-2 text-xl">
        <b>{React.string("STEPS")}</b>
      </div>

      // TODO: add class to "steps" div to allow scrolling
      <div id="step-details">
        // For each leg show: [mode] [distance] [duration]
        {
          React.array(legElements)
        }
        // IF leg has steps show: [relativeDirection] on to [streetName] [distance]
      </div>
    </div>
  </div>
}
