## High level drawing routines
## ===========================
## 
## High level drawing routines encompass the most common usage of this addon:
## to draw geometric primitives, both smooth (variations on the circle theme)
## and piecewise linear. Outlined primitives support the concept of thickness
## with two distinct modes of output: hairline lines and thick lines. Hairline
## lines are specifically designed to be exactly a pixel wide, and are commonly
## used for drawing outlined figures that need to be a pixel wide. Hairline
## thickness is designated as thickness less than or equal to 0. Unfortunately,
## the exact rasterization rules for drawing these hairline lines vary from one
## video card to another, and sometimes leave gaps where the lines meet. If that
## matters to you, then you should use thick lines. In many cases, having a
## thickness of 1 will produce 1 pixel wide lines that look better than hairline
## lines. Obviously, hairline lines cannot replicate thicknesses greater than 1.
## Thick lines grow symmetrically around the generating shape as thickness is
## increased.
## 
## Pixel-precise output
## ====================
## 
## While normally you should not be too concerned with which pixels are displayed
## when the high level primitives are drawn, it is nevertheless possible to control
## that precisely by carefully picking the coordinates at which you draw those
## primitives.
## 
## To be able to do that, however, it is critical to understand how GPU cards convert
## shapes to pixels. Pixels are not the smallest unit that can be addressed by the GPU.
## Because the GPU deals with floating point coordinates, it can in fact assign
## different coordinates to different parts of a single pixel. To a GPU, thus, a screen
## is composed of a grid of squares that have width and length of 1. The top left corner
## of the top left pixel is located at (0, 0). Therefore, the center of that pixel is at
## (0.5, 0.5). The basic rule that determines which pixels are associated with which
## shape is then as follows: a pixel is treated to belong to a shape if the pixel's
## center is located in that shape. The figure below illustrates the above concepts:
## 
## ```
##  0         1         2         3                   0         1         2         3    
## º------------------------------- y                º------------------------------- y  
##  |         |         |         |                   |         |         |         |    
##  | (.5, .5)|       $$|$$       |                   |         |         |         |    
##  |    +    |    +  $ | $  +    |                   |         |         |         |    
##  |         |       $$|$$       |                   |         |         |         |    
##  |         |         |         |                   |         |         |         |    
## ¹-------------------------------                  ¹-------------------------------    
##  |         |         |         |                   |         |#########|#########|     
##  |         |  #######|#########|                   |         |#########|#########|    
##  |    +    |  # +    |    +   #|        -->        |         |#########|#########|    
##  |         |  #      |        #|                   |         |#########|#########|    
##  |         |  #      |        #|                   |         |#########|#########|    
## ²-------------------------------                  ²-------------------------------    
##  |   @@@@@@|  #      |        #|                   |@@@@@@@@@|         |         |    
##  |  @      |@ #######|#########|                   |@@@@@@@@@|         |         |    
##  | @  +    | @ +     |    +    |                   |@@@@@@@@@|         |         |    
##  |@        |  @      |         |                   |@@@@@@@@@|         |         |    
##  | @       | @       |         |                   |@@@@@@@@@|         |         |    
## ³-------------------------------                  ³-------------------------------    
## y                                                 y                                   
## ```
## 
## Diagram showing a how pixel output is calculated by the GPU given the mathematical
## description of several shapes.
## 
## This figure depicts three shapes drawn at the top left of the screen: an orange
## (#) and green ($) rectangles and a purple (@) circle. On the left are the
## mathematical descriptions of pixels on the screen and the shapes to be drawn.
## On the right is the screen output. Only a single pixel has its center inside the
## circle, and therefore only a single pixel is drawn on the screen. Similarly, two
## pixels are drawn for the orange rectangle. Since there are no pixels that have
## their centers inside the green rectangle, the output image has no green pixels.

import allegro5/private/library

{.push importc, dynlib: library.primitivesAddon.}
proc al_init_primitives_addon(): bool
{.pop.}

proc installAllegroPrimitivesAddon*(): void =
  discard al_init_primitives_addon()
