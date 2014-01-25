input = require("input")
vector = require("libs.hump.vector")
require("Square")

function love.load()
  winWidth, winHeight = love.window.getDimensions()
  input.register()
  camX = winWidth/2
  horizon = 3*winHeight/4
  local rows, cols = 50, 100
  local sq_size, sq_sep = 40, 10
  squares = {}
  for i=1,rows do
    for j=1,cols do
      table.insert(squares, 
        Square(vector((j-1)*(sq_size+sq_sep), (i-1)*20), 
               sq_size, {20, 30, 160}))
    end
  end
end

function love.update( dt )
  input.update()
  if input.isKeyDown('left') then camX = camX - 3 end
  if input.isKeyDown('right') then camX = camX + 3 end
end

-- Sets the coordinate system to scale and position your character properly.
-- Returns the x and y values of the bottom left point on the ground
function transformCoords(x, y)
  scale = horizon/(horizon+y)
  love.graphics.translate(winWidth/2, winHeight)
  love.graphics.scale(scale, scale)
  love.graphics.translate(x-camX, 0)
  return vector(0, -y)
end

function drawBG( )
  love.graphics.setColor(128, 128, 128)
  love.graphics.rectangle('fill', 0, (winHeight-horizon), winWidth, horizon)
end

function love.draw(  )
  drawBG()
  for _,v in pairs(squares) do 
    v:draw()
  end
end

