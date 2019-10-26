class Star

  STAR_WIDTH = 25
  FRAME_SPEED = 200
  STAR_ANIM = Gosu::Image.load_tiles('resources/star.png', STAR_WIDTH, STAR_WIDTH)

  attr_accessor :x
  attr_accessor :y
  attr_accessor :rad

  def initialize(x, y)
    @x = x
    @y = y
    @rad = STAR_WIDTH / 2.0
    @color = Gosu::Color.new(rand(255), rand(255), rand(255))
  end

  def draw
    frame = (Gosu.milliseconds / FRAME_SPEED) % STAR_ANIM.length
    STAR_ANIM[frame].draw(@x - @rad, @y - @rad, Z::STAR, 1, 1, @color, :additive)
  end

end
