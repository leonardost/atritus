local GAME_STATES = {
    TITLE = 1,
    GAME = 2,
    GAMEOVER = 3
}

function Game()

    local self = {}

    local state = GAME_STATES.TITLE
    local shouldDrawPress = true
    local timeSinceLastDrawPressChange = 0
    local keyDelay = 0
    local keyDelayThreshold = 0.3
    local secondaryKeyDelayThreshould = 0.02

    local level = 1
    local points = 0
    local totalLinesCleared = 0

    local bottle = Bottle()
    local currentPiece = {}
    local nextPiece = {}
    if CONFIG.debug then
        currentPiece = Piece(CONFIG.nextPiece, 1, CONFIG.startingX, CONFIG.startingY, bottle.getBottle())
        nextPiece = Piece(CONFIG.nextPiece, 1, CONFIG.startingX, CONFIG.startingY, bottle.getBottle())
    else
        currentPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
        nextPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
    end
    local shadowPiece = currentPiece.copy()
    shadowPiece.setShadow()

    local function updateShadow()
        shadowPiece = currentPiece.copy()
        shadowPiece.setShadow()
        shadowPiece.drop()
    end

    local function updatePointsAndLevel(clearedLines)
        if #clearedLines > 0 then
            points = points + CONFIG.tableOfPoints[#clearedLines]
            totalLinesCleared = totalLinesCleared + #clearedLines
            if totalLinesCleared >= CONFIG.linesClearedToPassLevels[level] and level < #CONFIG.linesClearedToPassLevels then
                level = level + 1
            end
        end
    end

    function consolidatePieceAndDoEverythingElse()
        local clearedLines = bottle.update()
        updatePointsAndLevel(clearedLines)
        throwNextPiece()
        if currentPiece.isConflicting() then
            currentPiece.consolidate()
            -- show game over animation
            state = GAME_STATES.GAMEOVER
        end
    end

    function throwNextPiece()
        currentPiece = nextPiece.copy()
        if CONFIG.debug then
            nextPiece = Piece(CONFIG.nextPiece, 1, CONFIG.startingX, CONFIG.startingY, bottle.getBottle())
        else
            nextPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
        end
    end

    local function keyDelayPassed(dt)
        if keyDelay > 0 then
            keyDelay = keyDelay - dt
        end
        return keyDelay <= 0
    end

    function self.update(dt)
        if state == GAME_STATES.TITLE then
            timeSinceLastDrawPressChange = timeSinceLastDrawPressChange + dt
            if timeSinceLastDrawPressChange > 0.5 then
                shouldDrawPress = not shouldDrawPress
                timeSinceLastDrawPressChange = 0
            end
        elseif state == GAME_STATES.GAME then
            if love.keyboard.isDown("left") and currentPiece.canMoveLeft() and keyDelayPassed(dt) then
                currentPiece.moveLeft()
                keyDelay = secondaryKeyDelayThreshould
            elseif love.keyboard.isDown("right") and currentPiece.canMoveRight() and keyDelayPassed(dt) then
                currentPiece.moveRight()
                keyDelay = secondaryKeyDelayThreshould
            elseif love.keyboard.isDown("down") and keyDelayPassed(dt) then
                if currentPiece.canFallFurther() then
                    currentPiece.fall()
                    keyDelay = secondaryKeyDelayThreshould
                else
                    currentPiece.consolidate()
                    consolidatePieceAndDoEverythingElse()
                end
            end

            if currentPiece.update(dt, level) == 1 then
                consolidatePieceAndDoEverythingElse()
            end
            updateShadow()
        elseif state == GAME_STATES.GAMEOVERGAMEOVER then

        end
    end

    local function startKeyDelay()
        -- delay after which a key kept being pressed has its input processed continuously
        keyDelay = keyDelayThreshold
    end

    function self.keyPressed(key)

        if state == GAME_STATES.TITLE then
            state = GAME_STATES.GAME
            return
        end

        if key == "left" and currentPiece.canMoveLeft() then
            currentPiece.moveLeft()
            startKeyDelay()
        elseif key == "right" and currentPiece.canMoveRight() then
            currentPiece.moveRight()
            startKeyDelay()
        elseif key == "down" then
            if currentPiece.canFallFurther() then
                currentPiece.fall()
                startKeyDelay()
            else
                currentPiece.consolidate()
                consolidatePieceAndDoEverythingElse()
            end
        elseif key == "up" then
            currentPiece.drop()
            consolidatePieceAndDoEverythingElse()
        elseif key == "z" then
            if currentPiece.canRotateCounterclockwise() then
                currentPiece.rotateCounterclockwise()
            else
                local offsetl, offsetr = currentPiece.canRotateCounterclockwiseWithLeniency()
                if offsetl > 0 then
                    currentPiece.rotateCounterclockwise()
                    for i = 1, offsetl do
                        currentPiece.moveLeft()
                    end
                elseif offsetr > 0 then
                    currentPiece.rotateCounterclockwise()
                    for i = 1, offsetr do
                        currentPiece.moveRight()
                    end
                end
            end
        elseif key == "x" then
            if currentPiece.canRotateClockwise() then
                currentPiece.rotateClockwise()
            else
                local offsetl, offsetr = currentPiece.canRotateClockwiseWithLeniency()
                if offsetl > 0 then
                    currentPiece.rotateClockwise()
                    for i = 1, offsetl do
                        currentPiece.moveLeft()
                    end
                elseif offsetr > 0 then
                    currentPiece.rotateClockwise()
                    for i = 1, offsetr do
                        currentPiece.moveRight()
                    end
                end
            end
        end
    end

    local function drawTitle()
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("line", 130, 30, 60, 30)
        love.graphics.printf("ATRITUS", 0, 40, 320, "center")
        if shouldDrawPress then
            love.graphics.printf("Press any key to start", 0, 110, 320, "center")
        end
        love.graphics.printf(CONFIG.VERSION, 0, 190, 320, "center")
    end

    local function drawHud()
        nextPiece.draw(110, 45)
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("line", 140, 30, 60, 50)
        love.graphics.print("Next", 140, 10)
        love.graphics.print("Level " .. level, 140, 105)
        love.graphics.print("Points: " .. points, 140, 120)
        love.graphics.print("Lines cleared: " .. totalLinesCleared, 140, 135)
    end

    function self.draw()
        if state == GAME_STATES.TITLE then
            drawTitle()
        elseif state == GAME_STATES.GAME then
            drawHud()
            bottle.draw()
            shadowPiece.draw(10, 10)
            currentPiece.draw(10, 10)
        elseif state == GAME_STATES.GAMEOVER then
            love.graphics.setColor(255, 255, 255)
            love.graphics.printf("GAME OVER", 0, 100, 320, "center")
            love.graphics.printf("HIGH SCORE", 0, 140, 320, "center")
            love.graphics.printf(points, 0, 160, 320, "center")
        end
    end

    return self

end
