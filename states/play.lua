local Gamestate = require "hump.gamestate"
local Constants = require "constants"

local PlayState = Gamestate.new()

local Ground = require "entities.ground"

function PlayState:init()
    -- TODO

    -- Load the map stuff
    self.ground = Ground()

    -- Initialize all the crap Olmec Chan says
    self.olmecSays = ""
    self.olmecSpeakTime = Constants.OLMEC_SPEECH_TIME

    -- Initialize the subjects that have more than one line
    self.olmecWorldLines = {Constants.OLMECTALK_WORLD1, Constants.OLMECTALK_WORLD2, Constants.OLMECTALK_WORLD3, Constants.OLMECTALK_WORLD4}
    self.olmecTempleLines = {Constants.OLMECTALK_TEMPLE1, Constants.OLMECTALK_TEMPLE2, Constants.OLMECTALK_TEMPLE3}
    self.olmecRoverLines = {Constants.OLMECTALK_ROVER1, Constants.OLMECTALK_ROVER2, Constants.OLMECTALK_ROVER3}
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

    -- TODO

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

    -- Update Olmec talk box
    if self.olmecSpeakTime > 0 then
        -- TODO: Olmec speaks!

        self.olmecSpeakTime = self.olmecSpeakTime - 1
    else
        self.olmecSpeakTime = 0
        self.olmecSays = ""
    end
end

function PlayState:draw()
    love.graphics.print("Hello remote game jam!", 200, 200)
    self.ground:draw()

    -- TODO
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
        if subject == "Constants.OLMECSUBJECT_INTRO" then
            self.olmecSays = Constants.OLMECTALK_INTRO
        elseif subject == "Constants.OLMECSUBJECT_WORLD" then
            i = math.random(0, (table.getn(self.olmecWorldLines)))
            self.olmecSays = self.olmecWorldLines[i]
        elseif subject == "Constants.OLMECSUBJECT_TEMPLE" then
            i = math.random(0, (table.getn(self.olmecTempleLines)))
            self.olmecSays = self.olmecTempleLines[i]
        elseif subject == "Constants.OLMECSUBJECT_ROVER" then
            i = math.random(0, (table.getn(self.olmecRoverLines)))
            self.olmecSays = self.olmecRoverLines[i]
        elseif subject == "Constants.OLMECSUBJECT_FIGHT" then
            self.olmecSays = Constants.OLMECTALK_FIGHT
        elseif subject == "Constants.OLMECSUBJECT_DEFEAT" then
            self.olmecSays = Constants.OLMECTALK_DEFEAT
        end
        olmecSpeakTime = Constants.OLMEC_SPEECH_TIME
    end
end

return PlayState
