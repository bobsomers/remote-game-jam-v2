local Vector = require "hump.vector"

local Constants = {}

-- Game info.
Constants.TITLE = "Revenge of Olmec (Chan)"
Constants.AUTHOR = "Bob Somers, Ryan Schmitt, Tim Adam, and Paul Morales"

-- Screen dimensions.
Constants.SCREEN = Vector(800, 600)
Constants.CENTER = Constants.SCREEN / 2

-- Debug mode.
Constants.DEBUG_MODE = true

-- Olmec Chan's lines.
Constants.OLMECTALK.INTRO = "Earth sends another metal man to this planet. Welcome to die!"
Constants.OLMECTALK.WORLD1 = "Curiously, there are no cats on Mars."
Constants.OLMECTALK.WORLD2 = "You should try anti-gravity. I'd let you borrow the book, but it's hard to put down."
Constants.OLMECTALK.WORLD3 = "There's a giant pit over there. Wouldn't you be curious to see what's at the bottom?"
Constants.OLMECTALK.WORLD4 = "What do you call a lost Mars rover? Rusty."
Constants.OLMECTALK.TEMPLE1 = "I locked the other ones away. You could say they've had a hard time."
Constants.OLMECTALK.TEMPLE2 = "You should step aside. This temple has stairs!"
Constants.OLMECTALK.TEMPLE3 = "You should've talked to those Vikings. Too bad you don't know Norse Code."
Constants.OLMECTALK.ROVER1 = "Your antennae make a good couple. I'm sure it'd be a great reception."
Constants.OLMECTALK.ROVER2 = "There was an opportunity to say something here, but I may have missed it."
Constants.OLMECTALK.ROVER3 = "Watch out! It's been hacked!"
Constants.OLMECTALK.FIGHT = "Stunned? Don't be. I'm stone cold."
Constants.OLMECTALK.DEFEAT = "Defeated?! Inconceivable!!"

return Constants
