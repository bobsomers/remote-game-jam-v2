local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local MiniMap = Class(function(self, curiosity, vikingManager)
    self.curiosity = curiosity
    self.vikingManager = vikingManager

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

    local curiosityPos = self.curiosity:getPosition()
    curiosityPos.x = curiosityPos.x / Constants.WORLD.x * self.SIZE.x
    curiosityPos.y = curiosityPos.y / Constants.WORLD.y * self.SIZE.y

    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.rectangle("fill",
        Constants.SCREEN.x - 1 - self.SIZE.x - self.OFFSET.x + curiosityPos.x - 1,
        Constants.SCREEN.y - 1 - self.SIZE.y - self.OFFSET.y + curiosityPos.y - 1,
        3, 3)

    -- draw red vikings
    love.graphics.setColor(255, 0, 0, 255)
    for i,entity in ipairs(self.vikingManager.entities) do
        local vikePos = Vector(entity.shape:center())
        vikePos.x = vikePos.x / Constants.WORLD.x * self.SIZE.x
        vikePos.y = vikePos.y / Constants.WORLD.y * self.SIZE.y
        love.graphics.rectangle("fill",
            Constants.SCREEN.x - 1 - self.SIZE.x - self.OFFSET.x + vikePos.x - 1,
            Constants.SCREEN.y - 1 - self.SIZE.y - self.OFFSET.y + vikePos.y - 1,
            3, 3)
    end

    love.graphics.setColor(255, 255, 255, 255)
end

return MiniMap
