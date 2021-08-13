when defined(Windows):
  const name* = "Allegro.dll"
elif defined(Linux):
  const name* = "liballegro.so"
elif defined(MacOsX):
  const name* = "liballegro.dylib"

when defined(Windows):
  const image* = "Allegro_image.dll"
elif defined(Linux):
  const image* = "liballegro_image.so"
elif defined(MacOsX):
  const image* = "liballegro_image.dylib"
