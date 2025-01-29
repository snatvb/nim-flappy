import raylib as rl
import std/random
import ../scene, ../renderer as r
import ../core/sprite, ../core/extra_math, ../core/ticker
import ../objects/tube, ../objects/ground

type
  Player = object
    position: rl.Vector2
    sprite: Sprite
    
  TubeType = enum
    Top, Bottom

var player: Player
var tubes: seq[Tube]
var tubes_pool: seq[Tube]
var speed = 100.float
var groundTiles: seq[GroundTile]

var renderer: Renderer

# func takeFlip(kind: TubeType): FlipDirection =
#   if kind == TubeType.Bottom:
#     result = FlipDirection.Flipped
#   else:
#     result = FlipDirection.Normal

proc newTube(kind: TubeType): Tube =
  randomize()
  var variant = int32(rand(0..3))
  var screenWidth = renderer.width.float
  var screenHeight = renderer.height.float

  var top = if kind == TubeType.Bottom: screenHeight - 32 * 3 + 12 else: 0
  var position = rl.Vector2(x: screenWidth + 32, y: top)
  var size = Size(width: 32 , height: 48)
  var offset = (variant * 32, int32(0))
  var flipY = if kind == TubeType.Bottom: FlipDirection.Normal else: FlipDirection.Flipped

  if tubes_pool.len > 0:
    var tube = tubes_pool.pop()
    tube.position = position
    tube.sprite.offset = offset
    tube.sprite.flipY(flipY)
    result = tube
  else:
    var tube = Tube(
      position: position,
      sprite: newStaticSprite(
        texture= rl.loadTexture("assets/pipe_n_ground.png"),
        size= size,
        offset= offset,
      )
    )
    tube.sprite.flipY(flipY)
    result = tube
    
proc freeTube(index: int) =
  tubes_pool.add(move(tubes[index]))
  tubes.del(index)
  
proc spawnTubes() 
var spawnTicker = newTicker(spawnTubes, 1.float32)

proc spawnTubes =
  tubes.add(newTube(TubeType.Top))
  tubes.add(newTube(TubeType.Bottom))
  var newInterval = rand(1000..2000).float32 / 1000
  spawnTicker.updateInterval(newInterval)

proc load* =
  renderer = newRenderer(getScreenWidth() div 3, getScreenHeight() div 3)
  player = Player(
    position: rl.Vector2(x:100, y:100),
    sprite: sprite.newSprite(
      texture= rl.loadTexture("assets/birds.png"),
      size= Size(width: 16, height: 16),
      animationSpeed= 0.1,
      frames= 4,
    )
  )

  let amount = renderer.width div 32 + 2
  groundTiles = ground.generate(0, renderer.height.float, amount)

proc unload* =
  tubes.setLen(0)
  tubes_pool.setLen(0)
  groundTiles.setLen(0)
  renderer = nil

proc update* = 
  let delta = rl.getFrameTime()

  for i in 0..<groundTiles.len:
    groundTiles[i].update(speed , delta, groundTiles.len div 3)

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
  rl.drawText(
    "PRESS [SPACE] TO JUMP", renderer.width div 2 -
    rl.measureText("PRESS [SPACE] TO JUMP", 20) div 2,
    30, 20, White
  )

  for i in 0..<groundTiles.len:
    groundTiles[i].draw()

  player.sprite.draw(player.position)

  for i in 0..<tubes.len:
    tubes[i].draw()


const def* = Scene(
  name: "game",
  load: load,
  getRenderer: proc(): r.Renderer = renderer,
  draw: draw,
  update: update,
  unload: unload,
)
