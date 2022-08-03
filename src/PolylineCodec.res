// ? May need to define a proper type here (note: cannot define array size) https://googlemaps.github.io/js-polyline-codec/modules.html#LatLngTuple
// type latlng = array<float>

// module LatLng = {
//   type t = array<float>

//   let make = () => []
// }

// ! array<float> TYPING IS WRONG => TYPING SHOULD BE array<array<float>> IT IS A 2D ARRAY (i.e. an array of coordinates)
@module("@googlemaps/polyline-codec") external decode: (~encodedPath: string, ~precision: int=?, unit) => array<float> = "decode"

// module Decode = {
//   type t = array<float>

//   @module("@googlemaps/polyline-codec") 
//   external make: (~encodedPath: string, ~precision: int=?, unit) => t = "decode"
// }