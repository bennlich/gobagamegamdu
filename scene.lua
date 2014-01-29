Class = require('libs.hump.class')
require('square')
require('tree')
require('dialog')
pretty = require('pl.pretty')
tablex = require('pl.tablex')
require('resources.scripts')
cron = require('libs.cron')

Scene = Class{
  init = function(self, filename)
    io.input("resources/"..filename..".scn")
    local data = pretty.read(io.read("*all"))

    self.objects = {}
    self.clocks = {}
    self.entrances = {}
    self.dialogs = {}
    self.collisionRegistry = {}
    self.collidedThisFrame = {}
    self.collidedLastFrame = {}

    self.width = data.width
    self.name = data.name
    self.horizon = data.horizon * winHeight

    if data.squares then
      for _,v in pairs(data.squares) do
        self:add(Square(v))
      end
    end
    if data.trees then 
      for _,v in pairs(data.trees) do
        self:add(Tree(v))
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
    if data.dialogs then
      for _,v in pairs(data.dialogs) do
        self.dialogs[v.name] = Dialog(v.filename, self)
      end
    end
    if data.background then
      self:loadBackground(data.background)
    end
    self.floorColor = data.floorColor or {255,255,255}
  end
}

function Scene:add(obj)
  self.objects[obj.name] = obj
end

function Scene:remove( name )
  if self.objects[name] then self.objects[name] = nil end
end

function Scene:addClock( clock )
  table.insert(self.clocks, clock)
end

function Scene:entered(player, previousSceneName)
  local e = self.entrances[previousSceneName]
  self:add(player)
  player.pos = vector(unpack(e.pos))
  -- call entrance callback
  if e.onEnter then scripts[e.onEnter](self, player) end
end

function Scene:left(player)
  self:remove(player.name)
  self.clocks = {}
end

function Scene:registerCollisionEvent(opts)
  table.insert(self.collisionRegistry, opts)
end

function Scene:getSortedList()
  local sortedList = {}
  for k,v in pairs(self.objects) do
    table.insert(sortedList, v)
  end
  table.sort(sortedList, function( v1, v2 )
    return v1.pos.y >  v2.pos.y
  end)
  return sortedList
end

function Scene:update( dt )
  self:resetCollisions()
  for _,v in pairs(self.objects) do 
    v:update(dt, self)
  end
  for k,v in pairs(self.clocks) do
    local expired = v:update(dt)
    if expired then self.clocks[k] = nil end
  end
  self:processCollisions()
end

-- DRAW --

function Scene:draw(camera)
  local sortedList = self:getSortedList()
  if self.background then self:drawBackground() end
  self:drawFloor()
  self:drawHorizonLine()
  for i,v in ipairs(sortedList) do
    if v.shadow and v.shadow=='on' then 
      v:drawShadow(camera) 
    end
  end
  for i,v in ipairs(sortedList) do
    v:draw(camera)
  end
end

function Scene:drawHorizonLine( )
  love.graphics.setColor(146,149,151)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle('rough')
  love.graphics.line(0, winHeight-self.horizon, winWidth, winHeight-self.horizon)
end

function Scene:loadBackground(background)
  self.background = {
    image = love.graphics.newImage('resources/'..background.filename),
    pos = vector(unpack(background.pos)) or vector(0, 500)
  }
end

function Scene:drawBackground()
  love.graphics.setColor(255,255,255)
  local y = self.background.pos.y
  local x = camera:getEdgeOffset(y)
  local groundPos = camera:groundToScreen(vector(x, y))
  local imageHeight = self.background.image:getHeight()
  love.graphics.draw(self.background.image, self.background.pos.x+groundPos.x, 2-imageHeight+winHeight-activeScene.horizon)
end

function Scene:drawFloor()
  love.graphics.setColor(self.floorColor)
  love.graphics.rectangle('fill', 0, winHeight-self.horizon, winWidth, self.horizon)
end

-- COLLISIONS --

function Scene:resetCollisions()
  self.collidedLastFrame = self.collidedThisFrame
  self.collidedThisFrame = {}
end

function Scene:processCollisions()
  local sortedList = self:getSortedList()
  for i=1,#sortedList do
    for j=i+1,#sortedList do
      obj1, obj2 = sortedList[i], sortedList[j]
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

