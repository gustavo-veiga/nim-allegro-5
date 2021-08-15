import private/library, bitmap, display

type
  AllegroMouseCursor* = ptr object
  AllegroSystemMouseCursor* {.pure.} = enum
    none        = 0
    default     = 1
    arrow       = 2
    busy        = 3
    question    = 4
    edit        = 5
    move        = 6
    resizeN     = 7
    resizeW     = 8
    resizeS     = 9
    resizeE     = 10
    resizeNW    = 11
    resizeSW    = 12
    resizeSE    = 13
    resizeNE    = 14
    progress    = 15
    precision   = 16
    link        = 17
    altSelect   = 18
    unavailable = 19

{.push importc, dynlib: library.allegro.}
proc al_create_mouse_cursor(sprite: AllegroBitmap, xfocus, yfocus: cint): AllegroMouseCursor
proc al_destroy_mouse_cursor(cursor: AllegroMouseCursor): void
proc al_set_mouse_cursor(display: AllegroDisplay, cursor: AllegroMouseCursor): bool
proc al_set_system_mouse_cursor(display: AllegroDisplay, cursorId: cint): bool
proc al_show_mouse_cursor(display: AllegroDisplay): bool
proc al_hide_mouse_cursor(display: AllegroDisplay): bool
{.pop.}

proc newAllegroMouseCursor*(sprite: AllegroBitmap, xFocus, yFocus: int): AllegroMouseCursor =
  return al_create_mouse_cursor(sprite, xFocus.cint, xFocus.cint)

proc free*(cursor: AllegroMouseCursor): void =
  al_destroy_mouse_cursor(cursor)

proc mouseCursor*(display: AllegroDisplay, cursor: AllegroMouseCursor): void =
  discard al_set_mouse_cursor(display, cursor)

proc mouseCursor*(display: AllegroDisplay, cursorId: AllegroSystemMouseCursor): void =
  discard al_set_system_mouse_cursor(display, cursorId.cint)

proc showMouseCursor*(display: AllegroDisplay): void =
  discard al_show_mouse_cursor(display)

proc hideMouseCursor*(display: AllegroDisplay): void =
  discard al_hide_mouse_cursor(display)
