local Gamestate = require "hump.gamestate"
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

local PlayState = Gamestate.new()

function PlayState:init()
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
    self.ground = Ground(self.cam)

    -- Load curiosity.
    self.curiosity = Curiosity(self.collider, self.cam, self.entities)
    self.entities:register(self.curiosity)

    -- Move the camera over curiosity.
    self.cam:teleport(self.curiosity:getPosition())
    
    -- Load other rovers (for now)
    self.spirit = Spirit(self.collider, self.curiosity, self.cam, self.entities)
    self.entities:register(self.spirit)
    self.opportunity = Opportunity(self.collider, self.curiosity, self.cam, self.entities)
    self.entities:register(self.opportunity)
    self.gibson = Gibson(self.collider, self.curiosity, self.cam, self.entities)
    self.entities:register(self.gibson)

    self.minimap = MiniMap(self.entities)
    self.talkbox = TalkBox()
end

function PlayState:enter(previous)
    self.lastFpsTime = 0
    self:SpawnVikings(self.entities)
    self.talkbox:olmecTalk(Constants.OLMECSUBJECT_INTRO)
end

function PlayState:leave()
    -- Nothing yet.
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
end

function PlayState:collide(dt, shape1, shape2, mtvX, mtvY)
    local laser, enemy

    if shape1.kind == "laser" then
        laser = self.entities:findByShape(shape1)
    elseif shape1.kind == "viking" then
        enemy = self.entities:findByShape(shape1)
    end

    if shape2.kind == "laser" then
        laser = self.entities:findByShape(shape2)
    elseif shape2.kind == "viking" then
        enemy = self.entities:findByShape(shape2)
    end

    if laser and enemy then
        enemy:takeDamage(Constants.LASER_DAMAGE)
        laser:kill()
    end
end

function PlayState:collideStop(dt, shape1, shape2)
    local laser, enemy

    if shape1.kind == "laser" then
        laser = self.entities:findByShape(shape1)
    elseif shape1.kind == "viking" then
        enemy = self.entities:findByShape(shape1)
    end

    if shape2.kind == "laser" then
        laser = self.entities:findByShape(shape2)
    elseif shape2.kind == "viking" then
        enemy = self.entities:findByShape(shape2)
    end

    if laser and laser.zombie then
        laser.dead = true
    end

    if enemy and enemy.zombie then
        enemy.dead = true
    end
end

function PlayState:keypressed(key)
    -- TODO
end

function PlayState:mousepressed(x, y, button)
    -- TODO
end

function PlayState:mousereleased(x, y, button)
    -- TODO
end

function PlayState:SpawnVikings(entities)
    local pos = Vector(0,0)
    local min = Vector(self.cam.camera:worldCoords(0, 0))
    local max = Vector(self.cam.camera:worldCoords(Constants.SCREEN.x - 1, Constants.SCREEN.y - 1))
    -- vikes from top and bottom
    for i = 1,math.ceil(Constants.VIKING_NUM_TO_SPAWN/2) do
        pos.x = math.random(min.x, max.x)
        if math.random() < 0.5 then
            pos.y = max.y + Constants.VIKING_SPAWN_OFFSET_OFF_SCREEN
        else
            pos.y = min.y - Constants.VIKING_SPAWN_OFFSET_OFF_SCREEN
        end
        entities:register(Viking(self.collider, self.curiosity, pos, false))
    end
    -- vikes from left and right
    for i = 1,Constants.VIKING_NUM_TO_SPAWN-(Constants.VIKING_NUM_TO_SPAWN/2) do
        pos.y = math.random(min.y, max.y)
        if math.random() < 0.5 then
            pos.x = max.x + Constants.VIKING_SPAWN_OFFSET_OFF_SCREEN
        else
            pos.x = min.x - Constants.VIKING_SPAWN_OFFSET_OFF_SCREEN
        end
        entities:register(Viking(self.collider, self.curiosity, pos, true))
    end
end

return PlayState
