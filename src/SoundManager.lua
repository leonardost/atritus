local SoundManager = {}

local SOUNDS = {
    ROTATE = love.audio.newSource("res/sound_rotate.mp3", "static"),
    -- FALL = love.audio.newSource("res/sound_fall.mp3", "static"),
    LINE_CLEAR = love.audio.newSource("res/sound_success.mp3", "static"),
    GAME_OVER = love.audio.newSource("res/sound_success.mp3", "static")
}

function SoundManager.init()
    SOUNDS["LINE_CLEAR"]:setVolume(0.5)
end

function SoundManager.play(audio)
    SOUNDS[audio]:stop()
    SOUNDS[audio]:play()
end

SoundManager.init()

return SoundManager
