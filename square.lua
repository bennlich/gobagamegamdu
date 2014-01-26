Class = require("libs.hump.class")

require("loadable")
require("label")

Square = Class{__includes=Loadable,
  defaults = {
    pos = vector(0,0),
    size = 0,
    color = {0, 0, 0},
    elevation = 0,
    thickness = 10,
    name = "missingno"
  },
  init = function(self, opts)
    Loadable.init(self, opts)
    self.label = Label({
      base = self,
      content = "a square"
    })
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

  self.label:draw(camera)
end