import private/library

type
  AllegroDisplayMode* = object ## \
    ## Used for fullscreen mode queries. Contains
    ## information about a supported fullscreen modes.
    ## 
    ## The `refreshRate` may be zero if unknown.
    width*, height*, format*, refreshRate*: cint

{.push importc, dynlib: library.allegro.}
proc al_get_num_display_modes(): cint
proc al_get_display_mode(index: cint, mode: var AllegroDisplayMode): AllegroDisplayMode
{.pop.}

proc availableDisplayModes*(): uint =
  ## Get the number of available fullscreen display modes for the current set of display
  ## parameters. This will use the values set with al_set_new_display_refresh_rate,
  ## and al_set_new_display_flags to find the number of modes that match. Settings the
  ## new display parameters to zero will give a list of all modes for the default driver.
  return al_get_num_display_modes().uint

proc newAllegroDisplayMode*(index: uint): AllegroDisplayMode =
  var mode = AllegroDisplayMode()
  discard al_get_display_mode(index.cint, mode)
  return mode
