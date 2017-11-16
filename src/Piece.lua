local pieces = require('src/pieces')

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
    local timeSinceLastDrop = 0

    function self.setX(x)
        position.x = x
    end

    function self.setY(y)
        position.y = y
    end

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
        timeSinceLastDrop = 0
    end

    function self.drop()
        while self.canFallFurther() do
            self.fall()
        end
        if not isShadow then
            self.consolidate()
            timeSinceLastDrop = 0
        end
    end

    function self.copy()
        return Piece(type, rotation, position.x, position.y, bottle)
    end

    -- puts this piece on hold, resetting its position
    function self.hold()
        return Piece(type, 1, 4, 0, bottle)
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

    function self.isConflicting()
        for i = 0, 3 do
            for j = 0, 3 do
                local x = position.x + j + 1
                local y = position.y + i + 1
                if pieces[type].blocks[rotation][i * 4 + j + 1] == 1 then
                    if x < 1 or x > CONFIG.BOTTLE_WIDTH or y > CONFIG.BOTTLE_HEIGHT then -- out of bounds
                        return true
                    end
                    if bottle[y][x].isActive() then -- bumped on other blocks
                        return true
                    end
                end
            end
        end
        return false
    end

    function self.canMoveLeft()
        local newPiece = self.copy()
        newPiece.moveLeft()
        return not newPiece.isConflicting()
    end

    function self.canMoveRight()
        local newPiece = self.copy()
        newPiece.moveRight()
        return not newPiece.isConflicting()
    end

    function self.canFallFurther(piece)
        local newPiece = self.copy()
        newPiece.fall()
        return not newPiece.isConflicting()
    end

    function self.canRotateCounterclockwise()
        local newPiece = self.copy()
        newPiece.rotateCounterclockwise()
        return not newPiece.isConflicting()
    end

    function self.canRotateCounterclockwiseWithLeniency()
        for i = 1, 3 do
            local newPiece = self.copy()
            newPiece.rotateCounterclockwise()
            for j = 1, i do
                newPiece.moveLeft()
            end
            if not newPiece.isConflicting() then
                return i, 0
            end
        end
        for i = 1, 3 do
            local newPiece = self.copy()
            newPiece.rotateCounterclockwise()
            for j = 1, i do
                newPiece.moveRight()
            end
            if not newPiece.isConflicting() then
                return 0, i
            end
        end
        return 0, 0
    end

    function self.canRotateClockwise()
        local newPiece = self.copy()
        newPiece.rotateClockwise()
        return not newPiece.isConflicting()
    end

    function self.canRotateClockwiseWithLeniency()
        for i = 1, 3 do
            local newPiece = self.copy()
            newPiece.rotateClockwise()
            for j = 1, i do
                newPiece.moveLeft()
            end
            if not newPiece.isConflicting() then
                return i, 0
            end
        end
        for i = 1, 3 do
            local newPiece = self.copy()
            newPiece.rotateClockwise()
            for j = 1, i do
                newPiece.moveRight()
            end
            if not newPiece.isConflicting() then
                return 0, i
            end
        end
        return 0, 0
    end

    function self.consolidate()
        for i = 0, 3 do
            for j = 0, 3 do
                if pieces[type].blocks[rotation][i * 4 + j + 1] == 1 then
                    bottle[position.y + i + 1][position.x + j + 1] =
                        Block(10 + (position.x + j) * 10,
                              10 + (position.y + i) * 10,
                              pieces[type].color, 1)
                end
            end
        end
    end

    function self.update(dt, level)
        timeSinceLastDrop = timeSinceLastDrop + dt

        if timeSinceLastDrop >= CONFIG.velocityOfLevels[level] then
            if self.canFallFurther() then
                self.fall()
            else
                self.consolidate()
                return 1 -- means the piece was consolidated
            end
        end

        return 0
    end

    function self.draw(screenx, screeny)
        local color = pieces[type].color
        if not isShadow then
            love.graphics.setColor(color)
        else
            love.graphics.setColor(80, 80, 80)
        end
        for i = 0, 3 do
            for j = 0, 3 do
                local x = (position.x + j) * 10
                local y = (position.y + i) * 10
                if pieces[type].blocks[rotation][i * 4 + j + 1] == 1 then
                    love.graphics.rectangle("line", screenx + x, screeny + y, 10, 10)
                end
            end
        end
    end

    return self

end
