local Gamestate = require "hump.gamestate"
local Signal = require "hump.signal"
local Constants = require "constants"
local Collider = require "hardoncollider"
local GameCam = require "entities.gamecam"
local MiniMap = require "entities.minimap"
local Curiosity = require "entities.curiosity"
local Spirit = require "entities.spirit"
local Opportunity = require "entities.opportunity"
local Gibson = require "entities.gibson"
local Ground = require "entities.ground"
local Vector = require "hump.vector"
local EntityManager = require "entities.manager"
local Viking = require "entities.viking"
local TalkBox = require "entities.talkbox"
local Media = require "media"
local Crosshair = require "entities.crosshair"
local Temple = require "entities.temple"
local OlmecChan = require "entities.olmecchan"

local PlayState = Gamestate.new()

function PlayState:init()
    -- Load media library.
    self.media = Media()

    -- Forward collision detection to self method.
    self.collider = Collider(100, function(dt, shape1, shape2, mtvX, mtvY)
        self:collide(dt, shape1, shape2, mtvX, mtvY)
    end, function(dt, shape1, shape2)
        self:collideStop(dt, shape1, shape2)
    end)

    -- Game camera.
    self.cam = GameCam()

    -- EntityManager.
    self.entities = EntityManager()

    -- Load the map stuff
    self.ground = Ground(self.media, self.cam)

    -- Load curiosity.
    self.curiosity = Curiosity(self.media, self.collider, self.entities, self.cam, self.entities)
    self.entities:register(self.curiosity)

    -- Load temples.
    self.temple1 = Temple(self.media, self.collider, self.entities, self.curiosity, 1)
    self.entities:register(self.temple1)
    self.temple2 = Temple(self.media, self.collider, self.entities, self.curiosity, 2)
    self.entities:register(self.temple2)
    self.temple3 = Temple(self.media, self.collider, self.entities, self.curiosity, 3)
    self.entities:register(self.temple3)

    -- Move the camera over curiosity.
    self.cam:teleport(self.curiosity:getPosition())
    
    -- Load HUD things.
    self.minimap = MiniMap(self.entities, {
        self.temple1,
        self.temple2,
        self.temple3
    })
    self.talkbox = TalkBox(self.media)
    self.crosshair = Crosshair()

    -- Register signal listeners.
    Signal.register("temple-triggered", function(which)
        self:templeTriggered(which)
    end)
    Signal.register("viking-death", function()
        self:vikingDeath()
    end)
end

function PlayState:enter(previous)
    self.lastFpsTime = 0
    self.talkbox:olmecTalk(Constants.OLMECSUBJECT_INTRO)
    love.mouse.setVisible(false)
    
    -- MUSIC
    self.music = love.audio.newSource(Constants.MUSIC, "stream")
    self.music:setLooping(true)
    self.music:setVolume(0.7)
    self.music:play()
end

function PlayState:leave()
    love.mouse.setVisible(true)
end

function PlayState:update(dt)
    dt = math.min(dt, 1/15) -- Minimum 15 FPS.

    self.entities:update(dt)
    self.collider:update(dt)

    self.talkbox:update(dt)

    -- The camera follows curiosity.
    self.cam:focus(self.curiosity:getPosition())
    self.cam:update(dt)

    -- Update FPS in window title (if DEBUG MODE is on).
    if Constants.DEBUG_MODE then
        self.lastFpsTime = self.lastFpsTime + dt
        if self.lastFpsTime > 1 then
            love.graphics.setCaption(table.concat({
                Constants.TITLE,
                " (",
                love.timer.getFPS(),
                " FPS)"
            }))
            self.lastFpsTime = 0
        end
    end
end

function PlayState:draw()
    self.cam:attach()

    -- Draw things affected by the camera.
    self.ground:draw()
    self.entities:draw()

    self.cam:detach()

    -- Draw things in screen space.
    self.minimap:draw()
    self.talkbox:draw()
    self.crosshair:draw()
end

function PlayState:collide(dt, shape1, shape2, mtvX, mtvY)
    local laser, missile, beam, flame, enemy, vikingshot, goodguy,
          rangedViking, meleeViking, olmec, bullet

    -- find first entity
    if shape1.kind == "laser" then
        laser = self.entities:findByShape(shape1)
    elseif shape1.kind == "missile" then
        missile = self.entities:findByShape(shape1)
    elseif shape1.kind == "beam" then
        beam = self.entities:findByShape(shape1)
    elseif shape1.kind == "flame" then
        flame = self.entities:findByShape(shape1)
    elseif shape1.kind == "viking" then
        enemy = self.entities:findByShape(shape1)
    elseif shape1.kind == "vikingshot" then
        vikingshot = self.entities:findByShape(shape1)
    elseif shape1.kind == "olmec" then
        enemy = self.entities:findByShape(shape1)
    elseif shape1.kind == "bullet" then
        bullet = self.entities:findByShape(shape1)
    elseif shape1.kind == "curiosity" or
           shape1.kind == "opportunity" or
           shape1.kind == "spirit" or
           shape1.kind == "gibson" then
        goodguy = self.entities:findByShape(shape1)
    end

    -- find second entity
    if shape2.kind == "laser" then
        laser = self.entities:findByShape(shape2)
    elseif shape2.kind == "missile" then
        missile = self.entities:findByShape(shape2)
    elseif shape2.kind == "beam" then
        beam = self.entities:findByShape(shape2)
    elseif shape2.kind == "flame" then
        flame = self.entities:findByShape(shape1)
    elseif shape2.kind == "viking" then
        enemy = self.entities:findByShape(shape2)
    elseif shape2.kind == "vikingshot" then
        vikingshot = self.entities:findByShape(shape2)
    elseif shape2.kind == "olmec" then
        enemy = self.entities:findByShape(shape2)
    elseif shape2.kind == "bullet" then
        bullet = self.entities:findByShape(shape2)
    elseif shape1.kind == "curiosity" or
           shape1.kind == "opportunity" or
           shape1.kind == "spirit" or
           shape1.kind == "gibson" then
        goodguy = self.entities:findByShape(shape2)
    end

    -- collsion logic
    if laser and enemy then
        enemy:takeDamage(Constants.LASER_DAMAGE)
        laser:kill()
    elseif missile and enemy then
        enemy:takeDamage(Constants.ROVER_MISSILE_DAMAGE)
        missile:kill()
    elseif beam and enemy then
        enemy:takeDamage(Constants.ROVER_LASER_DAMAGE)
    elseif flame and enemy then
        enemy:takeDamage(Constants.ROVER_FLAME_DAMAGE)
    elseif goodguy and enemy and enemy.shape.kind ~= "olmec" then
        enemy:meleeAttack(goodguy)
    elseif goodguy and vikingshot then
        goodguy:takeDamage(Constants.RANGED_VIKING_SHOT_DAMAGE)
        vikingshot:kill()
    elseif goodguy and bullet then
        goodguy:takeDamage(Constants.OLMEC_DAMAGE)
        bullet:kill()
    end
end

function PlayState:collideStop(dt, shape1, shape2)
    local entity1 = self.entities:findByShape(shape1)
    local entity2 = self.entities:findByShape(shape2)

    if entity1.zombie then
        entity1.dead = true
    end
    if entity2.zombie then
        entity2.dead = true
    end
end

function PlayState:templeTriggered(which)
    self:SpawnVikings(Constants.TEMPLE_SPAWN_AMOUNT[which])
    self.talkbox:reset()
    self.talkbox:olmecTalk(Constants.OLMECSUBJECT_TEMPLE)
end

function PlayState:vikingDeath()
    -- If there are still vikings, no upgrades for you!
    for _, entity in ipairs(self.entities.entities) do
        if entity.shape and entity.shape.kind == "viking" and not entity.zombie then
            return
        end
    end

    -- Upgrades!
    if self.temple1.triggered then
        self.temple1.complete = true
        self.curiosity:upgradeFireRate()
        if not self.gibson then
            self.gibson = Gibson(self.media, self.collider, self.curiosity, self.cam, self.entities)
            self.entities:register(self.gibson)

            love.audio.stop(self.media.UPGRADE)
            love.audio.rewind(self.media.UPGRADE)
            love.audio.play(self.media.UPGRADE)
            
            self.talkbox:reset()
            self.talkbox:olmecTalk(Constants.OLMECSUBJECT_ROVER)
        end
    end
    if self.temple2.triggered then
        self.temple2.complete = true
        self.curiosity:upgradeTripleFire()
        if not self.opportunity then
            self.opportunity = Opportunity(self.media, self.collider, self.curiosity, self.cam, self.entities)
            self.entities:register(self.opportunity)

            love.audio.stop(self.media.UPGRADE)
            love.audio.rewind(self.media.UPGRADE)
            love.audio.play(self.media.UPGRADE)
            
            self.talkbox:reset()
            self.talkbox:olmecTalk(Constants.OLMECSUBJECT_ROVER)
        end
    end
    if self.temple3.triggered then
        self.temple3.complete = true
        self.curiosity:upgradeExplosive()
        if not self.spirit then
            self.spirit = Spirit(self.media, self.collider, self.curiosity, self.cam, self.entities)
            self.entities:register(self.spirit)

            love.audio.stop(self.media.UPGRADE)
            love.audio.rewind(self.media.UPGRADE)
            love.audio.play(self.media.UPGRADE)
            
            self.olmec = OlmecChan(self.media, self.collider, self.curiosity, self, self.entities, self.talkbox)
            self.entities:register(self.olmec)
            
            self.talkbox:reset()
            self.talkbox:olmecTalk(Constants.OLMECSUBJECT_FIGHT)
        end
    end
end

function PlayState:SpawnVikings(howMany)
    local pos = Vector(0,0)
    local min = Vector(self.cam.camera:worldCoords(0, 0))
    local max = Vector(self.cam.camera:worldCoords(Constants.SCREEN.x - 1, Constants.SCREEN.y - 1))
    -- vikes from top and bottom
    for i = 1,math.ceil(howMany/2) do
        pos.x = math.random(min.x, max.x)
        if math.random() < 0.5 then
            pos.y = max.y + Constants.VIKING_SPAWN_OFFSET_OFF_SCREEN
        else
            pos.y = min.y - Constants.VIKING_SPAWN_OFFSET_OFF_SCREEN
        end
        self.entities:register(Viking(self.media, self.entities, self.collider, self.curiosity, pos, false))
    end
    -- vikes from left and right
    for i = 1,howMany-(howMany/2) do
        pos.y = math.random(min.y, max.y)
        if math.random() < 0.5 then
            pos.x = max.x + Constants.VIKING_SPAWN_OFFSET_OFF_SCREEN
        else
            pos.x = min.x - Constants.VIKING_SPAWN_OFFSET_OFF_SCREEN
        end
        self.entities:register(Viking(self.media, self.entities, self.collider, self.curiosity, pos, true))
    end
end

return PlayState
