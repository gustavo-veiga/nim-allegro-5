import private/library, config

{.push importc, dynlib: library.allegro.}
proc al_install_system(version, exit: cint): bool
proc al_uninstall_system(): void
proc al_is_system_installed(): bool

proc al_get_system_config(): AllegroConfig
{.pop.}

let allegroVersionInt {.importc: "ALLEGRO_VERSION_INT", header: "<allegro5/base.h>".}: cint

proc installAllegro*(): void =
  discard al_install_system(allegroVersionInt, 0);

proc installAllegroSystemConfig*(): AllegroConfig =
  return al_get_system_config()

proc uninstallAllegro*(): void =
  al_uninstall_system()

proc isAlegroInstalled*(): bool =
  return al_is_system_installed()
