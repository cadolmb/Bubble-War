class TransitionState < GameState

  FONT = Gosu::Font.new(100,  name: 'resources/zorque_font.ttf')
  TOTAL_TIME = 4000.0
  FADE_TIME = 1500.0

  def initialize(level, show_entities = false, player = nil, bullets = nil, enemies = nil, stars = 0)
    @start_time = Gosu.milliseconds
    @level = level
    @msg = "Level #{@level}"
    @show_entities = show_entities
    @player, @bullets, @enemies = player, bullets, enemies if @show_entities
    @stars = stars
  end

  def enter
  end

  def leave
  end

  def button_down(id)
  end

  def update
    if Gosu.milliseconds - @start_time > TOTAL_TIME
      unless @stars == 0
        GameState.switch UpgradeState.new(@level, @stars)
      else
        GameState.switch PlayState.new(@level)
      end
    end
  end

  def draw
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, BG_COLOR, Z::BG)
    if @show_entities
      @player.draw
      @bullets.each { |bullet| bullet.draw }
      @enemies.each { |enemy| enemy.draw }
    end

    t = Gosu.milliseconds - @start_time
    a = Math.sin( [t / FADE_TIME, 1].min * Math::PI/2.0) * 255
    color = Gosu::Color.new(a, 0, 0, 0)
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, color, Z::TOP)

    a = Math.sin( ((t - FADE_TIME) / (TOTAL_TIME - FADE_TIME)) * Math::PI) * 255
    color = BG_COLOR.dup
    color.alpha = a
    FONT.draw_rel(@msg, WIDTH / 2, HEIGHT / 2, Z::TOP, 0.5, 0.5, 1, 1, color)
  end

end
