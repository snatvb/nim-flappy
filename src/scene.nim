import tables
import renderer

type Scene* = object
  name*: string
  getRenderer*: proc(): Renderer
  load*: proc ()
  draw*: proc ()
  update*: proc ()
  unload*: proc ()
  
var current: Scene
var scenes: Table[string, Scene]

proc init*(scene_list: seq[Scene], initScene: Scene) =
  for scene in scene_list:
    scenes[scene.name] = scene
  current = initScene
  current.load()

proc switch*(scene: string) =
  echo "switching to" & scene
  current.unload()
  if not scenes.hasKey(scene):
    echo "scene not found" & scene
    return
  current = scenes[scene] 
  current.load()
  
proc tick* =
  current.update()
  
proc draw* =
  current.draw()

proc getRenderer*(): Renderer = current.getRenderer()