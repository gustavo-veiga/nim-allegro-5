import private/library, events

type
  AllegroTimer* = ptr object

{.push importc, dynlib: library.allegro.}
proc al_create_timer(speedSecs: cdouble): AllegroTimer
proc al_destroy_timer(timer: AllegroTimer): void
proc al_start_timer(timer: AllegroTimer): void
proc al_stop_timer(timer: AllegroTimer): void
proc al_resume_timer(timer: AllegroTimer): void
proc al_get_timer_started(timer: AllegroTimer): bool
proc al_get_timer_speed(timer: AllegroTimer): cdouble
proc al_set_timer_speed(timer: AllegroTimer, speedSecs: cdouble): void
proc al_get_timer_count(timer: AllegroTimer): cint
proc al_set_timer_count(timer: AllegroTimer, count: cint): void
proc al_add_timer_count(timer: AllegroTimer, diff: cint): void
proc al_get_timer_event_source(timer: AllegroTimer): AllegroEventSource
{.pop.}

proc newAllegroTimer*(speedSecs: float64): AllegroTimer =
  return al_create_timer(speedSecs.cdouble)

proc free*(timer: AllegroTimer): void =
  al_destroy_timer(timer)

proc start*(timer: AllegroTimer): void =
  al_start_timer(timer)

proc stop*(timer: AllegroTimer): void =
  al_stop_timer(timer)

proc resume*(timer: AllegroTimer): void =
  al_resume_timer(timer)

proc isStarted*(timer: AllegroTimer): bool =
  return al_get_timer_started(timer)

proc speed*(timer: AllegroTimer): float64 =
  return al_get_timer_speed(timer).float64

proc speed*(timer: AllegroTimer, speedSecs: float64): void =
  al_set_timer_speed(timer, speedSecs.cdouble)

proc count*(timer: AllegroTimer): uint =
  al_get_timer_count(timer).uint

proc count*(timer: AllegroTimer, count: uint): void =
  al_set_timer_count(timer, count.cint)

proc `count+`*(timer: AllegroTimer, diff: uint): void =
  al_add_timer_count(timer, diff.cint)

proc eventSource*(timer: AllegroTimer): AllegroEventSource =
  return al_get_timer_event_source(timer)
