import raylib as rl
import ../scene

proc load* = discard
proc update* = 
  rl.drawText(
    "PRESS [SPACE] TO PLAY", rl.getScreenWidth() div 2 -
    rl.measureText("PRESS [SPACE] TO PLAY", 20) div 2,
    rl.getScreenHeight() div 2 - 50, 20, Gray
  )
  if rl.isKeyDown(rl.Space):
    echo "space pressed"
    scene.switch("game")

proc unload* = discard

const def* = Scene(
  name: "welcome",
  load: load,
  update: update,
  unload: unload,
)
