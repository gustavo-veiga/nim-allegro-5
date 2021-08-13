import private/library

{.push importc, dynlib: library.allegro.}
proc al_init_image_addon(): bool
proc al_is_image_addon_initialized(): bool
proc al_shutdown_image_addon(): void
proc al_get_allegro_image_version(): cuint
{.pop.}

proc newAllegroImageAddon*(): void =
  discard al_init_image_addon()

proc isImageAddonInitialized*(): bool =
  return al_is_image_addon_initialized()

proc freeAllegroImageAddon*(): void =
  al_shutdown_image_addon()

proc imageAddonVersion*(): uint =
  return al_get_allegro_image_version().uint
