local Class = require "hump.class"
local Vector = require "hump.vector"
local Camera = require "hump.camera"
local Constants = require "constants"

local GameCam = Class(function(self)
    self.SPRING_K = 0.9
    self.FRICTION = 0.77

    self.camera = Camera(0, 0, 1, 0)
    self.target = Vector(0, 0)

    self:reset()
end)

function GameCam:reset()
    self.time = 0
    self.translateVelocity = Vector(0, 0)
end

function GameCam:teleport(position)
    self.target = position
    self.camera.x = position.x
    self.camera.y = position.y
    self.translateVelocity = Vector(0, 0)
end

function GameCam:focus(position)
    self.target = position
end

function GameCam:update(dt)
    self.time = self.time + dt

    local a = (self.target - Vector(self.camera:pos())) * self.SPRING_K

    self.translateVelocity = (self.translateVelocity + a) * self.FRICTION
    local delta = self.translateVelocity * dt
    self.camera:move(delta.x, delta.y)
end

function GameCam:draw()
    -- Nothing to do.
end

function GameCam:attach()
    self.camera:attach()
end

function GameCam:detach()
    self.camera:detach()
end

return GameCam
