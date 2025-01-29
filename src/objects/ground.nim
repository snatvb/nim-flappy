import raylib as rl
import ../core/sprite, ../core/math
import std/random

type GroundTile* = object
    position*: rl.Vector2
    sprite*: StaticSprite

proc generate*(x: float, y: float, amount: int32): seq[GroundTile] =
    result = @[]
    randomize()
    const width = 32
    const height = 16
    const size = Size(width: width, height: height)
    for i in 0..<amount:
      result.add(GroundTile(
        position: rl.Vector2(x: x + i.float * width, y: y - height * 3),
        sprite: newStaticSprite(
          texture= rl.loadTexture("assets/pipe_n_ground.png"),
          size= size,
          offset= (int32(32 * rand(0..1)), int32(48))
        ))
      )
      result.add(GroundTile(
        position: rl.Vector2(x: x + i.float * width, y: y - height * 2),
        sprite: newStaticSprite(
          texture= rl.loadTexture("assets/pipe_n_ground.png"),
          size= size,
          offset= (int32(32 * rand(0..1)), int32(64))
        ))
      )
      result.add(GroundTile(
        position: rl.Vector2(x: x + i.float * width, y: y - height),
        sprite: newStaticSprite(
          texture= rl.loadTexture("assets/pipe_n_ground.png"),
          size= size,
          offset= (int32(32 * rand(0..1)), int32(64))
        ))
      )
      
proc draw*(self: GroundTile) =
    self.sprite.draw(self.position)