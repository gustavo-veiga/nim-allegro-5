import private/library
import event_source, exceptions, display

const maxTouchCount = 16

type
  AllegroTouchInput* = ptr object
  AllegroTouchState = object
    id*:      cint    ## An identifier of touch. If touch is valid this number is positive.
    x, y*:    cfloat  ## Touch position on the screen in 1:1 resolution.
    dx, dy*:  cfloat  ## Relative touch position.
    primary*: bool    ## True, if touch is a primary one (usually first one).
    display*: AllegroDisplay ## Display at which the touch belong.
  AllegroTouchInputState* = object
    touches: array[maxTouchCount, AllegroTouchState]

{.push importc, dynlib: library.allegro.}
proc al_is_touch_input_installed(): bool
proc al_install_touch_input(): bool
proc al_uninstall_touch_input(): void
proc al_get_touch_input_state(ret_state: ref AllegroTouchInputState): void
proc al_get_touch_input_event_source(): AllegroEventSource
{.pop.}

proc installAllegroTouchInput*(): void =
  ## Install a touch input driver.
  let installed = al_install_touch_input()
  if not installed:
    raise new AllegroInstallTouchInputException

proc isTouchInputInstalled*(): bool =
  ## Returns true if installAllegroTouchInput was called successfully.
  return al_is_touch_input_installed()

proc uninstallAllegroTouchInput*(): void =
  ## Uninstalls the active touch input driver. If no touch input driver was
  ## active, this function does nothing.
  ## 
  ## This function is automatically called when Allegro is shut down.
  al_uninstall_touch_input()

proc state*(state: ref AllegroTouchInputState): void =
  ## Gets the current touch input state. The touch information is copied
  ## into the AllegroTouchInputState you provide to this proc.
  al_get_touch_input_state(state)

proc touchInputEventSource*(): AllegroEventSource =
  ## Returns the global touch input event source. This event source
  ## generates touch input events.
  return al_get_touch_input_event_source()
