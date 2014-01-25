require("square")
require("input")
Class = require("libs.hump.class")
vector = require("libs.hump.vector")

local xSpeed, ySpeed = 7, 4

Player = Class{__includes=Square}

function Player:update(dt)
  if input.isKeyDown('left') then self.pos.x = self.pos.x - xSpeed end
  if input.isKeyDown('right') then self.pos.x = self.pos.x + xSpeed end
  if input.isKeyDown('down') then self.pos.y = self.pos.y - ySpeed end
  if input.isKeyDown('up') then self.pos.y = self.pos.y + ySpeed end
end

