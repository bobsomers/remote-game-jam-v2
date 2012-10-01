local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Laser = require "entities.laser"
local Damage = require "entities.damage"
local TireTrack = require "entities.tiretrack"

local Curiosity = Class(function(self, media, collider, camera, entities)
    self.media = media
    self.collider = collider
    self.camera = camera
    self.entities = entities

    self.SIZE = Vector(50, 50)
    self.MOVE_SPEED = Constants.CURIOSITY_SPEED
    self.TURN_SPEED = Constants.CURIOSITY_TURN_SPEED
    self.FRAME_DURATION = Constants.CURIOSITY_FRAME_DURATION

    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "curiosity"
    self.collider:addToGroup("friend", self.shape)

    self.frames = self.media.CURIOSITY_FRAMES
    self.head = self.media.CURIOSITY_HEAD

    self.damage = Damage(self, Constants.CURIOSITY_HEALTH, self.SIZE.x,
        Vector(-self.SIZE.x / 2, -self.SIZE.y / 2 - 5))

    self:reset()
end)

function Curiosity:reset()
    self.health = 100
    self.shape:moveTo(Constants.WORLD.x/2, Constants.WORLD.y/2)

    self.headRotation = 0

    self.frame = 0
    self.frameTime = 0

    self.fireTime = 0
    self.fireRate = Constants.CURIOSITY_BASE_FIRE_RATE

    self.tireTrackTime = 0
    self.previousTracks = nil

    self.fastFire = false
    self.tripleFire = false
    self.explosive = false
end

function Curiosity:getPosition()
    return Vector(self.shape:center())
end

function Curiosity:upgradeFireRate()
    if not self.fastFire then
        self.fireRate = self.fireRate / Constants.CURIOSITY_FIRE_RATE_BONUS
        self.fastFire = true
    end
end

function Curiosity:upgradeTripleFire()
    self.tripleFire = true
end

function Curiosity:upgradeExplosive()
    self.explosive = true
end

function Curiosity:takeDamage(amount)
    self.damage.health = math.max(self.damage.health - amount, 0)
    if self.damage.health <= 0 then
        self.collider:remove(self.shape)
        self.zombie = true
        -- TODO Player death
        -- Signal.emit("viking-death")
    end
end

function Curiosity:update(dt)
    local position = Vector(self.shape:center())
    local moving = false
    local backward = false
    local advancing = false

    delta = Vector(0, 0)
    if love.keyboard.isDown("w") then
        delta.y = delta.y - Constants.CURIOSITY_SPEED * dt
        moving = true
        advancing = true
    elseif love.keyboard.isDown("s") then
        delta.y = delta.y + Constants.CURIOSITY_SPEED * dt
        moving = true
        backward = true
        advancing = true
    end

    if love.keyboard.isDown("a") then
        if backward then
            self.shape:rotate(self.TURN_SPEED * dt)
        else
            self.shape:rotate(-self.TURN_SPEED * dt)
        end
        moving = true
    end
    if love.keyboard.isDown("d") then
        if backward then
            self.shape:rotate(-self.TURN_SPEED * dt)
        else
            self.shape:rotate(self.TURN_SPEED * dt)
        end
        moving = true
    end

    delta:rotate_inplace(self.shape:rotation())
    local nextPos = position + delta

    -- Disallow moves outside the world bounds.
    if nextPos.x < Constants.WORLD.x - 1 and
       nextPos.x > 0 and
       nextPos.y < Constants.WORLD.y - 1 and
       nextPos.y > 0 then
        position = nextPos
    end

    self.shape:moveTo(position.x, position.y)

    if moving then
        self.frameTime = self.frameTime + dt
        if self.frameTime > self.FRAME_DURATION then
            self.frame = self.frame + 1
            self.frame = self.frame % 3
            self.frameTime = 0
        end
    end

    if advancing then
        self.tireTrackTime = self.tireTrackTime + dt
        if self.tireTrackTime > 0.1 then
            self.previousTrack = TireTrack(self:getPosition(), self.shape:rotation(), self.previousTrack, false)
            self.entities:register(self.previousTrack)
            self.tireTrackTime = 0
        end
    end

    local mouseX, mouseY = self.camera.camera:worldCoords(love.mouse.getX(), love.mouse.getY())
    local dx = mouseX - position.x
    local dy = mouseY - position.y
    self.headRotation = math.atan2(dy, dx) + math.pi / 2

    self.fireTime = self.fireTime + dt
    if love.mouse.isDown("l") and self.fireTime > self.fireRate then
        local upgrade = "weak"
        if self.tripleFire then
            upgrade = "triple"
        elseif self.fastFire then
            upgrade = "fast"
        end

        self.entities:register(
            Laser(self.media, self.collider, self:getPosition(),
                  Vector(math.cos(self.headRotation - math.pi / 2),
                         math.sin(self.headRotation - math.pi / 2)),
                  upgrade, false
            )
        )

        if self.tripleFire then
            self.entities:register(
                Laser(self.media, self.collider, self:getPosition(),
                      Vector(math.cos(self.headRotation - math.pi / 2 - math.pi / 15),
                             math.sin(self.headRotation - math.pi / 2 - math.pi / 15)),
                      upgrade, true
                )
            )
            self.entities:register(
                Laser(self.media, self.collider, self:getPosition(),
                      Vector(math.cos(self.headRotation - math.pi / 2 + math.pi / 15),
                             math.sin(self.headRotation - math.pi / 2 + math.pi / 15)),
                      upgrade, true
                )
            )
        end

        self.fireTime = 0
    end
end

function Curiosity:draw()
    local position = Vector(self.shape:center())
    love.graphics.draw(self.frames[self.frame + 1],
        position.x, position.y,
        self.shape:rotation(),
        1, 1,
        self.SIZE.x / 2, self.SIZE.y / 2,
        0, 0
    )

    love.graphics.draw(self.head,
        position.x, position.y,
        self.headRotation,
        1, 1,
        8, 7,
        0, 0
    )

    self.damage:draw()
end

return Curiosity
