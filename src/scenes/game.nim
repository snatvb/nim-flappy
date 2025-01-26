import raylib as rl
import ../scene
import ../core/sprite, ../core/math

type
  Player = object
    position: rl.Vector2
    sprite: Sprite

var player: Player

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

proc unload* =
  discard
  # rl.unloadTexture(player.texture)

proc update* = 
  rl.drawText(
    "PRESS [SPACE] TO JUMP", rl.getScreenWidth() div 2 -
    rl.measureText("PRESS [SPACE] TO JUMP", 20) div 2,
    rl.getScreenHeight() - 50, 20, White
  )
  player.sprite.tick(rl.getFrameTime())
  player.sprite.draw(player.position)


const def* = Scene(
  name: "game",
  load: load,
  update: update,
  unload: unload,
)
