import raylib as rl
import ../core/sprite, ../core/extra_math

type
  Player* = object
    position*: rl.Vector2
    sprite*: Sprite
    velocity*: float32
    maxVelocity*: float32 = 10
    
proc update*(self: var Player, delta: float32) =
  self.velocity = lerp(self.velocity, self.maxVelocity, min(0.8, delta * 0.4))
  self.position.y += self.velocity
  self.sprite.rotation = self.velocity * 20
  
proc jump*(self: var Player) =
  self.velocity = -2

proc draw*(self: var Player, delta: float32) =
  self.sprite.tick(delta)
  self.sprite.draw(self.position)