import raylib as rl

type
  Size* = object
    width*: int32
    height*: int32
    
func area*(self: Size): int32 = self.width * self.height

func lerp*[T: SomeFloat](a, b: T, t: T): T =
  a * (T(1) - t) + b * t

proc `+`*(a, b: rl.Vector2): rl.Vector2 = rl.Vector2(x: a.x + b.x, y: a.y + b.y)
proc `-`*(a, b: rl.Vector2): rl.Vector2 = rl.Vector2(x: a.x - b.x, y: a.y - b.y)
proc `*`*(vec: rl.Vector2, scalar: float32): rl.Vector2 = rl.Vector2(x: vec.x * scalar, y: vec.y * scalar)