import private/library

type
  AllegroDisplayMode* = object
    width*, height*, format*, refreshRate*: cint

{.push importc, dynlib: library.allegro.}
proc al_get_num_display_modes(): cint
proc al_get_display_mode(index: cint, mode: var AllegroDisplayMode): AllegroDisplayMode
{.pop.}

proc availableDisplayModes*(): uint =
  return al_get_num_display_modes().uint

proc newAllegroDisplayMode*(index: uint): AllegroDisplayMode =
  var mode = AllegroDisplayMode()
  discard al_get_display_mode(index.cint, mode)
  return mode
