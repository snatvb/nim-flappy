import raylib as rl
import ../core/sprite, ../core/math
import std/random

type GroundTile* = object
    position*: rl.Vector2
    sprite*: StaticSprite

proc generate*(x: float, y: float, amount: int32): seq[GroundTile] =
    result = @[]
    randomize()
    for i in 0..<amount:
      result.add(GroundTile(
        position: rl.Vector2(x: x + i.float * 32, y: y - 16),
        sprite: newStaticSprite(
          texture= rl.loadTexture("assets/pipe_n_ground.png"),
          size= Size(width: 32, height: 16),
          offset= (int32(32 * rand(0..1)), int32(48))
        ))
      )
      
proc draw*(self: GroundTile) =
    self.sprite.draw(self.position)