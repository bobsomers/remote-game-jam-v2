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
    self.olmecWorldAudioFiles = {Constants.OLMECTALK_WORLD1_MP3, Constants.OLMECTALK_WORLD2_MP3, Constants.OLMECTALK_WORLD3_MP3, Constants.OLMECTALK_WORLD4_MP3}
    self.olmecTempleLines = {Constants.OLMECTALK_TEMPLE1, Constants.OLMECTALK_TEMPLE2, Constants.OLMECTALK_TEMPLE3}
    self.olmecTempleAudioFiles = {Constants.OLMECTALK_TEMPLE1_MP3, Constants.OLMECTALK_TEMPLE2_MP3, Constants.OLMECTALK_TEMPLE3_MP3}
    self.olmecRoverLines = {Constants.OLMECTALK_ROVER1, Constants.OLMECTALK_ROVER2, Constants.OLMECTALK_ROVER3}
    self.olmecRoverAudioFiles = {Constants.OLMECTALK_ROVER1_MP3, Constants.OLMECTALK_ROVER2_MP3, Constants.OLMECTALK_ROVER3_MP3}
    
    self:olmecTalk(Constants.OLMECSUBJECT_INTRO)

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
        -- Something random so that Olmec Chan isn't always speaking
        i = math.random(1, 10)
        print("If this is greated than 8, you will get OLMEC CHAN: " .. i)
        if i > 8 then
            self:olmecTalk(Constants.OLMECSUBJECT_WORLD)
        else
            self.olmecSpeakTime = Constants.OLMEC_SPEECH_TIME
            self.olmecSays = ""
        end
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
            i = math.random(1, (table.getn(self.olmecWorldLines)))
            self.olmecSays = self.olmecWorldLines[i]
            self.olmecAudio = love.audio.newSource(self.olmecWorldAudioFiles[i], "stream")
        elseif subject == Constants.OLMECSUBJECT_TEMPLE then
            i = math.random(0, (table.getn(self.olmecTempleLines)))
            self.olmecSays = self.olmecTempleLines[i]
            self.olmecAudio = love.audio.newSource(self.olmecTempleAudioFiles[i], "stream")
        elseif subject == Constants.OLMECSUBJECT_ROVER then
            i = math.random(0, (table.getn(self.olmecRoverLines)))
            self.olmecSays = self.olmecRoverLines[i]
            self.olmecAudio = love.audio.newSource(self.olmecRoverAudioFiles[i], "stream")
        elseif subject == Constants.OLMECSUBJECT_FIGHT then
            self.olmecSays = Constants.OLMECTALK_FIGHT
            self.olmecAudio = love.audio.newSource(Constants.OLMECTALK_FIGHT_MP3, "stream")
        elseif subject == Constants.OLMECSUBJECT_DEFEAT then
            self.olmecSays = Constants.OLMECTALK_DEFEAT
            self.olmecAudio = love.audio.newSource(Constants.OLMECTALK_DEFEAT_MP3, "stream")
        end
        self.olmecSpeakTime = Constants.OLMEC_SPEECH_TIME
        self.olmecAudio:setVolume(1.0)
        self.olmecAudio:play()
    end
end

function PlayState:SpawnVikings()
    local vikings = {}
    local pos = Vector(0,0)
    local min = Vector(self.cam.camera:worldCoords(0, 0))
    local max = Vector(self.cam.camera:worldCoords(Constants.SCREEN.x - 1, Constants.SCREEN.y - 1))
    -- vikes from top and bottom
    for i = 1,Constants.MELEE_VIKING_NUM_TO_SPAWN/2 do
        pos.x = math.random(min.x, max.x)
        if math.random() < 0.5 then
            pos.y = max.y + Constants.MELEE_VIKING_SPAWN_OFFSET_OFF_SCREEN
        else
            pos.y = min.y - Constants.MELEE_VIKING_SPAWN_OFFSET_OFF_SCREEN
        end
        table.insert(vikings, Viking(self.collider, pos, self.curiosity:getPosition()-pos))
    end
    -- vikes from left and right
    for i = 1,Constants.MELEE_VIKING_NUM_TO_SPAWN-(Constants.MELEE_VIKING_NUM_TO_SPAWN/2) do
        pos.y = math.random(min.y, max.y)
        if math.random() < 0.5 then
            pos.x = max.x + Constants.MELEE_VIKING_SPAWN_OFFSET_OFF_SCREEN
        else
            pos.x = min.x - Constants.MELEE_VIKING_SPAWN_OFFSET_OFF_SCREEN
        end
        table.insert(vikings, Viking(self.collider, pos, self.curiosity:getPosition()-pos))
    end
    return vikings
end

return PlayState
