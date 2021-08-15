import private/library

type
  AllegroRenderState* {.pure.} = enum
    alphaTest       = 0x0010
    writeMask       = 0x0011
    depthTest       = 0x0012
    depthFunction   = 0x0013
    alpheFunction   = 0x0014
    alpheTestValue  = 0x0015
  AllegroRenderFunction* {.pure.} = enum
    never         = 0
    always        = 1
    less          = 2
    equal         = 3
    lessEqual     = 4
    greater       = 5
    notEqual      = 6
    greaterEqual  = 7
  AllegroWriteMaskFlags* {.pure.} = enum
    red   = 1 shl 0
    green = 1 shl 1
    blue  = 1 shl 2
    rgb   = 7 # red | green | blue
    alpha = 1 shl 3
    rgba  = 15 # rgb | alpha
    depth = 1 shl 4

{.push importc, dynlib: library.allegro.}
proc al_set_render_state(state: AllegroRenderState, value: cint): void
{.pop.}

proc renderState*(state: AllegroRenderState, value: int): void =
  al_set_render_state(state, value.cint)
