type
  Size* = object
    width*: int32
    height*: int32
    
func area*(self: Size): int32 = self.width * self.height