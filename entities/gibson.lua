local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Laser = require "entities.laser"

local Gibson = Class(function(self, collider, curiosity, camera, entities)
    self.collider = collider
    self.curiosity = curiosity
    self.camera = camera
    self.entities = entities

    self.SIZE = Vector(20, 20)
    self.MOVE_SPEED = Constants.HELPER_SPEED
    self.FRAME_DURATION = Constants.HELPER_FRAME_DURATION

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "gibson"
    self.collider:addToGroup("gibson", self.shape)

    self.frames = {
        love.graphics.newImage("assets/gibson1.png"),
        love.graphics.newImage("assets/gibson2.png")
    }

    self.head = love.graphics.newImage("assets/gibsonhead.png")
    
    self:reset()
end)

function Gibson:reset()
    self.shape:moveTo(50, 150)
    
    self.headRotation = 0

    self.frame = 0
    self.frameTime = 0

    self.fireTime = 0
    self.fireRate = Constants.CURIOSITY_BASE_FIRE_RATE
    
    self.explosive = false
end

function Gibson:update(dt)
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
    if distance > (Constants.HELPER_MINIMUM_DISTANCE - 50) then
        self.shape:moveTo(position.x, position.y)
    end
    
    local mouseX, mouseY = self.camera.camera:worldCoords(love.mouse.getX(), love.mouse.getY())
    local dx = mouseX - position.x
    local dy = mouseY - position.y
    self.headRotation = math.atan2(dy, dx) + math.pi / 2

    self.fireTime = self.fireTime + dt
    if love.mouse.isDown("l") and self.fireTime > self.fireRate then
        self.entities:register(
            Laser(self.collider, position,
                  Vector(math.cos(self.headRotation - math.pi / 2),
                         math.sin(self.headRotation - math.pi / 2)),
                  self.explosive
            )
        )
        
        self.fireTime = 0
    end
end

function Gibson:draw()
    local position = Vector(self.shape:center())
    local curiosityPosition = self.curiosity:getPosition()
    local dx = curiosityPosition.x - position.x
    local dy = curiosityPosition.y - position.y
    local rotation = math.atan2(dy, dx) + math.pi / 2
    love.graphics.draw(self.frames[self.frame + 1],
        position.x, position.y,
        rotation,
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
        8, 10,
        0, 0
    )
end

return Gibson
