import private/library, bitmap

type
  AllegroBitmapLoaderFlag* {.pure.} = enum
    keepBitmapFormat      = 0x0002
      ## Force the resulting AllegroBitmap to use the same format as the file.
    noPremultipliedAlpha  = 0x0200
      ## Loads an image file into a new AllegroBitmap. The file type is determined
      ## by theextension, except if the file has no extension in which case
      ## identifyBitmap is used instead.
    keepIndex             = 0x0800
      ## Load the palette indices of 8-bit .bmp and .pcx files instead of the rgb colors.

{.push importc, dynlib: library.allegro.}
proc al_load_bitmap(filename: cstring): AllegroBitmap
proc al_load_bitmap_flags(filename: cstring, flags: cint): AllegroBitmap
proc al_save_bitmap(filename: cstring, bitmap: AllegroBitmap): bool
proc al_identify_bitmap(filename: cstring): cstring
{.pop.}

proc newAllegroBitmap*(filename: string): AllegroBitmap =
  ## Loads an image file into a new AllegroBitmap. The file type is determined
  ## by theextension, except if the file has no extension in which case
  ## identifyBitmap is used instead.
  return al_load_bitmap(filename)

proc newAllegroBitmap*(filename: string, flag: AllegroBitmapLoaderFlag): AllegroBitmap =
  ## Loads an image file into a new AllegroBitmap. The file type is determined
  ## by theextension, except if the file has no extension in which case
  ## identifyBitmap is used instead.
  return al_load_bitmap_flags(filename, flag.cint)

proc save*(bitmap: AllegroBitmap, filename: string): void =
  ## Saves an AllegroBitmap to an image file. The file type is determined by the extension.
  discard al_save_bitmap(filename, bitmap)

proc identifyBitmap*(filename: string): string =
  return $al_identify_bitmap(filename)
