class Bullet

  ANIM_WIDTH = 55
  ANIM = Gosu::Image.load_tiles('resources/bullet_pop.png', ANIM_WIDTH, ANIM_WIDTH)
  ANIM_FRAMES = ANIM.length - 1
  POP_TIME = 200
  ANIM_TICK = POP_TIME / ANIM_FRAMES.to_f
  DECEL = 0.7

  attr_accessor :x
  attr_accessor :y
  attr_accessor :rad



  def initialize(x, y, xv, yv, width, speed, penetration)
    @width = width
    @speed = speed
    @penetration = penetration
    @enemies_hit = []

    @x, @y, @xv, @yv = x, y, xv, yv
    @angle = Gosu.angle(0, 0, @xv, @yv) + 25
    @rad = @width / 2.0
    @scl = @width / ANIM_WIDTH.to_f
  end

  def move
    if @popping
      @xv *= DECEL
      @yv *= DECEL
    end

    @x += @xv
    @y += @yv
  end

  def hit(enemy)
    mark_hit enemy
    unless @popping
      @penetration -= 1
      if @penetration == 0
        @popping = true
        @time = Gosu.milliseconds
      end
    end
  end

  def mark_hit(enemy)
    @enemies_hit << enemy
  end

  def already_hit(enemy)
    @enemies_hit.each { |e| return true if e == enemy }
    return false
  end

  def popped?
    begin
      return true if Gosu.milliseconds - @time >= POP_TIME
    rescue
      return false
    end
  end

  def draw
    unless @popping
      ANIM[0].draw_rot(@x, @y, Z::BULLET, @angle, 0.5, 0.5, @scl, @scl)
    else # POPPING
      begin
        frame = (Gosu.milliseconds - @time) / ANIM_TICK
        ANIM[frame].draw_rot(@x, @y, Z::BULLET, @angle, 0.5, 0.5, @scl*1.5, @scl*1.5)
      rescue
        puts "Error, bullet animation frame: #{frame}"
      end
    end
  end

end
