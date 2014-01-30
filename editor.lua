require("scene")
require("square")
require("util")
pretty = require("pl.pretty")
tablex = require("pl.tablex")

local activeSquare = nil
local editor = {}
-- e is where all of the edit functions live
local e = {}
local numObjects = 0
local objects = {}

local nothingSelected = {
  update = 'nothingSelectedUpdate',
  keyDown = {
    ['='] = 'raiseHorizon',
    ['-'] = 'lowerHorizon',
  },
  keyPressed = {
    tab = 'selectNext'
  },
  mousePressed = {
    l = 'addNewSquare'
  },
  modifier = 1,
}

local squareSelected = {
  update = 'squareSelectedUpdate',
  keyDown = {
    ['='] = 'raiseHorizon',
    ['-'] = 'lowerHorizon',
    left = 'moveLeft',
    right = 'moveRight',
    up = 'moveBack',
    down = 'moveForward',
    q = 'makeBigger',
    a = 'makeSmaller',
    w = 'raise',
    s = 'lower',
  },
  keyPressed = {
    l = 'enterLabelMode',
    tab = 'selectNext',
    escape = 'unselect'
  },
  mousePressed = {
    l = 'addNewSquare'
  },
  modifier = 1
}

local editLabel = {
  update = 'editLabelUpdate',
  keyPressed = {
    esc = 'exitLabelMode'
  }
}

local editorMode = nothingSelected


function editor.update( dt )
  if editorMode then
    local shouldExit = e[editorMode.update](dt, editorMode)
    if not shouldExit then
      for k,v in pairs(editorMode.keyDown or {}) do
        if love.keyboard.isDown(k) then e[v](dt, editorMode) end
      end
      for k,v in pairs(editorMode.keyPressed or {}) do
        if love.keyboard.wasJustPressed(k) then e[v](dt, editorMode) end
      end

      for k,v in pairs(editorMode.mousePressed or {}) do
        if love.mouse.wasJustPressed(k) then e[v](dt, editorMode) end
      end
    end
  end
end

function editor.getMod( )
  if love.keyboard.isDown('lshift') then return 3 else return 1 end
end

function e.nothingSelectedUpdate(dt, m) end

function e.squareSelectedUpdate(dt, m) 
  if not activeSquare then e.unselect() end
  for k,v in pairs(activeScene.objects) do
    if v == activeSquare then v.color = colors.red else v.color = colors.gray end
  end
end

local function changeHorizon( dh, m )
  activeScene.horizon = activeScene.horizon + editor.getMod()*dh
end
function e.raiseHorizon(dt, m) changeHorizon(1, m) end
function e.lowerHorizon(dt, m) changeHorizon(-1, m) end

local function changeX( dx, m )
  activeSquare.pos.x = activeSquare.pos.x + editor.getMod()*dx
end
function e.moveLeft(dt, m) changeX(-1, m) end
function e.moveRight(dt, m) changeX(1, m) end

local function changeY( dy, m )
  activeSquare.pos.y = activeSquare.pos.y + editor.getMod()*dy
end
function e.moveBack(dt, m) changeY(1, m) end
function e.moveForward(dt, m) changeY(-1, m) end

local function changeSize( ds, m )
  activeSquare.size = activeSquare.size + editor.getMod()*ds
end
function e.makeBigger(dt, m) changeSize(1, m) end
function e.makeSmaller(dt, m) changeSize(-1, m) end

local function changeElevation( de, m )
  activeSquare.elevation = activeSquare.elevation + editor.getMod()*de
  if activeSquare.elevation < 0 then activeSquare.elevation = 0 end
end
function e.raise(dt, m) changeElevation(1, m) end
function e.lower(dt, m) changeElevation(-1, m) end

function e.selectNext(dt, m)
  -- god this is ugly but i'm tired
  if not activeSquare then activeSquare = objects[1] or nil 
  else
    k,activeSquare = next(objects, table.find(objects, activeSquare)) 
    if not activeSquare then activeSquare = objects[1] end
  end
  if activeSquare then editorMode = squareSelected end
end

function e.unselect(dt, m) 
  activeSquare = nil 
  editorMode = nothingSelected
end

function e.addNewSquare(dt, m) 
  numObjects = numObjects + 1
  local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
  local groundPos = camera:screenToGround(vector(mouseX, mouseY))
  if groundPos then
    local newSquare = Square{
      name=tostring(numObjects), pos={groundPos.x, groundPos.y}, 
      size = 100, color='gray'} 
    activeScene:add(newSquare) 
    table.insert(objects, newSquare)
    activeSquare = newSquare
  end
end

function e.enterLabelMode(dt, m) 
  if activeSquare then
    editorMode = editLabel
  end
end

function e.editLabelUpdate(dt, m)
  if not activeSquare.label then activeSquare.label = Label("") end
end

function e.exitLabelMode(  )
  if activeSquare.label.content == "" then activeSquare.label = nil end
  editorMode = squareSelected
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