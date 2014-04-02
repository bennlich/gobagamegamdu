require("square")
require("input")
Class = require("libs.hump.class")
vector = require("libs.hump.vector")

local xSpeed, ySpeed = 7, 4

Player = Class{__includes=Square}

function Player:init(opts)
  Square.init(self, opts)
  self.vel = vector(0,0)
end

function Player:update(dt, scene)
  if love.keyboard.isDown('left') then 
    self:moveLeft() 
    network.sendMessage("moveLeft")
  end
  if love.keyboard.isDown('right') then 
    self:moveRight() 
    network.sendMessage("moveRight")
  end
  if love.keyboard.isDown('down') then 
    self:moveDown() 
    network.sendMessage("moveDown")
  end
  if love.keyboard.isDown('up') then 
    self:moveUp() 
    network.sendMessage("moveUp")
  end

  -- Stop player from going off front of screen
  if self.pos.y + self.vel.y < 0 then 
    self.vel.y = 0 
    scene:collided(self, {name="edgeFront"}) 
  end

  -- Stop player from going off sides of screen
  -- I should pass camera in here but bite me.
  local edgeOffset = camera:getEdgeOffset(self.pos.y)
  local scaledSize = camera:getScale(self.pos.y)*self.size
  if self.pos.x + self.vel.x - scaledSize/2 < edgeOffset then
    self.vel.x = 0
    self.pos.x = edgeOffset + scaledSize/2
    scene:collided(self, {name="edgeLeft"}) 
  end
  if self.pos.x + self.vel.x + scaledSize/2 > scene.width - edgeOffset then
    self.vel.x = 0
    self.pos.x = scene.width - edgeOffset - scaledSize/2
    scene:collided(self, {name="edgeRight"}) 
  end

  self.pos = self.pos + self.vel
  self.vel = vector(0,0)
end
  
function Player:moveLeft()
  self.vel.x = self.vel.x - xSpeed
end
function Player:moveRight()
  self.vel.x = self.vel.x + xSpeed
end
function Player:moveUp()
  self.vel.y = self.vel.y + ySpeed
end
function Player:moveDown()
  self.vel.y = self.vel.y - ySpeed
end
