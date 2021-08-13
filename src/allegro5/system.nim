import private/library, config

{.push dynlib: library.name.}
proc alInstallSystem(version, exit: cint): bool {.importc: "al_install_system".}
proc alUninstallSystem(): void {.importc: "al_uninstall_system".}
proc alIsSystemInstalled(): bool {.importc: "al_is_system_installed".}

proc alGetSystemConfig(): AllegroConfig {.importc: "al_get_system_config".}
{.pop.}
let allegroVersionInt {.importc: "ALLEGRO_VERSION_INT", header: "<allegro5/base.h>".}: cint

proc newAllegro*(): void =
  discard alInstallSystem(allegroVersionInt, 0);

proc newAllegroSystemConfig*(): AllegroConfig =
  return alGetSystemConfig()

proc freeAllegro*(): void =
  alUninstallSystem()

proc isInstalledAlegro*(): bool =
  return alIsSystemInstalled()
