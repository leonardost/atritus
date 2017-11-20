local SoundManager = require('src/SoundManager')

function GameOverState()

    local self = State()

    local STATES = {NORMAL = 1, NEW_HIGH_SCORE = 2, GAME_OVER_SCREEN = 3}
    local state = STATES.GAME_OVER_SCREEN
    local points = 0
    local name = ""
    local scoreTable = {}
    local writeUnderscore = true
    local timeSinceLastBlink = 0
    local timeInGameOverScreen = 0
    local newHighScoreFlag = false
    local newHighScorePosition = 0

    function self.setPoints(p)
        points = p
    end

    local function loadScores()
        local scores = nil
        if love.filesystem.exists("scoreboard.dat") then
            scores = love.filesystem.read("scoreboard.dat")
        end

        while scores:find("\n") ~= nil do
            local bytesOfThisRecord = scores:find("\n")
            local record = scores:sub(1, bytesOfThisRecord)
            local recordSeparatorPosition = record:find("\t")
            local name = record:sub(1, recordSeparatorPosition - 1)
            local score = record:sub(recordSeparatorPosition + 1)
            table.insert(scoreTable, {name = name, score = tonumber(score)})
            scores = scores:sub(bytesOfThisRecord + 1)
        end
    end

    local function isNewHighScore(score)
        if #scoreTable < 10 then
            newHighScoreFlag = true
            return true
        end

        for i = 1, #scoreTable do
            if score > scoreTable[i].score then
                newHighScoreFlag = true
                return true
            end
        end
        return false
    end

    local function addNewHighScore(name, score)
        if name == "" then
            name = "ATRITUS"
        end
        local positionToInsert = #scoreTable + 1
        for i = 1, #scoreTable do
            if score > scoreTable[i].score then
                positionToInsert = i
                break
            end
        end
        newHighScorePosition = positionToInsert
        table.insert(scoreTable, positionToInsert, {name = name, score = score})
        if #scoreTable > 10 then
            table.remove(scoreTable)
        end
    end

    local function saveScoreTable()
        saveBuffer = ""
        limit = #scoreTable
        if #scoreTable > 10 then
            limit = 10
        end
        for i = 1, limit do
            saveBuffer = saveBuffer .. scoreTable[i].name .. "\t" .. scoreTable[i].score .. "\n"
        end
        love.filesystem.write("scoreboard.dat", saveBuffer)
    end

    function self.updateScoreboard()
        if isNewHighScore(points) then
            state = STATES.NEW_HIGH_SCORE
        end
    end

    function self.keyPressed(key)
        if state == STATES.NEW_HIGH_SCORE then
            if key == "return" then
                addNewHighScore(name, points)
                saveScoreTable()
                state = STATES.NORMAL
            elseif key == "backspace" and name:len() > 0 then
                name = name:sub(1, name:len() - 1)
            elseif key:match('^[%w%s]$') then
                name = name .. key
            end
        end
    end

    function self.update(dt)
        if state == STATES.GAME_OVER_SCREEN then
            timeInGameOverScreen = timeInGameOverScreen + dt
            if timeInGameOverScreen > 2.5 then
                state = STATES.NORMAL
                self.updateScoreboard()
            end
        elseif state == STATES.NEW_HIGH_SCORE then
            timeSinceLastBlink = timeSinceLastBlink + dt
            if timeSinceLastBlink > 0.5 then
                writeUnderscore = not writeUnderscore
                timeSinceLastBlink = 0
            end
        end
    end

    function self.draw()
        love.graphics.setColor(255, 255, 255)
        if state == STATES.GAME_OVER_SCREEN then
            love.graphics.printf("GAME OVER", 0, 90, 320, "center")
            if newHighScoreFlag then
                love.graphics.printf("NEW HIGH SCORE", 0, 130, 320, "center")
            else
                love.graphics.printf("SCORE", 0, 130, 320, "center")
            end
            love.graphics.printf(points, 0, 150, 320, "center")
        elseif state == STATES.NORMAL then
            love.graphics.printf("LEADERBOARD", 0, 20, 320, "center")
            for i = 1, #scoreTable do
                love.graphics.setColor(255, 255, 255)
                if newHighScorePosition == i then
                    love.graphics.setColor(255, 255, 0)
                end
                love.graphics.print(i .. ". " .. scoreTable[i].name, 80, 40 + i * 17)
                love.graphics.print(scoreTable[i].score, 215, 40 + i * 17)
            end
        elseif state == STATES.NEW_HIGH_SCORE then
            love.graphics.printf("Congratulations!", 0, 50, 320, "center")
            love.graphics.printf("You achieved a new high score!", 0, 70, 320, "center")
            love.graphics.printf("Please enter your name:", 0, 110, 320, "center")
            local nameWithUnderscore = name
            if writeUnderscore then
                nameWithUnderscore = nameWithUnderscore .. "_"
            else
                nameWithUnderscore = nameWithUnderscore .. " "
            end
            love.graphics.print(nameWithUnderscore, 60, 140)
        end
    end

    loadScores()
    return self

end
