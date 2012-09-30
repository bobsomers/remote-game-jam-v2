local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local SmokeTrail = Class(function(self, media, missile)
    self.missile = missile

    self.image = media.PARTICLE

    self.particles = love.graphics.newParticleSystem(self.image, 500)
    self.particles:setEmissionRate(250)
    self.particles:setSizes(0.2, 0.1)
    self.particles:setColors(194, 30, 18, 255, 152, 152, 152, 0)
    self.particles:setLifetime(-1)
    self.particles:setParticleLife(1, 2)
    
    local position = self.missile:getPosition()
    self.particles:setPosition(position.x, position.y)

    self.particles:start()
end)

function SmokeTrail:update(dt)
    local position = self.missile:getPosition()
    self.particles:setPosition(position.x, position.y)
    self.particles:update(dt)
end

function SmokeTrail:draw()
    local color_mode = love.graphics.getColorMode()
    local blend_mode = love.graphics.getBlendMode()
    love.graphics.setColorMode("modulate")
    love.graphics.setBlendMode("additive")
    love.graphics.draw(self.particles, 0, 0)
    love.graphics.setColorMode(color_mode)
    love.graphics.setBlendMode(blend_mode)
end

return SmokeTrail
