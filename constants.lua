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

return Constants
