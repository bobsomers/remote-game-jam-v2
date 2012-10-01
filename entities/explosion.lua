local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Explosion = Class(function(self, media, collider, entities, position)
    self.SIZE = Vector(50, 50)

    self.image = media.PARTICLE

    self.fire = love.graphics.newParticleSystem(self.image, 500)
    self.fire:setEmissionRate(1000)
    self.fire:setSizes(1, 1.5)
    self.fire:setSpeed(500, 700)
    self.fire:setColors(220, 105, 20, 255, 194, 30, 18, 0)
    self.fire:setPosition(position.x, position.y)
    self.fire:setLifetime(0.2)
    self.fire:setParticleLife(0.2)
    self.fire:setSpread(2 * math.pi)
    self.fire:setTangentialAcceleration(1000)
    self.fire:setRadialAcceleration(-2000)

    self.smoke = love.graphics.newParticleSystem(self.image, 100)
    self.smoke:setEmissionRate(300)
    self.smoke:setSizes(2, 4)
    self.smoke:setSpeed(100, 200)
    self.smoke:setColors(62, 62, 62, 50, 152, 152, 152, 0)
    self.smoke:setPosition(position.x, position.y)
    self.smoke:setSpread(2 * math.pi)
    self.smoke:setLifetime(0.15)
    self.smoke:setParticleLife(0.75)

    love.audio.stop(media.EXPLODE)
    love.audio.rewind(media.EXPLODE)
    love.audio.play(media.EXPLODE)

    for shape in pairs(collider:shapesInRange(position.x - self.SIZE.x / 2, position.y - self.SIZE.y / 2, position.x + self.SIZE.x / 2, position.y + self.SIZE.y / 2)) do
        if shape.kind == "viking" or shape.kind == "olmec" then
            local entity = entities:findByShape(shape)
            entity:takeDamage(Constants.EXPLOSION_DAMAGE)
        end
    end

    self:reset()
end)

function Explosion:reset()
    self.dead = false
    self.duration = 0
end

function Explosion:update(dt)
    self.fire:update(dt)
    self.smoke:update(dt)

    self.duration = self.duration + dt
    if self.duration > 4 then
        self.dead = true
    end
end

function Explosion:draw()
    local color_mode = love.graphics.getColorMode()
    local blend_mode = love.graphics.getBlendMode()
    love.graphics.setColorMode("modulate")
    love.graphics.setBlendMode("additive")
    love.graphics.draw(self.smoke, 0, 0)
    love.graphics.draw(self.fire, 0, 0)
    love.graphics.setColorMode(color_mode)
    love.graphics.setBlendMode(blend_mode)
end

return Explosion
