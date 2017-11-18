function GameOverState()

    local self = State()

    local points = 0

    function self.setPoints(p)
        points = p
    end

    function self.draw()
        love.graphics.setColor(255, 255, 255)
        love.graphics.printf("GAME OVER", 0, 100, 320, "center")
        love.graphics.printf("HIGH SCORE", 0, 140, 320, "center")
        love.graphics.printf(points, 0, 160, 320, "center")
    end

    return self

end
