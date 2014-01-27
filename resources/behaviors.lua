behaviors = {}

-- Requires: 
-- other.xVel: The speed at which the object travels
function behaviors.moveLeft(dt, obj, scene)
  obj.pos.x = obj.pos.x - obj.other.xVel
end

-- Requires: 
-- other.xVel: The speed at which the object travels
function behaviors.moveRight(dt, obj, scene)
  obj.pos.x = obj.pos.x + obj.other.xVel
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
-- other.maxVel: The speed at which to follow
function behaviors.follow(dt, obj, scene )
  if not scene.objects[obj.other.target] then return end
  local target = scene.objects[obj.other.target]
  if target.pos:dist(obj.pos) > obj.other.followDist then
    local vel = obj.other.maxVel*(target.pos-obj.pos):normalized()
    obj.pos = obj.pos + vel
  end
end