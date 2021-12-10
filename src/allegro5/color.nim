import private/library

type
  AllegroColor* = object
    r*, g*, b*, a*: cfloat
  AllegroPixelFormat* {.pure.} = enum
    anyFormat           = 0
    anyNoAlpha          = 1
    anyWithAlpha        = 2
    any15NoAlpha        = 3
    any16NoAlpha        = 4
    any16WithAlpha      = 5
    any24NoAlpha        = 6
    any32NoAlpha        = 7
    any32WithAlpha      = 8
    argb8888            = 9
    rgga8888            = 10
    argb4444            = 11
    rgb888              = 12 # 24 bit format
    rgb565              = 13
    rgb555              = 14
    rgba5551            = 15
    argb1555            = 16
    abgr8888            = 17
    xbgr8888            = 18
    bgr888              = 19 # 24 bit format
    bgr565              = 20
    bgr555              = 21
    rgbx8888            = 22
    xrgb8888            = 23
    abgrF32             = 24
    abgr8888Le          = 25
    rgba4444            = 26
    singleChannel8      = 27
    compressedRgbaDxt1  = 28
    compressedRgbaDxt3  = 29
    compressedRgbaDxt5  = 30
    numPixelFormats     = 31

{.push importc, dynlib: library.allegro.}
#[ Pixel mapping ]#
proc al_map_rgb(r, g, b: cuchar): AllegroColor
proc al_map_rgba(r, g, b, a: cuchar): AllegroColor
proc al_map_rgb_f(r, g, b: cfloat): AllegroColor
proc al_map_rgba_f(r, g, b, a: cfloat): AllegroColor
proc al_premul_rgba(r, g, b, a: cuchar): AllegroColor
proc al_premul_rgba_f(r, g, b, a: cfloat): AllegroColor

#[ Pixel unmapping ]#
proc al_unmap_rgb(color: AllegroColor, r, g, b: var cint): void
proc al_unmap_rgba(color: AllegroColor, r, g, b, a: var cint): void
{.pop.}

proc newAllegroMapRGB*(r, g, b: uint8): AllegroColor =
  ## Convert r, g, b (ranging from 0-255) into an AllegroColor, using 255 for alpha.
  ## 
  ## This function can be called before Allegro is initialized.
  return al_map_rgb(r.cuchar, g.cuchar, b.cuchar)

proc newAllegroMapRGBA*(r, g, b, a: uint8): AllegroColor =
  ## Convert r, g, b, a (ranging from 0-255) into an AllegroColor.
  ## 
  ## This function can be called before Allegro is initialized.
  return al_map_rgba(r.cuchar, g.cuchar, b.cuchar, a.cuchar)

proc newAllegroMapRGB*(r, g, b: float32): AllegroColor =
  ## Convert r, g, b, (ranging from 0.0'f-1.0'f) into an AllegroColor, using 1.0'f for alpha.
  ## 
  ## This function can be called before Allegro is initialized.
  return al_map_rgb_f(r, g, b)

proc newAllegroMapRGBA*(r, g, b, a: float32): AllegroColor =
  ## Convert r, g, b, a (ranging from 0.0'f-1.0'f) into an AllegroColor.
  ## 
  ## This function can be called before Allegro is initialized.
  return al_map_rgba_f(r, g, b, a)

proc newAllegroPreMultipliedRGBA*(r, g, b, a: uint8): AllegroColor =
  ## This is a shortcut for newAllegroMapRGBA(r * a / 255, g * a / 255, b * a / 255, a).
  ## 
  ## By default Allegro uses pre-multiplied alpha for transparent blending of bitmaps
  ## and primitives (see al_load_bitmap_flags for a discussion of that feature). This
  ## means that if you want to tint a bitmap or primitive to be transparent you need to
  ## multiply the color components by the alpha components when you pass them to this
  ## function. For example:
  ## 
  ## .. code-block:: nim
  ##   let
  ##     r: uint8 = 255
  ##     g: uint8 = 0
  ##     b: uint8 = 0
  ##     a: uint8 = 127
  ##   var color: AllegroColor = newAllegroPreMultipliedRGBA(r, g, b, a)
  ##   #[ Draw the bitmap tinted red and half-transparent ]#
  ##   bitmap.drawTinted(color, 0, 0, 0)
  ## 
  ## This function can be called before Allegro is initialized.
  return al_premul_rgba(r.cuchar, g.cuchar, b.cuchar, a.cuchar)

proc newAllegroPreMultipliedRGBA*(r, g, b, a: float32): AllegroColor =
  ## This is a shortcut for newAllegroMapRGBA(r * a, g * a, b * a, a).
  ## 
  ## By default Allegro uses pre-multiplied alpha for transparent blending of bitmaps
  ## and primitives (see al_load_bitmap_flags for a discussion of that feature). This
  ## means that if you want to tint a bitmap or primitive to be transparent you need to
  ## multiply the color components by the alpha components when you pass them to this
  ## function. For example:
  ## 
  ## .. code-block:: nim
  ##   let
  ##     r: float = 1
  ##     g: float = 0
  ##     b: float = 0
  ##     a: float = 0.5
  ##   var color: AllegroColor = newAllegroPreMultipliedRGBA(r, g, b, a)
  ##   #[ Draw the bitmap tinted red and half-transparent ]#
  ##   bitmap.drawTinted(color, 0, 0, 0)
  ## 
  ## This function can be called before Allegro is initialized.
  return al_premul_rgba_f(r, g, b, a)

proc unmapRGB*(color: AllegroColor): tuple[r, g, b: uint8] =
  ## Retrieves components of an AllegroColor, ignoring alpha. Components will range from 0-255.
  ## 
  ## This function can be called before Allegro is initialized.
  var r, g, b: cint = 0
  al_unmap_rgb(color, r, g, b)
  return (r.uint8, g.uint8, b.uint8)

proc unmapRGBA*(color: AllegroColor): tuple[r, g, b, a: uint8] =
  ## Retrieves components of an AllegroColor. Components will range from 0-255.
  ## 
  ## This function can be called before Allegro is initialized.
  var r, g, b, a: cint = 0
  al_unmap_rgba(color, r, g, b, a)
  return (r.uint8, g.uint8, b.uint8, a.uint8)
