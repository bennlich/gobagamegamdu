Class = require('libs.hump.class')
vector = require('libs.hump.vector')

Camera = Class{
  init = function( self, following)
    self.following = following
  end
}

function Camera:getCamX()
  return math.min(math.max(winWidth/2, self.following.pos.x), activeScene.width-winWidth/2)
end

-- Sets the coordinate system to scale and position your character properly.
-- Returns the x and y values of the bottom left point on the ground
-- relative to the applied transformations.
-- NOTE: To be used between a push() and a pop()
function Camera:transformCoords(x, y)
  local scale = self:getScale(y) 
  love.graphics.translate(winWidth/2, winHeight)
  love.graphics.scale(scale, scale)
  love.graphics.translate(x-self:getCamX(), 0)
  return vector(0, -y)
end

function Camera:getScale(y)
  return activeScene.horizon/(activeScene.horizon+y)
end

-- transforms a point from ground coordinates (where y is depth)
-- to screen coordinates
function Camera:groundToScreen( pos )
  local scale = self:getScale(pos.y)
  local x = winWidth/2 + scale*(pos.x-self:getCamX())
  local y = winHeight - scale*pos.y
  return vector(x, y)
end

function Camera:screenToGround( pos )
  if (pos.y > activeScene.horizon) then 
    return nil
  end
  
  local y = activeScene.horizon * (pos.y - winHeight) / (winHeight - activeScene.horizon - pos.y)
  local scale = self:getScale(y)
  local x = self:getCamX() + (pos.x - winWidth/2) / scale
  
  return vector(x, y)
end

-- for a given y, returns the x value of the screen's left edge
function Camera:getEdgeOffset( y )
  local scale = self:getScale(y)
  return winWidth*(scale-1)/(2*scale)
end