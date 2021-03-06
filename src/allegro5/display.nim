import std/sequtils, private/library, bitmap, event_source

type
  AllegroDisplay* = ptr object
  AllegroWindowConstraints* = object
    minWidth*, minHeight*, maxWidth*, maxHeight*: int32
  AllegroDisplayFlag* {.pure, final.} = enum
    windowed                = 1 shl 0
    fullscreen              = 1 shl 1
    openGL                  = 1 shl 2
    direct3DInternal        = 1 shl 3
    resizable               = 1 shl 4
    frameless               = 1 shl 5
    generateExposeEvents    = 1 shl 6
    openGL3                 = 1 shl 7
    openGLForwardCompatible = 1 shl 8
    fullscreenWindow        = 1 shl 9
    minimized               = 1 shl 10
    programmablePipeline    = 1 shl 11
    gtkTopLevelInternal     = 1 shl 12
    maximized               = 1 shl 13
    openGLESProfile         = 1 shl 14
  AllegroDisplayOption* {.pure, final.} = enum
    redSize               = 0
    greenSize             = 1
    blueSize              = 2
    alphaSize             = 3
    redShift              = 4
    greenShift            = 5
    blueShift             = 6
    alphaShift            = 7
    accRedSize            = 8
    accGreenSize          = 9
    accBlueSize           = 10
    accAlphaSize          = 11
    stereo                = 12
    auxBuffers            = 13
    colorSize             = 14
    depthSize             = 15
    stencilSize           = 16
    sampleBuffers         = 17
    samples               = 18
    renderMethod          = 19
    floatColor            = 20
    floatDepth            = 21
    singleBuffer          = 22
    swapMethod            = 23
    compatibleDisplay     = 24
    updateDisplayRegion   = 25
    vsync                 = 26
    maxBitmapSize         = 27
    supportNpotBitmap     = 28
    canDrawIntoBitmap     = 29
    supportSeparateAlpha  = 30
    autoConvertBitmaps    = 31
    supportedOrientations = 32
    openGLMajorVersion    = 33
    openGLMinorVersion    = 34
    displayOptionsCount   = 35
  AllegroDisplayOrientation* {.pure, final.} = enum
    unknown    = 0
    degrees0   = 1
    degrees90  = 2
    degrees180 = 4
    portrait   = 6
    degrees270 = 8
    landscape  = 10
    all        = 15
    faceUp     = 16
    faceDown   = 32
  AllegroDisplayImportance* {.pure, final.} = enum
    dontcare  = 0
    require   = 1
    suggest   = 2

{.push importc, dynlib: library.allegro.}
proc al_set_new_display_refresh_rate(refreshRate: cint): void
proc al_set_new_display_flags(flags: cint): void
proc al_get_new_display_refresh_rate(): cint
proc al_get_new_display_flags(): cint

proc al_set_new_window_title(title: cstring): void
proc al_get_new_window_title(): cstring

proc al_get_display_width(display: AllegroDisplay): cint
proc al_get_display_height(display: AllegroDisplay): cint
proc al_get_display_format(display: AllegroDisplay): cint
proc al_get_display_refresh_rate(display: AllegroDisplay): cint
proc al_get_display_flags(display: AllegroDisplay): cint
proc al_get_display_orientation(display: AllegroDisplay): cint
proc al_set_display_flag(display: AllegroDisplay, flag: cint, onOff: bool): bool

proc al_create_display(w, h: cint): AllegroDisplay
proc al_destroy_display(display: AllegroDisplay): void
proc al_get_current_display(): AllegroDisplay
proc al_set_target_bitmap(bitmap: AllegroBitmap): void
proc al_set_target_backbuffer(display: AllegroDisplay): void
proc al_get_backbuffer(display: AllegroDisplay): AllegroBitmap
proc al_get_target_bitmap(): AllegroBitmap

proc al_acknowledge_resize(display: AllegroDisplay): bool
proc al_resize_display(display: AllegroDisplay, width, height: cint): bool
proc al_flip_display(): void
proc al_update_display_region(x, y, width, height: cint): void
proc al_is_compatible_bitmap(bitmap: AllegroBitmap): bool

proc al_wait_for_vsync(): bool

proc al_get_display_event_source(display: AllegroDisplay): AllegroEventSource

proc al_set_display_icon(display: AllegroDisplay, icon: AllegroBitmap): void
proc al_set_display_icons(display: AllegroDisplay, num_icons: cint, icons: openArray[AllegroBitmap]): void

#[ Stuff for multihead/window management ]#
proc al_get_new_display_adapter(): cint
proc al_set_new_display_adapter(adapter: cint): void
proc al_set_new_window_position(x, y: cint): void
proc al_get_new_window_position(x, y: var cint): void
proc al_set_window_position(display: AllegroDisplay, x, y: cint): void
proc al_get_window_position(display: AllegroDisplay, x, y: var cint): void
proc al_set_window_constraints(display: AllegroDisplay, min_w, min_h, max_w, max_h: cint): bool
proc al_get_window_constraints(display: AllegroDisplay, min_w, min_h, max_w, max_h: var cint): bool
proc al_apply_window_constraints(display: AllegroDisplay, onoff: bool): void

proc al_set_window_title(display: AllegroDisplay, title: cstring): void

#[ Defined in display_settings.c ]#
proc al_set_new_display_option(option, value, importance: cint): void
proc al_get_new_display_option(option: cint, importance: var cint): cint
proc al_reset_new_display_options(): void
proc al_set_display_option(display: AllegroDisplay, option, value: cint): void
proc al_get_display_option(display: AllegroDisplay, option: cint): cint

#[ Deferred drawing ]#
proc al_hold_bitmap_drawing(hold: bool): void
proc al_is_bitmap_drawing_held(): bool

#[ Miscellaneous ]#
proc al_acknowledge_drawing_halt(display: AllegroDisplay): void
proc al_acknowledge_drawing_resume(display: AllegroDisplay): void
{.pop.}

proc newAllegroDisplayRefreshRate*(): uint =
  return al_get_new_display_refresh_rate().uint

proc newAllegroDisplayRefreshRate*(refreshRate: uint): void =
  al_set_new_display_refresh_rate(refreshRate.cint)

proc newAllegroDisplayFlags*(): int =
  return al_get_new_display_flags()

proc allegroDisplayFlags*(flags: varargs[AllegroDisplayFlag]): void =
  let flagInt = flags.mapIt(it.cint).foldl(a or b)
  if (flagInt > 0):
    al_set_new_display_flags(flagInt)

proc newAllegroWindowTitle*(): string =
  return $al_get_new_window_title()

proc newAllegroWindowTitle*(title: string): void =
  al_set_new_window_title(title)

proc newAllegroDisplay*(width, height: uint): AllegroDisplay =
  return al_create_display(width.cint, height.cint)

proc currentAllegroDisplay*(): AllegroDisplay =
  return al_get_current_display()

proc free*(display: AllegroDisplay): void =
  al_destroy_display(display)

proc resize*(display: AllegroDisplay, width, height: uint): void =
  discard al_resize_display(display, width.cint, height.cint)

proc width*(display: AllegroDisplay): uint =
  return al_get_display_width(display).uint

proc height*(display: AllegroDisplay): uint =
  return al_get_display_height(display).uint

proc width*(display: AllegroDisplay, width: uint): void =
  display.resize(width, display.height)

proc height*(display: AllegroDisplay, height: uint): void =
  display.resize(display.width, height)

proc format*(display: AllegroDisplay): int =
  return al_get_display_format(display)

proc acknowledgeResize*(display: AllegroDisplay): void =
  discard al_acknowledge_resize(display)

proc refreshRate*(display: AllegroDisplay): uint =
  al_get_display_refresh_rate(display).uint

proc flags*(display: AllegroDisplay): uint =
  return al_get_display_flags(display).uint

proc orientation*(display: AllegroDisplay): AllegroDisplayOrientation =
  return AllegroDisplayOrientation(al_get_display_orientation(display))

proc fullscreen*(display: AllegroDisplay, enable: bool): void =
  discard al_set_display_flag(display, AllegroDisplayFlag.fullscreenWindow.cint, enable)

proc frameless*(display: AllegroDisplay, enable: bool): void =
  discard al_set_display_flag(display, AllegroDisplayFlag.frameless.cint, enable)

proc maximized*(display: AllegroDisplay, enable: bool): void =
  discard al_set_display_flag(display, AllegroDisplayFlag.maximized.cint, enable)

proc target*(bitmap: AllegroBitmap): void =
  al_set_target_bitmap(bitmap)

proc targetBackbuffer*(display: AllegroDisplay): void =
  al_set_target_backbuffer(display)

proc backbuffer*(display: AllegroDisplay): AllegroBitmap =
  return al_get_backbuffer(display)

proc targetBitmap*(): AllegroBitmap =
  return al_get_target_bitmap()

proc flipDisplay*(): void =
  al_flip_display()

proc updateDisplayRegion*(x, y: int, width, height: uint): void =
  al_update_display_region(x.cint, y.cint, width.cint, height.cint)

proc isCompatible*(bitmap: AllegroBitmap): bool =
  return al_is_compatible_bitmap(bitmap)

proc waitForVSYNC*(): bool =
  return al_wait_for_vsync()

proc eventSource*(display: AllegroDisplay): AllegroEventSource =
  return al_get_display_event_source(display)

proc icon*(display: AllegroDisplay, icon: AllegroBitmap): void =
  al_set_display_icon(display, icon)

proc icon*(display: AllegroDisplay, icons: seq[AllegroBitmap]): void =
  al_set_display_icons(display, icons.len.cint, icons.toOpenArray(icons.minIndex, icons.maxIndex))

proc newAllegroDisplayAdapter*(): uint =
  return al_get_new_display_adapter().uint

proc newAllegroDisplayAdapter*(adapter: uint): void =
  al_set_new_display_adapter(adapter.cint)

proc newWindowPosition*(x, y: int): void =
  al_set_new_window_position(x.cint, y.cint)

proc newWindowPosition*(): tuple[x, y: int] =
  var x, y: cint = 0
  al_get_new_window_position(x, y)
  return (x.int, y.int)

proc position*(display: AllegroDisplay, x, y: int): void =
  al_set_window_position(display, x.cint, y.cint)

proc position*(display: AllegroDisplay): tuple[x, y: int] =
  var x, y: cint = 0
  al_get_window_position(display, x, y)
  return (x.int, y.int) 

proc windowConstraints*(display: AllegroDisplay, constraints: AllegroWindowConstraints): void =
  discard al_set_window_constraints(display, constraints.min_width.cint, constraints.min_height.cint, constraints.max_width.cint, constraints.max_height.cint)

proc windowConstraints*(display: AllegroDisplay): AllegroWindowConstraints =
  var minW, minH, maxW, maxH: cint = 0
  discard al_get_window_constraints(display, minW, minH, maxW, maxH) 
  result = AllegroWindowConstraints()
  result.minWidth = minW
  result.minHeight = minH
  result.maxHeight = maxH
  result.maxWidth = maxW

proc applyWindowConstraints*(display: AllegroDisplay, enable: bool): void =
  al_apply_window_constraints(display, enable)

proc title*(display: AllegroDisplay, title: string): void =
  al_set_window_title(display, title)

proc newDisplayOption*(option: AllegroDisplayOption, value: int32, importance: AllegroDisplayImportance): void =
  al_set_new_display_option(option.cint, value, importance.cint)

proc displayOption*(option: AllegroDisplayOption): tuple[value: int32, importance: AllegroDisplayImportance] =
  var importance: cint = 0
  var value = al_get_new_display_option(option.cint, importance)
  return (value, AllegroDisplayImportance(importance))

proc resetDisplayOptions*(): void =
  al_reset_new_display_options()

proc option*(display: AllegroDisplay, option: AllegroDisplayOption, value: int32): void =
  al_set_display_option(display, option.cint, value)

proc option*(display: AllegroDisplay, option: AllegroDisplayOption): int32 =
  al_get_display_option(display, option.cint)

proc holdBitmapDrawing*(hold: bool): void =
  al_hold_bitmap_drawing(hold)

proc isBitmapDrawingHeld*(): bool =
  al_is_bitmap_drawing_held()

proc acknowledgeDrawingHalt*(display: AllegroDisplay): void =
  al_acknowledge_drawing_halt(display)

proc acknowledgeDrawingResume*(display: AllegroDisplay): void =
  al_acknowledge_drawing_resume(display)
