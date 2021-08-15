import private/library, display

{.push importc, dynlib: library.allegro.}
proc al_get_clipboard_text(display: AllegroDisplay): cstring
proc al_set_clipboard_text(display: AllegroDisplay, text: cstring): bool
proc al_clipboard_has_text(display: AllegroDisplay): bool
{.pop.}

proc clipboard*(display: AllegroDisplay): string =
  return $al_get_clipboard_text(display)

proc clipboard*(display: AllegroDisplay, text: string): void =
  discard al_set_clipboard_text(display, text)

proc hasClipboard*(display: AllegroDisplay): bool =
  return al_clipboard_has_text(display)
