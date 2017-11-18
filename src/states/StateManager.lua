local StateManager = {}

local currentState = nil

function StateManager.switch(state)
    currentState = state
end

function StateManager.draw()
    currentState.draw()
end

function StateManager.update(dt)
    currentState.update(dt)
end

function StateManager.keyPressed(key)
    currentState.keyPressed(key)
end

return StateManager
