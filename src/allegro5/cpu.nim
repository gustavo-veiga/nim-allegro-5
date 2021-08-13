import private/library

{.push importc, dynlib: library.allegro.}
proc al_get_cpu_count(): cint
proc al_get_ram_size(): cint
{.pop.}

proc cpuCount*(): uint =
  return al_get_cpu_count().uint

proc ramSize*(): uint =
  return al_get_ram_size().uint
