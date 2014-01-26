Class = require("libs.hump.class")

require("loadable")
Pretty = require("pl.pretty")

Label = Class{__includes=Loadable,
  defaults = {
    base = {},
    content = "",
    font = love.graphics.getFont(),
    width = 100,
    elevationOffset = 15,
    color = {0,0,0}
  },
  init = function(self, opts)
    Loadable.init(self, opts)
    local width, lines = self.font:getWrap(self.content, self.width)
    self.height = self.font:getHeight() * lines
    self.pos = self.pos or vector(-self.width/2, 0)
  end
}

function Label:update(dt)
end

function Label:draw(camera)
  love.graphics.setColor(self.color)
  love.graphics.push()
  local base = self.base
  local groundPos = camera:transformCoords(base.pos.x + self.pos.x, base.pos.y + self.pos.y)
  local headY = groundPos.y - base.size - base.elevation
  local textY = headY - self.height - self.elevationOffset
  love.graphics.printf(self.content, groundPos.x, textY, self.width, "center")
  love.graphics.rectangle("line", groundPos.x, textY, self.width, self.height)
  love.graphics.pop()
end