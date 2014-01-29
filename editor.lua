require("scene")
require("square")
require("input")
pretty = require("pl.pretty")
tablex = require("pl.tablex")

local activeSquare = nil
local editor = {}

function editor.update( dt )
  if activeSquare then
    local vel = vector(0,0)
    if love.keyboard.isKeyDown('left') then vel.x = -1 end

    activeSquare.pos = activeSquare.pos + vel
  end
  if love.mouse.wasJustPressed('l') then 
    print("hello")
    activeScene:add("test", Square{
      name="test", pos={100, 100}, color='gray'}) 
  end
  -- if love.keyboard.wasJustPressed('x') then print(editor.write(activeScene)) end
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