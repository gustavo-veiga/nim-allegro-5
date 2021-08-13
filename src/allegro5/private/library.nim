when defined(Windows):
  const allegro* = "Allegro.dll"
  const imageAddon* = "AllegroImage.dll"
elif defined(Linux):
  const allegro* = "liballegro.so"
  const acodecAddon* = "liballegro_acodec.so"
  const audioAddon* = "liballegro_audio.so"
  const colorAddon* = "liballegro_color.so"
  const dialogAddon* = "liballegro_dialog.so"
  const fontAddon* = "liballegro_font.so"
  const imageAddon* = "liballegro_image.so"
  const physfsAddon* = "liballegro_physfs.so"
  const ttfAddon* = "liballegro_ttf.so"
  const videoAddon* = "liballegro_video.so"
elif defined(MacOsX):
  const allegro* = "liballegro.dylib"
  const imageAddon* = "liballegro_image.dylib"
