module(..., package.seeall)

curr_state, old_state = {}, {}

function register()
	love.keypressed = keypressed
	love.keyreleased = keyreleased
end

function keypressed( key )
  curr_state[key] = true
end

function keyreleased( key )
  curr_state[key] = nil
end

function update(dt)
  old_state = curr_state
end

function isKeyDown( key )
  return curr_state[key]
end

function isKeyUp( key )
  return not curr_state[key]
end

function wasJustPressed( key )
  return (not old_state[key] and curr_state[key])
end

function wasJustReleased( key )
  return (old_state[key] and not curr_state[key])
end

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