input = require("input")
vector = require("libs.hump.vector")
tween = require("libs.tween")
editor = require("editor")
require("square")
require("player")
require("camera")
require("scene")
require("label")

function love.load()
  winWidth, winHeight = love.window.getDimensions()
  input.register(love)
  love.graphics.setBackgroundColor( 255, 255, 255 ) 
  Label.loadFont()

  mode = 'game'

  world_vers = 1
  player = Player({size = 50, color = 'yellowGreen', 
                  name = "player" .. tostring(world_vers), label="You"})
  scenes = {}
  switchScene("blockcity1")
end

function love.update( dt )
  if love.keyboard.wasJustPressed('x') then enterEditor() end
  if mode == 'editor' then 
    editor.update(dt) 
  elseif mode == 'game' then 
    tween.update(dt)
    activeScene:update(dt)
  end
end

function switchScene(name, from)
  if not scenes[name] then scenes[name] = Scene(name) end
  local previousScene = activeScene
  local previousName = from or "default"
  if not from and previousScene then 
    previousScene:left(player) 
    previousName = previousScene.name
  end

  activeScene = scenes[name]
  camera = Camera(player, activeScene.horizon*winHeight )
  activeScene:entered(player, previousName)
end

function enterEditor(  )
  mode = 'editor'
  switchScene('template', 'default')
end

function drawHorizonLine( )
  love.graphics.setColor(146,149,151)
  love.graphics.setLineWidth(1)
  love.graphics.setLineStyle('rough')
  love.graphics.line(0, winHeight-camera.horizon, winWidth, winHeight-camera.horizon)
end

function love.draw() 
  drawHorizonLine()
  activeScene:draw(camera)
end

