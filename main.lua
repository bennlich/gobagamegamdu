input = require("input")
vector = require("libs.hump.vector")
tween = require("libs.tween")
editor = require("editor")
network = require("network")
require("enet")
require("square")
require("camera")
require("scene")
require("label")
require("util")

pretty = require("pl.pretty")


function love.load(args)
  winWidth, winHeight = love.window.getDimensions()
  input.register(love)
  love.graphics.setBackgroundColor( 255, 255, 255 ) 
  Label.loadFont()

  mode = 'game'

  localPlayerBehaviors = {'controlledByKeyboard', 'keepOnScreen', 'syncPosition'}
  remotePlayerBehaviors = {}

  if args[2] == "1" then
    world_vers = 1
    p1Behaviors, p2Behaviors = localPlayerBehaviors, remotePlayerBehaviors
    p1Label, p2Label = "You", "Them"
    network.initAsServer()
  else
    world_vers = 2
    p1Behaviors, p2Behaviors = remotePlayerBehaviors, localPlayerBehaviors
    p1Label, p2Label = "Them", "You"
    network.initAsClient()
  end


  player1 = Square({size = 50, color = 'yellowGreen',
                  name = "player1", label=p1Label, 
                  behavior = p1Behaviors,
                  other = {xSpeed = 7, ySpeed = 4}})

  player2 = Square({size = 70, color = 'magenta',
                  name = "player2", label=p2Label, 
                  behavior = p2Behaviors,
                  other = {xSpeed = 7, ySpeed = 4}})
  -- TODO: Do we need a "player" global var? where do we use it?
  if world_vers == 1 then
    player = player1
    partner = player2
  else
    player = player2
    partner = player1
  end

  scenes = {}
  switchScene("networktest")

  --TODO SHOULD GENERICIZE ADDING PARTNERS
  activeScene:add(partner)
end

function love.update( dt )
  if love.keyboard.wasJustPressed('x') then enterEditor() end
  if mode == 'editor' then 
    editor.update(dt) 
  elseif mode == 'game' then 
    tween.update(dt)
    activeScene:update(dt)
  end

  network.update()
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

