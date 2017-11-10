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

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Atritus")
    love.window.setMode(320, 240, { centered = true })
    game = Game()
end

function love.update(dt)
    game.update(dt)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    else
        game.keyPressed(key)
    end
end

function love.draw(dt)
    game.draw()
end
