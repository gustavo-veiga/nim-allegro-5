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
  return al_lock_bitmap(bitmap, format.cint, flag.cint)

proc lockRegion*(bitmap: AllegroBitmap, flag: AllegroBitmapLockFlag, x, y: int, width, height: uint, format: int): AllegroLockedRegion =
  return al_lock_bitmap_region(bitmap, x.cint, y.cint, width.cint, height.cint, format.cint, flag.cint)

proc lockBlocked*(bitmap: AllegroBitmap, flag: AllegroBitmapLockFlag): AllegroLockedRegion =
  return al_lock_bitmap_blocked(bitmap, flag.cint)

proc lockRegionBlocked*(bitmap: AllegroBitmap, flag: AllegroBitmapLockFlag, x_block, y_block: int, width_block, height_block: uint): AllegroLockedRegion =
  return al_lock_bitmap_region_blocked(bitmap, x_block.cint, y_block.cint, width_block.cint, height_block.cint, flag.cint)

proc unlock*(bitmap: AllegroBitmap): void =
  al_unlock_bitmap(bitmap)

proc isLocked*(bitmap: AllegroBitmap): bool =
  return al_is_bitmap_locked(bitmap)
