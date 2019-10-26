class Button

    SCL = 0.8
    SCL_X = SCL * 1.5; SCL_Y = SCL
    FONT = Gosu::Font.new((45 * SCL).to_i, name: 'resources/zorque_font.ttf')
    IMG = Gosu::Image.new('resources/button.png')

    attr_accessor :title
    attr_accessor :action

    def initialize(x, y, title, action = {})
        @x = x
        @y = y
        @title = title
        @action = action
    end

    def clicked?
        mx = $window.mouse_x
        my = $window.mouse_y
        return true if mx > @x && mx < @x + IMG.width * SCL_X && my > @y && my < @y + IMG.height * SCL_Y
    end

    def draw
        IMG.draw(@x, @y, Z::HUD, SCL_X, SCL_Y)
        FONT.draw_rel(@title, @x + IMG.width/2 * SCL_X, @y + IMG.height/2  * SCL_Y, Z::HUD + 1, 0.5, 0.5)
    end

end
