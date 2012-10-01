local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Explosion = require "entities.explosion"

local Laser = Class(function(self, media, collider, entities, position, direction, upgrade, silent)
    self.media = media
    self.collider = collider
    self.entities = entities
    self.direction = direction
    self.upgrade = upgrade

    self.SIZE = Vector(7, 16)
    self.SPEED = Constants.LASER_SPEED

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "laser"
    self.collider:addToGroup("friend", self.shape)
    self.shape:moveTo(position.x, position.y)

    self.image = self.media.LASER

    if self.upgrade == "weak" then
        love.audio.stop(media.WEAK_LASER)
        love.audio.rewind(media.WEAK_LASER)
        love.audio.play(media.WEAK_LASER)
    elseif self.upgrade == "fast" then
        love.audio.stop(media.FAST_LASER)
        love.audio.rewind(media.FAST_LASER)
        love.audio.play(media.FAST_LASER)
    else -- triple & explosive
        love.audio.stop(media.TRIPLE_LASER)
        love.audio.rewind(media.TRIPLE_LASER)
        love.audio.play(media.TRIPLE_LASER)
    end

    self:reset()
end)

function Laser:reset()
    self.dead = false
    self.zombie = false
end

function Laser:kill()
    if self.upgrade == "explosive" then
        self.entities:register(Explosion(self.media, self.collider, self.entities, Vector(self.shape:center())))
    end
    self.collider:remove(self.shape)
    self.zombie = true
end

function Laser:update(dt)
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
