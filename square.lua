Class = require("libs.hump.class")

Square = Class{
  init = function(self, pos, size, color, elevation)
    self.pos = (vector.isvector(pos) and pos) or vector(unpack(pos))
    self.size = size
    self.color = color
    self.elevation = elevation or 0
  end
}

function Square:update(dt)
  -- body
end

function Square:draw(camera)
  love.graphics.setColor(self.color)
  love.graphics.push()
  local groundPos = camera:transformCoords(self.pos.x, self.pos.y)
  -- draw the character from the head down
  local headY = groundPos.y - self.size - self.elevation
  love.graphics.rectangle("fill", groundPos.x, headY, self.size, self.size)
  love.graphics.pop()
end

