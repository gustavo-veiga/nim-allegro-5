## PhysicsFS is a library to provide abstract access to various archives.
## See http://icculus.org/physfs/ for more information.
## 
## This addon makes it possible to read and write files (on disk or inside
## archives) using PhysicsFS, through Allegro’s file I/O API. For example,
## that means you can use the Image I/O addon to load images from .zip files.
## 
## You must set up PhysicsFS through its own API.

import allegro5/private/library

{.push importc, dynlib: library.physfsAddon.}
proc al_set_physfs_file_interface(): void
proc al_get_allegro_physfs_version(): cuint
{.pop.}

proc physfsFileInterface*(): void =
  ## This function sets both the ALLEGRO_FILE_INTERFACE and ALLEGRO_FS_INTERFACE
  ## for the calling thread.
  ## 
  ## Subsequent calls to al_fopen on the calling thread will be handled by
  ## PHYSFS_open(). Operations on the files returned by al_fopen will then
  ## be performed through PhysicsFS. Calls to the Allegro filesystem functions,
  ## such as al_read_directory or al_create_fs_entry, on the calling thread will
  ## be diverted to PhysicsFS.
  ## 
  ## To remember and restore another file I/O backend, you can use
  ## al_store_state/al_restore_state.
  ## 
  ## Note: due to an oversight, this function differs from
  ## al_set_new_file_interface and al_set_standard_file_interface which only alter
  ## the current ALLEGRO_FILE_INTERFACE.
  ## 
  ## Note: PhysFS does not support the text-mode reading and writing, which means
  ## that Windows-style newlines will not be preserved.
  al_set_physfs_file_interface()

proc allegroPhysfsVersion*(): uint =
  ## Returns the (compiled) version of the addon.
  return al_get_allegro_physfs_version()
