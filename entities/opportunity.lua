local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local RoverMissile = require "entities.rovermissile"
local Damage = require "entities.damage"
local TireTrack = require "entities.tiretrack"

local Opportunity = Class(function(self, media, collider, curiosity, camera, entities)
    self.media = media
    self.collider = collider
    self.curiosity = curiosity
    self.camera = camera
    self.entities = entities

    self.SIZE = Vector(20, 20)
    self.MOVE_SPEED = Constants.HELPER_SPEED
    self.FRAME_DURATION = Constants.HELPER_FRAME_DURATION

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "opportunity"
    self.collider:addToGroup("friend", self.shape)

    self.frames = self.media.OPPORTUNITY_FRAMES
    self.head = self.media.OPPORTUNITY_HEAD

    self.damage = Damage(self, Constants.ROVER_HEALTH, self.SIZE.x,
        Vector(-self.SIZE.x / 2, -self.SIZE.y / 2 - 5))

    self.rotation = 0

    self:reset()
end)

function Opportunity:reset()
    local where = self.curiosity:getPosition() - Vector(100, 100)
    self.shape:moveTo(where.x, where.y)
    
    self.headRotation = 0

    self.frame = 0
    self.frameTime = 0

    self.fireTime = 0
    self.fireRate = Constants.OPPORTUNITY_BASE_FIRE_RATE

    self.tireTrackTime = 0
    self.previousTracks = nil
end

function Opportunity:getPosition()
    return Vector(self.shape:center())
end

function Opportunity:update(dt)
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
    if distance > (Constants.HELPER_MINIMUM_DISTANCE + 100) then
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
            RoverMissile(self.media, self.collider, position,
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

function Opportunity:draw()
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
        5, 15,
        0, 0
    )

    self.damage:draw()
end

return Opportunity
