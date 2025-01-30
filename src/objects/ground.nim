import raylib as rl
import ../core/sprite, ../core/extra_math, ../core/refs
import os,std/random

type GroundTile* = object
    position*: rl.Vector2
    sprite*: StaticSprite

let exeDir = getAppDir()
proc generate*(x: float, y: float, amount: int32, layers: int): seq[GroundTile] =
    result = @[]
    randomize()
    let texture = newRef(rl.loadTexture(exeDir / "assets" / "pipe_n_ground.png"))   
    const width = 32
    const height = 16
    const size = Size(width: width, height: height)
    for i in 0..<amount:
      for j in 0..<layers:
        let yOffset = if j == layers - 1: 48 else: 64
        echo yOffset, " ", j, " ", y - height * j.float32
        result.add(GroundTile(
          position: rl.Vector2(x: x + i.float * width, y: y - height * j.float32),
          sprite: newStaticSprite(
            texture = texture,
            size = size,
            offset= (int32(width * rand(0..1)), int32(yOffset))
          ))
        )
      
proc draw*(self: GroundTile) =
    self.sprite.draw(self.position)
    
proc update*(self: var GroundTile, speed: float, delta: float, amount: int) =
    self.position.x -= speed * delta 
    if self.position.x < -32:
      let rest = self.position.x + 32
      self.position.x = (amount * 32 - 32).float + rest