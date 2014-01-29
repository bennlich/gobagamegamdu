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
  if activeSquare then
    local vel = vector(0,0)
    if love.keyboard.isKeyDown('left') then vel.x = -1 end

    activeSquare.pos =  activeSquare.pos + vel
  end
  if love.keyboard.wasJustPressed('tab') then 
    activeSquare = next(objects, table.find(activeSquare)) or objects[1]
  end
  if love.keyboard.wasJustPressed('s') then 
    editor.addNewSquare()
  end
end

function editor.addNewSquare(  )
  numObjects = numObjects + 1
  local newSquare = Square{
    name=tostring(numObjects), pos={activeScene.width/2, 0}, 
    size = 100, color='gray'} 
  activeScene:add(newSquare) 
  table.insert(objects, newSquare)
end

function editor.write( scene )
  local out = {}
  out.name = scene.name
  out.width = scene.width
  out.horizon = scene.horizon
  out.squares = tablex.deepcopy(scene.objects)
  out.squares["player1"] = nil
  out.squares["player2"] = nil
  out.entrances = tablex.deepcopy(scene.entrances)
  out.collisionEvents = tablex.deepcopy(scene.collisionRegistry)
  print(pretty.write(out))
end

return editor