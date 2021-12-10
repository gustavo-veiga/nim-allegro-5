import std/os
import std/logging
import std/strformat

import allegro5
import allegro5/addon/image

const defaultFile = "/data/mysha.pcx"

when isMainModule:
  installAllegro()
  installAllegroMouse()
  installAllegroKeyboard()
  installAllegroImageAddon()

  let filename = if paramCount() > 0:
    paramStr(1)
  else:
    getAppDir() & defaultFile

  # Initializes and displays a log window for debugging purposes.
  let logger = newConsoleLogger()

  # Create a new display that we can render the image to.
  let display = newAllegroDisplay(640, 480)
  display.title filename

  # Load the image and time how long it took for the log.
  let t0 = time()
  let bitmap = newAllegroBitmap(filename)
  let t1 = time()
  logger.log(lvlInfo, &"Loading took {t0-t1:.4f} seconds")

  # Create a timer that fires 30 times a second.
  let timer = newAllegroTimer(1 / 30)
  let queue = newAllegroEventQueue()
  queue.register timer.eventSource
  queue.register display.eventSource
  queue.register keyboardEventSource()

  # Start the timer
  timer.start

  var zoom = 1.0
  var redraw = true
  var event = new AllegroEvent

  # Primary 'game' loop
  while true:
    queue.wait event
    case event.typeEvent:
      of AllegroEventType.displayOrientation:
        case event.display.orientation:
          of AllegroDisplayOrientation.degrees0:
            logger.log(lvlInfo, "0 degrees")
          of AllegroDisplayOrientation.degrees90:
            logger.log(lvlInfo, "90 degrees")
          of AllegroDisplayOrientation.degrees180:
            logger.log(lvlInfo, "180 degrees")
          of AllegroDisplayOrientation.degrees270:
            logger.log(lvlInfo, "270 degrees")
          of AllegroDisplayOrientation.faceUp:
            logger.log(lvlInfo, "Face up")
          of AllegroDisplayOrientation.faceDown:
            logger.log(lvlInfo, "Face down")
          else:
            discard
      of AllegroEventType.displayClose:
        break
      of AllegroEventType.keyChar:
        case event.keyboard.unichar.cchar:
          of '1':
            zoom = 1
          of '+':
            zoom *= 1.1
          of '-':
            zoom /= 1.1
          of 'f':
            zoom = display.width.float / bitmap.width.float
          else:
            discard
      of AllegroEventType.timer:
        redraw = true
      else:
        discard

    if redraw and queue.isEmpty:
      redraw = false
      # Clear so we don't get trippy artifacts left after zoom.
      newAllegroMapRGB(0'f, 0'f, 0'f).clearToColor
      if zoom == 1:
        bitmap.draw(0'f, 0'f)
      else:
        bitmap.drawScaledRotated(0, 0, 0, 0, zoom, zoom, 0)
      flipDisplay()
  
  queue.free
