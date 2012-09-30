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

local PlayState = Gamestate.new()

function PlayState:init()
    -- Forward collision detection to self method.
    self.collider = Collider(100, function(dt, shape1, shape2, mtvX, mtvY)
        self:collide(dt, shape1, shape2, mtvX, mtvY)
    end)

    -- Game camera.
    self.cam = GameCam()

    -- EntityManager.
    self.entities = EntityManager()

    -- Load the map stuff
    self.ground = Ground(self.cam)

    -- Load curiosity.
    self.curiosity = Curiosity(self.collider, self.cam)
    self.entities:register(self.curiosity)
    
    -- Load other rovers (for now)
    self.spirit = Spirit(self.collider, self.curiosity)
    self.entities:register(self.spirit)
    self.opportunity = Opportunity(self.collider, self.curiosity)
    self.entities:register(self.opportunity)
    self.gibson = Gibson(self.collider, self.curiosity)
    self.entities:register(self.gibson)

    -- Load viking manager
    self.vikings = self:SpawnVikings()
    for _, viking in ipairs(self.vikings) do
        self.entities:register(viking)
    end

    -- Initialize all the crap Olmec Chan says
    self.olmecSays = ""
    self.olmecAudio = ""
    self.olmecSpeakTime = 0

    -- Initialize the subjects that have more than one line
    self.olmecWorldLines = {Constants.OLMECTALK_WORLD1, Constants.OLMECTALK_WORLD2, Constants.OLMECTALK_WORLD3, Constants.OLMECTALK_WORLD4}
    self.olmecTempleLines = {Constants.OLMECTALK_TEMPLE1, Constants.OLMECTALK_TEMPLE2, Constants.OLMECTALK_TEMPLE3}
    self.olmecRoverLines = {Constants.OLMECTALK_ROVER1, Constants.OLMECTALK_ROVER2, Constants.OLMECTALK_ROVER3}
    
    self:olmecTalk(Constants.OLMECSUBJECT_INTRO)

    -- Move the camera over curiosity.
    self.cam:teleport(self.curiosity:getPosition())

    self.minimap = MiniMap(self.curiosity, self.vikings)
end

function PlayState:enter(previous)
    self.lastFpsTime = 0
    self:SpawnVikings()

    -- TODO
end

function PlayState:leave()
    -- TODO
end

function PlayState:update(dt)
    dt = math.min(dt, 1/15) -- Minimum 15 FPS.

    self.entities:update(dt)

    -- Update Olmec talk box
    if self.olmecSpeakTime > 0 then
        -- TODO: Olmec speaks!

        self.olmecSpeakTime = self.olmecSpeakTime - 1
    else
        self.olmecSpeakTime = 0
        self.olmecSays = ""
    end

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
    love.graphics.print(self.olmecSays, 50, 550)
end

function PlayState:collide(dt, shape1, shape2, mtvX, mtvY)
    -- TODO dispatch to collision resolvers
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

-- Stuff Olmec Chan Says
function PlayState:olmecTalk(subject)
    -- If Olmec is not currently speaking, sayeth something
    if self.olmecSpeakTime <= 0 then
        if subject == Constants.OLMECSUBJECT_INTRO then
            self.olmecSays = Constants.OLMECTALK_INTRO
            self.olmecAudio = love.audio.newSource(Constants.OLMECTALK_INTRO_MP3, "stream")
        elseif subject == Constants.OLMECSUBJECT_WORLD then
            i = math.random(0, (table.getn(self.olmecWorldLines)))
            self.olmecSays = self.olmecWorldLines[i]
        elseif subject == Constants.OLMECSUBJECT_TEMPLE then
            i = math.random(0, (table.getn(self.olmecTempleLines)))
            self.olmecSays = self.olmecTempleLines[i]
        elseif subject == Constants.OLMECSUBJECT_ROVER then
            i = math.random(0, (table.getn(self.olmecRoverLines)))
            self.olmecSays = self.olmecRoverLines[i]
        elseif subject == Constants.OLMECSUBJECT_FIGHT then
            self.olmecSays = Constants.OLMECTALK_FIGHT
        elseif subject == Constants.OLMECSUBJECT_DEFEAT then
            self.olmecSays = Constants.OLMECTALK_DEFEAT
        end
        self.olmecSpeakTime = Constants.OLMEC_SPEECH_TIME
        self.olmecAudio:setVolume(1.0)
        self.olmecAudio:play()
    end
end

function PlayState:SpawnVikings()
    local vikings = {}
    for i = 1, 5 do
        table.insert(vikings, Viking(self.collider, Vector(math.random(0,800), math.random(0,600))))
    end
    return vikings
end

return PlayState
