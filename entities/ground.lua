local Class = require "hump.class"
local Vector = require "hump.vector"
local Constants = require "constants"

local Ground = Class(function(self, media, camera)
    self.camera = camera

    self.TILE_SIZE = Vector(200, 200)

    self.ground_tile = media.GROUND_TILE
    self.border_tile = media.BORDER_TILE
end)

function Ground:draw()
    -- Figure out start and stop positions for tile drawing.
    local min = Vector(self.camera.camera:worldCoords(0, 0))
    local max = Vector(self.camera.camera:worldCoords(Constants.SCREEN.x - 1, Constants.SCREEN.y - 1))

    min.x = min.x - (min.x % self.TILE_SIZE.x)
    min.y = min.y - (min.y % self.TILE_SIZE.y)

    max.x = max.x - (max.x % self.TILE_SIZE.x)
    max.y = max.y - (max.y % self.TILE_SIZE.y)

    for i = min.x, max.x, self.TILE_SIZE.x do
        for j = min.y, max.y, self.TILE_SIZE.y do
            if i >= Constants.WORLD.x or i < 0 or j >= Constants.WORLD.y or j < 0 then
                love.graphics.draw(self.border_tile, i, j, 0, 1, 1, 0, 0, 0, 0)
            else
                love.graphics.draw(self.ground_tile, i, j, 0, 1, 1, 0, 0, 0, 0)
            end
        end
    end
end

return Ground
