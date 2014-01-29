require("scene")
require("square")
require("util")
pretty = require("pl.pretty")
tablex = require("pl.tablex")

local activeSquare = nil
local editor = {}
local numObjects = 0
local objects = {}

function editor.update( dt )
  local modifier = 1
  local horizonChange = 0
  if love.keyboard.isDown('lshift') then modifier = 3 end

  if love.keyboard.isDown('=') then horizonChange = 1 end
  if love.keyboard.isDown('-') then horizonChange = -1 end

  if activeSquare then
    local vel = vector(0,0)
    local sizeChange = 0
    local elevationChange = 0

    if love.keyboard.isDown('left') then vel.x = -1 end
    if love.keyboard.isDown('right') then vel.x = 1 end
    if love.keyboard.isDown('up') then vel.y = 1 end
    if love.keyboard.isDown('down') then vel.y = -1 end

    if love.keyboard.isDown('q') then sizeChange = 1 end
    if love.keyboard.isDown('a') then sizeChange = -1 end

    if love.keyboard.isDown('w') then elevationChange = 1 end
    if love.keyboard.isDown('s') then elevationChange = -1 end


    activeSquare.pos =  activeSquare.pos + vel * modifier
    activeSquare.size = activeSquare.size + sizeChange * modifier
    activeSquare.elevation = activeSquare.elevation + elevationChange * modifier
    if activeSquare.elevation < 0 then activeSquare.elevation = 0 end
  end

  activeScene.horizon = activeScene.horizon + horizonChange * modifier

  if love.keyboard.wasJustPressed('tab') then 
    -- god this is ugly but i'm tired
    if not activeSquare then activeSquare = objects[1] or nil 
    else
      k,activeSquare = next(objects, table.find(objects, activeSquare)) 
      if not activeSquare then activeSquare = objects[1] end
    end
  end
  if love.keyboard.wasJustPressed(' ') then 
    editor.addNewSquare()
  end

  for k,v in pairs(activeScene.objects) do
    if v == activeSquare then v.color = colors.red else v.color = colors.gray end
  end
end

function editor.addNewSquare(  )
  numObjects = numObjects + 1
  local newSquare = Square{
    name=tostring(numObjects), pos={activeScene.width/2-numObjects*100, 0}, 
    size = 100, color='gray'} 
  activeScene:add(newSquare) 
  table.insert(objects, newSquare)
  activeSquare = newSquare
end

function editor.write( scene )
  local out = {}
  out.name = scene.name
  out.width = scene.width
  out.horizon = scene.horizon/winHeight
  out.squares = tablex.deepcopy(scene.objects)
  out.squares["player1"] = nil
  out.squares["player2"] = nil
  out.entrances = tablex.deepcopy(scene.entrances)
  out.collisionEvents = tablex.deepcopy(scene.collisionRegistry)
  print(pretty.write(out))
end

return editor