import raylib as rl
import ../core/sprite

type
  TubeType* {.size: sizeof(int8).} = enum
    Top, Bottom

  Tube* = object
    kind*: TubeType
    visited*: bool
    position*: rl.Vector2
    sprite*: StaticSprite

proc update*(tube: var Tube, speed: float, delta: float) =
  tube.position.x -= speed * delta

proc draw*(self: Tube) =
  self.sprite.draw(self.position)
  