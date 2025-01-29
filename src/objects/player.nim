import raylib as rl
import ../core/sprite

type
  Player* = object
    position*: rl.Vector2
    sprite*: Sprite
    velocity*: float32
    
proc update*(self: var Player, delta: float32) =
  self.position.y += self.velocity

proc draw*(self: var Player, delta: float32) =
  self.sprite.tick(delta)
  self.sprite.draw(self.position)