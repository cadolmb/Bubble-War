class GameState

    def self.switch(new_state)
        $window&.state&.leave
        $window.state = new_state
        new_state.enter
    end

    def enter
    end

    def leave
    end

    def button_down(id)
    end

    def update
    end

    def draw
    end

end
