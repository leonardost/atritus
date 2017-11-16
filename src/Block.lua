function Block(x, y, color, state)

    local STATES = {
        ACTIVE = 1,
        BLINKING = 2,
        DESTROYED = 3
    }
    local BLINKING_STATES = {
        ON = 1,
        OFF = 2
    }

    local self = {}
    self.x = x
    self.y = y
    self.color = color
    self.state = state
    local blinkingState = BLINKING_STATES.ON
    local BLINKING_TIME = 0.25
    local timeInBlinkingState = 0

    function self.copy()
        return Block(self.x, self.y, self.color, self.state)
    end

    function self.set(x, y)
        self.x = x
        self.y = y
    end

    function self.isActive()
        return self.state == STATES.ACTIVE
    end

    function self.setActive()
        self.state = STATES.ACTIVE
    end

    function self.enterBlinkingState()
        self.state = STATES.BLINKING
        timeInBlinkingState = 0
    end

    function self.isBlinking()
        return self.state == STATES.BLINKING
    end

    function self.destroy()
        self.state = STATES.DESTROYED
    end

    local function toggle()
        if blinkingState == BLINKING_STATES.ON then
            blinkingState = BLINKING_STATES.OFF
        elseif blinkingState == BLINKING_STATES.OFF then
            blinkingState = BLINKING_STATES.ON
        end
    end

    function self.update(dt)
        if self.state == STATES.BLINKING then
            timeInBlinkingState = timeInBlinkingState + dt
            if timeInBlinkingState > BLINKING_TIME then
                toggle()
                timeInBlinkingState = 0
            end
        end
    end

    function self.draw(dt)
        if self.state == STATES.ACTIVE or (self.state == STATES.BLINKING and blinkingState == BLINKING_STATES.ON) then
            love.graphics.setColor(self.color)
            love.graphics.rectangle("fill", self.x, self.y, 10, 10)
        end
    end

    return self

end
