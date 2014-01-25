Class = require('libs.hump.class')
vector = require('libs.hump.vector')

Camera = Class{
  init = function( self, following, horizon )
    self.following = following
    self.horizon = horizon
  end
}

function Camera:getCamX()
  return math.max(winWidth/2, self.following.x)
end

-- Sets the coordinate system to scale and position your character properly.
-- Returns the x and y values of the bottom left point on the ground
function Camera:transformCoords(x, y)
  scale = self.horizon/(self.horizon+y)
  love.graphics.translate(winWidth/2, winHeight)
  love.graphics.scale(scale, scale)
  love.graphics.translate(x-self:getCamX(), 0)
  return vector(0, -y)
end
