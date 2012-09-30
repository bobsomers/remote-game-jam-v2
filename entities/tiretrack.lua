local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local TireTrack = Class(function(self, position, rotation, previous, rover)
    self.rover = rover

    local leftOffset, rightOffset
    if self.rover then
        leftOffset = Vector(-7, 2):rotate_inplace(rotation)
        rightOffset = Vector(7, 2):rotate_inplace(rotation)
    else
        leftOffset = Vector(-20, 8):rotate_inplace(rotation)
        rightOffset = Vector(20, 8):rotate_inplace(rotation)
    end

    self.leftPos = position + leftOffset
    self.rightPos = position + rightOffset
    
    if previous then
        self.previous = previous
    else
        self.previous = {
            leftPos = self.leftPos + Vector(0, 10),
            rightPos = self.rightPos + Vector(0, 10)
        }
    end

    self.bg = true

    self:reset()
end)

function TireTrack:reset()
    self.dead = false
    self.alpha = 128
end

function TireTrack:update(dt)
    self.alpha = self.alpha - 64 * dt
    if self.alpha <= 0 then
        self.dead = true
    end
end

function TireTrack:draw()
    if self.alpha <= 0 then return end

    love.graphics.setColor(0, 0, 0, self.alpha)
    if self.rover then
        love.graphics.setLineWidth(3)
    else
        love.graphics.setLineWidth(6)
    end
    love.graphics.line(self.leftPos.x, self.leftPos.y, self.previous.leftPos.x, self.previous.leftPos.y)
    love.graphics.line(self.rightPos.x, self.rightPos.y, self.previous.rightPos.x, self.previous.rightPos.y)
    love.graphics.setColor(255, 255, 255, 255)
end

return TireTrack
