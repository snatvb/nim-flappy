import math

type
  Size* = object
    width*: int32
    height*: int32
    
func area*(self: Size): int32 = self.width * self.height

func precision*(value: float, factor: float): float = 
  return trunc(value * factor) / factor
  