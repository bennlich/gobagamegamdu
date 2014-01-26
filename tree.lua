require("leaf")
require("loadable")

Class = require("libs.hump.class")
vector = require("libs.hump.vector")

Tree = Class{__includes=Loadable,
  defaults = {
    pos = vector(0,0),
    fruitsPerLeaf = 2.5,
    size = 1,
    elevation = 0,
    trunkHeight = 100,
    trunkWidth = 10,
    color = {200, 100, 50},
    depth = 10,
    name = "missingno"
  },
  init = function(self, opts)
    Loadable.init(self, opts)
    --default opts
    self.trunkHeight = self.size * self.trunkHeight
    self.trunkWidth = self.size * self.trunkWidth
    --init leaves
    self.leaves = {
      Leaf(self, vector(self.trunkWidth/2,0),
        self.size*100, (1/2)*self.size*100, self.fruitsPerLeaf),
      Leaf(self, vector(-(1/2)*self.trunkWidth-(1/4)*self.size*110,0),
        self.size*110, (1/4)*self.size*110, self.fruitsPerLeaf),
      Leaf(self, vector(self.trunkWidth+(1/2)*self.size*80,0),
        self.size*80, 0, self.fruitsPerLeaf),
      Leaf(self, vector(-self.trunkWidth/2,0),
        self.size*60, (7/3)*self.size*60, self.fruitsPerLeaf)
    }
  end
}

function Tree:update(dt)
  table.foreach(self.leaves, function(k, leaf)
    leaf:update(dt)
  end)
end

function Tree:draw(camera)
  table.foreach(self.leaves, function(k, leaf)
    leaf:draw(camera)
  end)

  --draw trunk
  love.graphics.setColor(self.color)
  love.graphics.push()
  local groundPos = camera:transformCoords(self.pos.x - self.trunkWidth/2, self.pos.y)
  local headY = groundPos.y - self.trunkHeight
  love.graphics.rectangle("fill", groundPos.x, headY, self.trunkWidth, self.trunkHeight)
  love.graphics.pop()
end

