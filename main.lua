
math.randomseed(os.time())

bottle = {}
for i = 1, 20 do
    bottle[i] = {}
    for j = 1, 10 do
        bottle[i][j] = 0
    end
end

pieces = {}
pieces[1] = {
    color = { 0, 0, 255 },
    blocks = {
        1, 1, 1, 1,
        0, 0, 0, 0
    }
}
pieces[2] = {
    color = { 255, 0, 0 },
    blocks = {
        1, 1, 0, 0,
        0, 1, 1, 0
    }
}
pieces[3] = {
    color = { 0, 255, 0 },
    blocks = {
        0, 1, 1, 0,
        1, 1, 0, 0
    }
}
pieces[4] = {
    color = { 255, 255, 0 },
    blocks = {
        1, 0, 0, 0,
        1, 1, 1, 0
    }
}
pieces[5] = {
    color = { 0, 255, 255 },
    blocks = {
        0, 0, 1, 0,
        1, 1, 1, 0
    }
}
pieces[6] = {
    color = { 255, 0, 255 },
    blocks = {
        0, 1, 0, 0,
        1, 1, 1, 0
    }
}
pieces[7] = {
    color = { 255, 255, 255 },
    blocks = {
        1, 1, 0, 0,
        1, 1, 0, 0
    }
}

currentPiece = {
    type = math.random(1, 7),
    position = {
        x = 4,
        y = 0
    }
}

nextPiece = math.random(1, 7)

function love.load()
    love.window.setTitle("Atritus")
    success = love.window.setMode(320, 240, { centered = true })
    
    timeSinceLastDrop = 0
end

function love.update(dt)

    timeSinceLastDrop = timeSinceLastDrop + dt

    if timeSinceLastDrop >= 0.3 then
        if canFallFurther(currentPiece) then
            currentPiece.position.y = currentPiece.position.y + 1
        else
            consolidatePiece(currentPiece)
            -- check if lines were eliminated
            -- throw next block
            currentPiece.type = nextPiece
            nextPiece = math.random(1, 7)
            currentPiece.position.x = 4
            currentPiece.position.y = 0
            -- if next block doesn't have space to appear, game over
        end
        timeSinceLastDrop = 0
    end

end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    elseif key == "left" then
        if currentPiece.position.x > 0 then
            currentPiece.position.x = currentPiece.position.x - 1
        end
    elseif key == "right" then
        -- if can move right
        currentPiece.position.x = currentPiece.position.x + 1
    elseif key == "down" then
        if canFallFurther(currentPiece) then
            currentPiece.position.y = currentPiece.position.y + 1
        else
            consolidatePiece(currentPiece)
            -- throw new block
            nextPiece = math.random(1, 7)
            currentPiece.position.x = 4
            currentPiece.position.y = 0
        end
    elseif key == "uo" then
        -- instant fall
    elseif key == "z" then
        -- rotate counter-clockwise
    elseif key == "x" then
        -- rotate clockwise
    end
end

function love.draw(dt)
    drawBottle()
    drawBlocks()
    drawPiece(currentPiece)
end

function drawBottle()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Next: " .. nextPiece, 200, 10)
    love.graphics.rectangle("line", 10 - 1, 10 - 1, 100 + 1, 200 + 1)
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
    for i = 0, 1 do
        for j = 0, 3 do
            if pieces[piece.type].blocks[i * 4 + j + 1] == 1 then -- and isPositionEmpty(piece.position.x + j, piece.position.y + i) then
                local x = (piece.position.x + j) * 10
                local y = (piece.position.y + i) * 10
                love.graphics.rectangle("line", 10 + x, 10 + y, 10, 10)
            end
        end
    end
end

function isPositionEmpty(x, y)
    return bottle[y][x] == 0
end

function canFallFurther(piece)
    for i = 0, 1 do
        for j = 0, 3 do
            if pieces[piece.type].blocks[i * 4 + j + 1] == 1 then
                if i + piece.position.y + 2 > 20 then
                    -- reached bottom of bottle
                    return false
                end
                if bottle[i + piece.position.y + 2][j + piece.position.x + 1] == 1 then
                    return false
                end
            end
        end
    end
    return true
end

function consolidatePiece(piece)
    local position = piece.position
    for i = 0, 1 do
        for j = 0, 3 do
            if pieces[piece.type].blocks[i * 4 + j + 1] == 1 then
                bottle[position.y + i + 1][position.x + j + 1] = 1
            end
        end
    end
end
