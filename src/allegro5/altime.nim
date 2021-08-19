import private/library

type
  AllegroTimeout* = object ## \
    ## Represent a timeout value. The size of the structure
    ## is known so it can be statically allocated.
    pad1*, pad2*: uint64

{.push importc, dynlib: library.allegro.}
proc al_get_time(): cdouble
proc al_rest(seconds: cdouble): void
proc al_init_timeout(timeout: var AllegroTimeout, seconds: cdouble): void
{.pop.}

proc time*(): float64 =
  ## Return the number of seconds since the Allegro library was initialised. The
  ## return value is undefined if Allegro is uninitialised. The resolution
  ## depends on the used driver, but typically can be in the order of microseconds.
  return al_get_time().float64

proc restTime*(seconds: float64): void =
  ## Waits for the specified number of seconds. This tells the system to pause the
  ## current thread for the given amount of time. With some operating systems, the
  ## accuracy can be in the order of 10ms. That is, even `restTime(0.000001) might
  ## pause for something like 10ms. Also see the section on Timer routines for
  ## easier ways to time your program without using up all CPU.
  al_rest(seconds.cdouble)

proc newAllegroTimeout*(seconds: float64): AllegroTimeout =
  ## Set timeout value of some number of seconds after the function call. For
  ## compatibility with all platforms, seconds must be 2,147,483.647 seconds or less.
  var timeout = AllegroTimeout()
  al_init_timeout(timeout, seconds.cdouble)
  return timeout
