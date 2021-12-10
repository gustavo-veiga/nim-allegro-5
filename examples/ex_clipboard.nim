import std/options

import allegro5
import allegro5/addon/font
import allegro5/addon/image
import allegro5/addon/primitives

const interval = 1 / 60

when isMainModule:
  installAllegro()
  installAllegroKeyboard()
  installAllegroFontAddon()
  installAllegroImageAddon()
  installAllegroPrimitivesAddon()

  var display = newAllegroDisplay(640, 480)
  var fixedFont = newAllegroFont("data/fixed_font.tga", 0, alignLeft)

  var timer = newAllegroTimer(interval)
  var queue = newAllegroEventQueue()
  queue.register timer.eventSource
  queue.register display.eventSource
  queue.register keyboardEventSource()

  timer.start
  var text = none(string)
  var done = false
  var redraw = true
  var event = new AllegroEvent
  while not done:
    if redraw and queue.isEmpty:
      if display.hasClipboardText:
        text = display.clipboardText
      else:
        text = none(string)

      newAllegroMapRGB(0, 0, 0).clearToColor

      if text.isSome:
        fixedFont.text(newAllegroMapRGBA(1, 1, 1, 1'f), text.get)
      else:
        fixedFont.text(newAllegroMapRGBA(1, 0, 0, 1'f), "No clipboard text available")
      
      flipDisplay()
      redraw = false

    queue.wait event
    case event.typeEvent:
      of AllegroEventType.keyDown:
        if event.keyboard.keycode.int == AllegroKey.keyEscape.int:
          done = true
        elif event.keyboard.keycode.int == AllegroKey.keySpace.int:
          display.clipboardText "Copied from Allegro!"
      of AllegroEventType.displayClose:
        done = true
      of AllegroEventType.timer:
        redraw = true
      else:
        discard
