Class = require('libs.hump.class')
require('square')
pretty = require('pl.pretty')

Scene = Class{
  init = function(self, filename)
    io.input(filename..".scn")
    local data = pretty.read(io.read("*all"))

    vstr = tostring(version)
    self.objects = {}

    self.width = data.width
    print(self.width)
    for name,v in pairs(data.squares) do
      self:add(name, Square(v))
    end
  end
}

function Scene:add(name, obj)
  self.objects[name] = obj
end

function Scene:update( dt )
  for _,v in pairs(self.objects) do 
    v:update(dt)
  end
end

function Scene:draw(camera)
  local sortList = {}
  for k,v in pairs(self.objects) do
    table.insert(sortList, v)
  end
  table.sort(sortList, function( v1, v2 )
    return v1.pos.y >  v2.pos.y
  end)
  for i,v in ipairs(sortList) do
    v:draw(camera)
  end
end

