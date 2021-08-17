import private/library, bitmap, color

type
  AllegroBitmapBlittingFlag* {.pure.} = enum
    flipHorizontal = 0x00001
    flipVertical   = 0x00002

{.push importc, dynlib: library.allegro.}
#[ Blitting ]#
proc al_draw_bitmap(bitmap: AllegroBitmap, dx, dy: cfloat, flags: cint)
proc al_draw_bitmap_region(bitmap: AllegroBitmap, sx, sy, sw, sh, dx, dy: cfloat, flags: cint): void
proc al_draw_scaled_bitmap(bitmap: AllegroBitmap, sx, sy, sw, sh, dx, dy, dw, dh: cfloat, flags: cint): void
proc al_draw_rotated_bitmap(bitmap: AllegroBitmap, cx, cy, dx, dy, angle: cfloat, flags: cint): void
proc al_draw_scaled_rotated_bitmap(bitmap: AllegroBitmap, cx, cy, dx, dy, xscale, yscale, angle: cfloat, flags: cint): void

#[ Tinted blitting ]#
proc al_draw_tinted_bitmap(bitmap: AllegroBitmap, tint: AllegroColor, dx, dy: cfloat, flags: cint);
proc al_draw_tinted_bitmap_region(bitmap: AllegroBitmap, tint: AllegroColor, sx, sy, sw, sh, dx, dy: cfloat, flags: cint): void
proc al_draw_tinted_scaled_bitmap(bitmap: AllegroBitmap, tint: AllegroColor, sx, sy, sw, sh, dx, dy, dw, dh: cfloat, flags: cint): void
proc al_draw_tinted_rotated_bitmap(bitmap: AllegroBitmap, tint: AllegroColor, cx, cy, dx, dy, angle: cfloat, flags: cint);
proc al_draw_tinted_scaled_rotated_bitmap(bitmap: AllegroBitmap, tint: AllegroColor, cx, cy, dx, dy, xscale, yscale, angle: cfloat, flags: cint): void
proc al_draw_tinted_scaled_rotated_bitmap_region(bitmap: AllegroBitmap, sx, sy, sw, sh: cfloat, tint: AllegroColor, cx, cy, dx, dy, xscale, yscale, angle: cfloat, flags: cint): void
{.pop.}
