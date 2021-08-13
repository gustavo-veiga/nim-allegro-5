import private/library

type
  AllegroJoystick* = ptr object
  AllegroJoyflags* {.pure.} = enum
    digital  = 0x01
    analogue = 0x02
  AllegroJoystickState* = object
    axis: float

{.push importc, dynlib: library.allegro.}
proc al_install_joystick(): bool
proc al_uninstall_joystick(): void
proc al_is_joystick_installed(): bool
proc al_reconfigure_joysticks(): bool

proc al_get_num_joysticks(): int
proc al_get_joystick(joyn: cint): AllegroJoystick
proc al_release_joystick(joystick: AllegroJoystick): void
proc al_get_joystick_active(joystick: AllegroJoystick): bool
proc al_get_joystick_name(joystick: AllegroJoystick): cstring
{.pop.}

proc newAllegroJoystick*(): void =
  discard al_install_joystick()

proc freeAllegroJoystick*(): void =
  al_uninstall_joystick()

proc isJoystickInstalled*(): bool =
  return al_is_joystick_installed()

proc reconfigureJoysticks*(): void =
  discard al_reconfigure_joysticks()

proc avaliableJoysticks*(): uint =
  return al_get_num_joysticks().uint

proc newAllegroJoystick*(joyNumber: uint): AllegroJoystick =
  return al_get_joystick(joyNumber.cint)

proc release*(joystick: AllegroJoystick): void =
  al_release_joystick(joystick)

proc isActive*(joystick: AllegroJoystick): bool =
  return al_get_joystick_active(joystick)

proc name*(joystick: AllegroJoystick): string =
  return $al_get_joystick_name(joystick)
