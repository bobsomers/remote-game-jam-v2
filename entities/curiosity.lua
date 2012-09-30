local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Laser = require "entities.laser"
local Damage = require "entities.damage"
local TireTrack = require "entities.tiretrack"

local Curiosity = Class(function(self, collider, camera, entities)
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

    self.frames = {
        love.graphics.newImage("assets/curiosity1.png"),
        love.graphics.newImage("assets/curiosity2.png"),
        love.graphics.newImage("assets/curiosity3.png")
    }

    self.head = love.graphics.newImage("assets/curiosityhead.png")

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

    -- TODO: reset these to non-upgraded
    self.tripleFire = true
    self:upgradeFireRate()
    self.explosive = false

    self.damage.health = 50
end

function Curiosity:getPosition()
    return Vector(self.shape:center())
end

function Curiosity:upgradeFireRate()
    self.fireRate = self.fireRate / 3
end

function Curiosity:upgradeTripleFire()
    self.tripleFire = true
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
        self.entities:register(
            Laser(self.collider, self:getPosition(),
                  Vector(math.cos(self.headRotation - math.pi / 2),
                         math.sin(self.headRotation - math.pi / 2)),
                  self.explosive
            )
        )

        if self.tripleFire then
            self.entities:register(
                Laser(self.collider, self:getPosition(),
                      Vector(math.cos(self.headRotation - math.pi / 2 - math.pi / 15),
                             math.sin(self.headRotation - math.pi / 2 - math.pi / 15)),
                      self.explosive
                )
            )
            self.entities:register(
                Laser(self.collider, self:getPosition(),
                      Vector(math.cos(self.headRotation - math.pi / 2 + math.pi / 15),
                             math.sin(self.headRotation - math.pi / 2 + math.pi / 15)),
                      self.explosive
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
