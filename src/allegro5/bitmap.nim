import std/sequtils
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
  ## Sets the pixel format (ALLEGRO_PIXEL_FORMAT) for newly created bitmaps.
  ## The default format is 0 and means the display driver will choose the
  ## best format.
  al_set_new_bitmap_format(format.cint)

proc bitmapFlags*(flags: varargs[AllegroBitmapFlag]): void =
  ## Sets the flags to use for newly created bitmaps.
  let flagInt = flags.mapIt(it.cint).foldl(a or b)
  al_set_new_bitmap_flags(flagInt)

proc bitmapFormat*(): int =
  # Returns the format used for newly created bitmaps.
  return al_get_new_bitmap_format()

proc bitmapFlags*(): int =
  ## Returns the format used for newly created bitmaps.
  return al_get_new_bitmap_flags()

proc addBitmapFlag*(flag: AllegroBitmapFlag): void =
  ## A convenience function which does the same as
  ## al_set_new_bitmap_flags(al_get_new_bitmap_flags() | flag);
  al_add_new_bitmap_flag(flag.cint)

proc newAllegroBitmap*(width, height: uint): AllegroBitmap =
  ## Creates a new bitmap using the bitmap format and flags for the current
  ## thread. Blitting between bitmaps of differing formats, or blitting between
  ## memory bitmaps and display bitmaps may be slow.
  return al_create_bitmap(width.cint, height.cint)

proc free*(bitmap: AllegroBitmap): void =
  ## Destroys the given bitmap, freeing all resources used by it. 
  al_destroy_bitmap(bitmap)

proc width*(bitmap: AllegroBitmap): uint =
  ## Returns the width of a bitmap in pixels.
  return al_get_bitmap_width(bitmap).uint

proc height*(bitmap: AllegroBitmap): uint =
  ## Returns the height of a bitmap in pixels.
  return al_get_bitmap_height(bitmap).uint

proc format*(bitmap: AllegroBitmap): uint =
  ## Returns the pixel format of a bitmap.
  return al_get_bitmap_format(bitmap).uint

proc flags*(bitmap: AllegroBitmap): int =
  ## Return the flags used to create the bitmap.
  return al_get_bitmap_flags(bitmap)

proc pixel*(color: AllegroColor, x, y: int): void =
  ## Draw a single pixel on the target bitmap. This operation is slow on non-memory bitmaps.
  ## Consider locking the bitmap if you are going to use this function multiple times on the
  ## same bitmap. This function is not affected by the transformations or the color blenders.
  al_put_pixel(x.cint, y.cint, color)

proc blendedPixel*(color: AllegroColor, x, y: int): void =
  al_put_blended_pixel(x.cint, y.cint, color)

proc pixel*(bitmap: AllegroBitmap, x, y: cint): AllegroColor =
  ## Like al_put_pixel, but the pixel color is blended using the current blenders
  ## before being drawn.
  return al_get_pixel(bitmap, x.cint, y.cint)

#[ Masking ]#
proc maskToAlpha*(bitmap: AllegroBitmap, maskColor: AllegroColor): void =
  ## Convert the given mask color to an alpha channel in the bitmap. Can be used
  ## to convert older 4.2-style bitmaps with magic pink to alpha-ready bitmaps.
  al_convert_mask_to_alpha(bitmap, maskColor)

#[ Clipping ]#
proc clippingRectangle*(x, y: int, width, height: uint): void =
  ## Set the region of the target bitmap or display that pixels get clipped to.
  ## The default is to clip pixels to the entire bitmap.
  al_set_clipping_rectangle(x.cint, y.cint, width.cint, height.cint)

proc resetClippingRectangle*(): void =
  ## Equivalent to calling 'clippingRectangle(0, 0, w, h)' where w and h
  ## are the width and height of the target bitmap respectively.
  ## 
  ## Does nothing if there is no target bitmap.
  al_reset_clipping_rectangle()

proc clippingRectangle*(): tuple[x, y: int, width, height: uint] =
  ## Gets the clipping rectangle of the target bitmap.
  var xV, yV, wV, hV: cint = 0
  al_get_clipping_rectangle(xV, yV, wV, hV)
  return (xV.int, yV.int, wV.uint, hV.uint)

#[ Sub bitmaps ]#
proc createSubBitmap*(parent: AllegroBitmap, x, y: int, width, height: uint): AllegroBitmap =
  ## Creates a sub-bitmap of the parent, at the specified coordinates and of the specified
  ##  size. A sub-bitmap is a bitmap that shares drawing memory with a pre-existing
  ## (parent) bitmap, but possibly with a different size and clipping settings.
  ## 
  ## The sub-bitmap may originate off or extend past the parent bitmap.
  ## 
  ## See the discussion in al_get_backbuffer about using sub-bitmaps of the backbuffer.
  ## 
  ## The parent bitmap’s clipping rectangles are ignored.
  ## 
  ## If a sub-bitmap was not or cannot be created then NULL is returned.
  ## 
  ## When you are done with using the sub-bitmap you must call al_destroy_bitmap on it
  ## to free any resources allocated for it.
  ## 
  ## Note that destroying parents of sub-bitmaps will not destroy the sub-bitmaps;
  ## instead the sub-bitmaps become invalid and should no longer be used for drawing
  ## - they still must be destroyed with al_destroy_bitmap however. It does not matter
  ## whether you destroy a sub-bitmap before or after its parent otherwise.
  return al_create_sub_bitmap(parent, x.cint, y.cint, width.cint, height.cint)

proc isSubBitmap*(bitmap: AllegroBitmap): bool =
  ## Returns true if the specified bitmap is a sub-bitmap, false otherwise.
  return al_is_sub_bitmap(bitmap)

proc parentBitmap*(bitmap: AllegroBitmap): AllegroBitmap =
  ## Returns the bitmap this bitmap is a sub-bitmap of.
  return al_get_parent_bitmap(bitmap)

proc x*(bitmap: AllegroBitmap): int =
  ## For a sub-bitmap, return it's x position within the parent.
  return al_get_bitmap_x(bitmap)

proc y*(bitmap: AllegroBitmap): int =
  ## For a sub-bitmap, return it's y position within the parent.
  return al_get_bitmap_y(bitmap)

proc reparent*(bitmap, parent: AllegroBitmap, x, y: int, width, height: uint): void =
  ## For a sub-bitmap, changes the parent, position and size. This is the same as
  ## destroying the bitmap and re-creating it with al_create_sub_bitmap - except
  ## the bitmap pointer stays the same. This has many uses, for example an animation
  ## player could return a single bitmap which can just be re-parented to different
  ## animation frames without having to re-draw the contents. Or a sprite atlas could
  ## re-arrange its sprites without having to invalidate all existing bitmaps.
  al_reparent_bitmap(bitmap, parent, x.cint, y.cint, width.cint, height.cint)

#[ Miscellaneous ]#
proc clone*(bitmap: AllegroBitmap): AllegroBitmap =
  ## Create a new bitmap with al_create_bitmap, and copy the pixel data from the old
  ## bitmap across. The newly created bitmap will be created with the current new bitmap
  ## flags, and not the ones that were used to create the original bitmap. If the
  ## newbitmap is a memory bitmap, its projection bitmap is reset to be orthographic.
  return al_clone_bitmap(bitmap)

template `=`*(bitmap: AllegroBitmap): AllegroBitmap =
  ## Create a new bitmap with al_create_bitmap, and copy the pixel data from the old
  ## bitmap across. The newly created bitmap will be created with the current new bitmap
  ## flags, and not the ones that were used to create the original bitmap. If the
  ## newbitmap is a memory bitmap, its projection bitmap is reset to be orthographic.
  return al_clone_bitmap(bitmap)

proc convert*(bitmap: AllegroBitmap): void =
  ## Converts the bitmap to the current bitmap flags and format. The bitmap will be as
  ## if it was created anew with al_create_bitmap but retain its contents. All of this
  ## bitmap’s sub-bitmaps are also converted. If the new bitmap type is memory, then
  ## the bitmap’s projection bitmap is reset to be orthographic.
  ## 
  ## If this bitmap is a sub-bitmap, then it, its parent and all the sibling
  ## sub-bitmaps are also converted.
  al_convert_bitmap(bitmap)

proc convertMemoryBitmaps*(): void =
  ## If you create a bitmap when there is no current display (for example because
  ## you have not called al_create_display in the current thread) and are using the
  ## ALLEGRO_CONVERT_BITMAP bitmap flag (which is set by default) then the bitmap
  ## will be created successfully, but as a memory bitmap. This function converts
  ## all such bitmaps to proper video bitmaps belonging to the current display.
  ## 
  ## Note that video bitmaps get automatically converted back to memory bitmaps when
  ## the last display is destroyed.
  ## 
  ## This operation will preserve all bitmap flags except ALLEGRO_VIDEO_BITMAP
  ## and ALLEGRO_MEMORY_BITMAP.
  al_convert_memory_bitmaps()
