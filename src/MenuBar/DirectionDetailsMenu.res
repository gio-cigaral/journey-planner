@react.component
let make = () => {
  let (dataState, dataDispatch) = React.useContext(DataContext.context)
  
  <div>
    {React.string("Hello World")}
  </div>
}