local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"
local Damage = require "entities.damage"
local Signal = require "hump.signal"
local VikingShot = require "entities.vikingshot"

local Viking = Class(function(self, media, entities, collider, curiosity, initialPos, isRanged)
    self.media = media
    self.entities = entities
    self.collider = collider
    self.curiosity = curiosity
    self.initialPos = initialPos
    self.isRanged = isRanged

    -- init constants
    self.SIZE = Vector(30, 30)
    if self.isRanged then
        self.MOVE_SPEED = math.random(Constants.RANGED_VIKING_MIN_SPEED, Constants.RANGED_VIKING_MAX_SPEED)
    else
        self.MOVE_SPEED = math.random(Constants.MELEE_VIKING_MIN_SPEED, Constants.MELEE_VIKING_MAX_SPEED)
    end
    self.FRAME_DURATION = Constants.VIKING_FRAME_DURATION
    self.OFFSET_RADS = math.pi/32


    -- collison detection
    self.shape = self.collider:addRectangle(0, 0, self.SIZE.x, self.SIZE.y)
    self.shape.kind = "viking"
    self.collider:addToGroup("foe", self.shape)

    -- sprite initialization
    if self.isRanged then
        self.frames = self.media.RANGED_VIKING_FRAMES
    else
        self.frames = self.media.MELEE_VIKING_FRAMES
    end

    local hp = 0
    if self.isRanged then
        hp = Constants.RANGED_VIKING_HEALTH
    else
        hp = Constants.MELEE_VIKING_HEALTH
    end
    self.damage = Damage(self, hp, self.SIZE.x, Vector(-self.SIZE.x / 2, -self.SIZE.y / 2 - 5))

    -- finish initialization by resetting
    self:reset()
end)

function Viking:reset()
    self.shape:moveTo(self.initialPos.x, self.initialPos.y)
    local initialDir = (self.curiosity:getPosition() - Vector(self.shape:center())):normalized()
    self.velocity = self.MOVE_SPEED * initialDir
    self.shape:setRotation((-math.pi/2)+math.atan2(self.velocity.y, self.velocity.x))
    self.chaseMode = true
    self.curDir = initialDir
    self.flankRotationAmt = 0

    -- shooting stuffs
    self.fireRate = Constants.RANGED_VIKING_FIRE_RATE
    self.fireTime = self.fireRate -- shoot right off the bat
    self.potShotFireRate = math.random(Constants.RANGED_VIKING_MIN_POT_SHOT_FIRE_RATE, Constants.RANGED_VIKING_MAX_POT_SHOT_FIRE_RATE)
    self.potShotTime = 0
    self.potShotDuration = Constants.RANGED_VIKING_POT_SHOT_DURATION
    self.isPotShotting = false
    self.potShotTaken = false

    -- melee stuffs
    if self.isRanged then
        self.meleeRate = Constants.RANGED_VIKING_MELEE_RATE
    else
        self.meleeRate = Constants.MELEE_VIKING_MELEE_RATE
    end
    self.meleeTime = self.meleeRate -- melee right off the bat

    -- animation data
    self.frame = 0
    self.frameTime = 0
end

function Viking:getPosition()
    return Vector(self.shape:center())
end

function Viking:takeDamage(amount)
    self.chaseMode = true
    self.damage.health = math.max(self.damage.health - amount, 0)
	
	love.audio.stop(self.media.HITBYLASER)
	love.audio.rewind(self.media.HITBYLASER)
	love.audio.play(self.media.HITBYLASER)
	
    if self.damage.health <= 0 then
        self.collider:remove(self.shape)
        self.zombie = true
        Signal.emit("viking-death")
    end
end

function Viking:meleeAttack(goodguy)
    if self.meleeTime > self.meleeRate then
        if self.isRanged then
            goodguy:takeDamage(Constants.RANGED_VIKING_MELEE_DAMAGE)
        else
            goodguy:takeDamage(Constants.MELEE_VIKING_DAMAGE)
        end
        self.meleeTime = 0
    end
end

function Viking:update(dt)
    -- calculate range and direction to curiosity
    local curiosityDir = self.curiosity:getPosition() - Vector(self.shape:center())
    local dist = curiosityDir:len()
    curiosityDir:normalize_inplace()

    -- always allow recharge, whether moving or not
    self.fireTime = self.fireTime + dt
    self.meleeTime = self.meleeTime + dt

    -- are we moving?
    local moving = true
    if self.isRanged then
        if dist < Constants.RANGED_VIKING_RANGE then
            moving = false
        end
    else
        if dist < Constants.MELEE_VIKING_RANGE then
            moving = false
        end
    end

    -- move or not
    if moving then
        -- choose what mode and direction
        if dist > Constants.VIKING_FLANK_RANGE and dist < Constants.VIKING_MAX_RANGE and self.chaseMode == true then
            self.chaseMode = false
            if math.random() < 0.5 then
                self.flankRotationAmt = math.pi/2 - self.OFFSET_RADS
            else
                self.flankRotationAmt = -math.pi/2 + self.OFFSET_RADS
            end
        elseif (dist < Constants.VIKING_FLANK_RANGE or dist > Constants.VIKING_MAX_RANGE) and self.chaseMode == false then
            self.chaseMode = true
        end

        -- update velocity and direction
        if self.chaseMode then
            self.curDir = curiosityDir
        else
            self.curDir = curiosityDir:rotated(self.flankRotationAmt)
        end
        self.velocity = self.MOVE_SPEED * self.curDir
        local newPos = Vector(self.shape:center()) + (self.velocity*dt)
        self.shape:setRotation((-math.pi/2)+math.atan2(self.velocity.y, self.velocity.x))

        -- bounce off walls
        if newPos.x > Constants.WORLD.x-1 or newPos.x < 0 or newPos.y > Constants.WORLD.y-1 or newPos.y < 0 then
            if self.flankRotationAmt > 0 then
                self.flankRotationAmt = -math.pi/2 + self.OFFSET_RADS
            else
                self.flankRotationAmt = math.pi/2 + self.OFFSET_RADS
            end
        end
        newPos.x = math.min(Constants.WORLD.x-1, math.max(0, newPos.x))
        newPos.y = math.min(Constants.WORLD.y-1, math.max(0, newPos.y))

        -- actually move now
        if not self.isPotShotting then
            self.shape:moveTo(newPos.x, newPos.y)
        end

        -- take a pot shot?
        if self.isRanged and self.chaseMode == false and not self.isPotShotting and self.fireTime > self.potShotFireRate then
            -- start shooting
            self.isPotShotting = true
        end
        if self.isPotShotting then
            -- face curiosity
            local curiosityDirRads = math.atan2(curiosityDir.y, curiosityDir.x)
            self.shape:setRotation((-math.pi/2)+curiosityDirRads)
            -- update pot shot time
            self.potShotTime = self.potShotTime + dt
            -- take potshot halfway through the potshot duration
            if self.isPotShotting and self.potShotTime > self.potShotDuration/2 and not self.potShotTaken then
                local rotation = curiosityDirRads +  math.pi / 2
                self.entities:register(
                    VikingShot(self.media, self.collider, self:getPosition(),
                               Vector(math.cos(rotation - math.pi / 2),
                                      math.sin(rotation - math.pi / 2)))
                )
                self.fireTime = 0
                self.potShotTaken = true
            end
            if self.potShotTime > self.potShotDuration then
                self.potShotTime = 0
                self.isPotShotting = false
                self.potShotTaken = false
            end
        end

        -- animate
        local animationSpeed = 0
        if self.isRanged then
            animationSpeed = Vector(Constants.RANGED_VIKING_MAX_SPEED, Constants.RANGED_VIKING_MAX_SPEED):len() / self.velocity:len()
        else
            animationSpeed = Vector(Constants.MELEE_VIKING_MAX_SPEED, Constants.MELEE_VIKING_MAX_SPEED):len() / self.velocity:len()
        end
        self.frameTime = self.frameTime + dt
        if self.frameTime > self.FRAME_DURATION*animationSpeed then
            self.frame = self.frame + 1
            self.frame = self.frame % 2
            self.frameTime = 0
        end
    elseif self.isRanged then
        -- turn
        local curiosityDirRads = math.atan2(curiosityDir.y, curiosityDir.x)
        self.shape:setRotation((-math.pi/2)+curiosityDirRads)
        -- shoot
        if self.fireTime > self.fireRate then
            local rotation = curiosityDirRads +  math.pi / 2
            self.entities:register(
                VikingShot(self.media, self.collider, self:getPosition(),
                           Vector(math.cos(rotation - math.pi / 2),
                                  math.sin(rotation - math.pi / 2)))
            )
            self.fireTime = 0
        end
    end
end

function Viking:draw()
    local pos = Vector(self.shape:center())
    local scale = Vector(self.SIZE.x/30.0, self.SIZE.y/30.0)
    love.graphics.draw(self.frames[self.frame + 1],
                       pos.x, pos.y,
                       self.shape:rotation(),
                       scale.x, scale.y,
                       15, 15, -- offset
                       0,0)   -- shearing

    self.damage:draw()
end

return Viking
