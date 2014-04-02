behaviors = {}

-- Requires: 
-- other.xSpeed: The speed at which the object travels
function behaviors.moveLeft(dt, obj, scene)
  obj.vel.x = obj.vel.x - obj.other.xSpeed
end

-- Requires: 
-- other.xSpeed: The speed at which the object travels
function behaviors.moveRight(dt, obj, scene)
  obj.vel.x = obj.vel.x + obj.other.xSpeed
end

-- Requires: 
-- other.yVel: The speed at which the object travels in y
function behaviors.moveBack(dt, obj, scene)
  obj.vel.y = obj.vel.y + obj.other.ySpeed
end

-- Requires: 
-- other.yVel: The speed at which the object travels in y
function behaviors.moveForward(dt, obj, scene)
  obj.vel.y = obj.vel.y - obj.other.ySpeed
end

-- Requires: 
-- other.xVel: The speed at which the object travels in x
-- other.yVel: The speed at which the object travels in y
function behaviors.controlledByKeyboard(dt, obj, scene)
  if love.keyboard.isDown('left') then 
    behaviors.moveLeft(dt, obj, scene)
    network.sendMessage("moveLeft")
  end
  if love.keyboard.isDown('right') then 
    behaviors.moveRight(dt, obj, scene)
    network.sendMessage("moveRight")
  end
  if love.keyboard.isDown('down') then 
    behaviors.moveForward(dt, obj, scene)
    network.sendMessage("moveForward")
  end
  if love.keyboard.isDown('up') then 
    behaviors.moveBack(dt, obj, scene)
    network.sendMessage("moveBack")
  end
end

function behaviors.sync(dt, obj, scene)
  network.sendMessage({name = obj.name, pos = obj.pos})
end

-- Requires: 
-- none
function behaviors.keepOnScreen(dt, obj, scene)
  -- Stop player from going off front of screen
  if obj.pos.y + obj.vel.y < 0 then 
    obj.vel.y = 0 
    scene:collided(obj, {name="edgeFront"}) 
  end

  -- Stop player from going off sides of screen
  -- I should pass camera in here but bite me.
  local edgeOffset = camera:getEdgeOffset(obj.pos.y)
  local scaledSize = camera:getScale(obj.pos.y)*obj.size
  if obj.pos.x + obj.vel.x - scaledSize/2 < edgeOffset then
    obj.vel.x = 0
    obj.pos.x = edgeOffset + scaledSize/2
    scene:collided(obj, {name="edgeLeft"}) 
  end
  if obj.pos.x + obj.vel.x + scaledSize/2 > scene.width - edgeOffset then
    obj.vel.x = 0
    obj.pos.x = scene.width - edgeOffset - scaledSize/2
    scene:collided(obj, {name="edgeRight"}) 
  end
end

-- Requires: 
-- none
function behaviors.wrapX(dt, obj, scene )
  local edgeOffset = camera:getEdgeOffset(obj.pos.y)
  local scaledSize = camera:getScale(obj.pos.y)*obj.size
  if obj.pos.x + scaledSize/2 < edgeOffset then
    obj.pos.x = scene.width - edgeOffset + scaledSize/2
    scene:collided(obj, {name="edgeLeft"}) 
    if obj.originalLabelContent then obj.label:setContent(obj.originalLabelContent) end
  end
  if obj.pos.x - scaledSize/2 > scene.width - edgeOffset then
    obj.pos.x = edgeOffset - scaledSize/2
    scene:collided(obj, {name="edgeRight"}) 
    if obj.originalLabelContent then obj.label:setContent(obj.originalLabelContent) end
  end
end

-- Requires: 
-- other.target: The name of the object in the scene to follow
-- other.followDist: Follow until you get to this distance
-- other.maxSpeed: The speed at which to follow
function behaviors.follow(dt, obj, scene )
  if not scene.objects[obj.other.target] then return end
  local target = scene.objects[obj.other.target]
  if target.pos:dist(obj.pos) > obj.other.followDist then
    obj.vel = obj.other.maxSpeed*(target.pos-obj.pos):normalized()
  end
end