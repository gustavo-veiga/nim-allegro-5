import ../private/library, ../event_source

type
  AllegroSample* = ptr object
  AllegroSampleInstance* = ptr object
  AllegroAudioStream* = ptr object
  AllegroMixer* = ptr object
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
  AllegroChanneConf* {.pure.} = enum
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
proc al_create_sample(buf: pointer, samples, freq: cuint, depth: AllegroAudioDepth, chan_conf: AllegroChanneConf, free_buf: bool): AllegroSample
proc al_destroy_sample(spl: AllegroSample): void

#[ Sample instance functions ]#
proc al_create_sample_instance(data: AllegroSample): AllegroSampleInstance
proc al_destroy_sample_instance(spl: AllegroSampleInstance): void

proc al_get_sample_frequency(spl: AllegroSample): cuint
proc al_get_sample_length(spl: AllegroSample): cuint
proc al_get_sample_depth(spl: AllegroSample): AllegroAudioDepth
proc al_get_sample_channels(spl: AllegroSample): AllegroChanneConf
proc al_get_sample_data(spl: AllegroSample): pointer

proc al_get_sample_instance_frequency(spl: AllegroSampleInstance): cuint
proc al_get_sample_instance_length(spl: AllegroSampleInstance): cuint
proc al_get_sample_instance_position(spl: AllegroSampleInstance): cuint

proc al_get_sample_instance_speed(spl: AllegroSampleInstance): cfloat
proc al_get_sample_instance_gain(spl: AllegroSampleInstance): cfloat
proc al_get_sample_instance_pan(spl: AllegroSampleInstance): cfloat
proc al_get_sample_instance_time(spl: AllegroSampleInstance): cfloat

proc al_get_sample_instance_depth(spl: AllegroSampleInstance): AllegroAudioDepth
proc al_get_sample_instance_channels(spl: AllegroSampleInstance): AllegroChanneConf
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

#[ Stream functions ]#
proc al_create_audio_stream(buffer_count: csize_t, samples, freq: cuint, depth: AllegroAudioDepth, chan_conf: AllegroChanneConf): AllegroAudioStream
proc al_destroy_audio_stream(stream: AllegroAudioStream): void
proc al_drain_audio_stream(stream: AllegroAudioStream): void

proc al_get_audio_stream_frequency(stream: AllegroAudioStream): cint
proc al_get_audio_stream_length(stream: AllegroAudioStream): cint
proc al_get_audio_stream_fragments(stream: AllegroAudioStream): cint
proc al_get_available_audio_stream_fragments(stream: AllegroAudioStream): cint

proc al_get_audio_stream_speed(stream: AllegroAudioStream): cfloat
proc al_get_audio_stream_gain(stream: AllegroAudioStream): cfloat
proc al_get_audio_stream_pan(stream: AllegroAudioStream): cfloat

proc al_get_audio_stream_channels(stream: AllegroAudioStream): AllegroChanneConf
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
proc al_set_audio_stream_fragment(stream: AllegroAudioStream, val: var pointer): bool

proc al_rewind_audio_stream(stream: AllegroAudioStream): bool
proc al_seek_audio_stream_secs(stream: AllegroAudioStream, time: cdouble): bool
proc al_get_audio_stream_position_secs(stream: AllegroAudioStream): cdouble
proc al_get_audio_stream_length_secs(stream: AllegroAudioStream): cdouble
proc al_set_audio_stream_loop_secs(stream: AllegroAudioStream, start_a, end_a: cdouble): bool

proc al_get_audio_stream_event_source(stream: AllegroAudioStream): AllegroEventSource
{.pop.}
