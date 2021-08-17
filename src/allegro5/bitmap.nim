import private/library, color

type
  AllegroBitmap* = ptr object
  AllegroBitmapFlag* {.pure.} = enum
    memoryBitmap          = 0x0001
    keepBitmapFormat      = 0x0002 # now a bitmap loader flag
    forceLocking          = 0x0004 # no longer honoured
    noPreserveTexture     = 0x0008
    alphaTest             = 0x0010 # now a render state flag
    internalOpenGL        = 0x0020
    minLinear             = 0x0040
    magLinear             = 0x0080
    mipmap                = 0x0100
    noPremultipliedAlpha  = 0x0200 # now a bitmap loader flag
    videoBitmap           = 0x0400
    convertBitmap         = 0x1000

{.push importc, dynlib: library.allegro.}
proc al_set_new_bitmap_format(format: cint): void
proc al_set_new_bitmap_flags(flags: cint): void
proc al_get_new_bitmap_format(): cint
proc al_get_new_bitmap_flags(): cint
proc al_add_new_bitmap_flag(flag: cint): void

proc al_get_bitmap_width(bitmap: AllegroBitmap): cint
proc al_get_bitmap_height(bitmap: AllegroBitmap): cint
proc al_get_bitmap_format(bitmap: AllegroBitmap): cint
proc al_get_bitmap_flags(bitmap: AllegroBitmap): cint

proc al_create_bitmap(w, h: cint): AllegroBitmap
proc al_destroy_bitmap(bitmap: AllegroBitmap): void

proc al_put_pixel(x, y: cint, color: AllegroColor): void
proc al_put_blended_pixel(x, y: cint, color: AllegroColor): void
proc al_get_pixel(bitmap: AllegroBitmap, x, y: cint): AllegroColor

#[ Masking ]#
proc al_convert_mask_to_alpha(bitmap: AllegroBitmap, maskColor: AllegroColor): void

#[ Clipping ]#
proc al_set_clipping_rectangle(x, y, width, height: cint): void
proc al_reset_clipping_rectangle(): void
proc al_get_clipping_rectangle(x, y, w, h: var cint): void

#[ Sub bitmaps ]#
proc al_create_sub_bitmap(parent: AllegroBitmap, x, y, w, h: cint): AllegroBitmap
proc al_is_sub_bitmap(bitmap: AllegroBitmap): bool
proc al_get_parent_bitmap(bitmap: AllegroBitmap): AllegroBitmap
proc al_get_bitmap_x(bitmap: AllegroBitmap): int
proc al_get_bitmap_y(bitmap: AllegroBitmap): int
proc al_reparent_bitmap(bitmap, parent: AllegroBitmap, x, y, w, h: cint): void

#[ Miscellaneous ]#
proc al_clone_bitmap(bitmap: AllegroBitmap): AllegroBitmap
proc al_convert_bitmap(bitmap: AllegroBitmap): void
proc al_convert_memory_bitmaps(): void
{.pop.}

proc bitmapFormat*(format: int): void =
  al_set_new_bitmap_format(format.cint)

proc bitmapFlags*(flags: int): void =
  al_set_new_bitmap_flags(flags.cint)

proc bitmapFormat*(): int =
  return al_get_new_bitmap_format()

proc bitmapFlags*(): int =
  return al_get_new_bitmap_flags()

proc addBitmapFlag*(flag: int): void =
  al_add_new_bitmap_flag(flag.cint)


proc newAllegroBitmap*(width, height: uint): AllegroBitmap =
  return al_create_bitmap(width.cint, height.cint)

proc free*(bitmap: AllegroBitmap): void =
  al_destroy_bitmap(bitmap)

proc width*(bitmap: AllegroBitmap): uint =
  return al_get_bitmap_width(bitmap).uint

proc height*(bitmap: AllegroBitmap): uint =
  return al_get_bitmap_height(bitmap).uint

proc format*(bitmap: AllegroBitmap): uint =
  return al_get_bitmap_format(bitmap).uint

proc flags*(bitmap: AllegroBitmap): int =
  return al_get_bitmap_flags(bitmap).int

proc pixel*(color: AllegroColor, x, y: int): void =
  al_put_pixel(x.cint, y.cint, color)

proc blendedPixel*(color: AllegroColor, x, y: int): void =
  al_put_blended_pixel(x.cint, y.cint, color)

proc pixel*(bitmap: AllegroBitmap, x, y: cint): AllegroColor =
  return al_get_pixel(bitmap, x.cint, y.cint)

#[ Masking ]#
proc maskToAlpha*(bitmap: AllegroBitmap, maskColor: AllegroColor): void =
  al_convert_mask_to_alpha(bitmap, maskColor)

#[ Clipping ]#
proc clippingRectangle*(x, y: int, width, height: uint): void =
  al_set_clipping_rectangle(x.cint, y.cint, width.cint, height.cint)

proc resetClippingRectangle*(): void =
  al_reset_clipping_rectangle()

proc clippingRectangle*(): tuple[x, y: int, width, height: uint] =
  var xV, yV, wV, hV: cint = 0
  al_get_clipping_rectangle(xV, yV, wV, hV)
  return (xV.int, yV.int, wV.uint, hV.uint)

#[ Sub bitmaps ]#
proc createSubBitmap*(parent: AllegroBitmap, x, y: int, width, height: uint): AllegroBitmap =
  return al_create_sub_bitmap(parent, x.cint, y.cint, width.cint, height.cint)

proc isSubBitmap*(bitmap: AllegroBitmap): bool =
  return al_is_sub_bitmap(bitmap)

proc parentBitmap*(bitmap: AllegroBitmap): AllegroBitmap =
  return al_get_parent_bitmap(bitmap)

proc x*(bitmap: AllegroBitmap): int =
 return al_get_bitmap_x(bitmap)

proc y*(bitmap: AllegroBitmap): int =
  return al_get_bitmap_y(bitmap)

proc reparent*(bitmap, parent: AllegroBitmap, x, y: int, width, height: uint): void =
  al_reparent_bitmap(bitmap, parent, x.cint, y.cint, width.cint, height.cint)

#[ Miscellaneous ]#
proc clone*(bitmap: AllegroBitmap): AllegroBitmap =
  return al_clone_bitmap(bitmap)

proc convert*(bitmap: AllegroBitmap): void =
  al_convert_bitmap(bitmap)

proc convertMemoryBitmaps*(): void =
  al_convert_memory_bitmaps()
