require("square")
require("input")
Class = require("libs.hump.class")
vector = require("libs.hump.vector")

local xSpeed, ySpeed = 7, 4

Player = Class{__includes=Square}

function Player:update(dt, scene)
  local vel = vector(0,0)
  if input.isKeyDown('left') then vel.x = vel.x - xSpeed end
  if input.isKeyDown('right') then vel.x = vel.x + xSpeed end 
  if input.isKeyDown('down') then vel.y = vel.y - ySpeed end
  if input.isKeyDown('up') then vel.y = vel.y + ySpeed end


  -- Stop player from going off front of screen
  if self.pos.y + vel.y < 0 then 
    vel.y = 0 
    scene:collided(self, {name="edgeFront"}) 
  end

  -- Stop player from going off sides of screen
  -- I should pass camera in here but bite me.
  local screenPos = camera:groundToScreen(self.pos+vel)
  if screenPos.x < 0 then 
    vel = vector(0,0) 
    scene:collided(self, {name="edgeLeft"}) 
  end
  if screenPos.x > winWidth then 
    vel = vector(0,0) 
    scene:collided(self, {name="edgeRight"}) 
  end

  self.pos = self.pos + vel
end

