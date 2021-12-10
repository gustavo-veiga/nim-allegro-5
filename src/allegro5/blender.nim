import private/library, color

type
  AllegroBlendMode* {.pure, final.} = enum
    zero              = 0
    one               = 1
    alpha             = 2
    inverseAlpha      = 3
    srcColor          = 4
    destColor         = 5
    inverseSrcColor   = 6
    inverseDestColor  = 7
    constColor        = 8
    inverseConstColor = 9
    numBlendModes     = 10
  AllegroBlendOperation* {.pure, final.} = enum
    add                 = 0
    srcMinusDest        = 1
    destMinusSrc        = 2
    numBlendOperations  = 3

{.push importc, dynlib: library.allegro.}
proc al_set_blender(op, source, dest: cint): void
proc al_set_blend_color(color: AllegroColor): void
proc al_get_blender(op, source, dest: var cint): void
proc al_get_blend_color(): AllegroColor
proc al_set_separate_blender(op, source, dest, alpha_op, alpha_source, alpha_dest: cint): void
proc al_get_separate_blender(op, source, dest, alpha_op, alpha_src, alpha_dest: var cint): void
{.pop.}

proc blender*(operation: AllegroBlendOperation, source, destination: AllegroBlendMode): void =
  ## Sets the function to use for blending for the current thread.
  ## 
  ## Blending means, the source and destination colors are combined in drawing operations.
  ## 
  ## Assume the source color (e.g. color of a rectangle to draw, or pixel of a bitmap
  ## to draw) is given as its red/green/blue/alpha components (if the bitmap has no
  ## alpha it always is assumed to be fully opaque, so 255 for 8-bit or 1.0 for
  ## floating point): s = s.r, s.g, s.b, s.a. And this color is drawn to a destination,
  ## which already has a color: d = d.r, d.g, d.b, d.a.
  ## 
  ## The conceptional formula used by Allegro to draw any pixel then depends on the op parameter:
  ## 
  ## ALLEGRO_ADD
  ## .. code-block:: nim
  ##   r = d.r * df.r + s.r * sf.r
  ##   g = d.g * df.g + s.g * sf.g
  ##   b = d.b * df.b + s.b * sf.b
  ##   a = d.a * df.a + s.a * sf.a
  ## 
  ## ALLEGRO_DEST_MINUS_SRC
  ## .. code-block:: nim
  ##   r = d.r * df.r - s.r * sf.r
  ##   g = d.g * df.g - s.g * sf.g
  ##   b = d.b * df.b - s.b * sf.b
  ##   a = d.a * df.a - s.a * sf.a
  ## 
  ## ALLEGRO_SRC_MINUS_DEST
  ## .. code-block:: nim
  ##   r = s.r * sf.r - d.r * df.r
  ##   g = s.g * sf.g - d.g * df.g
  ##   b = s.b * sf.b - d.b * df.b
  ##   a = s.a * sf.a - d.a * df.a
  al_set_blender(operation.cint, source.cint, destination.cint)

proc blend*(color: AllegroColor): void =
  ## Sets the color to use for blending when using the ALLEGRO_CONST_COLOR
  ## or ALLEGRO_INVERSE_CONST_COLOR blend functions. 
  al_set_blend_color(color)

proc blender*(): tuple[operation: AllegroBlendOperation, source, destination: AllegroBlendMode] =
  ## Returns the active blender for the current thread.
  var source, destination, operation: cint = 0
  al_get_blender(operation, source, destination)
  return (
    AllegroBlendOperation(operation),
    AllegroBlendMode(source),
    AllegroBlendMode(destination)
  )

proc blend*(): AllegroColor =
  ## Returns the color currently used for constant color blending (white by default).
  return al_get_blend_color()

proc separateBlender*(operation, source, destination, alphaOperation, alphaSource, alphaDestination: int32): void =
  ## Like al_set_blender, but allows specifying a separate blending operation for the
  ## alpha channel. This is useful if your target bitmap also has an alpha channel and
  ## the two alpha channels need to be combined in a different way than the color components.
  al_set_separate_blender(operation, source, destination, alphaOperation, alphaSource, alphaDestination)

proc separateBlender*(): tuple[operation, source, destination, alphaOperation, alphaSource, alphaDestination: int32] =
  ## Returns the active blender for the current thread.
  var operation, source, destination, alphaOperation, alphaSource, alphaDestination: cint = 0
  al_get_separate_blender(operation, source, destination, alphaOperation, alphaSource, alphaDestination)
  return (operation, source, destination, alphaOperation, alphaSource, alphaDestination)
