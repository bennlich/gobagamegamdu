input = require("input")
vector = require("libs.hump.vector")
require("square")
require("player")
require("camera")
require("scene")
require("label")

function love.load()
  winWidth, winHeight = love.window.getDimensions()
  input.register()
  love.graphics.setBackgroundColor( 255, 255, 255 ) 
  Label.loadFont()

  world_vers = 2
  player = Player({pos = vector(30, 30), size = 50, color = {20, 30, 160}, 
                  name = "player" .. tostring(world_vers), label="You"})
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
  camera = Camera(player, activeScene.horizon*winHeight)
  activeScene:entered(player, previousName)
end

function drawHorizonLine( )
  love.graphics.setColor(146,149,151)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle('rough')
  love.graphics.line(0, camera.horizon, winWidth, camera.horizon)
end

function love.draw() 
  drawHorizonLine()
  activeScene:draw(camera)
end

