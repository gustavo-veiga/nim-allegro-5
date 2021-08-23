import std/options

import private/library
import exceptions, event_source

#[ internal values ]#
const maxJoystickAxes     = 3
const maxJoystickSticks   = 16
const maxJoystickButtons  = 32

type
  AllegroJoystick* = ptr object
  AllegroJoystickFlag* {.pure, final.} = enum
    digital  = 0x01
    analogue = 0x02
  AllegroJoystickAxis = object
    axis*: array[maxJoystickAxes, cfloat]     ##  -1.0 to 1.0
  AllegroJoystickState* = object
    stick*: array[maxJoystickSticks, AllegroJoystickAxis]
    button*: array[maxJoystickButtons, cint]  ##  0 to 32767

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

proc al_get_joystick_num_sticks(joystick: AllegroJoystick): cint
proc al_get_joystick_stick_flags(joystick: AllegroJoystick, stick: cint): cint
proc al_get_joystick_stick_name(joystick: AllegroJoystick, stick: cint): cstring

proc al_get_joystick_num_axes(joystick: AllegroJoystick, stick: cint): cint
proc al_get_joystick_axis_name(joystick: AllegroJoystick, stick, axis: cint): cstring

proc al_get_joystick_num_buttons(joystick: AllegroJoystick): cint
proc al_get_joystick_button_name(joystick: AllegroJoystick, buttonn: cint): cstring

proc al_get_joystick_state(joystick: AllegroJoystick, ret_state: ref AllegroJoystickState): void

proc al_get_joystick_event_source(): AllegroEventSource
{.pop.}

proc installAllegroJoystick*(): void =
  ## Install a joystick driver
  let installed = al_install_joystick()
  if not installed:
    raise new AllegroInstallJoystickException

proc uninstallAllegroJoystick*(): void =
  ## Uninstalls the active joystick driver. All outstanding AllegroJoystick
  ## structures are invalidated. If no joystick driver was active, this
  ## function does nothing.
  ## 
  ## This function is automatically called when Allegro is shut down.
  al_uninstall_joystick()

proc isJoystickInstalled*(): bool =
  ## Returns true if installAllegroJoystick was called successfully.
  return al_is_joystick_installed()

proc reconfigureJoysticks*(): bool =
  ## Allegro is able to cope with users connecting and disconnected joystick devices
  ## on-the-fly. On existing platforms, the joystick event source will generate an 
  ## event of type ALLEGRO_EVENT_JOYSTICK_CONFIGURATION when a device is plugged in
  ## or unplugged. In response, you should call reconfigureJoysticks.
  ## 
  ## Afterwards, the number returned by al_get_num_joysticks may be different, and
  ## the handles returned by al_get_joystick may be different or be ordered differently.
  ## 
  ## All AllegroJoystick handles remain valid, but handles for disconnected devices
  ## become inactive: their states will no longer update, and al_get_joystick will
  ## not return the handle. Handles for devices which remain connected will continue
  ## to represent the same devices. Previously inactive handles may become active again,
  ## being reused to represent newly connected devices.
  ## 
  ## Returns true if the joystick configuration changed, otherwise returns false.
  ## 
  ## It is possible that on some systems, Allegro won’t be able to generate
  ## ALLEGRO_EVENT_JOYSTICK_CONFIGURATION events. If your game has an input configuration
  ## screen or similar, you may wish to call al_reconfigure_joysticks when entering that screen.
  return al_reconfigure_joysticks()

proc availableJoysticks*(): uint =
  ## Return the number of joysticks currently on the system (or potentially on the
  ## system). This number can change after al_reconfigure_joysticks is called, in
  ## order to support hotplugging.
  ## 
  ## Returns 0 if there is no joystick driver installed.
  return al_get_num_joysticks().uint

proc newAllegroJoystick*(joyNumber: uint): Option[AllegroJoystick] =
  ## Get a handle for a joystick on the system. The number may be from 0 to
  ## availableJoysticks-1. If successful a pointer to a joystick object is
  ## returned, which represents a physical device. Otherwise NULL is returned.
  ## 
  ## The handle and the index are only incidentally linked. After
  ## reconfigureJoysticks is called, al_get_joystick may return handles in a
  ## different order, and handles which represent disconnected devices will
  ## not be returned.
  let joystick = al_get_joystick(joyNumber.cint)
  if joystick.isNil:
    return none(AllegroJoystick)
  return some(joystick)

proc release*(joystick: AllegroJoystick): void =
  ## This function currently does nothing.
  al_release_joystick(joystick)

proc isActive*(joystick: AllegroJoystick): bool =
  ## Return if the joystick handle is “active”, i.e. in the current configuration,
  ## the handle represents some physical device plugged into the system.
  ## newAllegroJoystick returns active handles. After reconfiguration, active
  ## handles may become inactive, and vice versa.
  return al_get_joystick_active(joystick)

proc name*(joystick: AllegroJoystick): string =
  ## Return the name of the given joystick.
  return $al_get_joystick_name(joystick)

proc numberSticks*(joystick: AllegroJoystick): uint =
  ## Return the number of "sticks" on the given joystick.
  ## A stick has one or more axes.
  return al_get_joystick_num_sticks(joystick).uint

proc stickFlags*(joystick: AllegroJoystick, stick: uint): Option[AllegroJoystickFlag] =
  ## Return the flags of the given "stick"
  let flag = al_get_joystick_stick_flags(joystick, stick.cint)
  if flag == 0:
    return none(AllegroJoystickFlag)
  return some(AllegroJoystickFlag(flag))


proc stickName*(joystick: AllegroJoystick, stick: uint): Option[string] =
  ## Return the name of the given "stick"
  let value = al_get_joystick_stick_name(joystick, stick.cint)
  if value.isNil:
    return none(string)
  return some($value)

proc numberAxes*(joystick: AllegroJoystick, stick: uint): uint =
  ## Return the number of axes on the given "stick".
  ## If the stick doesn’t exist, 0 is returned.
  return al_get_joystick_num_axes(joystick, stick.cint).uint

proc axisName*(joystick: AllegroJoystick, stick, axis: uint): Option[string] =
  ## Return the name of the given axis.
  let value = al_get_joystick_axis_name(joystick, stick.cint, axis.cint)
  if value.isNil:
    return none(string)
  return some($value)

proc numberButtons*(joystick: AllegroJoystick): uint =
  ## Return the number of buttons on the joystick.
  return al_get_joystick_num_buttons(joystick).uint

proc buttonName*(joystick: AllegroJoystick, button: uint): Option[string] =
  ## Return the name of the given button.
  let value = al_get_joystick_button_name(joystick, button.cint)
  if value.isNil:
    return none(string)
  return some($value)

proc state*(joystick: AllegroJoystick, state: ref AllegroJoystickState): void =
  ## Get the current joystick state.
  al_get_joystick_state(joystick, state)

proc joystickEventSource*(): AllegroEventSource =
  ## Returns the global joystick event source. All joystick events are
  ## generated by this event source.
  return al_get_joystick_event_source()
