local Constants = require "constants"

function love.conf(t)
    -- Game info.
    t.title = Constants.TITLE
    t.author = Constants.AUTHOR

    -- Graphic settings.
    t.screen.width = Constants.SCREEN.x
    t.screen.height = Constants.SCREEN.y
    t.screen.vsync = true

    -- Show console on Windows?
    t.console = Constants.DEBUG_MODE
end
