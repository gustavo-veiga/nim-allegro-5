import ../private/library

{.push importc, dynlib: library.primitivesAddon.}
proc al_init_primitives_addon(): bool
{.pop.}

proc installAllegroPrimitivesAddon*(): void =
  discard al_init_primitives_addon()
