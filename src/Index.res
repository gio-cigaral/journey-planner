switch ReactDOM.querySelector("#root") {
| Some(root) => ReactDOM.render(
  <DataProvider>
    <App />
  </DataProvider>, root)
| None => ()
}
