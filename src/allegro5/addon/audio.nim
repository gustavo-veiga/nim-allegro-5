import allegro5/[events, exceptions, event_source]
import allegro5/private/library

type
  AllegroMixer* = ptr object
  AllegroVoice* = ptr object
  AllegroSample* = ptr object
  AllegroSampleId* = ptr object
  AllegroAudioStream* = ptr object
  AllegroAudioRecorder* = ptr object
  AllegroSampleInstance* = ptr object
  AllegroAudioRecorderEvent* = ptr object
  AllegroAudioEventType* {.pure.} = enum
    ## Internal, used to communicate with acodec.
    ## Must be in 512 <= n < 1024
    streamFragment   = 513
    streamFinished   = 514
    recorderFragment = 515
  AllegroAudioDepth* {.pure.} = enum
    ## Sample depth and type, and signedness. Mixers only use 32-bit signed
    ## float (-1..+1). The unsigned value is a bit-flag applied to the depth
    ## value.
    depthInt8      = 0x00
    depthInt16     = 0x01
    depthInt24     = 0x02
    depthFloat32   = 0x03
    #[ For convenience ]#
    depthUInt8  = AllegroAudioDepth.depthInt8.int or 0x08
    depthUInt16 = AllegroAudioDepth.depthInt16.int or 0x08
    depthUInt24 = AllegroAudioDepth.depthInt24.int or 0x08
  AllegroChannelConf* {.pure.} = enum
    ## Speaker configuration (mono, stereo, 2.1, 3, etc). With regards to
    ## behavior, most of this code makes no distinction between, say, 4.1 and
    ## speaker setups.. they both have 5 "channels". However, users would
    ## like the distinction, and later when the higher-level stuff is added,
    ## the differences will become more important. (v>>4)+(v&0xF) should yield
    ## the total channel count.
    conf1   = 0x10
    conf2   = 0x20
    conf3   = 0x30
    conf4   = 0x40
    conf5_1 = 0x51
    conf6_1 = 0x61
    conf7_1 = 0x71
  AllegroPlaymode* {.pure.} = enum
    once    = 0x100
    loop    = 0x101
    bidir   = 0x102
  AllegroMixerQuality* {.pure.} = enum
    point   = 0x110
    linear  = 0x111
    cubic   = 0x112

{.push importc, dynlib: library.audioAddon.}
#[ Sample functions ]#
proc al_create_sample(buf: pointer, samples, freq: cuint, depth: AllegroAudioDepth, chan_conf: AllegroChannelConf, free_buf: bool): AllegroSample
proc al_destroy_sample(spl: AllegroSample): void

#[ Sample instance functions ]#
proc al_create_sample_instance(data: AllegroSample): AllegroSampleInstance
proc al_destroy_sample_instance(spl: AllegroSampleInstance): void

proc al_get_sample_frequency(spl: AllegroSample): cuint
proc al_get_sample_length(spl: AllegroSample): cuint
proc al_get_sample_depth(spl: AllegroSample): AllegroAudioDepth
proc al_get_sample_channels(spl: AllegroSample): AllegroChannelConf
proc al_get_sample_data(spl: AllegroSample): pointer

proc al_get_sample_instance_frequency(spl: AllegroSampleInstance): cuint
proc al_get_sample_instance_length(spl: AllegroSampleInstance): cuint
proc al_get_sample_instance_position(spl: AllegroSampleInstance): cuint

proc al_get_sample_instance_speed(spl: AllegroSampleInstance): cfloat
proc al_get_sample_instance_gain(spl: AllegroSampleInstance): cfloat
proc al_get_sample_instance_pan(spl: AllegroSampleInstance): cfloat
proc al_get_sample_instance_time(spl: AllegroSampleInstance): cfloat

proc al_get_sample_instance_depth(spl: AllegroSampleInstance): AllegroAudioDepth
proc al_get_sample_instance_channels(spl: AllegroSampleInstance): AllegroChannelConf
proc al_get_sample_instance_playmode(spl: AllegroSampleInstance): AllegroPlaymode

proc al_get_sample_instance_playing(spl: AllegroSampleInstance): bool
proc al_get_sample_instance_attached(spl: AllegroSampleInstance): bool

proc al_set_sample_instance_position(spl: AllegroSampleInstance, val: cuint): bool
proc al_set_sample_instance_length(spl: AllegroSampleInstance, val: cuint): bool

proc al_set_sample_instance_speed(spl: AllegroSampleInstance, val: cfloat): bool
proc al_set_sample_instance_gain(spl: AllegroSampleInstance, val: cfloat): bool
proc al_set_sample_instance_pan(spl: AllegroSampleInstance, val: cfloat): bool

proc al_set_sample_instance_playmode(spl: AllegroSampleInstance, val: AllegroPlaymode): bool

proc al_set_sample_instance_playing(spl: AllegroSampleInstance, val: bool): bool
proc al_detach_sample_instance(spl: AllegroSampleInstance): bool

proc al_set_sample(spl: AllegroSampleInstance, data: AllegroSample): bool
proc al_get_sample(spl: AllegroSampleInstance): AllegroSample
proc al_play_sample_instance(spl: AllegroSampleInstance): bool
proc al_stop_sample_instance(spl: AllegroSampleInstance): bool

proc al_set_sample_instance_channel_matrix(spl: AllegroSampleInstance, matrix: openArray[cfloat]): bool

#[ Stream functions ]#
proc al_create_audio_stream(buffer_count: csize_t, samples, freq: cuint, depth: AllegroAudioDepth, chan_conf: AllegroChannelConf): AllegroAudioStream
proc al_destroy_audio_stream(stream: AllegroAudioStream): void
proc al_drain_audio_stream(stream: AllegroAudioStream): void

proc al_get_audio_stream_frequency(stream: AllegroAudioStream): cuint
proc al_get_audio_stream_length(stream: AllegroAudioStream): cuint
proc al_get_audio_stream_fragments(stream: AllegroAudioStream): cuint
proc al_get_available_audio_stream_fragments(stream: AllegroAudioStream): cuint

proc al_get_audio_stream_speed(stream: AllegroAudioStream): cfloat
proc al_get_audio_stream_gain(stream: AllegroAudioStream): cfloat
proc al_get_audio_stream_pan(stream: AllegroAudioStream): cfloat

proc al_get_audio_stream_channels(stream: AllegroAudioStream): AllegroChannelConf
proc al_get_audio_stream_depth(stream: AllegroAudioStream): AllegroAudioDepth
proc al_get_audio_stream_playmode(stream: AllegroAudioStream): AllegroPlaymode

proc al_get_audio_stream_playing(spl: AllegroAudioStream): bool
proc al_get_audio_stream_attached(spl: AllegroAudioStream): bool
proc al_get_audio_stream_played_samples(stream: AllegroAudioStream): culonglong

proc al_get_audio_stream_fragment(stream: AllegroAudioStream): pointer

proc al_set_audio_stream_speed(stream: AllegroAudioStream, val: cfloat): bool
proc al_set_audio_stream_gain(stream: AllegroAudioStream, val: cfloat): bool
proc al_set_audio_stream_pan(stream: AllegroAudioStream, val: cfloat): bool

proc al_set_audio_stream_playmode(stream: AllegroAudioStream, val: AllegroPlaymode): bool

proc al_set_audio_stream_playing(stream: AllegroAudioStream, val: bool): bool
proc al_detach_audio_stream(stream: AllegroAudioStream): bool
proc al_set_audio_stream_fragment(stream: AllegroAudioStream, val: pointer): bool

proc al_rewind_audio_stream(stream: AllegroAudioStream): bool
proc al_seek_audio_stream_secs(stream: AllegroAudioStream, time: cdouble): bool
proc al_get_audio_stream_position_secs(stream: AllegroAudioStream): cdouble
proc al_get_audio_stream_length_secs(stream: AllegroAudioStream): cdouble
proc al_set_audio_stream_loop_secs(stream: AllegroAudioStream, start_a, end_a: cdouble): bool

proc al_get_audio_stream_event_source(stream: AllegroAudioStream): AllegroEventSource

proc al_set_audio_stream_channel_matrix(stream: AllegroAudioStream, matrix: openArray[cfloat]): bool

#[ Mixer functions ]#
proc al_create_mixer(freq: cuint, depth: AllegroAudioDepth, chan_conf: AllegroChannelConf): AllegroMixer
proc al_destroy_mixer(mixer: AllegroMixer): void
proc al_attach_sample_instance_to_mixer(stream: AllegroSampleInstance, mixer: AllegroMixer): bool
proc al_attach_audio_stream_to_mixer(stream: AllegroAudioStream, mixer: AllegroMixer): bool
proc al_attach_mixer_to_mixer(stream, mixer: AllegroMixer): bool
proc al_set_mixer_postprocess_callback(mixer: AllegroMixer, cb: proc (buf: pointer, samples: cuint, data: pointer), data: pointer): bool

proc al_get_mixer_frequency(mixer: AllegroMixer): cuint
proc al_get_mixer_channels(mixer: AllegroMixer): AllegroChannelConf
proc al_get_mixer_depth(mixer: AllegroMixer): AllegroAudioDepth
proc al_get_mixer_quality(mixer: AllegroMixer): AllegroMixerQuality
proc al_get_mixer_gain(mixer: AllegroMixer): cfloat
proc al_get_mixer_playing(mixer: AllegroMixer): bool
proc al_get_mixer_attached(mixer: AllegroMixer): bool
proc al_set_mixer_frequency(mixer: AllegroMixer, val: cuint): bool
proc al_set_mixer_quality(mixer: AllegroMixer, val: AllegroMixerQuality): bool
proc al_set_mixer_gain(mixer: AllegroMixer, gain: cfloat): bool
proc al_set_mixer_playing(mixer: AllegroMixer, val: bool): bool
proc al_detach_mixer(mixer: AllegroMixer): bool

#[ Voice functions ]#
proc al_create_voice(freq: cuint, depth: AllegroAudioDepth, chan_conf: AllegroChannelConf): AllegroVoice
proc al_destroy_voice(voice: AllegroVoice): void
proc al_attach_sample_instance_to_voice(stream: AllegroSampleInstance, voice: AllegroVoice): bool
proc al_attach_audio_stream_to_voice(stream: AllegroAudioStream, voice: AllegroVoice): bool
proc al_attach_mixer_to_voice(mixer: AllegroMixer, voice: AllegroVoice): bool
proc al_detach_voice(voice: AllegroVoice): void

proc al_get_voice_frequency(voice: AllegroVoice): cuint
proc al_get_voice_position(voice: AllegroVoice): cuint
proc al_get_voice_channels(voice: AllegroVoice): AllegroChannelConf
proc al_get_voice_depth(voice: AllegroVoice): AllegroAudioDepth
proc al_get_voice_playing(voice: AllegroVoice): bool
proc al_set_voice_position(voice: AllegroVoice, val: cuint): bool
proc al_set_voice_playing(voice: AllegroVoice, val: bool): bool

#[ Misc. audio functions ]#
proc al_install_audio(): bool
proc al_uninstall_audio(): void
proc al_is_audio_installed(): bool
proc al_get_allegro_audio_version(): cuint

proc al_get_channel_count(conf: AllegroChannelConf): csize_t
proc al_get_audio_depth_size(conf: AllegroAudioDepth): csize_t

proc al_fill_silence(buf: pointer, samples: cuint, depth: AllegroAudioDepth, chan_conf: AllegroChannelConf): void

#[ Simple audio layer ]#
proc al_reserve_samples(reserve_samples: cint): bool
proc al_get_default_mixer(): AllegroMixer
proc al_set_default_mixer(mixer: AllegroMixer): bool
proc al_restore_default_mixer(): bool
proc al_play_sample(data: AllegroSample, gain, pan, speed: cfloat, loop: AllegroPlaymode, ret_id: AllegroSampleId): bool
proc al_stop_sample(spl_id: AllegroSampleId): void
proc al_stop_samples(): void
proc al_get_default_voice(): AllegroVoice
proc al_set_default_voice(voice: AllegroVoice): void

#[ File type handlers ]#
proc al_load_sample(filename: cstring): AllegroSample
proc al_save_sample(filename: cstring, spl: AllegroSample): bool
proc al_load_audio_stream(filename: cstring, buffer_count: csize_t, samples: cuint): AllegroAudioStream

#[ Recording functions ]#
proc al_create_audio_recorder(fragment_count: csize_t, samples, freq: cuint, depth: AllegroAudioDepth, chan_conf: AllegroChannelConf): AllegroAudioRecorder
proc al_start_audio_recorder(r: AllegroAudioRecorder): bool
proc al_stop_audio_recorder(r: AllegroAudioRecorder): void
proc al_is_audio_recorder_recording(r: AllegroAudioRecorder): bool
proc al_get_audio_recorder_event_source(r: AllegroAudioRecorder): AllegroEventSource
proc al_get_audio_recorder_event(event: AllegroEvent): AllegroAudioRecorderEvent
proc al_destroy_audio_recorder(r: AllegroAudioRecorder): void
{.pop.}

proc newAllegroSample*(buf: pointer, samples, freq: uint, depth: AllegroAudioDepth, channelConf: AllegroChannelConf, freeBuf: bool): AllegroSample =
  return al_create_sample(buf, samples.cuint, freq.cuint, depth, channelConf, freeBuf)

proc free*(sample: AllegroSample): void =
  al_destroy_sample(sample)

proc newAllegroSampleInstance*(): AllegroSampleInstance =
  return al_create_sample_instance(nil)

proc newAllegroSampleInstance*(data: AllegroSample): AllegroSampleInstance =
  return al_create_sample_instance(data)

proc free*(sample: AllegroSampleInstance): void =
  al_destroy_sample_instance(sample)

proc frequency*(sample: AllegroSample): uint =
  return al_get_sample_frequency(sample)

proc length*(sample: AllegroSample): uint =
  return al_get_sample_length(sample)

proc depth*(sample: AllegroSample): AllegroAudioDepth =
  return al_get_sample_depth(sample)

proc channels*(sample: AllegroSample): AllegroChannelConf =
  return al_get_sample_channels(sample)

proc  data*(sample: AllegroSample): pointer =
  return al_get_sample_data(sample)

proc frequency*(sample: AllegroSampleInstance): uint32 =
  return al_get_sample_instance_frequency(sample)

proc length*(sample: AllegroSampleInstance): uint32 =
  return al_get_sample_instance_length(sample)

proc position*(sample: AllegroSampleInstance): uint32 =
  return al_get_sample_instance_position(sample)

proc speed*(sample: AllegroSampleInstance): float32 =
  return al_get_sample_instance_speed(sample)

proc gain*(sample: AllegroSampleInstance): float32 =
  return al_get_sample_instance_gain(sample)

proc pan*(sample: AllegroSampleInstance): float32 =
  return al_get_sample_instance_pan(sample)

proc time*(sample: AllegroSampleInstance): float32 =
  return al_get_sample_instance_time(sample)

proc depth*(sample: AllegroSampleInstance): AllegroAudioDepth =
  return al_get_sample_instance_depth(sample)

proc channels*(sample: AllegroSampleInstance): AllegroChannelConf =
  return al_get_sample_instance_channels(sample)

proc playmode*(sample: AllegroSampleInstance): AllegroPlaymode =
  return al_get_sample_instance_playmode(sample)

proc isPlaying*(sample: AllegroSampleInstance): bool =
  return al_get_sample_instance_playing(sample)

proc isAttached*(sample: AllegroSampleInstance): bool =
  return al_get_sample_instance_attached(sample)

proc position*(sample: AllegroSampleInstance, value: uint32): void =
  discard al_set_sample_instance_position(sample, value)

proc length*(sample: AllegroSampleInstance, value: uint32): void =
  discard al_set_sample_instance_length(sample, value)

proc speed*(sample: AllegroSampleInstance, value: float32): void =
  discard al_set_sample_instance_speed(sample, value)

proc gain*(sample: AllegroSampleInstance, value: float32): void =
   discard al_set_sample_instance_gain(sample, value)

proc pan*(sample: AllegroSampleInstance, value: float32): void =
  discard al_set_sample_instance_pan(sample, value)

proc playmode*(sample: AllegroSampleInstance, value: AllegroPlaymode): void =
  discard al_set_sample_instance_playmode(sample, value)

proc isPlaying*(sample: AllegroSampleInstance, value: bool): void =
  discard al_set_sample_instance_playing(sample, value)

proc detach*(sample: AllegroSampleInstance): void =
  discard al_detach_sample_instance(sample)

proc sample*(sample: AllegroSampleInstance, data: AllegroSample): void =
  discard al_set_sample(sample, data)

proc sample*(sample: AllegroSampleInstance): AllegroSample =
  return al_get_sample(sample)

proc play*(sample: AllegroSampleInstance): void =
  discard al_play_sample_instance(sample)

proc stop*(sample: AllegroSampleInstance): void =
  discard al_stop_sample_instance(sample)

proc matrix*(sample: AllegroSampleInstance, matrix: openArray[float32]): void =
  discard al_set_sample_instance_channel_matrix(sample, matrix)

proc newAllegroAudioStream*(bufferCount, samples, freq: uint32, depth: AllegroAudioDepth, channelConf: AllegroChannelConf): AllegroAudioStream =
  return al_create_audio_stream(bufferCount, samples, freq, depth, channelConf)

proc free*(stream: AllegroAudioStream): void =
  al_destroy_audio_stream(stream)

proc drain*(stream: AllegroAudioStream): void =
  al_drain_audio_stream(stream)

proc frequency*(stream: AllegroAudioStream): uint32 =
  return al_get_audio_stream_frequency(stream)

proc length*(stream: AllegroAudioStream): uint32 =
  return al_get_audio_stream_length(stream)

proc fragments*(stream: AllegroAudioStream): uint32 =
  return al_get_audio_stream_fragments(stream)

proc availableFragments*(stream: AllegroAudioStream): uint32 =
  return al_get_available_audio_stream_fragments(stream)

proc speed*(stream: AllegroAudioStream): float32 =
  return al_get_audio_stream_speed(stream)

proc gain*(stream: AllegroAudioStream): float32 =
  return al_get_audio_stream_gain(stream)

proc pan*(stream: AllegroAudioStream): float32 =
  return al_get_audio_stream_pan(stream)

proc channels*(stream: AllegroAudioStream): AllegroChannelConf =
  return al_get_audio_stream_channels(stream)

proc depth*(stream: AllegroAudioStream): AllegroAudioDepth =
  return al_get_audio_stream_depth(stream)

proc playmode*(stream: AllegroAudioStream): AllegroPlaymode =
  return al_get_audio_stream_playmode(stream)

proc isPlaying*(stream: AllegroAudioStream): bool =
  return al_get_audio_stream_playing(stream)

proc isAttached*(stream: AllegroAudioStream): bool =
  return al_get_audio_stream_attached(stream)

proc playedSamples*(stream: AllegroAudioStream): uint64 =
  return al_get_audio_stream_played_samples(stream)

proc fragment*(stream: AllegroAudioStream): pointer =
  return al_get_audio_stream_fragment(stream)

proc speed*(stream: AllegroAudioStream, value: float32): void =
  discard al_set_audio_stream_speed(stream, value)

proc gain*(stream: AllegroAudioStream, value: float32): void =
  discard al_set_audio_stream_gain(stream, value)

proc pan*(stream: AllegroAudioStream, value: float32): bool =
  discard al_set_audio_stream_pan(stream, value)

proc playmode*(stream: AllegroAudioStream, value: AllegroPlaymode): bool =
  discard al_set_audio_stream_playmode(stream, value)

proc isPlaying*(stream: AllegroAudioStream, value: bool): void =
  discard al_set_audio_stream_playing(stream, value)

proc detach*(stream: AllegroAudioStream): void =
  discard al_detach_audio_stream(stream)

proc fragment*(stream: AllegroAudioStream, value: pointer): void =
  discard al_set_audio_stream_fragment(stream, value)

proc rewind*(stream: AllegroAudioStream): bool =
  return al_rewind_audio_stream(stream)

proc seekSecs*(stream: AllegroAudioStream, time: float64): void =
  discard al_seek_audio_stream_secs(stream, time)

proc positionSecs*(stream: AllegroAudioStream): float64 =
  return al_get_audio_stream_position_secs(stream)

proc lengthSecs*(stream: AllegroAudioStream): float64 =
  return al_get_audio_stream_length_secs(stream)

proc loopSecs*(stream: AllegroAudioStream, `start`, `end`: float64): void =
  discard al_set_audio_stream_loop_secs(stream, `start`, `end`)

proc eventSource*(stream: AllegroAudioStream): AllegroEventSource =
  return al_get_audio_stream_event_source(stream)

proc matrix*(stream: AllegroAudioStream, matrix: openArray[float32]): void =
  discard al_set_audio_stream_channel_matrix(stream, matrix)

proc newAllegroMixer*(freq: uint32, depth: AllegroAudioDepth, channelConf: AllegroChannelConf): AllegroMixer =
  return al_create_mixer(freq, depth, channelConf)

proc free*(mixer: AllegroMixer): void =
  al_destroy_mixer(mixer)

proc attach*(mixer: AllegroMixer, stream: AllegroSampleInstance): bool {.discardable.} =
  return al_attach_sample_instance_to_mixer(stream, mixer)

proc attach*(mixer: AllegroMixer, stream: AllegroAudioStream): bool {.discardable.} =
  return al_attach_audio_stream_to_mixer(stream, mixer)

proc attach*(mixer, stream: AllegroMixer): bool {.discardable.} =
  return al_attach_mixer_to_mixer(stream, mixer)

proc postProcessCallback*(mixer: AllegroMixer, cb: proc (buf: pointer, samples: uint32, data: pointer), data: pointer): bool {.discardable.} =
  return al_set_mixer_postprocess_callback(mixer, cb, data)

proc frequency*(mixer: AllegroMixer): uint32 =
  return al_get_mixer_frequency(mixer)

proc channels*(mixer: AllegroMixer): AllegroChannelConf =
  return al_get_mixer_channels(mixer)

proc depth*(mixer: AllegroMixer): AllegroAudioDepth =
  return al_get_mixer_depth(mixer)

proc quality*(mixer: AllegroMixer): AllegroMixerQuality =
  return al_get_mixer_quality(mixer)

proc gain*(mixer: AllegroMixer): float32 =
  return al_get_mixer_gain(mixer)

proc isPlaying*(mixer: AllegroMixer): bool =
  return al_get_mixer_playing(mixer)

proc isAttached*(mixer: AllegroMixer): bool =
  return al_get_mixer_attached(mixer)

proc frequency*(mixer: AllegroMixer, value: uint32): void =
  discard al_set_mixer_frequency(mixer, value)

proc quality*(mixer: AllegroMixer, value: AllegroMixerQuality): void =
  discard al_set_mixer_quality(mixer, value)

proc gain*(mixer: AllegroMixer, gain: float32): void =
  discard al_set_mixer_gain(mixer, gain)

proc isPlaying*(mixer: AllegroMixer, value: bool): void =
  discard al_set_mixer_playing(mixer, value)

proc detach*(mixer: AllegroMixer): void =
  discard al_detach_mixer(mixer)

proc newAllegroVoice*(freq: uint32, depth: AllegroAudioDepth, channelConf: AllegroChannelConf): AllegroVoice =
  return al_create_voice(freq, depth, channelConf)

proc free*(voice: AllegroVoice): void =
  al_destroy_voice(voice)

proc attach*(voice: AllegroVoice, stream: AllegroSampleInstance): bool {.discardable.} =
  return al_attach_sample_instance_to_voice(stream, voice)

proc attach*(voice: AllegroVoice, stream: AllegroAudioStream): bool {.discardable.} =
  return al_attach_audio_stream_to_voice(stream, voice)

proc attach*(voice: AllegroVoice, mixer: AllegroMixer): bool {.discardable.} =
  return al_attach_mixer_to_voice(mixer, voice)

proc detach*(voice: AllegroVoice): void =
  al_detach_voice(voice)

proc frequency*(voice: AllegroVoice): uint32 =
  return al_get_voice_frequency(voice)

proc position*(voice: AllegroVoice): uint32 =
  return al_get_voice_position(voice)

proc channels*(voice: AllegroVoice): AllegroChannelConf =
  return al_get_voice_channels(voice)

proc depth*(voice: AllegroVoice): AllegroAudioDepth =
  return al_get_voice_depth(voice)

proc isPlaying*(voice: AllegroVoice): bool =
  return al_get_voice_playing(voice)

proc position*(voice: AllegroVoice, value: uint32): void =
  discard al_set_voice_position(voice, value)

proc isPlaying*(voice: AllegroVoice, value: bool): void =
  discard al_set_voice_playing(voice, value)

proc installAllegroAudioAddon*(): void =
  let installed = al_install_audio()
  if not installed:
    raise new AllegroInstallAudioException

proc uninstallAllegroAudioAddon*(): void =
  al_uninstall_audio()

proc isAudioInstalled*(): bool =
  return al_is_audio_installed()

proc allegroAudioAddonVersion*(): uint32 =
  return al_get_allegro_audio_version()

proc count*(conf: AllegroChannelConf): uint =
  return al_get_channel_count(conf)

proc size*(conf: AllegroAudioDepth): uint =
  return al_get_audio_depth_size(conf)

proc fillSilence*(buf: pointer, samples: uint32, depth: AllegroAudioDepth, channelConf: AllegroChannelConf): void =
  al_fill_silence(buf, samples, depth, channelConf)

proc reserveSamples*(number: uint32): void =
  discard al_reserve_samples(number.cint)

proc defaultMixer*(): AllegroMixer =
  return al_get_default_mixer()

proc defaultMixer*(mixer: AllegroMixer): void =
  discard al_set_default_mixer(mixer)

proc restoreDefaultMixer*(): void =
  discard al_restore_default_mixer()

proc play*(data: AllegroSample, gain, pan, speed: float32, loop: AllegroPlaymode, sampleId: AllegroSampleId): void =
  discard al_play_sample(data, gain, pan, speed, loop, sampleId)

proc stop*(sampleId: AllegroSampleId): void =
  al_stop_sample(sampleId)

proc stopSamples*(): void =
  al_stop_samples()

proc defaultVoice*(): AllegroVoice =
  return al_get_default_voice()

proc defaultVoice*(voice: AllegroVoice): void =
  al_set_default_voice(voice)

proc newAllegroSample*(filename: string): AllegroSample =
  return al_load_sample(filename)

proc save*(sample: AllegroSample, filename: string): void =
  discard al_save_sample(filename, sample)

proc newAllegroAudioStream*(filename: string, bufferCount, samples: uint32): AllegroAudioStream =
  return al_load_audio_stream(filename, bufferCount, samples)

proc newAllegroAudioRecorder*(fragmentCount, samples, freq: uint32, depth: AllegroAudioDepth, channelConf: AllegroChannelConf): AllegroAudioRecorder =
  return al_create_audio_recorder(fragmentCount, samples, freq, depth, channelConf)

proc start*(recorder: AllegroAudioRecorder): void =
  discard al_start_audio_recorder(recorder)

proc stop*(recorder: AllegroAudioRecorder): void =
  al_stop_audio_recorder(recorder)

proc isRecording*(recorder: AllegroAudioRecorder): bool =
  return al_is_audio_recorder_recording(recorder)

proc eventSource*(recorder: AllegroAudioRecorder): AllegroEventSource =
  return al_get_audio_recorder_event_source(recorder)

proc recorderEvent*(event: AllegroEvent): AllegroAudioRecorderEvent =
  return al_get_audio_recorder_event(event)

proc free*(recorder: AllegroAudioRecorder): void =
  al_destroy_audio_recorder(recorder)
