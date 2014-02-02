require("scene")
require("square")
require("util")
require("colors")
pretty = require("pl.pretty")
tablex = require("pl.tablex")

local activeSquare = nil
local editor = {}
-- e is where all of the edit functions live
local e = {}
local selSquare = Square{border={thickness=4, color=colors.red},color={0,0,0,0}}

local nothingSelected = {
  update = 'nothingSelectedUpdate',
  keyDown = {
    ['='] = 'raiseHorizon',
    ['-'] = 'lowerHorizon',
  },
  keyPressed = {
    tab = 'selectNext',
    o = 'write'
  },
  mousePressed = {
    l = 'selectOrAddNewSquare'
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
    c = 'enterRGBMode',
    n = 'enterColorNameMode',
    tab = 'selectNext',
    escape = 'unselect',
    o = 'write'
  },
  mousePressed = {
    l = 'selectOrAddNewSquare'
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

local editRGB = {
  update = 'editRGBUpdate',
  keyPressed = {
    escape = 'exitRGBMode',
    ['return'] = 'exitRGBMode',
    tab = 'switchComponent',
    backspace = 'backspaceRGB',
    b = 'toggleBorder'
  }
}

local chooseColorName = {
  update = 'chooseColorNameUpdate',
  keyPressed = {
    escape = 'exitColorNameMode',
    tab = 'nextColorName',
    ['return'] = 'saveAndExitColorNameMode',
    backspace = 'backspaceColorName'
  }
}

local editorMode = nothingSelected


function editor.update( dt )
  activeScene.objects["player1"] = nil
  activeScene.objects["player2"] = nil
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
  if activeSquare then
    local offset = 20
    selSquare.size = activeSquare.size + offset
    selSquare.pos = activeSquare.pos
    selSquare.elevation = activeSquare.elevation - offset/2
  end
end

function editor.draw(camera)
  selSquare:draw(camera)
end

function editor.getMod( )
  if love.keyboard.isDown('lshift') then return 3 else return 1 end
end

function e.nothingSelectedUpdate(dt, m) end

function e.squareSelectedUpdate(dt, m) 
  if not activeSquare then e.unselect() end
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
  -- Seems to select the same ones over and over? ugh
  if not activeSquare then _,activeSquare = next(activeScene.objects)
  else
    k,activeSquare = next(activeScene.objects, table.find(activeScene.objects, activeSquare)) 
    if not activeSquare then _,activeSquare = next(activeScene.objects) end
  end
  if activeSquare then editorMode = squareSelected end
end

function e.unselect(dt, m) 
  activeSquare = nil 
  editorMode = nothingSelected
end

function e.addNewSquare(dt, m)
  local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
  local groundPos = camera:screenToGround(vector(mouseX, mouseY))

  function getFreeIndex()
    local i = 1
    while activeScene.objects[tostring(i)] do
      i=i+1
    end
    return i
  end
  if groundPos then
    local newSquare = Square{
      name=tostring(getFreeIndex()), pos={math.floor(groundPos.x), math.floor(groundPos.y)}, 
      size = 100, color='gray'} 
    activeScene:add(newSquare) 
    activeSquare = newSquare
    editorMode=squareSelected
  end
end

function e.selectOrAddNewSquare(dt, m) 
  local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()

  local squaresOnScreen = {}
  for k,v in pairs(activeScene.objects) do
    table.insert(squaresOnScreen, v:getScreenBounds(camera))
  end
  for k,v in pairs(squaresOnScreen) do
    -- TODO: TEST SQUARES HERE TO SEE IF CAR IS INSIDE
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
  editorMode = squareSelected
  love.textinput = m.oldTextInput
  if activeSquare.label.content == "" then 
    activeSquare.label = nil 
  else
    activeSquare.label.fillColor = m.oldFillColor
    activeSquare.label.textColor = m.oldTextColor
  end

end

function e.backspaceLabel(dt, m)
  if activeSquare.label.content:len() > 0 then
    activeSquare.label.content = activeSquare.label.content:sub(1, -2)
  end
end

function editor.labelTextInput(text)
  activeSquare.label.content = activeSquare.label.content .. text
end

function e.editRGBUpdate(dt, m)
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

function e.enterRGBMode(dt, m) 
  if activeSquare then
    editorMode = editRGB
    love.textinput = editor.RGBTextInput

    local c = activeSquare.color
    editorMode.r,editorMode.g,editorMode.b,editorMode.a = c[1], c[2], c[3], c[4] or 255
    editorMode.selected = 'r'

    editorMode.oldLabel = activeSquare.label
    activeSquare.label = Label()

    editorMode.oldTextInput = love.textinput
  end
end

function e.exitRGBMode(dt, m)
  editorMode = squareSelected

  love.textinput = m.oldTextInput
  activeSquare.label = m.oldLabel
end

function editor.RGBTextInput(text)
  local n = tonumber(text)
  local m = editorMode
  if n then m[m.selected] = tonumber(m[m.selected]..n) end
end

function e.switchComponent( dt, m )
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

function e.backspaceRGB(dt, m)
  local s = tostring(m[m.selected])
  if s:len() > 0 then
    s = s:sub(1, -2)
    m[m.selected] = tonumber(s) or 0
  end
end

local function colorsEqual(c1, c2)
  return c1[1]==c2[1] and c1[2]==c2[2] and c1[3]==c2[3] and c1[4]==c2[4]
end

local function matchToName(c)
  for k,v in pairs(colors) do
    if type(v)=='table' and colorsEqual(c, v) then return k end
  end
  return nil
end

function e.enterColorNameMode(dt, m)
  if activeSquare then
    editorMode = chooseColorName

    editorMode.colorName = matchToName(activeSquare.color) or ""

    editorMode.oldLabel = activeSquare.label
    activeSquare.label = Label()

    editorMode.oldTextInput = love.textinput
    love.textinput = editor.colorNameTextInput
  end
end

function e.exitColorNameMode(dt, m)
  editorMode = squareSelected

  love.textinput = m.oldTextInput
  activeSquare.label = m.oldLabel
end

function e.saveAndExitColorNameMode(dt, m)
  if type(colors[m.colorName])=='table' then 
    e.exitColorNameMode(dt, m)
  end
end

function e.chooseColorNameUpdate(dt, m)
  activeSquare.label.content = "Color Name: "..m.colorName
  if type(colors[m.colorName])=='table' then 
    activeSquare.color = colors[m.colorName] 
  end
end

function e.nextColorName(dt, m)
  local function getNextColor(t, i)
    local c = nil
    repeat i,c = next(t, i) until type(c)=='table' or c==nil
    -- If we hit the end of the table, start from the beginning
    if not c then return getNextColor(t, nil) 
    else return i,c
    end
  end
  local c = matchToName(activeSquare.color)
  m.colorName = getNextColor(colors, c)
end

function e.backspaceColorName(dt, m)
  if m.colorName:len() > 0 then
    m.colorName = m.colorName:sub(1, -2)
  end
end

function editor.colorNameTextInput(text)
  editorMode.colorName = editorMode.colorName..text
end

function e.write(dt, m)
  local out = {}
  out.name = activeScene.name
  out.width = activeScene.width
  out.horizon = activeScene.horizon/winHeight
  out.squares = tablex.deepcopy(activeScene.objects)
  out.squares["player1"] = nil
  out.squares["player2"] = nil
  out.entrances = tablex.deepcopy(activeScene.entrances)
  out.collisionEvents = tablex.deepcopy(activeScene.collisionRegistry)

  io.output("resources/editorOutput.scn")
  io.write(pretty.write(out))
  io.close()
end

return editor