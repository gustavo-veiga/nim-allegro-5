import std/os
import std/logging
import std/strformat

import allegro5
import allegro5/addon/audio
import allegro5/addon/acodec

when isMainModule:
  installAllegro()
  installAllegroAcodecAddon()
  installAllegroAudioAddon()

  var filenames = newSeq[string]()
  if paramCount() == 0:
    filenames.add getAppDir() & "/data/welcome.wav"
  else:
    for param in commandLineParams():
      filenames.add param

  let logger = newConsoleLogger()
  let voice = newAllegroVoice(44100, depthInt16, conf2)
  let mixer = newAllegroMixer(44100, depthFloat32, conf2)
  voice.attach mixer

  let sample = newAllegroSampleInstance()

  for filename in filenames:
    let sampleData = newAllegroSample(filename)
    sample.sample sampleData
    mixer.attach sample

    sample.playmode loop

    sample.play
    logger.log(lvlInfo, &"Playing {filename} ({sample.time:.3f} seconds) normally")
    restTime(sample.time)

    if sample.channels.count == 1:
      sample.matrix [1'f, 0'f]
      logger.log(lvlInfo, "Playing left channel only")
      restTime(sample.time)
    
    sample.gain 0.5
    logger.log(lvlInfo, "Playing with gain 0.5")
    restTime(sample.time)

    sample.gain 0.25
    logger.log(lvlInfo, "Playing with gain 0.25")
    restTime(sample.time)

    sample.stop
    logger.log(lvlInfo, &"Done playing")

    sample.sample nil
    sampleData.free
  
  sample.free
  mixer.free
  voice.free

  uninstallAllegroAudioAddon()
