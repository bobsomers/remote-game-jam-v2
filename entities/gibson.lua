local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Gibson = Class(function(self, collider)
    self.collider = collider
    self.camera = camera

    self.SIZE = Vector(20, 20)
    self.MOVE_SPEED = Constants.HELPER_SPEED

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "gibson"
    self.collider:addToGroup("gibson", self.shape)

    self.image = love.graphics.newImage("assets/curiosity1.png")

    self:reset()
end)

function Gibson:reset()
    self.velocity = Vector(0, 0)

    self.shape:moveTo(50, 50)
end

function Gibson:update(dt)

end

function Gibson:draw()
    local position = Vector(self.shape:center())
    love.graphics.draw(self.image,
        position.x, position.y,
        0,
        .6, .6,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return Gibson
