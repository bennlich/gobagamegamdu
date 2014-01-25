input = require("input")


function love.load()
  winWidth, winHeight = love.window.getDimensions()
  input.register()
  camX = winWidth/2
  horizon = 3*winHeight/4
  -- fog.color = {255, 255, 255, 255}
  -- fog.near, fog.far = {20, 1000}
  local rows, cols = 50, 100
  local sq_size, sq_sep = 40, 10
  squares = {}
  for i=1,rows do
    for j=1,cols do
      table.insert(squares, 
        {(j-1)*(sq_size+sq_sep), (i-1)*20, sq_size, sq_size})
    end
  end
end

function love.update( dt )
  input.update()
  if input.keydown('left') then camX = camX - 3 end
  if input.keydown('right') then camX = camX + 3 end
end


function transformCoords(square)
  local x, y = square[1],square[2]
  scale = horizon/(horizon+y)
  love.graphics.translate(winWidth/2, winHeight)
  love.graphics.scale(scale, scale)
  love.graphics.translate(x-camX, 0)
  return 0, -y
end

function drawSquare( square )
  love.graphics.setColor(20, 30, 160)
  love.graphics.push()
  local x, y, width, height = unpack(square)
  local ground_x, ground_y = transformCoords(square)
  -- Draw with 0 = bottom
  love.graphics.rectangle("fill", ground_x, ground_y-height, width, height)
  love.graphics.pop()
end

function drawBG( )
  love.graphics.setColor(128, 128, 128)
  love.graphics.rectangle('fill', 0, (winHeight-horizon), winWidth, horizon)
end

function love.draw(  )
  drawBG()
  for _,v in pairs(squares) do 
    drawSquare(v)
  end
end

