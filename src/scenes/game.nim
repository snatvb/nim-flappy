import raylib as rl
import std/random
import ../scene, ../renderer as r
import ../core/sprite, ../core/extra_math, ../core/ticker, ../core/refs, ../core/gradient
import ../objects/tube, ../objects/ground

type
  Player = object
    position: rl.Vector2
    sprite: Sprite
    
  TubeType = enum
    Top, Bottom
    
  Env = object
    background: StaticSprite
    foreground: StaticSprite
    withHint: bool

const LAYERS = 4
const SKY_COLOR = rl.Color(r:0, g:57, b:109, a:255)

var player: Player
var tubes: seq[Tube]
var tubesPool: seq[Tube]
var speed = 100.float
var groundTiles: seq[GroundTile]
var env: Env

var renderer: Renderer

# func takeFlip(kind: TubeType): FlipDirection =
#   if kind == TubeType.Bottom:
#     result = FlipDirection.Flipped
#   else:
#     result = FlipDirection.Normal

var tubeOffsets = @[0, 4, 8, -8, 12, -12]

proc newTube(kind: TubeType, tubeOffset: float32): Tube =
  randomize()
  var variant = int32(rand(0..3))
  var screenWidth = renderer.width.float
  var screenHeight = renderer.height.float

  var top =
    if kind == TubeType.Bottom:
      (screenHeight - 32 * (LAYERS - 1) + 24) - tubeOffset
    else:
      16 - tubeOffset
  var position = rl.Vector2(x: screenWidth + 32, y: top)
  var size = Size(width: 32 , height: 48)
  var offset = (variant * 32, int32(0))
  var flipY = if kind == TubeType.Bottom: FlipDirection.Normal else: FlipDirection.Flipped

  if tubesPool.len > 0:
    var tube = tubesPool.pop()
    tube.position = position
    tube.sprite.offset = offset
    tube.sprite.flipY(flipY)
    result = tube
  else:
    var tube = Tube(
      position: position,
      sprite: newStaticSprite(
        texture= newRef(rl.loadTexture("assets/pipe_n_ground.png")),
        size= size,
        offset= offset,
      )
    )
    tube.sprite.flipY(flipY)
    result = tube
    
proc freeTube(index: int) =
  tubesPool.add(move(tubes[index]))
  tubes.del(index)
  
proc spawnTubes() 
var spawnTicker = newTicker(spawnTubes, 1.float32)

proc spawnTubes =
  let tubeOffset = sample(tubeOffsets).float32
  tubes.add(newTube(TubeType.Top, tubeOffset))
  tubes.add(newTube(TubeType.Bottom, tubeOffset))
  var newInterval = rand(1000..2000).float32 / 1000
  spawnTicker.updateInterval(newInterval)

proc load* =
  renderer = newRenderer(getScreenWidth() div 4, getScreenHeight() div 4)
  player = Player(
    position: rl.Vector2(x:100, y:100),
    sprite: sprite.newSprite(
      texture= newRef(rl.loadTexture("assets/birds.png")),
      size= Size(width: 16, height: 16),
      animationSpeed= 0.1,
      frames= 4,
    )
  )

  let amount = renderer.width div 32 + 2
  groundTiles = ground.generate(0, renderer.height.float, amount, LAYERS)
  
  let bgTexture = newRef(rl.loadTexture("assets/background/background3.png"))
  let fgGradient = newRef(gradient(
    renderer.width,
    64,
    90,
    SKY_COLOR,
    rl.Color(r:SKY_COLOR.r, g:SKY_COLOR.g, b:SKY_COLOR.b, a:0))
  )
  env = Env(
    background: newStaticSprite(
      texture= bgTexture,
      size= Size(width: renderer.width, height: renderer.height),
    ),
    foreground: newStaticSprite(
      texture= fgGradient,
      size= Size(width: renderer.width, height: 64),
    ),
    withHint: true,
  )

proc unload* =
  tubes.setLen(0)
  tubesPool.setLen(0)
  groundTiles.setLen(0)
  renderer = nil

proc update* = 
  let delta = rl.getFrameTime()

  for i in 0..<groundTiles.len:
    groundTiles[i].update(speed , delta, groundTiles.len div LAYERS)

  player.sprite.tick(delta)
  
  var toRemove: seq[int]
  for i in 0..<tubes.len:
    tubes[i].update(speed, delta)
    if tubes[i].position.x < -32:
      toRemove.add(i)
      
  for i in countdown(toRemove.high, 0):
    freeTube(toRemove[i])

  spawnTicker.update(delta)

proc draw* =
  env.background.draw(rl.Vector2(x: 0, y: 0))

  for i in 0..<tubes.len:
    tubes[i].draw()

  for i in 0..<groundTiles.len:
    groundTiles[i].draw()

  if env.withHint:
    const fontSize = 20
    rl.drawText(
      "PRESS [SPACE] TO JUMP", renderer.width div 2 -
      rl.measureText("PRESS [SPACE] TO JUMP", fontSize) div 2,
      renderer.height - 32, fontSize, White
    )

  player.sprite.draw(player.position)
    
  rl.drawRectangle(0, 0, renderer.width, 16, SKY_COLOR)
  env.foreground.draw(rl.Vector2(x: 0, y: 16))


const def* = Scene(
  name: "game",
  load: load,
  getRenderer: proc(): r.Renderer = renderer,
  draw: draw,
  update: update,
  unload: unload,
)
