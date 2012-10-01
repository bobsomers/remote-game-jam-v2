local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Fire = Class(function(self, media, collider, position, direction, explosive, lifetime)
    self.collider = collider
    self.position = position
    self.direction = direction
    self.explosive = explosive
    self.lifetime = lifetime
    
    self.SIZE = Vector(1, 1)
    self.SPEED = 500
    
    self.shape = self.collider:addCircle(self.position.x, self.position.y, 10)
    self.shape.lifetime = 1
    self.shape.velocity = Vector(self.direction) * 200
    self.shape.kind = "flame"
    self.collider:addToGroup("friend", self.shape)
    self.shape:moveTo(position.x, position.y)

    self.image = love.graphics.newImage("assets/fireparticle.png")

    self:reset()
 end)
 
function Fire:reset()
    self.dead = false
    self.zombie = false
end

function Fire:kill()
    self.collider:remove(self.shape)
    self.zombie = true
end

function Fire:update(dt)
    self.lifetime = self.lifetime - dt

    local position = Vector(self.shape:center())

    position = position + self.direction * self.SPEED * dt

    if self.lifetime < 0 then
        self.dead = true
    end
    
    -- Destroy when outside the world bounds.
    if position.x > Constants.WORLD.x - 1 or
       position.x < 0 or
       position.y > Constants.WORLD.y - 1 or
       position.y < 0 then
        self.dead = true
    end

    self.shape:moveTo(position.x, position.y)
end

function Fire:draw()
    --[[ Don't draw "fire"
    local position = Vector(self.shape:center())

    love.graphics.draw(self.image,
        position.x, position.y,
        math.atan2(self.direction.y, self.direction.x) + math.pi / 2,
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
    --]]
end

return Fire