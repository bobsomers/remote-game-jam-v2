local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Laser = Class(function(self, collider, position, direction)
    self.collider = collider
    self.direction = direction

    self.SIZE = Vector(7, 16)
    self.SPEED = Constants.LASER_SPEED

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "laser"
    self.collider:addToGroup("lasers", self.shape)
    self.shape:moveTo(position.x, position.y)

    self.image = love.graphics.newImage("assets/laserbullet.png"),

    self:reset()
end)

function Laser:reset()
    self.alive = true
end

function Laser:update(dt)
    local position = Vector(self.shape:center())

    position = position + self.direction * self.SPEED * dt

    -- Destroy when outside the world bounds.
    if position.x > Constants.WORLD.x - 1 and
       position.x < 0 and
       position.y > Constants.WORLD.y - 1 and
       position.y < 0 then
        self.alive = false
    end

    self.shape:moveTo(position.x, position.y)
end

function Laser:draw()
    local position = Vector(self.shape:center())

    love.graphics.draw(self.image,
        position.x, position.y,
        math.atan2(self.direction.y, self.direction.x) + math.pi / 2,
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return Laser
