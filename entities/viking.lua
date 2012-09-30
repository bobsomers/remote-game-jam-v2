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
    self.FRAME_DURATION = Constants.MELEE_VIKING_FRAME_DURATION

    -- collison detection
    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "viking"
    self.collider:addToGroup("viking", self.shape)

    -- sprite initialization
    self.frames = {
        love.graphics.newImage("assets/meleeviking1.png"),
        love.graphics.newImage("assets/meleeviking2.png")
    }

    -- finish initialization by resetting
    self:reset()
end)

function Viking:reset()
    self.velocity = Vector(math.random(-self.MOVE_SPEED, self.MOVE_SPEED), math.random(-self.MOVE_SPEED, self.MOVE_SPEED))
    self.health = Constants.MELEE_VIKING_HP
    self.shape:moveTo(self.initialPos.x, self.initialPos.y)

    -- animation data
    self.frame = 0
    self.frameTime = 0
end

function Viking:update(dt)
    local moving = false
    local pos = Vector(self.shape:center())

    local newPos = Vector(self.shape:center()) + (self.velocity*dt)
    moving = true
    -- TODO: think of caching this value because the velocity isn't changing often
    self.shape:setRotation((-math.pi/2)+math.atan2(self.velocity.y, self.velocity.x))

    -- bounce code
    if newPos.x > Constants.WORLD.x-1 or newPos.x < 0 then
        self.velocity.x = -1 * self.velocity.x
    end
    if newPos.y > Constants.WORLD.y-1 or newPos.y < 0 then
        self.velocity.y = -1 * self.velocity.y
    end
    newPos.x = math.min(Constants.WORLD.x-1, math.max(0, newPos.x))
    newPos.y = math.min(Constants.WORLD.y-1, math.max(0, newPos.y))
    self.shape:moveTo(newPos.x, newPos.y)

    local speed_ratio = Vector(Constants.MELEE_VIKING_SPEED, Constants.MELEE_VIKING_SPEED):len() / self.velocity:len()

    if moving then
        self.frameTime = self.frameTime + dt
        if self.frameTime > self.FRAME_DURATION*speed_ratio then
            self.frame = self.frame + 1
            self.frame = self.frame % 2
            self.frameTime = 0
        end
    end
end

function Viking:draw()
    local pos = Vector(self.shape:center())
    local scale = Vector(self.SIZE.x/30.0, self.SIZE.y/30.0)
    love.graphics.draw(self.frames[self.frame + 1],
                       pos.x, pos.y,
                       self.shape:rotation(),
                       scale.x, scale.y,
                       15, 15, -- offset
                       0,0)   -- shearing
end

return Viking
