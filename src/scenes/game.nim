import raylib as rl
import ../scene

proc load* = discard
proc update* = 
  rl.drawText(
    "PRESS [SPACE] TO JUMP", rl.getScreenWidth() div 2 -
    rl.measureText("PRESS [SPACE] TO JUMP", 20) div 2,
    rl.getScreenHeight() div 2 - 50, 20, White
  )

proc unload* = discard

const def* = Scene(
  name: "game",
  load: load,
  update: update,
  unload: unload,
)
