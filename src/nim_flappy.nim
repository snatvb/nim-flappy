import raylib
import scenes/welcome, scenes/game
import scene
import renderer

const
  screenWidth = 1280
  screenHeight = 720

var target: RenderTexture2D

proc draw =
  beginDrawing()
  clearBackground(Black)
  endDrawing()

proc initGame =
  scene.init(@[welcome.def, game.def], welcome.def)

proc unloadGame = discard

proc tick =
  var renderer = scene.getRenderer()
  renderer.beginMode()
  scene.tick()
  renderer.endMode()

  beginDrawing()
  clearBackground(Black)
  renderer.draw()
  endDrawing()

proc main =
  # Initialization
  # --------------------------------------------------------------------------------------
  initWindow(screenWidth, screenHeight, "classic game: floppy")
  defer:
    unloadGame() # Unload loaded data (textures, sounds, models...)
    closeWindow()

  target = loadRenderTexture(320, 260)

  setTextureFilter(target.texture, TextureFilter.Point)
  initGame()
  when defined(emscripten):
    emscriptenSetMainLoop(tick, 60, 1)
  else:
    setTargetFPS(60)
    while not windowShouldClose(): # Detect window close button or ESC key
      tick()
    
  
main()

when isMainModule:
  echo("Hello, World!")
