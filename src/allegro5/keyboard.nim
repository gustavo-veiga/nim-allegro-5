import std/sequtils

import private/library
import exceptions, event_source, keycodes, display

type
  AllegroKeyboard* = ptr object
  AllegroKeyboardState* = object
    display*: AllegroDisplay

{.push importc, dynlib: library.allegro.}
proc al_install_keyboard(): bool
proc al_uninstall_keyboard(): void
proc al_is_keyboard_installed(): bool

proc al_set_keyboard_leds(leds: cint): bool
proc al_keycode_to_name(keycode: cint): cstring
proc al_get_keyboard_state(ret_state: ref AllegroKeyboardState): void
proc al_key_down(state: ref AllegroKeyboardState, keycode: cint): bool
proc al_get_keyboard_event_source(): AllegroEventSource
{.pop.}

proc installAllegroKeyboard*(): void =
  ## Install a keyboard driver.
  let installed = al_install_keyboard()
  if not installed:
    raise new AllegroInstallKeyboardException

proc uninstallAllegroKeyboard*(): void =
  ## Uninstalls the active keyboard driver, if any. This will automatically
  ## unregister the keyboard event source with any event queues.
  ## 
  ## This function is automatically called when Allegro is shut down.
  al_uninstall_keyboard()

proc isAllegroKeyboardInstalled*(): bool =
  ## Returns true if installAllegroKeyboard was called successfully.
  return al_is_keyboard_installed()

proc keyboardLeds*(leds: varargs[AllegroKeyMod]): bool =
  ## Overrides the state of the keyboard LED indicators. Set leds to a
  ## combination of the keyboard modifier flags to enable the corresponding
  ## LED indicators (keyNumLock, keyCapsLock and keyScrollLock are supported)
  ## or to -1 to return to default behavior. False is returned if the current
  ## keyboard driver cannot set LED indicators.
  let keys = leds.mapIt(it.cint).foldl(a or b)
  return al_set_keyboard_leds(keys)

proc name*(keycode: AllegroKey): string =
  ## Converts the given keycode to a description of the key.
  return $al_keycode_to_name(keycode.cint)

proc state*(state: ref AllegroKeyboardState): void =
  ## Save the state of the keyboard specified at the time the function is
  ## called into the structure pointed to by ret_state.
  al_get_keyboard_state(state)

proc keyDown*(state: ref AllegroKeyboardState, keyCode: AllegroKey): bool =
  ## Return true if the key specified was held down in the state specified.
  return al_key_down(state, keyCode.cint)

proc keyboardEventSource*(): AllegroEventSource =
  ## Retrieve the keyboard event source. All keyboard events are generated
  ## by this event source.
  return al_get_keyboard_event_source()
