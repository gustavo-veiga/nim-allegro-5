import private/library, color

{.push importc, dynlib: library.allegro.}
proc al_clear_to_color(color: AllegroColor): void
proc al_clear_depth_buffer(x: cfloat): void
proc al_draw_pixel(x, y: cfloat, color: AllegroColor): void
{.pop.}

proc clearToColor*(color: AllegroColor): void =
  al_clear_to_color(color)

proc clearDepthBuffer*(x: float): void =
  al_clear_depth_buffer(x)

proc drawPixel*(color: AllegroColor, x, y: float): void =
  al_draw_pixel(x, y, color)
