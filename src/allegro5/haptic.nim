import private/library
import mouse, joystick, keyboard, display, touch_input

type
  AllegroHaptic* = ptr object
  AllegroHapticEffectId* = ptr object
  AllegroHapticDirection* = object
    angle*:           float64
    radius*:          float64
    azimuth*:         float64
  AllegroHapticReplay* = object
    length*:          float64
    delay*:           float64
  AllegroHapticEnvelope* = object
    attackLength*:    float64
    attackLevel*:     float64
    fadeLength*:      float64
    fadeLevel*:       float64
  AllegroHapticConstantEffect* = object
    level*:           float64
    envelope*:        AllegroHapticEnvelope
  AllegroHapticRampEffect* = object
    startLevel*:      float64
    endLevel*:        float64
    envelope*:        AllegroHapticEnvelope
  AllegroHapticConditionEffect* = object
    rightSaturation*: float64
    leftSaturation*:  float64
    rightCoeff*:      float64
    leftCoeff*:       float64
    deadband*:        float64
    center*:          float64
  AllegroHapticPeriodicEffect* = object
    waveform*:        int32
    period*:          float64
    magnitude*:       float64
    offset*:          float64
    phase*:           float64
    envelope*:        AllegroHapticEnvelope
    customLength*:    int32
    customData*:      openArray[float64]
  AllegroHapticRumbleEffect* = object
    strongMagnitude*: float64
    weakMagnitude*:   float64
  AllegroHapticEffectUnion* {.union.} = object
    constant*:        AllegroHapticConstantEffect
    ramp*:            AllegroHapticRampEffect
    periodic*:        AllegroHapticPeriodicEffect
    condition*:       AllegroHapticConditionEffect
    rumble*:          AllegroHapticRumbleEffect
  AllegroHapticEffect* = object
    typeHaptic*:      AllegroHapticConstants
    direction*:       AllegroHapticDirection
    replay*:          AllegroHapticReplay
    data*:            AllegroHapticEffectUnion
  AllegroHapticConstants* {.pure, final.} = enum
    hapticRumble      = 1 shl 0
    hapticPeriodic    = 1 shl 1
    hapticConstant    = 1 shl 2
    hapticSpring      = 1 shl 3
    hapticFriction    = 1 shl 4
    hapticDamper      = 1 shl 5
    hapticInertia     = 1 shl 6
    hapticRamp        = 1 shl 7
    hapticSquare      = 1 shl 8
    hapticTriangle    = 1 shl 9
    hapticSine        = 1 shl 10
    hapticSawUp       = 1 shl 11
    hapticSawDown     = 1 shl 12
    hapticCustom      = 1 shl 13
    hapticGain        = 1 shl 14
    hapticAngle       = 1 shl 15
    hapticRadius      = 1 shl 16
    hapticAzimuth     = 1 shl 17
    hapticAutocenter  = 1 shl 18

{.push importc, dynlib: library.allegro.}
proc al_install_haptic(): bool
proc al_uninstall_haptic(): void
proc al_is_haptic_installed(): bool

proc al_is_mouse_haptic(dev: AllegroMouse): bool
proc al_is_joystick_haptic(dev: AllegroJoystick): bool
proc al_is_keyboard_haptic(dev: AllegroKeyboard): bool
proc al_is_display_haptic(dev: AllegroDisplay): bool
proc al_is_touch_input_haptic(dev: AllegroTouchInput): bool

proc al_get_haptic_from_mouse(dev: AllegroMouse): AllegroHaptic
proc al_get_haptic_from_joystick(dev: AllegroJoystick): AllegroHaptic
proc al_get_haptic_from_keyboard(dev: AllegroKeyboard): AllegroHaptic
proc al_get_haptic_from_display(dev: AllegroDisplay): AllegroHaptic
proc al_get_haptic_from_touch_input(dev: AllegroTouchInput): AllegroHaptic

proc al_release_haptic(hap: AllegroHaptic): bool

proc al_is_haptic_active(hap: AllegroHaptic): bool
proc al_get_haptic_capabilities(hap: AllegroHaptic): cint
proc al_is_haptic_capable(hap: AllegroHaptic, query: cint): bool

proc al_set_haptic_gain(hap: AllegroHaptic, gain: cdouble): bool
proc al_get_haptic_gain(hap: AllegroHaptic): cdouble

proc al_set_haptic_autocenter(hap: AllegroHaptic, intensity: cdouble): bool
proc al_get_haptic_autocenter(hap: AllegroHaptic): cdouble


proc al_get_max_haptic_effects(hap: AllegroHaptic): cint
proc al_is_haptic_effect_ok(hap: AllegroHaptic, effect: AllegroHapticEffect): bool
proc al_upload_haptic_effect(hap: AllegroHaptic, effect: AllegroHapticEffect, id: AllegroHapticEffectId): bool
proc al_play_haptic_effect(id: AllegroHapticEffectId, loop: cint): bool
proc al_upload_and_play_haptic_effect(hap: AllegroHaptic, effect: AllegroHapticEffect, id: AllegroHapticEffectId, loop: cint): bool
proc al_stop_haptic_effect(id: AllegroHapticEffectId): bool
proc al_is_haptic_effect_playing(id: AllegroHapticEffectId): bool
proc al_release_haptic_effect(id: AllegroHapticEffectId): bool
proc al_get_haptic_effect_duration(id: AllegroHapticEffectId): cdouble
proc al_rumble_haptic(hap: AllegroHaptic, intensity, duration: cdouble, id: AllegroHapticEffectId): bool
{.pop.}
