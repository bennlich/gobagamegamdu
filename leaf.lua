require("square")

Class = require("libs.hump.class")
vector = require("libs.hump.vector")

Leaf = Class{__includes=Square,
	init = function(self, tree, posOffset, size, elevationOffset, numFruits)
		
    --init leaf
		local leafColor = { 0, 200, 50 }
		Square.init(self, {
      pos = tree.pos+posOffset,
      size = size,
      color = leafColor,
      elevation = tree.elevation+tree.trunkHeight+elevationOffset
    })

    --init fruits
		local minNumFruits = math.floor(numFruits)
		local probFruit = numFruits % minNumFruits
		local numFruits = minNumFruits + ((math.random() > probFruit and 1) or 0)
    local fruitColor = { 200, 200, 20 }
		self.fruits = {}
		for i=1,numFruits do
			self.fruits[i] = Square({
        pos = self.pos + vector(math.random(-self.size/2, self.size/2), 0),
        size = 5,
        color = fruitColor,
        elevation = self.elevation+math.random(self.size)
      })
		end
	end
}

function Leaf:update(dt)
	table.foreach(self.fruits, function(k, fruit)
		fruit:update(dt)
	end)
end

function Leaf:draw(camera)
  Square.draw(self, camera)
	if (self.fruits) then
		table.foreach(self.fruits, function(k, fruit)
			fruit:draw(camera)
		end)
	end
end