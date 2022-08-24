@module("@googlemaps/polyline-codec") 
external decode: (
  ~encodedPath: string, 
  ~precision: int=?, 
  unit
) => array<array<float>> = "decode"