Class = require("libs.hump.class")

require("loadable")
require("util")
require("colors")
Pretty = require("pl.pretty")

Label = Class{__includes=Loadable,
  defaults = {
    base = {},
    content = "",
    width = 0,
    elevationOffset = 15,
    color = {0,0,0}
  },
  init = function(self, opts)
    Loadable.init(self, opts)
    self.pos = self.pos or vector(0, 0)
  end, 
  triWidth = 15, triHeight = 10, 
  borderColor = {128,130,133},
  fillColor = colors.white,
  textColor = colors.black,
  perspectiveCorrection = 0.25,
  padding = 15
}

function Label.loadFont( )
  Label.font = love.graphics.newFont("resources/SourceCodePro-Light.ttf", 18)
end

function Label:getTextDimensions(  )
  if self.width == 0 then
    return self.font:getWidth(self.content), self.font:getHeight()
  else
    local width, lines = self.font:getWrap(self.content, self.width)
    local height = self.font:getHeight() * lines
    return width, height
  end
end

function Label:setContent( text )
  self.content = text
end

function Label:setWidth( width )
  self.width = width
end

function Label:update(dt)
end

function Label:draw(camera)
  local textWidth, textHeight = self:getTextDimensions()

  love.graphics.setColor(self.color)
  love.graphics.push()
  local base = self.base
  local groundPos = camera:transformCoords(base.pos.x + self.pos.x, base.pos.y + self.pos.y)
  local headY = groundPos.y - base.size - base.elevation
  love.graphics.translate(groundPos.x, headY)

  -- Text boxes don't scale in perspective normally.
  -- This is some magic to get the boxes to scale, but not the offset
  local textBoxOffset = -(textHeight + self.triHeight + self.elevationOffset + self.padding)
  local scale = camera:getScale(base.pos.y + self.pos.y)
  local scaleCorrection = (self.perspectiveCorrection + scale*(1-self.perspectiveCorrection))
  -- undo previous scale operation
  love.graphics.scale(1/scale, 1/scale)
  -- apply new perspective
  love.graphics.scale(scaleCorrection, scaleCorrection)
  love.graphics.translate(0, textBoxOffset)

  self:drawBox()
  love.graphics.setFont(Label.font)
  love.graphics.setColor(self.textColor)
  love.graphics.printf(self.content, -textWidth/2, 0, textWidth, "center")

  love.graphics.pop()
end

function Label:drawBox()
  local textWidth, textHeight = self:getTextDimensions()
  -- X is from the center, y is from the top.
  local w, h = textWidth + self.padding*2, textHeight + self.padding

  local leftVertices = {
    -w/2, -self.padding,
    -w/2, h
  }
  local triVertices = {
    -self.triWidth/2, h,
    0, h + self.triHeight,
    self.triWidth/2, h
  }
  local rightVertices = {
    w/2, h,
    w/2, -self.padding
  }

  love.graphics.setLineWidth(5)
  love.graphics.setLineStyle("smooth")
  love.graphics.setColor(self.borderColor)
  love.graphics.polygon("line",table.concatArrays(leftVertices,triVertices,rightVertices))

  love.graphics.setColor(self.fillColor)
  -- Dialog box is not convex, so draw triangle and rectangle separately
  love.graphics.polygon("fill",table.concatArrays(leftVertices, rightVertices))
  love.graphics.polygon("fill",triVertices)

end