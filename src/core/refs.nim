template newRef*[T](value: T): ref T =
  var result = new(T)
  result[] = value
  result

# import macros

# macro newRef*(value: typed): untyped =
#   let T = value.getType
#   quote do:
#     block:
#       var result = new(`T`)
#       result[] = `value`
#       result
