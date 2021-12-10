import std/sequtils

import allegro5
import allegro5/private/library
import allegro5/[color, bitmap, exceptions]

type
  AllegroFont* = ptr object
  AllegroFontFlag* {.pure, final.} = enum
    noKerning       = -1
    alignLeft       = 0
    alignCenter     = 1
    alignRight      = 2
    alignInteger    = 4

{.push importc, dynlib: library.fontAddon.}
proc al_register_font_loader(ext: cstring, load_font: proc (filename: cstring, size, flags: cint): AllegroFont): bool
proc al_load_bitmap_font(filename: cstring): AllegroFont
proc al_load_bitmap_font_flags(filename: cstring, flags: cint): AllegroFont
proc al_load_font(filename: cstring, size, flags: cint): AllegroFont

proc al_grab_font_from_bitmap(bmp: allegro5.AllegroBitmap | bitmap.AllegroBitmap, n: cint, ranges: openArray[int]): AllegroFont
proc al_create_builtin_font(): AllegroFont

proc al_draw_text(font: AllegroFont, color: allegro5.AllegroColor | color.AllegroColor, x, y: cfloat, flags: cint, text: cstring): void
proc al_draw_justified_text(font: AllegroFont, color: allegro5.AllegroColor | color.AllegroColor, x1, x2, y, diff: cfloat, flags: cint, text: cstring): void
proc al_get_text_width(font: AllegroFont, str: cstring): cint
proc al_get_font_line_height(font: AllegroFont): cint
proc al_get_font_ascent(font: AllegroFont): cint
proc al_get_font_descent(font: AllegroFont): cint
proc al_destroy_font(font: AllegroFont): void
proc al_get_text_dimensions(font: AllegroFont, text: cstring, bbx, bby, bbw, bbh: var cint): void
proc al_init_font_addon(): bool
proc al_is_font_addon_initialized(): bool
proc al_shutdown_font_addon(): void
proc al_get_allegro_font_version(): cuint
proc al_get_font_ranges(font: AllegroFont, ranges_count: cint, ranges: var cint): cint

proc al_draw_glyph(font: AllegroFont, color: allegro5.AllegroColor | color.AllegroColor, x, y: cfloat, codepoint: cint): void
proc al_get_glyph_width(font: AllegroFont, codepoint: cint): cint
proc al_get_glyph_dimensions(font: AllegroFont, codepoint: cint, bbx, bby, bbw, bbh: var cint): bool
proc al_get_glyph_advance(font: AllegroFont, codepoint, codepoint2: cint): cint

proc al_draw_multiline_text(font: AllegroFont, color: allegro5.AllegroColor | color.AllegroColor, x, y, max_width, line_height: cfloat, flags: cint, text: cstring): void

proc al_do_multiline_text(font: AllegroFont; max_width: cfloat; text: cstring;
  cb: proc (line_num: cint; line: cstring; size: cint; extra: pointer): bool; extra: pointer): void

proc al_set_fallback_font(font, fallback: AllegroFont): void
proc al_get_fallback_font(font: AllegroFont): AllegroFont
{.pop.}

proc installAllegroFontAddon*(): void =
  ## Initialise the font addon.
  ## 
  ## Note that if you intend to load bitmap fonts, you will need to initialise
  ## installAllegroImageAddon separately (unless you are using another library
  ## to load images).
  ## 
  ## Similarly, if you wish to load truetype-fonts, do not forget to also call
  ## installAllegroTtfAddon.
  let installed = al_init_font_addon()
  if not installed:
    raise new AllegroInstallFontException

proc isFontAddonInitialized*(): bool =
  ## Returns true if the font addon is initialized, otherwise returns false
  return al_is_font_addon_initialized()

proc uninstallAllegroFontAddon*(): void =
  ## Shut down the font addon. This is done automatically at program exit, but
  ## can be called any time the user wishes as well.
  al_shutdown_font_addon()

proc newAllegroFontBitmap*(filename: string): AllegroFont =
  return al_load_bitmap_font(filename)

proc newAllegroFontBitmap*(filename: string, flags: varargs[AllegroFontFlag]): AllegroFont =
  let flagsInt = flags.mapIt(it.cint).foldl(a or b)
  return al_load_bitmap_font_flags(filename, flagsInt)

proc newAllegroFont*(filename: string, size: uint, flags: varargs[AllegroFontFlag]): AllegroFont =
  let flagsInt = flags.mapIt(it.cint).foldl(a or b)
  return al_load_font(filename, size.cint, flagsInt)

proc newAllegroFontBuiltin*(): AllegroFont =
  return al_create_builtin_font()

proc text*(font: AllegroFont, color: allegro5.AllegroColor | color.AllegroColor, text: string, x, y: float = 0, flags: AllegroFontFlag = alignLeft): void =
  al_draw_text(font, color, x.cfloat, y.cfloat, flags.cint, text)

proc textJustified*(font: AllegroFont, color: allegro5.AllegroColor | color.AllegroColor, text: string, x1, x2, y, diff: float, flags: AllegroFontFlag = alignLeft): void =
  al_draw_justified_text(font, color, x1, x2, y, diff, flags, text)

proc textWidth*(font: AllegroFont, str: string): uint =
  return al_get_text_width(font, str).uint

proc lineHeight*(font: AllegroFont): uint =
  return al_get_font_line_height(font).uint

proc ascent*(font: AllegroFont): int =
  return al_get_font_ascent(font)

proc descent*(font: AllegroFont): int =
  return al_get_font_descent(font)

proc free*(font: AllegroFont): void =
  al_destroy_font(font)
