local GAME_STATES = {
    TITLE = 1,
    GAME = 2,
    GAMEOVER = 3
}

function Game()

    local self = {}

    local state = GAME_STATES.TITLE
    local keyDelay = 0
    local keyDelayThreshold = 0.3
    local secondaryKeyDelayThreshould = 0.02

    local level = 1
    local points = 0
    local totalLinesCleared = 0
    local timeSinceLastDrop = 0

    local bottle = Bottle()
    local currentPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
    local nextPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
    local shadowPiece = currentPiece.copy()
    shadowPiece.setShadow()

    local function updateCurrentPiece(dt)
        timeSinceLastDrop = timeSinceLastDrop + dt

        if timeSinceLastDrop >= CONFIG.velocityOfLevels[level] then
            if currentPiece.canFallFurther() then
                currentPiece.fall()
            else
                consolidatePieceAndDoEverythingElse()
            end
            timeSinceLastDrop = 0
        end
    end

    local function updateShadow()
        shadowPiece = currentPiece.copy()
        shadowPiece.setShadow()
        shadowPiece.drop()
    end

    function consolidatePieceAndDoEverythingElse()
        currentPiece.consolidate()
        local clearedLines = bottle.getClearedLines()
        if #clearedLines > 0 then
            points = points + CONFIG.tableOfPoints[#clearedLines]
            totalLinesCleared = totalLinesCleared + #clearedLines
            if totalLinesCleared >= CONFIG.linesClearedToPassLevels[level] then
                level = level + 1
            end
            bottle.removeCompletedLines()
        end
        throwNextPiece()
        if currentPiece.isConflicting() then
            currentPiece.consolidate()
            -- show game over animation
            state = GAME_STATES.GAMEOVER
        end
    end

    function throwNextPiece()
        currentPiece = nextPiece.copy()
        nextPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
    end

    local function keyDelayPassed(dt)
        if keyDelay > 0 then
            keyDelay = keyDelay - dt
        end
        return keyDelay <= 0
    end

    function self.update(dt)
        if state == GAME_STATES.GAME then
            if love.keyboard.isDown("left") and currentPiece.canMoveLeft() and keyDelayPassed(dt) then
                currentPiece.moveLeft()
                keyDelay = secondaryKeyDelayThreshould
            elseif love.keyboard.isDown("right") and currentPiece.canMoveRight() and keyDelayPassed(dt) then
                currentPiece.moveRight()
                keyDelay = secondaryKeyDelayThreshould
            elseif love.keyboard.isDown("down") and keyDelayPassed(dt) then
                if currentPiece.canFallFurther() then
                    currentPiece.fall()
                    timeSinceLastDrop = 0
                    keyDelay = secondaryKeyDelayThreshould
                else
                    consolidatePieceAndDoEverythingElse()
                end
            end

            updateCurrentPiece(dt)
            updateShadow()
        elseif state == GAME_STATES.GAMEOVER then

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
                timeSinceLastDrop = 0
                startKeyDelay()
            else
                consolidatePieceAndDoEverythingElse()
            end
        elseif key == "up" then
            currentPiece.drop()
            consolidatePieceAndDoEverythingElse()
        elseif key == "z" and currentPiece.canRotateCounterclockwise() then
            currentPiece.rotateCounterclockwise()
        elseif key == "x" and currentPiece.canRotateClockwise() then
            currentPiece.rotateClockwise()
        end
    end

    local function drawTitle()
        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle("line", 100, 30, 150, 30)
        love.graphics.print("ATRITUS", 140, 40)
        love.graphics.print(CONFIG.VERSION, 160, 190)
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
            love.graphics.print("GAME OVER", 125, 100)
            love.graphics.print("HIGH SCORE", 120, 140)
            love.graphics.print(points, 160, 160)
        end
    end

    return self

end
