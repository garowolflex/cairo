require 'cairo'

WIDTH = 32
HEIGHT = WIDTH

surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, WIDTH, HEIGHT)
context = Cairo::Context.new(surface)

# Do Drawing.

surface.write_to_png('sample.png')
