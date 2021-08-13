type
  AllegroJoystick* = ptr object
  AllegroJoyflags* {.pure.} = enum
    digital  = 0x01
    analogue = 0x02
  AllegroJoystickState* = object
    axis: float

{.push dynlib: "liballegro.so".}
proc installJoystick(): bool {.importc: "al_install_joystick".}
proc uninstallJoystick(): void {.importc: "al_uninstall_joystick".}
proc isJoystickInstalled(): bool {.importc: "is_joystick_installed".}
proc reconfigureJoystick(): bool {.importc: "al_reconfigure_joysticks".}

proc getNumJoysticks(): int {.importc: "al_get_num_joysticks".}
proc getJoystick(joyn: cint): AllegroJoystick {.importc: "al_get_joystick".}
proc releasejoystick(joystick: AllegroJoystick): void {.importc: "al_release_joystick".}
{.pop.}

proc avaliableJoysticks*(): uint =
  return getNumJoysticks().uint

proc newAllegroJoystick*(joyNumber: uint): AllegroJoystick =
  return getJoystick(joyNumber.cint)

proc release*(self: var AllegroJoystick): void =
  releasejoystick(self)