import private/library

{.push importc, dynlib: library.allegro.}
proc al_init_acodec_addon(): bool
proc al_is_acodec_addon_initialized(): bool
proc al_get_allegro_acodec_version(): cuint
{.pop.}

proc installAllegroAcodecAddon*(): void =
  discard al_init_acodec_addon()

proc isAllegroAcodecAddonInitialized*(): bool =
  return al_is_acodec_addon_initialized()

proc allegroAcodecAddonVersion*(): uint =
  return al_get_allegro_acodec_version()
