import private/library, bitmap

type
  AllegroBitmapLoaderFlag* {.pure.} = enum
    keepBitmapFormat      = 0x0002 # was a bitmap flag in 5.0
    noPremultipliedAlpha  = 0x0200 # was a bitmap flag in 5.0
    keepIndex             = 0x0800

{.push importc, dynlib: library.allegro.}
proc al_load_bitmap(filename: cstring): AllegroBitmap
proc al_load_bitmap_flags(filename: cstring, flags: cint): AllegroBitmap
proc al_save_bitmap(filename: cstring, bitmap: AllegroBitmap): bool
proc al_identify_bitmap(filename: cstring): cstring
{.pop.}

proc newAllegroBitmap*(filename: string): AllegroBitmap =
  return al_load_bitmap(filename)

proc newAllegroBitmap*(filename: string, flag: AllegroBitmapLoaderFlag): AllegroBitmap =
  return al_load_bitmap_flags(filename, flag.cint)

proc save*(bitmap: AllegroBitmap, filename: string): void =
  discard al_save_bitmap(filename, bitmap)

proc identifyBitmap*(filename: string): string =
  return $al_identify_bitmap(filename)
