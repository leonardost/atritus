local StateManager = require('src/states/StateManager')
local SoundManager = require('src/SoundManager')

function GameState()

    local self = State()

    local level = 1
    local points = 0
    local totalLinesCleared = 0

    local bottle = Bottle()
    local currentPiece = {}
    local nextPiece = {}
    local holdPiece = {}
    local heldPiece = false
    local isHoldEmpty = true
    if CONFIG.debug then
        currentPiece = Piece(CONFIG.nextPiece, 1, CONFIG.startingX, CONFIG.startingY, bottle.getBottle())
        nextPiece = Piece(CONFIG.nextPiece, 1, CONFIG.startingX, CONFIG.startingY, bottle.getBottle())
    else
        currentPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
        nextPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
    end
    local shadowPiece = currentPiece.copy()
    shadowPiece.setShadow()

    local keyDelay = 0
    local keyDelayThreshold = 0.3
    local secondaryKeyDelayThreshould = 0.02

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
        local clearedLines = bottle.getClearedLines()

        if #clearedLines > 0 then
            updatePointsAndLevel(clearedLines)
            bottle.setClearingLines()
            SoundManager.play("LINE_CLEAR")
        else
            bottle.setThrowNextPiece()
        end

        heldPiece = false
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

        bottle.update(dt)

        if bottle.isActive() then
            
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

        elseif bottle.isThrowNextPiece() then
            throwNextPiece()
            if currentPiece.isConflicting() then
                currentPiece.consolidate()
                -- show game over animation
                local gameOverState = GameOverState()
                gameOverState.setPoints(points)
                StateManager.switch(gameOverState)
            end
            bottle.setActive()
        end
    end

    local function drawHud()
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Next", 140, 10)
        love.graphics.print("Hold", 140, 90)
        love.graphics.print("Level " .. level, 140, 170)
        love.graphics.print("Points: " .. points, 140, 185)
        love.graphics.print("Lines cleared: " .. totalLinesCleared, 140, 200)

        love.graphics.rectangle("line", 140, 30, 60, 50)
        love.graphics.rectangle("line", 140, 110, 60, 50)
        love.graphics.setColor(0, 0, 0, 215)
        love.graphics.rectangle("fill", 141, 31, 58, 48)
        love.graphics.rectangle("fill", 141, 111, 58, 48)

        nextPiece.draw(110, 45)
        if not isHoldEmpty then
            holdPiece.draw(110, 125)
        end
    end

    function self.draw()
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(scenario1, 0, 0)
        drawHud()
        bottle.draw()
        if bottle.isActive() then
            if CONFIG.showShadow then
                shadowPiece.draw(10, 10)
            end
            currentPiece.draw(10, 10)
        end
    end

    local function startKeyDelay()
        -- delay after which a key kept being pressed has its input processed continuously
        keyDelay = keyDelayThreshold
    end

    function self.keyPressed(key)

        if bottle.isActive() then

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
            elseif key == "c" and not heldPiece then -- hold
                if isHoldEmpty then
                    holdPiece = currentPiece.hold()
                    throwNextPiece()
                    isHoldEmpty = false
                else
                    local tempPiece = holdPiece
                    holdPiece = currentPiece.hold()
                    currentPiece = tempPiece
                end
                heldPiece = true
            elseif key == "s" then
                CONFIG.showShadow = not CONFIG.showShadow
            elseif key == "p" then
                bottle.pause()
            end

        elseif bottle.isPaused() and key == "p" then
            bottle.pause()
        end

    end

    return self

end
