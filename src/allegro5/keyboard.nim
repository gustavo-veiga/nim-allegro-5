import private/library, event_source, keycodes

type
  AllegroKeyboard* = ptr object
  AllegroKeyboardState* = ptr object

{.push importc, dynlib: library.allegro.}
proc al_install_keyboard(): bool
proc al_uninstall_keyboard(): void
proc al_is_keyboard_installed(): bool

proc al_key_down(state: ref AllegroKeyboardState, keyCode: cint): bool

proc al_get_keyboard_event_source(): AllegroEventSource
{.pop.}

proc installAllegroKeyboard*(): void = 
  discard al_install_keyboard()

proc uninstallAllegroKeyboard*(): void =
  al_uninstall_keyboard()

proc isAllegroKeyboardInstalled*(): bool =
  return al_is_keyboard_installed()

proc keyboardEventSource*(): AllegroEventSource =
  return al_get_keyboard_event_source()
