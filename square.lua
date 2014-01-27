Class = require("libs.hump.class")

require("loadable")
require("label")
require("util")
require("colors")
require("resources.behaviors")

Square = Class{__includes=Loadable,
  defaults = {
    name = "missingno",
    pos = vector(0,0),
    size = 0,
    color = {0,0,0,255},
    elevation = 0,
    depth = 10,
    collisionRect = {},
    label = "",
    shadow = 'on',
    border = {},
    behavior = {},
    other = {}
  },
  init = function(self, opts)
    Loadable.init(self, opts)
    --If a label exists, create it. Otherwise, it's nil
    local labelOpts = {}
    -- self.label can be either a table or a string
    if type(self.label) == 'table' then
      labelOpts = self.label
    elseif type(self.label) == 'string' then
      labelOpts.content = self.label
    end
    labelOpts.base = self
    if labelOpts.content ~= '' then
      self.label = Label(labelOpts)
      self.originalLabelContent = self.label.content
    else
      self.label = nil
    end

    self.color = colors.loadColor(self.color)
    if self.border.color then 
      self.border.color=colors.loadColor(self.border.color) 
    end

    -- Transform behaviors into functions
    local loadedBehavior = self.behavior
    self.behavior = {}
    -- If behavior is just a string, make a trivial array
    if type(loadedBehavior) == 'string' then loadedBehavior = {loadedBehavior} end
    for k,v in pairs(loadedBehavior) do
      self.behavior[k] = behaviors[v]
    end
  end
}

function Square:getCollisionRect(  )
  -- next() returns false if table is empty
  if table.empty(self.collisionRect) then
    return self.pos.x, self.pos.y, self.elevation, self.size, self.depth, self.size
  else
    return unpack(self.collisionRect)
  end

end

function Square:getSides(  )
  -- returns left, right, front, back, bottom, top
  -- in other words, low to high, x,y,z
  local x,y,z,w,d,h = self:getCollisionRect()
  return x-w/2,x+w/2, y-d/2,y+d/2, z,z+h
end

function Square:update(dt,scene)
  for k,v in pairs(self.behavior) do
    v(dt, self, scene)
  end
end

function Square:draw(camera)
  love.graphics.push()
  -- Get the lower-left coordinate
  local groundPos = camera:transformCoords(self.pos.x-self.size/2, self.pos.y)
  -- draw the character from the head down
  local headY = groundPos.y - self.size - self.elevation
  love.graphics.translate(groundPos.x, headY)

  -- This seems stupid to undo the scale, but it lets us draw
  -- at the right position with crisp lines
  local scale = camera:getScale(self.pos.y)
  love.graphics.scale(1/scale, 1/scale)
  local drawSize = scale*self.size
  
  love.graphics.setColor(self.color)
  love.graphics.rectangle("fill", 0, 0, drawSize, drawSize)

  if not table.empty(self.border) then
    love.graphics.setColor(self.border.color)
    love.graphics.setLineWidth(self.border.thickness or 1)
    love.graphics.setLineStyle('rough')
    love.graphics.rectangle("line", 0, 0, drawSize, drawSize)
  end
  love.graphics.pop()

  if self.label then 
    -- print(self.label.content)
    self.label:draw(camera) 
  end
end

function Square:drawShadow(camera)
  local shadowColor = {0,0,0,128}
  local shadowColor2 = {0,0,0,0}
  local shadowMesh = love.graphics.newMesh(
    {
       {0,0, 0,0, unpack(shadowColor)},
       {-0.2,-0.26, 0,0, unpack(shadowColor2)},
       {0.8,-0.26, 0,0, unpack(shadowColor2)},
       {1,0, 0,0, unpack(shadowColor)}
    }
  )
  love.graphics.push()
  local groundPos = camera:transformCoords(self.pos.x-self.size/2, self.pos.y)
  love.graphics.translate(groundPos.x, groundPos.y)
  love.graphics.scale(self.size, self.size)
  love.graphics.draw(shadowMesh)
  love.graphics.pop()
end