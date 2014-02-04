tween = require("libs.tween")
tablex = require("pl.tablex")
require("libs.hump.class")
require("colors")
transitions={}

transitions.Fade = Class{ 
  init = function(self, fromColor, toColor, callback)
    self.fromColor = fromColor
    self.toColor = toColor
    self.color = tablex.copy(fromColor)
    self.callback = callback
  end,

  start = function(self)
    tween(2, self.color, self.toColor, 'linear', self.callback)
  end,

  setupDraw = function(self)
    addToDrawList(-math.huge, function()
      love.graphics.setColor(self.color)
      love.graphics.rectangle('fill',0,0,winWidth,winHeight)
    end)
  end,

  update = function(self) end
}


transitions.fadeOut = Class{
  __includes = transitions.Fade,
  init = function(self, callback)
    local fromColor = tablex.copy(colors.gray)
    fromColor[4] = 0
    local toColor = tablex.copy(colors.gray)
    toColor[4] = 255
    transitions.Fade.init(self, fromColor, toColor, callback)
    self:start()
  end
}

transitions.fadeIn = Class{
  __includes = transitions.Fade,
  init = function(self, callback)
    local fromColor = tablex.copy(colors.gray)
    fromColor[4] = 255
    local toColor = tablex.copy(colors.gray)
    toColor[4] = 0
    transitions.Fade.init(self, fromColor, toColor, callback)
    self:start()
  end
}
