import private/library

type
  AllegroColor* = object
    r*, g*, b*, a*: cfloat
  AllegroPixelFormat* {.pure.} = enum
    any                 = 0
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
    singleChannel_8     = 27
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
{.pop.}

proc newAllegroMapRGB*(r, g, b: uint8): AllegroColor =
  return al_map_rgb(r.cuchar, g.cuchar, b.cuchar)

proc newAllegroMapRGBA*(r, g, b, a: uint8): AllegroColor =
  return al_map_rgba(r.cuchar, g.cuchar, b.cuchar, a.cuchar)

proc newAllegroColor*(r, g, b: uint8): AllegroColor =
  return al_map_rgb(r.cuchar, g.cuchar, b.cuchar)

proc newAllegroColor*(r, g, b, a: uint8): AllegroColor =
  return al_map_rgba(r.cuchar, g.cuchar, b.cuchar, a.cuchar)

proc newAllegroMapRGB*(r, g, b: float): AllegroColor =
  return al_map_rgb_f(r.cfloat, g.cfloat, b.cfloat)

proc newAllegroMapRGBA*(r, g, b, a: float): AllegroColor =
  return al_map_rgba_f(r.cfloat, g.cfloat, b.cfloat, a.cfloat)

proc newAllegroPreMultipliedRGBA*(r, g, b, a: uint8): AllegroColor =
  return al_premul_rgba(r.cuchar, g.cuchar, b.cuchar, a.cuchar)

proc newAllegroPreMultipliedRGBA*(r, g, b, a: float): AllegroColor =
  return al_premul_rgba_f(r.cfloat, g.cfloat, b.cfloat, a.cfloat)
