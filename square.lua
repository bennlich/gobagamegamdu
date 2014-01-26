Class = require("libs.hump.class")

local params = {
  pos = vector(0,0),
  size = 0,
  color = {0, 0, 0},
  elevation = 0,
  collision_depth = 10,
  name = "missingno"
}

Square = Class{
  init = function(self, opts)
    for k,v in pairs(params) do
      -- Tries to load the number-versioned of parameters,
      -- then the unnumbered version, and then the defaults
      self[k] = (opts[world_vers] and opts[world_vers][k]) 
        or opts[k] 
        or params[k]
    end
    -- Lets you pass in either a vector or a pair of numbers
    self.pos = (vector.isvector(self.pos) and self.pos) 
                  or vector(unpack(self.pos))
  end
}

function Square:update(dt)
end

function Square:draw(camera)
  love.graphics.setColor(self.color)
  love.graphics.push()
  -- Get the lower-left coordinate
  local groundPos = camera:transformCoords(self.pos.x-self.size/2, self.pos.y)
  -- draw the character from the head down
  local headY = groundPos.y - self.size - self.elevation
  love.graphics.rectangle("fill", groundPos.x, headY, self.size, self.size)
  love.graphics.pop()
end