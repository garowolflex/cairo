require 'cairo'

IMAGE_SIZE = 1024
RADIUS = (IMAGE_SIZE / 2.0) - 8.0

BG_COLOR = '#FFFFFF'
LINE_COLOR = '#333333'
LINE_WIDTH = 1.0

if (corner_count = ARGV[0].to_i) < 3
  puts "三角形からしか使えません"
  exit 1
end

# 初期化(背景色塗り + 原点を中央に移動 + 最初の頂点を上に)
surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, IMAGE_SIZE, IMAGE_SIZE)
context = Cairo::Context.new(surface)
context.set_source_color(BG_COLOR)
context.paint
context.translate(IMAGE_SIZE / 2.0, IMAGE_SIZE / 2.0)
context.rotate(-Math::PI / 2.0)

# 描画準備
per_rad = Math::PI * 2 / corner_count
position = ->(r, i){ [r * Math.cos(i * per_rad), r * Math.sin(i * per_rad)] }

# 描画
context.stroke do
  context.set_source_color(LINE_COLOR)
  context.set_line_width(LINE_WIDTH)

  corner_count.times do |c|
    x, y = position[RADIUS, c]
    context.line_to(x, y)
  end
  context.close_path
end

# ファイルに出力
surface.write_to_png("polygon[#{corner_count}].png")
