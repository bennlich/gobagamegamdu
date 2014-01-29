input = require("input")
vector = require("libs.hump.vector")
tween = require("libs.tween")
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

  world_vers = 1
  player = Player({size = 50, color = 'yellowGreen', 
                  name = "player" .. tostring(world_vers), label="You"})
  scenes = {}
  switchScene("blockcity1")
end

function love.update( dt )
  tween.update(dt)
  -- if input.wasJustPressed('space') then 
  --   if world_vers == 1 then world_vers = 2
  --   elseif world_vers == 2 then world_vers = 1  end
  --   player.name = "player"..tostring(world_vers)
  -- end  
  activeScene:update(dt)
  input.update(dt)
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
  camera = Camera(player, activeScene.horizon*winHeight )
  activeScene:entered(player, previousName)
end

function love.draw() 
  activeScene:draw(camera)
end

