local Class = require "hump.class"

local Ground = Class(function(self)
    self.tile = love.graphics.newImage("assets/groundtile.png")
end)

function Ground:draw()
    -- top row
    self:drawAt(0  ,0)
    self:drawAt(200,0)
    self:drawAt(400,0)
    self:drawAt(600,0)
    --
    self:drawAt(0  ,200)
    self:drawAt(200,200)
    self:drawAt(400,200)
    self:drawAt(600,200)
    --
    self:drawAt(0  ,400)
    self:drawAt(200,400)
    self:drawAt(400,400)
    self:drawAt(600,400)
end

function Ground:drawAt(x, y)
    love.graphics.draw(self.tile,
                       x,y,  -- position
                       0,    -- rotation
                       1,1,  -- scale
                       0,0,  -- offset
                       0,0) -- shearing
end

return Ground
