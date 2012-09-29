local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Curiosity = Class(function(self, collider, camera)
    self.collider = collider
    self.camera = camera

    self.SIZE = Vector(50, 50)
    self.MOVE_SPEED = Constants.PLAYER_SPEED

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "curiosity"
    self.collider:addToGroup("curiosity", self.shape)

    self:reset()
end)

function Curiosity:reset()
    self.velocity = Vector(0, 0)
    self.health = 100
end

function Curiosity:update(dt)

end

function Curiosity:draw()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", 100, 100, self.SIZE.x, self.SIZE.y)
end

return Curiosity
