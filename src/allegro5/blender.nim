import private/library, color

type
  AllegroBlendMode* {.pure.} = enum
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
  AllegroBlendOperations* {.pure.} = enum
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
