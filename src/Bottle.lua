function Bottle()

    local self = {}
    local bottle = {}

    for i = 1, CONFIG.BOTTLE_HEIGHT do
        bottle[i] = {}
        for j = 1, CONFIG.BOTTLE_WIDTH do
            bottle[i][j] = 0
        end
    end

    function self.getBottle()
        return bottle
    end

    local function isCompleteLine(line)
        for i = 1, CONFIG.BOTTLE_WIDTH do
            if bottle[line][i] == 0 then
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
                bottle[i][j] = bottle[i - 1][j]
            end
        end
        for j = 1, CONFIG.BOTTLE_WIDTH do
            bottle[1][j] = 0
        end
    end

    local function reorganizeLines(clearedLines)
        -- the line offset compensates the lines that fall down
        lineOffset = 0
        for i = #clearedLines, 1, -1 do
            dropLine(clearedLines[i] + lineOffset)
            lineOffset = lineOffset + 1
        end
    end

    function self.removeCompletedLines()
        clearedLines = self.getClearedLines()
        reorganizeLines(clearedLines)
    end

    local function drawBottle()
        x = 10 - 1
        y = 10 - 1
        w = CONFIG.BOTTLE_WIDTH * 10 + 2
        h = CONFIG.BOTTLE_HEIGHT * 10 + 2
        love.graphics.rectangle("line", x, y, w, h)
    end

    local function drawBlocks()
        love.graphics.setColor(255, 255, 255)
        for i = 0, CONFIG.BOTTLE_HEIGHT - 1 do
            for j = 0, CONFIG.BOTTLE_WIDTH - 1 do
                local x = 10 + j * 10
                local y = 10 + i * 10
                if bottle[i + 1][j + 1] ~= 0 then
                    love.graphics.rectangle("fill", x, y, 10, 10)
                end
            end
        end
        love.graphics.setColor(255, 255, 255)
    end

    function self.draw()
        drawBottle()
        drawBlocks()
    end

    return self

end
