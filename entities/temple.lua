local Class = require "hump.class"
local Vector = require "hump.vector"
local Signal = require "hump.signal"
local Constants = require "constants"

local Temple = Class(function(self, media, collider, entities, curiosity, which)
    self.media = media
    self.collider = collider
    self.entities = entities
    self.curiosity = curiosity
    self.which = which

    self.SIZE = Vector(200, 200)
    self.POSITION = Constants.TEMPLE_LOCATION[self.which]

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "temple"
    self.collider:addToGroup("world", self.shape)

    self.image = media.TEMPLE_IMAGES[which]

    self.bg = true

    self:reset()
end)

function Temple:reset()
    self.shape:moveTo(self.POSITION.x + self.SIZE.x / 2, self.POSITION.y + self.SIZE.y / 2)
    self.triggered = false
    self.complete = false
end

function Temple:getPosition()
    return Vector(self.shape:center())
end

function Temple:update(dt)
    local dist = self:getPosition():dist(self.curiosity:getPosition())
    if not self.triggered and dist < self.SIZE.x * 1.3 then
        Signal.emit("temple-triggered", self.which)
        self.triggered = true
    end
end

function Temple:draw()
    love.graphics.draw(self.image,
        self.POSITION.x, self.POSITION.y,
        0,
        1, 1,
        0, 0,
        0, 0
    )
end

return Temple
