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

bottle = {}
pieces = {}
points = 0
tableOfPoints = { 10, 25, 75, 200 }
linesClearedToPassLevels = { 10, 20, 30, 40, 50 }
velocityOfLevels = { 1, 0.5, 0.3, 0.1, 0.07 }
totalLinesCleared = 0
level = 1

gameStates = {
    TITLE = 1,
    GAME = 2,
    GAMEOVER = 3
}
gameState = gameStates.GAME
keyDelay = 0
keyDelayThreshold = 0.3
secondaryKeyDelayThreshould = 0.02

currentPiece = {
    type = math.random(1, 7),
    position = {
        x = 4,
        y = 0
    },
    rotation = 1
}

shadowPiece = {
    type = currentPiece.type,
    position = {
        x = currentPiece.position.x,
        y = currentPiece.position.y
    },
    rotation = currentPiece.rotation
}

nextPiece = math.random(1, 7)

function init()
    math.randomseed(os.time())

    for i = 1, 20 do
        bottle[i] = {}
        for j = 1, 10 do
            bottle[i][j] = 0
        end
    end

    -- I
    pieces[1] = {
        color = { 0, 0, 255 },
        blocks = {
            { 1, 1, 1, 1,
              0, 0, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 0, 0, 0,
              1, 0, 0, 0,
              1, 0, 0, 0,
              1, 0, 0, 0 },
            { 1, 1, 1, 1,
              0, 0, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 0, 0, 0,
              1, 0, 0, 0,
              1, 0, 0, 0,
              1, 0, 0, 0 }
        }
    }
    -- Z
    pieces[2] = {
        color = { 255, 0, 0 },
        blocks = {
            { 1, 1, 0, 0,
              0, 1, 1, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 0, 1, 0, 0,
              1, 1, 0, 0,
              1, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 1, 0, 0,
              0, 1, 1, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 0, 1, 0, 0,
              1, 1, 0, 0,
              1, 0, 0, 0,
              0, 0, 0, 0 }
        }
    }
    -- S
    pieces[3] = {
        color = { 0, 255, 0 },
        blocks = {
            { 0, 1, 1, 0,
              1, 1, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 0, 0, 0,
              1, 1, 0, 0,
              0, 1, 0, 0,
              0, 0, 0, 0 },
            { 0, 1, 1, 0,
              1, 1, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 0, 0, 0,
              1, 1, 0, 0,
              0, 1, 0, 0,
              0, 0, 0, 0 }
        }
    }
    -- L invertido
    pieces[4] = {
        color = { 255, 255, 0 },
        blocks = {
            { 1, 0, 0, 0,
              1, 1, 1, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 1, 0, 0,
              1, 0, 0, 0,
              1, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 1, 1, 0,
              0, 0, 1, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 0, 1, 0, 0,
              0, 1, 0, 0,
              1, 1, 0, 0,
              0, 0, 0, 0 }
        }
    }
    -- L
    pieces[5] = {
        color = { 0, 255, 255 },
        blocks = {
            { 0, 0, 1, 0,
              1, 1, 1, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 0, 0, 0,
              1, 0, 0, 0,
              1, 1, 0, 0,
              0, 0, 0, 0 },
            { 1, 1, 1, 0,
              1, 0, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 1, 0, 0,
              0, 1, 0, 0,
              0, 1, 0, 0,
              0, 0, 0, 0 }
        }
    }
    -- T
    pieces[6] = {
        color = { 255, 0, 255 },
        blocks = {
            { 0, 1, 0, 0,
              1, 1, 1, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 0, 1, 0, 0,
              0, 1, 1, 0,
              0, 1, 0, 0,
              0, 0, 0, 0 },
            { 0, 0, 0, 0,
              1, 1, 1, 0,
              0, 1, 0, 0,
              0, 0, 0, 0 },
            { 0, 1, 0, 0,
              1, 1, 0, 0,
              0, 1, 0, 0,
              0, 0, 0, 0 }
        }
    }
    -- O
    pieces[7] = {
        color = { 255, 255, 255 },
        blocks = {
            { 1, 1, 0, 0,
              1, 1, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 1, 0, 0,
              1, 1, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 1, 0, 0,
              1, 1, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 },
            { 1, 1, 0, 0,
              1, 1, 0, 0,
              0, 0, 0, 0,
              0, 0, 0, 0 }
        }
    }

end

init()

function love.load()
    love.window.setTitle("Atritus")
    success = love.window.setMode(320, 240, { centered = true })
    timeSinceLastDrop = 0
end

function keyDelayPassed(dt)
    if keyDelay > 0 then
        keyDelay = keyDelay - dt
    end
    return keyDelay <= 0
end

function love.update(dt)

    if love.keyboard.isDown("left") and canMoveLeft() and keyDelayPassed(dt) then
        currentPiece.position.x = currentPiece.position.x - 1
        keyDelay = secondaryKeyDelayThreshould
    elseif love.keyboard.isDown("right") and canMoveRight() and keyDelayPassed(dt) then
        currentPiece.position.x = currentPiece.position.x + 1
        keyDelay = secondaryKeyDelayThreshould
    elseif love.keyboard.isDown("down") and keyDelayPassed(dt) then
        if canFallFurther(currentPiece) then
            currentPiece.position.y = currentPiece.position.y + 1
            timeSinceLastDrop = 0
            keyDelay = secondaryKeyDelayThreshould
        else
            consolidatePieceAndDoEverythingElse()
        end
    end

    timeSinceLastDrop = timeSinceLastDrop + dt

    if timeSinceLastDrop >= velocityOfLevels[level] then
        if canFallFurther(currentPiece) then
            currentPiece.position.y = currentPiece.position.y + 1
        else
            consolidatePieceAndDoEverythingElse()
        end
        timeSinceLastDrop = 0
    end

    updateShadow()

end

function updateShadow()
    shadowPiece = {
        type = currentPiece.type,
        position = {
            x = currentPiece.position.x,
            y = currentPiece.position.y
        },
        rotation = currentPiece.rotation
    }
    while canFallFurther(shadowPiece) do
        shadowPiece.position.y = shadowPiece.position.y + 1
    end
end

function consolidatePieceAndDoEverythingElse()
    consolidatePiece(currentPiece)
    removeCompletedLinesAndAddPoints()
    throwNextPiece()
    if isPieceConflicting(currentPiece) then
        consolidatePiece(currentPiece)
        -- show game over animation
        gameState = gameStates.GAMEOVER
    end
end

function removeCompletedLinesAndAddPoints()
    clearedLines = {}
    for i = 1, 20 do
        if isCompleteLine(i) then
            removeLine(i)
            table.insert(clearedLines, i)
        end
    end
    totalLinesCleared = totalLinesCleared + #clearedLines
    if totalLinesCleared >= linesClearedToPassLevels[level] then
        level = level + 1
    end
    if #clearedLines > 0 then
        points = points + tableOfPoints[#clearedLines]
        reorganizeLines(clearedLines)
    end
end

function isCompleteLine(line)
    for i = 1, 10 do
        if bottle[line][i] == 0 then
            return false
        end
    end
    return true
end

function removeLine(line)
    for i = 1, 10 do
        bottle[line][i] = 0
    end
end

function reorganizeLines(clearedLines)
    -- the line offset compensates the lines that fall down
    lineOffset = 0
    for i = #clearedLines, 1, -1 do
        dropLine(clearedLines[i] + lineOffset)
        lineOffset = lineOffset + 1
    end
end

function dropLine(line)
    for i = line, 2, -1 do
        for j = 1, 10 do
            bottle[i][j] = bottle[i - 1][j]
        end
    end
    for j = 1, 10 do
        bottle[1][j] = 0
    end
end

function throwNextPiece()
    currentPiece.type = nextPiece
    nextPiece = math.random(1, 7)
    currentPiece.position.x = 4
    currentPiece.position.y = 0
end

function startKeyDelay()
    -- delay after which a key kept being pressed has its input processed continuously
    keyDelay = keyDelayThreshold
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    elseif key == "left" and canMoveLeft() then
        currentPiece.position.x = currentPiece.position.x - 1
        startKeyDelay()
    elseif key == "right" and canMoveRight() then
        currentPiece.position.x = currentPiece.position.x + 1
        startKeyDelay()
    elseif key == "down" then
        if canFallFurther(currentPiece) then
            currentPiece.position.y = currentPiece.position.y + 1
            timeSinceLastDrop = 0
            startKeyDelay()
        else
            consolidatePieceAndDoEverythingElse()
        end
    elseif key == "up" then
        -- instant fall
        while canFallFurther(currentPiece) do
            currentPiece.position.y = currentPiece.position.y + 1
        end
        consolidatePieceAndDoEverythingElse()
    elseif key == "z" and canRotateCounterclockwise() then
        rotateCounterclockwise()
    elseif key == "x" and canRotateClockwise() then
        rotateClockwise()
    end
end

function rotateCounterclockwise()
    currentPiece.rotation = currentPiece.rotation - 1
    if currentPiece.rotation == 0 then
        currentPiece.rotation = 4
    end
end

function rotateClockwise()
    currentPiece.rotation = currentPiece.rotation + 1
    if currentPiece.rotation == 5 then
        currentPiece.rotation = 1
    end
end

function canMoveLeft()
    currentPiece.position.x = currentPiece.position.x - 1
    isConflicting = isPieceConflicting(currentPiece)
    currentPiece.position.x = currentPiece.position.x + 1
    return not isConflicting
end

function canMoveRight()
    currentPiece.position.x = currentPiece.position.x + 1
    isConflicting = isPieceConflicting(currentPiece)
    currentPiece.position.x = currentPiece.position.x - 1
    return not isConflicting
end

function canFallFurther(piece)
    piece.position.y = piece.position.y + 1
    isConflicting = isPieceConflicting(piece)
    piece.position.y = piece.position.y - 1
    return not isConflicting
end

function canRotateCounterclockwise()
    rotateCounterclockwise()
    isConflicting = isPieceConflicting(currentPiece)
    rotateClockwise()
    return not isConflicting
end

function canRotateClockwise()
    rotateClockwise()
    isConflicting = isPieceConflicting(currentPiece)
    rotateCounterclockwise()
    return not isConflicting
end

function consolidatePiece(piece)
    local position = piece.position
    for i = 0, 3 do
        for j = 0, 3 do
            if pieces[piece.type].blocks[piece.rotation][i * 4 + j + 1] == 1 then
                bottle[position.y + i + 1][position.x + j + 1] = 1
            end
        end
    end
end

function isPieceConflicting(piece)
    for i = 0, 3 do
        for j = 0, 3 do
            if pieces[piece.type].blocks[piece.rotation][i * 4 + j + 1] == 1 then
                if piece.position.y + i + 1 > 20 or piece.position.x + j + 1 < 1 or piece.position.x + j + 1 > 10 then
                    -- out of bounds
                    return true
                end
                if bottle[piece.position.y + i + 1][piece.position.x + j + 1] == 1 then
                    -- bumped on other blocks
                    return true
                end
            end
        end
    end
    return false
end

function love.draw(dt)
    if gameState == gameStates.GAME then
        drawBottle()
        drawBlocks()
        drawShadow(shadowPiece)
        drawPiece(currentPiece)
    elseif gameState == gameStates.GAMEOVER then
        love.graphics.print("GAME OVER", 120, 110)
        love.graphics.print("HIGH SCORE", 110, 150)
        love.graphics.print(points, 140, 170)
    end
end

function drawBottle()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Level " .. level, 180, 10)
    love.graphics.print("Next: " .. nextPiece, 180, 25)
    love.graphics.print("Points: " .. points, 180, 40)
    love.graphics.print("Lines cleared: " .. totalLinesCleared, 180, 55)
    love.graphics.rectangle("line", 10 - 1, 10 - 1, 100 + 2, 200 + 2)
end

function drawBlocks()
    love.graphics.setColor(255, 255, 255)
    for i = 0, 19 do
        for j = 0, 9 do
            if bottle[i + 1][j + 1] == 1 then
                love.graphics.rectangle("fill", 10 + j * 10, 10 + i * 10, 10, 10)
            end
        end
    end
end

function drawPiece(piece)
    local color = pieces[piece.type].color
    love.graphics.setColor(color[1], color[2], color[3])
    for i = 0, 3 do
        for j = 0, 3 do
            if pieces[piece.type].blocks[piece.rotation][i * 4 + j + 1] == 1 then
                local x = (piece.position.x + j) * 10
                local y = (piece.position.y + i) * 10
                love.graphics.rectangle("line", 10 + x, 10 + y, 10, 10)
            end
        end
    end
end

function drawShadow(piece)
    love.graphics.setColor(70, 70, 70)
    for i = 0, 3 do
        for j = 0, 3 do
            if pieces[piece.type].blocks[piece.rotation][i * 4 + j + 1] == 1 then
                local x = (piece.position.x + j) * 10
                local y = (piece.position.y + i) * 10
                love.graphics.rectangle("line", 10 + x, 10 + y, 10, 10)
            end
        end
    end
end
