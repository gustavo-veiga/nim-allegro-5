import private/library, font

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
  discard al_init_ttf_addon()

proc newAllegroFontTTF*(filename: string, size: int): AllegroFont =
  return al_load_ttf_font(filename, size.cint, 0)
