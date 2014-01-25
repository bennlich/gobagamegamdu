input = require("input")
vector = require("libs.hump.vector")
require("square")
require("player")
require("camera")

function love.load()
  winWidth, winHeight = love.window.getDimensions()
  input.register()

  squares = {}
  player = Player(vector(0, 0), 50, {20, 30, 160})
  table.insert(squares, player)
  cam = Camera(player.pos, 3*winHeight/4)
end

function love.update( dt )
  input.update(dt)
  for _,v in pairs(squares) do 
    v:update(dt)
  end
end

function drawBG( )
  love.graphics.setColor(128, 128, 128)
  love.graphics.rectangle('fill', 0, (winHeight-cam.horizon), winWidth, 5)
end

function love.draw(  )
  drawBG()
  for _,v in pairs(squares) do 
    v:draw(cam)
  end
end

