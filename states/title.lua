local Gamestate = require "hump.gamestate"
local PlayState = require "states.play"
local Constants = require "constants"

local TitleState = Gamestate.new()

function TitleState:init()
end

function TitleState:enter(previous)
    self.lastFpsTime = 0
end

function TitleState:leave()
end

function TitleState:update(dt)
    dt = math.min(dt, 1/15) -- Minimum 15 FPS.

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

function TitleState:draw()
    love.graphics.print(Constants.TITLE, 50, 50, 0, 3, 3)
    love.graphics.print(Constants.AUTHOR, 50, 100, 0, 2, 2)
    love.graphics.print(Constants.FEAT, 50, 130, 0, 2, 2)
    love.graphics.print(Constants.INSTRUCTIONS, 50, 200)
    love.graphics.print(Constants.INSTRUCTIONS2, 50, 220)
end

function TitleState:keypressed(key)
    Gamestate.switch(PlayState)
end

return TitleState
