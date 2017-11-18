--[[
    Features to implement:
    - Improve visuals
      - Backgrounds
      - Music and SFX
--]]

require('src/Config')
require('src/Block')
require('src/Bottle')
require('src/Piece')

require('src/states/State')
require('src/states/TitleState')
require('src/states/GameState')
require('src/states/GameOverState')

StateManager = require('src/StateManager')

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter("nearest","nearest")
    logoImage = love.graphics.newImage("res/logo.png")    
    love.window.setTitle("Atritus")
    love.window.setMode(320 * CONFIG.scale, 240 * CONFIG.scale, { centered = true })
    StateManager.switch(TitleState())
    print("Everything loaded")
end

function love.update(dt)
    StateManager.update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    elseif key == "1" then
        CONFIG.scale = 1
        love.window.setMode(320 * CONFIG.scale, 240 * CONFIG.scale, { centered = true })
    elseif key == "2" then
        CONFIG.scale = 2
        love.window.setMode(320 * CONFIG.scale, 240 * CONFIG.scale, { centered = true })
    elseif key == "3" then
        CONFIG.scale = 3
        love.window.setMode(320 * CONFIG.scale, 240 * CONFIG.scale, { centered = true })
    else
        StateManager.keyPressed(key)
    end
end

function love.draw(dt)
    love.graphics.push()
    love.graphics.scale(CONFIG.scale, CONFIG.scale)
    StateManager.draw()
    love.graphics.pop()
end
