module Stop = {
  type t = {
    id: string,
    code: option<string>,
    name: string,
    lat: float,
    lon: float
  }
}