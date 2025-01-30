import raylib as rl
import std/strformat
import ../core/extra_math

type
  Score* = object
    value: int
    scale: float32 = 1
    color: Color = White

const FONT_SIZE = 20

proc draw*(self: var Score, delta: float32, sWidth: int32) =
  let text = fmt"{self.value}"
  let fontSize = int32(FONT_SIZE * self.scale)
  rl.drawText(
    text,
    sWidth div 2 - rl.measureText(text, fontSize) div 2,
    20,
    fontSize,
    self.color
  )
  self.scale = lerp(self.scale, 1.0, 0.3)
  self.color = colorLerp(self.color, White, 0.05)
  
proc increment*(self: var Score) =
  self.value += 1
  self.scale = 1.5
  if self.value mod 5 == 0:
    self.color = rl.Color(r: 200, g: 10, b: 10, a: 255)
    self.scale = 3.0