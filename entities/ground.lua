local Class = require "hump.class"

local Ground = Class(function(self)
    self.tile = love.graphics.newImage("assets/groundtile.png")
    self.quad = love.graphics.newQuad(0,0, 200, 200, 200, 200); -- describes the full image
end)

function Ground:draw()
    love.graphics.drawq(self.tile, self.quad,
                        0, 0, -- x,y pos
                        0,    -- rotation
                        1, 1, -- x,y scale
                        0, 0, -- x,y origin offset
                        0, 0) -- x,y shearing factor
end

return Ground
