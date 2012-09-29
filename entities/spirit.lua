local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Spirit = Class(function(self, collider)
    self.collider = collider
    self.camera = camera

    self.SIZE = Vector(20, 20)
    self.MOVE_SPEED = Constants.HELPER_SPEED

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "spirit"
    self.collider:addToGroup("spirit", self.shape)

    self.image = love.graphics.newImage("assets/curiosity1.png")

    self:reset()
end)

function Spirit:reset()
    self.velocity = Vector(0, 0)

    self.shape:moveTo(150, 150)
end

function Spirit:update(dt)

end

function Spirit:draw()
    local position = Vector(self.shape:center())
    love.graphics.draw(self.image,
        position.x, position.y,
        0,
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return Spirit
