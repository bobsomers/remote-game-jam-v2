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

    self.head = love.graphics.newImage("assets/curiosityhead.png")

    self:reset()
end)

function Curiosity:reset()
    self.health = 100
    self.shape:moveTo(Constants.WORLD.x/2, Constants.WORLD.y/2)

    self.frame = 0
    self.frameTime = 0
end

function Curiosity:getPosition()
    return Vector(self.shape:center())
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
    local nextPos = position + delta

    -- Disallow moves outside the world bounds.
    if nextPos.x < Constants.WORLD.x - 1 and
       nextPos.x > 0 and
       nextPos.y < Constants.WORLD.y - 1 and
       nextPos.y > 0 then
        position = nextPos
    end

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

    local mouseX, mouseY = self.camera.camera:worldCoords(love.mouse.getX(), love.mouse.getY())
    local dx = mouseX - position.x
    local dy = mouseY - position.y
    local rotation = math.atan2(dy, dx) + math.pi / 2

    love.graphics.draw(self.head,
        position.x, position.y,
        rotation,
        1, 1,
        8, 7,
        0, 0
    )
end

return Curiosity
