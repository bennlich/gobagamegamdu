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
    c = 'enterColorMode',
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
    escape = 'exitLabelMode',
    ['return'] = 'exitLabelMode',
    backspace = 'backspaceLabel'
  }
}

local editColor = {
  update = 'editColorUpdate',
  keyPressed = {
    escape = 'exitColorMode',
    ['return'] = 'exitColorMode',
    tab = 'switchColor',
    backspace = 'backspaceColor',
    b = 'toggleBorder'
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


function e.editLabelUpdate(dt, m)
end

function e.enterLabelMode(dt, m) 
  if activeSquare then
    if not activeSquare.label then activeSquare.label = Label("") end
    editorMode = editLabel

    editorMode.oldTextInput = love.textinput
    love.textinput = editor.labelTextInput
    editorMode.oldFillColor = activeSquare.label.fillColor
    editorMode.oldTextColor = activeSquare.label.textColor
    activeSquare.label.fillColor = colors.red
    activeSquare.label.textColor = colors.white
  end
end

function e.exitLabelMode(dt, m)
  if activeSquare.label.content == "" then activeSquare.label = nil end
  editorMode = squareSelected

  love.textinput = m.oldTextInput
  activeSquare.label.fillColor = m.oldFillColor
  activeSquare.label.textColor = m.oldTextColor
end

function e.backspaceLabel(dt, m)
  if activeSquare.label.content:len() > 0 then
    activeSquare.label.content = activeSquare.label.content:sub(1, -2)
  end
end

function editor.labelTextInput(text)
  activeSquare.label.content = activeSquare.label.content .. text
end

function e.editColorUpdate(dt, m)
  activeSquare.color = {m.r, m.g, m.b, m.a}
  local labels = {r='r',g='g',b='b',a='a'}
  labels[m.selected] = labels[m.selected]:upper()
  local numbers = string.format("%s=%d\n%s=%d\n%s=%d\n%s=%d", 
                  labels.r,m.r,
                  labels.g,m.g,
                  labels.b,m.b,
                  labels.a,m.a)
  activeSquare.label.content = numbers
end

function e.enterColorMode(dt, m) 
  if activeSquare then
    editorMode = editColor
    love.textinput = editor.colorTextInput

    local c = activeSquare.color
    editorMode.r,editorMode.g,editorMode.b,editorMode.a = c[1], c[2], c[3], c[4] or 255
    editorMode.selected = 'r'

    editorMode.oldLabel = activeSquare.label
    activeSquare.label = Label()

    editorMode.oldTextInput = love.textinput
  end
end

function e.exitColorMode(dt, m)
  editorMode = squareSelected

  love.textinput = m.oldTextInput
  activeSquare.label = m.oldLabel
end

function e.switchColor( dt, m )
  local colors = {'r','g','b','a'}
  local ind = table.find(colors, m.selected)
  if m[m.selected] > 255 then m[m.selected]=m[m.selected]%255 end
  m.selected = colors[ind+1] or colors[1]
end

function e.toggleBorder( dt, m )
  if table.empty(activeSquare.border) then
    activeSquare.border={color=colors.gray, thickness=1}
  else
    activeSquare.border={}
  end
end

function e.backspaceColor(dt, m)
  local s = tostring(m[m.selected])
  if s:len() > 0 then
    s = s:sub(1, -2)
    m[m.selected] = tonumber(s) or 0
  end
end

function editor.colorTextInput(text)
  local n = tonumber(text)
  local m = editorMode
  if n then m[m.selected] = tonumber(m[m.selected]..n) end
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