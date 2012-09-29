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

    self.image = love.graphics.newImage("assets/curiosity1.png")

    self:reset()
end)

function Curiosity:reset()
    self.velocity = Vector(0, 0)
    self.health = 100

    self.shape:moveTo(100, 100)
end

function Curiosity:update(dt)

end

function Curiosity:draw()
    local position = Vector(self.shape:center())
    love.graphics.draw(self.image,
        position.x, position.y,
        0,
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return Curiosity
