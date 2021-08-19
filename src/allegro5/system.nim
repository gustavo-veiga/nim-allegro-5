import private/library, config, path

type
  AllegroSystem* = ptr object
  AllegroSystemID* {.pure.} = enum
    unknown     = 0
    android     = 1_095_648_338
    iphone      = 1_229_998_159
    macOS       = 1_330_862_112
    raspberryPI = 1_380_012_880
    sdl         = 1_396_984_882
    windows     = 1_464_421_956
    gp2xwiz     = 1_464_424_992
    xglx        = 1_481_067_608
  AllegroStandardPath* {.pure.} = enum
    resourcesPath     = 0
    tempPath          = 1
    userDataPath      = 2
    userHomePath      = 3
    userSettingsPath  = 4
    userDocumentsPath = 5
    exeNamePath       = 6
    lastPath          = 7 # must be last

{.push importc, dynlib: library.allegro.}
proc al_install_system(version: cint; atexit_ptr: proc (a1: proc ()): cint): bool
proc al_uninstall_system(): void
proc al_is_system_installed(): bool

proc al_get_system_driver(): AllegroSystem
proc al_get_system_config(): AllegroConfig
proc al_get_system_id(): AllegroSystemID

proc al_get_standard_path(id: cint): AllegroPath
proc al_set_exe_name(path: cstring): void

proc al_set_org_name(org_name: cstring): void
proc al_set_app_name(app_name: cstring): void
proc al_get_org_name(): cstring
proc al_get_app_name(): cstring

proc al_inhibit_screensaver(inhibit: bool): bool
{.pop.}

proc atexit(fun: proc ()): cint {.importc, header: "<stdlib.h>".}

let allegroVersionInt {.importc: "ALLEGRO_VERSION_INT", header: "<allegro5/base.h>".}: cint

proc installAllegro*(): void =
  ## Initialize the Allegro system. No other Allegro functions can be called
  ## before this (with one or two exceptions).
  discard al_install_system(allegroVersionInt, atexit);

proc uninstallAllegro*(): void =
  ## Closes down the Allegro system.
  al_uninstall_system()

proc isAlegroInstalled*(): bool =
  ## Returns true if Allegro is initialized, otherwise returns false.
  return al_is_system_installed()

proc allegroSystemDriver*(): AllegroSystem =
  ## Returns the currently active system driver.
  return al_get_system_driver()

proc allegroSystemConfig*(): AllegroConfig =
  ## Returns the system configuration structure. The returned configuration should
  ## not be destroyed with al_destroy_config. This is mainly used for configuring
  ## Allegro and its addons. You may populate this configuration before Allegro is
  ## installed to control things like the logging levels and other features.
  ## 
  ## Allegro will try to populate this configuration by loading a configuration file
  ## from a few different locations, in this order:
  ## 
  ## * Unix only: /etc/allegro5rc
  ## * Unix only: $HOME/allegro5rc
  ## * Unix only: $HOME/.allegro5rc
  ## * allegro5.cfg next to the executable
  ## 
  ## If multiple copies are found, then they are merged using al_merge_config_into.
  ## 
  ## The contents of this file are documented inside a prototypical allegro5.cfg
  ## thatyou can find in the root directory of the source distributions of Allegro.
  ## They are also reproduced below.
  ## 
  ## Note that Allegro will not look into that file unless you make a copy of it
  ## and place it next to your executable!
  return al_get_system_config()

proc allegroSystemID*(): AllegroSystemID =
  ## Returns the platform that Allegro is running on.
  return al_get_system_id()

proc allegroStandardPath*(id: AllegroStandardPath): AllegroPath =
  ## Gets a system path, depending on the id parameter. Some of these paths may be
  ## affected by the organization and application name, so be sure to set those
  ## beforecalling this function.
  ## 
  ## The paths are not guaranteed to be unique (e.g., SETTINGS and DATA may be the
  ## same on some platforms), so you should be sure your filenames are unique if
  ## you need to avoid naming collisions. Also, a returned path may not actually
  ## exist on the file system.
  return al_get_standard_path(id.cint)

proc allegroExeName*(path: string): void =
  ## This override the executable name used by allegroStandardPath for
  ## AllegroStandardPath.exeNamePath and AllegroStandardPath.resourcesPath.
  ## 
  ## One possibility where changing this can be useful is if you use the Python wrapper.
  ## Allegro would then by default think that the system’s Python executable is the
  ## current executable - but you can set it to the .py file being executed instead.
  al_set_exe_name(path)

proc allegroOrgName*(orgName: string): void =
  ## Sets the global organization name.
  ## 
  ## The organization name is used by allegroStandardPath to build the
  ## full path to an application’s files.
  al_set_org_name(org_name)

proc allegroAppName*(appName: cstring): void =
  ## Sets the global application name.
  ## 
  ## The application name is used by allegroStandardPath to build the
  ## full path to an application’s files.
  al_set_app_name(app_name)

proc allegroOrgName*(): string =
  ## Returns the global organization name string.
  return $al_get_org_name()

proc allegroAppName*(): string =
  ## Returns the global application name string.
  return $al_get_app_name()

proc allegroInhibitScreensaver*(inhibit: bool): void =
  ## This function allows the user to stop the system screensaver from starting
  ## up if true is passed, or resets the system back to the default state
  ## (the state at program start) if false is passed. It returns true if the
  ## state was set successfully, otherwise false.
  discard al_inhibit_screensaver(inhibit)
