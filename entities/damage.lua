local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Damage = Class(function(self, entity, health, width, offset)
    self.entity = entity
    self.health = health
    self.totalHealth = health
    self.width = width
    self.offset = offset

    self:reset()
end)

function Damage:reset()
    -- Nothing yet
end

function Damage:update(dt)
    -- Nothing yet
end

function Damage:draw()
    local position = self.entity:getPosition() + self.offset

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("fill",
        position.x, position.y,
        self.health / self.totalHealth * (self.width - 1), 4
    )
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.line(
        position.x, position.y + 5,
        position.x + self.width, position.y + 5,
        position.x + self.width, position.y)
end

return Damage
