import raylib as rl
import std/strformat
import ../core/extra_math

type
  Score* = object
    value: int
    scale: float32

const FONT_SIZE = 20

proc draw*(self: var Score, delta: float32, sWidth: int32) =
  let text = fmt"{self.value}"
  let fontSize = int32(FONT_SIZE * self.scale)
  rl.drawText(
    text,
    sWidth div 2 - rl.measureText(text, fontSize) div 2,
    20,
    fontSize,
    White
  )
  self.scale = lerp(self.scale, 1.0, 0.1 * delta)
  
proc increment*(self: var Score) =
  self.value += 1
  self.scale = 1.5
  if self.value mod 5 == 0:
    self.scale = 2.0