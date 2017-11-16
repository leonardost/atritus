--[[
    Features to implement:
    - Improve visuals
      - Line clearing effect 
      - Backgrounds
      - Music and SFX
    - Improve gameplay
      - Create options screen
        - BGM volume, SFX volume
        - Toggle shadow piece on/off
--]]

require('src/Config')
require('src/Game')
require('src/Block')
require('src/Bottle')
require('src/Piece')

local game

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Atritus")
    love.window.setMode(320 * CONFIG.scale, 240 * CONFIG.scale, { centered = true })
    game = Game()
end

function love.update(dt)
    game.update(dt)
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
        game.keyPressed(key)
    end
end

function love.draw(dt)
    love.graphics.push()
    love.graphics.scale(CONFIG.scale, CONFIG.scale)
    game.draw()
    love.graphics.pop()
end
