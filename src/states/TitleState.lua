function TitleState()

    local self = State()

    local shouldDrawPress = true
    local timeSinceLastDrawPressChange = 0

    function self.update(dt)
        timeSinceLastDrawPressChange = timeSinceLastDrawPressChange + dt
        if timeSinceLastDrawPressChange > 0.5 then
            shouldDrawPress = not shouldDrawPress
            timeSinceLastDrawPressChange = 0
        end
    end

    function self.draw()
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(logoImage, 14, 30)
        if shouldDrawPress then
            love.graphics.printf("Press any key to start", 0, 110, 320, "center")
        end
        love.graphics.printf(CONFIG.VERSION, 0, 190, 320, "center")
        love.graphics.printf("(c) 2017 - LST Soft", 0, 210, 320, "center")
    end

    function self.keyPressed(key)
        if key ~= nil then
            StateManager.switch(GameState())
        end
    end

    return self

end
