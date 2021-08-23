import ../private/library

{.push importc, dynlib: library.allegro.}
proc al_init_acodec_addon(): bool
proc al_is_acodec_addon_initialized(): bool
proc al_get_allegro_acodec_version(): cuint
{.pop.}

proc installAllegroAcodecAddon*(): void =
  ## This function registers all the known audio file type handlers for
  ## al_load_sample, al_save_sample, al_load_audio_stream, etc.
  ## 
  ## Depending on what libraries are available, the full set of recognised
  ## extensions is: .wav, .flac, .ogg, .opus, .it, .mod, .s3m, .xm, .voc.
  ## 
  ## Limitations:
  ## * Saving is only supported for wav files.
  ## * The wav file loader currently only supports 8/16 bit little endian PCM files.
  ##   16 bits are used when saving wav files. Use flac files if more precision is required.
  ## * Module files (.it, .mod, .s3m, .xm) are often composed with streaming in mind,
  ##   an sometimes cannot be easily rendered into a finite length sample. Therefore they
  ##   cannot be loaded with al_load_sample/al_load_sample_f and must be streamed
  ##   with al_load_audio_stream or al_load_audio_stream_f.
  ## * .voc file streaming is unimplemented.
  discard al_init_acodec_addon()

proc isAllegroAcodecAddonInitialized*(): bool =
  # Returns true if the acodec addon is initialized, otherwise returns false.
  return al_is_acodec_addon_initialized()

proc allegroAcodecAddonVersion*(): uint =
  # Returns the (compiled) version of the addon.
  return al_get_allegro_acodec_version()
