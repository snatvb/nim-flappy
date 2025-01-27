import raylib as rl

type Renderer* = ref object
  width*: int32
  height*: int32
  target: rl.RenderTexture2D
  source: rl.Rectangle
  dest: rl.Rectangle

proc updateRects(self: var Renderer, width: int32, height: int32) =
  let screenWidth = rl.getScreenWidth()
  let screenHeight = rl.getScreenHeight()
  let scale = min(float32(screenWidth) / float32(width), float32(screenHeight) / float32(height))
  let marginX = (screenWidth - int32(float32(width) * scale)) div 2
  let marginY = (screenHeight - int32(float32(height) * scale)) div 2
  self.source = Rectangle(x: 0.0, y: 0.0, width: float32(width), height: -float32(height))
  self.dest = Rectangle(x: float32(marginX), y: float32(marginY), width: float32(width) * scale, height: float32(height) * scale)
  
proc newRenderer*(width: int32, height: int32): Renderer =
  result = Renderer(
    width: width,
    height: height,
    target: rl.loadRenderTexture(width, height)
  )
  result.updateRects(width, height)
  
proc beginMode*(self: var Renderer) =
  rl.beginTextureMode(self.target)
  clearBackground(rl.Black)
  
proc endMode*(self: var Renderer) =
  rl.endTextureMode()
  
proc resize*(self: var Renderer, width: int32, height: int32) =
  self.width = width
  self.height = height
  self.target = rl.loadRenderTexture(width, height)

  self.updateRects(width, height)


proc draw*(self: Renderer) =
  drawTexture(
    self.target.texture,
    self.source,
    self.dest,
    Vector2(x: 0.0, y: 0.0),
    0.0,
    WHITE
  )