import raylib as rl
import std/random
import ../scene, ../renderer as r
import ../core/sprite, ../core/math, ../core/ticker
import ../objects/tube, ../objects/ground

type
  Player = object
    position: rl.Vector2
    sprite: Sprite

var player: Player
var tubes: seq[Tube]
var tubes_pool: seq[Tube]
var speed = 100.float
var groundTiles: seq[GroundTile]

var renderer: Renderer

proc newTube(): Tube =
  var variant = int32(rand(0..3))
  var screenWidth = renderer.width.float
  var screenHeight = renderer.height.float
  var position = rl.Vector2(x: screenWidth + 32, y: screenHeight - 64)
  var size = Size(width: 32 , height: 48)
  var offset = (variant * 32, int32(0))

  if tubes_pool.len > 0:
    var tube = tubes_pool.pop()
    tube.position = position
    tube.sprite.offset = offset
    result = tube
  else:
    randomize()
    result = Tube(
      position: position,
      sprite: newStaticSprite(
        texture= rl.loadTexture("assets/pipe_n_ground.png"),
        size= size,
        offset= offset,
      )
    )
    
proc freeTube(index: int) =
  tubes_pool.add(move(tubes[index]))
  tubes.del(index)
  
proc spawnTube() 
var spawnTicker = newTicker(spawnTube, 1.float32)

proc spawnTube =
  tubes.add(newTube())
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

  tubes.add(newTube())
  randomize()
  let amount = renderer.width div 32 + 2
  groundTiles = ground.generate(0, renderer.height.float - 16, amount)

proc unload* =
  tubes.setLen(0)
  tubes_pool.setLen(0)
  groundTiles.setLen(0)
  renderer = nil

proc update* = 
  rl.drawText(
    "PRESS [SPACE] TO JUMP", renderer.width div 2 -
    rl.measureText("PRESS [SPACE] TO JUMP", 20) div 2,
    30, 20, White
  )
  let delta = rl.getFrameTime()
  player.sprite.tick(delta)
  player.sprite.draw(player.position)
  
  var toRemove: seq[int]
  for i in 0..<tubes.len:
    tubes[i].update(speed, delta)
    tubes[i].draw()
    if tubes[i].position.x < -32:
      toRemove.add(i)
      
  for i in 0..<toRemove.len:
    freeTube(toRemove[i])
    
  for i in 0..<groundTiles.len:
    groundTiles[i].draw()

  spawnTicker.update(delta)

const def* = Scene(
  name: "game",
  load: load,
  getRenderer: proc(): r.Renderer = renderer,
  update: update,
  unload: unload,
)
