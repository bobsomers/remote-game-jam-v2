local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Opportunity = Class(function(self, collider)
    self.collider = collider
    self.camera = camera

    self.SIZE = Vector(20, 20)
    self.MOVE_SPEED = Constants.HELPER_SPEED

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "opportunity"
    self.collider:addToGroup("opportunity", self.shape)

    self.image = love.graphics.newImage("assets/curiosity1.png")

    self:reset()
end)

function Opportunity:reset()
    self.velocity = Vector(0, 0)

    self.shape:moveTo(100, 50)
end

function Opportunity:update(dt)

end

function Opportunity:draw()
    local position = Vector(self.shape:center())
    love.graphics.draw(self.image,
        position.x, position.y,
        0,
        .6, .6,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return Opportunity
