local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local TalkBox = Class(function(self, media)
    self.FACE_SIZE = Vector(100, 100)
    self.BOX_SIZE = Vector(685, 100)
    self.OFFSET = Vector(5, 5)

    self.face = media.TALKBOX_FACE
    self.mouth = media.TALKBOX_MOUTH

    self.font = media.TALKBOX_FONT

    self:reset()
end)

function TalkBox:reset()
    self.mouthOffset = 0
    self.mouthTime = 0

    self.olmecSays = ""
    self.olmecAudio = ""
    self.olmecSpeakTime = 0
    self.justTalked = false

    self.olmecWorldLines = {
        Constants.OLMECTALK_WORLD1,
        Constants.OLMECTALK_WORLD2,
        Constants.OLMECTALK_WORLD3,
        Constants.OLMECTALK_WORLD4
    }
    self.olmecWorldAudioFiles = {
        Constants.OLMECTALK_WORLD1_MP3,
        Constants.OLMECTALK_WORLD2_MP3,
        Constants.OLMECTALK_WORLD3_MP3,
        Constants.OLMECTALK_WORLD4_MP3
    }
    self.olmecTempleLines = {
        Constants.OLMECTALK_TEMPLE1,
        Constants.OLMECTALK_TEMPLE2,
        Constants.OLMECTALK_TEMPLE3
    }
    self.olmecTempleAudioFiles = {
        Constants.OLMECTALK_TEMPLE1_MP3,
        Constants.OLMECTALK_TEMPLE2_MP3,
        Constants.OLMECTALK_TEMPLE3_MP3
    }
    self.olmecRoverLines = {
        Constants.OLMECTALK_ROVER1,
        Constants.OLMECTALK_ROVER2,
        Constants.OLMECTALK_ROVER3
    }
    self.olmecRoverAudioFiles = {
        Constants.OLMECTALK_ROVER1_MP3,
        Constants.OLMECTALK_ROVER2_MP3,
        Constants.OLMECTALK_ROVER3_MP3
    }
end

function TalkBox:update(dt)
    self.mouthTime = self.mouthTime + dt
    self.mouthOffset = 5 * math.sin(self.mouthTime * 25) + 5

    if self.olmecSpeakTime > 0 then
        self.olmecSpeakTime = self.olmecSpeakTime - 1
    else
        -- Something random so that Olmec Chan isn't always speaking
        i = math.random(1, 10)
        if i > 6 and not self.justTalked then
            self:olmecTalk(Constants.OLMECSUBJECT_WORLD)
            self.justTalked = true
        else
            self.olmecSpeakTime = Constants.OLMEC_SPEECH_TIME
            self.olmecSays = ""
            self.justTalked = false
        end
    end
end

function TalkBox:draw()
    if self.olmecSays == "" then return end

    love.graphics.setColor(0, 0, 0, 128)

    love.graphics.rectangle("fill",
        self.OFFSET.x, Constants.SCREEN.y - 1 - self.BOX_SIZE.y - self.OFFSET.y,
        self.BOX_SIZE.x, self.BOX_SIZE.y
    )

    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 0, 0, 255)

    love.graphics.printf(self.olmecSays,
        self.OFFSET.x + self.FACE_SIZE.x + 10 + 1,
        Constants.SCREEN.y - 1 - self.BOX_SIZE.y - self.OFFSET.y + 10 + 1,
        565, "left"
    )

    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.printf(self.olmecSays,
        self.OFFSET.x + self.FACE_SIZE.x + 10,
        Constants.SCREEN.y - 1 - self.BOX_SIZE.y - self.OFFSET.y + 10,
        565, "left"
    )

    love.graphics.draw(self.face,
        self.OFFSET.x, Constants.SCREEN.y - 1 - self.BOX_SIZE.y - self.OFFSET.y,
        0, 1, 1, 0, 0
    )

    love.graphics.draw(self.mouth,
        self.OFFSET.x, Constants.SCREEN.y - 1 - self.BOX_SIZE.y - self.OFFSET.y + self.mouthOffset,
        0, 1, 1, 0, 0
    )
end

function TalkBox:olmecTalk(subject)
    -- If Olmec is speaking, shut him up and make him say something else
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

return TalkBox
