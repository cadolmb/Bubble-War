class UpgradeState < GameState

    HEADING_FONT = Gosu::Font.new(110, name: 'resources/zorque_font.ttf')
    HEADING_POS = [WIDTH * 0.7, HEIGHT*(0.1)]
    HEADING_COLOR = Gosu::Color.new(100, 160, 255)
    MSG = "Use the stars you collect to buy upgrades.\nPress enter to continue."

    BG_ANIM = Gosu::Image.load_tiles('resources/shop_bg.png', 720, 720)
    BG_ANIM_SPEED = 100
    BG_SCL_X = WIDTH / 720.0
    BG_SCL_Y = HEIGHT / 720.0

    CURSOR_IMG = Gosu::Image.new('resources/cursor.png')

    BUTTON_SPACING = 122

    SONG = Gosu::Song.new('resources/mii_store.mp3')
    STAR_SOUND = Gosu::Sample.new('resources/star.wav')
    CONFIRM_SOUND = Gosu::Sample.new('resources/menu_select.wav')

    def initialize(level, stars = 0)
        @level = level
        @stars = stars

        @stats = Upgrades.stats
        @upgrades = Upgrades.upgrades

        @buttons = []
        y = 1
        @stats.each do |stat, upgrade|
            @buttons << Button.new(
                0, y, stat + " - " + upgrade.to_s, # x, y, title
                {stat: stat, upgrade: @upgrades[stat]} # action values
            )
            y += BUTTON_SPACING
        end
    end

    def enter
        SONG.play(true)
    end

    def leave
        SONG.stop
    end

    def button_down(id)
        if id == Gosu::KB_RETURN
            CONFIRM_SOUND.play
            GameState.switch PlayState.new(@level)
        end
        if id == Gosu::MS_LEFT
            unless @stars == 0
                @buttons.each do |button|
                    if button.clicked?
                        stat = button.action[:stat]
                        upgrade = button.action[:upgrade]
                        bought = Upgrades.upgrade(stat, upgrade)
                        @stats = Upgrades.stats
                        button.title = stat + " - " + @stats[stat].to_s
                        if bought
                            @stars -= 1
                            STAR_SOUND.play
                        end
                    end
                end
            end
        end

    end

    def update
    end

    def draw
        frame = Gosu.milliseconds / BG_ANIM_SPEED % BG_ANIM.length
        BG_ANIM[frame].draw(0, 0, Z::BG, BG_SCL_X, BG_SCL_Y)

        CURSOR_IMG.draw($window.mouse_x, $window.mouse_y, Z::TOP)
        @buttons.each { |button| button.draw }

        HEADING_FONT.draw_text_rel("Upgrades", HEADING_POS[0], HEADING_POS[1], Z::HUD, 0.5, 0.5, 1, 1, HEADING_COLOR)
        HEADING_FONT.draw_text_rel("Stars: " + @stars.to_s, HEADING_POS[0], HEADING_POS[1] + 100, Z::HUD, 0.5, 0.5, 0.8, 0.8, HEADING_COLOR)
        Gosu::Font.new(30).draw_markup_rel(MSG, HEADING_POS[0], HEADING_POS[1] + HEIGHT * 0.8, Z::HUD, 0.5, 0.5, 1, 1, Gosu::Color::WHITE)
    end

end
