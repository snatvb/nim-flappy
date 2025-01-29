type
  Size* = object
    width*: int32
    height*: int32
    
func area*(self: Size): int32 = self.width * self.height

func lerp*[T: SomeFloat](a, b: T, t: T): T =
  a * (T(1) - t) + b * t

  