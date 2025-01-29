import raylib as rl
import ../scene, ../renderer as r

var renderer: Renderer

proc load* = 
  renderer = newRenderer(320, 260)

proc update* = 
  # rl.drawText(
  #   "PRESS [SPACE] TO PLAY", rl.getScreenWidth() div 2 -
  #   rl.measureText("PRESS [SPACE] TO PLAY", 20) div 2,
  #   rl.getScreenHeight() div 2 - 50, 20, Gray
  # )
  if rl.isKeyDown(rl.Space):
    echo "space pressed"
    scene.switch("game")

proc draw* =
  rl.drawText(
    "PRESS [SPACE] TO PLAY", 320 div 2 -
    rl.measureText("PRESS [SPACE] TO PLAY", 20) div 2,
    260 div 2 - 10, 20, Gray
  )


proc unload* =
  renderer = nil

const def* = Scene(
  name: "welcome",
  load: load,
  get_renderer: proc(): r.Renderer = renderer,
  draw: draw,
  update: update,
  unload: unload,
)
