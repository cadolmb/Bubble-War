class Window < Gosu::Window

    attr_accessor :state

    def initialize
        super WIDTH, HEIGHT
        self.caption = TITLE
    end

    def button_down(id)
        @state.button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        end
    end

    def update
        @state.update
    end

    def draw
        @state.draw
    end

end
