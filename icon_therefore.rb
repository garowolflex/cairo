require 'cairo'

WIDTH = 128
HEIGHT = WIDTH
ICON_SIZE = (WIDTH * 0.8) / 2.0
CORE_SIZE = ICON_SIZE / 10.0

PIECE_CNT = 3
LINE_COLOR = "#00000099"
PIECE_COLORS = [
  ['#0033CCFF', '#FF0000FF'],
  ['#000066FF', '#EEEEFFFF'],
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

context.rotate(Math::PI / 2.0)

LIGHTING_RAD = Math::PI * 5.0 / 4.0
x, y = getpos.call(ICON_SIZE - 24.0, LIGHTING_RAD)
s_grad = Cairo::RadialPattern.new(
  0, 0, ICON_SIZE,
  x, y, 0
)
s_grad.add_color_stop(0.0, '#00000099')
s_grad.add_color_stop(0.3, '#3333FF33')
s_grad.add_color_stop(0.5, '#3333FF00')

context.fill do
  context.circle(0, 0, ICON_SIZE)
  context.set_source(s_grad)
end

surface.write_to_png('icon_therefore.png')
