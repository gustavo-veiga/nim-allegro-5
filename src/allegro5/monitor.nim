import private/library

type
  AllegroMonitorInfo* = object
    x1*, y1*, x2*, y2*: cint

{.push importc, dynlib: library.allegro.}
proc al_get_num_video_adapters(): cint
proc al_get_monitor_info(adapter: cint, info: var AllegroMonitorInfo): bool
proc al_get_monitor_dpi(adapter: cint): cint
{.pop.}

proc availableVideoAdapters*(): int =
  return al_get_num_video_adapters().int

proc monitorInfo*(adapter: uint): AllegroMonitorInfo =
  var info = AllegroMonitorInfo()
  discard al_get_monitor_info(adapter.cint, info)
  return info

proc monitorDPI*(adapter: uint): uint =
  return al_get_monitor_dpi(adapter.cint).uint
