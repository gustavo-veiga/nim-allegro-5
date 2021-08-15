import private/library

type
  AllegroTimeout* = object
    pad1*, pad2*: uint64

{.push importc, dynlib: library.allegro.}
proc al_get_time(): cdouble
proc al_rest(seconds: cdouble): void
proc al_init_timeout(timeout: var AllegroTimeout, seconds: cdouble): void
{.pop.}

proc time*(): float =
  return al_get_time().cdouble

proc rest*(seconds: float): void =
  al_rest(seconds.cdouble)

proc newAllegroTimeout*(seconds: float): AllegroTimeout =
  var timeout = AllegroTimeout()
  al_init_timeout(timeout, seconds.cdouble)
  return timeout
