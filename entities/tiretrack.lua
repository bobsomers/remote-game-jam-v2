local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local TireTrack = Class(function(self, position, rotation, previous)
    local leftOffset = Vector(-20, 10):rotate_inplace(rotation)
    local rightOffset = Vector(20, 10):rotate_inplace(rotation)

    self.leftPos = position + leftOffset
    self.rightPos = position + rightOffset
    
    if previous then
        self.previous = previous
    else
        self.previous = {
            leftPos = self.leftPos + Vector(0, 20),
            rightPos = self.rightPos + Vector(0, 20)
        }
    end

    self:reset()
end)

function TireTrack:reset()
    self.dead = false
    self.alpha = 128
end

function TireTrack:update(dt)
    self.alpha = self.alpha - 27 * dt
    if self.alpha <= 0 then
        self.dead = true
    end
end

function TireTrack:draw()
    love.graphics.setColor(0, 0, 0, self.alpha)
    love.graphics.setLineWidth(6)
    love.graphics.line(self.leftPos.x, self.leftPos.y, self.previous.leftPos.x, self.previous.leftPos.y)
    love.graphics.line(self.rightPos.x, self.rightPos.y, self.previous.rightPos.x, self.previous.rightPos.y)
    love.graphics.setColor(255, 255, 255, 255)
end

return TireTrack
