local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Ground = Class(function(self, camera)
    self.camera = camera

    self.TILE_SIZE = Vector(200, 200)

    self.tile = love.graphics.newImage("assets/groundtile.png")
end)

function Ground:draw()
    -- Figure out start and stop positions for tile drawing.
    min = Vector(self.camera.camera:worldCoords(0, 0))
    max = Vector(self.camera.camera:worldCoords(Constants.SCREEN.x - 1, Constants.SCREEN.y - 1))

    min.x = min.x - (min.x % 200)
    min.y = min.y - (min.y % 200)

    max.x = max.x - (max.x % 200)
    max.y = max.y - (max.y % 200)

    for i = min.x, max.x, self.TILE_SIZE.x do
        for j = min.y, max.y, self.TILE_SIZE.y do
            love.graphics.draw(self.tile, i, j, 0, 1, 1, 0, 0, 0, 0)
        end
    end
end

return Ground
