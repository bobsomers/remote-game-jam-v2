local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Spirit = Class(function(self, collider, curiosity)
    self.collider = collider
    self.curiosity = curiosity

    self.SIZE = Vector(20, 20)
    self.MOVE_SPEED = Constants.HELPER_SPEED
    self.TURN_SPEED = Constants.HELPER_TURN_SPEED
    self.FRAME_DURATION = Constants.HELPER_FRAME_DURATION

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "spirit"
    self.collider:addToGroup("spirit", self.shape)

    self.frames = {
        love.graphics.newImage("assets/curiosity1.png"),
        love.graphics.newImage("assets/curiosity2.png"),
        love.graphics.newImage("assets/curiosity3.png")
    }

    self:reset()
end)

function Spirit:reset()
    self.shape:moveTo(150, 150)
    
    self.frame = 0
    self.frameTime = 0
end

function Spirit:update(dt)
    local curiosityPosition = self.curiosity:getPosition()
    local position = Vector(self.shape:center())
    local dx = curiosityPosition.x - position.x
    local dy = curiosityPosition.y - position.y
    local rotation = math.atan2(dy, dx) + math.pi / 2
 
    delta = Vector(0, 0)
    delta.y = delta.y - self.MOVE_SPEED * dt
    
    delta:rotate_inplace(rotation)
    position = position + delta

    distance = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
    if distance > Constants.HELPER_MINIMUM_DISTANCE then
        self.shape:moveTo(position.x, position.y)
    end
end

function Spirit:draw()    
    local position = Vector(self.shape:center())
    local curiosityPosition = self.curiosity:getPosition()
    local dx = curiosityPosition.x - position.x
    local dy = curiosityPosition.y - position.y
    local rotation = math.atan2(dy, dx) + math.pi / 2
    love.graphics.draw(self.frames[self.frame + 1],
        position.x, position.y,
        rotation,
        .6, .6,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return Spirit
