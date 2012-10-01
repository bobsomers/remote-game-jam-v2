local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Damage = require "entities.damage"
local OlmecBullet = require "entities.olmecbullet"

local OlmecChan = Class(function(self, media, collider, curiosity, play, entities, talkbox)
    self.media = media
    self.collider = collider
    self.curiosity = curiosity
    self.play = play
    self.entities = entities
    self.talkbox = talkbox

    self.SIZE = Vector(60, 60)
    self.ANGULAR_SPEED = Constants.OLMEC_ANGULAR_SPEED

    self.shape = self.collider:addCircle(0, 0, self.SIZE.x)
    self.shape.kind = "olmec"
    self.collider:addToGroup("foe", self.shape)

    self.closed = self.media.OLMEC_CLOSED
    self.open = self.media.OLMEC_OPEN

    self.damage = Damage(self, Constants.OLMEC_HEALTH, self.SIZE.x,
        Vector(-self.SIZE.x / 2, -self.SIZE.y / 2 - 5))

    self:reset()
end)

function OlmecChan:reset()
    self.fireTime = 0
    self.fireRate = Constants.OLMEC_FIRE_RATE
    
    self.waveTime = 0
    self.waveRate = Constants.OLMEC_VIKING_RATE
    self.waveAmount = Constants.OLMEC_VIKING_AMOUNT

    self.angle = 0
    self.distance = Constants.OLMEC_DISTANCE
    self.time = 0

    local position = self.curiosity:getPosition()
    position = position + Vector(self.distance, 0):rotated(self.angle)
    self.shape:moveTo(position.x, position.y)
end

function OlmecChan:getPosition()
    return Vector(self.shape:center())
end

function OlmecChan:takeDamage(amount)
    self.damage.health = math.max(self.damage.health - amount, 0)
	
    love.audio.stop(self.media.THUD)
    love.audio.rewind(self.media.THUD)
    love.audio.play(self.media.THUD)
	
    if self.damage.health <= 0 then
        self.collider:remove(self.shape)
        self.zombie = true

        -- TODO: you win?
		
		love.audio.stop(self.media.EXPLODE)
		love.audio.rewind(self.media.EXPLODE)
		love.audio.play(self.media.EXPLODE)
		love.audio.stop(self.media.DEATH)
		love.audio.rewind(self.media.DEATH)
		love.audio.play(self.media.DEATH)
        
        self.talkbox:reset()
        self.talkbox:olmecTalk(Constants.OLMECSUBJECT_DEFEAT)
    end
end

function OlmecChan:update(dt)
    self.angle = self.angle + self.ANGULAR_SPEED * dt

    self.time = self.time + dt
    self.distance = 100 * math.sin(self.time) + Constants.OLMEC_DISTANCE

    local position = self.curiosity:getPosition()
    position = position + Vector(self.distance, 0):rotated(self.angle)
    self.shape:moveTo(position.x, position.y)

    self.fireTime = self.fireTime + dt
    if self.fireTime > self.fireRate then
        self.entities:register(
            OlmecBullet(self.media, self.collider, self:getPosition(),
                (self.curiosity:getPosition() - position):normalize_inplace()
            )
        )
        self.fireTime = 0
    end

    self.waveTime = self.waveTime + dt
    if self.waveTime > self.waveRate then
        self.play:SpawnVikings(self.waveAmount)
        self.waveTime = 0
    end
end

function OlmecChan:draw()
    local position = self:getPosition()
    love.graphics.draw(self.closed,
        position.x, position.y,
        0,
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )

    self.damage:draw()
end

return OlmecChan
