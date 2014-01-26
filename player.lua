require("square")
require("input")
Class = require("libs.hump.class")
vector = require("libs.hump.vector")

local xSpeed, ySpeed = 7, 4

Player = Class{__includes=Square}

function Player:update(dt)
  local vel = vector(0,0)
  if input.isKeyDown('left') then vel.x = vel.x - xSpeed end
  if input.isKeyDown('right') then vel.x = vel.x + xSpeed end 
  if input.isKeyDown('down') then vel.y = vel.y - ySpeed end
  if input.isKeyDown('up') then vel.y = vel.y + ySpeed end

  self.pos = self.pos + vel
end

