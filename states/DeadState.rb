class DeadState < GameState

  FONT = Gosu::Font.new(100, name: 'resources/zorque_font.ttf')
  MSG = "You Died"
  TOTAL_TIME = 5000.0
  FADE_TIME = 2000.0

  def initialize(player, bullets, enemies)
    @start_time = Gosu.milliseconds
    @player, @bullets, @enemies = player, bullets, enemies
  end

  def enter
  end

  def leave
  end

  def button_down(id)
  end

  def update
    if Gosu.milliseconds - @start_time > TOTAL_TIME
      GameState.switch MenuState.new
    end
  end

  def draw
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, BG_COLOR, Z::BG)

    @player.draw
    @bullets.each { |bullet| bullet.draw }
    @enemies.each { |enemy| enemy.draw }

    t = Gosu.milliseconds - @start_time
    a = Math.sin( [t / FADE_TIME, 1].min * Math::PI/2.0) * 255
    color = Gosu::Color.new(a, 0, 0, 0)
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, color, Z::TOP)

    a = Math.sin( ((t - FADE_TIME) / (TOTAL_TIME - FADE_TIME)) * Math::PI) * 255
    color = Gosu::Color.new(a, 255, 0, 0)
    FONT.draw_rel(MSG, WIDTH / 2, HEIGHT / 2, Z::TOP, 0.5, 0.5, 1, 1, color)
  end

end
