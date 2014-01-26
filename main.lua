input = require("input")
vector = require("libs.hump.vector")
require("square")
require("player")
require("camera")
require("scene")

function love.load()
  winWidth, winHeight = love.window.getDimensions()
  input.register()

  world_vers = 1
  player = Player({pos = vector(30, 30), size = 50, color = {20, 30, 160}, 
                  name = "player" .. tostring(world_vers)})
  camera = Camera(player, winHeight)
  scenes = {}
  switchScene("beachblimp")
end

function love.update( dt )
  input.update(dt)
  -- if input.wasJustPressed('space') then 
  --   if world_vers == 1 then world_vers = 2
  --   elseif world_vers == 2 then world_vers = 1  end
  --   player.name = "player"..tostring(world_vers)
  -- end  
  activeScene:update(dt)
end

function switchScene(name)
  if not scenes[name] then scenes[name] = Scene(name) end
  local previousScene = activeScene
  local previousName = "default"
  if previousScene then 
    previousScene:left(player) 
    previousName = previousScene.name
  end

  activeScene = scenes[name]
  activeScene:entered(player, previousName)
end

function drawBG( )
  love.graphics.setColor(128, 128, 128)
  love.graphics.rectangle('fill', 0, (winHeight-camera.horizon), winWidth, 1000)
end

function love.draw() 
  drawBG()
  activeScene:draw(camera)
end

