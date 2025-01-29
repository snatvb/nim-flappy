import extra_math
import raylib as rl

func hitTest*(aPos, bPos: Vector2, aSize, bSize: Size): bool =
  let
    r1Right = aPos.x + aSize.width.float32
    r1Bottom = aPos.y + aSize.height.float32
    r2Right = bPos.x + bSize.width.float32
    r2Bottom = bPos.y + bSize.height.float32

  not (r1Right < bPos.x or
      aPos.x > r2Right or
      r1Bottom < bPos.y or
      aPos.y > r2Bottom)