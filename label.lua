Class = require("libs.hump.class")

require("loadable")
require("util")
require("colors")
Pretty = require("pl.pretty")

Label = Class{__includes=Loadable,
  defaults = {
    content = "",
    width = 0,
    pos = {0,0},
    elevationOffset = 15,
    color = {0,0,0}
  },
  triWidth = 15, triHeight = 10, 
  borderColor = {128,130,133},
  fillColor = colors.white,
  contentColor = colors.black,
  perspectiveCorrection = 0.25,
  padding = 15
}

function Label.loadFont( )
  Label.font = love.graphics.newFont("resources/SourceCodePro-Regular.ttf", 18)
end
  
function Label:getContentDimensions(  )
  if type(self.content)=='string' then
    if self.width == 0 and not self.content:find('\n') then
      return self.font:getWidth(self.content), self.font:getHeight()
    else
      local width, lines = self.font:getWrap(self.content, self.width)
      local height = self.font:getHeight() * lines
      return width, height
    end
  else
    return self.content:getDimensions()
  end
end

function Label:setContent( content )
  if type(content) == 'string' then
    self.content = content
  elseif type(content) == 'table' then
    self.content = love.graphics.newImage("resources/"..content.filename)
  end
end

function Label:setWidth( width )
  self.width = width
end

function Label:update(dt)
end

function Label:setupDraw(camera, base)
  --If label is put on top of square, should draw in front
  local labelFrontOffset = -0.01
  local z = self.zOrder or base.pos.y+self.pos.y+labelFrontOffset
  addToDrawList(z, function()
    local contentWidth, contentHeight = self:getContentDimensions()

    -- TODO: rewrite this to use same math as square
    love.graphics.setColor(self.color)
    love.graphics.push()
    local groundPos = camera:transformCoords(base.pos.x + self.pos.x, base.pos.y + self.pos.y)
    local headY = groundPos.y - base.size - base.elevation
    love.graphics.translate(groundPos.x, headY)

    -- Text boxes don't scale in perspective normally.
    -- This is some magic to get the boxes to scale, but not the offset
    local contentBoxOffset = -(contentHeight + self.triHeight + self.elevationOffset + self.padding)
    local scale = camera:getScale(base.pos.y + self.pos.y)
    local scaleCorrection = (self.perspectiveCorrection + scale*(1-self.perspectiveCorrection))
    -- undo previous scale operation
    love.graphics.scale(1/scale, 1/scale)
    -- apply new perspective
    love.graphics.scale(scaleCorrection, scaleCorrection)
    love.graphics.translate(0, contentBoxOffset)

    self:drawBox()
    if type(self.content) == 'string' then
      love.graphics.setFont(Label.font)
      love.graphics.setColor(self.contentColor)
      love.graphics.printf(self.content, -contentWidth/2, 0, contentWidth, "center")
    else
      love.graphics.draw(self.content, -contentWidth/2, 0)
    end
    love.graphics.pop()
  end)
end

function Label:drawBox()
  local contentWidth, contentHeight = self:getContentDimensions()
  -- X is from the center, y is from the top.
  local w, h = contentWidth + self.padding*2, contentHeight + self.padding

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