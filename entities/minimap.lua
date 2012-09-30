local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local MiniMap = Class(function(self, entities)
    self.entities = entities

    self.SIZE = Vector(100, 100)
    self.OFFSET = Vector(5, 5)
end)

function MiniMap:draw()
    love.graphics.setColor(0, 0, 0, 128)
    love.graphics.rectangle("fill",
        Constants.SCREEN.x - 1 - self.SIZE.x - self.OFFSET.x,
        Constants.SCREEN.y - 1 - self.SIZE.y - self.OFFSET.y,
        self.SIZE.x, self.SIZE.y
    )

    for _, entity in ipairs(self.entities.entities) do
        if entity.shape then
            if entity.shape.kind == "curiosity" then
                self:drawCuriosity(entity)
            elseif entity.shape.kind == "viking" then
                self:drawViking(entity)
            end
        end
    end

    love.graphics.setColor(255, 255, 255, 255)
end

function MiniMap:drawCuriosity(curiosity)
    local curiosityPos = curiosity:getPosition()
    curiosityPos.x = curiosityPos.x / Constants.WORLD.x * self.SIZE.x
    curiosityPos.y = curiosityPos.y / Constants.WORLD.y * self.SIZE.y

    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.rectangle("fill",
        Constants.SCREEN.x - 1 - self.SIZE.x - self.OFFSET.x + curiosityPos.x - 1,
        Constants.SCREEN.y - 1 - self.SIZE.y - self.OFFSET.y + curiosityPos.y - 1,
        3, 3)
end

function MiniMap:drawViking(viking)
    local vikePos = viking:getPosition()
    vikePos.x = vikePos.x / Constants.WORLD.x * self.SIZE.x
    vikePos.y = vikePos.y / Constants.WORLD.y * self.SIZE.y

    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.rectangle("fill",
        Constants.SCREEN.x - 1 - self.SIZE.x - self.OFFSET.x + vikePos.x - 1,
        Constants.SCREEN.y - 1 - self.SIZE.y - self.OFFSET.y + vikePos.y - 1,
        3, 3)
end

return MiniMap
