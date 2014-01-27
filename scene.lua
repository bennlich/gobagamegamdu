Class = require('libs.hump.class')
require('square')
require('tree')
pretty = require('pl.pretty')
require('resources.scripts')

Scene = Class{
  init = function(self, filename)
    io.input("resources/"..filename..".scn")
    local data = pretty.read(io.read("*all"))

    vstr = tostring(version)
    self.objects = {}
    self.sortedList = {}
    self.entrances = {}
    self.collisionRegistry = {}
    self.collidedThisFrame = {}
    self.collidedLastFrame = {}

    self.width = data.width
    self.name = data.name
    self.horizon = data.horizon

    if data.squares then
      for _,v in pairs(data.squares) do
        self:add(v.name, Square(v))
      end
    end
    if data.trees then 
      for _,v in pairs(data.trees) do
        self:add(v.name, Tree(v))
      end
    end
    if data.collisionEvents then
      for _,v in pairs(data.collisionEvents) do
        self:registerCollisionEvent(v)
      end
    end
    if data.entrances then
      for _,v in pairs(data.entrances) do
        self.entrances[v.from] = v
      end
    end
  end
}

function Scene:add(name, obj)
  self.objects[name] = obj
end

function Scene:remove( name )
  if self.objects[name] then self.objects[name] = nil end
end

function Scene:entered(player, previousSceneName)
  local e = self.entrances[previousSceneName]
  self:add(player.name, player)
  player.pos = vector(unpack(e.pos))
  -- call entrance callback
  if e.onEnter then scripts[e.onEnter]() end
end

function Scene:left(player)
  self:remove(player.name)
end

function Scene:registerCollisionEvent(opts)
  table.insert(self.collisionRegistry, opts)
end

function Scene:update( dt )
  self:resetCollisions()
  for _,v in pairs(self.objects) do 
    v:update(dt, self)
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
    if v.shadow and v.shadow=='on' then 
      v:drawShadow(camera) 
    end
  end
  for i,v in ipairs(self.sortedList) do
    v:draw(camera)
  end
end

function Scene:resetCollisions()
  self.collidedLastFrame = self.collidedThisFrame
  self.collidedThisFrame = {}
end

function Scene:processCollisions()
  for i=1,#self.sortedList do
    for j=i+1,#self.sortedList do
      obj1, obj2 = self.sortedList[i], self.sortedList[j]
      local le1,ri1,fr1,ba1,bo1,to1= obj1:getSides()
      local le2,ri2,fr2,ba2,bo2,to2= obj2:getSides()

      if le1 < ri2 and
         le2 < ri1 and
         fr1 < ba2 and
         fr2 < ba1 and
         bo1 < to2 and
         bo2 < to1 
      then
        -- Whichever of these is smallest indicates that 
        -- "object 1 is [direction] of object 2"
        local penetrations = {
          right=ri2-le1, left=ri1-le2, 
          back=ba2-fr1, front=ba1-fr2, 
          top=to2-bo1, bottom=to1-bo2
        }
        local minPen, minDir = math.huge, ""
        for k,v in pairs(penetrations) do
          if v < minPen then minPen, minDir = v, k end
        end
        self:collided(obj1, obj2, minPen, minDir)
      end
    end
  end

  -- Call collision callbacks
  for k,v in pairs(self.collidedThisFrame) do
    -- Called the first time the objects collide
    if v.event.onCollide and not self.collidedLastFrame[k] then 
      scripts[v.event.onCollide](self, v.obj1, v.obj2, v.penAmt, v.penDir) 
    end
    -- Called as long as the object is in the other object
    if v.event.onColliding then 
      scripts[v.event.onColliding](self, v.obj1, v.obj2, v.penAmt, v.penDir) 
    end
  end
  for k,v in pairs(self.collidedLastFrame) do
    -- Called when two objects disengage
    if v.event.onRelease and not self.collidedThisFrame[k] then
      scripts[v.event.onRelease](self, v.obj1, v.obj2, v.penAmt, v.penDir) 
    end
  end
end

function Scene:collided(obj1, obj2, penAmt, penDir)
  -- See if this collision matches anything in the collision registry
  for _,v in ipairs(self.collisionRegistry) do
    if (obj1.name:find(v.names[1]) and obj2.name:find(v.names[2])) or
       (obj1.name:find(v.names[2]) and obj2.name:find(v.names[1])) then
       -- If needed, swap to make sure obj1 == name1
       if not obj1.name:find(v.names[1]) then 
          local temp = obj1
          obj1 = obj2
          obj2 = temp
          -- Object 1 and 2 have switched, so the direction of penetration has as well
          if penDir and penDir == "left" then penDir = "right" 
          elseif penDir and penDir == "right" then penDir = "left" 
          elseif penDir and penDir == "top" then penDir = "bottom" 
          elseif penDir and penDir == "bottom" then penDir = "top"
          elseif penDir and penDir == "front" then penDir = "back" 
          elseif penDir and penDir == "back" then penDir = "front" end
       end
       self.collidedThisFrame[tostring(obj1)..tostring(obj2)] =  
          {event=v, obj1=obj1, obj2=obj2, penAmt=penAmt, penDir=penDir}
    end
  end
end
