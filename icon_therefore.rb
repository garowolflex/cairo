require 'cairo'

WIDTH = 128
HEIGHT = WIDTH
ICON_SIZE = (WIDTH - 2.0) / 2.0
CORE_SIZE = ICON_SIZE / 10.0

PIECE_CNT = 3
LINE_COLOR = "#00000099"
PIECE_COLORS = [
  ['#000066FF', '#FF0000FF'],
  ['#333333FF', '#EEEEFFFF'],
  ['#EEEEFFFF', '#000066FF'],
]

surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, WIDTH, HEIGHT)
context = Cairo::Context.new(surface)

context.translate(WIDTH / 2.0, HEIGHT / 2.0)
context.set_line_width(1.0)

getpos = ->(len, rot){ [len * Math.cos(rot), len * Math.sin(rot)] }

context.rotate(-Math::PI / 2.0)
PIECE_CNT.times do |cnt|
  rot_to = Math::PI * 2.0 / PIECE_CNT
  x, y = getpos.call(ICON_SIZE / 2.0, rot_to)
  piece_color, core_color = PIECE_COLORS[cnt]

  context.stroke do
    context.arc(0, 0, ICON_SIZE, 0, rot_to)
    rot_end = rot_to + Math::PI
    context.arc(x, y, ICON_SIZE / 2.0, rot_to, rot_end)
    context.arc_negative(ICON_SIZE / 2.0, 0, ICON_SIZE / 2.0, Math::PI, 0)
    context.set_source_color(piece_color)
    context.fill(true)
    context.set_source_color(LINE_COLOR)
  end

  context.stroke do
  	context.circle(x, y, CORE_SIZE)
    context.set_source_color(core_color)
    context.fill(true)
    context.set_source_color(LINE_COLOR)
  end

  context.rotate(rot_to)
end

surface.write_to_png('icon_therefore.png')
