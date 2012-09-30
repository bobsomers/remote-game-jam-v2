local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Viking = Class(function(self, collider, initialPos)
    -- handle params
    self.collider = collider
    self.initialPos = initialPos

    -- init constants
    self.SIZE = Vector(30, 30)
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
    self.velocity = Vector(math.random(-self.MOVE_SPEED, self.MOVE_SPEED), math.random(-self.MOVE_SPEED, self.MOVE_SPEED))
    self.health = Constants.MELEE_VIKING_HP
    self.shape:moveTo(self.initialPos.x, self.initialPos.y)
end

function Viking:update(dt)
    self.shape:move(self.velocity*dt)

    -- TODO: think of caching this value because the velocity isn't changing often
    self.shape:setRotation((-math.pi/2)+math.atan2(self.velocity.y, self.velocity.x))

    -- shitty bounce code
    local pos = Vector(self.shape:center())
    if pos.x > Constants.WORLD.x or pos.x < 0 then
        self.velocity.x = -1 * self.velocity.x
    end
    if pos.y > Constants.WORLD.y or pos.y < 0 then
        self.velocity.y = -1 * self.velocity.y
    end
end

function Viking:draw()
    local pos = Vector(self.shape:center())
    local scale = Vector(self.SIZE.x/30.0, self.SIZE.y/30.0)
    love.graphics.draw(self.sprite,
                       pos.x, pos.y,
                       self.shape:rotation(),
                       scale.x, scale.y,
                       15, 15, -- offset
                       0,0)   -- shearing
end

return Viking
