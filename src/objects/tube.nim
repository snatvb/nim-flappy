import raylib as rl
import ../core/sprite

type
  Tube* = object
    position*: rl.Vector2
    sprite*: StaticSprite

proc update*(tube: var Tube, speed: float, delta: float) =
  tube.position.x -= speed * delta

proc draw*(self: Tube) =
  self.sprite.draw(self.position)
  