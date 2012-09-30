local Class = require "hump.class"

local Media = Class(function(self)
    self.LASER = love.graphics.newImage("assets/laserbullet.png")
    self.FIRE_PARTICLE = love.graphics.newImage("assets/fireparticle.png")
    self.VIKING_ARROW = love.graphics.newImage("assets/arrow.png")

    self.CURIOSITY_FRAMES = {
        love.graphics.newImage("assets/curiosity1.png"),
        love.graphics.newImage("assets/curiosity2.png"),
        love.graphics.newImage("assets/curiosity3.png")
    }
    self.CURIOSITY_HEAD = love.graphics.newImage("assets/curiosityhead.png")

    self.GIBSON_FRAMES = {
        love.graphics.newImage("assets/gibson1.png"),
        love.graphics.newImage("assets/gibson2.png")
    }
    self.GIBSON_HEAD = love.graphics.newImage("assets/gibsonhead.png")

    self.OPPORTUNITY_FRAMES = {
        love.graphics.newImage("assets/opportunity1.png"),
        love.graphics.newImage("assets/opportunity2.png")
    }
    self.OPPORTUNITY_HEAD = love.graphics.newImage("assets/opportunityhead.png")

    self.SPIRIT_FRAMES = {
        love.graphics.newImage("assets/spirit1.png"),
        love.graphics.newImage("assets/spirit2.png")
    }
    self.SPIRIT_HEAD = love.graphics.newImage("assets/spirithead.png")

    self.GROUND_TILE = love.graphics.newImage("assets/groundtile.png")
    self.BORDER_TILE = love.graphics.newImage("assets/groundtile2.png")

    self.ROVER_LASER = love.graphics.newImage("assets/roverlaser.png")

    self.ROVER_MISSILE = love.graphics.newImage("assets/rovermissile.png")

    self.TALKBOX_FACE = love.graphics.newImage("assets/talkface.png")
    self.TALKBOX_MOUTH = love.graphics.newImage("assets/talkmouth.png")

    self.TALKBOX_FONT = love.graphics.newFont("assets/spacefont.ttf", 24)

    self.RANGED_VIKING_FRAMES = {
        love.graphics.newImage("assets/rangedviking1.png"),
        love.graphics.newImage("assets/rangedviking2.png")
    }
    self.MELEE_VIKING_FRAMES = {
        love.graphics.newImage("assets/meleeviking1.png"),
        love.graphics.newImage("assets/meleeviking2.png")
    }

    self.TEMPLE_IMAGES = {
        love.graphics.newImage("assets/ruins1.png"),
        love.graphics.newImage("assets/ruins2.png"),
        love.graphics.newImage("assets/ruins3.png")
    }

    self.WEAK_LASER = love.audio.newSource("assets/weaklaser.wav", "static")
    self.WEAK_LASER:setVolume(0.3)
    self.FAST_LASER = love.audio.newSource("assets/fastlaser.wav", "static")
    self.FAST_LASER:setVolume(0.3)
    self.TRIPLE_LASER = love.audio.newSource("assets/triplelaser.wav", "static")
    self.TRIPLE_LASER:setVolume(0.3)

    self.MISSILE_LAUNCH = love.audio.newSource("assets/missilelaunch.wav", "static")
    self.MISSILE_LAUNCH:setVolume(0.3)

    self.BEAM = love.audio.newSource("assets/beam.wav", "static")
    self.BEAM:setVolume(0.5)
	
	self.ARROW = love.audio.newSource("assets/whoosh2.wav", "static");
	self.ARROW:setVolume(0.5)

	self.THUD = love.audio.newSource("assets/thud.wav", "static");
	self.THUD:setVolume(0.9)
	
	self.EXPLODE = love.audio.newSource("assets/bomb.wav", "static");
	self.EXPLODE:setVolume(0.5)
	
	self.DEATH = love.audio.newSource("assets/Fireball.wav", "static");
	self.DEATH:setVolume(0.9)

	self.HITBYLASER = love.audio.newSource("assets/cut.wav", "static");
	self.HITBYLASER:setVolume(0.5)
	
    self.UPGRADE = love.audio.newSource("assets/upgrade.wav", "static")
    self.UPGRADE:setVolume(0.5)

    self.PARTICLE = love.graphics.newImage("assets/particle.png")
end)

return Media
