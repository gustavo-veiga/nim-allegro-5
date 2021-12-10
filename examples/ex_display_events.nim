import std/strformat

import allegro5
import allegro5/addon/font

proc add(events: var seq[string], index: var int, description: string): void =
  events[index] = description
  if index >= events.len - 1:
    index = 0
  else:
    index += 1

when isMainModule:
  installAllegro()
  installAllegroMouse()
  installAllegroKeyboard()
  installAllegroFontAddon()

  allegroDisplayFlags(resizable)

  let fontIn = newAllegroFontBuiltin()
  let display = newAllegroDisplay(640, 480)

  let red = newAllegroMapRGB(1'f, 0'f, 0'f)
  let blue = newAllegroMapRGB(0'f, 0'f, 1'f)

  let queue = newAllegroEventQueue()
  queue.register display.eventSource
  queue.register mouseEventSource()
  queue.register keyboardEventSource()

  var index = 0
  var event = new AllegroEvent
  var events = newSeq[string](23)
  while true:
    if queue.isEmpty:
      var x =  8'f
      var y = 28'f

      newAllegroMapRGB(0xff, 0xff, 0xc0).clearToColor
      fontIn.text(blue, "Display events (newest on top)", 8, 8,)

      for description in events:
        fontIn.text(red, description, x, y)
        y += 20
      flipDisplay()

    queue.wait event
    case event.typeEvent:
      of AllegroEventType.mouseEnterDisplay:
        events.add index, "ALLEGRO_EVENT_MOUSE_ENTER_DISPLAY"
      of AllegroEventType.mouseLeaveDisplay:
        events.add index,"ALLEGRO_EVENT_MOUSE_LEAVE_DISPLAY"
      of AllegroEventType.keyDown:
        if event.keyboard.keycode.int == AllegroKey.keyEscape.int:
          break
      of AllegroEventType.displayResize:
        events.add index, &"ALLEGRO_EVENT_DISPLAY_RESIZE x={event.display.x} y={event.display.y} width={event.display.width}, height={event.display.width}"
        display.acknowledgeResize
      of AllegroEventType.displayClose:
        events.add index, "ALLEGRO_EVENT_DISPLAY_CLOSE"
      of AllegroEventType.displayLost:
        events.add index, "ALLEGRO_EVENT_DISPLAY_LOST"
      of AllegroEventType.displayFound:
        events.add index, "ALLEGRO_EVENT_DISPLAY_FOUND"
      of AllegroEventType.displaySwitchOut:
        events.add index, "ALLEGRO_EVENT_DISPLAY_SWITCH_OUT"
      of AllegroEventType.displaySwitchIn:
        events.add index, "ALLEGRO_EVENT_DISPLAY_SWITCH_IN"
      else:
        discard
