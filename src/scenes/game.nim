import raylib as rl
import std/random
import ../scene
import ../core/sprite, ../core/math
import ../objects/tube

type
  Player = object
    position: rl.Vector2
    sprite: Sprite
    
  GroundTile = object
    position: rl.Vector2
    sprite: StaticSprite

var player: Player
var tubes: seq[Tube]
var tubes_pool: seq[Tube]
var speed = 100.float
var ground: seq[GroundTile]

proc newTube(): Tube =
  if tubes_pool.len > 0:
    result = tubes_pool.pop()
  else:
    randomize()
    var variant = int32(rand(0..3))
    result = Tube(
      position: rl.Vector2(x: rl.getScreenWidth().float + 32, y: rl.getScreenHeight().float - 64),
      sprite: newStaticSprite(
        texture= rl.loadTexture("assets/pipe_n_ground.png"),
        size= Size(width: 32 , height: 48),
        offset= (variant * 32, int32(0))
      )
    )
    
proc load* =
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
  let amount = rl.getScreenWidth() div 32 + 2
  for i in 0..<amount:
    ground.add(GroundTile(
      position: rl.Vector2(x: i.float * 32, y: rl.getScreenHeight().float - 16),
      sprite: newStaticSprite(
        texture= rl.loadTexture("assets/pipe_n_ground.png"),
        size= Size(width: 32, height: 16),
        offset= (int32(32 * rand(0..1)), int32(48))
      )
    ))

proc unload* =
  tubes.setLen(0)
  tubes_pool.setLen(0)
  ground.setLen(0)

proc update* = 
  rl.drawText(
    "PRESS [SPACE] TO JUMP", rl.getScreenWidth() div 2 -
    rl.measureText("PRESS [SPACE] TO JUMP", 20) div 2,
    rl.getScreenHeight() - 50, 20, White
  )
  let delta = rl.getFrameTime()
  player.sprite.tick(delta)
  player.sprite.draw(player.position)
  
  for i in 0..<tubes.len:
    tubes[i].update(speed, delta)
    tubes[i].draw()
    
  for i in 0..<ground.len:
    ground[i].sprite.draw(ground[i].position)


const def* = Scene(
  name: "game",
  load: load,
  update: update,
  unload: unload,
)
