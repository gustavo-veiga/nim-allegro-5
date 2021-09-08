import private/library, event_source, display

type
  AllegroMouse* = ptr object
  AllegroMouseState* = object
    x*: cint
    y*: cint
    z*: cint
    w*: cint
    more_axes*: array[4, cint]
    buttons*: cint
    pressure*: cfloat
    display*: AllegroDisplay

{.push importc, dynlib: library.allegro.}
proc al_is_mouse_installed(): bool
proc al_install_mouse(): bool
proc al_uninstall_mouse(): void
proc al_get_mouse_num_buttons(): cuint
proc al_get_mouse_num_axes(): cuint
proc al_set_mouse_xy(display: AllegroDisplay, x, y: cint): bool
proc al_set_mouse_z(z: cint): bool
proc al_set_mouse_w(w: cint): bool
proc al_set_mouse_axis(axis, value: cint): bool
proc al_get_mouse_state(retState: var AllegroMouseState): void
proc al_mouse_button_down(state: AllegroMouseState, button: cint): bool
proc al_get_mouse_state_axis(state: AllegroMouseState, axis: cint): bool
proc al_get_mouse_cursor_position(retX, retY: var cint): bool
proc al_grab_mouse(display: AllegroDisplay): bool
proc al_ungrab_mouse(): bool
proc al_set_mouse_wheel_precision(precision: cint): void
proc al_get_mouse_wheel_precision(): cint

proc al_get_mouse_event_source(): AllegroEventSource
{.pop.}

proc installAllegroMouse*(): void =
  discard al_install_mouse()

proc isMouseInstalled*(): bool =
  return al_is_mouse_installed()

proc unistallAllegroMouse*(): void =
  al_uninstall_mouse()

proc mouseNumberButtons*(): uint =
  return al_get_mouse_num_buttons().uint

proc mouseNumverAxes*(): uint =
  return al_get_mouse_num_axes().uint

proc mouseXY*(display: AllegroDisplay, x, y: int): void =
  discard al_set_mouse_xy(display, x.cint, y.cint)

proc mouseZ*(z: int): void =
  discard al_set_mouse_z(z.cint)

proc mouseW*(w: int): void =
  discard al_set_mouse_w(w.cint)

proc mouseAxis*(axis: uint, value: int): void =
  discard al_set_mouse_axis(axis.cint, value.cint)

proc mouseState*(): AllegroMouseState =
  var state = AllegroMouseState()
  al_get_mouse_state(state)
  return state

proc isButtonDown*(state: AllegroMouseState, button: int): bool =
  return al_mouse_button_down(state, button.cint)

proc isStateAxis*(state: AllegroMouseState, axis: int): bool =
  return al_get_mouse_state_axis(state, axis.cint)

proc mouseCursorPositon*(): tuple[x, y: int] =
  var x, y: cint = 0
  discard al_get_mouse_cursor_position(x, y)
  return (x.int, y.int)

proc grabMouse*(display: AllegroDisplay): void =
  discard al_grab_mouse(display)

proc ungrabMouse*(): void =
  discard al_ungrab_mouse()

proc mouseWheelPrecision*(): int =
  return al_get_mouse_wheel_precision().int

proc mouseWheelPrecision*(precision: int): void =
  al_set_mouse_wheel_precision(precision.cint)

proc mouseEventSource*(): AllegroEventSource =
  return al_get_mouse_event_source()
