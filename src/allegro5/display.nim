import std/sequtils, private/library, bitmap, events

type
  AllegroDisplay* = ptr object
  AllegroWindowConstraints* = object
    min_width*, min_height*, max_width*, max_height*: int
  AllegroDisplayFlag* {.pure.} = enum
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
  AllegroDisplayOption* {.pure.} = enum
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
  AllegroDisplayOrientation* {.pure.} = enum
    unknown    = 0
    degrees    = 1
    degrees90  = 2
    degrees180 = 4
    portrait   = 6
    degrees270 = 8
    landscape  = 10
    all        = 15
    faceUp     = 16
    faceDown   = 32
  AllegroDisplayImportance* {.pure.} = enum
    dontcare  = 0
    require   = 1
    suggest   = 2

{.push dynlib: library.name.}
proc alSetNewDisplayRefreshRate(refreshRate: cint): void {.importc: "al_set_new_display_refresh_rate".}
proc alSetNewDisplayFlags(flags: cint): void {.importc: "al_set_new_display_flags".}
proc alGetNewDisplayRefreshRate(): cint {.importc: "al_get_new_display_refresh_rate".}
proc alGetNewDisplayFlags(): cint {.importc: "al_get_new_display_flags".}

proc alSetNewWindowTitle(title: cstring): void {.importc: "al_set_new_window_title".}
proc alGetNewWindowTitle(): cstring {.importc: "al_get_new_window_title".}

proc alGetDisplayWidth(display: AllegroDisplay): cint {.importc: "al_get_display_width".}
proc alGetDisplayHeight(display: AllegroDisplay): cint {.importc: "al_get_display_height".}
proc alGetDisplayFormat(display: AllegroDisplay): cint {.importc: "al_get_display_format".}
proc alGetDisplayRefreshRate(display: AllegroDisplay): cint {.importc: "al_get_display_refresh_rate".}
proc alGetDisplayFlags(display: AllegroDisplay): cint {.importc: "al_get_display_flags".}
proc alGetDisplayOrientation(display: AllegroDisplay): cint {.importc: "al_get_display_orientation".}
proc alSetDisplayFlag(display: AllegroDisplay, flag: cint, onOff: bool): bool {.importc: "al_set_display_flag".}

proc alCreateDisplay(w, h: cint): AllegroDisplay {.importc: "al_create_display".}
proc alDestroyDisplay(display: AllegroDisplay): void {.importc: "al_destroy_display".}
proc alGetCurrentDisplay(): AllegroDisplay {.importc: "al_get_current_display".}
proc alSetTargetBitmap(bitmap: AllegroBitmap): void {.importc: "al_set_target_bitmap".}
proc alSetTargetBackbuffer(display: AllegroDisplay): void {.importc: "al_set_target_backbuffer".}
proc alGetBackbuffer(display: AllegroDisplay): AllegroBitmap {.importc: "al_get_backbuffer".}
proc alGetTargetBitmap(): AllegroBitmap {.importc: "al_get_target_bitmap".}

proc alAcknowledgeResize(display: AllegroDisplay): bool {.importc: "al_acknowledge_resize".}
proc alResizeDisplay(display: AllegroDisplay, width, height: cint): bool {.importc: "al_resize_display".}
proc alFlipDisplay(): void {.importc: "al_flip_display".}
proc alUpdateDisplayRegion(x, y, width, height: cint): void {.importc: "al_update_display_region".}
proc alIsCompatibleBitmap(bitmap: AllegroBitmap): bool {.importc: "al_is_compatible_bitmap".}

proc alWaitForVsync(): bool {.importc: "al_wait_for_vsync".}

proc alGetDisplayEventSource(display: AllegroDisplay): AllegroEventSource {.importc: "al_get_display_event_source".}

proc alSetDisplayIcon(display: AllegroDisplay, icon: AllegroBitmap): void {.importc: "al_set_display_icon".}
proc alSetDisplayIcons(display: AllegroDisplay, num_icons: cint, icons: openArray[AllegroBitmap]): void {.importc: "al_set_display_icons".}

#[ Stuff for multihead/window management ]#
proc alGetNewDisplayAdapter(): cint {.importc: "al_get_new_display_adapter".}
proc alSetNewDisplayAdapter(adapter: cint): void {.importc: "al_set_new_display_adapter".}
proc alSetNewWindowPosition(x, y: cint): void {.importc: "al_set_new_window_position".}
proc alGetNewWindowPosition(x, y: var cint): void {.importc: "al_get_new_window_position".}
proc alSetWindowPosition(display: AllegroDisplay, x, y: cint): void {.importc: "al_set_window_position".}
proc alGetWindowPosition(display: AllegroDisplay, x, y: var cint): void {.importc: "al_get_window_position".}
proc alSetWindowConstraints(display: AllegroDisplay, min_w, min_h, max_w, max_h: cint): bool {.importc: "al_set_window_constraints".}
proc alGetWindowConstraints(display: AllegroDisplay, min_w, min_h, max_w, max_h: var cint): bool {.importc: "al_get_window_constraints".}
proc alApplyWindowConstraints(display: AllegroDisplay, onoff: bool): void {.importc: "al_apply_window_constraints".}

proc alSetWindowTitle(display: AllegroDisplay, title: cstring): void {.importc: "al_set_window_title".}

#[ Defined in display_settings.c ]#
proc alSetNewDisplayOption(option, value, importance: cint): void {.importc: "al_set_new_display_option".}
proc alGetNewDisplayOption(option: cint, importance: var cint): cint {.importc: "al_get_new_display_option".}
proc alResetNewDisplayOptions(): void {.importc: "al_reset_new_display_options".}
proc alSetDisplayOption(display: AllegroDisplay, option, value: cint): void {.importc: "al_set_display_option".}
proc alGetDisplayOption(display: AllegroDisplay, option: cint): cint {.importc: "al_get_display_option".}

#[ Deferred drawing ]#
proc alHoldBitmapDrawing(hold: bool): void {.importc: "al_hold_bitmap_drawing".}
proc alIsBitmapDrawingHeld(): bool {.importc: "al_is_bitmap_drawing_held".}

#[ Miscellaneous ]#
proc alAcknowledgeDrawingHalt(display: AllegroDisplay): void {.importc: "al_acknowledge_drawing_halt".}
proc alAcknowledgeDrawingResume(display: AllegroDisplay): void {.importc: "al_acknowledge_drawing_resume".}
{.pop.}

proc newAllegroDisplayRefreshRate*(): uint =
  return alGetNewDisplayRefreshRate().uint

proc newAllegroDisplayRefreshRate*(refreshRate: uint): void =
  alSetNewDisplayRefreshRate(refreshRate.cint)

proc newAllegroDisplayFlags*(): int =
  return alGetNewDisplayFlags()

proc newAllegroDisplayFlags*(flags: seq[AllegroDisplayFlag]): void =
  var flagsCount = 0;
  for flag in flags:
    flagsCount += flag.int
  if (flagsCount > 0):
    alSetNewDisplayFlags(flagsCount.cint)

proc newAllegroWindowTitle*(): string =
  return $alGetNewWindowTitle()

proc newAllegroWindowTitle*(title: string): void =
  alSetNewWindowTitle(title)

proc newAllegroDisplay*(width, height: uint): AllegroDisplay =
  return alCreateDisplay(width.cint, height.cint)

proc currentAllegroDisplay*(): AllegroDisplay =
  return alGetCurrentDisplay()

proc free*(display: AllegroDisplay): void =
  alDestroyDisplay(display)

proc resize*(display: AllegroDisplay, width, height: uint): void =
  discard alResizeDisplay(display, width.cint, height.cint)

proc width*(display: AllegroDisplay): uint =
  return alGetDisplayWidth(display).uint

proc height*(display: AllegroDisplay): uint =
  return alGetDisplayHeight(display).uint

proc width*(display: AllegroDisplay, width: uint): void =
  display.resize(width, display.height)

proc height*(display: AllegroDisplay, height: uint): void =
  display.resize(display.width, height)

proc format*(display: AllegroDisplay): int =
  return alGetDisplayFormat(display)

proc isResizible*(display: AllegroDisplay): bool =
  return alAcknowledgeResize(display)

proc refreshRate*(display: AllegroDisplay): uint =
  alGetDisplayRefreshRate(display).uint

proc flags*(display: AllegroDisplay): uint =
  return alGetDisplayFlags(display).uint

proc orientation*(display: AllegroDisplay): AllegroDisplayOrientation =
  return AllegroDisplayOrientation(alGetDisplayOrientation(display))

proc fullscreen*(display: AllegroDisplay, enable: bool): void =
  discard alSetDisplayFlag(display, AllegroDisplayFlag.fullscreenWindow.cint, enable)

proc frameless*(display: AllegroDisplay, enable: bool): void =
  discard alSetDisplayFlag(display, AllegroDisplayFlag.frameless.cint, enable)

proc maximized*(display: AllegroDisplay, enable: bool): void =
  discard alSetDisplayFlag(display, AllegroDisplayFlag.maximized.cint, enable)

proc target*(bitmap: AllegroBitmap): void =
  alSetTargetBitmap(bitmap)

proc targetBackbuffer*(display: AllegroDisplay): void =
  alSetTargetBackbuffer(display)

proc backbuffer*(display: AllegroDisplay): AllegroBitmap =
  return alGetBackbuffer(display)

proc targetBitmap*(): AllegroBitmap =
  return alGetTargetBitmap()

proc flipDisplay*(): void =
  alFlipDisplay()

proc updateDisplayRegion*(x, y: int, width, height: uint): void =
  alUpdateDisplayRegion(x.cint, y.cint, width.cint, height.cint)

proc isCompatible*(bitmap: AllegroBitmap): bool =
  return alIsCompatibleBitmap(bitmap)

proc waitForVSYNC*(): bool =
  return alWaitForVsync()

proc eventSource*(display: AllegroDisplay): AllegroEventSource =
  return alGetDisplayEventSource(display)

proc icon*(display: AllegroDisplay, icon: AllegroBitmap): void =
  alSetDisplayIcon(display, icon)

proc icon*(display: AllegroDisplay, icons: seq[AllegroBitmap]): void =
  alSetDisplayIcons(display, icons.len.cint, icons.toOpenArray(icons.minIndex, icons.maxIndex))

proc newAllegroDisplayAdapter*(): uint =
  return alGetNewDisplayAdapter().uint

proc newAllegroDisplayAdapter*(adapter: uint): void =
  alSetNewDisplayAdapter(adapter.cint)

proc newWindowPosition*(x, y: int): void =
  alSetNewWindowPosition(x.cint, y.cint)

proc newWindowPosition*(): tuple[x, y: int] =
  var x, y: cint = 0
  alGetNewWindowPosition(x, y)
  return (x.int, y.int)

proc position*(display: AllegroDisplay, x, y: int): void =
  alSetWindowPosition(display, x.cint, y.cint)

proc position*(display: AllegroDisplay): tuple[x, y: int] =
  var x, y: cint = 0
  alGetWindowPosition(display, x, y)
  return (x.int, y.int) 

proc windowConstraints*(display: AllegroDisplay, constraints: AllegroWindowConstraints): void =
  discard alSetWindowConstraints(display, constraints.min_width.cint, constraints.min_height.cint, constraints.max_width.cint, constraints.max_height.cint)

proc windowConstraints*(display: AllegroDisplay): AllegroWindowConstraints =
  var min_w, min_h, max_w, max_h: cint = 0
  discard alGetWindowConstraints(display, min_w, min_h, max_w, max_h) 
  result = AllegroWindowConstraints()
  result.min_width = min_w.int
  result.min_height = min_h.int
  result.max_height = max_h.int
  result.max_width = max_w.int

proc applyWindowConstraints*(display: AllegroDisplay, enble: bool): void =
  alApplyWindowConstraints(display, enble)

proc title*(display: AllegroDisplay, title: string): void =
  alSetWindowTitle(display, title)

proc newDisplayOption*(option: AllegroDisplayOption, value: int, importance: AllegroDisplayImportance): void =
  alSetNewDisplayOption(option.cint, value.cint, importance.cint)

proc displayOption*(option: AllegroDisplayOption): tuple[value: int, importance: AllegroDisplayImportance] =
  var importance: cint = 0
  var value = alGetNewDisplayOption(option.cint, importance)
  return (value.int, AllegroDisplayImportance(importance))

proc resetDisplayOptions*(): void =
  alResetNewDisplayOptions()

proc option*(display: AllegroDisplay, option: AllegroDisplayOption, value: int): void =
  alSetDisplayOption(display, option.cint, value.cint)

proc option*(display: AllegroDisplay, option: AllegroDisplayOption): int =
  alGetDisplayOption(display, option.cint)

proc holdBitmapDrawing*(hold: bool): void =
  alHoldBitmapDrawing(hold)

proc isBitmapDrawingHeld*(): bool =
  alIsBitmapDrawingHeld()

proc acknowledgeDrawingHalt*(display: AllegroDisplay): void =
  alAcknowledgeDrawingHalt(display)

proc acknowledgeDrawingResume*(display: AllegroDisplay): void =
  alAcknowledgeDrawingResume(display)
