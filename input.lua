
--module boilerplate
local require = require
local M = {}
if setfenv then
  setfenv(1, M) -- for 5.1
else
  _ENV = M -- for 5.2
end
-- End module boilerplate

tablex = require('pl.tablex')

local curr_kb_state, old_kb_state = {}, {}
local curr_mouse_state, old_mouse_state = {}, {}


local function keypressed( key )
  curr_kb_state[key] = true
end

local function keyreleased( key )
  curr_kb_state[key] = nil
end

local function mousepressed( button )
  curr_mouse_state[button] = true
end

local function mousereleased( button )
  curr_mouse_state[button] = nil
end

local function update(dt)
  old_kb_state = tablex.copy(curr_kb_state)
  old_mouse_state = tablex.copy(curr_mouse_state)
end

local function kb_wasJustPressed( key )
  return (not old_kb_state[key] and curr_kb_state[key])
end

local function kb_wasJustReleased( key )
  return (old_kb_state[key] and not curr_kb_state[key])
end

local function mouse_wasJustPressed( button )
  return (not old_mouse_state[button] and curr_mouse_state[button])
end

local function mouse_wasJustReleased( button )
  return (old_mouse_state[button] and not curr_mouse_state[button])
end

function register(love)
  love.keypressed = keypressed
  love.keyreleased = keyreleased
  love.keyboard.wasJustPressed = kb_wasJustPressed
  love.keyboard.wasJustReleased = kb_wasJustReleased
  love.mousepressed = mousepressed
  love.mousereleased = mousereleased
  love.mouse.wasJustPressed = mouse_wasJustPressed
  love.mouse.wasJustReleased = mouse_wasJustReleased
  local loveupdate = love.update 
  love.update = function(dt)
    loveupdate(dt)
    update(dt)
  end
end
return M

------------------------
-- [CONTROLLER INPUT] --
------------------------
-- controller_state, needs_reset = {}, {}
-- controller_state[1], needs_reset[1] = {}, {}
-- for i=1,love.joystick.getNumJoysticks() do
--   controller_state[i], needs_reset[i] = {}, {}
-- end

-- BUTTON = {
--   A = 12,
--   B = 13,
--   X = 14,
--   Y = 15,

--   LB = 9,
--   RB = 10,

--   LS = 7,
--   RS = 8,

--   UP = 1,
--   DOWN = 2,
--   LEFT = 3,
--   RIGHT = 4,

--   BACK = 6,
--   START = 5,
--   HOME = 11
-- }

-- function use_pressed(joystick, buttonstr)
--   b = BUTTON[buttonstr]
--   if controller_state[joystick][b] then
--     if needs_reset[joystick][b] then
--       return false
--     else
--       needs_reset[joystick][b] = true
--       return true
--     end
--   else
--     return false
--   end
-- end

-- function start_controller(joystick)
--   love.joystick.open(joystick)
--   controller_state[joystick] = {}
-- end

-- function stop_controller(joystick)
--   love.joystick.close(joystick)
--   controller_state[joystick] = nil
-- end

-- function love.joystickpressed(joystick, button)
--   controller_state[joystick][button] = true
--   print('Player ' .. joystick .. ' pressed ' .. get_button_name(button))
-- end

-- function love.joystickreleased(joystick, button)
--   controller_state[joystick][button], needs_reset[joystick][button] = nil, nil
--   print('Player ' .. joystick .. ' released ' .. get_button_name(button))
-- end

-- function love.keypressed(key)
--   k = BUTTON[string.upper(key)]
--   if k then
--     controller_state[1][k] = true
--     -- print('Keyboard pressed ' .. k)
--   end
-- end

-- function love.keyreleased(key)
--   k = BUTTON[string.upper(key)]
--   if k then
--     controller_state[1][k], needs_reset[1][k] = nil, nil
--     -- print('Keyboard released ' .. k)
--   end
-- end

-- function get_button_name(button)
--   for name,b in pairs(BUTTON) do
--     if b == button then return name end
--   end
--   return nil
-- end