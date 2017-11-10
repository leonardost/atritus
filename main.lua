--[[
    Features to implement:
    - Improve visuals
      - Show next piece that's going to fall
      - Line clearing effect
      - Backgrounds
      - Music and SFX
    - Improve gameplay
      - When rotating, give pieces some leniency to accomodate themselves
      - Create title screen
      - Create options screen
        - BGM volume, SFX volume
        - Toggle shadow piece on/off
    - Improve code
      - Organize code in objects
--]]

require('src/Config')
require('src/Game')
require('src/Bottle')
require('src/Piece')

bottle = Bottle()

level = 1
points = 0
totalLinesCleared = 0
timeSinceLastDrop = 0

gameStates = {
    TITLE = 1,
    GAME = 2,
    GAMEOVER = 3
}
gameState = gameStates.GAME
keyDelay = 0
keyDelayThreshold = 0.3
secondaryKeyDelayThreshould = 0.02
nextPiece = math.random(1, 7)

local currentPiece = Piece(math.random(1, 7), 1, 4, 0, bottle.getBottle())
local shadowPiece = currentPiece.copy()
shadowPiece.setShadow()

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Atritus")
    love.window.setMode(320, 240, { centered = true })
end

function love.update(dt)

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

end

function keyDelayPassed(dt)
    if keyDelay > 0 then
        keyDelay = keyDelay - dt
    end
    return keyDelay <= 0
end

function updateCurrentPiece(dt)
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

function updateShadow()
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
    --~ if isPieceConflicting(currentPiece) then
        --~ currentPiece.consolidate()
        --~ -- show game over animation
        --~ gameState = gameStates.GAMEOVER
    --~ end
end

function throwNextPiece()
    currentPiece = Piece(nextPiece, 1, 4, 0, bottle.getBottle())
    nextPiece = math.random(1, 7)
end

function startKeyDelay()
    -- delay after which a key kept being pressed has its input processed continuously
    keyDelay = keyDelayThreshold
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    elseif key == "left" and currentPiece.canMoveLeft() then
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

function love.draw(dt)
    if gameState == gameStates.GAME then
        drawHud()
        bottle.draw()
        shadowPiece.draw()
        currentPiece.draw()
    elseif gameState == gameStates.GAMEOVER then
        love.graphics.print("GAME OVER", 120, 110)
        love.graphics.print("HIGH SCORE", 110, 150)
        love.graphics.print(points, 140, 170)
    end
end

function drawHud()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Level " .. level, 180, 10)
    love.graphics.print("Next: " .. nextPiece, 180, 25)
    love.graphics.print("Points: " .. points, 180, 40)
    love.graphics.print("Lines cleared: " .. totalLinesCleared, 180, 55)
end
