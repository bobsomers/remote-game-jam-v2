local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local VikingShot = Class(function(self, media, collider, position, direction)
    self.collider = collider
    self.direction = direction

    self.SIZE = Vector(12, 12) --TODO
    self.SPEED = Constants.RANGED_VIKING_SHOT_SPEED

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "vikingshot"
    self.collider:addToGroup("foe", self.shape)
    self.shape:moveTo(position.x, position.y)

    self.image = media.FIRE_PARTICLE

    self:reset()
end)

function VikingShot:reset()
    self.dead = false
    self.zombie = false
end

function VikingShot:kill()
    self.collider:remove(self.shape)
    self.zombie = true
end

function VikingShot:update(dt)
    local position = Vector(self.shape:center())

    position = position + self.direction * self.SPEED * dt

    -- Destroy when outside the world bounds.
    if position.x > Constants.WORLD.x - 1 or
       position.x < 0 or
       position.y > Constants.WORLD.y - 1 or
       position.y < 0 then
        self.dead = true
    end

    self.shape:moveTo(position.x, position.y)
end

function VikingShot:draw()
    local position = Vector(self.shape:center())

    love.graphics.draw(self.image,
        position.x, position.y,
        math.atan2(self.direction.y, self.direction.x) + math.pi / 2,
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return VikingShot
