function Bottle()

    local STATES = {
        ACTIVE = 1,
        CLEARING_LINES = 2,
        THROW_NEXT_PIECE = 3,
        PAUSE = 4
    }
    local BLINKING_STATE_TIME = 0.8

    local self = {}
    local bottle = {}
    local state = STATES.ACTIVE
    local timeInLineClearingState = 0
    local clearedLines = {}

    for i = 1, CONFIG.BOTTLE_HEIGHT do
        bottle[i] = {}
        for j = 1, CONFIG.BOTTLE_WIDTH do
            bottle[i][j] = Block(10 + j * 10, 10 + i * 10, 1, 3)
        end
    end

    function self.getBottle()
        return bottle
    end

    function self.setActive()
        state = STATES.ACTIVE
    end

    function self.isActive()
        return state == STATES.ACTIVE
    end

    function self.setClearingLines()
        state = STATES.CLEARING_LINES
        timeInLineClearingState = 0

        clearedLines = self.getClearedLines()
        if #clearedLines > 0 then
            for i = 1, #clearedLines do
                for j = 1, CONFIG.BOTTLE_WIDTH do
                    bottle[clearedLines[i]][j].enterBlinkingState()
                end
            end
        end
    end

    function self.isClearingLines()
        return state == STATES.CLEARING_LINES
    end

    function self.setThrowNextPiece()
        state = STATES.THROW_NEXT_PIECE
    end

    function self.isThrowNextPiece()
        return state == STATES.THROW_NEXT_PIECE
    end

    function self.isPaused()
        return state == STATES.PAUSE
    end

    function self.pause()
        if state == STATES.ACTIVE then
            state = STATES.PAUSE
        elseif state == STATES.PAUSE then
            state = STATES.ACTIVE
        end
    end

    local function isCompleteLine(line)
        for i = 1, CONFIG.BOTTLE_WIDTH do
            if not bottle[line][i].isActive() then
                return false
            end
        end
        return true
    end

    function self.getClearedLines()
        clearedLines = {}
        for i = 1, CONFIG.BOTTLE_HEIGHT do
            if isCompleteLine(i) then
                table.insert(clearedLines, i)
            end
        end
        return clearedLines;
    end

    local function dropLine(line)
        for i = line, 2, -1 do
            for j = 1, CONFIG.BOTTLE_WIDTH do
                bottle[i][j] = bottle[i - 1][j].copy()
                bottle[i][j].set(10 + (j - 1) * 10, 10 + (i - 1) * 10)
            end
        end
    end

    local function removeCompletedLines()
        -- the line offset compensates the lines that fall down
        local lineOffset = 0
        for i = #clearedLines, 1, -1 do
            dropLine(clearedLines[i] + lineOffset)
            lineOffset = lineOffset + 1
        end
        for j = 1, CONFIG.BOTTLE_WIDTH do
            bottle[1][j].destroy()
        end
    end

    function self.update(dt)

        if state == STATES.PAUSE then
            return
        end

        for i = 1, CONFIG.BOTTLE_HEIGHT do
            for j = 1, CONFIG.BOTTLE_WIDTH do
                bottle[i][j].update(dt)
            end
        end

        if state == STATES.CLEARING_LINES then
            timeInLineClearingState = timeInLineClearingState + dt
            if timeInLineClearingState >= BLINKING_STATE_TIME then
                removeCompletedLines()
                state = STATES.THROW_NEXT_PIECE
            end
        end
    end

    local function drawBottle()
        x = 10 - 1
        y = 10 - 1
        w = CONFIG.BOTTLE_WIDTH * 10 + 2
        h = CONFIG.BOTTLE_HEIGHT * 10 + 2
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("line", x, y, w, h)
        love.graphics.setColor(0, 0, 0, 215)
        love.graphics.rectangle("fill", x + 1, y + 1, w - 2, h - 2)
    end

    local function drawBlocks()
        for i = 1, CONFIG.BOTTLE_HEIGHT do
            for j = 1, CONFIG.BOTTLE_WIDTH do
                bottle[i][j].draw()
            end
        end
    end

    function self.draw()
        drawBottle()
        if state ~= STATES.PAUSE then
            drawBlocks()
        else
            love.graphics.setColor(255, 255, 255)
            love.graphics.printf("PAUSED", 10, 110, 100, "center")
        end
    end

    return self

end
