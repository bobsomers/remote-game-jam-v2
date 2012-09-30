local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Damage = require "entities.damage"
local TireTrack = require "entities.tiretrack"
local Flamethrower = require "entities.flamethrower"

local Gibson = Class(function(self, media, collider, curiosity, camera, entities)
    self.media = media
    self.collider = collider
    self.curiosity = curiosity
    self.camera = camera
    self.entities = entities

    self.SIZE = Vector(20, 20)
    self.MOVE_SPEED = Constants.HELPER_SPEED
    self.FRAME_DURATION = Constants.HELPER_FRAME_DURATION

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "gibson"
    self.collider:addToGroup("friend", self.shape)

    self.frames = self.media.GIBSON_FRAMES
    self.head = self.media.GIBSON_HEAD

    self.damage = Damage(self, Constants.ROVER_HEALTH, self.SIZE.x,
        Vector(-self.SIZE.x / 2, -self.SIZE.y / 2 - 5))

    self.rotation = 0
    
    self.flamethrower = Flamethrower(self, collider, entities)
    
    self:reset()
end)

function Gibson:reset()
    local where = self.curiosity:getPosition() - Vector(100, 100)
    self.shape:moveTo(where.x, where.y)
    
    self.headRotation = 0

    self.frame = 0
    self.frameTime = 0

    self.fireTime = 0
    self.fireRate = Constants.CURIOSITY_BASE_FIRE_RATE
    
    self.tireTrackTime = 0
    self.previousTracks = nil
end

function Gibson:getPosition()
    return Vector(self.shape:center())
end

function Gibson:getDirection()
    local position = self:getPosition()
    local mouseX, mouseY = self.camera.camera:worldCoords(love.mouse.getX(), love.mouse.getY())
    local dx = mouseX - position.x
    local dy = mouseY - position.y
    
    return math.atan2(dy, dx)
end

function Gibson:update(dt)
    local curiosityPosition = self.curiosity:getPosition()
    local position = self:getPosition()
    local dx = curiosityPosition.x - position.x
    local dy = curiosityPosition.y - position.y
    self.rotation = math.atan2(dy, dx) + math.pi / 2
 
    delta = Vector(0, 0)
    delta.y = delta.y - self.MOVE_SPEED * dt
    
    delta:rotate_inplace(self.rotation)
    position = position + delta

    local advancing = false
    distance = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2))
    if distance > (Constants.HELPER_MINIMUM_DISTANCE - 50) then
        self.shape:moveTo(position.x, position.y)
        advancing = true
    end
    
    local mouseX, mouseY = self.camera.camera:worldCoords(love.mouse.getX(), love.mouse.getY())
    local dx = mouseX - position.x
    local dy = mouseY - position.y
    self.headRotation = math.atan2(dy, dx) + math.pi / 2

    if love.mouse.isDown("l") then        
        self.flamethrower.firing = true
        self.flamethrower.particles:start()
    elseif love.mouse.isDown("l") == false then
        self.flamethrower.firing = false
        self.flamethrower.particles:stop()
    end

    if advancing then
        self.tireTrackTime = self.tireTrackTime + dt
        if self.tireTrackTime > 0.1 then
            self.previousTrack = TireTrack(self:getPosition(), self.rotation, self.previousTrack, true)
            self.entities:register(self.previousTrack)
            self.tireTrackTime = 0
        end
    end
    
    self.flamethrower:update(dt)
end

function Gibson:takeDamage(amount)
    self.damage.health = math.max(self.damage.health - amount, 0)
    if self.damage.health <= 0 then
        self.collider:remove(self.shape)
        self.zombie = true
        --Signal.emit("viking-death")
    end
end

function Gibson:draw()
    local position = self:getPosition()
    love.graphics.draw(self.frames[self.frame + 1],
        position.x, position.y,
        self.rotation,
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )
    
    local mouseX, mouseY = self.camera.camera:worldCoords(love.mouse.getX(), love.mouse.getY())
    local dx = mouseX - position.x
    local dy = mouseY - position.y
    local rot = math.atan2(dy, dx) + math.pi / 2
    
    love.graphics.draw(self.head,
        position.x, position.y,
        rot,
        1, 1,
        8, 10,
        0, 0
    )

    self.damage:draw()
    self.flamethrower:draw()
end

return Gibson
