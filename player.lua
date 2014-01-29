require("square")
require("input")
Class = require("libs.hump.class")
vector = require("libs.hump.vector")

local xSpeed, ySpeed = 7, 4

Player = Class{__includes=Square}

function Player:update(dt, scene)
  local vel = vector(0,0)
  if love.keyboard.isDown('left') then vel.x = vel.x - xSpeed end
  if love.keyboard.isDown('right') then vel.x = vel.x + xSpeed end 
  if love.keyboard.isDown('down') then vel.y = vel.y - ySpeed end
  if love.keyboard.isDown('up') then vel.y = vel.y + ySpeed end


  -- Stop player from going off front of screen
  if self.pos.y + vel.y < 0 then 
    vel.y = 0 
    scene:collided(self, {name="edgeFront"}) 
  end

  -- Stop player from going off sides of screen
  -- I should pass camera in here but bite me.
  local edgeOffset = camera:getEdgeOffset(self.pos.y)
  local scaledSize = camera:getScale(self.pos.y)*self.size
  if self.pos.x + vel.x - scaledSize/2 < edgeOffset then
    vel.x = 0
    self.pos.x = edgeOffset + scaledSize/2
    scene:collided(self, {name="edgeLeft"}) 
  end
  if self.pos.x + vel.x + scaledSize/2 > scene.width - edgeOffset then
    vel.x = 0
    self.pos.x = scene.width - edgeOffset - scaledSize/2
    scene:collided(self, {name="edgeRight"}) 
  end

  self.pos = self.pos + vel
end

