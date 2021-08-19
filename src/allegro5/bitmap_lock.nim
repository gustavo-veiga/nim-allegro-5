import private/library, bitmap

type
  AllegroLockedRegion* = ptr object
    data*: pointer
    format*: cint
    pitch*: cint
    pixelSize*: cint
  AllegroBitmapLockFlag* {.pure.} = enum
    readWrite  = 0,
    readOnly   = 1,
    writeOnly  = 2

{.push importc, dynlib: library.allegro.}
proc al_lock_bitmap(bitmap: AllegroBitmap, format, flags: cint): AllegroLockedRegion
proc al_lock_bitmap_region(bitmap: AllegroBitmap, x, y, width, height, format, flags: cint): AllegroLockedRegion
proc al_lock_bitmap_blocked(bitmap: AllegroBitmap, flags: cint): AllegroLockedRegion
proc al_lock_bitmap_region_blocked(bitmap: AllegroBitmap, x_block, y_block, width_block, height_block, flags: cint): AllegroLockedRegion
proc al_unlock_bitmap(bitmap: AllegroBitmap): void
proc al_is_bitmap_locked(bitmap: AllegroBitmap): bool
{.pop.}

proc lock*(bitmap: AllegroBitmap, flag: AllegroBitmapLockFlag, format: int): AllegroLockedRegion =
  ## Lock an entire bitmap for reading or writing. If the bitmap is a display bitmap it
  ## will be updated from system memory after the bitmap is unlocked (unless locked read only).
  return al_lock_bitmap(bitmap, format.cint, flag.cint)

proc lockRegion*(bitmap: AllegroBitmap, flag: AllegroBitmapLockFlag, x, y: int, width, height: uint, format: int): AllegroLockedRegion =
  ## Like lock, but only locks a specific area of the bitmap. If the bitmap is
  ## a video bitmap, only that area of the texture will be updated when it is unlocked.
  ## Locking only the region you indend to modify will be faster than locking the whole bitmap.
  return al_lock_bitmap_region(bitmap, x.cint, y.cint, width.cint, height.cint, format.cint, flag.cint)

proc lockBlocked*(bitmap: AllegroBitmap, flag: AllegroBitmapLockFlag): AllegroLockedRegion =
  ## Like lock, but allows locking bitmaps with a blocked pixel format (i.e. a format
  ## for which al_get_pixel_block_width or al_get_pixel_block_height do not return 1)
  ## in that format. To that end, this function also does not allow format conversion.
  ## For bitmap formats with a block size of 1, this function is identical to calling
  ## al_lock_bitmap(bmp, al_get_bitmap_format(bmp), flags).
  return al_lock_bitmap_blocked(bitmap, flag.cint)

proc lockRegionBlocked*(bitmap: AllegroBitmap, flag: AllegroBitmapLockFlag, x_block, y_block: int, width_block, height_block: uint): AllegroLockedRegion =
  ## Like al_lock_bitmap_blocked, but allows locking a sub-region, for performance.
  ## Unlike al_lock_bitmap_region the region specified in terms of blocks and not pixels.
  return al_lock_bitmap_region_blocked(bitmap, x_block.cint, y_block.cint, width_block.cint, height_block.cint, flag.cint)

proc unlock*(bitmap: AllegroBitmap): void =
  ## Unlock a previously locked bitmap or bitmap region. If the bitmap is a video
  ## bitmap, the texture will be updated to match the system memory copy (unless
  ## it was locked read only).
  al_unlock_bitmap(bitmap)

proc isLocked*(bitmap: AllegroBitmap): bool =
  ## Returns whether or not a bitmap is already locked.
  return al_is_bitmap_locked(bitmap)
