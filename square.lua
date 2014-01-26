Class = require("libs.hump.class")

require("loadable")

Square = Class{__includes=Loadable,
  defaults = {
    name = "missingno",
    pos = vector(0,0),
    size = 0,
    color = {0, 0, 0},
    elevation = 0,
    depth = 10,
    collisionRect = {}
  }
}

function Square:getCollisionRect(  )
  -- next() returns false if table is empty
  if not next(self.collisionRect) then
    return self.pos.x, self.pos.y, self.elevation, self.size, self.depth, self.size
  else
    return unpack(self.collisionRect)
  end

end

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