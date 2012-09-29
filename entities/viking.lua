local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Viking = Class(function(self, collider)
    -- handle params
    self.collider = collider

    -- init constants
    self.SIZE = Constants.MELEE_VIKING_SIZE
    self.MOVE_SPEED = Constants.MELEE_VIKING_SPEED

    -- collison detection
    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "viking"
    self.collider:addToGroup("viking", self.shape)

    -- sprite initialization
    self.sprite = love.graphics.newImage("assets/meleeviking1.png")

    -- finish initialization by resetting
    self:reset()
end)

function Viking:reset()
    self.velocity = Vector(0, 0)
    self.health = Constants.MELEE_VIKING_HP

    self.shape:moveTo(700, 500) --TODO fixme
end

function Viking:update(dt)

end

function Viking:draw()
    local pos = Vector(self.shape:center())
    love.graphics.draw(self.sprite,
                       pos.x, pos.y,  -- position
                       0,             -- rotation
                       1,1,           -- scale
                       15,15,         -- offset
                       0,0)           -- shearing
end

return Viking
