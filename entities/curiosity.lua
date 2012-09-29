local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Curiosity = Class(function(self, collider, camera)
    self.collider = collider
    self.camera = camera

    self.SIZE = Vector(50, 50)
    self.MOVE_SPEED = Constants.CURIOSITY_SPEED
    self.TURN_SPEED = Constants.CURIOSITY_TURN_SPEED
    self.FRAME_DURATION = Constants.CURIOSITY_FRAME_DURATION

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "curiosity"
    self.collider:addToGroup("curiosity", self.shape)

    self.frames = {
        love.graphics.newImage("assets/curiosity1.png"),
        love.graphics.newImage("assets/curiosity2.png"),
        love.graphics.newImage("assets/curiosity3.png")
    }

    self:reset()
end)

function Curiosity:reset()
    self.health = 100
    self.shape:moveTo(100, 100)

    self.frame = 0
    self.frameTime = 0
end

function Curiosity:update(dt)
    local position = Vector(self.shape:center())
    local moving = false
    local backward = false

    delta = Vector(0, 0)
    if love.keyboard.isDown("w") then
        delta.y = delta.y - Constants.CURIOSITY_SPEED * dt
        moving = true
    elseif love.keyboard.isDown("s") then
        delta.y = delta.y + Constants.CURIOSITY_SPEED * dt
        moving = true
        backward = true
    end

    if love.keyboard.isDown("a") then
        if backward then
            self.shape:rotate(self.TURN_SPEED * dt)
        else
            self.shape:rotate(-self.TURN_SPEED * dt)
        end
        moving = true
    end
    if love.keyboard.isDown("d") then
        if backward then
            self.shape:rotate(-self.TURN_SPEED * dt)
        else
            self.shape:rotate(self.TURN_SPEED * dt)
        end
        moving = true
    end

    delta:rotate_inplace(self.shape:rotation())
    position = position + delta

    self.shape:moveTo(position.x, position.y)

    if moving then
        self.frameTime = self.frameTime + dt
        if self.frameTime > self.FRAME_DURATION then
            self.frame = self.frame + 1
            self.frame = self.frame % 3
            self.frameTime = 0
        end
    end
end

function Curiosity:draw()
    local position = Vector(self.shape:center())
    love.graphics.draw(self.frames[self.frame + 1],
        position.x, position.y,
        self.shape:rotation(),
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
end

return Curiosity
