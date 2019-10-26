class Player

  IMG = Gosu::Image.new('resources/ship.bmp')
  PLAYER_WIDTH = IMG.width
  PLAYER_HEIGHT = IMG.height
  PLAYER_COLLISION_POINTS = [[1, 50], [6, 39], [10, 33], [17, 18], [20, 8], [24.5, 0], [29, 8], [32, 18], [39, 33], [43, 39], [49, 50], [10, 50], [21, 50], [28, 50], [39, 50]]

  HEART_IMG = Gosu::Image.new('resources/heart.png')
  HB_WIDTH = 150
  HB_HEIGHT = 30

  PLAYER_ROT = 4.0
  PLAYER_ACCEL = 0.25
  PLAYER_DECCEL = 0.95
  HIT_COOLDOWN = 2000

  attr_accessor :x
  attr_accessor :y
  attr_accessor :angle
  def dead?; @dead; end
  def width; PLAYER_WIDTH; end
  def height; PLAYER_HEIGHT; end
  def coll_points; PLAYER_COLLISION_POINTS; end

  def initialize
    @x = WIDTH / 2
    @y = HEIGHT / 2
    @xv = 0.0
    @yv = 0.0
    @angle = 0.0
    @start_health = Upgrades.stats["Health"]
    @health = @start_health
    @dead = false
  end

  def turn(direction)
    if direction == "left"
      @angle -= PLAYER_ROT
    end
    if direction == "right"
      @angle += PLAYER_ROT
    end
  end

  def accelerate(direction)
    if direction == 'up'
      @xv += Gosu.offset_x(@angle, PLAYER_ACCEL)
      @yv += Gosu.offset_y(@angle, PLAYER_ACCEL)
    end
    if direction == 'down'
      @xv -= Gosu.offset_x(@angle, PLAYER_ACCEL)
      @yv -= Gosu.offset_y(@angle, PLAYER_ACCEL)
    end
  end

  def move
    @x += @xv
    @y += @yv
    @xv *= PLAYER_DECCEL
    @yv *= PLAYER_DECCEL

    @x = 0 + PLAYER_WIDTH/2 if @x < 0 + PLAYER_WIDTH/2
    @x = WIDTH - PLAYER_WIDTH/2 if @x > WIDTH - PLAYER_WIDTH/2
    @y = 0 + PLAYER_HEIGHT/2 if @y < 0 + PLAYER_HEIGHT/2
    @y = HEIGHT - PLAYER_HEIGHT/2 if @y > HEIGHT - PLAYER_HEIGHT/2
  end

  def hit
    immune = false
    begin
      immune = true if Gosu.milliseconds - @hit_time < HIT_COOLDOWN
    rescue
    end
    unless immune
      @health -= 1
      if @health <= 0
        @dead = true
      else
        @hit_time = Gosu.milliseconds
      end
    end
  end

  def draw
    begin
      t = Gosu.milliseconds - @hit_time
      if t < HIT_COOLDOWN
        r = Math.cos((t / HIT_COOLDOWN.to_f) * Math::PI * 5/2.0).abs * 100
        c = Gosu::Color.new(255, 255 - r, 255 - r)
      else
        c = Gosu::Color::WHITE
      end
    rescue
      c = Gosu::Color::WHITE
    end

    IMG.draw_rot(@x, @y, Z::PLAYER, @angle, 0.5, 0.5, 1, 1, c)

    # HEALTH BAR
    health_width = [HB_WIDTH * @health/@start_health.to_f, 0].max
    pad = (HEART_IMG.height - HB_HEIGHT) / 2.0
    heart_x, heart_y = 10, 10
    x = heart_x + HEART_IMG.width * 0.5
    y = heart_y + pad
    HEART_IMG.draw(heart_x, heart_y, Z::HUD + 1)
    Gosu.draw_rect(x, y, health_width, HB_HEIGHT, Gosu::Color::GREEN, Z::HUD)
    Gosu.draw_rect(x + health_width, y, HB_WIDTH - health_width, HB_HEIGHT, Gosu::Color::RED , Z::HUD)
  end

end
