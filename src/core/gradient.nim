import raylib as rl
import math

proc gradient*(width: int32, height: int32, direction: float32, colorFrom: rl.Color, colorTo: rl.Color): rl.Texture2D =
  var image = rl.genImageColor(width, height, colorFrom)
  let
      angle = float(direction) * PI / 180.0
      cosAngle = cos(angle)
      sinAngle = sin(angle)
      # Максимальная проекция размеров на направление градиента
      maxProj = float(width) * abs(cosAngle) + float(height) * abs(sinAngle)
      maxDist = maxProj / 2.0

  for y in 0..<height:
    for x in 0..<width:
      # Проекция точки на направление градиента
      let
        dx = float(x) - float(width)/2.0
        dy = float(y) - float(height)/2.0
        dist = dx * cosAngle + dy * sinAngle
        t = clamp((dist + maxDist) / (2 * maxDist), 0.0, 1.0)
      
      # Интерполяция цвета
      let color = rl.Color(
        r: uint8(float(colorFrom.r) * (1.0 - t) + float(colorTo.r) * t),
        g: uint8(float(colorFrom.g) * (1.0 - t) + float(colorTo.g) * t),
        b: uint8(float(colorFrom.b) * (1.0 - t) + float(colorTo.b) * t),
        a: uint8(float(colorFrom.a) * (1.0 - t) + float(colorTo.a) * t)
      )
      
      image.imageDrawPixel(x.cint, y.cint, color)
  
  return rl.loadTextureFromImage(image)