class Enemy

  BUBBLE_WIDTH = 290
  POP_WIDTH = 400
  IDLE_IMG = Gosu::Image.new('resources/enemy_idle.png')
  POP_ANIM = Gosu::Image.load_tiles('resources/enemy_pop.png', POP_WIDTH, POP_WIDTH)
  POP_TIME = 350
  PAD = 5
  BOUND_PAD = 200
  HEALTH_DISPLAY_TIME = 600

  # ENEMY TYPES
  BLUE = 0
  GREEN = 1
  BIGBLUE = 2
  BIGGREEN = 3
  RED = 4

  TYPES = [
    { #BLUE
      color: Gosu::Color.new(0, 40, 100),
      health: 5,
      speed: 4,
      rad: 25
    },
    { #RED
      color: Gosu::Color.new(0, 80, 40),
      health: 10,
      speed: 3.5,
      rad: 35
    },
    { #BIG BLUE
      color: Gosu::Color.new(0, 50, 150),
      health: 25,
      speed: 3,
      rad: 50,
      split: [[BLUE], 4]
    },
    { #BIG GREEN
      color: Gosu::Color.new(0, 120, 40),
      health: 30,
      speed: 2.5,
      rad: 65,
      split: [[GREEN], 4]
    },
    { #RED
      color: Gosu::Color.new(255, 30, 30),
      health: 50,
      speed: 2,
      rad: 80,
      split: [[BIGBLUE, BIGGREEN], 2]
    }
  ]

  attr_accessor :x
  attr_accessor :y
  attr_accessor :rad
  attr_accessor :split

  def initialize(type, overide_pos = false, x = nil, y = nil)
    @speed = TYPES[type][:speed]
    @start_health = TYPES[type][:health]
    @health = @start_health
    @split = TYPES[type][:split]
    @color = TYPES[type][:color]
    @rad = TYPES[type][:rad]
    @scl = @rad*2 / BUBBLE_WIDTH.to_f
    @dead = false
    @popping = false
    @deccel = 1

    #RANDOM SPAWN POSITION
    unless overide_pos
      angle = rand * 360
      rand_diff = rand(10) - 5
      @x = WIDTH/2 + Gosu.offset_x(angle, WIDTH)
      @y = HEIGHT/2 + Gosu.offset_y(angle, HEIGHT)
      @xv = Gosu.offset_x(angle + rand_diff, -@speed)
      @yv = Gosu.offset_y(angle + rand_diff, -@speed)
    else
      @x, @y = x, y
      angle = rand*360
      @xv = Gosu.offset_x(angle, @speed)
      @yv = Gosu.offset_y(angle, @speed)
    end
  end

  def move
    @x += @xv * @deccel
    @y += @yv * @deccel

    if @x - @rad < 0 && @xv < 0 || @x + @rad > WIDTH && @xv > 0
      @xv = -@xv
    end
    if @y - @rad < 0 && @yv < 0 || @y + @rad > HEIGHT && @yv > 0
      @yv = -@yv
    end
  end

  def hit(damage)
      @health -= damage
      @dead = true if @health <= 0
      @time_hit = Gosu.milliseconds
  end

  def dead?
    @dead
  end

  def pop
    @popping = true
    @pop_time = Gosu.milliseconds
    @deccel = 0.2
  end

  def popping?
    @popping
  end

  def popped?
    begin
      return true if Gosu.milliseconds - @pop_time > POP_TIME
    rescue
    end
    return false
  end

  def draw
    unless @popping
      IDLE_IMG.draw(@x - @rad, @y - @rad, Z::ENEMY, @scl, @scl, @color, :additive)

      # Health Bar
      begin
        time = Gosu.milliseconds - @time_hit

        if time < HEALTH_DISPLAY_TIME
          bar_width = @rad
          health_width = bar_width * @health/@start_health.to_f
          height = bar_width / 5.0
          x = @x - bar_width/2.0
          y = @y + @rad + height

          a = Math.cos((time / HEALTH_DISPLAY_TIME.to_f) * Math::PI / 2.0) * 255
          green = Gosu::Color.new(a, 0, 255, 0)
          red = Gosu::Color.new(a, 255, 0, 0)
          Gosu.draw_rect(x, y, health_width, height, green, Z::ENEMY)
          Gosu.draw_rect(x + health_width, y, bar_width - health_width, height, red, Z::ENEMY)
        end
      rescue
      end

    else # POPPING
      begin
        x = @x - (POP_WIDTH - BUBBLE_WIDTH)/2 * @scl
        y = @y - (POP_WIDTH - BUBBLE_WIDTH)/2 * @scl
        frame = (Gosu.milliseconds - @pop_time) / (POP_TIME / (POP_ANIM.length - 1).to_f)
        POP_ANIM[frame].draw(x - @rad, y - @rad, Z::ENEMY, @scl, @scl, @color, :additive)
      rescue
        puts "Error, enemy animation frame: #{frame}"
      end
    end
  end

end
