local pieces = require('pieces')

function Piece(type, rotation, x, y, bottle)

    local self = {}
    local type = type
    local rotation = rotation
    local position = {
        x = x,
        y = y
    }
    local bottle = bottle
    local isShadow = false

    function self.setShadow()
        isShadow = true
    end

    function self.moveLeft()
        position.x = position.x - 1
    end

    function self.moveRight()
        position.x = position.x + 1
    end

    function self.fall()
        position.y = position.y + 1
    end

    function self.rise()
        position.y = position.y - 1
    end

    function self.drop()
        while self.canFallFurther() do
            self.fall()
        end
    end

    function self.copy()
        return Piece(type, rotation, position.x, position.y, bottle)
    end

    function self.rotateCounterclockwise()
        rotation = rotation - 1
        if rotation == 0 then
            rotation = 4
        end
    end

    function self.rotateClockwise()
        rotation = rotation + 1
        if rotation == 5 then
            rotation = 1
        end
    end

    local function isConflicting()
        for i = 0, 3 do
            for j = 0, 3 do
                local x = position.x + j + 1
                local y = position.y + i + 1
                if pieces[type].blocks[rotation][i * 4 + j + 1] == 1 then
                    if x < 1 or x > CONFIG.BOTTLE_WIDTH or y > CONFIG.BOTTLE_HEIGHT then -- out of bounds
                        return true
                    end
                    if bottle[y][x] ~= 0 then -- bumped on other blocks
                        return true
                    end
                end
            end
        end
        return false
    end

    function self.canMoveLeft()
        self.moveLeft()
        canMove = not isConflicting()
        self.moveRight()
        return canMove
    end

    function self.canMoveRight()
        self.moveRight()
        canMove = not isConflicting()
        self.moveLeft()
        return canMove
    end

    function self.canFallFurther(piece)
        self.fall()
        canMove = not isConflicting()
        self.rise()
        return canMove
    end

    function self.canRotateCounterclockwise()
        self.rotateCounterclockwise()
        canMove = not isConflicting()
        self.rotateClockwise()
        return canMove
    end

    function self.canRotateClockwise()
        self.rotateClockwise()
        canMove = not isConflicting()
        self.rotateCounterclockwise()
        return canMove
    end

    function self.consolidate()
        for i = 0, 3 do
            for j = 0, 3 do
                if pieces[type].blocks[rotation][i * 4 + j + 1] == 1 then
                    bottle[position.y + i + 1][position.x + j + 1] = 1
                end
            end
        end
    end

    function self.draw(screenx, screeny)
        local color = pieces[type].color
        if not isShadow then
            love.graphics.setColor(color[1], color[2], color[3])
        else
            love.graphics.setColor(80, 80, 80)
        end
        for i = 0, 3 do
            for j = 0, 3 do
                local x = (position.x + j) * 10
                local y = (position.y + i) * 10
                if pieces[type].blocks[rotation][i * 4 + j + 1] == 1 then
                    love.graphics.rectangle("line", 10 + x, 10 + y, 10, 10)
                end
            end
        end
    end

    return self

end
