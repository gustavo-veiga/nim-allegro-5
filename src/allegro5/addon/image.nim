import ../private/library

{.push importc, dynlib: library.imageAddon.}
proc al_init_image_addon(): bool
proc al_is_image_addon_initialized(): bool
proc al_shutdown_image_addon(): void
proc al_get_allegro_image_version(): cuint
{.pop.}

proc installAllegroImageAddon*(): void =
  ## Initializes the image addon. This registers bitmap format handlers
  ## for al_load_bitmap, al_load_bitmap_f, al_save_bitmap, al_save_bitmap_f.
  ## 
  ## The following types are built into the Allegro image addon and guaranteed
  ## to be available: BMP, DDS, PCX, TGA. Every platform also supports JPEG and
  ## PNG via external dependencies.
  ## 
  ## Other formats may be available depending on the operating system and
  ## installed libraries, but are not guaranteed and should not be assumed to be
  ## universally available.
  ## 
  ## The DDS format is only supported to load from, and only if the DDS file contains
  ## textures compressed in the DXT1, DXT3 and DXT5 formats. Note that when loading a
  ## DDS file, the created bitmap will always be a video bitmap and will have the pixel
  ## format matching the format in the file.
  discard al_init_image_addon()

proc isImageAddonInitialized*(): bool =
  ## Returns true if the image addon is initialized, otherwise returns false.
  return al_is_image_addon_initialized()

proc uninstallAllegroImageAddon*(): void =
  ## Shut down the image addon. This is done automatically at program exit,
  ## but can be called any time the user wishes as well.
  al_shutdown_image_addon()

proc allegroImageAddonVersion*(): uint =
  ## Returns the (compiled) version of the addon.
  return al_get_allegro_image_version().uint
