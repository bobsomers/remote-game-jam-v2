local Gamestate = require "hump.gamestate"
local Constants = require "constants"

local PlayState = Gamestate.new()

local Ground = require "entities.ground"

function PlayState:init()
    -- TODO

    -- Load the map stuff
    self.ground = Ground()

end

function PlayState:enter(previous)
    self.lastFpsTime = 0

    -- TODO
end

function PlayState:leave()
    -- TODO
end

function PlayState:update(dt)
    dt = math.min(dt, 1/15) -- Minimum 15 FPS.

    -- TODO

    -- Update FPS in window title (if DEBUG MODE is on).
    if Constants.DEBUG_MODE then
        self.lastFpsTime = self.lastFpsTime + dt
        if self.lastFpsTime > 1 then
            love.graphics.setCaption(table.concat({
                Constants.TITLE,
                " (",
                love.timer.getFPS(),
                " FPS)"
            }))
            self.lastFpsTime = 0
        end
    end
end

function PlayState:draw()
    love.graphics.print("Hello remote game jam!", 200, 200)
    self.ground:draw()

    -- TODO
end

function PlayState:keypressed(key)
    -- TODO
end

function PlayState:mousepressed(x, y, button)
    -- TODO
end

function PlayState:mousereleased(x, y, button)
    -- TODO
end

return PlayState
