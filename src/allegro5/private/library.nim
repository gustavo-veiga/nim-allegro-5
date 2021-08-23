import std/strformat

const version = "5.(0|1|2)"

when defined(Windows):
  const
    allegro*          = &"allegro-{version}.dll"
    ttfAddon*         = &"allegro_ttf-{version}.dll"
    fontAddon*        = &"allegro_font-{version}.dll"
    audioAddon*       = &"allegro_audio-{version}.dll"
    colorAddon*       = &"allegro_color-{version}.dll"
    imageAddon*       = &"allegro_image-{version}.dll"
    videoAddon*       = &"allegro_video-{version}.dll"
    dialogAddon*      = &"allegro_dialog-{version}.dll"
    physfsAddon*      = &"allegro_physfs-{version}.dll"
    acodecAddon*      = &"allegro_acodec-{version}.dll"
    primitivesAddon*  = &"allegro_primitives-{version}.dll"
elif defined(Linux):
  const
    allegro*          = &"liballegro.so.{version}"
    ttfAddon*         = &"liballegro_ttf.so.{version}"
    fontAddon*        = &"liballegro_font.so.{version}"
    audioAddon*       = &"liballegro_audio.so.{version}"
    colorAddon*       = &"liballegro_color.so.{version}"
    imageAddon*       = &"liballegro_image.so.{version}"
    videoAddon*       = &"liballegro_video.so.{version}"
    dialogAddon*      = &"liballegro_dialog.so.{version}"
    physfsAddon*      = &"liballegro_physfs.so.{version}"
    acodecAddon*      = &"liballegro_acodec.so.{version}"
    primitivesAddon*  = &"liballegro_primitives.so.{version}"
elif defined(MacOsX):
  const
    allegro*          = &"liballegro.{version}.dylib"
    ttfAddon*         = &"liballegro_ttf.{version}.dylib"
    fontAddon*        = &"liballegro_font.{version}.dylib"
    audioAddon*       = &"liballegro_audio.{version}.dylib"
    colorAddon*       = &"liballegro_color.{version}.dylib"
    imageAddon*       = &"liballegro_image.{version}.dylib"
    videoAddon*       = &"liballegro_video.{version}.dylib"
    dialogAddon*      = &"liballegro_dialog.{version}.dylib"
    physfsAddon*      = &"liballegro_physfs.{version}.dylib"
    acodecAddon*      = &"liballegro_acodec.{version}.dylib"
    primitivesAddon*  = &"liballegro_primitives.{version}.dylib"
