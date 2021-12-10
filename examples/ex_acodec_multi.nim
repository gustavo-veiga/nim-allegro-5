import std/os
import std/sequtils
import std/strformat

import allegro5
import allegro5/addon/audio
import allegro5/addon/acodec

type
  Audio = object
    file: string
    data: AllegroSample
    sample: AllegroSampleInstance

const defaultFiles: seq[string] = @[
  "/data/welcome.voc",
  "/data/haiku/earth_0.ogg",
  "/data/haiku/water_0.ogg",
  "/data/haiku/fire_0.ogg",
  "/data/haiku/air_0.ogg"
]

proc newAudio(file: string, data: AllegroSample, sample: AllegroSampleInstance): Audio =
  result = Audio()
  result.file = file
  result.data = data
  result.sample = sample

when isMainModule:
  installAllegro()
  installAllegroAudioAddon()
  installAllegroAcodecAddon()

  var files: seq[string]
  if paramCount() > 0:
    files = commandLineParams()
  else:
    echo "This example can be run from the command line"
    let path = relativePath(getAppDir(), getCurrentDir(), '/')
    files = defaultFiles.mapIt(path & it)

  var audios = newSeq[Audio](files.len)
  let voice = newAllegroVoice(44100, depthInt16, conf2)
  let mixer = newAllegroMixer(44100, depthFloat32, conf2)
  voice.attach mixer

  for i, file in files:
    let sampleData = newAllegroSample(file)
    let sampleInstance =  newAllegroSampleInstance(sampleData)
    audios[i] = newAudio(file, sampleData, sampleInstance)
    mixer.attach sampleInstance

  var longestSample = 0'f
  for audio in audios:
    audio.sample.play
    echo &"Playing {audio.file} ({audio.sample.time:.3f} seconds)"
    if audio.sample.time > longestSample:
      longestSample = audio.sample.time
  restTime(longestSample)
  
  echo "Done"

  for audio in audios:
    audio.sample.stop
    audio.sample.free
    audio.data.free

  mixer.free
  voice.free

  uninstallAllegroAudioAddon()
