local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local RoverLaser = require "entities.roverlaser"
local Damage = require "entities.damage"
local TireTrack = require "entities.tiretrack"

local Spirit = Class(function(self, media, collider, curiosity, camera, entities)
    self.media = media
    self.collider = collider
    self.curiosity = curiosity
    self.camera = camera
    self.entities = entities

    self.SIZE = Vector(20, 20)
    self.MOVE_SPEED = Constants.HELPER_SPEED
    self.FRAME_DURATION = Constants.HELPER_FRAME_DURATION

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "spirit"
    self.collider:addToGroup("friend", self.shape)

    self.frames = self.media.SPIRIT_FRAMES
    self.head = self.media.SPIRIT_HEAD

    self.damage = Damage(self, Constants.ROVER_HEALTH, self.SIZE.x,
        Vector(-self.SIZE.x / 2, -self.SIZE.y / 2 - 5))

    self.rotation = 0
    
    self:reset()
end)

function Spirit:reset()
    local where = self.curiosity:getPosition() - Vector(100, 100)
    self.shape:moveTo(where.x, where.y)
    
    self.headRotation = 0

    self.frame = 0
    self.frameTime = 0

    self.fireTime = 0
    self.fireRate = Constants.SPIRIT_BASE_FIRE_RATE

    self.tireTrackTime = 0
    self.previousTracks = nil
end

function Spirit:getPosition()
    return Vector(self.shape:center())
end

function Spirit:update(dt)
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
    if distance > Constants.SPIRIT_MINIMUM_DISTANCE then
        self.shape:moveTo(position.x, position.y)
        advancing = true
    end
    
    local mouseX, mouseY = self.camera.camera:worldCoords(love.mouse.getX(), love.mouse.getY())
    local dx = mouseX - position.x
    local dy = mouseY - position.y
    self.headRotation = math.atan2(dy, dx) + math.pi / 2

    self.fireTime = self.fireTime + dt
    if love.mouse.isDown("l") and self.fireTime > self.fireRate then
        self.entities:register(
            RoverLaser(self.media, self.collider, position,
                  Vector(math.cos(self.headRotation - math.pi / 2),
                         math.sin(self.headRotation - math.pi / 2))
            )
        )
        
        self.fireTime = 0
    end

    if advancing then
        self.tireTrackTime = self.tireTrackTime + dt
        if self.tireTrackTime > 0.1 then
            self.previousTrack = TireTrack(self:getPosition(), self.rotation, self.previousTrack, true)
            self.entities:register(self.previousTrack)
            self.tireTrackTime = 0
        end
    end
end

function Spirit:takeDamage(amount)
    self.damage.health = math.max(self.damage.health - amount, 0)
    if self.damage.health <= 0 then
        self.collider:remove(self.shape)
        self.zombie = true
        --Signal.emit("viking-death")
    end
end

function Spirit:draw()    
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
        2, 18,
        0, 0
    )

    self.damage:draw()
end

return Spirit
