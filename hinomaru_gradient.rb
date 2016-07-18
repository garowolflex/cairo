require 'cairo'

WIDTH = 128
HEIGHT = WIDTH * 2 / 3.0
HINOMARU_R = HEIGHT * 3 / 5.0 / 2.0
GRADIENT_R = HINOMARU_R / 4.0

surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, WIDTH, HEIGHT)
context = Cairo::Context.new(surface)

l_grad = Cairo::LinearPattern.new(0, 0, 0, HEIGHT)
l_grad.add_color_stop(0.0, '#FFFF3333')
l_grad.add_color_stop(0.30, '#FFFFFF00')
l_grad.add_color_stop(0.35, '#FFFFFF00')
l_grad.add_color_stop(0.7, '#FFFF3333')
l_grad.add_color_stop(1.0, '#000000FF')

context.fill do
  context.rectangle(0, 0, WIDTH, HEIGHT)
  context.set_source_color('#FFFFFFFF')
  context.fill(true)
  context.set_source(l_grad)
end

x = WIDTH / 2.0 - Math.cos(Math::PI / 4.0) * (HINOMARU_R - GRADIENT_R) + 4.0
y = HEIGHT / 2.0 - Math.sin(Math::PI / 4.0) * (HINOMARU_R - GRADIENT_R) + 4.0

r_grad = Cairo::RadialPattern.new(
  WIDTH / 2.0, HEIGHT / 2.0, HINOMARU_R,
  x, y, GRADIENT_R
)

r_grad.add_color_stop(0.0, '#00000066')
r_grad.add_color_stop(0.2, '#FF000033')
r_grad.add_color_stop(0.7, '#FF000099')
r_grad.add_color_stop(1.0, '#FFFFFFFF')

context.fill do
  context.circle(WIDTH / 2.0, HEIGHT / 2.0, HINOMARU_R)
  context.set_source_color('#C22047FF')
  context.fill(true)
  context.set_source(r_grad)
end

surface.write_to_png('hinomaru.png')
