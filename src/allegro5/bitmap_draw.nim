import private/library, bitmap, color

type
  AllegroBitmapBlittingFlag* {.pure.} = enum
    flipNone        = 0x00000
    flipHorizontal  = 0x00001
    flipVertical    = 0x00002

{.push importc, dynlib: library.allegro.}
#[ Blitting ]#
proc al_draw_bitmap(bitmap: AllegroBitmap, dx, dy: cfloat, flags: cint): void
proc al_draw_bitmap_region(bitmap: AllegroBitmap, sx, sy, sw, sh, dx, dy: cfloat, flags: cint): void
proc al_draw_scaled_bitmap(bitmap: AllegroBitmap, sx, sy, sw, sh, dx, dy, dw, dh: cfloat, flags: cint): void
proc al_draw_rotated_bitmap(bitmap: AllegroBitmap, cx, cy, dx, dy, angle: cfloat, flags: cint): void
proc al_draw_scaled_rotated_bitmap(bitmap: AllegroBitmap, cx, cy, dx, dy, xscale, yscale, angle: cfloat, flags: cint): void

#[ Tinted blitting ]#
proc al_draw_tinted_bitmap(bitmap: AllegroBitmap, tint: AllegroColor, dx, dy: cfloat, flags: cint): void
proc al_draw_tinted_bitmap_region(bitmap: AllegroBitmap, tint: AllegroColor, sx, sy, sw, sh, dx, dy: cfloat, flags: cint): void
proc al_draw_tinted_scaled_bitmap(bitmap: AllegroBitmap, tint: AllegroColor, sx, sy, sw, sh, dx, dy, dw, dh: cfloat, flags: cint): void
proc al_draw_tinted_rotated_bitmap(bitmap: AllegroBitmap, tint: AllegroColor, cx, cy, dx, dy, angle: cfloat, flags: cint): void
proc al_draw_tinted_scaled_rotated_bitmap(bitmap: AllegroBitmap, tint: AllegroColor, cx, cy, dx, dy, xscale, yscale, angle: cfloat, flags: cint): void
proc al_draw_tinted_scaled_rotated_bitmap_region(bitmap: AllegroBitmap, sx, sy, sw, sh: cfloat, tint: AllegroColor, cx, cy, dx, dy, xscale, yscale, angle: cfloat, flags: cint): void
{.pop.}

proc draw*(bitmap: AllegroBitmap, destination: tuple[x, y: float32], flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Draws an unscaled, unrotated bitmap at the given position to the
  ## current target bitmap.
  ## 
  ## Note: The current target bitmap must be a different bitmap. Drawing
  ## a bitmap to itself (or to a sub-bitmap of itself) or drawing a
  ## sub-bitmap to its parent (or another sub-bitmap of its parent) are
  ## not currently supported. To copy part of a bitmap into the same bitmap
  ## simply use a temporary bitmap instead.
  ## 
  ## Note: The backbuffer (or a sub-bitmap thereof) can not be transformed,
  ## blended or tinted. If you need to draw the backbuffer draw it to a
  ## temporary bitmap first with no active transformation (except translation).
  ## Blending and tinting settings/parameters will be ignored. This does not
  ## apply when drawing into a memory bitmap.
  al_draw_bitmap(bitmap, destination.x, destination.y, flags.cint)

proc drawRegion*(bitmap: AllegroBitmap, source: tuple[x, y, width, height: float32], destination: tuple[x, y: float32], flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Draws a region of the given bitmap to the target bitmap.
  al_draw_bitmap_region(bitmap, source.x, source.y, source.width, source.height, destination.x, destination.y, flags.cint)

proc drawScaled*(bitmap: AllegroBitmap, source, destination: tuple[x, y, width, height: float32], flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Draws a scaled version of the given bitmap to the target bitmap.
  al_draw_scaled_bitmap(bitmap, source.x, source.y, source.width, source.height, destination.x, destination.y, destination.width, destination.height, flags.cint)

proc drawRotated*(bitmap: AllegroBitmap, center, destination: tuple[x, y: float32], angle: float32, flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Draws a rotated version of the given bitmap to the target bitmap.
  ## The bitmap is rotated by 'angle' radians clockwise.
  ## 
  ## The point at center.x / center.y relative to the upper left corner
  ## of the bitmap will be drawn at destination.x/destination.y and the
  ## bitmap is rotated around this point. If center (x,y) is (0,0) the
  ## bitmap will rotate around its upper left corner.
  al_draw_rotated_bitmap(bitmap, center.x, center.y, destination.x, destination.y, angle, flags.cint)

proc drawScaledRotated*(bitmap: AllegroBitmap, center, destination, scale: tuple[x, y: float32], angle: float, flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Like al_draw_rotated_bitmap, but can also scale the bitmap.
  ## 
  ## The point at center.x / center.y in the bitmap will be drawn
  ## at destination.x / destination.y and the bitmap is rotated
  ## and scaled around this point.
  al_draw_scaled_rotated_bitmap(bitmap, center.x, center.y, destination.x, destination.y, scale.x, scale.y, angle, flags.cint)

proc drawTinted*(bitmap: AllegroBitmap, tint: AllegroColor, destination: tuple[x, y: float32], flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Like al_draw_bitmap but multiplies all colors in the bitmap with the
  ## given color. For example:
  ## 
  ## .. code-block:: nim
  ##   bitmap.drawTinted(newAllegroMapRGBA(0.5, 0.5, 0.5, 0.5), (x, y))
  ## 
  ## The above will draw the bitmap 50% transparently (r/g/b values need to
  ## be pre-multiplied with the alpha component with the default blend mode).
  ## 
  ## .. code-block:: nim
  ##   bitmap.drawTinted(newAllegroMapRGBA(1, 0, 0, 1), (x, y))
  ## 
  ## The above will only draw the red component of the bitmap.
  ## 
  ## See al_draw_bitmap for a note on restrictions on which bitmaps can be
  ## drawn where.
  al_draw_tinted_bitmap(bitmap, tint, destination.x, destination.y, flags.cint)

proc drawTintedRegion*(bitmap: AllegroBitmap, tint: AllegroColor, source: tuple[x, y, width, height: float32], destination: tuple[x, y: float32], flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Like `drawRegion` but multiplies all colors in the bitmap with the given color.
  ## 
  ## See `draw` for a note on restrictions on which bitmaps can be drawn where.
  al_draw_tinted_bitmap_region(bitmap, tint, source.x, source.y, source.width, source.height, destination.x, destination.y, flags.cint)

proc drawTintedScaled*(bitmap: AllegroBitmap, tint: AllegroColor, source, destination: tuple[x, y, width, height: float32], flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Like `drawScaled` but multiplies all colors in the bitmap with the given color.
  ## 
  ## See `draw` for a note on restrictions on which bitmaps can be drawn where.
  al_draw_tinted_scaled_bitmap(bitmap, tint, source.x, source.y, source.width, source.height, destination.x, destination.y, destination.width, destination.height, flags.cint)

proc drawTintedRotated*(bitmap: AllegroBitmap, tint: AllegroColor, center, destination: tuple[x, y: float32], angle: float32, flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Like al_draw_rotated_bitmap but multiplies all colors in the bitmap with
  ## the given color.
  al_draw_tinted_rotated_bitmap(bitmap, tint, center.x, center.y, destination.x, destination.y, angle, flags.cint)

proc drawTintedScaledRotated*(bitmap: AllegroBitmap, tint: AllegroColor, center, destination, scale: tuple[x, y: float32], angle: float32, flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Like al_draw_rotated_bitmap, but can also scale the bitmap.
  al_draw_tinted_scaled_rotated_bitmap(bitmap, tint, center.x, center.y, destination.x, destination.y, scale.x, scale.y, angle, flags.cint)

proc drawTintedScaledRotatedRegion*(bitmap: AllegroBitmap, tint: AllegroColor, source: tuple[x, y, width, height: float32], center, destination, scale: tuple[x, y: float32], angle: float32, flags: AllegroBitmapBlittingFlag = flipNone): void =
  ## Like al_draw_scaled_rotated_bitmap but multiplies all colors in the
  ## bitmap with the given color.
  al_draw_tinted_scaled_rotated_bitmap_region(bitmap, source.x, source.y, source.width, source.height, tint, center.x, center.y, destination.x, destination.y, scale.x, scale.y, angle, flags.cint)
