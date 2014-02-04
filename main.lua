input = require("input")
vector = require("libs.hump.vector")
tween = require("libs.tween")
editor = require("editor")
require("square")
require("player")
require("camera")
require("scene")
require("label")
require("util")

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
  local previousName = from or (previousScene and previousScene.name) or "default"

  activeScene = scenes[name]
  camera = Camera(player)
  activeScene:entered(player, previousName)
end

function enterEditor(  )
  mode = 'editor'
  if fileExists('resources/editorOutput.scn') then
    switchScene('editorOutput', 'default')
  else
    switchScene('template', 'default')
  end
end

function addToDrawList(z, drawFunction)
  assert(type(z)=='number', "First argument to addToDrawList must be a number")
  assert(type(drawFunction)=='function', 
    "Second argument to addToDrawList must be a function. Was instead "..type(drawFunction))
  table.insert(drawList, {z=z, f=drawFunction})
end

function love.draw() 
  drawList = {}
  activeScene:setupDraw(camera)
  if editor then editor.setupDraw(camera) end

  --Sort the draw functions and then call them
  table.sort(drawList, function( v1, v2 )
    return v1.z > v2.z
  end)
  for _,v in ipairs(drawList) do
    v.f()
  end
end

