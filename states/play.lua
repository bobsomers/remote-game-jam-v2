local Gamestate = require "hump.gamestate"
local Constants = require "constants"
local Collider = require "hardoncollider"
local GameCam = require "entities.gamecam"
local Curiosity = require "entities.curiosity"
local Spirit = require "entities.spirit"
local Opportunity = require "entities.opportunity"
local Gibson = require "entities.gibson"
local Ground = require "entities.ground"
local Vector = require "hump.vector"

local PlayState = Gamestate.new()

-- TODO make a list of enemies or some shit
local TempViking = require "entities.viking"

function PlayState:init()
    -- Forward collision detection to self method.
    self.collider = Collider(100, function(dt, shape1, shape2, mtvX, mtvY)
        self:collide(dt, shape1, shape2, mtvX, mtvY)
    end)

    -- Game camera.
    self.cam = GameCam()

    -- Load the map stuff
    self.ground = Ground()

    -- Load curiosity.
    self.curiosity = Curiosity(self.collider, self.cam)
    
    -- Load other rovers (for now)
    self.spirit = Spirit(self.collider, self.curiosity)
    self.opportunity = Opportunity(self.collider, self.curiosity)
    self.gibson = Gibson(self.collider, self.curiosity)

    -- Load temp viking
    self.tempViking = TempViking(self.collider, Vector(750, 510))

    -- Initialize all the crap Olmec Chan says
    self.olmecSays = ""
    self.olmecSpeakTime = 0

    -- Initialize the subjects that have more than one line
    self.olmecWorldLines = {Constants.OLMECTALK_WORLD1, Constants.OLMECTALK_WORLD2, Constants.OLMECTALK_WORLD3, Constants.OLMECTALK_WORLD4}
    self.olmecTempleLines = {Constants.OLMECTALK_TEMPLE1, Constants.OLMECTALK_TEMPLE2, Constants.OLMECTALK_TEMPLE3}
    self.olmecRoverLines = {Constants.OLMECTALK_ROVER1, Constants.OLMECTALK_ROVER2, Constants.OLMECTALK_ROVER3}
    
    self:olmecTalk(Constants.OLMECSUBJECT_INTRO)

    -- Move the camera over curiosity.
    self.cam:teleport(self.curiosity:getPosition())
end

function PlayState:enter(previous)
    self.lastFpsTime = 0

    -- TODO
end

function PlayState:leave()
    -- TODO
end

function PlayState:update(dt)
    dt = math.min(dt, 1/15) -- Minimum 15 FPS.

    self.curiosity:update(dt)
    self.spirit:update(dt)
    self.opportunity:update(dt)
    self.gibson:update(dt)

    self.tempViking:update(dt) --TODO remove

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
    self.curiosity:draw()
    self.spirit:draw()
    self.opportunity:draw()
    self.gibson:draw()

    self.tempViking:draw() --TODO remove
    
    self.cam:detach()

    -- Draw things in screen space.
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
    end
end

return PlayState
