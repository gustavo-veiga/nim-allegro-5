import private/library, event_source, altime, keyboard, keycodes, display, joystick

type
  AllegroEventQueue* = ptr object
  AllegroEventType* {.pure.} = enum
    joystickAxis          = 1
    joystickButtonDown    = 2
    joystickButtonUp      = 3
    joystickConfiguration = 4

    keyDown               = 10
    keyChar               = 11
    keyUp                 = 12
    mouseAxes             = 20
    mouseButtonDown       = 21
    mouseButtonUp         = 22
    mouseEnterDisplay     = 23
    mouseLeaveDisplay     = 24
    mouseWarped           = 25

    timer                 = 30

    displayExpose         = 40
    displayResize         = 41
    displayClose          = 42
    displayLost           = 43
    displayFound          = 44
    displaySwitchIn       = 45
    displaySwitchOut      = 46
    displayOrientation    = 47
    displayHaltDrawing    = 48
    displayResumeDrawing  = 49

    touchBegin            = 50
    touchEnd              = 51
    touchMove             = 52
    touchCancel           = 53
   
    displayConnected      = 60
    displayDisconnected   = 61
  AllegroEventAny* = object
    event*:     AllegroEventType
    source*:    pointer
    timestamp*: float64
  AllegroEventDisplay* = object
    event*:       AllegroEventType
    source*:      AllegroDisplay
    timestamp*:   float64
    x*, y*:       cint
    width*:       cint
    height*:      cint
    orientation*: AllegroDisplayOrientation
  AllegroEventJoystick* = object
    event*:     AllegroEventType
    source*:    AllegroJoystick
    timestamp*: float64
    id*:        cint
    stick*:     cint
    axis*:      cint
    pos*:       cfloat
    button*:    cint
  AllegroEventKeyboard* = object
    event*:     AllegroEventType
    source*:    AllegroKeyboard
    timestamp*: float64
    display*:   AllegroDisplay  # the window the key was pressed in
    keycode*:   AllegroKey      # the physical key pressed
    unichar*:   cint            # unicode character or negative
    modifiers*: AllegroKeyMod   # bitfield
    repeat*:    bool            # auto-repeated or not
  AllegroEvent* {.union.} = object
    typeEvent*: AllegroEventType
    anyEvent*: AllegroEventAny
    display*: AllegroEventDisplay
    joystick*: AllegroEventJoystick
    keyboard*: AllegroEventKeyboard

{.push importc, dynlib: library.allegro.}
proc al_create_event_queue(): AllegroEventQueue
proc al_destroy_event_queue(queue: AllegroEventQueue): void
proc al_is_event_source_registered(queue: AllegroEventQueue, source: AllegroEventSource): bool
proc al_register_event_source(queue: AllegroEventQueue, source: AllegroEventSource): void
proc al_unregister_event_source(queue: AllegroEventQueue, source: AllegroEventSource): void
proc al_pause_event_queue(queue: AllegroEventQueue, pause: bool): void
proc al_is_event_queue_paused(queue: AllegroEventQueue): bool
proc al_is_event_queue_empty(queue: AllegroEventQueue): bool
proc al_get_next_event(queue: AllegroEventQueue, event: var AllegroEvent): bool
proc al_peek_next_event(queue: AllegroEventQueue, event: var AllegroEvent): bool
proc al_drop_next_event(queue: AllegroEventQueue): bool
proc al_flush_event_queue(queue: AllegroEventQueue): void
proc al_wait_for_event(queue: AllegroEventQueue, event: var AllegroEvent): void
proc al_wait_for_event_timed(queue: AllegroEventQueue, ret_event: var cint, secs: cfloat): bool
proc al_wait_for_event_until(queue: AllegroEventQueue, ret_event: var cint, timeout: AllegroTimeout): bool
{.pop.}

proc newAllegroEventQueue*(): AllegroEventQueue =
  return al_create_event_queue()

proc free*(queue: AllegroEventQueue): void =
  al_destroy_event_queue(queue)

proc isRegistered*(queue: AllegroEventQueue, source: AllegroEventSource): bool =
  return al_is_event_source_registered(queue, source)

proc register*(queue: AllegroEventQueue, source: AllegroEventSource): void =
  al_register_event_source(queue, source)

proc unregister*(queue: AllegroEventQueue, source: AllegroEventSource): void =
  al_unregister_event_source(queue, source)

proc pause*(queue: AllegroEventQueue, pause: bool): void =
  al_pause_event_queue(queue, pause)

proc isPaused*(queue: AllegroEventQueue): bool = 
  return al_is_event_queue_paused(queue)

proc isEmpty*(queue: AllegroEventQueue): bool =
  return al_is_event_queue_empty(queue)

proc next*(queue: AllegroEventQueue): AllegroEvent =
  var next = AllegroEvent()
  discard al_get_next_event(queue, next)
  return next

proc peekNext*(queue: AllegroEventQueue, event: var AllegroEvent): void =
  discard al_peek_next_event(queue, event)

proc dropNext*(queue: AllegroEventQueue): void =
  discard al_drop_next_event(queue)

proc flush*(queue: AllegroEventQueue): void =
  al_flush_event_queue(queue)

proc wait*(queue: AllegroEventQueue, event: var AllegroEvent) =
  al_wait_for_event(queue, event)

