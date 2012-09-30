local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Damage = require "entities.damage"

local Viking = Class(function(self, collider, initialPos, initialDir, isRanged)
    -- handle params
    self.collider = collider
    self.initialPos = initialPos
    self.initialDir = initialDir
    self.isRanged = isRanged

    -- init constants
    self.SIZE = Vector(30, 30)
    if self.isRanged then
        self.MOVE_SPEED = math.random(Constants.RANGED_VIKING_MIN_SPEED, Constants.RANGED_VIKING_MAX_SPEED)
    else
        self.MOVE_SPEED = math.random(Constants.MELEE_VIKING_MIN_SPEED, Constants.MELEE_VIKING_MAX_SPEED)
    end
    self.FRAME_DURATION = Constants.VIKING_FRAME_DURATION

    -- collison detection
    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "viking"
    self.collider:addToGroup("foe", self.shape)

    -- sprite initialization
    if self.isRanged then
        self.frames = {
            love.graphics.newImage("assets/rangedviking1.png"),
            love.graphics.newImage("assets/rangedviking2.png")
        }
    else
        self.frames = {
            love.graphics.newImage("assets/meleeviking1.png"),
            love.graphics.newImage("assets/meleeviking2.png")
        }
    end

    local hp = 0
    if self.isRanged then
        hp = Constants.RANGED_VIKING_HEALTH
    else
        hp = Constants.MELEE_VIKING_HEALTH
    end
    self.damage = Damage(self, hp, self.SIZE.x, Vector(-self.SIZE.x / 2, -self.SIZE.y / 2 - 5))

    -- finish initialization by resetting
    self:reset()
end)

function Viking:reset()
    self.velocity = self.MOVE_SPEED * self.initialDir:normalized()
    self.shape:setRotation((-math.pi/2)+math.atan2(self.velocity.y, self.velocity.x))
    self.shape:moveTo(self.initialPos.x, self.initialPos.y)

    -- animation data
    self.frame = 0
    self.frameTime = 0
end

function Viking:getPosition()
    return Vector(self.shape:center())
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

    local animationSpeed = 0
    if self.isRanged then
        animationSpeed = Vector(Constants.RANGED_VIKING_MAX_SPEED, Constants.RANGED_VIKING_MAX_SPEED):len() / self.velocity:len()
    else
        animationSpeed = Vector(Constants.MELEE_VIKING_MAX_SPEED, Constants.MELEE_VIKING_MAX_SPEED):len() / self.velocity:len()
    end

    if moving then
        self.frameTime = self.frameTime + dt
        if self.frameTime > self.FRAME_DURATION*animationSpeed then
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

    self.damage:draw()
end

return Viking
