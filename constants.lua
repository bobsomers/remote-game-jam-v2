local Vector = require "hump.vector"

local Constants = {}

-- Game info.
Constants.TITLE = "Revenge of Olmec (Chan)"
Constants.AUTHOR = "Bob Somers, Ryan Schmitt, Tim Adam, and Paul Morales"

-- Screen dimensions.
Constants.SCREEN = Vector(800, 600)
Constants.CENTER = Constants.SCREEN / 2

-- World settings.
Constants.WORLD = Vector(1000, 1000)

-- Debug mode.
Constants.DEBUG_MODE = true

-- Player settings.
Constants.CURIOSITY_SPEED = 100 -- 100 pixels/sec
Constants.CURIOSITY_TURN_SPEED = math.pi / 3 -- pi/3 radians/sec
Constants.CURIOSITY_FRAME_DURATION = 0.1 -- 1/10 of a sec
Constants.CURIOSITY_BASE_FIRE_RATE = 0.7 -- 0.7 sec between lasers
Constants.CURIOSITY_HEALTH = 100 -- 100 hit points

-- Laser weapon settings.
Constants.LASER_SPEED = 250 -- 250 pixels/sec

-- Gameplay variabls things.
Constants.HELPER_SPEED = 120
Constants.HELPER_FRAME_DURATION = 0.1 -- 1/10 of a sec
Constants.HELPER_MINIMUM_DISTANCE = 150

-- Melee Viking data
Constants.MELEE_VIKING_HP = 100
Constants.MELEE_VIKING_SPEED = 100
Constants.MELEE_VIKING_FRAME_DURATION = 0.1 -- 1/10 of a sec

-- Olmec Chan's speech thing
Constants.OLMEC_SPEECH_TIME = 400

-- Olmec Chan's topics of interest
Constants.OLMECSUBJECT_INTRO = "INTRO"
Constants.OLMECSUBJECT_WORLD = "WORLD"
Constants.OLMECSUBJECT_TEMPLE = "TEMPLE"
Constants.OLMECSUBJECT_ROVER = "ROVER"
Constants.OLMECSUBJECT_FIGHT = "FIGHT"
Constants.OLMECSUBJECT_DEFEAT = "DEFEAT"

-- Olmec Chan's lines.
Constants.OLMECTALK_INTRO = "Earth sends another metal man to this planet. Welcome to die!"
Constants.OLMECTALK_INTRO_MP3 = "assets/olmecSpeaks/earthsendsanothermetalman.mp3"

Constants.OLMECTALK_WORLD1 = "Curiously, there are no cats on Mars."
Constants.OLMECTALK_WORLD1_MP3 = "assets/olmecSpeaks/curiouslytherearenocatsonmars.mp3"

Constants.OLMECTALK_WORLD2 = "You should try anti-gravity. I'd let you borrow the book, but it's hard to put down."
Constants.OLMECTALK_WORLD2_MP3 = "assets/olmecSpeaks/youshouldtryantigravity.mp3"

Constants.OLMECTALK_WORLD3 = "There's a giant pit over there. Wouldn't you be curious to see what's at the bottom?"
Constants.OLMECTALK_WORLD3_MP3 = "assets/olmecSpeaks/theresagiantpitoverthere.mp3"

Constants.OLMECTALK_WORLD4 = "What do you call a lost Mars rover? Rusty."
Constants.OLMECTALK_WORLD4_MP3 = "assets/olmecSpeaks/whatdoyoucallalostmarsrover.mp3"

Constants.OLMECTALK_TEMPLE1 = "I locked the other ones away. You could say they've had a hard time."
Constants.OLMECTALK_TEMPLE1_MP3 = "assets/olmecSpeaks/ilockedtheothersaway.mp3"

Constants.OLMECTALK_TEMPLE2 = "You should step aside. This temple has stairs!"
Constants.OLMECTALK_TEMPLE2_MP3 = "assets/olmecSpeaks/youshouldstepaside.mp3"

Constants.OLMECTALK_TEMPLE3 = "You should've talked to those Vikings. Too bad you don't know Norse Code."
Constants.OLMECTALK_TEMPLE3_MP3 = "assets/olmecSpeaks/youshouldvetalkedtothosevikings.mp3"

Constants.OLMECTALK_ROVER1 = "Your antennae make a good couple. I'm sure it'd be a great reception."
Constants.OLMECTALK_ROVER1_MP3 = "assets/olmecSpeaks/yourantennaemakeagoodcouple.mp3"

Constants.OLMECTALK_ROVER2 = "There was an opportunity to say something here, but I may have missed it."
Constants.OLMECTALK_ROVER2_MP3 = "assets/olmecSpeaks/therewasanopporunitytosaysomething.mp3"

Constants.OLMECTALK_ROVER3 = "Watch out! It's been hacked!"
Constants.OLMECTALK_ROVER3_MP3 = "assets/olmecSpeaks/watchoutthegibsonsbeenhacked.mp3"

Constants.OLMECTALK_FIGHT = "Stunned? Don't be. I'm stone cold."
Constants.OLMECTALK_FIGHT_MP3 = "assets/olmecSpeaks/stunneddontbe.mp3"

Constants.OLMECTALK_DEFEAT = "Defeated?! Inconceivable!!"
Constants.OLMECTALK_DEFEAT_MP3 = "assets/olmecSpeaks/defeatedinconceivable.mp3"

return Constants
