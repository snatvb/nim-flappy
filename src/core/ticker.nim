type
  Ticker* = object
    tick: proc()
    interval*: float32
    time*: float32
    last*: float32
    
proc newTicker*(tick: proc(); interval: float32): Ticker =
  result.tick = tick
  result.interval = interval
  result.time = 0
  result.last = 0

proc update*(ticker: var Ticker, delta: float32) =
  ticker.time += delta
  if ticker.time - ticker.last >= ticker.interval:
    ticker.last = ticker.time
    ticker.tick()

proc updateInterval*(ticker: var Ticker, interval: float32) =
  ticker.interval = interval
  ticker.last = ticker.time
