local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local RoverLaser = Class(function(self, media, collider, position, direction)
    self.collider = collider
    self.direction = direction

    self.SIZE = Vector(7, 850)
    self.SPEED = Constants.ROVER_LASER_SPEED

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, 500)
    self.shape.kind = "beam"
    self.collider:addToGroup("friend", self.shape)
    self.shape:moveTo(position.x, position.y)

    self.image = media.ROVER_LASER

    love.audio.stop(media.BEAM)
    love.audio.rewind(media.BEAM)
    love.audio.play(media.BEAM)

    self:reset()
end)

function RoverLaser:reset()
    self.dead = false
end

function RoverLaser:update(dt)
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

function RoverLaser:draw()
    local position = Vector(self.shape:center())

    love.graphics.draw(self.image,
        position.x, position.y,
        math.atan2(self.direction.y, self.direction.x) + math.pi / 2,
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return RoverLaser
