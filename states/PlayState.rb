class PlayState < GameState

  FONT = Gosu::Font.new(50, name: 'resources/zorque_font.ttf')
  TEXT_COLOR = Gosu::Color.new(100, 160, 255)
  TEXT_POS = [100, 100]

  SONG = Gosu::Song.new('resources/cave_story.mp3')
  STAR_SOUND = Gosu::Sample.new('resources/star.wav')

  def initialize(level)
      @level = level

      @player = Player.new
      @enemies = []
      @bullets = []
      @stars = []
      @star_count = 0

      @damage = Upgrades.stats["Damage"]
      @bullet_speed = Upgrades.stats["Bullet Speed"]
      @bullet_width = Upgrades.stats["Bullet Size"]
      @bullet_penetration = Upgrades.stats["Bullet Piercing"]
      @double_shot = Upgrades.stats["Double Shot"]
  end

  def enter
    SONG.play(true)
    spawn_enemies @level
  end

  def leave
    SONG.stop
  end



  def spawn_enemies(level)
    enemies = File.readlines('data/levels.csv')[level - 1].split(',')
    enemies.each_with_index do |n, i|
      n.to_i.times { @enemies << Enemy.new(i) }
    end
  end


  def shoot
    unless @double_shot
      @bullets << Bullet.new(
        @player.x + Gosu.offset_x(@player.angle, @player.width/2.0),
        @player.y + Gosu.offset_y(@player.angle, @player.height/2.0),
        Gosu.offset_x(@player.angle, @bullet_speed),
        Gosu.offset_y(@player.angle, @bullet_speed),
        @bullet_width, @bullet_speed, @bullet_penetration
      )
    else
      @bullets << Bullet.new(
        @player.x + Gosu.offset_x(@player.angle, @player.width/2.0),
        @player.y + Gosu.offset_y(@player.angle, @player.height/2.0),
        Gosu.offset_x(@player.angle + 5, @bullet_speed),
        Gosu.offset_y(@player.angle + 5, @bullet_speed),
        @bullet_width, @bullet_speed, @bullet_penetration
      )
      @bullets << Bullet.new(
        @player.x + Gosu.offset_x(@player.angle, @player.width/2.0),
        @player.y + Gosu.offset_y(@player.angle, @player.height/2.0),
        Gosu.offset_x(@player.angle - 5, @bullet_speed),
        Gosu.offset_y(@player.angle - 5, @bullet_speed),
        @bullet_width, @bullet_speed, @bullet_penetration      )
    end
  end

  def pop(enemy, bullet)
    enemy.pop
    begin # SPLIT
      types = enemy.split[0]
      num = enemy.split[1]
      num.times do
        types.each do |type|
          new_enemy = Enemy.new(type, true, enemy.x, enemy.y)
          @enemies << new_enemy
          bullet.mark_hit new_enemy
        end
      end
    rescue
      # NOT SPLITABLE ENEMY
    end
  end

  def drop_items(enemy)
    if rand < 0.1
      @stars << Star.new(enemy.x, enemy.y)
    end
  end




  def button_down(id)
    if id == Gosu::KB_SPACE
      shoot
    end
  end





  # U P D A T E
  def update
    # USER INPUT
    if Gosu.button_down? Gosu::KB_LEFT
      @player.turn 'left'
    end
    if Gosu.button_down? Gosu::KB_RIGHT
      @player.turn 'right'
    end
    if Gosu.button_down? Gosu::KB_UP
      @player.accelerate 'up'
    end
    if Gosu.button_down? Gosu::KB_DOWN
      @player.accelerate 'down'
    end

    # UPDATE ENTITY POSITIONS
    @player.move
    @bullets.each { |bullet| bullet.move }
    @enemies.each { |enemy| enemy.move }

    # DELETE OLD ENTITIES
    @bullets.reject! do |bullet|
      bullet.x < 0 - @bullet_width || bullet.x > WIDTH ||
      bullet.y < 0 - @bullet_width || bullet.y > HEIGHT ||
      bullet.popped?
    end

    @enemies.reject! do |enemy|
      enemy.popped?
    end
    @enemies.compact!

    # COLISSION
    @enemies.each do |enemy|
      # BULLET - ENEMY
      @bullets.each do |bullet|
        unless bullet.already_hit(enemy)
          if Collision.circle(bullet, enemy)
            bullet.hit(enemy)
            enemy.hit(@damage)
            if enemy.dead? && !enemy.popping?
              pop(enemy, bullet)
              drop_items(enemy)
            end
          end
        end
      end
      # PLAYER - ENEMY
      if Collision.player_enemy(@player, enemy) && !enemy.popping?
        @player.hit
      end
    end
    @stars.each do |star|
      if Collision.player_star(@player, star)
        @stars.delete star
        @star_count += 1
        STAR_SOUND.play
      end
    end

    if @enemies.empty?
      GameState.switch TransitionState.new(@level + 1, true, @player, @bullets, @enemies, @star_count)
    end
  end





  def draw
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, BG_COLOR, Z::BG)

    FONT.draw_text_rel("Stars: " + @star_count.to_s, TEXT_POS[0], TEXT_POS[1], Z::HUD, 0.5, 0.5, 1, 1, TEXT_COLOR)

    @player.draw
    @bullets.each { |bullet| bullet.draw }
    @enemies.each { |enemy| enemy.draw }
    @stars.each { |star| star.draw }

    if @player.dead?
      Upgrades.reset
      GameState.switch DeadState.new(@player, @bullets, @enemies)
    end



    # DEBUG

    # @enemies.each do |c|
    #   t = @player
    #   t.coll_points.each do |v|
    #     x = t.x + (v[0] - t.width/2) * Math.cos(t.angle*(Math::PI/180)) - (v[1] - t.height/2) * Math.sin(t.angle*(Math::PI/180))
    #     y = t.y + (v[0] - t.width/2) * Math.sin(t.angle*(Math::PI/180)) + (v[1] - t.height/2) * Math.cos(t.angle*(Math::PI/180))
    #
    #     red = Gosu::Color::RED
    #     Gosu.draw_line(x, y, red, c.x, c.y+c, red)
    #   end
    # end

    # @stars.each do |s|
    #   p = @player
    #   red = Gosu::Color::RED
    #   Gosu.draw_line(p.x, p.y, red, s.x + s.rad, s.y + s.rad, red)
    # end
  end

end
