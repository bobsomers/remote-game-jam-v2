local Class = require "hump.class"
local Vector = require "hump.vector"

local Crosshair = Class(function(self)
    self.EXTENT = 10
end)

function Crosshair:draw()
    local x, y = love.mouse.getPosition()
    love.graphics.setColor(0, 0, 0, 255)
    love.graphics.line(
        x - self.EXTENT + 1, y + 1,
        x + self.EXTENT + 1, y + 1
    )
    love.graphics.line(
        x + 1, y - self.EXTENT + 1,
        x + 1, y + self.EXTENT + 1
    )
    love.graphics.setColor(0, 255, 70, 255)
    love.graphics.line(
        x - self.EXTENT, y,
        x + self.EXTENT, y
    )
    love.graphics.line(
        x, y - self.EXTENT,
        x, y + self.EXTENT
    )
    love.graphics.setColor(255, 255, 255, 255)
end

return Crosshair
