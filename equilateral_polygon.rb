require 'cairo'

IMAGE_SIZE = 1024
RADIUS = (IMAGE_SIZE / 2.0) - 8.0

BG_COLOR = '#FFFFFF'
#LINE_COLOR = '#333333'
LINE_WIDTH = 1.0

if (corner_count = ARGV[0].to_i) < 3
  puts "三角形からしか使えません"
  exit 1
end

# 虹色ピッカー生成(引数: 目標カウント数)
# 目標カウント数の周期で赤緑青への遷移を行う、色取得用のラムダ式を生成する
def create_rainbow_picker(count)
  ->(i) {
    r = g = b = 0
    phase_val = 6.0 * i / count
    phase_val -= 6.0 if phase_val > 6.0
    fraction = phase_val - phase_val.floor
    case phase_val.to_i
    when 0
      # 赤MAX, 緑UP
      r = 1.0
      g = fraction
    when 1
      # 赤DOWN, 緑MAX
      r = 1.0 - fraction
      g = 1.0
    when 2
      # 緑MAX, 青UP
      g = 1.0
      b = fraction
    when 3
      # 緑DOWN, 青MAX
      g = 1.0 - fraction
      b = 1.0
    when 4
      # 青MAX, 赤UP
      b = 1.0
      r = fraction
    when 5
      # 青DOWN, 赤MAX
      b = 1.0 - fraction
      r = 1.0
    end

    [r, g, b]
  }
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
picker = create_rainbow_picker(corner_count)

# 描画
context.set_line_width(LINE_WIDTH)

corner_count.times do |c|
  sx, sy = position[RADIUS, c]
  dx, dy = position[RADIUS, c + 1]
  context.stroke do
    context.move_to(sx, sy)
    context.line_to(dx, dy)
    context.set_source_color(picker[c])
  end
end

# ファイルに出力
surface.write_to_png("polygon[#{corner_count}].png")
