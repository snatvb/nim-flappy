import raylib as rl
import extra_math

# TODO: Compose static sprite with Sprite

type
  Direction* {.size: sizeof(int8).} = enum 
    Right, Left, Up, Down

  Sprite* = object
    size*: Size
    offset*: (int32, int32)
    texture*: ref rl.Texture2D
    origin*: rl.Vector2
    frames*: int16
    currentFrame*: int16
    animationSpeed*: float32
    direction: Direction
    restTime: float32
    rotation*: float32
    rect: rl.Rectangle
  
  StaticSprite* = object
    size*: Size
    offset*: (int32, int32)
    texture*: ref rl.Texture2D
    origin*: rl.Vector2
    rect*: rl.Rectangle
    rotation*: float32
  
  FlipDirection* {.size: sizeof(int8).} = enum
    Normal = -1, Flipped = 1
    
    
func newSprite*(texture: ref rl.Texture2D, size: Size, frames: int16, offset: (int32, int32) = (0, 0), frame:int16 = 0, animationSpeed = 0.2): Sprite =
  Sprite(
    texture: texture,
    size: size,
    frames: frames,
    currentFrame: frame,
    animationSpeed: animationSpeed,
    direction: Direction.Right,
    restTime: 0,
    rect: rl.Rectangle(
      x: offset[0].float32,
      y: offset[1].float32,
      width: size.width.float32,
      height: size.height.float32
    )
  )

proc tick*(self: var Sprite, delta: float32) =
  if self.restTime > 0:
    self.restTime -= delta
    return
    
  self.restTime = self.animationSpeed
  self.currentFrame += 1
  if self.currentFrame >= self.frames:
    self.currentFrame = 0
  self.rect.x = self.offset[0].float32 + self.size.width.float32 * self.currentFrame.float32
  self.rect.y = self.offset[1].float32
  
proc draw*(self: Sprite, position: rl.Vector2) =
  rl.drawTexture(self.texture[], self.rect, rl.Rectangle(x: position.x, y: position.y, width: self.size.width.float32, height: self.size.height.float32), self.origin, self.rotation, rl.White)

proc newStaticSprite*(texture: ref rl.Texture2D, size: Size, offset: (int32, int32) = (0, 0)): StaticSprite =
  StaticSprite(
    texture: texture,
    size: size,
    offset: offset,
    rect: rl.Rectangle(
      x: offset[0].float32,
      y: offset[1].float32,
      width: size.width.float32,
      height: size.height.float32
    )
  )

proc draw*(self: StaticSprite, position: rl.Vector2) =
  rl.drawTexture(self.texture[], self.rect, rl.Rectangle(x: position.x, y: position.y, width: self.size.width.float32, height: self.size.height.float32), self.origin, self.rotation, rl.White)
  
proc flipX*(self: var StaticSprite, direction: FlipDirection) =
  if direction == FlipDirection.Normal:
    if self.rect.width < 0:
      self.rect.x *= -1
  else:
    if self.rect.width > 0:
      self.rect.x *= -1

proc flipY(self: var StaticSprite) =
  self.rect.height *= -1

proc flipY*(self: var StaticSprite, direction: FlipDirection) =
  if direction == FlipDirection.Normal:
    if self.rect.height < 0:
      self.flipY()
  else:
    if self.rect.height > 0:
      self.flipY()