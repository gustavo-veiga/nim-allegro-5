import ../private/library

{.push importc, dynlib: library.physfsAddon.}
proc al_set_physfs_file_interface(): void
proc al_get_allegro_physfs_version(): cuint
{.pop.}

proc physfsFileInterface*(): void =
  al_set_physfs_file_interface()

proc allegroPhysfsVersion*(): uint =
  return al_get_allegro_physfs_version()
