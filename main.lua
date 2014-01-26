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
  camera = Camera(player, winHeight/2)
  scenes = {}
  switchScene("scene1")
end

function love.update( dt )
  input.update(dt)
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

