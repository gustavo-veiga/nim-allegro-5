import private/library

{.push dynlib: library.image.}
proc alInitImageAddon(): bool  {.importc: "al_init_image_addon".}
proc alIsImageAddonInitialized(): bool  {.importc: "al_is_image_addon_initialized".}
proc alShutdownImageAddon(): void  {.importc: "al_shutdown_image_addon".}
proc alGetAllegroImageVersion(): cuint  {.importc: "al_get_allegro_image_version".}
{.pop.}

proc newAllegroImageAddon*(): void =
  discard alInitImageAddon()

proc isImageAddonInitialized*(): bool =
  return alIsImageAddonInitialized()

proc freeAllegroImageAddon*(): void =
  alShutdownImageAddon()

proc imageAddonVersion*(): uint =
  return alGetAllegroImageVersion().uint
