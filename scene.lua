Class = require('libs.hump.class')
require('square')
pretty = require('pl.pretty')
require('scripts')

Scene = Class{
  init = function(self, filename)
    io.input(filename..".scn")
    local data = pretty.read(io.read("*all"))

    vstr = tostring(version)
    self.objects = {}
    self.collisionRegistry = {}

    self.width = data.width
    for _,v in pairs(data.squares) do
      self:add(v.name, Square(v))
    end
    for _,v in pairs(data.collisionEvents) do
      self:registerCollisionEvent(v)
    end
  end
}

function Scene:add(name, obj)
  self.objects[name] = obj
end

function Scene:registerCollisionEvent(opts)
  table.insert(self.collisionRegistry, opts)
end

function doghit()
  print('hello')
end

function Scene:update( dt )
  for _,v in pairs(self.objects) do 
    v:update(dt)
  end
  self.sortedList = {}
  for k,v in pairs(self.objects) do
    table.insert(self.sortedList, v)
  end
  table.sort(self.sortedList, function( v1, v2 )
    return v1.pos.y >  v2.pos.y
  end)
  self:processCollisions()
end

function Scene:draw(camera)
  for i,v in ipairs(self.sortedList) do
    v:draw(camera)
  end
end

function Scene:processCollisions()
  self.collisions = {}
  for i=1,#self.sortedList do
    for j=i+1,#self.sortedList do
      obj1, obj2 = self.sortedList[i], self.sortedList[j]
      local x1,y1,z1,s1,cd1 = obj1.pos.x, obj1.pos.y, obj1.elevation, obj1.size, obj1.collision_depth
      local x2,y2,z2,s2,cd2 = obj2.pos.x, obj2.pos.y, obj2.elevation, obj2.size, obj2.collision_depth

      if x1 - s1/2 < x2 + s2/2 and
         x2 - s2/2 < x1 + s1/2 and
         y1 < y2 + cd2 and
         y2 < y1 + cd1 and
         z1 < z2 + s2 and
         z2 < z1 + s1 then
         self:collided(obj1, obj2)
      end
    end
  end
end

function Scene:collided(obj1, obj2)
  -- See if this collision matches anything in the collision registry
  for _,v in ipairs(self.collisionRegistry) do
    if (obj1.name == v.names[1] and obj2.name == v.names[2]) then
       scripts[v.script](self, obj1, obj2)
    elseif (obj1.name == v.names[2] and obj2.name == v.names[1]) then
       scripts[v.script](self, obj2, obj1)
    end
  end
end
