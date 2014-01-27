Class = require('libs.hump.class')
vector = require('libs.hump.vector')

Camera = Class{
  init = function( self, following, horizon )
    self.following = following
    self.horizon = horizon
  end
}

function Camera:getCamX()
  return math.min(math.max(winWidth/2, self.following.pos.x), activeScene.width-winWidth/2)
end

-- Sets the coordinate system to scale and position your character properly.
-- Returns the x and y values of the bottom left point on the ground
function Camera:transformCoords(x, y)
  local scale = self:getScale(y) 
  love.graphics.translate(winWidth/2, winHeight)
  love.graphics.scale(scale, scale)
  love.graphics.translate(x-self:getCamX(), 0)
  return vector(0, -y)
end

function Camera:groundToScreen( pos )
  local scale = self:getScale(pos.y) 
  local x = winWidth/2 + scale*(pos.x-self:getCamX())
  local y = winHeight - scale*pos.y
  return vector(x, y)
end

function Camera:getScale(y)
  return self.horizon/(self.horizon+y)
end