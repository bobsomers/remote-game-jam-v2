local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Fire = require "entities.fire"

local Flamethrower = Class(function(self, emitter, collider, entities)
    self.emitter = emitter
    self.collider = collider
    self.entities = entities
    
    self.particles = love.graphics.newParticleSystem(
        love.graphics.newImage("assets/fireparticle.png"), 250)
    self.particles:setEmissionRate(500)
    self.particles:setSizes(1, 2)
    self.particles:setSpeed(500, 700)
    self.particles:setColors(220, 105, 20, 255, 194, 30, 18, 0)
    self.particles:setLifetime(-1)
    self.particles:setParticleLife(0.3)
    self.particles:setSpread(math.pi / 10)
    self.particles:stop()
    
    self:reset()
end)

function Flamethrower:reset()
    self.blobs = {}
    self.firing = false
    self.cooldown = 0
end

function Flamethrower:update(dt)
    self.cooldown = self.cooldown - dt
    
    local position = self.emitter:getPosition()
    local direction = self.emitter:getDirection()
    self.particles:setPosition(position.x, position.y)
    self.particles:setDirection(direction)

    if self.firing then
        if self.cooldown < 0 then
            -- Expose through constants
            self.entities:register(Fire(self.media, self.collider, position, 
                Vector(math.cos(direction),
                       math.sin(direction)), false, 0.3))

            self.particles:setPosition(position.x, position.y)
            self.particles:setDirection(direction)

            -- Also this
            self.cooldown = 0.15
        end
    end

    -- Update particles.
    self.particles:update(dt)
end

function Flamethrower:draw()
    local colorMode = love.graphics.getColorMode()
    local blendMode = love.graphics.getBlendMode()
    love.graphics.setColorMode("modulate")
    love.graphics.setBlendMode("additive")
    love.graphics.draw(self.particles, 0, 0)
    love.graphics.setColorMode(colorMode)
    love.graphics.setBlendMode(blendMode)
end

return Flamethrower