import std/options

import private/library, display, memory

{.push importc, dynlib: library.allegro.}
proc al_get_clipboard_text(display: AllegroDisplay): cstring
proc al_set_clipboard_text(display: AllegroDisplay, text: cstring): bool
proc al_clipboard_has_text(display: AllegroDisplay): bool
{.pop.}

proc clipboardText*(display: AllegroDisplay): Option[string] =
  ## This function returns a string with the text contents of the clipboard available.
  ## 
  ## Beware that text on the clipboard on Windows may be in Windows format, that is,
  ## it may have carriage return newline combinations for the line endings instead
  ## of regular newlines for the line endings on Linux or OSX.
  let text = al_get_clipboard_text(display)
  if text.isNil:
    return none(string)
  let value = $text
  free(text)
  return some(value)

proc clipboardText*(display: AllegroDisplay, text: string): void =
  ## This function pastes the text given as an argument to the clipboard.
  discard al_set_clipboard_text(display, text)

proc hasClipboardText*(display: AllegroDisplay): bool =
  ## This function returns true if and only if the clipboard has text available.
  return al_clipboard_has_text(display)
