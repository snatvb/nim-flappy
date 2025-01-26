import raylib
import scenes/welcome, scenes/game
import scene

const
  screenWidth = 800
  screenHeight = 450

  MaxTubes = 100
  FloppyRadius = 24
  TubeWidth = 80
  
  
proc draw =
  beginDrawing()
  clearBackground(Black)
  endDrawing()

proc initGame =
  scene.init(@[welcome.def, game.def], welcome.def)

proc unloadGame = discard

proc tick =
  beginDrawing()
  clearBackground(Black)
  scene.tick()
  endDrawing()

proc main =
  # Initialization
  # --------------------------------------------------------------------------------------
  initWindow(screenWidth, screenHeight, "classic game: floppy")
  defer:
    unloadGame() # Unload loaded data (textures, sounds, models...)
    closeWindow()

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
