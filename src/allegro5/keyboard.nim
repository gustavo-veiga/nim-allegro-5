import keycodes

type
  AllegroKeyboard* = ptr object
  AllegroKeyboardState* = ptr object

{.push dynlib: "liballegro.so".}
proc installKeyboard(): bool {.importc: "al_install_keyboard".}
proc uninstallKeyboard(): void {.importc: "al_uninstall_keyboard".}
proc isKeyboardInstalled(): bool {.importc: "al_is_keyboard_installed".}

proc keyDown(state: ref AllegroKeyboardState, keyCode: cint): bool {.importc: "al_key_down".}
{.pop.}

proc keyDown*(state: ref AllegroKeyboardState, key: AllegroKey): bool =
  keyDown(state, key.cint)
