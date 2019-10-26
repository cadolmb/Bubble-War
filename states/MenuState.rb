class MenuState < GameState

    HEADING = "Bubble War"
    HEADING_FONT = Gosu::Font.new(120, name: 'resources/zorque_font.ttf')
    HEADING_POS = [WIDTH/2, HEIGHT*(0.25)]
    OPTIONS = [
      "Start",
      "Quit"
    ]
    OPTIONS_FONT = Gosu::Font.new(50, name: 'resources/zorque_font.ttf')
    OPTIONS_POS = [WIDTH/2, HEIGHT*(0.45)]
    OPTIONS_PAD = 80
    C1 = Gosu::Color.new(50, 100, 200)
    C2 = Gosu::Color::WHITE

    BG_ANIM = Gosu::Image.load_tiles('resources/menu_bg.png', 435, 250)
    BG_ANIM_SPEED = 100
    BG_SCL_X = WIDTH / 435.0
    BG_SCL_Y = HEIGHT / 250.0

    SONG = Gosu::Song.new('resources/mii_store.mp3')
    MOVE_SOUND = Gosu::Sample.new('resources/menu_move.wav')
    SELECT_SOUND = Gosu::Sample.new('resources/menu_select.wav')

    def initialize
        @selection = 0
    end

    def enter
      SONG.play(true)
    end

    def leave
      SONG.stop
    end

    def button_down(id)
        if id == Gosu::KB_RETURN
            case @selection
            when 0
              SELECT_SOUND.play
              GameState.switch TransitionState.new(1)
            when 1
              $window.close
            end
        end
        if id == Gosu::KB_UP
          @selection = [@selection - 1, 0].max
          MOVE_SOUND.play
        end
        if id == Gosu::KB_DOWN
          @selection = [@selection + 1, OPTIONS.length - 1].min
          MOVE_SOUND.play
        end
    end

    def update
    end

    def draw
        frame = Gosu.milliseconds / BG_ANIM_SPEED % BG_ANIM.length
        BG_ANIM[frame].draw(0, 0, Z::BG, BG_SCL_X, BG_SCL_Y)

        HEADING_FONT.draw_rel(HEADING, HEADING_POS[0], HEADING_POS[1], Z::HUD, 0.5, 0.5, 1, 1, C1)
        OPTIONS.each_with_index do |option, i|
          if i == @selection
            c = C2
            scl = 0.5
          else
            c = C1
            scl = 0
          end
          OPTIONS_FONT.draw_rel(option, OPTIONS_POS[0], OPTIONS_POS[1] + OPTIONS_PAD * i, Z::HUD, 0.5, 0.5, 1 + scl, 1 + scl, c)
        end
    end

end
