import std/sequtils, ../private/library, ../exceptions, font

type
  AllegroFontTTFFlag* {.pure.} = enum
    noKerning   = 1
    monochrome  = 2
    noAutohint  = 4

{.push importc, dynlib: library.ttfAddon.}
proc al_load_ttf_font(filename: cstring, size, flags: cint): AllegroFont
proc al_load_ttf_font_stretch(filename: cstring, w, h, flags: cint): AllegroFont
proc al_init_ttf_addon(): bool
proc al_is_ttf_addon_initialized(): bool
proc al_shutdown_ttf_addon(): void
proc al_get_allegro_ttf_version(): cuint
{.pop.}

proc installAllegroTTFAddon*(): void =
  let installed = al_init_ttf_addon()
  if not installed:
    raise new AllegroInstallTrueTypeFontException

proc newAllegroFontTTF*(filename: string, size: int, flags: varargs[AllegroFontTTFFlag]): AllegroFont =
  let flagInt = if flags.len > 0: flags.mapIt(it.cint).foldl(a or b) else: 0
  return al_load_ttf_font(filename, size.cint, flagInt)

proc newAllegroFontTTF*(filename: string, width, height: uint, flags: varargs[AllegroFontTTFFlag]): AllegroFont =
  let flagInt = if flags.len > 0: flags.mapIt(it.cint).foldl(a or b) else: 0
  return al_load_ttf_font_stretch(filename, width.cint, height.cint, flagInt)

proc isAllegroFontTTFInitialized*(): bool =
  return al_is_ttf_addon_initialized()
