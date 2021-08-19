import private/library, event_source

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
  ## Allocates and initializes a timer. If successful, a pointer to a new timer object is
  ## returned, otherwise NULL is returned. speed_secs is in seconds per “tick”, and must 
  ## be positive. The new timer is initially stopped.
  ## 
  ## Usage note: typical granularity is on the order of microseconds, but with some
  ## drivers might only be milliseconds.
  return al_create_timer(speedSecs.cdouble)

proc free*(timer: AllegroTimer): void =
  ## Uninstall the timer specified. If the timer is started, it will automatically be
  ## stopped before uninstallation. It will also automatically unregister the
  ## timer with any event queues.
  al_destroy_timer(timer)

proc start*(timer: AllegroTimer): void =
  ## Start the timer specified. From then, the timer’s counter will increment at a
  ## constant rate, and it will begin generating events. Starting a timer that is
  ## already started does nothing. Starting a timer that was stopped will reset the
  ## timer’s counter, effectively restarting the timer from the beginning.
  al_start_timer(timer)

proc stop*(timer: AllegroTimer): void =
  ## Stop the timer specified. The timer’s counter will stop incrementing and it wil
  ## stop generating events. Stopping a timer that is already stopped does nothing.
  al_stop_timer(timer)

proc resume*(timer: AllegroTimer): void =
  ## Resume the timer specified. From then, the timer’s counter will increment at a
  ## constant rate, and it will begin generating events. Resuming a timer that is
  ## already started does nothing. Resuming a stopped timer will not reset the
  ## timer’s counter (unlike start).
  al_resume_timer(timer)

proc isStarted*(timer: AllegroTimer): bool =
  ## Return true if the timer specified is currently started.
  return al_get_timer_started(timer)

proc speed*(timer: AllegroTimer): float64 =
  ## Return the timer’s speed, in seconds.
  return al_get_timer_speed(timer).float64

proc speed*(timer: AllegroTimer, speedSecs: float64): void =
  ## Set the timer’s speed, i.e. the rate at which its counter will be incremented
  ## when it is started. This can be done when the timer is started or stopped. If
  ## the timer is currently running, it is made to look as though the speed change
  ## occurred precisely at the last tick.
  al_set_timer_speed(timer, speedSecs.cdouble)

proc count*(timer: AllegroTimer): uint =
  ## Return the timer’s counter value. The timer can be started or stopped.
  al_get_timer_count(timer).uint

proc count*(timer: AllegroTimer, count: uint): void =
  ## Set the timer’s counter value. The timer can be started or stopped. The count value
  ## may be positive or negative, but will always be incremented by +1 at each tick.
  al_set_timer_count(timer, count.cint)

proc `count+`*(timer: AllegroTimer, diff: uint): void =
  ## Add diff to the timer’s counter value.
  al_add_timer_count(timer, diff.cint)

proc eventSource*(timer: AllegroTimer): AllegroEventSource =
  ## Retrieve the associated event source.
  return al_get_timer_event_source(timer)
