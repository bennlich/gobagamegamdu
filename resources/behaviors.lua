behaviors = {}

function behaviors.moveLeft(dt, obj, scene)
  obj.pos.x = obj.pos.x - obj.other.xVel
end

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